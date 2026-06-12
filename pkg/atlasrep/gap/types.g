#############################################################################
##
#W  types.g              GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains implementations of the actual data types used in the
##  &ATLAS; of Group Representations.
##


#############################################################################
##
#V  AtlasOfGroupRepresentationsInfo
##
BindGlobal( "AtlasOfGroupRepresentationsInfo", rec(

    # user parameters
    accessFunctions := AtlasOfGroupRepresentationsAccessFunctionsDefault,

    # system parameters (filled automatically)
    GAPnames := [],

    ringinfo := [],

    permrepinfo := rec(),

    characterinfo := rec(),

    notified := [],

    filenames := [],
    newfilenames := [],

    TableOfContents := rec( core   := rec(),
                            types  := rec( rep   := [],
                                           prg   := [],
                                           cache := [] ),
                            merged := rec() ),

    TOC_Cache := rec(),
    ) );


#############################################################################
##
#D  Permutation representations
##
##  <#GAPDoc Label="type:perm:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-p</C><M>n</M><M>id</M><C>B</C><M>m</M><C>.m</C><M>nr</M></Mark>
##  <Item>
##    a file in &MeatAxe; text file format
##    containing the <M>nr</M>-th generator of a permutation representation
##    on <M>n</M> points.
##    An example is <C>M11G1-p11B0.m1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "perm", rec(

    # `<groupname>G<i>-p<n><id>B<m>.m<nr>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "p", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
                            "B", IsDigitChar, ".m", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed, comp, info, pos;

      repid:= record.identifier[2][1];
      if not IsString( repid ) then
        repid:= repid[2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.p:= Int( parsed[5] );
      record.id:= parsed[6];
      repid:= repid{ [ 1 .. Position( repid, '.' ) - 1 ] };
      if IsBound( AtlasOfGroupRepresentationsInfo.characterinfo.(
                      record.groupname ) ) then
        info:= AtlasOfGroupRepresentationsInfo.characterinfo.(
                   record.groupname );
        if IsBound( info[1] ) then
          info:= info[1];
          pos:= Position( info[2], repid );
          if pos <> fail then
            record.constituents:= info[1][ pos ];
            if info[3][ pos ] <> fail then
              record.charactername:= info[3][ pos ];
            fi;
          fi;

        fi;
      fi;
      if IsBound( AtlasOfGroupRepresentationsInfo.permrepinfo.( repid ) ) then
        repid:= AtlasOfGroupRepresentationsInfo.permrepinfo.( repid );
        for comp in [ "isPrimitive", "orbits", "rankAction", "stabilizer",
                      "transitivity", "maxnr" ] do
          if IsBound( repid.( comp ) ) and repid.( comp ) <> "???" then
            record.( comp ):= repid.( comp );
          fi;
        od;
      fi;
    end,

    # `[ <i>, <n>, <id>, <m>, <filenames> ]'
    AddFileInfo := function( list, entry, name )
      local known;
      if 0 < entry[5] then
        known:= First( list, x -> x{ [ 1 .. 4 ] } = entry{ [3, 5, 6, 8 ] } );
        if known = fail then
          known:= entry{ [ 3, 5, 6, 8 ] };
          Add( known, [] );
          Add( list, known );
        fi;
        known[5][ entry[10] ]:= name;
        return true;
      fi;
      return false;
    end,

    DisplayOverviewInfo := [ "#", "r", function( conditions )
      # Put *all* types of representations together, in particular
      # assume that the functions for the other "rep" kind types are trivial!
      local info, no;

      conditions:= ShallowCopy( conditions );
      conditions[1]:= conditions[1][1];
      info:= CallFuncList( AllAtlasGeneratingSetInfos, conditions );
      no:= Length( info );
      if no = 0 then
        no:= "";
      fi;
      return [ String( no ),
               not ForAll( info,
                           x -> IsString( x.identifier[2] )
                                or ForAll( x.identifier[2], IsString ) ) ];
    end ],

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsPermGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsPermGroup, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( NrMovedPoints,
                  x -> ( IsFunction( x ) and x( info.p ) = true )
                       or info.p = x, cond )
          and AGR.CheckOneCondition( IsTransitive,
                  x -> ( not IsBound( info.transitivity ) and x = fail ) or
                       ( IsBound( info.transitivity ) and
                         ( ( IsFunction( x ) and x( info.transitivity > 0 ) = true )
                           or ( info.transitivity > 0 ) = x ) ), cond )
          and AGR.CheckOneCondition( Transitivity,
                  x -> ( not IsBound( info.transitivity ) and x = fail ) or
                       ( IsBound( info.transitivity ) and
                         ( ( IsFunction( x ) and x( info.transitivity ) = true )
                           or info.transitivity = x ) ), cond )
          and AGR.CheckOneCondition( IsPrimitive,
                  x -> ( not IsBound( info.isPrimitive ) and x = fail ) or
                       ( IsBound( info.isPrimitive ) and
                         ( ( IsFunction( x ) and x( info.isPrimitive ) = true )
                           or info.isPrimitive = x ) ), cond )
          and AGR.CheckOneCondition( RankAction,
                  x -> ( not IsBound( info.rankAction ) and x = fail ) or
                       ( IsBound( info.rankAction ) and
                         ( ( IsFunction( x ) and x( info.rankAction ) = true )
                           or info.rankAction = x ) ), cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    DisplayGroup := function( r )
      local disp, sep;

      if AGR.ShowOnlyASCII() then
        disp:= Concatenation( "G <= Sym(", String( r.p ), r.id, ")" );
      else
        disp:= Concatenation( "G ≤ Sym(", String( r.p ), r.id, ")" );
      fi;
      if IsBound( r.transitivity ) then
        disp:= [ disp ];
        if   r.transitivity = 0 then
          # For intransitive repres., show the orbit lengths.
          Add( disp, Concatenation( "orbit lengths ",
            JoinStringsWithSeparator( List( r.orbits, String ), ", " ) ) );
          sep:= ", ";
        elif r.transitivity = 1 then
          # For transitivity 1, show the rank (if known).
          if IsBound( r.rankAction ) and r.rankAction <> "???" then
            Add( disp, Concatenation( "rank ", String( r.rankAction ) ) );
            sep:= ", ";
          fi;
        elif IsInt( r.transitivity ) then
          # For transitivity at least 2, show the transitivity.
          Add( disp, Concatenation( String( r.transitivity ), "-trans." ) );
          sep:= ", ";
        else
          # The transitivity is not known.
          Add( disp, "" );
          sep:= "";
        fi;
        if 0 < r.transitivity then
          # For transitive representations, more info may be available.
          if IsBound( r.isPrimitive ) and r.isPrimitive then
            if IsBound( r.stabilizer ) and r.stabilizer <> "???" then
              Add( disp, Concatenation( sep, "on cosets of " ) );
              Add( disp, r.stabilizer );
              if IsBound( r.maxnr ) and r.maxnr <> "???" then
                Add( disp, Concatenation( " (",
                                          Ordinal( r.maxnr ), " max.)" ) );
              else
                Add( disp, "" );
              fi;
            elif IsBound( r.maxnr ) and r.maxnr <> "???" then
              Add( disp, Concatenation( sep, "on cosets of ",
                                        Ordinal( r.maxnr ), " max." ) );
            else
              Add( disp, Concatenation( sep, "primitive" ) );
            fi;
          elif IsBound( r.stabilizer ) and r.stabilizer <> "???" then
            Add( disp, Concatenation( sep, "on cosets of " ) );
            Add( disp, r.stabilizer );
          fi;
        fi;
      fi;
      return disp;
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      local name, cand, filename, len, file, line;

      if tocid = "core" then
        tocid:= "datagens";
      fi;

      # Each generator is stored in a file of its own.
      for name in entry[ Length( entry ) ] do

        # Consider only local files, do not download them.
        cand:= AtlasOfGroupRepresentationsLocalFilename(
                   [ [ tocid, name ] ], type );
        if not ( Length( cand ) = 1 and ForAll( cand[1][2], x -> x[2] ) ) then
          return true;
        fi;
        filename:= cand[1][2][1][1];
        len:= Length( filename );
        if 3 < len and filename{ [ len-2 .. len ] } = ".gz" then
          filename:= filename{ [ 1 .. len-3 ] };
        fi;

        # Read the first line of the file.
        file:= InputTextFile( filename );
        if file = fail then
          return Concatenation( "cannot create input stream for file `",
                     filename,"'" );
        fi;
        AGR.InfoRead( "#I  reading `",filename,"' started\n" );
        line:= ReadLine( file );
        if line = fail then
          CloseStream( file );
          return Concatenation( "no first line in file `",filename,"'" );
        fi;
        while not '\n' in line do
          Append( line, ReadLine( file ) );
        od;
        CloseStream( file );
        AGR.InfoRead( "#I  reading `",filename,"' done\n" );

        # The header must consist of four nonnegative integers.
        line:= CMeatAxeFileHeaderInfo( line );
        if line = fail then
          return Concatenation( "illegal header of file `", filename,"'" );
        fi;

        # Start the specific tests for permutations.
        # Check mode, number of permutations, and degree.
        if   line[1] <> 12 then
          return Concatenation( "mode of file `", name,
                     "' differs from 12" );
        elif line[4] <> 1 then
          return Concatenation(
                "more than one permutation in file `", name, "'" );
        elif line[3] <> entry[2] then
          return Concatenation( "perm. degree in file `",
                     name, "' is ", String( line[3] ) );
        fi;

      od;
      return true;
    end,

    TestFiles := AGR.TestFilesMTX,

    # Permutation representations are sorted according to
    # degree and identification string.
    SortTOCEntries := entry -> entry{ [ 2, 3 ] },

    # Check whether the right number of files is available for each repres.
    PostprocessFileInfo := function( toc, record )
      local list, i;
      list:= record.perm;
      for i in [ 1 .. Length( list ) ] do
        if not IsDenseList( list[i][5] ) then
#T better check whether the number of generators equals the number of
#T standard generators
          Info( InfoAtlasRep, 1, "not all generators for ", list[i][5] );
          Unbind( list[i] );
        fi;
      od;
      if not IsDenseList( list ) then
        record.perm:= Compacted( list );
      fi;
    end,

    # We store the type, the full filename, and the list of CRC values.
    TOCEntryString := function( typename, entry )
      local list, pos, name, crc, info;

      list:= AtlasOfGroupRepresentationsInfo.filenames;
      pos:= List( entry[5], nam -> PositionSorted( list, [ nam ] ) );
      if ForAll( pos, x -> x <= Length( list ) ) and
         List( pos, x -> list[x][1] ) = entry[5] then
        name:= list[ pos[1] ][2];
        crc:= List( pos, i -> AGR_Checksum( list[i], typename ) );
        info:= Concatenation( "\"", typename, "\",\"",
            name{ [ 1 .. PositionSublist( name, ".m" ) + 1 ] }, "\"" );
        if not fail in crc then
          Append( info, Concatenation( ",[",
                            JoinStringsWithSeparator( crc, "," ), "]" ) );
        fi;
        return info;
      fi;
      return fail;
    end,

    # The default access reads the text format files.
    # Note that `ScanMeatAxeFile' returns a list of permutations.
    ReadAndInterpretDefault := paths -> Concatenation( List( paths,
                                            ScanMeatAxeFile ) ),

    InterpretDefault := strings -> Concatenation( List( strings,
                                 str -> ScanMeatAxeFile( str, "string" ) ) ),
    ) );


#############################################################################
##
#D  Matrix representations over finite fields
##
##  <#GAPDoc Label="type:matff:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-f</C><M>q</M><C>r</C><M>dim</M><M>id</M><C>B</C><M>m</M><C>.m</C><M>nr</M></Mark>
##  <Item>
##    a file in &MeatAxe; text file format
##    containing the <M>nr</M>-th generator of a matrix representation
##    over the field with <M>q</M> elements, of dimension <M>dim</M>.
##    An example is <C>S5G1-f2r4aB0.m1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "matff",   rec(

    # `<groupname>G<i>-f<q>r<dim><id>B<m>.m<nr>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "f", IsDigitChar, "r", IsDigitChar,
                            AGR.IsLowerAlphaOrDigitChar,
                            "B", IsDigitChar, ".m", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed, info, char, pos;

      repid:= record.identifier[2][1];
      if not IsString( repid ) then
        repid:= repid[2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.dim:= Int( parsed[7] );
      record.id:= parsed[8];
      record.ring:= GF( parsed[5] );
      if IsBound( AtlasOfGroupRepresentationsInfo.characterinfo.(
                      record.groupname ) ) then
        info:= AtlasOfGroupRepresentationsInfo.characterinfo.(
                   record.groupname );
        char:= Characteristic( record.ring );
        if IsBound( info[ char ] ) then
          info:= info[ char ];
          pos:= Position( info[2], repid{ [ 1 .. Position( repid, '.' ) - 1 ] } );
          if pos <> fail then
            record.constituents:= info[1][ pos ];
            if IsInt( record.constituents ) then
              record.constituents:= [ record.constituents ];
            fi;
            if info[3][ pos ] <> fail then
              record.charactername:= info[3][ pos ];
            fi;
          fi;
        fi;
      fi;
    end,

    # `[ <i>, <q>, <dim>, <id>, <m>, <filenames> ]'
    AddFileInfo := function( list, entry, name )
      local known;
      if IsPrimePowerInt( entry[5] ) and 0 < entry[7] then
        known:= First( list, x -> x{ [ 1 .. 5 ] }
                                  = entry{ [ 3, 5, 7, 8, 10 ] } );
        if known = fail then
          known:= entry{ [ 3, 5, 7, 8, 10 ] };
          Add( known, [] );
          Add( list, known );
        fi;
        known[6][ entry[12] ]:= name;
        return true;
      fi;
      return false;
    end,

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsMatrixGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, cond )
          and AGR.CheckOneCondition( IsPermGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( Characteristic,
                  function( p )
                    local char;
                    char:= SmallestRootInt( Size( info.ring ) );
                    return char = p or IsFunction( p ) and p( char ) = true;
                  end,
                  cond )
          and AGR.CheckOneCondition( Dimension,
                  x -> ( IsFunction( x ) and x( info.dim ) )
                       or info.dim = x, cond )
          and AGR.CheckOneCondition( Ring,
                  R -> ( IsFunction( R ) and R( info.ring ) ) or
                       ( IsField( R ) and IsFinite( R )
                         and Size( info.ring ) mod Characteristic( R ) = 0
                         and DegreeOverPrimeField( R )
                            mod LogInt( Size( info.ring ),
                                        Characteristic( R ) ) = 0 ),
                  cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    DisplayGroup := function( r )
      local disp;

      if AGR.ShowOnlyASCII() then
        disp:= Concatenation( "G <= GL(", String( r.dim ), r.id,
                              ",", String( r.identifier[4] ), ")" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "character ", r.charactername ) ];
        fi;
      else
        disp:= Concatenation( "G ≤ GL(", String( r.dim ), r.id,
                              ",", String( r.identifier[4] ), ")" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "φ = ", r.charactername ) ];
        fi;
      fi;
      return disp;
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      local name, cand, filename, len, file, line, errors;

      if tocid = "core" then
        tocid:= "datagens";
      fi;

      # Each generator is stored in a file of its own.
      for name in entry[ Length( entry ) ] do

        # Consider only local files, do not download them.
        cand:= AtlasOfGroupRepresentationsLocalFilename(
                   [ [ tocid, name ] ], type );
        if not ( Length( cand ) = 1 and ForAll( cand[1][2], x -> x[2] ) ) then
          return true;
        fi;
        filename:= cand[1][2][1][1];
        len:= Length( filename );
        if 3 < len and filename{ [ len-2 .. len ] } = ".gz" then
          filename:= filename{ [ 1 .. len-3 ] };
        fi;

        # Read the first line of the file.
        file:= InputTextFile( filename );
        if file = fail then
          return Concatenation( "cannot create input stream for file `",
                     filename,"'" );
        fi;
        AGR.InfoRead( "#I  reading `",filename,"' started\n" );
        line:= ReadLine( file );
        if line = fail then
          CloseStream( file );
          return Concatenation( "no first line in file `",filename,"'" );
        fi;
        while not '\n' in line do
          Append( line, ReadLine( file ) );
        od;
        CloseStream( file );
        AGR.InfoRead( "#I  reading `",filename,"' done\n" );

        # The header must consist of four nonnegative integers.
        line:= CMeatAxeFileHeaderInfo( line );
        if line = fail then
          return Concatenation( "illegal header of file `", filename,"'" );
        fi;

        # Start the specific tests for matrices over finite fields.
        # Check mode, field size, and dimension.
        errors:= "";
        if   6 < line[1] then
          Append( errors, Concatenation( "mode of file `", name,
                            "' is larger than 6" ) );
        elif line[2] <> entry[2] then
          Append( errors, Concatenation( "file `", name,
                            "': field is of size ", String( line[2] ) ) );
        elif line[3] <> entry[3] then
          Append( errors, Concatenation( "file `", name,
                            "': matrix dimension is ", String( line[3] ) ) );
        elif line[3] <> line[4] then
          Append( errors, Concatenation( "file `", name,
                            "': matrix is not square" ) );
        fi;
        if not IsEmpty( errors ) then
          return errors;
        fi;

      od;
      return true;
    end,

    TestFiles := AGR.TestFilesMTX,

    # Matrix representations over finite fields are sorted according to
    # field size, dimension, and identification string.
    SortTOCEntries := entry -> entry{ [ 2 .. 4 ] },

    # Check whether the right number of files is available for each repres.
    PostprocessFileInfo := function( toc, record )
      local list, i;
      list:= record.matff;
      for i in [ 1 .. Length( list ) ] do
        if not IsDenseList( list[i][6] ) then
#T better check whether the number of generators equals the number of
#T standard generators
          Info( InfoAtlasRep, 1, "not all generators for ", list[i][6] );
          Unbind( list[i] );
        fi;
      od;
      if not IsDenseList( list ) then
        record.matff:= Compacted( list );
      fi;
    end,

    # We store the type, the full filename, and the list of CRC values.
    TOCEntryString := function( typename, entry )
      local list, pos, name, crc, info;

      list:= AtlasOfGroupRepresentationsInfo.filenames;
      pos:= List( entry[6], nam -> PositionSorted( list, [ nam ] ) );
      if ForAll( pos, x -> x <= Length( list ) ) and
         List( pos, x -> list[x][1] ) = entry[6] then
        name:= list[ pos[1] ][2];
        crc:= List( pos, i -> AGR_Checksum( list[i], typename ) );
        info:= Concatenation( "\"", typename, "\",\"",
            name{ [ 1 .. PositionSublist( name, ".m" ) + 1 ] }, "\"" );
        if not fail in crc then
          Append( info, Concatenation( ",[",
                            JoinStringsWithSeparator( crc, "," ), "]" ) );
        fi;
        return info;
      fi;
      return fail;
    end,

    # The default access reads the text format files.
    ReadAndInterpretDefault := paths -> List( paths, ScanMeatAxeFile ),

    InterpretDefault := strings -> List( strings,
                                 str -> ScanMeatAxeFile( str, "string" ) ),
    ) );


#############################################################################
##
#D  Matrix representations over the integers
##
##  <#GAPDoc Label="type:matint:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-Zr</C><M>dim</M><M>id</M><C>B</C><M>m</M>.g</Mark>
##  <Item>
##    a &GAP; readable file
##    containing all generators of a matrix representation
##    over the integers, of dimension <M>dim</M>.
##    An example is <C>A5G1-Zr4B0.g</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "matint",  rec(

    # `<groupname>G<i>-Zr<dim><id>B<m>.g'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                        [ "Zr", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
                          "B", IsDigitChar, ".g" ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed, info, pos;

      repid:= record.identifier[2];
      if not IsString( repid ) then
        # one private file
        repid:= repid[1][2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.dim:= Int( parsed[5] );
      record.id:= parsed[6];
      record.ring:= Integers;
      if IsBound( AtlasOfGroupRepresentationsInfo.characterinfo.(
                      record.groupname ) ) then
        info:= AtlasOfGroupRepresentationsInfo.characterinfo.(
                   record.groupname );
        if IsBound( info[1] ) then
          info:= info[1];
          pos:= Position( info[2], repid{ [ 1 .. Position( repid, '.' ) - 1 ] } );
          if pos <> fail then
            record.constituents:= info[1][ pos ];
            if IsInt( record.constituents ) then
              record.constituents:= [ record.constituents ];
            fi;
            if info[3][ pos ] <> fail then
              record.charactername:= info[3][ pos ];
            fi;
          fi;
        fi;
      fi;
    end,

    # `[ <i>, <dim>, <id>, <m>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      if 0 < entry[5] then
        Add( list, Concatenation( entry{ [ 3, 5, 6, 8 ] }, [ name ] ) );
        return true;
      fi;
      return false;
    end,

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsMatrixGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, cond )
          and AGR.CheckOneCondition( IsPermGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( Characteristic,
                  p -> p = 0 or ( IsFunction( p ) and p( 0 ) = true ),
                  cond )
          and AGR.CheckOneCondition( Dimension,
                  x -> ( IsFunction( x ) and x( info.dim ) )
                       or info.dim = x, cond )
          and AGR.CheckOneCondition( Ring,
                  R -> ( IsFunction( R ) and R( Integers ) ) or
                       ( IsRing( R ) and IsCyclotomicCollection( R ) ), cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      return AGR.TestFileHeadersDefault( tocid, groupname, entry, type,
               entry[2],
               function( entry, mats, filename )
                 if not ForAll( mats, mat -> ForAll( mat,
                                 row -> ForAll( row, IsInt ) ) ) then
                   return Concatenation( "matrices in `", filename,
                              "' are not over the integers" );
                 fi;
                 return true;
               end );
    end,

    DisplayGroup := function( r )
      local disp;

      if AGR.ShowOnlyASCII() then
        disp:= Concatenation( "G <= GL(", String( r.dim ), r.id, ",Z)" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "character ", r.charactername ) ];
        fi;
      else
        disp:= Concatenation( "G ≤ GL(", String( r.dim ), r.id, ",ℤ)" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "χ = ", r.charactername ) ];
        fi;
      fi;
      return disp;
    end,

    # Matrix representations over the integers are sorted according to
    # dimension and identification string.
    SortTOCEntries := entry -> entry{ [ 2, 3 ] },

    # There is only one file.
    ReadAndInterpretDefault := function( paths )
      if EndsWith( paths[1], ".json" ) then
        return AtlasDataJsonFormatFile( paths[1] ).generators;
      else
        return AtlasDataGAPFormatFile( paths[1] ).generators;
      fi;
    end,

    InterpretDefault := function( strings )
      if strings[1][1] = '{' then
        return AtlasDataJsonFormatFile( strings[1], "string" ).generators;
      else
        return AtlasDataGAPFormatFile( strings[1], "string" ).generators;
      fi;
    end,
    ) );


#############################################################################
##
#D  Matrix representations over algebraic number fields
##
##  <#GAPDoc Label="type:matalg:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-Ar</C><M>dim</M><M>id</M><C>B</C><M>m</M><C>.g</C></Mark>
##  <Item>
##    a &GAP; readable file
##    containing all generators of a matrix representation of dimension
##    <M>dim</M> over an algebraic number field not specified further.
##    An example is <C>A5G1-Ar3aB0.g</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "matalg",  rec(

    # `<groupname>G<i>-Ar<dim><id>B<m>.g'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                        [ "Ar", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
                          "B", IsDigitChar, ".g" ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed, info, F, gens, pos;

      repid:= record.identifier[2];
      if not IsString( repid ) then
        # one private file
        repid:= repid[1][2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.dim:= Int( parsed[5] );
      record.id:= parsed[6];
      info:= repid{ [ 1 .. Position( repid, '.' )-1 ] };
      info:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                    x -> x[1] = info );
      if info <> fail then
        F:= info[3];
        record.ring:= F;
        if IsField( F ) then
          gens:= GeneratorsOfField( F );
          if Length( gens ) = 1 then
            # is true for all currently available representations
            record.polynomial:= CoefficientsOfUnivariatePolynomial(
                                    MinimalPolynomial( Rationals, gens[1] ) );
          fi;
        fi;
      fi;
      if IsBound( AtlasOfGroupRepresentationsInfo.characterinfo.(
                      record.groupname ) ) then
        info:= AtlasOfGroupRepresentationsInfo.characterinfo.(
                   record.groupname );
        if IsBound( info[1] ) then
          info:= info[1];
          pos:= Position( info[2], repid{ [ 1 .. Position( repid, '.' ) - 1 ] } );
          if pos <> fail then
            record.constituents:= info[1][ pos ];
            if IsInt( record.constituents ) then
              record.constituents:= [ record.constituents ];
            fi;
            if info[3][ pos ] <> fail then
              record.charactername:= info[3][ pos ];
            fi;
          fi;
        fi;
      fi;
    end,

    # `[ <i>, <dim>, <id>, <m>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      if 0 < entry[5] then
        Add( list, Concatenation( entry{ [ 3, 5, 6, 8 ] }, [ name ] ) );
        return true;
      fi;
      return false;
    end,

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsMatrixGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, cond )
          and AGR.CheckOneCondition( IsPermGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( Characteristic,
                  p -> p = 0 or ( IsFunction( p ) and p( 0 ) = true ),
                  cond )
          and AGR.CheckOneCondition( Dimension,
                  x -> ( IsFunction( x ) and x( info.dim ) = true )
                       or info.dim = x, cond )
          and AGR.CheckOneCondition( Ring,
                  x -> IsIdenticalObj( x, Cyclotomics ) or
                       ( not IsBound( info.ring ) and x = fail ) or
                       # case of a field consisting of cyclotomics
                       ( IsBound( info.ring ) and
                         ( ( IsFunction( x ) and x( info.ring ) = true )
                           or ( IsRing( x ) and IsCyclotomicCollection( x )
#T problem with GAP:
#T 'IsSubset( Integers, CF(5) )' runs into an error
                                and ( not IsIdenticalObj( x, Integers ) and
                                      IsSubset( x, info.ring ) ) ) ) ) or
                       # case of a field not consisting of cyclotomics
                       ( IsBound( info.ring ) and
                         IsBound( info.polynomial ) and
                         IsField( x ) and Characteristic( x ) = 0 and
                         1 in List( Factors(
                                      UnivariatePolynomial( x,
                                        info.polynomial * One( x ), 1 ) ),
                                    Degree ) ), cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      return AGR.TestFileHeadersDefault( tocid, groupname, entry, type,
               entry[2],
               function( entry, mats, filename )
                 local info;

                 if not IsCyclotomicCollCollColl( mats ) then
                   return Concatenation( "matrices in `",filename,
                              "' are not over cyclotomics" );
                 elif ForAll( Flat( mats ), IsInt ) then
                   return Concatenation( "matrices in `",filename,
                              "' are over the integers" );
                 fi;
                 filename:= filename{ [ 1 .. Position( filename, '.' )-1 ] };
                 info:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                               l -> l[1] = filename );
                 if info = fail then
                   return Concatenation( "field info for `",filename,
                              "' missing" );
                 elif Field( Rationals, Flat( mats ) ) <> info[3] then
                   return Concatenation( "field info for `",filename,
                              "' should be ",
                              String( Field( Rationals, Flat( mats ) ) ) );
                 fi;
                 return true;
               end );
    end,

    DisplayGroup := function( r )
      local fld, disp;

      fld:= r.identifier[2];
      if not IsString( fld ) then
        fld:= fld[1][2];
      fi;
      fld:= fld{ [ 1 .. Length( fld )-2 ] };
      fld:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                   p -> p[1] = fld );
      if AGR.ShowOnlyASCII() then
        if fld <> fail then
          fld:= fld[2];
        else
          fld:= "C";
        fi;
        disp:= Concatenation( "G <= GL(", String( r.dim ), r.id, ",",
                              fld, ")" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "character ", r.charactername ) ];
        fi;
      else
        if fld <> fail then
          fld:= fld[2];
        else
          fld:= "ℂ";
        fi;
        disp:= Concatenation( "G ≤ GL(", String( r.dim ), r.id, ",",
                              fld, ")" );
        if IsBound( r.charactername ) then
          disp:= [ disp, Concatenation( "χ = ", r.charactername ) ];
        fi;
      fi;
      return disp;
    end,

    # Matrix representations over algebraic extension fields are sorted
    # according to dimension and identification string.
    SortTOCEntries := entry -> entry{ [ 2, 3 ] },

    # There is only one file.
    # It may be a GAP format file or a Json format file.
    ReadAndInterpretDefault := function( paths )
      if EndsWith( paths[1], ".json" ) then
        return AtlasDataJsonFormatFile( paths[1] ).generators;
      else
        return AtlasDataGAPFormatFile( paths[1] ).generators;
      fi;
    end,

    InterpretDefault := function( strings )
      if strings[1][1] = '{' then
        return AtlasDataJsonFormatFile( strings[1], "string" ).generators;
      else
        return AtlasDataGAPFormatFile( strings[1], "string" ).generators;
      fi;
    end,
    ) );


#############################################################################
##
#D  Matrix representations over residue class rings
##
##  <#GAPDoc Label="type:matmodn:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-Z</C><M>n</M><C>r</C><M>dim</M><M>id</M><C>B</C><M>m</M><C>.g</C></Mark>
##  <Item>
##    a &GAP; readable file
##    containing all generators of a matrix representation of dimension
##    <M>dim</M> over the ring of integers mod <M>n</M>.
##    An example is <C>2A8G1-Z4r4aB0.g</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "matmodn", rec(

    # `<groupname>G<i>-Z<n>r<dim><id>B<m>.g'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "Z", IsDigitChar, "r", IsDigitChar,
                            AGR.IsLowerAlphaOrDigitChar,
                            "B", IsDigitChar, ".g" ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed;

      repid:= record.identifier[2];
      if not IsString( repid ) then
        # one private file
        repid:= repid[1][2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.dim:= Int( parsed[7] );
      record.id:= parsed[8];
      record.ring:= ZmodnZ( parsed[5] );
    end,

    # `[ <i>, <n>, <dim>, <id>, <m>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      if 0 < entry[5] and 0 < entry[7] then
        Add( list, Concatenation( entry{ [ 3, 5, 7, 8, 10 ] }, [ name ] ) );
        return true;
      fi;
      return false;
    end,

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsMatrixGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, cond )
          and AGR.CheckOneCondition( IsPermGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( Characteristic,
                  p -> p = fail or ( IsFunction( p ) and p( fail ) = true ),
                  cond )
          and AGR.CheckOneCondition( Dimension,
                  x -> ( IsFunction( x ) and x( info.dim ) )
                       or info.dim = x, cond )
          and AGR.CheckOneCondition( Ring,
                  R -> ( IsFunction( R ) and R( info.ring ) ) or
                       ( IsRing( R )
                  and IsZmodnZObjNonprimeCollection( R )
                  and Characteristic( One( R ) ) = Size( info.ring ) ),
                  cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    DisplayGroup := function( r )
      if AGR.ShowOnlyASCII() then
        return Concatenation( "G <= GL(",String( r.dim ), r.id,
                              ",Z/", String( r.identifier[4] ),"Z)" );
      else
        return Concatenation( "G ≤ GL(",String( r.dim ), r.id,
                              ",ℤ/", String( r.identifier[4] ),"ℤ)" );
      fi;
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      return AGR.TestFileHeadersDefault( tocid, groupname, entry, type,
               entry[3],
               function( entry, mats, filename )
                 if   not IsZmodnZObjNonprimeCollCollColl( mats ) then
                   return Concatenation( "matrices in `", filename,
                              "' are not over a residue class ring" );
                 elif Characteristic( mats[1][1,1] ) <> entry[2] then
                   return Concatenation( "matrices in `", filename,
                              "' are not over Z/", entry[2], "Z" );
                 fi;
                 return true;
               end );
    end,

    # Matrix representations over residue class rings are sorted according
    # to modulus, dimension, and identification string.
    SortTOCEntries := entry -> entry{ [ 2 .. 4 ] },

    # There is only one file.
    ReadAndInterpretDefault := paths -> AtlasDataGAPFormatFile(
                                            paths[1] ).generators,

    InterpretDefault := strings -> AtlasDataGAPFormatFile(
                                       strings[1], "string" ).generators,
    ) );


#############################################################################
##
#D  Quaternionic matrix representations
##
##  <#GAPDoc Label="type:quat:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-Hr</C><M>dim</M><M>id</M><C>B</C><M>m</M><C>.g</C></Mark>
##  <Item>
##    a &GAP; readable file
##    containing all generators of a matrix representation
##    over a quaternion algebra over an algebraic number field,
##    of dimension <M>dim</M>.
##    An example is <C>2A6G1-Hr2aB0.g</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "rep", "quat",  rec(

    # `<groupname>G<i>-Hr<dim><id>B<m>.g'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "Hr", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
                            "B", IsDigitChar, ".g" ] ],
                        [ ParseBackwards, ParseForwards ] ],

    AddDescribingComponents := function( record, type )
      local repid, parsed, info;

      repid:= record.identifier[2];
      if not IsString( repid ) then
        # one private file
        repid:= repid[1][2];
      fi;
      parsed:= AGR.ParseFilenameFormat( repid, type[2].FilenameFormat );
      record.dim:= Int( parsed[5] );
      record.id:= parsed[6];
      info:= repid{ [ 1 .. Position( repid, '.' )-1 ] };
      info:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                    x -> x[1] = info );
      if info <> fail then
        record.ring:= info[3];
      fi;
    end,

    # `[ <i>, <dim>, <id>, <m>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      if 0 < entry[5] then
        Add( list, Concatenation( entry{ [ 3, 5, 6, 8 ] }, [ name ] ) );
        return true;
      fi;
      return false;
    end,

    AccessGroupCondition := function( info, cond )
      return  AGR.CheckOneCondition( IsMatrixGroup, x -> x = true, cond )
          and AGR.CheckOneCondition( IsMatrixGroup, cond )
          and AGR.CheckOneCondition( IsPermGroup, x -> x = false, cond )
          and AGR.CheckOneCondition( Characteristic,
                  p -> p = 0 or ( IsFunction( p ) and p( 0 ) = true ),
                  cond )
          and AGR.CheckOneCondition( Dimension,
                  x -> ( IsFunction( x ) and x( info.dim ) = true )
                       or info.dim = x, cond )
          and AGR.CheckOneCondition( Ring,
                  x -> ( not IsBound( info.ring ) and x = fail ) or
                       ( IsBound( info.ring ) and
                         ( ( IsFunction( x ) and x( info.ring ) = true )
                           or ( IsRing( x ) and IsQuaternionCollection( x )
                                and IsSubset( x, info.ring ) ) ) ), cond )
          and AGR.CheckOneCondition( Identifier,
                  x -> ( IsFunction( x ) and x( info.id ) = true )
                       or info.id = x, cond )
          and IsEmpty( cond );
    end,

    TestFileHeaders := function( tocid, groupname, entry, type )
      return AGR.TestFileHeadersDefault( tocid, groupname, entry, type,
               entry[2],
               function( entry, mats, filename )
                 local info;

                 if not ForAll( mats, IsQuaternionCollColl ) then
                   return Concatenation( "matrices in `",filename,
                              "' are not over the quaternions" );
                 fi;
                 filename:= filename{ [ 1 .. Position( filename, '.' )-1 ] };
                 info:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                               l -> l[1] = filename );
                 if info = fail then
                   return Concatenation( "field info for `",filename,
                              "' missing" );
                 elif Field( Flat( List( Flat( mats ), ExtRepOfObj ) ) )
                      <> EvalString( Concatenation( "Field",
                             info[2]{ [ Position( info[2], '(' ) ..
                                      Length( info[2] ) ] } ) ) then
                   return Concatenation( "field info for `", filename,
                              "' should involve ",
                              Field( Flat( List( Flat( mats ),
                                                 ExtRepOfObj ) ) ) );
                 fi;
                 return true;
               end );
    end,

    DisplayGroup := function( r )
      local fld;

      fld:= r.identifier[2];
      if not IsString( fld ) then
        fld:= fld[1][2];
      fi;
      fld:= fld{ [ 1 .. Length( fld )-2 ] };
      fld:= First( AtlasOfGroupRepresentationsInfo.ringinfo,
                   p -> p[1] = fld );
      if AGR.ShowOnlyASCII() then
        if fld = fail then
          fld:= "QuaternionAlgebra(C)";
        else
          fld:= fld[2];
        fi;
        return Concatenation( "G <= GL(", String( r.dim ), r.id, ",", fld,
                              ")" );
      else
        if fld = fail then
          fld:= "QuaternionAlgebra(ℂ)";
        else
          fld:= fld[2];
        fi;
        return Concatenation( "G ≤ GL(", String( r.dim ), r.id, ",", fld,
                              ")" );
      fi;
    end,

    # Matrix representations over the quaternions are sorted according to
    # dimension and identification string.
    SortTOCEntries := entry -> entry{ [ 2, 3 ] },

    # There is only one file.
    ReadAndInterpretDefault := paths -> AtlasDataGAPFormatFile(
                                            paths[1] ).generators,

    InterpretDefault := strings -> AtlasDataGAPFormatFile(
                                       strings[1], "string" ).generators,
    ) );


#############################################################################
##
#D  Straight line programs for generators of maximal subgroups
##
##  <#GAPDoc Label="type:maxes:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-max</C><M>k</M><C>W</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th set
##    of standard generators,
##    and returns a list of generators
##    (in general <E>not</E> standard generators)
##    for a subgroup <M>U</M> in the <M>k</M>-th class of maximal subgroups
##    of <M>G</M>.
##    An example is <C>J1G1-max7W1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "maxes", rec(

    # `<groupname>G<i>-max<k>W<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "max", IsDigitChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    # `[ <i>, <k>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      if 0 < entry[5] then
        Add( list, Concatenation( entry{ [ 3, 5 ] }, [ name ] ) );
        return true;
      fi;
      return false;
    end,

    DisplayOverviewInfo := [ "maxes", "r", function( conditions )
      local groupname, tocs, std, info, factgroupinfo, maxext, value,
            private, toc, record, new, finfo, factgroupname;

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

      info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                    x -> x[2] = groupname );
      if info = fail or not IsBound( info[3].maxext )
                     or not IsBound( info[3].factorCompatibility ) then
        factgroupinfo:= [];
        maxext:= [];
      else
        factgroupinfo:= Filtered( info[3].factorCompatibility,
                                  x -> ( std = true or x[1] in std )
                                       and x[4] = true );
        maxext:= Filtered( info[3].maxext,
                            x -> std = true or x[1] in std );
      fi;

      value:= [];
      private:= false;
      for toc in tocs do
        # If a straight line program for the restriction is available
        # then take it.
        if IsBound( toc.( groupname ) ) then
          record:= toc.( groupname );
          if IsBound( record.maxes ) then
            new:= List( Filtered( record.maxes,
                                  x -> std = true or x[1] in std ),
                        x -> x[2] );
            if toc.TocID <> "core" and not IsEmpty( new ) then
              private:= true;
            fi;
            UniteSet( value, new );
          fi;
        fi;

        # If a straight line program is available for the restriction
        # to the maximal subgroup of a factor group,
        # and if this program can be used also here
        # then take it.
        for finfo in factgroupinfo do
          factgroupname:= finfo[2];
          info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                        x -> x[1] = factgroupname );
          factgroupname:= info[2];
          if IsBound( toc.( factgroupname ) ) then
            record:= toc.( factgroupname );
            if IsBound( record.maxes ) then
              new:= List( Filtered( maxext,
                                    l -> ForAny( record.maxes,
                                                 fl -> fl[3] = l[3][1] ) ),
                          x -> x[2] );
              if toc.TocID <> "core" and not IsEmpty( new ) then
                private:= true;
              fi;
              UniteSet( value, new );
            fi;
          fi;
        od;
      od;
      if IsEmpty( value ) then
        value:= "";
      else
        value:= String( Length( value ) );
      fi;
      return [ value, private ];
    end ],

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, sortkeys, alltocs, info,
            factgroupinfo, maxext, prvwidth, toc, record, i, private, mxstd,
            pos, finfo, factgroupname, facti, ker, kerid, pi, result, nrmaxes,
            title, entry, line, width, prvphantom, maxnr, j, line2;

      data:= [];
      sortkeys:= [];

      alltocs := AGR.TablesOfContents( "all" );
      info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                    x -> x[2] = names[2] );
      if info = fail or not IsBound( info[3].maxext )
                     or not IsBound( info[3].factorCompatibility ) then
        factgroupinfo:= [];
        maxext:= [];
      else
        factgroupinfo:= Filtered( info[3].factorCompatibility,
                                  x -> ( std = true or x[1] in std )
                                       and x[4] = true );
        maxext:= Filtered( info[3].maxext,
                            x -> std = true or x[1] in std );
      fi;

      prvwidth:= 0;
      for toc in tocs do
        # If a straight line program for the restriction is available
        # then take it.
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.maxes ) then
            for i in record.maxes do
              if std = true or i[1] in std then
                if toc.TocID <> "core" then
                  private:= UserPreference( "AtlasRep",
                                "AtlasRepMarkNonCoreData" );
                  prvwidth:= Length( private );
                else
                  private := "";
                fi;

                entry:= [ ,
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[3] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;

                # If *standard* generators of the max. subgroup are available
                # (perhaps in another table of contents) then mention this,
                # in a line of its own;
                # note that Browse will allow one to click on the line.
                mxstd:= AGR.StandardizeMaximalSubgroup( names[2], i[3], true,
                                                        true );
                Add( data, entry );
                Add( sortkeys, [ i[2], i[1], Int( entry[4] ) ] );
                if mxstd <> fail then
                  entry:= ShallowCopy( entry );
                  entry[5]:= ShallowCopy( entry[5] );
                  if IsString( entry[5][2] ) then
                    entry[5][2]:= [ entry[5][2], mxstd[1] ];
                  else
                    Add( entry[5][2], mxstd[1] );
                  fi;
                  entry[6]:= Concatenation( "std. ", String( mxstd[2] ) );
                  Add( data, entry );
                  Add( sortkeys, [ i[2], i[1], Int( entry[4] ), mxstd[2] ] );
                fi;
              fi;
            od;
          fi;
        fi;

        # If a straight line program is available for the restriction
        # to the maximal subgroup of a factor group,
        # and if this program can be used also here
        # then take it.
        for finfo in factgroupinfo do
          factgroupname:= finfo[2];
          info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                        x -> x[1] = factgroupname );
          factgroupname:= info[2];
          if IsBound( toc.( factgroupname ) ) then
            record:= toc.( factgroupname );
            if IsBound( record.maxes ) then
              for i in maxext do
                facti:= First( record.maxes, fl -> fl[3] = i[3][1] );
                if facti <> fail and ( std = true or i[1] in std ) then
                  if toc.TocID <> "core" then
                    private:= UserPreference( "AtlasRep",
                                  "AtlasRepMarkNonCoreData" );
                    prvwidth:= Length( private );
                  else
                    private := "";
                  fi;

                  entry:= [ ,
                            private,
                            String( i[1] ),
                            AGR.VersionOfSLP( facti[3] ),
                            [ names[1], i[3], i[1] ] ];
                  if Length( i[3] ) = 1 then
                    entry[5][2]:= i[3][1];
                    # No additional kernel generators are needed.
                    if toc.TocID <> "core" then
                      entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                    fi;
                  else
                    # We have to specify a program for computing the kernel.
                    ker:= AtlasProgramInfo( names[1], std, "kernel", finfo[2] );
                    if ker <> fail then
                      kerid:= ker.identifier[2];
                      if IsString( kerid ) then
                        entry[5][2]:= [ entry[5][2][1], kerid ];
                      else
                        entry[5][2]:= [ entry[5][2][1], kerid[1] ];
                      fi;
                      if toc.TocID <> "core" then
                        entry[5][2][1]:= [ toc.TocID, entry[5][2][1] ];
                      fi;
                    fi;
                  fi;
                  Add( data, entry );
                  Add( sortkeys, [ i[2], i[1], Int( entry[4] ) ] );
                fi;
              od;
            fi;
          fi;
        od;
      od;

      title:= "maxes";
      if not IsEmpty( data ) then
        entry:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       x -> x[2] = names[2] );
        if IsBound( entry[3].nrMaxes ) then
          title:= "maxes (";
          nrmaxes:= Length( Set( List( sortkeys, x -> x[1] ) ) );
          if nrmaxes = entry[3].nrMaxes then
            Append( title, "all " );
          else
            Append( title, String( nrmaxes ) );
            Append( title, " out of " );
          fi;
          Append( title, String( entry[3].nrMaxes ) );
          Append( title, ")" );
        fi;

        SortParallel( sortkeys, data );

        width:= Length( String( sortkeys[ Length( sortkeys ) ][1] ) );
        prvphantom:= RepeatedString( " ", prvwidth );

        for i in [ 1 .. Length( data ) ] do
          # Compute the value for the first column (including privacy flag).
          maxnr:= sortkeys[i][1];
          line:= String( maxnr, width );
          Append( line, data[i][2] );
          if IsBound( entry[3].structureMaxes ) and
             IsBound( entry[3].structureMaxes[ maxnr ] ) then
            Append( line, ":  " );
            if data[i][2] = "" then
              Append( line, prvphantom );
            fi;
            Append( line, entry[3].structureMaxes[ maxnr ] );
          fi;
          data[i][1]:= line;
          data[i][2]:= "";
        od;
      fi;

      return AGR.CommonDisplayPRG( title, stdavail, data, false );
    end,

    # Create the program info from the identifier.
    AtlasProgramInfo := function( type, identifier, groupname )
      local filename, i, result, gapname;

      # We need only the information about the restriction part,
      # not a standardization or kernel generators.
      filename:= identifier[2];
      if not IsString( filename ) then
        if IsString( filename[1] ) then
          filename:= filename[1];
        else
          filename:= filename[1][2];
        fi;
      fi;

      i:= AGR.ParseFilenameFormat( filename, type[2].FilenameFormat );
      if i = fail then
        return fail;
      fi;
      i:= i[5];

      result:= rec( standardization := identifier[3],
                    identifier      := identifier );

      # Set the size if available.
      gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> pair[2] = groupname );
      if IsBound( gapname[3].sizesMaxes )
         and IsBound( gapname[3].sizesMaxes[i] ) then
        result.size:= gapname[3].sizesMaxes[i];
      fi;
      if IsBound( gapname[3].structureMaxes ) and
         IsBound( gapname[3].structureMaxes[i] ) then
        result.subgroupname:= gapname[3].structureMaxes[i];
      fi;

      return result;
    end,

    # Create the program from the identifier.
    AtlasProgram := function( type, identifier, groupname )
      local i, std, result, entry, prog, names, pos, maxstd, info, datadirs,
            name, kerprg, gapname;

      i:= identifier[2];
      if not IsString( i ) then
        i:= i[1];
        if not IsString( i ) then
          i:= i[2];
        fi;
      fi;
      i:= AGR.ParseFilenameFormat( i, type[2].FilenameFormat );
      if i = fail then
        return fail;
      fi;
      i:= i[5];
      std:= identifier[3];

      # The second entry is one of
      # - the filename of the program,
      # - this filename plus a filename for standardization
      #   (so we need the *composition* of two programs).
      # - this filename plus a filename for kernel generators
      #   (so we need the *union* of two sets of generators),
      if IsString( identifier[2] ) or Length( identifier[2] ) = 1 then
        # There is just one program.
        result:= AtlasProgramDefault( type, identifier, groupname );
      elif Length( identifier[2] ) = 2 then
        # The second entry describes two files.
        entry:= identifier[2][1];
        if IsString( entry ) then
          prog:= AGR.FileContents( [ [ "dataword", entry ] ], type );
          names:= [ entry ];
        else
          prog:= AGR.FileContents( [ entry ], type );
          names:= [ entry[2] ];
        fi;
        if prog = fail then
          return fail;
        fi;

        entry:= identifier[2][2];
        if IsString( entry ) then
          Add( names, entry );
        else
          Add( names, entry[2] );
          entry:= [ entry ];
        fi;

        # Decide in which situation we are.
        pos:= Position( names[2], '-' );
        if pos <> fail and names[2]{ [ 1 .. pos - 1 ] }
                           = ReplacedString( names[1], "-", "" ) then
          # One program for the restriction, one for the standardization.
          type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "maxstd" );
          maxstd:= AtlasProgramDefault( type, [ groupname, entry, std ],
                       groupname );
          if maxstd = fail then
            return fail;
          fi;
          prog:= CompositionOfStraightLinePrograms( maxstd.program,
                                                    prog.program );
        else
          # One program for a factor group and some kernel generators
          # must be integrated.
          type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "kernel" );
          kerprg:= AtlasProgramDefault( type, [ groupname, entry, std ],
                       groupname );
          if kerprg = fail then
            return fail;
          fi;
          prog:= [ prog.program, kerprg.program ];
          prog:= IntegratedStraightLineProgram( prog );
        fi;
        result:= rec( program         := prog,
                      standardization := std,
                      identifier      := identifier );
      else
        return fail;
      fi;

      # Set subgroup size and subgroup name if available.
      gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> pair[2] = groupname );
      if IsBound( gapname[3].sizesMaxes ) and
         IsBound( gapname[3].sizesMaxes[i] ) then
        result.size:= gapname[3].sizesMaxes[i];
      fi;
      if IsBound( gapname[3].structureMaxes ) and
         IsBound( gapname[3].structureMaxes[i] ) then
        result.subgroupname:= gapname[3].structureMaxes[i];
      fi;

      return result;
    end,

    # entry: `[ <std>, <maxnr>, <file> ]',
    # conditions: `[ "maxes", <maxnr> ]' or `[ "maxes", <maxnr>, <std2> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local std2, version, record, entry, mxstd, info, factgroupinfo, maxext,
            finfo, factgroupname, i, istd, ker;

      std2:= true;
      version:= true;
      if not ( Length( conditions ) in [ 2 .. 5 ] and conditions[1] = "maxes"
               and IsPosInt( conditions[2] ) ) then
        return fail;
      elif Length( conditions ) = 3 then
        std2:= conditions[3];
        if not IsPosInt( std2 ) then
          return fail;
        fi;
      elif Length( conditions ) = 4 then
        if conditions[3] <> "version" then
          return fail;
        fi;
        version:= String( conditions[4] );
      elif Length( conditions ) = 5 then
        std2:= conditions[3];
        if not ( IsPosInt( std2 ) and conditions[4] = "version" ) then
          return fail;
        fi;
        version:= String( conditions[5] );
      fi;

      if IsBound( toc.( groupname ) ) then
        record:= toc.( groupname );

        # If a straight line program for the restriction is available
        # then take it.
        if IsBound( record.maxes ) then
          for entry in record.maxes do
            if     ( std = true or entry[1] in std )
               and entry[2] = conditions[2] then
              if version = true or AGR.VersionOfSLP( entry[3] ) = version then
                # Note that the version number refers to the straight line
                # program for computing the restriction, not to the program
                # for standardizing the result of the restriction.
                # (This feature is needed by 'BrowseAtlasInfo'.)
                if std2 = true then
                  # We need not standardize the subgroup generators.
                  entry:= entry{ [ 3, 1 ] };
                  if toc.TocID <> "core" then
                    entry[1]:= [ [ toc.TocID, entry[1] ] ];
                  fi;
                  return entry;
                else
                  # We have to find a slp for computing *standard* generators
                  # of the max. subgp., perhaps in another table of contents.
                  mxstd:= AGR.StandardizeMaximalSubgroup( groupname,
                              entry[3], std2, true );
                  if mxstd <> fail then
                    entry:= [ [ entry[3], mxstd[1] ], entry[1] ];
                    if toc.TocID <> "core" then
                      entry[1][1]:= [ toc.TocID, entry[1][1] ];
                    fi;
                    return entry;
                  fi;
                fi;
              fi;
            fi;
          od;
        fi;
      fi;

      # If a straight line program is available for the restriction
      # to the maximal subgroup of a factor group,
      # and if this program can be used also here
      # then take it.
      # In this case, we cannot return *standard* generators.
      # We do not want to support version numbers,
      # they would depend on two programs.
      if Length( conditions ) <> 2 then
        return fail;
      fi;

      info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                    x -> x[2] = groupname );
      if info = fail or not IsBound( info[3].maxext )
                     or not IsBound( info[3].factorCompatibility ) then
        return fail;
      fi;
      factgroupinfo:= Filtered( info[3].factorCompatibility,
                                x -> ( std = true or x[1] in std )
                                     and x[4] = true );
      maxext:= Filtered( info[3].maxext,
                          x -> ( std = true or x[1] in std )
                               and x[2] = conditions[2] );
      for finfo in factgroupinfo do
        factgroupname:= finfo[2];
        info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                      x -> x[1] = factgroupname );
        factgroupname:= info[2];
        if IsBound( toc.( factgroupname ) ) then
          record:= toc.( factgroupname );
          if IsBound( record.maxes ) then
            for i in maxext do
              if ForAny( record.maxes, fl -> fl[3] = i[3][1] ) then
                entry:= i{ [ 3, 1 ] };
                if Length( entry[1] ) = 1 then
                  # No additional kernel generators are needed.
                  entry[1]:= entry[1][1];
                  if toc.TocID <> "core" then
                    entry[1]:= [ [ toc.TocID, entry[1] ] ];
                  fi;
                  return entry;
                else
                  # We have to specify a program for computing the kernel.
                  if std = true then
                    ker:= AtlasProgramInfo( AGR.GAPNameAtlasName( groupname ),
                                            "kernel", finfo[2] );
                  else
                    for istd in std do
                      ker:= AtlasProgramInfo( AGR.GAPNameAtlasName( groupname ),
                                              istd, "kernel", finfo[2] );
                      if ker <> fail then
                        break;
                      fi;
                    od;
                  fi;
                  if ker <> fail then
                    entry[1]:= ShallowCopy( entry[1] );
                    if IsString( ker.identifier[2] ) then
                      entry[1][2]:= ker.identifier[2];
                    else
                      entry[1][2]:= ker.identifier[2][1];
                    fi;
                    if toc.TocID <> "core" then
                      entry[1][1]:= [ toc.TocID, entry[1][1] ];
                    fi;
                    return entry;
                  fi;
                fi;
              fi;
            od;
          fi;
        fi;
      od;
      return fail;
    end,

    # Maxes are sorted according to their natural position.
    SortTOCEntries := entry -> entry[2],

    # In addition to the tests in `AGR.TestWordsSLPDefault',
    # compute the images in a representation if available,
    # and compare the group order with that stored in the
    # GAP Character Table Library (if available).
    TestWords:= function( tocid, name, file, type, verbose )
        local prog, prg, gens, pos, pos2, maxnr, gapname, storedsize, tbl,
              subname, subtbl, std, grp, size;

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

        # Create a list of trivial generators.
        gens:= ListWithIdenticalEntries(
                   NrInputsOfStraightLineProgram( prg ), () );

        # Run the program.
        gens:= ResultOfStraightLineProgram( prg, gens );

        # Compute the position in the `Maxes' list.
        pos:= PositionSublist( file, "-max" );
        pos2:= pos + 4;
        while file[ pos2 ] <> 'W' do
          pos2:= pos2 + 1;
        od;
        maxnr:= Int( file{ [ pos+4 .. pos2-1 ] } );

        # Fetch a perhaps stored value.
        gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                         pair -> name = pair[2] );
        if gapname = fail then
          Print( "#E  problem: no GAP name for `", name, "'\n" );
          return false;
        fi;
        storedsize:= fail;
        if IsBound( gapname[3].sizesMaxes ) and
           IsBound( gapname[3].sizesMaxes[ maxnr ] ) then
          storedsize:= gapname[3].sizesMaxes[ maxnr ];
        fi;

        # Identify the group in the GAP Character Table Library.
        tbl:= CharacterTable( gapname[1] );
        if tbl = fail and storedsize = fail then
          if verbose then
            Print( "#I  no character table for `", gapname[1],
                   "', no check for `", file, "'\n" );
          fi;
          return true;
        fi;

        # Identify the subgroup in the GAP Character Table Library.
        if tbl <> fail then
          if HasMaxes( tbl ) then
            if Length( Maxes( tbl ) ) < maxnr then
              Print( "#E  program `", file,
                     "' contradicts `Maxes( ", tbl, " )'\n" );
              return false;
            fi;
            subname:= Maxes( tbl )[ maxnr ];
          else
            subname:= Concatenation( Identifier( tbl ), "M", String( maxnr ) );
          fi;
          subtbl:= CharacterTable( subname );
          if IsCharacterTable( subtbl ) then
            if storedsize <> fail and storedsize <> Size( subtbl ) then
              Print( "#E  program `", file,
                     "' contradicts stored subgroup order'\n" );
              return false;
            elif storedsize = fail then
              storedsize:= Size( subtbl );
            fi;
          elif storedsize = fail then
            if verbose then
              Print( "#I  no character table for `", subname,
                     "', no check for `", file, "'\n" );
            fi;
            return true;
          fi;
        fi;
        if storedsize = fail then
          return true;
        fi;

        # Compute the standardization.
        pos2:= pos - 1;
        while file[ pos2 ] <> 'G' do
          pos2:= pos2-1;
        od;
        std:= Int( file{ [ pos2+1 .. pos-1 ] } );

        # Get a representation if available, and map the generators.
        gapname:= gapname[1];
        gens:= OneAtlasGeneratingSetInfo( gapname, std,
                   NrMovedPoints, [ 2 .. AGR.Test.MaxTestDegree ],
                   "contents", [ tocid, "local" ] );
        if gens = fail then
          if verbose then
            Print( "#I  no perm. repres. for `", gapname,
                   "', no check for `", file, "'\n" );
          fi;
        else
          gens:= AtlasGenerators( gens );
          grp:= Group( gens.generators );
          if tbl <> fail then
            if IsBound( gens.size ) and gens.size <> Size( tbl ) then
              Print( "#E  wrong size for group`", gapname, "'\n" );
              return false;
            fi;
            SetSize( grp, Size( tbl ) );
          fi;
          gens:= ResultOfStraightLineProgram( prg, gens.generators );
          size:= Size( SubgroupNC( grp, gens ) );
          if size <> storedsize then
            Print( "#E  program `", file, "' for group of order ", size,
                   " not ", storedsize, "\n" );
            if subtbl <> fail then
              Print( "#E  (contradicts character table of `",
                     Identifier( subtbl ), "')\n" );
            fi;
            return false;
          fi;
        fi;

        # No more tests are available.
        return true;
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for class representatives
##
##  <#GAPDoc Label="type:classes:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-cclsW</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that returns
##    a list of conjugacy class representatives of <M>G</M>.
##    An example is <C>RuG1-cclsW1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "classes", rec(

    # `<groupname>G<i>-cclsW<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "cclsW", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    # `[ <i>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, Concatenation( entry{ [ 3 ] }, [ name ] ) );
      return true;
    end,

    DisplayOverviewInfo := [ "cl", "c", function( conditions )
      local groupname, tocs, std, value, private, toc, record, i, pos, rel;

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
          if IsBound( record.classes ) and
             ( ( std = true and not IsEmpty( record.classes ) ) or
               ForAny( record.classes, l -> l[1] in std ) ) then
            value:= true;
          elif IsBound( record.cyc2ccl ) and IsBound( record.cyclic ) then
            for i in record.cyc2ccl do
              # Check that for scripts of the form
              # `<groupname>G<i>cycW<n>-cclsW<m>',
              # a script of the form `<groupname>G<i>-cycW<n>' is available.
              pos:= PositionSublist( i[2], "cycW" );
              rel:= Concatenation( i[2]{ [ 1 .. pos-1 ] }, "-",
                        i[2]{ [ pos .. Position( i[2], '-' ) - 1 ] } );
              if ( std = true or i[1] in std ) and
                 ForAny( record.cyclic,
                     x -> x[2] = rel and ( std = true or x[1] in std ) ) then
                value:= true;
                break;
              fi;
            od;
          fi;
          if value then
            if toc.TocID <> "core" then
              private:= true;
            fi;
            break;
          fi;
        fi;
      od;
      if value then
        value:= "+";
      else
        value:= "";
      fi;
      return [ value, private ];
    end ],

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, c2c, cyc, toc, record, private, i, filec2c, filecyc, pos,
            rel, match, entry;

      data:= [];

      # The information can be stored either directly or via two scripts
      # in `cyclic' and `cyc2ccl'.
      c2c:= [];
      cyc:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if toc.TocID <> "core" then
            private:= UserPreference( "AtlasRep",
                          "AtlasRepMarkNonCoreData" );
          else
            private:= "";
          fi;
          if IsBound( record.classes ) then
            for i in record.classes do
              if std = true or i[1] in std then
                entry:= [ "",
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[2] ),
                          [ names[1], i[2], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;

          if IsBound( record.cyc2ccl ) then
            for i in record.cyc2ccl do
              if std = true or i[1] in std then
                entry:= [ i, private ];
                if toc.TocID <> "core" then
                  entry[3]:= toc.TocID;
                fi;
                Add( c2c, entry );
              fi;
            od;
          fi;

          if IsBound( record.cyclic ) then
            for i in record.cyclic do
              if std = true or i[1] in std then
                entry:= [ i, private ];
                if toc.TocID <> "core" then
                  entry[3]:= toc.TocID;
                fi;
                Add( cyc, entry );
              fi;
            od;
          fi;
        fi;
      od;

      for i in c2c do

        # Check if for scripts of the form `<groupname>G<i>cycW<n>-cclsW<m>',
        # a script of the form `<groupname>G<i>-cycW<n>' is available.
        filec2c:= i[1][2];
        pos:= PositionSublist( filec2c, "cycW" );
        rel:= Concatenation( filec2c{ [ 1 .. pos-1 ] }, "-",
                  filec2c{ [ pos .. Position( filec2c, '-' ) - 1 ] } );
        match:= First( cyc, x -> x[1][2] = rel );
        if match <> fail then
          private:= "";
          if i[2] <> "" then
            private:= i[2];
          elif match[2] <> "" then
            private:= match[2];
          fi;
          if Length( i ) = 3 then
            filec2c:= [ i[3], filec2c ];
          fi;
          filecyc:= match[1][2];
          if Length( match ) = 3 then
            filecyc:= [ match[3], filecyc ];
          fi;
          entry:= [ "(composed)",
                    private,
                    String( match[1][1] ),
                    JoinStringsWithSeparator( AGR.VersionOfSLP( filec2c ),
                                              ", " ),
                    [ names[1], [ filec2c, filecyc ], match[1][1] ] ];
          Add( data, entry );
        fi;
      od;

      if ForAny( data, x -> x[1] = "(composed)" ) then
        for i in data do
          if i[1] = "" then
            i[1]:= "(direct)";
          fi;
        od;
      fi;

      return AGR.CommonDisplayPRG( "class repres.", stdavail, data, true );
    end,

    # entry: `[ <std>, <file> ]',
    # conditions: `[ "classes" ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry, toc2, record2, pos, rel, entry2, file2;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "classes" then
        version:= true;
      elif Length( conditions ) = 3 and conditions[1] = "classes"
                                    and conditions[2] = "version" then
        version:= String( conditions[3] );
      else
        return fail;
      fi;

      # Check whether there is a program for computing class repres.
      record:= toc.( groupname );
      if IsBound( record.classes ) then
        for entry in record.classes do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[2] ) = version ) then
            entry:= entry{ [ 2, 1 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;

      # Try to compose the program for computing classes
      # from a program for computing repres. of cyclic subgroups
      # (in the given table of contents)
      # and a program for computing class representatives from the outputs of
      # this program (in *any* table of contents).
      for toc2 in AGR.TablesOfContents( "all" ) do
        if IsBound( toc2.( groupname ) ) then
          record2:= toc2.( groupname );

          if IsBound( record.cyclic ) and IsBound( record2.cyc2ccl )
                                      and version = true then
            for entry2 in record2.cyc2ccl do
              if std = true or entry2[1] in std then

                # Check if for `<groupname>G<i>cycW<n>-cclsW<m>' scripts,
                # a script of the form `<groupname>G<i>-cycW<n>' exists.
                file2:= entry2[2];
                pos:= PositionSublist( file2, "cycW" );
                rel:= Concatenation( file2{ [ 1 .. pos-1 ] }, "-",
                        file2{ [ pos .. Position( file2, '-' ) - 1 ] } );
                for entry in record.cyclic do
                  if entry[2] = rel and ( std = true or entry[1] in std ) then
                    if toc.TocID <> "core" then
                      rel:= [ toc.TocID, rel ];
                    fi;
                    if toc.TocID <> "core" then
                      file2:= [ toc2.TocID, file2 ];
                    fi;
                    return [ [ file2, rel ], entry2[1] ];
                  fi;
                od;
              fi;
            od;
          fi;
        fi;
      od;

      return fail;
    end,

    # Create the program info from the identifier.
    AtlasProgramInfo := function( type, identifier, groupname )
      local filename;

      # If only one file is involved then use the default function.
      filename:= identifier[2];
      if IsString( filename ) or Length( filename ) = 1 then
        return AtlasProgramInfoDefault( type, identifier, groupname );
      fi;

      # Two files are involved.
      filename:= identifier[2][1];
      if not IsString( filename ) then
        filename:= filename[2];
      fi;
      type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "cyc2ccl" );
      if AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
             = fail then
        return fail;
      fi;

      filename:= identifier[2][2];
      if not IsString( filename ) then
        filename:= filename[2];
      fi;
      type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "cyclic" );
      if AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
             = fail then
        return fail;
      fi;

      return rec( standardization := identifier[3],
                  identifier      := identifier );
    end,

    # Create the program from the identifier.
    AtlasProgram := function( type, identifier, groupname )
      local type1, entry1, filename, type2, entry2, prog1, prog2, prog,
            result;

      if IsString( identifier[2] ) or Length( identifier[2] ) = 1 then
        # The second entry describes one file.
        return AtlasProgramDefault( type, identifier, groupname );
      elif Length( identifier[2] ) = 2 then
        # The second entry describes two files to be composed.
        type1:= First( AGR.DataTypes( "prg" ), x -> x[1] = "cyclic" );
        entry1:= identifier[2][2];
        if IsString( entry1 ) then
          filename:= entry1;
          entry1:= [ "dataword", entry1 ];
        else
          filename:= entry1[2];
        fi;
        if AGR.ParseFilenameFormat( filename, type1[2].FilenameFormat )
               = fail then
          return fail;
        fi;

        type2:= First( AGR.DataTypes( "prg" ), x -> x[1] = "cyc2ccl" );
        entry2:= identifier[2][1];
        if IsString( entry2 ) then
          filename:= entry2;
          entry2:= [ "dataword", entry2 ];
        else
          filename:= entry2[2];
        fi;
        if AGR.ParseFilenameFormat( filename, type2[2].FilenameFormat )
               = fail then
          return fail;
        fi;

        prog1:= AGR.FileContents( [ entry1 ], type1 );
        if prog1 = fail then
          return fail;
        fi;
        prog2:= AGR.FileContents( [ entry2 ], type2 );
        if prog2 = fail then
          return fail;
        fi;

        prog:= CompositionOfStraightLinePrograms( prog2.program,
                   prog1.program );
        if prog = fail then
          return fail;
        fi;

        result:= rec( program         := prog,
                      standardization := identifier[3],
                      identifier      := identifier );

        if IsBound( prog2.outputs ) then
          # Take the outputs of the last program in the composition.
          result.outputs:= prog2.outputs;
        fi;

        return result;
      fi;

      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, true, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for representatives of cyclic subgroups
##
##  <#GAPDoc Label="type:cyclic:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-cycW</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that returns
##    a list of representatives of generators
##    of maximally cyclic subgroups of <M>G</M>.
##    An example is <C>Co1G1-cycW1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "cyclic", rec(
    # `<groupname>G<i>-cycW<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "cycW", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    # `[ <i>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, Concatenation( entry{ [ 3 ] }, [ name ] ) );
      return true;
    end,

    DisplayOverviewInfo := AGR.DisplayOverviewInfoDefault( "cyc", "c", "cyclic" ),

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.cyclic ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private := "";
            fi;
            for i in record.cyclic do
              if std = true or i[1] in std then
                entry:= [ "",
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[2] ),
                          [ names[1], i[2], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "repr. cyc. subg.", stdavail, data, true );
    end,

    # entry: `[ <std>, <file> ]',
    # conditions: `[ "cyclic" ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "cyclic" then
        version:= true;
      elif Length( conditions ) = 3 and conditions[1] = "cyclic"
                                    and conditions[2] = "version" then
        version:= String( conditions[3] );
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.cyclic ) then
        for entry in record.cyclic do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[2] ) = version ) then
            entry:= entry{ [ 2, 1 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, true, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for computing class representatives from
#D      representatives of cyclic subgroups
##
##  <#GAPDoc Label="type:cyc2ccls:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>cycW</C><M>n</M><C>-cclsW</C><M>m</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    the return value of the program in the file
##    <M>groupname</M><C>G</C><M>i</M><C>-cycW</C><M>n</M>
##    (see above),
##    and returns a list of conjugacy class representatives of <M>G</M>.
##    An example is <C>M11G1cycW1-cclsW1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "cyc2ccl", rec(

    # `<groupname>G<i>cycW<n>-cclsW<m>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar, "cycW", IsDigitChar ],
                          [ "cclsW", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    # `[ <i>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, Concatenation( entry{ [ 3 ] }, [ name ] ) );
      return true;
    end,

    # entry: `[ <std>, <file> ]',
    # conditions: `[ "cyc2ccl" ]' or
    #             `[ "cyc2ccl", <vers> ]' or
    #             `[ "cyc2ccl", "version", <version> ]' or
    #             `[ "cyc2ccl", <vers>, "version", <version> ]'
    #             where <vers> is the version number of the 'cyc' script
    #             and <version> is the version number of the program itself
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, versions, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "cyc2ccl" then
        version:= true;
      elif Length( conditions ) = 2 and conditions[1] = "cyc2ccl" then
        version:= [ conditions[2], true ];
      elif Length( conditions ) = 3 and conditions[1] = "cyc2ccl"
                                    and conditions[2] = "version" then
        version:= [ true, conditions[3] ];
      elif Length( conditions ) = 4 and conditions[1] = "cyc2ccl"
                                    and conditions[3] = "version" then
        version:= [ conditions[2], conditions[4] ];
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.cyc2ccl ) then
        for entry in record.cyc2ccl do
          if version <> true then
            # Note that 'AGR.VersionOfSLP' returns two strings in this case.
            versions:= AGR.VersionOfSLP( entry[2] );
          fi;
          if ( std = true or entry[1] in std ) and
             ( version = true or
               ( ( version[1] = true or
                   String( version[1] ) = versions[1] ) and
                 ( version[2] = true or
                   String( version[2] ) = versions[2] ) ) ) then
            entry:= entry{ [ 2, 1 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, true, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for computing kernel generators
##
##  <#GAPDoc Label="type:kernel:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-ker</C><M>factgroupname</M><C>W</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th set of
##    standard generators,
##    and returns generators of the kernel of an epimorphism
##    that maps <M>G</M> to a group with <Package>ATLAS</Package>-file name
##    <M>factgroupname</M>.
##    An example is <C>2A5G1-kerA5W1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "kernel", rec(

    # `<groupname>G<i>-ker<factgroupname>W<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [  "ker", IsChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <factgroupname>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, [ entry[3], entry[5], name ] );
      return true;
    end,

    # no DisplayOverviewInfo function
    DisplayPRG := function( tocs, names, std, stdavail )
      local data, gapname, toc, record, private, i, entry;

      data:= [];
      if AGR.ShowOnlyASCII() then
        gapname:= Concatenation( names[1], " -> " );
      else
        gapname:= Concatenation( names[1], " → " );
      fi;

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.kernel ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private := "";
            fi;
            for i in record.kernel do
              if std = true or i[1] in std then
                entry:= [ Concatenation( gapname,
                                         AGR.GAPNameAtlasName( i[2] ) ),
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[3] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "kernels", stdavail, data, false );
    end,

    # entry: `[ <std>, <descr>, <file> ]',
    # conditions: `[ "kernel", <factgroupname> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, info, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 2 and conditions[1] = "kernel" then
        version:= true;
      elif Length( conditions ) = 4 and conditions[1] = "kernel"
                                    and conditions[3] = "version" then
        version:= String( conditions[4] );
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.kernel ) then
        info:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                      x -> x[1] = conditions[2] );
        if info = fail then
          return fail;
        fi;
        info:= info[2];

        for entry in record.kernel do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) and
             info = entry[2] then
            entry:= entry{ [ 3, 1, 2 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, false, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for standardizing generators of maximal subgroups
##
##  <#GAPDoc Label="type:maxstd:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>max</C><M>k</M><C>W</C><M>n</M><C>-</C><M>subgroupname</M><C>G</C><M>j</M><C>W</C><M>m</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    the return value of the program in the file
##    <M>groupname</M><C>G</C><M>i</M><C>-max</C><M>k</M><C>W</C><M>n</M>
##    (see above),
##    which are generators for a group <M>U</M>, say;
##    <M>subgroupname</M> is a name for <M>U</M>,
##    and the return value is a list of standard generators for <M>U</M>,
##    w.&nbsp;r.&nbsp;t.&nbsp;the <M>j</M>-th set of standard generators.
##    (Of course this implies that the groups in the <M>k</M>-th class of
##    maximal subgroups of <M>G</M> are isomorphic to the group with name
##    <M>subgroupname</M>.)
##    An example is <C>J1G1max1W1-L211G1W1</C>;
##    the first class of maximal subgroups of the Janko group <M>J_1</M>
##    consists of groups isomorphic to the linear group <M>L_2(11)</M>,
##    for which standard generators are defined.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "maxstd", rec(
    # `<groupname>G<i>max<k>W<n>-<subgroupname>G<j>W<m>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar, "max", IsDigitChar,
                            "W", IsDigitChar ],
                          [ IsChar, "G", IsDigitChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwards ] ],

    # `[ <i>, <k>, <n>, <subgroupname>, <j>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, Concatenation( entry{ [ 3, 5, 7, 8, 10 ] }, [ name ] ) );
      return true;
    end,

    # no DisplayOverviewInfo function
    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.maxstd ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private := "";
            fi;
            for i in record.maxstd do
              if std = true or i[1] in std then
                entry:= [ Concatenation( "from ", Ordinal( i[2] ),
                                         " max., version ", String( i[3] ),
                                         " to ",
                                         AGR.GAPNameAtlasName( i[4] ),
                                         ", std. ", String( i[5] ) ),
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[6] ),
                          [ names[1], i[6], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "standardizations of maxes",
                                   stdavail, data, false );
    end,

    # Check whether ATLAS names are defined.
    PostprocessFileInfo := function( toc, record )
      local list, i;
      list:= record.maxstd;
      for i in [ 1 .. Length( list ) ] do
        if ForAll( AtlasOfGroupRepresentationsInfo.GAPnames,
                   pair -> pair[2] <> list[i][4] ) then
          Info( InfoAtlasRep, 3,
                "t.o.c. construction: ignoring name `", list[i][6], "'" );
          Unbind( list[i] );
        fi;
      od;
      if not IsDenseList( list ) then
        record.maxstd:= Compacted( list );
      fi;
    end,

    # entry: `[ <std>, <maxnr>, <vers>, <subgroupname>, <substd>, <file> ]',
    # conditions: `[ "maxstd", <maxnr>, <vers>, <substd> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local record, version, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      fi;
      record:= toc.( groupname );

      if Length( conditions ) in [ 4, 6 ] and conditions[1] = "maxstd"
                                          and IsBound( record.maxstd ) then
        version:= true;
        if Length( conditions ) = 6 then
          if conditions[5] <> "version" then
            return fail;
          fi;
          version:= String( conditions[6] );
        fi;
        for entry in record.maxstd do
          if     ( std = true or entry[1] in std )
             and conditions[2] = entry[2]
             and conditions[3] = entry[3]
             and conditions[4] = entry[5]
             and ( version = true or
                   version = Int( AGR.VersionOfSLP( entry[6] ) ) ) then
            entry:= entry{ [ 6, 1, 2, 3, 5 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, false, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for computing images of standard generators
#D      under outer automorphisms
##
##  <#GAPDoc Label="type:out:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-a</C><M>outname</M><C>W</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th set
##    of standard generators,
##    and returns the list of their images
##    under the outer automorphism <M>\alpha</M> of <M>G</M>
##    given by the name <M>outname</M>;
##    if this name is empty then <M>\alpha</M> is the unique nontrivial
##    outer automorphism of <M>G</M>;
##    if it is a positive integer <M>k</M> then <M>\alpha</M> is a
##    generator of the unique cyclic order <M>k</M> subgroup of the outer
##    automorphism group of <M>G</M>;
##    if it is of the form <C>2_1</C> or <C>2a</C>,
##    <C>4_2</C> or <C>4b</C>, <C>3_3</C> or <C>3c</C>
##    <M>\ldots</M> then <M>\alpha</M>
##    generates the cyclic group of automorphisms induced on <M>G</M> by
##    <M>G.2_1</M>, <M>G.4_2</M>, <M>G.3_3</M> <M>\ldots</M>;
##    finally, if it is of the form <M>k</M><C>p</C><M>d</M>,
##    with <M>k</M> one of the above forms and <M>d</M> an integer then
##    <M>d</M> denotes the number of dashes
##    appended to the automorphism described by <M>k</M>;
##    if <M>d = 1</M> then <M>d</M> can be omitted.
##    Examples are <C>A5G1-aW1</C>, <C>L34G1-a2_1W1</C>,
##    <C>U43G1-a2_3pW1</C>, and <C>O8p3G1-a2_2p5W1</C>;
##    these file names describe the outer order <M>2</M> automorphism of
##    <M>A_5</M> (induced by the action of <M>S_5</M>)
##    and the order <M>2</M> automorphisms of
##    <M>L_3(4)</M>, <M>U_4(3)</M>, and <M>O_8^+(3)</M>
##    induced by the actions of
##    <M>L_3(4).2_1</M>, <M>U_4(3).2_2^{\prime}</M>,
##    and <M>O_8^+(3).2_2^{{\prime\prime\prime\prime\prime}}</M>,
##    respectively.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "out", rec(
    # `<groupname>G<i>-a<outname>W<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [  "a", IsChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <nam>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      local std, descr, pos, dashes, order, index;
      std:= entry[3];
      descr:= entry[5];
      pos:= Position( descr, 'p' );
      if pos = fail then
        dashes:= "";
        pos:= Length( descr ) + 1;
      elif pos = Length( descr ) then
        dashes:= "'";
      else
        dashes:= Int( descr{ [ pos+1 .. Length( descr ) ] } );
        if dashes = fail then
          return false;
        fi;
        dashes:= ListWithIdenticalEntries( dashes, '\'' );
      fi;
      descr:= descr{ [ 1 .. pos-1 ] };
      pos:= Position( descr, '_' );
      if pos = fail then
        order:= descr;
        index:= "";
      else
        order:= descr{ [ 1 .. pos-1 ] };
        index:= descr{ [ pos+1 .. Length( descr ) ] };
      fi;
      if Int( order ) = fail or Int( index ) = fail then
        return false;
      elif order = "" then
        order:= "2";
      fi;
      if index <> "" then
        order:= Concatenation( order, "_", index );
      fi;
      order:= Concatenation( order, dashes );
      Add( list, [ std, order, name ] );
      return true;
    end,

    DisplayOverviewInfo := [ "out", "r", function( conditions )
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

      value:= [];;
      private:= false;
      for toc in tocs do
        if IsBound( toc.( groupname ) ) then
          record:= toc.( groupname );
          if IsBound( record.out ) then
            new:= Set( List( Filtered( record.out,
                                       x -> std = true or x[1] in std ),
                             x -> x[2] ) );
            if toc.TocID <> "core" and not IsEmpty( new ) then
              private:= true;
            fi;
            UniteSet( value, new );
          fi;
        fi;
      od;
      value:= JoinStringsWithSeparator( value, "," );
      return [ value, private ];
    end ],

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.out ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private:= "";
            fi;
            for i in record.out do
              if std = true or i[1] in std then
                entry:= [ i[2],
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[3] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "automorphisms", stdavail, data, false );
    end,

    # entry: `[ <std>, <autname>, <file> ]',
    # conditions: `[ "automorphism", <autname> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 2 and conditions[1] = "automorphism" then
        version:= true;
      elif Length( conditions ) = 4 and conditions[1] = "automorphism"
                                    and conditions[3] = "version" then
        version:= String( conditions[4] );
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.out ) then
        for entry in record.out do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) and
             entry[2] = conditions[2] then
            entry:= entry{ [ 3, 1 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    # Create the program info from the identifier.
    AtlasProgramInfo := function( type, identifier, groupname )
    local filename, parsed;

    filename:= identifier[2];
    if not IsString( filename ) then
      filename:= filename[1][2];
    fi;

    if IsString( filename ) then
      parsed:= AGR.ParseFilenameFormat( filename, type[2].FilenameFormat );
      if parsed <> fail then
        return rec( standardization := identifier[3],
                    identifier      := identifier,
                    autname         := parsed[5] );
      fi;
    fi;

    return fail;
    end,

    # It would be good to check whether the order of the automorphism
    # fits to the name of the script, but the scripts do not describe
    # automorphisms of minimal possible order.
    # (So the power given by the name of the script is an inner
    # automorphism; how could we check this with reasonable effort?)
    # Thus we check just whether the name fits to the structure of the
    # outer automorphism group and to the order of the automorphism.
    # (We copy the relevant part of the code of `AGR.TestWordsSLPDefault'
    # into this function.)
    TestWords := function( tocid, name, file, type, verbose )
      local filename, prog, prg, gens, gapname, pos, claimedorder, tbl,
            outinfo, bound, imgs, order;

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

      # Get the GAP name of `name'.
      gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> name = pair[2] );
      if gapname = fail then
        Print( "#E  problem: no GAP name for `", name, "'\n" );
        return false;
      fi;
      gapname:= gapname[1];

      # Get the order of the automorphism from the filename.
      pos:= PositionSublist( file, "-a" );
      claimedorder:= file{ [ pos+2 .. Length( file ) ] };
      pos:= Position( claimedorder, 'W' );
      claimedorder:= claimedorder{ [ 1 .. pos-1 ] };
      pos:= Position( claimedorder, 'p' );
      if pos <> fail then
	if not ForAll( claimedorder{ [ pos+1 .. Length( claimedorder ) ] },
	               IsDigitChar ) then
	  Print( "#E  wrong number of dashes in `", file, "'\n" );
	  return false;
	elif claimedorder{ [ pos+1 .. Length( claimedorder ) ] } = "0" then
          Print( "#E  wrong name `", file, "'\n" );
	  return false;
	fi;
        claimedorder:= claimedorder{ [ 1 .. pos-1 ] };
      fi;
      pos:= Position( claimedorder, '_' );
      if pos <> fail then
        claimedorder:= claimedorder{ [ 1 .. pos-1 ] };
      fi;
      if not ForAll( claimedorder, IsDigitChar ) then
        Print( "#E  wrong name `", file, "'\n" );
	return false;
      fi;
      claimedorder:= Int( claimedorder );

      # Get the structure of the automorphism group.
      # If this group is cyclic then we compare orders.
      tbl:= CharacterTable( gapname );
      if tbl <> fail and IsBound( AGR.HasExtensionInfoCharacterTable )
                     and AGR.HasExtensionInfoCharacterTable( tbl ) then
        outinfo:= AGR.ExtensionInfoCharacterTable( tbl )[2];
        if    outinfo = "" then
          Print( "#E  automorphism `", file,
                 "' for group without outer automorphisms\n" );
          return false;
        elif outinfo <> "2" and claimedorder = 0 then
          Print( "#E  automorphism `", file,
                 "' but the outer automorphism is not unique\n" );
          return false;
        elif Int( outinfo ) <> fail and claimedorder <> 0
             and Int( outinfo ) mod claimedorder <> 0 then
          Print( "#E  automorphism `", file,
                 "' for outer automorphism group ", outinfo, "\n" );
          return false;
        fi;
      fi;

      if claimedorder = 0 then
        claimedorder:= 2;
      fi;

      # Get generators of the group in question.
      gens:= OneAtlasGeneratingSetInfo( gapname,
                 "contents", [ tocid, "local" ] );
      if gens <> fail and tbl <> fail then
        gens:= AtlasGenerators( gens );
        if gens <> fail then
          gens:= gens.generators;
          bound:= Exponent( tbl ) * claimedorder;

          # Compute the order of the automorphism.
          imgs:= ResultOfStraightLineProgram( prg, gens );
          order:= 1;
          while order < bound and imgs <> gens do
            imgs:= ResultOfStraightLineProgram( prg, imgs );
            order:= order + 1;
          od;

          if   imgs <> gens then
            Print( "#E  order ", order, " of automorphism `", file,
                   "' is larger than ", bound, "\n" );
            return false;
          elif order mod claimedorder <> 0 then
            Print( "#E  order ", order, " of automorphism `", file,
                   "' not divisible by ", claimedorder, "\n" );
            return false;
          fi;
        fi;
      fi;

      return true;
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Straight line programs for switching between different standardizations
##
##  <#GAPDoc Label="type:switch:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-G</C><M>j</M><C>W</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th set
##    of standard generators, and returns standard generators of <M>G</M>
##    w.&nbsp;r.&nbsp;t.&nbsp;the <M>j</M>-th set of standard generators.
##    An example is <C>L35G1-G2W1</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "switch", rec(
    # `<groupname>G<i>-G<j>W<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [  "G", IsDigitChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseForwards ] ],

    # `[ <i>, <j>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, [ entry[3], entry[5], name ] );
      return true;
    end,

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.switch ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private:= "";
            fi;
            for i in record.switch do
              if std = true or i[1] in std then
                entry:= [ Concatenation( String( i[1] ), " -> ",
                                         String( i[2] ) ),
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[3] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "restandardizations", stdavail, data, false );
    end,

    # entry: `[ <std>, <descr>, <file> ]',
    # conditions: `[ "restandardize", <std2> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 2 and conditions[1] = "restandardize" then
        version:= true;
      elif Length( conditions ) = 4 and conditions[1] = "restandardize"
                                    and conditions[3] = "version" then
        version:= String( conditions[4] );
      else
        return fail;
      fi;
      record:= toc.( groupname );

      if IsBound( record.switch ) then
        for entry in record.switch do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) and
             conditions[2] = entry[2] then
            entry:= entry{ [ 3, 1, 2 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, false, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
#D  Black box programs for finding standard generators
##
##  <#GAPDoc Label="type:find:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-find</C><M>n</M></Mark>
##  <Item>
##    <Index Subkey="for finding standard generators">black box program
##    </Index>
##    In this case, the file contains a black box program that takes
##    a group, and returns (if it is successful) a set of standard generators
##    for <M>G</M>, w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th standardization.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "find", rec(
    # `<groupname>G<i>-find<j>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "find", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <j>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, [ entry[3], entry[5], name ] );
      return true;
    end,

    DisplayOverviewInfo := AGR.DisplayOverviewInfoDefault( "fnd", "c", "find" ),

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.find ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private:= "";
            fi;
            for i in record.find do
              if std = true or i[1] in std then
                entry:= [ "",
                          private,
                          String( i[1] ),
                          String( i[2] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "std. gen. finder", stdavail, data, true );
    end,

    # entry: `[ <std>, <version>, <file> ]',
    # conditions: `[ "find" ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "find" then
        version:= true;
      elif Length( conditions ) = 3 and conditions[1] = "find"
                                    and conditions[2] = "version" then
        version:= String( conditions[3] );
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.find ) then
        for entry in record.find do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) then
            # the part of the identifier
            entry:= entry{ [ 3, 1, 2 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanBBoxProgram( AGR.StringFile(
                                                             paths[1] ) ),

    InterpretDefault := strings -> ScanBBoxProgram( strings[1] ),

    # If there is a representation for this group (independent of the
    # standardization) then we apply the script, and check whether at least
    # the whole group is generated by the result; if also a `check' script
    # is available for this standardization then we run it on the result.
    TestWords := function( tocid, name, file, type, verbose )
      local prog, prg, gapname, gens, G, res, pos, pos2, std, check;

      # Read the program.
      if tocid = "core" then
        tocid:= "dataword";
      fi;
      prog:= AGR.FileContents( [ [ tocid, file ] ], type );
      if prog = fail then
        Print( "#E  file `", file, "' is corrupted\n" );
        return false;
      fi;
      prg:= prog.program;

      # Get the GAP name of `name'.
      gapname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> name = pair[2] );
      if gapname = fail then
        Print( "#E  problem: no GAP name for `", name, "'\n" );
        return false;
      fi;

      # Get generators of the group in question.
      gens:= OneAtlasGeneratingSetInfo( gapname[1], "contents", "local" );
      if gens <> fail then
        gens:= AtlasGenerators( gens );
        if gens <> fail then
          gens:= gens.generators;
          G:= Group( gens );
          if IsBound( gapname[3].size ) then
            SetSize( G, gapname[3].size );
          fi;
          res:= ResultOfBBoxProgram( prg, G );
          if IsList( res ) and not IsString( res ) then
            # Compute the standardization.
            pos:= Position( file, '-' );
            pos2:= pos - 1;
            while file[ pos2 ] <> 'G' do
              pos2:= pos2-1;
            od;
            std:= Int( file{ [ pos2+1 .. pos-1 ] } );
            check:= AtlasProgram( gapname[1], std, "check" );
            if check <> fail then
              if not ResultOfStraightLineDecision( check.program, res ) then
                Print( "#E  return values of `", file,
                       "' do not fit to the check file\n" );
                return false;
              fi;
            fi;
            # Check the group order only for permutation groups.
            if IsPermGroup( G ) then
              if not IsSubset( G, res ) then
                Print( "#E  return values of `", file,
                       "' do not lie in the group\n" );
                return false;
              elif Size( SubgroupNC( G, res ) ) <> Size( G ) then
                Print( "#E  return values of `", file,
                       "' do not generate the group\n" );
                return false;
              fi;
            fi;
          fi;
        fi;
      fi;

      return true;
    end,

    ) );


#############################################################################
##
#D  Straight line programs for checking standard generators
##
##  <#GAPDoc Label="type:check:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-check</C><M>n</M></Mark>
##  <Item>
##    <Index>semi-presentation</Index>
##    In this case, the file contains a straight line decision that takes
##    generators of <M>G</M>, and returns <K>true</K> if these generators are
##    standard generators w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th
##    standardization, and <K>false</K> otherwise.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "check", rec(
    # `<groupname>G<i>-check<j>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "check", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <j>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, [ entry[3], entry[5], name ] );
      return true;
    end,

    DisplayOverviewInfo := [ "chk", "c", function( conditions )
      local groupname, tocs, std, value, private, toc, record;

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

      value:= "";
      private:= false;
      for toc in tocs do
        if IsBound( toc.( groupname ) ) then
          record:= toc.( groupname );
          if ( IsBound( record.check ) and
               ForAny( record.check, x -> std = true or x[1] in std ) ) or
             ( IsBound( record.pres ) and
               ForAny( record.pres, x -> std = true or x[1] in std ) ) then
            value:= "+";
            if toc.TocID <> "core" then
              private:= true;
            fi;
            break;
          fi;
        fi;
      od;
      return [ value, private ];
    end ],

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, comp, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if toc.TocID <> "core" then
            private:= UserPreference( "AtlasRep",
                          "AtlasRepMarkNonCoreData" );
          else
            private:= "";
          fi;
          for comp in [ "check", "pres" ] do
            if IsBound( record.( comp ) ) then
              for i in record.( comp ) do
                if std = true or i[1] in std then
                  entry:= [ Concatenation( "(", comp, ")" ),
                            private,
                            String( i[1] ),
                            String( i[2] ),
                            [ names[1], i[3], i[1] ] ];
                  if toc.TocID <> "core" then
                    entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                  fi;
                  Add( data, entry );
                fi;
              od;
            fi;
          od;
        fi;
      od;

      return AGR.CommonDisplayPRG( "std. gen. checker", stdavail, data, true );
    end,

    # entry: `[ <std>, <version>, <file> ]',
    # conditions: `[ "check" ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry, comp;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "check" then
        version:= true;
      elif Length( conditions ) = 3 and conditions[1] = "check"
                                    and conditions[2] = "version" then
        version:= String( conditions[3] );
      else
        return fail;
      fi;
      record:= toc.( groupname );

      for comp in [ "check", "pres" ] do
        if IsBound( record.( comp ) ) then
          for entry in record.( comp ) do
            if ( std = true or entry[1] in std ) and
               ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) then
              # the part of the identifier
              entry:= entry{ [ 3, 1, 2 ] };
              if toc.TocID <> "core" then
                entry[1]:= [ [ toc.TocID, entry[1] ] ];
              fi;
              return entry;
            fi;
          od;
        fi;
      od;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
        return AGR.TestWordsSLDDefault( tocid, name, file, type,
                 [ IsChar, "G", IsDigitChar, "-check", IsDigitChar ],
                 verbose ); end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineDecision(
                                            AGR.StringFile( paths[1] ) ),

    InterpretDefault := strings -> ScanStraightLineDecision( strings[1] ),
    ) );


#############################################################################
##
#D  Straight line decisions representing presentations
##
##  <#GAPDoc Label="type:pres:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-P</C><M>n</M></Mark>
##  <Item>
##    <Index>presentation</Index>
##    In this case, the file contains a straight line decision that takes
##    some group elements, and returns <K>true</K> if these elements are
##    standard generators for <M>G</M>,
##    w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th standardization,
##    and <K>false</K> otherwise.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "pres", rec(
    # `<groupname>G<i>-P<j>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "P", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <j>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, [ entry[3], entry[5], name ] );
      return true;
    end,

    DisplayOverviewInfo := AGR.DisplayOverviewInfoDefault( "prs", "c", "pres" ),

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.pres ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private:= "";
            fi;
            for i in record.pres do
              if std = true or i[1] in std then
                entry:= [ "",
                          private,
                          String( i[1] ),
                          String( i[2] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

#T better add rows for pres. obtained by restandardization,
#T in analogy to the maxes scripts plus "std." info
      return AGR.CommonDisplayPRG( "presentation", stdavail, data, true );
    end,

    # entry: `[ <std>, <version>, <file> ]',
    # conditions: `[ "presentation" ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry, tocs, toc2, record2, entry2, switch, pres;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 1 and conditions[1] = "presentation" then
        version:= true;
      elif Length( conditions ) = 3 and conditions[1] = "presentation"
                                    and conditions[2] = "version" then
        version:= String( conditions[3] );
      else
        return fail;
      fi;
      record:= toc.( groupname );

      if IsBound( record.pres ) then
        # Look for a presentation in the required standardization.
        for entry in record.pres do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) then
            # the part of the identifier
            entry:= entry{ [ 3, 1, 2 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
        if std <> true then
          # Look for a presentation in another standardization
          # such that we have a restandardization program
          # (in *any* table of contents).
          tocs:= AGR.TablesOfContents( "all" );
          for entry in record.pres do
            if version = true or AGR.VersionOfSLP( entry[3] ) = version then
              for toc2 in tocs do
                if IsBound( toc2.( groupname ) ) then
                  record2:= toc2.( groupname );
                  if IsBound( record2.switch ) then
                    for entry2 in record2.switch do
                      if entry2[1] in std and entry2[2] = entry[1] then
                        pres:= entry[3];
                        if toc.TocID <> "core" then
                          pres:= [ toc.TocID, pres ];
                        fi;
                        switch:= entry2[3];
                        if toc2.TocID <> "core" then
                          switch:= [ toc2.TocID, switch ];
                        fi;
                        return [ [ pres, switch ], entry2[1], entry[1] ];
                      fi;
                    od;
                  fi;
                fi;
              od;
            fi;
          od;
        fi;
      fi;
      return fail;
    end,

    # Create the program info from the identifier.
    AtlasProgramInfo := function( type, identifier, groupname )
      local filename;

      # If only one file is involved then use the default function.
      filename:= identifier[2];
      if IsString( filename ) or Length( filename ) = 1 then
        return AtlasProgramInfoDefault( type, identifier, groupname );
      fi;

      # Two files are involved.
      filename:= identifier[2][1];
      if not IsString( filename ) then
        filename:= filename[2];
      fi;
      type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "pres" );
      if AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
             = fail then
        return fail;
      fi;

      filename:= identifier[2][2];
      if not IsString( filename ) then
        filename:= filename[2];
      fi;
      type:= First( AGR.DataTypes( "prg" ), x -> x[1] = "switch" );
      if AGR.ParseFilenameFormat( filename, type[2].FilenameFormat )
             = fail then
        return fail;
      fi;

      return rec( standardization := identifier[3],
                  identifier      := identifier );
    end,

    # Create the program from the identifier.
    AtlasProgram := function( type, identifier, groupname )
      local type1, entry1, filename, type2, entry2, prog1, prog2, prog,
            result;

      if IsString( identifier[2] ) or Length( identifier[2] ) = 1 then
        # The second entry describes one file.
        return AtlasProgramDefault( type, identifier, groupname );
      elif Length( identifier[2] ) = 2 then
        # The second entry describes two files to be composed.
        type1:= First( AGR.DataTypes( "prg" ), x -> x[1] = "switch" );
        entry1:= identifier[2][2];
        if IsString( entry1 ) then
          filename:= entry1;
          entry1:= [ "dataword", entry1 ];
        else
          filename:= entry1[2];
        fi;
        if AGR.ParseFilenameFormat( filename, type1[2].FilenameFormat )
               = fail then
          return fail;
        fi;

        type2:= First( AGR.DataTypes( "prg" ), x -> x[1] = "pres" );
        entry2:= identifier[2][1];
        if IsString( entry2 ) then
          filename:= entry2;
          entry2:= [ "dataword", entry2 ];
        else
          filename:= entry2[2];
        fi;
        if AGR.ParseFilenameFormat( filename, type2[2].FilenameFormat )
               = fail then
          return fail;
        fi;

        prog1:= AGR.FileContents( [ entry1 ], type1 );
        if prog1 = fail then
          return fail;
        fi;
        prog2:= AGR.FileContents( [ entry2 ], type2 );
        if prog2 = fail then
          return fail;
        fi;

        prog:= CompositionOfSLDAndSLP( prog2.program, prog1.program );
        if prog <> fail then
          return rec( program         := prog,
                      standardization := identifier[3],
                      identifier      := identifier );
        fi;
      fi;

      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
        return AGR.TestWordsSLDDefault( tocid, name, file, type,
                 [ IsChar, "G", IsDigitChar, "-P", IsDigitChar ],
                 verbose ); end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineDecision(
                                            AGR.StringFile( paths[1] ) ),

    InterpretDefault := strings -> ScanStraightLineDecision( strings[1] ),
    ) );


#############################################################################
##
#D  Other straight line programs
##
##  <#GAPDoc Label="type:otherscripts:format">
##  <Mark><M>groupname</M><C>G</C><M>i</M><C>-X</C><M>descr</M><C>W</C><M>n</M></Mark>
##  <Item>
##    In this case, the file contains a straight line program that takes
##    generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the <M>i</M>-th set
##    of standard generators,
##    and whose return value corresponds to <M>descr</M>.
##    This format is used only in private extensions
##    (see Chapter&nbsp;<Ref Chap="chap:Private Extensions"/>),
##    such a script can be accessed with <M>descr</M> as the third argument
##    of <Ref Func="AtlasProgram"/>.
##  </Item>
##  <#/GAPDoc>
##
AGR.DeclareDataType( "prg", "otherscripts", rec(

    # `<groupname>G<i>-X<descr>W<n>'
    FilenameFormat := [ [ [ IsChar, "G", IsDigitChar ],
                          [ "X", IsChar, "W", IsDigitChar ] ],
                        [ ParseBackwards, ParseBackwardsWithPrefix ] ],

    # `[ <i>, <descr>, <filename> ]'
    AddFileInfo := function( list, entry, name )
      Add( list, Concatenation( entry{ [ 3, 5 ] }, [ name ] ) );
      return true;
    end,

    DisplayPRG := function( tocs, names, std, stdavail )
      local data, toc, record, private, i, entry;

      data:= [];

      for toc in tocs do
        if IsBound( toc.( names[2] ) ) then
          record:= toc.( names[2] );
          if IsBound( record.otherscripts ) then
            if toc.TocID <> "core" then
              private:= UserPreference( "AtlasRep",
                            "AtlasRepMarkNonCoreData" );
            else
              private:= "";
            fi;
            for i in record.otherscripts do
              if std = true or i[1] in std then
                entry:= [ Concatenation( "\"", i[2], "\"" ),
                          private,
                          String( i[1] ),
                          AGR.VersionOfSLP( i[3] ),
                          [ names[1], i[3], i[1] ] ];
                if toc.TocID <> "core" then
                  entry[5][2]:= [ [ toc.TocID, entry[5][2] ] ];
                fi;
                Add( data, entry );
              fi;
            od;
          fi;
        fi;
      od;

      return AGR.CommonDisplayPRG( "other scripts", stdavail, data, false );
    end,

    # entry: `[ <std>, <descr>, <file> ]',
    # conditions: `[ "other", <descr> ]'
    #             or together with `[ "version", <vers> ]'
    AccessPRG := function( toc, groupname, std, conditions )
      local version, record, entry;

      if not IsBound( toc.( groupname ) ) then
        return fail;
      elif Length( conditions ) = 2 and conditions[1] = "other" then
        version:= true;
      elif Length( conditions ) = 4 and conditions[1] = "other"
                                    and conditions[3] = "version" then
        version:= String( conditions[4] );
      else
        return fail;
      fi;

      record:= toc.( groupname );
      if IsBound( record.otherscripts ) then
        for entry in record.otherscripts do
          if ( std = true or entry[1] in std ) and
             ( version = true or AGR.VersionOfSLP( entry[3] ) = version ) and
             entry[2] = conditions[2] then
            entry:= entry{ [ 3, 1 ] };
            if toc.TocID <> "core" then
              entry[1]:= [ [ toc.TocID, entry[1] ] ];
            fi;
            return entry;
          fi;
        od;
      fi;
      return fail;
    end,

    TestWords := function( tocid, name, file, type, verbose )
      return AGR.TestWordsSLPDefault( tocid, name, file, type, false, verbose );
    end,

    # There is only one file.
    ReadAndInterpretDefault := paths -> ScanStraightLineProgram( paths[1] ),

    InterpretDefault := strings -> ScanStraightLineProgram( strings[1],
                                       "string" ),
    ) );


#############################################################################
##
##  Read the known tables of contents,
##  as given by the user preference "AtlasRepTOCData".
##
##  Note that the current file gets notified via
##  'DeclareAutoreadableVariables',
##  because we want to delay the evaluation of the data.
##
##  We cannot read the tables of contents in 'read.g' because this would
##  trigger that 'gap/types.g' and then 'atlasprm.json' etc. are read.
##  This would not work because some functions are not yet available in this
##  situation.
##
##  (A notification of the "internal" extension in test mode is contained
##  in the test file 'tst/atlasrep.tst'.)
##
AGR.EvaluateTOC:= function()
    local entry, pos, id, filename;

    for entry in UserPreference( "AtlasRep", "AtlasRepTOCData" ) do
      pos:= Position( entry, '|' );
      if pos <> fail then
        id:= entry{ [ 1 .. pos-1 ] };
        filename:= entry{ [ pos+1 .. Length( entry ) ] };
        AtlasOfGroupRepresentationsNotifyData( filename, id );
      fi;
    od;
end;

AGR.EvaluateTOC();


#############################################################################
##
##  For backwards compatibility, we set the components of the global record
##  'AtlasOfGroupRepresentationsInfo' that were used up to version 1.5.1
##  of the package, for specifying user preferences.
##  Note that the values of the "real" user preferences
##  are relevant for setting the record components,
##  modifying the record components does *not* affect these user preferences.
##
##  (We cannot move the code to 'obsolete.gi' because then 'types.g' would
##  be read too early.)
##
if UserPreference( "gap", "ReadObsolete" ) <> false then
  AtlasOfGroupRepresentationsInfo.SetComponentsOfUserParameters:= function()
    local url, pos;

    AtlasOfGroupRepresentationsInfo.remote:= UserPreference( "AtlasRep",
        "AtlasRepAccessRemoteFiles" );

    url:= First( AtlasOfGroupRepresentationsInfo.notified,
                 r -> r.ID = "core" ).DataURL;
    if 7 < Length( url ) and
       LowercaseString( url{ [ 1 .. 7 ] } ) = "http://" then
      url:= url{ [ 8 .. Length( url ) ] };
    fi;
    pos:= Position( url, '/' );
    AtlasOfGroupRepresentationsInfo.servers:= [
        [ url{ [ 1 .. pos - 1 ] }, url{ [ pos+1 .. Length( url ) ] } ] ];

    AtlasOfGroupRepresentationsInfo.wget:= false;

    AtlasOfGroupRepresentationsInfo.compress:= UserPreference( "AtlasRep",
        "CompressDownloadedMeatAxeFiles" );

    AtlasOfGroupRepresentationsInfo.displayFunction:= EvalString(
        UserPreference( "AtlasRep", "DisplayFunction" ) );

    AtlasOfGroupRepresentationsInfo.markprivate:= UserPreference( "AtlasRep",
        "AtlasRepMarkNonCoreData" );

    end;

  AtlasOfGroupRepresentationsInfo.SetComponentsOfUserParameters();
fi;


#############################################################################
##
#E

