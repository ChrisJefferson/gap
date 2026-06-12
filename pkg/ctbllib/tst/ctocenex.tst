# This file was created automatically, do not edit!
#############################################################################
##
#W  ctocenex.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "ctocenex.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "ctocenex.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/ctocenex.xml (589-592)
gap> LoadPackage( "ctbllib", false );
true

##  doc2/ctocenex.xml (612-633)
gap> list:= [
>     #         G          m.G          n.G           mn.G
> 
>     [      "A6",      "2.A6",      "3.A6",        "6.A6" ],
>     [      "A7",      "2.A7",      "3.A7",        "6.A7" ],
>     [   "L3(4)",   "2.L3(4)",   "3.L3(4)",     "6.L3(4)" ],
>     [ "2.L3(4)", "4_1.L3(4)",   "6.L3(4)",  "12_1.L3(4)" ],
>     [ "2.L3(4)", "4_2.L3(4)",   "6.L3(4)",  "12_2.L3(4)" ],
>     [     "M22",     "2.M22",     "3.M22",       "6.M22" ],
>     [   "2.M22",     "4.M22",     "6.M22",      "12.M22" ],
>     [   "U4(3)",   "2.U4(3)", "3_1.U4(3)",   "6_1.U4(3)" ],
>     [   "U4(3)",   "2.U4(3)", "3_2.U4(3)",   "6_2.U4(3)" ],
>     [ "2.U4(3)",   "4.U4(3)", "6_1.U4(3)",  "12_1.U4(3)" ],
>     [ "2.U4(3)",   "4.U4(3)", "6_2.U4(3)",  "12_2.U4(3)" ],
>     [   "O7(3)",   "2.O7(3)",   "3.O7(3)",     "6.O7(3)" ],
>     [   "U6(2)",   "2.U6(2)",   "3.U6(2)",     "6.U6(2)" ],
>     [     "Suz",     "2.Suz",     "3.Suz",       "6.Suz" ],
>     [    "Fi22",    "2.Fi22",    "3.Fi22",      "6.Fi22" ],
>     [  "2E6(2)",  "2.2E6(2)",  "3.2E6(2)",    "6.2E6(2)" ],
>   ];;

##  doc2/ctocenex.xml (650-706)
gap> SetInfoLevel( InfoCharacterTable, 1 );
gap> for entry in list do
>   id    := entry[4];
>   tblG  := CharacterTable( entry[1] );
>   tblmG := CharacterTable( entry[2] );
>   tblnG := CharacterTable( entry[3] );
>   lib   := CharacterTable( id );
>   res:= CharacterTableOfCommonCentralExtension( tblG, tblmG, tblnG, id );
>   if not res.IsComplete then
>     Print( "#E  not complete: ", id, "\n" );
>   fi;
>   if not IsSubset( Irr( lib ), res.irreducibles ) then
>     Print( "#E  inconsistent: ", id, "\n" );
>   fi;
> od;
#I  6.A6: need 4 faithful irreducibles
#I  6.A6: 4 found by tensoring
#I  6.A7: need 5 faithful irreducibles
#I  6.A7: 5 found by tensoring
#I  6.L3(4): need 7 faithful irreducibles
#I  6.L3(4): 7 found by LLL
#I  12_1.L3(4): need 5 faithful irreducibles
#I  12_1.L3(4): 2 found by tensoring
#I  12_1.L3(4): 3 found by tensoring
#I  12_2.L3(4): need 6 faithful irreducibles
#I  12_2.L3(4): 6 found by LLL
#I  6.M22: need 10 faithful irreducibles
#I  6.M22: 1 found by tensoring
#I  6.M22: 9 found by LLL
#I  12.M22: need 7 faithful irreducibles
#I  12.M22: 7 found by LLL
#I  6_1.U4(3): need 15 faithful irreducibles
#I  6_1.U4(3): 1 found by tensoring
#I  6_1.U4(3): 14 found by LLL
#I  6_2.U4(3): need 12 faithful irreducibles
#I  6_2.U4(3): 12 found by LLL
#I  12_1.U4(3): need 12 faithful irreducibles
#I  12_1.U4(3): 4 found by tensoring
#I  12_1.U4(3): 8 found by tensoring
#I  12_2.U4(3): need 9 faithful irreducibles
#I  12_2.U4(3): 9 found by LLL
#I  6.O7(3): need 12 faithful irreducibles
#I  6.O7(3): 2 found by tensoring
#I  6.O7(3): 10 found by LLL
#I  6.U6(2): need 28 faithful irreducibles
#I  6.U6(2): 2 found by tensoring
#I  6.U6(2): 26 found by LLL
#I  6.Suz: need 29 faithful irreducibles
#I  6.Suz: 29 found by LLL
#I  6.Fi22: need 34 faithful irreducibles
#I  6.Fi22: 4 found by tensoring
#I  6.Fi22: 30 found by LLL
#I  6.2E6(2): need 60 faithful irreducibles
#I  6.2E6(2): 60 found by LLL
gap> SetInfoLevel( InfoCharacterTable, 0 );

##  doc2/ctocenex.xml (756-762)
gap> list2:= [
>     [ "2.L3(4)",     "2^2.L3(4)",   "6.L3(4)",       "(2^2x3).L3(4)" ],
>     [ "2^2.L3(4)",   "(2x4).L3(4)", "(2^2x3).L3(4)", "(2x12).L3(4)"  ],
>     [ "(2x4).L3(4)", "4^2.L3(4)",   "(2x12).L3(4)",  "(4^2x3).L3(4)" ],
>   ];;

##  doc2/ctocenex.xml (793-840)
gap> Append( list2, [
>     [ "3_1.U4(3)",   "6_1.U4(3)",   "3^2.U4(3)",     "(3^2x2).U4(3)" ],
>     [ "3_2.U4(3)",   "6_2.U4(3)",   "3^2.U4(3)",     "(3^2x2).U4(3)" ],
>     [ "6_1.U4(3)",   "12_1.U4(3)",  "(3^2x2).U4(3)", "(3^2x4).U4(3)" ],
>     [ "6_2.U4(3)",   "12_2.U4(3)",  "(3^2x2).U4(3)", "(3^2x4).U4(3)" ],
>   ] );
gap> SetInfoLevel( InfoCharacterTable, 1 );
gap> for entry in list2 do
>   id    := entry[4];
>   tblG  := CharacterTable( entry[1] );
>   tblmG := CharacterTable( entry[2] );
>   tblnG := CharacterTable( entry[3] );
>   lib   := CharacterTable( id );
>   res:= CharacterTableOfCommonCentralExtension(
>             tblG, tblmG, tblnG, id );
>   if not res.IsComplete then
>     Print( "#E  not complete: ", id, "\n" );
>   fi;
>   if TransformingPermutationsCharacterTables( res.tblmnG, lib )
>          = fail then
>     Print( "#E  inconsistent: ", id, "\n" );
>   fi;
> od;
#I  (2^2x3).L3(4): need 14 faithful irreducibles
#I  (2^2x3).L3(4): 14 found by tensoring
#I  (2x12).L3(4): need 11 faithful irreducibles
#I  (2x12).L3(4): 7 found by tensoring
#I  (2x12).L3(4): 4 found by LLL
#I  (4^2x3).L3(4): need 22 faithful irreducibles
#I  (4^2x3).L3(4): 14 found by tensoring
#I  (4^2x3).L3(4): 8 found by LLL
#I  (3^2x2).U4(3): need 39 faithful irreducibles
#I  (3^2x2).U4(3): 27 found by tensoring
#I  (3^2x2).U4(3): 12 found by LLL
#I  (3^2x2).U4(3): need 42 faithful irreducibles
#I  (3^2x2).U4(3): 2 found by tensoring
#I  (3^2x2).U4(3): 40 found by LLL
#I  (3^2x4).U4(3): need 30 faithful irreducibles
#I  (3^2x4).U4(3): 6 found by tensoring
#I  (3^2x4).U4(3): 8 found by tensoring
#I  (3^2x4).U4(3): 16 found by LLL
#I  (3^2x4).U4(3): need 33 faithful irreducibles
#I  (3^2x4).U4(3): 9 found by tensoring
#I  (3^2x4).U4(3): 18 found by tensoring
#I  (3^2x4).U4(3): 6 found by further tensoring
gap> SetInfoLevel( InfoCharacterTable, 0 );

##  doc2/ctocenex.xml (864-896)
gap> sublist:= list{ [ 6, 7, 14 ] };
[ [ "M22", "2.M22", "3.M22", "6.M22" ], 
  [ "2.M22", "4.M22", "6.M22", "12.M22" ], 
  [ "Suz", "2.Suz", "3.Suz", "6.Suz" ] ]
gap> for entry in sublist do
>   tblG  := CharacterTable( entry[1] );
>   tblmG := CharacterTable( entry[2] );
>   tblnG := CharacterTable( entry[3] );
>   lib   := CharacterTable( entry[4] );
> 
>   maxesG   := List( Maxes( tblG ), CharacterTable );
>   maxesmG  := List( Maxes( tblmG ), CharacterTable );
>   maxesnG  := List( Maxes( tblnG ), CharacterTable );
>   maxeslib := List( Maxes( lib ), CharacterTable );
> 
>   for i in [ 1 .. Length( maxesG ) ] do
>     id:= Identifier( maxeslib[i] );
>     res:= CharacterTableOfCommonCentralExtension( maxesG[i],
>               maxesmG[i], maxesnG[i], id );
>     if not res.IsComplete then
>       Print( "#E  not complete: ", id, "\n" );
>     fi;
>     if not IsSubset( Irr( maxeslib[i] ), res.irreducibles ) then
>       trans:= TransformingPermutationsCharacterTables( maxeslib[i],
>                                                        res.tblmnG );
>       if not IsRecord( trans ) then
>         Print( "#E  not transformable: ", id, "\n" );
>       fi;
>     fi;
>   od;
> od;

##  doc2/ctocenex.xml (958-962)
gap> tblmG := CharacterTable( "F3+N2B" );;
gap> tblG  := tblmG / ClassPositionsOfCentre( tblmG );;
gap> tblnG := CharacterTable( "2^12.3^2.U4(3).2_2'" );;

##  doc2/ctocenex.xml (972-981)
gap> f2:= tblnG / ClassPositionsOfCentre( tblnG );;
gap> trans:= TransformingPermutationsCharacterTables( f2, tblG );;
gap> tblnGfustblG:= OnTuples( GetFusionMap( tblnG, f2 ),
>                             trans.columns );;
gap> StoreFusion( tblnG, tblnGfustblG, tblG );
gap> IsSubset( Irr( tblnG ),
>              List( Irr( tblG ), x -> x{ tblnGfustblG } ) );
true

##  doc2/ctocenex.xml (990-999)
gap> SetInfoLevel( InfoCharacterTable, 1 );
gap> id:= "3.2^(1+12).3U4(3).2";;
gap> res:= CharacterTableOfCommonCentralExtension(
>              tblG, tblmG, tblnG, id );;
#I  3.2^(1+12).3U4(3).2: need 36 faithful irreducibles
#I  3.2^(1+12).3U4(3).2: 16 found by tensoring
#I  3.2^(1+12).3U4(3).2: 20 found by LLL
gap> SetInfoLevel( InfoCharacterTable, 0 );

##  doc2/ctocenex.xml (1009-1014)
gap> lib:= CharacterTable( "3.F3+N2B" );;
gap> IsRecord( TransformingPermutationsCharacterTables(
>                  res.tblmnG, lib ) );
true

##  doc2/ctocenex.xml (1028-1039)
gap> 3f3p:= CharacterTable( "3.F3+" );;
gap> f3p:= CharacterTable( "F3+" );;
gap> approxfus:= CompositionMaps(
>                    InverseMap( GetFusionMap( 3f3p, f3p ) ),
>                    CompositionMaps( GetFusionMap( tblmG, f3p ),
>                        GetFusionMap( lib, tblmG ) ) );;
gap> poss:= PossibleClassFusions( lib, 3f3p,
>               rec( fusionmap:= approxfus ) );;
gap> Length( poss );
1

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "ctocenex.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
