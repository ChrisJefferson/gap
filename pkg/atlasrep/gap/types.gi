#############################################################################
##
#W  types.gi             GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains implementations of the functions for administrating
##  the data types used in the ATLAS of Group Representations.
##


#############################################################################
##
#F  AGR_Checksum( <entry>, <typename> )
##
##  <entry> is an entry in 'AtlasOfGroupRepresentationsInfo.filenames',
##  that is, a list of length 3 or 4.
##
BindGlobal( "AGR_Checksum", function( entry, typename )
    local tocid, info, localname;

    if Length( entry ) >= 4 then
      # There is already a checksum.
      if ValueOption( "SHA" ) = true then
        if IsString( entry[4] ) then
          return Concatenation( "\"", entry[4], "\"" );
        fi;
      elif IsInt( entry[4] ) then
        return String( entry[4] );
      fi;
    fi;

    tocid:= entry[3];
    if tocid = "core" then
      if ForAny( AtlasOfGroupRepresentationsInfo.TableOfContents.types.rep,
                 x -> x[1] = typename ) then
        tocid:= "datagens";
      else
        tocid:= "dataword";
      fi;
    fi;

    # If the file is available locally then compute the value,
    # otherwise leave it out.
    info:= AtlasOfGroupRepresentationsLocalFilename(
               [ [ tocid, entry[1] ] ], typename );
    info:= First( info, l -> l[2][1][2] = true );
    if info = fail then
      return fail;
    fi;
    localname:= info[2][1][1];
    if EndsWith( localname, ".json" ) then
      # The t.o.c. file contains the checksum for the '.g' file.
      localname:= Concatenation(
                      localname{ [ 1 .. Length( localname ) - 5 ] }, ".g" );
      if not IsExistingFile( localname ) then
        return fail;
      fi;
    fi;
    if ValueOption( "SHA" ) = true and IsBoundGlobal( "HexSHA256" ) then
      return Concatenation( "\"",
                 ValueGlobal( "HexSHA256" )( StringFile( localname ) ),
                 "\"" );
    else
      return String( CrcFile( localname ) );
    fi;
end );


#############################################################################
##
#F  TOCEntryStringDefault( <typename>, <entry> )
##
BindGlobal( "TOCEntryStringDefault", function( typename, entry )
    local list, name, pos, info, crc;

    list:= AtlasOfGroupRepresentationsInfo.filenames;
    name:= entry[ Length( entry ) ];
    pos:= PositionSorted( list, [ name ] );
    if pos > Length( list ) or list[ pos ][1] <> name then
      return fail;
    fi;
    entry:= list[ pos ];
    info:= Concatenation( "\"", typename, "\",\"", entry[2], "\"" );
    crc:= AGR_Checksum( entry, typename );
    if crc <> fail then
      Append( info, Concatenation( ",[", crc, "]" ) );
    fi;
    return info;
end );


#############################################################################
##
#F  AGR.DisplayOverviewInfoDefault( <dispname>, <align>, <compname> )
##
AGR.DisplayOverviewInfoDefault:= function( dispname, align, compname )
    return [ dispname, align, function( conditions )
      local groupname, tocs, std, value, private, toc, record, new;

      groupname:= conditions[1][2];
      tocs:= AGR.TablesOfContents( conditions );
      if Length( conditions ) = 1 or
         not ( IsInt( conditions[2] ) or IsList( conditions[2] ) ) then
        std:= true;
      else
        std:= conditions[2];
        if IsInt( std ) then
          std:= [ std ];
        fi;
      fi;

      value:= false;
      private:= false;
      for toc in tocs do
        if IsBound( toc.( groupname ) ) then
          record:= toc.( groupname );
          if IsBound( record.( compname ) ) then
            new:= ForAny( record.( compname ),
                          x -> std = true or x[1] in std );
            if toc.TocID <> "core" and new then
              private:= true;
            fi;
            value:= value or new;
          fi;
        fi;
      od;
      if value then
        value:= "+";
      else
        value:= "";
      fi;
      return [ value, private ];
    end ];
    end;


#############################################################################
##
#F  AGR.TestWordsSLPDefault( <tocid>, <name>, <file>, <type>, <outputs>,
#F                           <verbose> )
##
##  For the straight line program that is returned by
##  <Ref Func="AGR.FileContents"/> when this is called
##  with the first four arguments,
##  it is checked that it is internally consistent and that it can be
##  evaluated at the right number of arguments.
##  If the argument <A>outputs</A> is <K>true</K> then it is additionally
##  checked that the result record has a component <C>outputs</C>,
##  a list whose length equals the number of outputs of the program.
##  (The argument <A>verbose</A> is currently not used,
##  in other <C>TestWords</C> functions the value <K>true</K> triggers that
##  more statements may be printed than just error messages.
##
AGR.TestWordsSLPDefault:= function( tocid, name, file, type, outputs, verbose )
    local filename, prog, prg, gens;

    # Read the program.
    if tocid = "core" then
      tocid:= "dataword";
    fi;
    prog:= AGR.FileContents( [ [ tocid, file ] ], type );
    if prog = fail then
      Print( "#E  file `", file, "' is corrupted\n" );
      return false;
    fi;

    # Check consistency.
    if prog = fail or not IsInternallyConsistent( prog.program ) then
      Print( "#E  program `", file, "' not internally consistent\n" );
      return false;
    fi;
    prg:= prog.program;

    # Create the list of (trivial) generators.
    gens:= ListWithIdenticalEntries( NrInputsOfStraightLineProgram( prg ),
                                     () );

    # Run the program.
    gens:= ResultOfStraightLineProgram( prg, gens );

    # If the script computes class representatives then
    # check whether there is an `outputs' component of the right length.
    if outputs = true then
      if not IsBound( prog.outputs ) then
        Print( "#E  program `", file, "' without component `outputs'\n" );
        return false;
      elif Length( prog.outputs ) <> Length( gens ) then
        Print( "#E  program `", file, "' with wrong number of `outputs'\n" );
        return false;
      fi;
    fi;

    return true;
    end;


#############################################################################
##
#F  AGR.TestWordsSLDDefault( <tocid>, <name>, <file>, <type>, <format>,
#F                           <verbose> )
##
##  For the straight line decision that is returned by
##  <Ref Func="AGR.FileContents"/> when this is called
##  with the same arguments,
##  it is checked that it is internally consistent and that it can be
##  evaluated in all relevant representations.
##
AGR.TestWordsSLDDefault:= function( tocid, name, file, type, format, verbose )
    local filename, prog, result, gapname, orderfunc, std, entry, gens;

    # Read the program.
    if tocid = "core" then
      tocid:= "dataword";
    fi;
    prog:= AGR.FileContents( [ [ tocid, file ] ], type );
    if prog = fail then
      Print( "#E  file `", file, "' is corrupted\n" );
      return false;
    fi;

    # Check consistency.
    if not IsInternallyConsistent( prog.program ) then
      Print( "#E  program `", file, "' not internally consistent\n" );
      return false;
    fi;
    prog:= prog.program;

    # Evaluate the program in *all* relevant representations.
    result:= true;
    gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                     pair -> name = pair[2] );
    if gapname = fail then
      Print( "#E  problem: no GAP name for `", name, "'\n" );
      return false;
    fi;
    gapname:= gapname[1];

    orderfunc:= function( g )
      if IsMatrix( g ) then
        # We know that the group elements that occur have small order.
        return OrderMatTrial( g, 10000 );
      else
        return Order( g );
      fi;
    end;

    std:= ParseBackwards( file, format );
    std:= std[3];
    for entry in AllAtlasGeneratingSetInfos( gapname, std,
                                             "contents", "local" ) do
      gens:= AtlasGenerators( entry.identifier );
      if gens <> fail then
        if not ResultOfStraightLineDecision( prog, gens.generators,
                   orderfunc ) then
          Print( "#E  program `", file, "' does not fit to\n#E  `",
                 entry.identifier, "'\n" );
          result:= false;
        fi;
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.TestFileHeadersDefault( <tocid>, <groupname>, <entry>, <type>, <dim>,
#F                              <special> )
##
##  This function can be used only if the last entry in the list <entry> is
##  the name of *one* file that contains a list of matrices.
##
AGR.TestFileHeadersDefault:= function( tocid, groupname, entry, type, dim, special )
    local filename, cand, name, mats;

    if tocid = "core" then
      tocid:= "datagens";
    fi;

    # Try to read the file.
    dim:= [ dim, dim ];
    filename:= entry[ Length( entry ) ];
    cand:= AtlasOfGroupRepresentationsLocalFilename(
               [ [ tocid, filename ] ], type );
    if not ( Length( cand ) = 1 and ForAll( cand[1][2], x -> x[2] ) ) then
      return true;
    fi;
    mats:= AGR.FileContents( [ [ tocid, filename ] ], type );

    # Check that the file contains a list of matrices of the right dimension.
    if   mats = fail then
      Print( "#E  filename `", filename, "' not found\n" );
      return false;
    elif not ( IsList( mats ) and ForAll( mats, IsMatrix ) ) then
      Print( "#E  file `", filename,
             "' does not contain a list of matrices\n" );
      return false;
    elif ForAny( mats, mat -> DimensionsMat( mat ) <> dim ) then
      Print( "#E  matrices in `",filename,"' have wrong dimensions\n" );
      return false;
    fi;

    # Check the entries.
    special:= special( entry, mats, filename );
    if IsString( special ) then
      Print( "#E  ", special, "\n" );
      return false;
    fi;

    return true;
    end;


#############################################################################
##
#F  AGR.TestFilesMTX( <tocid>, <groupname>, <entry>, <type> )
##
AGR.TestFilesMTX:= function( tocid, groupname, entry, type )
    local result, filename;

    if tocid = "core" then
      tocid:= "datagens";
    fi;

    # Read the file(s).
    result:= true;
    for filename in entry[ Length( entry ) ] do
      if AGR.FileContents( [ [ tocid, filename ] ], type ) = fail then
        Print( "#E  file `", filename, "' corrupted\n" );
        result:= false;
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AtlasProgramInfoDefault( <type>, <identifier>, <groupname> )
##
##  This function can be used only in the case that the second entry in
##  <identifier> is either one filename or a list of length one,
##  such that the unique entry is a list of a t.o.c. identifier and
##  a filename.
##
BindGlobal( "AtlasProgramInfoDefault",
    function( type, identifier, groupname )
    local filename;

    filename:= identifier[2];
    if not IsString( filename ) then
      filename:= filename[1][2];
    fi;

    if IsString( filename ) and
       AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
           <> fail then
      return rec( standardization := identifier[3],
                  identifier      := identifier );
    fi;

    return fail;
end );


#############################################################################
##
#F  AtlasProgramDefault( <type>, <identifier>, <groupname> )
##
##  This function can be used only in the case that the second entry in
##  <identifier> is either one filename or a list of length one,
##  such that the unique entry is a list of a t.o.c. identifier and
##  a filename.
##
BindGlobal( "AtlasProgramDefault", function( type, identifier, groupname )
    local filename, tocid, prog, result;

    filename:= identifier[2];
    if IsString( filename ) then
      tocid:= "dataword";
    else
      tocid:= filename[1][1];
      filename:= filename[1][2];
    fi;

    if IsString( filename ) and
       AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
           <> fail then
      prog:= AGR.FileContents( [ [ tocid, filename ] ], type );
      if prog <> fail then
        result:= rec( program         := prog.program,
                      standardization := identifier[3],
                      identifier      := identifier );
        if IsBound( prog.outputs ) then
          result.outputs:= prog.outputs;
        fi;
        return result;
      fi;
    fi;

    return fail;
end );


#############################################################################
##
#F  AGR.CheckOneCondition( <func>[, <detect>], <condlist> )
##
##  This function always returns `true'; it changes <condlist> in place.
##
AGR.CheckOneCondition:= function( arg )
    local func, detect, condlist, pos, val;

    func:= arg[1];
    if Length( arg ) = 2 then
      condlist:= arg[2];
    else
      detect:= arg[2];
      condlist:= arg[3];
    fi;
    pos:= Position( condlist, func );
    while pos <> fail do
      if Length( arg ) = 2 then
        # Support `IsPermGroup' etc. *without* subsequent `true'.
        Unbind( condlist[ pos ] );
      else
        if pos = Length( condlist ) then
          # Keep `condlist' unchanged.
          # If there is a call without <detect> then it will remove the entry.
          return true;
        fi;
        val:= condlist[ pos+1 ];
        if    ( IsString( val ) and detect( val ) )
           or ( not IsList( val ) and detect( val ) )
           or ( IsList( val ) and ForAny( val, detect ) ) then
          Unbind( condlist[ pos ] );
          Unbind( condlist[ pos+1 ] );
        fi;
      fi;
      pos:= Position( condlist, func, pos );
    od;
    return true;
    end;


#############################################################################
##
#F  AGR.DeclareDataType( <kind>, <name>, <record> )
##
##  Check that the necessary components are bound,
##  and add default values if necessary.
##
AGR.DeclareDataType:= function( kind, name, record )
    local types, nam;

    # Check that the type does not yet exist.
    types:= AtlasOfGroupRepresentationsInfo.TableOfContents.types;
    if ForAny( types.( kind ), x -> x[1] = name ) then
      Error( "data type <name> exists already" );
    fi;
    record:= ShallowCopy( record );

    # Check mandatory components.
    for nam in [ "FilenameFormat", "AddFileInfo",
                 "ReadAndInterpretDefault" ] do
      if not IsBound( record.( nam ) ) then
        Error( "the component `", nam, "' must be bound in <record>" );
      fi;
    od;

    # Add default components.
    if not IsBound( record.DisplayOverviewInfo ) then
      record.DisplayOverviewInfo:= fail;
    fi;
    if not IsBound( record.TOCEntryString ) then
      record.TOCEntryString := TOCEntryStringDefault;
    fi;
    if not IsBound( record.PostprocessFileInfo ) then
      record.PostprocessFileInfo := Ignore;
    fi;
    if   kind = "rep" then
      for nam in [ "DisplayGroup", "AddDescribingComponents" ] do
        if not IsBound( record.( nam ) ) then
          Error( "the component `", nam, "' must be bound in <record>" );
        fi;
      od;
      if not IsBound( record.AccessGroupCondition ) then
        record.AccessGroupCondition := ReturnFalse;
      fi;
      if not IsBound( record.TestFileHeaders ) then
        record.TestFileHeaders := ReturnTrue;
      fi;
      if not IsBound( record.TestFiles ) then
        record.TestFiles := ReturnTrue;
      fi;
    elif kind = "prg" then
      if not IsBound( record.DisplayPRG ) then
        record.DisplayPRG := function( tocs, names, std, stdavail )
            return []; end;
      fi;
      if not IsBound( record.AccessPRG ) then
        record.AccessPRG := function( toc, groupname, std, conditions )
          return fail;
        end;
      fi;
      if not IsBound( record.AtlasProgram ) then
        record.AtlasProgram := AtlasProgramDefault;
      fi;
      if not IsBound( record.AtlasProgramInfo ) then
        record.AtlasProgramInfo := AtlasProgramInfoDefault;
      fi;
    else
      Error( "<kind> must be one of \"rep\", \"prg\"" );
    fi;

    # Add the pair.
    Add( types.( kind ), [ name, record, kind ] );

    # Clear the cache.
    types.cache:= [];
    end;


#############################################################################
##
#F  AGR.DataTypes( <kind1>[, <kind2>] )
##
##  returns the list of pairs <C>[ <A>name</A>, <A>record</A> ]</C>
##  as declared for the kinds in question.
##
AGR.DataTypes:= function( arg )
    local types, result, kind;

    types:= AtlasOfGroupRepresentationsInfo.TableOfContents.types;
    result:= First( types.cache, x -> x[1] = arg );

    if result = fail then
      result:= [];
      for kind in arg do
        if IsBound( types.( kind ) ) then
          Append( result, types.( kind ) );
        fi;
      od;
      result:= [ arg, result ];
      Add( types.cache, result );
    fi;

    return result[2];
    end;


#############################################################################
##
#F  AGR.VersionOfSLP( <filename> )
##
##  Note that 'cyc2ccl' scripts involve *two* version numbers,
##  the one of the corresponding 'cyc' script and the one of their own.
##  We return the *list* of these version numbers in this case.
##
AGR.VersionOfSLP:= function( filename )
    local len, pos, pos2;

    if not IsString( filename ) then
      # a list of one or more file descriptions, take the first of them
      filename:= filename[1];
      if not IsString( filename ) then
        # a file from a private extension
        filename:= filename[2];
      fi;
    fi;

    len:= Length( filename );
    pos:= len;
    while IsDigitChar( filename[ pos ] ) do
      pos:= pos - 1;
    od;
    if 6 < pos and filename{ [ pos-5 .. pos ] } = "-cclsW" then
      # Check whether we are in the case of a 'cyc2ccls' script.
      pos2:= pos-6;
      while IsDigitChar( filename[ pos2 ] ) do
        pos2:= pos2 - 1;
      od;
      if 4 < pos2 and filename{ [ pos2-3 .. pos2 ] } = "cycW" then
        return [ filename{ [ pos2+1 .. pos-6 ] },
                 filename{ [ pos+1 .. len ] } ];
      fi;
    fi;

    return filename{ [ pos+1 .. len ] };
    end;


#############################################################################
##
#F  AGR.StandardizeMaximalSubgroup( <groupname>, <maxslpname>, <std>, <vers> )
##
##  returns <K>fail</K> or the list
##  <C>[ <A>filename</A>, <A>std</A> ]</C>
##  where a straight line program for standardizing the generators of the
##  maximal subgroup given by <maxslpname> can be found in the file
##  <A>filename</A> (which is either a string or a list containng the
##  name of the table of contents and the actual filename.
##  The standardization number of the result is <A>std</A>.
##  One can prescribe this standardization via a list or integer <std>,
##  otherwise one can enter <K>true</K> as <std>.
##  If <A>vers</A> is <K>true</K> then any version of the program is taken,
##  otherwise only a version in the list <A>vers</A>.
##
AGR.StandardizeMaximalSubgroup:= function( groupname, maxslpname, std, vers )
    local prefix, toc, r, l, filename;

    if IsInt( std ) then
      std:= [ std ];
    fi;
    if IsInt( vers ) then
      vers:= [ vers ];
    fi;
    prefix:= ReplacedString( maxslpname, "-", "" );
    for toc in AGR.TablesOfContents( "all" ) do
      if IsBound( toc.( groupname ) ) then
        r:= toc.( groupname );
        if IsBound( r.maxstd ) then
          for l in r.maxstd do
            filename:= l[6];
            if l[6]{ [ 1 .. Position( filename, '-' ) - 1 ] } = prefix and
               ( std = true or l[5] in std ) and
               ( vers = true or AGR.VersionOfSLP( filename ) in vers ) then
              if toc.TocID <> "core" then
                return [ [ toc.TocID, filename], l[5] ];
              else
                return [ filename, l[5] ];
              fi;
            fi;
          od;
        fi;
      fi;
    od;

    return fail;
    end;


#############################################################################
##
#F  AGR.CommonDisplayPRG( <title>, <stdavail>, <data>, <onelineonly> )
##
##  This is a utility for the 'DisplayPRG' functions of "prg" types.
##
##  <data> is a matrix whose columns correspond to
##  1. the values to be shown in the first column
##  2. the privacy flags
##  3. the standardizations,
##  4. the versions,
##  5. the identifiers,
##  6. (optional) additional information for the second column
##
AGR.CommonDisplayPRG:= function( title, stdavail, data, onelineonly )
    local res, entry, line, private;

    res:= [];

    if Length( data ) = 0 then
      return res;
    elif Length( data ) = 1 and onelineonly then
      # Show just one line.
      # (If there is only one line then showing version info makes no sense.)
      entry:= data[1];
      if 1 < Length( stdavail ) then
        Add( res, Concatenation( "(for std. generators ", entry[3], ")" ) );
      fi;
      if IsBound( entry[6] ) then
        Add( res, Concatenation( "(", entry[6], ")" ) );
      fi;
      return [ Concatenation( title, entry[2] ),
               JoinStringsWithSeparator( res, "  " ),
               entry[5] ];
    else
      # Show a header line plus one line for each program.
      for entry in data do
        line:= [];
        # Show the standardization only if several are available.
        if 1 < Length( stdavail ) then
          Add( line, Concatenation( "(for std. gen. ", entry[3], ")" ) );
        fi;
        # Show the version only if several are available.
        if 0 < Number( data, x -> x[1] = entry[1] and x[4] <> entry[4] ) then
          Add( line, Concatenation( "(version ", entry[4], ")" ) );
        fi;
        # Show additional information whenever available.
        if IsBound( entry[6] ) then
          Add( line, Concatenation( "(", entry[6], ")" ) );
        fi;
        Add( res, [ Concatenation( entry[1], entry[2] ),
                    JoinStringsWithSeparator( line, "  " ),
                    entry[5] ] );
      od;

      private:= First( data, x -> x[2] <> "" );
      if private = fail then
        private:= "";
      else
        private:= private[2];
      fi;
      return Concatenation( [ Concatenation( title, private ) ], res );
    fi;
    end;


#############################################################################
##
#F  AtlasProgramInfoForFilename( <filename> )
##
##  returns the `AtlasProgramInfo' record for the straight line program with
##  filename <filename>, which must be a string.
##
##  This function is used for example by the function
##  'GeneralizedStraightLineProgramFromInfo',
##  which evaluates data files from the CTBlocks package.
##
#T document this function, then change the reference in CTBlocks accordingly
##
BindGlobal( "AtlasProgramInfoForFilename", function( filename )
    local type, parsed, gapname, toc, data, l, id;

    for type in AGR.DataTypes( "prg" ) do
      parsed:= AGR.ParseFilenameFormat( filename, type[2].FilenameFormat );
      if parsed <> fail then
        # We need always GAP name, filename, and standardization.
        # In case of a private extension,
        # the second entry is a pair of the form [ <tocid>, <gapname> ].
        gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                         pair -> pair[2] = parsed[1] )[1];
        if gapname = fail then
          return fail;
        fi;

        for toc in AGR.TablesOfContents( "all" ) do
          if IsBound( toc.( parsed[1] ) ) then
            data:= toc.( parsed[1] );
            if IsBound( data.( type[1] ) ) then
              for l in data.( type[1] ) do
                if l[ Length( l ) ] = filename then
                  id:= [ gapname, filename, parsed[3] ];
                  if toc.TocID <> "core" then
                    id[2]:= [ [ toc.TocID, filename ] ];
                  fi;
                  # ...
                  if type[1] in [ "check", "find", "kernel", "pres", "switch" ] then
                    id[4]:= parsed[5];
                  elif type[1] = "out" then
                    id[3]:= parsed[5];
#T is this really intended? -> better add the standardization of G!!!
                  elif not type[1] in [ "maxes", "classes", "cyclic",
                                        "cyc2ccl", "maxstd", "switch",
                                        "otherscripts" ] then
                    Error( "unknown type <type>" );
                  fi;
                  return AtlasProgramInfo( id );
                fi;
              od;
            fi;
          fi;
        od;
      fi;
    od;

    return fail;
    end );


#############################################################################
##
#E

