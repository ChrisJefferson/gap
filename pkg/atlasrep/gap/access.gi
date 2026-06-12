#############################################################################
##
#W  access.gi            GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains functions for accessing data from the ATLAS of Group
##  Representations.
##


#############################################################################
##
#F  AGR.InfoRead( <str1>, <str2>, ... )
##
AGR.InfoRead:= function( arg )
    local str;

    if UserPreference( "AtlasRep", "DebugFileLoading" ) = true then
      for str in arg do
        Print( str );
      od;
    fi;
    end;


#############################################################################
##
#F  AGR.StringFile( <filename> )
##
##  In unfortunate cases, files may contain line breaks of the form "\r\n"
##  instead of "\n".
##  'Read' would recognize this situation, and would silently replace these
##  line breaks, but 'StringFile' keeps the file contents.
##  Therefore we remove the '\r' characters.
##
AGR.StringFile:= function( filename )
    local str;

    AGR.InfoRead( "#I  reading `", filename, "' started\n" );
    str:= StringFile( filename );
    AGR.InfoRead( "#I  reading `", filename, "' done\n" );
    if IsString( str ) then
      str:= ReplacedString( str, "\r", "" );
    fi;

    return str;
    end;


#############################################################################
##
#F  AGR.ExtensionInfoCharacterTable
#F  AGR.HasExtensionInfoCharacterTable
#F  AGR.LibInfoCharacterTable
##
##  If the CTblLib package is not available then we cannot use these
##  functions.
##
if IsBound( ExtensionInfoCharacterTable ) then
  AGR.ExtensionInfoCharacterTable:= ExtensionInfoCharacterTable;
  AGR.HasExtensionInfoCharacterTable:= HasExtensionInfoCharacterTable;
  AGR.LibInfoCharacterTable:= LibInfoCharacterTable;
fi;


#############################################################################
##
#F  AGR.IsLowerAlphaOrDigitChar( <char> )
##
AGR.IsLowerAlphaOrDigitChar:= 
    char -> IsLowerAlphaChar( char ) or IsDigitChar( char );


#############################################################################
##
#F  AGR_ChecksumFits( <string>, <checksum> )
##
BindGlobal( "AGR_ChecksumFits", function( string, checksum )
    if checksum = fail then
      # We cannot check anything.
      return true;
    elif IsString( checksum ) then
      # This is a 'SHA256' format string.
      return checksum = ValueGlobal( "HexSHA256" )( string );
    elif IsInt( checksum ) then
      # This is a 'CrcString' value.
      return checksum = CrcString( string );
    else
      Error( "<chcksum> must be a string or an integer" );
    fi;
end );


#############################################################################
##
##  If the IO package is not available then the following assignments have
##  the effect that no warnings about unbound variables are printed when this
##  file gets read.
##
if not IsBound( IO_mkdir ) then
  IO_mkdir:= "dummy";
fi;
if not IsBound( IO_stat ) then
  IO_stat:= "dummy";
fi;
if not IsBound( IO_chmod ) then
  IO_chmod:= "dummy";
fi;


#############################################################################
##
#F  AtlasOfGroupRepresentationsTransferFile( <url>, <localpath>, <crc> )
##
##  This function encapsulates the access to the remote file at the address
##  <url>.
##  <P/>
##  If the access failed then <K>false</K> is returned, otherwise
##  either the data are written to the local file with filename
##  <A>localpath</A> (if this is a string and the user preference
##  <C>AtlasRepDataDirectory</C> is nonempty),
##  or a string with the contents of the file is returned.
##
BindGlobal( "AtlasOfGroupRepresentationsTransferFile",
    function( url, localpath, crc )
    local savetofile, pref, result, str, out;

    # Save the contents of the target file to a local file?
    # (The first two conditions mean that we *want* to avoid saving,
    # the third deals with the situation that the intended path does not
    # exist, probably due to missing write permissions.)
    savetofile:= not ( localpath = fail or
                       IsEmpty( UserPreference( "AtlasRep",
                                "AtlasRepDataDirectory" ) ) or
                       not IsWritableFile( localpath{ [ 1 .. Last( Positions(
                             localpath, '/' ) ) - 1 ] } ) );

    Info( InfoAtlasRep, 2,
          "calling 'Download' with url '", url, "'" );
    if savetofile then
      result:= Download( url, rec( target:= localpath ) );
    elif EndsWith( url, ".gz" ) then
      # We can only download the compressed file and then load it.
      if not IsBound( AGR.TmpDir ) then
        AGR.TmpDir:= DirectoryTemporary();
      fi;
      if AGR.TmpDir = fail then
        return false;
      fi;
      localpath:= Filename( AGR.TmpDir, "currentfile" );
      result:= Download( url, rec( target:= localpath ) );
      if result.success <> true then
        Info( InfoAtlasRep, 2,
              "Download failed" );
        RemoveFile( localpath );
        return false;
      fi;
      # Uncompress and load the contents.
      str:= StringFile( localpath );
      RemoveFile( localpath );
      if not AGR_ChecksumFits( str, crc ) then
        Info( InfoWarning, 1,
              "download of file '", url,
              "' does not yield a string with the expected crc value '",
              crc, "'" );
        return false;
      fi;
      return str;
    else
      # Transfer the file into the GAP session.
      result:= Download( url, rec() );
    fi;

    if result.success <> true then
      Info( InfoAtlasRep, 2,
            "Download failed with message\n#I  ", result.error );
      if savetofile and IsExistingFile( localpath ) then
        # This should not happen, 'Download' should have removed the file.
        if RemoveFile( localpath ) <> true then
          Error( "cannot remove corruped file '", localpath, "'" );
        fi;
      fi;
    elif savetofile and not AGR_ChecksumFits( StringFile( localpath ), crc ) then
      Info( InfoWarning, 1,
            "download of file '", url, "' to '", localpath,
            "' does not yield a file with the expected crc value '",
            crc, "'" );
      if RemoveFile( localpath ) <> true then
        Error( "cannot remove corruped file '", localpath, "'" );
      fi;
    elif not savetofile and not AGR_ChecksumFits( result.result, crc ) then
      Info( InfoWarning, 1,
            "download of file '", url,
            "' does not yield a string with the expected crc value '",
            crc, "'" );
    elif savetofile then
      # The file has been downloaded and stored and seems to be o.k.
      return true;
    else
      # The contents has been downloaded and seems to be o.k.
      return result.result;
    fi;

    return false;
end );


#############################################################################
##
#F  AGR.AccessFilesLocation( <files>, <type>, <replace>, <compressed> )
##
AGR.AccessFilesLocation:= function( files, type, replace, compressed )
#T type is not used at all!
    local names, pref, pair, dirname, filename, datadirs, info, entry,
          prefjson, name, namegz;

    names:= [];
    pref:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
    if pref <> "" and not EndsWith( pref, "/" ) then
      pref:= Concatenation( pref, "/" );
    fi;
    for pair in files do
      dirname:= pair[1];
      filename:= pair[2];
      if dirname in [ "datagens", "dataword" ] then
        datadirs:= [ Directory( Concatenation( pref, dirname ) ) ];
      else
        datadirs:= fail;
        for info in AtlasOfGroupRepresentationsInfo.notified do
          if dirname = info.ID then
            if StartsWith( info.DataURL, "http" ) then
              # local directory of a remote data extension
              datadirs:= [ Directory(
                             Concatenation( pref, "dataext/", info.ID ) ) ];
            else
              # local data extension
              datadirs:= [ Directory( info.DataURL ) ];
              entry:= First( AtlasOfGroupRepresentationsInfo.filenames,
                             x -> x[1] = filename );
              if entry = fail then
                Error( "do not know about <filename>" );
              fi;
              filename:= entry[2];
            fi;
            break;
          fi;
        od;
        if datadirs = fail then
          Error( "no data extension with identifier '", dirname, "'" );
        fi;
      fi;

      if replace <> fail then
        filename:= ReplacedString( filename, replace[1], replace[2] );
      fi;

      # Hack/experimental:
      # If wanted then switch to a JSON format alternative of
      # characteristic zero matrices (supported only for "datagens").
      if dirname = "datagens" and
         ( PositionSublist( filename, "-Ar" ) <> fail or
           PositionSublist( filename, "-Zr" ) <> fail ) then
        prefjson:= UserPreference( "AtlasRep", "AtlasRepJsonFilesAddresses" );
        if prefjson <> fail then
          # Use Json format files of characteristic zero
          # matrix representations instead of the GAP format files.
          datadirs:= [ Directory( prefjson[2] ) ];
          filename:= ReplacedString( filename, ".g", ".json" );
        fi;
      fi;

      # There may be an uncompressed or a compressed version.
      # If both are available then prefer the uncompressed version.
      # Take the compressed version only if the program 'gunzip'
      # is available.
      name:= Filename( datadirs, filename );
      if name = fail or not IsReadableFile( name ) then
        if compressed and 
           Filename( DirectoriesSystemPrograms(), "gunzip" ) <> fail then
          namegz:= Filename( datadirs, Concatenation( filename, ".gz" ) );
          if namegz = fail then
            # No version is available yet.
            Add( names, Filename( datadirs[1], filename ) );
          else
            Add( names, namegz );
          fi;
        else
          # No version is available yet.
          Add( names, Filename( datadirs[1], filename ) );
        fi;
      else
        Add( names, name );
      fi;
    od;

    return names;
    end;


#############################################################################
##
#F  AGR.AccessFilesFetch( <filepath>, <filename>, <dirname>
#F                        <type>, <compressed>, <crc> )
##
##  We assume that the local file <filepath> is not yet available,
##  and that we have to download the file.
##
##  <filepath> is the local path where the file shall be stored if local
##  directories are writable (otherwise the content just gets downloaded),
##  <filename> is the name part of the file in question.
##  <dirname> is one of "datagens", "dataword", or a private id.
##  <type> is a type record.
##  <compressed> is 'true' or 'false'.
##  <crc> is either the expected crc value of the file or 'fail'.
##
##  The function returns 'false' if the access failed,
##  'true' if the remote file was copied to a local file,
##  and a string containing the contents of the file otherwise.
##
AGR.AccessFilesFetch:= function( filepath, filename, dirname,
                                 type, compressed, crc )
    local result, iscompressed, info, datadirs, pref, url, pos,
          gzip, gunzip;

    # Try to fetch the remote file.
    result:= fail;
    iscompressed:= false;
    if dirname in [ "datagens", "dataword" ] then
      # This is an 'official' file.
      dirname:= "core";
    fi;

    # The domain is described by the 'notified' list.
    # We are in the case of a remote extension.
    datadirs:= fail;
    for info in AtlasOfGroupRepresentationsInfo.notified do
      if dirname = info.ID then
        if not IsBound( info.data ) then
          # This should happen only for pure local extension, 
          Error( "non-available file <filepath> of a local extension?" );
        fi;

        # Fetch the file if possible.
        if EndsWith( filepath, ".json" ) and EndsWith( filename, ".g" ) then
          # Fetch the file from the address given by the user preference
          # 'AtlasRepJsonFilesAddresses'.
          filename:= filepath{ [ Last( Positions( filepath, '/' ) )+1
                                 .. Length( filepath ) ] };
          crc:= fail;
          pref:= UserPreference( "AtlasRep", "AtlasRepJsonFilesAddresses" );
          url:= pref[1];
        else
          # Use the standard addresses.
          url:= info.DataURL;
        fi;
        if not EndsWith( url, "/" ) then
          url:= Concatenation( url, "/" );
        fi;
        url:= Concatenation( url, filename );

        # First look for an uncompressed file.
        result:= AtlasOfGroupRepresentationsTransferFile( url,
                     filepath, crc );

        # In case of private MeatAxe text files
        # and if 'gunzip' is available,
        # look for a compressed version of the file.
        # (This is not supported for "core".)
        if result = false and compressed and dirname <> "core" then
          gunzip:= Filename( DirectoriesSystemPrograms(), "gunzip" );
          if gunzip <> fail and not IsExecutableFile( gunzip ) then
            gunzip:= fail;
          fi;
          if gunzip <> fail then
            result:= AtlasOfGroupRepresentationsTransferFile(
                         Concatenation( url, ".gz" ),
                         Concatenation( filepath, ".gz" ), fail );
            # If the file has been stored locally then it is compressed.
            # If the contents is stored in 'result' then it is *uncompressed*.
            if result = true then
              iscompressed:= true;
            fi;
          fi;
        fi;

        if result = false then
          Info( InfoAtlasRep, 1,
                "failed to transfer file '", url, "'" );
          return false;
        fi;

        break;
      fi;
    od;
    if dirname <> info.ID then
      Error( "no data extension with identifier '", dirname, "'" );
    fi;

    if result = true then
      # The contents has just been stored in a local file.
      # For MeatAxe text files, perform postprocessing:
      # If wanted and if the file is not yet compressed then compress it.
      if compressed and
         ( iscompressed = false ) and
         type[1] in [ "perm", "matff" ] and
         UserPreference( "AtlasRep", "CompressDownloadedMeatAxeFiles" ) = true
         then
        gzip:= Filename( DirectoriesSystemPrograms(), "gzip" );
        if gzip = fail or not IsExecutableFile( gzip ) then
          Info( InfoAtlasRep, 1, "no 'gzip' executable found" );
        else
          if not IsBound( gunzip ) then
            gunzip:= Filename( DirectoriesSystemPrograms(), "gunzip" );
            if gunzip <> fail and not IsExecutableFile( gunzip ) then
              gunzip:= fail;
            fi;
          fi;
          if gunzip <> fail then
            result:= Process( DirectoryCurrent(), gzip,
                         InputTextNone(), OutputTextNone(), [ filepath ] );
            if result = fail then
              Info( InfoAtlasRep, 2,
                    "impossible to compress file '", filepath, "'" );
            fi;
          fi;
        fi;
      fi;
    fi;

    return result;
    end;


#############################################################################
##
#F  AGR.AtlasDataGAPFormatFile2( <filename>[, "string"] )
##
##  This function is used for reading a GAP format file containing
##  a permutation or a matrix over a finite field.
##  The assignment to a global variable is avoided by reading a modified
##  version of the file.
##
AGR.AtlasDataGAPFormatFile2:= function( filename, string... )
    local str, pos, i;

    if Length( string ) = 0 then
      str:= AGR.StringFile( filename );
    else
      str:= filename;
    fi;
    pos:= PositionSublist( str, ":=" );
    if pos <> fail then
      str:= str{ [ pos + 2 .. Length( str ) ] };
    fi;
    i := InputTextString( Concatenation( "return ", str ) );
    i:= ReadAsFunction( i );
    if i <> fail then
      i:= i();
    fi;
    return i;
    end;


#############################################################################
##
#V  AtlasOfGroupRepresentationsAccessFunctionsDefault
##
##  several functions may be provided; return value 'fail' means that
##  the next function is tried, otherwise the result counts
##
InstallValue( AtlasOfGroupRepresentationsAccessFunctionsDefault, [
  rec(
    description:= "download/read MeatAxe text files (default)",

    location:= function( files, type )
      return AGR.AccessFilesLocation( files, type, fail, true );
    end,

    fetch:= function( filepath, filename, dirname, type, crc )
      return AGR.AccessFilesFetch( filepath, filename, dirname, type, true, crc );
    end,

    contents:= function( files, type, filepaths )
      local i;

      if not ( IsExistingFile( filepaths[1] ) or
               IsExistingFile( Concatenation( filepaths[1], ".gz" ) ) ) then
        # We have the file contents.
        return type[2].InterpretDefault( filepaths );
      else
        # We have the local filenames.
        filepaths:= ShallowCopy( filepaths );
        for i in [ 1 .. Length( filepaths ) ] do
          if EndsWith( filepaths[i], ".gz" ) then
            filepaths[i]:= filepaths[i]{ [ 1 .. Length( filepaths[i] )-3 ] };
          fi;
        od;
        return type[2].ReadAndInterpretDefault( filepaths );
      fi;
    end,
  ),

  rec(
    description:= "prefer downloading/reading MeatAxe binary files",

    location:= function( files, type )
      if ( not type[1] in [ "perm", "matff" ] ) or
         IsEmpty( UserPreference( "AtlasRep", "AtlasRepDataDirectory" ) ) then
        return fail;
      fi;

      # A list of file names is given, and the files are not compressed.
      # Replace the text format names by binary format names.
      return AGR.AccessFilesLocation( files, type, [ ".m", ".b" ], false );
    end,

    fetch:= function( filepath, filename, dirname, type, crc )
      # Replace the filename by that of the binary file.
      filename:= ReplacedString( filename, ".m", ".b" );
      filename:= ReplacedString( filename, "/mtx/", "/bin/" );
      return AGR.AccessFilesFetch( filepath, filename, dirname,
                                   type, false, fail );
    end,

    contents:= function( files, type, filepaths )
      # This function is called only for the types "perm" and "matff",
      # binary format files are *not* compressed,
      # and we are sure that we have the filenames not file contents.
      return List( filepaths, FFMatOrPermCMtxBinary );
    end,
  ),

  # GAP format files means:
  # one generator per file,
  # the first line containing an assignment to a global variable,
  # the last character being a semicolon
  rec(
    description:= "prefer downloading/reading GAP format files",

    location:= function( files, type )
      if not type[1] in [ "perm", "matff" ] then
        return fail;
      fi;

      # A list of file names is given, and the files are not compressed.
      # Replace the text format names by GAP format names.
      return AGR.AccessFilesLocation( files, type, [ ".m", ".g" ], false );
    end,

    fetch:= function( filepath, filename, dirname, type, crc )
      # Replace the filename by that of the GAP format file.
      filename:= ReplacedString( filename, ".m", ".g" );
      filename:= ReplacedString( filename, "/mtx/", "/gap/" );
      return AGR.AccessFilesFetch( filepath, filename, dirname,
                                   type, false, fail );
    end,

    contents:= function( files, type, filepaths )
      # This function is called only for the types "perm" and "matff",
      # and GAP format files are *not* compressed.
      if not ( IsExistingFile( filepaths[1] ) or
               IsExistingFile( Concatenation( filepaths[1], ".gz" ) ) ) then
        # We have the file contents.
        return List( filepaths,
                     str -> AGR.AtlasDataGAPFormatFile2( str, "string" ) );
      else
        # We have the local filenames.
        return List( filepaths, AGR.AtlasDataGAPFormatFile2 );
      fi;
    end,
  ),

  rec(
    # This applies only to the "core" data, not to extensions.
    description:= "prefer reading files available from a local server",

    location:= function( files, type )
      local localserverpath, names, pair, filename, info, name;

      # This is meaningful only for official data
      # and if there is a local server.
      localserverpath:= UserPreference( "AtlasRep",
                                        "AtlasRepLocalServerPath" );
      if localserverpath = "" then
        return fail;
      fi;

      names:= [];
      for pair in files do

        # Compose the remote filename.
        if not pair[1] in [ "datagens", "dataword" ] then
          return fail;
        fi;
        filename:= pair[2];
        info:= First( AtlasOfGroupRepresentationsInfo.filenames,
                      x -> x[1] = filename );
        if info = fail then
          Error( "do not know about <filename>" );
        fi;
        filename:= info[2];

        # Check whether the file(s) exist(s).
        name:= Concatenation( localserverpath, filename );
        if IsReadableFile( name ) then
          Add( names, name );
        else
          return fail;
        fi;
      od;

      return names;
    end,

    fetch:= function( filepath, filename, dirname, type, crc )
      # The 'location' function has checked that the file exists.
      return true;
    end,

    contents:= function( files, type, filepaths )
      # We need not care about compressed files,
      # and we know that we get filenames not file contents.
      return type[2].ReadAndInterpretDefault( filepaths );
    end,
  ),
  ] );


#############################################################################
##
#F  AtlasOfGroupRepresentationsLocalFilename( <files>, <type> )
##
InstallGlobalFunction( AtlasOfGroupRepresentationsLocalFilename,
    function( files, type )
    local pref, cand, r, paths;

    pref:= UserPreference( "AtlasRep", "FileAccessFunctions" );
    cand:= [];
    for r in Reversed( AtlasOfGroupRepresentationsInfo.accessFunctions ) do
      if r.description in pref then
        paths:= r.location( files, type );
        if paths <> fail then
          if ForAll( paths, IsReadableFile ) then
            # This has priority, do not consider other sources.
            cand:= [ [ r, List( paths, x -> [ x, true ] ) ] ];
            break;
          else
            Add( cand, [ r, List( paths, x -> [ x, IsReadableFile( x ) ] ) ] );
          fi;
        fi;
      fi;
    od;

    return cand;
end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsLocalFilenameTransfer( <files>, <type> )
##
InstallGlobalFunction( AtlasOfGroupRepresentationsLocalFilenameTransfer,
    function( files, type )
    local cand, list, ok, result, fetchfun, i, filepath, filename, info,
          dirname, crc, res;

    # 1. Determine the local directory where to look for the file,
    #    and the functions that claim to be applicable.
    cand:= AtlasOfGroupRepresentationsLocalFilename( files, type );

    # 2. Check whether the files are already stored.
    #    (If yes then 'cand' has length 1.)
    if Length( cand ) = 1 and ForAll( cand[1][2], x -> x[2] ) then
      # 3. We have the local files.  Return paths and access functions.
      return [ List( cand[1][2], x -> x[1] ), cand[1][1] ];
    elif UserPreference( "AtlasRep", "AtlasRepAccessRemoteFiles" ) = true then
      # Try to fetch the remote files,
      # using the applicable methods.
      for list in cand do
        if Length( list[2] ) = Length( files ) then
          ok:= true;
          result:= [];
          fetchfun:= list[1].fetch;
          for i in [ 1 .. Length( files ) ] do
            if not list[2][i][2] then
              filepath:= list[2][i][1];
              filename:= files[i][2];
              info:= First( AtlasOfGroupRepresentationsInfo.filenames,
#T the list is ssorted; cheaper way!
                            x -> x[1] = filename );
              if info = fail then
                Error( "do not know about <filename>" );
              fi;
              filename:= info[2];
              dirname:= files[i][1];
              if IsBound( info[4] ) then
                crc:= info[4];
              else
                crc:= fail;
              fi;
              res:= fetchfun( filepath, filename, dirname, type, crc );
              if res = false then
                ok:= false;
              fi;
              Add( result, res );
            fi;
          od;
          if ok then
            # 3. We have either the local files or their contents.
            if result[1] = true then
              #  Return paths and the relevant record of access functions.
              return [ List( list[2], x -> x[1] ), list[1] ];
            else
              #  Return contents and the relevant record of access functions.
              return [ result, list[1] ];
            fi;
          fi;
        fi;
      od;
    fi;

    # The file cannot be made available.
    Info( InfoAtlasRep, 1,
          "no files '", files, "' found in the local directories" );
    return fail;
end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates()
##
InstallGlobalFunction(
    AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates, function()
    local pref, version, inforec, home, result, lines,
          datadirs, line, pos, pos2, filename, localfile, servdate,
          stat;

    if not IsPackageMarkedForLoading( "io", "" ) then
      Info( InfoAtlasRep, 1, "the package IO is not available" );
      return fail;
    fi;

    # If the data directories do not yet exist then nothing is to do.
    pref:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
    if not IsDirectoryPath( pref ) then
      return [];
    fi;

    # Download the file that lists the changes.
    version:= InstalledPackageVersion( "atlasrep" );
    inforec:= First( PackageInfo( "atlasrep" ), r -> r.Version = version );
    home:= inforec.PackageWWWHome;
    result:= AtlasOfGroupRepresentationsTransferFile(
                 Concatenation( home, "/htm/data/changes.htm" ), fail, fail );
    if result <> false then
      lines:= SplitString( result, "\n" );
      result:= [];
      lines:= Filtered( lines,
                  x ->     20 < Length( x ) and x{ [ 1 .. 4 ] } = "<tr>"
                       and x{ [ -3 .. 0 ] + Length( x ) } = " -->" );
      if pref <> "" and not EndsWith( pref, "/" ) then
        pref:= Concatenation( pref, "/" );
      fi;
      datadirs:= [ Directory( Concatenation( pref, "datagens" ) ),
                   Directory( Concatenation( pref, "dataword" ) ) ];
      for line in lines do
        pos:= PositionSublist( line, "</td><td>" );
        if pos <> fail then
          pos2:= PositionSublist( line, "</td><td>", pos );
          filename:= line{ [ pos+9 .. pos2-1 ] };
          localfile:= Filename( datadirs, filename );
          if localfile <> fail then
            if not IsReadableFile( localfile ) then
              localfile:= Concatenation( localfile, ".gz" );
            fi;
            if IsReadableFile( localfile ) then
              # There is something to compare.
              pos:= PositionSublist( line, "<!-- " );
              if pos <> fail then
                servdate:= Int( line{ [ pos+5 .. Length( line )-4 ] } );
                stat:= IO_stat( localfile );
                if stat <> fail then
                  if stat.mtime < servdate then
                    Add( result, localfile );
                  fi;
                fi;
              fi;
            fi;
          fi;
        fi;
      od;
      return result;
    fi;

    return [];
    end );


#############################################################################
##
#F  AGR.FileContents( <files>, <type> )
##
##  <files> must be a list of [ <dirname>, <filename> ] pairs,
##  where <dirname> is one of "dataword" or "datagens" or the ID of a
##  data extension.
##
AGR.FileContents:= function( files, type )
    local result;

    if not ( IsList( files ) and
             ForAll( files, l -> IsList( l ) and Length( l ) = 2
                                 and ForAll( l, IsString ) ) ) then
      Error( "<files> must be a list of [ <dirname>, <filename> ] pairs" );
    fi;

    # Perhaps the method in question rearranges the distribution into
    # one or several files.
    result:= AtlasOfGroupRepresentationsLocalFilenameTransfer( files, type );
    if result = fail then
      return fail;
    else
      # We have the local files or the contents of the files.
      # Extract and process the contents.
      return result[2].contents( files, type, result[1] );
    fi;
    end;


#############################################################################
##
#F  AGR.InfoForName( <gapname> )
##
AGR.InfoForName:= function( gapname )
    local pos;

    gapname:= AGR.GAPName( gapname );
    pos:= PositionSorted( AtlasOfGroupRepresentationsInfo.GAPnames,
                          [ gapname ] );
    if pos <= Length( AtlasOfGroupRepresentationsInfo.GAPnames ) and
       AtlasOfGroupRepresentationsInfo.GAPnames[ pos ][1] = gapname then
      return AtlasOfGroupRepresentationsInfo.GAPnames[ pos ];
    else
      return fail;
    fi;
    end;


#############################################################################
##
##  auxiliary function
##
AGR.TST:= function( gapname, value, compname, testfun, msg )
    if not IsBound( AGR.GAPnamesRec.( gapname ) ) then
      Error( "AGR.GAPnamesRec.( \"", gapname, "\" ) is not bound" );
    elif not IsBound( AGR.GAPnamesRec.( gapname )[3] ) then
      Error( "AGR.GAPnamesRec.( \"", gapname, "\" )[3] is not bound" );
    elif IsBound( AGR.GAPnamesRec.( gapname )[3].( compname ) ) then
      Error( "AGR.GAPnamesRec.( \"", gapname, "\" )[3].", compname,
             " is bound" );
    elif not testfun( value ) then
      Error( "<", compname, "> must be a ", msg );
    fi;
    end;


#############################################################################
##
#F  AGR.IsRepNameAvailable( <repname> )
##
##  If 'AtlasOfGroupRepresentationsInfo.checkData' is bound then this
##  function is called when additional data are added that refer to the
##  representation <repname>.
##
##  The data files themselves are *not* read by the function,
##  only the format of the filenames and the access with
##  'AllAtlasGeneratingSetInfos' are checked.
##
AGR.IsRepNameAvailable:= function( repname )
    local filenames, type, parsed, groupname, gapname;

    filenames:= [ Concatenation( repname, ".m1" ),
                  Concatenation( repname, ".g" ) ];
    for type in AGR.DataTypes( "rep" ) do
      parsed:= List( filenames,
          x -> AGR.ParseFilenameFormat( x, type[2].FilenameFormat ) );
      if ForAny( parsed, IsList ) then
        break;
      fi;
    od;
    if ForAll( parsed, IsBool ) then
      Print( "#E  wrong format of '", repname, "'\n" );
      return false;
    fi;
    groupname:= First( parsed, IsList )[1];
    gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                     pair -> pair[2] = groupname );
    if gapname = fail then
      Print( "#E  no group name '", groupname, "' for '", repname, "'\n" );
      return false;
    elif ForAll( AllAtlasGeneratingSetInfos( gapname[1] ),
                 x -> x.repname <> repname ) then
      Print( "#E  no representation '", repname, "' available\n" );
      return false;
    fi;

    return true;
    end;


#############################################################################
##
#F  AGR.IsPrgNameAvailable( <prgname> )
##
##  If 'AtlasOfGroupRepresentationsInfo.checkData' is bound then this
##  function is called when additional data are added that refer to the
##  program <prgname>.
##
AGR.IsPrgNameAvailable:= function( prgname )
    local type, parsed, groupname;

    for type in AGR.DataTypes( "prg" ) do
      parsed:= AGR.ParseFilenameFormat( prgname, type[2].FilenameFormat );
      if IsList( parsed ) then
        break;
      fi;
    od;
    if parsed = fail then
      Print( "#E  wrong format of '", prgname, "'\n" );
      return false;
    fi;
    groupname:= parsed[1];
    if ForAny( AGR.TablesOfContents( "all" ),
           toc -> IsBound( toc.( groupname ) ) and
                  ForAny( RecNames( toc.( groupname ) ),
                      nam -> ForAny( toc.( groupname ).( nam ),
                                 l -> l[ Length( l ) ] = prgname ) ) ) then
      return true;
    else
      Print( "#E  no program '", prgname, "' available\n" );
      return false;
    fi;
    end;


#############################################################################
##
#V  AGR.MapNameToGAPName
#F  AGR.GAPName( <name> )
##
##  Let <name> be a string.
##  If 'LowercaseString( <name> )' is the lower case version of the GAP name
##  of an ATLAS group then 'AGR.GAPName' returns this GAP name.
##  If <name> is an admissible name of a GAP character table with identifier
##  <id> (this condition is already case insensitive) then 'AGR.GAPName'
##  returns 'AGR.GAPName( <id> )'.
##
##  These two conditions are forced to be consistent, as follows.
##  Whenever a GAP name <nam>, say, of an ATLAS group is notified with
##  'AGR.GNAN', we compute 'LibInfoCharacterTable( <nam> )'.
##  If this is 'fail' then there is no danger of an inconsistency,
##  and if the result is a record <r> then we have the condition
##  'AGR.GAPName( <r>.firstName ) = <nam>'.
##
##  So a case insensitive partial mapping from character table identifiers
##  to GAP names of ATLAS groups is built in 'AGR.GNAN',
##  and is used in 'AGR.GAPName'
##
##  Examples of different names for a group are '"F3+"' vs. '"Fi24'"'
##  and '"S6"' vs. '"A6.2_1"'.
##
AGR.MapNameToGAPName:= [ [], [] ];

AGR.GAPName:= function( name )
    local r, nname, pos;

    # Make sure that the file 'gap/types.g' is already loaded.
    IsRecord( AtlasOfGroupRepresentationsInfo );

    if IsBound( AGR.LibInfoCharacterTable ) then
      r:= AGR.LibInfoCharacterTable( name );
    else
      r:= fail;
    fi;
    if r = fail then
      nname:= LowercaseString( name );
    else
      nname:= r.firstName;
    fi;
    pos:= Position( AGR.MapNameToGAPName[1], nname );
    if pos = fail then
      return name;
    fi;
    return AGR.MapNameToGAPName[2][ pos ];
    end;


#############################################################################
##
#F  AGR.GAPNameAtlasName( <atlasname> )
##
##  Map the Atlas name <atlasname> to the corresponding GAP name.
##
AGR.GAPNameAtlasName:= function( atlasname )
    local entry;

    entry:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                   x -> x[2] = atlasname );
    if entry = fail then
      return fail;
    fi;
    return entry[1];
    end;


#############################################################################
##
#F  AGR.GNAN( <gapname>, <atlasname>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.GNAN">
##  <Mark><C>AGR.GNAN( </C><M>gapname, atlasname[, dirid]</M><C> )</C></Mark>
##  <Item>
##    Called with two strings <M>gapname</M> (the &GAP; name of the group)
##    and <M>atlasname</M> (the &ATLAS; name of the group),
##    <C>AGR.GNAN</C> stores the information in the list
##    <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>,
##    which defines the name mapping between the &ATLAS;
##    names and &GAP; names of the groups.
##    <P/>
##    An example of a valid call is
##    <C>AGR.GNAN("A5.2","S5")</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.GNAN:= function( gapname, atlasname, dirid... )
    local value, r, pos;

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      if   ForAny( AtlasOfGroupRepresentationsInfo.GAPnames,
                   pair -> gapname = pair[1] ) then
        Error( "cannot notify '", gapname, "' more than once" );
      elif ForAny( AtlasOfGroupRepresentationsInfo.GAPnames,
                   pair -> atlasname = pair[2] ) then
        Error( "ambiguous GAP names for ATLAS name '", atlasname, "'" );
      fi;
    fi;

    # Make the character table names admissible.
    if IsBound( AGR.LibInfoCharacterTable ) then
      r:= AGR.LibInfoCharacterTable( gapname );
    else
      r:= fail;
    fi;
    if r = fail then
      # Store the lowercase name.
      Add( AGR.MapNameToGAPName[1], LowercaseString( gapname ) );
      Add( AGR.MapNameToGAPName[2], gapname );
    elif not r.firstName in AGR.MapNameToGAPName[1] then
      Add( AGR.MapNameToGAPName[1], r.firstName );
      Add( AGR.MapNameToGAPName[2], gapname );
    else
      Error( "<gapname> is not compatible with CTblLib" );
    fi;

    value:= [ gapname, atlasname,
              rec(),
              rec( GNAN:= dirid ) ];
    AddSet( AtlasOfGroupRepresentationsInfo.GAPnames, value );
    AGR.GAPnamesRec.( gapname ):= value;
    end;


#############################################################################
##
#F  AGR.TOC( <typename>, <filename>, <crc>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.TOC">
##  <Mark><C>AGR.TOC( </C><M>typename, filename, crc[, dirid]</M><C> )</C></Mark>
##  <Item>
##    <C>AGR.TOC</C> notifies an entry to the
##    <C>TableOfContents.( </C><M>dirid</M><C> )</C>
##    component of <Ref Var="AtlasOfGroupRepresentationsInfo"/>.
##    The string <M>typename</M> must be the name of the data type
##    to which the entry belongs,
##    the string <M>filename</M> must be the prefix of the data file(s), and
##    <M>crc</M> must be a list that contains the checksums of the data files,
##    which are either integers (see <Ref BookName="ref" Func="CrcFile"/>)
##    or strings (see <C>HexSHA256</C>).
##    In particular, the number of files that are described by the entry
##    equals the length of <M>crc</M>.
##    <P/>
##    The optional argument <M>dirid</M> is equal to the argument with the
##    same name in the corresponding call of
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>.
##    If no <M>dirid</M> argument is given then the current value of
##    <C>AGR.DIRID</C> is taken as the default;
##    this value is set automatically before a <F>toc.json</F> file
##    gets evaluated by
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>,
##    and is reset afterwards.
##    If <C>AGR.DIRID</C> is not bound and <M>dirid</M> is not given then
##    this function has no effect.
##    <P/>
##    An example of a valid call is
##    <C>AGR.TOC("perm","alt/A5/mtx/S5G1-p5B0.m", [-3581724,115937465])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.TOC:= function( arg )
    local type, crc, n, string, dirid, t, record, filename, pos, entry,
          groupname, added, j, filenamex, stringx;

    # Get the arguments.
    type:= arg[1];
    crc:= arg[3];
    n:= Length( crc );
    string:= arg[2];
    if Length( arg ) = 4 and IsString( arg[4] ) then
      dirid:= arg[4];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    # Parse the filename with the given format info.
    type:= First( AGR.DataTypes( "rep", "prg" ), x -> x[1] = type );
    record:= AtlasTableOfContents( dirid, "all" );

    # Split the name into path and filename.
    filename:= string;
    pos:= Position( filename, '/' );
    while pos <> fail do
      filename:= filename{ [ pos+1 .. Length( filename ) ] };
      pos:= Position( filename, '/' );
    od;

    filenamex:= filename;
    stringx:= string;
    if 1 < n then
      filenamex:= Concatenation( filename, "1" );
      stringx:= Concatenation( string, "1" );
    fi;
    entry:= AGR.ParseFilenameFormat( filenamex, type[2].FilenameFormat );
    if entry = fail then
      Info( InfoAtlasRep, 1, "'", arg, "' is not a valid t.o.c. entry" );
      return;
    fi;
    Add( AtlasOfGroupRepresentationsInfo.newfilenames,
         Immutable( [ filenamex, stringx, dirid, crc[1] ] ) );

    # Get the list for the data in the record for the group name.
    groupname:= entry[1];
    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) and
       ForAll( AtlasOfGroupRepresentationsInfo.GAPnames,
               x -> x[2] <> groupname ) then
      Error( "'", groupname, "' is not a valid group name" );
    fi;
    if not IsBound( record.( groupname ) ) then
      record.( groupname ):= rec();
    fi;
    record:= record.( groupname );
    if not IsBound( record.( type[1] ) ) then
      record.( type[1] ):= [];
    fi;

    # Add the first filename.
    added:= type[2].AddFileInfo( record.( type[1] ), entry, filenamex );

    # Add the other filenames if necessary.
    if added then
      for j in [ 2 .. n ] do
        entry[ Length( entry ) ]:= j;
        filenamex:= Concatenation( filename, String( j ) );
        stringx:= Concatenation( string, String( j ) );
        added:= type[2].AddFileInfo( record.( type[1] ), entry, filenamex )
                and added;
        Add( AtlasOfGroupRepresentationsInfo.newfilenames,
             Immutable( [ filenamex, stringx, dirid, crc[j] ] ) );
      od;
    fi;

    if not added then
      Info( InfoAtlasRep, 1, "'", arg, "' is not a valid t.o.c. entry" );
    fi;
    end;


#############################################################################
##
#F  AGR.GRS( <gapname>, <size>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.GRS">
##  <Mark><C>AGR.GRS( </C><M>gapname, size[, dirid]</M><C> )</C></Mark>
##  <Item>
##    The integer <M>size</M> is stored as the order of the group with
##    &GAP; name <M>gapname</M>,
##    in <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.GRS("A5.2",120)</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.GRS:= function( gapname, size, dirid... )

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      AGR.TST( gapname, size, "size", IsPosInt, "positive integer" );
    fi;
    AGR.GAPnamesRec.( gapname )[3].size:= size;
    AGR.GAPnamesRec.( gapname )[4].GRS:= dirid;
    end;


#############################################################################
##
#F  AGR.MXN( <gapname>, <nrMaxes>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.MXN">
##  <Mark><C>AGR.MXN( </C><M>gapname, nrMaxes[, dirid]</M><C> )</C></Mark>
##  <Item>
##    The integer <M>nrMaxes</M> is stored as the number of classes of
##    maximal subgroups of the group with &GAP; name <M>gapname</M>,
##    in <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.MXN("A5.2",4)</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.MXN:= function( gapname, nrMaxes, dirid... )

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      AGR.TST( gapname, nrMaxes, "nrMaxes", IsPosInt, "positive integer" );
    fi;
    AGR.GAPnamesRec.( gapname )[3].nrMaxes:= nrMaxes;
    AGR.GAPnamesRec.( gapname )[4].MXN:= dirid;
    end;


#############################################################################
##
#F  AGR.MXO( <gapname>, <sizesMaxes>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.MXO">
##  <Mark><C>AGR.MXO( </C><M>gapname, sizesMaxes[, dirid]</M><C> )</C></Mark>
##  <Item>
##    The list <M>sizesMaxes</M> of subgroup orders of the classes of
##    maximal subgroups of the group with &GAP; name <M>gapname</M>
##    (not necessarily dense, in non-increasing order) is stored
##    in <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.MXO("A5.2",[60,24,20,12])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.MXO:= function( gapname, sizesMaxes, dirid... )
    local i;

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    # Entries of the form '0' mean unknown values.
    for i in [ 1 .. Length( sizesMaxes ) ] do
      if IsBound( sizesMaxes[i] ) and sizesMaxes[i] = 0 then
        Unbind( sizesMaxes[i] );
      fi;
    od;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      AGR.TST( gapname, sizesMaxes, "sizesMaxes",
          x -> IsList( x ) and ForAll( x, IsPosInt )
                           and IsSortedList( Reversed( Compacted( x ) ) ),
          "list of non-increasing pos. integers" );
    fi;
    AGR.GAPnamesRec.( gapname )[3].sizesMaxes:= sizesMaxes;
    AGR.GAPnamesRec.( gapname )[4].MXO:= dirid;
    end;


#############################################################################
##
#F  AGR.MXS( <gapname>, <structureMaxes>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.MXS">
##  <Mark><C>AGR.MXS( </C><M>gapname, structureMaxes[, dirid]</M><C> )</C></Mark>
##  <Item>
##    The list <M>structureMaxes</M> of strings describing the
##    structures of the maximal subgroups of the group with &GAP; name
##    <M>gapname</M> (not necessarily dense), is stored
##    in <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.MXS("A5.2",["A5","S4","5:4","S3x2"])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.MXS:= function( gapname, structureMaxes, dirid... )
    local i;

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    # Entries of the form '""' mean unknown values.
    for i in [ 1 .. Length( structureMaxes ) ] do
      if IsBound( structureMaxes[i] ) and structureMaxes[i] = "" then
        Unbind( structureMaxes[i] );
      fi;
    od;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      AGR.TST( gapname, structureMaxes, "structureMaxes",
          x -> IsList( x ) and ForAll( x, IsString ),
          "list of strings" );
    fi;
    AGR.GAPnamesRec.( gapname )[3].structureMaxes:= structureMaxes;
    AGR.GAPnamesRec.( gapname )[4].MXS:= dirid;
    end;


#############################################################################
##
#F  AGR.STDCOMP( <gapname>, <factorCompatibility>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.STDCOMP">
##  <Mark><C>AGR.STDCOMP( </C><M>gapname, factorCompatibility[, dirid]</M><C> )</C></Mark>
##  <Item>
##    The list <M>factorCompatibility</M> (with entries
##    the standardization of the group with &GAP; name <M>gapname</M> ,
##    the &GAP; name of a factor group,
##    the standardization of this factor group, and
##    <K>true</K> or <K>false</K>, indicating whether mapping the standard
##    generators for <M>gapname</M> to those of <M>factgapname</M> defines an
##    epimorphism) is stored
##    in <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.STDCOMP("2.A5.2",[1,"A5.2",1,true])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.STDCOMP:= function( gapname, factorCompatibility, dirid... )

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) and
       not ( IsList( factorCompatibility ) and
             Length( factorCompatibility ) = 4 and
             IsPosInt( factorCompatibility[1] ) and
             IsString( factorCompatibility[2] ) and
             IsPosInt( factorCompatibility[3] ) and
             IsBool( factorCompatibility[4] ) ) then
      Error( "<factorCompatibility> must be a suitable list" );
    fi;
    if not IsBound( AGR.GAPnamesRec.( gapname )[3].factorCompatibility ) then
      AGR.GAPnamesRec.( gapname )[3].factorCompatibility:= [];
    fi;
    Add( AGR.GAPnamesRec.( gapname )[3].factorCompatibility,
         Concatenation( factorCompatibility, [ dirid ] ) );
    end;


#############################################################################
##
#F  AGR.RNG( <repname>, <descr>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.RNG">
##  <Mark><C>AGR.RNG( </C><M>repname, descr[, dirid]</M><C> )</C></Mark>
##  <Item>
##    Called with two strings <M>repname</M> (denoting the name
##    of a file containing the generators of a matrix representation over a
##    ring that is not determined by the filename)
##    and <M>descr</M> (describing this ring <M>R</M>, say),
##    <C>AGR.RNG</C> adds the triple
##    <M>[ repname, descr, R ]</M>
##    to the list stored in the <C>ringinfo</C> component of
##    <Ref Var="AtlasOfGroupRepresentationsInfo"/>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.RNG("A5G1-Ar3aB0","Field([Sqrt(5)])")</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.RNG:= function( repname, descr, args... )
    local len, dirid, data;

    # Get the arguments.
    len:= Length( args );
    if len in [ 1, 3 ] and IsString( args[ len ] ) then
      dirid:= args[ len ];
      args:= args{ [ 1 .. len-1 ] };
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      # Check that this representation really exists.
      if not AGR.IsRepNameAvailable( repname ) then
        return;
      fi;
    fi;

    data:= [ repname, descr, EvalString( descr ) ];
    Append( data, args );
    Add( data, dirid );

    if ForAny( AtlasOfGroupRepresentationsInfo.ringinfo,
               entry -> repname = entry[1] ) then
      Info( InfoAtlasRep, 1,
            "data '", data, "' cannot be notified more than once" );
    else
      Add( AtlasOfGroupRepresentationsInfo.ringinfo, data );
    fi;
    end;


#############################################################################
##
#F  AGR.TOCEXT( <atlasname>, <std>, <maxnr>, <files>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.TOCEXT">
##  <Mark><C>AGR.TOCEXT( </C><M>atlasname, std, maxnr, files[, dirid]</M><C> )</C></Mark>
##  <Item>
##    Called with <M>atlasname</M>,
##    the positive integers <M>std</M> (the standardization) and
##    <M>maxnr</M> (the number of the class of maximal subgroups), and
##    the list <M>files</M> (of filenames of straight line programs for
##    computing generators of the <M>maxnr</M>-th maximal subgroup, using
##    a straight line program for a factor group plus perhaps some straight
##    line program for computing kernel generators),
##    <C>AGR.TOCEXT</C> stores the information in
##    <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>.
##    <P/>
##    An example of a valid call is
##    <C>AGR.TOCEXT("2A5",1,3,["A5G1-max3W1"])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.TOCEXT:= function( groupname, std, maxnr, files, dirid... )
    local info;

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      if not ( IsString( groupname ) and IsPosInt( std )
                                     and IsPosInt( maxnr )
                                     and IsList( files )
                                     and ForAll( files, IsString ) ) then
        Error( "not a valid t.o.c.ext entry" );
      elif ForAll( AtlasOfGroupRepresentationsInfo.GAPnames,
                   x -> x[2] <> groupname )  then
        Error( "'", groupname, "' is not a valid group name" );
      fi;

      # Check that the required programs really exist.
      # (We cannot check the availability of the required program for
      # computing kernel generators, since these programs will be notified
      # *after* the current call, in another directory.)
      if not AGR.IsPrgNameAvailable( files[1] ) then
        # The program for the max. subgroup of the factor is not available.
        Print( "#E  factor program required by '", groupname, "' and '",
               files, "' not available\n" );
        return;
      fi;
    fi;

    info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                      x -> x[2] = groupname );
    if not IsBound( info[3].maxext ) then
      info[3].maxext:= [];
    fi;
    Add( info[3].maxext, [ std, maxnr, files, dirid ] );
    end;


#############################################################################
##
#F  AGR.API( <repname>, <info>[, <dirid>] )
##
##  <#GAPDoc Label="AGR.API">
##  <Mark><C>AGR.API( </C><M>repname, info[, dirid]</M><C> )</C></Mark>
##  <Item>
##    Called with the string <M>repname</M> (denoting the name of a
##    permutation representation)
##    and the list <M>info</M> (describing the point stabilizer of this
##    representation),
##    <C>AGR.API</C> binds the component <M>repname</M> of the record
##    <C>AtlasOfGroupRepresentationsInfo.permrepinfo</C> to a record that
##    describes the contents of <M>info</M>.
##    <P/>
##    <M>info</M> has the following entries.
##    <List>
##    <Item>
##      At position <M>1</M>, the transitivity is stored.
##    </Item>
##    <Item>
##      If the transitivity is zero then <M>info</M> has length two,
##      and the second entry is the list of orbit lengths.
##    </Item>
##    <Item>
##      If the transitivity is positive then <M>info</M> has length
##      four or five, and the second entry is the rank of the action.
##    </Item>
##    <Item>
##      If the transitivity is positive then the third entry is one of the
##      strings <C>"prim"</C>, <C>"imprim"</C>, denoting primitivity or not.
##    </Item>
##    <Item>
##      If the transitivity is positive then the fourth entry is either
##      the string <C>"???"</C> or a string that describes the structure of
##      the point stabilizer.
##      If the third entry is <C>"imprim"</C> then this description consists
##      of a subgroup part and a maximal subgroup part, separated by
##      <C>" &lt; "</C>.
##    </Item>
##    <Item>
##      If the third entry is <C>"prim"</C> then the fifth entry is either
##      the string <C>"???"</C>
##      or the number of the class of maximal subgroups
##      that are the point stabilizers.
##    </Item>
##    </List>
##    <P/>
##    An example of a valid call is
##    <C>AGR.API("A5G1-p5B0",[3,2,"prim","A4",1])</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.API:= function( repname, info, dirid... )
    local r;

    # Get the arguments.
    if Length( dirid ) = 1 and IsString( dirid[1] ) then
      dirid:= dirid[1];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      if IsBound( AtlasOfGroupRepresentationsInfo.permrepinfo.( repname ) ) then
        Error( "cannot notify '", repname, "' more than once" );
      fi;

      # Check that this representation really exists.
      if not AGR.IsRepNameAvailable( repname ) then
        return;
      fi;
    fi;

    # The component 'dirid' is used in 'StringOfAtlasTableOfContents'.
    r:= rec( transitivity:= info[1], dirid:= dirid );
    if info[1] = 0 then
      r.orbits:= info[2];
      r.isPrimitive:= false;
    else
      r.rankAction:= info[2];
      r.isPrimitive:= ( info[3] = "prim" );
      r.stabilizer:= info[4];
      if r.isPrimitive then
        r.maxnr:= info[5];
      fi;
    fi;

    AtlasOfGroupRepresentationsInfo.permrepinfo.( repname ):= r;
    end;


#############################################################################
##
#F  AGR.CHAR( <gapname>, <repname>, <char>, <pos>[, <charname>][, <dirid>] )
##
##  <#GAPDoc Label="AGR.CHAR">
##  <Mark><C>AGR.CHAR( </C><M>gapname, repname, char, pos[, charname[, dirid]]</M><C> )</C></Mark>
##  <Item>
##    Called with the strings <M>gapname</M>
##    and <M>repname</M> (denoting the name of the representation),
##    the integer <M>char</M> (the characteristic of the representation),
##    and <M>pos</M> (the position or list of positions of the irreducible
##    constituent(s)),
##    <C>AGR.CHAR</C> stores the information in
##    <C>AtlasOfGroupRepresentationsInfo.characterinfo</C>.
##    <P/>
##    A string describing the character can be entered as <M>charname</M>.
##    <P/>
##    If <M>dirid</M> is given but no <M>charname</M> is known then one can
##    enter <K>fail</K> as the fifth argument.
##    <P/>
##    An example of a valid call is
##    <C>AGR.CHAR("M11","M11G1-p11B0",0,[1,2],"1a+10a")</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.CHAR:= function( groupname, repname, char, pos, arg... )
    local charname, dirid, map;

    # Get the arguments.
    if Length( arg ) >= 1 then
      charname:= arg[1];
    else
      charname:= fail;
    fi;
    if Length( arg ) = 2 then
      dirid:= arg[2];
    elif IsBound( AGR.DIRID ) then
      dirid:= AGR.DIRID;
    else
      Info( InfoAtlasRep, 1, "'AGR.DIRID' is not bound" );
      return;
    fi;

    map:= AtlasOfGroupRepresentationsInfo.characterinfo;
    if not IsBound( map.( groupname ) ) then
      map.( groupname ):= [];
    fi;
    map:= map.( groupname );
    if char = 0 then
      char:= 1;
    fi;
    if not IsBound( map[ char ] ) then
      map[ char ]:= [ [], [], [], [] ];
    fi;
    map:= map[ char ];

    if IsBound( AtlasOfGroupRepresentationsInfo.checkData ) then
      # Check whether we have already a character for this representation.
      # (Two different representations with the same character are allowed.)
      if arg[2] in map[2] and map[1][ Position( map[2], repname ) ] <> pos then
        Error( "attempt to enter two different characters for ", arg[2] );
      fi;

      # Check that this representation really exists.
      if not AGR.IsRepNameAvailable( repname ) then
        return;
      fi;
    fi;

    Add( map[1], pos );
    Add( map[2], repname );
    Add( map[3], charname );
    Add( map[4], dirid );

    # The character information forms one global object.
    # It may belong to any t.o.c., and we would not consider the new entry
    # if the cached t.o.c. would be taken.
    AtlasOfGroupRepresentationsInfo.TOC_Cache:= rec();
    AtlasOfGroupRepresentationsInfo.TableOfContents.merged:= rec();
    end;


#############################################################################
##
#F  AGR.CompareAsNumbersAndNonnumbers( <nam1>, <nam2> )
##
##  This function is available as 'BrowseData.CompareAsNumbersAndNonnumbers'
##  if the Browse package is available.
##  But we must deal also with the case that this package is not available.
##
AGR.CompareAsNumbersAndNonnumbers:= function( nam1, nam2 )
    local len1, len2, len, digit, comparenumber, i;

    len1:= Length( nam1 );
    len2:= Length( nam2 );
    len:= len1;
    if len2 < len then
      len:= len2;
    fi;
    digit:= false;
    comparenumber:= 0;
    for i in [ 1 .. len ] do
      if nam1[i] in DIGITS then
        if nam2[i] in DIGITS then
          digit:= true;
          if comparenumber = 0 then
            # first digit of a number, or previous digits were equal
            if nam1[i] < nam2[i] then
              comparenumber:= 1;
            elif nam1[i] <> nam2[i] then
              comparenumber:= -1;
            fi;
          fi;
        else
          # if digit then the current number in 'nam2' is shorter,
          # so 'nam2' is smaller;
          # if not digit then a number starts in 'nam1' but not in 'nam2',
          # so 'nam1' is smaller
          return not digit;
        fi;
      elif nam2[i] in DIGITS then
        # if digit then the current number in 'nam1' is shorter,
        # so 'nam1' is smaller;
        # if not digit then a number starts in 'nam2' but not in 'nam1',
        # so 'nam2' is smaller
        return digit;
      else
        # both characters are non-digits
        if digit then
          # first evaluate the current numbers (which have the same length)
          if comparenumber = 1 then
            # nam1 is smaller
            return true;
          elif comparenumber = -1 then
            # nam2 is smaller
            return false;
          fi;
          digit:= false;
        fi;
        # now compare the non-digits
        if nam1[i] <> nam2[i] then
          return nam1[i] < nam2[i];
        fi;
      fi;
    od;

    if digit then
      # The suffix of the shorter string is a number.
      # If the longer string continues with a digit then it is larger,
      # otherwise the first digits of the number decide.
      if len < len1 and nam1[ len+1 ] in DIGITS then
        # nam2 is smaller
        return false;
      elif len < len2 and nam2[ len+1 ] in DIGITS then
        # nam1 is smaller
        return true;
      elif comparenumber = 1 then
        # nam1 is smaller
        return true;
      elif comparenumber = -1 then
        # nam2 is smaller
        return false;
      fi;
    fi;

    # Now the longer string is larger.
    return len1 < len2;
    end;


#############################################################################
##
#F  AGR.SetGAPnamesSortDisp()
##
##  Bind the component 'AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp'.
##
AGR.SetGAPnamesSortDisp:= function()
    local list;

    list:= ShallowCopy( AtlasOfGroupRepresentationsInfo.GAPnames );
    SortParallel( List( list, x -> x[1] ), list,
                  AGR.CompareAsNumbersAndNonnumbers );
    AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp:= list;
    end;


#############################################################################
##
#F  AGR.ParseFilenameFormat( <string>, <format> )
##
AGR.ParseFilenameFormat:= function( string, format )
    local result, i, res;

    string:= SplitString( string, "-" );
    if Length( string ) <> Length( format[1] ) then
      return fail;
    fi;
    result:= [];
    for i in [ 1 .. Length( string ) ] do

      # Loop over the '-' separated components.
      res:= format[2][i]( string[i], format[1][i] );
      if res = fail then
        return fail;
      fi;
      Append( result, res );

    od;
    return result;
    end;


#############################################################################
##
#F  AtlasDataGAPFormatFile( <filename>[, "string"] )
##
##  <ManSection>
##  <Func Name="AtlasDataGAPFormatFile" Arg='filename[, "string"]'/>
##
##  <Description>
##  Let <A>filename</A> be the name of a file containing the generators of a
##  representation in characteristic zero such that reading the file via
##  <Ref Func="ReadAsFunction" BookName="ref"</C> yields a record
##  containing the list of the generators and additional information.
##  Then <Ref Func="AtlasDataGAPFormatFile"/> returns this record.
##  </Description>
##  </ManSection>
##
BindGlobal( "AtlasDataGAPFormatFile", function( filename, string... )
    local fun;

    AGR.InfoRead( "#I  reading '", filename, "' started\n" );
    if Length( string ) = 0 then
      fun:= ReadAsFunction( filename );
    else
      fun:= ReadAsFunction( InputTextString( filename ) );
    fi;
    AGR.InfoRead( "#I  reading '", filename, "' done\n" );
    if fun = fail then
      Info( InfoAtlasRep, 1,
            "problem reading '", filename, "' as function\n" );
    else
      fun:= fun();
    fi;
    return fun;
end );


#############################################################################
##
#F  AtlasDataJsonFormatFile( <filename>[, "string"] )
##
##  Evaluate the contents of a Json format file that describes matrices
##  in characteristic zero.
##
##  Admit a prescribed ring for the matrix entries,
##  given by the 'givenRing' component of the info record stored in the
##  global option 'inforecord'.
##
BindGlobal( "AtlasDataJsonFormatFile", function( filename, string... )
    local obj, arec, givenF, info, F, pol, facts, gen, roots, ecoeffs, pos,
          found, N, B, nrows, ncols, mats, d, mat, i, j;

    if Length( string ) = 0 then
      obj:= AGR.GapObjectOfJsonText( StringFile( filename ) );
    else
      obj:= AGR.GapObjectOfJsonText( filename );
    fi;
    if obj.status = false then
      if Length( string ) = 0 then
        Info( InfoAtlasRep, 1,
              "file ", filename, " does not contain valid Json" );
      else
        Info( InfoAtlasRep, 1,
              "string <filename> does not contain valid Json" );
      fi;
      return fail;
    fi;
    arec:= obj.value;

    givenF:= ValueOption( "inforecord" );
    if givenF <> fail then
      if IsBound( givenF.givenRing ) then
        givenF:= givenF.givenRing;
      else
        givenF:= fail;
      fi;
    fi;

    info:= arec.ringinfo;

    if givenF = fail or IsCyclotomicCollection( givenF ) then
      # Create the default field extension in GAP.
      if Length( info ) = 1 and info[1] = "IntegerRing" then
        F:= Integers;
        gen:= 1;
      elif Length( info ) = 2 and info[1] = "QuadraticField" then
        F:= Field( Rationals, [ Sqrt( info[2] ) ] );
        pol:= UnivariatePolynomial( F, arec.polynomial );
        gen:= - Value( Factors( PolynomialRing( F ), pol )[1], 0 );
      elif Length( info ) = 2 and info[1] = "CyclotomicField" then
        F:= CyclotomicField( Rationals, info[2] );
        gen:= E( info[2] );
      elif Length( info ) = 2 and info[1] = "AbelianNumberField" then
        # Choose the unique root of the polynomial
        # that involves E(N) with the correct sign.
        # (This is of course a hack, but it makes the generators in GAP
        # backwards compatible with the old Magma and GAP format files.)
        F:= CyclotomicField( Rationals, info[2] );
        pol:= UnivariatePolynomial( F, arec.polynomial );
        roots:= List( Factors( PolynomialRing( F ), pol ),
                      x -> - Value( x, 0 ) );
        ecoeffs:= COEFFS_CYC( E( info[2] ) );
        pos:= PositionNonZero( ecoeffs );
        gen:= First( roots, x -> COEFFS_CYC( x )[ pos ] = ecoeffs[ pos ] );
        F:= Field( Rationals, [ gen ] );
      elif Length( info ) = 1 and info[1] = "NumberField" then
        # We have no good idea to guess the conductor.
        found:= false;
        pol:= UnivariatePolynomial( Rationals, arec.polynomial );
        for N in [ 3 .. 100 ] do
          F:= CyclotomicField( Rationals, N );
          facts:= Factors( PolynomialRing( F ), pol );
          if Length( facts ) = Degree( pol ) then
            roots:= List( facts, x -> - Value( x, 0 ) );
            ecoeffs:= COEFFS_CYC( E( info[2] ) );
            pos:= PositionNonZero( ecoeffs );
            gen:= First( roots, x -> COEFFS_CYC( x )[ pos ] = ecoeffs[ pos ] );
            F:= Field( Rationals, [ gen ] );
            found:= true;
            break;
          fi;
        od;
        if not found then
          Error( "did not find conductor" );
        fi;
      else
        Error( "invalid 'ringinfo'" );
      fi;
    else
      # Take a root of the given defining polynomial
      # over the given field extension as the primitive element.
      F:= givenF;
      if Length( arec.polynomial ) = 2 then
        # no proper extension, usually 'Integers'
        gen:= One( F );
      else
        pol:= UnivariatePolynomial( F, arec.polynomial * One( F ) );
        facts:= Filtered( Factors( PolynomialRing( F ), pol ),
                          x -> Degree( x ) = 1 );
        if Length( facts ) = 0 then
          Error( "the polynomial <pol> has no root in <F>" );
        fi;
        gen:= - Value( facts[1], 0 );
      fi;
    fi;

    B:= List( [ 0 .. Length( arec.polynomial )-2 ], i -> gen^i );

    nrows:= arec.dimensions[1];
    ncols:= arec.dimensions[2];

    mats:= [];
    d:= arec.denominator;
    for mat in arec.generators do
      pos:= 0;
      for i in [ 1 .. nrows ] do
        for j in [ 1 .. ncols ] do
          pos:= pos + 1;
          if IsList( mat[ pos ] ) then
            mat[ pos ]:= mat[ pos ] * B;
          fi;
        od;
      od;
      if givenF <> fail then
        mat:= mat * One( givenF );
      fi;
      if d <> 1 then
        mat:= mat / d;
      fi;
#T eventually support 'Matrix( F, mat, ncols )'
#T and given ConstructingFilter!
      Add( mats, List( [ 1 .. nrows ],
                       i -> mat{ [ (i-1)*ncols+1 .. i*ncols ] } ) );
    od;

    return rec( generators:= mats );
end );


#############################################################################
##
#F  AtlasStringOfFieldOfMatrixEntries( <mats> )
#F  AtlasStringOfFieldOfMatrixEntries( <filename> )
##
InstallGlobalFunction( AtlasStringOfFieldOfMatrixEntries, function( mats )
    local F, n, str;

    if IsString( mats ) then
      mats:= AtlasDataGAPFormatFile( mats ).generators;
    fi;

    if   IsCyclotomicCollCollColl( mats ) then
      F:= Field( Rationals, Flat( mats ) );
    elif ForAll( mats, IsQuaternionCollColl ) then
      F:= Field( Flat( List( Flat( mats ), ExtRepOfObj ) ) );
    else
      Error( "<mats> must be a matrix list of cyclotomics or quaternions" );
    fi;

    n:= Conductor( F );

    if DegreeOverPrimeField( F ) = 2 then

      # The field is quadratic,
      # so it is generated by 'Sqrt(n)' if $'n' \equiv 1 \pmod{4}$,
      # by 'Sqrt(-n)' if $'n' \equiv 3 \pmod{4}$,
      # and by one of 'Sqrt(n/4)', 'Sqrt(-n/4)' otherwise.
      if   n mod 4 = 1 then
        str:= Concatenation( "[Sqrt(", String( n ), ")]" );
      elif n mod 4 = 3 then
        str:= Concatenation( "[Sqrt(-", String( n ), ")]" );
      elif Sqrt( -n/4 ) in F then
        str:= Concatenation( "[Sqrt(-", String( n/4 ), ")]" );
      else
        str:= Concatenation( "[Sqrt(", String( n/4 ), ")]" );
      fi;

    elif IsCyclotomicField( F ) then

      # The field is not quadratic but cyclotomic.
      str:= Concatenation( "[E(", String( n ), ")]" );

    else
      str:= "";
    fi;

    if IsCyclotomicCollCollColl( mats ) then
      if str = "" then
        str:= String( F );
      else
        str:= Concatenation( "Field(", str, ")" );
      fi;
    elif F = Rationals then
      str:= "QuaternionAlgebra(Rationals)";
    elif str = "" then
      str:= Concatenation( "QuaternionAlgebra(", String( F ), ")" );
    else
      str:= Concatenation( "QuaternionAlgebra(", str, ")" );
    fi;

    return [ F, str ];
end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsScanFilename( <name>, <result>, <dirid> )
##
BindGlobal( "AtlasOfGroupRepresentationsScanFilename",
    function( name, result, dirid )
    local filename, pos, type, format, groupname;

    # Replace the name of binary files by the corresponding MeatAxe filename.
    pos:= PositionSublist( name, ".b" );
    if pos <> fail then
      name:= ReplacedString( name, ".b", ".m" );
    fi;

    # Split the name into path and filename.
    filename:= name;
    pos:= Position( filename, '/' );
    while pos <> fail do
      filename:= filename{ [ pos+1 .. Length( filename ) ] };
      pos:= Position( filename, '/' );
    od;

    for type in AGR.DataTypes( "rep", "prg" ) do
      format:= AGR.ParseFilenameFormat( filename, type[2].FilenameFormat );
      if format <> fail then
        groupname:= format[1];
        if not IsBound( result.( groupname ) ) then
          result.( groupname ):= rec();
        fi;
        if not IsBound( result.( groupname ).( type[1] ) ) then
          result.( groupname ).( type[1] ):= [];
        fi;
        if type[2].AddFileInfo( result.( groupname ).( type[1] ),
                                format, filename ) then
          Add( AtlasOfGroupRepresentationsInfo.newfilenames,
               Immutable( [ filename, name, dirid ] ) );
          return true;
        else
          return false;
        fi;
      fi;
    od;

    # No type matches.
    return false;
end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsComposeTableOfContents( <filelist>,
#F                                                     <gapnames>, <dirid> )
##
##  This code is used by 'AtlasTableOfContents'.
##
BindGlobal( "AtlasOfGroupRepresentationsComposeTableOfContents",
    function( filelist, gapnames, dirid )
    local result, name, len, groupname, record, type, listtosort;

    # Initialize the result record.
    result:= rec( otherfiles:= [] );

    # Deal with the case of 'gzip'ped files, and omit obvious garbage.
    for name in Set( filelist ) do
      len:= Length( name );
      if 3 <= len and name{ [ len-2 .. len ] } = ".gz" then
        name:= name{ [ 1 .. len-3 ] };
      fi;
      if AtlasOfGroupRepresentationsScanFilename( name, result, dirid )
         = false then
        if not ( name in [ "dummy", ".", "..", ".svn", "toc.g", "toc.json",
                           ".svnignore" ] or
                 name[ Length( name ) ] = '%' or
                 ( 3 <= Length( name )
                   and name{ Length( name ) + [ - 2 .. 0 ] } = "BAK" ) ) then
          Info( InfoAtlasRep, 3,
                "t.o.c. construction: ignoring name '", name, "'" );
          AddSet( result.otherfiles, name );
        fi;
      fi;
    od;

    # Postprocessing,
    # and *sort* the representations as given in the type definition.
    for groupname in List( gapnames, x -> x[2] ) do
      if IsBound( result.( groupname ) ) then

        record:= result.( groupname );
        for type in AGR.DataTypes( "rep", "prg" ) do
          if IsBound( record.( type[1] ) ) then

            type[2].PostprocessFileInfo( result, record );

            # Sort the data of the given type as defined.
            if IsBound( type[2].SortTOCEntries ) then
              listtosort:= List( record.( type[1] ), type[2].SortTOCEntries );
              SortParallel( listtosort, record.( type[1] ) );
            fi;

          fi;
        od;

      fi;
    od;

    # Store the current date in Coordinated Universal Time
    # (Greenwich Mean Time).
    result.lastupdated:= CurrentDateTimeString();

    return result;
end );


#############################################################################
##
#F  AtlasTableOfContents( <tocid>, <allorlocal>[, <body>] )
##
InstallGlobalFunction( AtlasTableOfContents,
    function( tocid, allorlocal, body... )
    local toc, id, groupnames, prefix, filenames, dirinfo, dstdir, dstfile,
          tocremote, typeinfo, groupname, r, pair, type, entry, fileinfo,
          filename, loc, dirname, privdir, f, comp, dir, result;

    # Take the stored version if it is already available.
    toc:= AtlasOfGroupRepresentationsInfo.TableOfContents;
    id:= Concatenation( tocid, "|", allorlocal );
    if IsBound( toc.( id ) ) then
      return toc.( id );
    fi;

    if not allorlocal in [ "all", "local" ] then
      Error( "<allorlocal> must be \"all\" or \"local\"" );
    fi;

    groupnames:= AtlasOfGroupRepresentationsInfo.GAPnames;
    prefix:= "";
    filenames:= [];

    # Fetch the information that was set during the notification.
    dirinfo:= First( AtlasOfGroupRepresentationsInfo.notified,
                     entry -> entry.ID = tocid );
    if dirinfo = fail then
      return fail;
    fi;

    if allorlocal = "all" then

      if IsBound( dirinfo.data ) then
        # This is a remote part of the database.
        # The contents are described by the record stored as the third entry.
        # (We need also the 'AGR.TOC' calls.)
        toc.( id ):= rec();
        AGR.DIRID:= tocid;
        for entry in dirinfo.data.Data do
          CallFuncList( AGR.( entry[1] ), entry[2] );
        od;
        Unbind( AGR.DIRID );
        toc.( id ).TocID:= tocid;
        return toc.( id );
      else
        # This is a local part of the database,
        # there may be a 'toc.json' file (evaluate it if available)
        # or 'body' contains its contents.
        if Length( body ) = 1 then
          body:= body[1];
        elif IsExistingFile( dirinfo.DataURL ) then
          privdir:= Directory( dirinfo.DataURL );
          filename:= Filename( privdir, "toc.json" );
          if not IsReadableFile( filename ) = true then
            return fail;
          fi;
          body:= AGR.StringFile( filename );
        else
          return fail;
        fi;

        # Store the hint for calls of 'AGR.API', 'AGR.CHR', 'AGR.TOC'.
        f:= AGR.GapObjectOfJsonText( body );
        if f.status = false then
          Error( "file <filename> does not contain valid JSON" );
        fi;
        f:= f.value;
        for comp in [ "Version", "SelfURL", "DataURL", "LocalDirectory" ] do
          if IsBound( f.( comp ) ) then
            dirinfo.( comp ):= f.( comp );
          fi;
        od;
        dirname:= dirinfo.DataURL;
        toc.( id ):= rec();
        AGR.DIRID:= tocid;
        if IsBound( f.DataURL ) then
          # Notify all files, not just the locally available ones.
          for entry in f.Data do
            CallFuncList( AGR.( entry[1] ), entry[2] );
          od;
          dirinfo.data:= f;
          Unbind( AGR.DIRID );
          toc.( id ).TocID:= tocid;
          return toc.( id );
        else
          # This is *only* locally available.
          # Rely on the locally available files.
          for entry in f.Data do
            # Omit 'AGR.TOC' lines that may be present.
            # Note that we are going to list the local directory contents.
            if entry[1] <> "TOC" then
              CallFuncList( AGR.( entry[1] ), entry[2] );
            fi;
          od;
          Unbind( AGR.DIRID );
        fi;

        if IsExistingFile( dirname ) then
          # List the information available in the given local directory.
          # (Up to one directory layer above the data files is supported.)
          for dir in Difference( DirectoryContents( dirname ),
                                 [ ".", "..", ".svn" ] ) do
            dstfile:= Filename( privdir, dir );
            if IsDirectoryPath( dstfile ) then
              Append( filenames,
                      List( Difference( DirectoryContents( dstfile ),
                                        [ ".", "..", ".svn" ] ),
                            x -> Concatenation( dir, "/", x ) ) );
            else
              Add( filenames, dir );
            fi;
          od;

          # Compose the result record.
          result:= AtlasOfGroupRepresentationsComposeTableOfContents( filenames,
                       groupnames, tocid );
          result.TocID:= tocid;

          # Store the newly computed table of contents.
          toc.( id ):= result;
          return result;

        fi;
      fi;

    else
      # First create the "all" variant, then filter it.
      tocremote:= AtlasTableOfContents( tocid, "all" );
      if tocid = "core" then
        typeinfo:= Concatenation(
                     List( AGR.DataTypes( "rep" ), x -> [ "datagens", x ] ),
                     List( AGR.DataTypes( "prg" ), x -> [ "dataword", x ] ) );
      else
        typeinfo:= List( AGR.DataTypes( "rep", "prg" ), x -> [ tocid, x ] );
      fi;

      for groupname in RecNames( tocremote ) do
        r:= tocremote.( groupname );
        if IsRecord( r ) then
          for pair in typeinfo do
            type:= pair[2];
            if IsBound( r.( type[1] ) ) then
              for entry in r.( type[1] ) do
                fileinfo:= entry[ Length( entry ) ];
                if IsString( fileinfo ) then
                  fileinfo:= [ fileinfo ];
                fi;
                loc:= AtlasOfGroupRepresentationsLocalFilename(
                          List( fileinfo, x -> [ pair[1], x ] ), type );
                if not IsEmpty( loc ) and ForAll( loc[1][2], x -> x[2] ) then
                  Append( filenames, fileinfo );
                fi;
              od;
            fi;
          od;
        fi;
      od;

      # Compose the result record.
      result:= AtlasOfGroupRepresentationsComposeTableOfContents( filenames,
                   groupnames, tocid );

      result.TocID:= tocid;

      # Store the newly computed table of contents.
      toc.( id ):= result;

      # Return the result record.
      return result;
    fi;

    return fail;
end );


#############################################################################
##
#F  StringOfAtlasTableOfContents( <inforec> )
##
InstallGlobalFunction( StringOfAtlasTableOfContents, function( inforec )
    local dirid, remote, prefix, open, close, toc, data, entry, name, val,
          entry2, reps, type, nam, r, line, map, i, j, list, comp, str,
          parskip;

    if IsString( inforec ) then
      r:= First( AtlasOfGroupRepresentationsInfo.notified,
                 x -> x.ID = inforec );
      if r = fail then
        Error( "if the argument is a string then it must be \"core\" ",
               "or the ID of a data extension" );
      elif IsBound( r.data ) then
        r:= r.data;
      fi;
      inforec:= rec( ID:= inforec );
      if IsBound( r.DataURL ) and StartsWith( r.DataURL, "http" ) then
        inforec.DataURL:= r.DataURL;
      fi;
      for comp in [ "Version", "SelfURL", "LocalDirectory" ] do
        if IsBound( r.( comp ) ) then
          inforec.( comp ):= r.( comp );
        fi;
      od;
    fi;

    if not IsRecord( inforec ) then
      Error( "<inforec> must be an ID string or a record" );
    elif not IsBound( inforec.ID ) then
      Error( "<inforec>.ID must be bound" );
    fi;

    dirid:= inforec.ID;
    if ForAll( AtlasOfGroupRepresentationsInfo.notified,
               x -> x.ID <> dirid ) then
      Error( "<inforec>.ID must be \"core\" ",
             "or the ID of a data extension" );
    fi;

    remote:= IsBound( inforec.DataURL ) and
             StartsWith( inforec.DataURL, "http" );

    prefix:= "[\"";
    open:= "\",[";
    close:= "]]";

    toc:= AGR.TablesOfContents( dirid )[1];

    data:= rec( GNAN:= [],
                GRS:= [],
                MXN:= [],
                MXO:= [],
                MXS:= [],
                TOC:= [],
                STDCOMP:= [],
                RNG:= [],
                TOCEXT:= [],
                API:= [],
                CHAR:= [],
              );

    # Collect the available information for this group.
    for entry in AtlasOfGroupRepresentationsInfo.GAPnames do

      if entry[4].GNAN = dirid then
        Add( data.GNAN, [ entry[1], Concatenation( "\"", entry[2], "\"" ) ] );
      fi;
      if IsBound( entry[4].GRS ) and entry[4].GRS = dirid then
        Add( data.GRS, [ entry[1], String( entry[3].size ) ] );
      fi;
      if IsBound( entry[4].MXN ) and entry[4].MXN = dirid then
        Add( data.MXN, [ entry[1], String( entry[3].nrMaxes ) ] );
      fi;
      if IsBound( entry[4].MXO ) and entry[4].MXO = dirid then
        # For the JSON format, replace each hole in the list by '0'.
        val:= ReplacedString( String( entry[3].sizesMaxes ), " ", "" );
        val:= ReplacedString( val, ",,", ",0," );
        val:= ReplacedString( val, ",,", ",0," );
        val:= ReplacedString( val, "[,", "[0," );
        Add( data.MXO, [ entry[1], val ] );
      fi;
      if IsBound( entry[4].MXS ) and entry[4].MXS = dirid then
        # For the JSON format, replace each hole in the list by '""'.
        val:= ReplacedString( String( entry[3].structureMaxes ), " ", "" );
        val:= ReplacedString( val, ",,", ",\"\"," );
        val:= ReplacedString( val, ",,", ",\"\"," );
        val:= ReplacedString( val, "[,", "[\"\"," );
        Add( data.MXS, [ entry[1], val ] );
      fi;
      if IsBound( entry[3].factorCompatibility ) then
        for entry2 in entry[3].factorCompatibility do
          if entry2[5] = dirid then
            Add( data.STDCOMP, [ entry[1],
              ReplacedString( String( entry2{ [ 1 .. 4 ] } ), " ", "" ) ] );
          fi;
        od;
      fi;
      if IsBound( entry[3].maxext ) then
        for entry2 in entry[3].maxext do
          if entry2[4] = dirid then
            Add( data.TOCEXT, [ entry[2],
              Concatenation(
                String( entry2[1] ), ",", String( entry2[2] ), ",",
                 ReplacedString( String( entry2[3] ), " ", "" ) ) ] );
          fi;
        od;
      fi;

      if remote and IsBound( toc.( entry[2] ) ) then
        # Collect the representations and straight line programs.
        reps:= toc.( entry[2] );
        for type in AGR.DataTypes( "rep", "prg" ) do
          if IsBound( reps.( type[1] ) ) then
            for entry in reps.( type[1] ) do
              if IsBound( type[2].TOCEntryString ) then
                val:= type[2].TOCEntryString( type[1], entry );
                if val = fail then
                  Info( InfoAtlasRep, 1,
                        "'TOCEntryString' for data type '", type[1], "'",
                        " returns 'fail'" );
                else
                  Add( data.TOC, type[2].TOCEntryString( type[1], entry ) );
                fi;
              else
                Info( InfoAtlasRep, 1,
                      "no component 'TOCEntryString' for data type '",
                      type[1], "'" );
              fi;
            od;
          fi;
        od;
      fi;

    od;

    for entry in AtlasOfGroupRepresentationsInfo.ringinfo do
      if entry[ Length( entry ) ] = dirid then
        if Length( entry ) = 4 then
          Add( data.RNG, [ entry[1], Concatenation( "\"", entry[2], "\"" ) ] );
        else
          # The length is 6.
          Add( data.RNG, [ entry[1], Concatenation( "\"", entry[2], "\"" ),
                           entry[4], entry[5] ] );
        fi;
      fi;
    od;

    for nam in RecNames( AtlasOfGroupRepresentationsInfo.permrepinfo ) do
      r:= AtlasOfGroupRepresentationsInfo.permrepinfo.( nam );
      if r.dirid = dirid then
        line:= "[";
        Append( line, String( r.transitivity ) );
        Append( line, "," );
        if r.transitivity = 0 then
          Append( line, ReplacedString( String( r.orbits ), " ", "" ) );
        else
          Append( line, String( r.rankAction ) );
          Append( line, "," );
          if r.isPrimitive then
            Append( line, "\"prim\"" );
          else
            Append( line, "\"imprim\"" );
          fi;
          Append( line, ",\"" );
          Append( line, r.stabilizer );
          Append( line, "\"" );
          if r.isPrimitive then
            Append( line, "," );
            if IsInt( r.maxnr ) then
              Append( line, String( r.maxnr ) );
            else
              Append( line, "\"" );
              Append( line, String( r.maxnr ) );
              Append( line, "\"" );
            fi;
          fi;
        fi;
        Append( line, "]" );

        Add( data.API, [ nam, line ] );
      fi;
    od;

    for nam in RecNames( AtlasOfGroupRepresentationsInfo.characterinfo ) do
      map:= AtlasOfGroupRepresentationsInfo.characterinfo.( nam );
      for i in [ 1 .. Length( map ) ] do
        if IsBound( map[i] ) then
          for j in [ 1 .. Length( map[i][1] ) ] do
            if map[i][4][j] = dirid then
              # This information belongs to the current t.o.c.
              line:= Concatenation( "\"", map[i][2][j], "\"," );
              if i = 1 then
                Append( line, "0" );
              else
                Append( line, String( i ) );
              fi;
              Append( line, "," );
              Append( line,
                      ReplacedString( String( map[i][1][j] ), " ", "" ) );
              if map[i][3][j] <> fail then
                Append( line, ",\"" );
                Append( line, map[i][3][j] );
                Append( line, "\"" );
              fi;
              Add( data.CHAR, [ nam, line ] );
            fi;
          od;
        fi;
      od;
    od;

    list:= [];
    for comp in [ "GNAN", "GRS", "MXN", "MXO", "MXS" ] do
      parskip:= "\n";
      Sort( data.( comp ) );
      for entry in data.( comp ) do
        Add( list, Concatenation( parskip, prefix, comp, open,
                       "\"", entry[1], "\",", entry[2], close ) );
        parskip:= "";
      od;
    od;

    # Sort the TOC entries by filename and type.
    SortParallel( List( data.TOC,
        x -> SplitString( x, "\"" ){ [ 4, 2 ] } ), data.TOC );
    parskip:= "\n";
    for entry in data.TOC do
      Add( list, Concatenation( parskip, prefix, "TOC", open, entry, close ) );
      parskip:= "";
    od;

    for comp in [ "STDCOMP", "RNG", "TOCEXT", "API", "CHAR" ] do
      parskip:= "\n";
      Sort( data.( comp ) );
      for entry in data.( comp ) do
        if Length( entry ) = 2 then
          Add( list, Concatenation( parskip, prefix, comp, open,
                         "\"", entry[1], "\",", entry[2], close ) );
        else
          Add( list, Concatenation( parskip, prefix, comp, open,
                         "\"", entry[1], "\",", entry[2], ",",
                         ReplacedString( String( entry[3] ), " ", "" ), ",",
                         ReplacedString( String( entry[4] ), " ", "" ),
                         close ) );
        fi;
        parskip:= "";
      od;
    od;

    str:= "{\n";
    Append( str, "\"ID\":\"" );
    Append( str, dirid );
    Append( str, "\",\n" );
    for comp in [ "Version", "DataURL", "SelfURL", "LocalDirectory" ] do
      if IsBound( inforec.( comp ) ) then
        Append( str, "\"" );
        Append( str, comp );
        Append( str, "\":\"" );
        Append( str, inforec.( comp ) );
        Append( str, "\",\n" );
      fi;
    od;
    Append( str, "\"Data\":[" );
    Append( str, JoinStringsWithSeparator( list, ",\n" ) );
    Append( str, "\n]\n}\n" );

    return str;
end );


#############################################################################
##
#F  AGR.TablesOfContents( <descr> )
##
##  Admissible arguments are
##  1 the string "all",
##  2 the string "local",
##  3 a string describing a table of contents
##    which occurs as the 'ID' component of an entry in
##    'AtlasOfGroupRepresentationsInfo.notified', or
##  4 a list of conditions such as [ <std>, "contents", <...> ]
##  5 a list of strings as 1-3.
##
AGR.TablesOfContents:= function( descr )
    local pos, tocid, allorlocal, label, tocs, entry;

    if descr = [] then
      descr:= [ "all" ];
    elif IsString( descr ) then
      descr:= [ descr ];
    elif not IsList( descr ) then
      Error( "<descr> must be a string or a list of strings/conditions" );
    fi;

    pos:= Position( descr, "contents" );
    if pos <> fail then
      # 'descr' is a list of conditions.
      # Evaluate only its "contents" part,
      # i. e., restrict the tables of contents, and remove this condition.
      # (Do not make a shallow copy!)
      tocid:= descr[ pos+1 ];
      Remove( descr, pos );
      Remove( descr, pos );
      if IsString( tocid ) then
        descr:= [ tocid ];
      else
        descr:= tocid;
      fi;
    elif ForAny( descr,
                 x -> x <> "all" and x <> "local"
                      and ForAll( AtlasOfGroupRepresentationsInfo.notified,
                                  entry -> x <> entry.ID ) ) then
      # 'descr' is a list of conditions that do not restrict the
      # table of contents.
      descr:= [ "all" ];
    fi;
    pos:= Position( descr, "local" );
    if pos <> fail then
      allorlocal:= "local";
      Remove( descr, pos );
      if descr = [] then
        descr:= [ "all" ];
      fi;
    else
      allorlocal:= "all";
    fi;

    # Now 'descr' is a list of identifiers of tables of contents.
    label:= JoinStringsWithSeparator(
                SortedList( Concatenation( [ allorlocal ], descr ) ), "|" );
    if not IsBound( AtlasOfGroupRepresentationsInfo.TOC_Cache.( label ) ) then
      tocs:= [];
      for entry in AtlasOfGroupRepresentationsInfo.notified do
        if "all" in descr or entry.ID in descr then
          Add( tocs, AtlasTableOfContents( entry.ID, allorlocal ) );
        fi;
      od;
      AtlasOfGroupRepresentationsInfo.TOC_Cache.( label ):= tocs;
    fi;
    return AtlasOfGroupRepresentationsInfo.TOC_Cache.( label );
end;


#############################################################################
##
#F  AGR.CreateLocalJSONFile( <dirid>, <body> )
##
##  Return either 'fail' or the path of the newly created file.
##
AGR.CreateLocalJSONFile:= function( dirid, body )
    local pref, datadir, filename;

    pref:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
    if pref = "" then
      # We cannot (or do not want to) store local files.
      return fail;
    elif pref <> "" and not EndsWith( pref, "/" ) then
      pref:= Concatenation( pref, "/" );
    fi;
    datadir:= Concatenation( pref, "dataext/", dirid );
    if not IsDirectoryPath( datadir ) then
      # Create the subdirectory 'dirid' and set the mode 1023.
      # (Note that 'mkdir' does not guarantee the required mode,
      # so we call 'chmod' afterwards.)
      if not IsPackageMarkedForLoading( "IO", "" ) or
         IO_mkdir( datadir, 1023 ) <> true then
        Info( InfoAtlasRep, 1,
              "AtlasOfGroupRepresentationsNotifyData:\n",
              "#I  'IO_mkdir' cannot create the local directory\n",
              "#I  ", datadir );
        return fail;
      elif IO_chmod( datadir, 1023 ) <> true then
        Info( InfoAtlasRep, 1,
              "AtlasOfGroupRepresentationsNotifyData:\n",
              "#I  'IO_chmod' cannot set the mode of \n",
              "#I  ", datadir, " to 1023" );
        return fail;
      fi;
    fi;

    filename:= Filename( Directory( datadir ), "toc.json" );
    if IsReadableFile( filename ) then
      # A perhaps outdated version of the file is stored;
      # we did not know this in advance because 'dirid' was not given.
      # Compare the current version with the available one,
      # and update the local version if necessary.
      if AGR.StringFile( filename ) <> body then
        if FileString( filename, body ) = fail then
          Info( InfoAtlasRep, 1,
                "AtlasOfGroupRepresentationsNotifyData:\n",
                "#I  could not replace file\n",
                "#I  '", filename, "'" );
          return fail;
        else
          Info( InfoAtlasRep, 1,
                "AtlasOfGroupRepresentationsNotifyData:\n",
                "#I  replaced file\n",
                "#I  '", filename, "'" );
        fi;
      fi;
    elif FileString( filename, body ) = fail then
      Info( InfoAtlasRep, 1,
            "AtlasOfGroupRepresentationsNotifyData:\n",
            "#I  could not write local file\n",
            "#I  '", filename, "'" );
      return fail;
    else
      Info( InfoAtlasRep, 1,
            "AtlasOfGroupRepresentationsNotifyData:\n",
            "#I  wrote new file\n",
            "#I  '", filename, "'" );
    fi;

    return filename;
end;


#############################################################################
##
#F  AtlasOfGroupRepresentationsNotifyData( <dir>, <id>[, <test>] )
#F  AtlasOfGroupRepresentationsNotifyData( <filename>[, <id>][, <test>] )
#F  AtlasOfGroupRepresentationsNotifyData( <url>[, <id>][, <test>] )
#F  AtlasOfGroupRepresentationsNotifyData( <filecontents>[, <id>][, <test>] )
##
InstallGlobalFunction( AtlasOfGroupRepresentationsNotifyData,
    function( arg )
    local usage, test, dir, filename, url, firstarg, dirname, dirid, body, f,
          known, r, comp, localdir, pos, package, path, localdirs, pref,
          datadirs, p, datadir, oldtest, olddata, nam, entry,
          toc, allfilenames, RemovedDirectories, groupname, record, type,
          name, tocs, ok, oldtoc, list, i, names, unknown, value;

    # Get and check the arguments.
    usage:= Concatenation(
      "usage:\n",
      "AtlasOfGroupRepresentationsNotifyData( <dir>, <id>[, <test>] ),\n",
      "AtlasOfGroupRepresentationsNotifyData( <filename>[, <id>][, <test>] ),\n",
      "AtlasOfGroupRepresentationsNotifyData( <url>[, <id>][, <test>] ),\n",
      "AtlasOfGroupRepresentationsNotifyData( <filecontents>[, <id>][, <test>] )" );

    test:= false;
    if Length( arg ) = 0 then
      Error( usage );
    elif IsBool( arg[ Length( arg ) ] ) then
      test:= ( arg[ Length( arg ) ] = true );
      Remove( arg );
      if Length( arg ) = 0 then
        Error( usage );
      fi;
    fi;

    dir:= fail;
    filename:= fail;
    url:= fail;
    body:= fail;
    firstarg:= arg[1];
    if IsDirectory( firstarg ) then
      # first form, with directory
      dir:= firstarg;
      dirname:= ShallowCopy( dir![1] );
    elif IsString( firstarg ) then
      if StartsWith( firstarg, "~" ) then
        firstarg:= UserHomeExpand( firstarg );
      fi;
      if IsDirectoryPath( firstarg ) then
        # first form, with directory path
        dirname:= ShallowCopy( firstarg );
        dir:= Directory( dirname );
      elif IsReadableFile( firstarg ) then
        # second form
        filename:= firstarg;
      elif not StartsWith( firstarg, "{" ) then
        # third form
        url:= firstarg;
      else
        # fourth form
        body:= firstarg;
      fi;
    else
      Error( usage );
    fi;

    if Length( arg ) = 2 and IsString( arg[2] ) then
      dirid:= arg[2];
      if dirid = "local" then
        # "local" is reserved to restrict overviews.
        Error( "<dirid> must not be the string \"local\"" );
      elif ( dir <> fail or filename <> fail ) and
         ForAny( AtlasOfGroupRepresentationsInfo.notified,
                 entry -> entry.ID = dirid and
                          not StartsWith( entry.DataURL, "http" ) ) then
        # We have already notified this extension,
        # and it is a local one, thus we can ignore this notification.
        # (If we know the extension just as a remote one,
        # we can try to upgrade it to a local one.)
        return true;
      fi;
    elif Length( arg ) <> 1 then
      Error( usage );
    fi;

    if dir <> fail then

      # This is the first form:
      # A local directory contains some data files.

      if IsEmpty( dirname ) then
        Error( "<dirname> must not be empty" );
      elif dirname[ Length( dirname ) ] <> '/' then
        Add( dirname, '/' );
      fi;
      Add( AtlasOfGroupRepresentationsInfo.notified,
           rec( ID:= dirid, DataURL:= dirname ) );

    elif filename <> fail then

      # This is the second form:
      # A local JSON format file describes remote and/or local data.
      body:= AGR.StringFile( filename );
      if body = fail then
        Info( InfoAtlasRep, 1,
              "AtlasOfGroupRepresentationsNotifyData:\n",
              "#I  cannot read '", filename, "'" );
        return false;
      fi;
      f:= AGR.GapObjectOfJsonText( body );
      if f.status = false then
        Error( "file <filename> does not contain valid JSON" );
      fi;
      f:= f.value;
      if IsBound( dirid ) and dirid <> f.ID then
        Error( "'", dirid, "' differs from ID in file: '", filename, "'" );
      fi;
      dirid:= f.ID;
      known:= First( AtlasOfGroupRepresentationsInfo.notified,
                     entry -> entry.ID = dirid );
      if known <> fail then
        if known.ID = dirid and not StartsWith( known.DataURL, "http" ) then
          # We have already notified this extension as a local one.
          return true;
        elif dirid = "core" then
          return true;
        fi;
      fi;

      # The extension is either new or has been notified as a remote one
      # which may later be upgraded to a local one.
      if dirid = "core" then
        r:= rec( ID:= dirid, data:= f );
        for comp in [ "Version", "DataURL", "SelfURL", "LocalDirectory" ] do
          if IsBound( f.( comp ) ) then
            r.( comp ):= f.( comp );
          fi;
        od;
        Add( AtlasOfGroupRepresentationsInfo.notified, r );
        AtlasTableOfContents( dirid, "all" );
        return true;
      elif IsBound( f.LocalDirectory ) then
        # If the local directory is available then delegate to the first form.
        # The filename is interpreted relative to GAP's 'pkg' directory,
        # so we assume that the relevant package is already loaded.
        localdir:= f.LocalDirectory;
        pos:= Position( f.LocalDirectory, '/' );
        if pos = fail then
          Error( "local directory ", f.LocalDirectory,
                 " does not have the form <pkgname>/<path>" );
        fi;
        package:= f.LocalDirectory{ [ 1 .. pos-1 ] };
        if IsPackageMarkedForLoading( package, "" ) then
          path:= f.LocalDirectory{ [ pos+1 .. Length ( f.LocalDirectory ) ] };
          localdirs:= DirectoriesPackageLibrary( package, path );
          if not IsEmpty( localdirs ) and IsDirectory( localdirs[1] ) then
            # Do not delegate to the first form
            # because we need the components of 'f'.
            Info( InfoAtlasRep, 2,
                  "AtlasOfGroupRepresentationsNotifyData:\n",
                  "#I  use the local directory instead of the remote one ",
                  "for '", dirid, "'" );
            if known <> fail then
              # Remove the remote notification before we can upgrade to local.
              Info( InfoAtlasRep, 2,
                    "AtlasOfGroupRepresentationsNotifyData:\n",
                    "#I  first remove the remote notification" );
              AtlasOfGroupRepresentationsForgetData( dirid );
            fi;
            r:= rec( ID:= dirid, DataURL:= ShallowCopy( localdirs[1]![1] ) );
          fi;
        fi;
      fi;

      if not IsBound( r ) then
        # If we arrive here then 'LocalDirectory' cannot be used.
        # Create a copy of the JSON file in the local data directory
        # if possible.
        AGR.CreateLocalJSONFile( dirid, body );
        r:= rec( ID:= dirid, DataURL:= f.DataURL );
      fi;
      r.data:= f;
      for comp in [ "Version", "SelfURL", "LocalDirectory" ] do
        if IsBound( f.( comp ) ) then
          r.( comp ):= f.( comp );
        fi;
      od;
      Add( AtlasOfGroupRepresentationsInfo.notified, r );

    elif url <> fail then

      # This is the third form:
      # We know a URL where a JSON format file can be found
      # that describes remote and/or local data.
      # - If 'dirid' is given and we have already a local copy of this file
      #   then we delegate to the second form.
      # - Otherwise, if we are in online mode and can download this file
      #   then do this and then delegate to the fourth form.
      # - Otherwise we give up.

      pref:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
      if pref <> "" and not EndsWith( pref, "/" ) then
        pref:= Concatenation( pref, "/" );
      fi;
      datadirs:= Directory( Concatenation( pref, "dataext" ) );
      if IsBound( dirid ) then
        datadirs:= Filename( datadirs, dirid );
        if IsReadableFile( datadirs ) and IsDirectoryPath( datadirs ) then
          filename:= Filename( Directory( datadirs ), "toc.json" );
          if IsReadableFile( filename ) then
            Info( InfoAtlasRep, 1,
                  "AtlasOfGroupRepresentationsNotifyData:\n",
                  "#I  use the locally available '", dirid, "/toc.json'\n",
                  "#I  instead of '", url, "'" );
            return AtlasOfGroupRepresentationsNotifyData(
                       filename, dirid, test );
          fi;
        fi;
      fi;

      if UserPreference( "AtlasRep", "AtlasRepAccessRemoteFiles" ) = true then
        # Try to fetch the file.
        body:= AtlasOfGroupRepresentationsTransferFile( url, fail, fail );
        if body = false then
          Info( InfoAtlasRep, 1,
                "AtlasOfGroupRepresentationsNotifyData:\n",
                "#I  cannot read '", url, "'" );
          return false;
        fi;

        f:= AGR.GapObjectOfJsonText( body );
        if f.status = false then
          Error( "file does not contain valid JSON: ", url );
        fi;
        f:= f.value;
        if not IsBound( f.ID ) then
          Error( "file does not contain ID: ", url );
        elif IsBound( dirid ) and dirid <> f.ID then
          Error( "'", dirid, "' differs from ID in file: ", url );
        elif not IsBound( f.DataURL ) then
          Error( "file does not contain DataURL: ", url );
        fi;
        dirid:= f.ID;
        if ForAny( AtlasOfGroupRepresentationsInfo.notified,
                   entry -> entry.ID = dirid and
                            not StartsWith( entry.DataURL, "http" ) ) then
          # We have already notified this extension as a local one.
          return true;
        fi;

        # Store a local copy of the file if it is not yet available
        # and if we are allowed/able to write local files;
        # it can then be used next time in offline mode.
        # If necessary then create a subdirectory in 'dataext'.
        filename:= AGR.CreateLocalJSONFile( dirid, body );

        # Delegate to the fourth form.
        return AtlasOfGroupRepresentationsNotifyData( body, dirid, test );

      elif IsBound( dirid ) then
        Info( InfoAtlasRep, 2,
              "AtlasOfGroupRepresentationsNotifyData:\n",
              "#I  cannot notify new data extension in offline mode,\n",
              "#I  local directory '", dirid, "'\n",
              "#I  is not available" );
      else
        Info( InfoAtlasRep, 2,
              "AtlasOfGroupRepresentationsNotifyData:\n",
              "#I  cannot notify new data extension via\n",
              "#I  '", url, "'\n",
              "#I  in offline mode" );
      fi;

      # Give up.
      return false;

    fi;

    # Now we are in the first, second, or fourth form.
    # It remains to evaluate the JSON file.
    # The file may contain calls of 'AGR.GNAN' (which must come *before* the
    # data for the groups in question can be notified) and of 'AGR.API' and
    # 'AGR.CHAR' (which must come *afterwards*).
    # So we must postpone the calls of 'AGR.IsRepNameAvailable'.
    # If the private files are not stored locally then the file must contain
    # also the relevant 'AGR.TOC' calls.
    oldtest:= IsBound( AtlasOfGroupRepresentationsInfo.checkData );
    Unbind( AtlasOfGroupRepresentationsInfo.checkData );
    olddata:= rec(
      permrepinfo:= RecNames( AtlasOfGroupRepresentationsInfo.permrepinfo ),
      charrepinfo:= [],
      );
    for nam in RecNames( AtlasOfGroupRepresentationsInfo.characterinfo ) do
      for entry in AtlasOfGroupRepresentationsInfo.characterinfo.( nam ) do
        Append( olddata.charrepinfo, entry[2] );
      od;
    od;

    # Set up the table of contents for the extension.
    # The following call does the work.
    if body <> fail then
      if ForAll( AtlasOfGroupRepresentationsInfo.notified,
                 r -> r.ID <> dirid ) then
        # 'AtlasTableOfContents' sets the necessary components.
        Add( AtlasOfGroupRepresentationsInfo.notified, rec( ID:= dirid ) );
      fi;
      toc:= AtlasTableOfContents( dirid, "all", body );
    else
      toc:= AtlasTableOfContents( dirid, "all" );
    fi;

    # In test mode, make the ignored filenames visible.
    if test and IsBound( toc.otherfiles )
            and not IsEmpty( toc.otherfiles ) then
      Print( "#I  AtlasOfGroupRepresentationsNotifyData:\n",
             "#I  ignored files in ", dirname, ":\n",
             "#I  ", toc.otherfiles, "\n" );
    fi;
    Unbind( toc.otherfiles );

    # Check that no filename of this table of contents exists already in
    # another table of contents.
    Sort( AtlasOfGroupRepresentationsInfo.filenames );
    ok:= true;
    for entry in AtlasOfGroupRepresentationsInfo.newfilenames do
      pos:= PositionSorted( AtlasOfGroupRepresentationsInfo.filenames,
                            [ entry[1] ] );
      if pos <= Length( AtlasOfGroupRepresentationsInfo.filenames )
         and AtlasOfGroupRepresentationsInfo.filenames[ pos ][1] = entry[1] then
        Info( InfoAtlasRep, 1,
              "file '", entry[1], "' was already in another t.o.c." );
        ok:= false;
      fi;
    od;
      
    if not ok then
      AtlasOfGroupRepresentationsForgetData( dirid );
      return false;
    fi;

    Append( AtlasOfGroupRepresentationsInfo.filenames,
            AtlasOfGroupRepresentationsInfo.newfilenames );
    AtlasOfGroupRepresentationsInfo.newfilenames:= [];
    Sort( AtlasOfGroupRepresentationsInfo.filenames );

    # Add group names that were not notified.
    unknown:= Set( Filtered( RecNames( toc ),
                       x -> ForAll( AtlasOfGroupRepresentationsInfo.GAPnames,
                                    pair -> x <> pair[2] ) ) );
    RemoveSet( unknown, "TocID" );
    RemoveSet( unknown, "lastupdated" );
    if not IsEmpty( unknown ) then
      ok:= false;
      Info( InfoAtlasRep, 1,
            "no GAP names defined for ", unknown );
      for name in unknown do
        value:= [ name, name, rec() ];
        AddSet( AtlasOfGroupRepresentationsInfo.GAPnames, value );
        AGR.GAPnamesRec.( name ):= value;
      od;
    fi;

    # Clear the caches.
    AGR.SetGAPnamesSortDisp();
    AtlasOfGroupRepresentationsInfo.TOC_Cache:= rec();
    AtlasOfGroupRepresentationsInfo.TableOfContents.merged:= rec();

    # Run the postponed tests.
    if test then
      AtlasOfGroupRepresentationsInfo.checkData:= true;
      olddata.repinfo:= Difference(
                   RecNames( AtlasOfGroupRepresentationsInfo.permrepinfo ),
                   olddata.permrepinfo );
      olddata.charrepinfonew:= [];
      for nam in RecNames( AtlasOfGroupRepresentationsInfo.characterinfo ) do
        for entry in AtlasOfGroupRepresentationsInfo.characterinfo.( nam ) do
          Append( olddata.charrepinfonew, entry[2] );
        od;
      od;
      UniteSet( olddata.repinfo, Difference( olddata.charrepinfonew,
                                             olddata.charrepinfo ) );
      for nam in olddata.repinfo do
        ok:= AGR.IsRepNameAvailable( nam ) and ok;
      od;
    fi;

    # Restore the original flag.
    if not oldtest then
      Unbind( AtlasOfGroupRepresentationsInfo.checkData );
    fi;

    # Return the flag.
    return ok;
    end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsForgetData( <dirid> )
##
InstallGlobalFunction( AtlasOfGroupRepresentationsForgetData,
    function( dirid )
    local GAPnames, notified, i, j, entry, gapname, pos, list, info;

    GAPnames:= AtlasOfGroupRepresentationsInfo.GAPnames;
    notified:= AtlasOfGroupRepresentationsInfo.notified;

    for i in [ 1 .. Length( notified ) ] do
      if notified[i].ID = dirid then

        # Remove the group related information that belongs to 'dirid'.
        for j in [ 1 .. Length( GAPnames ) ] do
          entry:= GAPnames[j];
          if entry[4].GNAN = dirid then
            gapname:= entry[1];
            pos:= Position( AGR.MapNameToGAPName[2], gapname );
            if pos <> fail then
              Remove( AGR.MapNameToGAPName[1], pos );
              Remove( AGR.MapNameToGAPName[2], pos );
            fi;
            Unbind( GAPnames[j] );
            # This throws away information which was perhaps added
            # in another extension.
            Unbind( AGR.GAPnamesRec.( gapname ) );
          fi;
          if IsBound( entry[4].GRS ) and entry[4].GRS = dirid then
            Unbind( entry[4].GRS );
            Unbind( entry[3].size );
          fi;
          if IsBound( entry[4].MXN ) and entry[4].MXN = dirid then
            Unbind( entry[4].MXN );
            Unbind( entry[3].nrMaxes );
          fi;
          if IsBound( entry[4].MXO ) and entry[4].MXO = dirid then
            Unbind( entry[4].MXO );
            Unbind( entry[3].sizesMaxes );
          fi;
          if IsBound( entry[4].MXS ) and entry[4].MXS = dirid then
            Unbind( entry[4].MXS );
            Unbind( entry[3].structureMaxes );
          fi;
        od;
        AtlasOfGroupRepresentationsInfo.GAPnames:= Compacted( GAPnames );

        # Remove information about representations.
        AtlasOfGroupRepresentationsInfo.ringinfo:= Filtered(
            AtlasOfGroupRepresentationsInfo.ringinfo,
            x -> x[ Length(x) ] <> dirid );
        for gapname in RecNames(
                         AtlasOfGroupRepresentationsInfo.characterinfo ) do
          for list in AtlasOfGroupRepresentationsInfo.characterinfo.(
                          gapname ) do
            for pos in Reversed( Positions( list[4], dirid ) ) do
              for j in [ 1 .. 4 ] do
                Remove( list[j], pos );
              od;
            od;
          od;
        od;
        info:= AtlasOfGroupRepresentationsInfo.permrepinfo;
        for entry in RecNames( info ) do
          if info.( entry ).dirid = dirid then
            Unbind( info.( entry ) );
          fi;
        od;

        AtlasOfGroupRepresentationsInfo.filenames:= Filtered(
            AtlasOfGroupRepresentationsInfo.filenames,
            x -> x[3] <> dirid );
        AtlasOfGroupRepresentationsInfo.newfilenames:= [];

        # Remove the information concerning the data extension.
        Remove( notified, i );

        # Discard all caches.
        Unbind( AtlasOfGroupRepresentationsInfo.TableOfContents.(
                    Concatenation( dirid, "|all" ) ) );
        Unbind( AtlasOfGroupRepresentationsInfo.TableOfContents.(
                    Concatenation( dirid, "|local" ) ) );
        AtlasOfGroupRepresentationsInfo.TableOfContents.merged:= rec();
        AGR.SetGAPnamesSortDisp();
        AtlasOfGroupRepresentationsInfo.TOC_Cache:= rec();

        return;

      fi;
    od;

    Print( "#I  AtlasOfGroupRepresentationsForgetData:\n",
           "#I  There seems to be no data extension with identifier '",
           dirid, "'\n" );
    end );


if IsString( IO_mkdir ) then
  Unbind( IO_mkdir );
fi;
if IsString( IO_stat ) then
  Unbind( IO_stat );
fi;
if IsString( IO_chmod ) then
  Unbind( IO_chmod );
fi;


#############################################################################
##
#E

