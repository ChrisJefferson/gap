#############################################################################
##
#W  ctadmin.gi           GAP 4 package CTblLib                  Thomas Breuer
#W                                                               Ute Schiffer
##
##  This file contains the implementation part of the data of the GAP
##  character table library that is not automatically produced from the
##  library files.
##
##  1. Representations of library tables
##  2. Functions used in the library files
##  3. Functions to construct library tables
##  4. Functions used as `construction' component of library tables
##  5. Selection functions for the table library
##  6. Functions to produce tables in library format
##
##  Note that in all construction functions, the table under construction is
##  a plain record, *not* a table object.
##


#############################################################################
##
#M  InfoText( <libtbl> )
##
##  <#GAPDoc Label="InfoText_libtable">
##  <ManSection>
##  <Meth Name="InfoText" Arg="tbl"/>
##
##  <Description>
##  This method for library character tables returns an empty string
##  if no <Ref Attr="InfoText"/> value is stored on the table <A>tbl</A>.
##  <P/>
##  Without this method, it would be impossible to use <Ref Attr="InfoText"/>
##  in calls to <Ref Func="AllCharacterTableNames"/>,
##  as in the following example.
##  <P/>
##  <Example><![CDATA[
##  gap> AllCharacterTableNames( InfoText,
##  >        s -> PositionSublist( s, "tests:" ) <> fail );;
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  We cannot use 'InstallMethod' since there are two declarations for the
##  attribute 'InfoText', and the method matches both of them.
##
##  (Apparently a more general declaration has been added recently.
##  A clean solution would be to change 'DeclareAttributeSuppCT'
##  such that no declaration happens if the operation exists already.)
##
InstallOtherMethod( InfoText,
    "for character tables in the library, the default is an empty string",
    [ "IsCharacterTable and IsLibraryCharacterTableRep" ],
    tbl -> "" );


#############################################################################
##
#F  PParseBackwards( <string>, <format> )
##
BindGlobal( "PParseBackwards", function( string, format )
#T Remove this as soon as `gpisotyp' is available!
    local result, pos, j, pos2;

    # Scan the string backwards.
    result:= [];
    pos:= Length( string );
    for j in Reversed( format ) do
      if IsString( j ) then
        pos2:= pos - Length( j );
        if pos2 < 0 or string{ [ pos2+1 .. pos ] } <> j then
          return fail;
        fi;
      else
        pos2:= pos;
        while 0 < pos2 and j( string[ pos2 ] ) do
          pos2:= pos2-1;
        od;
      fi;
      if j = IsDigitChar then
        Add( result, Int( string{ [ pos2+1 .. pos ] } ) );
      else
        Add( result, string{ [ pos2+1 .. pos ] } );
      fi;
      pos:= pos2;
    od;
    if 0 < pos then
      return fail;
    fi;

    return Reversed( result );
    end );


#############################################################################
##
#F  CTblLib.ReadTbl( [<filename>, ]<id> ) . . . . read character tables files
##
##  This function is used to read data files of the character table library.
##  If the initial part of <filename> is one of `~/', `/' or `./' then we
##  interpret the name as *absolute*, and try to read the file analogous to
##  `Read'; otherwise we interpret the name as *relative* to the `data'
##  directory of the CTblLib package.
##
CTblLib.ReadTbl:= function( arg )
    local name, id, var, readIndent, found;

    if Length( arg ) = 1 then
      id:= arg[1];
      name:= Concatenation( id, ".tbl" );
    else
      name:= arg[1];
      id:= arg[2];
    fi;

    # `LIBTABLE.TABLEFILENAME' is used in `MOT', `ALF', `ALN'.
    LIBTABLE.TABLEFILENAME:= id;
    if not IsBound( LIBTABLE.( id ) ) then
      LIBTABLE.( id ):= rec();
    fi;

    # Make some variables available that are used in data files.
    # Save perhaps available user variables with these names.
    if 2 <= Length( name )
       and ( name[1] = '/' or name{ [ 1, 2 ] } in [ "~/", "./" ] ) then
      # `name' is an absolute filename.
      CTblLib.ALN:= NotifyNameOfCharacterTable;
    else
      # The names in ``official'' table files are already stored.
      CTblLib.ALN:= Ignore;
    fi;
    for var in [ "ACM", "ALF", "ALN", "ARC", "MBT", "MOT" ] do
      if IsBoundGlobal( var ) then
        if IsReadOnlyGlobal( var ) then
          MakeReadWriteGlobal( var );
          CTblLib.( Concatenation( "GlobalR_", var ) ):= ValueGlobal( var );
        else
          CTblLib.( Concatenation( "GlobalW_", var ) ):= ValueGlobal( var );
        fi;
        UnbindGlobal( var );
      fi;
      ASS_GVAR( var, CTblLib.( var ) );
    od;

    if 2 <= Length( name )
       and ( name[1] = '/' or name{ [ 1, 2 ] } in [ "~/", "./" ] ) then
      name:= UserHomeExpand( name );
      if GAPInfo.CommandLineOptions.D then
        readIndent:= SHALLOW_COPY_OBJ( READ_INDENT );
        APPEND_LIST_INTR( READ_INDENT, "  " );
        Print( "#I", READ_INDENT, "Read( \"", name, "\" )\n" );
      fi;
      found:= IsReadableFile( name ) = true and READ( name );
      if GAPInfo.CommandLineOptions.D then
        READ_INDENT:= readIndent;
        if found and READ_INDENT = "" then
          Print( "#I  Read( \"", name, "\" ) done\n" );
        fi;
      fi;
    else
      found:= RereadPackage( "ctbllib", Concatenation( "data/", name ) );
    fi;

    # Unbind the variables again that have been assigned above.
    for var in [ "ACM", "ALF", "ALN", "ARC", "MBT", "MOT" ] do
      UnbindGlobal( var );
      if IsBound( CTblLib.( Concatenation( "GlobalR_", var ) ) ) then
        BindGlobal( var, CTblLib.( Concatenation( "GlobalR_", var ) ) );
        Unbind( CTblLib.( Concatenation( "GlobalR_", var ) ) );
      elif IsBound( CTblLib.( Concatenation( "GlobalW_", var ) ) ) then
        ASS_GVAR( var, CTblLib.( Concatenation( "GlobalW_", var ) ) );
        Unbind( CTblLib.( Concatenation( "GlobalW_", var ) ) );
      fi;
    od;

    return found;
    end;


#############################################################################
##
#V  LIBTABLE
##
InstallFlushableValue( LIBTABLE, rec(
    LOADSTATUS    := rec(),
    TABLEFILENAME := "",
    clmelab       := [],
    clmexsp       := [],
  ) );


#############################################################################
##
#V  LIBLIST
##
##  <#GAPDoc Label="LIBLIST">
##  <ManSection>
##  <Var Name="LIBLIST"/>
##
##  <Description>
##  &GAP;'s knowledge about the ordinary character tables in the
##  &GAP; Character Table Library is given by several JSON format files
##  that get evaluated when the file <F>gap4/ctprimar.g</F>
##  (the <Q>primary file</Q> of the character table library) is read.
##  These files can be produced from the data files,
##  see Section <Ref Subsect="subsec:CTblLib data files"/>.
##  <P/>
##  The information is stored in the global variable <Ref Var="LIBLIST"/>,
##  which is a record with the following components.
##  <P/>
##  <List>
##  <Mark><C>firstnames</C></Mark>
##  <Item>
##    the list of
##    <Ref Func="Identifier" Label="for character tables" BookName="ref"/>
##    values of the ordinary tables,
##  </Item>
##  <Mark><C>files</C></Mark>
##  <Item>
##    the list of filenames containing the data of ordinary tables,
##  </Item>
##  <Mark><C>filenames</C></Mark>
##  <Item>
##    a list of positive integers, value <M>j</M> at position <M>i</M> means
##    that the table whose identifier is the <M>i</M>-th in the
##    <C>firstnames</C> list is contained in the <M>j</M>-th file of the
##    <C>files</C> component,
##  </Item>
##  <Mark><C>fusionsource</C></Mark>
##  <Item>
##    a list containing at position <M>i</M> the list of names of tables that
##    store a fusion into the table whose identifier is the <M>i</M>-th in
##    the <C>firstnames</C> list,
##  </Item>
##  <Mark><C>allnames</C></Mark>
##  <Item>
##    a list of all admissible names of ordinary library tables,
##  </Item>
##  <Mark><C>position</C></Mark>
##  <Item>
##    a list that stores at position <M>i</M> the position in
##    <C>firstnames</C> of the identifier of the table with the <M>i</M>-th
##    admissible name in <C>allnames</C>,
##  </Item>
##  <Mark><C>simpleinfo</C></Mark>
##  <Item>
##    a list of triples <M>[ m, name, a ]</M> describing
##    the tables of simple groups in the library;
##    <M>name</M> is the identifier of the table,
##    <M>m</M><C>.</C><M>name</M> and <M>name</M><C>.</C><M>a</M> are
##    admissible names for its Schur multiplier and automorphism group,
##    respectively, if these tables are available at all,
##  </Item>
##  <Mark><C>sporadicSimple</C></Mark>
##  <Item>
##    a list of identifiers of the tables of the <M>26</M> sporadic simple
##    groups, and
##  </Item>
##  <Mark><C>GENERIC</C></Mark>
##  <Item>
##    a record with information about generic tables
##    (see Section&nbsp;<Ref Sect="sec:generictables"/>).
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "LIBLIST", rec() );

# The information about TomLib tables will be read as soon as
# this package is available.
# We initialize the interface here because rereading 'gap4/ctprimar.g'
# shall not overwrite known values.
LIBLIST.TOM_TBL_INFO_VERSION:= "no information about tables of marks";
LIBLIST.TOM_TBL_INFO:= [ [], [] ];

ReadPackage( "ctbllib", "gap4/ctprimar.g" );


#############################################################################
##
#F  GALOIS( <chars>, <list> )
#F  TENSOR( <chars>, <list> )
#F  EvalChars( <chars> )
##
InstallGlobalFunction( GALOIS, function( chars, li )
    return List( chars[ li[1] ], x -> GaloisCyc( x, li[2] ) );
end );

InstallGlobalFunction( TENSOR, function( chars, list )
    local i, chi, psi, result;
    chi:= chars[ list[1] ];
    psi:= chars[ list[2] ];
    result:= [];
    for i in [ 1 .. Length( chi ) ] do result[i]:= chi[i] * psi[i]; od;
    return result;
end );

InstallGlobalFunction( EvalChars, function( chars )
    local i;
    for i in [ 1 .. Length( chars ) ] do
      if IsFunction( chars[i][1] ) then
        chars[i]:= chars[i][1]( chars, chars[i][2] );
      fi;
    od;
    return chars;
end );


#############################################################################
##
#F  CTblLib.ALF( <from>, <to>, <map>[, <text>, <spec>] )  add library fusions
##
CTblLib.ALF:= function( arg )
    local pos, fus, text;

    if CTblLib.ALN <> Ignore then

      # A file is read that does not belong to the official library.
      # Check that the names are valid.
      if not arg[1] in RecNames( LIBTABLE.( LIBTABLE.TABLEFILENAME ) ) then
        Error( "source `", arg[1], "' is not stored in `LIBTABLE.",
               LIBTABLE.TABLEFILENAME, "'" );
      fi;
      pos:= Position( LIBLIST.firstnames, arg[2] );
#T this is not sorted! (take LIBLIST.allnames instead, and use indirection)
      if pos = fail then
        Info( InfoWarning, 1,
              "destination `", arg[2], "' is not a valid first name" );
      else

        # Check whether there was already such a fusion.
        if not arg[1] in LIBLIST.fusionsource[ pos ] then

          # Store the fusion source.
          LIBLIST.fusionsource:= ShallowCopy( LIBLIST.fusionsource );
          LIBLIST.fusionsource[ pos ]:= MakeImmutable( Concatenation(
              LIBLIST.fusionsource[ pos ], [ arg[1] ] ) );
          MakeImmutable( LIBLIST.fusionsource );

        fi;

      fi;

    fi;

    fus:= rec( name:= arg[2], map:= arg[3] );
    if 4 <= Length( arg ) then
      text:= Concatenation( arg[4] );
      ConvertToStringRep( text );
      fus.text:= text;
    fi;
    if Length( arg ) = 5 then
      text:= arg[5];
      ConvertToStringRep( text );
      fus.specification:= text;
    fi;

    Add( LIBTABLE.( LIBTABLE.TABLEFILENAME ).( arg[1] ).ComputedClassFusions,
         fus );
    end;


#############################################################################
##
#F  CTblLib.ACM( <spec>, <dim>, <val> ) . . . . . . . . . add Clifford matrix
##
CTblLib.ACM:= function( spec, dim, val )
    spec:= LIBTABLE.( Concatenation( "clm", spec ) );
    if not IsBound( spec[ dim ] ) then
      spec[ dim ]:= [];
    fi;
    Add( spec[ dim ], val );
    end;


#############################################################################
##
#F  CTblLib.ARC( <name>, <comp>, <val> ) . . . add component of library table
##
CTblLib.ARC:= function( name, comp, val )
    LIBTABLE.( LIBTABLE.TABLEFILENAME ).( name ).( comp ):= val;
    end;


#############################################################################
##
#F  NotifyGroupInfoForCharacterTable( <id>, <value> )
##
##  This function shall be available also if the Browse package is not
##  available, and then do nothing.
##
BindGlobal( "NotifyGroupInfoForCharacterTable", function( id, value )
    local enum, r, list, pos, i;

    if id in CTblLib.Data.IdEnumerator.identifiers then
      enum:= CTblLib.Data.IdEnumerator;
    elif id in CTblLib.Data.IdEnumeratorExt.identifiers then
      enum:= CTblLib.Data.IdEnumeratorExt;
    else
      return false;
    fi;

    if not IsBound( enum.attributes.indiv ) then
      return false;
    fi;

    r:= enum.attributes.indiv;
    if not IsBound( r.data ) then
      r.data:= rec( automatic:= [], nonautomatic:= [] );
    fi;
    list:= r.data.nonautomatic;
    pos:= PositionSorted( list, [ id ] );
    if IsBound( list[ pos ] ) then
      if list[ pos ][1] = id then
        Add( list[ pos ][2], value );
      else
        for i in [ Length( list ), Length( list ) - 1 .. pos ] do
          list[ i+1 ]:= list[i];
        od;
        list[ pos ]:= [ id, [ value ] ];
      fi;
    else
      Add( list, [ id, [ value ] ] );
    fi;

    return true;
    end );


#############################################################################
##
#F  CTblLib.NotifyNameOfCharacterTable( <firstname>, <newnames>, <pos> )
##
##  This code does not perform any argument check,
##  and does not clean up components in 'LIBLIST'.
##
CTblLib.NotifyNameOfCharacterTable:= function( firstname, newnames, pos,
    allnames, position )
    local lower, pos2, name, j;

    lower:= List( newnames, LowercaseString );
    if ForAny( lower, x -> x in allnames ) then
      Error( "<newnames> must contain only new names" );
    fi;

    Append( allnames, lower );
    Append( position, List( lower, x -> pos ) );
    end;


#############################################################################
##
#F  NotifyNameOfCharacterTable( <firstname>, <newnames> )
##
##  notifies the new names in the list <newnames> for the library table with
##  first name <firstname>, if there is no other table yet for that some of
##  these names are admissible.
##
InstallGlobalFunction( NotifyNameOfCharacterTable,
    function( firstname, newnames )
    local pos, allnames, position;

    if not ( IsString( firstname )
             and IsList( newnames ) and ForAll( newnames, IsString ) ) then
      Error( "<firstname> and entries in list <newnames> must be strings" );
    elif ForAny( [ 1 .. Length( firstname ) - 2 ],
               x -> firstname{ [ x .. x+2 ] } = "mod" ) then
      Error( "Brauer tables must not have explicitly given `othernames'" );
    fi;

    pos:= Position( LIBLIST.firstnames, firstname );
#T this is not sorted! (take LIBLIST.allnames instead, and use indirection)
    if pos = fail then
      Error( "no GAP library table with first name `", firstname, "'" );
    fi;

    # Change `LIBLIST'.
    allnames:= ShallowCopy( LIBLIST.allnames );
    position:= ShallowCopy( LIBLIST.position );

    CTblLib.NotifyNameOfCharacterTable( firstname, newnames, pos,
        allnames, position );
    SortParallel( allnames, position );
    LIBLIST.allnames:= MakeImmutable( allnames );
    LIBLIST.position:= MakeImmutable( position );
end );


#############################################################################
##
#F  NotifyCharacterTables( <list> )
##
InstallGlobalFunction( NotifyCharacterTables,
    function( list )
    local firstnames, filenames, files, fusionsource, allnames, position,
          triple, firstname, filename, othernames, len;

    if not IsList( list ) then
      Error( "<list> must be a list of triples" );
    fi;

    firstnames:= ShallowCopy( LIBLIST.firstnames );
    filenames:= ShallowCopy( LIBLIST.filenames );
    files:= ShallowCopy( LIBLIST.files );
    fusionsource:= ShallowCopy( LIBLIST.fusionsource );
    allnames:= ShallowCopy( LIBLIST.allnames );
    position:= ShallowCopy( LIBLIST.position );

    for triple in list do
      if Length( triple ) <> 3 then
        Error( "<list> must be a list of triples" );
      fi;

      firstname:= triple[1];
      filename:= triple[2];
      othernames:= triple[3];

      if not ( IsString( firstname ) and IsString( filename ) and
               IsList( othernames ) and ForAll( othernames, IsString ) ) then
        Error( "<firstname>, <filename> must be strings, ",
               "<othernames> must be a list of strings" );
      elif LowercaseString( firstname ) in LIBLIST.allnames then
        Error( "<firstname> is already a valid name" );
      fi;

      if not filename in files then
        Add( files, filename );
      fi;
      len:= Length( firstnames ) + 1;
      firstnames[ len ]:= firstname;
      filenames[ len ]:= Position( files, filename );
      fusionsource[ len ]:= [];

      CTblLib.NotifyNameOfCharacterTable( firstname, [ firstname ], len,
          allnames, position );
      CTblLib.NotifyNameOfCharacterTable( firstname, othernames, len,
          allnames, position );

      if IsBound( CTblLib.Data.IdEnumeratorExt.identifiers ) then
        Add( CTblLib.Data.IdEnumeratorExt.identifiers, firstname );

        # This is an ugly hack in order to achieve a better
        # integration of the SpinSym package.
        # It would be better (and cheaper) if the attributes would be set
        # inside the SpinSym package.
        # Also, we *want* those SpinSym tables that are available also in the
        # main library to be regarded as duplicates, although they are
        # formally not declared as duplicates, i. e., as permuted tables
        # of library tables.
        if IsBound( GAPInfo.PackageCurrent ) and
           IsBound( GAPInfo.PackageCurrent.PackageName ) and
           GAPInfo.PackageCurrent.PackageName = "SpinSym" then
          Add( CTblLib.SpinSymNames, firstname );
          if not IsBound( GAPInfo.PackageExtensionsLoaded ) then
            # We are in GAP up to version 4.12.
            # The SpinSym package notifies its tables
            # *after* the CTblLib package has been loaded.
            # Thus we have to set the attributes here.
            CTblLib.SetAttributesForSpinSymTable( firstname );
          fi;
        fi;
      fi;
    od;

    LIBLIST.firstnames:= MakeImmutable( firstnames );
    LIBLIST.filenames:= MakeImmutable( filenames );
    LIBLIST.files:= MakeImmutable( files );
    LIBLIST.fusionsource:= MakeImmutable( fusionsource );
    SortParallel( allnames, position );
    LIBLIST.allnames:= MakeImmutable( allnames );
    LIBLIST.position:= MakeImmutable( position );
end );


#############################################################################
##
#F  NotifyCharacterTable( <firstname>, <filename>, <othernames> )
##
InstallGlobalFunction( NotifyCharacterTable,
    function( firstname, filename, othernames )
    NotifyCharacterTables( [ [ firstname, filename, othernames ] ] );
end );


#############################################################################
##
#F  NotifyBrauerTable( <firstordname>, <p>, <filename> )
#F  NotifyBrauerTables( <list> )
##
BindGlobal( "NotifyBrauerTables", function( list )
    local firstmodnames, filenames, triple, firstordname, p, filename,
          lowername, pos;

    if not IsList( list ) then
      Error( "<list> must be a list of triples" );
    fi;

    firstmodnames:= ShallowCopy( LIBLIST.PrivateBrauerTables[1] );
    filenames:= ShallowCopy( LIBLIST.PrivateBrauerTables[2] );

    for triple in list do
      if Length( triple ) <> 3 then
        Error( "<list> must be a list of triples" );
      fi;

      firstordname:= triple[1];
      p:= triple[2];
      filename:= triple[3];

      if not ( IsString( firstordname ) and IsString( filename ) and
               IsPrimeInt( p ) ) then
        Error( "<firstordname>, <filename> must be strings, ",
               "<p> must be a prime integer" );
      fi;

      lowername:= MakeImmutable(
                      Concatenation( LowercaseString( firstordname ),
                                     "mod", String( p ) ) );
      pos:= Position( firstmodnames, lowername );
      if pos <> fail then
        if filenames[ pos ] <>filename then
          Error( "<firstordname> is already notified with a different file" );
        fi;
      else
        Add( firstmodnames, lowername );
        Add( filenames, Immutable( filename ) );
      fi;
    od;

    LIBLIST.PrivateBrauerTables[1]:= firstmodnames;
    LIBLIST.PrivateBrauerTables[2]:= filenames;
    SortParallel( firstmodnames, filenames );
end );

BindGlobal( "NotifyBrauerTable", function( firstordname, p, filename )
    NotifyBrauerTables( [ [ firstordname, p, filename ] ] );
end );


#############################################################################
##
#F  CTblLib.MBT( <arg> )
##
CTblLib.MBT:= function( arg )
    local i, record;

    record:= rec(
                  InfoText                 := arg[ 3],
                  UnderlyingCharacteristic := arg[ 2],
                  block                    := arg[ 4],
                  defect                   := arg[ 5],
                  basicset                 := arg[ 6],
                  brauertree               := arg[ 7],
                  decinv                   := arg[ 8],
                  factorblocks             := arg[ 9],
                  AutomorphismsOfTable     := arg[10],
                  indicator                := arg[11]
                 );

    for i in RecNames( record ) do
      if record.(i) = 0 then
        Unbind( record.(i) );
      fi;
    od;
    if Length( arg ) = 12 then
      for i in RecNames( arg[12] ) do
        record.(i):= arg[12].(i);
      od;
    fi;
    LIBTABLE.( LIBTABLE.TABLEFILENAME ).(
                 Concatenation( arg[1], "mod", String( arg[2] ) ) ):= record;
    end;


#############################################################################
##
#F  CTblLib.MOT( <arg> )
##
CTblLib.MOT:= function( arg )
    local record, i, len;

    # Construct the record.
    record:= rec(
                  Identifier               := arg[1],
                  InfoText                 := arg[2],
                  UnderlyingCharacteristic := 0,
                  SizesCentralizers        := arg[3],
                  ComputedPowerMaps        := arg[4],
                  ComputedClassFusions     := [],
                  Irr                      := arg[5],
                  AutomorphismsOfTable     := arg[6]
                 );

    for i in [ "InfoText", "SizesCentralizers", "ComputedPowerMaps",
               "ComputedClassFusions", "Irr", "AutomorphismsOfTable" ] do
      if record.(i) = 0 then
        Unbind( record.(i) );
      fi;
    od;
    if IsBound( arg[7] ) and IsList( arg[7] ) then
      record.ConstructionInfoCharacterTable:= arg[7];
    fi;
    len:= Length( arg );
    if IsRecord( arg[ len ] ) then
      for i in RecNames( arg[ len ] ) do
        record.(i):= arg[ len ].(i);
      od;
    fi;

    # Store the table record.
    LIBTABLE.( LIBTABLE.TABLEFILENAME ).( arg[1] ):= record;
    end;


#############################################################################
##
#V  GEN_Q_P
##
#F  PrimeBase( <q> )
##
InstallFlushableValue( GEN_Q_P, [] );

InstallGlobalFunction( PrimeBase, function( q )
    if not IsBound( GEN_Q_P[q] ) then
      GEN_Q_P[q]:= FactorsInt( q )[1];
    fi;
    return GEN_Q_P[q];
end );


#############################################################################
##
#F  LibInfoCharacterTable( <tblname> )
##
InstallGlobalFunction( LibInfoCharacterTable, function( tblname )
    local i, ordinfo, str, pos, filename;

    if IsCharacterTable( tblname ) then
      tblname:= Identifier( tblname );
    fi;

    # Is `tblname' the name of a Brauer table,
    # i.e., does it have the structure `<ordname>mod<prime>' ?
    # If so, return `<firstordname>mod<prime>' where
    # `<firstordname> = LibInfoCharacterTable( <ordname> ).firstName'.

    tblname:= LowercaseString( tblname );
    for i in [ 1 .. Length( tblname ) - 2 ] do
      if tblname{ [ i .. i+2 ] } = "mod" then
        ordinfo:= LibInfoCharacterTable( tblname{ [ 1 .. i-1 ] } );
        if ordinfo <> fail then
          ordinfo.firstName:= Concatenation( ordinfo.firstName,
                                  tblname{ [ i .. Length( tblname ) ] } );
          ConvertToStringRep( ordinfo.firstName );
          str:= ordinfo.fileName;
          pos:= Position( LIBLIST.PrivateBrauerTables[1],
                          LowercaseString( ordinfo.firstName ) );
          if pos <> fail then
            ordinfo.fileName:= LIBLIST.PrivateBrauerTables[2][ pos ];
          elif '/' in str then
            pos:= Maximum( Filtered( [ 1 .. Length( str ) ],
                           i -> str[i] = '/' ) );
            filename:= str{ [ pos+1 .. Length( str ) ] };
            if 3 <= Length( filename ) and filename{ [ 1 .. 3 ] } = "cto" then
              filename[3]:= 'b';
            fi;
            ordinfo.fileName:= Concatenation( str{ [ 1 .. pos ] }, filename );
          else
            ordinfo.fileName:= ShallowCopy( str );
            if 3 <= Length( str ) and str{ [ 1 .. 3 ] } = "cto" then
              ordinfo.fileName[3]:= 'b';
            fi;
          fi;
          ConvertToStringRep( ordinfo.fileName );
        fi;
        return ordinfo;
      fi;
    od;

    # The name might belong to an ordinary table.
    pos:= Position( LIBLIST.allnames, tblname );
    if pos <> fail then
      pos:= LIBLIST.position[ pos ];
      if pos <> fail then
        return rec( firstName := LIBLIST.firstnames[ pos ],
                    fileName  := LIBLIST.files[
                                     LIBLIST.filenames[ pos ] ] );
      fi;
      return fail;
    fi;

    # The name might belong to a generic table.
    if tblname in LIBLIST.GENERIC.allnames then
      return rec( firstName := LIBLIST.GENERIC.firstnames[
                            Position( LIBLIST.GENERIC.allnames,
                                      tblname ) ],
                  fileName  := "ctgeneri" );
    fi;

    return fail;
end );


#############################################################################
##
#F  LibraryTables( <filename> )
##
InstallGlobalFunction( LibraryTables, function( filename )
    local suffix, file, pos;

    # Omit the initial path for the name of the component in `LIBTABLE'.
    suffix:= filename;
    pos:= Position( suffix, '/' );
    while pos <> fail do
      suffix:= suffix{ [ pos+1 .. Length( suffix ) ] };
      pos:= Position( suffix, '/' );
    od;

    if not IsBound( LIBTABLE.LOADSTATUS.( suffix ) )
       or LIBTABLE.LOADSTATUS.( suffix ) = "unloaded" then

      # It is necessary to read a library file.
      # First unload all files which are not `"userloaded"', except that
      # with the ordinary resp. Brauer tables corresponding to those in
      # the file `filename'
      if UserPreference( "CTblLib", "UnloadCTblLibFiles" ) then
        for file in RecNames( LIBTABLE.LOADSTATUS ) do
          if LIBTABLE.LOADSTATUS.( file ) <> "userloaded" and
             suffix{ [ 4 .. Length( suffix ) ] }
              <> file{ [ 4 .. Length( file ) ] } then
            LIBTABLE.( file ):= rec();
            LIBTABLE.LOADSTATUS.( file ):= "unloaded";
          fi;
        od;
      fi;

      LIBTABLE.( suffix ):= rec();

      # Try to read the file.
      if not CTblLib.ReadTbl( Concatenation( filename, ".tbl" ), suffix ) then
        Info( InfoCharacterTable, 1,
              "no file `", filename,
              ".tbl' in the GAP Character Table Library" );
        return fail;
      fi;

      # Reset the load status from `"userloaded"' to `"loaded"'.
      LIBTABLE.LOADSTATUS.( suffix ):= "loaded";

    fi;

    return LIBTABLE.( suffix );
end );


############################################################################
##
#V  CTblLib.SupportedGenericIdentifiers
##
##  Make generic identifiers admissible.
##
CTblLib.SupportedGenericIdentifiers:= [
    [ PParseBackwards, [ "c", IsDigitChar ],
                       "Cyclic", [ 2 ] ],
    [ PParseBackwards, [ "alt(", IsDigitChar, ")" ],
                       "Alternating", [ 2 ] ],
    [ PParseBackwards, [ "sym(", IsDigitChar, ")" ],
                       "Symmetric", [ 2 ] ],
    [ PParseBackwards, [ "dihedral(", IsDigitChar, ")" ],
                       "Dihedral", [ 2 ] ],
    [ PParseBackwards, [ "2.sym(", IsDigitChar, ")" ],
                       "DoubleCoverSymmetric", [ 2 ] ],
    [ PParseBackwards, [ "2.alt(", IsDigitChar, ")" ],
                       "DoubleCoverAlternating", [ 2 ] ],
    ];


#############################################################################
##
#F  CTblLib.TrySpecialization( <tblname> )
##
CTblLib.TrySpecialization:= function( tblname )
    local entry, scan;

    tblname:= LowercaseString( tblname );
    for entry in CTblLib.SupportedGenericIdentifiers do
      scan:= entry[1]( tblname, entry[2] );
      if scan <> fail then
        return CallFuncList( CharacterTableFromLibrary,
                   Concatenation( [ entry[3] ], scan{ entry[4] } ) );
      fi;
    od;
    return fail;
    end;


#############################################################################
##
#F  CharacterTableFromLibrary( <tblname> )
#F  CharacterTableFromLibrary( <series>, <param1>[, <param2>] )
##
InstallGlobalFunction( CharacterTableFromLibrary, function( arg )
    local tblname, firstname, filename, suffix, pos, librarytables, name,
          libtbl, fld, i, fus;

    if IsEmpty( arg ) or not IsString( arg[1] ) then

      Error( "usage: CharacterTableFromLibrary( <tblname> )\n",
             " resp. CharacterTableFromLibrary( <series>, <parameters> )" );

    elif Length( arg ) = 1 then

      # `CharacterTableFromLibrary( tblname )'
      tblname:= arg[1];
      firstname:= LibInfoCharacterTable( tblname );
      if firstname = fail then
        # Perhaps it is the identifier of a generic table.
        libtbl:= CTblLib.TrySpecialization( tblname );
        if libtbl <> fail then
          return libtbl;
        fi;
        Info( InfoCharacterTable, 1,
              "No library table with name `", tblname, "'" );
        return fail;
      fi;
      filename  := firstname.fileName;
      firstname := firstname.firstName;
      suffix:= filename;
      pos:= Position( suffix, '/' );
      while pos <> fail do
        suffix:= suffix{ [ pos+1 .. Length( suffix ) ] };
        pos:= Position( suffix, '/' );
      od;

      if 3 < Length( suffix ) and suffix{ [ 1 .. 3 ] } = "ctb" then

        # Brauer table, call `BrauerTable'
        # (First get the ordinary table.)
        name:= PartsBrauerTableName( firstname );
        return BrauerTable(
                   CharacterTableFromLibrary( name.ordname ),
                   name.prime );

      fi;

      # ordinary or generic table

      librarytables:= LibraryTables( filename );

      if    librarytables = fail
         or not IsBound( librarytables.( firstname ) ) then
        Info( InfoCharacterTable, 1,
              "No library table with name `", tblname, "'" );
        return fail;
      fi;

      libtbl:= librarytables.( firstname );

      # If the table has not yet been converted to an object,
      # we must do this now.
      if IsRecord( libtbl ) then

        # If the table is a generic table then simply return it.
        if IsBound( libtbl.isGenericTable )
           and libtbl.isGenericTable = true then
          return libtbl;
        fi;

        # Concatenate the lines of the `InfoText' component.
        if IsBound( libtbl.InfoText ) then
          libtbl.InfoText:= Concatenation( libtbl.InfoText );
          ConvertToStringRep( libtbl.InfoText );
        fi;

        # Store the fusion sources.
        pos:= Position( LIBLIST.firstnames, firstname );
#T this is not sorted! (take LIBLIST.allnames instead, and use indirection)
        libtbl.NamesOfFusionSources:=
            ShallowCopy( LIBLIST.fusionsource[ pos ] );

        # Evaluate characters encoded as `[GALOIS,[i,j]]'
        # or `[TENSOR,[i,j]]'.
        if IsBound( libtbl.projectives ) then
          fld:= libtbl.projectives;
          libtbl.ProjectivesInfo:= [];
          Unbind( libtbl.projectives );
          for i in [ 1, 3 .. Length( fld ) - 1 ] do
            Add( libtbl.ProjectivesInfo,
                 rec( name:= fld[i], chars:= EvalChars( fld[i+1] ) ) );
          od;
        fi;

        # Obey the construction component.
        if IsBound( libtbl.ConstructionInfoCharacterTable ) then
          if IsFunction( libtbl.ConstructionInfoCharacterTable ) then
#T for backwards compatibility, supported in Version 1.1.
            libtbl.ConstructionInfoCharacterTable( libtbl );
          else
            CallFuncList(
                ValueGlobal( libtbl.ConstructionInfoCharacterTable[1] ),
                Concatenation( [ libtbl ],
                    libtbl.ConstructionInfoCharacterTable{ [ 2 ..  Length(
                        libtbl.ConstructionInfoCharacterTable ) ] } ) );
          fi;
        fi;

        # initialize some components
        if     IsBound( libtbl.ComputedPowerMaps )
           and not IsEmpty( libtbl.ComputedPowerMaps )
           and not IsBound( libtbl.OrdersClassRepresentatives ) then
          libtbl.OrdersClassRepresentatives:=
                       ElementOrdersPowerMap( libtbl.ComputedPowerMaps );
          if not ForAll( libtbl.OrdersClassRepresentatives, IsPosInt ) then
            Info( InfoWarning, 1,
                  "representative orders of library table ", tblname,
                  " not uniquely determined" );
            Unbind( libtbl.OrdersClassRepresentatives );
          fi;
        fi;

        if IsBound( libtbl.AutomorphismsOfTable ) and
           IsList( libtbl.AutomorphismsOfTable ) then
          libtbl.AutomorphismsOfTable:= GroupByGenerators(
                     libtbl.AutomorphismsOfTable, () );
        fi;

        if IsBound( libtbl.maxes ) then
          libtbl.Maxes:= libtbl.maxes;
          Unbind( libtbl.maxes );
        fi;

        if IsBound( libtbl.tomfusion ) then
          if IsBound( libtbl.tomfusion.text ) then
            libtbl.tomfusion.text:= Concatenation( libtbl.tomfusion.text );
            ConvertToStringRep( libtbl.tomfusion.text );
          fi;
          libtbl.FusionToTom:= libtbl.tomfusion;
# For backwards compatibility, do not unbind the component.
          libtbl.tomidentifier:= libtbl.tomfusion.name;
        fi;

        if IsBound( libtbl.isSimple ) then
          libtbl.IsSimpleCharacterTable:= libtbl.isSimple;
          Unbind( libtbl.isSimple );
        fi;

        if IsBound( libtbl.extInfo ) then
          libtbl.ExtensionInfoCharacterTable:= libtbl.extInfo;
          Unbind( libtbl.extInfo );
        fi;

        if IsBound( libtbl.CAS ) then
          libtbl.CASInfo:= libtbl.CAS;
          Unbind( libtbl.CAS );
        fi;
        if IsBound( libtbl.CASInfo ) then
          # For tables constructed from others,
          # the value may be copied from an attribute value
          # and hence may be immutable.
#T mutability problem:
#T if the following comment signs are removed then GAP runs into an error!
#         if not IsMutable( libtbl.CASInfo ) then
            libtbl.CASInfo:= List( libtbl.CASInfo, ShallowCopy );
#         fi;
          for i in libtbl.CASInfo do
            if IsBound( i.text ) and ForAll( i.text, IsString ) then
              i.text:= Concatenation( i.text );
              ConvertToStringRep( i.text );
            fi;
          od;
        fi;

        # Evaluate characters encoded as `[GALOIS,[i,j]]', `[TENSOR,[i,j]]'.
        EvalChars( libtbl.Irr );

        # Make the table object, and store it for the next call.
        ConvertToLibraryCharacterTableNC( libtbl );
        librarytables.( firstname ):= libtbl;

      fi;

      # Return the library table.
      return libtbl;

    else

      if arg[1] = "Quaternionic" and Length( arg ) = 2
         and IsInt( arg[2] ) then
        return CharacterTableQuaternionic( arg[2] );

      elif arg[1] = "GL" and Length( arg ) = 3
           and IsInt( arg[2] ) and IsInt( arg[3] ) then

        # `CharacterTable( GL, 2, q )'
        if arg[2] = 2 then
          return CharacterTableSpecialized(
                     CharacterTableFromLibrary( "GL2" ), arg[3] );
        else
          Info( InfoCharacterTable, 1,
                "Table of GL(", arg[2], ",q) not yet implemented" );
          return fail;
        fi;

      elif arg[1] = "SL" and Length( arg ) = 3
           and IsInt( arg[2] ) and IsInt( arg[3] ) then

        # CharacterTable( SL, 2, q )
        if arg[2] = 2 then
          if arg[3] mod 2 = 0 then
            return CharacterTableSpecialized(
                       CharacterTableFromLibrary( "SL2even" ),
                       arg[3] );
          else
            return CharacterTableSpecialized(
                       CharacterTableFromLibrary( "SL2odd" ),
                       arg[3] );
          fi;
        else
          Info( InfoCharacterTable, 1,
                "Table of SL(", arg[2], ",q) not yet implemented" );
          return fail;
        fi;

      elif arg[1] = "PSL" and Length( arg ) = 3
           and IsInt( arg[2] ) and IsInt( arg[3] ) then

        # PSL( 2, q )
        if arg[2] = 2 then
          if arg[3] mod 2 = 0 then
            return CharacterTableSpecialized(
                       CharacterTableFromLibrary( "SL2even" ),
                       arg[3] );
          elif ( arg[3] - 1 ) mod 4 = 0 then
            return CharacterTableSpecialized(
                       CharacterTableFromLibrary( "PSL2even" ),
                       arg[3] );
          else
            return CharacterTableSpecialized(
                       CharacterTableFromLibrary( "PSL2odd" ),
                       arg[3] );
          fi;
        else
          Info( InfoCharacterTable, 1,
                "Table of PSL(", arg[2], ",q) not yet implemented" );
          return fail;
        fi;

      elif arg[1] = "GU" and Length( arg ) = 3
           and IsInt( arg[2] ) and IsInt( arg[3] ) then

        # GU( 3, q )
        if arg[2] = 3 then
          return CharacterTableSpecialized(
                     CharacterTableFromLibrary( "GU3" ), arg[3] );
        else
          Info( InfoCharacterTable, 1,
                "Table of GU(", arg[2], ",q) not yet implemented" );
          return fail;
        fi;

      elif arg[1] = "SU" and Length( arg ) = 3
           and IsInt( arg[2] ) and IsInt( arg[3] ) then

        # SU( 3, q )
        if arg[2] = 3 then
          return CharacterTableSpecialized(
                     CharacterTableFromLibrary( "SU3" ),
                     arg[3] );
        else
          Info( InfoCharacterTable, 1,
                "Table of SU(", arg[2], ",q) not yet implemented" );
          return fail;
        fi;

      elif arg[1] = "Suzuki" and Length( arg ) = 2
           and IsInt( arg[2] ) then
        if not PrimeDivisors( arg[2] ) = [ 2 ] then
          Info( InfoCharacterTable, 1,
                "CharacterTable(\"Suzuki\",q): q must be a power of 2");
          return fail;
        fi;
        return CharacterTableSpecialized(
                   CharacterTableFromLibrary( "Suzuki" ),
                   [ arg[2],
                     2^((Length(FactorsInt(arg[2]))+1)/2) ] );

      else
        return CharacterTableSpecialized(
                   CharacterTableFromLibrary( arg[1] ), arg[2] );
      fi;
    fi;
end );


#############################################################################
##
#F  PartsBrauerTableName( <modname> )
##
InstallGlobalFunction( PartsBrauerTableName, function( modname )
    local i, primestring, ordname, prime, digits;

    primestring:= 0;
    for i in [ 1 .. Length( modname ) - 2 ] do
      if modname{ [ i .. i + 2 ] } = "mod" then
        primestring:= modname{ [ i + 3 .. Length( modname ) ] };
        ordname:= modname{ [ 1 .. i-1 ] };
      fi;
    od;
    if primestring = 0 then
      Print( "#I PartsBrauerTableName: ", modname,
             " is no valid name\n",
             "#I      for a Brauer table\n" );
      return fail;
    fi;

    # Convert the string back to a number.
    digits:= "0123456789";
    primestring:= List( primestring, x -> Position( digits, x ) );
    if fail in primestring then
      Print( "#I PartsBrauerTableName: ", modname,
             " is no valid name\n",
             "#I      for a Brauer table\n" );
      return fail;
    fi;
    prime:= 0;
    for i in [ 1 .. Length( primestring ) ] do
      prime:= 10 * prime + ( primestring[i] - 1 );
    od;

    return rec( ordname:= ordname, prime:= prime );
end );


#############################################################################
##
#F  BasicSetBrauerTree( <brauertree> )
##
InstallGlobalFunction( BasicSetBrauerTree, function( brauertree )
    local i, degrees, basicset, edge, elm;

    brauertree:= Set( brauertree );
    basicset:= [];

    # degrees of the vertices
    degrees:= [];
    for edge in brauertree do
      for i in edge do
        if not IsBound( degrees[i] ) then
          degrees[i]:= 1;
        else
          degrees[i]:= degrees[i] + 1;
        fi;
      od;
    od;

    while brauertree <> [] do

      # take a vertex of degree 1, remove its edge, adjust `degrees'
      elm:= Position( degrees, 1 );
      AddSet( basicset, elm );
      edge:= First( brauertree, x -> elm in x );
      RemoveSet( brauertree, edge );
      for i in edge do
        degrees[i]:= degrees[i] - 1;
      od;
    od;

    return basicset;
end );


#############################################################################
##
#F  DecMatBrauerTree( <brauertree> )
##
InstallGlobalFunction( DecMatBrauerTree, function( brauertree )
    local i, j, max, decmat;

    max:= 1;
    for i in brauertree do
      max:= Maximum( max, Maximum(i) );
    od;
    decmat:= NullMat( max, Length( brauertree ) );
    for i in [ 1 .. Length( brauertree ) ] do
      for j in brauertree[i] do
        decmat[j][i]:= 1;
      od;
    od;
    return decmat;
end );


#############################################################################
##
#F  BrauerTree( <decmat> )
##
InstallGlobalFunction( BrauerTree, function( decmat )
    local i, j, brauertree, edge, len;

    if not ( IsMatrix( decmat )
             and ForAll( decmat, x -> ForAll( x, y -> y=0 or y=1 ) ) ) then
      Print( "#I BrauerTree: <decmat> is not decomposition matrix\n",
             "#I     of a block of cyclic defect\n");
      return fail;
    fi;

    if decmat = [ [ 1 ] ] then return []; fi;

    brauertree:= [];
    for i in [ 1 .. Length( decmat[1] ) ] do

      # find the entries 1 in column `i'
      edge:= [];
      for j in [ 1 .. Length( decmat ) ] do
        if decmat[j][i] = 1 then Add( edge, j ); fi;
      od;
      len:= Length( edge );

      # If `len = 2', we have an ordinary edge of the tree; else this may
      # concern an exceptional character.

      if len = 2 then
        Add( brauertree, edge );
      else
        if Length( Set( decmat{ edge } ) ) <= 2 then

          # all or all but one ordinary irreducibles restrict identically
          Add( brauertree, edge );

        else
          Print( "#I BrauerTree: <decmat> is not decomposition",
                 " matrix\n",
                 "#I     of a block of cyclic defect\n");
          return fail;
        fi;
      fi;
    od;
    return brauertree;
end );


#############################################################################
##
#F  BrauerTableFromLibrary( <ordtbl>, <prime> )
##
InstallGlobalFunction( BrauerTableFromLibrary, function( ordtbl, prime )
    local filename,      # name of the file containing the Brauer table
          fld,           # library tables of the whole library file
          libtbl,        # record with data of the desired table
          reg,           # Brauer table, result
          op,            # largest normal $p$-subgroup
          orders,        # representative orders in `ordtbl'
          nccl,          # no. of classes in `ordtbl'
          entry,         # loop over stored fusions
          fusion,        # one fusion map
          result_blocks,
          i, j,
          ord,
          pow,
          ordblocks,
          modblocks,
          defect,
          name,
          irreducibles,
          restricted,
          block,
          basicset,
          class,
          images,
          chi,
          gal,
          newimages,
          pos,
          im,
          decmat,
          brauertree,
          facttbl,
          mfacttbl,
          pbl,
          info,
          factinfo,
          ordchars,
          offset,
          decinv,
          suffix;

    # Get the library file of the Brauer table if possible.
    name:= Concatenation( Identifier( ordtbl ), "mod", String( prime ) );
    filename:= LibInfoCharacterTable( name );
    if IsRecord( filename ) then
      filename:= filename.fileName;
      fld:= LibraryTables( filename );
    else
      fld:= fail;
    fi;

    if fld = fail or not IsBound( fld.( name ) ) then

      # For p-solvable tables, prefer the generic method.
      if IsPSolvableCharacterTable( ordtbl, prime ) then
        return fail;
      fi;

      # Maybe we have to factor out a normal $p$-subgroup before
      # we find the table (name) in the library.
      op:= ClassPositionsOfPCore( ordtbl, prime );
      if Length( op ) = 1 then
        Info( InfoCharacterTable, 1,
              "No library table with name `", name, "'" );
        return fail;
      fi;

      orders:= OrdersClassRepresentatives( ordtbl );
      nccl:= NrConjugacyClasses( ordtbl );
      for entry in ComputedClassFusions( ordtbl ) do
        fusion:= entry.map;
        if Positions( fusion, 1 ) = op then

          # We found the ordinary factor for which the Brauer characters
          # are equal to the ones we need.
          facttbl:= CharacterTableFromLibrary( entry.name );
          if facttbl = fail then
            return fail;
          fi;
          mfacttbl:= BrauerTable( facttbl, prime );
          if mfacttbl = fail then
            return fail;
          fi;

          # Now we set up a *new* Brauer table since the ordinary table
          # as well as the blocks information for the factor group is
          # different from the one for the extension.
          reg:= CharacterTableRegular( ordtbl, prime );
          SetFilterObj( reg, IsLibraryCharacterTableRep );

          # Set the irreducibles.
          # Note that the ordering of classes is in general *not* the same,
          # so we must translate with the help of fusion maps.
          fusion:= CompositionMaps(
                    InverseMap( GetFusionMap( mfacttbl, facttbl ) ),
                    CompositionMaps( GetFusionMap( ordtbl, facttbl ),
                                     GetFusionMap( reg, ordtbl ) ) );
          SetIrr( reg, List( Irr( mfacttbl ),
              chi -> Character( reg,
                  ValuesOfClassFunction( chi ){ fusion } ) ) );

          # Set known attribute values that can be copied from `mfacttbl'.
          if HasAutomorphismsOfTable( mfacttbl ) then
            SetAutomorphismsOfTable( reg, AutomorphismsOfTable( mfacttbl )
                ^ Inverse( PermList( fusion ) ) );
          fi;
          if HasInfoText( mfacttbl ) then
            SetInfoText( reg, InfoText( mfacttbl ) );
          fi;
          if HasComputedIndicators( mfacttbl ) then
            SetComputedIndicators( reg, ComputedIndicators( mfacttbl ) );
          fi;

          # Return the table.
          return reg;

        fi;
      od;

      Info( InfoCharacterTable, 1,
            "No library table of the factor by O_p" );
      return fail;

    fi;

    libtbl:= fld.( name );

    # If the table was already constructed simply return it.
    if IsBrauerTable( libtbl ) then
      return libtbl;
    fi;

    # Otherwise we have to work.
    reg:= CharacterTableRegular( ordtbl, prime );
    SetFilterObj( reg, IsLibraryCharacterTableRep );

#T just a hack ...
    reg!.defect:= libtbl.defect;
    reg!.block:= libtbl.block;
    if IsBound( libtbl.decinv ) then
      reg!.decinv:= libtbl.decinv;
    fi;
    if IsBound( libtbl.basicset ) then
      reg!.basicset:= libtbl.basicset;
    fi;
    if IsBound( libtbl.brauertree ) then
      reg!.brauertree:= libtbl.brauertree;
    fi;
#T end of the hack ...

    # Concatenate the lines of the `InfoText' component if necessary.
    if   not IsBound( libtbl.InfoText ) then
      SetInfoText( reg, "(no info text)" );
    elif IsString( libtbl.InfoText ) then
      SetInfoText( reg, libtbl.InfoText );
    else
      SetInfoText( reg, Concatenation( libtbl.InfoText ) );
    fi;

    # If automorphisms are known (list of generators), convert to a group.
    if IsBound( libtbl.AutomorphismsOfTable ) then
      SetAutomorphismsOfTable( reg,
          GroupByGenerators( libtbl.AutomorphismsOfTable, () ) );
    fi;

    # Initialize some components.
    if not IsBound( libtbl.decinv ) then
      libtbl.decinv:= [];
    fi;

    block:= [];
    defect:= [];
    basicset:= [];
    brauertree:= [];
    decinv:= [];

    # If the distribution to blocks is stored on the table
    # then use it, otherwise compute it.
    ordblocks:= InverseMap( PrimeBlocks( ordtbl, prime ).block );

    # Get the blocks of factor groups if necessary;
    # `factorblocks' is a list of pairs containing the names of the
    # tables that hold the blocks and the offset of basic set characters.
    if IsBound( libtbl.factorblocks ) then

      suffix:= filename;
      pos:= Position( suffix, '/' );
      while pos <> fail do
        suffix:= suffix{ [ pos+1 .. Length( suffix ) ] };
        pos:= Position( suffix, '/' );
      od;

      for i in libtbl.factorblocks do
        facttbl:= Concatenation( i[1], "mod", String( prime ) );
        if IsBound( LIBTABLE.( suffix ).( facttbl ) ) then
          facttbl:= LIBTABLE.( suffix ).( facttbl );
        else
          # The factor table is in another file (hopefully a rare case),
          # or it is obtained from a construction.
          facttbl:= CharacterTableFromLibrary( i[1] ) mod prime;
        fi;
        if block = [] then
          offset:= 0;
        else
          offset:= Maximum( block ) + 1 - Minimum( facttbl!.block );
        fi;
        pos:= Length( defect );
        Append( defect, facttbl!.defect );
        Append( block, offset + facttbl!.block );
        for j in [ 1 .. Length( facttbl!.defect ) ] do
          if facttbl!.defect[j] <> 0 then
            if IsBound( facttbl!.decinv ) and
               IsBound( facttbl!.decinv[j] ) then
              if IsInt( facttbl!.decinv[j] ) then
                decinv[ pos + j ]:= facttbl!.decinv[ facttbl!.decinv[j] ];
              else
                decinv[ pos + j ]:= facttbl!.decinv[j];
              fi;
              brauertree[ pos + j ]:= fail;
              basicset[ pos + j ]:= i[2] + facttbl!.basicset[j];
            else
              if IsInt( facttbl!.brauertree[j] ) then
                brauertree[ pos + j ]:=
                    facttbl!.brauertree[ facttbl!.brauertree[j] ];
              else
                brauertree[ pos + j ]:= facttbl!.brauertree[j];
              fi;
              basicset[ pos + j ]:= ordblocks[ pos + j ]{
                            BasicSetBrauerTree( brauertree[ pos + j ] ) };
            fi;
          fi;
        od;
      od;

      reg!.factorblocks:= libtbl.factorblocks;
#T a hack? (make the stored component evaluable)

    fi;

    pos:= Length( defect );
    Append( defect, libtbl.defect );
    Append( block, libtbl.block );
    for j in [ 1 .. Length( libtbl.defect ) ] do
      if libtbl.defect[j] <> 0 then
        if IsBound( libtbl.decinv[j] ) then
          if IsInt( libtbl.decinv[j] ) then
            decinv[ pos + j ]:= libtbl.decinv[ libtbl.decinv[j] ];
          else
            decinv[ pos + j ]:= libtbl.decinv[j];
          fi;
          brauertree[ pos + j ]:= fail;
          basicset[ pos + j ]:= libtbl.basicset[j];
        else
          if IsInt( libtbl.brauertree[j] ) then
            brauertree[ pos + j ]:=
                libtbl.brauertree[ libtbl.brauertree[j] ];
          else
            brauertree[ pos + j ]:= libtbl.brauertree[j];
          fi;
          basicset[ pos + j ]:= ordblocks[ pos + j ]{
                            BasicSetBrauerTree( brauertree[ pos + j ] ) };
        fi;
      fi;
    od;

    # compute the blocks and the irreducibles of each block,
    # and assign them to the right positions;
    # assign the known decomposition matrices and Brauer trees;
    # ignore defect 0 blocks
    irreducibles:= [];
    restricted:= RestrictedClassFunctions( Irr( ordtbl ), reg );

    modblocks := InverseMap( block );
    result_blocks:= [];

    for i in [ 1 .. Length( ordblocks ) ] do

      if IsInt( ordblocks[i] ) then ordblocks[i]:= [ ordblocks[i] ]; fi;
      if IsInt( modblocks[i] ) then modblocks[i]:= [ modblocks[i] ]; fi;

      if defect[i] = 0 then

        irreducibles[ modblocks[i][1] ]:= restricted[ ordblocks[i][1] ];
        decinv[i]:= [ [1] ];
        basicset[i]:= ordblocks[i];

      else

        if IsBound( basicset[i] ) then
          if IsBound( brauertree[i] ) and brauertree[i] <> fail then
            decinv[i]:= DecMatBrauerTree( brauertree[i]){
                             Filtered( [ 1 .. Length( ordblocks[i] ) ],
                                       x -> ordblocks[i][x] in basicset[i] )
                            }^(-1) ;
          fi;
          if IsBound( decinv[i] ) then
            irreducibles{ modblocks[i] }:=
                List( decinv[i] * List( restricted{ basicset[i] },
                                        ValuesOfClassFunction ),
                      vals -> Character( reg, vals ) );
          else
            Error( "at least one of the components <decinv>, <brauertree> ",
                   "must be bound at pos. ", i );
          fi;
        else
          Print( "#E BrauerTable: no basic set for block ", i, "\n" );
        fi;
      fi;

      result_blocks[i]:= rec( defect    := defect[i],
                              ordchars  := ordblocks[i],
                              modchars  := modblocks[i],
                              decinv    := decinv[i],
                              basicset  := basicset[i]   );
      if IsBound( brauertree[i] ) and brauertree[i] <> fail then
        result_blocks[i].brauertree:= brauertree[i];
      fi;

    od;

    # instead of calling `Immutable' for the entries in the loop ...
    MakeImmutable( ordblocks );
    MakeImmutable( modblocks );
    MakeImmutable( decinv );
    MakeImmutable( basicset );
    MakeImmutable( brauertree );

    SetBlocksInfo( reg, result_blocks );
    SetIrr( reg, irreducibles );

    if IsBound( libtbl.CharacterParameters ) then
      SetCharacterParameters( reg, libtbl.CharacterParameters );
    fi;

    # decode the `IrredInfo' value
    # (contains 2nd indicator if the prime is 2, else nothing)
    if IsBound( libtbl.indicator ) then
      SetComputedIndicators( reg, [ , libtbl.indicator ] );
    fi;

#T BAD HACK until incomplete tables disappeared ...
#T only file ctborth2 ...
    if IsBound( libtbl.warning ) then
      Print( "#W warning for table of `", Identifier( reg ), "':\n",
             libtbl.warning, "\n" );
    fi;

    # Store additional information.
    # for the moment just as components.
    for entry in [ "version", "date" ] do
      if IsBound( libtbl.( entry ) ) then
        reg!.( entry ):= libtbl.( entry );
      fi;
    od;
    for entry in [ "ClassInfo", "RootDatumInfo" ] do
      if IsBound( libtbl.( entry ) ) then
        Setter( ValueGlobal( entry ) )( reg, libtbl.( entry ) );
      fi;
    od;

    # Store the Brauer table for the next call.
    fld.( name ):= reg;

    # Return the Brauer table.
    return reg;
end );


#############################################################################
##
#M  BrauerTableOp( <tbl>, <p> ) . . . . . . . . . . <p>-modular library table
##
##  Let <tbl> be an ordinary character table from the GAP table library,
##  and <p> be a prime integer.
##  - If the <p>-modular Brauer table of <tbl> is stored in a library file
##    then this table is returned.
##  - If <tbl> is <p>-solvable then we delegate to the library method
##    that is based on the Fong-Swan theorem.
##  - If the construction information stored on <tbl> admits the construction
##    of the <p>-modular Brauer table then the result of this construction
##    is returned.
##  - Otherwise fall back to the generic method.
##
InstallMethod( BrauerTableOp,
    [ "IsOrdinaryTable and IsLibraryCharacterTableRep", "IsPosInt" ], SUM_FLAGS,
    function( tbl, p )
    local result, modtbl, info, t, orig, fus, rest, modtblMG, modtblGA,
          tblG2, tblG3, found, cand, tblG, modtblG, modtblG2, modtblG3,
          modtblH1, modtblG1, modtblH2, perm,
          ordfacttbls, modfacttbls, modfacttbl, ordtbl, proj, inv, ker, irr;

    result:= fail;
    modtbl:= BrauerTableFromLibrary( tbl, p );
    if modtbl <> fail then
      result:= modtbl;
    elif IsPSolvableCharacterTable( tbl, p ) then
      # The generic method is preferred to table constructions.
      TryNextMethod();
    elif HasConstructionInfoCharacterTable( tbl ) then
      info:= ConstructionInfoCharacterTable( tbl );
      if IsList( info ) and info[1] = "ConstructPermuted" then
        t:= CallFuncList( CharacterTableFromLibrary, info[2] );
        orig:= t mod p;
        if orig <> fail then
          result:= CharacterTableRegular( tbl, p );
          # Restrict the permutation (if given) to the `p'-regular classes.
          fus:= GetFusionMap( result, tbl );
          if IsBound( info[3] ) then
            fus:= OnTuples( fus, Inverse( info[3] ) );
          fi;
          rest:= CompositionMaps( InverseMap( GetFusionMap( orig, t ) ),
                     fus );
          SetIrr( result, List( Irr( orig ),
                        chi -> Character( result,
                                 ValuesOfClassFunction( chi ){ rest } ) ) );
          # Transfer 2-modular indicators if they are stored.
          if p = 2 and HasComputedIndicators( orig ) and
             IsBound( ComputedIndicators( orig )[2] ) then
            ComputedIndicators( result )[2]:= ComputedIndicators( orig )[2];
          fi;
          # Transfer character parameters if they are stored.
          if HasCharacterParameters( orig ) then
            SetCharacterParameters( result, CharacterParameters( orig ) );
          fi;
        fi;
      elif IsList( info ) and info[1] = "ConstructMGA" then
        modtblMG:= CharacterTable( info[2] ) mod p;
        modtblGA:= CharacterTable( info[3] ) mod p;
        if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
          result:= BrauerTableOfTypeMGA( modtblMG, modtblGA, tbl );
          if result <> fail then
            result:= result.table;
          fi;
        fi;
      elif IsList( info ) and info[1] = "ConstructGS3" then
        # The identifier of the table of the normal subgroup 'G'
        # does not occur in the construction parameters.
        # We know that the factor group modulo 'G' is a Frobenius group
        # such that 'info[2]' modulo 'G' is a cyclic Frobenius complement.
        tblG2:= CharacterTable( info[2] );
        tblG3:= CharacterTable( info[3] );
        if ForAll( [ tblG2, tblG3 ], IsCharacterTable ) then
          found:= false;
          for cand in Intersection( NamesOfFusionSources( tblG2 ),
                                    NamesOfFusionSources( tblG3 ) ) do
            tblG:= CharacterTable( cand );
            if IsPrimeInt( Size( tblG2 ) / Size( tblG ) ) then
              found:= true;
              break;
            fi;
          od;
          if found then
            modtblG:= tblG mod p;
            modtblG2:= tblG2 mod p;
            modtblG3:= tblG3 mod p;
            if ForAll( [ modtblG, modtblG2, modtblG3 ],
                       IsCharacterTable ) then
              result:= CharacterTableOfTypeGS3( modtblG, modtblG2, modtblG3,
                  tbl,
                  Concatenation( Identifier( tbl ), "mod", String( p ) ) );
              if Length( Irr( result.table ) ) =
                 Length( Irr( result.table )[1] ) then
                result:= result.table;
              else
                # Not all irreducibles have been determined.
                result:= fail;
              fi;
            fi;
          fi;
        fi;
      elif IsList( info ) and info[1] = "ConstructIndexTwoSubdirectProduct"
           then
        modtblH1:= CharacterTable( info[2] ) mod p;
        modtblG1:= CharacterTable( info[3] ) mod p;
        modtblH2:= CharacterTable( info[4] ) mod p;
        modtblG2:= CharacterTable( info[5] ) mod p;
        if not fail in [ modtblH1, modtblG1, modtblH2, modtblG2 ] then
          perm:= info[7];
          if HasClassPermutation( tbl ) then
            perm:= perm * ClassPermutation( tbl );
          fi;
          result:= CharacterTableOfIndexTwoSubdirectProduct(
                       modtblH1, modtblG1, modtblH2, modtblG2,
                       [ tbl, perm ] );
          if result <> fail then
            result:= result.table;
          fi;
        fi;
      elif IsList( info ) and info[1] = "ConstructV4G" then
        result:= fail;
        if Length( info ) = 2 then
          ordfacttbls:= List( info[2], CharacterTableFromLibrary );
          modfacttbls:= List( ordfacttbls, x -> x mod p );
          if not fail in modfacttbls then
            result:= BrauerTableOfTypeV4G( tbl, modfacttbls );
          fi;
        else
          modfacttbl:= CharacterTable( info[2] ) mod p;
          if modfacttbl <> fail then
            result:= CallFuncList( BrauerTableOfTypeV4G,
                         Concatenation( [ tbl, modfacttbl ],
                             info{ [ 3 .. Length( info ) ] } ) );
          fi;
        fi;
      elif IsList( info ) and info[1] = "ConstructFactor" then
        # If the kernel in question is the p-core then
        # we would run into an infinite recursion
        # if we try to compute the Brauer table for the big table,
        # because the big table would delegate to the factor modulo
        # its p-core.
        ordtbl:= CallFuncList( CharacterTableFromLibrary, info[2] );
        if ClassPositionsOfPCore( ordtbl, p ) = info[3] then
          modtbl:= fail;
        else
          modtbl:= ordtbl mod p;
        fi;
        if modtbl <> fail then
          result:= CharacterTableRegular( tbl, p );
          proj:= GetFusionMap( modtbl, result );
          if proj = fail then
            result:= fail;
          else
            # It may happen that the kernel contains a nontrivial p-part.
            proj:= ProjectionMap( proj );
            inv:= InverseMap( GetFusionMap( modtbl, ordtbl ) );
            ker:= Filtered( info[3], i -> IsBound( inv[i] ) );
            ker:= inv{ ker };
            irr:= List( Filtered( Irr( modtbl ),
                                  x -> IsSubset( ClassPositionsOfKernel( x ),
                                       ker ) ),
                        x -> Character( result, x{ proj } ) );
            SetIrr( result, irr );
          fi;
        fi;
      fi;
    fi;

    if result <> fail then
      SetFilterObj( result, IsLibraryCharacterTableRep );
      if HasClassParameters( tbl ) then
        SetClassParameters( result,
            ClassParameters( tbl ){ GetFusionMap( result, tbl ) } );
      fi;
      return result;
    fi;

    TryNextMethod();
    end );


#############################################################################
##
#M  BrauerTable( <tblname>, <p> )
##
InstallMethod( BrauerTable,
    "for a string (the name of the table), and a prime",
    [ "IsString", "IsInt" ],
    function( tblname, p )
    local tbl;

    if not IsPrimeInt( p ) then
      Error( "<p> must be a prime integer" );
    fi;
    tbl:= CharacterTable( tblname );
    if tbl <> fail then
      tbl:= BrauerTable( tbl, p );
    fi;
    return tbl;
    end );


#############################################################################
##
#F  CharacterTableSpecialized( <generic_table>, <q> )  . . . . specialise <q>
##
InstallGlobalFunction( CharacterTableSpecialized, function( gtab, q )
    local taf,         # record of the specialized table, result
          genclass,    #
          classparam,  #
          genchar,     #
          charparam,   #
          parm,        #
          i, k,        #
          class;       #

    # Check if the argument is valid.
    if not ( IsRecord( gtab ) and IsBound( gtab.isGenericTable ) ) then
      Error( "this is not a generic character table" );
    elif IsBound( gtab!.domain ) and not gtab!.domain( q ) then
      Error( q, " is not a valid parameter for this generic table" );
    fi;

    # A generic character table must contain at least functions to compute
    # the parametrisation of classes and characters.

    if IsBound( gtab!.wholetable ) then

      # If the generic table has a component `wholetable'
      # (a function which takes the generic table and `q' as arguments),
      # use this function to construct the whole table.
      taf:= gtab!.wholetable( gtab, q );

    else

      taf := rec();

      # Get the parametrisation of classes and characters.
      # `genclass' stores for each class of the specialized character table
      # the number of the class of the generic table it stems from.
      # `classparam' stores the parameter of the special class.
      # `genchar' and `charparam' do the same for characters.

      if    not IsBound( gtab!.classparam )
         or not IsBound( gtab!.charparam ) then
        Error( "components `classparam' and `charparam' are missing" );
      fi;

      genclass   := [];
      classparam := [];

      for i in [ 1 .. Length( gtab!.classparam ) ] do
        parm := gtab!.classparam[i](q);
        Append( classparam, parm );
        Append( genclass, List( parm, j -> i ) );
      od;

      genchar   := [];
      charparam := [];

      for i in [ 1 .. Length( gtab!.charparam ) ] do
        parm := gtab!.charparam[i](q);
        Append( charparam, parm );
        Append( genchar, List( parm, j -> i ) );
      od;

      # Compute the name of the table.
      if IsBound( gtab!.specializedname ) then
        taf.Identifier:= gtab!.specializedname( q );
        ConvertToStringRep( taf.Identifier );
      fi;

      # Compute the group order.
      if IsBound( gtab!.size ) then
        taf.Size := gtab!.size(q);
      fi;

      # Compute centralizer and representative orders.
      if IsBound( gtab!.centralizers ) then
        taf.SizesCentralizers := List( [ 1 .. Length( classparam ) ],
                j -> gtab!.centralizers[ genclass[j] ]( q, classparam[j] ) );
      fi;

      if IsBound( gtab!.orders ) then
        taf.OrdersClassRepresentatives :=
                List( [ 1 .. Length( classparam ) ],
                      j -> gtab!.orders[ genclass[j] ]( q, classparam[j] ) );
      fi;

      # Compute the power maps.
      taf.ComputedPowerMaps := [];
      if IsBound( gtab!.powermap ) and IsBound( taf.Size ) then
        for i in Reversed( PrimeDivisors( taf.Size ) ) do
          taf.ComputedPowerMaps[i] := [];
          for class in Reversed( [1 .. Length( classparam ) ] ) do
            parm := gtab!.powermap[genclass[class]](q, classparam[class],i);
            k := 1;
            while genclass[k] <> parm[1] or classparam[k] <> parm[2] do
              k := k+1;
            od;
            taf.ComputedPowerMaps[i][class] := k;
          od;
        od;
      fi;

      # Perform some initialisations, if the necessary data are present.
      if IsBound( gtab!.classtext ) then
        taf.classtext := List( [ 1 .. Length( classparam ) ],
                   j -> gtab!.classtext[ genclass[j] ]( q, classparam[j] ) );
      fi;

      # Compute the character values.
      if IsBound( gtab!.matrix ) then
        taf.Irr := gtab!.matrix( q );
      elif IsBound( gtab!.irreducibles ) then
        taf.Irr := List( [ 1 .. Length( charparam ) ],
                  i -> List( [1..Length(classparam)],
                             j -> gtab!.irreducibles[genchar[i]][genclass[j]]
                                  ( q, charparam[i], classparam[j] ) ) );
      fi;

      taf.ClassParameters:= List( [ 1 .. Length( classparam ) ],
                                  i -> [ genclass[i], classparam[i] ] );
      taf.CharacterParameters:= List( [ 1 .. Length( charparam ) ],
                                      i -> [ genchar[i], charparam[i] ] );

      if IsBound( gtab!.text ) then
        taf.InfoText:= Concatenation( "computed using ", gtab!.text );
      fi;

      if IsBound( gtab!.UnderlyingCharacteristic ) then
        taf.UnderlyingCharacteristic:= gtab!.UnderlyingCharacteristic;
      else
        taf.UnderlyingCharacteristic:= 0;
      fi;

    fi;

    # Objectify and return the table.
    ConvertToLibraryCharacterTableNC( taf );
    return taf;
end );


#############################################################################
##
#F  TransferComponentsToLibraryTableRecord( <t>, <tbl> )
##
InstallGlobalFunction( TransferComponentsToLibraryTableRecord,
    function( t, tbl )
    local names, i, fld;

    names:= ShallowCopy( RecNames( tbl ) );
    Add( names, "Irr" );

    # Set the supported attribute values.
    for i in [ 1, 4 .. Length( SupportedCharacterTableInfo ) - 2 ] do
      if     not SupportedCharacterTableInfo[ i+1 ] in names
         and Tester( SupportedCharacterTableInfo[i] )( t ) then
        tbl.( SupportedCharacterTableInfo[ i+1 ] ):=
            SupportedCharacterTableInfo[i]( t );
      fi;
    od;

    # Set the supported library table components.
    for fld in Difference( SupportedLibraryTableComponents, names ) do
      if IsBound( t!.( fld ) ) then
        tbl.( fld ):= t!.( fld );
      fi;
    od;

    # Set the irreducibles if necessary.
    if HasIrr( t ) and not IsBound( tbl!.Irr ) then
      tbl.Irr:= List( Irr( t ), ValuesOfClassFunction );
    fi;
end );


#############################################################################
##
#F  InducedLibraryCharacters( <subtbl>, <tblrec>, <chars>, <fusionmap> )
##
##  is the list of class function values lists
##
InstallGlobalFunction( InducedLibraryCharacters,
    function( subtbl, tblrec, chars, fusion )
    local j,              # loop variables
          centralizers,   # centralizer orders in hte supergroup
          nccl,           # number of conjugacy classes of the group
          subnccl,        # number of conjugacy classes of the subgroup
          suborder,       # order of the subgroup
          subclasses,     # class lengths in the subgroup
          induced,        # list of induced characters, result
          singleinduced,  # one induced character
          char;           # one character to be induced

    centralizers:= tblrec.SizesCentralizers;
    nccl:= Length( centralizers );
    suborder:= Size( subtbl );
    subclasses:= SizesConjugacyClasses( subtbl );
    subnccl:= Length( subclasses );

    induced:= [];

    for char in chars do

      # preset the character with zeros
      singleinduced:= ListWithIdenticalEntries( nccl, 0 );

      # add the contribution of each class of the subgroup
      for j in [ 1 .. subnccl ] do
        if char[j] <> 0 then
          singleinduced[ fusion[j] ]:= singleinduced[ fusion[j] ]
                                   + char[j] * subclasses[j];
        fi;
      od;

      # adjust the values by multiplication
      for j in [ 1 .. nccl ] do
        singleinduced[j]:= singleinduced[j] * centralizers[j] / suborder;
      od;

      Add( induced, singleinduced );

    od;

    # Return the list of values lists.
    return induced;
end );


#############################################################################
##
#F  UnpackedCll( <cll> )
##
InstallGlobalFunction( UnpackedCll, function( cll )
    local l, clmlist,  # library list of the possible matrices
          clf,         # Clifford matrix record, result
          pi;          # permutation to sort library matrices

    # Initialize the Clifford matrix record.
    clf:= rec(
               inertiagrps   := cll[1],
               fusionclasses := cll[2]
              );

    if Length( cll[2] ) = 1 then

      clf.mat:= [ [ 1 ] ];

    elif IsMatrix( cll[3] ) then

      # is already unpacked, for example dimension 2
      clf.mat:= cll[3];

    else

      # Fetch the matrix from the library.
      cll:= cll[3];
      clf.libname:= cll;
      l:= cll[2];
      clmlist:= LibraryTables( Concatenation( "clm", cll[1] ) );
      if clmlist = fail or not IsBound( clmlist[l] ) then
        Error( "sorry, component <mat> not found in the library" );
      fi;

      clf.mat:= List( clmlist[l][ cll[3] ], ShallowCopy );

      # Sort the rows and columns of the Clifford matrix
      # w.r.t. the explicitly given permutations.
      if IsBound( cll[4] ) then
        clf.mat:= Permuted( clf.mat, cll[4] );
      fi;
      if IsBound( cll[5] ) then
        pi:= cll[5];
        clf.mat:= List( clf.mat, x -> Permuted( x, pi ) );
      fi;

    fi;

    return clf;
end );


#############################################################################
##
#F  CllToClf( <tbl>, <cll> )
##
InstallGlobalFunction( CllToClf, function( tbl, cll )
    local Ti,          #
          factor,      # character table of the factor group G/N
          classnames,
          i, nr,
          dim,         # dimension of the matrix
          clf,         # expanded record
          pos,
          map;

    Ti:= tbl!.cliffordTable.Ti;
    factor:= Ti.tables[1];
    classnames:= ClassNames( factor );

    nr:= cll[2][1];
    dim:= Length( cll[2] );

    # Decode `cll'.
    clf:= UnpackedCll( cll );

    # Fill the Clifford matrix record.
    clf.nr     := nr;
    clf.size   := dim;
    clf.order  := factor.orders[nr];
    clf.orders := [ factor.orders[nr] ];
    clf.elname := classnames[nr];
    clf.full   := true;

    # Compute the row weights $b_a = |C_{T_m/N}(gN)|$.
    clf.roww:= List( [ 1 .. dim ],
        i -> SizesCentralizers( Ti.tables[ cll[1][i] ] )[ cll[2][i] ] );

    # Compute the column weights $m_k = |Cl_{G/N}(gN)| / |Cl_G(g_k)|$.
    pos:= 0;
    for map in Ti.fusions do
      pos:= pos + Number( map, x -> x < nr );
    od;
    clf.colw:= List( [ 1 .. dim ],
                     i -> SizesConjugacyClasses( tbl )[ pos+i ] /
                          SizesConjugacyClasses( factor )[nr] );
#T !!

#     if dim = 1 then
#       if IsBound( cll[4] ) then
#         clf.colw := [cll[4][2]];
#       else
#         clf.colw := [1];
# #T ??
#       fi;
#     elif dim = 2 then
#
#         factor:= Ti.tables[ clf.inertiagrps[2] ];
#         if not IsCharacterTable( factor ) then
#           factor:= CallFuncList( CharacterTableFromLibrary, factor );
#         fi;
#
#         if IsBound( cll[4] )  then
#             if cll[4][1] = 0 then #not really splitted
#                 clf.colw := cll[4][2]*[1, clf.roww[1]/clf.roww[2]];
#                 clf.mat:= [[1,1],[clf.roww[1]/clf.roww[2],-1]];
#             else
#                 clf.colw := [ 1, cll[4][2]-1 ];
#                 clf.mat:= [[1,1],[cll[4][4]*clf.colw[2],-cll[4][4]]];
#             fi;
#         else
#             clf.colw := [1, clf.roww[1]/clf.roww[2]];
#             clf.mat:= [[1,1],[clf.colw[2],-1]];
# #T but this holds only for split cosets!
#         fi;
#     fi;

    # Handle the special case of extraspecial groups.
    if Length( cll ) = 4 then
      clf.splitinfos:= rec( classindex := cll[4][1],
                            p          := cll[4][2] );
      if IsBound( cll[4][3] ) then
        clf.splitinfos.numclasses:= cll[4][3];
      fi;
      if IsBound( cll[4][4] ) then
        clf.splitinfos.root:= cll[4][4];
      fi;
    fi;

    return clf;
end );


#############################################################################
##
#F  CompleteGroup()
##
InstallGlobalFunction( CompleteGroup,
    function() Error( "this is just a dummy function" ); end );


#############################################################################
##
#F  OfThose()
##
InstallGlobalFunction( OfThose,
    function() Error( "this is just a dummy function" ); end );


#############################################################################
##
#F  CTblLib.GetAccessFunctionAttrs()
##
CTblLib.AccessFunctionAttrs:= fail;

CTblLib.GetAccessFunctionAttrs:= function()
    local attrs, attr, name;

    if CTblLib.AccessFunctionAttrs = fail then
      attrs:= [ [ Identifier ], [ "dummy" ], [ "dummy" ] ];
      for name in RecNames( CTblLib.Data.IdEnumerator.attributes ) do
        attr:= CTblLib.Data.IdEnumerator.attributes.( name );
        if IsBound( attr.name ) then
          Add( attrs[1], ValueGlobal( attr.name ) );
          Add( attrs[2], attr );
          Add( attrs[3], CTblLib.Data.IdEnumeratorExt.attributes.( name ) );
        fi;
      od;
      CTblLib.AccessFunctionAttrs:= attrs;
    fi;
    return CTblLib.AccessFunctionAttrs;
    end;


#############################################################################
##
#F  CTblLib.ValueOfFunction( <func>, <nam> )
##
CTblLib.ValueOfFunction:= function( func, nam )
    local attrs, apos, val, attr, result;

    # Initialize the attribute information if necessary.
    attrs:= CTblLib.GetAccessFunctionAttrs();

    apos:= Position( attrs[1], func );

    val:= nam;
    if apos = 1 then
      # Applying the function yields the identifier of the table.
      if IsCharacterTable( nam ) then
        nam:= Identifier( nam );
      fi;
      return [ nam, val ];
    elif apos = fail then
      # Use the character table for computing this invariant.
      if not IsCharacterTable( val ) then
        val:= CharacterTable( nam );
      fi;
      return [ func( val ), val ];
    else
      # We fetch the known attribute value,
      # or compute it and amend the cache.
      if IsCharacterTable( nam ) then
        nam:= Identifier( nam );
      fi;
      if nam in CTblLib.Data.IdEnumerator.identifiers then
        # The table is not private, the value is stored.
        attr:= attrs[2][ apos ];
        return [ attr.attributeValue( attr, nam ), val ];
      else
#T what about CTblLib.Data.IdEnumeratorExt?
        # The table is private, the value may be missing.
#T  TODO:
#T  -> if val is the table then use it & set the value, only otherwise compute!
        attr:= attrs[3][ apos ];
        return [ attr.attributeValue( attr, nam ), val ];
      fi;
    fi;
    end;


#############################################################################
##
#P  IsQuasisimple( <tbl> )
##
if not IsBound( IsQuasisimple ) then
  # Apparently the GAP library does not install a method for character tables.
  DeclareProperty( "IsQuasisimple", IsObject );
  DeclarePropertySuppCT( "IsQuasisimpleCharacterTable",
      IsNearlyCharacterTable );
  InstallMethod( IsQuasisimpleCharacterTable,
      [ "IsOrdinaryTable" ],
      tbl -> IsPerfect( tbl ) and
             IsSimple( tbl / ClassPositionsOfCentre( tbl ) ) );
  InstallMethod( IsQuasisimple, [ "IsOrdinaryTable" ],
      IsQuasisimpleCharacterTable );
fi;


#############################################################################
##
#F  CTblLib.AccessFunction( [{<func>, <val>}], <mode>
#F                          [: OrderedBy:= <func>] )
#F  CTblLib.AccessFunction( [<func>, <val>,{ OfThose, <func>,}] <mode>
#F                          [: OrderedBy:= <func>] )
##
##  <mode> must be one of "one", "all".
##
##  If <mode> has the value "all" then we run over all library tables,
##  and in the end we sort the result either according to the function
##  stored in the global option "OrderedBy" or (the default) alphabetically.
##
##  If <mode> has the value "one" there are several cases:
##  - If no sorting is prescribed by the global option "OrderedBy" then take
##    the first table that fits to the conditions in <args>.
##  - If "OrderedBy" is one of the supported (cheap) attributes then run over
##    the library tables in this order and return the first table that fits
##    to <args>.
##  - If "OrderedBy" is not one of the supported (cheap) attributes then
##    anyhow we have to construct all library tables that fit to <args>.
##    Thus we run over all library tables and keep always only the currently
##    smallest one that fits, according to "OrderedBy".
##
CTblLib.AccessFunction:= function( args, mode )
    local names, orderedby, attrs, pos, cheapconditions, otherconditions, i,
          values, multinfo, simpinfo, autoinfo, result, key, name, vals,
          newvals, val, ident, pp, ext, resul, newkey;

    names:= LIBLIST.firstnames;

    # Fetch the option value.
    orderedby:= ValueOption( "OrderedBy" );

    if orderedby = fail then
      if IsEmpty( args ) then
        if mode = "all" then
          # all table names in the library
          return ShallowCopy( names );
        else
          # one table name in the library
          return names[1];
        fi;
      fi;
    elif not IsFunction( orderedby ) then
      Error( "global option OrderedBy, if given, must be a function" );
    fi;

    if mode = "one" or not IsEmpty( args ) then
      # Rearrange the conditions until the first occurrence of 'OfThose'
      # such that the cheap ones come first.
      # For that, initialize the attribute information if necessary.
      attrs:= CTblLib.GetAccessFunctionAttrs();
      pos:= Position( args, OfThose );
      if pos = fail then
        pos:= Length( args ) + 1;
      fi;
      cheapconditions:= [];
      otherconditions:= [];
      for i in [ 1, 3 .. pos-2 ] do
        if args[i] in attrs[1] then
          Append( cheapconditions, args{ [ i, i+1 ] } );
        else
          Append( otherconditions, args{ [ i, i+1 ] } );
        fi;
      od;
      Append( cheapconditions, otherconditions );
      Append( cheapconditions, args{ [ pos .. Length( args ) ] } );
      args:= cheapconditions;
    fi;

    if mode = "one" and orderedby in attrs[1] then
      # Sort the library table names by the required ordering,
      # and then forget about the global option.
      names:= ShallowCopy( names );
      values:= List( names,
                     nam -> CTblLib.ValueOfFunction( orderedby, nam )[1] );
      StableSortParallel( values, names );
      orderedby:= fail;
    fi;

    # table names of sporadic simple groups
    # (sorted according to size)
    multinfo:= List( LIBLIST.simpleInfo, x -> x[1] );
    simpinfo:= List( LIBLIST.simpleInfo, x -> x[2] );
    autoinfo:= List( LIBLIST.simpleInfo, x -> x[3] );
#T access gpisotyp data!

    # Initialize the result.
    if mode = "all" then
      result:= [];
      key:= [];
    else
      key:= fail;
    fi;

    # Loop over the names.
    for name in names do

      # Now there are two possibilities:
      # Either one filters the list `list',
      # or we reach an `OfThose', so we replace the current entry of `list'
      # by the image under the mapping instruction after `OfThose'.
      vals:= [ name ];
      pos:= 1;
      while pos <= Length( args ) do

        newvals:= [];
        for val in vals do

          if args[ pos ] = OfThose then
            if args[ pos + 1 ] in
                [ SchurCover, AutomorphismGroup, CompleteGroup ] then

              # These cases are supported via `ExtensionInfoCharacterTable'.
              ident:= val;
              if IsCharacterTable( ident ) then
                ident:= Identifier( ident );
              fi;
              pp:= Position( simpinfo, ident );
              if pp = fail then
                if not IsCharacterTable( val ) then
                  val:= CharacterTable( val );
                fi;
                if HasExtensionInfoCharacterTable( val ) then
                  ext:= ExtensionInfoCharacterTable( val );
                else
                  Error( "no info about multiplier and autom. group of `",
                         val, "' stored" );
                fi;
              else
                ext:= [ multinfo[ pp ], autoinfo[ pp ] ];
              fi;
              if args[ pos + 1 ] <> AutomorphismGroup then
                if ext[1] <> "" then
                  ident:= Concatenation( ext[1], ".", ident );
                fi;
              fi;
              if args[ pos + 1 ] <> SchurCover then
                if ext[2] <> "" then
                  ident:= Concatenation( ident, ".", ext[2] );
                fi;
              fi;
              Add( newvals, ident );
#T in these cases,
#T better use `val' itself if the image is the simple group?
#T or avoid storing a possibly large number of tables?
#T or admit switching the mode?

            else

              # If a database attribute is available for the mapping
              # then use it (`Maxes', `NamesOfFusionSources').
              resul:= CTblLib.ValueOfFunction( args[ pos + 1 ], val );
              val:= resul[2];
              resul:= resul[1];

              if   IsString( resul ) then
                Add( newvals, resul );
              elif ForAll( resul, IsString ) then
                UniteSet( newvals, resul );
              else
                Error( "<args>[", pos+1, "] must return a (list of) strings" );
              fi;
            fi;

          else

            # Check one condition.
            resul:= CTblLib.ValueOfFunction( args[ pos ], val );
            val:= resul[2];
            resul:= resul[1];

            if resul = args[ pos+1 ] or
               ( IsList( args[ pos+1 ] ) and resul in args[ pos+1 ] ) or
               ( IsFunction( args[ pos+1 ] ) and args[ pos+1 ]( resul ) )
               then
              Add( newvals, val );
            fi;

          fi;

        od;

        pos:= pos + 2;
        vals:= newvals;

      od;

      # All conditions have been checked for `name'.
      for val in vals do
        if orderedby = fail then
          if not IsString( val ) then
            val:= Identifier( val );
          fi;
          if mode = "all" then
            Add( result, val );
          else
            return val;
          fi;
        else
          newkey:= CTblLib.ValueOfFunction( orderedby, val )[1];
          if not IsString( val ) then
            val:= Identifier( val );
          fi;
          if mode = "all" then
            Add( key, newkey );
            Add( result, val );
          elif key = fail or newkey < key then
            key:= newkey;
            result:= val;
          fi;
        fi;
      od;

    od;

    # Return the result.
    if mode = "one" then
      if key = fail then
        return fail;
      fi;
      return result;
    elif orderedby = fail then
      return Set( result );
    else
      SortParallel( key, result );
      return result;
    fi;
    end;


#############################################################################
##
#F  AllCharacterTableNames( {<func>, <val>} )
#F  AllCharacterTableNames( <func>, <val>, ...{, OfThose, <func>} )
##
InstallGlobalFunction( AllCharacterTableNames, function( arg )
    return CTblLib.AccessFunction( arg, "all" );
    end );


#############################################################################
##
#F  OneCharacterTableName( {<func>, <val>} )
#F  OneCharacterTableName( <func>, <val>, ...{, OfThose, <func>} )
##
InstallGlobalFunction( OneCharacterTableName, function( arg )
    return CTblLib.AccessFunction( arg, "one" );
    end );


#############################################################################
##
#F  NameOfEquivalentLibraryCharacterTable( <ordtbl> )
#F  NamesOfEquivalentLibraryCharacterTables( <ordtbl> )
##
CTblLib.AccessNamesOfEquivalentLibraryCharacterTables:=
    function( ordtbl, mode )
    local init, result, name, trans;

    # Test cheap attributes first, and exclude duplicates.
    init:= AllCharacterTableNames( Size, Size( ordtbl ),
                   NrConjugacyClasses, NrConjugacyClasses( ordtbl ),
                   IsDuplicateTable, false );
#T why not more invariants?

#T if ordtbl is itself a library table then make sure that the test is cheap!
    # Do the hard test.
    result:= [];
    for name in init do
#T careful:
#T TransformingPermutationsCharacterTables computes table automorphisms
#T if necessary, but here we do not need them!
      trans:= TransformingPermutationsCharacterTables(
                  CharacterTable( name ), ordtbl );
      if trans <> fail then
        if mode = "all" then
          AddSet( result, name );
        else
          return name;
        fi;
      fi;
    od;

    # Return the result.
    if mode <> "all" then
      return fail;
    else
      # Add the names of duplicates.
      for name in ShallowCopy( result ) do
        UniteSet( result, IdentifiersOfDuplicateTables( name ) );
      od;
      return result;
    fi;
    end;


InstallGlobalFunction( NameOfEquivalentLibraryCharacterTable,
    function( ordtbl )
    if not IsOrdinaryTable( ordtbl ) then
      Error( "usage: NameOfEquivalentLibraryCharacterTable( <ordtbl> )" );
    fi;
    return CTblLib.AccessNamesOfEquivalentLibraryCharacterTables( ordtbl,
                       "one" );
    end );


InstallGlobalFunction( NamesOfEquivalentLibraryCharacterTables,
    function( ordtbl )
    if not IsOrdinaryTable( ordtbl ) then
      Error( "usage: NamesOfEquivalentLibraryCharacterTables( <ordtbl> )" );
    fi;
    return CTblLib.AccessNamesOfEquivalentLibraryCharacterTables( ordtbl,
                       "all" );
    end );


#############################################################################
##
#F  UnloadCharacterTableData()
##
##  This is equivalent to flushing the cache.
##
InstallGlobalFunction( UnloadCharacterTableData, function()
    local name;

    for name in RecNames( LIBTABLE.LOADSTATUS ) do
      Unbind( LIBTABLE.( name ) );
    od;
    LIBTABLE.LOADSTATUS    := rec();
    LIBTABLE.TABLEFILENAME := "";
    LIBTABLE.clmelab       := [];
    LIBTABLE.clmexsp       := [];
    end );


#T #############################################################################
#T ##
#T #F  ShrinkClifford( <tbl> )
#T ##
#T InstallGlobalFunction( ShrinkClifford, function( tbl )
#T 
#T     local i, flds, cltbl;
#T 
#T     cltbl:= tbl!.cliffordTable;
#T     cltbl.Ti.tables := cltbl.Ti.ident;
#T 
#T     cltbl.cliffordrecords:= [];
#T 
#T     for i in  [1..cltbl.size] do
#T 
#T       cltbl.cliffordrecords[i]:= ClfToCll( cltbl.(i) );
#T       Unbind( cltbl.(i) );
#T 
#T     od;
#T 
#T     Unbind( tbl.irreducibles);
#T #T how to remove attributes ??
#T     Unbind( cltbl.Ti.ident );
#T     Unbind( cltbl.Ti.expN );
#T 
#T     for flds in [ "name", "grpname", "elements", "isDomain", "operations",
#T                   "charTable", "size", "expN" ] do
#T       Unbind( cltbl.(flds) );
#T     od;
#T end );


#############################################################################
##
#F  TextString( <text> )
##
InstallGlobalFunction( TextString, function( text )
    local str, start, stop, line, len, pos;

    str:=  "[\n\"";
    stop:= 1;
    len:= Length( text );
    while stop <= len do
      start:= stop;
      while stop <= len and text[stop] <> '\n' do
        stop:= stop + 1;
      od;
      line:= text{ [ start .. stop-1 ] };
      pos:= Position( line, '\"' );
      while pos <> fail do
        line:= Concatenation( line{ [ 1 .. pos-1 ] },
               "\\\"", line{ [ pos+1 .. Length( line ) ] } );
        pos:= Position( line, '\"', pos + 1 );
      od;
      Append( str, line );
      if stop <= len then
        Append( str, "\\n\",\n\"" );
        stop:= stop+1;     # skip the '\n'
      fi;
    od;
    Append( str, "\"\n]" );
    return str;
end );


#############################################################################
##
#F  ShrinkChars( <chars> )
##
InstallGlobalFunction( ShrinkChars, function( chars )
    local i, j, k, N, oldchars, linear, chi, fams, pos, ppos;

    linear:= Filtered( chars, x -> x[1] = 1 );
    fams:= GaloisMat( chars ).galoisfams;
    chars:=    ShallowCopy( chars );
    oldchars:= ShallowCopy( chars );

    if Length( linear ) > 1 then
      ppos:= List( linear, x -> Position( chars, x ) );
      for i in [ 1 .. Length( chars ) ] do
        chi:= chars[i];
        if not IsString( chi ) then
          for j in [ 1 .. Length( linear ) ] do
            pos:= Position( chars, Tensored( [ linear[j] ],[ chi ] )[1] );
            if pos <> fail and pos > i and pos > ppos[j] then
              chars[ pos ]:= Concatenation( "\n[TENSOR,[",
                                  String(i),",",String( ppos[j] ),"]]");
            fi;
          od;
        fi;
      od;
    fi;

    for i in [ 1 .. Length( chars ) ] do
      if IsList( fams[i] ) then
        for j in [ 2 .. Length( fams[i][1] ) ] do
          if fams[i][1][j] <= Length( chars ) then
            chi:= chars[ fams[i][1][j] ];
            if IsClassFunction( chi ) then
              chi:= ValuesOfClassFunction( chi );
            fi;
            if not IsString( chi ) then
              N:= Conductor( chi );
              k:= First( [ 2..N ], x -> chi = List( oldchars[i],
                                                    y -> GaloisCyc(y,x) ) );
              chars[ fams[i][1][j] ]:= Concatenation("\n[GALOIS,[",
                                               String(i),",",String(k),"]]");
            fi;
          fi;
        od;
      fi;
    od;

    return chars;
end );


#T #############################################################################
#T ##
#T #F  ClfToCll( <clf> )
#T ##
#T InstallGlobalFunction( ClfToCll, function( clf )
#T     local p,       # position of the Clifford matrix clm in CLM[*]
#T           cll,     # compressed record
#T           clm,     # the pure Clifford matrix consisting of "mat" and "colw"
#T           clmlist, # list of stored cliffordrecords
#T           l,
#T           lname,   # name of item in the library
#T           list,    #
#T           tr;
#T 
#T     # Check the input.
#T     if not IsRecord( clf ) or
#T        not IsBound( clf.inertiagrps ) or
#T        not IsBound( clf.fusionclasses ) or
#T        not IsBound( clf.mat ) then
#T       Error( "<clf> must be record with components `inertiagrps', `mat' ",
#T              "and `fusionclasses'" );
#T     fi;
#T 
#T     l:= Length( clf.mat[1] );
#T     cll:= [ clf.inertiagrps, clf.fusionclasses ];
#T 
#T     if IsBound( clf.splitinfos )  then
#T       lname := "exsp";
#T       cll[4]:= [ clf.splitinfos.classindex, clf.splitinfos.p ];
#T       if IsBound( clf.splitinfos.numclasses ) then
#T         cll[4][3]:= clf.splitinfos.numclasses;
#T       fi;
#T       if IsBound( clf.splitinfos.root ) then
#T         cll[4][4]:= clf.splitinfos.root;
#T       fi;
#T     else
#T       lname := "elab";
#T     fi;
#T 
#T     if l = 2  then
#T 
#T       # Store the full matrix.
#T       cll[3]:= clf.mat;
#T 
#T     elif 2 < l then
#T 
#T       clm:= clf.mat;
#T       cll[3]:= clm;
#T 
#T       # Try to find the matrix in the library of Clifford matrices.
#T       clmlist := LibraryTables( Concatenation( "clm", lname ) );
#T       if not IsList( clmlist ) then
#T         Error( "#E ClfToCll: can't find library of Clifford matrices.\n" );
#T       fi;
#T 
#T       if IsBound( clmlist[l] ) then
#T 
#T         list:= clmlist[l];
#T         p:= Position( list, clm );
#T         if p <> fail then
#T 
#T           # Just store the library code.
#T           cll[3]:= [ lname, l, p ];
#T           return cll;
#T 
#T         else
#T 
#T           # The matrix itself is not in the library.
#T           # Perhaps it is contained up to permutations of rows/columns,
#T           # in this case print an appropriate message.
#T           for p in [ 1 .. Length( list ) ] do
#T 
#T             tr:= TransformingPermutations( clm, list[p] );
#T             if tr <> fail then
#T 
#T               # The matrix can be permuted to a library matrix.
#T               cll[3]:= [ lname, l, p ];
#T               if tr.rows <> () then
#T                 cll[3][4]:= tr.rows^-1;
#T               fi;
#T               if tr.columns <> () then
#T                 cll[3][5]:= tr.columns^-1;
#T               fi;
#T               return cll;
#T 
#T             fi;
#T 
#T           od;
#T 
#T           Print( "#I Clifford matrix not found in the library\n" );
#T 
#T # `clm' not found in library, either because given libname is wrong or
#T # the matrix must be added first by an authorized person.
#T # The order would be:
#T #           PrintClmsToLib( <file>, [clf] );
#T 
#T         fi;
#T       fi;
#T     fi;
#T 
#T     return cll;
#T end );


#############################################################################
##
#F  LibraryFusion( <name>, <fus> )
#F  LibraryFusion( <s>, <t> )
##
InstallGlobalFunction( LibraryFusion, function( name, fus )
    local poss, reps, source, target, string, linelen, i, str, spec;

    if IsCharacterTable( name ) and IsCharacterTable( fus ) then
      # Try to compute the information in question.
      poss:= PossibleClassFusions( name, fus );
      reps:= RepresentativesFusions( name, poss, fus );
      source:= Identifier( name );
      if Length( poss ) = 0 then
        return fail;
      elif Length( poss ) = 1 then
        fus:= rec( name:= fus, map:= poss[1],
                   text:= "fusion map is unique" );
      elif Length( reps ) = 1 then
        fus:= rec( name:= fus, map:= poss[1],
                   text:= "fusion map is unique up to table aut." );
      else
        return fail;
      fi;
    elif IsCharacterTable( name ) then
      source:= Identifier( name );
    else
      source:= name;
    fi;
    target:= fus.name;
    if IsCharacterTable( target ) then
      if HasClassPermutation( target )
         and not IsOne( ClassPermutation( target ) ) then
        Print( "#W  target of the fusion map stores a class permutation\n" );
      fi;
      target:= Identifier( target );
    fi;

    # Initialize the result string.
    string:= "";

    # Print the source and destination.
    Append( string, "ALF(\"" );
    Append( string, source );
    Append( string, "\",\"" );
    Append( string, target );

    # Initialize the current position in the line.
    linelen:= Length( source ) + Length( target ) + 11;

    # Add the values of the fusion map.
    Append( string, "\",[" );
    for i in fus.map do
      str:= String( i );
      if linelen + Length( str ) + 1 < 75 then
        linelen:= linelen + Length( str ) + 1;
      else
        Append( string, "\n" );
        linelen:= Length( str ) + 1;
      fi;
      Append( string, str );
      Append( string, "," );
    od;
    string[ Length( string ) ]:= ']';

    # If a text is bound, add it.
    if IsBound( fus.text ) then
      Append( string, "," );
      Append( string, TextString( fus.text ) );

      # If a specification is bound, add it.
      if IsBound( fus.specification ) then
        spec:= fus.specification;
        if IsString( spec ) then
          spec:= Concatenation( "\"", spec, "\"" );
        fi;
        Append( string, "," );
        Append( string, spec );
      fi;
    fi;

    Append( string, ");\n" );

    return string;
end );


#############################################################################
##
#F  LibraryFusionTblToTom( <tblname>, <fus> )
##
InstallGlobalFunction( LibraryFusionTblToTom, function( name, fus )
    local string, target, linelen, i, str;

    if IsCharacterTable( name ) then
      name:= Identifier( name );
    fi;

    # Initialize the result string.
    string:= "";

    target:= fus.name;
    if IsTableOfMarks( target ) then
      target:= Identifier( target );
    fi;

    # Print the source and destination.
    Append( string, "ARC(\"" );
    Append( string, name );
    Append( string, "\",\"tomfusion\",rec(name:=\"" );
    Append( string, target );
    Append( string, "\",map:=[" );

    # Initialize the current position in the line.
    linelen:= Length( string );

    # Add the values of the fusion map.
    for i in fus.map do
      str:= String( i );
      if linelen + Length( str ) >= 74 then
        Add( string, '\n' );
        linelen:= 0;
      fi;
      linelen:= linelen + Length( str ) + 1;
      Append( string, str );
      Add( string, ',' );
    od;
    string[ Length( string ) ]:= ']';

    # If a text is bound, add it.
    if IsBound( fus.text ) then
      Add( string, ',' );
      if linelen >= 71 then
        Add( string, '\n' );
      fi;
      Append( string, "text:=" );
      Append( string, TextString( fus.text ) );
    fi;

    # If a permutation of maxes is bound then add it.
    if IsBound( fus.perm ) then
      Add( string, ',' );
      if linelen >= 71 then
        Add( string, '\n' );
      fi;
      Append( string, "perm:=" );
      Append( string, String( fus.perm ) );
    fi;

    Append( string, "));\n" );

    return string;
end );


#############################################################################
##
#F  CTblLib.ConsiderFactorBlocks( <tbl> )
##
##  (This is a utility for `CTblLib.StringBrauer'.)
##
##  Let <A>tbl</A> be the Brauer character table of a group <M>G</M>, say.
##  If the &GAP; Character Table Library contains the tables of factor groups
##  of <M>G</M> by central subgroups
##  such that the irreducible characters of these factors precede the other
##  characters in <A>tbl</A> then the blocks of the factors can be omitted
##  in the library version of <A>tbl</A>,
##  and references to the factors are stored instead.
##  <P/>
##  <Ref Func="CTblLib.ConsiderFactorBlocks"/> returns an empty record
##  if no such replacement is possible because no table of a relevant
##  factor group was found.
##  If some factor fusion is missing or if the irreducibles of a factor table
##  are sorted incompatibly then a record with the component <C>error</C>
##  is returned, whose value is a string.
##  Otherwise a record with the components <C>offset</C> and <C>info</C> is
##  returned,
##  the former being the number of those irreducible characters of <A>tbl</A>
##  that are not covered by the factor groups,
##  and the latter being the list that can be inserted as value of the
##  <C>factorblocks</C> component in the library version of <A>tbl</A>;
##  this is a list of pairs whose first entries are the names of the factor
##  tables, and the second entries are the offsets of numbers of basic set
##  characters.
##  <P/>
##  Currently this special treatment of factor groups is supported only for
##  Brauer tables in the &ATLAS; of Finite Groups.
##  This means that the central subgroups in question must have order
##  divisible by <M>12</M>, and the ordering of characters in the tables of
##  the factor groups must coincide with the ordering for the table given.
##
CTblLib.ConsiderFactorBlocks:= function( tbl )
    local p, ordinary, factfus, classes, nsg, pos, mult, sizes, kernels, i,
          kernel, size, name, facttbl, map, modfacttbl,
          info,
          nonfaith1,
          nonfaith,
          1faith,
          ppos,
          2faith,
          nonfaith2,
          nonfaith4,
          4faith;

    # Get the factor fusions stored on the ordinary table.
    p:= UnderlyingCharacteristic( tbl );
    ordinary:= OrdinaryCharacterTable( tbl );
    factfus:= Filtered( ComputedClassFusions( ordinary ),
                  x -> Length( ClassPositionsOfKernel( x.map ) ) <> 1 );

    # We must make sure that the fusions to all relevant factor tables
    # are available.  (Otherwise some blocks could be missing.)
#T (example: "2^2.L3(4).2_3" with fusion only to "2.L3(4).2_3"
#T but not to "L3(4).2_3")
    classes:= SizesConjugacyClasses( ordinary );
    nsg:= Filtered( ClassPositionsOfNormalSubgroups( ordinary ),
                    n -> 12 mod Sum( classes{ n } ) = 0 );
    nsg:= Difference( nsg, [ [ 1 ] ] );

    # Get the maximal normal subgroup of order dividing $12$.
    pos:= 0;
    mult:= 0;
    sizes:= List( factfus, x -> 0 );
    kernels:= [];
    for i in [ 1 .. Length( factfus ) ] do
      kernel:= ClassPositionsOfKernel( factfus[i].map );
      size:= Sum( classes{ kernel } );
      if 12 mod size = 0 then
        RemoveSet( nsg, kernel );
        sizes[i]:= size;
        kernels[i]:= kernel;
        if mult < size then
          pos:= i;
          mult:= size;
        fi;
      fi;
    od;
    if pos = 0 or ( mult mod p = 0 ) then
      # No ordinary factor table was found,
      # or the Brauer table can be constructed itself from that of a factor.
      return rec();
    elif not IsEmpty( nsg ) and
      # If `kernels[ pos ]' describes a cyclic group then some fusions are
      # missing; if the normal subgroup has the type 2^2 or 2^2x3 then only
      # one factor fusion for kernels of order 2 or 6 is needed.
         not ( sizes[ pos ] = 4 and Length( nsg ) = 2 and
               List( nsg, n -> Sum( classes{ n } ) ) = [ 2, 2 ] ) and
         not ( sizes[ pos ] = 12 and Length( nsg ) = 4 and
               SortedList( List( nsg, n -> Sum( classes{ n } ) ) ) = [ 2, 2, 6, 6 ] ) then
#T and what if 2^2.G really comes with three nonisom. factors 2.G?
      return rec( error:= "some fusion missing" );
    fi;

    # Get the table of the smallest factor group.
    name:= factfus[ pos ].name;
    facttbl:= CharacterTable( name );

    # Check that the irreducibles fit together.
    map:= factfus[ pos ].map;
    if List( Irr( facttbl ), x -> x{ map } )
           <> Irr( ordinary ){ [ 1 .. NrConjugacyClasses( facttbl ) ] } then
      return rec( error:= "incompatible irred. for 1.G" );
    fi;
    modfacttbl:= facttbl mod p;
    if modfacttbl = fail or not IsBound( modfacttbl!.defect ) then
      return rec( error:= "missing components in 1.G" );
    fi;

    # Initialize the `factorblocks' info.
    info:= [ [ name, 0 ] ];
    nonfaith1:= Length( PrimeBlocks( facttbl, p ).defect );
    nonfaith:= nonfaith1;

    # If `mult' is a prime then we are done.
    if mult <> 3 and mult <> 2 then

      # Get the number of ordinary characters of `1.G'.
      1faith:= Maximum( map );

      # Get the number of faithful ordinary characters of `2.G'.
      # (Note that there is no group `2.G' if `2^2.G' occurs and the three
      # subgroups of order two inside the `2^2' are conjugate.)
      ppos:= First( [ 1 .. Length( factfus ) ],
                    i ->     sizes[i] = mult / 2
                         and IsSubset( kernels[ pos ], kernels[i] ) );
      if ppos <> fail then
        map:= factfus[ ppos ].map;
        2faith:= Maximum( map ) - 1faith;
        Add( info, [ factfus[ ppos ].name, 0 ] );
        facttbl:= CharacterTable( factfus[ ppos ].name );
        nonfaith2:= Length( PrimeBlocks( facttbl, p ).defect );
        nonfaith:= nonfaith2;

        # Check that the irreducibles fit together.
        if List( Irr( facttbl ), x -> x{ map } )
           <> Irr( ordinary ){ [ 1 .. NrConjugacyClasses( facttbl ) ] } then
          return rec( error:= "incompatible irred. for 2.G" );
        fi;
      else
        2faith:= 0;
      fi;

      # If `mult = 4' then we are done.
      if mult = 6 then

        # Consider `3.G'
        # (offset is the number of ordinary faithful characters of `2.G').
        ppos:= First( [ 1 .. Length( factfus ) ],
                      i ->     sizes[i] = 2
                           and IsSubset( kernels[ pos ], kernels[i] ) );
        Add( info, [ factfus[ ppos ].name, 2faith ] );
        facttbl:= CharacterTable( factfus[ ppos ].name );

        # Check that the irreducibles fit together.
        map:= factfus[ ppos ].map;
        if List( Irr( facttbl ), x -> x{ map } )
           <> Irr( ordinary ){
                Concatenation( [ 1 .. 1faith ], 1faith + 2faith +
                    [ 1 .. Maximum( map ) - 1faith ] ) } then
          return rec( error:= "incompatible irred. for 3.G" );
        fi;

        nonfaith:= Length( PrimeBlocks( facttbl, p ).defect )
                   + nonfaith2 - nonfaith1;

      elif mult = 12 then

        # If the normal subgroup of order 12 is cyclic then the proper factor
        # groups have orders 1, 2, 4, 3, 6 (in this order).
        # If the structure is 2^2x3 then the proper factor groups have orders
        # 1, 2, 4, 3, 6 or 1, 4, 3 (in this order).

        # Consider `4.G' or `2^2.G' (no offset).
        ppos:= First( [ 1 .. Length( factfus ) ],
                      i ->     sizes[i] = 3
                           and IsSubset( kernels[ pos ], kernels[i] ) );
        Add( info, [ factfus[ ppos ].name, 0 ] );
        facttbl:= CharacterTable( factfus[ ppos ].name );
        nonfaith4:= Length( PrimeBlocks( facttbl, p ).defect );

        # Check that the irreducibles fit together.
        map:= factfus[ ppos ].map;
        if List( Irr( facttbl ), x -> x{ map } )
           <> Irr( ordinary ){ [ 1 .. NrConjugacyClasses( facttbl ) ] } then
          return rec( error:= "incompatible irred. for [4].G" );
        fi;

        # Get the number of ordinary characters of `4.G' or `2^2.G' that
        # are not characters of `2.G'.
        4faith:= Maximum( map ) - 1faith - 2faith;

        # Consider `3.G' (offset is the number of
        # ordinary faithful characters of `2.G' and `4.G').
        ppos:= First( [ 1 .. Length( factfus ) ],
                      i ->     sizes[i] = 4
                           and IsSubset( kernels[ pos ], kernels[i] ) );

        Add( info, [ factfus[ ppos ].name, 2faith + 4faith ] );
        map:= factfus[ ppos ].map;
        facttbl:= CharacterTable( factfus[ ppos ].name );

        # Check that the irreducibles fit together.
        if List( Irr( facttbl ), x -> x{ map } )
           <> Irr( ordinary ){
                Concatenation( [ 1 .. 1faith ], 1faith + 2faith + 4faith +
                    [ 1 .. Maximum( map ) - 1faith ] ) } then
          return rec( error:= "incompatible irred. for 3.G" );
        fi;

        # Consider `6.G' (offset is the number of
        # ordinary faithful characters of `4.G').
        ppos:= First( [ 1 .. Length( factfus ) ],
                      i ->     sizes[i] = 2
                           and IsSubset( kernels[ pos ], kernels[i] ) );
        if ppos <> fail then
          map:= factfus[ ppos ].map;
          Add( info, [ factfus[ ppos ].name, 4faith ] );
          facttbl:= CharacterTable( factfus[ ppos ].name );
          nonfaith:= Length( PrimeBlocks( facttbl, p ).defect )
                     + nonfaith4 - nonfaith2;

          # Check that the irreducibles fit together.
          if List( Irr( facttbl ), x -> x{ map } )
             <> Irr( ordinary ){
                  Concatenation( [ 1 .. 1faith + 2faith ], 1faith + 2faith + 4faith +
                      [ 1 .. Maximum( map ) - 1faith - 2faith ] ) } then
            return rec( error:= "incompatible irred. for 6.G" );
          fi;

        else
          # The normal subgroup has the structure 2^2x3, and no invariant 2.
          # So we have to take the table of 3.G as the missing factor table
          # for computing the number of non-faithful characters..
#T ???
          nonfaith:= Length( PrimeBlocks( facttbl, p ).defect )
                     + nonfaith4 - nonfaith1;
        fi;

      fi;

    fi;

    # Return the ``shrink'' information.
    return rec( offset := nonfaith,
                info   := info );
    end;


#############################################################################
##
#F  BlanklessPrintTo( <stream>, <obj>, <ncols>, <used>, <quote> )
##
InstallGlobalFunction( BlanklessPrintTo,
    function( stream, obj, ncols, used, quote )
    local PrintToEx, i, names, newstring, newstream, len, j;

    # Print the arguments without separators and line breaks.
    PrintToEx := function( arg )
      local len, entry;
      len:= Sum( arg, Length );
      if ncols < used + len then
        PrintTo( stream, "\n" );
        used:= 0;
      fi;
      for entry in arg do
        PrintTo( stream, entry );
      od;
      used:= used + len;
    end;

    if not IsEmptyString( obj ) and IsList( obj ) and IsEmpty( obj ) then
      if used + 2 > ncols then
        PrintTo( stream, "\n" );
        used:= 0;
      fi;
      PrintTo( stream, "[]" );
      used:= used + 2;
    elif IsString( obj ) then
      if quote then
        if '\n' in obj then
          PrintTo( stream, TextString( obj ) );
          used:= 1;
        else
          PrintToEx( "\"", obj, "\"" );
        fi;
      else
        PrintToEx( obj );
      fi;
    elif IsRange( obj ) and 2 < Length( obj ) then
      PrintToEx( "[" );
      used:= BlanklessPrintTo( stream, obj[1], ncols, used, true );
      if obj[2] <> obj[1] + 1 then
        PrintToEx( "," );
        used:= BlanklessPrintTo( stream, obj[2], ncols, used, true );
      fi;
      PrintToEx( ".." );
      used:= BlanklessPrintTo( stream, obj[ Length( obj ) ], ncols, used,
                               true );
      PrintToEx( "]" );
    elif IsList( obj ) then
      PrintToEx( "[" );
      for i in [ 1 .. Length( obj ) - 1 ] do
        if IsBound( obj[i] ) then
          used:= BlanklessPrintTo( stream, obj[i], ncols, used, true );
        fi;
        PrintToEx( "," );
      od;
      if not IsEmpty( obj ) then
        used:= BlanklessPrintTo( stream, obj[ Length( obj ) ], ncols, used,
                                 true );
      fi;
      PrintToEx( "]" );
    elif IsRecord( obj ) then
      PrintToEx( "rec(" );
      names:= RecNames( obj );
      for i in [ 1 .. Length( names ) - 1 ] do
        PrintToEx( names[i], ":=" );
        used:= BlanklessPrintTo( stream, obj.( names[i] ), ncols, used,
                                 true );
        PrintToEx( ",\n" );
        used:= 0;
      od;
      if not IsEmpty( names  ) then
        i:= Length( names );
        PrintToEx( names[i], ":=" );
        used:= BlanklessPrintTo( stream, obj.( names[i] ), ncols, used,
                                 true );
      fi;
      PrintToEx( ")" );
    elif IsChar( obj ) then
      PrintToEx( [ '\'', obj, '\'' ] );
    elif IsPerm( obj ) or IsCyc( obj ) then
      newstring:= "";
      newstream:= OutputTextString( newstring, true );
      SetPrintFormattingStatus( newstream, false );
      PrintTo( newstream, obj );
      CloseStream( newstream );
      newstring:= ReplacedString( newstring, " ", "" );
      i:= 1;
      while i <= Length( newstring ) do
        if not IsDigitChar( newstring[i] ) then
          # This implies that a leading '-' character is preferably left
          # at the end of lines; this is perhaps not a good idea.
          PrintToEx( [ newstring[i] ] );
          i:= i + 1;
        else
          j:= i + 1;
          while j <= Length( newstring ) and IsDigitChar( newstring[j] ) do
            j:= j+1;
          od;
          used:= BlanklessPrintTo( stream, newstring{ [ i .. j-1 ] }, ncols,
                                   used, false );
          i:= j;
        fi;
      od;
    else
      newstring:= "";
      newstream:= OutputTextString( newstring, true );
      PrintTo( newstream, obj );
      CloseStream( newstream );
      len:= Length( newstring );
      if ncols < used + len then
        PrintTo( stream, "\n" );
        used:= 0;
      fi;
      PrintTo( stream, newstring );
      used:= used + len;
    fi;
    return used;
end );


#############################################################################
##
#F  CTblLib.BasicSet( <decmat> )
##
CTblLib.BasicSet:= function( decmat )
    local lic, other, k, comb, old, diff, new, bs;

    lic:= LinearIndependentColumns( TransposedMat( decmat ) );
    if DeterminantMat( decmat{ lic } ) in [ 1, -1 ] then
      return lic;
    fi;

    # The first choice was not successful.
    # Exchange `k' members, starting with `k = 1'.
    other:= Difference( [ 1 .. Length( decmat ) ], lic );
    for k in [ 1 .. Minimum( Length( lic ), Length( other ) ) ] do
      Info( InfoCharacterTable, 2,
            "CTblLib.BasicSet: exchange ", k, " members" );
      comb:= Combinations( other, k );
      for old in Combinations( lic, k ) do
        diff:= Difference( lic, old );
        for new in comb do
          bs:= Concatenation( diff, new );
          if DeterminantMat( decmat{ bs } ) in [ 1, -1 ] then
            return Set( bs );
          fi;
        od;
      od;
    od;

    # There is no basic set that consists of ordinary irreducibles.
    Info( InfoWarning, 1, "no basic set of irreducibles found" );
    return fail;
    end;


#############################################################################
##
#F  CTblLib.AppendSpecial( <stream>, <ncols>, <chars>, <used> )
##
##  Special cases are `Irr( tbl )' and `ProjectivesInfo( tbl )' since
##  after the call of `ShrinkChars' they may
##  contain strings, which shall be printed without `"'
##
CTblLib.AppendSpecial:= function( stream, ncols, chars, used )
    local j;

    used:= BlanklessPrintTo( stream, "[", ncols, used, false );
    for j in [ 1 .. Length( chars ) ] do
      if j <> 1 then
        used:= BlanklessPrintTo( stream, ",", ncols, used, false );
      fi;
      if IsBound( chars[j] ) then
        if IsString( chars[j] ) then
          PrintTo( stream, chars[j] );            # strip the `"'
          used:= Length( chars[j] );
        else
          used:= BlanklessPrintTo( stream, chars[j], ncols, used, false );
        fi;
      fi;
    od;
    return BlanklessPrintTo( stream, "]", ncols, used, false );
    end;


#############################################################################
##
#F  CTblLib.StringOfProjectivesInfo( <projinfo>, <name> )
##
CTblLib.StringOfProjectivesInfo:= function( projinfo, name )
    local ncols, string, stream, used, j;

    ncols:= 78;
    string:= "";
    stream:= OutputTextString( string, true );
    SetPrintFormattingStatus( stream, false );
    used:= BlanklessPrintTo( stream,
               Concatenation( "ARC(\"", name,
                              "\",\"projectives\",[" ),
               ncols, 0, false );
    for j in projinfo do
      used:= BlanklessPrintTo( stream,
                 Concatenation( "\"", j.name, "\"," ), ncols, used, false );
      used:= CTblLib.AppendSpecial( stream, ncols,
                 ShrinkChars( EvalChars( j.chars ) ), used );
      used:= BlanklessPrintTo( stream, ",", ncols, used, false );
    od;
    BlanklessPrintTo( stream, "]);", ncols, used, false );
    PrintTo( stream, "\n" );

    # Return the string.
    CloseStream( stream );
    return string;
    end;


#############################################################################
##
#F  CTblLib.StringOrdinary( <tbl> )
#F  CTblLib.StringBrauer( <tbl> )
#F  PrintToLib( <file>, <tbl> )
##
CTblLib.StringOrdinary:= function( tbl )
    local ncols,
          used,
          string,
          stream,
          i, j,
          name,
          powermap,
          primes,
          tblinfo,
          chars,
          fld,
          info,
          fus,
          names,
          linelen,
          done,
          val,
          libinfo,
          maxes,
          pos;

    ncols:= 78;
    string:= "";
    stream:= OutputTextString( string, true );
    SetPrintFormattingStatus( stream, false );

    name:= Identifier( tbl );

    # Step 1:  Do the preparatory work, i.e.,
    #          shrink the Clifford records and remove the irreducibles,
    #          compute missing irreducibles, power maps, and table
    #          automorphisms if an underlying group is stored.
    if     IsLibraryCharacterTableRep( tbl )
       and HasConstructionInfoCharacterTable( tbl )
       and IsList( ConstructionInfoCharacterTable( tbl ) )
       and ConstructionInfoCharacterTable( tbl )[1] = "ConstructClifford" then
      if HasIrr( tbl ) then
Error( "handling of Clifford tables not yet installed!" );
        ShrinkClifford( tbl );
      fi;
    elif HasUnderlyingGroup( tbl ) then
      Irr( tbl );
      for i in PrimeDivisors( Size( tbl ) ) do
        PowerMap( tbl, i );
      od;
      AutomorphismsOfTable( tbl );
    fi;

    # Step 2:  Print the compulsory components.
    PrintTo( stream, Concatenation( "MOT(\"", name, "\",\n" ) );

    if HasInfoText( tbl ) then
      PrintTo( stream, TextString( InfoText( tbl ) ), ",\n" );
    else
      PrintTo( stream, "0,\n" );
    fi;

    if HasSizesCentralizers( tbl ) or HasSizesConjugacyClasses( tbl ) then
      used:= BlanklessPrintTo( stream, SizesCentralizers( tbl ), ncols, 0,
                               false );
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
    else
      PrintTo( stream, "0,\n" );
    fi;

    if     HasComputedPowerMaps( tbl )
       and 1 < Length( ComputedPowerMaps( tbl ) ) then
      powermap:= ShallowCopy( ComputedPowerMaps( tbl ) );
      if IsBound( powermap[1] ) then
        Unbind( powermap[1] );
      fi;
      if HasIrr( tbl ) then
        primes:= PrimeDivisors( Size( tbl ) );
        for i in [ 2 .. Length( powermap ) ] do
          if IsBound( powermap[i] ) and not i in primes then
            Unbind( powermap[i] );
          fi;
        od;
      fi;
      used:= BlanklessPrintTo( stream, powermap, ncols, 0, false );
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
    else
      PrintTo( stream, "0,\n" );
    fi;

    if HasIrr( tbl ) then
      used:= CTblLib.AppendSpecial( stream, ncols, ShrinkChars( Irr( tbl ) ), 0 );
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
    else
      PrintTo( stream, "0,\n" );
    fi;

    if HasAutomorphismsOfTable( tbl ) then
      used:= BlanklessPrintTo( stream,
                  Filtered( GeneratorsOfGroup( AutomorphismsOfTable( tbl ) ),
                            p -> not IsOne( p ) ),
                  ncols, 0, false );
    else
      PrintTo( stream, "0" );
      used:= 1;
    fi;

    if     IsLibraryCharacterTableRep( tbl )
       and HasConstructionInfoCharacterTable( tbl ) then
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
      if IsFunction( ConstructionInfoCharacterTable( tbl ) ) then
        used:= BlanklessPrintTo( stream,
                   ConstructionInfoCharacterTable( tbl ), ncols, 0,
                   false );
      else
        used:= BlanklessPrintTo( stream,
                   ConstructionInfoCharacterTable( tbl ), ncols, 0,
                   false );
#T is this meaningful?
      fi;
    fi;
    BlanklessPrintTo( stream, ");", ncols, used, false );
    PrintTo( stream, "\n" );

    # Step 3:  Print the optional components.

    # Print the representative orders only if they are not redundant.
    if HasOrdersClassRepresentatives( tbl ) and
       ( IsEmpty( ComputedPowerMaps( tbl ) )
         or OrdersClassRepresentatives( tbl )
           <> ElementOrdersPowerMap( ComputedPowerMaps( tbl ) ) ) then

      used:= BlanklessPrintTo( stream,
                 Concatenation( "ARC(\"", name,
                                "\",\"OrdersClassRepresentatives\"," ),
                ncols, 0, false );
      used:= BlanklessPrintTo( stream,
                 OrdersClassRepresentatives( tbl ), ncols, used, false );
      BlanklessPrintTo( stream, ");\n", ncols, used, false );

    fi;

    # Shrink and print the projectives.
    if HasProjectivesInfo( tbl ) then
      PrintTo( stream,
          CTblLib.StringOfProjectivesInfo( ProjectivesInfo( tbl ), name ) );
    fi;

    # Print remaining supported components of library tables.
    for fld in SupportedLibraryTableComponents do
#T CTblLib.StringOrdinary also for ``tables with group'' !!
      if IsBound( tbl!.( fld ) ) then
        used:= BlanklessPrintTo( stream,
                   Concatenation( "ARC(\"", name, "\",\"", fld, "\"," ),
                   ncols, 0, false );
        used:= BlanklessPrintTo( stream, tbl!.( fld ), ncols, used, true );
        BlanklessPrintTo( stream, ");" , ncols, used, false );
        PrintTo( stream, "\n" );
      fi;
    od;

    # Print remaining supported attributes of ordinary tables.
    done:= [
             "AutomorphismsOfTable",
             "ComputedClassFusions",
             "ComputedPowerMaps",
             "ConjugacyClasses",
             "ConstructionInfoCharacterTable",
             "ExtensionInfoCharacterTable",
             "FusionToTom",
             "IdentificationOfConjugacyClasses",
             "Identifier",
             "InfoText",
             "Irr",
             "IsPerfectCharacterTable",
             "IsSimpleCharacterTable",
             "IsSolvableCharacterTable",
             "NamesOfFusionSources",
             "NrConjugacyClasses",
             "OrdersClassRepresentatives",
             "ProjectivesInfo",
             "SizesCentralizers",
             "SizesConjugacyClasses",
             "UnderlyingCharacteristic",
             "UnderlyingGroup",
             ];
    if HasSizesCentralizers( tbl ) then
      Add( done, "Size" );
    fi;

    for i in [ 3, 6 .. Length( SupportedCharacterTableInfo ) ] do
      fld:= SupportedCharacterTableInfo[ i-1 ];
      if     not fld in done
         and Tester( SupportedCharacterTableInfo[ i-2 ] )( tbl ) then
        val:= SupportedCharacterTableInfo[ i-2 ]( tbl );

        # Omit empty lists, for example in the case `ComputedPrimeBlockss'.
        if not IsList( val ) or not IsEmpty( val ) then
          used:= BlanklessPrintTo( stream,
                     Concatenation( "ARC(\"", name, "\",\"", fld, "\"," ),
                     ncols, 0, false );
          used:= BlanklessPrintTo( stream,
                     val,
                     ncols, used, true );
          BlanklessPrintTo( stream, ");" , ncols, used, false );
          PrintTo( stream, "\n" );
        fi;

      fi;
    od;
    if     HasIsSimpleCharacterTable( tbl )
       and IsSimpleCharacterTable( tbl ) then
      BlanklessPrintTo( stream,
          Concatenation( "ARC(\"", name, "\",\"isSimple\",true);\n" ),
          ncols, 0, false );
    fi;
    if HasExtensionInfoCharacterTable( tbl ) then
      BlanklessPrintTo( stream,
          Concatenation( "ARC(\"", name, "\",\"extInfo\",[\"",
                         String( ExtensionInfoCharacterTable( tbl )[1] ),
                         "\",\"",
                         String( ExtensionInfoCharacterTable( tbl )[2] ),
                         "\"]);\n" ),
          ncols, 0, false );
    fi;

    if  HasFusionToTom( tbl ) then
      PrintTo( stream, LibraryFusionTblToTom( tbl, FusionToTom( tbl ) ) );
    fi;

    # Add the fusion assignments
    # (first the factor fusions, then the subgroup fusions).
    for fus in Filtered( ComputedClassFusions( tbl ),
                   r -> Length( ClassPositionsOfKernel( r.map ) ) > 1 ) do
      PrintTo( stream, LibraryFusion( name, fus ) );
    od;
    for fus in Filtered( ComputedClassFusions( tbl ),
                   r -> Length( ClassPositionsOfKernel( r.map ) ) = 1 ) do
      PrintTo( stream, LibraryFusion( name, fus ) );
    od;

    # Write the names information to the file.
    libinfo:= LibInfoCharacterTable( name );
    if libinfo <> fail then
      names:= [];
#T       if IsBound( libinfo.othernames ) then
#T         Append( names, libinfo.othernames );
#T       fi;
#T       if IsBound( libinfo.CASnames ) then
#T         Append( names, libinfo.CASnames );
#T       fi;
#T get the other names from somewhere ...
      if not IsEmpty( names ) then
        used:= BlanklessPrintTo( stream,
                   Concatenation( "ALN(\"", name, "\",[" ), ncols, 0, false );
        for i in [ 1 .. Length( names )-1 ] do
          used:= BlanklessPrintTo( stream,
                     Concatenation( "\"", names[i], "\"," ), ncols, used, false );
        od;
        BlanklessPrintTo( stream,
            Concatenation( "\"", names[ Length( names ) ], "\"]);" ),
            ncols, used, false );
        PrintTo( stream, "\n" );
      fi;
    fi;
    PrintTo( stream, "\n" );

    # Return the string.
    CloseStream( stream );
    return string;
    end;

CTblLib.StringBrauer:= function( tbl )
    local ordtbl,
          ordname,
          prime,
          info,
          factorblocks,
          block,
          offset,
          defect,
          basicset,
          brauertree,
          decinv,
          i,
          decmat,
          lic,
          pos,
          automorphisms,
          indicator,
          ncols,
          string,
          stream,
          used,
          additional;

    ordtbl:= OrdinaryCharacterTable( tbl );
    ordname:= Identifier( ordtbl );
    prime:= UnderlyingCharacteristic( tbl );

    # Fetch the blocks info.
    info:= BlocksInfo( tbl );

    # Check whether tables of factors groups are available
    # that allow one to omit some of the blocks.
    factorblocks:= CTblLib.ConsiderFactorBlocks( tbl );

    # `block' component (position 4)
    block:= InverseMap( List( info, r -> r.modchars ) );

    # factor blocks (pos. 9)
    offset:= 0;
    if IsBound( factorblocks.info ) then
      offset:= factorblocks.offset;
      info:= info{ [ offset + 1 .. Length( info ) ] };
      block:= Filtered( block, x -> offset < x );
      factorblocks:= factorblocks.info;
    else
      factorblocks:= 0;
    fi;

    # `defect' component (position 5)
    defect:= List( info, r -> r.defect );

    # `basicset' component (position 6)
    # `brauertree' component (position 7)
    # `decinv' component (position 8)
    basicset:= [];
    brauertree:= [];
    decinv:= [];
    for i in [ 1 .. Length( info ) ] do
      if info[i].defect = 1 then

        brauertree[i]:= BrauerTree( DecompositionMatrix( tbl, i + offset ) );

        # Replace multiple occurrences of a tree by an index.
        pos:= Position( brauertree, brauertree[i] );
        if pos < i then
          brauertree[i]:= pos;
        fi;

      elif info[i].defect > 1 then

        if IsBound( info[i].basicset ) and IsBound( info[i].decinv ) then
          basicset[i]:= info[i].basicset;
          decinv[i]:= info[i].decinv;
        else
          decmat:= DecompositionMatrix( tbl, i + offset );
          lic:= CTblLib.BasicSet( decmat );
          basicset[i]:= info[i].ordchars{ lic };
          decinv[i]:= Inverse( decmat{ lic } );
        fi;

        # Replace multiple occurrences of a matrix by an index.
        pos:= Position( decinv, decinv[i] );
        if pos < i then
          decinv[i]:= pos;
        fi;

      fi;
    od;

    # automorphisms (pos. 10)
    if HasAutomorphismsOfTable( tbl ) then
      automorphisms:= GeneratorsOfGroup( AutomorphismsOfTable( tbl ) );
    else
      automorphisms:= 0;
    fi;

    # indicator (pos. 11)
    if prime = 2 and IsBound( ComputedIndicators( tbl )[2] ) then
      indicator:= ComputedIndicators( tbl )[2];
    else
      indicator:= 0;
    fi;

    # Create the output stream.
    ncols:= 78;
    string:= "";
    stream:= OutputTextString( string, true );
    SetPrintFormattingStatus( stream, false );

    # Print the header (positions 1, 2).
    PrintTo( stream, "MBT(\"", ordname, "\",", prime, ",\n" );

    # `InfoText' (pos. 3)
    if not HasInfoText( tbl ) then
      PrintTo( stream, "\"(no info text)\"" );
    elif InfoText( tbl ) =
         "origin: modular ATLAS of finite groups, tests: DEC, TENS" then
      PrintTo( stream, "TEXT1" );
    else
      PrintTo( stream, TextString( InfoText( tbl ) ) );
    fi;
    PrintTo( stream, ",\n" );

    # Print the other components.
    for i in [ block, defect, basicset, brauertree, decinv,
               factorblocks, automorphisms ] do
      used:= BlanklessPrintTo( stream, i, ncols, 0, false );
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
    od;
    used:= BlanklessPrintTo( stream, indicator, ncols, 0, false );

    additional:= [ "version", "date", "ClassInfo", "RootDatumInfo" ];
    if ForAny( additional, nam -> IsBound( tbl!.( nam ) ) ) then
      BlanklessPrintTo( stream, ",", ncols, used, false );
      PrintTo( stream, "\n" );
      used:= BlanklessPrintTo( stream, "rec(", ncols, 0, false );
      for i in additional do
        if IsBound( tbl!.( i ) ) then
          used:= BlanklessPrintTo( stream, i, ncols, used, false );
          used:= BlanklessPrintTo( stream, ":=", ncols, used, false );
          used:= BlanklessPrintTo( stream, tbl!.( i ), ncols, used, false );
          BlanklessPrintTo( stream, ",", ncols, used, false );
          PrintTo( stream, "\n" );
          used:= 0;
        fi;
      od;
      PrintTo( stream, ")" );
      used:= 1;
    fi;

    # Complete the function call.
    BlanklessPrintTo( stream, ");", ncols, used, false );
    PrintTo( stream, "\n\n" );

    # Close the stream.
    CloseStream( stream );
    return string;
    end;

InstallGlobalFunction( PrintToLib, function( file, tbl )
    local string, oldsize;

    if not ( IsString( file ) and IsCharacterTable( tbl ) ) then
      Error( "usage: PrintToLib( <file>, <tbl> ) for string <file>\n",
             "and char. table <tbl>" );
    fi;

    if    Length( file ) <= 3
       or file{ [ Length( file ) - 3 .. Length( file ) ] } <> ".tbl" then
      file:= Concatenation( file, ".tbl" );
    fi;

    if IsOrdinaryTable( tbl ) then
      string:= CTblLib.StringOrdinary( tbl );
    elif IsBrauerTable( tbl ) then
      string:= CTblLib.StringBrauer( tbl );
    fi;

    oldsize:= SizeScreen();
    SizeScreen( [ 80 ] );
    AppendTo( file, string );
    SizeScreen( oldsize );
end );


#T #############################################################################
#T ##
#T #F  PrintClmsToLib( <file>, <clms> )
#T ##
#T InstallGlobalFunction( PrintClmsToLib, function( filename, clms )
#T 
#T     local  ind, i, il, lclms, clm, size,
#T         l,               # clmname
#T         clmlist,         # list of cliffordmatrices in the library
#T         lname,           # name of the file in the library
#T         ir,              # the internal record used here of the library
#T         found;           # whether the clm is already in the library
#T 
#T     if not( IsCliffordTable( clms ) or
#T             IsList( clms ) and ForAll( clms, x-> IsBound( x.mat ) and
#T                           IsBound( x.colw ) ) )  then
#T         Error( "usage: PrintClmsToLib( <file>, <clms> ) for a list ",
#T                "of cliffordrecords or a cliffordtable " );
#T     fi;
#T 
#T     if IsList( clms ) then lclms := Length( clms );
#T     else                   lclms := clms.size;
#T     fi;
#T 
#T     ir := [];
#T     for ind in [1..lclms] do
#T         if IsList( clms ) then clm := clms[ind];
#T         else       clm := clms.(ind);
#T         fi;
#T 
#T         size := 0;
#T         if IsBound( clm.mat )  then size := Length( clm.mat[1] ); fi;
#T 
#T         if size = 0  then
#T             Print("#I PrintClmsToLib: no <mat> and <colw>. Nothing done.\n");
#T         elif  size > 2  then
#T             if IsBound( clm.splitinfos )  then
#T               lname := "exsp";
#T             else
#T               lname := "elab";
#T             fi;
#T             l := Concatenation( lname, String( size ));
#T 
#T             clmlist := LibraryTables( Concatenation( "clm", lname ) );
#T             found := false;
#T             if IsBound( clmlist.(l) ) then
#T                 i := 0;
#T                 il := Length( clmlist.(l) );
#T                 while ( not found and i < il ) do
#T                     i := i+1;
#T                     found := clmlist.(l)[i][1] = clm.mat
#T                          and clmlist.(l)[i][2] = clm.colw;
#T                 od;
#T             fi;
#T             if not found and IsBound( ir[size] ) then
#T                 i := 0;
#T                 il := Length( ir[size] );
#T                 while ( not found and i < il ) do
#T                     i := i+1;
#T                     found := ir[size][i][1] = clm.mat
#T                          and ir[size][i][2] = clm.colw;
#T                 od;
#T             fi;
#T 
#T             if not found then
#T                 if IsBound( ir[size] )  then
#T                   ir[size][Length( ir[size] )+1] :=
#T                                          [clm.mat, clm.colw];
#T                 else
#T                   ir[size] := [ [clm.mat, clm.colw] ];
#T                 fi;
#T             else
#T                 Print( "#I PrintClmsToLib: Matrix ", ind,
#T                        " already in library or in ", filename, ".\n" );
#T             fi;
#T         fi;
#T     od;
#T 
#T     PrintTo( filename, ir, "\n" );
#T 
#T     return;
#T end );


#############################################################################
##
#F  OrbitsResidueClass( <pq>, <set> )
##
InstallGlobalFunction( OrbitsResidueClass, function( pq, set )
    local gen, orbs, pnt, orb, i;

    if Length( pq ) = 2 then
      # `pq' is a pair `[ <p>, <q> ]' where <p> is an odd prime power;
      # take a residue class mod <p> of order <q>.
      gen:= PowerModInt( PrimitiveRootMod( pq[1] ), Phi( pq[1] ) / pq[2],
                pq[1] );
    else
      # We know that <k> has order <q> modulo <p>.
      # `pq' is a triple `[ <p>, <q>, <k> ]' where <k> has order <q> modulo
      # <p> and acts semiregularly on the nonidentity residue classes mod <p>.
      gen:= pq[3];
    fi;

    orbs:= [];
    while not IsEmpty( set ) do
      pnt:= set[1];
      orb:= [];
      for i in [ 1 .. pq[2] ] do
        orb[i]:= pnt;
        pnt:= ( pnt * gen ) mod pq[1];
      od;
      Add( orbs, orb );
      SubtractSet( set, orb );
    od;
    return orbs;
end );


#############################################################################
##
#M  GroupInfoForCharacterTable( <tbl> )
##
InstallMethod( GroupInfoForCharacterTable,
    [ "IsOrdinaryTable and IsLibraryCharacterTableRep" ],
    tbl -> GroupInfoForCharacterTable( Identifier( tbl ) ) );

InstallOtherMethod( GroupInfoForCharacterTable,
    [ "IsString" ],
    function( id )
    local result, name, attr, val, generic, i, bad, good, other;

    if Length( CTblLib.Data.IdEnumerator.identifiers ) = 0 then
      Info( InfoWarning, 1,
            "the data for 'GroupInfoForCharacterTable' are not available" );
      return [];
    fi;

    # Replace the name by the identifier if applicable.
    id:= LibInfoCharacterTable( id );
    if id = fail then
      return [];
    fi;
    id:= id.firstName;

    result:= [];

    for name in CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable do
      if id in CTblLib.Data.IdEnumerator.identifiers then
        attr:= CTblLib.Data.IdEnumerator.attributes.( name );
      else
        attr:= CTblLib.Data.IdEnumeratorExt.attributes.( name );
      fi;
      val:= attr.attributeValue( attr, id );
      if name = "factorsOfDirectProduct" then
        # Add only pairs of those factors that know group info.
        generic:= [ "Cyclic", "Alternating", "Symmetric", "Dihedral" ];
        val:= Filtered( val,
                info -> info[2] <> "fail" and
                  ForAll( info[2], l -> l[1] in generic or
                    ( Length( l ) = 1 and not IsEmpty(
                          GroupInfoForCharacterTable( l[1] ) ) ) ) );
      elif name = "indiv" then
        val:= ShallowCopy( val );
        for i in [ 1 .. Length( val ) ] do
          if val[i][1] in [ "IndividualGroupConstruction",
                            "FactorGroupOfPerfectSpaceGroup" ] then
            # Show only what is needed to find the construction;
            # the function in question will fetch the data.
            val[i]:= [ Concatenation( "CTblLib.", val[i][1] ), [ id ] ];
          fi;
        od;
      fi;
      Append( result, val );
    od;

    Sort( result );
    if ValueOption( "sort" ) <> fail then
      # Use a heuristic to get reasonable constructions first.
      # Note that for example "47:23" has '[ "AtlasSubgroup", [ "B", 30 ] ]'
      # alphabetically first.
      # Thus move 'AtlasSubgroup' to the end, and 'SmallGroup' to the start.
      bad:= Filtered( result, x -> x[1] = "AtlasSubgroup" );
      good:= Filtered( result, x -> x[1] = "SmallGroup" );
      other:= Filtered( result, x -> not ( x in bad or x in good ) );
      result:= Concatenation( good, other, bad );
    fi;

    return result;
    end );


#############################################################################
##
#M  KnowsSomeGroupInfo( <tbl> )
##
InstallMethod( KnowsSomeGroupInfo,
    [ "IsOrdinaryTable" ],
    tbl -> not IsEmpty( GroupInfoForCharacterTable( tbl ) ) );


#############################################################################
##
#F  CharacterTableForGroupInfo( <info> )
##
InstallGlobalFunction( CharacterTableForGroupInfo, function( info )
    local name, attr, value;

    if not ( IsDenseList( info ) and Length( info ) = 2 ) then
      Error( "<info> must be a list of length two" );
    elif not IsString( info[1] ) then
      Error( "<info>[1] must be a string" );
    elif not IsList( info[2] ) then
      Error( "<info>[2] must be the list of arguments of <info>[1]" );
    fi;

    for name in RecNames( CTblLib.Data.IdEnumerator.attributes ) do
      attr:= CTblLib.Data.IdEnumerator.attributes.( name );
      if attr.identifier = "indiv" and info[1] in [
         "CTblLib.IndividualGroupConstruction",
         "CTblLib.FactorGroupOfPerfectSpaceGroup" ] then
        return CharacterTable( info[2][1] );
      elif attr.identifier in
             CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable
         and IsBound( attr.reverseEval ) then
        value:= attr.reverseEval( attr, info );
        if value <> fail then
          return CharacterTable( value );
        fi;
      fi;
    od;

    return fail;
    end );


#############################################################################
##
#F  GroupForGroupInfo( <info> )
##
InstallGlobalFunction( GroupForGroupInfo, function( info )
    local factors, genericnam, genericfun, entry, pos, grp, ginfo, func;

    if not ( IsDenseList( info )
             and Length( info ) = 2 and IsString( info[1] )
             and IsList( info[2] ) and not IsEmpty( info[2] ) ) then
      return fail;
    elif info[1] = "DirectProductByNames" then
      # Delegate to the factors.
      factors:= [];
      genericnam:= [ "Cyclic", "Alternating", "Symmetric", "Dihedral" ];
      genericfun:= [ CyclicGroup, AlternatingGroup, SymmetricGroup,
                     DihedralGroup ];
      for entry in info[2] do
        if Length( entry ) = 2 and IsPosInt( entry[2] ) then
          pos:= Position( genericnam, entry[1] );
          if pos = fail then
            return fail;
          fi;
          Add( factors, genericfun[ pos ]( entry[2] ) );
        elif Length( entry ) = 1 then
          grp:= fail;
          for ginfo in GroupInfoForCharacterTable( entry[1] : sort:= true ) do
            grp:= GroupForGroupInfo( ginfo );
            if IsGroup( grp ) then
              Add( factors, grp );
              break;
            fi;
          od;
          if grp = fail then
            return fail;
          fi;
        else
          return fail;
        fi;
      od;
      if Length( factors ) < 2 then
        return fail;
      fi;

      # Choose factors that fit together.
      if   IsPermGroup( factors[1] ) and IsPcGroup( factors[2] ) then
        factors[2]:= Image( IsomorphismPermGroup( factors[2] ) );
      elif IsPcGroup( factors[1] ) and IsPermGroup( factors[2] ) then
        factors[1]:= Image( IsomorphismPermGroup( factors[1] ) );
      fi;

      return CallFuncList( DirectProduct, factors );
    elif info[1] = "PerfectGroup" then
      # Create a permutation group not a f.p. group.
      return PerfectGroup( IsPermGroup, info[2][1], info[2][2] );
    elif info[1] = "Aut" then
      # Create the automorphism group of another group.
      for entry in GroupInfoForCharacterTable( info[2][1] : sort:= true ) do
        grp:= GroupForGroupInfo( entry );
        if grp <> fail then
          return AutomorphismGroup( grp );
        fi;
      od;
      return fail;
    elif info[1] = "AGL" then
      # There is no function 'AGL' in GAP (yet).
      info:= ShallowCopy( info );
      info[1]:= "CTblLib.AGL";
    fi;

    pos:= Position( info[1], '.' );
    if pos = fail then
      func:= info[1];
      if not IsBoundGlobal( func ) then
        return fail;
      fi;
      func:= ValueGlobal( func );
    else
      func:= info[1]{ [ 1 .. pos - 1 ] };
      if not IsBoundGlobal( func ) then
        return fail;
      fi;
      func:= ValueGlobal( func );
      if not IsRecord( func ) then
        return fail;
      fi;
      func:= func.( info[1]{ [ pos + 1 .. Length( info[1] ) ] } );
    fi;

    if not IsFunction( func ) then
      return fail;
    fi;

    return CallFuncList( func, info[2] );
    end );


#############################################################################
##
#F  GroupForTom( <tomidentifier>[, <repnr>] )
##
InstallGlobalFunction( GroupForTom, function( arg )
    local tom;

    if   Length( arg ) = 1 and IsString( arg[1] ) then
      tom:= TableOfMarks( arg[1] );
      if tom <> fail and HasUnderlyingGroup( tom ) then
        return UnderlyingGroup( tom );
      fi;
    elif Length( arg ) = 2 and IsString( arg[1] ) and IsPosInt( arg[2] ) then
      tom:= TableOfMarks( arg[1] );
      if tom <> fail and IsTableOfMarksWithGens( tom ) then
        return RepresentativeTom( tom, arg[2] );
      fi;
    fi;

    return fail;
    end );


#############################################################################
##
#F  AtlasStabilizer( <gapname>, <repname> )
##
InstallGlobalFunction( AtlasStabilizer, function( gapname, repname )
    local fun, info, g;

    if not IsBoundGlobal( "AllAtlasGeneratingSetInfos" ) then
      return fail;
    fi;
    fun:= ValueGlobal( "AllAtlasGeneratingSetInfos" );
    info:= First( fun( gapname, IsTransitive, true ),
                  r -> r.repname = repname );
    if info = fail then
      return fail;
    fi;
    g:= ValueGlobal( "AtlasGroup" )( info );
    if g = fail then
      return fail;
    fi;

    return Stabilizer( g, info.p );
    end );


#############################################################################
##
#M  IsAtlasCharacterTable( <tbl> )
##
InstallMethod( IsAtlasCharacterTable,
    [ "IsOrdinaryTable" ],
    tbl -> PositionSublist( InfoText( tbl ),
                            "origin: ATLAS of finite groups" ) <> fail );

InstallMethod( IsAtlasCharacterTable,
    [ "IsBrauerTable" ],
    tbl -> IsAtlasCharacterTable( OrdinaryCharacterTable( tbl ) ) );


#############################################################################
##
#M  IsNontrivialDirectProduct( <tbl> )
##
InstallMethod( IsNontrivialDirectProduct,
    [ "IsOrdinaryTable" ],
    tbl -> not IsEmpty( ClassPositionsOfDirectProductDecompositions(
                            tbl ) ) );


#############################################################################
##
#M  KnowsDeligneLusztigNames( <tbl> )
##
InstallMethod( KnowsDeligneLusztigNames,
    [ "IsOrdinaryTable" ],
    tbl -> DeltigLibGetRecord( Identifier( tbl ) ) <> fail );


#############################################################################
##
#M  IsDuplicateTable( <tbl> )
##
##  Perhaps it is not a good idea to force duplicate tables to be constructed
##  via `ConstructPermuted',
##  in the sense that there might be faster constructions.
##
InstallMethod( IsDuplicateTable,
    [ "IsOrdinaryTable" ],
    tbl -> IdentifierOfMainTable( tbl ) <> fail );


#############################################################################
##
#M  IdentifierOfMainTable( <tbl> )
##
InstallMethod( IdentifierOfMainTable,
    [ "IsOrdinaryTable" ],
    function( tbl )
    local result, info, n;

    result:= Identifier( tbl );

    if HasConstructionInfoCharacterTable( tbl ) then
      info:= ConstructionInfoCharacterTable( tbl );
      if IsList( info ) and info[1] = "ConstructPermuted" then
        info:= info[2];
        if Length( info ) = 1 then
          # permuted library table
          result:= info[1];
        elif Length( info ) = 2 then
          # perhaps one of the spinsym tables;
          # this code is needed because these tables are not declared as
          # permuted tables of library tables, and we *want* to regard them
          # as duplicates
          n:= info[2];
          if n in [ 2 .. 19 ] then
            if info[1] = "Alternating" then
              if n = 3 then
                result:= "C3";
              elif n = 4 then
                result:= "a4";
              elif n <> 2 then
                result:= Concatenation( "A", String( n ) );
              fi;
            elif info[1] = "Symmetric" then
              if n = 2 then
                result:= "C2";
              elif n = 3 then
                result:= "S3";
              elif n = 4 then
                result:= "s4";
              elif n = 6 then
                result:= "A6.2_1";
              else
                result:= Concatenation( "A", String( n ), ".2" );
              fi;
            elif info[1] = "DoubleCoverAlternating" then
              if n = 2 then
                result:= "C2";
              elif n = 3 then
                result:= "C6";
              elif n = 4 then
                result:= "2.L2(3)";
              elif 2 < n and n < 14 then
                result:= Concatenation( "2.A", String( n ) );
              fi;
            elif info[1] = "DoubleCoverSymmetric" then
              if n = 2 then
                result:= "C4";
              elif n = 3 then
                result:= "2.S3";
              elif n = 4 then
                result:= "2.Symm(4)";
              elif n = 6 then
                result:= "2.A6.2_1";
              elif n < 15 then
                result:= Concatenation( "Isoclinic(2.A", String( n ), ".2)" );
              fi;
            fi;
          fi;
        fi;
      fi;
    fi;

    if result = Identifier( tbl ) then
      return fail;
    else
      return result;
    fi;
    end );


#############################################################################
##
#M  IdentifiersOfDuplicateTables( <tbl> )
##
InstallMethod( IdentifiersOfDuplicateTables,
    [ "IsOrdinaryTable" ],
    tbl -> AllCharacterTableNames( IdentifierOfMainTable,
               Identifier( tbl ) ) );

InstallOtherMethod( IdentifiersOfDuplicateTables,
    [ "IsString" ],
    id -> AllCharacterTableNames( IdentifierOfMainTable, id ) );


#############################################################################
##
#V  CTblLib.NameReplacements
##
CTblLib.NameReplacements:= CallFuncList( function()
    local file, str;
    file:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                     "namerepl.json" );
    str:= StringFile( file );
    if str = fail then
      Error( "the data file '", file, "' is not available" );
    fi;
    return TransposedMat( EvalString( str ) );
    end, [] );


#############################################################################
##
#F  StructureDescriptionCharacterTableName( <name> )
##
InstallGlobalFunction( StructureDescriptionCharacterTableName,
    function( name )
    local parts, tbl, pos;

    parts:= PParseBackwards( name, [ IsChar, "M", IsDigitChar ] );
    if parts <> fail then
      # If the table has a `ConstructPermuted' description then
      # replace the name.
      tbl:= CharacterTable( name );
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        name:= ConstructionInfoCharacterTable( tbl )[2][1];
      fi;
    fi;

    # Replace {} by ().
    name:= ReplacedString( name, "{", "(" );
    name:= ReplacedString( name, "}", ")" );

    # Replace individual values.
    pos:= Position( CTblLib.NameReplacements[1], name );
    if pos <> fail then
      name:= CTblLib.NameReplacements[2][ pos ];
    fi;

    return name;
    end );


#############################################################################
##
#F  GaloisPartnersOfIrreducibles( <tbl>, <characters>, <n> )
##
##  Compute the Galois automorphism(s) carrying to the partner(s).
##
InstallGlobalFunction( GaloisPartnersOfIrreducibles,
    function( tbl, characters, n )
    local partners,  # list of partners, result
          chi,       # loop over `characters'
          N,         # conductor of `chi'
          k,         # list of values representing the partner cohorts
          facts,     # collected factors of `N'
          primes,    # prime factors of `N'
          2part,     # $2$-part of `N'
          3part,     # $3$-part of `N'
          NN,        # part of `N' that is coprime to $2$ and $3$
          kk,        # list with possible prime residues for each in `k'
          new,       # admissible subsets of `kk'
          p;         # characteristic in the case of a Brauer table

    if n < 3 then
      Error( "only for n >=3" );
    fi;

    partners:= [];

    for chi in characters do

      N:= Conductor( chi );

      # The rules of the ordinary Atlas apply for ordinary tables
      # and for Brauer characters for which all algebraic conjugates
      # are Brauer characters.
      if    IsOrdinaryTable( tbl )
         or (     IsBrauerTable( tbl )
              and ( n <> 12 or Identifier( tbl ) <> "12.M22mod11" )
#T is this reasonable?
              and ForAll( PrimeResidues( N ),
                    k -> List( chi,
                               x -> GaloisCyc( x, k ) ) in characters ) ) then

        if n <> 12 then
          k:= [ n - 1 ];
        else
          k:= [ 5, 7, 11 ];
        fi;
        facts:= Collected( Factors( N ) );
        primes:= List( facts, x -> x[1] );
        if 2 in primes then
          2part:= 2^facts[ Position( primes, 2 ) ][2];
        else
          2part:= 1;
        fi;
        if 3 in primes then
          3part:= 3^facts[ Position( primes, 3 ) ][2];
        else
          3part:= 1;
        fi;
        NN:= N / ( 2part * 3part );

        # The automorphism $*k^\prime$ that carries to the
        # partner in the cohort given by $*k$
        # is determined by the conditions that
        # $k^\prime \equiv k \pmod{n}$,
        # $k^\prime \equiv 1$ modulo each divisor of $N$ coprime to $n$,
        # $k^\prime \equiv \pm 1$ modulo powers of $2$ and $3$
        # dividing $n$,
        # where $+1$ is preferred if there is a choice.
        # (As an example, consider $N = 60$, $n = 3$, and $k = 2$
        # where $11$ and $41$ are possible solutions,
        # and the action on $20$-th roots of unity is different;
        # this occurs for the group $3.U_3(11)$.)
        # Note that we may have to replace $N$ by the l.c.m. of $N$
        # and $n$, for example if $n = 6$ and $N$ is odd.
        kk:= List( k, y -> Filtered( PrimeResidues( LcmInt( N, n ) ),
                                      x -> x mod NN in [ 0, 1 ]
                                  and x mod n = y
                                  and x mod 2part in [ 2part-1, 1 ]
                                  and x mod 3part in [ 3part-1, 1 ] ) );
        for k in [ 1 .. Length( kk ) ] do
          if Length( kk[k] ) = 1 then
            kk[k]:= kk[k][1];
          else
            if 2part <> 1 then
              new:= Filtered( kk[k], x -> x mod 2part = 1 );
              if Length( new ) <> 0 then
                kk[k]:= new;
              fi;
            fi;
            if Length( kk[k] ) > 1 and 3part <> 1 then
              new:= Filtered( kk[k], x -> x mod 3part = 1 );
              if Length( new ) <> 0 then
                kk[k]:= new;
              fi;
            fi;
            kk[k]:= kk[k][1];
          fi;
        od;

      else

        p:= UnderlyingCharacteristic( tbl );
        if n <> 12 then
          if ( p-1 ) mod n <> 0 then
            kk:= [ p ];
          else
            kk:= [ -1 ];
          fi;
        elif Identifier( tbl ) = "12.M22mod11" then
          kk:= [ -1 ];
        else
          kk:= [ p, -1, -p ];
        fi;

      fi;

      Add( partners, kk );

    od;

    return partners;
end );


#############################################################################
##
#F  AtlasLabelsOfIrreducibles( <tbl>[, <short>] )
##
InstallGlobalFunction( AtlasLabelsOfIrreducibles, function( arg )
    local tbl,        # first argument, an ATLAS character table
          short,      # optional second argument, choice of short labels
          ordtbl,     # ordinary table of `tbl'
          out,        # index of the derived subgroup
          centre,     # centre of the derived subgroup
          mult,       # order of `centre'
          nccl,       # no. of conjugacy classes of `tbl'
          charname,   # string "\\chi" or "\\varphi"
          der,        # table of the derived subgroup corresp. to `tbl'
          ordder,     # table of the derived subgroup corresp. to `ordtbl'
          pos,        # position in a list
          irr,        # list of irreducibles
          portions,   # list that separates characters with different kernel
          divisors,   # list of divisors of the multiplier
          i, j, k, l, # loop variables
          labels,     # list of labels, result
          portionlbs, # list of labels for one portion
          max,        # current maximal offset
          partners,   # output of `GaloisPartnersOfIrreducibles'
          special,    # list of special cases requiring offsets
          offsets,    # current offsets in special case
          fus,        # various fusion maps
          rest,       # list of restricted characters
          distrib,    # positions of restrictions in `rest'
          restchi,    # one restriction to the derived subgroup
          dec,        # decomposition matrix of restrictions
          derlabels,  # list of labels of the derived subgroup
          inv,        # inverse map of `distrib'
          dl,         # list of nonzero coefficients in a decomposition
          n,          # length of `dl'
          lb,         # one label
          intermed,   # list of intermediate tables
          index,      # index of an inertia subgroup
          fus1,       # fusion from derived subgroup to intermediate group
          fus2,       # fusion from intermediate group to group
          ext,        # positions of extensions of a character
          interirr;   # irreducibles of an intermediate table

    # Get the arguments.
    tbl:= arg[1];
    short:= Length( arg ) = 2 and ( arg[2] = "short" or arg[2] = true );

    # `tbl' is assumed to be the table of a bicyclic extension
    # of a simple group.
    # Get the index `out' of the derived subgroup
    # and the order `mult' of the centre of the derived subgroup.
    if IsBrauerTable( tbl ) then
      ordtbl:= OrdinaryCharacterTable( tbl );
    else
      ordtbl:= tbl;
    fi;
    out:= AbelianInvariants( ordtbl );
    if not IsSSortedList( out ) then
      Error( "<tbl> is not a bicyclic extension of a simple table" );
    fi;
    out:= Product( out, 1 );
    centre:= ClassPositionsOfFittingSubgroup( ordtbl );
    mult:= Sum( SizesConjugacyClasses( ordtbl ){ centre }, 0 );
    if 12 mod mult <> 0 then
      Error( "<tbl> is not a bicyclic extension of an ATLAS table" );
    fi;

    nccl:= NrConjugacyClasses( tbl );

    # Initializations for the final labels.
    if IsOrdinaryTable( tbl ) then
      charname:= "\\chi_{";
    else
      charname:= "\\varphi_{";
    fi;

    # Compute label descriptions for the derived subgroup.
    # (For tables of non-perfect groups,
    # the labels are formed relative to the labels of the
    # table of the derived subgroup,
    # so we need this table and its label descriptions.)
    if out = 1 then

      der:= tbl;
      ordder:= ordtbl;

    else

      ordder:= Identifier( ordtbl );
      pos:= Length( ordder );
      while IsDigitChar( ordder[ pos ] ) or ordder[ pos ] = '_' do
        pos:= pos - 1;
      od;
      if pos = Length( ordder ) or ordder[ pos ] <> '.' then
        Error( "derived subgroup table not given by identifier of <tbl>" );
      fi;
      ordder:= CharacterTable( ordder{ [ 1 .. pos-1 ] } );
      if ordder = fail then
        Info( InfoCharacterTable, 1 ,
              "no derived character table of ", Identifier( ordtbl ),
              " available" );
        return fail;
      fi;
      if IsBrauerTable( tbl ) then
        der:= BrauerTable( ordder, UnderlyingCharacteristic( tbl ) );
        if der = fail then
          Info( InfoCharacterTable, 1 ,
                "no ", UnderlyingCharacteristic( tbl ), "-modular ",
                "derived character table of ", Identifier( ordtbl ),
                " available" );
          return fail;
        fi;
      else
        der:= ordder;
      fi;

    fi;

    # `der' is the table of a central extension of a simple group.
    # Each label is encoded by an integer (the subscript)
    # or a list of length two (the pair of subscript and a Galois
    # automorphism).

    # Distribute the characters to different portions.
    irr:= List( Irr( der ), ValuesOfClassFunction );

    if mult <> 12 then
      divisors:= DivisorsInt( mult );
    else
      divisors:= [ 1, 2, 4, 3, 6, 12 ];
    fi;

    # The `i'-th portion consists of those characters with
    # conductor of the restriction to `centre' equal to `divisors[i]'.
    if IsBrauerTable( der ) then
      fus:= GetFusionMap( der, ordder );
      centre:= Filtered( [ 1 .. Length( fus ) ], i -> fus[i] in centre );
    fi;
    portions:= List( divisors,
                     i -> Filtered( [ 1 .. NrConjugacyClasses( der ) ],
                                j -> Conductor( irr[j]{ centre } ) = i ) );

    labels:= [];
    max:= 0;

    for i in [ 1 .. Length( portions ) ] do

      if divisors[i] < 3 then

        # The $i$-th label has index $i$.
        Append( labels, [ 1 .. Length( portions[i] ) ] + max );
        max:= Maximum( labels );

      else

        # Some of the characters are not printed in the {\ATLAS},
        # therefore the labels are more complicated.
        portionlbs:= [];

        # Compute the Galois automorphisms mapping the printed
        # characters to their partner(s).
        partners:= GaloisPartnersOfIrreducibles( der, irr{ portions[i] },
                                                 divisors[i] );

        for k in [ 1 .. Length( portions[i] ) ] do

          j:= portions[i][k];

          # Get the position(s) of the partner(s).
          pos:= List( partners[k],
                      x -> Position( irr,
                                     List( irr[j],
                                           y -> GaloisCyc( y, x ) ) ) );

          # Construct labels relative to the *first* character
          # of each set with the same proxy.
          if j < Minimum( pos ) then
            max:= max + 1;
            portionlbs[k]:= max;
            for l in [ 1 .. Length( pos ) ] do
              portionlbs[ Position( portions[i], pos[l] ) ]:=
                  [ max, partners[k][l] ];
            od;
          fi;

        od;

        Append( labels, portionlbs );

      fi;

    od;

    # Adjust the labels in the special cases
    # $A_6$, $A_7$, $L_3(4)$, $M_{22}$, $U_4(3)$, $O_7(3)$,
    # $U_6(2)$, $Suz$, $Fi_{22}$, and ${}^2E_6(2)$.
    # For these groups, $6$ divides the multiplier,
    # so at least $3.G$ needs an offset.
    special:= [
                "3.A6",           [  7,  6 ],
                "3.A6mod5",       [  5,  4 ],

                "3.A7",           [  9,  7 ],
                "3.A7mod5",       [  8,  6 ],
                "3.A7mod7",       [  7,  5 ],

                "3.L3(4)",        [ 10, 21 ],
                "4_2.L3(4)",      [ 18,  6 ],
                "6.L3(4)",        [ 18, 13 ],
                "12_1.L3(4)",     [ 24,  7 ],
                "12_2.L3(4)",     [ 41, 11, 18, 6 ],

                "4_2.L3(4)mod3",  [ 16,  5 ],
                "12_2.L3(4)mod3", [ 16,  5 ],

                "3.L3(4)mod5",    [  8, 15 ],
                "6.L3(4)mod5",    [ 14,  9 ],
                "12_1.L3(4)mod5", [ 18,  5 ],
                "12_2.L3(4)mod5", [ 31,  7, 14, 4 ],

                "3.L3(4)mod7",    [  8, 15 ],
                "6.L3(4)mod7",    [ 14,  9 ],
                "12_1.L3(4)mod7", [ 18,  5 ],
                "12_2.L3(4)mod7", [ 31,  7, 14, 4 ],

                "3.M22",          [ 12, 19 ],
                "6.M22",          [ 23,  8 ],

                "3.M22mod5",      [ 11, 10 ],
                "6.M22mod5",      [ 21,  7 ],

                "3.M22mod7",      [ 10,  9 ],
                "6.M22mod7",      [ 19,  6 ],

                "3_1.U4(3)",      [ 20, 35 ],
                "3_2.U4(3)",      [ 20, 78 ],
                "6_1.U4(3)",      [ 39, 16 ],
                "6_2.U4(3)",      [ 39, 59 ],
                "12_2.U4(3)",     [ 55, 43 ],

                "3_2.U4(3)mod2",  [ 12,  8 ],
                "6_2.U4(3)mod2",  [ 12,  8 ],
                "12_2.U4(3)mod2", [ 12,  8 ],

                "3_2.U4(3)mod5",  [ 19, 73 ],
                "6_2.U4(3)mod5",  [ 37, 55 ],
                "12_2.U4(3)mod5", [ 52, 40 ],

                "3_2.U4(3)mod7",  [ 18, 68 ],
                "6_2.U4(3)mod7",  [ 35, 51 ],
                "12_2.U4(3)mod7", [ 49, 37 ],

                "3.O7(3)",        [ 58, 30 ],
                "3.O7(3)mod5",    [ 53, 27 ],
                "3.O7(3)mod7",    [ 56, 28 ],
                "3.O7(3)mod13",   [ 56, 28 ],

                "3.Suz",          [ 43, 33 ],
                "3.Suzmod5",      [ 35, 26 ],
                "3.Suzmod7",      [ 39, 30 ],
                "3.Suzmod11",     [ 42, 32 ],
                "3.Suzmod13",     [ 41, 31 ],

                "3.Fi22",         [ 65, 49 ],
                "3.Fi22mod5",     [ 59, 43 ],
                "3.Fi22mod7",     [ 62, 46 ],
                "3.Fi22mod11",    [ 61, 45 ],
                "3.Fi22mod13",    [ 63, 47 ],

                "3.2E6(2)",       [ "?", "?" ],
                "3.2E6(2)mod5",   [ "?", "?" ],
                "3.2E6(2)mod7",   [ "?", "?" ],
                "3.2E6(2)mod11",  [ "?", "?" ],
                "3.2E6(2)mod13",  [ "?", "?" ],
                "3.2E6(2)mod17",  [ "?", "?" ],
                "3.2E6(2)mod19",  [ "?", "?" ],

                ];

    pos:= Position( special, Identifier( der ) );
    if pos <> fail then
      offsets:= special[ pos+1 ];
      for i in [ 1 .. Length( labels ) ] do
        if IsInt( labels[i] ) and labels[i] > offsets[1] then
          labels[i]:= labels[i] + offsets[2];
        elif IsList( labels[i] ) and labels[i][1] > offsets[1] then
          labels[i][1]:= labels[i][1] + offsets[2];
        elif Length( offsets ) > 2 then
          if IsInt( labels[i] ) and labels[i] > offsets[3] then
            labels[i]:= labels[i] + offsets[4];
          elif IsList( labels[i] ) and labels[i][1] > offsets[3] then
            labels[i][1]:= labels[i][1] + offsets[4];
          fi;
        fi;
      od;
    fi;

    if out = 1 then

      # Build the final labels from the subscripts.
      for i in [ 1 .. Length( labels ) ] do
        if IsInt( labels[i] ) then
          lb:= Concatenation( charname, String( labels[i] ), "}" );
        else
          lb:= Concatenation( charname, String( labels[i][1] ), "}^{\\ast" );
          k:= labels[i][2];
          if k < 0 then
            Append( lb, "\\ast" );
            k:= -k;
          fi;
          if k <> 1 then
            Append( lb, " " );
            Append( lb, String( k ) );
          fi;
          Append( lb, "}" );
        fi;
        labels[i]:= lb;
      od;

    else

      # Start with the labels for `der'.
      # They are of the form `i' (for $\chi_i$)
      # or `[ i, j ]' (for $\chi_i^{*j}$).
      derlabels:= labels;
      labels:= [];

      fus:= GetFusionMap( der, tbl );
      if fus = fail then
        Info( InfoCharacterTable, 1 ,
              "no fusion from ", der, " to ", tbl, " available" );
        return fail;
      fi;

      # `rest' is the list of the different restrictions of `irr'
      # to the derived subgroup.
      # `distrib[i]' is the position of the restriction of `irr[i]'
      # in `rest'.
      rest:= [];
      distrib:= [];
      irr:= List( Irr( tbl ), ValuesOfClassFunction );
      for i in [ 1 .. Length( irr ) ] do
        restchi:= irr[i]{ fus };
        pos:= Position( rest, restchi );
        if pos = fail then
          Add( rest, restchi );
          pos:= Length( rest );
        fi;
        distrib[i]:= pos;
      od;

      # Compute the decompositions of `rest' into irreducibles of `der'.
      dec:= Decomposition( List( Irr( der ), ValuesOfClassFunction ),
                           rest, "nonnegative" );

      # Store tables of intermediate groups if `out' is nonprime.
      intermed:= [];

      # Compute the labels of `irr'.
      # The number $n$ of different irreducibles of `der' contained in
      # a restriction divides `out'.
      # Let `outprime' be the $p^\prime$ part of `out'.
      # The following labels occur.
      # - If $n = 1$ then the labels are of the form
      #   $\chi_{i,k}$ and $\chi_{i,k}^{*j}$, respectively,
      #   where $0 \leq k < `outprime'$.
      # - If $n$ equals `out' then the labels are of the form
      #   $\chi_{i1+i2+...+iout}$ or
      #   $\chi_{i1* j1 + i2* j2 +...+ iout* jout}$ .
      # - In all other cases, `outprime' is either $4$ or $6$,
      #   and we need the intermediate tables.

      inv:= InverseMap( distrib );
      for i in [ 1 .. Length( rest ) ] do
        if IsInt( inv[i] ) then
          inv[i]:= [ inv[i] ];
        fi;
        dl:= Filtered( [ 1 .. Length( dec[i] ) ], j -> dec[i][j] <> 0 );
        n:= Length( dl );
        if n = 1 then
          # extension case
          for j in [ 1 .. Length( inv[i] ) ] do
            if IsInt( derlabels[ dl[1] ] ) then
              # extension
              labels[ inv[i][j] ]:= Concatenation( charname,
                                        String( derlabels[ dl[1] ] ), ",",
                                        String( j-1 ), "}" );
            else
              # conjugate of an extension
              lb:= Concatenation( charname, String( derlabels[ dl[1] ][1] ),
                       ",", String( j-1 ), "}^{\\ast" );
              k:= derlabels[ dl[1] ][2];
              if k < 0 then
                Append( lb, "\\ast" );
                k:= -k;
              fi;
              if k <> 1 then
                Append( lb, " " );
                Append( lb, String( k ) );
              fi;
              Append( lb, "}" );
              labels[ inv[i][j] ]:= lb;
            fi;
          od;
        elif n = out then
          # case of fusion
          if short then
            if ForAny( derlabels{ dl }, IsInt ) then
              lb:= Concatenation( charname,
                                  String( First( derlabels{ dl }, IsInt ) ),
                                  "+}" );
            else
              j:= derlabels[ dl[1] ];
              lb:= Concatenation( charname,
                                  String( j[1] ),
                                  "\\ast" );
              k:= j[2];
              if k < 0 then
                Append( lb, "\\ast" );
                k:= - k;
              fi;
              Append( lb, " " );
              if k <> 1 then
                Append( lb, String( k ) );
              fi;
              Append( lb, "+}" );
            fi;
          else
            lb:= ShallowCopy( charname );
            for j in derlabels{ dl } do
              if IsInt( j ) then
                Append( lb, Concatenation( String( j ), "+" ) );
              else
                Append( lb, String( j[1] ) );
                Append( lb, "\\ast" );
                k:= j[2];
                if k < 0 then
                  Append( lb, "\\ast" );
                  k:= -k;
                fi;
                Append( lb, " " );
                if k <> 1 then
                  Append( lb, String( k ) );
                fi;
                Append( lb, "+" );
              fi;
            od;
            lb[ Length( lb ) ]:= '}';
          fi;
          labels[ inv[i][1] ]:= lb;

        else

          # We have an intermediate group $U$ such that the characters
          # of the simple group extend to $U$ and the extensions of
          # different characters fuse in the full extension.
          # (In our cases, this intermediate group is uniquely determined
          # because `out' is either $4$ or $6$.)

          # The inertia subgroup has index `index'.
          index:= Length( dl );
          if not IsBound( intermed[ index ] ) then
            intermed[ index ]:= List( Filtered(
                ComputedClassFusions( ordder ),
                x -> x.name in NamesOfFusionSources( ordtbl ) ),
                    y -> CharacterTable( y.name ) );
            intermed[ index ]:= Filtered( intermed[ index ],
                 x -> Size( tbl ) / Size( x ) = index );
            if Length( intermed[ index ] ) > 1 then
              Error( "indermediate table of index ", index, " in ", ordtbl,
                     " not unique" );
            fi;
            intermed[ index ]:= intermed[ index ][1];
            if IsBrauerTable( der ) then
              intermed[ index ]:= BrauerTable( intermed[ index ],
                                         UnderlyingCharacteristic( der ) );
            fi;
          fi;
          interirr:= List( Irr( intermed[ index ] ),
                           ValuesOfClassFunction );
          fus1:= GetFusionMap( der, intermed[ index ] );
          fus2:= GetFusionMap( intermed[ index ], tbl );

          for j in inv[i] do

            # Construct the label string.
            if short then

              if ForAny( dl, x -> IsInt( derlabels[x] ) ) then

                l:= First( dl, x -> IsInt( derlabels[x] ) );

                # Get the extensions from `der' to the intermediate group.
                ext:= ValuesOfClassFunction( Irr( der )[l] );
                ext:= Filtered( [ 1 .. Length( interirr ) ],
                        x -> Irr( intermed[ index ] )[x]{ fus1 } = ext );

                # Count which extension occurs in the restriction from `tbl'
                # to the intermediate group.
                k:= Decomposition( interirr, [ irr[j]{ fus2 } ],
                                   "nonnegative" );
                k:= First( [ 1 .. Length( ext ) ],
                           x -> k[1][ ext[x] ] <> 0 );

                lb:= Concatenation( charname,
                                    String( derlabels[l] ),
                                    ",",
                                    String( k-1 ),
                                    "+}" );

              else

                l:= dl[1];

                # Get the extensions from `der' to the intermediate group.
                ext:= ValuesOfClassFunction( Irr( der )[l] );
                ext:= Filtered( [ 1 .. Length( interirr ) ],
                        x -> Irr( intermed[ index ] )[x]{ fus1 } = ext );

                # Count which extension occurs in the restriction from `tbl'
                # to the intermediate group.
                k:= Decomposition( interirr, [ irr[j]{ fus2 } ],
                                   "nonnegative" );
                k:= First( [ 1 .. Length( ext ) ],
                           x -> k[1][ ext[x] ] <> 0 );

                lb:= Concatenation( charname,
                                    String( derlabels[l][1] ),
                                    ",",
                                    String( k-1 ),
                                    "\\ast" );

                if derlabels[l][2] < 0 then
                  Append( lb, "\\ast" );
                  derlabels[l][2]:= -derlabels[l][2];
                fi;
                if derlabels[l][2] <> 1 then
                  Append( lb, " " );
                  Append( lb, String( derlabels[l][2] ) );
                fi;
                Append( lb, "+}" );

              fi;

            else

              lb:= ShallowCopy( charname );

              for l in dl do

                # Get the extensions from `der' to the intermediate group.
                ext:= ValuesOfClassFunction( Irr( der )[l] );
                ext:= Filtered( [ 1 .. Length( interirr ) ],
                        x -> Irr( intermed[ index ] )[x]{ fus1 } = ext );

                # Count which extension occurs in the restriction from `tbl'
                # to the intermediate group.
                k:= Decomposition( interirr, [ irr[j]{ fus2 } ],
                                   "nonnegative" );
                k:= First( [ 1 .. Length( ext ) ],
                           x -> k[1][ ext[x] ] <> 0 );

                if IsInt( derlabels[l] ) then
                  Append( lb, String( derlabels[l] ) );
                  Append( lb, "," );
                  Append( lb, String( k-1 ) );
                  Append( lb, "+" );
                else
                  Append( lb, String( derlabels[l][1] ) );
                  Append( lb, "," );
                  Append( lb, String( k-1 ) );
                  Append( lb, "\\ast" );
                  if derlabels[l][2] < 0 then
                    Append( lb, "\\ast" );
                    derlabels[l][2]:= -derlabels[l][2];
                  fi;
                  if derlabels[l][2] <> 1 then
                    Append( lb, String( derlabels[l][2] ) );
                  fi;
                  Append( lb, "+" );
                fi;

              od;

              lb[ Length( lb ) ]:= '}';

            fi;

            labels[j]:= lb;

          od;

        fi;
      od;

    fi;


    # Return the labels.
    return labels;
end );


#############################################################################
##
##  The rest of this file contains the interface between the GAP libraries
##  of character tables and of tables of marks.
##
##  The interface consists of methods for the operations `CharacterTable' and
##  `TableOfMarks', with argument a table of marks and a character table,
##  respectively.
##  These methods try to get the corresponding character table resp.~table of
##  marks from the library.
##
##  If the required information is not found in the respective library,
##  and if no group is available from which this information can be computed
##  then `fail' returned.
##
##  The availability of the required information is looked up in
##  `LIBLIST.TOM_TBL_INFO'.
##  This is a list of length two,
##  the first entry being the list of identifiers of tables of marks,
##  the second entry being the list of corresponding identifiers of library
##  character tables.
##
##  (If not both the library of character tables and the library of tables of
##  marks are installed then the entries in `LIBLIST.TOM_TBL_INFO' are empty
##  lists, hence the methods mentioned above become trivial.)
##


#############################################################################
##
#M  TableOfMarks( <tbl> ) . . . . . . . . . . . . . . . for a character table
#M  TableOfMarks( <G> )
##
##  We delegate from <tbl> to the underlying group in the general case.
##
##  If the argument is a group, we can use the known table of marks of the
##  known ordinary character table.
##
InstallOtherMethod( TableOfMarks,
    [ "IsCharacterTable and HasUnderlyingGroup" ],
    tbl -> TableOfMarks( UnderlyingGroup( tbl ) ) );


InstallOtherMethod( TableOfMarks,
    [ "IsGroup and HasOrdinaryCharacterTable" ], 100,
    function( G )
    local tbl;
    tbl:= OrdinaryCharacterTable( G );
    if HasTableOfMarks( tbl ) then
      return TableOfMarks( tbl );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  TableOfMarks( <tbl> ) . . . . . . . . . . . for a library character table
##
##  <#GAPDoc Label="TableOfMarks">
##  <ManSection>
##  <Meth Name="TableOfMarks" Arg="tbl"
##   Label="for a character table from the library"/>
##
##  <Description>
##  Let <A>tbl</A> be an ordinary character table from the
##  &GAP; Character Table Library,
##  for the group <M>G</M>, say.
##  If the <Package>TomLib</Package> package is loaded and contains the
##  table of marks of <M>G</M> then there is a method based on
##  <Ref Oper="TableOfMarks" Label="for a string" BookName="ref"/>
##  that returns this table of marks.
##  If there is no such table of marks but <A>tbl</A> knows its underlying
##  group then this method delegates to the group.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> TableOfMarks( CharacterTable( "A5" ) );
##  TableOfMarks( "A5" )
##  gap> TableOfMarks( CharacterTable( "M" ) );
##  fail
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallOtherMethod( TableOfMarks,
    [ "IsOrdinaryTable and IsLibraryCharacterTableRep" ],
    function( tbl )
    local pos;
    pos:= Position( LIBLIST.TOM_TBL_INFO[2],
                    LowercaseString( Identifier( tbl ) ) );
    if pos <> fail then
      return TableOfMarks( LIBLIST.TOM_TBL_INFO[1][ pos ] );
    elif HasUnderlyingGroup( tbl ) then
      TryNextMethod();
    fi;
    return fail;
    end );


#############################################################################
##
#M  CharacterTable( <G> )
##
##  If the argument is a group, we can use the known character table of the
##  known table of marks.
##
InstallOtherMethod( CharacterTable,
    [ "IsGroup and HasTableOfMarks" ], 100,
    function( G )
    local tom;
    tom:= TableOfMarks( G );
    if HasOrdinaryCharacterTable( tom ) then
      return OrdinaryCharacterTable( tom );
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#F  NameOfLibraryCharacterTable( <tomname> )
##
InstallGlobalFunction( NameOfLibraryCharacterTable, function( tomname )
    local pos;

    pos:= Position( LIBLIST.TOM_TBL_INFO[1], LowercaseString( tomname ) );
    if pos <> fail then
      pos:= LibInfoCharacterTable( LIBLIST.TOM_TBL_INFO[2][ pos ] );
      if IsRecord( pos ) then
        return pos.firstName;
      fi;
    fi;
    return fail;
    end );


#############################################################################
##
#F  CTblLib.SetAttributesForSpinSymTable( <firstname> )
##
##  The character tables with the identifiers '"Alt(<n>)"', '"2.Alt(<n>)"',
##  '"Sym(<n>)"', and '"2.Sym(<n>)"', for $1 \leq <n> \leq 19$,
##  are provided by the SpinSym package.
##  If the values of the attributes supported by 'CTblLib.Data.IdEnumerator'
##  are not set then calls of 'AllCharacterTableNames' will have to compute
##  these values and thus will be slow.
##  Moreover, several SpinSym tables are duplicates of tables from CTblLib,
##  so we have to notify at least this information.
##
CTblLib.SetAttributesForSpinSymTable:= function( spinsymname )
    local store_data, enum, attrs, enumext, attrsext, posext, n,
          An, Sn, 2An, 2Sn, libname, attr, pos, repl, str, values;

    # auxiliary function that adds data for `libname` either directly
    # to the attribute `dataname` or to a global variable tat gets evaluated
    # as soon as the underlying GAP package becomes available
    store_data:= function( libname, dataname )
      local nam, str, data, values;

      if libname = fail then
        return;
      fi;
      nam:= Concatenation( "Source_data_", dataname );
      if not IsBound( CTblLib.Data.( nam ) ) then
        str:= StringFile( Filename( DirectoriesPackageLibrary( "CTblLib",
                                        "data" ), 
                          Concatenation( "grp_", dataname, ".json" ) ) );
        CTblLib.Data.( nam ):= AGR.GapObjectOfJsonText( str ).value;
      fi;
      data:= CTblLib.Data.( nam ).automatic;
      values:= PositionSorted( data, [ libname ] );
      if not IsBound( data[ values ] ) then
        return;
      fi;
      values:= data[ values ];
      if values[1] <> libname then
        return;
      elif IsBound( attrsext.( dataname ) ) then
        Add( attrsext.( dataname ).data.automatic,
             [ spinsymname, values[2] ] );
      else
        # The data will be inserted in an extension file.
        nam:= Concatenation( "IdEnumeratorExt_attributes_", dataname,
                             "_data_automatic" );
        if not IsBound( CTblLib.( nam ) ) then
          CTblLib.( nam ):= [];
        fi;
        Add( CTblLib.( nam ), [ spinsymname, values[2] ] );
      fi;
    end;

    enum:= CTblLib.Data.IdEnumerator;
    if enum.identifiers = [] then
      # No attributes are available.
      return;
    fi;

    attrs:= enum.attributes;
    enumext:= CTblLib.Data.IdEnumeratorExt;
    attrsext:= enumext.attributes;

    posext:= Position( enumext.identifiers, spinsymname );
    n:= Int( spinsymname{ [ Position( spinsymname, '(' ) + 1
                            .. Length( spinsymname ) - 1 ] } );
    if n < 2 or 19 < n then
      return;
    fi;
    An:= ( spinsymname[1] = 'A' );
    Sn:= ( spinsymname[1] = 'S' );
    2An:= ( spinsymname[3] = 'A' );
    2Sn:= ( spinsymname[3] = 'S' );
    libname:= fail;
    if An then
      if n = 3 then
        libname:= "C3";
      elif n = 4 then
        libname:= "a4";
      elif n <> 2 then
        libname:= Concatenation( "A", String( n ) );
      fi;
    elif Sn then
      if n = 2 then
        libname:= "C2";
      elif n = 3 then
        libname:= "S3";
      elif n = 4 then
        libname:= "s4";
      elif n = 6 then
        libname:= "A6.2_1";
      else
        libname:= Concatenation( "A", String( n ), ".2" );
      fi;
    elif 2An then
      if n = 2 then
        libname:= "C2";
      elif n = 3 then
        libname:= "C6";
      elif n = 4 then
        libname:= "2.L2(3)";
      else
        libname:= Concatenation( "2.A", String( n ) );
      fi;
    elif 2Sn then
      if n = 2 then
        libname:= "C4";
      elif n = 3 then
        libname:= "2.S3";
      elif n = 4 then
        libname:= "2.Symm(4)";
      elif n = 6 then
        libname:= "2.A6.2_1";
      else
        # Note that the library tables with identifier "2.A<n>.2"
        # are not the tables 'CharacterTable( "DoubleCoverSymmetric", <n> )'.
        libname:= Concatenation( "Isoclinic(2.A", String( n ), ".2)" );
      fi;
    fi;
    if libname <> fail and
       Position( LIBLIST.allnames, LowercaseString( libname ) ) = fail then
      libname:= fail;
    fi;

    # AbelianInvariants:
    attr:= attrsext.AbelianInvariants;
    if spinsymname in [ "2.Sym(2)", "2.Sym(3)" ] then
      attr.data[ posext ]:= [ 4 ];
    elif Sn or 2Sn then
      attr.data[ posext ]:= [ 2 ];
    elif 5 <= n then
      attr.data[ posext ]:= [];
    else
      pos:= PositionSorted( [ "2.Alt(2)", "2.Alt(3)", "2.Alt(4)", "Alt(2)",
                              "Alt(3)", "Alt(4)" ], spinsymname );
      repl:= [ [ 2 ], [ 2, 3 ], [ 3 ], [], [ 3 ], [ 3 ] ];
      attr.data[ posext ]:= repl[ pos ];
    fi;

    # almostSimpleInfo:
    if 5 <= n then
      if An then
        Add( attrsext.almostSimpleInfo.data.automatic,
             [ spinsymname, [ libname, [ 1, 1 ] ] ] );
      elif Sn then
        Add( attrsext.almostSimpleInfo.data.automatic,
             [ spinsymname, [ Concatenation( "A", String( n ) ), [ 2, 1 ] ] ] );
      fi;
    fi;

    # atlas:
    # If the AtlasRep package is not (yet) loaded at runtime,
    # we add the information to a global variable that gets evaluated
    # as soon as AtlasRep is available.
    # In order to copy the known values from a library table,
    # we evaluate the source data of the 'atlas' attribute.
    # (Note that we can do this because the 'eval' function in
    # 'CTblLib.Data.IdEnumerator' and in 'CTblLib.Data.IdEnumeratorExt'
    # are the same.)
    store_data( libname, "atlas" );

    # basic:
    if An then
      Add( attrsext.basic.data.automatic,
           [ spinsymname, [ [ "AlternatingGroup", [ n ] ] ] ] );
    elif Sn then
      Add( attrsext.basic.data.automatic,
           [ spinsymname, [ [ "SymmetricGroup", [ n ] ] ] ] );
    elif 2An and 4 <= n then
      Add( attrsext.basic.data.automatic,
           [ spinsymname, [ [ "DoubleCoverOfAlternatingGroup", [ n ] ] ] ] );
    elif 2Sn and 4 <= n then
      Add( attrsext.basic.data.automatic,
           [ spinsymname, [ [ "SchurCoverOfSymmetricGroup", [ n ] ] ] ] );
    fi;

    # FusionsTo:
    # 'Alt(<n>)' -> 'Sym(<n>)',
    # '2.Alt(<n>)' -> 'Alt(<n>)',
    # '2.Alt(<n>)' -> '2.Sym(<n>)',
    # '2.Sym(<n>)' -> 'Sym(<n>)'.
    attr:= attrsext.FusionsTo;
    values:= [];
    if 2An or 2Sn then
      Add( values, ReplacedString( spinsymname, "2.", "" ) );
    fi;
    if An or 2An then
      Add( values, ReplacedString( spinsymname, "Alt", "Sym" ) );
    fi;
    Add( attr.data.automatic, [ spinsymname, values ] );

    # IdentifierOfMainTable:
    attrsext.IdentifierOfMainTable.data[ posext ]:= libname;

    # IsDuplicateTable:
    attrsext.IsDuplicateTable.data[ posext ]:= ( libname <> fail );

    # InfoText:
    if An then
      attrsext.InfoText.data[ posext ]:=
          "computed using generic character table for alternating groups";
    elif Sn then
      attrsext.InfoText.data[ posext ]:=
          "computed using generic character table for symmetric groups";
    else
      attrsext.InfoText.data[ posext ]:= "";
    fi;

    # IsAbelian:
    attrsext.IsAbelian.data[ posext ]:=
        ( n <= 2 or ( n = 3 and ( An or 2An ) ) );

    # IsAlmostSimple:
    attrsext.IsAlmostSimple.data[ posext ]:= ( 5 <= n and ( An or Sn ) );

    # IsNontrivialDirectProduct, factorsOfDirectProduct:
    if spinsymname = "2.Alt(3)" then
      attrsext.IsNontrivialDirectProduct.data[ posext ]:= true;
      Add( attrsext.factorsOfDirectProduct.data.automatic,
           [ spinsymname, [ [ "DirectProductByNames", "fail" ] ] ] );
    else
      attrsext.IsNontrivialDirectProduct.data[ posext ]:= false;
    fi;

    # IsPerfect:
    attrsext.IsPerfect.data[ posext ]:= ( 5 <= n and ( An or 2An ) ) or
        ( spinsymname = "Alt(2)" );

    # IsSimple:
    attrsext.IsSimple.data[ posext ]:= ( An and 5 <= n ) or
        ( spinsymname in [ "2.Alt(2)", "Sym(2)", "Alt(3)" ] );

    # IsSporadicSimple:
    attrsext.IsSporadicSimple.data[ posext ]:= false;

    # NamesOfFusionSources:
    values:= [];
    if Sn or 2Sn then
      Add( values, ReplacedString( spinsymname, "Sym", "Alt" ) );
    fi;
    if An or Sn then
      Add( values, Concatenation( "2.", spinsymname ) );
    fi;
    attrsext.NamesOfFusionSources.data[ posext ]:= values;

    # NrConjugacyClasses:
    if An then
      attrsext.NrConjugacyClasses.data[ posext ]:=
          Length( CharTableAlternating.classparam[1]( n ) );
    elif Sn then
      attrsext.NrConjugacyClasses.data[ posext ]:= NrPartitions( n );
    elif libname <> fail then
      attr:= attrs.NrConjugacyClasses;
      attrsext.NrConjugacyClasses.data[ posext ]:=
        attr.attributeValue( attr, libname );
    elif 2An then
      if n = 2 then
        attrsext.NrConjugacyClasses.data[ posext ]:= 2;
      else
        values:= [ 105, 135, 171, 213, 269, 335 ];
        attrsext.NrConjugacyClasses.data[ posext ]:= values[ n - 13 ];
      fi;
    else
      values:= [ 216, 279, 354, 454, 571 ];
      attrsext.NrConjugacyClasses.data[ posext ]:= values[ n - 14 ];
    fi;

    # "perf":
    if ( An or 2An ) and 5 <= n and n <= 9 then
      attr:= attrs.perf;
      values:= attr.attributeValue( attr, libname );
      if not IsEmpty( values ) then
        Add( attrsext.perf.data.automatic, [ spinsymname, values ] );
      fi;
    fi;

    # "prim":
    # Take the known values for alternating and symmetric groups.
    if ( An or Sn ) and libname <> fail then
      attr:= attrs.prim;
      values:= attr.attributeValue( attr, libname );
      if not IsEmpty( values ) then
        Add( attrsext.prim.data.automatic, [ spinsymname, values ] );
      fi;
    fi;

    # Size:
    if An then
      attrsext.Size.data[ posext ]:= Factorial( n ) / 2;
    elif 2An or Sn then
      attrsext.Size.data[ posext ]:= Factorial( n );
    elif 2Sn then
      attrsext.Size.data[ posext ]:= 2 * Factorial( n );
    fi;

    # small:
    if libname <> fail then
      attr:= attrs.small;
      values:= attr.attributeValue( attr, libname );
      if not IsEmpty( values ) then
        Add( attrsext.small.data.automatic, [ spinsymname, values ] );
      fi;
    fi;

    # tom:
    # If the TomLib package is not (yet) loaded at runtime,
    # we add the information to a global variable that gets evaluated
    # as soon as TomLib is available.
    # In order to copy the known values from a library table,
    # we evaluate the source data of the 'tom' attribute.
    # (Note that we can do this because the 'eval' function in
    # 'CTblLib.Data.IdEnumerator' and in 'CTblLib.Data.IdEnumeratorExt'
    # are the same.)
    store_data( libname, "tom" );

    # trans:
    if libname <> fail then
      attr:= attrs.trans;
      values:= attr.attributeValue( attr, libname );
      if not IsEmpty( values ) then
        Add( attrsext.trans.data.automatic, [ spinsymname, values ] );
      fi;
    fi;

    # IdentifiersOfDuplicateTables
    attrsext.IdentifiersOfDuplicateTables.data[ posext ]:= [];
end;


#############################################################################
##
#F  CTblLib.AGL( <d>, <q> )
##
CTblLib.AGL:= function( d, q )
    local gl, F, gens, mats, i;

    gl:= GL( d, q );
    F:= FieldOfMatrixGroup( gl );
    gens:= GeneratorsOfGroup( gl );
    mats:= List( [ 1 .. Length( gens ) + 1 ], i -> IdentityMat( d+1, F ) );
    for i in [ 1 .. Length( gens ) ] do
      mats[i]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens[i];
    od;
    mats[ Length( mats ) ][ d+1, 1 ]:= One( F );

    return GroupByGenerators( mats );
end;


#############################################################################
##
#E

