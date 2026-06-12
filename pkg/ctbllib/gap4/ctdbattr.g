#############################################################################
##
#W  ctdbattr.g           GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains the declarations for the database id enumerators
##  `CTblLib.Data.IdEnumerator' and `CTblLib.Data.IdEnumeratorExt`,
##  and their database attributes.
##  See the GAP package `Browse' for technical details.
##  Among others, the enumerators provide the data for the GAP attribute
##  `GroupInfoForCharacterTable'.
##
##  The component `reverseEval' is used only by the function
##  `CharacterTableForGroupInfo',
##  it is not needed by the database attribute handling mechanism.
##
##  (Some attributes are available only if additional GAP packages are
##  available, for example the TomLib package.
##  Their data are read via suitable package extensions that are listed
##  in CTblLib's 'PackageInfo.g' file.)
##


#############################################################################
##
#F  IsDihedralCharacterTable( <tbl> )
##
##  Let <A>tbl</A> be the character table of a group <M>G</M>, say.
##  Then <M>G</M> is a dihedral group if and only if
##  the order of <M>G</M> is an even integer <M>n</M>,
##  <M>G</M> contains a cyclic normal subgroup <M>N</M> of index two,
##  <M>G \setminus N</M> contains involutions,
##  and the table of <M>G</M> is real.
##
BindGlobal( "IsDihedralCharacterTable", function( tbl )
    local size, orders, nsg, ccl;

    size:= Size( tbl );
    if size mod 2 = 1 then
      return false;
    fi;
    orders:= OrdersClassRepresentatives( tbl );
    nsg:= Filtered( ClassPositionsOfNormalSubgroups( tbl ),
                    n -> size / 2 in orders{ n } );
    ccl:= [ 1 .. NrConjugacyClasses( tbl ) ];
    return ForAny( nsg, n -> 2 in orders{ Difference( ccl, n ) } )
           and PowerMap( tbl, -1 ) = ccl;
    end );


#############################################################################
##
#F  CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage( <tbl>,
#F      <classes> )
##
##  Let <tbl> be an ordinary character table, and <classes> be a list of
##  class positions for <tbl>.
##  `CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage' returns the
##  list of those library tables that store a class fusion to <tbl> having
##  image exactly <classes> and whose size equals the union of the
##  class lengths for <classes>.
##
CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage:=
    function( tbl, classes )
    local n, result, ids, name, subtbl, fus, next;

    n:= Sum( SizesConjugacyClasses( tbl ){ classes } );
    result:= [];
    ids:= [];
    for name in NamesOfFusionSources( tbl ) do
      subtbl:= CharacterTable( name );
      if subtbl <> fail and Size( subtbl ) mod n = 0 then
        fus:= GetFusionMap( subtbl, tbl );
        if Set( fus ) = classes and Size( subtbl ) = n then
          # The table itself satisfies the conditions.
          if not Identifier( subtbl ) in ids then
            Add( result, [ subtbl, fus ] );
            AddSet( ids, Identifier( subtbl ) );
          fi;
        elif ClassPositionsOfKernel( fus ) = [ 1 ]
             and IsSubset( fus, classes ) then
          # Maybe a subgroup fits, so enter a recursion.
          for next in
            CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage( subtbl,
              Filtered( [ 1 .. Length( fus ) ], i -> fus[i] in classes ) ) do
            if not Identifier( next[1] ) in ids then
              Add( result, [ next[1], fus{ next[2] } ] );
              AddSet( ids, Identifier( next[1] ) );
            fi;
          od;
        fi;
      fi;
    od;
    return result;
    end;


#############################################################################
##
#F  CTblLib.FindTableForGroup( <G>, <tbls>, <pos> )
##
##  Let <G> be a group, <tbls> be a list of ordinary character tables,
##  and <pos> be a position in this list such that <G> belongs to (at least)
##  one of these tables.
##  `CTblLib.FindTableForGroup' tries to decide whether <G> belongs to the
##  <pos>-th entry in <tbls>.
##  If this is possible then `true' or `false' is returned,
##  otherwise `fail' is returned.
##
CTblLib.FindTableForGroup:= function( G, tbls, pos )
    local funs, invs, rng, bound, k, g, i, val;

    # Use element orders and centralizer orders.
    funs:= [ Order,
             g -> Size( Centralizer( G, g ) ) ];
    invs:= List( tbls, t -> TransposedMat(
                                [ OrdersClassRepresentatives( t ),
                                  SizesCentralizers( t ) ] ) );

    # Can we decide the question, or is there a chance to fail?
    rng:= [ 1 .. Length( tbls ) ];
    if ForAll( rng, i -> i = pos or
                 not ( IsEmpty( Difference( invs[i], invs[ pos ] ) ) or
                       IsEmpty( Difference( invs[i], invs[ pos ] ) ) ) ) then
      bound:= infinity;
    else
      bound:= 100;
    fi;

    k:= 1;
    while k <= bound do
      g:= PseudoRandom( G );
      for i in [ 1 .. Length( funs ) ] do
        val:= funs[i]( g );
        rng:= Filtered( rng,
                        j -> ForAny( invs[j], tuple -> val = tuple[i] ) );
        if   rng = [ pos ] then
          return true;
        elif not pos in rng then
          return false;
        fi;
      od;
      k:= k + 1;
    od;

    return fail;
    end;


#############################################################################
##
##  Provide utilities for the computation of database attribute values.
##  They allow one to access table data without actually creating the tables.
##


#############################################################################
##
#F  CTblLib.AttrDataString( <entry>, <default>, <withcomment> )
##
##  This is the default value for the `string' component of database
##  attributes,
##  which is used for storing the attriute values in files.
##
CTblLib.AttrDataString:= function( entry, default, withcomment )
    local encode, result, comment, data, l, x;

    encode:= function( value )
      if IsString( value ) and
         ( IsStringRep( value ) or not IsEmpty( value ) ) then
        value:= ReplacedString( value, "\"", "\\\"" );
        value:= ReplacedString( value, "\n", "\\n" );
        value:= Concatenation( "\"", value, "\"" );
      elif IsList( value ) then
        value:= Concatenation( "[",
                    JoinStringsWithSeparator( List( value, encode ), "," ),
                    "]" );
      else
        value:= String( value );
        value:= ReplacedString( value, "\"", "\\\"" );
        value:= ReplacedString( value, "\n", "\\n" );
      fi;
      return value;
    end;

    # Default values need not be stored.
    if IsList( entry[2] ) and entry[2] = default then
      return "";
    fi;

    # The first entry is the identifier.
    result:= Concatenation( "[", encode( entry[1] ), "," );

    if withcomment then
      # A comment may be stored at the second position.
      comment:= entry[2][1];
      data:= entry[2][2];
      Append( result, Concatenation( "[", encode( comment ), "," ) );
    else
      data:= entry[2];
    fi;
    Append( result, encode( data ) );
    if withcomment then
      Append( result, "]" );
    fi;
    Append( result, "],\n" );
    return result;
end;


#############################################################################
##
#F  CTblLib.Data.InvariantByRecursion( <list>, <funcs> )
##
##  ... is used only for computing the `Size' and `NrConjugacyClasses' values
##
##  <funcs> is a record with the components
##    `gentablefunc'
##      a function that takes two arguments,
##      a generic character table and ...
##    `wreathsymmfunc'
##      a function ...
##    `cheaptest'
##      a function ...
##
CTblLib.Data.InvariantByRecursion:= function( list, funcs )
    local id, info, r, res, cen;

    id:= list[1];
    info:= LibInfoCharacterTable( id );
    id:= info.firstName;
    if info.fileName = "ctgeneri" then
      # Evaluate only part of the generic table.
      return funcs.gentablefunc( CharacterTable( info.firstName ), list );
    elif Length( list ) = 1
         and IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.CharacterTableInfo.( id );
      res:= funcs.cheaptest( r );
      if res <>  fail then
        return res;
      elif IsBound( r.ConstructionInfoCharacterTable )
           and IsList( r.ConstructionInfoCharacterTable ) then
        # Determine the size/nccl from the sizes/nccls of the input tables.
        if   r.ConstructionInfoCharacterTable[1] in
                  [ "ConstructDirectProduct", "ConstructIsoclinic" ] then
          r:= List( r.ConstructionInfoCharacterTable[2],
                    l -> CTblLib.Data.InvariantByRecursion( l, funcs ) );
          if fail in r then
            return fail;
          fi;
          return Product( r, 1 );
        elif r.ConstructionInfoCharacterTable[1] in
                  [ "ConstructPermuted", "ConstructAdjusted" ] then
          r:= CTblLib.Data.InvariantByRecursion(
                  r.ConstructionInfoCharacterTable[2], funcs );
          if r = fail then
            return fail;
          fi;
          return r;
        elif r.ConstructionInfoCharacterTable[1]
             = "ConstructWreathSymmetric" then
          id:= r.ConstructionInfoCharacterTable[3];
          r:= CTblLib.Data.InvariantByRecursion(
                  r.ConstructionInfoCharacterTable[2], funcs );
          if r = fail then
            return fail;
          fi;
          return funcs.wreathsymmfunc( r, id );
        elif r.ConstructionInfoCharacterTable[1]
             = "ConstructCentralProduct" then
          cen:= r.ConstructionInfoCharacterTable[3];
          r:= List( r.ConstructionInfoCharacterTable[2],
                    l -> CTblLib.Data.InvariantByRecursion( l, funcs ) );
          if fail in r then
            return fail;
          fi;
          return Product( r, 1 ) / Length( cen );
        fi;
      fi;
    fi;
    return fail;
end;

CTblLib.Data.prepare:= function( attr )
  CTblLib.Data.unload:= UserPreference( "CTblLib", "UnloadCTblLibFiles" );
  SetUserPreference( "CTblLib", "UnloadCTblLibFiles", false );
end;

CTblLib.Data.cleanup:= function( attr )
  SetUserPreference( "CTblLib", "UnloadCTblLibFiles", CTblLib.Data.unload );
  Unbind( CTblLib.Data.unload );
end;

# a function that does nothing
CTblLib.Data.MyIdFunc:= function( arg ); end;

CTblLib.Data.TABLE_ACCESS_FUNCTIONS:= [
  rec(),
  rec(
       LIBTABLE := rec( LOADSTATUS := rec(), clmelab := [], clmexsp := [] ),

       # These functions are used in the data files.
       GALOIS := CTblLib.Data.MyIdFunc,
       TENSOR := CTblLib.Data.MyIdFunc,
       ALF := CTblLib.Data.MyIdFunc,
       ACM := CTblLib.Data.MyIdFunc,
       ARC := CTblLib.Data.MyIdFunc,
       ALN := CTblLib.Data.MyIdFunc,
       MBT := CTblLib.Data.MyIdFunc,
       MOT := CTblLib.Data.MyIdFunc,
      ) ];

CTblLib.Data.SaveTableAccessFunctions := function()
  local name;

  if CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1] <> rec() then
    Info( InfoDatabaseAttributeX, 1, "functions were already saved" );
    return;
  fi;

  Info( InfoDatabaseAttributeX, 1, "before saving global variables" );
  for name in RecNames( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2] ) do
    if IsBoundGlobal( name ) then
      if IsReadOnlyGlobal( name ) then
        MakeReadWriteGlobal( name );
        CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ):=
            [ ValueGlobal( name ), "readonly" ];
      else
        CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ):=
            [ ValueGlobal( name ) ];
      fi;
      UnbindGlobal( name );
    fi;
    ASS_GVAR( name, CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2].( name ) );
  od;
end;

CTblLib.Data.RestoreTableAccessFunctions := function()
  local name;

  if CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1] = rec() then
    Info( InfoDatabaseAttributeX, 1, "cannot restore without saving" );
    return;
  fi;

  for name in RecNames( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[2] ) do
    UnbindGlobal( name );
    if IsBound( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) ) then
      ASS_GVAR( name, CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name )[1] );
      if Length( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) ) = 2 then
        MakeReadOnlyGlobal( name );
      fi;
      Unbind( CTblLib.Data.TABLE_ACCESS_FUNCTIONS[1].( name ) );
    fi;
  od;
  Info( InfoDatabaseAttributeX, 1, "after restoring global variables" );
end;


#############################################################################
##
#F  CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
#F      <neededcomponents>, <providedcomponents>, <pairs> )
##
##  If `CTblLib.Data.knownComponents' contains all entries of the list
##  <neededcomponents> then nothing is done.
##
##  Otherwise, ...
##
##  The argument <A>pairs</A> must be a list of pairs
##  <C>[ <A>nam</A>, <A>fun</A> ]</C>
##  where <A>nam</A> is the name of a function to be reassigned during the
##  reread process (such as <C>"MOT"</C>, <C>"ARC"</C>),
##  and <A>fun</A> is the corresponding value.
##
CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles :=
    function( neededcomponents, providedcomponents, pairs )
    local filenames, pair, name;

    # Check if we have to do something.
    if IsBound( CTblLib.Data.knownComponents ) and
       IsSubset( CTblLib.Data.knownComponents, neededcomponents ) then
      return;
    fi;

    # Remember the names of all character table library files.
    filenames:= LIBLIST.files;

    # Disable the table library access.
    CTblLib.Data.SaveTableAccessFunctions();

    # Define appropriate access functions.
    for pair in pairs do
      ASS_GVAR( pair[1], pair[2] );
    od;

    # Clear the cache.
    CTblLib.Data.CharacterTableInfo:= rec();

    # Loop over the library files.
    for name in filenames do
      if name[1] = '/' then
        # private extension
        Read( Concatenation( name, ".tbl" ) );
      else
        ReadPackage( "ctbllib", Concatenation( "data/", name, ".tbl" ) );
      fi;
    od;

    # Restore the ordinary table library access.
    CTblLib.Data.RestoreTableAccessFunctions();

    # Replace the component list for the next call.
    CTblLib.Data.knownComponents:= providedcomponents;
    end;


#############################################################################
##
##  Create the database id enumerator to which the database attributes refer.
##
CTblLib.Data.IdEnumerator:= DatabaseIdEnumeratorX( rec(
    identifiers:= Set( LIBLIST.firstnames_orig ),
    isSorted:= true,
    entry:= function( idenum, id ) return CharacterTable( id ); end,
    version:= LIBLIST.lastupdated,
    update:= function( idenum )
      idenum.identifiers:= Set( AllCharacterTableNames() );
      idenum.version:= LIBLIST.lastupdated;
      return true;
      end,
#   isUpToDate:= idenum -> idenum.version = LIBLIST.lastupdated,
#T note: notifying a new table should then change the lastupdated field!
    viewSort:= CTblLib.CompareAsNumbersAndNonnumbers,
    align:= "lt",
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.Size
##
AddSet( CTblLib.SupportedAttributes, "Size" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "Size",
  description:= "sizes of GAP library character tables",
  type:= "pairs",
  name:= "Size",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_size.json" ),
  dataDefault:= fail,
  isSorted:= true,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "SizesCentralizers" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local r, other;

    if IsBound( CTblLib.Data.CharacterTableInfo ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.InvariantByRecursion( [ id ],
              rec( gentablefunc:= function( gentable, list)
                     return gentable.size( list[2] );
                   end,
                   cheaptest:= function( r )
                     if IsList( r.SizesCentralizers ) then
                       return r.SizesCentralizers[1];
                     fi;
                     return fail;
                   end,
                   wreathsymmfunc:= function( subval, n )
                     return subval^n * Factorial( n );
                   end,
                 ) );
    else
      r:= fail;
    fi;
    if r = fail then
      Info( InfoDatabaseAttributeX, 1,
            "hard test for Size computation of ", id );
      return Size( CharacterTable( id ) );
    else
      return r;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "size",
  viewSort:= CTblLib.CompareLenLex,
  categoryValue:= res -> Concatenation( "size = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 25,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IdentifierOfMainTable
##
DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IdentifierOfMainTable",
  description:= "identifier of the table for which the current table is a duplicate",
  type:= "pairs",
  name:= "IdentifierOfMainTable",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_main.json" ),
  dataDefault:= fail,
  isSorted:= true,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local t, info;

    if IsBound( CTblLib.Data.CharacterTableInfo ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      t:= CTblLib.Data.CharacterTableInfo.( id );
      if IsBound( t.ConstructionInfoCharacterTable ) then
        info:= t.ConstructionInfoCharacterTable;
      fi;
    else
      t:= CharacterTable( id );
      if HasConstructionInfoCharacterTable( t ) then
        info:= ConstructionInfoCharacterTable( t );
      fi;
    fi;
    if IsBound( info ) and IsList( info )
                       and info[1] = "ConstructPermuted" then
      info:= info[2];
      if Length( info ) = 1 then
        # permuted library table
        return info[1];
      fi;
    fi;

    return fail;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "main",
  categoryValue:= res -> Concatenation( "main table = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 12,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsDuplicateTable
##
AddSet( CTblLib.SupportedAttributes, "IsDuplicateTable" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsDuplicateTable",
  description:= "are GAP library character tables duplicates of others",
  type:= "values",
  name:= "IsDuplicateTable",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "duplicate";
    else
      return "not duplicate";
    fi;
    end,
  neededAttributes:= [ "IdentifierOfMainTable" ],
  create:= function( attr, id )
    local main;

    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    return IsString( main.attributeValue( main, id ) );
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "duplicate?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IdentifiersOfDuplicateTables
##
AddSet( CTblLib.SupportedAttributes, "IdentifiersOfDuplicateTables" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IdentifiersOfDuplicateTables",
  description:= "identifiers of GAP library character tables that are duplicates",
  type:= "pairs",
  name:= "IdentifiersOfDuplicateTables",
  dataDefault:= [],
  isSorted:= true,
  neededAttributes:= [ "IdentifierOfMainTable" ],
  prepareAttributeComputation:= function( attr )
      local main, id, mainid;

      main:= attr.idenumerator.attributes.IdentifierOfMainTable;
      CTblLib.IdentifiersOfDuplicateTables:= rec();

      for id in attr.idenumerator.identifiers do
        mainid:= main.attributeValue( main, id );
        if mainid <> fail then
          if not IsBound( CTblLib.IdentifiersOfDuplicateTables.( mainid ) ) then
            CTblLib.IdentifiersOfDuplicateTables.( mainid ):= [ id ];
          else
            AddSet( CTblLib.IdentifiersOfDuplicateTables.( mainid ), id );
          fi;
        fi;
      od;
    end,
  cleanupAfterAttributeComputation:= function( attr )
      Unbind( CTblLib.IdentifiersOfDuplicateTables );
    end,
  create:= function( attr, id )
    if IsBound( CTblLib.IdentifiersOfDuplicateTables.( id ) ) then
      return CTblLib.IdentifiersOfDuplicateTables.( id );
    else
      return [];
    fi;
    end,
  viewLabel:= "duplicates",
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.NrConjugacyClasses
##
AddSet( CTblLib.SupportedAttributes, "NrConjugacyClasses" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "NrConjugacyClasses",
  description:= "class numbers of GAP library character tables",
  type:= "pairs",
  name:= "NrConjugacyClasses",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_nccl.json" ),
  dataDefault:= fail,
  isSorted:= true,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "SizesCentralizers" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local r, other;

    if IsBound( CTblLib.Data.CharacterTableInfo ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      r:= CTblLib.Data.InvariantByRecursion( [ id ],
              rec( gentablefunc:= function( gentable, list )
                     return Sum( List( gentable.classparam,
                                       p -> Length( p( list[2] ) ) ), 0 );
                   end,
                   cheaptest:= function( r )
                     if IsList( r.SizesCentralizers ) then
                       return Length( r.SizesCentralizers );
                     fi;
                     return fail;
                   end,
                   wreathsymmfunc:= function( subval, n )
                     return NrPartitionTuples( n, subval );
                   end,
                 ) );
    else
      r:= fail;
    fi;
    if r = fail then
      return NrConjugacyClasses( CharacterTable( id ) );
    else
      return r;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "nccl",
  viewSort:= CTblLib.CompareLenLex,
  categoryValue:= res -> Concatenation( "nccl = ", String( res ) ),
  sortParameters:= [ "add counter on categorizing", "yes" ],
  widthCol:= 4,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.InfoText
##
##  This is used for creating the group overviews
##  (plain strings or Browse tables or HTML files).
##
AddSet( CTblLib.SupportedAttributes, "InfoText" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "InfoText",
  description:= "info text of GAP library character tables",
  type:= "pairs",
  name:= "InfoText",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_text.json" ),
  dataDefault:= "",
  isSorted:= true,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "ConstructionInfoCharacterTable", "InfoText" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    local info, r;

    if IsBound( CTblLib.Data.CharacterTableInfo ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) then
      info:= LibInfoCharacterTable( id );
      id:= info.firstName;
      if info.fileName = "ctgeneri" then
        # Evaluate only part of the generic table.
        return CharacterTable( info.firstName ).text;
      else
        r:= CTblLib.Data.CharacterTableInfo.( id );
        if IsList( r.InfoText ) then
          return Concatenation( r.InfoText );
        fi;
        return "";
      fi;
    else
      r:= CharacterTable( id );
      if HasInfoText( r ) then
        return InfoText( r );
      else
        return "";
      fi;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, "", false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "info",
  widthCol:= 20,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.Maxes
##
AddSet( CTblLib.SupportedAttributes, "Maxes" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "Maxes",
  description:= "maxes lists of GAP library character tables",
  type:= "pairs",
  name:= "Maxes",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_maxes.json" ),
  dataDefault:= fail,
  isSorted:= true,
  neededAttributes:= [],
  prepareAttributeComputation:= function( attr )
    CTblLib.Data.prepare( attr );
    CTblLib.Data.ComputeCharacterTableInfoByScanningLibraryFiles(
      [ "Maxes" ],
      [ "ConstructionInfoCharacterTable", "InfoText", "Maxes",
        "SizesCentralizers" ],
      [ [ "MOT", function( arg )
          local record;
            record:= rec( InfoText:= arg[2],
                          SizesCentralizers:= arg[3] );
            if IsBound( arg[7] ) then
              record.ConstructionInfoCharacterTable:= arg[7];
            fi;
            CTblLib.Data.CharacterTableInfo.( arg[1] ):= record;
          end ],
        [ "ARC", function( arg )
            if arg[2] = "maxes" then
              CTblLib.Data.CharacterTableInfo.( arg[1] ).Maxes:= arg[3];
            fi;
          end ] ] );
    end,
  cleanupAfterAttributeComputation:= CTblLib.Data.cleanup,
  create:= function( attr, id )
    if IsBound( CTblLib.Data.CharacterTableInfo ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ) ) and
       IsBound( CTblLib.Data.CharacterTableInfo.( id ).Maxes ) then
      return CTblLib.Data.CharacterTableInfo.( id ).Maxes;
    else
      return fail;
    fi;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "maxes",
  widthCol:= 25,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.NamesOfFusionSources
##
AddSet( CTblLib.SupportedAttributes, "NamesOfFusionSources" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "NamesOfFusionSources",
  description:= "fusions from other character tables to the given one",
  type:= "values",
  name:= "NamesOfFusionSources",
  align:= "tl",
  create:= function( attr, id )
    local pos;

    pos:= Position( LIBLIST.firstnames, id );
#T firstnames is not sorted, better use allnames & position?
    if pos <> fail then
      return LIBLIST.fusionsource[ pos ];
    fi;
    return [];
    end,
  version:= CTblLib.Data.IdEnumerator.version,
  viewValue:= x -> rec( rows:= x, align:= "tl" ),
  viewLabel:= "fusions -> G",
  categoryValue:= function( val )
    if IsEmpty( val ) then
      return "(no fusions to these tables)";
    fi;
    return List( val, x -> Concatenation( "fusions from ", x ) );
    end,
  sortParameters:= [ "add counter on categorizing", "yes",
                     "split rows on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.FusionsTo
##
DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "FusionsTo",
  description:= "fusions from the given character table to other ones",
  type:= "values",
  align:= "tl",
  categoryValue:= function( val )
    if IsEmpty( val ) then
      return "(no fusions from these tables)";
    fi;
    return List( val, x -> Concatenation( "fusions to ", x ) );
    end,
  prepareAttributeComputation:= function( attr )
    local i, nam, src;

    CTblLib.Data.sortedfirstnames:= ShallowCopy( LIBLIST.firstnames );
    CTblLib.Data.position:= [ 1 .. Length( LIBLIST.firstnames ) ];
    SortParallel( CTblLib.Data.sortedfirstnames, CTblLib.Data.position );
    CTblLib.Data.FusionInfo:= List( [ 1 .. Length( LIBLIST.firstnames ) ],
                                   i -> [] );
    for i in [ 1 .. Length( LIBLIST.firstnames ) ] do
      nam:= LIBLIST.firstnames[i];
      for src in LIBLIST.fusionsource[i] do
        Add( CTblLib.Data.FusionInfo[ PositionSet(
               CTblLib.Data.sortedfirstnames, src ) ], nam );
      od;
    od;
    end,
  create:= function( attr, id )
    local pos;

    pos:= PositionSet( CTblLib.Data.sortedfirstnames, id );
    if pos <> fail then
      return CTblLib.Data.FusionInfo[ pos ];
    fi;
    return [];
    end,
  viewValue:= x -> rec( rows:= x, align:= "tl" ),
  viewLabel:= "fusions G ->",
  sortParameters:= [ "add counter on categorizing", "yes",
                     "split rows on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.basic
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "basic" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "basic",
  description:= "mapping between CTblLib and GAP's basic groups libraries",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_basic.json" ),
  dataDefault:= [],
  isSorted:= true,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] in [ "AlternatingGroup", "CyclicGroup",
                    "DihedralGroup", "MathieuGroup", "POmega", "PSL",
                    "PSU", "PSp", "ReeGroup", "SuzukiGroup",
                    "SymmetricGroup" ] then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:=  function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_basic:= rec();
    CTblLib.Data.prepare( attr );
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_basic );
    CTblLib.Data.cleanup( attr );
    end,
  create:= function( attr, id )
    local main, mainid, result, tbl, type, r, nsg, simp, cen, ext, explicit,
          entry, name;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_basic ) and
       IsBound( CTblLib.Data.attrvalues_basic.( id ) ) then
      return CTblLib.Data.attrvalues_basic.( id );
    fi;

    # Now we know that we have to work.
    result:= [];
    tbl:= CharacterTable( id );
    if IsSimpleCharacterTable( tbl ) then
      type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
      if   type.series = "A" then
        Add( result, [ "AlternatingGroup", [ type.parameter ] ] );
        if   type.parameter = 5 then
          Add( result, [ "PSL", [ 2, 4 ] ] );
          Add( result, [ "PSL", [ 2, 5 ] ] );
        elif type.parameter = 6 then
          Add( result, [ "PSL", [ 2, 9 ] ] );
        elif type.parameter = 8 then
          Add( result, [ "PSL", [ 4, 2 ] ] );
        fi;
      elif type.series = "B" then
        Add( result,
             [ "POmega", [ 2 * type.parameter[1] + 1, type.parameter[2] ] ] );
        if IsEvenInt( type.parameter[2] ) or type.parameter[1] = 2 then
          Add( result,
               [ "PSp", [ 2 * type.parameter[1], type.parameter[2] ] ] );
        fi;
        if type.parameter = [ 2, 3 ] then
          Add( result, [ "PSU", [ 4, 2 ] ] );
          Add( result, [ "POmega", [ -1, 6, 2 ] ] );
        fi;
      elif type.series = "C" then
        Add( result,
             [ "PSp", [ 2 * type.parameter[1], type.parameter[2] ] ] );
        if type.parameter[1] = 2 then
          Add( result, [ "POmega", [ 5, type.parameter[2] ] ] );
        fi;
      elif type.series = "D" then
        Add( result,
             [ "POmega", [ 1, 2 * type.parameter[1], type.parameter[2] ] ] );
      elif type.series = "L" then
        Add( result, [ "PSL", type.parameter ] );
        if   type.parameter[1] = 2 then
          Add( result, [ "POmega", [ 3, type.parameter[2] ] ] );
          Add( result, [ "PSp", type.parameter ] );
          Add( result, [ "PSU", type.parameter ] );
          r:= RootInt( type.parameter[2] );
          if r^2 = type.parameter[2] then
            Add( result, [ "POmega", [ -1, 4, r ] ] );
          fi;
          if type.parameter[2] = 7 then
            Add( result, [ "PSL", [ 3, 2 ] ] );
          fi;
        elif type.parameter[1] = 4 then
          Add( result, [ "POmega", [ 1, 6, type.parameter[2] ] ] );
        fi;
      elif type.series = "G" then
        Add( result, [ "SimpleGroup", [ "G", 2, type.parameter ] ] );
      elif type.series = "2A" then
        Add( result,
             [ "PSU", [ type.parameter[1] + 1, type.parameter[2] ] ] );
        if type.parameter[1] = 3 then
          Add( result, [ "POmega", [ -1, 6, type.parameter[2] ] ] );
        fi;
      elif type.series = "2B" then
        Add( result, [ "SuzukiGroup", [ type.parameter ] ] );
      elif type.series = "2D" then
        Add( result,
             [ "POmega", [ -1, 2 * type.parameter[1], type.parameter[2] ] ] );
      elif type.series = "2G" then
        Add( result, [ "ReeGroup", [ type.parameter ] ] );
      elif type.series = "3D" then
        Add( result, [ "SimpleGroup", [ "3D", 4, type.parameter ] ] );
      elif type.series = "Spor" then
        if   type.name = "M(11)" then
          Add( result, [ "MathieuGroup", [ 11 ] ] );
        elif type.name = "M(12)" then
          Add( result, [ "MathieuGroup", [ 12 ] ] );
        elif type.name = "M(22)" then
          Add( result, [ "MathieuGroup", [ 22 ] ] );
        elif type.name = "M(23)" then
          Add( result, [ "MathieuGroup", [ 23 ] ] );
        elif type.name = "M(24)" then
          Add( result, [ "MathieuGroup", [ 24 ] ] );
        fi;
#T more series of simple groups?
      fi;
    elif IsPerfectCharacterTable( tbl ) then
      # Detect nonsolvable groups SL(2,q), for odd q.
      cen:= ClassPositionsOfCentre( tbl );
      if Size( cen ) = 2 then
        simp:= tbl / cen;
        if IsSimpleCharacterTable( simp ) then
          type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
          if type.series = "L" and type.parameter[1] = 2 then
            Add( result, [ "SL", type.parameter ] );
          fi;
        fi;
      fi;
#T detect DoubleCoverOfAlternatingGroup:
#T modulo central inv., a simple group of type An, except in small cases
    fi;

    # Detect nonsolvable symmetric groups
#T Can this be done without the character table of the socle?
    # and automorphism groups of simple groups.
    if IsAlmostSimpleCharacterTable( tbl ) and
       not IsSimpleCharacterTable( tbl ) then
      # There is a unique minimal normal subgroup.
      nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
      simp:= CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage(
                 tbl, nsg );
      if not IsEmpty( simp ) then
        simp:= simp[1][1];
        type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
        if type.series = "A" then
          if type.parameter <> 6 then
            Add( result, [ "SymmetricGroup", [ type.parameter ] ] );
          elif not 8 in OrdersClassRepresentatives( tbl ) then
            # 'A6.2_1'
            Add( result, [ "SymmetricGroup", [ type.parameter ] ] );
            Add( result, [ "PSp", [ 4, 2 ] ] );
            Add( result, [ "POmega", [ 5, 2 ] ] );
          elif not 10 in OrdersClassRepresentatives( tbl ) then
            # 'A6.2_3'
            Add( result, [ "MathieuGroup", [ 10 ] ] );
          elif NrConjugacyClasses( tbl ) = 11 then
            # 'A6.2_2'
            Add( result, [ "PGL", [ 2, 9 ] ] );
            Add( result, [ "PGU", [ 2, 9 ] ] );
          else
            # 'A6.2^2'
            Add( result, [ "PGammaL", [ 2, 9 ] ] );
          fi;
        fi;

        if HasExtensionInfoCharacterTable( simp ) then
          ext:= ExtensionInfoCharacterTable( simp );
          if ext[2] <> "" then
            ext:= CharacterTable( Concatenation( Identifier( simp ),
                                      ".", ext[2] ) );
            if ext <> fail and Size( ext ) = Size( tbl ) then
              Add( result, [ "Aut", [ Identifier( simp ) ] ] );
            fi;
          fi;
        fi;

        # Detect some projective and semilinear groups.
        # (Note that we give no abstract description.)
        explicit:= [
          ["L2(16).4",[["PGammaL",[2,16]],["SigmaL",[2,16]],["PSigmaL",[2,16]]]],
          ["L2(25).2^2",[["PGammaL",[2,25]]]],
          ["L2(25).2_1",[["PGL",[2,25]]]],
          ["L2(25).2_2",[["PSigmaL",[2,25]]]],
          ["L2(27).2",[["PGL",[2,27]]]],
          ["L2(27).3",[["PSigmaL",[2,27]]]],
          ["L2(27).6",[["PGammaL",[2,27]]]],
          ["L2(32).5",[["PGammaL",[2,32]],["SigmaL",[2,32]],["PSigmaL",[2,32]]]],
          ["L2(49).2^2",[["PGammaL",[2,49]]]],
          ["L2(49).2_1",[["PGL",[2,49]]]],
          ["L2(49).2_2",[["PSigmaL",[2,49]]]],
          ["L2(64).6",[["PGammaL",[2,64]]]],
          ["L2(81).(2x4)",[["PGammaL",[2,81]]]],
          ["L2(81).2_2",[["PGL",[2,81]]]],
          ["L2(81).4_1",[["PSigmaL",[2,81]]]],
          ["L3(7).3",[["PGL",[3,7]]]],
          ["L3(8).3",[["PGammaL",[3,8]],["SigmaL",[3,8]],["PSigmaL",[3,8]]]],
          ["L3(9).2_2",[["PGammaL",[3,9]],["SigmaL",[3,9]],["PSigmaL",[3,9]]]],
          ["L4(3).2_1",[["PGL",[4,3]]]],
          ["L4(3).2_2",[["PGO",[+1,6,3]]]],
          ["L4(4).2_1",[["PSigmaL",[4,4]]]],
          ["O8+(3).2_1",[["PSO",[+1,8,3]]]],
          ["O8+(3).(2^2)_{122}",[["PGO",[+1,8,3]]]],
          ["O8-(3).2_1",[["PGO",[-1,8,3]]]],
          ["S4(5).2",[["SO",[5,5]]]],
          ["U3(11).3",[["PGU",[3,11]]]],
          ["U3(5).3",[["PGU",[3,5]]]],
          ["U3(8).3^2",[["PGammaU",[3,8]]]],
          ["U3(8).3_1",[["PSigmaU",[3,8]]]],
          ["U3(8).3_2",[["PGU",[3,8]]]],
          ["U4(2).2",[["PSO",[5,3]]]],
          ["U4(3).2_1",[["PSO",[-1,6,3]]]],
          ["U4(5).2_2",[["PGU",[4,5]]]],
        ];
        entry:= First( explicit, x -> Identifier( tbl ) = x[1] );
        if entry <> fail then
          Append( result, entry[2] );
        fi;
      fi;
    fi;

    # Detect some AGLs.
    # (Note that we give no abstract description.)
    explicit:= [
      ["S3",[["AGL",[1,3]]]],
      ["a4",[["AGL",[1,4]]]],
      ["5:4",[["AGL",[1,5]]]],
      ["7:6",[["AGL",[1,7]]]],
      ["2^3:7",[["AGL",[1,8]]]],
      ["11:10",[["AGL",[1,11]]]],
      ["13:12",[["AGL",[1,13]]]],
      ["17:16",[["AGL",[1,17]]]],
      ["19:18",[["AGL",[1,19]]]],
      ["23:22",[["AGL",[1,23]]]],
      ["frob",[["AGL",[1,29]]]],
      ["31:30",[["AGL",[1,31]]]],
      ["41:40",[["AGL",[1,41]]]],
      ["s4",[["AGL",[2,2]]]],
      ["3^2.2.S4",[["AGL",[2,3]]]],
      ["j3m4",[["AGL",[2,4]]]],
      ["5^2:4s5",[["AGL",[2,5]]]],
      ["2^6:(7xL2(8))",[["AGL",[2,8]]]],
      ["3^4:GL2(9)",[["AGL",[2,9]]]],
      ["11^2:(5x2L2(11).2)",[["AGL",[2,11]]]],
      ["2^3:sl(3,2)",[["AGL",[3,2]]]],
      ["2^4:a8",[["AGL",[4,2]]]],
      ["2^5:L5(2)",[["AGL",[5,2]]]],
      ["2^6:L6(2)",[["AGL",[6,2]]]],
      ["P1L82",[["AGL",[7,2]]]],
    ];
    entry:= First( explicit, x -> Identifier( tbl ) = x[1] );
    if entry <> fail then
      Append( result, entry[2] );
    fi;

    # Detect some solvable groups.
    if   Size( tbl ) = 12 and NrConjugacyClasses( tbl ) = 4 then
      Add( result, [ "AlternatingGroup", [ 4 ] ] );
      Add( result, [ "PSL", [ 2, 3 ] ] );
      Add( result, [ "PSU", [ 2, 3 ] ] );
      Add( result, [ "PSp", [ 2, 3 ] ] );
    elif Size( tbl ) = 20 and NrConjugacyClasses( tbl ) = 5 then
      Add( result, [ "SuzukiGroup", [ 2 ] ] );
    elif Size( tbl ) = 24 and NrConjugacyClasses( tbl ) = 5 then
      Add( result, [ "SymmetricGroup", [ 4 ] ] );
    elif Size( tbl ) = 72 and NrConjugacyClasses( tbl ) = 6 then
      Add( result, [ "MathieuGroup", [ 9 ] ] );
      Add( result, [ "PSU", [ 3, 2 ] ] );
    fi;

    if IsCyclic( tbl ) then
      Add( result, [ "CyclicGroup", [ Size( tbl ) ] ] );
      if Size( tbl ) = 2 then
        Add( result, [ "SymmetricGroup", [ 2 ] ] );
      elif Size( tbl ) = 3 then
        Add( result, [ "AlternatingGroup", [ 3 ] ] );
      fi;
    fi;

    if IsDihedralCharacterTable( tbl ) then
      Add( result, [ "DihedralGroup", [ Size( tbl ) ] ] );
      if Size( tbl ) = 6 then
        Add( result, [ "SymmetricGroup", [ 3 ] ] );
        Add( result, [ "PSL", [ 2, 2 ] ] );
        Add( result, [ "PSU", [ 2, 2 ] ] );
        Add( result, [ "PSp", [ 2, 2 ] ] );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_basic.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.perf
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "perf" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "perf",
  description:= "mapping between CTblLib and  GAP's library of perfect groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_perf.json" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
           return List( l, val -> [ "PerfectGroup", val ] );
         end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "PerfectGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_perf:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_perf );
    end,
  create:= function( attr, id )
    local main, mainid, tbl, result, n, nr, pos, type, i, G;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_perf ) and
       IsBound( CTblLib.Data.attrvalues_perf.( id ) ) then
      return CTblLib.Data.attrvalues_perf.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    result:= [];
    if IsPerfectCharacterTable( tbl ) then
      n:= Size( tbl );
      nr:= NumberPerfectLibraryGroups( n );
      if IsPosInt( nr ) then
        if   NumberPerfectGroups( n ) = 1 then
          # If there is only one perfect group of this order
          # (and we believe this) then we assign the table name to it.
          pos:= 1;
        elif IsSimpleCharacterTable( tbl ) then
          # If the table is simple then compare isomorphism types.
          type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
          for i in [ 1 .. nr ] do
            G:= PerfectGroup( IsPermGroup, n, i );
            if IsSimpleGroup( G ) and
               IsomorphismTypeInfoFiniteSimpleGroup( G ).name = type.name then
              pos:= i;
              break;
            fi;
          od;
        else
          # Do the hard test.
#T perhaps compare the lattice of normal subgroups first?
          for i in [ 1 .. nr ] do
            G:= PerfectGroup( IsPermGroup, n, i );
            if NrConjugacyClasses( G ) = NrConjugacyClasses( tbl ) and
               IsRecord( TransformingPermutationsCharacterTables(
                         CharacterTable( G ), tbl ) ) then
              pos:= i;
              break;
            fi;
          od;
        fi;
        Add( result, [ n, pos ] );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= Set( result );
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_perf.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.prim
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "prim" );

# The library of primitive groups may be not (yet) loaded.
if IsBound( PRIMRANGE ) then
  CTblLib.MAXPRIMRANGE:= PRIMRANGE[ Length( PRIMRANGE ) ];
else
  CTblLib.MAXPRIMRANGE:= 2499;
fi;

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "prim",
  description:= "mapping between CTblLib and GAP's library of prim. groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_prim.json" ),
  dataDefault:= [ "no information", [] ],
  isSorted:= true,
  eval:= function( attr, l )
      return List( l[2], val -> [ "PrimitiveGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "PrimitiveGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2][2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local result, i;

    CTblLib.Data.prepare( attr );

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_prim:= rec();
    end,

  cleanupAfterAttributeComputation:= function( attr )
    CTblLib.Data.cleanup( attr );
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_prim );
    end,

  create:= function( attr, id )
    local main, mainid, tbl, nsg, nsgsizes, n, solvmin, deg, cand, result,
          type, G, gcd, dupl, names, name, simp, outinfo, info, facttbl, der,
          socle, soclefact, tbls, tblpos, cand2, try, mustbesplit, fuscand,
          s, pos;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_prim ) and
       IsBound( CTblLib.Data.attrvalues_prim.( id ) ) then
      return CTblLib.Data.attrvalues_prim.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );

    # Let $G$ be a primitive permutation group of degree $n$
    # that contains a *solvable* minimal normal subgroup $N$.
    # Then we have $|N| = n$, $|G|$ divides $|N|!$, $G$ is centerless
    # (Any point stabilizer $M$ is maximal in $G$, and $M \cap Z(G)$ is
    # contained in $Core_G(M)$, which is trivial; if $Z(G)$ is nontrivial
    # then $G = \langle M, Z(G) \rangle \cong M \times Z(G)$, contradiction.),
    # $N$ is the unique minimal normal subgroup of $G$,
    # and $G$ is a split extension of $N$.
    # (Proof:
    # Let $M$ be a core-free maximal subgroup of index $n$ in $G$.
    # Then $M \cap N$ is invariant under $M$ and (since $N$ is abelian)
    # under $N$, and because $N$ is not contained in $M$, we have $G = M N$,
    # so $M \cap N$ is normal in $G$ and hence $|M \cap N| = 1$.
    # This implies $n = [G:M] = |N|$, and clearly $G$ embeds into $Sym(n)$.
    # If $G$ would contain a nontrivial central subgroup $Z$ of prime order
    # then $|M \cap Z| = 1$ holds, which implies that $M$ is normal in $G$,
    # a contradiction.
    # Obviously $G$ cannot contain another *solvable* minimal normal
    # subgroup.  Suppose there is a nonsolvable minimal normal subgroup $T$,
    # say.  Then $T$ commutes with $N$, so $T \cap M$ is normal in $M$ and
    # commutes with $N$, hence is normal in $G$ and thus trivial --but this
    # implies that $G$ is a split extension of $T$ with $M$, hence the order
    # of $T$ is the prime power $n$, a contradiction.)

    # So we can immediately exclude tables with nontrivial centre,
    # as well as tables with a minimal normal subgroup $N$ of prime power
    # order that is either *larger* than the largest degree in the library
    # of primitive groups
    # or *too small* in the sense that the group order does not divide the
    # factorial of $|N|$.
    # Also note that for tables with a minimal normal subgroup $N$
    # of prime power order, the only possible degree is $|N|$,
    # and the table must admit a class fusion from the factor modulo $N$,
    # corresponding to the embedding of the point stabilizer
    # (so nonsplit extensions may be excluded using the character table).

    if 1 < Length( ClassPositionsOfCentre( tbl ) ) then
      if IsBound( CTblLib.Data.attrvalues_prim ) then
        CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      fi;
      return attr.dataDefault;
    fi;
    nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl );
    nsgsizes:= List( nsg, x -> Sum( SizesConjugacyClasses( tbl ){ x } ) );
    n:= Size( tbl );
    solvmin:= Filtered( nsgsizes, IsPrimePowerInt );
    if   Length( solvmin ) >= 1 and Length( nsg ) > 1 then
      # A primitive group containing a solvable minimal subgroup cannot
      # contain another minimal normal subgroup.
      if IsBound( CTblLib.Data.attrvalues_prim ) then
        CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      fi;
      return attr.dataDefault;
    elif Length( solvmin ) = 1 then
      # We know the possible degree.
      deg:= solvmin[1];
      if deg > CTblLib.MAXPRIMRANGE or Factorial( deg ) mod n <> 0 then
#T the factorial value is no longer cached, thus we can do better
#T (n is much smaller than it):
#T some prime divisor of n is larger than deg,
#T or some prime power dividing n does not divide the factorial
#T (compute this condition)
        if IsBound( CTblLib.Data.attrvalues_prim ) then
          CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
        fi;
        return attr.dataDefault;
      fi;
      # Use only those invariants that are already stored for the groups
      # in the GAP library of primitive groups;
      # for example, do not force computing the number of conjugacy classes.
      cand:= AllPrimitiveGroups(
                 NrMovedPoints, deg,
                 Size, n,
                 IsSimple, IsSimple( tbl ),
                 IsSolvable, IsSolvable( tbl ),
                 IsPerfect, IsPerfect( tbl ) );
    else
      # Use only those invariants that are already stored for the groups
      # in the GAP library of primitive groups;
      # for example, do not force computing the number of conjugacy classes.
      cand:= AllPrimitiveGroups(
                 # avoid the annoying ``Degree restricted to ...'' message.
                 NrMovedPoints, [ 1 .. CTblLib.MAXPRIMRANGE ],
                 Size, n,
                 IsSimple, IsSimple( tbl ),
                 IsSolvable, IsSolvable( tbl ),
                 IsPerfect, IsPerfect( tbl ) );
    fi;
    if cand = [] then
      if IsBound( CTblLib.Data.attrvalues_prim ) then
        CTblLib.Data.attrvalues_prim.( id ):= attr.dataDefault;
      fi;
      return attr.dataDefault;
    fi;
    result:= [];
    if   IsSimple( tbl ) then
      # The isomorphism type of simple tables can be determined.
      # Simply assign the name to the simple group.
      type:= IsomorphismTypeInfoFiniteSimpleGroup( tbl );
      for G in cand do
        if IsomorphismTypeInfoFiniteSimpleGroup( G ).name = type.name then
          Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
        fi;
      od;
      result:= [ "simple group", result ];
      if IsBound( CTblLib.Data.attrvalues_prim ) then
        CTblLib.Data.attrvalues_prim.( id ):= result;
      fi;
      return result;
    elif IsPerfect( tbl ) and NumberPerfectGroups( n ) = 1 then
      # If there is a unique perfect group of this order then we are done.
      for G in cand do
        Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
      od;
      result:= [ "unique perfect group of its order", result ];
      if IsBound( CTblLib.Data.attrvalues_prim ) then
        CTblLib.Data.attrvalues_prim.( id ):= result;
      fi;
      return result;
    fi;

    # For any minimal normal subgroup $N$ (not necessarily abelian)
    # in a primitive group, the degree of the action divides $|N|$ because
    # $N$ acts transitively.
    # So we can exclude all candidates that do not satisfy this condition.
    gcd:= Gcd( nsgsizes );
    cand:= Filtered( cand, G -> gcd mod NrMovedPoints( G ) = 0 );

    dupl:= attr.idenumerator.attributes.IdentifiersOfDuplicateTables;
    names:= Concatenation( [ id ], dupl.attributeValue( dupl, id ) );

    if IsAlmostSimpleCharacterTable( tbl ) then
      for name in names do
        # Determine the isomorphism type of the socle.
        # If the character table library provides enough information about
        # the automorphic extensions of this group then try to determine the
        # isomorphism type of the almost simple group.
        tbl:= CharacterTable( name );
        nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl );
        simp:= CTblLib.Data.CharacterTablesOfNormalSubgroupWithGivenImage(
                   tbl, nsg[1] );
        if not IsEmpty( simp )
           and HasExtensionInfoCharacterTable( simp[1][1] ) then
          simp:= simp[1][1];
          type:= IsomorphismTypeInfoFiniteSimpleGroup( simp );
          # The following list contains pairs `[ <nam>, <indices> ]'
          # where <nam> runs over the suffixes of the names of
          # full automorphism groups of simple groups that occur in the
          # character table library, and <indices> is a list of orders of
          # socle factors for which the isomorphism type of the extension
          # is uniquely determined by these orders.
          outinfo:= [
                      [ "2",      [ 2 ] ],
                      [ "3",      [ 3 ] ],
                      [ "4",      [ 2, 4 ] ],
                      [ "2^2",    [ 4 ] ],
                      [ "5",      [ 5 ] ],
                      [ "6",      [ 2, 3, 6 ] ],
                      [ "3.2",    [ 2, 3, 6 ] ],
                      [ "(2x4)",  [ 8 ] ],
                      [ "D8",     [ 8 ] ],
                      [ "D12",    [ 3, 4, 12 ] ],
                      [ "(2xD8)", [ 16 ] ],
                      [ "(S3x3)", [ 2, 9, 18 ] ],
                      [ "5:4",    [ 2, 4, 5, 10, 20 ] ],
                      [ "S4",     [ 3, 6, 8, 12, 24 ] ],
                    ];
          info:= ExtensionInfoCharacterTable( simp )[2];
          info:= First( outinfo, x -> x[1] = info );
          facttbl:= tbl / nsg[1];
          if   info = fail then
            Print( "#E problem: is the table of ", id,
                   " really almost simple?\n ");
          elif    Size( tbl ) / Size( simp ) in info[2]
               or ( info[1] = "(2x4)" and Size( tbl ) / Size( simp ) = 4
                                      and not IsCyclic( facttbl ) )
               or ( info[1] = "D8" and Size( tbl ) / Size( simp ) = 4
                                   and IsCyclic( facttbl ) )
               or ( info[1] = "D12" and Size( tbl ) / Size( simp ) = 6
                                    and IsCyclic( facttbl ) )
               or ( info[1] = "(S3x3)" and Size( tbl ) / Size( simp ) = 6 )
               or ( info[1] = "S4" and Size( tbl ) / Size( simp ) = 4
                                   and IsCyclic( facttbl ) ) then
            # We can identify the group.
            for G in cand do
              if IsAlmostSimpleGroup( G ) then
                der:= DerivedSeriesOfGroup( G );
                socle:= der[ Length( der ) ];
                soclefact:= G / socle;
                if type.name = IsomorphismTypeInfoFiniteSimpleGroup( socle ).name and
                   ( Size( tbl ) / Size( simp ) in info[2] or
                     ( info[1] = "(2x4)" and not IsCyclic( soclefact ) ) or
                     ( info[1] = "D8" and IsCyclic( soclefact ) ) or
                     ( info[1] = "D12" and IsCyclic( soclefact ) ) or
                     ( info[1] = "(S3x3)" and IsCyclic( soclefact )
                                          and IsCyclic( facttbl ) ) or
                     ( info[1] = "(S3x3)" and not IsCyclic( soclefact )
                                          and not IsCyclic( facttbl ) ) or
                     ( info[1] = "S4" and IsCyclic( soclefact ) ) ) then
                  Add( result, [ NrMovedPoints( G ),
                                 PrimitiveIdentification( G ) ] );
                fi;
              fi;
            od;

            result:= [ Concatenation( "unique almost simple group with the ",
                                      "given socle and socle factor" ),
                       result ];
            if IsBound( CTblLib.Data.attrvalues_prim ) then
              CTblLib.Data.attrvalues_prim.( id ):= result;
            fi;
            return result;
          else
            # Try to identify the extension of the socle by excluding
            # all but one of the possibilities
            # if we have all tables for these possibilities.
            outinfo:= [
                        [ "2^2",    [ [ 2, [ "2_1", "2_2", "2_3" ] ] ] ],
                        [ "(2x4)",  [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 4, [ "2^2", "4_1", "4_2" ] ] ] ],
                        [ "D8",     [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 4, [ "4", "(2^2)_{122}",
                                             "(2^2)_{133}" ] ] ] ],
                        [ "D12",    [ [ 2, [ "2_1", "2_2", "2_3" ] ],
                                      [ 6, [ "6", "3.2_2", "3.2_3" ] ] ] ],
                        [ "(S3x3)", [ [ 3, [ "3_1", "3_2", "3_3" ] ] ] ],
                        [ "S4",     [ [ 2, [ "2_1", "2_2" ] ],
                                      [ 4, [ "4", "(2^2)_{111}",
                                             "(2^2)_{122}" ] ] ] ],
                      ];
            info:= First( outinfo, x -> x[1] = info[1] );
            if info <> fail then
              info:= First( info[2],
                            x -> x[1] = Size( tbl ) / Size( simp ) );
              if info <> fail then
                tbls:= List( info[2],
                             s -> CharacterTable( Concatenation(
                                      Identifier( simp ), ".", s ) ) );
                if ForAll( tbls, IsCharacterTable ) then
                  tblpos:= First( [ 1 .. Length( tbls ) ],
                               i -> TransformingPermutationsCharacterTables(
                                        tbl, tbls[i] ) <> fail );
                  cand2:= [];
                  for G in cand do
                    if IsAlmostSimpleGroup( G ) then
                      der:= DerivedSeriesOfGroup( G );
                      socle:= der[ Length( der ) ];
                      if type.name = IsomorphismTypeInfoFiniteSimpleGroup( socle ).name
                         then
                        try:= CTblLib.FindTableForGroup( G, tbls, tblpos );
                        if try = true then
                          Add( result, [ NrMovedPoints( G ),
                                         PrimitiveIdentification( G ) ] );
                        elif try = fail then
                          Add( cand2, G );
                        fi;
                      fi;
                    fi;
                  od;
                  if cand2 = [] then
                    result:= [ Concatenation( "almost simple group with ",
                        "the given socle and socle factor that fits" ),
                               result ];
                    if IsBound( CTblLib.Data.attrvalues_prim ) then
                      CTblLib.Data.attrvalues_prim.( id ):= result;
                    fi;
                    return result;
                  else
#T inhomogeneous: some groups are detected, others are not ...
#T (problem for the comment string ...)
                    result:= [];
                  fi;
                fi;
              fi;
            fi;
          fi;
#T the following is no longer necessary, since we have the socle tables
#       else
#         # There are some cases where the table of the socle is not available,
#         # and where the almost simple group is determined by its order.
#         if Identifier( tbl ) in [ "O12+(2).2", "O12-(2).2" ] then
#           for G in cand do
#             if IsAlmostSimpleGroup( G ) then
#               der:= DerivedSeriesOfGroup( G );
#               socle:= der[ Length( der ) ];
#               soclefact:= G / socle;
#               type:= IsomorphismTypeInfoFiniteSimpleGroup( socle );
#               if ( Identifier( tbl ) = "O12+(2).2" and
#                    type.series = "D" and type.parameter = [ 6, 2 ] ) or
#                  ( Identifier( tbl ) = "O12-(2).2" and
#                    type.series = "2D" and type.parameter = [ 6, 2 ] ) then
#                 Add( result, [ NrMovedPoints( G ),
#                                PrimitiveIdentification( G ) ] );
#               fi;
#             fi;
#           od;
#           result:= [ Concatenation( "unique almost simple group with the ",
#                                     "given socle and socle factor" ),
#                      result ];
#           if IsBound( CTblLib.Data.attrvalues_prim ) then
#             CTblLib.Data.attrvalues_prim.( id ):= result;
#           fi;
#           return result;
#         fi;
        fi;
      od;
    fi;

    cand:= Filtered( cand, G -> IsAlmostSimpleCharacterTable( tbl )
                                = IsAlmostSimpleGroup( G ) );

    # Now deal with the case that the given character table belongs to
    # a group $G$ with a unique minimal normal subgroup $N$ of prime power
    # $p^d$, such that $G$ is a *split* extension of $N$, with complement $C$.
    # (This can be concluded either from the fact that $|N|$ and $[G:N]$ are
    # coprime, or from the fact that fusions from $C$ to $G$ and from $G$
    # onto $C$ are stored, such that the image of the embedding intersects
    # the kernel of the projection trivially.)
    # Then $C$ is maximal in $G$, so $G$ acts primitively on the cosets
    # of $C$.
    # (Note that for any maximal subgroup $M$ of $G$ that properly contains
    # $C$, the intersection $M \cap N$ is not trivial, so $M$ and thus also
    # $G = M N$ normalizes $M \cap N$, a contradiction to the minimality of
    # $N$.)
    # So if there is a unique primitive group of degree $|N|$ and of order
    # $|G|$ then it must belong to the given table --we do not check this!
    if Length( nsg ) = 1 then
      for name in names do
        tbl:= CharacterTable( name );
        nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
        n:= Sum( SizesConjugacyClasses( tbl ){ nsg } );
        if IsPrimePowerInt( n ) then
          # The minimal normal subgroup is elementary abelian.
          mustbesplit:= false;
          if Gcd( Size( tbl ) / n, n ) = 1 then
            mustbesplit:= true;
          else
            fuscand:= First( ComputedClassFusions( tbl ),
                             r -> ClassPositionsOfKernel( r.map ) = nsg );
            if fuscand <> fail then
              s:= CharacterTable( fuscand.name );
              if s <> fail then
                fuscand:= First( ComputedClassFusions( s ),
                                 r -> r.name = Identifier( tbl ) );
                if fuscand = fail then
                  if IsEmpty( PossibleClassFusions( s, tbl ) ) then
                    # The table is a nonsplit extension, hence not primitive.
                    result:= attr.dataDefault;
                    if IsBound( CTblLib.Data.attrvalues_prim ) then
                      CTblLib.Data.attrvalues_prim.( id ):= result;
                    fi;
                    return result;
                  fi;
                elif Intersection( fuscand.map, nsg ) = [ 1 ] then
                  # There is a subgroup fusion from the factor table,
                  # and the factor is really a complement.
                  mustbesplit:= true;
                fi;
              fi;
            else
              Info( InfoDatabaseAttributeX, 1,
                    "primitivity test: factor fusion missing on ",
                    Identifier( tbl ) );
            fi;
          fi;
          if mustbesplit then
            # The table belongs to a split extension,
            # so we know that it belongs to a primitive group.
            cand:= Filtered( cand, G -> n = NrMovedPoints( G ) );
            if Length( cand ) = 1 then
              # There is a unique primitive group of the relevant
              # degree that fits to the table.
              G:= cand[1];
              result:= [ "prim. group on solv. minimal normal subgroup",
                         [ [ n, PrimitiveIdentification( G ) ] ] ];
              if IsBound( CTblLib.Data.attrvalues_prim ) then
                CTblLib.Data.attrvalues_prim.( id ):= result;
              fi;
              return result;
            fi;

            cand:= Filtered( cand, G -> NrConjugacyClasses( G )
                                        = NrConjugacyClasses( tbl ) );
            if Length( cand ) = 1 then
              # There is a unique primitive group with the right number of
              # classes that fits to the table.
              G:= cand[1];
              result:= [
              "prim. group on solv. minimal normal subgroup (classes test)",
                  [ [ n, PrimitiveIdentification( G ) ] ] ];
              if IsBound( CTblLib.Data.attrvalues_prim ) then
                CTblLib.Data.attrvalues_prim.( id ):= result;
              fi;
              return result;
            fi;
          fi;
        fi;
      od;
    fi;

    if not IsEmpty( cand ) then
      if Size( tbl ) <= 5 * 10^7 then
        Info( InfoDatabaseAttributeX, 1,
              "primitivity test: hard test for ", Identifier( tbl ),
              " (", Length( cand ), " candidates)" );
        for G in cand do
          # Do the hard test.
          if NrConjugacyClasses( G ) = NrConjugacyClasses( tbl ) and
             IsRecord( TransformingPermutationsCharacterTables(
                       CharacterTable( G ), tbl ) ) then
            Add( result, [ NrMovedPoints( G ), PrimitiveIdentification( G ) ] );
          fi;
        od;
      else
        Info( InfoDatabaseAttributeX, 1,
              "primitivity test: omit hard test for ", Identifier( tbl ) );
      fi;
    fi;

    if IsEmpty( result ) then
      result:= attr.dataDefault;
    else
      result:= [ "hard test", result ];
    fi;

    # Cache the result.
    if IsBound( CTblLib.Data.attrvalues_prim ) then
      CTblLib.Data.attrvalues_prim.( id ):= result;
    fi;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [ "no information", [] ],
                                            true ),
  check:= function( id )
    local pos, entry, tbl, degrees, nsg, result, cand, nam, subtbl, fus, deg,
          i;

    pos:= Position( CTblLib.Data.GROUPINFO.prim.data[1], id );
    if pos = fail then
      return true;
    fi;
    entry:= CTblLib.Data.GROUPINFO.prim.data[3][ pos ];
    tbl:= CharacterTable( id );
    if tbl = fail then
      Print( "#I  no character table for `", id, "'\n" );
      return false;
    elif ForAny( entry, pair -> Size( PrimitiveGroup( pair[1], pair[2] ) )
                                <> Size( tbl ) ) then
      Print( "#I  different sizes for `", id, "'\n" );
      return false;
    fi;
    degrees:= Set( List( entry, pair -> pair[1] ) );
    nsg:= ClassPositionsOfNormalSubgroups( tbl );
    result:= true;
    if HasMaxes( tbl ) then
      # Delegate to an equivalent table where appropriate.
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        tbl:= CharacterTable( ConstructionInfoCharacterTable( tbl )[2][1] );
      fi;
      # If the tables of all maximal subgroups are known then check that
      # the primitive degrees are exactly the indices of the core-free
      # maximal subgroups (without multiplicity).
      cand:= [];
      for nam in Maxes( tbl ) do
        subtbl:= CharacterTable( nam );
        if subtbl = fail then
          Print( "#I  no character table for `", id, "'\n" );
          result:= false;
        else
          fus:= GetFusionMap( subtbl, tbl );
          if fus = fail then
            Print( "#I  no fusion `", nam, "' -> `", id, "'\n" );
            result:= false;
          elif ClassPositionsOfKernel( fus ) = [ 1 ]
               and Number( nsg, n -> IsSubset( Set( fus ), n ) ) = 1 then
            deg:= Size( tbl ) / Size( subtbl );
            if deg <= CTblLib.MAXPRIMRANGE then
              if deg in degrees then
                AddSet( cand, deg );
              else
                Print( "#E  maximal subgroup `", Identifier( subtbl ),
                       "' should yield degree ", deg, "\n" );
                result:= false;
              fi;
            fi;
          fi;
        fi;
      od;
      if degrees <> cand then
        Print( "#E  different prim. degrees for `", id, "'\n" );
        result:= false;
      fi;
    else
      # The indices of known core-free maximal subgroups yield primitive
      # degrees.
      for i in [ 1 .. 100 ] do
        subtbl:= CharacterTable( Concatenation( id, "M", String(i) ) );
        if subtbl <> fail then
          fus:= GetFusionMap( subtbl, tbl );
          if fus <> fail and ClassPositionsOfKernel( fus ) = [ 1 ]
                  and Number( nsg, n -> IsSubset( Set( fus ), n ) ) = 1 then
            deg:= Size( tbl ) / Size( subtbl );
            if deg <= CTblLib.MAXPRIMRANGE and not deg in degrees then
              Print( "#E  maximal subgroup `", Identifier( subtbl ),
                     "' should yield degree ", deg, "\n" );
              result:= false;
            fi;
          fi;
        fi;
      od;
    fi;
    return result;
  end,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.small
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "small" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "small",
  description:= "mapping between CTblLib and GAP's library of small groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_small.json" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
      return List( l, val -> [ "SmallGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "SmallGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "atlas", "basic", "perf", "prim", "tom", "trans",
                       "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_small:= rec();
    CTblLib.Data.prepare( attr );
    LIBTABLE.IsEquiv:= function( G, tbl )
      return IsRecord( TransformingPermutationsCharacterTables(
                           CharacterTable( G ), tbl ) );
      end;
    end,

  cleanupAfterAttributeComputation:= function( attr )
    CTblLib.Data.cleanup( attr );
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_small );
    Unbind( LIBTABLE.IsEquiv );
    end,

  create:= function( attr, id )
    local main, mainid, tbl, n, result, found, entry, G;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_small ) and
       IsBound( CTblLib.Data.attrvalues_small.( id ) ) then
      return CTblLib.Data.attrvalues_small.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    n:= Size( tbl );
    result:= attr.dataDefault;
    if IdGroupsAvailable( n ) then
      found:= GroupInfoForCharacterTable( tbl );
      if not IsEmpty( found ) then
        result:= [];
        for entry in found do
          G:= GroupForGroupInfo( entry );
          if   G = fail then
            Print( "#E  GroupForGroupInfo fails for ", entry, "\n" );
            continue;
          elif entry[1] = "SmallGroup" then
            # Verify all claimed 'SmallGroup' constructions.
            if TransformingPermutationsCharacterTables( tbl,
                   CharacterTable( G ) ) = fail then
              Error( "small groups test: wrong 'SmallGroup' construction ",
                     "for character table '", id, "'" );
            fi;
            AddSet( result, entry[2] );
          else
            # Trust other constructions.
            # The group may be given on very many points,
            # so try to choose a better representation.
            if IsSolvableCharacterTable( tbl ) then
              G:= Image( IsomorphismPcGroup( G ) );
            elif IsPermGroup( G ) then
              G:= Image( SmallerDegreePermutationRepresentation( G : cheap ) );
            fi;
            AddSet( result, IdGroup( G ) );
          fi;
        od;
      elif n in [ 1152, 1920 ] or n mod 256 = 0 then
        # The access to library groups would take too long.
        Info( InfoDatabaseAttributeX, 1,
              "small groups test: omit ", Identifier( tbl ),
              " (too expensive for order ", n, ")" );
      else
        # Use the access via the small groups library.
        result:= IdsOfAllSmallGroups( Size, n,
                     IsAbelian, IsAbelian( tbl ),
                     IsNilpotentGroup, IsNilpotent( tbl ),
                     IsSupersolvableGroup, IsSupersolvable( tbl ),
                     IsSolvableGroup, IsSolvable( tbl ),
                     IsSimple, IsSimple( tbl ),
                     IsPerfect, IsPerfect( tbl ),
                     NrConjugacyClasses, NrConjugacyClasses( tbl ),
                     G -> LIBTABLE.IsEquiv( G, tbl ), true );
        if IsEmpty( result ) then
          # This should never happen.
          Error( "small groups test: no group found for table '", id, "'" );
        fi;
        # The following is necessary in a loop over several tables.
        UnloadSmallGroupsData();
      fi;
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_small.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.trans
##
CTblLib.TRANSDEGREES:= 30;

Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "trans" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "trans",
  description:= "mapping between CTblLib and GAP's library of trans. groups",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_trans.json" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= function( attr, l )
    return List( l, val -> [ "TransitiveGroup", val ] );
    end,
  reverseEval:= function( attr, info )
    local data, entry;

    if info[1] = "TransitiveGroup" then
      if not IsBound( attr.data )  then
        Read( attr.datafile );
      fi;
      for data in [ attr.data.automatic, attr.data.nonautomatic ] do
        for entry in data do
          if info[2] in entry[2] then
            return entry[1];
          fi;
        od;
      od;
    fi;
    return fail;
    end,
  neededAttributes:= [ "IsDuplicateTable", "IdentifiersOfDuplicateTables" ],
  prepareAttributeComputation:= function( attr )
    local i;

    CTblLib.Data.invposition:= InverseMap( LIBLIST.position );
    for i in [ 1 .. Length( CTblLib.Data.invposition ) ] do
      if IsInt( CTblLib.Data.invposition[i] ) then
        CTblLib.Data.invposition[i]:= [ CTblLib.Data.invposition[i] ];
      fi;
    od;
    CTblLib.Data.attrvalues_trans:= rec();
    end,
  cleanupAfterAttributeComputation:= function( attr )
    Unbind( CTblLib.Data.invposition );
    Unbind( CTblLib.Data.attrvalues_trans );
    end,
  create:= function( attr, id )
    local main, mainid, tbl, result, cand, G;

    # For duplicate tables, take (and cache) the result for the main table.
    main:= attr.idenumerator.attributes.IdentifierOfMainTable;
    mainid:= main.attributeValue( main, id );
    if mainid <> fail then
      id:= mainid;
    fi;
    if IsBound( CTblLib.Data.attrvalues_trans ) and
       IsBound( CTblLib.Data.attrvalues_trans.( id ) ) then
      return CTblLib.Data.attrvalues_trans.( id );
    fi;

    # Now we know that we have to work.
    tbl:= CharacterTable( id );
    result:= [];

# If the table belongs to a transitive permutation group of degree $n$
# then there must be a nontrivial rationally irreducible character
# of degree at most $n-1$.
# Moreover, the intersection of kernels of the rationally irreducible
# characters of degree up to $n-1$ must be trivial.
# -> does this help?

# Try a class fusion of tbl into Sym( CTblLib.TRANSDEGREES ),
# using only orders and centralizer orders:
# CTblLib.TRANSDEGREES; # 30
# NrPartitions( 30 ); # 5604
# gen:= CharacterTable( "Symmetric" );
# cl:= gen.classparam[1]( CTblLib.TRANSDEGREES );;
# cent:= List( cl, x -> gen.centralizers[1]( CTblLib.TRANSDEGREES, x ) );;
# ord:= List( cl, x -> gen.orders[1]( CTblLib.TRANSDEGREES, x ) );;
# -> now InitFusion!
# -> does this help?

    # Just check the obvious invariants;
    # do not try `PermChars' for excluding some tables,
    # because computing the irreducibles is faster in most cases.
    cand:= AllTransitiveGroups(
      NrMovedPoints, [ 2 .. CTblLib.TRANSDEGREES ],
      Size, Size( tbl ),
      AbelianInvariants, AbelianInvariants( tbl ),
      G -> Size( Centre( G ) ), Length( ClassPositionsOfCentre( tbl ) ),
      NrConjugacyClasses, NrConjugacyClasses( tbl ) );
    for G in cand do
      if IsRecord( TransformingPermutationsCharacterTables(
                   CharacterTable( G ), tbl ) ) then
        Add( result, [ NrMovedPoints( G ), TransitiveIdentification( G ) ] );
      fi;
    od;
    if IsEmpty( result ) then
      result:= attr.dataDefault;
    fi;

    # Cache the result.
    CTblLib.Data.attrvalues_trans.( id ):= result;

    return result;
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.factorsOfDirectProduct
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable,
     "factorsOfDirectProduct" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "factorsOfDirectProduct",
  description:= "direct factors of a direct product",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_dirprod.json" ),
  isSorted:= true,
  eval:= function( attr, l )
    return List( l, val -> [ "DirectProductByNames", val ] );
    end,
  neededAttributes:= [],
  create:= function( attr, id )
    local tbl, dp, constr;

    tbl:= CharacterTable( id );
    dp:= ClassPositionsOfDirectProductDecompositions( tbl );
    if IsEmpty( dp ) then
      # The table is not a nontrivial direct product.
      return attr.dataDefault;
    elif HasConstructionInfoCharacterTable( tbl ) then
      constr:= ConstructionInfoCharacterTable( tbl );
      if constr[1] = "ConstructDirectProduct" then
        # The factorization is stored.
        return [ constr[2] ];
      elif constr[1] = "ConstructPermuted" and Length( constr[2] ) = 1 then
        # Delegate to a better table.
        return attr.create( attr, constr[2][1] );
      fi;
    fi;

    # The table is a nontrivial direct product, but we do not know factors.
    return [ "fail" ];
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsNontrivialDirectProduct
##
AddSet( CTblLib.SupportedAttributes, "IsNontrivialDirectProduct" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsNontrivialDirectProduct",
  description:= "is this character table a direct product of smaller ones",
  type:= "values",
  name:= "IsNontrivialDirectProduct",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "nontrivial direct product";
    else
      return "not a nontrivial direct product";
    fi;
    end,
  neededAttributes:= [ "factorsOfDirectProduct" ],
  create:= function( attr, id )
    local otherattr;

    otherattr:= attr.idenumerator.attributes.factorsOfDirectProduct;
    return not IsEmpty( otherattr.attributeValue( otherattr, id ) );
    end,
  version:= CTblLib.Data.IdEnumerator.version,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "dir. prod.?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.KnowsSomeGroupInfo
##
AddSet( CTblLib.SupportedAttributes, "KnowsSomeGroupInfo" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "KnowsSomeGroupInfo",
  description:= "accumulated info about group info attributes",
  type:= "values",
  name:= "KnowsSomeGroupInfo",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "group info available";
    else
      return "no group info available";
    fi;
    end,
  neededAttributes:=
      CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable,
  create:= function( attr, id )
    local nam, otherattr;

    for nam in CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable do
      otherattr:= attr.idenumerator.attributes.( nam );
      if not IsEmpty( otherattr.attributeValue( otherattr, id ) ) then
        return true;
      fi;
    od;

    return false;
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "group?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsAbelian
##
AddSet( CTblLib.SupportedAttributes, "IsAbelian" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsAbelian",
  description:= "are GAP library character tables abelian",
  type:= "values",
  name:= "IsAbelian",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "abelian";
    else
      return "nonabelian";
    fi;
    end,
  neededAttributes:= [ "Size", "NrConjugacyClasses" ],
  create:= function( attr, id )
    local size, nccl;

    size:= attr.idenumerator.attributes.Size;
    nccl:= attr.idenumerator.attributes.NrConjugacyClasses;
    return size.attributeValue( size, id ) = nccl.attributeValue( nccl, id );
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "abelian?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.AbelianInvariants
##
AddSet( CTblLib.SupportedAttributes, "AbelianInvariants" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "AbelianInvariants",
  description:= "abelian invariants of GAP library character tables",
  type:= "pairs",
  name:= "AbelianInvariants",
#T cheaper construction than via the tables:
#T if the irreducibles are explicitly given then
#T first check the no. of linear characters (if 1 or prime then clear)
#T and the orders of their irrationalities
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_abinv.json" ),
  dataDefault:= fail,
  neededAttributes:= [],
  isSorted:= true,
  string:= entry -> CTblLib.AttrDataString( entry, fail, false ),
  check:= ReturnTrue,

  align:= "t",
  viewLabel:= "ab. inv.",
  widthCol:= 15,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsPerfect
##
AddSet( CTblLib.SupportedAttributes, "IsPerfect" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsPerfect",
  description:= "are GAP library character tables perfect",
  type:= "values",
  name:= "IsPerfect",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "perfect";
    else
      return "not perfect";
    fi;
    end,
  neededAttributes:= [ "AbelianInvariants" ],
  create:= function( attr, id )
    local abinv;

    abinv:= attr.idenumerator.attributes.AbelianInvariants;
    return IsEmpty( abinv.attributeValue( abinv, id ) );
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "perfect?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.almostSimpleInfo
##
DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "almostSimpleInfo",
  description:= "socle type and socle factor type of an almost simple group",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_asinfo.json" ),
  isSorted:= true,
  dataDefault:= fail,
  neededAttributes:= [ "Size" ],
  create:= function( attr, id )
    local tbl, nsg, soclesize, cand, socle, cand2, soclefactor;

    tbl:= CharacterTable( id );
    if IsSimple( tbl ) and not IsPrimeInt( Size( tbl ) ) then
      # Replace the name by the "main" name.
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        id:= ConstructionInfoCharacterTable( tbl )[2][1];
      fi;
      return [ id, [ 1, 1 ] ];
    elif not IsAlmostSimple( tbl ) then
      # The table is not almost simple.
      return attr.dataDefault;
    fi;
    # There is a unique minimal normal subgroup.
    nsg:= ClassPositionsOfMinimalNormalSubgroups( tbl )[1];
    soclesize:= Sum( SizesConjugacyClasses( tbl ){ nsg }, 0 );
    cand:= AllCharacterTableNames( Size, soclesize );
    # Do not call `IsSimple' as a filter here,
    # because the `IsSimple' attribute is derived from the current one.
    cand:= Filtered( List( cand, CharacterTable ), IsSimple );
    if IsEmpty( cand ) then
      # We do not have the character table of the socle,
      # but we have to create an entry because the table is almost simple.
      Info( InfoDatabaseAttributeX, 1, "socle not available for ", id );
      socle:= fail;
    else
      # Find the "main" table of the socle.
      cand:= Filtered( cand, t -> not IsDuplicateTable( t ) );
      if Length( cand ) <> 1 then
        # Take only those that admit a fusion into `tbl'.
        cand2:= Filtered( cand, t -> ForAny( ComputedClassFusions( t ),
                                             r -> r.name = id ) );
        if IsEmpty( cand2 ) then
          cand:= Filtered( cand, t -> PossibleClassFusions( t, tbl ) <> [] );
        else
          cand:= cand2;
        fi;
      elif not IsBound(
           IsomorphismTypeInfoFiniteSimpleGroup( soclesize ).series ) then
        # There is more than one simple group of this order,
        # but the library contains just one of them.
        return fail;
      fi;
      if Length( cand ) <> 1 then
        Info( InfoDatabaseAttributeX, 1, "socle not identified for ", id );
        return fail;
      fi;
      socle:= Identifier( cand[1] );
    fi;
    soclefactor:= tbl / nsg;
    soclefactor:= First( AllSmallGroups( Size, Size( soclefactor ) ),
                         g -> TransformingPermutationsCharacterTables(
                                CharacterTable( g ), soclefactor ) <> fail );
    return [ socle, IdGroup( soclefactor ) ];
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsAlmostSimple
##
AddSet( CTblLib.SupportedAttributes, "IsAlmostSimple" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsAlmostSimple",
  description:= "are GAP library character tables almost simple",
  type:= "values",
  name:= "IsAlmostSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "almost simple";
    else
      return "not almost simple";
    fi;
    end,
  neededAttributes:= [ "almostSimpleInfo" ],
  create:= function( attr, id )
    local asinfo;

    asinfo:= attr.idenumerator.attributes.almostSimpleInfo;
    return asinfo.attributeValue( asinfo, id ) <> fail;
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "almost simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.quasisimpleInfo
##
DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "quasisimpleInfo",
  description:= "centre type and type of simple factor of a quasisimple group",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "attr_qsinfo.json" ),
  isSorted:= true,
  dataDefault:= fail,
  neededAttributes:= [ "Size" ],
  create:= function( attr, id )
    local tbl, nsg, centresize, factsize, cand, fact, facttbl, ords, centre;

    tbl:= CharacterTable( id );
    if IsSimple( tbl ) and not IsPrimeInt( Size( tbl ) ) then
      # Replace the name by the "main" name.
      if HasConstructionInfoCharacterTable( tbl ) and
         IsList( ConstructionInfoCharacterTable( tbl ) ) and
         ConstructionInfoCharacterTable( tbl )[1] = "ConstructPermuted" and
         Length( ConstructionInfoCharacterTable( tbl )[2] ) = 1 then
        id:= ConstructionInfoCharacterTable( tbl )[2][1];
      fi;
      return [ [ 1, 1 ], id ];
    elif not IsQuasisimple( tbl ) then
      # The table is not almost simple.
      return attr.dataDefault;
    fi;
    # There is a unique minimal normal subgroup.
    nsg:= ClassPositionsOfCentre( tbl );
    centresize:= Sum( SizesConjugacyClasses( tbl ){ nsg }, 0 );
    factsize:= Size( tbl ) / centresize;
    cand:= AllCharacterTableNames( Size, factsize,
               IsDuplicateTable, false, IsSimple, true );
    if IsEmpty( cand ) then
      # We do not have the character table of the simple factor,
      # but we have to create an entry because the table is quasisimple.
      Info( InfoDatabaseAttributeX, 1, "simple factor not available for ", id );
      fact:= fail;
    elif IsBound(
           IsomorphismTypeInfoFiniteSimpleGroup( factsize ).series ) then
      # There is exactly one simple group of this order.
      if Length( cand ) > 1 then
        Error( "there should be only one simple group of the given order" );
      fi;
      fact:= cand[1];
    else
      facttbl:= tbl / nsg;
      cand:= Filtered( cand,
                 name -> TransformingPermutationsCharacterTables(
                             CharacterTable( name ), facttbl ) <> fail );
      if Length( cand ) > 1 then
        Error( "there should be only one simple group that fits" );
      fi;
      fact:= cand[1];
    fi;
    ords:= Collected( OrdersClassRepresentatives( tbl ){ nsg } );
    centre:= Filtered( AllSmallGroups( Size, Length( nsg ), IsAbelian, true ),
                 g -> Collected( List( Elements( g ), Order ) ) = ords );
    if Length( centre ) > 1 then
      Error( "there should be only one abelian group that fits" );
    fi;
    return [ IdGroup( centre[1] ), cand[1] ];
    end,
  string:= entry -> CTblLib.AttrDataString( entry, [], false ),
  check:= ReturnTrue,
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsQuasisimple
##
AddSet( CTblLib.SupportedAttributes, "IsQuasisimple" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsQuasisimple",
  description:= "are GAP library character tables quasisimple",
  type:= "values",
  name:= "IsQuasisimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "quasisimple";
    else
      return "not quasisimple";
    fi;
    end,
  neededAttributes:= [ "quasisimpleInfo" ],
  create:= function( attr, id )
    local asinfo;

    asinfo:= attr.idenumerator.attributes.quasisimpleInfo;
    return asinfo.attributeValue( asinfo, id ) <> fail;
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "quasisimple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsSimple
##
AddSet( CTblLib.SupportedAttributes, "IsSimple" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsSimple",
  description:= "are GAP library character tables simple",
  type:= "values",
  name:= "IsSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "simple";
    else
      return "not simple";
    fi;
    end,
  neededAttributes:= [ "almostSimpleInfo", "Size" ],
  create:= function( attr, id )
    local size, asinfo;

    size:= attr.idenumerator.attributes.Size;
    if IsPrimeInt( size.attributeValue( size, id ) ) then
      return true;
    fi;
    asinfo:= attr.idenumerator.attributes.almostSimpleInfo;
    asinfo:= asinfo.attributeValue( asinfo, id );
    return asinfo <> fail and asinfo[2] = [ 1, 1 ];
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsAtlasCharacterTable
##
AddSet( CTblLib.SupportedAttributes, "IsAtlasCharacterTable" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsAtlasCharacterTable",
  description:= "are GAP library character tables Atlas tables",
  type:= "values",
  name:= "IsAtlasCharacterTable",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "Atlas table";
    else
      return "not Atlas table";
    fi;
    end,
  neededAttributes:= [ "InfoText" ],
  create:= function( attr, id )
    local infotext;

    infotext:= attr.idenumerator.attributes.InfoText;
    return PositionSublist( infotext.attributeValue( infotext, id ),
                            "origin: ATLAS of finite groups" ) <> fail;
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "Atlas table?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.IsSporadicSimple
##
AddSet( CTblLib.SupportedAttributes, "IsSporadicSimple" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "IsSporadicSimple",
  description:= "are GAP library character tables sporadic simple",
  type:= "values",
  name:= "IsSporadicSimple",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "sporadic simple";
    else
      return "not sporadic simple";
    fi;
    end,
  neededAttributes:= [ "IsSimple", "Size" ],
  create:= function( attr, id )
    local issimple, size, info;

    issimple:= attr.idenumerator.attributes.IsSimple;
    if not issimple.attributeValue( issimple, id ) then
      return false;
    fi;
    size:= attr.idenumerator.attributes.Size;
    size:= size.attributeValue( size, id );
    info:= IsomorphismTypeInfoFiniteSimpleGroup( size );
    return     info <> fail
           and IsBound( info.series )
           and info.series = "Spor";
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "simple?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.KnowsDeligneLusztigNames
##
AddSet( CTblLib.SupportedAttributes, "KnowsDeligneLusztigNames" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "KnowsDeligneLusztigNames",
  description:= "availability of Deligne-Lusztig names",
  type:= "values",
  name:= "KnowsDeligneLusztigNames",
  align:= "c",
  categoryValue:= function( val )
    if val then
      return "Deligne-Lusztig names available";
    else
      return "no Deligne-Lusztig names available";
    fi;
    end,
  neededAttributes:= [],
  create:= function( attr, id )
    return DeltigLibGetRecord( id ) <> fail;
    end,
  viewValue:= x -> CTblLib.ReplacedEntry( x, [ false, true ],
                                                [ "-", "+" ] ),
  viewLabel:= "Deligne-Lusztig names?",
  sortParameters:= [ "add counter on categorizing", "yes" ],
  ) );


#############################################################################
##
#V  CTblLib.Data.IdEnumerator.attributes.indiv
##
##  The individual entries are added either via the list in `grp_indiv.json'
##  or via 'NotifyGroupInfoForCharacterTable'.
##  The latter happens for example in the `ctblocks' package.
##
Add( CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable, "indiv" );

DatabaseAttributeAddX( CTblLib.Data.IdEnumerator, rec(
  identifier:= "indiv",
  description:= "individual group constructions for CTblLib tables",
  type:= "pairs",
  datafile:= Filename( DirectoriesPackageLibrary( "ctbllib", "data" )[1],
                       "grp_indiv.json" ),
  dataDefault:= [],
  isSorted:= true,
  eval:= { attr, l } -> l,
  reverseEval:= function( attr, info )
    local data, entry;

    for data in [ attr.data.automatic, attr.data.nonautomatic ] do
      for entry in data do
        if info in entry[2] then
          return entry[1];
        fi;
      od;
    od;
    return fail;
    end,
  neededAttributes:= [],
  check:= ReturnTrue,
  ) );


#############################################################################
##
#F  CTblLib.FactorGroupOfPerfectSpaceGroup( <id> )
##
##  The groups that belong to the character tables on the microfiches that
##  belong to the book [HP89] are factor groups of perfect space groups.
##  For those tables which did not have other group information,
##  we provide group constructions according to the recipes in [HP89].
##
##  Permutation generators of the individual groups are stored in the
##  attribute 'indiv'.
##
##  The function 'CTblLib.FactorGroupOfPerfectSpaceGroup' is used in the
##  'GroupInfoForCharacterTable' output of the character tables in question.
##
CTblLib.FactorGroupOfPerfectSpaceGroup:= function( id )
    local attr, val;

    attr:= CTblLib.Data.IdEnumerator.attributes.indiv;
    val:= First( attr.attributeValue( attr, id ),
                 l -> l[1] = "FactorGroupOfPerfectSpaceGroup" );
    if val = fail then
      return fail;
    elif val[2] = "perms" then
      return Group( List( val[3], PermList ) );
    fi;
    Error( "<val> is not a supported group construction" );
end;


#############################################################################
##
#F  CTblLib.IndividualGroupConstruction( <id> )
##
##  The character tables for which this function yields group generators
##  belong mainly to ATLAS groups, thus the group constructions may become
##  unnecessary as soon as extensions of the Atlas of Group Representations
##  provide better constructions (in terms of standard generators,
##  for example).
##
##  The function 'CTblLib.IndividualGroupConstruction' is used in the
##  'GroupInfoForCharacterTable' output of the character tables in question.
##
CTblLib.IndividualGroupConstruction:= function( id )
    local attr, val;

    attr:= CTblLib.Data.IdEnumerator.attributes.indiv;
    val:= First( attr.attributeValue( attr, id ),
                 l -> l[1] = "IndividualGroupConstruction" );
    if val = fail then
      return fail;
    elif val[2] = "perms" then
      return Group( List( val[3], PermList ) );
    elif val[2] = "ffmats" then
      return Group( List( val[3], s -> ScanMeatAxeFile( s, "string" ) ) );
    elif val[2] = "codepcgroup" then
      return PcGroupCode( val[3], val[4] );
    fi;
    Error( "<val> is not a supported group construction" );
end;


#############################################################################
##
##  Provide a data structure for private extensions of the table library.
##  We create a second id enumerator with the same attributes as
##  'CTblLib.Data.IdEnumerator', which is initially empty.
##  Identifiers get added by 'NotifyCharacterTableNames'.
##
##  Attribute values are cached when the tables are accessed for the first
##  time.
##  Moreover, it is possible to precompute the values, and to store them
##  in appropriate files.
##
##  'AllCharacterTableNames', 'OneCharacterTableName',
##  'BrowseCTblLibInfo', and 'GroupInfoForCharacterTable'
##  use the stored information.
##
CTblLib.Data.IdEnumeratorExt:= DatabaseIdEnumeratorX( rec(
    identifiers:= CTblLib.Data.IdEnumeratorExt.identifiers,
    isSorted:= false,
    entry:= function( idenum, id ) return CharacterTable( id ); end,
    version:= "",
    update:= ReturnTrue,
    viewSort:= CTblLib.Data.IdEnumerator.viewSort,
    align:= CTblLib.Data.IdEnumerator.align,
  ) );

CTblLib.ExtendAttributeOfIdEnumeratorExt:= function( name, eval )
    local attr, r;

    attr:= CTblLib.Data.IdEnumerator.attributes.( name );
    r:= rec( identifier:= attr.identifier,
             description:= attr.description,
             align:= attr.align,
             categoryValue:= attr.categoryValue,
             viewValue:= attr.viewValue,
             attributeValue:= attr.attributeValue,
           );
    if IsBound( attr.name ) then
      # We can compute the value at runtime if necessary.
      r.type:= "values";
      r.data:= [];
      r.name:= attr.name;
      if IsBound( attr.create ) then
        r.create:= attr.create;
      fi;
    else
      # We do not compute values at runtime.
      r.type:= "pairs";
      r.data:= rec( automatic:= [], nonautomatic:= [] );
    fi;
    if eval and IsBound( attr.eval ) then
      r.eval:= attr.eval;
    fi;
    DatabaseAttributeAddX( CTblLib.Data.IdEnumeratorExt, r );
end;

# Note that the attribute 'atlas' is not yet known here.
CallFuncList( function()
    local name;

    for name in Difference( RecNames( CTblLib.Data.IdEnumerator.attributes ),
                            [ "self" ] ) do
      # Do not set the 'eval' component,
      # we rely on this in 'CTblLib.SetAttributesForSpinSymTable'.
      CTblLib.ExtendAttributeOfIdEnumeratorExt( name, false );
    od;
    end, [] );


#############################################################################
##
#E

