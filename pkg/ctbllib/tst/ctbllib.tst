#############################################################################
##
#W  ctbllib.tst         GAP character table library             Thomas Breuer
##

gap> START_TEST( "ctbllib.tst");

#
gap> LoadPackage( "ctbllib", false );
true

#
gap> tbl:= CharacterTable( "A5" );;
gap> Print( CASString( tbl ), "\n" );
'A5'
00/00/00. 00.00.00.
(5,5,0,5,-1,0)
text:
(#origin: ATLAS of finite groups, tests: 1.o.r., pow[2,3,5]#),
order=60,
centralizers:(
60,4,3,5,5
),
reps:(
1,2,3,5,5
),
powermap:2(
1,1,3,5,4
),
powermap:3(
1,2,1,5,4
),
powermap:5(
1,2,3,1,1
),
fusion:'A5.2'(
1,2,3,4,4
),
fusion:'A6'(
1,2,3,6,7
),
fusion:'L2(11)'(
1,2,3,4,5
),
fusion:'L2(16)'(
1,2,3,4,5
),
fusion:'L2(19)'(
1,2,3,4,5
),
fusion:'L2(29)'(
1,2,3,4,5
),
fusion:'L2(31)'(
1,2,3,5,6
),
fusion:'L2(109)'(
1,30,21,41,52
),
fusion:'L2(125)'(
1,34,55,2,3
),
fusion:'2^4:A5'(
1,3,7,8,9
),
fusion:'J2'(
1,3,5,9,10
),
fusion:'S6(3)'(
1,3,10,14,14
),
fusion:'P1/G1/L1/V1/ext2'(
1,4,7,11,12
),
characters:
(1,1,1,1,1
,0:0)
(3,-1,0,
<w5,-w1-w4
>
,
<w5,-w2-w3
>

,0:0)
(3,-1,0,
<w5,-w2-w3
>
,
<w5,-w1-w4
>

,0:0)
(4,0,1,-1,-1
,0:0)
(5,1,-1,0,0
,0:0);
/// converted from GAP

# Try 'CharacterTableDirectProduct' in all four combinations.
gap> t1:= CharacterTable( "Cyclic", 2 );
CharacterTable( "C2" )
gap> t2:= CharacterTable( "Cyclic", 3 );
CharacterTable( "C3" )
gap> t1 * t1;
CharacterTable( "C2xC2" )
gap> ( t1 mod 2 ) * ( t1 mod 2 );
BrauerTable( "C2xC2", 2 )
gap> ( t1 mod 2 ) * t2;
BrauerTable( "C2xC3", 2 )
gap> t2 * ( t1 mod 2 );
BrauerTable( "C3xC2", 2 )

# Test the generalized contruction of isoclinic tables.
# (The extended functionality is available in GAP 4.11.)
gap> iso:= CharacterTableIsoclinic( CharacterTable( "2.A5.2" ) );
CharacterTable( "Isoclinic(2.A5.2)" )
gap> TransformingPermutationsCharacterTables( iso,
>        CharacterTable( "Isoclinic(2.A5.2)" ) ) <> fail;
true
gap> lib:= CharacterTable( "3.L3(4).3" );;
gap> iso:= CharacterTableIsoclinic( lib );
CharacterTable( "Isoclinic(3.L3(4).3,1)" )
gap> for p in [ 2, 3, 5, 7 ] do
>      poss:= PossiblePowerMaps( iso, p );
>      if Length( poss ) <> 1 or poss[1] <> PowerMap( iso, p ) then
>        Error( p );
>      fi;
>    od;
gap> iso2:= CharacterTableIsoclinic( lib, rec( k:= 2 ) );
CharacterTable( "Isoclinic(3.L3(4).3,2)" )
gap> for p in [ 2, 3, 5, 7 ] do
>      poss:= PossiblePowerMaps( iso2, p );
>      if Length( poss ) <> 1 or poss[1] <> PowerMap( iso2, p ) then
>        Error( p );
>      fi;
>    od;
gap> TransformingPermutationsCharacterTables( lib, iso );
fail
gap> TransformingPermutationsCharacterTables( lib, iso2 );
fail
gap> TransformingPermutationsCharacterTables( iso, iso2 );
fail
gap> g:= ExtraspecialGroup( 27, "+" );;
gap> t:= CharacterTable( g );;
gap> g2:= ExtraspecialGroup( 27, "-" );;
gap> t2:= CharacterTable( g2 );;
gap> nsg:= ClassPositionsOfNormalSubgroups( t );
[ [ 1 ], [ 1, 4, 8 ], [ 1, 2, 4, 5, 8 ], [ 1, 3, 4, 7, 8 ], 
  [ 1, 4, 6, 8, 11 ], [ 1, 4, 8, 9, 10 ], [ 1 .. 11 ] ]
gap> iso:= CharacterTableIsoclinic( t,
>              rec( normalSubgroup:= [ 1, 2, 4, 5, 8 ] ) );;
gap> TransformingPermutationsCharacterTables( iso, t2 ) <> fail;
true
gap> iso2:= CharacterTableIsoclinic( t,
>               rec( normalSubgroup:= [ 1, 2, 4, 5, 8 ], k:= 2 ) );;
gap> TransformingPermutationsCharacterTables( iso, iso2 ) <> fail;
true
gap> t:= CharacterTable( "3.L3(4).3" );;
gap> iso:= CharacterTableIsoclinic( lib );
CharacterTable( "Isoclinic(3.L3(4).3,1)" )
gap> br:= BrauerTable( iso, 2 );
BrauerTable( "Isoclinic(3.L3(4).3,1)", 2 )
gap> fail in Flat( DecompositionMatrix( br ) );
false

# Test that the ordering of classes in isoclinic tables is as expected.
# (Changes in the GAP library may mix up the tables.)
gap> t:= CharacterTable( "4_1.L3(4).2_3" );;
gap> iso:= CharacterTableIsoclinic( t, [ 1 .. 4 ] );;
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( t ) ],
>                        ClassPositionsOfDerivedSubgroup( t ) );;
gap> if PowerMap( iso, 2 ){ outer{ [ 1 .. 4 ] } } <> [ 2, 4, 2, 4 ] then
>      # If the power map is [ ..., 4, 2, 4, 2, ... ] then
>      # the table can be correct, but we want
>      # --for example for the library table "4_1.L3(4).2_3*"--
>      # that the *first* generator of the centre appears first.
>      Error( "wrong ordering of classes for isoclinic table" );
>    fi;
gap> Irr( iso ) = Irr( CharacterTable( "4_1.L3(4).2_3*" ) );
true

# Test some variants of 'AllCharacterTableNames' and 'OneCharacterTableName'.
# 1. no conditions, without sorting or with cheap sorting
gap> res:= AllCharacterTableNames();;
gap> Length( res ) = Length( AllCharacterTableNames( : OrderedBy:= Size ) );
true
gap> OneCharacterTableName() <> fail;
true
gap> OneCharacterTableName( : OrderedBy:= Size ) <> fail;
true

# 2. cheap condition, without or with cheap or expensive sorting
gap> fun:= tbl -> Size( tbl );;  # is not detected as 'Size'
gap> res:= AllCharacterTableNames( Size, 6 );;
gap> Length( res ) = Length( AllCharacterTableNames( Size, 6 : OrderedBy:= Size ) );
true
gap> Length( res ) = Length( AllCharacterTableNames( Size, 6 : OrderedBy:= fun ) );
true
gap> OneCharacterTableName( Size, 6 ) <> fail;
true
gap> OneCharacterTableName( Size, 6 : OrderedBy:= Size ) <> fail;
true
gap> OneCharacterTableName( Size, 6 : OrderedBy:= fun ) <> fail;
true

# 3. not cheap condition, without or with cheap or expensive sorting
gap> Length( res ) = Length( AllCharacterTableNames( fun, 6 ) );
true
gap> Length( res ) = Length( AllCharacterTableNames( fun, 6 : OrderedBy:= Size ) );
true
gap> Length( res ) = Length( AllCharacterTableNames( fun, 6 : OrderedBy:= fun ) );
true
gap> OneCharacterTableName( fun, 6 ) <> fail;
true
gap> OneCharacterTableName( fun, 6 : OrderedBy:= Size ) <> fail;  # should be fast
true
gap> OneCharacterTableName( fun, 6 : OrderedBy:= fun ) <> fail;
true

# 4. unorthodox condition
gap> AllCharacterTableNames( Identifier, x -> ForAll( x, IsAlphaChar ) );;
gap> AllCharacterTableNames( InfoText, IsEmpty );;

# Check the availability of representations for the tables.
gap> AllCharacterTableNames( KnowsSomeGroupInfo, false );;
gap> for name in AllCharacterTableNames() do
>      GroupInfoForCharacterTable( name );
>    od;

# Check that all ordinary tables can be loaded without problems,
# are internally consistent, and have power maps and automorphisms stored.
gap> easytest:= function( ordtbl )
>       if not IsInternallyConsistent( ordtbl ) then
>         Print( "#E  not internally consistent: ", ordtbl, "\n" );
>       elif Size( ordtbl ) <> 1 and ForAny( Factors( Size( ordtbl ) ),
>                p -> not IsBound( ComputedPowerMaps( ordtbl )[p] ) ) then
>         Print( "#E  some power maps are missing: ", ordtbl, "\n" );
>       elif not HasAutomorphismsOfTable( ordtbl ) then
>         Print( "#E  table automorphisms missing: ", ordtbl, "\n" );
>       fi;
>       return true;
> end;;
gap> AllCharacterTableNames( easytest, false );;

# Check that all Brauer tables can be loaded without problems
# and are internally consistent.
# (This covers the tables that belong to the library via 'MBT' calls
# as well as $p$-modular tables of $p$-solvable ordinary tables
# and tables of groups $G$ for which the Brauer table of $G/O_p(G)$ is
# contained in the library and the corresponding factor fusion is stored
# on the table of $G$.)
# For those tables which are stored in library files,
# check also that table automorphisms are stored.
gap> brauernames:= function( ordtbl )
>       local primes;
>       if Size( ordtbl ) = 1 then
>         return [];
>       fi;
>       primes:= Set( Factors( Size( ordtbl ) ) );
>       return List( primes, p -> Concatenation( Identifier( ordtbl ),
>                                     "mod", String( p ) ) );
> end;;
gap> easytest:= function( modtbl )
>       local libinfo;
>       if not IsInternallyConsistent( modtbl ) then
>         Print( "#E  not internally consistent: ", modtbl, "\n" );
>       fi;
>       libinfo:= LibInfoCharacterTable( modtbl );
>       if libinfo <> fail and IsBound( LIBTABLE.( libinfo.fileName ) ) and
>          IsBound( LIBTABLE.( libinfo.fileName ).( Identifier( modtbl ) ) )
>          and not HasAutomorphismsOfTable( modtbl ) then
>         Print( "#E  table automorphisms missing: ", modtbl, "\n" );
>       fi;
>       return true;
> end;;
gap> AllCharacterTableNames( OfThose, brauernames, IsCharacterTable, true,
>                            easytest, false );;

# Check the creation of ATLAS maps.
# For the simple groups listed in the ATLAS,
# consider characteristics zero and all prime divisors of the group order
# (not just the ones that appear in the Atlas of Brauer Characters).
gap> for entry in CTblLib.AtlasPages do
>   name:= entry[1][1];
>   tbl:= CharacterTable( name );
>   if tbl <> fail then
>     for p in Concatenation( [ 0 ], Set( Factors( Size( tbl ) ) ) ) do
>       args:= [ name, p ];
>       res:= CallFuncList( StringsAtlasMap, args );
>       if res <> fail and not IsList( res ) then
>         Print( "#E  problem with StringsAtlasMap for ", args,
>                ", result is ", res, "\n" );
>       fi;
>       BrowseData.SetReplay( "Q" );
>       CallFuncList( BrowseAtlasMap, args );
>       BrowseData.SetReplay( false );
>     od;
>   fi;
> od;

# Check the creation of Cambridge format files for ATLAS tables.
gap> for entry in CTblLib.AtlasPages do
>   name:= entry[1][1];
>   tbl:= CharacterTable( name );
>   if tbl <> fail then
>     for p in Concatenation( [ 0 ], Set( Factors( Size( tbl ) ) ) ) do
>       args:= [ name, p ];
>       res:= CallFuncList( StringOfCambridgeFormat, args );
>       if res <> fail and not IsString( res ) then
>         Print( "#E  problem with StringOfCambridgeFormat for ", args,
>                ", result is ", res, "\n" );
>       fi;
>       BrowseData.SetReplay( "Q" );
>       CallFuncList( BrowseAtlasTable, args );
>       BrowseData.SetReplay( false );
>     od;
>   fi;
> od;

# Check the names of simple tables computed by
# 'IsomorphismTypeInfoFiniteSimpleGroup'.
gap> simp:= AllCharacterTableNames( IsSimple, true, IsDuplicateTable, false );;
gap> info:= List( simp,
>                 nam -> IsomorphismTypeInfoFiniteSimpleGroup(
>                            CharacterTable( nam ) ) );;
gap> Intersection( simp, [ "C2", "2.Alt(2)", "Sym(2)" ] );
[ "C2" ]
gap> for i in [ 1 .. Length( simp ) ] do
>      if not IsBound( info[i].shortname ) then
>        Print( "#E  no shortname for '", simp[i], "'\n" );
>      elif simp[i] <> info[i].shortname then
>        Print( "#E  '", simp[i], "' has shortname '", info[i].shortname,
>               "'\n" );
>      fi;
>    od;

# Check the attribute handling for private tables.
gap> if IsBound( BrowseCTblLibInfo ) and
>       LibInfoCharacterTable( "Alt(6)" ) <> fail then
>      BrowseData.SetReplay( "Q" );
>      BrowseCTblLibInfo( "Alt(6)" );
>      BrowseData.SetReplay( false );
>    fi;

# Check consistency of character and class parameters.
gap> for n in [ 5 .. 19 ] do
>      CTblLib.Test.TablesOfSymmetricGroup( n );
>    od;

##
gap> STOP_TEST( "ctbllib.tst" );

#############################################################################
##
#E

