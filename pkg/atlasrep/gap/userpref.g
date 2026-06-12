#############################################################################
##
#W  userpref.g           GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains the declarations of the user preferences for the
##  AtlasRep package.
##


#############################################################################
##
#U  AtlasRepAccessRemoteFiles
##
##  <#GAPDoc Label="AtlasRepAccessRemoteFiles">
##  <Subsection Label="subsect:AtlasRepAccessRemoteFiles">
##  <Heading>User preference <C>AtlasRepAccessRemoteFiles</C></Heading>
##  <Index Key="AtlasRepAccessRemoteFiles"><C>AtlasRepAccessRemoteFiles</C></Index>
##  <Index>local access</Index>
##  <Index>remote access</Index>
##
##  The value <K>true</K> (the default) allows the &AtlasRep; package
##  to fetch data files that are not yet locally available.
##  If the value is <K>false</K> then only those data files can be used
##  that are available locally.
##  <P/>
##  If you are working offline then you should set the value to <K>false</K>.
##  <P/>
##  Changing the value in a running &GAP; session does not affect the
##  information shown by <Ref Func="DisplayAtlasInfo"/>,
##  this information depends on the value of the preference at the time
##  when the &AtlasRep; package and its data extensions get loaded.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepAccessRemoteFiles",
  description:= [
    "The value 'true' (the default) allows the AtlasRep package to fetch \
data files that are not yet locally available.  \
If the value is 'false' then only those data files can be used that are \
available locally.  \
Changing the value in a running GAP session does not affect the \
information shown by 'DisplayAtlasInfo', \
this information depends on the value of the preference at the time \
when the AtlasRep package and its data extensions get loaded."
    ],
  default:= true,
  values:= [ true, false ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  AtlasRepDataDirectory
##
##  <#GAPDoc Label="AtlasRepDataDirectory">
##  <Subsection Label="subsect:AtlasRepDataDirectory">
##  <Heading>User preference <C>AtlasRepDataDirectory</C></Heading>
##  <Index Key="AtlasRepDataDirectory"><C>AtlasRepDataDirectory</C></Index>
##
##  The value must be a string that is either empty or the filename of a
##  directory (in the sense of <Ref Func="IsDirectoryPath" BookName="ref"/>)
##  that contains the directories in which downloaded data will be stored.
##  <P/>
##  An empty string means that downloaded data are just kept in the &GAP;
##  session but not saved to local files.
##  <P/>
##  The default depends on the user's permissions for the subdirectories
##  <F>dataext</F>, <F>datagens</F>, <F>dataword</F> of the &AtlasRep;
##  directory:
##  If these directories are writable for the user then the installation path
##  of the &AtlasRep; package (including a trailing slash symbol) is taken.
##  If this is not the case but the currentl &GAP; session is running inside
##  a &Julia; session then a &Julia; scratchspace is taken,
##  otherwise the default is an empty string.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepDataDirectory",
  description:= [
    "The value must be a string that is either empty or the filename \
of a directory (in the sense of 'IsDirectoryPath') \
that contains the directories in which downloaded data will be stored. \
An empty string means that downloaded data are just kept in the GAP session \
but not saved to local files. \
The default depends on the user's permissions for the subdirectories \
'dataext', 'datagens', 'dataword' of the AtlasRep directory: \
If these directories are writable for the user then the installation path \
of the AtlasRep package (including a trailing slash symbol) is taken. \
If this is not the case but the current GAP session is running inside a \
Julia session then a Julia scratchspace is taken, \
otherwise the default is an empty string."
    ],
  default:= function()
      local val, dir, julia, Scratch, subdir, file;

      # In general, the default of a user preference gets computed
      # also if a value is already stored.
      # (This can be regarded as a bug in the handling of user preferences.)
      # Here we return a stored value without running the computation.
      val:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
      if val <> fail then
        return val;
      fi;

      dir:= DirectoriesPackageLibrary( "atlasrep", "" );
      if ForAll( [ "dataext", "datagens", "dataword" ],
                 subdir -> IsWritableFile( Filename( dir, subdir ) ) ) then
        # The package directory is the first default.
        return Filename( dir, "" );
      elif IsPackageLoaded( "JuliaInterface" ) then
        # Create/fetch a Julia scratchspace.
        julia:= ValueGlobal( "Julia" );
        Scratch:= julia.GAP.eval( ValueGlobal( "JuliaEvalString" )(
                      ":(import Scratch; Scratch)" ) );
        val:= julia.GAP.GapObj( Scratch.( "get_scratch!" )( julia.GAP,
                  julia.String( "atlasrep_cache" ) ) );
        if not IsDirectoryPath( val ) then
          # Something went wrong.
          return "";
        fi;

        # Create writable subdirectories if necessary.
        dir:= Directory( val );
        for subdir in [ "datagens", "dataword", "dataext" ] do
          file:= Filename( dir, subdir );
          if not IsDirectoryPath( file ) then
            CreateDir( file );
          fi;
        od;

        return Concatenation( val, "/" );
      else
        return "";
      fi;
    end,
  package:= "AtlasRep",
  check:= function( val )
    if val = "" then
      return true;
    elif not ( IsString( val ) and IsDirectoryPath( val ) ) then
      Info( InfoWarning, 1,
            "the value of the preference 'AtlasRepDataDirectory' must be\n",
            "#W  an empty string or a directory path" );
      return false;
    elif Last( val ) <> '/' then
      Info( InfoWarning, 1,
            "the value of the preference 'AtlasRepDataDirectory' must end ",
            "with '/'" );
      return false;
    elif ForAny( [ "datagens", "dataword", "dataext" ],
             name -> not IsDirectoryPath( Concatenation( val, name ) ) ) then
      Info( InfoWarning, 1,
            "the directory given by the preference ",
            "'AtlasRepDataDirectory'\n",
            "#W  must contain subdirectories 'datagens', 'dataword', ",
            "'dataext'" );
      return false;
    fi;

    return true;
  end,
  ) );


#############################################################################
##
#U  AtlasRepTOCData
##
##  <#GAPDoc Label="AtlasRepTOCData">
##  <Subsection Label="subsect:AtlasRepTOCData">
##  <Heading>User preference <C>AtlasRepTOCData</C></Heading>
##  <Index Key="AtlasRepTOCData"><C>AtlasRepTOCData</C></Index>
##
##  The value must be a list of strings of the form <C>"ID|address"</C>
##  where <C>ID</C> is the id of a part of the database
##  and <C>address</C> is an URL or a file path
##  (as an absolute path or relative to the user's home directory,
##  cf.&nbsp;<Ref Func="Directory" BookName="ref"/>) of a readable
##  JSON format file that contain the table of contents of this part,
##  see <Ref Func="StringOfAtlasTableOfContents"/>.
##  <P/>
##  The default lists four entries:
##  the core database, the data distributed with the &AtlasRep; package,
##  and the data that belong to the packages
##  <Package>MFER</Package> and <Package>CTBlocks</Package>.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepTOCData",
  description:= [
    "The value must be a list of strings of the form \"<ID>|<address>\" \
where <ID> is the id of a part of the database \
and <address> is an URL or a file path \
(as an absolute path or relative to the user's home directory) of a readable \
JSON format file that contain the table of contents of this part. \
The default lists four entries: \
the core database, the data distributed with the AtlasRep package, \
and the data that belong to the packages MFER and CTBlocks."
    ],
  default:= function()
    local res, file;

    # the two files from the AtlasRep package
    if IsBoundGlobal( "HexSHA256" ) then
      res:= [ Concatenation( "core|",
                  Filename( DirectoriesPackageLibrary( "atlasrep", "" ),
                            "atlasprm_SHA.json" ) ),
              Concatenation( "internal|",
                  Filename( DirectoriesPackageLibrary( "atlasrep", "" ),
                            "datapkg/toc_SHA.json" ) ) ];
    else
      res:= [ Concatenation( "core|",
                  Filename( DirectoriesPackageLibrary( "atlasrep", "" ),
                            "atlasprm.json" ) ),
              Concatenation( "internal|",
                  Filename( DirectoriesPackageLibrary( "atlasrep", "" ),
                            "datapkg/toc.json" ) ) ];
    fi;

    # the MFER file
    if IsBoundGlobal( "HexSHA256" ) then
      file:= Filename( DirectoriesPackageLibrary( "mfer", "" ),
                       "mfertoc_SHA.json" );
      if file <> fail then
        Add( res, Concatenation( "mfer|", file ) );
      else
        Add( res, "mfer|http://www.math.rwth-aachen.de/~mfer/mfertoc_SHA.json" );
      fi;
    else
      file:= Filename( DirectoriesPackageLibrary( "mfer", "" ),
                       "mfertoc.json" );
      if file <> fail then
        Add( res, Concatenation( "mfer|", file ) );
      else
        Add( res, "mfer|http://www.math.rwth-aachen.de/~mfer/mfertoc.json" );
      fi;
    fi;

    # the CTBlocks file
    if IsBoundGlobal( "HexSHA256" ) then
      file:= Filename( DirectoriesPackageLibrary( "ctblocks", "" ),
                       "ctblockstoc_SHA.json" );
      if file <> fail then
        Add( res, Concatenation( "ctblocks|", file ) );
      else
        Add( res, "ctblocks|http://www.math.rwth-aachen.de/~Thomas.Breuer/ctblocks/ctblockstoc_SHA.json" );
      fi;
    else
      file:= Filename( DirectoriesPackageLibrary( "ctblocks", "" ),
                       "ctblockstoc.json" );
      if file <> fail then
        Add( res, Concatenation( "ctblocks|", file ) );
      else
        Add( res, "ctblocks|http://www.math.rwth-aachen.de/~Thomas.Breuer/ctblocks/ctblockstoc.json" );
      fi;
    fi;

    return res;
  end,

  package:= "AtlasRep",
  check:= function( val )
    local ok, entry, suffix;

    ok:= true;
    if not IsList( val ) then
      ok:= false;
    else
      for entry in val do
        if not ( IsString( entry ) and '|' in entry ) then
          ok:= false;
          break;
        else
          suffix:= entry{ [ Position( entry, '|' )+1 .. Length( entry ) ] };
          if not ( StartsWith( suffix, "http" ) or
                   IsReadableFile( suffix ) ) then
            ok:= false;
            break;
          fi;
        fi;
      od;
    fi;
    if not ok then
      Info( InfoWarning, 1,
            "the value of the preference 'AtlasRepTOCData' must be ",
            "a list of strings of the form \"<ID>|<address>\" ",
            "where <address> is an URL or a file path of a readable file" );
      return false;
    fi;

    return true;
  end,
  ) );


#############################################################################
##
#U  CompressDownloadedMeatAxeFiles
##
##  <#GAPDoc Label="CompressDownloadedMeatAxeFiles">
##  <Subsection Label="subsect:CompressDownloadedMeatAxeFiles">
##  <Heading>User preference <C>CompressDownloadedMeatAxeFiles</C></Heading>
##  <Index Key="CompressDownloadedMeatAxeFiles"><C>CompressDownloadedMeatAxeFiles</C></Index>
##
##  <Index Key="compress"><C>compress</C></Index>
##  <Index Key="gzip"><F>gzip</F></Index>
##  When used with UNIX, &GAP; can read <F>gzip</F>ped files,
##  see&nbsp;<Ref Sect="Saving and Loading a Workspace" BookName="ref"/>.
##  If the package's user preference <C>CompressDownloadedMeatAxeFiles</C>
##  has the value <K>true</K>
##  then each &MeatAxe; format text file that is downloaded from the internet
##  is afterwards compressed with <F>gzip</F>.
##  The default value is <K>false</K>.
##  <P/>
##  Compressing files saves a lot of space if many &MeatAxe; format files
##  are accessed.
##  (Note that data files in other formats are very small.)
##  For example, at the time of the release of version&nbsp;2.0 the core
##  database contained about <M>8\,400</M> data files in &MeatAxe; format,
##  which needed about <M>1\,400</M> MB in uncompressed text format
##  and about <M>275</M> MB in compressed text format.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "CompressDownloadedMeatAxeFiles",
  description:= [
    "When  used with UNIX, GAP can read 'gzip'ped files.  \
If this preference has the value 'true' then each MeatAxe format text file \
that is downloaded from a remote server \
is afterwards compressed with 'gzip'.  \
The default value is 'false'."
    ],
  default:= false,
  values:= [ true, false ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  FileAccessFunctions
##
##  <#GAPDoc Label="FileAccessFunctions">
##  <Subsection Label="subsect:FileAccessFunctions">
##  <Heading>User preference <C>FileAccessFunctions</C></Heading>
##  <Index Key="FileAccessFunctions"><C>FileAccessFunctions</C></Index>
##
##  This preference allows one to customize what actually happens
##  when data are requested by the interface functions:
##  Is it necessary to download some files?
##  If yes then which files are downloaded?
##  If no then which files are actually read into &GAP;?
##  <P/>
##  Currently one can choose among the following features.
##  <P/>
##  <Enum>
##  <Item>
##    Download/read &MeatAxe; text files.
##  </Item>
##  <Item>
##    Prefer downloading/reading &MeatAxe; binary files.
##  </Item>
##  <Item>
##    Prefer reading locally available data files.
##  </Item>
##  </Enum>
##  <P/>
##  (Of course files can be downloaded only if the user preference
##  <C>AtlasRepAccessRemoteFiles</C> has the value <K>true</K>,
##  see Section <Ref Subsect="subsect:AtlasRepAccessRemoteFiles"/>.)
##  <P/>
##  This feature could be used more generally,
##  see Section <Ref Sect="sect:How to Customize the Access to Data files"/>
##  for technical details and the possibility to add other features.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "FileAccessFunctions",
  description:= [
    "This preference allows one to customize what actually happens \
when data are requested by the interface functions. \
(Of course files can be downloaded only if the user preference \
'AtlasRepAccessRemoteFiles' has the value 'true'.)"
    ],
  default:= [ "download/read MeatAxe text files (default)" ],
  values:= [ "download/read MeatAxe text files (default)",
             "prefer downloading/reading MeatAxe binary files",
#            "prefer downloading/reading GAP format files",
             "prefer reading files available from a local server" ],
  multi:= true,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  AtlasRepMarkNonCoreData
##
##  <#GAPDoc Label="AtlasRepMarkNonCoreData">
##  <Subsection Label="subsect:AtlasRepMarkNonCoreData">
##  <Heading>User preference <C>AtlasRepMarkNonCoreData</C></Heading>
##  <Index Key="AtlasRepMarkNonCoreData"><C>AtlasRepMarkNonCoreData</C></Index>
##
##  The value is a string (the default is a star '*')
##  that is used in <Ref Func="DisplayAtlasInfo"/> to mark data that do not
##  belong to the core database,
##  see Section&nbsp; <Ref Sect="sect:Effect of Private Extensions"/>.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepMarkNonCoreData",
  description:= [
    "The value is a string (the default is a star '*') \
that is used in 'DisplayAtlasInfo' to mark data that do not \
belong to the core database."
    ],
  default:= "*",
  package:= "AtlasRep",
  check:= IsString,
  ) );


#############################################################################
##
#U  AtlasRepLocalServerPath
##
##  <#GAPDoc Label="AtlasRepLocalServerPath">
##  <Subsection Label="subsect:AtlasRepLocalServerPath">
##  <Heading>User preference <C>AtlasRepLocalServerPath</C></Heading>
##  <Index Key="AtlasRepLocalServerPath"><C>AtlasRepLocalServerPath</C></Index>
##
##  If the data of the core database are available locally
##  (for example because one has access to a local mirror of the data)
##  then one may prefer reading these files instead of downloading data.
##  In order to achieve this, one can set the user preference
##  <C>AtlasRepLocalServerPath</C> and add
##  <C>"direct access to a local server"</C> to the user preference
##  <C>FileAccessFunctions</C>,
##  see Section <Ref Subsect="subsect:FileAccessFunctions"/>.
##  <P/>
##  The value must be a string that is the filename of a directory
##  (in the sense of <Ref Func="IsDirectoryPath" BookName="ref"/>)
##  that contains the data of the &ATLAS; of Group Representations,
##  in the same directory tree structure as on the &ATLAS; server.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepLocalServerPath",
  description:= [
    "The value must be a string that is the filename of a directory \
(in the sense of 'IsDirectoryPath') \
that contains the data of the Atlas of Group Representations, \
in the same directory tree structure as on the Atlas server. \
This preference needs to be set only if \
\"direct access to a local server\" is an entry in the value of the \
user preference \"FileAccessFunctions\" of the AtlasRep package."
    ],
  default:= "",
  package:= "AtlasRep",
  check:= function( val )
    local name;

    if not ( "direct access to a local server" in
             UserPreference( "AtlasRep", "FileAccessFunctions" ) ) then
      # The value of this user preference is irrelevant.
      return true;
    elif not ( IsString( val ) and IsDirectoryPath( val ) ) then
      Info( InfoWarning, 1,
            "the value of the preference 'AtlasRepLocalServerPath' must be ",
            "a directory path" );
      return false;
    elif val[ Length( val ) ] <> '/' then
      Info( InfoWarning, 1,
            "the value of the preference 'AtlasRepLocalServerPath' must end ",
            "with '/'" );
      return false;
    fi;

    return true;
  end,
  ) );


#############################################################################
##
#U  HowToReadMeatAxeTextFiles
##
##  <#GAPDoc Label="HowToReadMeatAxeTextFiles">
##  <Subsection Label="subsect:HowToReadMeatAxeTextFiles">
##  <Heading>User preference <C>HowToReadMeatAxeTextFiles</C></Heading>
##  <Index Key="HowToReadMeatAxeTextFiles"><C>HowToReadMeatAxeTextFiles</C></Index>
##
##  The value <C>"fast"</C> means that <Ref Func="ScanMeatAxeFile"/> reads
##  text files via <Ref Func="StringFile" BookName="gapdoc"/>.
##  Otherwise each file containing a matrix over a finite field is read
##  line by line via  <Ref Func="ReadLine" BookName="ref"/>,
##  and the &GAP; matrix is constructed line by line,
##  in a compressed representation
##  (see&nbsp;<Ref Sect="Row Vectors over Finite Fields" BookName="ref"/>
##  and&nbsp;<Ref Sect="Matrices over Finite Fields" BookName="ref"/>);
##  this makes it possible to read large matrices in a reasonable amount
##  of space.
##  <P/>
##  The <Ref Func="StringFile" BookName="gapdoc"/> approach is faster
##  but needs more intermediate space when text files containing
##  matrices over finite fields are read.
##  For example, a <M>4\,370</M> by <M>4\,370</M> matrix over the field
##  with two elements
##  (as occurs for an irreducible representation of the Baby Monster)
##  requires less than <M>3</M> MB space in &GAP; but the corresponding
##  &MeatAxe; format text file is more than <M>19</M> MB large.
##  This means that when one reads the file with the fast variant,
##  &GAP; will temporarily grow by more than this value.
##  <P/>
##  Note that this parameter has an effect only when
##  <Ref Func="ScanMeatAxeFile"/> is used.
##  It has no effect for example if &MeatAxe; binary files are read,
##  cf.&nbsp;<Ref Func="FFMatOrPermCMtxBinary"/>.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "HowToReadMeatAxeTextFiles",
  description:= [
    "The value '\"fast\"' means that 'ScanMeatAxeFile' reads \
MeatAxe text files via 'StringFile'.  \
Otherwise each file containing a matrix over a finite \
field is read line by line via 'ReadLine',  \
and the GAP matrix is constructed line by line, \
in a compressed representation; \
this makes it possible to read large matrices in a reasonable amount of \
space.  \
The 'StringFile' approach is faster but needs more intermediate space \
when text files containing matrices over finite fields are read."
    ],
  default:= "minimizing the space",
  values:= [ "fast", "minimizing the space" ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  WriteMeatAxeFilesOfMode2
##
##  <#GAPDoc Label="WriteMeatAxeFilesOfMode2">
##  <Subsection Label="subsect:WriteMeatAxeFilesOfMode2">
##  <Heading>User preference <C>WriteMeatAxeFilesOfMode2</C></Heading>
##  <Index Key="WriteMeatAxeFilesOfMode2"><C>WriteMeatAxeFilesOfMode2</C></Index>
##
##  The value <K>true</K> means that the function <Ref Func="MeatAxeString"/>
##  will encode permutation matrices via mode 2 descriptions, that is,
##  the first entry in the header line is 2, and the following lines contain
##  the positions of the nonzero entries.
##  If the value is <K>false</K> (the default) then
##  <Ref Func="MeatAxeString"/> encodes permutation matrices
##  via mode 1 or mode 6 descriptions, that is,
##  the lines contain the matrix entries.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "WriteMeatAxeFilesOfMode2",
  description:= [
    "The value 'true' means that the function 'MeatAxeString' \
will encode permutation matrices via mode 2 descriptions, that is, \
the first entry in the header line is 2, and the following lines contain \
the positions of the nonzero entries.  \
If the value is 'false' (the default) then 'MeatAxeString' encodes \
permutation matrices via mode 1 or mode 6 descriptions, that is, \
the lines contain the matrix entries."
    ],
  default:= false,
  values:= [ true, false ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  WriteHeaderFormatOfMeatAxeFiles
##
##  <#GAPDoc Label="WriteHeaderFormatOfMeatAxeFiles">
##  <Subsection Label="subsect:WriteHeaderFormatOfMeatAxeFiles">
##  <Heading>User preference <C>WriteHeaderFormatOfMeatAxeFiles</C></Heading>
##  <Index Key="WriteHeaderFormatOfMeatAxeFiles"><C>WriteHeaderFormatOfMeatAxeFiles</C></Index>
##
##  This user preference determines the format of the header lines of
##  &MeatAxe; format strings created by <Ref Func="MeatAxeString"/>,
##  see the <C>C</C>-&MeatAxe; manual&nbsp;<Cite Key="CMeatAxe"/>
##  for details.
##  The following values are supported.
##  <List>
##  <Mark><C>"numeric"</C></Mark>
##  <Item>
##    means that the header line of the returned string
##    consists of four integers
##    (in the case of a matrix these are mode, row number, column number
##    and field size),
##  </Item>
##  <Mark><C>"numeric (fixed)"</C></Mark>
##  <Item>
##    means that the header line of the returned string
##    consists of four integers as in the case <C>"numeric"</C>,
##    but additionally each integer is right aligned in a substring of
##    length (at least) six,
##  </Item>
##  <Mark><C>"textual"</C></Mark>
##  <Item>
##    means that the header line of the returned string
##    consists of assignments such as <C>matrix field=2</C>.
##  </Item>
##  </List>
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "WriteHeaderFormatOfMeatAxeFiles",
  description:= [
    "This user preference determines the format of the header lines of \
MeatAxe format strings created by MeatAxeString, \
see the C-MeatAxe manual for details. \
The following values are supported. \
\"numeric\" means that the header line of the returned string \
consists of four integers \
(in the case of a matrix these are mode, row number, column number \
and field size), \
\"numeric (fixed)\" means that the header line of the returned string \
consists of four integers as in the case \"numeric\", \
but additionally each integer is right aligned in a substring of \
length (at least) six, \
\"textual\" means that the header line of the returned string \
consists of assignments such as \"matrix field=2\"."
    ],
  default:= "numeric",
  values:= [ "numeric", "numeric (fixed)", "textual" ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  BaseOfMeatAxePermutation
##
##  <#GAPDoc Label="BaseOfMeatAxePermutation">
##  <Subsection Label="subsect:BaseOfMeatAxePermutation">
##  <Heading>User preference <C>BaseOfMeatAxePermutation</C></Heading>
##  <Index Key="BaseOfMeatAxePermutation"><C>BaseOfMeatAxePermutation</C></Index>
##
##  The value <M>0</M> means that the function
##  <Ref Func="CMtxBinaryFFMatOrPerm"/> writes zero-based permutations,
##  that is, permutations acting on the points from <M>0</M> to the
##  degree minus one; this is achieved by shifting down all images of the
##  &GAP; permutation by one.
##  The value <M>1</M> (the default) means that the permutation stored in the
##  binary file acts on the points from <M>1</M> to the degree.
##  <P/>
##  Up to version&nbsp;2.3 of the <C>C</C>-&MeatAxe;, permutations in
##  binary files were always one-based.
##  Zero-based permutations were introduced in version&nbsp;2.4.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "BaseOfMeatAxePermutation",
  description:= [
    "The value 0 means that the function 'CMtxBinaryFFMatOrPerm' \
writes zero-based permutations, \
that is, permutations acting on the points from 0 to the \
degree minus one; this is achieved by shifting down all images of the \
GAP permutation by one.  \
The value 1 (the default) means that the permutation stored in the \
binary file acts on the points from 1 to the degree."
    ],
  default:= 1,
  values:= [ 0, 1 ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  DisplayFunction
##
##  <#GAPDoc Label="DisplayFunction">
##  <Subsection Label="subsect:DisplayFunction">
##  <Heading>User preference <C>DisplayFunction</C></Heading>
##  <Index Key="DisplayFunction"><C>DisplayFunction</C></Index>
##
##  The way how <Ref Func="DisplayAtlasInfo"/>
##  <!-- and <Ref Func="DisplayBlockInvariants" BookName="ctblocks"/> -->
##  shows the requested overview is controlled by the package
##  &AtlasRep;'s user preference <C>DisplayFunction</C>.
##  The value must be a string that evaluates to a &GAP; function.
##  The default value is <C>"Print"</C>
##  (see <Ref Func="Print" BookName="ref"/>),
##  other useful values are <C>"PrintFormattedString"</C>
##  (see <Ref Func="PrintFormattedString" BookName="gapdoc"/>)
##  and <C>"AGR.Pager"</C>;
##  the latter means that <Ref Func="Pager" BookName="ref"/> is called with
##  the <C>formatted</C> option,
##  which is necessary for switching off &GAP;'s automatic line breaking.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "DisplayFunction",
  description:= [
    "This preference controls the way how 'DisplayAtlasInfo', \
'DisplayBlockInvariants', and \
'DisplayCTblLibInfo' show the requested overview. \
The value must be a string that evaluates to a GAP function. \
The default value is \"Print\", \
other useful values are \"PrintFormattedString\" and \"AGR.Pager\"; \
the latter calls 'Pager' with the 'formatted' option, \
which is necessary for switching off GAP's automatic line breaking."
    ],
  default:= "Print",
  package:= "AtlasRep",
# check:= function( val ) ... end,
#T BrowseData.TryEval could be used to check this more or less safely.
#T Let us wait until the GAP library provides a function for that.
  ) );


#############################################################################
##
#U  DebugFileLoading
##
##  <#GAPDoc Label="DebugFileLoading">
##  <Subsection Label="subsect:DebugFileLoading">
##  <Heading>User preference <C>DebugFileLoading</C></Heading>
##  <Index Key="DebugFileLoading"><C>DebugFileLoading</C></Index>
##
##  If the value is <K>true</K> then debug messages are printed before and
##  after data files get loaded.
##  The default value is <K>false</K>.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "DebugFileLoading",
  description:= [
    "If the value is 'true' then debug messages are printed before and \
after data files get loaded. \
The default value is 'false'."
    ],
  default:= false,
  values:= [ true, false ],
  multi:= false,
  package:= "AtlasRep",
  ) );


#############################################################################
##
#U  AtlasRepJsonFilesAddresses
##
##  <#GAPDoc Label="AtlasRepJsonFilesAddresses">
##  <Subsection Label="subsect:AtlasRepJsonFilesAddresses">
##  <Heading>User preference <C>AtlasRepJsonFilesAddresses</C></Heading>
##  <Index Key="AtlasRepJsonFilesAddresses"><C>AtlasRepJsonFilesAddresses</C></Index>
##
##  The value, if set, must be a list of length two,
##  the first entry being an URL describing a directory that contains
##  Json format files of the available matrix representations in
##  characteristic zero,
##  and the second being a directory path where these files shall be
##  stored locally.
##  If the value is set (this is the default) then the functions
##  of the package use the Json format files instead of the GAP format files.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec(
  name:= "AtlasRepJsonFilesAddresses",
  description:= [
    "The value, if set, must be a list of length two, \
the first entry being an URL describing a directory that contains \
Json format files of the available matrix representations in \
characteristic zero, \
and the second being a directory path where these files shall be \
stored locally.  \
If the value is set (this is the default) then the functions \
of the package use the Json format files instead of the GAP format files."
    ],
  default:= [
    "http://www.math.rwth-aachen.de/~Thomas.Breuer/atlasrep/datachar0",
    Filename( DirectoriesPackageLibrary( "atlasrep", "datagens" ), "" ) ],
  package:= "AtlasRep",
  ) );


#############################################################################
##
#E

