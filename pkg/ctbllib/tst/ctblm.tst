# This file was created from xpl/ctblm.xpl, do not edit!
#############################################################################
##
#W  ctblm.tst                 GAP applications              Thomas Breuer
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `Test( "ctblm.tst" );`.
##
gap> START_TEST( "ctblm.tst" );

##
gap> LoadPackage( "ctbllib", false );
true
gap> LoadPackage( "atlasrep", false );
true

##
gap> CTblLib.IsMagmaAvailable();
true

##
gap> SizeScreen( [ 72 ] );;

##
gap> table2B:= CharacterTable( "2.B" );;
gap> cand:= Filtered( Irr( table2B ), x -> x[1] <= 196883 );;
gap> List( cand, x -> x[1] );
[ 1, 4371, 96255, 96256 ]
gap> inv:= Positions( OrdersClassRepresentatives( table2B ), 2 );
[ 2, 3, 4, 5, 7 ]
gap> PrintArray( List( cand, x -> x{ Concatenation( [ 1 ], inv ) } ) );
[ [       1,       1,       1,       1,       1,       1 ],
  [    4371,    4371,    -493,     275,     275,      19 ],
  [   96255,   96255,    4863,    2047,    2047,     255 ],
  [   96256,  -96256,       0,    2048,   -2048,       0 ] ]

##
gap> Sum( cand ){ inv };
[ 4371, 4371, 4371, 275, 275 ]

##
gap> table3Fi24prime:= CharacterTable( "3.Fi24'" );;
gap> cand:= Filtered( Irr( table3Fi24prime ), x -> x[1] <= 196883 );;
gap> inv:= Positions( OrdersClassRepresentatives( table3Fi24prime ), 2 );
[ 4, 7 ]
gap> mat:= List( cand, x -> x{ Concatenation([1], inv)});;
gap> PrintArray( mat );
[ [      1,      1,      1 ],
  [   8671,    351,    -33 ],
  [  57477,   1157,    133 ],
  [    783,     79,     15 ],
  [    783,     79,     15 ],
  [  64584,   1352,     72 ],
  [  64584,   1352,     72 ] ]

##
gap> List( cand, x -> x[2] );
[ 1, 8671, 57477, 783*E(3), 783*E(3)^2, 64584*E(3), 64584*E(3)^2 ]

##
gap> Float( 196883 / 4371 );
45.043
gap> List( mat, v -> Float( v[1] / v[2] ) );
[ 1., 24.7037, 49.6776, 9.91139, 9.91139, 47.7692, 47.7692 ]
gap> Float( ( 196883 - 2 * 64584 ) / ( 4371 - 2 * 1352 ) );
40.6209
gap> Float( ( 196883 - 57477 ) / ( 4371 - 1157 ) );
43.3746
gap> Float( ( 196883 - 2*57477 ) / ( 4371 - 2*1157 ) );
39.8294
gap> Float( ( 196883 - 3*57477 ) / ( 4371 - 3*1157 ) );
27.1689

##
gap> mat[3] + mat[6] + mat[7];
[ 186645, 3861, 277 ]

##
gap> Sum( mat );
[ 196883, 4371, 275 ]

##
gap> table3Fi24:= CharacterTable( "3.Fi24" );;
gap> cand:= Filtered( Irr( table3Fi24 ), x -> x[1] <= 196883 );;
gap> inv:= Positions( OrdersClassRepresentatives( table3Fi24 ), 2 );
[ 3, 5, 172, 173 ]
gap> mat:= List( cand, x -> x{ Concatenation([1], inv)});;
gap> PrintArray( mat );
[ [       1,       1,       1,       1,       1 ],
  [       1,       1,       1,      -1,      -1 ],
  [    8671,     351,     -33,    1495,     -41 ],
  [    8671,     351,     -33,   -1495,      41 ],
  [   57477,    1157,     133,    5865,     233 ],
  [   57477,    1157,     133,   -5865,    -233 ],
  [    1566,     158,      30,       0,       0 ],
  [  129168,    2704,     144,       0,       0 ] ]

##
gap> Sum( mat{ [ 1, 4, 5, 7, 8 ] } );
[ 196883, 4371, 275, 4371, 275 ]

##
gap> pi1:= TrivialCharacter( table2B );;

##
gap> tableB:= CharacterTable( "B" );;   
gap> tableUbar:= CharacterTable( "2.2E6(2)" );;
gap> fus:= PossibleClassFusions( tableUbar, tableB );;
gap> pi:= Set( fus,
>              map -> InducedClassFunctionsByFusionMap( tableUbar, tableB,
>                         [ TrivialCharacter( tableUbar ) ], map )[1] );;
gap> Length( pi );
1
gap> pi2:= Inflated( tableB, table2B, pi )[1];;
gap> mult:= List( Irr( table2B ),
>                 chi -> ScalarProduct( table2B, chi, pi2 ) );;
gap> Maximum( mult );
1
gap> Positions( mult, 1 );
[ 1, 2, 3, 5, 7, 13, 15, 17 ]

##
gap> tableUbar:= CharacterTable( "BN2B" );
CharacterTable( "2^(1+22).Co2" )
gap> fus:= PossibleClassFusions( tableUbar, tableB );;
gap> pi:= Set( fus,
>              map -> InducedClassFunctionsByFusionMap( tableUbar, tableB,
>                         [ TrivialCharacter( tableUbar ) ], map )[1] );;
gap> Length( pi );
1
gap> pi3:= Inflated( tableB, table2B, pi )[1];;
gap> mult:= List( Irr( table2B ),
>                 chi -> ScalarProduct( table2B, chi, pi3 ) );;
gap> Maximum( mult );
1
gap> Positions( mult, 1 );
[ 1, 3, 5, 8, 13, 15, 28, 30, 37, 40 ]

##
gap> tableU:= CharacterTable( "Fi23" );;
gap> fus:= PossibleClassFusions( tableU, table2B );;
gap> pi:= Set( fus,
>              map -> InducedClassFunctionsByFusionMap( tableU, table2B,
>                         [ TrivialCharacter( tableU ) ], map )[1] );;
gap> Length( pi );
1
gap> pi4:= pi[1];;
gap> mult:= List( Irr( table2B ),
>                 chi -> ScalarProduct( table2B, chi, pi4 ) );;
gap> Maximum( mult );
1
gap> Positions( mult, 1 );
[ 1, 2, 3, 5, 7, 8, 9, 12, 13, 15, 17, 23, 27, 30, 32, 40, 41, 54, 
  63, 68, 77, 81, 83, 185, 186, 187, 188, 189, 194, 195, 196, 203, 
  208, 220 ]

##
gap> tableU:= CharacterTable( "Th" );;
gap> fus:= PossibleClassFusions( tableU, table2B );;
gap> pi:= Set( fus,
>              map -> InducedClassFunctionsByFusionMap( tableU, table2B,
>                         [ TrivialCharacter( tableU ) ], map )[1] );;
gap> Length( pi );
1
gap> pi5:= pi[1];;
gap> mult:= List( Irr( table2B ),
>                 chi -> ScalarProduct( table2B, chi, pi5 ) );;
gap> Maximum( mult );
2
gap> Positions( mult, 1 );
[ 1, 3, 7, 8, 12, 13, 16, 19, 27, 28, 34, 38, 41, 57, 68, 70, 77, 78, 
  85, 89, 113, 114, 116, 129, 133, 142, 143, 145, 155, 156, 185, 187, 
  188, 193, 195, 196, 201, 208, 216, 219, 225, 232, 233, 235, 236, 
  237, 242 ]
gap> Positions( mult, 2 );
[ 62 ]

##
gap> mcl:= CharacterTable( "McL" );;
gap> co2:= CharacterTable( "Co2" );;
gap> fus:= PossibleClassFusions( mcl, co2 );;       
gap> Length( fus );
4
gap> ind:= Set( fus, map -> InducedClassFunctionsByFusionMap( mcl, co2,     
>                               [ TrivialCharacter( mcl ) ], map )[1] );;
gap> Length( ind );
1
gap> bm2:= CharacterTable( "BM2" );
CharacterTable( "2^(1+22).Co2" )
gap> infl:= Inflated( co2, bm2, ind );;
gap> ind:= Induced( bm2, tableB, infl );;
gap> infl:= Inflated( tableB, table2B, ind )[1];;

##
gap> centre:= ClassPositionsOfCentre( table2B );
[ 1, 2 ]
gap> pi:= PermChars( table2B, rec( torso:= [ 2 * infl[1], 0 ],
>                             normalsubgroup:= centre,
>                             nonfaithful:= infl ) );;
gap> Length( pi );
1
gap> pi6:= pi[1];;
gap> List( Irr( table2B ), chi -> ScalarProduct( table2B, chi, pi6 ) );
[ 1, 1, 2, 1, 2, 0, 2, 3, 2, 0, 0, 1, 4, 1, 2, 0, 3, 2, 0, 2, 0, 0, 
  2, 2, 0, 0, 2, 3, 1, 5, 0, 4, 3, 2, 0, 0, 3, 2, 0, 6, 4, 0, 1, 1, 
  0, 0, 0, 0, 3, 0, 1, 0, 0, 5, 0, 5, 2, 0, 0, 2, 0, 0, 4, 1, 0, 2, 
  0, 4, 2, 4, 4, 3, 0, 2, 4, 2, 4, 0, 3, 0, 3, 2, 5, 0, 1, 0, 3, 1, 
  0, 1, 1, 2, 5, 3, 1, 1, 4, 5, 1, 1, 0, 3, 0, 0, 3, 2, 1, 1, 2, 1, 
  1, 4, 0, 3, 2, 3, 1, 3, 0, 1, 3, 0, 2, 2, 1, 3, 3, 0, 0, 2, 0, 0, 
  0, 0, 3, 0, 3, 3, 3, 1, 0, 3, 0, 4, 0, 1, 0, 0, 2, 0, 0, 2, 0, 0, 
  2, 1, 1, 0, 0, 0, 0, 1, 2, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 2, 1, 
  1, 3, 3, 0, 0, 0, 1, 1, 1, 1, 2, 3, 2, 0, 0, 2, 2, 4, 3, 5, 2, 4, 
  0, 0, 0, 0, 5, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 1, 7, 
  7, 0, 0, 0, 1, 6, 4, 5, 0, 0, 3, 0, 0, 0, 0, 0, 4, 1, 1, 3, 8, 3, 
  2, 2, 5, 0, 1 ]

##
gap> tableU:= CharacterTable( "2.F4(2)" );;
gap> fus:= PossibleClassFusions( tableU, table2B );;
gap> pi:= Set( fus, map -> InducedClassFunctionsByFusionMap( tableU, table2B,
>             [ TrivialCharacter( tableU ) ], map )[1] );;
gap> Length( pi );
2
gap> pi:= Filtered( pi, x -> ClassPositionsOfKernel( x ) = [ 1 ] );;
gap> Length( pi );
1
gap> pi7:= pi[1];;
gap> List( Irr( table2B ), chi -> ScalarProduct( table2B, chi, pi7 ) );
[ 1, 1, 2, 0, 2, 0, 2, 2, 1, 0, 0, 2, 4, 1, 3, 0, 2, 1, 0, 0, 0, 0, 
  2, 1, 0, 0, 2, 2, 1, 4, 0, 2, 1, 2, 0, 0, 3, 2, 0, 4, 4, 0, 0, 0, 
  0, 0, 1, 0, 0, 0, 1, 0, 0, 2, 1, 3, 3, 0, 0, 3, 0, 1, 4, 0, 0, 3, 
  0, 6, 0, 3, 2, 0, 0, 1, 4, 1, 4, 2, 6, 1, 4, 0, 4, 0, 1, 1, 2, 0, 
  0, 3, 2, 1, 3, 2, 0, 0, 4, 5, 3, 1, 0, 3, 0, 0, 1, 1, 2, 0, 0, 2, 
  0, 2, 0, 3, 3, 3, 0, 4, 1, 0, 4, 1, 1, 1, 1, 1, 2, 1, 1, 2, 3, 0, 
  0, 2, 2, 0, 5, 5, 3, 0, 1, 5, 1, 4, 0, 1, 0, 1, 1, 0, 0, 3, 1, 0, 
  2, 3, 1, 0, 2, 0, 0, 2, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 2, 
  1, 4, 4, 0, 0, 0, 3, 1, 1, 1, 2, 2, 2, 0, 0, 1, 2, 3, 3, 3, 1, 2, 
  0, 0, 1, 1, 4, 2, 0, 0, 0, 3, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 1, 5, 
  5, 0, 1, 1, 2, 2, 4, 4, 0, 0, 3, 1, 1, 1, 0, 0, 4, 1, 1, 5, 7, 3, 
  2, 5, 5, 0, 1 ]

##
gap> tableU:= CharacterTable( "HN" );;
gap> fus:= PossibleClassFusions( tableU, table2B );;
gap> pi:= Set( fus, map -> InducedClassFunctionsByFusionMap( tableU, table2B,
>             [ TrivialCharacter( tableU ) ], map )[1] );;
gap> Length( pi );
1
gap> pi8:= pi[1];;
gap> List( Irr( table2B ), chi -> ScalarProduct( table2B, chi, pi8 ) );
[ 1, 1, 2, 1, 2, 0, 3, 4, 2, 1, 1, 4, 4, 2, 1, 1, 3, 3, 1, 3, 0, 0, 
  5, 3, 0, 0, 6, 4, 5, 6, 1, 7, 4, 7, 0, 0, 3, 8, 2, 6, 11, 2, 5, 5, 
  0, 0, 2, 1, 3, 4, 7, 0, 0, 7, 3, 9, 5, 0, 0, 6, 4, 2, 13, 6, 0, 4, 
  4, 12, 11, 16, 9, 7, 3, 11, 13, 12, 20, 5, 10, 6, 11, 13, 17, 4, 
  10, 7, 19, 7, 7, 8, 10, 14, 18, 19, 5, 10, 12, 23, 7, 12, 6, 24, 6, 
  4, 17, 16, 8, 9, 17, 11, 12, 23, 8, 24, 18, 26, 21, 29, 10, 18, 31, 
  10, 24, 21, 17, 27, 35, 13, 14, 29, 19, 12, 7, 18, 26, 15, 34, 34, 
  35, 20, 14, 36, 14, 39, 8, 29, 24, 15, 40, 13, 9, 38, 24, 17, 35, 
  32, 26, 26, 24, 22, 17, 31, 39, 29, 30, 30, 19, 44, 37, 37, 28, 30, 
  31, 29, 42, 40, 40, 56, 56, 30, 30, 42, 50, 47, 2, 2, 4, 6, 4, 0, 
  0, 4, 6, 10, 10, 12, 8, 12, 0, 0, 2, 4, 16, 10, 0, 0, 2, 12, 10, 0, 
  0, 0, 0, 0, 0, 28, 0, 0, 14, 34, 40, 2, 10, 10, 22, 40, 44, 44, 8, 
  8, 36, 14, 14, 16, 8, 8, 46, 28, 28, 58, 90, 72, 70, 92, 104, 56, 
  90 ]

##
gap> tableU:= CharacterTable( "2.Fi22" );;
gap> fus:= PossibleClassFusions( tableU, table2B );;
gap> pi:= Set( fus, map -> InducedClassFunctionsByFusionMap( tableU, table2B,
>             [ TrivialCharacter( tableU ) ], map )[1] );;
gap> Length( pi );
2
gap> pi:= Filtered( pi, x -> ClassPositionsOfKernel( x ) = [ 1 ] );;
gap> Length( pi );
1
gap> pi9:= pi[1];;
gap> List( Irr( table2B ), chi -> ScalarProduct( table2B, chi, pi9 ) );
[ 1, 2, 3, 1, 4, 1, 5, 5, 5, 1, 1, 5, 8, 4, 4, 1, 7, 6, 0, 5, 0, 0, 
  10, 7, 0, 0, 10, 6, 6, 13, 3, 14, 10, 11, 0, 0, 5, 11, 2, 14, 19, 
  6, 6, 5, 0, 0, 0, 3, 6, 7, 11, 0, 0, 17, 2, 20, 9, 0, 0, 12, 8, 1, 
  23, 11, 1, 8, 7, 23, 18, 27, 18, 12, 7, 22, 29, 21, 34, 6, 22, 7, 
  22, 18, 33, 3, 19, 10, 34, 12, 12, 15, 17, 28, 34, 34, 7, 20, 26, 
  40, 15, 25, 3, 40, 9, 6, 34, 25, 18, 21, 30, 21, 18, 43, 12, 45, 
  39, 49, 38, 51, 18, 32, 63, 19, 42, 41, 33, 48, 64, 27, 29, 52, 38, 
  29, 19, 40, 47, 31, 69, 69, 65, 42, 35, 68, 27, 73, 20, 53, 46, 38, 
  75, 29, 24, 72, 50, 41, 72, 68, 58, 52, 54, 50, 44, 64, 75, 58, 69, 
  65, 49, 85, 75, 75, 63, 68, 65, 63, 90, 87, 83, 118, 118, 74, 71, 
  90, 109, 109, 2, 3, 6, 9, 8, 0, 0, 7, 10, 18, 16, 22, 12, 23, 0, 0, 
  2, 6, 28, 19, 0, 0, 5, 16, 18, 0, 0, 0, 0, 0, 0, 52, 1, 1, 26, 59, 
  76, 11, 18, 18, 39, 77, 80, 77, 22, 22, 66, 27, 27, 33, 20, 20, 87, 
  60, 60, 103, 175, 148, 152, 187, 215, 140, 201 ]

##
gap> constit:= [ pi1, pi2, pi3, pi4, pi5, pi6, pi7, pi8, pi9 ];;
gap> pi:= Sum( constit );;

##
gap> sizeM:= pi[1] * Size( table2B );
808017424794512875886459904961710757005754368000000000
gap> StringPP( sizeM );
"2^46*3^20*5^9*7^6*11^2*13^3*17*19*23*29*31*41*47*59*71"
gap> sizeM = Size( CharacterTable( "M" ) );
true

##
gap> head:= rec( Size:= sizeM,
>                SizesCentralizers:= [ sizeM ],
>                OrdersClassRepresentatives:= [ 1 ],
>                fusions:= [],
>              );;

##
gap> ExtendTableHeadByRootClasses:= function( head, s, pos )
>    local fus, orders, p, cents, oldnumber, i, ord;
> 
>    # Initialize the fusion information.
>    fus:= rec( subtable:= s, map:= [ 1 ] );
>    Add( head.fusions, fus );
> 
>    # Compute the positions of root classes of 'pos'.
>    orders:= OrdersClassRepresentatives( s );
>    p:= orders[ pos ];
>    cents:= SizesCentralizers( s );
>    oldnumber:= Length( head.OrdersClassRepresentatives );
> 
>    # Run over the classes of 's'
>    # are already contained in head
>    for i in [ 1 .. NrConjugacyClasses( s ) ] do
>      ord:= orders[i];
>      if ord mod p = 0 and
>         Minimum( PrimeDivisors( ord ) ) = p and
>         PowerMap( s, ord / p, i ) = pos then
>        # Class 'i' is a root class of 'pos' and is new in 'head'.
>        Add( head.SizesCentralizers, cents[i] );
>        Add( head.OrdersClassRepresentatives, orders[i] );
>        fus.map[i]:= Length( head.SizesCentralizers );
>      fi;
>    od;
> 
>    Print( "#I  after ", Identifier( s ), ": found ",
>           Length( head.OrdersClassRepresentatives ) - oldnumber,
>           " classes, now have ",
>           Length( head.OrdersClassRepresentatives ), "\n" );
>    end;;

##
gap> ExtendTableHeadByCentralizerOrder:= function( head, s, cent, poss )
>    local ord, fus, i;
> 
>    if IsCharacterTable( s ) then
>      ord:= Set( OrdersClassRepresentatives( s ){ poss } );
>      if Length( ord ) <> 1 then
>        Error( "classes cannot fuse" );
>      fi;
>      ord:= ord[1];
>    elif IsInt( s ) then
>      ord:= s;
>    fi;
>    Add( head.SizesCentralizers, cent );
>    Add( head.OrdersClassRepresentatives, ord );
> 
>    Print( "#I  after order ", ord, " element" );
>    if IsCharacterTable( s ) then
>      # extend the stored fusion from s
>      fus:= First( head.fusions,
>                   r -> Identifier( r.subtable ) = Identifier( s ) );
>      for i in poss do
>        fus.map[i]:= Length( head.SizesCentralizers );
>      od;
>      Print( " from ", Identifier( s ) );
>    fi;
>    Print( ": have ",
>           Length( head.OrdersClassRepresentatives ), " classes\n" );
>    end;;

##
gap> ExtendTableHeadByPermCharValue:= function( head, s, pi_rest_to_s, poss )
>    local pival, cent;
> 
>    pival:= Set( pi_rest_to_s{ poss } );
>    if Length( pival ) <> 1 then
>      Error( "classes cannot fuse" );
>    fi;
> 
>    cent:= pival[1] * Size( s ) / Sum( SizesConjugacyClasses( s ){ poss } );
>    ExtendTableHeadByCentralizerOrder( head, s, cent, poss );
>    end;;

##
gap> s:= CharacterTable( "2.B" );;
gap> ClassPositionsOfCentre( s );
[ 1, 2 ]
gap> ExtendTableHeadByRootClasses( head, s, 2 );
#I  after 2.B: found 42 classes, now have 43
gap> s:= CharacterTable( "MN2B" );;
gap> ClassPositionsOfCentre( s );
[ 1, 2 ]
gap> ExtendTableHeadByRootClasses( head, s, 2 );
#I  after 2^1+24.Co1: found 91 classes, now have 134

##
gap> s:= CharacterTable( "3.Fi24" );;
gap> ClassPositionsOfPCore( s, 3 );
[ 1, 2 ]
gap> ExtendTableHeadByRootClasses( head, s, 2 );
#I  after 3.F3+.2: found 12 classes, now have 146
gap> s:= CharacterTableDirectProduct( CharacterTable( "Th" ),
>                                     CharacterTable( "Symmetric", 3 ) );;
gap> ClassPositionsOfPCore( s, 3 );
[ 1, 3 ]
gap> ExtendTableHeadByRootClasses( head, s, 3 );
#I  after ThxSym(3): found 7 classes, now have 153

##
gap> exts:= CharacterTable( "3^(1+12):6.Suz.2" );;
gap> kernels:= Positions( SizesConjugacyClasses( exts ), 2 );
[ 2, 18, 19, 20 ]
gap> order3_13:= Filtered( ClassPositionsOfNormalSubgroups( exts ),
>        l -> Sum( SizesConjugacyClasses( exts ){ l } ) = 3^13 );
[ [ 1 .. 4 ] ]
gap> kernels:= Difference( kernels, order3_13[1] );
[ 18, 19, 20 ]

##
gap> facts:= List( kernels, i -> exts / [ 1, i ] );
[ CharacterTable( "3^(1+12):6.Suz.2/[ 1, 18 ]" ), 
  CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" ), 
  CharacterTable( "3^(1+12):6.Suz.2/[ 1, 20 ]" ) ]
gap> f:= CharacterTable( "2.Suz.2" );;
gap> facts:= Filtered( facts,
>        x -> Length( PossibleClassFusions( f, x ) ) = 0 );
[ CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" ), 
  CharacterTable( "3^(1+12):6.Suz.2/[ 1, 20 ]" ) ]

##
gap> kernels:= List( facts,
>        f -> Positions( SizesConjugacyClasses( f ), 2 ) );
[ [ 2 ], [ 2 ] ]
gap> head2:= StructuralCopy( head );;
gap> ExtendTableHeadByRootClasses( head, facts[1], 2 );
#I  after 3^(1+12):6.Suz.2/[ 1, 19 ]: found 12 classes, now have 165
gap> ExtendTableHeadByRootClasses( head2, facts[2], 2 );
#I  after 3^(1+12):6.Suz.2/[ 1, 20 ]: found 12 classes, now have 165

##
gap> nams:= RecNames( head );
[ "Size", "OrdersClassRepresentatives", "SizesCentralizers", 
  "fusions" ]
gap> ForAll( Difference( nams, [ "fusions" ] ),
>            nam -> head.( nam ) = head2.( nam ) );
true
gap> Length( head.fusions );
5
gap> ForAll( [ 1 .. 4 ], i -> head.fusions[i] = head2.fusions[i] );
true
gap> head.fusions[5].map = head2.fusions[5].map;
true

##
gap> s:= CharacterTable( "2.B" );;
gap> pos:= Positions( OrdersClassRepresentatives( s ), 5 );
[ 23, 25 ]
gap> pi{ pos };
[ 1539000, 7875 ]

##
gap> cents:= List( pos,
>      i -> pi[i] * Size( s ) / SizesConjugacyClasses( s )[i] );
[ 1365154560000000, 94500000000 ]
gap> cents = [ 5 * Size( CharacterTable( "HN" ) ),
>              5^7 * Size( CharacterTable( "2.J2" ) ) ];
true

##
gap> s:= CharacterTable( "MN5A" );
CharacterTable( "(D10xHN).2" )
gap> ClassPositionsOfPCore( s, 5 );
[ 1, 45 ]
gap> ExtendTableHeadByRootClasses( head, s, 45 );
#I  after (D10xHN).2: found 5 classes, now have 170

##
gap> s:= CharacterTable( "MN5B" );
CharacterTable( "5^(1+6):2.J2.4" )
gap> 5core:= ClassPositionsOfPCore( s, 5 );
[ 1 .. 4 ]
gap> SizesConjugacyClasses( s ){ 5core };
[ 1, 4, 37800, 40320 ]
gap> ExtendTableHeadByRootClasses( head, s, 2 );
#I  after 5^(1+6):2.J2.4: found 3 classes, now have 173

##
gap> s:= CharacterTable( "2.B" );;
gap> pos:= Positions( OrdersClassRepresentatives( s ), 11 );
[ 71 ]

##
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos );
#I  after order 11 element from 2.B: have 174 classes

##
gap> s:= CharacterTable( "2.B" );;
gap> pos:= Positions( OrdersClassRepresentatives( s ), 17 );
[ 118 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos );
#I  after order 17 element from 2.B: have 175 classes
gap> pos:= Positions( OrdersClassRepresentatives( s ), 19 );
[ 128 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos );
#I  after order 19 element from 2.B: have 176 classes

##
gap> s:= CharacterTable( "2.B" );
CharacterTable( "2.B" )
gap> ord:= OrdersClassRepresentatives( s );;
gap> classes:= SizesConjugacyClasses( s );;
gap> p:= 23;;
gap> pos:= Positions( ord, p );
[ 147, 149 ]
gap> n:= (p-1)/2 * Size( s ) * pi[ pos[1] ] / classes[ pos[1] ];
6072
gap> Collected( Factors( n ) );
[ [ 2, 3 ], [ 3, 1 ], [ 11, 1 ], [ 23, 1 ] ]

##
gap> u:= CharacterTable( "MN2B" );
CharacterTable( "2^1+24.Co1" )
gap> upos:= Positions( OrdersClassRepresentatives( u ), p );
[ 289, 294 ]
gap> SizesCentralizers( u ){ upos } / 2^3;
[ 23, 23 ]

##
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [1] } );
#I  after order 23 element from 2.B: have 177 classes
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [2] } );
#I  after order 23 element from 2.B: have 178 classes

##
gap> p:= 31;;
gap> pos:= Positions( OrdersClassRepresentatives( s ), p );
[ 190, 192 ]
gap> n:= (p-1)/2 * Size( s ) * pi[ pos[1] ] / classes[ pos[1] ];
2790
gap> Collected( Factors( n ) );
[ [ 2, 1 ], [ 3, 2 ], [ 5, 1 ], [ 31, 1 ] ]
gap> SizesCentralizers( s ){ pos };
[ 62, 62 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [1] } );
#I  after order 31 element from 2.B: have 179 classes
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [2] } );
#I  after order 31 element from 2.B: have 180 classes

##
gap> p:= 47;;
gap> pos:= Positions( OrdersClassRepresentatives( s ), p );
[ 228, 230 ]
gap> n:= (p-1)/2 * Size( s ) * pi[ pos[1] ] / classes[ pos[1] ];
2162
gap> Collected( Factors( n ) );
[ [ 2, 1 ], [ 23, 1 ], [ 47, 1 ] ]
gap> SizesCentralizers( s ){ pos };
[ 94, 94 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [1] } );
#I  after order 47 element from 2.B: have 181 classes
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos{ [2] } );
#I  after order 47 element from 2.B: have 182 classes

##
gap> p:= 13;;
gap> pos:= Positions( OrdersClassRepresentatives( s ), p );
[ 97 ]
gap> c:= Size( s ) * pi[ pos[1] ] / classes[ pos[1] ];
73008
gap> Factors( c );
[ 2, 2, 2, 2, 3, 3, 3, 13, 13 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos );
#I  after order 13 element from 2.B: have 183 classes

##
gap> c2b:= CharacterTable( "MN2B" );;
gap> pos:= Positions( OrdersClassRepresentatives( c2b ), 13 );
[ 220 ]
gap> ExtendTableHeadByCentralizerOrder( head, c2b, 13^3 * 24, pos );
#I  after order 13 element from 2^1+24.Co1: have 184 classes

##
gap> u:= CharacterTable( "3.Fi24" );;
gap> pos:= Positions( OrdersClassRepresentatives( u ), 29 );
[ 142 ]
gap> SizesCentralizers( u ){ pos };
[ 87 ]

##
gap> poss:= PositionsProperty( head.SizesCentralizers,
>                              x -> x mod 29 = 0 );
[ 1, 135, 144, 145 ]
gap> head.OrdersClassRepresentatives{ poss };
[ 1, 3, 87, 87 ]
gap> head.SizesCentralizers{ poss };
[ 808017424794512875886459904961710757005754368000000000, 
  3765617127571985163878400, 87, 87 ]

##
gap> candprimes:= Difference( PrimeDivisors( head.Size ),
>                     [ 2, 3, 5, 11, 13, 17, 19, 23, 29, 31, 47 ] );
[ 7, 41, 59, 71 ]

##
gap> parts:= Filtered( Collected( Factors( head.Size ) ),
>                      x -> x[1] in candprimes );
[ [ 7, 6 ], [ 41, 1 ], [ 59, 1 ], [ 71, 1 ] ]
gap> poss:= List( parts, l -> List( [ 0 .. l[2] ], i -> l[1]^i ) );;
gap> cart:= Cartesian( poss );;
gap> possord:= 3 * 29 * List( cart, Product );;

##
gap> good:= Filtered( possord,
>                     x -> ( head.Size / ( 28 * x ) ) mod 29 = 1 );
[ 87, 5133 ]
gap> List( good, Factors );
[ [ 3, 29 ], [ 3, 29, 59 ] ]

##
gap> Filtered( DivisorsInt( 5133 ), x -> x mod 59 = 1 );
[ 1 ]

##
gap> ExtendTableHeadByCentralizerOrder( head, u, 3 * 29, pos );
#I  after order 29 element from 3.F3+.2: have 185 classes

##
gap> t:= CharacterTable( "O8-(3)" );
CharacterTable( "O8-(3)" )
gap> Length( Positions( OrdersClassRepresentatives( t ), 41 ) );
10

##
gap> possord:= 2^2 * 41 * DivisorsInt( 2 * 5 * 7^6 * 59 * 71 );;
gap> good:= Filtered( possord,
>                     x -> ( head.Size / x ) mod 41 = 1 );
[ 1640, 163016 ]
gap> List( good, Factors );
[ [ 2, 2, 2, 5, 41 ], [ 2, 2, 2, 7, 41, 71 ] ]

##
gap> Filtered( DivisorsInt( good[2] ), x -> x mod 71 = 1 );
[ 1 ]

##
gap> ExtendTableHeadByCentralizerOrder( head, 41, 41, fail );
#I  after order 41 element: have 186 classes

##
gap> possord:= 59 * DivisorsInt( 58*7^6*71 );;
gap> good:= Filtered( possord,
>                     x -> ( head.Size / x ) mod 59 = 1 );
[ 1711 ]
gap> List( good, Factors );
[ [ 29, 59 ] ]

##
gap> ExtendTableHeadByCentralizerOrder( head, 59, 59, fail );
#I  after order 59 element: have 187 classes
gap> ExtendTableHeadByCentralizerOrder( head, 59, 59, fail );
#I  after order 59 element: have 188 classes

##
gap> possord:= 71 * DivisorsInt( 70*7^5 );;
gap> good:= Filtered( possord,
>                     x -> ( head.Size / x ) mod 71 = 1 );
[ 2485 ]
gap> List( good, Factors );
[ [ 5, 7, 71 ] ]

##
gap> ExtendTableHeadByCentralizerOrder( head, 71, 71, fail );
#I  after order 71 element: have 189 classes
gap> ExtendTableHeadByCentralizerOrder( head, 71, 71, fail );
#I  after order 71 element: have 190 classes

##
gap> s:= CharacterTable( "2.B" );;
gap> pos:= Positions( OrdersClassRepresentatives( s ), 7 );
[ 41 ]
gap> ExtendTableHeadByPermCharValue( head, s, pi, pos );
#I  after order 7 element from 2.B: have 191 classes
gap> Last( head.SizesCentralizers ) = 7 * Size( CharacterTable( "He" ) );
true

##
gap> ExtendTableHeadByCentralizerOrder( head, 119, 119, fail );
#I  after order 119 element: have 192 classes
gap> ExtendTableHeadByCentralizerOrder( head, 119, 119, fail );
#I  after order 119 element: have 193 classes

##
gap> u:= CharacterTable( "3.Fi24" );;
gap> cand:= Filtered( Irr( u ), x -> x[1] <= 196883 );;
gap> rest:= Sum( cand{ [ 1, 4, 5, 7, 8 ] } );;
gap> pos:= Positions( OrdersClassRepresentatives( u ), 7 );
[ 41, 43 ]
gap> rest{ pos };
[ 50, 1 ]

##
gap> ExtendTableHeadByCentralizerOrder( head, u, 7^5 * Factorial(7), [ 43 ] );
#I  after order 7 element from 3.F3+.2: have 194 classes

##
gap> Sum( head.SizesCentralizers, x -> head.Size / x ) = head.Size;
true

##
gap> m:= ConvertToCharacterTableNC( rec(
>      UnderlyingCharacteristic:= 0,
>      Size:= head.Size,
>      SizesCentralizers:= head.SizesCentralizers,
>      OrdersClassRepresentatives:= head.OrdersClassRepresentatives,
>    ) );;

##
gap> safe_fusions:= Filtered( head.fusions,
>        r -> not IsIdenticalObj( r.subtable, facts[1] ) );;
gap> Length( safe_fusions );
6

##
gap> for r in safe_fusions do
>      fus:= InitFusion( r.subtable, m );
>      for i in [ 1 .. Length( r.map ) ] do
>        if IsBound( r.map[i] ) then
>          if IsInt( fus[i] ) then
>            if fus[i] <> r.map[i] then
>              Error( "fusion problem" );
>            fi;
>          elif IsInt( r.map[i] ) then
>            if not r.map[i] in fus[i] then
>              Error( "fusion problem" );
>            fi;
>          else
>            if not IsSubset( fus[i], r.map[i] ) then
>              Error( "fusion problem" );
>            fi;
>          fi;
>          fus[i]:= r.map[i];
>        fi;
>      od;
>      r.fus:= fus;
>    od;

##
gap> maxorder:= Maximum( head.OrdersClassRepresentatives );
119
gap> powermaps:= [];;
gap> primes:= Filtered( [ 1 .. maxorder ], IsPrimeInt );;
gap> for p in primes do
>      powermaps[p]:= InitPowerMap( m, p );
>      for r in safe_fusions do
>        subpowermap:= PowerMap( r.subtable, p );
>        if TransferDiagram( subpowermap, r.fus, powermaps[p] ) = fail then
>          Error( "inconsistency" );
>        fi;
>      od;
>    od;

##
gap> found:= true;;
gap> res:= "dummy";;  # avoid a syntax warning
gap> while found do
>      Print( "#I  start a round\n" );
>      found:= false;
>      for p in primes do
>        for r in safe_fusions do
>          subpowermap:= PowerMap( r.subtable, p );
>          res:= TransferDiagram( subpowermap, r.fus, powermaps[p] );
>          if res = fail then
>            Error( "inconsistency" );
>          elif ForAny( RecNames( res ), nam -> res.( nam ) <> [] ) then
>            found:= true;
>          fi;
>        od;
>      od;
>    od;
#I  start a round
#I  start a round
#I  start a round
#I  start a round

##
gap> pos:= PositionsProperty( powermaps[5], IsList );
[ 157, 158, 163, 164, 187, 188, 189, 190, 192, 193 ]
gap> head.OrdersClassRepresentatives{ pos };
[ 15, 15, 39, 39, 59, 59, 71, 71, 119, 119 ]

##
gap> u:= CharacterTable( "(7:3xHe):2" );;
gap> ConstructionInfoCharacterTable( u );
[ "ConstructIndexTwoSubdirectProduct", "7:3", "7:6", "He", "He.2", 
  [ 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 
      130, 131, 132, 133, 134, 135, 207, 208, 209, 210, 211, 212, 
      213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 
      225, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 
      308, 309, 310, 311, 312, 313, 314, 315 ], (), () ]
gap> pos:= Positions( OrdersClassRepresentatives( u ), 119 );
[ 52, 53 ]
gap> f:= Field( Rationals, List( Irr( u ), x -> x[pos[1]] ) );;
gap> Sqrt(-119) in f;
true

##
gap> for l in [ 59, 71, 119 ] do
>      val:= Sqrt( -l );
>      poss:= Positions( head.OrdersClassRepresentatives, l );
>      for p in primes do
>        if Gcd( l, p ) = 1 then
>          if GaloisCyc( val, p ) = val then
>            powermaps[p]{ poss }:= poss;
>          else
>            powermaps[p]{ poss }:= Reversed( poss );
>          fi;
>        fi;
>      od;
>    od;

##
gap> PositionsProperty( powermaps[17], IsList );
[ 163, 164 ]
gap> head.OrdersClassRepresentatives{ [ 163, 164 ] };
[ 39, 39 ]
gap> List( Filtered( head.fusions,
>                    r -> IsSubset( r.map, [ 163, 164 ] ) ),
>          r -> r.subtable );
[ CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" ) ]

##
gap> 78pos:= Positions( head.OrdersClassRepresentatives, 78 );
[ 37, 132, 133 ]
gap> head.fusions[1].subtable;
CharacterTable( "2.B" )
gap> Intersection( 78pos, head.fusions[1].map );
[ 37 ]
gap> s:= head.fusions[2].subtable;
CharacterTable( "2^1+24.Co1" )
gap> Intersection( 78pos, head.fusions[2].map );
[ 132, 133 ]
gap> Positions( head.fusions[2].map, 132 );
[ 342 ]
gap> Positions( head.fusions[2].map, 133 );
[ 344 ]
gap> PowerMap( s, 7 )[342];
344

##
gap> poss:= Filtered( head.fusions, r -> IsSubset( r.map, [ 163, 164 ] ) );;
gap> List( poss, r -> r.subtable );
[ CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" ) ]
gap> Position( poss[1].map, 163 );
173
gap> Position( poss[1].map, 164 );
174
gap> List( facts, s -> Positions( OrdersClassRepresentatives( s ), 39 ) );
[ [ 173, 174 ], [ 173, 174 ] ]
gap> List( facts, s -> PowerMap( s, 7 )[173] );
[ 174, 174 ]

##
gap> fields:= List( facts,
>                   s -> Field( Rationals, List( Irr( s ),
>                                                x -> x[173] ) ) );;
gap> Length( Set( fields ) );
1
gap> Sqrt(-39) in fields[1];
true

##
gap> val:= Sqrt( -39 );;
gap> poss:= [ 163, 164 ];;
gap> for p in primes do
>      if Gcd( 39, p ) = 1 then
>        if GaloisCyc( val, p ) = val then
>          powermaps[p]{ poss }:= poss;
>        else
>          powermaps[p]{ poss }:= Reversed( poss );
>        fi;
>      fi;
>    od;
gap> List( powermaps, Indeterminateness );
[ , 2048, 1536,, 4,, 2,,,, 2,, 9,,,, 1,, 1,,,, 1,,,,,, 1,, 1,,,,,, 1,,
  ,, 1,, 1,,,, 1,,,,,, 1,,,,,, 1,, 1,,,,,, 1,,,, 1,, 1,,,,,, 1,,,, 1,,
  ,,,, 1,,,,,,,, 1,,,, 1,, 1,,,, 1,, 1,,,, 1 ]

##
gap> r:= First( head.fusions, r -> IsIdenticalObj( r.subtable, facts[1] ) );;
gap> fus:= InitFusion( r.subtable, m );;
gap> for i in [ 1 .. Length( r.map ) ] do
>      if IsBound( r.map[i] ) then
>        if IsInt( fus[i] ) then
>          if fus[i] <> r.map[i] then
>            Error( "fusion problem" );
>          fi;
>        elif IsInt( r.map[i] ) then
>          if not r.map[i] in fus[i] then
>            Error( "fusion problem" );
>          fi;
>        else
>          if not IsSubset( fus[i], r.map[i] ) then
>            Error( "fusion problem" );
>          fi;
>        fi;
>        fus[i]:= r.map[i];
>      fi;
>    od;
gap> r.fus:= fus;;

##
gap> r2:= First( head2.fusions, r -> IsIdenticalObj( r.subtable, facts[2] ) );;
gap> fus2:= InitFusion( r2.subtable, m );;
gap> for i in [ 1 .. Length( r2.map ) ] do 
>      if IsBound( r2.map[i] ) then
>        if IsInt( fus2[i] ) then
>          if fus2[i] <> r2.map[i] then
>            Error( "fusion problem" );
>          fi;
>        elif IsInt( r2.map[i] ) then
>          if not r2.map[i] in fus2[i] then
>            Error( "fusion problem" );
>          fi;
>        else
>          if not IsSubset( fus2[i], r2.map[i] ) then
>            Error( "fusion problem" );
>          fi;
>        fi;
>        fus2[i]:= r2.map[i];
>      fi;
>    od;
gap> r2.fus:= fus2;;

##
gap> powermaps2:= StructuralCopy( powermaps );;
gap> s:= r.subtable;
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" )
gap> for p in primes do
>      if TransferDiagram( PowerMap( s, p ), fus, powermaps[p] ) = fail then
>        Error( "inconsistency" );
>      fi;
>    od;
gap> s2:= r2.subtable;
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 20 ]" )
gap> for p in primes do
>      if TransferDiagram( PowerMap( s2, p ), fus2, powermaps2[p] ) = fail then
>        Error( "inconsistency" );
>      fi;
>    od;
gap> powermaps = powermaps2;
true
gap> List( powermaps, Indeterminateness );
[ , 32, 64,, 1,, 1,,,, 1,, 1,,,, 1,, 1,,,, 1,,,,,, 1,, 1,,,,,, 1,,,, 
  1,, 1,,,, 1,,,,,, 1,,,,,, 1,, 1,,,,,, 1,,,, 1,, 1,,,,,, 1,,,, 1,,,,,
  , 1,,,,,,,, 1,,,, 1,, 1,,,, 1,, 1,,,, 1 ]

##
gap> powermaps[2]{ [ 132, 133 ] };
[ [ 163, 164 ], [ 163, 164 ] ]
gap> pos78:= List( facts,
>                  s -> Positions( OrdersClassRepresentatives( s ), 78 ) );
[ [ 235, 236 ], [ 235, 236 ] ]
gap> fus{ [ 235, 236 ] };
[ [ 132, 133 ], [ 132, 133 ] ]
gap> fus2{ [ 235, 236 ] };
[ [ 132, 133 ], [ 132, 133 ] ]

##
gap> fus[235]:= 132;;
gap> fus2[235]:= 132;;
gap> TransferDiagram( PowerMap( s, 2 ), fus, powermaps[2] ) <> fail;
true
gap> TransferDiagram( PowerMap( s2, 2 ), fus2, powermaps2[2] ) <> fail;
true
gap> powermaps = powermaps2;
true
gap> List( powermaps{ [ 2, 3 ] }, Indeterminateness );
[ 8, 64 ]

##
gap> powermaps[3]{ [ 163, 164 ] };
[ [ 183, 184 ], [ 183, 184 ] ]
gap> TransferDiagram( powermaps[2], powermaps[3], powermaps[2] ) <> fail;
true
gap> List( powermaps{ [ 2, 3 ] }, Indeterminateness );
[ 8, 16 ]

##
gap> poss:= Filtered( head.fusions,
>                     r -> 93 in OrdersClassRepresentatives( r.subtable ) );;
gap> List( poss, r -> r.subtable );
[ CharacterTable( "ThxSym(3)" ) ]
gap> pos93:= Positions( head.OrdersClassRepresentatives, 93 );
[ 152, 153 ]
gap> powermaps[3]{ pos93 };
[ [ 179, 180 ], [ 179, 180 ] ]
gap> powermaps[3][152]:= 179;;
gap> TransferDiagram( PowerMap( poss[1].subtable, 3 ), poss[1].fus,
>                     powermaps[3] ) <> fail;
true
gap> List( powermaps{ [ 2, 3 ] }, Indeterminateness );
[ 8, 4 ]

##
gap> poss:= Filtered( head.fusions, 
>                     r -> 69 in OrdersClassRepresentatives( r.subtable ) );;
gap> List( poss, r -> r.subtable );
[ CharacterTable( "3.F3+.2" ) ]
gap> pos69:= Positions( head.OrdersClassRepresentatives, 69 );
[ 142, 143 ]
gap> powermaps[3]{ pos69 };
[ [ 177, 178 ], [ 177, 178 ] ]
gap> powermaps[3]{ [ 142, 143 ] }:= [ 177, 178 ];;
gap> TransferDiagram( PowerMap( poss[1].subtable, 3 ), poss[1].fus,
>                     powermaps[3] ) <> fail;
true
gap> List( powermaps{ [ 2, 3 ] }, Indeterminateness );
[ 8, 1 ]

##
gap> pos46:= Positions( head.OrdersClassRepresentatives, 46 );
[ 26, 27, 118, 120 ]
gap> powermaps[2]{ pos46 };
[ 177, 178, [ 177, 178 ], [ 177, 178 ] ]
gap> powermaps[23]{ pos46 };
[ 2, 2, 44, 44 ]

##
gap> powermaps[2]{ [ 118, 120 ] }:= [ 177, 178 ];;
gap> Indeterminateness ( powermaps[2] );
2

##
gap> powermaps[2][78];
[ 155, 156 ]
gap> head.OrdersClassRepresentatives[78];
18
gap> head.SizesCentralizers[78];
3888

##
gap> Filtered( [ 1 .. Length( head.OrdersClassRepresentatives ) ],
>              i -> head.OrdersClassRepresentatives[i] = 18 and
>                   head.SizesCentralizers[i] = 3888 );
[ 78, 79 ]
gap> powermaps[3]{ [ 78, 79 ] };
[ 52, 52 ]
gap> powermaps[2][52];
154
gap> First( head.fusions, r -> 154 in r.map ).subtable;
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" )
gap> s:= facts[1];
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 19 ]" )
gap> pos18:= Filtered( [ 1 .. NrConjugacyClasses( s ) ],
>                i -> OrdersClassRepresentatives( s )[i] = 18 and
>                     SizesCentralizers( s )[i] = 3888 );
[ 67, 83 ]
gap> PowerMap( s, 2 ){ pos18 };
[ 24, 24 ]
gap> s:= facts[2];
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 20 ]" )
gap> pos18:= Filtered( [ 1 .. NrConjugacyClasses( s ) ],
>                i -> OrdersClassRepresentatives( s )[i] = 18 and
>                     SizesCentralizers( s )[i] = 3888 );
[ 67, 83 ]
gap> PowerMap( s, 2 ){ pos18 };
[ 24, 24 ]

##
gap> powermaps[2][78]:= powermaps[2][79];;
gap> for r in safe_fusions do
>      if not TestConsistencyMaps( ComputedPowerMaps( r.subtable ), r.fus,
>                                  powermaps ) then
>        Error( "inconsistent!" );
>      fi;
>    od;
gap> r:= First( head.fusions, r -> IsIdenticalObj( r.subtable, facts[1] ) );;
gap> TestConsistencyMaps( ComputedPowerMaps( r.subtable ), r.fus,
>                         powermaps );
true
gap> r2:= First( head2.fusions, r -> IsIdenticalObj( r.subtable, facts[2] ) );;
gap> TestConsistencyMaps( ComputedPowerMaps( r2.subtable ), r2.fus,
>                         powermaps );
true
gap> SetComputedPowerMaps( m, powermaps );

##
gap> r:= head.fusions[1];;
gap> s:= r.subtable;
CharacterTable( "2.B" )
gap> cand:= Filtered( Irr( s ), x -> x[1] <= 196883 );;
gap> List( cand, x -> x[1] );
[ 1, 4371, 96255, 96256 ]
gap> rest:= Sum( cand );;
gap> rest[1];
196883

##
gap> chi:= [];;
gap> map:= r.fus;;
gap> for i in [ 1 .. Length( map ) ] do
>      if IsInt( map[i] ) then
>        chi[ map[i] ]:= rest[i];
>      fi;
>    od;
gap> Number( chi );
111

##
gap> r:= head.fusions[3];;
gap> s:= r.subtable;
CharacterTable( "3.F3+.2" )
gap> cand:= Filtered( Irr( s ), x -> x[1] <= 196883 );;
gap> rest:= Sum( cand{ [ 1, 4, 5, 7, 8 ] } );;
gap> rest[1];
196883
gap> map:= r.fus;;
gap> for i in [ 1 .. Length( map ) ] do
>      if IsInt( map[i] ) then
>        if IsBound( chi[ map[i] ] ) and chi[ map[i] ] <> rest[i] then
>          Error( "inconsistency!" );
>        fi;
>        chi[ map[i] ]:= rest[i];
>      fi;
>    od;
gap> Number( chi );
140

##
gap> r:= head.fusions[2];;
gap> s:= r.subtable;
CharacterTable( "2^1+24.Co1" )
gap> cand:= Filtered( Irr( s ), x -> x[1] <= chi[1] );;
gap> map:= r.fus;;
gap> knownpos:= Filtered( [ 1 .. Length( map ) ],
>                      i -> IsInt( map[i] ) and IsBound( chi[ map[i] ] ) );;
gap> rest:= List( knownpos, i -> chi[ map[i] ] );;
gap> mat:= List( cand, x -> x{ knownpos } );;
gap> Length( mat );
13
gap> RankMat( mat );
13
gap> sol:= SolutionMat( mat, rest );
[ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ]
gap> rest:= sol * cand;;
gap> for i in [ 1 .. Length( map ) ] do
>      if IsInt( map[i] ) then chi[ map[i] ]:= rest[i]; fi;
>    od;
gap> Number( chi );
181

##
gap> missing:= Filtered( [ 1..194 ], i -> not IsBound( chi[i] ) );
[ 151, 152, 153, 160, 169, 170, 186, 187, 188, 189, 190, 192, 193 ]
gap> head.OrdersClassRepresentatives{ missing };
[ 57, 93, 93, 27, 95, 95, 41, 59, 59, 71, 71, 119, 119 ]
gap> head.SizesCentralizers{ missing };
[ 57, 93, 93, 243, 95, 95, 41, 59, 59, 71, 71, 119, 119 ]

##
gap> for i in missing do
>      ord:= head.OrdersClassRepresentatives[i];
>      divs:= PrimeDivisors( ord );
>      if ForAll( divs, p -> IsBound( chi[ powermaps[p][i] ] ) ) then
>        congr:= List( divs, p -> chi[ powermaps[p][i] ] mod p );
>        res:= ChineseRem( divs, congr );
>        modulus:= Lcm( divs );
>        c:= head.SizesCentralizers[i];
>        Print( "#I  |g| = ", head.OrdersClassRepresentatives[i],
>               ", |C_M(g)| = ", c,
>               ": value ", res, " modulo ", modulus, "\n" );
>        if ( res + 2 * modulus )^2 >= c and ( res - 2 * modulus )^2 >= c then
>          cand:= Filtered( res + [ -1 .. 1 ] * modulus, a -> a^2 < c );
>          if Length( cand ) = 1 then
>            chi[i]:= cand[1];
>          fi;
>        fi;
>      fi;
>    od;
#I  |g| = 57, |C_M(g)| = 57: value 56 modulo 57
#I  |g| = 93, |C_M(g)| = 93: value 92 modulo 93
#I  |g| = 93, |C_M(g)| = 93: value 92 modulo 93
#I  |g| = 27, |C_M(g)| = 243: value 2 modulo 3
#I  |g| = 95, |C_M(g)| = 95: value 0 modulo 95
#I  |g| = 95, |C_M(g)| = 95: value 0 modulo 95
#I  |g| = 41, |C_M(g)| = 41: value 1 modulo 41
#I  |g| = 59, |C_M(g)| = 59: value 0 modulo 59
#I  |g| = 59, |C_M(g)| = 59: value 0 modulo 59
#I  |g| = 71, |C_M(g)| = 71: value 0 modulo 71
#I  |g| = 71, |C_M(g)| = 71: value 0 modulo 71
#I  |g| = 119, |C_M(g)| = 119: value 118 modulo 119
#I  |g| = 119, |C_M(g)| = 119: value 118 modulo 119
gap> missing:= Filtered( [ 1..194 ], i -> not IsBound( chi[i] ) );
[ 160 ]

##
gap> diff:= Difference( [ 1 .. NrConjugacyClasses( m ) ], missing );;
gap> classes:= SizesConjugacyClasses( m );;
gap> sum:= Sum( diff, i -> classes[i] * chi[i] );
-6650349175263480459970863415322722279882752000000000
gap> chi[ missing[1] ]:= - sum / classes[ missing[1] ];
2

##
gap> r:= First( head.fusions, r -> IsIdenticalObj( r.subtable, facts[1] ) );;
gap> map:= r.fus;;
gap> knownpos:= Filtered( [ 1 .. Length( map ) ], i -> IsInt( map[i] ) );;
gap> rest:= List( knownpos, i -> chi[ map[i] ] );;
gap> cand:= Filtered( Irr( r.subtable ), x -> x[1] <= chi[1] );;
gap> mat:= List( cand, x -> x{ knownpos } );;
gap> Length( mat );
95
gap> RankMat( mat );
88
gap> SolutionMat( mat, rest );
fail

##
gap> r2:= First( head2.fusions, r -> IsIdenticalObj( r.subtable, facts[2] ) );;
gap> map:= r2.fus;;
gap> knownpos:= Filtered( [ 1 .. Length( map ) ], i -> IsInt( map[i] ) );;
gap> rest:= List( knownpos, i -> chi[ map[i] ] );;
gap> cand:= Filtered( Irr( r2.subtable ), x -> x[1] <= chi[1] );;
gap> mat:= List( cand, x -> x{ knownpos } );;
gap> Length( mat );
95
gap> RankMat( mat );
88
gap> SolutionMat( mat, rest );
[ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 1, 1, 1, 0 ]
gap> Add( safe_fusions, r2 );

##
gap> TransformingPermutationsCharacterTables( r2.subtable,
>        CharacterTable( "MN3B" ) ) <> fail;
true

##
gap> invs:= TransposedMat( [
>      OrdersClassRepresentatives( m ),
>      SizesCentralizers( m ),
>      chi,
>      CompositionMaps( chi, PowerMap( m, 2 ) ) ] );;
gap> invs_set:= Set( invs );;
gap> Length( invs_set );
172
gap> atlas_m:= CharacterTable( "M" );;
gap> invs_atlas:= TransposedMat( [
>      OrdersClassRepresentatives( atlas_m ),
>      SizesCentralizers( atlas_m ),
>      Irr( atlas_m )[2],
>      CompositionMaps( Irr( atlas_m )[2], PowerMap( atlas_m, 2 ) ) ] );;
gap> invs_atlas_set:= Set( invs_atlas );;
gap> invs_atlas_set = invs_set;
true

##
gap> pi1:= SortingPerm( invs );;
gap> pi2:= SortingPerm( invs_atlas );;
gap> pi:= pi2 / pi1 * (32,33)(179,180);;
gap> oracle:= List( Irr( atlas_m ), x -> Permuted( x, pi ) );;

##
gap> SetAutomorphismsOfTable( m, Group( () ) );

##
gap> r:= safe_fusions[1];;
gap> s:= r.subtable;
CharacterTable( "2.B" )
gap> pos:= [ 217, 218, 222, 223 ];;
gap> r.fus{ pos };
[ [ 110, 111 ], [ 110, 111 ], [ 88, 89 ], [ 88, 89 ] ]
gap> OrdersClassRepresentatives( s ){ pos };
[ 40, 40, 44, 44 ]

##
gap> r.fus[ PowerMap( s, 20 )[217] ];
44
gap> r2:= safe_fusions[2];;
gap> s2:= r2.subtable;
CharacterTable( "2^1+24.Co1" )
gap> Position( r2.map, 110 );
273
gap> ForAll( Irr( s2 ), x -> IsInt( x[273] ) );
false

##
gap> (217,218) in AutomorphismsOfTable( s );
true
gap> r.fus{ [ 217, 218 ] }:= [ 110, 111 ];;

##
gap> r.fus[ PowerMap( s, 22 )[ 222 ] ];
44
gap> Position( r2.map, 88 );
178
gap> ForAll( Irr( s2 ), x -> IsInt( x[178] ) );
false

##
gap> (143,144)(222,223)(244,245) in AutomorphismsOfTable( s );
true
gap> r.fus{ [ 143, 144, 244, 245 ] };
[ 15, 15, 34, 34 ]
gap> r.fus{ [ 222, 223 ] }:= [ 88, 89 ];;

##
gap> knownirr:= [ TrivialCharacter( m ), chi ];;
gap> poss:= PossibleClassFusions( s, m,
>               rec( chars:= knownirr, fusionmap:= r.fus ) );;
gap> List( poss, Indeterminateness );
[ 1 ]

##
gap> induced:= InducedClassFunctionsByFusionMap( s, m, Irr( s ), poss[1] );;

##
gap> poss:= PossibleClassFusions( s2, m,
>               rec( chars:= Concatenation( knownirr, induced ),
>                    fusionmap:= r2.fus ) );;
gap> List( poss, Indeterminateness );
[ 1, 1, 1, 1 ]
gap> Length( RepresentativesFusions( AutomorphismsOfTable( s2 ), poss,
>                Group( () ) ) );
1
gap> Append( induced,
>        InducedClassFunctionsByFusionMap( s2, m, Irr( s2 ), poss[1] ) );

##
gap> r:= safe_fusions[7];;
gap> s:= r.subtable;
CharacterTable( "3^(1+12):6.Suz.2/[ 1, 20 ]" )
gap> pos:= Positions( OrdersClassRepresentatives( s ), 56 );
[ 250, 251 ]
gap> r.fus{ pos };
[ [ 125, 126 ], [ 125, 126 ] ]
gap> r.fus[ PowerMap( s, 28 )[ 250 ] ];
44
gap> Position( r2.map, 125 );
319
gap> ForAll( Irr( s2 ), x -> IsInt( x[319] ) );
false
gap> (250, 251) in AutomorphismsOfTable( s );
true
gap> r.fus{ [ 250, 251 ] }:= [ 125, 126 ];;

##
gap> poss:= PossibleClassFusions( s, m,
>               rec( chars:= Concatenation( knownirr, induced ),
>                    fusionmap:= r.fus ) );;
gap> List( poss, Indeterminateness );
[ 1, 1 ]
gap> Length( RepresentativesFusions( AutomorphismsOfTable( s ), poss,
>                Group( () ) ) );
1
gap> Append( induced,
>        InducedClassFunctionsByFusionMap( s, m, Irr( s ), poss[1] ) );

##
gap> r:= safe_fusions[3];;
gap> s:= r.subtable;
CharacterTable( "3.F3+.2" )
gap> poss:= PossibleClassFusions( s, m,
>               rec( chars:= Concatenation( knownirr, induced ),
>                    fusionmap:= r.fus ) );;
gap> List( poss, Indeterminateness );
[ 1 ]
gap> Append( induced,
>        InducedClassFunctionsByFusionMap( s, m, Irr( s ), poss[1] ) );

##
gap> Append( induced,
>      InducedCyclic( m, [ 2 .. NrConjugacyClasses( m ) ], "all" ) );

##
gap> red:= Reduced( m, knownirr, induced );;
gap> Length( red.irreducibles );
0
gap> lll:= LLL( m, red.remainders );;
gap> Length( lll.irreducibles );
4

##
gap> knownirr:= Union( knownirr, lll.irreducibles );;
gap> red:= Reduced( m, knownirr, induced );;
gap> Length( red.irreducibles );
0
gap> lll:= LLL( m, red.remainders );;
gap> Length( lll.irreducibles );
0

##
gap> mat:= MatScalarProducts( m, oracle, lll.remainders );;
gap> norm:= NormalFormIntMat( mat, 4 );;
gap> rowtrans:= norm.rowtrans;;
gap> normal:= norm.normal{ [ 1 .. norm.rank ] };;
gap> one:= IdentityMat( NrConjugacyClasses( m ) );;
gap> for i in [ 2 .. Length( one ) ] do
>      extmat:= Concatenation( normal, [ one[i] ] );
>      extlen:= Length( extmat );
>      extnorm:= NormalFormIntMat( extmat, 4 );
>      if extnorm.rank = Length( extnorm.normal ) or
>         extnorm.rowtrans[ extlen ][ extlen ] <> 1 then
>        coeffs:= fail;
>      else
>        coeffs:= - extnorm.rowtrans[ extlen ]{ [ 1 .. extnorm.rank ] }
>                   * rowtrans{ [ 1 .. extnorm.rank ] };
>      fi;
>      if coeffs <> fail and ForAll( coeffs, IsInt ) then
>        # The vector lies in the lattice.
>        chi:= coeffs * lll.remainders;
>        if not chi in knownirr then
>          Add( knownirr, chi );
>        fi;
>      fi;
>    od;
gap> Length( knownirr );
66
gap> Set( knownirr, chi -> ScalarProduct( m, chi, chi ) );
[ 1 ]

##
gap> red:= Reduced( m, knownirr, lll.remainders );;
gap> Length( red.irreducibles );
0
gap> sym:= Symmetrizations( m, knownirr, 2 );;
gap> sym:= Reduced( m, knownirr, sym );;
gap> Length( sym.irreducibles );
0
gap> lll:= LLL( m, Concatenation( red.remainders, sym.remainders ) );;
gap> Length( lll.irreducibles );
0

##
gap> mat:= MatScalarProducts( m, oracle, lll.remainders );;
gap> norm:= NormalFormIntMat( mat, 4 );;
gap> rowtrans:= norm.rowtrans;;
gap> normal:= norm.normal{ [ 1 .. norm.rank ] };;
gap> one:= IdentityMat( NrConjugacyClasses( m ) );;
gap> for i in [ 2 .. Length( one ) ] do
>      extmat:= Concatenation( normal, [ one[i] ] );
>      extlen:= Length( extmat );
>      extnorm:= NormalFormIntMat( extmat, 4 );
>      if extnorm.rank = Length( extnorm.normal ) or
>         extnorm.rowtrans[ extlen ][ extlen ] <> 1 then
>        coeffs:= fail;
>      else
>        coeffs:= - extnorm.rowtrans[ extlen ]{ [ 1 .. extnorm.rank ] }
>                   * rowtrans{ [ 1 .. extnorm.rank ] };
>      fi;
>      if coeffs <> fail and ForAll( coeffs, IsInt ) then
>        Add( knownirr, coeffs * lll.remainders );
>      fi;
>    od;
gap> Length( knownirr );
194

##
gap> SetIrr( m, List( knownirr, x -> ClassFunction( m, x ) ) );
gap> ResetFilterObj( m, HasAutomorphismsOfTable );
gap> TransformingPermutationsCharacterTables( m, atlas_m ) <> fail;
true

##
gap> info:= OneAtlasGeneratingSetInfo( "3^(1+12):6.Suz.2", Dimension, 38 );;
gap> gens:= AtlasGenerators( info ).generators;;
gap> Length( gens );
4
gap> ForAll( gens,
>            m -> ForAll( [ 25 .. 38 ],
>                         i -> ForAll( [ 1 .. 24 ],
>                                      j -> IsZero( m[i,j] ) and
>                                           IsZero( m[i,j] ) ) ) );
true

##
gap> mats:= List( gens, x -> x{ [ 25 .. 38 ] }{ [ 25 .. 38 ] } );;
gap> List( mats, ConvertToMatrixRep );;
gap> Comm( mats[3], mats[3]^mats[2] ) = Inverse( mats[4] );
true
gap> mats:= mats{ [ 1 .. 3 ] };;

##
gap> G:= GroupWithGenerators( mats );;
gap> orbs:= ShallowCopy( OrbitsDomain( G, GF(3)^14 ) );;
gap> Length( orbs );
6
gap> SortBy( orbs, Length );
gap> List( orbs, Length );
[ 1, 2, 196560, 1397760, 1594323, 1594323 ]
gap> v:= [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 ] * Z(3)^0;;
gap> orb_large:= First( orbs, x -> v in x );;
gap> Length( orb_large );
1594323
gap> Length( orb_large ) = 3^13;
true
gap> orb_large:= SortedList( orb_large );;
gap> homHtoHmodX:= ActionHomomorphism( G, orb_large );;
gap> represHmodX:= Image( homHtoHmodX );;
gap> Size( represHmodX );
2859230155080499200
gap> Size( represHmodX ) = Size( CharacterTable( "2.Suz.2" ) ) * 3^13;
true

##
gap> gensHmodX:= List( mats, m -> m^homHtoHmodX );;
gap> n:= NormalClosure( represHmodX,
>                       Subgroup( represHmodX, [ gensHmodX[3] ] ) );;
gap> Size( n ) = 3^13;
true
gap> IsAbelian( n );
false

##
gap> slp:= AtlasProgram( "Suz.2", "check" );;
gap> prog:= StraightLineProgramFromStraightLineDecision( slp.program );;
gap> res:= ResultOfStraightLineProgram( prog, gensHmodX );;
gap> List( res, Order );
[ 2, 1, 2, 1 ]
gap> ForAll( gensHmodX{ [ 1, 2 ] }, x -> ForAll( res, y -> x*y = y*x ) );
true
gap> Order( gensHmodX[2] );
3

##
gap> 3suz2:= OneAtlasGeneratingSet( "3.Suz.2", NrMovedPoints, 5346 );;
gap> 3suz2:= 3suz2.generators;;
gap> omega:= [ 1 .. LargestMovedPoint( 3suz2 ) ];;
gap> shifted:= omega + LargestMovedPoint( gensHmodX );;
gap> pi:= MappingPermListList( omega, shifted );;
gap> shiftedgens:= List( 3suz2, x -> x^pi );;
gap> Append( shiftedgens, [ () ] );
gap> gensH:= List( [ 1 .. 3 ], i -> gensHmodX[i] * shiftedgens[i] );;
gap> NrMovedPoints( gensH );
1599669

##
gap> Order( gensH[2] );
3
gap> Order( Product( gensH{ [ 1, 2, 1, 2, 2 ] } ) );
7

##
gap> H:= GroupWithGenerators( gensH );;
gap> if CTblLib.IsMagmaAvailable() then
>      mgmt:= CharacterTableComputedByMagma( H, "H_Magma" );
>    else
>      mgmt:= CharacterTable( "3^(1+12):6.Suz.2" );
>    fi;

##
gap> IsRecord( TransformingPermutationsCharacterTables( mgmt,
>        CharacterTable( "3^(1+12):6.Suz.2" ) ) );
true

##
gap> g:= AtlasGroup( "5^(1+6):2.J2.4" );;
gap> if CTblLib.IsMagmaAvailable() then
>      mgmt:= CharacterTableComputedByMagma( g, "MN5B_Magma" );
>    else
>      mgmt:= CharacterTable( "5^(1+6):2.J2.4" );
>    fi;
gap> IsRecord( TransformingPermutationsCharacterTables( mgmt,
>        CharacterTable( "5^(1+6):2.J2.4" ) ) );
true

##
gap> STOP_TEST( "ctblm.tst" );

#############################################################################
##
#E

