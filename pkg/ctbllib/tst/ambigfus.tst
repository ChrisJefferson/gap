# This file was created automatically, do not edit!
#############################################################################
##
#W  ambigfus.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "ambigfus.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "ambigfus.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/ambigfus.xml (40-43)
gap> LoadPackage( "ctbllib", false );
true

##  doc2/ambigfus.xml (68-79)
gap> SetOfComposedClassFusions:= function( hfusg, ufush )
>     local result, map1, map2;
>     result:= [];;
>     for map2 in hfusg do
>       for map1 in ufush do
>         AddSet( result, CompositionMaps( map2, map1 ) );
>       od;
>     od;
>     return result;
> end;;

##  doc2/ambigfus.xml (105-113)
gap> co3:= CharacterTable( "Co3" );
CharacterTable( "Co3" )
gap> h:= CharacterTable( "Co3N5" );
CharacterTable( "5^(1+2):(24:2)" )
gap> hfusco3:= PossibleClassFusions( h, co3 );;
gap> Length( RepresentativesFusions( h, hfusco3, co3 ) );
2

##  doc2/ambigfus.xml (123-132)
gap> mx:= Maxes( co3 );
[ "McL.2", "HS", "U4(3).(2^2)_{133}", "M23", "3^5:(2xm11)", 
  "2.S6(2)", "U3(5).3.2", "3^1+4:4s6", "2^4.a8", "L3(4).D12", 
  "2xm12", "2^2.[2^7*3^2].S3", "s3xpsl(2,8).3", "a4xs5" ]
gap> maxes:= List( mx, CharacterTable );;
gap> filt:= Filtered( maxes, x -> Size( x ) mod Size( h ) = 0 );
[ CharacterTable( "McL.2" ), CharacterTable( "HS" ), 
  CharacterTable( "U3(5).3.2" ) ]

##  doc2/ambigfus.xml (155-165)
gap> max:= filt[1];;
gap> hfusmax:= PossibleClassFusions( h, max );;
gap> maxfusco3:= PossibleClassFusions( max, co3 );;
gap> comp:= SetOfComposedClassFusions( maxfusco3, hfusmax );;
gap> Length( comp );
2
gap> reps:= RepresentativesFusions( h, comp, co3 );
[ [ 1, 2, 3, 4, 8, 8, 7, 9, 10, 11, 17, 17, 19, 19, 22, 23, 27, 27, 
      30, 33, 34, 40, 40, 40, 40, 42 ] ]

##  doc2/ambigfus.xml (180-188)
gap> max:= filt[3];;
gap> hfusmax:= PossibleClassFusions( h, max );;
gap> maxfusco3:= PossibleClassFusions( max, co3 );;
gap> comp:= SetOfComposedClassFusions( maxfusco3, hfusmax );;
gap> reps2:= RepresentativesFusions( h, comp, co3 );;
gap> reps2 = reps;
true

##  doc2/ambigfus.xml (197-200)
gap> GetFusionMap( h, co3 ) in reps;
true

##  doc2/ambigfus.xml (214-220)
gap> b:= CharacterTable( "B" );;
gap> h:= CharacterTable( "31:15" );;
gap> hfusb:= PossibleClassFusions( h, b );;
gap> Length( RepresentativesFusions( h, hfusb, b ) );
2

##  doc2/ambigfus.xml (229-241)
gap> th:= CharacterTable( "Th" );;
gap> hfusth:= PossibleClassFusions( h, th );;
gap> thfusb:= PossibleClassFusions( th, b );;
gap> comp:= SetOfComposedClassFusions( thfusb, hfusth );;
gap> Length( comp );
2
gap> reps:= RepresentativesFusions( h, comp, b );
[ [ 1, 145, 146, 82, 82, 19, 82, 7, 19, 82, 82, 19, 7, 82, 19, 82, 82 
     ] ]
gap> GetFusionMap( h, b ) in reps;
true

##  doc2/ambigfus.xml (256-264)
gap> h:= CharacterTable( "SuzN3" );
CharacterTable( "3^5:(3^2:SD16)" )
gap> suz:= CharacterTable( "Suz" );
CharacterTable( "Suz" )
gap> hfussuz:= PossibleClassFusions( h, suz );;
gap> Length( RepresentativesFusions( h, hfussuz, suz ) );
2

##  doc2/ambigfus.xml (273-278)
gap> maxes:= List( Maxes( suz ), CharacterTable );;
gap> filt:= Filtered( maxes, x -> Size( x ) mod Size( h ) = 0 );
[ CharacterTable( "3_2.U4(3).2_3'" ), CharacterTable( "3^5:M11" ), 
  CharacterTable( "3^2+4:2(2^2xa4)2" ) ]

##  doc2/ambigfus.xml (286-289)
gap> PossibleClassFusions( h, filt[1] );
[  ]

##  doc2/ambigfus.xml (302-311)
gap> max:= filt[2];;
gap> hfusmax:= PossibleClassFusions( h, max );;
gap> maxfussuz:= PossibleClassFusions( max, suz );;
gap> comp:= SetOfComposedClassFusions( maxfussuz, hfusmax );;
gap> repr:= RepresentativesFusions( h, comp, suz );
[ [ 1, 2, 2, 4, 5, 4, 5, 5, 5, 5, 5, 6, 9, 9, 14, 15, 13, 16, 16, 14, 
      15, 13, 13, 13, 16, 15, 14, 16, 16, 16, 21, 21, 23, 22, 29, 29, 
      29, 38, 39 ] ]

##  doc2/ambigfus.xml (320-323)
gap> GetFusionMap( h, suz ) in repr;
true

##  doc2/ambigfus.xml (337-343)
gap> f3p:= CharacterTable( "F3+" );;
gap> h:= CharacterTable( "F3+N5" );;
gap> hfusf3p:= PossibleClassFusions( h, f3p );;
gap> Length( RepresentativesFusions( h, hfusf3p, f3p ) );
2

##  doc2/ambigfus.xml (352-371)
gap> maxes:= List( Maxes( f3p ), CharacterTable );;
gap> filt:= Filtered( maxes, x -> Size( x ) mod Size( h ) = 0 );
[ CharacterTable( "Fi23" ), CharacterTable( "2.Fi22.2" ), 
  CharacterTable( "(3xO8+(3):3):2" ), CharacterTable( "O10-(2)" ), 
  CharacterTable( "(A4xO8+(2).3).2" ), CharacterTable( "He.2" ), 
  CharacterTable( "F3+M14" ), CharacterTable( "(A5xA9):2" ) ]
gap> possfus:= List( filt, x -> PossibleClassFusions( h, x ) );
[ [  ], [  ], [  ], [  ], 
  [ [ 1, 69, 110, 12, 80, 121, 4, 72, 113, 11, 11, 79, 79, 120, 120, 
          3, 71, 11, 79, 23, 91, 112, 120, 132, 29, 32, 97, 100, 37, 
          37, 105, 105, 139, 140, 145, 146, 155, 155, 156, 156, 44, 
          44, 167, 167, 48, 48, 171, 171, 57, 57, 180, 180, 66, 66, 
          189, 189 ], 
      [ 1, 69, 110, 12, 80, 121, 4, 72, 113, 11, 11, 79, 79, 120, 
          120, 3, 71, 11, 79, 23, 91, 112, 120, 132, 29, 32, 97, 100, 
          37, 37, 105, 105, 140, 139, 146, 145, 156, 156, 155, 155, 
          44, 44, 167, 167, 48, 48, 171, 171, 57, 57, 180, 180, 66, 
          66, 189, 189 ] ], [  ], [  ], [  ] ]

##  doc2/ambigfus.xml (384-397)
gap> max:= filt[5];
CharacterTable( "(A4xO8+(2).3).2" )
gap> hfusmax:= possfus[5];;
gap> maxfusf3p:= PossibleClassFusions( max, f3p );;
gap> comp:= SetOfComposedClassFusions( maxfusf3p, hfusmax );;
gap> Length( comp );
2
gap> repr:= RepresentativesFusions( h, comp, f3p );
[ [ 1, 2, 4, 12, 35, 54, 3, 3, 16, 9, 9, 11, 11, 40, 40, 2, 3, 9, 11, 
      35, 36, 13, 40, 90, 7, 22, 19, 20, 43, 43, 50, 50, 8, 8, 23, 
      23, 46, 46, 47, 47, 10, 10, 9, 9, 10, 10, 11, 11, 26, 26, 28, 
      28, 67, 67, 68, 68 ] ]

##  doc2/ambigfus.xml (405-408)
gap> GetFusionMap( h, f3p ) in repr;
true

##  doc2/ambigfus.xml (494-502)
gap> b:= CharacterTable( "B" );
CharacterTable( "B" )
gap> h:= CharacterTable( "BN7" );
CharacterTable( "BN7" )
gap> hfusb:= PossibleClassFusions( h, b );;
gap> Length( RepresentativesFusions( h, hfusb, b ) );
2

##  doc2/ambigfus.xml (523-530)
gap> Number( Factors( Size( b ) ), x -> x = 7 );
2
gap> th:= CharacterTable( "Th" );
CharacterTable( "Th" )
gap> Filtered( Maxes( th ), x -> Size( CharacterTable( x ) ) mod 7^2 = 0 );
[ "3D4(2).3", "7^2:(3x2S4)" ]

##  doc2/ambigfus.xml (539-546)
gap> thn7:= CharacterTable( "ThN7" );
CharacterTable( "7^2:(3x2S4)" )
gap> comp:= SetOfComposedClassFusions( PossibleClassFusions( th, b ),
>               PossibleClassFusions( thn7, th ) );
[ [ 1, 31, 7, 7, 5, 28, 28, 17, 72, 72, 6, 6, 7, 28, 27, 27, 109, 
      109, 17, 45, 45, 72, 72, 127, 127, 127, 127 ] ]

##  doc2/ambigfus.xml (555-561)
gap> thn7fush:= PossibleClassFusions( thn7, h );;
gap> filt:= Filtered( hfusb, x ->
>               ForAny( thn7fush, y -> CompositionMaps( x, y ) in comp ) );;
gap> Length( RepresentativesFusions( h, filt, b ) );
1

##  doc2/ambigfus.xml (570-573)
gap> GetFusionMap( h, b ) in filt;
true

##  doc2/ambigfus.xml (588-595)
gap> m:= CharacterTable( "(A4xO8+(2).3).2" );;
gap> t:= CharacterTable( "F3+" );;
gap> mfust:= PossibleClassFusions( m, t );;
gap> repr:= RepresentativesFusions( m, mfust, t );;
gap> Length( repr );
2

##  doc2/ambigfus.xml (604-614)
gap> a4inm:= Filtered( ClassPositionsOfNormalSubgroups( m ),
>                      n -> Sum( SizesConjugacyClasses( m ){ n } ) = 12 );
[ [ 1, 69, 110 ] ]
gap> OrdersClassRepresentatives( m ){ a4inm[1] };
[ 1, 2, 3 ]
gap> List( repr, map -> map[110] );
[ 4, 4 ]
gap> OrdersClassRepresentatives( t ){ [ 1 .. 4 ] };
[ 1, 2, 2, 3 ]

##  doc2/ambigfus.xml (624-627)
gap> s:= CharacterTable( "F3+N3A" );
CharacterTable( "(3xO8+(3):3):2" )

##  doc2/ambigfus.xml (641-657)
gap> u:= CharacterTable( "Cyclic", 3 ) * CharacterTable( "O8+(2).3" );
CharacterTable( "C3xO8+(2).3" )
gap> ufuss:= PossibleClassFusions( u, s );;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> comp:= SetOfComposedClassFusions( sfust, ufuss );;
gap> Length( comp );
6
gap> filt:= Filtered( mfust,
>     x -> ForAny( ufusm, map -> CompositionMaps( x, map ) in comp ) );;
gap> repr:= RepresentativesFusions( m, filt, t );;
gap> Length( repr );
1
gap> GetFusionMap( m, t ) in repr;
true

##  doc2/ambigfus.xml (676-682)
gap> m:= CharacterTable( "A6xL2(8):3" );;
gap> t:= CharacterTable( "F3+" );;
gap> mfust:= PossibleClassFusions( m, t );;
gap> Length( RepresentativesFusions( m, mfust, t ) );
2

##  doc2/ambigfus.xml (692-705)
gap> dppos:= ClassPositionsOfDirectProductDecompositions( m );
[ [ [ 1, 12 .. 67 ], [ 1 .. 11 ] ] ]
gap> List( dppos[1], l -> Sum( SizesConjugacyClasses( t ){ l } ) );
[ 17733424133316996808705, 4545066196775803392 ]
gap> List( dppos[1], l -> Sum( SizesConjugacyClasses( m ){ l } ) );
[ 360, 1512 ]
gap> 3Apos:= Position( OrdersClassRepresentatives( t ), 3 );
4
gap> 3Ainm:= List( mfust, map -> Position( map, 3Apos ) );
[ 23, 23, 23, 23, 34, 34, 34, 34 ]
gap> ForAll( 3Ainm, x -> x in dppos[1][1] );
true

##  doc2/ambigfus.xml (723-739)
gap> u:= CharacterTable( "3^2:2" ) * CharacterTable( "L2(8).3" );
CharacterTable( "3^2:2xL2(8).3" )
gap> s:= CharacterTable( "F3+N3A" );
CharacterTable( "(3xO8+(3):3):2" )
gap> ufuss:= PossibleClassFusions( u, s );;
gap> comp:= SetOfComposedClassFusions( sfust, ufuss );;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> filt:= Filtered( mfust,
>               map -> ForAny( ufusm,
>                          map2 -> CompositionMaps( map, map2 ) in comp ) );;
gap> repr:= RepresentativesFusions( m, filt, t );;
gap> Length( repr );
1
gap> GetFusionMap( m, t ) in repr;
true

##  doc2/ambigfus.xml (776-784)
gap> b:= CharacterTable( "B" );;
gap> n:= CharacterTable( "BN3A" );
CharacterTable( "S3xFi22.2" )
gap> nfusb:= PossibleClassFusions( n, b );;
gap> Length( nfusb );
1
gap> nfusb:= nfusb[1];;

##  doc2/ambigfus.xml (794-804)
gap> fi222:= CharacterTable( "Fi22.2" );;
gap> fi222n3a:= CharacterTable( "S3xU4(3).(2^2)_{122}" );;
gap> s3:= CharacterTable( "S3" );;
gap> inter:= s3 * fi222n3a;;
gap> intermods3fusnmods3:= PossibleClassFusions( fi222n3a, fi222 );;
gap> Length( intermods3fusnmods3 );
2
gap> Length( RepresentativesFusions( fi222n3a, intermods3fusnmods3, fi222 ) );
1

##  doc2/ambigfus.xml (819-827)
gap> interfusn:= CompositionMaps( InverseMap( GetFusionMap( n, fi222 ) ),
>        CompositionMaps( intermods3fusnmods3[1],
>            GetFusionMap( inter, fi222n3a ) ) );;
gap> interfusn:= PossibleClassFusions( inter, n,
>        rec( fusionmap:= interfusn, quick:= true ) );;
gap> Length( interfusn );
1

##  doc2/ambigfus.xml (840-845)
gap> nccl:= NrConjugacyClasses( fi222 );;
gap> interfusn[1] = Concatenation( List( [ 0 .. 2 ],
>                       i -> intermods3fusnmods3[1] + i * nccl ) );
true

##  doc2/ambigfus.xml (854-862)
gap> tblg:= CharacterTable( "BM14" );
CharacterTable( "(3^2:D8xU4(3).2^2).2" )
gap> interfusg:= PossibleClassFusions( inter, tblg );;
gap> Length( interfusg );
2
gap> Length( RepresentativesFusions( inter, interfusg, tblg ) );
1

##  doc2/ambigfus.xml (874-885)
gap> interfusb:= CompositionMaps( nfusb, interfusn[1] );;
gap> approx:= List( interfusg,
>        map -> CompositionMaps( interfusb, InverseMap( map ) ) );;
gap> gfusb:= Set( Concatenation( List( approx,
>                     map -> PossibleClassFusions( tblg, b,
>                                rec( fusionmap:= map ) ) ) ) );;
gap> Length( gfusb );
4
gap> Length( RepresentativesFusions( tblg, gfusb, b ) );
1

##  doc2/ambigfus.xml (894-897)
gap> GetFusionMap( tblg, b ) in gfusb;
true

##  doc2/ambigfus.xml (912-918)
gap> tblu:= CharacterTable( "7^(1+4):(3x2.S7)" );;
gap> m:= CharacterTable( "M" );;
gap> ufusm:= PossibleClassFusions( tblu, m );;
gap> Length( RepresentativesFusions( tblu, ufusm, m ) );
2

##  doc2/ambigfus.xml (938-951)
gap> LoadPackage( "atlasrep", false );
true
gap> g1:= AtlasGroup( "7^(2+1+2):GL2(7)" );;
gap> s1:= SylowSubgroup( g1, 7 );;
gap> n1:= Normalizer( g1, s1 );;
gap> g2:= AtlasGroup( "7^(1+4):(3x2.S7)" );;
gap> s2:= SylowSubgroup( g2, 7 );;
gap> n2:= Normalizer( g2, s2 );;
gap> Size( n1 ) = Size( n2 );
true
gap> ( Size( m ) / Size( s1 ) ) mod 7 <> 0;
true

##  doc2/ambigfus.xml (969-980)
gap> tbln:= CharacterTable( Image( IsomorphismPcGroup( n1 ) ) );;
gap> tbls:= CharacterTable( "7^(2+1+2):GL2(7)" );;
gap> nfusm:= PossibleClassFusions( tbln, m );;
gap> Length( RepresentativesFusions( tbln, nfusm, m ) );
2
gap> nfuss:= PossibleClassFusions( tbln, tbls );;
gap> sfusm:= PossibleClassFusions( tbls, m );;
gap> nfusm:= SetOfComposedClassFusions( sfusm, nfuss );;
gap> Length( nfusm );
1

##  doc2/ambigfus.xml (991-997)
gap> nfusu:= PossibleClassFusions( tbln, tblu );;
gap> ufusm:= Filtered( ufusm, map2 -> ForAny( nfusu, 
>        map1 -> CompositionMaps( map2, map1 ) in nfusm ) );;
gap> Length( RepresentativesFusions( tblu, ufusm, m ) );
1

##  doc2/ambigfus.xml (1013-1023)
gap> tblc:= CharacterTable( "MC7B" );                             
CharacterTable( "7^1+4.2A7" )
gap> cfusm:= PossibleClassFusions( tblc, m );;             
gap> Length( RepresentativesFusions( tblc, cfusm, m ) );
2
gap> cfusu:= PossibleClassFusions( tblc, tblu );;
gap> cfusm:= SetOfComposedClassFusions( ufusm, cfusu );;
gap> Length( RepresentativesFusions( tblc, cfusm, m ) );
1

##  doc2/ambigfus.xml (1039-1045)
gap> m:= CharacterTable( "3^7.O7(3):2" );;
gap> t:= CharacterTable( "F3+.2" );;
gap> mfust:= PossibleClassFusions( m, t );;
gap> Length( RepresentativesFusions( m, mfust, t ) );
2

##  doc2/ambigfus.xml (1055-1066)
gap> nsg:= ClassPositionsOfNormalSubgroups( m );
[ [ 1 ], [ 1 .. 4 ], [ 1 .. 158 ], [ 1 .. 291 ] ]
gap> Sum( SizesConjugacyClasses( m ){ nsg[2] } );
2187
gap> 3^7;
2187
gap> rest:= Set( mfust, map -> map{ nsg[2] } );
[ [ 1, 4, 5, 6 ] ]
gap> List( rest, l -> ClassNames( t, "Atlas" ){ l } );
[ [ "1A", "3A", "3B", "3C" ] ]

##  doc2/ambigfus.xml (1077-1086)
gap> s:= CharacterTable( "F3+.2N3A" );
CharacterTable( "S3xO8+(3):S3" )
gap> PowerMap( m, 2 )[4];
4
gap> size_u:= 2 * SizesCentralizers( m )[ 2 ];
53059069440
gap> Size( s ) / size_u;
3360

##  doc2/ambigfus.xml (1099-1107)
gap> o8p3:= CharacterTable( "O8+(3)" );;
gap> mx:= List( Maxes( o8p3 ), CharacterTable );;
gap> filt:= Filtered( mx, x -> 3360 mod Index( o8p3, x ) = 0 );
[ CharacterTable( "3^6:L4(3)" ), CharacterTable( "O8+(3)M8" ), 
  CharacterTable( "O8+(3)M9" ) ]
gap> List( filt, x -> Index( o8p3, x ) );
[ 1120, 1120, 1120 ]

##  doc2/ambigfus.xml (1119-1141)
gap> uu:= filt[1];;
gap> u:= CharacterTable( "Symmetric", 3 ) * uu;
CharacterTable( "Sym(3)x3^6:L4(3)" )
gap> uufusm:= PossibleClassFusions( uu, m );;
gap> Length( uufusm );
8
gap> approx:= List( uufusm, map -> CompositionMaps( map,
>                   InverseMap( GetFusionMap( uu, u ) ) ) );;
gap> ufusm:= Concatenation( List( approx, map ->
>        PossibleClassFusions( u, m, rec( fusionmap:= map ) ) ) );;
gap> Length( ufusm );
8
gap> uufuss:= PossibleClassFusions( uu, s );;
gap> Length( uufuss );
8
gap> approx:= List( uufuss, map -> CompositionMaps( map,
>              InverseMap( GetFusionMap( uu, u ) ) ) );;
gap> ufuss:= Concatenation( List( approx, map ->
>   PossibleClassFusions( u, s, rec( fusionmap:= map ) ) ) );;
gap> Length( ufuss );
8

##  doc2/ambigfus.xml (1151-1156)
gap> sfust:= PossibleClassFusions( s, t );;
gap> comp:= SetOfComposedClassFusions( sfust, ufuss );;
gap> Length( comp );
8

##  doc2/ambigfus.xml (1165-1172)
gap> filt:= Filtered( mfust, map2 -> ForAny( ufusm, map1 ->
>        CompositionMaps( map2, map1 ) in comp ) );;
gap> Length( filt );
4
gap> Length( RepresentativesFusions( m, filt, t ) );
1

##  doc2/ambigfus.xml (1180-1183)
gap> GetFusionMap( m, t ) in filt;
true

##  doc2/ambigfus.xml (1200-1216)
gap> t:= CharacterTable( "2E6(2)" );;
gap> pos3CinG:= Position( ClassNames( t ), "3c" );
7
gap> n:= CharacterTable( "2E6(2)N3C" );;
gap> nclasses:= SizesConjugacyClasses( n );;
gap> pos3CinN:= Filtered( [ 1 .. NrConjugacyClasses( n ) ],
>                         i -> nclasses[i] = 2 );
[ 2 ]
gap> nfust:= PossibleClassFusions( n, t );;
gap> ForAll( nfust, x -> x[ pos3CinN[1] ] = pos3CinG );
true
gap> Size( n ) = 2 * SizesCentralizers( t )[ pos3CinG ];
true
gap> ForAll( Irr( n ), x -> IsInt( x[ pos3CinN[1] ] ) );
true

##  doc2/ambigfus.xml (1224-1228)
gap> rep:= RepresentativesFusions( n, nfust, t );;
gap> Length( rep );
4

##  doc2/ambigfus.xml (1235-1241)
gap> s:= CharacterTable( "Fi22" );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> ForAll( sfust, x -> x[6] = pos3CinG );
true
gap> pos3CinS:= 6;;

##  doc2/ambigfus.xml (1250-1262)
gap> u:= CharacterTable( Maxes( s )[11] );
CharacterTable( "3^(1+6):2^(3+4):3^2:2" )
gap> uclasses:= SizesConjugacyClasses( u );;
gap> pos3CinU:= Filtered( [ 1 .. NrConjugacyClasses( u ) ],
>                         i -> uclasses[i] = 2 );
[ 2 ]
gap> ufuss:= PossibleClassFusions( u, s );;
gap> ForAll( ufuss, x -> x[ pos3CinU[1] ] = pos3CinS );
true
gap> Size( n ) / Size( u );
4

##  doc2/ambigfus.xml (1272-1282)
gap> ufusn:= PossibleClassFusions( u, n );;
gap> comp:= SetOfComposedClassFusions( sfust, ufuss );;
gap> good:= Filtered( nfust, map2 -> ForAny( ufusn,
>               map1 -> CompositionMaps( map2, map1 ) in comp ) );;
gap> Length( good );
1728
gap> goodrep:= RepresentativesFusions( n, good, t );;
gap> Length( goodrep );
2

##  doc2/ambigfus.xml (1298-1309)
gap> tfust3:= GetFusionMap( t, CharacterTable( "2E6(2).3" ) );;
gap> Number( InverseMap( tfust3 ), IsList );
14
gap> autt:= AutomorphismsOfTable( t );;
gap> ord3:= Filtered( autt, x -> Order( x ) = 3 );;
gap> Length( ord3 );
2
gap> alpha:= ord3[1];;
gap> pos3CinG ^ alpha = pos3CinG;
true

##  doc2/ambigfus.xml (1324-1334)
gap> autn:= AutomorphismsOfTable( n );;
gap> ord3:= Filtered( autn, x -> Order( x ) = 3 );;
gap> Length( ord3 );
26
gap> Add( ord3, () );
gap> filt:= Filtered( rep, map -> ForAny( ord3, beta ->
> OnTuples( map, alpha ) = Permuted( map, beta ) ) );;
gap> Length( filt );
2

##  doc2/ambigfus.xml (1345-1355)
gap> inter:= Intersection( good, filt );
[ [ 1, 7, 5, 6, 7, 2, 3, 4, 27, 30, 24, 32, 25, 26, 9, 11, 12, 13, 
      10, 14, 19, 19, 19, 16, 17, 18, 21, 58, 61, 62, 67, 68, 69, 57, 
      72, 59, 75, 76, 77, 78, 79, 80, 64, 65, 66, 60, 81, 82, 5, 6, 
      7, 6, 7, 7, 7, 7, 6, 7, 6, 7, 7, 24, 25, 27, 26, 28, 30, 29, 
      31, 32, 31, 32, 32, 32, 32, 31, 32, 31, 32, 51, 52, 52, 52, 52, 
      74, 76, 77, 77, 75, 74, 76, 74, 75, 99, 100, 101, 102, 4, 20, 
      29, 31, 32, 36, 36, 42, 42, 39, 40, 41, 49, 49, 49, 49, 49, 49, 
      71, 112, 112, 114, 115, 116 ] ]

##  doc2/ambigfus.xml (1364-1367)
gap> GetFusionMap( n, t ) = inter[1];
true

##  doc2/ambigfus.xml (1384-1387)
gap> Length( LinearCharacters( n ) );
2

##  doc2/ambigfus.xml (1410-1417)
gap> t:= CharacterTable( "Suz" );;
gap> 3t:= CharacterTable( "3.Suz" );;
gap> s:= CharacterTable( "A7" );;
gap> 3s:= CharacterTable( "3.A7" );;
gap> PossibleClassFusions( s, 3t );
[  ]

##  doc2/ambigfus.xml (1425-1436)
gap> 3sfus3t:= PossibleClassFusions( 3s, 3t );;
gap> Length( 3sfus3t );
6
gap> RepresentativesFusions( 3s, 3sfus3t, 3t );
[ [ 1, 2, 3, 7, 8, 9, 16, 16, 26, 27, 28, 32, 33, 34, 47, 47, 47, 48, 
      49, 50, 48, 49, 50 ], 
  [ 1, 11, 12, 4, 36, 37, 13, 16, 23, 82, 83, 32, 100, 101, 44, 38, 
      41, 48, 112, 116, 48, 115, 113 ] ]
gap> ClassPositionsOfCentre( 3t );
[ 1, 2, 3 ]

##  doc2/ambigfus.xml (1450-1461)
gap> sfust:= PossibleClassFusions( s, t );;
gap> Length( sfust );
1
gap> filt:= Filtered( 3sfus3t, map -> CompositionMaps( GetFusionMap( 3t, t ),
>                                         map )
>               = CompositionMaps( sfust[1], GetFusionMap( 3s, s ) ) );
[ [ 1, 2, 3, 7, 8, 9, 16, 16, 26, 27, 28, 32, 33, 34, 47, 47, 47, 48, 
      49, 50, 48, 49, 50 ], 
  [ 1, 3, 2, 7, 9, 8, 16, 16, 26, 28, 27, 32, 34, 33, 47, 47, 47, 48, 
      50, 49, 48, 50, 49 ] ]

##  doc2/ambigfus.xml (1471-1477)
gap> RepresentativesFusions( 3s, filt, 3t );
[ [ 1, 2, 3, 7, 8, 9, 16, 16, 26, 27, 28, 32, 33, 34, 47, 47, 47, 48, 
      49, 50, 48, 49, 50 ] ]
gap> GetFusionMap( 3s, 3t ) in filt;
true

##  doc2/ambigfus.xml (1495-1501)
gap> u:= CharacterTable( "3_2.U4(3)" );;
gap> PossibleClassFusions( s, u );
[  ]
gap> Length( PossibleClassFusions( 3s, u ) );
8

##  doc2/ambigfus.xml (1516-1526)
gap> s:= CharacterTable( "S6" );
CharacterTable( "A6.2_1" )
gap> t:= CharacterTable( "U4(2)" );
CharacterTable( "U4(2)" )
gap> sfust:= PossibleClassFusions( s, t );
[ [ 1, 3, 6, 7, 9, 10, 3, 2, 9, 16, 15 ], 
  [ 1, 3, 7, 6, 9, 10, 2, 3, 9, 15, 16 ] ]
gap> Length( RepresentativesFusions( s, sfust, t ) );
1

##  doc2/ambigfus.xml (1536-1546)
gap> 2t:= CharacterTable( "2.U4(2)" );
CharacterTable( "2.U4(2)" )
gap> 2s:= CharacterTable( "2.A6.2_1" );
CharacterTable( "2.A6.2_1" )
gap> 2sfus2t:= PossibleClassFusions( 2s, 2t );
[ [ 1, 2, 4, 11, 12, 9, 10, 15, 16, 17, 3, 4, 15, 24, 25, 26, 26 ], 
  [ 1, 2, 4, 11, 12, 9, 10, 15, 16, 17, 3, 4, 15, 25, 24, 26, 26 ] ]
gap> Length( RepresentativesFusions( 2s, 2sfus2t, 2t ) );
1

##  doc2/ambigfus.xml (1555-1562)
gap> 2sfuss:= GetFusionMap( 2s, s );
[ 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 7, 8, 9, 10, 10, 11, 11 ]
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> induced:= Set( 2sfus2t, x -> CompositionMaps( 2tfust,
>      CompositionMaps( x, InverseMap( 2sfuss ) ) ) );
[ [ 1, 3, 7, 6, 9, 10, 2, 3, 9, 15, 16 ] ]

##  doc2/ambigfus.xml (1576-1584)
gap> auts:= AutomorphismsOfTable( s );
Group([ (3,4)(7,8)(10,11) ])
gap> other:= OnTuples( 2sfuss, GeneratorsOfGroup( auts )[1] );
[ 1, 1, 2, 4, 4, 3, 3, 5, 6, 6, 8, 7, 9, 11, 11, 10, 10 ]
gap> Set( 2sfus2t, x -> CompositionMaps( 2tfust,
>      CompositionMaps( x, InverseMap( other ) ) ) );
[ [ 1, 3, 6, 7, 9, 10, 3, 2, 9, 16, 15 ] ]

##  doc2/ambigfus.xml (1593-1596)
gap> GetFusionMap( s, t ) in induced;
true

##  doc2/ambigfus.xml (1620-1628)
gap> s:= CharacterTable( "U3(8).3_1" );;
gap> t:= CharacterTable( "2E6(2)" );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> Length( sfust );
24
gap> Length( RepresentativesFusions( s, sfust, t ) );
2

##  doc2/ambigfus.xml (1640-1648)
gap> s2:= CharacterTable( "U3(8).6" );;
gap> t2:= CharacterTable( "2E6(2).2" );;
gap> s2fust2:= PossibleClassFusions( s2, t2 );;
gap> Length( s2fust2 );
2
gap> Length( RepresentativesFusions( s2, s2fust2, t2 ) );
1

##  doc2/ambigfus.xml (1658-1668)
gap> sfuss2:= PossibleClassFusions( s, s2 );;
gap> comp:= SetOfComposedClassFusions( s2fust2, sfuss2 );;
gap> tfust2:= PossibleClassFusions( t, t2 );;
gap> filt:= Filtered( sfust, map -> ForAny( tfust2,
>               map2 -> CompositionMaps( map2, map ) in comp ) );;
gap> Length( filt );
12
gap> Length( RepresentativesFusions( s, filt, t ) );
1

##  doc2/ambigfus.xml (1684-1693)
gap> Set( filt, x -> x{ [ 31 .. 36 ] } );
[ [ 74, 74, 81, 82, 81, 82 ], [ 74, 74, 82, 81, 82, 81 ], 
  [ 81, 82, 74, 74, 81, 82 ], [ 81, 82, 81, 82, 74, 74 ], 
  [ 82, 81, 74, 74, 82, 81 ], [ 82, 81, 82, 81, 74, 74 ] ]
gap> Set( Difference( sfust, filt ), x -> x{ [ 31 .. 36 ] } );
[ [ 74, 74, 81, 82, 82, 81 ], [ 74, 74, 82, 81, 81, 82 ], 
  [ 81, 82, 74, 74, 82, 81 ], [ 81, 82, 82, 81, 74, 74 ], 
  [ 82, 81, 74, 74, 81, 82 ], [ 82, 81, 81, 82, 74, 74 ] ]

##  doc2/ambigfus.xml (1703-1708)
gap> Set( sfuss2, x -> x{ [ 31 .. 36 ] } );
[ [ 28, 29, 30, 31, 30, 31 ], [ 29, 28, 31, 30, 31, 30 ], 
  [ 30, 31, 28, 29, 30, 31 ], [ 30, 31, 30, 31, 28, 29 ], 
  [ 31, 30, 29, 28, 31, 30 ], [ 31, 30, 31, 30, 29, 28 ] ]

##  doc2/ambigfus.xml (1718-1723)
gap> List( tfust2, x -> x{ [ 74, 81, 82 ] } );
[ [ 65, 70, 71 ], [ 65, 70, 71 ], [ 65, 71, 70 ], [ 65, 71, 70 ], 
  [ 65, 70, 71 ], [ 65, 70, 71 ], [ 65, 71, 70 ], [ 65, 71, 70 ], 
  [ 65, 70, 71 ], [ 65, 70, 71 ], [ 65, 71, 70 ], [ 65, 71, 70 ] ]

##  doc2/ambigfus.xml (1732-1735)
gap> List( s2fust2, x -> x{ [ 28 .. 31 ] } );
[ [ 65, 65, 70, 71 ], [ 65, 65, 71, 70 ] ]

##  doc2/ambigfus.xml (1743-1746)
gap> GetFusionMap( s, t ) in filt;
true

##  doc2/ambigfus.xml (1762-1770)
gap> s:= CharacterTable( "L3(4).2_1" );;
gap> t:= CharacterTable( "U6(2)" );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> Length( sfust );
27
gap> Length( RepresentativesFusions( s, sfust, t ) );
3

##  doc2/ambigfus.xml (1782-1790)
gap> s3:= CharacterTable( "L3(4).6" );;
gap> t3:= CharacterTable( "U6(2).3" );;
gap> s3fust3:= PossibleClassFusions( s3, t3 );;
gap> Length( s3fust3 );
2
gap> Length( RepresentativesFusions( s3, s3fust3, t3 ) );
1

##  doc2/ambigfus.xml (1801-1808)
gap> sfuss3:= PossibleClassFusions( s, s3 );;
gap> comp:= SetOfComposedClassFusions( s3fust3, sfuss3 );;
gap> tfust3:= PossibleClassFusions( t, t3 );;
gap> sfust = Filtered( sfust, map -> ForAny( tfust3,
>                map2 -> CompositionMaps( map2, map ) in comp ) );
true

##  doc2/ambigfus.xml (1818-1823)
gap> OrdersClassRepresentatives( s );
[ 1, 2, 3, 4, 4, 4, 5, 7, 2, 4, 6, 8, 8, 8 ]
gap> sfuss3;
[ [ 1, 2, 3, 4, 4, 4, 5, 6, 7, 8, 9, 10, 10, 10 ] ]

##  doc2/ambigfus.xml (1832-1843)
gap> Set( sfust, map -> map{ [ 4 .. 6 ] } );
[ [ 10, 10, 10 ], [ 10, 10, 11 ], [ 10, 10, 12 ], [ 10, 11, 10 ], 
  [ 10, 11, 11 ], [ 10, 11, 12 ], [ 10, 12, 10 ], [ 10, 12, 11 ], 
  [ 10, 12, 12 ], [ 11, 10, 10 ], [ 11, 10, 11 ], [ 11, 10, 12 ], 
  [ 11, 11, 10 ], [ 11, 11, 11 ], [ 11, 11, 12 ], [ 11, 12, 10 ], 
  [ 11, 12, 11 ], [ 11, 12, 12 ], [ 12, 10, 10 ], [ 12, 10, 11 ], 
  [ 12, 10, 12 ], [ 12, 11, 10 ], [ 12, 11, 11 ], [ 12, 11, 12 ], 
  [ 12, 12, 10 ], [ 12, 12, 11 ], [ 12, 12, 12 ] ]
gap> Set( tfust3, map -> map{ [ 10 .. 12 ] } );
[ [ 10, 10, 10 ] ]

##  doc2/ambigfus.xml (1858-1870)
gap> Filtered( sfust, map -> Intersection( map, [ 10 .. 12 ] ) = [] );
[  ]
gap> filt:= Filtered( sfust, map -> IsSubset( map, [ 10 .. 12 ] ) );
[ [ 1, 3, 7, 10, 11, 12, 15, 24, 4, 14, 23, 26, 27, 28 ], 
  [ 1, 3, 7, 10, 12, 11, 15, 24, 4, 14, 23, 26, 28, 27 ], 
  [ 1, 3, 7, 11, 10, 12, 15, 24, 4, 14, 23, 27, 26, 28 ], 
  [ 1, 3, 7, 11, 12, 10, 15, 24, 4, 14, 23, 27, 28, 26 ], 
  [ 1, 3, 7, 12, 10, 11, 15, 24, 4, 14, 23, 28, 26, 27 ], 
  [ 1, 3, 7, 12, 11, 10, 15, 24, 4, 14, 23, 28, 27, 26 ] ]
gap> Length( RepresentativesFusions( s, filt, t ) );
1

##  doc2/ambigfus.xml (1878-1881)
gap> GetFusionMap( s, t ) in filt;
true

##  doc2/ambigfus.xml (1914-1925)
gap> s:= CharacterTable( "L2(16).4" );;
gap> t:= CharacterTable( "J3.2" );;
gap> fus:= PossibleClassFusions( s, t );
[ [ 1, 2, 3, 6, 14, 15, 16, 2, 5, 7, 12, 5, 5, 8, 8, 13, 13 ], 
  [ 1, 2, 3, 6, 14, 15, 16, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ], 
  [ 1, 2, 3, 6, 14, 16, 15, 2, 5, 7, 12, 5, 5, 8, 8, 13, 13 ], 
  [ 1, 2, 3, 6, 14, 16, 15, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ] ]
gap> RepresentativesFusions( s, fus, t );
[ [ 1, 2, 3, 6, 14, 15, 16, 2, 5, 7, 12, 5, 5, 8, 8, 13, 13 ], 
  [ 1, 2, 3, 6, 14, 15, 16, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ] ]

##  doc2/ambigfus.xml (1939-1950)
gap> j3:= CharacterTable( "J3" );;
gap> PossibleClassFusions( s, j3 );
[  ]
gap> GetFusionMap( j3, t );
[ 1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12, 12, 13, 14, 14, 15, 16, 
  17, 17 ]
gap> filt:= Filtered( fus,
>          x -> not IsSubset( ClassPositionsOfDerivedSubgroup( t ), x ) );
[ [ 1, 2, 3, 6, 14, 15, 16, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ], 
  [ 1, 2, 3, 6, 14, 16, 15, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ] ]

##  doc2/ambigfus.xml (1961-1975)
gap> smod2:= s mod 2;;
gap> tmod2:= t mod 2;;
gap> admissible:= [];;  modmap:= "dummy";;
gap> for map in filt do
>      modmap:= CompositionMaps( InverseMap( GetFusionMap( tmod2, t ) ),
>                   CompositionMaps( map, GetFusionMap( smod2, s ) ) );
>      if not fail in Decomposition( Irr( smod2 ),
>            List( Irr( tmod2 ), chi -> chi{ modmap } ), "nonnegative" ) then
>        AddSet( admissible, map );
>      fi;
>    od;
gap> admissible;
[ [ 1, 2, 3, 6, 14, 16, 15, 2, 5, 7, 12, 19, 19, 22, 22, 23, 23 ] ]

##  doc2/ambigfus.xml (1985-1988)
gap> CTblLib.Test.Decompositions( s, fus, t ) = admissible;
true

##  doc2/ambigfus.xml (1995-1998)
gap> GetFusionMap( s, t ) in admissible;
true

##  doc2/ambigfus.xml (2027-2033)
gap> m:= CharacterTable( "L2(17)" );;
gap> t:= CharacterTable( "S8(2)" );;
gap> mfust:= PossibleClassFusions( m, t );;
gap> Length( RepresentativesFusions( m, mfust, t ) );
4

##  doc2/ambigfus.xml (2042-2049)
gap> filt:= CTblLib.Test.Decompositions( m, mfust, t );;
gap> repr:= RepresentativesFusions( m, filt, t );;
gap> Length( repr );
1
gap> GetFusionMap( m, t ) in repr;
true

##  doc2/ambigfus.xml (2068-2086)
gap> s:= CharacterTable( "L2(19)" );;
gap> t:= CharacterTable( "J3" );;
gap> sfust:= PossibleClassFusions( s, t );
[ [ 1, 2, 4, 6, 7, 10, 11, 12, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 10, 11, 12, 13, 14, 21, 20 ], 
  [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14, 21, 20 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14, 21, 20 ], 
  [ 1, 2, 4, 7, 6, 10, 11, 12, 14, 13, 20, 21 ], 
  [ 1, 2, 4, 7, 6, 10, 11, 12, 14, 13, 21, 20 ], 
  [ 1, 2, 4, 7, 6, 11, 12, 10, 14, 13, 20, 21 ], 
  [ 1, 2, 4, 7, 6, 11, 12, 10, 14, 13, 21, 20 ], 
  [ 1, 2, 4, 7, 6, 12, 10, 11, 14, 13, 20, 21 ], 
  [ 1, 2, 4, 7, 6, 12, 10, 11, 14, 13, 21, 20 ] ]
gap> fusreps:= RepresentativesFusions( s, sfust, t );
[ [ 1, 2, 4, 6, 7, 10, 11, 12, 13, 14, 20, 21 ] ]

##  doc2/ambigfus.xml (2098-2117)
gap> tmod19:= t mod 19;
BrauerTable( "J3", 19 )
gap> deg110:= Filtered( Irr( tmod19 ), phi -> phi[1] = 110 );
[ Character( BrauerTable( "J3", 19 ),
  [ 110, -2, 5, 2, 2, 0, 0, 1, 0, 
      -2*E(9)^2+E(9)^3-E(9)^4-E(9)^5+E(9)^6-2*E(9)^7, 
      E(9)^2+E(9)^3-E(9)^4-E(9)^5+E(9)^6+E(9)^7, 
      E(9)^2+E(9)^3+2*E(9)^4+2*E(9)^5+E(9)^6+E(9)^7, -2, -2, -1, 0, 
      0, E(17)^3+E(17)^5+E(17)^6+E(17)^7+E(17)^10+E(17)^11+E(17)^12
         +E(17)^14, 
      E(17)+E(17)^2+E(17)^4+E(17)^8+E(17)^9+E(17)^13+E(17)^15+E(17)^16
     ] ) ]
gap> 9A:= Position( OrdersClassRepresentatives( tmod19 ), 9 );
10
gap> deg110[1][ 9A ];
-2*E(9)^2+E(9)^3-E(9)^4-E(9)^5+E(9)^6-2*E(9)^7
gap> AtlasIrrationality( "-1+2y9+&4" ) = deg110[1][ 9A ];
true

##  doc2/ambigfus.xml (2126-2147)
gap> smod19:= s mod 19;
BrauerTable( "L2(19)", 19 )
gap> compatible:= [];;
gap> for map in sfust do
>      comp:= CompositionMaps( InverseMap( GetFusionMap( tmod19, t ) ),
>      CompositionMaps( map, GetFusionMap( smod19, s ) ) );
>      rest:= List( Irr( tmod19 ), phi -> phi{ comp } );
>      if not fail in Decomposition( Irr( smod19 ), rest, "nonnegative" ) then
>        Add( compatible, map );
>      fi;
>    od;
gap> compatible;
[ [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14, 21, 20 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14, 21, 20 ], 
  [ 1, 2, 4, 7, 6, 11, 12, 10, 14, 13, 20, 21 ], 
  [ 1, 2, 4, 7, 6, 11, 12, 10, 14, 13, 21, 20 ], 
  [ 1, 2, 4, 7, 6, 12, 10, 11, 14, 13, 20, 21 ], 
  [ 1, 2, 4, 7, 6, 12, 10, 11, 14, 13, 21, 20 ] ]

##  doc2/ambigfus.xml (2159-2173)
gap> reps:= RepresentativesFusions( s, compatible, t );
[ [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14, 20, 21 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14, 20, 21 ] ]
gap> compatiblemod19:= List( reps, map -> CompositionMaps(
>        InverseMap( GetFusionMap( tmod19, t ) ),
>        CompositionMaps( map, GetFusionMap( smod19, s ) ) ) );
[ [ 1, 2, 4, 6, 7, 11, 12, 10, 13, 14 ], 
  [ 1, 2, 4, 6, 7, 12, 10, 11, 13, 14 ] ]
gap> rest:= List( compatiblemod19, map -> Irr( tmod19 )[3]{ map } );;
gap> dec:= Decomposition( Irr( smod19 ), rest, "nonnegative" );
[ [ 0, 0, 1, 2, 1, 2, 2, 1, 0, 1 ], [ 0, 2, 0, 2, 0, 1, 2, 0, 2, 1 ] ]
gap> List( Irr( smod19 ), phi -> phi[1] );
[ 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 ]

##  doc2/ambigfus.xml (2187-2217)
gap> LoadPackage( "atlasrep", false );
true
gap> prog:= AtlasProgram( "J3", "maxes", 2 );
rec( groupname := "J3", identifier := [ "J3", "J3G1-max2W1", 1 ], 
  program := <straight line program>, size := 3420, 
  standardization := 1, subgroupname := "L2(19)", version := "1" )
gap> gens:= OneAtlasGeneratingSetInfo( "J3", Characteristic, 19,
>               Dimension, 110 );;
gap> gens:= AtlasGenerators( gens );
rec( charactername := "110a", constituents := [ 3 ], 
  contents := "core", dim := 110, 
  generators := [ < immutable compressed matrix 110x110 over GF(19) >,
      < immutable compressed matrix 110x110 over GF(19) > ], 
  groupname := "J3", id := "", 
  identifier := [ "J3", [ "J3G1-f19r110B0.m1", "J3G1-f19r110B0.m2" ], 
      1, 19 ], repname := "J3G1-f19r110B0", repnr := 35, 
  ring := GF(19), size := 50232960, standardization := 1, 
  type := "matff" )
gap> restgens:= ResultOfStraightLineProgram( prog.program, gens.generators );
[ < immutable compressed matrix 110x110 over GF(19) >, 
  < immutable compressed matrix 110x110 over GF(19) > ]
gap> module:= GModuleByMats( restgens, GF( 19 ) );;
gap> facts:= SMTX.CollectedFactors( module );;
gap> Length( facts );
7
gap> List( facts, x -> x[1].dimension );
[ 5, 7, 9, 11, 13, 15, 19 ]
gap> List( facts, x -> x[2] );
[ 1, 2, 1, 2, 2, 1, 1 ]

##  doc2/ambigfus.xml (2229-2232)
gap> GetFusionMap( s, t ) = reps[1];
true

##  doc2/ambigfus.xml (2267-2270)
gap> LoadPackage( "atlasrep", false );
true

##  doc2/ambigfus.xml (2377-2405)
gap> t:= CharacterTable( "F3+" );
CharacterTable( "F3+" )
gap> s:= CharacterTable( "U3(3).2" );
CharacterTable( "U3(3).2" )
gap> tnames:= ClassNames( t, "ATLAS" );
[ "1A", "2A", "2B", "3A", "3B", "3C", "3D", "3E", "4A", "4B", "4C", 
  "5A", "6A", "6B", "6C", "6D", "6E", "6F", "6G", "6H", "6I", "6J", 
  "6K", "7A", "7B", "8A", "8B", "8C", "9A", "9B", "9C", "9D", "9E", 
  "9F", "10A", "10B", "11A", "12A", "12B", "12C", "12D", "12E", 
  "12F", "12G", "12H", "12I", "12J", "12K", "12L", "12M", "13A", 
  "14A", "14B", "15A", "15B", "15C", "16A", "17A", "18A", "18B", 
  "18C", "18D", "18E", "18F", "18G", "18H", "20A", "20B", "21A", 
  "21B", "21C", "21D", "22A", "23A", "23B", "24A", "24B", "24C", 
  "24D", "24E", "24F", "24G", "26A", "27A", "27B", "27C", "28A", 
  "29A", "29B", "30A", "30B", "33A", "33B", "35A", "36A", "36B", 
  "36C", "36D", "39A", "39B", "39C", "39D", "42A", "42B", "42C", 
  "45A", "45B", "60A" ]
gap> OrdersClassRepresentatives( s );
[ 1, 2, 3, 3, 4, 4, 6, 7, 8, 12, 2, 4, 6, 8, 12, 12 ]
gap> sfust:= List( [ "1A", "2B", "3D", "3E", "4C", "4C", "6J", "7B", "8C",
>                    "12M" ], x -> Position( tnames, x ) );
[ 1, 3, 7, 8, 11, 11, 22, 25, 28, 50 ]
gap> sfust:= PossibleClassFusions( s, t, rec( fusionmap:= sfust ) );
[ [ 1, 3, 7, 8, 11, 11, 22, 25, 28, 50, 3, 9, 23, 28, 43, 43 ], 
  [ 1, 3, 7, 8, 11, 11, 22, 25, 28, 50, 3, 11, 23, 28, 50, 50 ] ]
gap> OrdersClassRepresentatives( s );
[ 1, 2, 3, 3, 4, 4, 6, 7, 8, 12, 2, 4, 6, 8, 12, 12 ]

##  doc2/ambigfus.xml (2426-2434)
gap> Maxes( s );
[ "U3(3)", "3^(1+2):SD16", "L3(2).2", "2^(1+4).S3", "4^2:D12" ]
gap> SizesCentralizers( s );
[ 12096, 192, 216, 18, 96, 32, 24, 7, 8, 12, 48, 48, 6, 8, 12, 12 ]
gap> u:= CharacterTable( Maxes( s )[2] );;
gap> ufuss:= GetFusionMap( u, s );
[ 1, 2, 11, 3, 4, 5, 12, 7, 13, 9, 9, 15, 16, 10 ]

##  doc2/ambigfus.xml (2444-2460)
gap> 3Dcentralizer:= SizesCentralizers( t )[7];
153055008
gap> cand:= [];;                                                               
gap> for name in Maxes( t ) do
>      m:= CharacterTable( name );
>      mfust:= GetFusionMap( m, t );        
>      if ForAny( [ 1 .. Length( mfust ) ],                    
>          i -> mfust[i] = 7 and SizesCentralizers( m )[i] = 3Dcentralizer )   
>      then
>        Add( cand, m );
>      fi;
>    od;
gap> cand;
[ CharacterTable( "3^7.O7(3)" ), 
  CharacterTable( "3^2.3^4.3^8.(A5x2A4).2" ) ]

##  doc2/ambigfus.xml (2471-2489)
gap> possufust:= List( sfust, x -> CompositionMaps( x, ufuss ) );
[ [ 1, 3, 3, 7, 8, 11, 9, 22, 23, 28, 28, 43, 43, 50 ], 
  [ 1, 3, 3, 7, 8, 11, 11, 22, 23, 28, 28, 50, 50, 50 ] ]
gap> m:= cand[1];;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> Length( ufusm );
242
gap> comp:= List( ufusm, x -> CompositionMaps( GetFusionMap( m, t ), x ) );;
gap> Intersection( possufust, comp );
[ [ 1, 3, 3, 7, 8, 11, 11, 22, 23, 28, 28, 50, 50, 50 ] ]
gap> m:= cand[2];;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> Length( ufusm );                        
256
gap> comp:= List( ufusm, x -> CompositionMaps( GetFusionMap( m, t ), x ) );;   
gap> Intersection( possufust, comp );
[ [ 1, 3, 3, 7, 8, 11, 11, 22, 23, 28, 28, 50, 50, 50 ] ]

##  doc2/ambigfus.xml (2498-2501)
gap> GetFusionMap( s, t ) = sfust[2];
true

##  doc2/ambigfus.xml (2520-2527)
gap> t:= CharacterTable( "F3+" );;
gap> u:= CharacterTable( "L2(13).2" );;
gap> fus:= PossibleClassFusions( u, t );;
gap> repr:= RepresentativesFusions( u, fus, t );;
gap> Length( repr );
3

##  doc2/ambigfus.xml (2540-2546)
gap> filt:= Filtered( repr, x -> t.2b in x and t.3d in x and t.7b in x );
[ [ 1, 3, 7, 22, 25, 25, 25, 51, 3, 9, 43, 43, 53, 53, 53 ], 
  [ 1, 3, 7, 22, 25, 25, 25, 51, 3, 11, 50, 50, 53, 53, 53 ] ]
gap> ClassNames( t ){ [ 43, 50 ] };
[ "12f", "12m" ]

##  doc2/ambigfus.xml (2562-2583)
gap> pos:= Position( OrdersClassRepresentatives( t ), 13 );
51
gap> SizesCentralizers( t )[ pos ];
234
gap> ClassOrbit( t, pos );
[ 51 ]
gap> cand:= [];;                                                         
gap> for name in Maxes( t ) do
>      m:= CharacterTable( name );
>      pos:= Position( OrdersClassRepresentatives( m ), 13 );
>      if pos <> fail and                                             
>         SizesCentralizers( m )[ pos ] = 234                         
>         and ClassOrbit( m, pos ) = [ pos ] then
>        Add( cand, m );
>      fi;
>    od;
gap> cand;
[ CharacterTable( "(3^2:2xG2(3)).2" ) ]
gap> s:= cand[1];;
gap> sfust:= PossibleClassFusions( s, t );;

##  doc2/ambigfus.xml (2593-2604)
gap> der:= ClassPositionsOfDerivedSubgroup( s );;
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( s ) ], der );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> imgs:= Set( Flat( List( sfust, x -> x{ outer } ) ) );
[ 2, 3, 10, 11, 15, 17, 18, 19, 21, 22, 26, 44, 45, 49, 50, 52, 62, 
  83, 87, 98 ]
gap> t.12f in imgs;
false
gap> t.12m in imgs;
true

##  doc2/ambigfus.xml (2616-2619)
gap> GetFusionMap( u, t ) = filt[2];
true

##  doc2/ambigfus.xml (3077-3089)
gap> b:= CharacterTable( "B" );;
gap> m11:= CharacterTable( "M11" );;
gap> m11fusb:= PossibleClassFusions( m11, b );;
gap> Length( m11fusb );
31
gap> CompositionMaps( ClassNames( b, "ATLAS" ), Parametrized( m11fusb ) );
[ "1A", [ "2B", "2D" ], [ "3A", "3B" ], 
  [ "4B", "4E", "4G", "4H", "4J" ], [ "5A", "5B" ], 
  [ "6C", "6E", "6H", "6I", "6J" ], 
  [ "8B", "8E", "8G", "8J", "8K", "8L", "8M", "8N" ], 
  [ "8B", "8E", "8G", "8J", "8K", "8L", "8M", "8N" ], "11A", "11A" ]

##  doc2/ambigfus.xml (3114-3122)
gap> th:= CharacterTable( "Th" );;
gap> s5:= CharacterTable( "S5" );;
gap> s5fusth:= PossibleClassFusions( s5, th );
[ [ 1, 2, 4, 8, 2, 7, 11 ] ]
gap> thfusb:= PossibleClassFusions( th, b );;
gap> s5fusb:= Set( thfusb, x -> CompositionMaps( x, s5fusth[1] ) );
[ [ 1, 5, 7, 19, 5, 17, 29 ] ]

##  doc2/ambigfus.xml (3131-3139)
gap> s5fusm11:= PossibleClassFusions( s5, m11 );
[ [ 1, 2, 3, 5, 2, 4, 6 ] ]
gap> m11fusb:= Filtered( m11fusb,
>                  map -> CompositionMaps( map, s5fusm11[1] ) = s5fusb[1] );
[ [ 1, 5, 7, 17, 19, 29, 45, 45, 54, 54 ] ]
gap> CompositionMaps( ClassNames( b, "ATLAS" ), m11fusb[1] );
[ "1A", "2D", "3B", "4J", "5B", "6J", "8N", "8N", "11A", "11A" ]

##  doc2/ambigfus.xml (3160-3175)
gap> b:= CharacterTable( "B" );;
gap> l:= CharacterTable( "L2(11).2" );;
gap> lfusb:= PossibleClassFusions( l, b );;
gap> Length( lfusb );
16
gap> CompositionMaps( ClassNames( b, "ATLAS" ), Parametrized( lfusb ) );
[ "1A", [ "2B", "2D" ], [ "3A", "3B" ], [ "5A", "5B" ], 
  [ "5A", "5B" ], [ "6C", "6H", "6I", "6J" ], "11A", [ "2C", "2D" ], 
  [ "4D", "4E", "4F", "4G", "4H", "4J" ], [ "10C", "10E", "10F" ], 
  [ "10C", "10E", "10F" ], 
  [ "12E", "12F", "12H", "12I", "12J", "12L", "12N", "12P", "12Q", 
      "12R", "12S" ], 
  [ "12E", "12F", "12H", "12I", "12J", "12L", "12N", "12P", "12Q", 
      "12R", "12S" ] ]

##  doc2/ambigfus.xml (3198-3211)
gap> m:= CharacterTable( "M11" );;
gap> u:= CharacterTable( "L2(11)" );;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> mfusb:= GetFusionMap( m, b );;
gap> ufusb:= Set( ufusm, x -> CompositionMaps( mfusb, x ) );
[ [ 1, 5, 7, 19, 19, 29, 54, 54 ] ]
gap> ufusl:= PossibleClassFusions( u, l );
[ [ 1, 2, 3, 4, 5, 6, 7, 7 ], [ 1, 2, 3, 5, 4, 6, 7, 7 ] ]
gap> lfusb:= Filtered( lfusb, 
>              map2 -> ForAny( ufusl, 
>                        map1 -> CompositionMaps( map2, map1 ) in ufusb ) );
[ [ 1, 5, 7, 19, 19, 29, 54, 5, 15, 53, 53, 73, 73 ] ]

##  doc2/ambigfus.xml (3225-3231)
gap> b:= CharacterTable( "B" );;
gap> t:= CharacterTable( "L3(3)" );;
gap> tfusb:= PossibleClassFusions( t, b );;
gap> Length( tfusb );
36

##  doc2/ambigfus.xml (3244-3262)
gap> m:= CharacterTable( "3^2.3^3.3^6.(S4x2S4)" );;
gap> g:= PSL(3,3);;
gap> mx:= MaximalSubgroupClassReps( g );;
gap> u:= First( mx, x -> Size( x ) = 432 );;
gap> u:= CharacterTable( u );;
gap> ufusm:= PossibleClassFusions( u, m );;
gap> ufust:= PossibleClassFusions( u, t );;
gap> mfusb:= GetFusionMap( m, b );;
gap> ufusb:= Set( ufusm, map -> CompositionMaps( mfusb, map ) );;
gap> tfusb:= Filtered( tfusb, map -> ForAny( ufust,
>        map2 -> CompositionMaps( map, map2 ) in ufusb ) );;
gap> tfusb;
[ [ 1, 5, 6, 7, 12, 27, 41, 41, 75, 75, 75, 75 ], 
  [ 1, 5, 7, 6, 12, 28, 41, 41, 75, 75, 75, 75 ], 
  [ 1, 5, 7, 7, 12, 28, 41, 41, 75, 75, 75, 75 ], 
  [ 1, 5, 7, 7, 12, 29, 41, 41, 75, 75, 75, 75 ], 
  [ 1, 5, 7, 7, 17, 29, 45, 45, 75, 75, 75, 75 ] ]

##  doc2/ambigfus.xml (3272-3275)
gap> ClassNames( b, "ATLAS" ){ [ 12, 17 ] };
[ "4E", "4J" ]

##  doc2/ambigfus.xml (3283-3286)
gap> GetFusionMap( t, b ) = tfusb[5];
true

##  doc2/ambigfus.xml (3300-3310)
gap> b:= CharacterTable( "B" );;
gap> u:= CharacterTable( "L2(17).2" );;
gap> ufusb:= PossibleClassFusions( u, b );
[ [ 1, 5, 7, 15, 42, 42, 47, 47, 47, 91, 4, 30, 89, 89, 89, 89, 97, 
      97, 97 ], 
  [ 1, 5, 7, 15, 44, 44, 46, 46, 46, 91, 5, 29, 90, 90, 90, 90, 96, 
      96, 96 ], 
  [ 1, 5, 7, 15, 44, 44, 47, 47, 47, 91, 5, 29, 90, 90, 90, 90, 95, 
      95, 95 ] ]

##  doc2/ambigfus.xml (3321-3328)
gap> names:= ClassNames( b, "ATLAS" );;
gap> pos:= List( [ "8M", "9A" ], x -> Position( names, x ) );
[ 44, 46 ]
gap> ufusb:= Filtered( ufusb, map -> IsSubset( map, pos ) );
[ [ 1, 5, 7, 15, 44, 44, 46, 46, 46, 91, 5, 29, 90, 90, 90, 90, 96, 
      96, 96 ] ]

##  doc2/ambigfus.xml (3336-3339)
gap> GetFusionMap( u, b ) = ufusb[1];
true

##  doc2/ambigfus.xml (3357-3368)
gap> u:= CharacterTable( "L2(49).2_3" );;
gap> b:= CharacterTable( "B" );;
gap> ufusb:= PossibleClassFusions( u, b );;
gap> Length( RepresentativesFusions( u, ufusb, b ) );
2
gap> ufusb;
[ [ 1, 5, 7, 15, 19, 28, 31, 42, 42, 71, 125, 125, 128, 128, 128, 
      128, 128, 15, 71, 71, 89, 89, 89, 89 ], 
  [ 1, 5, 7, 15, 19, 28, 31, 42, 42, 71, 125, 125, 128, 128, 128, 
      128, 128, 17, 72, 72, 89, 89, 89, 89 ] ]

##  doc2/ambigfus.xml (3388-3408)
gap> g:= SL( 2, 49 );;
gap> gens:= GeneratorsOfGroup( g );;
gap> f:= GF(49);;
gap> mats:= List( gens, x -> IdentityMat( 4, f ) );;
gap> for i in [ 1 .. Length( gens ) ] do
>      mats[i]{ [ 1, 2 ] }{ [ 1, 2 ] }:= gens[i];
>      mats[i]{ [ 3, 4 ] }{ [ 3, 4 ] }:= List( gens[i],
>                                              x -> List( x, y -> y^7 ) );
>    od;
gap> fieldaut:= PermutationMat( (1,3)(2,4), 4, f );;
gap> diagaut:= IdentityMat( 4, f );;
gap> diagaut[1][1]:= Z(49);;
gap> diagaut[3][3]:= Z(49)^7;;
gap> g:= Group( Concatenation( mats, [ fieldaut * diagaut ] ) );;
gap> v:= [ 1, 0, 0, 0 ] * Z(7)^0;;
gap> orb:= Orbit( g, v, OnLines );;
gap> act:= Action( g, orb, OnLines );;
gap> n:= Normalizer( act, SylowSubgroup( act, 7 ) );;
gap> ntbl:= CharacterTable( n );;

##  doc2/ambigfus.xml (3417-3426)
gap> bn7:= CharacterTable( "BN7" );;
gap> nfusbn7:= PossibleClassFusions( ntbl, bn7 );;
gap> Length( RepresentativesFusions( ntbl, nfusbn7, bn7 ) );
3
gap> nfusb:= SetOfComposedClassFusions( PossibleClassFusions( bn7, b ),
>                                       nfusbn7 );;
gap> Length( RepresentativesFusions( ntbl, nfusb, b ) );
5

##  doc2/ambigfus.xml (3435-3447)
gap> nfusu:= PossibleClassFusions( ntbl, u );;
gap> Length( nfusu );
4
gap> filt:= Filtered( ufusb,
>              x -> ForAny( nfusu, y -> CompositionMaps( x, y ) in nfusb ) );
[ [ 1, 5, 7, 15, 19, 28, 31, 42, 42, 71, 125, 125, 128, 128, 128, 
      128, 128, 17, 72, 72, 89, 89, 89, 89 ] ]
gap> ClassNames( b, "ATLAS" ){ filt[1] };
[ "1A", "2D", "3B", "4H", "5B", "6I", "7A", "8K", "8K", "12Q", "24L", 
  "24L", "25A", "25A", "25A", "25A", "25A", "4J", "12R", "12R", 
  "16G", "16G", "16G", "16G" ]

##  doc2/ambigfus.xml (3461-3464)
gap> GetFusionMap( u, b ) in filt;
true

##  doc2/ambigfus.xml (3479-3499)
gap> NrConjugacyClasses( u );  NrConjugacyClasses( act );
24
24
gap> u:= CharacterTable( "L2(49).2_1" );;
gap> g:= Group( Concatenation( mats, [ diagaut ] ) );;
gap> orb:= Orbit( g, v, OnLines );;
gap> act:= Action( g, orb, OnLines );;
gap> Size(act );
117600
gap> NrConjugacyClasses( u );  NrConjugacyClasses( act );
51
51
gap> u:= CharacterTable( "L2(49).2_2" );;
gap> g:= Group( Concatenation( mats, [ fieldaut ] ) );;
gap> orb:= Orbit( g, v, OnLines );;
gap> act:= Action( g, orb, OnLines );;
gap> NrConjugacyClasses( u );  NrConjugacyClasses( act );
27
27

##  doc2/ambigfus.xml (3508-3511)
gap> PossibleClassFusions( CharacterTable( "L2(49).2_1" ), b );
[  ]

##  doc2/ambigfus.xml (3526-3530)
gap> n:= Normalizer( act, SylowSubgroup( act, 7 ) );;
gap> Length( PossibleClassFusions( CharacterTable( n ), bn7 ) );
0

##  doc2/ambigfus.xml (3544-3553)
gap> t:= CharacterTable( "G2(5)" );;
gap> s:= CharacterTable( "2^3.L3(2)" );;
gap> sfust:= PossibleClassFusions( s, t );;
gap> RepresentativesFusions( s, sfust, t );
[ [ 1, 2, 2, 5, 6, 4, 13, 16, 17, 15, 15 ], 
  [ 1, 2, 2, 5, 6, 4, 14, 16, 17, 15, 15 ] ]
gap> OrdersClassRepresentatives( s );
[ 1, 2, 2, 4, 4, 3, 6, 8, 8, 7, 7 ]

##  doc2/ambigfus.xml (3564-3577)
gap> g:= AtlasGroup( "G2(5)" );;
gap> u:= AtlasSubgroup( "G2(5)", 7 );;
gap> Size( u );
1344
gap> repeat
>      x:= Random( u );
>    until Order( x ) = 6;
gap> siz:= Size( Centralizer( g, x ) );
36
gap> Filtered( [ 1 .. NrConjugacyClasses( t ) ],
>              i -> SizesCentralizers( t )[i] = siz );
[ 14 ]

##  doc2/ambigfus.xml (3585-3588)
gap> GetFusionMap( s, t ) in Filtered( sfust, map -> 14 in map );  
true

##  doc2/ambigfus.xml (3602-3611)
gap> b:= CharacterTable( "B" );;
gap> m:= CharacterTable( "5^(1+4).2^(1+4).A5.4" );;
gap> mfusb:= PossibleClassFusions( m, b );;
gap> Length( mfusb );
4
gap> repres:= RepresentativesFusions( m, mfusb, b );; 
gap> Length( repres );
2

##  doc2/ambigfus.xml (3620-3633)
gap> char:= Filtered( Irr( b ), x -> x[1] = 4371 );;
gap> Length( char );
1
gap> rest:= List( repres, map -> char[1]{ map } );;
gap> scprs:= MatScalarProducts( m, Irr( m ), rest );;
gap> constit:= List( scprs,
>                x -> Filtered( [1 .. Length(x) ], i -> x[i] <> 0 ) );
[ [ 2, 27, 60, 63, 73, 74, 75, 79, 82 ], 
  [ 2, 27, 60, 63, 70, 72, 75, 79, 84 ] ]
gap> List( constit, x -> List( Irr( m ){ x }, Degree ) );
[ [ 1, 6, 384, 480, 400, 400, 500, 1000, 1200 ], 
  [ 1, 6, 384, 480, 100, 300, 500, 1000, 1600 ] ]

##  doc2/ambigfus.xml (3647-3653)
gap> g:= AtlasSubgroup( "B", Dimension, 4371, Ring, GF(3), 21 );;
gap> module:= GModuleByMats( GeneratorsOfGroup( g ), GF(3) );;
gap> dec:= MTX.CompositionFactors( module );;
gap> SortedList( List( dec, x -> x.dimension ) );
[ 1, 6, 100, 384, 400, 400, 400, 480, 1000, 1200 ]

##  doc2/ambigfus.xml (3703-3729)
gap> tbl:= CharacterTable( "7^2:2psl(2,7)" );
CharacterTable( "7^2:2psl(2,7)" )
gap> tom:= TableOfMarks( tbl );
TableOfMarks( "7^2:2L2(7)" )
gap> fus:= PossibleFusionsCharTableTom( tbl, tom );
[ [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 8, 10, 9, 16, 7, 10, 9, 8, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 9, 8, 10, 16, 7, 8, 10, 9, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 10, 9, 8, 16, 7, 9, 8, 10, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 8, 9, 10, 16, 7, 9, 10, 8, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 10, 8, 9, 16, 7, 8, 9, 10, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 9, 10, 8, 16, 7, 10, 8, 9, 16 ] ]
gap> reps:= RepresentativesFusions( tbl, fus, Group(()) );        
[ [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 8, 9, 10, 16, 7, 9, 10, 8, 16 ], 
  [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 8, 10, 9, 16, 7, 10, 9, 8, 16 ] ]
gap> AutomorphismsOfTable( tbl );
Group([ (9,14)(10,17)(11,15)(12,16)(13,18), (7,8), (10,11,12)
  (15,16,17) ])
gap> OrdersClassRepresentatives( tbl );
[ 1, 7, 2, 4, 3, 6, 8, 8, 7, 7, 7, 7, 14, 7, 7, 7, 7, 14 ]
gap> perms1:= PermCharsTom( reps[1], tom );;
gap> perms2:= PermCharsTom( reps[2], tom );;
gap> perms1 = perms2;      
false
gap> Set( perms1 ) = Set( perms2 );
true

##  doc2/ambigfus.xml (3746-3827)
gap> Display( tbl );
7^2:2psl(2,7)

      2  4  .  4  3  1  1  3  3   1   .   .   .   1   1   .   .   .
      3  1  .  1  .  1  1  .  .   .   .   .   .   .   .   .   .   .
      7  3  3  1  .  .  .  .  .   2   2   2   2   1   2   2   2   2

        1a 7a 2a 4a 3a 6a 8a 8b  7b  7c  7d  7e 14a  7f  7g  7h  7i
     2P 1a 7a 1a 2a 3a 3a 4a 4a  7b  7c  7d  7e  7b  7f  7g  7h  7i
     3P 1a 7a 2a 4a 1a 2a 8b 8a  7f  7i  7g  7h 14b  7b  7d  7e  7c
     5P 1a 7a 2a 4a 3a 6a 8b 8a  7f  7i  7g  7h 14b  7b  7d  7e  7c
     7P 1a 1a 2a 4a 3a 6a 8a 8b  1a  1a  1a  1a  2a  1a  1a  1a  1a
    11P 1a 7a 2a 4a 3a 6a 8b 8a  7b  7c  7d  7e 14a  7f  7g  7h  7i
    13P 1a 7a 2a 4a 3a 6a 8b 8a  7f  7i  7g  7h 14b  7b  7d  7e  7c

X.1      1  1  1  1  1  1  1  1   1   1   1   1   1   1   1   1   1
X.2      3  3  3 -1  .  .  1  1   B   B   B   B   B  /B  /B  /B  /B
X.3      3  3  3 -1  .  .  1  1  /B  /B  /B  /B  /B   B   B   B   B
X.4      6  6  6  2  .  .  .  .  -1  -1  -1  -1  -1  -1  -1  -1  -1
X.5      7  7  7 -1  1  1 -1 -1   .   .   .   .   .   .   .   .   .
X.6      8  8  8  . -1 -1  .  .   1   1   1   1   1   1   1   1   1
X.7      4  4 -4  .  1 -1  .  .  -B  -B  -B  -B   B -/B -/B -/B -/B
X.8      4  4 -4  .  1 -1  .  . -/B -/B -/B -/B  /B  -B  -B  -B  -B
X.9      6  6 -6  .  .  .  A -A  -1  -1  -1  -1   1  -1  -1  -1  -1
X.10     6  6 -6  .  .  . -A  A  -1  -1  -1  -1   1  -1  -1  -1  -1
X.11     8  8 -8  . -1  1  .  .   1   1   1   1  -1   1   1   1   1
X.12    48 -1  .  .  .  .  .  .   6  -1  -1  -1   .   6  -1  -1  -1
X.13    48 -1  .  .  .  .  .  .   C  -1  /C  /D   .  /C   C   D  -1
X.14    48 -1  .  .  .  .  .  .   C  /C  /D  -1   .  /C   D  -1   C
X.15    48 -1  .  .  .  .  .  .  /C   D  -1   C   .   C  -1  /C  /D
X.16    48 -1  .  .  .  .  .  .   C  /D  -1  /C   .  /C  -1   C   D
X.17    48 -1  .  .  .  .  .  .  /C   C   D  -1   .   C  /D  -1  /C
X.18    48 -1  .  .  .  .  .  .  /C  -1   C   D   .   C  /C  /D  -1

      2   1
      3   .
      7   1

        14b
     2P  7f
     3P 14a
     5P 14a
     7P  2a
    11P 14b
    13P 14a

X.1       1
X.2      /B
X.3       B
X.4      -1
X.5       .
X.6       1
X.7      /B
X.8       B
X.9       1
X.10      1
X.11     -1
X.12      .
X.13      .
X.14      .
X.15      .
X.16      .
X.17      .
X.18      .

A = E(8)-E(8)^3
  = Sqrt(2) = r2
B = E(7)+E(7)^2+E(7)^4
  = (-1+Sqrt(-7))/2 = b7
C = 2*E(7)+2*E(7)^2+2*E(7)^4
  = -1+Sqrt(-7) = 2b7
D = -3*E(7)-3*E(7)^2-2*E(7)^3-3*E(7)^4-2*E(7)^5-2*E(7)^6
  = (5-Sqrt(-7))/2 = 2-b7
gap> mat:= MatTom( tom );;
gap> mataut:= MatrixAutomorphisms( mat );;
gap> Print( mataut, "\n" );
Group( [ (11,12)(23,24)(27,28)(46,47)(53,54)(56,57), 
  ( 9,10)(20,21)(31,32)(38,39), ( 8, 9)(20,22)(31,33)(38,40) ] )
gap> RepresentativesFusions( Group( () ), reps, mataut );
[ [ 1, 6, 2, 4, 3, 5, 13, 13, 7, 8, 9, 10, 16, 7, 9, 10, 8, 16 ] ]

##  doc2/ambigfus.xml (3839-3851)
gap> g:= UnderlyingGroup( tom );;
gap> tg:= CharacterTable( g );;
gap> tgfustom:= FusionCharTableTom( tg, tom );;
gap> trans:= TransformingPermutationsCharacterTables( tg, tbl );;
gap> tblfustom:= Permuted( tgfustom, trans.columns );;
gap> orbits:= List( reps, map -> OrbitFusions( AutomorphismsOfTable( tbl ),
>                                              map, Group( () ) ) );;
gap> PositionProperty( orbits, orb -> tblfustom in orb );
2
gap> PositionProperty( orbits, orb -> FusionToTom( tbl ).map in orb );
2

##  doc2/ambigfus.xml (3872-3880)
gap> u42:= CharacterTable( "U4(2)" );;
gap> u43:= CharacterTable( "U4(3)" );;
gap> u42fusu43:= PossibleClassFusions( u42, u43 );;
gap> Length( u42fusu43 );
4
gap> Length( RepresentativesFusions( u42, u42fusu43, u43 ) );
1

##  doc2/ambigfus.xml (3905-3914)
gap> u43_21:= CharacterTable( "U4(3).2_1" );;
gap> fus1:= GetFusionMap( u43, u43_21 );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 17, 17, 
  18 ]
gap> act1:= Filtered( InverseMap( fus1 ), IsList );
[ [ 16, 17 ], [ 18, 19 ] ]
gap> CompositionMaps( ClassNames( u43, "Atlas" ), act1 );
[ [ "9A", "9B" ], [ "9C", "9D" ] ]

##  doc2/ambigfus.xml (3925-3935)
gap> u43_23:= CharacterTable( "U4(3).2_3" );;
gap> fus3:= GetFusionMap( u43, u43_23 );
[ 1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 13, 14, 13, 14, 
  15 ]
gap> act3:= Filtered( InverseMap( fus3 ), IsList );
[ [ 4, 5 ], [ 11, 12 ], [ 13, 14 ], [ 16, 18 ], [ 17, 19 ] ]
gap> CompositionMaps( ClassNames( u43, "Atlas" ), act3 );
[ [ "3B", "3C" ], [ "6B", "6C" ], [ "7A", "7B" ], [ "9A", "9C" ], 
  [ "9B", "9D" ] ]

##  doc2/ambigfus.xml (3953-3960)
gap> firstfus:= First( u42fusu43, x -> IsSubset( x, [ 16, 17 ] ) );
[ 1, 2, 2, 3, 3, 5, 4, 7, 8, 9, 10, 10, 12, 12, 11, 12, 16, 17, 20, 
  20 ]
gap> secondfus:= First( u42fusu43, x -> IsSubset( x, [ 18, 19 ] ) );
[ 1, 2, 2, 3, 3, 4, 5, 7, 8, 9, 10, 10, 11, 11, 12, 11, 18, 19, 20, 
  20 ]

##  doc2/ambigfus.xml (3973-3983)
gap> 3u42:= CharacterTable( "Cyclic", 3 ) * u42;
CharacterTable( "C3xU4(2)" )
gap> 3u43:= CharacterTable( "3_1.U4(3)" );
CharacterTable( "3_1.U4(3)" )
gap> 3u42fus3u43:= PossibleClassFusions( 3u42, 3u43 );;
gap> Length( 3u42fus3u43 );
8
gap> Length( RepresentativesFusions( 3u42, 3u42fus3u43, 3u43 ) );
2

##  doc2/ambigfus.xml (3997-4003)
gap> inducedmaps:= List( 3u42fus3u43, map -> CompositionMaps(
>        GetFusionMap( 3u43, u43 ), CompositionMaps( map,
>        InverseMap( GetFusionMap( 3u42, u42 ) ) ) ) );;
gap> List( inducedmaps, map -> Position( u42fusu43, map ) );
[ 1, 1, 2, 2, 4, 4, 3, 3 ]

##  doc2/ambigfus.xml (4033-4061)
gap> rep:= RepresentativesFusions( 3u42, 3u42fus3u43, 3u43 );
[ [ 1, 4, 4, 7, 7, 10, 13, 15, 18, 21, 24, 24, 27, 27, 30, 27, 48, 
      49, 50, 50, 2, 5, 5, 8, 8, 11, 13, 16, 19, 22, 25, 25, 28, 28, 
      31, 28, 48, 49, 51, 51, 3, 6, 6, 9, 9, 12, 13, 17, 20, 23, 26, 
      26, 29, 29, 32, 29, 48, 49, 52, 52 ], 
  [ 1, 4, 4, 8, 9, 13, 10, 15, 18, 21, 25, 26, 31, 32, 27, 30, 46, 
      44, 51, 52, 2, 5, 5, 9, 7, 13, 11, 16, 19, 22, 26, 24, 32, 30, 
      28, 31, 47, 42, 52, 50, 3, 6, 6, 7, 8, 13, 12, 17, 20, 23, 24, 
      25, 30, 31, 29, 32, 45, 43, 50, 51 ] ]
gap> irr:= Irr( 3u42 );;
gap> ind:= InducedClassFunctionsByFusionMap( 3u42, 3u43, irr, rep[1] );;
gap> Intersection( ind, Irr( 3u43 ) );
[ Character( CharacterTable( "3_1.U4(3)" ),
  [ 630, 630*E(3)^2, 630*E(3), 6, 6*E(3)^2, 6*E(3), 9, 9*E(3)^2, 
      9*E(3), -9, -9*E(3)^2, -9*E(3), 0, 0, 2, 2*E(3)^2, 2*E(3), -2, 
      -2*E(3)^2, -2*E(3), 0, 0, 0, -3, -3*E(3)^2, -3*E(3), 3, 
      3*E(3)^2, 3*E(3), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, -1, -E(3)^2, -E(3) ] ), 
  Character( CharacterTable( "3_1.U4(3)" ),
  [ 630, 630*E(3), 630*E(3)^2, 6, 6*E(3), 6*E(3)^2, 9, 9*E(3), 
      9*E(3)^2, -9, -9*E(3), -9*E(3)^2, 0, 0, 2, 2*E(3), 2*E(3)^2, 
      -2, -2*E(3), -2*E(3)^2, 0, 0, 0, -3, -3*E(3), -3*E(3)^2, 3, 
      3*E(3), 3*E(3)^2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, -1, -E(3), -E(3)^2 ] ) ]
gap> ind:= InducedClassFunctionsByFusionMap( 3u42, 3u43, irr, rep[2] );;
gap> Intersection( ind, Irr( 3u43 ) );
[  ]

##  doc2/ambigfus.xml (4091-4100)
gap> 2a12:= CharacterTable( "2.A12" );;
gap> mtbl:= CharacterTable( "2.3^4.2^3.S4" );;
gap> mtblfus2a12:= PossibleClassFusions( mtbl, 2a12 );;
gap> Length( mtblfus2a12 );
32
gap> repres:= RepresentativesFusions( mtbl, mtblfus2a12, 2a12 );; 
gap> Length( repres );
2

##  doc2/ambigfus.xml (4134-4154)
gap> g:= AtlasGroup( "A12" );
Group([ (1,2,3), (2,3,4,5,6,7,8,9,10,11,12) ])
gap> 2g:= AtlasGroup( "2.A12" );
<matrix group of size 479001600 with 2 generators>
gap> f:= FreeGroup( 2 );;
gap> pi1:= GroupHomomorphismByImagesNC( f, 2g, GeneratorsOfGroup( f ),
>              GeneratorsOfGroup( 2g ) );;
gap> pi2:= GroupHomomorphismByImagesNC( f, g, GeneratorsOfGroup( f ),
>              GeneratorsOfGroup( g ) );;
gap> w:= WreathProduct( SymmetricGroup( 3 ), SymmetricGroup(4) );
<permutation group of size 31104 with 10 generators>
gap> NrMovedPoints( w );
12
gap> s:= Intersection( w, g );  Size( s );
<permutation group with 8 generators>
15552
gap> m:= SubgroupNC( 2g, List( SmallGeneratingSet( s ),
>            x -> ImagesRepresentative( pi1,
>                   PreImagesRepresentative( pi2, x ) ) ) );;

##  doc2/ambigfus.xml (4163-4171)
gap> iso:= IsomorphismPermGroup( m );;
gap> t:= CharacterTable( Image( iso ) );;
gap> Size( t );
31104
gap> trans:= TransformingPermutationsCharacterTables( mtbl, t );;
gap> IsRecord( trans );
true

##  doc2/ambigfus.xml (4179-4189)
gap> para:= Parametrized( repres );
[ 1, 2, 6, 10, 8, 12, 7, 11, 9, 13, 5, 5, 17, 17, 17, 17, 3, 4, 24, 
  22, 27, 25, 12, 10, 13, 11, 28, 29, 35, 37, 39, 36, 38, 40, 5, 23, 
  28, 29, 26, 14, 14, 16, 16, 33, 34, [ 33, 34 ], [ 33, 34 ], 49, 49, 
  48, 48 ]
gap> PositionsProperty( para, IsList );
[ 46, 47 ]
gap> List( repres, map -> map{ [ 44 .. 47 ] } );
[ [ 33, 34, 33, 34 ], [ 33, 34, 34, 33 ] ]

##  doc2/ambigfus.xml (4200-4207)
gap> positions:= OnTuples( [ 44 .. 47 ], trans.columns );;
gap> classreps:= List( ConjugacyClasses( t ){ positions },
>        c -> PreImagesRepresentative( iso, Representative( c ) ) );;
gap> traces:= List( classreps, TraceMat );;
gap> List( traces, x -> Position( traces, x ) );
[ 1, 2, 2, 1 ]

##  doc2/ambigfus.xml (4221-4226)
gap> good:= First( repres,
>                  map -> map{ [ 44 .. 47 ] } = [ 33, 34, 34, 33 ] );;
gap> GetFusionMap( mtbl, 2a12 ) = good;
true

##  doc2/ambigfus.xml (4241-4250)
gap> t:= CharacterTable( "L7(2)" );;
gap> s:= CharacterTable( "127:7" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> repr:= RepresentativesFusions( s, fus, t );
[ [ 1, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 
      112, 113, 114, 115, 117, 116, 76, 76, 77, 76, 77, 77 ], 
  [ 1, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 
      112, 113, 114, 115, 117, 116, 83, 83, 83, 83, 83, 83 ] ]

##  doc2/ambigfus.xml (4258-4268)
gap> diff:= Filtered( [ 1 .. Length( repr[1] ) ],
>                     i -> repr[1][i] <> repr[2][i] );
[ 20, 21, 22, 23, 24, 25 ]
gap> OrdersClassRepresentatives( s ){ diff };
[ 7, 7, 7, 7, 7, 7 ]
gap> List( repr, l -> l{ diff } );
[ [ 76, 76, 77, 76, 77, 77 ], [ 83, 83, 83, 83, 83, 83 ] ]
gap> SizesCentralizers( t ){ [ 76, 77, 83 ] };
[ 3528, 3528, 49 ]

##  doc2/ambigfus.xml (4278-4288)
gap> g:= Image( IsomorphismPermGroup( GL(7,2) ) );;
gap> repeat x:= Random( g ); until Order(x) = 127;
gap> n:= Normalizer( g, SubgroupNC( g, [ x ] ) );;
gap> Size( n ) / 127;
7
gap> repeat x:= Random( n ); until Order( x ) = 7;
gap> c:= Centralizer( g, x );;
gap> Size( c );
49

##  doc2/ambigfus.xml (4296-4299)
gap> GetFusionMap( s, t ) = repr[2];
true

##  doc2/ambigfus.xml (4324-4343)
gap> t:= CharacterTable( "M" );;
gap> s:= CharacterTable( "L2(59)" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> repr:= RepresentativesFusions( s, fus, t );
[ [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 98, 52, 32, 52, 14, 12, 98, 52, 32, 5, 98, 12, 98, 52, 3 ], 
  [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 100, 50, 30, 50, 15, 11, 100, 50, 30, 4, 100, 11, 100, 50, 
      3 ], 
  [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 101, 51, 30, 51, 14, 11, 101, 51, 30, 5, 101, 11, 101, 51, 
      3 ], 
  [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 102, 53, 32, 53, 18, 12, 102, 53, 32, 6, 102, 12, 102, 53, 
      3 ], 
  [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 104, 52, 33, 52, 17, 12, 104, 52, 33, 5, 104, 12, 104, 52, 
      3 ] ]

##  doc2/ambigfus.xml (4351-4358)
gap> ord:= OrdersClassRepresentatives( s );;
gap> ord30:= Filtered( [ 1 .. Length( ord ) ], i -> ord[i] = 30 );
[ 18, 24, 28, 30 ]
gap> List( repr, x -> x{ ord30 } );
[ [ 98, 98, 98, 98 ], [ 100, 100, 100, 100 ], [ 101, 101, 101, 101 ], 
  [ 102, 102, 102, 102 ], [ 104, 104, 104, 104 ] ]

##  doc2/ambigfus.xml (4371-4386)
gap> pos:= Position( ClassNames( t, "Atlas" ), "30G" );;
gap> good:= Filtered( fus, map -> pos in map );
[ [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 104, 52, 33, 52, 17, 12, 104, 52, 33, 5, 104, 12, 104, 52, 
      3 ], 
  [ 1, 153, 152, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 104, 52, 33, 52, 17, 12, 104, 52, 33, 5, 104, 12, 104, 52, 
      3 ] ]
gap> repr:= RepresentativesFusions( s, good, t );
[ [ 1, 152, 153, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 
      97, 104, 52, 33, 52, 17, 12, 104, 52, 33, 5, 104, 12, 104, 52, 
      3 ] ]
gap> GetFusionMap( s, t ) = fail;
true

##  doc2/ambigfus.xml (4401-4424)
gap> t:= CharacterTable( "M" );;
gap> s:= CharacterTable( "L2(71)" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> repr:= RepresentativesFusions( s, fus, t );
[ [ 1, 169, 170, 112, 112, 112, 112, 19, 112, 11, 112, 112, 19, 112, 
      112, 112, 11, 19, 112, 112, 114, 60, 36, 27, 114, 17, 114, 27, 
      7, 60, 114, 5, 114, 60, 36, 27, 114, 3 ], 
  [ 1, 169, 170, 112, 112, 112, 112, 19, 112, 11, 112, 112, 19, 112, 
      112, 112, 11, 19, 112, 112, 115, 61, 36, 28, 115, 17, 115, 28, 
      7, 61, 115, 5, 115, 61, 36, 28, 115, 3 ], 
  [ 1, 169, 170, 112, 112, 112, 112, 19, 112, 11, 112, 112, 19, 112, 
      112, 112, 11, 19, 112, 112, 117, 61, 43, 28, 117, 17, 117, 28, 
      9, 61, 117, 5, 117, 61, 43, 28, 117, 3 ], 
  [ 1, 169, 170, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 114, 60, 36, 27, 114, 17, 114, 27, 
      7, 60, 114, 5, 114, 60, 36, 27, 114, 3 ], 
  [ 1, 169, 170, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 115, 61, 36, 28, 115, 17, 115, 28, 
      7, 61, 115, 5, 115, 61, 36, 28, 115, 3 ], 
  [ 1, 169, 170, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 117, 61, 43, 28, 117, 17, 117, 28, 
      9, 61, 117, 5, 117, 61, 43, 28, 117, 3 ] ]

##  doc2/ambigfus.xml (4433-4441)
gap> ord:= OrdersClassRepresentatives( s );;
gap> ord36:= Filtered( [ 1 .. Length( ord ) ], i -> ord[i] = 36 );
[ 21, 25, 27, 31, 33, 37 ]
gap> List( repr, x -> x{ ord36 } );
[ [ 114, 114, 114, 114, 114, 114 ], [ 115, 115, 115, 115, 115, 115 ], 
  [ 117, 117, 117, 117, 117, 117 ], [ 114, 114, 114, 114, 114, 114 ], 
  [ 115, 115, 115, 115, 115, 115 ], [ 117, 117, 117, 117, 117, 117 ] ]

##  doc2/ambigfus.xml (4451-4468)
gap> pos1:= Position( ClassNames( t, "Atlas" ), "7B" );;
gap> pos2:= Position( ClassNames( t, "Atlas" ), "36D" );;
gap> pos:= [ pos1, pos2 ];;
gap> good:= Filtered( fus, map -> IsSubset( map, pos ) );
[ [ 1, 169, 170, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 117, 61, 43, 28, 117, 17, 117, 28, 
      9, 61, 117, 5, 117, 61, 43, 28, 117, 3 ], 
  [ 1, 170, 169, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 117, 61, 43, 28, 117, 17, 117, 28, 
      9, 61, 117, 5, 117, 61, 43, 28, 117, 3 ] ]
gap> repr:= RepresentativesFusions( s, good, t );
[ [ 1, 169, 170, 113, 113, 113, 113, 20, 113, 12, 113, 113, 20, 113, 
      113, 113, 12, 20, 113, 113, 117, 61, 43, 28, 117, 17, 117, 28, 
      9, 61, 117, 5, 117, 61, 43, 28, 117, 3 ] ]
gap> GetFusionMap( s, t ) = repr[1];
true

##  doc2/ambigfus.xml (4483-4510)
gap> t:= CharacterTable( "M" );;
gap> s:= CharacterTable( "L2(41)" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> repr:= RepresentativesFusions( s, fus, t );
[ [ 1, 127, 127, 64, 30, 64, 11, 7, 30, 64, 11, 64, 3, 70, 70, 19, 
      70, 70, 19, 4, 70, 19, 70 ], 
  [ 1, 127, 127, 64, 30, 64, 11, 7, 30, 64, 11, 64, 3, 72, 72, 19, 
      72, 72, 19, 6, 72, 19, 72 ], 
  [ 1, 127, 127, 64, 30, 64, 11, 7, 30, 64, 11, 64, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ], 
  [ 1, 127, 127, 66, 33, 66, 12, 7, 33, 66, 12, 66, 3, 72, 72, 19, 
      72, 72, 19, 6, 72, 19, 72 ], 
  [ 1, 127, 127, 66, 33, 66, 12, 7, 33, 66, 12, 66, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ], 
  [ 1, 127, 127, 67, 30, 67, 11, 10, 30, 67, 11, 67, 3, 72, 72, 19, 
      72, 72, 19, 6, 72, 19, 72 ], 
  [ 1, 127, 127, 67, 30, 67, 11, 10, 30, 67, 11, 67, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ], 
  [ 1, 127, 127, 68, 32, 68, 12, 10, 32, 68, 12, 68, 3, 72, 72, 19, 
      72, 72, 19, 6, 72, 19, 72 ], 
  [ 1, 127, 127, 68, 32, 68, 12, 10, 32, 68, 12, 68, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ], 
  [ 1, 127, 127, 69, 33, 69, 12, 9, 33, 69, 12, 69, 3, 72, 72, 19, 
      72, 72, 19, 6, 72, 19, 72 ], 
  [ 1, 127, 127, 69, 33, 69, 12, 9, 33, 69, 12, 69, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ] ]

##  doc2/ambigfus.xml (4519-4526)
gap> ambig:= Parametrized( repr );;
gap> ambigpos:= PositionsProperty( ambig, IsList );
[ 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 
  23 ]
gap> Set( OrdersClassRepresentatives( t ){ ambigpos } );
[ 3, 4, 5, 6, 7, 8 ]

##  doc2/ambigfus.xml (4537-4546)
gap> pos1:= Position( ClassNames( t, "Atlas" ), "3B" );;
gap> pos2:= Position( ClassNames( t, "Atlas" ), "4C" );;
gap> pos:= [ pos1, pos2 ];;
gap> good:= Filtered( fus, map -> IsSubset( map, pos ) );
[ [ 1, 127, 127, 69, 33, 69, 12, 9, 33, 69, 12, 69, 3, 73, 73, 20, 
      73, 73, 20, 5, 73, 20, 73 ] ]
gap> GetFusionMap( s, t ) = good[1];
true

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "ambigfus.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
