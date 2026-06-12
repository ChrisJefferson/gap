# This file was created automatically, do not edit!
#############################################################################
##
#W  ctblcons.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "ctblcons.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "ctblcons.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/ctblcons.xml (45-48)
gap> LoadPackage( "ctbllib", "1.1.4", false );
true

##  doc2/ctblcons.xml (172-187)
gap> RepresentativesCharacterTables:= function( list )
>    local reps, entry, r;
> 
>    reps:= [];
>    for entry in list do
>      if ForAll( reps, r -> ( IsCharacterTable( r ) and
>             TransformingPermutationsCharacterTables( entry, r ) = fail )
>           or ( IsRecord( r ) and TransformingPermutationsCharacterTables(
>                                    entry.table, r.table ) = fail ) ) then
>        Add( reps, entry );
>      fi;
>    od;
>    return reps;
>    end;;

##  doc2/ctblcons.xml (513-526)
gap> t:= CharacterTable( "3.L3(4).3" );
CharacterTable( "3.L3(4).3" )
gap> iso1:= CharacterTableIsoclinic( t );
CharacterTable( "Isoclinic(3.L3(4).3,1)" )
gap> iso2:= CharacterTableIsoclinic( t, rec( k:= 2 ) );
CharacterTable( "Isoclinic(3.L3(4).3,2)" )
gap> TransformingPermutationsCharacterTables( t, iso1 );
fail
gap> TransformingPermutationsCharacterTables( t, iso2 );
fail
gap> TransformingPermutationsCharacterTables( iso1, iso2 );
fail

##  doc2/ctblcons.xml (535-539)
gap> IsRecord( TransformingPermutationsCharacterTables( t,
>                  CharacterTable( GL( 3, 4 ) ) ) );
true

##  doc2/ctblcons.xml (567-582)
gap> t:= CharacterTable( "2.A6.2_1" );
CharacterTable( "2.A6.2_1" )
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTableIsoclinic( t ) );
rec( columns := (4,6)(5,7)(11,12)(14,16)(15,17), 
  group := Group([ (16,17), (14,15) ]), 
  rows := (3,5)(4,6)(10,11)(12,15,13,14) )
gap> t:= CharacterTable( "2.L2(25).2_2" );
CharacterTable( "2.L2(25).2_2" )
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTableIsoclinic( t ) );
rec( columns := (7,9)(8,10)(20,21)(23,24)(25,27)(26,28), 
  group := <permutation group with 4 generators>, 
  rows := (3,5)(4,6)(14,15)(16,17)(19,22,20,21) )

##  doc2/ctblcons.xml (609-628)
gap> tbls:= [];;
gap> for m in [ "4_1", "4_2" ] do
>      for a in [ "2_1", "2_2", "2_3" ] do
>        Add( tbls, CharacterTable( Concatenation( m, ".L3(4).", a ) ) );
>      od;
>    od;
gap> tbls;
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" )
    , CharacterTable( "4_1.L3(4).2_3" ), 
  CharacterTable( "4_2.L3(4).2_1" ), CharacterTable( "4_2.L3(4).2_2" )
    , CharacterTable( "4_2.L3(4).2_3" ) ]
gap> case1:= Filtered( tbls, t -> Size( ClassPositionsOfCentre( t ) ) = 2 );
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" )
    , CharacterTable( "4_2.L3(4).2_1" ), 
  CharacterTable( "4_2.L3(4).2_3" ) ]
gap> case2:= Filtered( tbls, t -> Size( ClassPositionsOfCentre( t ) ) = 4 );
[ CharacterTable( "4_1.L3(4).2_3" ), 
  CharacterTable( "4_2.L3(4).2_2" ) ]

##  doc2/ctblcons.xml (640-647)
gap> isos1:= List( case1, CharacterTableIsoclinic );;
gap> List( [ 1 .. 4 ], i -> Irr( case1[i] ) = Irr( isos1[i] ) );
[ true, true, true, true ]
gap> List( [ 1 .. 4 ],
>      i -> TransformingPermutationsCharacterTables( case1[i], isos1[i] ) );
[ fail, fail, fail, fail ]

##  doc2/ctblcons.xml (656-673)
gap> isos2:= List( case2, CharacterTableIsoclinic );;
gap> List( [ 1, 2 ],
>      i -> TransformingPermutationsCharacterTables( case2[i], isos2[i] ) );
[ rec( columns := (26,27,28,29)(30,31,32,33)(38,39,40,41)(42,43,44,45)
        , group := <permutation group with 5 generators>, 
      rows := (16,17)(18,19)(20,21)(22,23)(28,29)(32,33)(36,37)(40,
        41) ), 
  rec( columns := (28,29,30,31)(32,33)(34,35,36,37)(38,39,40,41)(42,
        43,44,45)(46,47,48,49), group := <permutation group with 
        3 generators>, rows := (15,16)(17,18)(20,21)(22,23)(24,25)(26,
        27)(28,29)(34,35)(38,39)(42,43)(46,47) ) ]
gap> isos3:= List( case2, t -> CharacterTableIsoclinic( t,
>                                ClassPositionsOfCentre( t ) ) );;
gap> List( [ 1, 2 ],
>      i -> TransformingPermutationsCharacterTables( case2[i], isos3[i] ) );
[ fail, fail ]

##  doc2/ctblcons.xml (2049-2074)
gap> tblMG:= CharacterTable( "Cyclic", 3 );;
gap> tblG:= CharacterTable( "Cyclic", 1 );;
gap> tblGA:= CharacterTable( "Cyclic", 2 );;
gap> StoreFusion( tblMG, [ 1, 1, 1 ], tblG );
gap> StoreFusion( tblG, [ 1 ], tblGA );
gap> elms:= Elements( AutomorphismsOfTable( tblMG ) );
[ (), (2,3) ]
gap> orbs:= [ [ 1 ], [ 2, 3 ] ];;
gap> new:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, orbs,
>              "S3" );
[ rec( MGfusMGA := [ 1, 2, 2 ], table := CharacterTable( "S3" ) ) ]
gap> Display( new[1].table );
S3

     2  1  .  1
     3  1  1  .

       1a 3a 2a
    2P 1a 3a 1a
    3P 1a 1a 2a

X.1     1  1  1
X.2     1  1 -1
X.3     2 -1  .

##  doc2/ctblcons.xml (2087-2104)
gap> tblMG:= CharacterTable( "Cyclic", 4 );;
gap> tblG:= CharacterTable( "Cyclic", 2 );;
gap> tblGA:= CharacterTable( "2^2" );;           
gap> OrdersClassRepresentatives( tblMG );
[ 1, 4, 2, 4 ]
gap> StoreFusion( tblMG, [ 1, 2, 1, 2 ], tblG ); 
gap> StoreFusion( tblG, [ 1, 2 ], tblGA );      
gap> elms:= Elements( AutomorphismsOfTable( tblMG ) );
[ (), (2,4) ]
gap> orbs:= Orbits( Group( elms[2] ), [ 1 ..4 ] );;
gap> new:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, orbs,
>              "order8" );
[ rec( MGfusMGA := [ 1, 2, 3, 2 ], 
      table := CharacterTable( "order8" ) ), 
  rec( MGfusMGA := [ 1, 2, 3, 2 ], 
      table := CharacterTable( "order8" ) ) ]

##  doc2/ctblcons.xml (2113-2129)
gap> List( new, x -> OrdersClassRepresentatives( x.table ) );
[ [ 1, 4, 2, 2, 2 ], [ 1, 4, 2, 4, 4 ] ]
gap> Display( new[1].table );
order8

     2  3  2  3  2  2

       1a 4a 2a 2b 2c
    2P 1a 2a 1a 1a 1a

X.1     1  1  1  1  1
X.2     1  1  1 -1 -1
X.3     1 -1  1  1 -1
X.4     1 -1  1 -1  1
X.5     2  . -2  .  .

##  doc2/ctblcons.xml (2229-2254)
gap> tblMG:= CharacterTable( "7:3" ) * CharacterTable( "A5" );;
gap> nsg:= ClassPositionsOfNormalSubgroups( tblMG );
[ [ 1 ], [ 1, 6 .. 11 ], [ 1 .. 5 ], [ 1, 6 .. 21 ], [ 1 .. 15 ], 
  [ 1 .. 25 ] ]
gap> List( nsg, x -> Sum( SizesConjugacyClasses( tblMG ){ x } ) );
[ 1, 7, 60, 21, 420, 1260 ]
gap> tblG:= tblMG / nsg[2];;
gap> tblGA:= CharacterTable( "Cyclic", 3 ) * CharacterTable( "A5.2" );;
gap> GfusGA:= PossibleClassFusions( tblG, tblGA );
[ [ 1, 2, 3, 4, 4, 8, 9, 10, 11, 11, 15, 16, 17, 18, 18 ], 
  [ 1, 2, 3, 4, 4, 15, 16, 17, 18, 18, 8, 9, 10, 11, 11 ] ]
gap> reps:= RepresentativesFusions( Group(()), GfusGA, tblGA );
[ [ 1, 2, 3, 4, 4, 8, 9, 10, 11, 11, 15, 16, 17, 18, 18 ] ]
gap> StoreFusion( tblG, reps[1], tblGA );
gap> acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4, 5 ], [ 6, 11 ], [ 7, 12 ], [ 8, 13 ], 
      [ 9, 15 ], [ 10, 14 ], [ 16 ], [ 17 ], [ 18 ], [ 19, 20 ], 
      [ 21 ], [ 22 ], [ 23 ], [ 24, 25 ] ] ]
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA,
>               acts[1], "A12N7" );
[ rec( 
      MGfusMGA := [ 1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 5, 6, 7, 9, 8, 10, 
          11, 12, 13, 13, 14, 15, 16, 17, 17 ], 
      table := CharacterTable( "A12N7" ) ) ]

##  doc2/ctblcons.xml (2263-2268)
gap> g:= AlternatingGroup( 12 );;
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                CharacterTable( Normalizer( g, SylowSubgroup( g, 7 ) ) ) ) );
true

##  doc2/ctblcons.xml (2280-2290)
gap> tblh1:= CharacterTable( "7:3" );;
gap> tblg1:= CharacterTable( "7:6" );;
gap> tblh2:= CharacterTable( "A5" );;
gap> tblg2:= CharacterTable( "A5.2" );;
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "(7:3xA5).2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                subdir.table ) );
true

##  doc2/ctblcons.xml (2326-2376)
gap> listMGA:= [
> [ "3.A6",        "A6",        "A6.2_1",        "3.A6.2_1"       ],
> [ "3.A6",        "A6",        "A6.2_2",        "3.A6.2_2"       ],
> [ "6.A6",        "2.A6",      "2.A6.2_1",      "6.A6.2_1"       ],
> [ "6.A6",        "2.A6",      "2.A6.2_2",      "6.A6.2_2"       ],
> [ "3.A7",        "A7",        "A7.2",          "3.A7.2"         ],
> [ "6.A7",        "2.A7",      "2.A7.2",        "6.A7.2"         ],
> [ "3.L3(4)",     "L3(4)",     "L3(4).2_2",     "3.L3(4).2_2"    ],
> [ "3.L3(4)",     "L3(4)",     "L3(4).2_3",     "3.L3(4).2_3"    ],
> [ "6.L3(4)",     "2.L3(4)",   "2.L3(4).2_2",   "6.L3(4).2_2"    ],
> [ "6.L3(4)",     "2.L3(4)",   "2.L3(4).2_3",   "6.L3(4).2_3"    ],
> [ "12_1.L3(4)",  "4_1.L3(4)", "4_1.L3(4).2_2", "12_1.L3(4).2_2" ],
> [ "12_1.L3(4)",  "4_1.L3(4)", "4_1.L3(4).2_3", "12_1.L3(4).2_3" ],
> [ "12_2.L3(4)",  "4_2.L3(4)", "4_2.L3(4).2_2", "12_2.L3(4).2_2" ],
> [ "12_2.L3(4)",  "4_2.L3(4)", "4_2.L3(4).2_3", "12_2.L3(4).2_3" ],
> [ "3.U3(5)",     "U3(5)",     "U3(5).2",       "3.U3(5).2"      ],
> [ "3.M22",       "M22",       "M22.2",         "3.M22.2"        ],
> [ "6.M22",       "2.M22",     "2.M22.2",       "6.M22.2"        ],
> [ "12.M22",      "4.M22",     "4.M22.2",       "12.M22.2"       ],
> [ "3.L3(7)",     "L3(7)",     "L3(7).2",       "3.L3(7).2"      ],
> [ "3_1.U4(3)",   "U4(3)",     "U4(3).2_1",     "3_1.U4(3).2_1"  ],
> [ "3_1.U4(3)",   "U4(3)",     "U4(3).2_2'",    "3_1.U4(3).2_2'" ],
> [ "3_2.U4(3)",   "U4(3)",     "U4(3).2_1",     "3_2.U4(3).2_1"  ],
> [ "3_2.U4(3)",   "U4(3)",     "U4(3).2_3'",    "3_2.U4(3).2_3'" ],
> [ "6_1.U4(3)",   "2.U4(3)",   "2.U4(3).2_1",   "6_1.U4(3).2_1"  ],
> [ "6_1.U4(3)",   "2.U4(3)",   "2.U4(3).2_2'",  "6_1.U4(3).2_2'" ],
> [ "6_2.U4(3)",   "2.U4(3)",   "2.U4(3).2_1",   "6_2.U4(3).2_1"  ],
> [ "6_2.U4(3)",   "2.U4(3)",   "2.U4(3).2_3'",  "6_2.U4(3).2_3'" ],
> [ "12_1.U4(3)",  "4.U4(3)",   "4.U4(3).2_1",   "12_1.U4(3).2_1" ],
> [ "12_2.U4(3)",  "4.U4(3)",   "4.U4(3).2_1",   "12_2.U4(3).2_1" ],
> [ "3.G2(3)",     "G2(3)",     "G2(3).2",       "3.G2(3).2"      ],
> [ "3.U3(8)",     "U3(8)",     "U3(8).2",       "3.U3(8).2"      ],
> [ "3.U3(8).3_1", "U3(8).3_1", "U3(8).6",       "3.U3(8).6"      ],
> [ "3.J3",        "J3",        "J3.2",          "3.J3.2"         ],
> [ "3.U3(11)",    "U3(11)",    "U3(11).2",      "3.U3(11).2"     ],
> [ "3.McL",       "McL",       "McL.2",         "3.McL.2"        ],
> [ "3.O7(3)",     "O7(3)",     "O7(3).2",       "3.O7(3).2"      ],
> [ "6.O7(3)",     "2.O7(3)",   "2.O7(3).2",     "6.O7(3).2"      ],
> [ "3.U6(2)",     "U6(2)",     "U6(2).2",       "3.U6(2).2"      ],
> [ "6.U6(2)",     "2.U6(2)",   "2.U6(2).2",     "6.U6(2).2"      ],
> [ "3.Suz",       "Suz",       "Suz.2",         "3.Suz.2"        ],
> [ "6.Suz",       "2.Suz",     "2.Suz.2",       "6.Suz.2"        ],
> [ "3.ON",        "ON",        "ON.2",          "3.ON.2"         ],
> [ "3.Fi22",      "Fi22",      "Fi22.2",        "3.Fi22.2"       ],
> [ "6.Fi22",      "2.Fi22",    "2.Fi22.2",      "6.Fi22.2"       ],
> [ "3.2E6(2)",    "2E6(2)",    "2E6(2).2",      "3.2E6(2).2"     ],
> [ "6.2E6(2)",    "2.2E6(2)",  "2.2E6(2).2",    "6.2E6(2).2"     ],
> [ "3.F3+",       "F3+",       "F3+.2",         "3.F3+.2"        ],
> ];;

##  doc2/ctblcons.xml (2402-2409)
gap> Append( listMGA, [
> [ "(2^2x3).L3(4)",  "2^2.L3(4)",   "2^2.L3(4).2_2", "(2^2x3).L3(4).2_2" ],
> [ "(2^2x3).L3(4)",  "2^2.L3(4)",   "2^2.L3(4).2_3", "(2^2x3).L3(4).2_3" ],
> [ "(2^2x3).U6(2)",  "2^2.U6(2)",   "2^2.U6(2).2",   "(2^2x3).U6(2).2"   ],
> [ "(2^2x3).2E6(2)", "2^2.2E6(2)",  "2^2.2E6(2).2",  "(2^2x3).2E6(2).2"  ],
> ] );

##  doc2/ctblcons.xml (2420-2440)
gap> Append( listMGA, [
> [ "3.A6.2_3",       "A6.2_3",    "A6.2^2",      "3.A6.2^2"          ],
> [ "3.L3(4).2_1",    "L3(4).2_1", "L3(4).2^2",   "3.L3(4).2^2"       ],
> [ "3_1.U4(3).2_2",  "U4(3).2_2", "U4(3).(2^2)_{122}",
>                                             "3_1.U4(3).(2^2)_{122}" ],
> [ "3_2.U4(3).2_3",  "U4(3).2_3", "U4(3).(2^2)_{133}",
>                                             "3_2.U4(3).(2^2)_{133}" ],
> [ "3^2.U4(3).2_3'", "3_2.U4(3).2_3'", "3_2.U4(3).(2^2)_{133}",
>                                             "3^2.U4(3).(2^2)_{133}" ],
> [ "2^2.L3(4)",      "L3(4)",     "L3(4).3",     "2^2.L3(4).3"       ],
> [ "(2^2x3).L3(4)",  "3.L3(4)",   "3.L3(4).3",   "(2^2x3).L3(4).3"   ],
> [ "2^2.L3(4).2_1",  "L3(4).2_1", "L3(4).6",     "2^2.L3(4).6"       ],
> [ "2^2.Sz(8)",      "Sz(8)",     "Sz(8).3",     "2^2.Sz(8).3"       ],
> [ "2^2.U6(2)",      "U6(2)",     "U6(2).3",     "2^2.U6(2).3"       ],
> [ "(2^2x3).U6(2)",  "3.U6(2)",   "3.U6(2).3",   "(2^2x3).U6(2).3"   ],
> [ "2^2.O8+(2)",     "O8+(2)",    "O8+(2).3",    "2^2.O8+(2).3"      ],
> [ "2^2.O8+(3)",     "O8+(3)",    "O8+(3).3",    "2^2.O8+(3).3"      ],
> [ "2^2.2E6(2)",     "2E6(2)",    "2E6(2).3",    "2^2.2E6(2).3"      ],
> ] );

##  doc2/ctblcons.xml (2480-2515)
gap> ConstructOrdinaryMGATable:= function( tblMG, tblG, tblGA, name, lib )
>      local acts, poss, trans;
> 
>      acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
>      poss:= Concatenation( List( acts, pi ->
>                 PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, pi,
>                     name ) ) );
>      poss:= RepresentativesCharacterTables( poss );
>      if Length( poss ) = 1 then
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          List( poss, x -> AutomorphismsOfTable( x.table ) );
>          Print( "#I  no library table for ", name, "\n" );
>        else
>          trans:= TransformingPermutationsCharacterTables( poss[1].table,
>                      lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusion with the stored one.
>          if OnTuples( poss[1].MGfusMGA, trans.columns )
>                 <> GetFusionMap( tblMG, lib ) then
>            Print( "#E  computed and stored fusion for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      elif Length( poss ) = 0 then
>        Print( "#E  no solution for ", name, "\n" );
>      else
>        Print( "#E  ", Length( poss ), " possibilities for ", name, "\n" );
>      fi;
>      return poss;
>    end;;

##  doc2/ctblcons.xml (2532-2564)
gap> ConstructModularMGATables:= function( tblMG, tblGA, ordtblMGA )
>    local name, poss, p, modtblMG, modtblGA, modtblMGA, modlib, trans;
> 
>    name:= Identifier( ordtblMGA );
>    poss:= [];
>    for p in PrimeDivisors( Size( ordtblMGA ) ) do
>      modtblMG := tblMG mod p;
>      modtblGA := tblGA mod p;
>      if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
>        modtblMGA:= BrauerTableOfTypeMGA( modtblMG, modtblGA, ordtblMGA );
>        Add( poss, modtblMGA );
>        modlib:= ordtblMGA mod p;
>        if IsCharacterTable( modlib ) then
>          trans:= TransformingPermutationsCharacterTables( modtblMGA.table,
>                      modlib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " mod ", p, " differ\n" );
>          fi;
>        else
>          AutomorphismsOfTable( modtblMGA.table );
>          Print( "#I  no library table for ", name, " mod ", p, "\n" );
>        fi;
>      else
>        Print( "#I  not all input tables for ", name, " mod ", p,
>               " available\n" );
>      fi;
>    od;
> 
>    return poss;
>    end;;

##  doc2/ctblcons.xml (2576-2637)
gap> for  input in listMGA do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      if 1 <> Length( poss ) then
>        Print( "#I  ", Length( poss ), " possibilities for ", name, "\n" );
>      elif lib = fail then
>        Print( "#I  no library table for ", input[4], "\n" );
>      else
>        ConstructModularMGATables( tblMG, tblGA, lib );
>      fi;
>    od;
#I  not all input tables for 3.2E6(2).2 mod 2 available
#I  not all input tables for 3.2E6(2).2 mod 3 available
#I  not all input tables for 3.2E6(2).2 mod 5 available
#I  not all input tables for 3.2E6(2).2 mod 7 available
#I  not all input tables for 3.2E6(2).2 mod 11 available
#I  not all input tables for 3.2E6(2).2 mod 13 available
#I  not all input tables for 3.2E6(2).2 mod 17 available
#I  not all input tables for 3.2E6(2).2 mod 19 available
#I  not all input tables for 6.2E6(2).2 mod 2 available
#I  not all input tables for 6.2E6(2).2 mod 3 available
#I  not all input tables for 6.2E6(2).2 mod 5 available
#I  not all input tables for 6.2E6(2).2 mod 7 available
#I  not all input tables for 6.2E6(2).2 mod 11 available
#I  not all input tables for 6.2E6(2).2 mod 13 available
#I  not all input tables for 6.2E6(2).2 mod 17 available
#I  not all input tables for 6.2E6(2).2 mod 19 available
#I  not all input tables for 3.F3+.2 mod 2 available
#I  not all input tables for 3.F3+.2 mod 3 available
#I  not all input tables for 3.F3+.2 mod 5 available
#I  not all input tables for 3.F3+.2 mod 7 available
#I  not all input tables for 3.F3+.2 mod 13 available
#I  not all input tables for 3.F3+.2 mod 17 available
#I  not all input tables for 3.F3+.2 mod 29 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 2 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 3 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 5 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 7 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 11 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 13 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 17 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 19 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 2 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 5 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 7 available
#I  not all input tables for 2^2.O8+(3).3 mod 5 available
#I  not all input tables for 2^2.O8+(3).3 mod 7 available
#I  not all input tables for 2^2.O8+(3).3 mod 13 available
#I  not all input tables for 2^2.2E6(2).3 mod 2 available
#I  not all input tables for 2^2.2E6(2).3 mod 3 available
#I  not all input tables for 2^2.2E6(2).3 mod 5 available
#I  not all input tables for 2^2.2E6(2).3 mod 7 available
#I  not all input tables for 2^2.2E6(2).3 mod 11 available
#I  not all input tables for 2^2.2E6(2).3 mod 13 available
#I  not all input tables for 2^2.2E6(2).3 mod 17 available
#I  not all input tables for 2^2.2E6(2).3 mod 19 available

##  doc2/ctblcons.xml (2669-2678)
gap> listMGA2:= [
> [ "4_1.L3(4)",  "2.L3(4)",   "2.L3(4).2_1",   "4_1.L3(4).2_1"  ],
> [ "4_1.L3(4)",  "2.L3(4)",   "2.L3(4).2_2",   "4_1.L3(4).2_2"  ],
> [ "4_2.L3(4)",  "2.L3(4)",   "2.L3(4).2_1",   "4_2.L3(4).2_1"  ],
> [ "4.M22",      "2.M22",     "2.M22.2",       "4.M22.2"        ],
> [ "4.U4(3)",    "2.U4(3)",   "2.U4(3).2_2",   "4.U4(3).2_2"    ],
> [ "4.U4(3)",    "2.U4(3)",   "2.U4(3).2_3",   "4.U4(3).2_3"    ],
> ];;

##  doc2/ctblcons.xml (2697-2706)
gap> Append( listMGA2, [
> [ "2^2.L3(4)",     "2.L3(4)",     "2.L3(4).2_2",         "2^2.L3(4).2_2" ],
> [ "2^2.L3(4)",     "2.L3(4)",     "2.L3(4).2_3",         "2^2.L3(4).2_3" ],
> [ "2^2.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123}", "2^2.L3(4).2^2" ],
> [ "2^2.O8+(2)",    "2.O8+(2)",    "2.O8+(2).2",          "2^2.O8+(2).2"  ],
> [ "2^2.U6(2)",     "2.U6(2)",     "2.U6(2).2",           "2^2.U6(2).2"   ],
> [ "2^2.2E6(2)",    "2.2E6(2)",    "2.2E6(2).2",          "2^2.2E6(2).2"  ],
> ] );

##  doc2/ctblcons.xml (2719-2724)
gap> Append( listMGA2, [
> [ "12_1.L3(4)", "6.L3(4)", "6.L3(4).2_1", "12_1.L3(4).2_1" ],
> [ "12_2.L3(4)", "6.L3(4)", "6.L3(4).2_1", "12_2.L3(4).2_1" ],
> ] );

##  doc2/ctblcons.xml (2743-2750)
gap> Append( listMGA2, [
> [ "12.M22",     "6.M22",     "6.M22.2",       "12.M22.2"       ],
> [ "12_1.L3(4)", "6.L3(4)",   "6.L3(4).2_2",   "12_1.L3(4).2_2" ],
> [ "12_1.U4(3)", "6_1.U4(3)", "6_1.U4(3).2_2", "12_1.U4(3).2_2" ],
> [ "12_2.U4(3)", "6_2.U4(3)", "6_2.U4(3).2_3", "12_2.U4(3).2_3" ],
> ] );

##  doc2/ctblcons.xml (2761-2768)
gap> Append( listMGA2, [
> [ "(2^2x3).L3(4)",  "6.L3(4)",   "6.L3(4).2_2", "(2^2x3).L3(4).2_2" ],
> [ "(2^2x3).L3(4)",  "6.L3(4)",   "6.L3(4).2_3", "(2^2x3).L3(4).2_3" ],
> [ "(2^2x3).U6(2)",  "6.U6(2)",   "6.U6(2).2",   "(2^2x3).U6(2).2"   ],
> [ "(2^2x3).2E6(2)", "6.2E6(2)",  "6.2E6(2).2",  "(2^2x3).2E6(2).2"  ],
> ] );

##  doc2/ctblcons.xml (2776-2835)
gap> for  input in listMGA2 do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      if Length( poss ) = 2 then
>        iso:= CharacterTableIsoclinic( poss[1].table );
>        if IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                         iso ) ) then
>          Unbind( poss[2] );
>        fi;
>      elif Length( poss ) = 1 then
>        Print( "#I  unique up to permutation equivalence: ", name, "\n" );
>      fi;
>      if 1 <> Length( poss ) then
>        Print( "#I  ", Length( poss ), " possibilities for ", name, "\n" );
>      elif lib = fail then
>        Print( "#I  no library table for ", input[4], "\n" );
>      else
>        ConstructModularMGATables( tblMG, tblGA, lib );
>      fi;
>    od;
#E  2 possibilities for new4_1.L3(4).2_1
#E  2 possibilities for new4_1.L3(4).2_2
#E  2 possibilities for new4_2.L3(4).2_1
#E  2 possibilities for new4.M22.2
#E  2 possibilities for new4.U4(3).2_2
#E  2 possibilities for new4.U4(3).2_3
#I  unique up to permutation equivalence: new2^2.L3(4).2_2
#I  unique up to permutation equivalence: new2^2.L3(4).2_3
#I  unique up to permutation equivalence: new2^2.L3(4).2^2
#I  unique up to permutation equivalence: new2^2.O8+(2).2
#I  unique up to permutation equivalence: new2^2.U6(2).2
#I  unique up to permutation equivalence: new2^2.2E6(2).2
#I  not all input tables for 2^2.2E6(2).2 mod 2 available
#I  not all input tables for 2^2.2E6(2).2 mod 3 available
#I  not all input tables for 2^2.2E6(2).2 mod 5 available
#I  not all input tables for 2^2.2E6(2).2 mod 7 available
#E  2 possibilities for new12_1.L3(4).2_1
#E  2 possibilities for new12_2.L3(4).2_1
#E  2 possibilities for new12.M22.2
#E  2 possibilities for new12_1.L3(4).2_2
#E  2 possibilities for new12_1.U4(3).2_2
#E  2 possibilities for new12_2.U4(3).2_3
#I  unique up to permutation equivalence: new(2^2x3).L3(4).2_2
#I  unique up to permutation equivalence: new(2^2x3).L3(4).2_3
#I  unique up to permutation equivalence: new(2^2x3).U6(2).2
#I  unique up to permutation equivalence: new(2^2x3).2E6(2).2
#I  not all input tables for (2^2x3).2E6(2).2 mod 2 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 3 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 5 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 7 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 11 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 13 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 17 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 19 available

##  doc2/ctblcons.xml (2857-2881)
gap> tblMG := CharacterTable( "4_2.L3(4)" );;
gap> tblG  := CharacterTable( "2.L3(4)" );;
gap> tblGA := CharacterTable( "2.L3(4).2_3" );;
gap> name  := "new4_2.L3(4).2_3";;
gap> lib   := CharacterTable( "4_2.L3(4).2_3" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
#E  4 possibilities for new4_2.L3(4).2_3
[ rec( 
      MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 
          12, 13, 14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 
          21, 20 ], table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( 
      MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 
          12, 13, 14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 
          21, 20 ], table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( 
      MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 
          12, 13, 14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 
          21, 20 ], table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( 
      MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 
          12, 13, 14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 
          21, 20 ], table := CharacterTable( "new4_2.L3(4).2_3" ) ) ]

##  doc2/ctblcons.xml (2901-2908)
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTableIsoclinic( poss[4].table ) ) );
true
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  CharacterTableIsoclinic( poss[3].table ) ) );
true

##  doc2/ctblcons.xml (2919-2929)
gap> List( poss, x -> PowerMap( x.table, 2 ) );
[ [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 1, 1, 6, 6, 9, 9, 11, 11, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 1, 1, 6, 6, 11, 11, 9, 9, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 3, 3, 8, 8, 9, 9, 11, 11, 18, 18, 15, 15 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 3, 3, 8, 8, 11, 11, 9, 9, 18, 18, 15, 15 ] ]

##  doc2/ctblcons.xml (2946-2956)
gap> PossiblePowerMaps( poss[1].table, 2 );
[ [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 1, 1, 6, 6, 11, 11, 9, 9, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 
      21, 19, 21, 1, 1, 6, 6, 9, 9, 11, 11, 16, 16, 13, 13 ] ]
gap> t:= CharacterTable( "4.U4(3)" );;
gap> List( [ "L3(4)", "2.L3(4)", "4_1.L3(4)", "4_2.L3(4)" ], name ->
>          Length( PossibleClassFusions( CharacterTable( name ), t ) ) );
[ 0, 0, 0, 4 ]

##  doc2/ctblcons.xml (2969-2973)
gap> t2:= CharacterTable( "4.U4(3).2_3" );;
gap> List( poss, x -> Length( PossibleClassFusions( x.table, t2 ) ) );
[ 0, 16, 0, 0 ]

##  doc2/ctblcons.xml (3010-3015)
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  lib ) );
true
gap> ConstructModularMGATables( tblMG, tblGA, lib );;

##  doc2/ctblcons.xml (3026-3049)
gap> tblMG := CharacterTable( "12_2.L3(4)" );;
gap> tblG  := CharacterTable( "6.L3(4)" );;
gap> tblGA := CharacterTable( "6.L3(4).2_3" );;
gap> name  := "new12_2.L3(4).2_3";;
gap> lib   := CharacterTable( "12_2.L3(4).2_3" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );;
#E  4 possibilities for new12_2.L3(4).2_3
gap> Length( poss );
4
gap> nsg:= ClassPositionsOfNormalSubgroups( poss[1].table );
[ [ 1 ], [ 1, 5 ], [ 1, 7 ], [ 1, 4 .. 7 ], [ 1, 3 .. 7 ], 
  [ 1 .. 7 ], [ 1 .. 50 ], [ 1 .. 62 ] ]
gap> List( nsg, x -> Sum( SizesConjugacyClasses( poss[1].table ){ x } ) );
[ 1, 3, 2, 4, 6, 12, 241920, 483840 ]
gap> factlib:= CharacterTable( "4_2.L3(4).2_3" );;
gap> List( poss, x -> IsRecord( TransformingPermutationsCharacterTables(
>                         x.table / [ 1, 5 ], factlib ) ) );
[ false, true, false, false ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  lib ) );
true
gap> ConstructModularMGATables( tblMG, tblGA, lib );;

##  doc2/ctblcons.xml (3075-3084)
gap> tblMG := CharacterTable( "12_1.U4(3)" );;
gap> tblG  := CharacterTable( "2.U4(3)" );;
gap> tblGA := CharacterTable( "2.U4(3).2_2'" );;
gap> name  := "new12_1.U4(3).2_2'";;
gap> lib   := CharacterTable( "12_1.U4(3).2_2'" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );;
#E  2 possibilities for new12_1.U4(3).2_2'
gap> ConstructModularMGATables( tblMG, tblGA, lib );;

##  doc2/ctblcons.xml (3096-3103)
gap> Irr( poss[1].table ) = Irr( poss[2].table );
true
gap> iso:= CharacterTableIsoclinic( poss[1].table );;
gap> TransformingPermutationsCharacterTables( iso, poss[2].table );
rec( columns := (), group := <permutation group with 5 generators>, 
  rows := () )

##  doc2/ctblcons.xml (3113-3126)
gap> tblMG := CharacterTable( "12_2.U4(3)" );;
gap> tblG  := CharacterTable( "2.U4(3)" );;
gap> tblGA := CharacterTable( "2.U4(3).2_3'" );;
gap> name  := "new12_2.U4(3).2_3'";;
gap> lib   := CharacterTable( "12_2.U4(3).2_3'" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );;
#E  2 possibilities for new12_2.U4(3).2_3'
gap> ConstructModularMGATables( tblMG, tblGA, lib );;
gap> iso:= CharacterTableIsoclinic( poss[1].table );;
gap> TransformingPermutationsCharacterTables( iso, poss[2].table );
rec( columns := (), group := <permutation group with 8 generators>, 
  rows := () )

##  doc2/ctblcons.xml (3177-3205)
gap> s:= SU(3,8);;
gap> gens:= GeneratorsOfGroup( s );;
gap> imgs1:= List( gens, m -> List( m, v -> List( v, x -> x^4 ) ) );;
gap> imgs2:= List( gens, m -> List( m, v -> List( v, x -> x^16 ) ) );;
gap> f:= GF(64);;
gap> mats:= List( gens, m -> IdentityMat( 9, f ) );;
gap> for i in [ 1 .. Length( gens ) ] do
>      mats[i]{ [ 1 .. 3 ] }{ [ 1 .. 3 ] }:= gens[i];
>      mats[i]{ [ 4 .. 6 ] }{ [ 4 .. 6 ] }:= imgs1[i];
>      mats[i]{ [ 7 .. 9 ] }{ [ 7 .. 9 ] }:= imgs2[i];
>    od;
gap> fieldaut:= NullMat( 9, 9, f );;
gap> fieldaut{ [ 4 .. 6 ] }{ [ 1 .. 3 ] }:= IdentityMat( 3, f );;
gap> fieldaut{ [ 7 .. 9 ] }{ [ 4 .. 6 ] }:= IdentityMat( 3, f );;
gap> fieldaut{ [ 1 .. 3 ] }{ [ 7 .. 9 ] }:= IdentityMat( 3, f );;
gap> v:= [ 1, 0, 0, 1, 0, 0, 1, 0, 0 ] * One( f );;
gap> g:= Group( Concatenation( mats, [ fieldaut ] ) );;
gap> orb:= Orbit( g, v );;
gap> Length( orb );
32319
gap> act:= Action( g, orb );;
gap> Size( act ) = 3 * Size( s );
true
gap> sm:= SmallerDegreePermutationRepresentation( act );;
gap> NrMovedPoints( Image( sm ) );
4617
gap> g:= Image( sm );;

##  doc2/ctblcons.xml (3221-3243)
gap> c:= CyclicGroup( IsPermGroup, 9 );;
gap> dp:= DirectProduct( g, c );;
gap> u:= Image( Embedding( dp, 1 ) );;
gap> c:= Image( Embedding( dp, 2 ) );;
gap> c3:= c.1^3;
(4618,4621,4624)(4619,4622,4625)(4620,4623,4626)
gap> z:= Centre( u );;
gap> Size( z );  Length( GeneratorsOfGroup( z ) );
3
1
gap> diag:= Subgroup( dp, [ c3 * z.1 ] );;
gap> orb:= Orbit( dp, [ 1, 4618 ], OnPairs );;
gap> Length( orb );
41553
gap> orb:= Set( orb );;
gap> orbs:= List( OrbitsDomain( diag, orb, OnSets ), Set );;
gap> Length( orbs );
13851
gap> cp:= Action( dp, orbs, OnSetsSets );;
gap> Size( cp );
148925952

##  doc2/ctblcons.xml (3254-3265)
gap> der:= DerivedSubgroup( cp );;
gap> Index( cp, der );
9
gap> inter:= IntermediateSubgroups( cp, der ).subgroups;;
gap> z:= Centre( cp );;
gap> Size( z );
9
gap> inter:= Filtered( inter, x -> not IsSubset( x, z ) );;
gap> List( inter, Size );
[ 49641984, 49641984, 49641984 ]

##  doc2/ctblcons.xml (3273-3278)
gap> IsomorphismGroups( inter[1], inter[2] ) <> fail;
true
gap> IsomorphismGroups( inter[1], inter[3] ) <> fail;
true

##  doc2/ctblcons.xml (3294-3302)
gap> t1:= CharacterTable( "3.U3(8).3_1" );;
gap> t2:= CharacterTableIsoclinic( t1, rec( k:= 1 ) );;
gap> t3:= CharacterTableIsoclinic( t1, rec( k:= 2 ) );;
gap> TransformingPermutationsCharacterTables( t1, t2 ) <> fail;
true
gap> TransformingPermutationsCharacterTables( t1, t3 ) <> fail;
true

##  doc2/ctblcons.xml (3398-3423)
gap> f42:= CharacterTable( "F4(2)" );;
gap> v4:= CharacterTable( "2^2" );;
gap> dp:= v4 * f42;
CharacterTable( "V4xF4(2)" )
gap> b:= CharacterTable( "B" );;
gap> f42fusb:= PossibleClassFusions( f42, b );;
gap> Length( f42fusb );
1
gap> f42fusdp:= GetFusionMap( f42, dp );;
gap> comp:= CompositionMaps( f42fusb[1], InverseMap( f42fusdp ) );
[ 1, 3, 3, 3, 5, 6, 6, 7, 9, 9, 9, 9, 14, 14, 13, 13, 10, 14, 14, 12, 
  14, 17, 15, 18, 22, 22, 22, 22, 26, 26, 22, 22, 27, 27, 28, 31, 31, 
  39, 39, 36, 36, 33, 33, 39, 39, 35, 41, 42, 47, 47, 49, 49, 49, 58, 
  58, 56, 56, 66, 66, 66, 66, 58, 58, 66, 66, 69, 69, 60, 72, 72, 75, 
  79, 79, 81, 81, 85, 86, 83, 83, 91, 91, 94, 94, 104, 104, 109, 109, 
  116, 116, 114, 114, 132, 132, 140, 140 ]
gap> v4fusdp:= GetFusionMap( v4, dp );
[ 1, 96 .. 286 ]
gap> comp[ v4fusdp[2] ]:= 4;;
gap> dpfusb:= PossibleClassFusions( dp, b, rec( fusionmap:= comp ) );;
gap> Length( dpfusb );
4
gap> Set( dpfusb, x -> x{ v4fusdp } );
[ [ 1, 4, 2, 2 ] ]

##  doc2/ctblcons.xml (3440-3451)
gap> tblG:= dp / v4fusdp{ [ 1, 2 ] };;
gap> tblMG:= dp;;
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblGA:= c2 * CharacterTable( "F4(2).2" );
CharacterTable( "C2xF4(2).2" )
gap> GfusGA:= PossibleClassFusions( tblG, tblGA );;
gap> Length( GfusGA );
4
gap> Length( RepresentativesFusions( tblG, GfusGA, tblGA ) );
1

##  doc2/ctblcons.xml (3468-3472)
gap> Length( RepresentativesFusions( Group( () ), GfusGA, tblGA ) );
1
gap> StoreFusion( tblG, GfusGA[1], tblGA );

##  doc2/ctblcons.xml (3477-3486)
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, elms[1],
>               "(2^2xF4(2)):2" );;
gap> Length( poss );
1
gap> tblMGA:= poss[1].table;;

##  doc2/ctblcons.xml (3498-3502)
gap> IsRecord( TransformingPermutationsCharacterTables( tblMGA,
>                  CharacterTable( "(2^2xF4(2)):2" ) ) );
true

##  doc2/ctblcons.xml (3565-3573)
gap> s3:= CharacterTable( "Dihedral", 6 );;
gap> fi222:= CharacterTable( "Fi22.2" );;
gap> tblMbar:= s3 * fi222;;
gap> b:= CharacterTable( "B" );;
gap> Mbarfusb:= PossibleClassFusions( tblMbar, b );;
gap> Length( Mbarfusb );
1

##  doc2/ctblcons.xml (3584-3588)
gap> 2b:= CharacterTable( "2.B" );;
gap> PossibleClassFusions( CharacterTable( "Fi22" ), 2b );
[  ]

##  doc2/ctblcons.xml (3607-3612)
gap> c3:= CharacterTable( "Cyclic", 3 );;
gap> 2fi222:= CharacterTable( "2.Fi22.2" );;
gap> PossibleClassFusions( c3 * CharacterTableIsoclinic( 2fi222 ), 2b );
[  ]

##  doc2/ctblcons.xml (3621-3631)
gap> s3inMbar:= GetFusionMap( s3, tblMbar );
[ 1, 113 .. 225 ]
gap> s3inb:= Mbarfusb[1]{ s3inMbar };
[ 1, 6, 2 ]
gap> 2bfusb:= GetFusionMap( 2b, b );;
gap> 2s3in2B:= InverseMap( 2bfusb ){ s3inb };
[ [ 1, 2 ], [ 8, 9 ], 3 ]
gap> CompositionMaps( OrdersClassRepresentatives( 2b ), 2s3in2B );
[ [ 1, 2 ], [ 3, 6 ], 2 ]

##  doc2/ctblcons.xml (3650-3653)
gap> PossibleClassFusions( s3 * 2fi222, 2b );
[  ]

##  doc2/ctblcons.xml (3759-3781)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2fi22:= CharacterTable( "2.Fi22" );;
gap> tblNmodY:= c2 * 2fi22;;
gap> centre:= GetFusionMap( 2fi22, tblNmodY ){
>                 ClassPositionsOfCentre( 2fi22 ) };
[ 1, 2 ]
gap> tblNmod6:= tblNmodY / centre;;
gap> tblMmod6:= c2 * fi222;;
gap> fus:= PossibleClassFusions( tblNmod6, tblMmod6 );;
gap> Length( fus );
1
gap> StoreFusion( tblNmod6, fus[1], tblMmod6 );
gap> elms:= PossibleActionsForTypeMGA( tblNmodY, tblNmod6, tblMmod6 );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblNmodY, tblNmod6, tblMmod6,
>               elms[1], "2^2.Fi22.2" );;
gap> Length( poss );
1
gap> tblMmodY:= poss[1].table;
CharacterTable( "2^2.Fi22.2" )

##  doc2/ctblcons.xml (3792-3811)
gap> tblU:= c3 * 2fi222;;
gap> tblUmodY:= tblU / GetFusionMap( c3, tblU );;
gap> fus:= PossibleClassFusions( tblUmodY, tblMmodY );;
gap> Length( RepresentativesFusions( Group( () ), fus, tblMmodY ) );
1
gap> StoreFusion( tblUmodY, fus[1], tblMmodY );
gap> elms:= PossibleActionsForTypeMGA( tblU, tblUmodY, tblMmodY );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblU, tblUmodY, tblMmodY,
>               elms[1], "(S3x2.Fi22).2" );;
gap> Length( poss );
1
gap> tblM:= poss[1].table;
CharacterTable( "(S3x2.Fi22).2" )
gap> mfus2b:= PossibleClassFusions( tblM, 2b );;
gap> Length( RepresentativesFusions( tblM, mfus2b, 2b ) );
1

##  doc2/ctblcons.xml (3821-3824)
gap> Irr( tblM / ClassPositionsOfCentre( tblM ) ) = Irr( tblMbar );
true

##  doc2/ctblcons.xml (3833-3837)
gap> IsRecord( TransformingPermutationsCharacterTables( tblM,
>                  CharacterTable( "(S3x2.Fi22).2" ) ) );
true

##  doc2/ctblcons.xml (3939-3947)
gap> fi24:= CharacterTable( "Fi24" );;
gap> t:= CharacterTable( "2^2.Fi22.2" );;
gap> fus:= PossibleClassFusions( t, fi24 );;
gap> Length( fus );
4
gap> Length( RepresentativesFusions( t, fus, fi24 ) );
1

##  doc2/ctblcons.xml (3976-3986)
gap> t:= CharacterTable( "(S3x2.Fi22).2" );;
gap> 3fi24:= CharacterTable( "3.Fi24" );;                        
gap> fus:= PossibleClassFusions( t, 3fi24 );;
gap> Length( fus );
16
gap> Length( RepresentativesFusions( t, fus, 3fi24 ) );
1
gap> GetFusionMap( t, 3fi24 ) in fus; 
true

##  doc2/ctblcons.xml (3995-4013)
gap> m:= CharacterTable( "M" );;
gap> tfusm:= PossibleClassFusions( t, m );;
gap> Length( tfusm );
4
gap> Length( RepresentativesFusions( t, tfusm, m ) );
1
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>        x -> Sum( SizesConjugacyClasses( t ){ x } ) = 6 );
[ [ 1, 2, 142, 143 ] ]
gap> Set( tfusm, x -> x{ nsg[1] } );
[ [ 1, 2, 4, 13 ] ]
gap> OrdersClassRepresentatives( t ){ nsg[1] };
[ 1, 2, 3, 6 ]
gap> PowerMap( m, -1 )[13];
13
gap> Size( t ) = 2 * SizesCentralizers( m )[13];
true

##  doc2/ctblcons.xml (4096-4102)
gap> 2Fi22:= CharacterTable( "2.Fi22" );;
gap> ClassPositionsOfCentre( 2Fi22 );
[ 1, 2 ]
gap> 2 in PowerMap( 2Fi22, 2 );
false

##  doc2/ctblcons.xml (4114-4122)
gap> PossibleClassFusions( CharacterTable( "U4(3)" ), 2Fi22 );
[  ]
gap> tblU:= CharacterTable( "2.U4(3).2_2" );;
gap> iso:= CharacterTableIsoclinic( tblU );
CharacterTable( "Isoclinic(2.U4(3).2_2)" )
gap> PossibleClassFusions( iso, 2Fi22 );                      
[  ]

##  doc2/ctblcons.xml (4148-4153)
gap> derpos:= ClassPositionsOfDerivedSubgroup( tblU );;
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( tblU ) ], derpos );;
gap> 2 in OrdersClassRepresentatives( tblU ){ outer };
true

##  doc2/ctblcons.xml (4169-4177)
gap> tblM:= CharacterTable( "Dihedral", 6 ) * tblU;;
gap> fus:= PossibleClassFusions( tblM, 2Fi22 );;
gap> Length( RepresentativesFusions( tblM, fus, 2Fi22 ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( tblM,
>                  CharacterTable( "2.Fi22M8" ) ) );
true

##  doc2/ctblcons.xml (4275-4278)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "2.HS" ) * c2 );;

##  doc2/ctblcons.xml (4287-4292)
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblCbar:= tblC / ord2[1];;

##  doc2/ctblcons.xml (4302-4309)
gap> tblNbar:= CharacterTable( "HS.2" ) * c2;;
gap> fus:= PossibleClassFusions( tblCbar, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 
      19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 29, 30, 31, 32, 
      33, 34, 35, 36, 35, 36, 37, 38, 39, 40, 41, 42, 41, 42 ] ]
gap> StoreFusion( tblCbar, fus[1], tblNbar );

##  doc2/ctblcons.xml (4318-4340)
gap> elms:= PossibleActionsForTypeMGA( tblC, tblCbar, tblNbar );
[ [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6, 8 ], [ 7 ], [ 9 ], [ 10 ], 
      [ 11 ], [ 12, 14 ], [ 13 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19 ], 
      [ 20 ], [ 21 ], [ 22 ], [ 23 ], [ 24, 26 ], [ 25 ], [ 27 ], 
      [ 28, 30 ], [ 29 ], [ 31 ], [ 32, 34 ], [ 33 ], [ 35 ], 
      [ 36, 38 ], [ 37 ], [ 39 ], [ 40, 42 ], [ 41 ], [ 43 ], 
      [ 44, 46 ], [ 45 ], [ 47 ], [ 48, 50 ], [ 49 ], [ 51, 53 ], 
      [ 52, 54 ], [ 55 ], [ 56, 58 ], [ 57 ], [ 59 ], [ 60 ], 
      [ 61, 65 ], [ 62, 68 ], [ 63, 67 ], [ 64, 66 ], [ 69 ], 
      [ 70, 72 ], [ 71 ], [ 73 ], [ 74, 76 ], [ 75 ], [ 77, 81 ], 
      [ 78, 84 ], [ 79, 83 ], [ 80, 82 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6, 8 ], [ 7 ], [ 9 ], [ 10 ], 
      [ 11 ], [ 12, 14 ], [ 13 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19 ], 
      [ 20 ], [ 21 ], [ 22 ], [ 23 ], [ 24, 26 ], [ 25 ], [ 27 ], 
      [ 28, 30 ], [ 29 ], [ 31 ], [ 32, 34 ], [ 33 ], [ 35, 37 ], 
      [ 36 ], [ 38 ], [ 39 ], [ 40, 42 ], [ 41 ], [ 43 ], [ 44, 46 ], 
      [ 45 ], [ 47, 49 ], [ 48 ], [ 50 ], [ 51, 53 ], [ 52, 54 ], 
      [ 55 ], [ 56, 58 ], [ 57 ], [ 59 ], [ 60 ], [ 61, 65 ], 
      [ 62, 68 ], [ 63, 67 ], [ 64, 66 ], [ 69, 71 ], [ 70 ], [ 72 ], 
      [ 73 ], [ 74, 76 ], [ 75 ], [ 77, 83 ], [ 78, 82 ], [ 79, 81 ], 
      [ 80, 84 ] ] ]

##  doc2/ctblcons.xml (4348-4353)
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblCbar, tblNbar, pi, "4.HS.2" ) );;
gap> List( poss, Length );
[ 0, 2 ]

##  doc2/ctblcons.xml (4376-4389)
gap> result:= poss[2];;
gap> hn2:= CharacterTable( "HN.2" );;
gap> possfus:= List( result, r -> PossibleClassFusions( r.table, hn2 ) );;
gap> List( possfus, Length );
[ 32, 0 ]
gap> RepresentativesFusions( result[1].table, possfus[1], hn2 );
[ [ 1, 46, 2, 2, 47, 3, 7, 45, 4, 58, 13, 6, 46, 47, 6, 47, 7, 48, 
      10, 62, 20, 9, 63, 21, 12, 64, 24, 27, 49, 50, 13, 59, 14, 16, 
      70, 30, 18, 53, 52, 17, 54, 20, 65, 22, 36, 56, 26, 76, 39, 77, 
      28, 59, 58, 31, 78, 41, 34, 62, 35, 65, 2, 45, 3, 45, 6, 48, 7, 
      47, 17, 54, 13, 49, 13, 50, 14, 50, 18, 53, 18, 52, 21, 56, 25, 
      57, 27, 59, 30, 60, 44, 72, 34, 66, 35, 66, 41, 71 ] ]

##  doc2/ctblcons.xml (4404-4409)
gap> libtbl:= CharacterTable( "4.HS.2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( result[1].table,
>                  libtbl ) );
true

##  doc2/ctblcons.xml (4427-4434)
gap> StoreFusion( tblC, result[1].MGfusMGA, result[1].table );
gap> ForAll( PrimeDivisors( Size( result[1].table ) ),
>            p -> IsRecord( TransformingPermutationsCharacterTables(
>                     BrauerTableOfTypeMGA( tblC mod p, tblNbar mod p,
>                         result[1].table ).table, libtbl mod p ) ) );
true

##  doc2/ctblcons.xml (4571-4601)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2a6:= CharacterTable( "2.A6" );;
gap> tblC:= CharacterTableIsoclinic( 2a6 * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10, 9, 10 ] ]
gap> StoreFusion( tblG, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 12 ], 
      [ 9, 13 ], [ 10, 14 ], [ 15, 17 ], [ 16, 18 ], [ 19, 23 ], 
      [ 20, 24 ], [ 21, 25 ], [ 22, 26 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], 
      [ 9, 13 ], [ 10, 12 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], 
      [ 9, 13 ], [ 10, 12 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.A6.2_3" ) );
[ [  ], [  ], 
  [ 
      rec( 
          MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 9, 6, 9, 8, 7, 10, 
              11, 10, 12, 13, 14, 15, 16, 13, 16, 15, 14 ], 
          table := CharacterTable( "4.A6.2_3" ) ) ] ]

##  doc2/ctblcons.xml (4611-4616)
gap> t:= poss[3][1].table;;
gap> IsRecord( TransformingPermutationsCharacterTables( t,
>                  CharacterTable( "4.A6.2_3" ) ) );
true

##  doc2/ctblcons.xml (4645-4664)
gap> g:= GammaL(2,9);;
gap> phi:= IsomorphismPermGroup( g );;
gap> img:= Image( phi );;
gap> der:= DerivedSubgroup( img );;
gap> derder:= DerivedSubgroup( der );;
gap> Index( img, derder );
16
gap> inter:= Filtered( IntermediateSubgroups( img, derder ).subgroups,
>                s -> Size( s ) = 4 * Size( derder ) and
>                     IsCyclic( CommutatorFactorGroup( s ) ) and
>                     Size( Centre( s ) ) = 2 );;
gap> Length( inter );
2
gap> ForAll( inter, x -> IsConjugate( img, inter[1], x ) );
true
gap> IsRecord( TransformingPermutationsCharacterTables( t,
>                  CharacterTable( inter[1] ) ) );
true

##  doc2/ctblcons.xml (4752-4779)
gap> tblC:= 2a6 * c2;;
gap> z:= GetFusionMap( 2a6, tblC ){ ClassPositionsOfCentre( 2a6 ) };
[ 1, 3 ]
gap> tblG:= tblC / z;;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10, 9, 10 ] ]
gap> StoreFusion( tblG, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 12 ], 
      [ 9, 13 ], [ 10, 14 ], [ 15, 17 ], [ 16, 18 ], [ 19, 23 ], 
      [ 20, 24 ], [ 21, 25 ], [ 22, 26 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], 
      [ 9, 13 ], [ 10, 12 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], 
      [ 9, 13 ], [ 10, 12 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "2^2.A6.2_3" ) );
[ [  ], [  ], 
  [ 
      rec( 
          MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 9, 6, 9, 8, 7, 10, 
              11, 10, 12, 13, 14, 15, 16, 13, 16, 15, 14 ], 
          table := CharacterTable( "2^2.A6.2_3" ) ) ] ]

##  doc2/ctblcons.xml (4878-4931)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "6.A6" ) * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 7 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "3.A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 
      17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 21, 22, 23, 24, 25, 26 ]
    , 
  [ 1, 2, 5, 6, 3, 4, 7, 8, 11, 12, 9, 10, 13, 14, 13, 14, 15, 16, 
      19, 20, 17, 18, 21, 22, 25, 26, 23, 24, 21, 22, 25, 26, 23, 24 
     ] ]
gap> rep:= RepresentativesFusions( Group( () ), fus, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 
      17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 21, 22, 23, 24, 25, 26 
     ] ]
gap> StoreFusion( tblG, rep[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], 
      [ 10 ], [ 11 ], [ 12 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], 
      [ 18 ], [ 19, 23 ], [ 20, 24 ], [ 21, 25 ], [ 22, 26 ], 
      [ 27, 33 ], [ 28, 34 ], [ 29, 35 ], [ 30, 36 ], [ 31, 37 ], 
      [ 32, 38 ], [ 39, 51 ], [ 40, 52 ], [ 41, 53 ], [ 42, 54 ], 
      [ 43, 55 ], [ 44, 56 ], [ 45, 57 ], [ 46, 58 ], [ 47, 59 ], 
      [ 48, 60 ], [ 49, 61 ], [ 50, 62 ] ], 
  [ [ 1 ], [ 2, 8 ], [ 3 ], [ 4, 10 ], [ 5 ], [ 6, 12 ], [ 7 ], 
      [ 9 ], [ 11 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], [ 18 ], 
      [ 19, 23 ], [ 20, 26 ], [ 21, 25 ], [ 22, 24 ], [ 27 ], 
      [ 28, 34 ], [ 29 ], [ 30, 36 ], [ 31 ], [ 32, 38 ], [ 33 ], 
      [ 35 ], [ 37 ], [ 39, 51 ], [ 40, 58 ], [ 41, 53 ], [ 42, 60 ], 
      [ 43, 55 ], [ 44, 62 ], [ 45, 57 ], [ 46, 52 ], [ 47, 59 ], 
      [ 48, 54 ], [ 49, 61 ], [ 50, 56 ] ], 
  [ [ 1 ], [ 2, 8 ], [ 3 ], [ 4, 10 ], [ 5 ], [ 6, 12 ], [ 7 ], 
      [ 9 ], [ 11 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], [ 18 ], 
      [ 19, 23 ], [ 20, 26 ], [ 21, 25 ], [ 22, 24 ], [ 27, 33 ], 
      [ 28 ], [ 29, 35 ], [ 30 ], [ 31, 37 ], [ 32 ], [ 34 ], [ 36 ], 
      [ 38 ], [ 39, 51 ], [ 40, 58 ], [ 41, 53 ], [ 42, 60 ], 
      [ 43, 55 ], [ 44, 62 ], [ 45, 57 ], [ 46, 52 ], [ 47, 59 ], 
      [ 48, 54 ], [ 49, 61 ], [ 50, 56 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "12.A6.2_3" ) );
[ [  ], [  ], 
  [ 
      rec( 
          MGfusMGA := [ 1, 2, 3, 4, 5, 6, 7, 2, 8, 4, 9, 6, 10, 11, 12, 
              13, 14, 15, 16, 17, 18, 19, 16, 19, 18, 17, 20, 21, 22, 
              23, 24, 25, 20, 26, 22, 27, 24, 28, 29, 30, 31, 32, 33, 
              34, 35, 36, 37, 38, 39, 40, 29, 36, 31, 38, 33, 40, 35, 
              30, 37, 32, 39, 34 ], 
          table := CharacterTable( "12.A6.2_3" ) ) ] ]

##  doc2/ctblcons.xml (4941-4945)
gap> IsRecord( TransformingPermutationsCharacterTables( poss[3][1].table,
>                  CharacterTable( "12.A6.2_3" ) ) );
true

##  doc2/ctblcons.xml (4955-5006)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "2.L2(25)" ) * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "L2(25).2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 15, 
      16, 15, 16, 17, 18, 17, 18, 19, 20, 19, 20 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 17, 
      18, 17, 18, 19, 20, 19, 20, 15, 16, 15, 16 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 19, 
      20, 19, 20, 15, 16, 15, 16, 17, 18, 17, 18 ] ]
gap> rep:= RepresentativesFusions( Group( () ), fus, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 15, 
      16, 15, 16, 17, 18, 17, 18, 19, 20, 19, 20 ] ]
gap> StoreFusion( tblG, rep[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], 
      [ 10 ], [ 11, 13 ], [ 12, 14 ], [ 15, 19 ], [ 16, 20 ], 
      [ 17, 21 ], [ 18, 22 ], [ 23, 25 ], [ 24, 26 ], [ 27, 33 ], 
      [ 28, 34 ], [ 29, 31 ], [ 30, 32 ], [ 35, 39 ], [ 36, 40 ], 
      [ 37, 41 ], [ 38, 42 ], [ 43, 47 ], [ 44, 48 ], [ 45, 49 ], 
      [ 46, 50 ], [ 51, 55 ], [ 52, 56 ], [ 53, 57 ], [ 54, 58 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7 ], [ 8, 10 ], [ 9 ], 
      [ 11 ], [ 12, 14 ], [ 13 ], [ 15, 19 ], [ 16, 22 ], [ 17, 21 ], 
      [ 18, 20 ], [ 23, 25 ], [ 24 ], [ 26 ], [ 27, 31 ], [ 28, 34 ], 
      [ 29, 33 ], [ 30, 32 ], [ 35, 39 ], [ 36, 42 ], [ 37, 41 ], 
      [ 38, 40 ], [ 43, 47 ], [ 44, 50 ], [ 45, 49 ], [ 46, 48 ], 
      [ 51, 55 ], [ 52, 58 ], [ 53, 57 ], [ 54, 56 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7 ], [ 8, 10 ], [ 9 ], 
      [ 11, 13 ], [ 12 ], [ 14 ], [ 15, 19 ], [ 16, 22 ], [ 17, 21 ], 
      [ 18, 20 ], [ 23, 25 ], [ 24 ], [ 26 ], [ 27, 33 ], [ 28, 32 ], 
      [ 29, 31 ], [ 30, 34 ], [ 35, 39 ], [ 36, 42 ], [ 37, 41 ], 
      [ 38, 40 ], [ 43, 47 ], [ 44, 50 ], [ 45, 49 ], [ 46, 48 ], 
      [ 51, 55 ], [ 52, 58 ], [ 53, 57 ], [ 54, 56 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.L2(25).2_3" ) );
[ [  ], [  ], 
  [ 
      rec( 
          MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 9, 11, 12, 
              13, 14, 15, 12, 15, 14, 13, 16, 17, 16, 18, 19, 20, 21, 
              22, 21, 20, 19, 22, 23, 24, 25, 26, 23, 26, 25, 24, 27, 
              28, 29, 30, 27, 30, 29, 28, 31, 32, 33, 34, 31, 34, 33, 
              32 ], table := CharacterTable( "4.L2(25).2_3" ) ) ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[3][1].table,
>                  CharacterTable( "4.L2(25).2_3" ) ) );
true

##  doc2/ctblcons.xml (5019-5032)
gap> g:= GammaL(2,25);;
gap> phi:= IsomorphismPermGroup( g );;
gap> img:= Image( phi );;
gap> der:= DerivedSubgroup( img );;
gap> derder:= DerivedSubgroup( der );;
gap> Index( img, derder );
48
gap> inter:= Filtered( IntermediateSubgroups( img, derder ).subgroups,
>                s -> Size( s ) = 4 * Size( derder ) and
>                     IsCyclic( CommutatorFactorGroup( s ) ) and
>                     Size( Centre( s ) ) = 2 );
[  ]

##  doc2/ctblcons.xml (5048-5065)
gap> c:= Centralizer( img, derder );;
gap> Size( c );  IsCyclic( c );
24
true
gap> cgen:= MinimalGeneratingSet( c );;
gap> four:= cgen[1]^6;;
gap> s:= ClosureGroup( derder, four );;
gap> LoadPackage( "GrpConst", false );
true
gap> filt:= Filtered( CyclicExtensions( s, 2 ),
>               x -> Size( Centre( x ) ) = 2 and
>                    IsCyclic( CommutatorFactorGroup( x ) ) );;
gap> Length( filt );
2
gap> IsomorphismGroups( filt[1], filt[2] ) <> fail;
true

##  doc2/ctblcons.xml (5073-5077)
gap> TransformingPermutationsCharacterTables( CharacterTable( filt[1] ),
>        CharacterTable( "4.L2(25).2_3" ) ) <> fail;
true

##  doc2/ctblcons.xml (5115-5136)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2l:= CharacterTable( "2.L2(49)" );;
gap> tblC:= CharacterTableIsoclinic( 2l * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic(
>                  CharacterTable( "L2(49).2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );;
gap> Length( fus );
10
gap> StoreFusion( tblG, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );;
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.L2(49).2_3" ) );;
gap> List( poss, Length );
[ 0, 0, 1 ]
gap> t:= poss[3][1].table;
CharacterTable( "4.L2(49).2_3" )

##  doc2/ctblcons.xml (5149-5165)
gap> g:= GammaL(2,49);;
gap> phi:= IsomorphismPermGroup( g );;
gap> img:= Image( phi );;
gap> der:= DerivedSubgroup( img );;
gap> derder:= DerivedSubgroup( der );;
gap> Index( img, derder );
96
gap> inter:= Filtered( IntermediateSubgroups( img, derder ).subgroups,
>                s -> Size( s ) = 4 * Size( derder ) and
>                     IsCyclic( CommutatorFactorGroup( s ) ) and
>                     Size( Centre( s ) ) = 2 );;
gap> Length( inter );                                        
4
gap> ForAll( inter, x -> IsConjugate( img, inter[1], x ) );
true

##  doc2/ctblcons.xml (5174-5181)
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTable( inter[1] ) ) <> fail;
true
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTable( "4.L2(49).2_3" ) ) <> fail;
true

##  doc2/ctblcons.xml (5195-5220)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2l:= CharacterTable( "2.L2(81)" );;
gap> tblC:= CharacterTableIsoclinic( 2l * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic(
>                  CharacterTable( "L2(81).2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );;
gap> Length( fus );
40
gap> fusreps:= RepresentativesFusions( tblG, fus, tblNbar );;
gap> Length( fusreps );
1
gap> StoreFusion( tblG, fusreps[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );;
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.L2(81).2_3" ) );;
gap> List( poss, Length );
[ 0, 0, 1 ]
gap> TransformingPermutationsCharacterTables( poss[3][1].table,
>        CharacterTable( "4.L2(81).2_3" ) ) <> fail;
true

##  doc2/ctblcons.xml (5230-5248)
gap> g:= GammaL(2,81);;
gap> phi:= IsomorphismPermGroup( g );;
gap> img:= Image( phi );;
gap> der:= DerivedSubgroup( img );;
gap> derder:= DerivedSubgroup( der );;
gap> Index( img, derder );
320
gap> inter:= Filtered( IntermediateSubgroups( img, derder ).subgroups,
>                s -> Size( s ) = 4 * Size( derder ) and
>                     IsCyclic( CommutatorFactorGroup( s ) ) and
>                     Size( Centre( s ) ) = 2 );;
gap> ForAll( inter, x -> IsConjugate( img, inter[1], x ) );
true
gap> NrConjugacyClasses( inter[1] );
52
gap> NrConjugacyClasses( CharacterTable( "4.L2(81).2_3" ) );
112

##  doc2/ctblcons.xml (5257-5264)
gap> t:= CharacterTable( "2.L2(81).4_1" );;
gap> NrConjugacyClasses( t );
52
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTable( inter[1] ) ) <> fail;
true

##  doc2/ctblcons.xml (5275-5295)
gap> c:= Centralizer( img, derder );;
gap> Size( c );  IsCyclic( c );
80
true
gap> cgen:= MinimalGeneratingSet( c );;
gap> four:= cgen[1]^20;;
gap> s:= ClosureGroup( derder, four );;
gap> LoadPackage( "GrpConst", false );
true
gap> filt:= Filtered( CyclicExtensions( s, 2 ),
>               x -> Size( Centre( x ) ) = 2 and
>                    IsCyclic( CommutatorFactorGroup( x ) ) );;
gap> Length( filt );
2
gap> IsomorphismGroups( filt[1], filt[2] ) <> fail;
true
gap> TransformingPermutationsCharacterTables( CharacterTable( filt[1] ),
>        CharacterTable( "4.L2(81).2_3" ) ) <> fail;
true

##  doc2/ctblcons.xml (5834-5855)
gap> s:= CharacterTable( "U3(8)" );;
gap> s3:= CharacterTable( "U3(8).3_3" );;
gap> poss:= PossibleClassFusions( s, s3 );;
gap> Length( poss );
4
gap> Length( RepresentativesFusions( s, poss, s3 ) );
1
gap> smod2:= s mod 2;;
gap> s3mod2:= s3 mod 2;;
gap> good:= [];;  modmap:= 0;;
gap> for map in poss do
>      modmap:= CompositionMaps( InverseMap( GetFusionMap( s3mod2, s3 ) ),
>                   CompositionMaps( map, GetFusionMap( smod2, s ) ) );
>      rest:= List( Irr( s3mod2 ), x -> x{ modmap } );
>      if not fail in Decomposition( Irr( smod2 ), rest, "nonnegative" ) then
>        Add( good, map );
>      fi;
>    od;
gap> Length( good );
2

##  doc2/ctblcons.xml (5865-5871)
gap> good[2] = CompositionMaps( PowerMap( s3, -1 ), good[1] );
true
gap> GetFusionMap( s, s3 ) in good;
true
gap> sfuss3:= GetFusionMap( s, s3 );;

##  doc2/ctblcons.xml (5903-5931)
gap> c3:= CharacterTable( "Cyclic", 3 );;
gap> tblG:= s * c3;;
gap> dp:= s3 * c3;;
gap> tblGA1:= CharacterTableIsoclinic( dp, rec( k:= 1 ) );;
gap> tblGA2:= CharacterTableIsoclinic( dp, rec( k:= 2 ) );;
gap> good:= [];;
gap> tblGmod2:= tblG mod 2;;
gap> for tblGA in [ tblGA1, tblGA2 ] do
>      tblGAmod2:= tblGA mod 2;
>      for map in PossibleClassFusions( tblG, tblGA ) do
>        modmap:= CompositionMaps(
>            InverseMap( GetFusionMap( tblGAmod2, tblGA ) ),
>            CompositionMaps( map, GetFusionMap( tblGmod2, tblG ) ) );
>        rest:= List( Irr( tblGAmod2 ), x -> x{ modmap } );
>        if not fail in Decomposition( Irr( tblGmod2 ), rest,
>                           "nonnegative" ) and
>           CompositionMaps( GetFusionMap( tblGA, s3 ), map ) =
>           CompositionMaps( sfuss3, GetFusionMap( tblG, s ) ) then
>          Add( good, [ tblGA, map ] );
>        fi;
>      od;
>    od;
gap> List( good, x -> x[1] );
[ CharacterTable( "Isoclinic(U3(8).3_3xC3,1)" ), 
  CharacterTable( "Isoclinic(U3(8).3_3xC3,1)" ), 
  CharacterTable( "Isoclinic(U3(8).3_3xC3,2)" ), 
  CharacterTable( "Isoclinic(U3(8).3_3xC3,2)" ) ]

##  doc2/ctblcons.xml (5944-5948)
gap> 3s:= CharacterTable( "3.U3(8)" );;
gap> dp:= 3s * c3;;
gap> tblMG:= CharacterTableIsoclinic( dp );;

##  doc2/ctblcons.xml (5959-5972)
gap> GetFusionMap( tblMG, tblG );
fail
gap> cen:= ClassPositionsOfCentre( tblMG );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
gap> OrdersClassRepresentatives( tblMG ){ cen };
[ 1, 9, 9, 3, 9, 9, 3, 9, 9 ]
gap> facttbl:= tblMG / [ 1, 4, 7 ];;
gap> tr:= TransformingPermutationsCharacterTables( facttbl, tblG );;
gap> tr.rows;  tr.columns;
()
()
gap> StoreFusion( tblMG, GetFusionMap( tblMG, facttbl ), tblG );

##  doc2/ctblcons.xml (5982-5998)
gap> posstbls:= [];;
gap> for pair in good do
>      tblGA:= pair[1];
>      GfusGA:= pair[2];
>      tblG:= s * c3;
>      StoreFusion( tblG, GfusGA, tblGA );
>      for pi in PossibleActionsForTypeMGA( tblMG, tblG, tblGA ) do
>        for cand in PossibleCharacterTablesOfTypeMGA(
>                        tblMG, tblG, tblGA, pi, "test" ) do
>          Add( posstbls, [ tblGA, cand ] );
>        od;
>      od;
>    od;
gap> Length( posstbls );
32

##  doc2/ctblcons.xml (6007-6030)
gap> compatible:= [];;  r:= 0;;  modr:= 0;;
gap> for pair in posstbls do
>      tblGA:= pair[1];
>      r:= pair[2];
>      comp:= ComputedClassFusions( tblMG );
>      pos:= PositionProperty( comp, x -> x.name = Identifier( r.table ) );
>      if pos = fail then
>        StoreFusion( tblMG, r.MGfusMGA, r.table );
>      else
>        comp[ pos ]:= ShallowCopy( comp[ pos ] );
>        comp[ pos ].map:= r.MGfusMGA;
>      fi;
>      Unbind( ComputedBrauerTables( tblMG )[2] );
>      modr:= BrauerTableOfTypeMGA( tblMG mod 2, tblGA mod 2, r.table );
>      rest:= List( Irr( modr.table ), x -> x{ modr.MGfusMGA } );
>      dec:= Decomposition( Irr( tblMG mod 2 ), rest, "nonnegative" );
>      if not fail in dec then
>        Add( compatible, pair );
>      fi;
>    od;
gap> Length( compatible );
8

##  doc2/ctblcons.xml (6038-6048)
gap> tbls:= [];;
gap> for pair in compatible do
>      if ForAll( tbls, t -> TransformingPermutationsCharacterTables(
>                                t, pair[2].table ) = fail ) then
>        Add( tbls, pair[2].table );
>      fi;
>    od;
gap> Length( tbls );
2

##  doc2/ctblcons.xml (6061-6074)
gap> Set( OrdersClassRepresentatives( tbls[1] ) );
[ 1, 2, 3, 4, 6, 7, 9, 12, 18, 19, 21, 27, 36, 54, 57, 63, 171 ]
gap> Set( OrdersClassRepresentatives( tbls[2] ) );
[ 1, 2, 3, 4, 6, 7, 9, 12, 18, 19, 21, 27, 36, 57, 63, 171 ]
gap> pos171:= Positions( OrdersClassRepresentatives( tbls[1] ), 171 );;
gap> pow4:= PowerMap( tbls[1], 4 );;
gap> ForAny( [ 1 .. Length( pos171 ) ],
>            i -> pos171[i] = pow4[ pos171[i] ] );
false
gap> pos171:= Positions( OrdersClassRepresentatives( tbls[2] ), 171 );;
gap> PowerMap( tbls[2], 4 ){ pos171 } = pos171;
true

##  doc2/ctblcons.xml (6083-6100)
gap> gu:= GU(3,8);;
gap> orbs:= OrbitsDomain( gu, Elements( GF(64)^3 ) );;
gap> List( orbs, Length );
[ 1, 32319, 32832, 32832, 32832, 32832, 32832, 32832, 32832 ]
gap> orb:= SortedList( First( orbs, x -> Length( x ) = 32319 ) );;
gap> actgu:= Action( gu, orb, OnRight );;
gap> Size( actgu ) = Size( gu );
true
gap> cen:= Centre( actgu );;
gap> Size( cen );
9
gap> u:= ClosureGroup( DerivedSubgroup( actgu ), cen );;
gap> aut:= v -> List( v, x -> x^4 );;
gap> pi:= PermList( List( orb, v -> PositionSorted( orb, aut( v ) ) ) );;
gap> outer:= First( GeneratorsOfGroup( actgu ), x -> not x in u );;
gap> g:= ClosureGroup( u, pi * outer );;

##  doc2/ctblcons.xml (6109-6120)
gap> g:= Group( SmallGeneratingSet( g ) );;
gap> allbl:= AllBlocks( g );;
gap> List( allbl, Length );
[ 3, 21, 63, 9, 7 ]
gap> orb:= Orbit( g, First( allbl, x -> Length( x ) = 7 ), OnSets );;
gap> act:= Action( g, orb, OnSets );;
gap> Size( act ) = Size( g );
true
gap> NrMovedPoints( act );
4617

##  doc2/ctblcons.xml (6129-6133)
gap> repeat x:= PseudoRandom( act ); until Order( x ) = 171;
gap> IsConjugate( act, x, x^4 );
true

##  doc2/ctblcons.xml (6144-6148)
gap> lib:= CharacterTable( "9.U3(8).3_3" );;
gap> IsRecord( TransformingPermutationsCharacterTables( tbls[2], lib ) );
true

##  doc2/ctblcons.xml (6190-6202)
gap> tblMG := CharacterTable( "3.A6" );;
gap> tblG  := CharacterTable( "A6" );;
gap> tblGA := CharacterTable( "A6.2_3" );;
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );  
[ [ [ 1 ], [ 2, 3 ], [ 4 ], [ 5, 6 ], [ 7, 8 ], [ 9 ], [ 10, 11 ], 
      [ 12, 15 ], [ 13, 17 ], [ 14, 16 ] ] ]
gap> poss:= PossibleCharacterTablesOfTypeMGA(                  
>                 tblMG, tblG, tblGA, elms[1], "pseudo" );    
[ rec( 
      MGfusMGA := [ 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 9, 10, 8, 10, 
          9 ], table := CharacterTable( "pseudo" ) ) ]

##  doc2/ctblcons.xml (6232-6278)
gap> pseudo:= poss[1].table;
CharacterTable( "pseudo" )
gap> Display( pseudo );
pseudo

      2  4   3  4  3  .  3   2  .   .   .  2  3  3
      3  3   3  1  1  2  1   1  1   1   1  .  .  .
      5  1   1  .  .  .  .   .  1   1   1  .  .  .

        1a  3a 2a 6a 3b 4a 12a 5a 15a 15b 4b 8a 8b
     2P 1a  3a 1a 3a 3b 2a  6a 5a 15a 15b 2a 4a 4a
     3P 1a  1a 2a 2a 1a 4a  4a 5a  5a  5a 4b 8a 8b
     5P 1a  3a 2a 6a 3b 4a 12a 1a  3a  3a 4b 8b 8a

X.1      1   1  1  1  1  1   1  1   1   1  1  1  1
X.2      1   1  1  1  1  1   1  1   1   1 -1 -1 -1
X.3     10  10  2  2  1 -2  -2  .   .   .  .  .  .
X.4     16  16  .  . -2  .   .  1   1   1  .  .  .
X.5      9   9  1  1  .  1   1 -1  -1  -1  1 -1 -1
X.6      9   9  1  1  .  1   1 -1  -1  -1 -1  1  1
X.7     10  10 -2 -2  1  .   .  .   .   .  .  B -B
X.8     10  10 -2 -2  1  .   .  .   .   .  . -B  B
X.9      6  -3 -2  1  .  2  -1  1   A  /A  .  .  .
X.10     6  -3 -2  1  .  2  -1  1  /A   A  .  .  .
X.11    12  -6  4 -2  .  .   .  2  -1  -1  .  .  .
X.12    18  -9  2 -1  .  2  -1 -2   1   1  .  .  .
X.13    30 -15 -2  1  . -2   1  .   .   .  .  .  .

A = -E(15)-E(15)^2-E(15)^4-E(15)^8
  = (-1-Sqrt(-15))/2 = -1-b15
B = E(8)+E(8)^3
  = Sqrt(-2) = i2
gap> IsInternallyConsistent( pseudo );
true
gap> irr:= Irr( pseudo );;
gap> test:= Concatenation( List( [ 2 .. 5 ],
>               n -> Symmetrizations( pseudo, irr, n ) ) );;
gap> Append( test, Set( Tensored( irr, irr ) ) );
gap> fail in Decomposition( irr, test, "nonnegative" );
false
gap> if ForAny( Tuples( [ 1 .. NrConjugacyClasses( pseudo ) ], 3 ),        
>      t -> not ClassMultiplicationCoefficient( pseudo, t[1], t[2], t[3] )   
>               in NonnegativeIntegers ) then                           
>      Error( "contradiction" );
> fi;

##  doc2/ctblcons.xml (6315-6325)
gap> tblMG := CharacterTable( "3.L3(4)" );;
gap> tblG  := CharacterTable( "L3(4)" );;
gap> tblGA := CharacterTable( "L3(4).2_1" );;
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[ [ [ 1 ], [ 2, 3 ], [ 4 ], [ 5, 6 ], [ 7 ], [ 8 ], [ 9, 10 ], 
      [ 11 ], [ 12, 13 ], [ 14 ], [ 15, 16 ], [ 17, 20 ], [ 18, 22 ], 
      [ 19, 21 ], [ 23, 26 ], [ 24, 28 ], [ 25, 27 ] ] ]
gap> PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, elms[1], "?" );
[  ]

##  doc2/ctblcons.xml (6337-6347)
gap> tblG  := CharacterTable( "U4(3)" );;
gap> tblMG := CharacterTable( "3_1.U4(3)" );;
gap> tblGA := CharacterTable( "U4(3).2_2" );;
gap> PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[  ]
gap> tblMG:= CharacterTable( "3_2.U4(3)" );;
gap> tblGA:= CharacterTable( "U4(3).2_3" );;
gap> PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[  ]

##  doc2/ctblcons.xml (6497-6549)
gap> FindExtraordinaryCase:= function( tblMGA )
>    local result, der, nsg, tblMGAclasses, orders, tblMG,
>          tblMGfustblMGA, tblMGclasses, pos, M, Mimg, tblMGAfustblGA, tblGA,
>          outer, inv, filt, other, primes, p;
>    result:= [];
>    der:= ClassPositionsOfDerivedSubgroup( tblMGA );
>    nsg:= ClassPositionsOfNormalSubgroups( tblMGA );
>    tblMGAclasses:= SizesConjugacyClasses( tblMGA );
>    orders:= OrdersClassRepresentatives( tblMGA );
>    if Length( der ) < NrConjugacyClasses( tblMGA ) then
>      # Look for tables of normal subgroups of the form $M.G$.
>      for tblMG in Filtered( List( NamesOfFusionSources( tblMGA ),
>                                   CharacterTable ), x -> x <> fail ) do
>        tblMGfustblMGA:= GetFusionMap( tblMG, tblMGA );
>        tblMGclasses:= SizesConjugacyClasses( tblMG );
>        pos:= Position( nsg, Set( tblMGfustblMGA ) );
>        if pos <> fail and
>           Size( tblMG ) = Sum( tblMGAclasses{ nsg[ pos ] } ) then
>          # Look for normal subgroups of the form $M$.
>          for M in Difference( ClassPositionsOfNormalSubgroups( tblMG ),
>                       [ [ 1 ], [ 1 .. NrConjugacyClasses( tblMG ) ] ] ) do
>            Mimg:= Set( tblMGfustblMGA{ M } );
>            if Sum( tblMGAclasses{ Mimg } ) = Sum( tblMGclasses{ M } ) then
>              tblMGAfustblGA:= First( ComputedClassFusions( tblMGA ),
>                  r -> ClassPositionsOfKernel( r.map ) = Mimg );
>              if tblMGAfustblGA <> fail then
>                tblGA:= CharacterTable( tblMGAfustblGA.name );
>                tblMGAfustblGA:= tblMGAfustblGA.map;
>                outer:= Difference( [ 1 .. NrConjugacyClasses( tblGA ) ],
>                    CompositionMaps( tblMGAfustblGA, tblMGfustblMGA ) );
>                inv:= InverseMap( tblMGAfustblGA ){ outer };
>                filt:= Flat( Filtered( inv, IsList ) );
>                if not IsEmpty( filt ) then
>                  other:= Filtered( inv, IsInt );
>                  primes:= Filtered( PrimeDivisors( Size( tblMGA ) ),
>                     p -> ForAll( orders{ filt }, x -> x mod p = 0 )
>                          and ForAny( orders{ other }, x -> x mod p <> 0 ) );
>                  for p in primes do
>                    Add( result, [ Identifier( tblMG ),
>                                   Identifier( tblMGA ),
>                                   Identifier( tblGA ), p ] );
>                  od;
>                fi;
>              fi;
>            fi;
>          od;
>        fi;
>      od;
>    fi;
>    return result;
> end;;

##  doc2/ctblcons.xml (6557-6594)
gap> cases:= [];;
gap> for name in AllCharacterTableNames( IsDuplicateTable, false ) do
>      Append( cases, FindExtraordinaryCase( CharacterTable( name ) ) );
>    od;
gap> for i in Set( cases ) do
>      Print( i, "\n" ); 
>    od;
[ "2.A6", "2.A6.2_1", "A6.2_1", 3 ]
[ "2.Fi22", "2.Fi22.2", "Fi22.2", 3 ]
[ "2.L2(25)", "2.L2(25).2_2", "L2(25).2_2", 5 ]
[ "2.L2(49)", "2.L2(49).2_2", "L2(49).2_2", 7 ]
[ "2.L2(81)", "2.L2(81).2_1", "L2(81).2_1", 3 ]
[ "2.L2(81)", "2.L2(81).4_1", "L2(81).4_1", 3 ]
[ "2.L2(81).2_1", "2.L2(81).4_1", "L2(81).4_1", 3 ]
[ "2.L4(3)", "2.L4(3).2_2", "L4(3).2_2", 3 ]
[ "2.L4(3)", "2.L4(3).2_3", "L4(3).2_3", 3 ]
[ "2.S3", "2.D12", "S3x2", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{12*2*}", "U4(3).(2^2)_{122}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{122}", "U4(3).(2^2)_{122}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{13*3*}", "U4(3).(2^2)_{133}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{133}", "U4(3).(2^2)_{133}", 3 ]
[ "3.U3(8)", "3.U3(8).3_1", "U3(8).3_1", 2 ]
[ "3.U3(8)", "3.U3(8).6", "U3(8).6", 2 ]
[ "3.U3(8)", "3.U3(8).6", "U3(8).6", 3 ]
[ "3.U3(8).2", "3.U3(8).6", "U3(8).6", 2 ]
[ "3^2:8", "2.A8N3", "s3wrs2", 3 ]
[ "5^(1+2):8:4", "2.HS.2N5", "HS.2N5", 5 ]
[ "6.A6", "6.A6.2_1", "3.A6.2_1", 3 ]
[ "6.A6", "6.A6.2_1", "A6.2_1", 3 ]
[ "6.Fi22", "6.Fi22.2", "3.Fi22.2", 3 ]
[ "6.Fi22", "6.Fi22.2", "Fi22.2", 3 ]
[ "Isoclinic(2.U4(3).2_1)", "2.U4(3).(2^2)_{1*2*2}", 
  "U4(3).(2^2)_{122}", 3 ]
[ "Isoclinic(2.U4(3).2_1)", "2.U4(3).(2^2)_{1*3*3}", 
  "U4(3).(2^2)_{133}", 3 ]
[ "bd10", "2.D20", "D20", 5 ]

##  doc2/ctblcons.xml (6604-6626)
gap> Display( CharacterTable( "2.A6.2_1" ) mod 3 );
2.A6.2_1mod3

     2  5   5  4  3  1   1  4  4  3
     3  2   2  .  .  .   .  1  1  .
     5  1   1  .  .  1   1  .  .  .

       1a  2a 4a 8a 5a 10a 2b 4b 8b
    2P 1a  1a 2a 4a 5a  5a 1a 2a 4a
    3P 1a  2a 4a 8a 5a 10a 2b 4b 8b
    5P 1a  2a 4a 8a 1a  2a 2b 4b 8b

X.1     1   1  1  1  1   1  1  1  1
X.2     1   1  1  1  1   1 -1 -1 -1
X.3     6   6 -2  2  1   1  .  .  .
X.4     4   4  . -2 -1  -1  2 -2  .
X.5     4   4  . -2 -1  -1 -2  2  .
X.6     9   9  1  1 -1  -1  3  3 -1
X.7     9   9  1  1 -1  -1 -3 -3  1
X.8     4  -4  .  . -1   1  .  .  .
X.9    12 -12  .  .  2  -2  .  .  .

##  doc2/ctblcons.xml (6646-6674)
gap> for input in cases do
>      p:= input[4];
>      modtblMG:=  CharacterTable( input[1] ) mod p;
>      ordtblMGA:= CharacterTable( input[2] );
>      modtblGA:=  CharacterTable( input[3] ) mod p;
>      name:= Concatenation( Identifier( ordtblMGA ), " mod ", String(p) );
>      if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
>        poss:= BrauerTableOfTypeMGA( modtblMG, modtblGA, ordtblMGA );
>        modlib:= ordtblMGA mod p;
>        if IsCharacterTable( modlib ) then
>          trans:= TransformingPermutationsCharacterTables( poss.table,
>                      modlib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        else
>          Print( "#I  no library table for ", name, "\n" );
>        fi;
>      else
>        Print( "#I  not all input tables for ", name, " available\n" );
>      fi;
>    od;
#I  not all input tables for 2.L2(49).2_2 mod 7 available
#I  not all input tables for 2.L2(81).2_1 mod 3 available
#I  not all input tables for 2.L2(81).4_1 mod 3 available
#I  not all input tables for 2.L2(81).4_1 mod 3 available

##  doc2/ctblcons.xml (6710-6742)
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> t:= c2 * c2;;
gap> tC:= CharacterTable( "Dihedral", 8 );;
gap> tK:= CharacterTable( "Alternating", 4 );;
gap> tfustC:= PossibleClassFusions( t, tC );
[ [ 1, 3, 4, 4 ], [ 1, 3, 5, 5 ], [ 1, 4, 3, 4 ], [ 1, 4, 4, 3 ], 
  [ 1, 5, 3, 5 ], [ 1, 5, 5, 3 ] ]
gap> StoreFusion( t, tfustC[1], tC );
gap> tfustK:= PossibleClassFusions( t, tK );
[ [ 1, 2, 2, 2 ] ]
gap> StoreFusion( t, tfustK[1], tK );
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );
[ (3,4) ]
gap> new:= CharacterTableOfTypeGS3( t, tC, tK, elms[1], "S4" );
rec( table := CharacterTable( "S4" ), 
  tblCfustblKC := [ 1, 4, 2, 2, 5 ], tblKfustblKC := [ 1, 2, 3, 3 ] )
gap> Display( new.table );
S4

     2  3  3  .  2  2
     3  1  .  1  .  .

       1a 2a 3a 4a 2b
    2P 1a 1a 3a 2a 1a
    3P 1a 2a 1a 4a 2b

X.1     1  1  1  1  1
X.2     1  1  1 -1 -1
X.3     3 -1  .  1 -1
X.4     3 -1  . -1  1
X.5     2  2 -1  .  .

##  doc2/ctblcons.xml (6762-6798)
gap> t:= CharacterTable( "Cyclic", 2 );;
gap> tC:= CharacterTable( "Cyclic", 6 );;
gap> tK:= CharacterTable( "Quaternionic", 8 );;
gap> tfustC:= PossibleClassFusions( t, tC );
[ [ 1, 4 ] ]
gap> StoreFusion( t, tfustC[1], tC );
gap> tfustK:= PossibleClassFusions( t, tK );
[ [ 1, 3 ] ]
gap> StoreFusion( t, tfustK[1], tK );
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );
[ (2,5,4) ]
gap> new:= CharacterTableOfTypeGS3( t, tC, tK, elms[1], "SL(2,3)" );
rec( table := CharacterTable( "SL(2,3)" ), 
  tblCfustblKC := [ 1, 4, 5, 3, 6, 7 ], 
  tblKfustblKC := [ 1, 2, 3, 2, 2 ] )
gap> Display( new.table );
SL(2,3)

     2  3  2  3  1   1   1  1
     3  1  .  1  1   1   1  1

       1a 4a 2a 6a  3a  3b 6b
    2P 1a 2a 1a 3a  3b  3a 3b
    3P 1a 4a 2a 2a  1a  1a 2a

X.1     1  1  1  1   1   1  1
X.2     1  1  1  A  /A   A /A
X.3     1  1  1 /A   A  /A  A
X.4     3 -1  3  .   .   .  .
X.5     2  . -2 /A  -A -/A  A
X.6     2  . -2  1  -1  -1  1
X.7     2  . -2  A -/A  -A /A

A = E(3)
  = (-1+Sqrt(-3))/2 = b3

##  doc2/ctblcons.xml (6819-6844)
gap> listGS3:= [
> [ "U3(5)",      "U3(5).2",      "U3(5).3",      "U3(5).S3"        ],
> [ "3.U3(5)",    "3.U3(5).2",    "3.U3(5).3",    "3.U3(5).S3"      ],
> [ "L3(4)",      "L3(4).2_2",    "L3(4).3",      "L3(4).3.2_2"     ],
> [ "L3(4)",      "L3(4).2_3",    "L3(4).3",      "L3(4).3.2_3"     ],
> [ "3.L3(4)",    "3.L3(4).2_2",  "3.L3(4).3",    "3.L3(4).3.2_2"   ],
> [ "3.L3(4)",    "3.L3(4).2_3",  "3.L3(4).3",    "3.L3(4).3.2_3"   ],
> [ "2^2.L3(4)",  "2^2.L3(4).2_2","2^2.L3(4).3",  "2^2.L3(4).3.2_2" ],
> [ "2^2.L3(4)",  "2^2.L3(4).2_3","2^2.L3(4).3",  "2^2.L3(4).3.2_3" ],
> [ "U6(2)",      "U6(2).2",      "U6(2).3",      "U6(2).3.2"       ],
> [ "3.U6(2)",    "3.U6(2).2",    "3.U6(2).3",    "3.U6(2).3.2"     ],
> [ "2^2.U6(2)",  "2^2.U6(2).2",  "2^2.U6(2).3",  "2^2.U6(2).3.2"   ],
> [ "O8+(2)",     "O8+(2).2",     "O8+(2).3",     "O8+(2).3.2"      ],
> [ "2^2.O8+(2)", "2^2.O8+(2).2", "2^2.O8+(2).3", "2^2.O8+(2).3.2"  ],
> [ "L3(7)",      "L3(7).2",      "L3(7).3",      "L3(7).S3"        ],
> [ "3.L3(7)",    "3.L3(7).2",    "3.L3(7).3",    "3.L3(7).S3"      ],
> [ "U3(8)",      "U3(8).2",      "U3(8).3_2",    "U3(8).S3"        ],
> [ "3.U3(8)",    "3.U3(8).2",    "3.U3(8).3_2",  "3.U3(8).S3"      ],
> [ "U3(11)",     "U3(11).2",     "U3(11).3",     "U3(11).S3"       ],
> [ "3.U3(11)",   "3.U3(11).2",   "3.U3(11).3",   "3.U3(11).S3"     ],
> [ "O8+(3)",     "O8+(3).2_2",   "O8+(3).3",     "O8+(3).S3"       ],
> [ "2E6(2)",     "2E6(2).2",     "2E6(2).3",     "2E6(2).S3"       ],
> [ "2^2.2E6(2)", "2^2.2E6(2).2", "2^2.2E6(2).3", "2^2.2E6(2).S3"   ],
> ];;

##  doc2/ctblcons.xml (6866-6873)
gap> Append( listGS3, [
> [ "L3(4).2_1",          "L3(4).2^2",     "L3(4).6",     "L3(4).D12"     ],
> [ "2^2.L3(4).2_1",      "2^2.L3(4).2^2", "2^2.L3(4).6", "2^2.L3(4).D12" ],
> [ "U3(8).3_1",          "U3(8).6",       "U3(8).3^2",   "U3(8).(S3x3)"  ],
> [ "O8+(3).(2^2)_{111}", "O8+(3).D8",     "O8+(3).A4",   "O8+(3).S4"     ],
> ] );

##  doc2/ctblcons.xml (6898-6947)
gap> ProcessGS3Example:= function( t, tC, tK, identifier, pi )
>    local tF, lib, trans, p, tmodp, tCmodp, tKmodp, modtF;
> 
>    tF:= CharacterTableOfTypeGS3( t, tC, tK, pi,
>             Concatenation( identifier, "new" ) );
>    lib:= CharacterTable( identifier );
>    if lib <> fail then
>      trans:= TransformingPermutationsCharacterTables( tF.table, lib );
>      if not IsRecord( trans ) then
>        Print( "#E  computed table and library table for `", identifier,
>               "' differ\n" );
>      fi;
>    else
>      Print( "#I  no library table for `", identifier, "'\n" );
>    fi;
>    StoreFusion( tC, tF.tblCfustblKC, tF.table );
>    StoreFusion( tK, tF.tblKfustblKC, tF.table );
>    for p in PrimeDivisors( Size( t ) ) do
>      tmodp := t  mod p;
>      tCmodp:= tC mod p;
>      tKmodp:= tK mod p;
>      if IsCharacterTable( tmodp ) and
>         IsCharacterTable( tCmodp ) and
>         IsCharacterTable( tKmodp ) then
>        modtF:= CharacterTableOfTypeGS3( tmodp, tCmodp, tKmodp,
>                    tF.table,
>                    Concatenation(  identifier, "mod", String( p ) ) );
>        if   Length( Irr( modtF.table ) ) <>
>             Length( Irr( modtF.table )[1] ) then
>          Print( "#E  nonsquare result table for `",
>                 identifier, " mod ", p, "'\n" );
>        elif lib <> fail and IsCharacterTable( lib mod p ) then
>          trans:= TransformingPermutationsCharacterTables( modtF.table,
>                                                           lib mod p );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for `",
>                   identifier, " mod ", p, "' differ\n" );
>          fi;
>        else
>          Print( "#I  no library table for `", identifier, " mod ",
>                 p, "'\n" );
>        fi;
>      else
>        Print( "#I  not all inputs available for `", identifier,
>               " mod ", p, "'\n" );
>      fi;
>    od;
> end;;

##  doc2/ctblcons.xml (6955-6989)
gap> for input in listGS3 do
>      t := CharacterTable( input[1] );
>      tC:= CharacterTable( input[2] );
>      tK:= CharacterTable( input[3] );
>      identifier:= input[4];
>      elms:= PossibleActionsForTypeGS3( t, tC, tK );
>      if Length( elms ) = 1 then
>        ProcessGS3Example( t, tC, tK, identifier, elms[1] );
>      else
>        Print( "#I  ", Length( elms ), " actions possible for `",
>               identifier, "'\n" );
>      fi;
>    od;
#I  not all inputs available for `O8+(3).S3 mod 3'
#I  not all inputs available for `2E6(2).S3 mod 2'
#I  not all inputs available for `2E6(2).S3 mod 3'
#I  not all inputs available for `2E6(2).S3 mod 5'
#I  not all inputs available for `2E6(2).S3 mod 7'
#I  not all inputs available for `2E6(2).S3 mod 11'
#I  not all inputs available for `2E6(2).S3 mod 13'
#I  not all inputs available for `2E6(2).S3 mod 17'
#I  not all inputs available for `2E6(2).S3 mod 19'
#I  not all inputs available for `2^2.2E6(2).S3 mod 2'
#I  not all inputs available for `2^2.2E6(2).S3 mod 3'
#I  not all inputs available for `2^2.2E6(2).S3 mod 5'
#I  not all inputs available for `2^2.2E6(2).S3 mod 7'
#I  not all inputs available for `2^2.2E6(2).S3 mod 11'
#I  not all inputs available for `2^2.2E6(2).S3 mod 13'
#I  not all inputs available for `2^2.2E6(2).S3 mod 17'
#I  not all inputs available for `2^2.2E6(2).S3 mod 19'
#I  not all inputs available for `U3(8).(S3x3) mod 2'
#I  not all inputs available for `U3(8).(S3x3) mod 19'
#I  not all inputs available for `O8+(3).S4 mod 3'

##  doc2/ctblcons.xml (7001-7022)
gap> input:= [ "O8+(3)", "O8+(3).3", "O8+(3).(2^2)_{111}", "O8+(3).A4" ];;
gap> t := CharacterTable( input[1] );;
gap> tC:= CharacterTable( input[2] );;
gap> tK:= CharacterTable( input[3] );;
gap> identifier:= input[4];;
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );;
gap> Length( elms );
4
gap> differ:= MovedPoints( Group( List( elms, x -> x / elms[1] ) ) );;
gap> List( elms, x -> RestrictedPerm( x, differ ) );
[ (118,216,169)(119,217,170)(120,218,167)(121,219,168), 
  (118,216,170)(119,217,169)(120,219,168)(121,218,167), 
  (118,217,169)(119,216,170)(120,218,168)(121,219,167), 
  (118,217,170)(119,216,169)(120,219,167)(121,218,168) ]
gap> poss:= List( elms, pi -> CharacterTableOfTypeGS3( t, tC, tK, pi,
>             Concatenation( identifier, "new" ) ) );;
gap> lib:= CharacterTable( identifier );;
gap> ForAll( poss, r -> IsRecord(
>        TransformingPermutationsCharacterTables( r.table, lib ) ) );
true

##  doc2/ctblcons.xml (7031-7034)
gap> ProcessGS3Example( t, tC, tK, identifier, elms[1] );
#I  not all inputs available for `O8+(3).A4 mod 3'

##  doc2/ctblcons.xml (7089-7098)
gap> tblG:= CharacterTable( "A6" );;
gap> tblsG2:= List( [ "A6.2_1", "A6.2_2", "A6.2_3" ], CharacterTable );;
gap> List( tblsG2, NrConjugacyClasses );
[ 11, 11, 8 ]
gap> possact:= List( tblsG2, x -> Filtered( Elements( 
>        AutomorphismsOfTable( x ) ), y -> Order( y ) <= 2 ) );
[ [ (), (3,4)(7,8)(10,11) ], 
  [ (), (8,9), (5,6)(10,11), (5,6)(8,9)(10,11) ], [ (), (7,8) ] ]

##  doc2/ctblcons.xml (7118-7122)
gap> List( tblsG2, x -> GetFusionMap( tblG, x ) );
[ [ 1, 2, 3, 4, 5, 6, 6 ], [ 1, 2, 3, 3, 4, 5, 6 ], 
  [ 1, 2, 3, 3, 4, 5, 5 ] ]

##  doc2/ctblcons.xml (7134-7137)
gap> acts:= PossibleActionsForTypeGV4( tblG, tblsG2 );    
[ [ (3,4)(7,8)(10,11), (5,6)(8,9)(10,11), (7,8) ] ]

##  doc2/ctblcons.xml (7148-7159)
gap> poss:= PossibleCharacterTablesOfTypeGV4( tblG, tblsG2, acts[1],
>               "A6.2^2" );
[ rec( 
      G2fusGV4 := [ [ 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 8 ], 
          [ 1, 2, 3, 4, 5, 5, 9, 10, 10, 11, 11 ], 
          [ 1, 2, 3, 4, 5, 12, 13, 13 ] ], 
      table := CharacterTable( "A6.2^2" ) ) ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTable( "A6.2^2" ) ) );
true

##  doc2/ctblcons.xml (7169-7177)
gap> PossibleCharacterTablesOfTypeGV4( tblG mod 3,
>        List( tblsG2, t -> t mod 3 ), poss[1].table );
[ rec( 
      G2fusGV4 := 
        [ [ 1, 2, 3, 4, 5, 5, 6 ], [ 1, 2, 3, 4, 4, 7, 8, 8, 9, 9 ], 
          [ 1, 2, 3, 4, 10, 11, 11 ] ], 
      table := BrauerTable( "A6.2^2", 3 ) ) ]

##  doc2/ctblcons.xml (7208-7232)
gap> listGV4:= [
> [ "A6",      "A6.2_1",      "A6.2_2",      "A6.2_3",      "A6.2^2"      ],
> [ "3.A6",    "3.A6.2_1",    "3.A6.2_2",    "3.A6.2_3",    "3.A6.2^2"    ],
> [ "L2(25)",  "L2(25).2_1",  "L2(25).2_2",  "L2(25).2_3",  "L2(25).2^2"  ],
> [ "L3(4)",   "L3(4).2_1",   "L3(4).2_2",   "L3(4).2_3",   "L3(4).2^2"   ],
> [ "2^2.L3(4)", "2^2.L3(4).2_1", "2^2.L3(4).2_2", "2^2.L3(4).2_3",
>                                                         "2^2.L3(4).2^2" ],
> [ "3.L3(4)", "3.L3(4).2_1", "3.L3(4).2_2", "3.L3(4).2_3", "3.L3(4).2^2" ],
> [ "U4(3)",   "U4(3).2_1",   "U4(3).2_2",   "U4(3).2_2'",
>                                                     "U4(3).(2^2)_{122}" ],
> [ "U4(3)",   "U4(3).2_1",   "U4(3).2_3",   "U4(3).2_3'",
>                                                     "U4(3).(2^2)_{133}" ],
> [ "3_1.U4(3)", "3_1.U4(3).2_1", "3_1.U4(3).2_2", "3_1.U4(3).2_2'",
>                                                 "3_1.U4(3).(2^2)_{122}" ],
> [ "3_2.U4(3)", "3_2.U4(3).2_1", "3_2.U4(3).2_3", "3_2.U4(3).2_3'",
>                                                 "3_2.U4(3).(2^2)_{133}" ],
> [ "L2(49)",  "L2(49).2_1",  "L2(49).2_2",  "L2(49).2_3",  "L2(49).2^2"  ],
> [ "L2(81)",  "L2(81).2_1",  "L2(81).2_2",  "L2(81).2_3",  "L2(81).2^2"  ],
> [ "L3(9)",   "L3(9).2_1",   "L3(9).2_2",   "L3(9).2_3",   "L3(9).2^2"   ],
> [ "O8+(3)",  "O8+(3).2_1",  "O8+(3).2_2",  "O8+(3).2_2'",
>                                                    "O8+(3).(2^2)_{122}" ],
> [ "O8-(3)",  "O8-(3).2_1",  "O8-(3).2_2",  "O8-(3).2_3",  "O8-(3).2^2"  ],
> ];;

##  doc2/ctblcons.xml (7260-7272)
gap> Append( listGV4, [
> [ "L3(4).3", "L3(4).6",     "L3(4).3.2_2", "L3(4).3.2_3", "L3(4).D12"   ],
> [ "2^2.L3(4).3", "2^2.L3(4).6", "2^2.L3(4).3.2_2", "2^2.L3(4).3.2_3",
>                                                         "2^2.L3(4).D12" ],
> [ "U4(3).2_1", "U4(3).4", "U4(3).(2^2)_{122}", "U4(3).(2^2)_{133}",
>                                                              "U4(3).D8" ],
> [ "O8+(3).2_1", "O8+(3).(2^2)_{111}", "O8+(3).(2^2)_{122}", "O8+(3).4",
>                                                             "O8+(3).D8" ],
> [ "L4(4)",   "L4(4).2_1",   "L4(4).2_2",   "L4(4).2_3",   "L4(4).2^2"   ],
> [ "U4(5)",   "U4(5).2_1",   "U4(5).2_2",   "U4(5).2_3",   "U4(5).2^2"   ],
> ] );

##  doc2/ctblcons.xml (7298-7341)
gap> ConstructOrdinaryGV4Table:= function( tblG, tblsG2, name, lib )
>      local acts, nam, poss, reps, i, trans;
> 
>      # Compute the possible actions for the ordinary tables.
>      acts:= PossibleActionsForTypeGV4( tblG, tblsG2 );
>      # Compute the possible ordinary tables for the given actions.
>      nam:= Concatenation( "new", name );
>      poss:= Concatenation( List( acts, triple -> 
>          PossibleCharacterTablesOfTypeGV4( tblG, tblsG2, triple, nam ) ) );
>      # Test the possibilities for permutation equivalence.
>      reps:= RepresentativesCharacterTables( poss );
>      if 1 < Length( reps ) then
>        Print( "#I  ", name, ": ", Length( reps ),
>               " equivalence classes\n" );
>      elif Length( reps ) = 0 then
>        Print( "#E  ", name, ": no solution\n" );
>      else
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          Print( "#I  no library table for ", name, "\n" );
>          PrintToLib( name, poss[1].table );
>          for i in [ 1 .. 3 ] do
>            Print( LibraryFusion( tblsG2[i],
>                       rec( name:= name, map:= poss[1].G2fusGV4[i] ) ) );
>          od;
>        else
>          trans:= TransformingPermutationsCharacterTables( poss[1].table,
>                      lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusions with the stored ones.
>          if List( poss[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>                 <> List( tblsG2, x -> GetFusionMap( x, lib ) ) then
>            Print( "#E  computed and stored fusions for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return poss;
>    end;;

##  doc2/ctblcons.xml (7366-7454)
gap> ConstructModularGV4Tables:= function( tblG, tblsG2, ordposs,
>                                          ordlibtblGV4 )
>      local name, modposs, primes, checkordinary, i, record, p, tmodp,
>            t2modp, poss, modlib, trans, reps;
> 
>      if not IsCharacterTable( ordlibtblGV4 ) then
>        Print( "#I  no ordinary library table ...\n" );
>        return [];
>      fi;
>      name:= Identifier( ordlibtblGV4 );
>      modposs:= List( ordposs, x -> [] );
>      primes:= ShallowCopy( PrimeDivisors( Size( tblG ) ) );
>      ordposs:= ShallowCopy( ordposs );
>      checkordinary:= false;
>      for i in [ 1 .. Length( ordposs ) ] do
>        record:= ordposs[i];
>        for p in primes do
>          tmodp := tblG  mod p;
>          t2modp:= List( tblsG2, t2 -> t2 mod p );
>          if IsCharacterTable( tmodp ) and
>             ForAll( t2modp, IsCharacterTable ) then
>            poss:= PossibleCharacterTablesOfTypeGV4( tmodp, t2modp,
>                       record.table, record.G2fusGV4 );
>            poss:= RepresentativesCharacterTables( poss );
>            if   Length( poss ) = 0 then
>              Print( "#I  excluded cand. ", i, " (out of ",
>                     Length( ordposs ), ") for ", name, " by ", p,
>                     "-mod. table\n" );
>              Unbind( ordposs[i] );
>              Unbind( modposs[i] );
>              checkordinary:= true;
>              break;
>            elif Length( poss ) = 1 then
>              # Compare the computed table with the library table.
>              modlib:= ordlibtblGV4 mod p;
>              if IsCharacterTable( modlib ) then
>                trans:= TransformingPermutationsCharacterTables(
>                            poss[1].table, modlib );
>                if not IsRecord( trans ) then
>                  Print( "#E  computed table and library table for ",
>                         name, " mod ", p, " differ\n" );
>                fi;
>              else
>                Print( "#I  no library table for ",
>                       name, " mod ", p, "\n" );
>                PrintToLib( name, poss[1].table );
>              fi;
>            else
>              Print( "#I  ", name, " mod ", p, ": ", Length( poss ),
>                     " equivalence classes\n" );
>            fi;
>            Add( modposs[i], poss );
>          elif i = 1 then
>            Print( "#I  not all input tables for ", name, " mod ", p,
>                   " available\n" );
>            primes:= Difference( primes, [ p ] );
>          fi;
>        od;
>      od;
>      if checkordinary then
>        # Test whether the ordinary table is admissible.
>        ordposs:= Compacted( ordposs );
>        modposs:= Compacted( modposs );
>        reps:= RepresentativesCharacterTables( ordposs );
>        if 1 < Length( reps ) then
>          Print( "#I  ", name, ": ", Length( reps ),
>                 " equivalence classes (ord. table)\n" );
>        elif Length( reps ) = 0 then
>          Print( "#E  ", name, ": no solution (ord. table)\n" );
>        else
>          # Compare the computed table with the library table.
>          trans:= TransformingPermutationsCharacterTables(
>                      ordposs[1].table, ordlibtblGV4 );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusions with the stored ones.
>          if List( ordposs[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>               <> List( tblsG2, x -> GetFusionMap( x, ordlibtblGV4 ) ) then
>            Print( "#E  computed and stored fusions for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return rec( ordinary:= ordposs, modular:= modposs );
>    end;;

##  doc2/ctblcons.xml (7462-7497)
gap> for input in listGV4 do
>      tblG   := CharacterTable( input[1] );
>      tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );
>      lib    := CharacterTable( input[5] );
>      poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, input[5], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>    od;
#I  excluded cand. 2 (out of 2) for L3(4).2^2 by 3-mod. table
#I  excluded cand. 2 (out of 8) for 2^2.L3(4).2^2 by 7-mod. table
#I  excluded cand. 3 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 5 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 6 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2^2.L3(4).2^2 by 7-mod. table
#I  excluded cand. 2 (out of 2) for 3.L3(4).2^2 by 3-mod. table
#I  excluded cand. 2 (out of 2) for L3(9).2^2 by 7-mod. table
#I  not all input tables for O8+(3).(2^2)_{122} mod 3 available
#I  not all input tables for O8-(3).2^2 mod 3 available
#I  not all input tables for O8-(3).2^2 mod 5 available
#I  not all input tables for O8-(3).2^2 mod 7 available
#I  not all input tables for O8-(3).2^2 mod 13 available
#I  not all input tables for O8-(3).2^2 mod 41 available
#I  excluded cand. 2 (out of 2) for L3(4).D12 by 3-mod. table
#I  excluded cand. 2 (out of 2) for 2^2.L3(4).D12 by 7-mod. table
#I  not all input tables for O8+(3).D8 mod 3 available
#I  not all input tables for L4(4).2^2 mod 3 available
#I  not all input tables for L4(4).2^2 mod 5 available
#I  not all input tables for L4(4).2^2 mod 7 available
#I  not all input tables for L4(4).2^2 mod 17 available
#I  not all input tables for U4(5).2^2 mod 2 available
#I  not all input tables for U4(5).2^2 mod 3 available
#I  not all input tables for U4(5).2^2 mod 5 available
#I  not all input tables for U4(5).2^2 mod 7 available
#I  not all input tables for U4(5).2^2 mod 13 available

##  doc2/ctblcons.xml (7527-7535)
gap> tblG:= CharacterTable( "S4(9)" );;
gap> tblsG2:= List( [ "S4(9).2_1", "S4(9).2_2", "S4(9).2_3" ],
>                   CharacterTable );;
gap> lib:= CharacterTable( "S4(9).2^2" );;
gap> poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, "newS4(9).2^2", lib );;
#I  newS4(9).2^2: 2 equivalence classes
gap> poss:= RepresentativesCharacterTables( poss );;

##  doc2/ctblcons.xml (7546-7557)
gap> order80:= PositionsProperty( OrdersClassRepresentatives( tblsG2[2] ),
>                  x -> x = 80 );
[ 98, 99, 100, 101, 102, 103, 104, 105 ]
gap> List( poss, r -> r.G2fusGV4[2]{ order80 } );
[ [ 77, 77, 78, 79, 80, 78, 79, 80 ], 
  [ 77, 78, 79, 79, 77, 80, 80, 78 ] ]
gap> PowerMap( tblsG2[2], 3 ){ order80 };
[ 99, 98, 103, 104, 105, 100, 101, 102 ]
gap> PowerMap( tblsG2[2], 13 ){ order80 };
[ 102, 105, 101, 100, 98, 104, 103, 99 ]

##  doc2/ctblcons.xml (7573-7576)
gap> List( tblsG2, x -> 80 in OrdersClassRepresentatives( x ) );
[ false, true, false ]

##  doc2/ctblcons.xml (7586-7590)
gap> tbl:= poss[1].table;;
gap> IsRecord( TransformingPermutationsCharacterTables( tbl, lib ) );
true

##  doc2/ctblcons.xml (7621-7706)
gap> names:= List( [ 1 .. 3 ],
>                  i -> Concatenation( "2.L3(4).2_", String( i ) ) );;
gap> tbls:= List( names, CharacterTable );
[ CharacterTable( "2.L3(4).2_1" ), CharacterTable( "2.L3(4).2_2" ), 
  CharacterTable( "2.L3(4).2_3" ) ]
gap> isos:= List( names, nam -> CharacterTable( Concatenation( nam, "*" ) ) );
[ CharacterTable( "Isoclinic(2.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(2.L3(4).2_2)" ), 
  CharacterTable( "Isoclinic(2.L3(4).2_3)" ) ]
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.L3(4).(2^2)_{123}" ],
> [ tbls[1], isos[2], tbls[3], "2.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "2.L3(4).(2^2)_{123*}" ],
> [ tbls[1], isos[2], isos[3], "2.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], tbls[2], tbls[3], "2.L3(4).(2^2)_{1*23}" ],
> [ isos[1], isos[2], tbls[3], "2.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "2.L3(4).(2^2)_{1*23*}" ],
> [ isos[1], isos[2], isos[3], "2.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "2.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 
5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*2*3*}" ) ]

##  doc2/ctblcons.xml (7720-7737)
gap> List( result, NrConjugacyClasses );
[ 39, 33, 33, 39, 33, 39, 39, 33 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 7, 6 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 8, 5 ]

##  doc2/ctblcons.xml (7758-7768)
gap> l34:= CharacterTable( "L3(4)" );;
gap> u:= CharacterTable( "U6(2)" );;
gap> 2u:= CharacterTable( "2.U6(2)" );;
gap> cand:= PossibleClassFusions( l34, 2u );
[ [ 1, 5, 12, 16, 22, 22, 23, 23, 41, 41 ], 
  [ 1, 5, 12, 22, 16, 22, 23, 23, 41, 41 ], 
  [ 1, 5, 12, 22, 22, 16, 23, 23, 41, 41 ] ]
gap> OrdersClassRepresentatives( l34 );
[ 1, 2, 3, 4, 4, 4, 5, 5, 7, 7 ]

##  doc2/ctblcons.xml (7784-7793)
gap> GetFusionMap( 2u, u ){ [ 16, 22 ] };
[ 10, 14 ]
gap> ClassNames( u, "ATLAS" ){ [ 10, 14 ] };
[ "4C", "4G" ]
gap> GetFusionMap( u, CharacterTable( "U6(2).3" ) );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 12, 13, 14, 15, 16, 17, 
  18, 19, 20, 21, 22, 23, 24, 24, 24, 25, 26, 27, 28, 29, 30, 31, 32, 
  33, 34, 35, 36, 36, 36, 37, 38, 39, 40 ]

##  doc2/ctblcons.xml (7808-7813)
gap> 2u2:= CharacterTable( "2.U6(2).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2u2 ) );;
gap> List( fus, Length );
[ 4, 0, 0, 0, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (7822-7827)
gap> 2u2iso:= CharacterTableIsoclinic( 2u2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2u2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 4, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (7840-7845)
gap> h2:= CharacterTable( "HS.2" );;
gap> 2h2:= CharacterTable( "2.HS.2" );;
gap> PossibleClassFusions( l34, 2h2 );
[  ]

##  doc2/ctblcons.xml (7859-7867)
gap> fus:= List( result, x -> PossibleClassFusions( x, 2h2 ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 4, 0, 0, 0 ]
gap> 2h2iso:= CharacterTableIsoclinic( 2h2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2h2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 0, 0, 0, 4 ]

##  doc2/ctblcons.xml (7909-7994)
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "6.L3(4).2_", i ) ) );
[ CharacterTable( "6.L3(4).2_1" ), CharacterTable( "6.L3(4).2_2" ), 
  CharacterTable( "6.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "6.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(6.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(6.L3(4).2_2)" ), 
  CharacterTable( "Isoclinic(6.L3(4).2_3)" ) ]
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "6.L3(4).(2^2)_{123}" ],
> [ tbls[1], isos[2], tbls[3], "6.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "6.L3(4).(2^2)_{123*}" ],
> [ tbls[1], isos[2], isos[3], "6.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], tbls[2], tbls[3], "6.L3(4).(2^2)_{1*23}" ],
> [ isos[1], isos[2], tbls[3], "6.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "6.L3(4).(2^2)_{1*23*}" ],
> [ isos[1], isos[2], isos[3], "6.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "6.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 
5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new6.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3*}" ) ]

##  doc2/ctblcons.xml (8004-8021)
gap> List( result, NrConjugacyClasses );
[ 59, 53, 53, 59, 53, 59, 59, 53 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 6, 4 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 8, 5, 3 ]

##  doc2/ctblcons.xml (8044-8049)
gap> 2l34:= CharacterTable( "2.L3(4)" );;
gap> 6u:= CharacterTable( "6.U6(2)" );;
gap> cand:= PossibleClassFusions( 2l34, 6u );
[  ]

##  doc2/ctblcons.xml (8058-8067)
gap> 6u2:= CharacterTable( "6.U6(2).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 6u2 ) );;
gap> List( fus, Length );
[ 8, 0, 0, 0, 0, 0, 0, 0 ]
gap> 6u2iso:= CharacterTableIsoclinic( 6u2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 6u2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 8, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (8081-8087)
gap> 3l34:= CharacterTable( "3.L3(4)" );;
gap> g2:= CharacterTable( "G2(4).2" );;
gap> 2g2:= CharacterTable( "2.G2(4).2" );;
gap> PossibleClassFusions( 3l34, 2g2 );
[  ]

##  doc2/ctblcons.xml (8097-8105)
gap> fus:= List( result, x -> PossibleClassFusions( x, 2g2 ) );;
gap> List( fus, Length );
[ 0, 0, 16, 0, 0, 0, 0, 0 ]
gap> 2g2iso:= CharacterTableIsoclinic( 2g2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2g2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 0, 0, 0, 16 ]

##  doc2/ctblcons.xml (8113-8162)
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{12*3}",
>              "L3(4).(2^2)_{123*}", "L3(4).(2^2)_{12*3*}" ];;
gap> inputs1:= List( names, nam -> [ "6.L3(4).2_1", "2.L3(4).2_1",
>        Concatenation( "2.", nam ), Concatenation( "6.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "1", "1*" ) );;
gap> inputs2:= List( names, nam -> [ "6.L3(4).2_1*", "2.L3(4).2_1*",
>        Concatenation( "2.", nam ), Concatenation( "6.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123}", 
      "6.L3(4).(2^2)_{123}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{12*3}", 
      "6.L3(4).(2^2)_{12*3}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123*}", 
      "6.L3(4).(2^2)_{123*}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{12*3*}", 
      "6.L3(4).(2^2)_{12*3*}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*23}", 
      "6.L3(4).(2^2)_{1*23}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*2*3}", 
      "6.L3(4).(2^2)_{1*2*3}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*23*}", 
      "6.L3(4).(2^2)_{1*23*}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*2*3*}", 
      "6.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new6.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3*}" ) ]
gap> trans:= List( [ 1 .. 8 ], i ->
>        TransformingPermutationsCharacterTables( result[i],
>            result2[i] ) );;
gap> ForAll( trans, IsRecord );
true

##  doc2/ctblcons.xml (8202-8230)
gap> tbls:= List( [ "1", "2", "2'" ], i ->
>      CharacterTable( Concatenation( "2.U4(3).2_", i ) ) );;
gap> isos:= List( [ "1", "2", "2'" ], i ->
>      CharacterTable( Concatenation( "Isoclinic(2.U4(3).2_", i, ")" ) ) );;
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{122}" ],
> [ isos[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{1*22}" ],
> [ tbls[1], isos[2], tbls[3], "2.U4(3).(2^2)_{12*2}" ],
> [ isos[1], isos[2], tbls[3], "2.U4(3).(2^2)_{1*2*2}" ],
> [ tbls[1], isos[2], isos[3], "2.U4(3).(2^2)_{12*2*}" ],
> [ isos[1], isos[2], isos[3], "2.U4(3).(2^2)_{1*2*2*}" ] ];;
gap> tblG:= CharacterTable( "2.U4(3)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.U4(3).(2^2)_{122}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*22}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{12*2}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*2*2}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{12*2*}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*2*2*}" ) ]

##  doc2/ctblcons.xml (8244-8261)
gap> List( result, NrConjugacyClasses );
[ 87, 102, 102, 87, 87, 102 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 4, 5 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 3, 6 ]

##  doc2/ctblcons.xml (8279-8284)
gap> u:= CharacterTable( "O8+(3)" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, u ) );;
gap> List( fus, Length );
[ 24, 0, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (8293-8298)
gap> u:= CharacterTable( "O7(3).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, u ) );;
gap> List( fus, Length );
[ 0, 16, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (8347-8403)
gap> tbls:= List( [ "1", "3", "3'" ],
>      i -> CharacterTable( Concatenation( "2.U4(3).2_", i ) ) );;
gap> isos:= List( [ "1", "3", "3'" ], i ->
>      CharacterTable( Concatenation( "Isoclinic(2.U4(3).2_", i, ")" ) ) );;
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{133}" ],
> [ isos[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{1*33}" ],
> [ tbls[1], isos[2], tbls[3], "2.U4(3).(2^2)_{13*3}" ],
> [ isos[1], isos[2], tbls[3], "2.U4(3).(2^2)_{1*3*3}" ],
> [ tbls[1], isos[2], isos[3], "2.U4(3).(2^2)_{13*3*}" ],
> [ isos[1], isos[2], isos[3], "2.U4(3).(2^2)_{1*3*3*}" ] ];;
gap> tblG:= CharacterTable( "2.U4(3)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{1*33} by 
3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{1*33} by 
3-mod. table
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{13*3} by 
3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{13*3} by 
3-mod. table
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{1*3*3*} by 
3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{1*3*3*} by 
3-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.U4(3).(2^2)_{133}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*33}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{13*3}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*3*3}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{13*3*}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*3*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 69, 72, 72, 69, 69, 72 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 4, 5 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 3, 6 ]

##  doc2/ctblcons.xml (8436-8446)
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_1.L3(4).2_", i ) ) );
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" )
    , CharacterTable( "4_1.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_1.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(4_1.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(4_1.L3(4).2_2)" ), 
  CharacterTable( "4_1.L3(4).2_3*" ) ]

##  doc2/ctblcons.xml (8457-8463)
gap> List( tbls, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ], [ 1, 2, 3, 4 ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( tbls[3],
>        CharacterTableIsoclinic( tbls[3] ) ) );
true

##  doc2/ctblcons.xml (8472-8564)
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "4_1.L3(4).(2^2)_{123}" ],
> [ isos[1], tbls[2], tbls[3], "4_1.L3(4).(2^2)_{1*23}" ],
> [ tbls[1], isos[2], tbls[3], "4_1.L3(4).(2^2)_{12*3}" ],
> [ isos[1], isos[2], tbls[3], "4_1.L3(4).(2^2)_{1*2*3}" ],
> [ tbls[1], tbls[2], isos[3], "4_1.L3(4).(2^2)_{123*}" ],
> [ isos[1], tbls[2], isos[3], "4_1.L3(4).(2^2)_{1*23*}" ],
> [ tbls[1], isos[2], isos[3], "4_1.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], isos[2], isos[3], "4_1.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "4_1.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 
5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 48, 48, 48, 48, 42, 42, 42, 42 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 2, 4 ]
gap> t:= result[5];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 6, 8 ]

##  doc2/ctblcons.xml (8573-8580)
gap> facts:= [ CharacterTable( "2.L3(4).(2^2)_{123}" ), 
>              CharacterTable( "2.L3(4).(2^2)_{123*}" ) ];;
gap> factresults:= List( result, t -> t / ClassPositionsOfCentre( t ) );;
gap> List( factresults, t -> PositionProperty( facts, f ->
>            IsRecord( TransformingPermutationsCharacterTables( t, f ) ) ) );
[ 1, 1, 1, 1, 2, 2, 2, 2 ]

##  doc2/ctblcons.xml (8592-8607)
gap> test:= [ CharacterTable( "4_1.L3(4).2_1" ),
>             CharacterTable( "4_1.L3(4).2_1*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> test:= [ CharacterTable( "4_1.L3(4).2_2" ),
>             CharacterTable( "4_1.L3(4).2_2*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true

##  doc2/ctblcons.xml (8617-8674)
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{1*23}",
>              "L3(4).(2^2)_{12*3}", "L3(4).(2^2)_{1*2*3}" ];;
gap> inputs1:= List( names, nam -> [ "4_1.L3(4).2_3", "2.L3(4).2_3",
>      Concatenation( "2.", nam ), Concatenation( "4_1.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "3}", "3*}" ) );;
gap> inputs2:= List( names, nam -> [ "4_1.L3(4).2_3*", "2.L3(4).2_3*",
>      Concatenation( "2.", nam ), Concatenation( "4_1.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{123}", 
      "4_1.L3(4).(2^2)_{123}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{1*23}", 
      "4_1.L3(4).(2^2)_{1*23}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{12*3}", 
      "4_1.L3(4).(2^2)_{12*3}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{1*2*3}", 
      "4_1.L3(4).(2^2)_{1*2*3}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{123*}", 
      "4_1.L3(4).(2^2)_{123*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{1*23*}", 
      "4_1.L3(4).(2^2)_{1*23*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{12*3*}", 
      "4_1.L3(4).(2^2)_{12*3*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{1*2*3*}", 
      "4_1.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
#E  4 possibilities for new4_1.L3(4).(2^2)_{123}
#E  no solution for new4_1.L3(4).(2^2)_{1*23}
#E  no solution for new4_1.L3(4).(2^2)_{12*3}
#E  no solution for new4_1.L3(4).(2^2)_{1*2*3}
#E  4 possibilities for new4_1.L3(4).(2^2)_{123*}
#E  no solution for new4_1.L3(4).(2^2)_{1*23*}
#E  no solution for new4_1.L3(4).(2^2)_{12*3*}
#E  no solution for new4_1.L3(4).(2^2)_{1*2*3*}
gap> Length( result2 );
8
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ) ]
gap> List( result, t1 -> PositionsProperty( result2, t2 -> IsRecord(
>      TransformingPermutationsCharacterTables( t1, t2 ) ) ) );
[ [ 1 ], [ 4 ], [ 3 ], [ 2 ], [ 7 ], [ 6 ], [ 5 ], [ 8 ] ]

##  doc2/ctblcons.xml (8693-8703)
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_2.L3(4).2_", i ) ) );
[ CharacterTable( "4_2.L3(4).2_1" ), CharacterTable( "4_2.L3(4).2_2" )
    , CharacterTable( "4_2.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ], 
>      i -> CharacterTable( Concatenation( "4_2.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(4_2.L3(4).2_1)" ), 
  CharacterTable( "4_2.L3(4).2_2*" ), 
  CharacterTable( "Isoclinic(4_2.L3(4).2_3)" ) ]

##  doc2/ctblcons.xml (8714-8720)
gap> List( tbls, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 2, 3, 4 ], [ 1, 3 ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( tbls[2],
>        CharacterTableIsoclinic( tbls[2] ) ) );
true

##  doc2/ctblcons.xml (8729-8821)
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "4_2.L3(4).(2^2)_{123}" ],
> [ isos[1], tbls[2], tbls[3], "4_2.L3(4).(2^2)_{1*23}" ],
> [ tbls[1], isos[2], tbls[3], "4_2.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "4_2.L3(4).(2^2)_{123*}" ],
> [ isos[1], isos[2], tbls[3], "4_2.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "4_2.L3(4).(2^2)_{1*23*}" ],
> [ tbls[1], isos[2], isos[3], "4_2.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], isos[2], isos[3], "4_2.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "4_2.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{123} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 
5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 
5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 50, 50, 44, 50, 44, 50, 44, 44 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 2, 6 ]
gap> t:= result[3];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 5, 8 ]

##  doc2/ctblcons.xml (8830-8837)
gap> facts:= [ CharacterTable( "2.L3(4).(2^2)_{123}" ),
>              CharacterTable( "2.L3(4).(2^2)_{12*3}" ) ];;
gap> factresults:= List( result, t -> t / ClassPositionsOfCentre( t ) );;
gap> List( factresults, t -> PositionProperty( facts, f ->
>            IsRecord( TransformingPermutationsCharacterTables( t, f ) ) ) );
[ 1, 1, 2, 1, 2, 1, 2, 2 ]

##  doc2/ctblcons.xml (8849-8864)
gap> test:= [ CharacterTable( "4_2.L3(4).2_1" ),
>             CharacterTable( "4_2.L3(4).2_1*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> test:= [ CharacterTable( "4_2.L3(4).2_3" ),
>             CharacterTable( "4_2.L3(4).2_3*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true

##  doc2/ctblcons.xml (8874-8931)
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{1*23}",
>              "L3(4).(2^2)_{123*}", "L3(4).(2^2)_{1*23*}" ];;
gap> inputs1:= List( names, nam -> [ "4_2.L3(4).2_2", "2.L3(4).2_2",
>      Concatenation( "2.", nam ), Concatenation( "4_2.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "23", "2*3" ) );;
gap> inputs2:= List( names, nam -> [ "4_2.L3(4).2_2*", "2.L3(4).2_2*",
>      Concatenation( "2.", nam ), Concatenation( "4_2.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{123}", 
      "4_2.L3(4).(2^2)_{123}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{1*23}", 
      "4_2.L3(4).(2^2)_{1*23}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{123*}", 
      "4_2.L3(4).(2^2)_{123*}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{1*23*}", 
      "4_2.L3(4).(2^2)_{1*23*}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{12*3}", 
      "4_2.L3(4).(2^2)_{12*3}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{1*2*3}", 
      "4_2.L3(4).(2^2)_{1*2*3}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{12*3*}", 
      "4_2.L3(4).(2^2)_{12*3*}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{1*2*3*}", 
      "4_2.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
#E  4 possibilities for new4_2.L3(4).(2^2)_{123}
#E  no solution for new4_2.L3(4).(2^2)_{1*23}
#E  no solution for new4_2.L3(4).(2^2)_{123*}
#E  no solution for new4_2.L3(4).(2^2)_{1*23*}
#E  4 possibilities for new4_2.L3(4).(2^2)_{12*3}
#E  no solution for new4_2.L3(4).(2^2)_{1*2*3}
#E  no solution for new4_2.L3(4).(2^2)_{12*3*}
#E  no solution for new4_2.L3(4).(2^2)_{1*2*3*}
gap> Length( result2 );
8
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ) ]
gap> List( result, t1 -> PositionsProperty( result2, t2 -> IsRecord(
>      TransformingPermutationsCharacterTables( t1, t2 ) ) ) );
[ [ 1 ], [ 4 ], [ 7 ], [ 3 ], [ 6 ], [ 2 ], [ 5 ], [ 8 ] ]

##  doc2/ctblcons.xml (8942-8947)
gap> on2:= CharacterTable( "ON.2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, on2 ) );;
gap> List( fus, Length );
[ 0, 0, 16, 0, 0, 0, 0, 0 ]

##  doc2/ctblcons.xml (8986-8998)
gap> input:= [ "L2(81).2_1", "L2(81).4_1", "L2(81).4_2", "L2(81).2^2",
>                                                        "L2(81).(2x4)" ];;
gap> tblG   := CharacterTable( input[1] );;
gap> tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );;
gap> name   := Concatenation( "new", input[5] );;
gap> lib    := CharacterTable( input[5] );;
gap> poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, name, lib );;
#I  newL2(81).(2x4): 2 equivalence classes
gap> reps:= RepresentativesCharacterTables( poss );;
gap> Length( reps );
2

##  doc2/ctblcons.xml (9007-9017)
gap> ord:= OrdersClassRepresentatives( reps[1].table );;
gap> ord = OrdersClassRepresentatives( reps[2].table ); 
true
gap> pos:= Position( ord, 80 );
33
gap> PowerMap( reps[1].table, 3 )[ pos ];
34
gap> PowerMap( reps[2].table, 3 )[ pos ];
33

##  doc2/ctblcons.xml (9033-9042)
gap> trans:= TransformingPermutationsCharacterTables( reps[2].table, lib );;
gap> IsRecord( trans );
true
gap> List( reps[2].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>  = List( tblsG2, x -> GetFusionMap( x, lib ) );
true
gap> ConstructModularGV4Tables( tblG, tblsG2, [ reps[2] ], lib );;
#I  not all input tables for L2(81).(2x4) mod 41 available

##  doc2/ctblcons.xml (9070-9084)
gap> input:= [ "O8+(3)", "O8+(3).2_1",  "O8+(3).2_1'", "O8+(3).2_1''",
>                                                  "O8+(3).(2^2)_{111}" ];;
gap> tblG   := CharacterTable( input[1] );;
gap> tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );;
gap> name   := Concatenation( "new", input[5] );;
gap> lib    := CharacterTable( input[5] );;
gap> poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, name, lib );;
#I  newO8+(3).(2^2)_{111}: 2 equivalence classes
gap> Length( poss );
64
gap> reps:= RepresentativesCharacterTables( poss );;
gap> Length( reps );
2

##  doc2/ctblcons.xml (9104-9120)
gap> t:= reps[1].table;;
gap> ord7:= Filtered( [ 1 .. NrConjugacyClasses( t ) ],                        
>               i -> OrdersClassRepresentatives( t )[i] = 7 );
[ 37 ]
gap> SizesCentralizers( t ){ ord7 };
[ 112 ]
gap> ord28:= Filtered( [ 1 .. NrConjugacyClasses( t ) ],
>               i -> OrdersClassRepresentatives( t )[i] = 28 );
[ 112, 113, 114, 115, 161, 162, 163, 164, 210, 211, 212, 213 ]
gap> List( reps[1].G2fusGV4, x -> Intersection( ord28, x ) );
[ [ 112, 113, 114, 115 ], [ 161, 162, 163, 164 ], 
  [ 210, 211, 212, 213 ] ]
gap> sub:= CharacterTable( "Cyclic", 28 ) * CharacterTable( "Cyclic", 4 );;
gap> List( reps, x -> Length( PossibleClassFusions( sub, x.table ) ) );
[ 0, 96 ]

##  doc2/ctblcons.xml (9132-9139)
gap> trans:= TransformingPermutationsCharacterTables( reps[2].table, lib );;
gap> IsRecord( trans );
true
gap> List( reps[2].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>  = List( tblsG2, x -> GetFusionMap( x, lib ) );
true

##  doc2/ctblcons.xml (9159-9165)
gap> poss:= Filtered( poss,
>      r -> TransformingPermutationsCharacterTables( r.table, lib )
>           <> fail );;
gap> ConstructModularGV4Tables( tblG, tblsG2, poss, lib );;
#I  not all input tables for O8+(3).(2^2)_{111} mod 3 available

##  doc2/ctblcons.xml (9210-9225)
gap> t:= CharacterTable( "Sz(8)" );;
gap> 2t:= CharacterTable( "2.Sz(8)" );;
gap> aut:= AutomorphismsOfTable( t );;
gap> elms:= Set( Filtered( aut, x -> Order( x ) in [ 1, 3 ] ),           
>                SmallestGeneratorPerm );
[ (), (9,10,11), (6,7,8), (6,7,8)(9,10,11), (6,7,8)(9,11,10) ]
gap> poss:= List( elms,                                         
>       pi -> PossibleCharacterTablesOfTypeV4G( t, 2t, pi, "2^2.Sz(8)" ) );
[ [ CharacterTable( "2^2.Sz(8)" ) ], [ CharacterTable( "2^2.Sz(8)" ) ]
    , [ CharacterTable( "2^2.Sz(8)" ) ], 
  [ CharacterTable( "2^2.Sz(8)" ) ], 
  [ CharacterTable( "2^2.Sz(8)" ) ] ]
gap> reps:= RepresentativesCharacterTables( Concatenation( poss ) );
[ CharacterTable( "2^2.Sz(8)" ) ]

##  doc2/ctblcons.xml (9233-9237)
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1],
>        CharacterTable( "2^2.Sz(8)" ) ) );
true

##  doc2/ctblcons.xml (9251-9261)
gap> GetFusionMap( poss[1][1], 2t, "1" );
[ 1, 1, 2, 2, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 
  12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19 ]
gap> GetFusionMap( poss[1][1], 2t, "2" );
[ 1, 2, 1, 2, 3, 4, 5, 6, 7, 6, 7, 8, 9, 8, 9, 10, 11, 10, 11, 12, 
  13, 12, 13, 14, 15, 14, 15, 16, 17, 16, 17, 18, 19, 18, 19 ]
gap> GetFusionMap( poss[1][1], 2t, "3" );
[ 1, 2, 2, 1, 3, 4, 5, 6, 7, 7, 6, 8, 9, 9, 8, 10, 11, 11, 10, 12, 
  13, 13, 12, 14, 15, 15, 14, 16, 17, 17, 16, 18, 19, 19, 18 ]

##  doc2/ctblcons.xml (9275-9278)
gap> PrimeDivisors( Size( t ) );
[ 2, 5, 7, 13 ]

##  doc2/ctblcons.xml (9298-9313)
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 5,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 5 ), BrauerTable( "2^2.Sz(8)", 5 ), 
  BrauerTable( "2^2.Sz(8)", 5 ), BrauerTable( "2^2.Sz(8)", 5 ), 
  BrauerTable( "2^2.Sz(8)", 5 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
2
gap> List( cand, CTblLib.Test.TensorDecomposition );
[ false, true, false, true, true ]
gap> Length( RepresentativesCharacterTables( cand{ [ 2, 4, 5 ] } ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[2],
>        CharacterTable( "2^2.Sz(8)" ) mod 5 ) );
true

##  doc2/ctblcons.xml (9327-9338)
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 7,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 7 ), BrauerTable( "2^2.Sz(8)", 7 ), 
  BrauerTable( "2^2.Sz(8)", 7 ), BrauerTable( "2^2.Sz(8)", 7 ), 
  BrauerTable( "2^2.Sz(8)", 7 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[1],      
>        CharacterTable( "2^2.Sz(8)" ) mod 7 ) );
true

##  doc2/ctblcons.xml (9347-9359)
gap> elms:= elms{ [ 2, 4, 5 ] };
[ (9,10,11), (6,7,8)(9,10,11), (6,7,8)(9,11,10) ]
gap> poss:= poss{ [ 2, 4, 5 ] };;                                     
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 13,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 13 ), BrauerTable( "2^2.Sz(8)", 13 ), 
  BrauerTable( "2^2.Sz(8)", 13 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
2
gap> List( cand, CTblLib.Test.TensorDecomposition );                      
[ true, true, true ]

##  doc2/ctblcons.xml (9375-9382)
gap> mod2:= CharacterTable( "Sz(8)" ) mod 2;
BrauerTable( "Sz(8)", 2 )
gap> AutomorphismsOfTable( mod2 );
Group([ (3,4,5)(6,7,8) ])
gap> OrdersClassRepresentatives( mod2 );
[ 1, 5, 7, 7, 7, 13, 13, 13 ]

##  doc2/ctblcons.xml (9391-9397)
gap> Length( RepresentativesCharacterTables( cand{ [ 2, 3 ] } ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[2],
>        CharacterTable( "2^2.Sz(8)" ) mod 13 ) );
true

##  doc2/ctblcons.xml (9458-9470)
gap> listV4G:= [
>      [ "2^2.L3(4)",         "2.L3(4)",     "L3(4)"       ],
>      [ "2^2.L3(4).2_1",     "2.L3(4).2_1", "L3(4).2_1"   ],
>      [ "(2^2x3).L3(4)",     "6.L3(4)",     "3.L3(4)"     ],
>      [ "(2^2x3).L3(4).2_1", "6.L3(4).2_1", "3.L3(4).2_1" ],
>      [ "2^2.O8+(2)",        "2.O8+(2)",    "O8+(2)"      ],
>      [ "2^2.U6(2)",         "2.U6(2)",     "U6(2)"       ],
>      [ "(2^2x3).U6(2)",     "6.U6(2)",     "3.U6(2)"     ],
>      [ "2^2.2E6(2)",        "2.2E6(2)",    "2E6(2)"      ],
>      [ "(2^2x3).2E6(2)",    "6.2E6(2)",    "3.2E6(2)"    ],
> ];;

##  doc2/ctblcons.xml (9489-9527)
gap> ConstructOrdinaryV4GTable:= function( tblG, tbl2G, name, lib )
>      local ord3, nam, poss, reps, trans;
> 
>      # Compute the possible actions for the ordinary tables.
>      ord3:= Set( Filtered( AutomorphismsOfTable( tblG ),
>                            x -> Order( x ) = 3 ),
>                  SmallestGeneratorPerm );
>      if 1 < Length( ord3 ) then
>        Print( "#I  ", name,
>               ": the action of the automorphism is not unique" );
>      fi;
>      # Compute the possible ordinary tables for the given actions.
>      nam:= Concatenation( "new", name );
>      poss:= Concatenation( List( ord3, pi ->
>             PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, nam ) ) );
>      # Test the possibilities for permutation equivalence.
>      reps:= RepresentativesCharacterTables( poss );
>      if 1 < Length( reps ) then
>        Print( "#I  ", name, ": ", Length( reps ),
>               " equivalence classes\n" );
>      elif Length( reps ) = 0 then
>        Print( "#E  ", name, ": no solution\n" );
>      else
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          Print( "#I  no library table for ", name, "\n" );
>          PrintToLib( name, poss[1].table );
>        else
>          trans:= TransformingPermutationsCharacterTables( reps[1], lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return poss;
>    end;;

##  doc2/ctblcons.xml (9542-9631)
gap> ConstructModularV4GTables:= function( tblG, tbl2G, ordposs,
>                                          ordlibtblV4G )
>      local name, modposs, primes, checkordinary, i, p, tmodp, 2tmodp, aut,
>            poss, modlib, trans, reps;
> 
>      if not IsCharacterTable( ordlibtblV4G ) then
>        Print( "#I  no ordinary library table ...\n" );
>        return [];
>      fi;
>      name:= Identifier( ordlibtblV4G );
>      modposs:= [];
>      primes:= ShallowCopy( PrimeDivisors( Size( tblG ) ) );
>      ordposs:= ShallowCopy( ordposs );
>      checkordinary:= false;
>      for i in [ 1 .. Length( ordposs ) ] do
>        modposs[i]:= [];
>        for p in primes do
>          tmodp := tblG  mod p;
>          2tmodp:= tbl2G mod p;
>          if IsCharacterTable( tmodp ) and IsCharacterTable( 2tmodp ) then
>            aut:= ConstructionInfoCharacterTable( ordposs[i] )[3];
>            poss:= BrauerTableOfTypeV4G( ordposs[i], 2tmodp, aut );
>            if CTblLib.Test.TensorDecomposition( poss, false ) = false then
>              Print( "#I  excluded cand. ", i, " (out of ",
>                     Length( ordposs ), ") for ", name, " by ", p,
>                     "-mod. table\n" );
>              Unbind( ordposs[i] );
>              Unbind( modposs[i] );
>              checkordinary:= true;
>              break;
>            fi;
>            Add( modposs[i], poss );
>          else
>            Print( "#I  not all input tables for ", name, " mod ", p,
>                   " available\n" );
>            primes:= Difference( primes, [ p ] );
>          fi;
>        od;
>        if IsBound( modposs[i] ) then
>          # Compare the computed Brauer tables with the library tables.
>          for poss in modposs[i] do
>            p:= UnderlyingCharacteristic( poss );
>            modlib:= ordlibtblV4G mod p;
>            if IsCharacterTable( modlib ) then
>              trans:= TransformingPermutationsCharacterTables(
>                          poss, modlib );
>              if not IsRecord( trans ) then
>                Print( "#E  computed table and library table for ",
>                       name, " mod ", p, " differ\n" );
>              fi;
>            else
>              Print( "#I  no library table for ",
>                     name, " mod ", p, "\n" );
>              PrintToLib( name, poss );
>            fi;
>          od;
>        fi;
>      od;
>      if checkordinary then
>        # Test whether the ordinary table is admissible.
>        ordposs:= Compacted( ordposs );
>        modposs:= Compacted( modposs );
>        reps:= RepresentativesCharacterTables( ordposs );
>        if 1 < Length( reps ) then
>          Print( "#I  ", name, ": ", Length( reps ),
>                 " equivalence classes (ord. table)\n" );
>        elif Length( reps ) = 0 then
>          Print( "#E  ", name, ": no solution (ord. table)\n" );
>        else
>          # Compare the computed table with the library table.
>          trans:= TransformingPermutationsCharacterTables( reps[1],
>                      ordlibtblV4G );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      # Test the uniqueness of the Brauer tables.
>      for poss in TransposedMat( modposs ) do
>        reps:= RepresentativesCharacterTables( poss );
>        if Length( reps ) <> 1 then
>          Print( "#I  ", name, ": ", Length( reps ), " candidates for the ",
>                 UnderlyingCharacteristic( reps[1] ), "-modular table\n" );
>        fi;
>      od;
>      return rec( ordinary:= ordposs, modular:= modposs );
>    end;;

##  doc2/ctblcons.xml (9642-9677)
gap> for input in listV4G do
>      tblG  := CharacterTable( input[3] );
>      tbl2G := CharacterTable( input[2] );
>      lib   := CharacterTable( input[1] );
>      poss  := ConstructOrdinaryV4GTable( tblG, tbl2G, input[1], lib );
>      ConstructModularV4GTables( tblG, tbl2G, poss, lib );
>    od;
#I  excluded cand. 1 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 2 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 7 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 10 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 15 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 16 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 1 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 2 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 7 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 10 (out of 16) for (2^2x3).L3(4).2_1 by 
7-mod. table
#I  excluded cand. 15 (out of 16) for (2^2x3).L3(4).2_1 by 
7-mod. table
#I  excluded cand. 16 (out of 16) for (2^2x3).L3(4).2_1 by 
7-mod. table
#I  not all input tables for 2^2.2E6(2) mod 2 available
#I  not all input tables for 2^2.2E6(2) mod 3 available
#I  not all input tables for 2^2.2E6(2) mod 5 available
#I  not all input tables for 2^2.2E6(2) mod 7 available
#I  not all input tables for (2^2x3).2E6(2) mod 2 available
#I  not all input tables for (2^2x3).2E6(2) mod 3 available
#I  not all input tables for (2^2x3).2E6(2) mod 5 available
#I  not all input tables for (2^2x3).2E6(2) mod 7 available
#I  not all input tables for (2^2x3).2E6(2) mod 11 available
#I  not all input tables for (2^2x3).2E6(2) mod 13 available
#I  not all input tables for (2^2x3).2E6(2) mod 17 available
#I  not all input tables for (2^2x3).2E6(2) mod 19 available

##  doc2/ctblcons.xml (9708-9716)
gap> entry:= [ "2^2.O8+(3)", "2.O8+(3)", "O8+(3)" ];;
gap> tblG:= CharacterTable( entry[3] );;
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( Filtered( aut, x -> Order( x ) = 3 ),
>                SmallestGeneratorPerm );;
gap> Length( ord3 );
4

##  doc2/ctblcons.xml (9726-9739)
gap> poss:= [];;
gap> tbl2G:= CharacterTable( entry[2] );
CharacterTable( "2.O8+(3)" )
gap> for pi in ord3 do
>   Append( poss,
>           PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, entry[1] ) );
> od;
gap> Length( poss );
32
gap> poss:= RepresentativesCharacterTables( poss );;
gap> Length( poss );
1

##  doc2/ctblcons.xml (9747-9752)
gap> lib:= CharacterTable( entry[1] );;
gap> if TransformingPermutationsCharacterTables( poss[1], lib ) = fail then
>      Print( "#E  differences for ", entry[1], "\n" );
>    fi;

##  doc2/ctblcons.xml (9979-9991)
gap> tblG:= CharacterTable( "2.L3(4)" );;
gap> tbls2G:= List( [ "4_1.L3(4)", "4_2.L3(4)", "2^2.L3(4)"],
>                   CharacterTable );;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbls2G, "(2x4).L3(4)" );;
gap> Length( poss );
2
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(2x4).L3(4)" ) ]
gap> lib:= CharacterTable( "(2x4).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true

##  doc2/ctblcons.xml (10003-10022)
gap> tblG:= tbls2G[3];
CharacterTable( "2^2.L3(4)" )
gap> tbl2G:= lib;       
CharacterTable( "(2x4).L3(4)" )
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( Filtered( aut, x -> Order( x ) = 3 ),
>                SmallestGeneratorPerm );
[ (2,3,4)(6,7,8)(10,11,12)(13,15,17)(14,16,18)(20,21,22)(24,25,26)(28,
    29,30)(32,33,34) ]
gap> pi:= ord3[1];;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, "4^2.L3(4)" );;
gap> Length( poss );
4
gap> reps:= RepresentativesCharacterTables( poss );        
[ CharacterTable( "4^2.L3(4)" ) ]
gap> lib:= CharacterTable( "4^2.L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true

##  doc2/ctblcons.xml (10036-10069)
gap> tblG:= CharacterTable( "6.L3(4)" );;
gap> tbls2G:= List( [ "12_1.L3(4)", "12_2.L3(4)", "(2^2x3).L3(4)"],            
>                   CharacterTable );;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbls2G, "(2x12).L3(4)" );;
gap> Length( poss );
2
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(2x12).L3(4)" ) ]
gap> lib:= CharacterTable( "(2x12).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true
gap> tblG:= CharacterTable( "(2^2x3).L3(4)" ); 
CharacterTable( "(2^2x3).L3(4)" )
gap> tbl2G:= CharacterTable( "(2x12).L3(4)" );
CharacterTable( "(2x12).L3(4)" )
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( Filtered( aut, x -> Order( x ) = 3 ),
>                SmallestGeneratorPerm );
[ (2,7,8)(3,4,10)(6,11,12)(14,19,20)(15,16,22)(18,23,24)(26,27,28)(29,
    35,41)(30,37,43)(31,39,45)(32,36,42)(33,38,44)(34,40,46)(48,53,
    54)(49,50,56)(52,57,58)(60,65,66)(61,62,68)(64,69,70)(72,77,
    78)(73,74,80)(76,81,82)(84,89,90)(85,86,92)(88,93,94) ]
gap> pi:= ord3[1];;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi,
>                                             "(4^2x3).L3(4)" );;
gap> Length( poss );
4
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(4^2x3).L3(4)" ) ]
gap> lib:= CharacterTable( "(4^2x3).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true

##  doc2/ctblcons.xml (10101-10141)
gap> for input in listMGA do
>      ordtblMG  := CharacterTable( input[1] );
>      ordtblG   := CharacterTable( input[2] );
>      ordtblGA  := CharacterTable( input[3] );
>      ordtblMGA := CharacterTable( input[4] );
>      p:= Size( ordtblGA ) / Size( ordtblG );
>      if IsPrimeInt( p ) then
>        modtblG:= ordtblG mod p;
>        if modtblG <> fail then
>          modtblGA := CharacterTableRegular( ordtblGA, p );
>          SetIrr( modtblGA, IBrOfExtensionBySingularAutomorphism( modtblG,
>                                ordtblGA ) );
>          modlibtblGA:= ordtblGA mod p;
>          if modlibtblGA = fail then
>            Print( "#E  ", p, "-modular table of '", Identifier( ordtblGA ),
>                   "' is missing\n" );
>          elif TransformingPermutationsCharacterTables( modtblGA,
>                   modlibtblGA ) = fail then
>            Print( "#E  computed table and library table for ", input[3],
>                   " mod ", p, " differ\n" );
>          fi;
>        fi;
>        modtblMG:= ordtblMG mod p;
>        if modtblMG <> fail then
>          modtblMGA := CharacterTableRegular( ordtblMGA, p );
>          SetIrr( modtblMGA, IBrOfExtensionBySingularAutomorphism( modtblMG,
>                                 ordtblMGA ) );
>          modlibtblMGA:= ordtblMGA mod p;
>          if modlibtblMGA = fail then
>            Print( "#E  ", p, "-modular table of '", Identifier( ordtblMGA ),
>                   "' is missing\n" );
>          elif TransformingPermutationsCharacterTables( modtblMGA,
>                   modlibtblMGA ) = fail then
>            Print( "#E  computed table and library table for ", input[4],
>                   " mod ", p, " differ\n" );
>          fi;
>        fi;
>      fi;
>    od;

##  doc2/ctblcons.xml (10165-10216)
gap> for input in listGS3 do
>      modtblG:= CharacterTable( input[1] ) mod 2;
>      if modtblG <> fail then
>        ordtblG2 := CharacterTable( input[2] );
>        modtblG2 := CharacterTableRegular( ordtblG2, 2 );
>        SetIrr( modtblG2, IBrOfExtensionBySingularAutomorphism( modtblG,
>                              ordtblG2 ) );
>        modlibtblG2:= ordtblG2 mod 2;
>        if modlibtblG2 = fail then
>          Print( "#E  2-modular table of '", Identifier( ordtblG2 ),
>                 "' is missing\n" );
>        elif TransformingPermutationsCharacterTables( modtblG2,
>                 modlibtblG2 ) = fail then
>          Print( "#E  computed table and library table for ", input[2],
>                 " mod 2 differ\n" );
>        fi;
>      fi;
>      modtblG:= CharacterTable( input[1] ) mod 3;
>      if modtblG <> fail then
>        ordtblG3 := CharacterTable( input[3] );
>        modtblG3 := CharacterTableRegular( ordtblG3, 3 );
>        SetIrr( modtblG3, IBrOfExtensionBySingularAutomorphism( modtblG,
>                              ordtblG3 ) );
>        modlibtblG3:= ordtblG3 mod 3;
>        if modlibtblG3 = fail then
>          Print( "#E  3-modular table of '", Identifier( ordtblG3 ),
>                 "' is missing\n" );
>        elif TransformingPermutationsCharacterTables( modtblG3,
>                 modlibtblG3 ) = fail then
>          Print( "#E  computed table and library table for ", input[3],
>                 " mod 3 differ\n" );
>        fi;
>      fi;
>      modtblG3:= CharacterTable( input[3] ) mod 2;
>      if modtblG3 <> fail then
>        ordtblGS3 := CharacterTable( input[4] );
>        modtblGS3 := CharacterTableRegular( ordtblGS3, 2 );
>        SetIrr( modtblGS3, IBrOfExtensionBySingularAutomorphism( modtblG3,
>                               ordtblGS3 ) );
>        modlibtblGS3:= ordtblGS3 mod 2;
>        if modlibtblGS3 = fail then
>          Print( "#E  2-modular table of '", Identifier( ordtblGS3 ),
>                 "' is missing\n" );
>        elif TransformingPermutationsCharacterTables( modtblGS3,
>                 modlibtblGS3 ) = fail then
>          Print( "#E  computed table and library table for ", input[4],
>                 " mod 2 differ\n" );
>        fi;
>      fi;
>    od;

##  doc2/ctblcons.xml (10243-10277)
gap> for input in listGV4 do
>      modtblG:= CharacterTable( input[1] ) mod 2;
>      if modtblG <> fail then
>        ordtblsG2:= List( input{ [ 2 .. 4 ] }, CharacterTable );
>        ordtblGV4:= CharacterTable( input[5] );
>        for tblG2 in ordtblsG2 do
>          modtblG2:= CharacterTableRegular( tblG2, 2 );
>          SetIrr( modtblG2, IBrOfExtensionBySingularAutomorphism( modtblG,
>                                tblG2 ) );
>          modlibtblG2:= tblG2 mod 2;
>          if modlibtblG2 = fail then
>            Print( "#E  2-modular table of '", Identifier( tblG2 ),
>                   "' is missing\n" );
>          elif TransformingPermutationsCharacterTables( modtblG2,
>                   modlibtblG2 ) = fail then
>            Print( "#E  computed table and library table for ",
>                   Identifier( tblG2 ), " mod 2 differ\n" );
>          fi;
>          modtblGV4:= CharacterTableRegular( ordtblGV4, 2 );
>          SetIrr( modtblGV4, IBrOfExtensionBySingularAutomorphism( modtblG2,
>                                ordtblGV4 ) );
>          modlibtblGV4:= ordtblGV4 mod 2;
>          if modlibtblGV4 = fail then
>            Print( "#E  2-modular table of '", Identifier( ordtblGV4 ),
>                   "' is missing\n" );
>          elif TransformingPermutationsCharacterTables( modtblGV4,
>                 ordtblGV4 mod 2 ) = fail then
>            Print( "#E  computed table and library table for ", input[5],
>                   " mod 2 differ\n" );
>          fi;
>        od;
>      fi;
>    od;

##  doc2/ctblcons.xml (10294-10312)
gap> ordtblG3:= CharacterTable( "U3(8).3^2" );;
gap> modlibtblG3:= ordtblG3 mod 3;
BrauerTable( "U3(8).3^2", 3 )
gap> for nam in [ "U3(8).3_1", "U3(8).3_2", "U3(8).3_3" ] do
>      modtblG:= CharacterTable( nam ) mod 3;
>      if modtblG = fail then
>        Error( "no 3-modular table of ", nam );
>      fi;
>      modtblG3:= CharacterTableRegular( ordtblG3, 3 );
>      SetIrr( modtblG3, IBrOfExtensionBySingularAutomorphism( modtblG,
>                            ordtblG3 ) );
>      if TransformingPermutationsCharacterTables( modtblG3,
>             modlibtblG3 ) = fail then
>        Print( "#E  computed table and library table for ",
>               Identifier( ordtblG3 ), " mod 3 differ\n" );
>      fi;
>    od;

##  doc2/ctblcons.xml (10326-10330)
gap> rest:= RestrictedClassFunctions( Irr( ordtblG3 ), modlibtblG3 );;
gap> IsSubset( rest, Irr( modlibtblG3 ) );
true

##  doc2/ctblcons.xml (10366-10378)
gap> tblh1:= CharacterTable( "C3" );;
gap> tblg1:= CharacterTable( "S3" );;
gap> StoreFusion( tblh1, PossibleClassFusions( tblh1, tblg1 )[1], tblg1 );
gap> tblh2:= CharacterTable( "C5" );;
gap> tblg2:= CharacterTable( "D10" );;
gap> StoreFusion( tblh2, PossibleClassFusions( tblh2, tblg2 )[1], tblg2 );
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "D30" );;
gap> IsRecord( TransformingPermutationsCharacterTables( subdir.table,
>                  CharacterTable( "Dihedral", 30 ) ) );
true

##  doc2/ctblcons.xml (10395-10411)
gap> tblh1:= CharacterTable( "D10" );;
gap> tblg1:= CharacterTable( "5:4" );;
gap> tblh2:= CharacterTable( "HN" );;
gap> tblg2:= CharacterTable( "HN.2" );;
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "(D10xHN).2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( subdir.table,
>                  CharacterTable( "(D10xHN).2" ) ) );
true
gap> m:= CharacterTable( "M" );;
gap> fus:= PossibleClassFusions( subdir.table, m );;
gap> Length( fus );
16
gap> Length( RepresentativesFusions( subdir.table, fus, m ) );
1

##  doc2/ctblcons.xml (10428-10473)
gap> c2:= CharacterTable( "C2" );;
gap> hn:= CharacterTable( "HN" );;
gap> g:= c2 * hn;;
gap> d10:= CharacterTable( "D10" );;
gap> mg:= d10 * hn;;
gap> nsg:= ClassPositionsOfNormalSubgroups( mg );
[ [ 1 ], [ 1, 55 .. 109 ], [ 1, 55 .. 163 ], [ 1 .. 54 ], 
  [ 1 .. 162 ], [ 1 .. 216 ] ]
gap> SizesConjugacyClasses( mg ){ nsg[2] };
[ 1, 2, 2 ]
gap> g:= mg / nsg[2];
CharacterTable( "D10xHN/[ 1, 55, 109 ]" )
gap> help:= c2 * CharacterTable( "HN.2" );
CharacterTable( "C2xHN.2" )
gap> ga:= CharacterTableIsoclinic( help ); 
CharacterTable( "Isoclinic(C2xHN.2)" )
gap> gfusga:= PossibleClassFusions( g, ga ); 
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 14, 15, 16, 17, 
      18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 
      32, 32, 33, 33, 34, 35, 36, 37, 37, 38, 39, 40, 40, 41, 42, 42, 
      43, 43, 44, 44, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 89, 
      90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 101, 102, 
      103, 103, 104, 105, 106, 107, 108, 109, 110, 110, 111, 111, 
      112, 113, 114, 115, 115, 116, 117, 118, 118, 119, 120, 120, 
      121, 121, 122, 122 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 14, 15, 16, 17, 
      18, 19, 20, 21, 22, 23, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 
      32, 32, 33, 33, 35, 34, 36, 37, 37, 38, 39, 40, 40, 41, 42, 42, 
      43, 43, 44, 44, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 89, 
      90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 101, 102, 
      103, 103, 104, 105, 106, 107, 108, 109, 110, 110, 111, 111, 
      113, 112, 114, 115, 115, 116, 117, 118, 118, 119, 120, 120, 
      121, 121, 122, 122 ] ]
gap> StoreFusion( g, gfusga[1], ga );
gap> acts:= PossibleActionsForTypeMGA( mg, g, ga );;
gap> Length( acts );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( mg, g, ga, acts[1],       
>               "(D10xHN).2" );;
gap> Length( poss );
1
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTable( "(D10xHN).2" ) ) );
true

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "ctblcons.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
