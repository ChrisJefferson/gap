# This file was created automatically, do not edit!
#############################################################################
##
#W  ctblpope.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "ctblpope.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "ctblpope.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/ctblpope.xml (76-79)
gap> LoadPackage( "ctbllib", "1.2", false );
true

##  doc2/ctblpope.xml (91-98)
gap> g:= MathieuGroup( 24 );;
gap> SetName( g, "m24" );
gap> Size( g );  IsSimple( g );  NrMovedPoints( g );
244823040
true
24

##  doc2/ctblpope.xml (109-117)
gap> ccl:= AttributeValueNotSet( ConjugacyClasses, g );;
gap> HasConjugacyClasses( g );
false
gap> invariants:= List( ccl, c -> [ Order( Representative( c ) ),
>        Size( c ), Size( ConjugacyClass( g, Representative( c )^2 ) ) ] );;
gap> SortParallel( invariants, ccl );
gap> SetConjugacyClasses( g, ccl );

##  doc2/ctblpope.xml (127-162)
gap> NrConjugacyClasses( g );
26
gap> pi:= NaturalCharacter( g );
Character( CharacterTable( m24 ),
 [ 24, 8, 0, 6, 0, 0, 4, 0, 4, 2, 0, 3, 3, 2, 0, 2, 0, 0, 1, 1, 1, 1, 
  0, 0, 1, 1 ] )
gap> IsTransitive( pi );  Transitivity( pi );
true
5
gap> SetIdentifier( CharacterTable( g ), "M24table" );
gap> Display( pi );
M24table

     2 10 10  9  3  3  7  7  5  2  3  3  1  1  4   2   .   2   2   1
     3  3  1  1  3  2  1  .  1  1  1  1  1  1  .   .   .   1   1   .
     5  1  .  1  1  .  .  .  .  1  .  .  .  .  .   1   .   .   .   .
     7  1  1  .  .  1  .  .  .  .  .  .  1  1  .   .   .   .   .   1
    11  1  .  .  .  .  .  .  .  .  .  .  .  .  .   .   1   .   .   .
    23  1  .  .  .  .  .  .  .  .  .  .  .  .  .   .   .   .   .   .

       1a 2a 2b 3a 3b 4a 4b 4c 5a 6a 6b 7a 7b 8a 10a 11a 12a 12b 14a

Y.1    24  8  .  6  .  .  4  .  4  2  .  3  3  2   .   2   .   .   1

     2   1   .   .   .   .   .   .
     3   .   1   1   1   1   .   .
     5   .   1   1   .   .   .   .
     7   1   .   .   1   1   .   .
    11   .   .   .   .   .   .   .
    23   .   .   .   .   .   1   1

       14b 15a 15b 21a 21b 23a 23b

Y.1      1   1   1   .   .   1   1

##  doc2/ctblpope.xml (179-192)
gap> piop:= pi * pi;
Character( CharacterTable( m24 ),
 [ 576, 64, 0, 36, 0, 0, 16, 0, 16, 4, 0, 9, 9, 4, 0, 4, 0, 0, 1, 1, 
  1, 1, 0, 0, 1, 1 ] )
gap> IsTransitive( piop );
false
gap> piup:= SymmetricParts( UnderlyingCharacterTable(pi), [ pi ], 2 )[1];
Character( CharacterTable( m24 ),
 [ 300, 44, 12, 21, 0, 4, 12, 0, 10, 5, 0, 6, 6, 4, 2, 3, 0, 1, 2, 2, 
  1, 1, 0, 0, 1, 1 ] )
gap> IsTransitive( piup );
false

##  doc2/ctblpope.xml (203-214)
gap> ScalarProduct( piup, TrivialCharacter( g ) );
2
gap> comb:= Combinations( [ 1 .. 24 ], 2 );;
gap> hom:= ActionHomomorphism( g, comb, OnSets );;
gap> pihom:= NaturalCharacter( hom );
Character( CharacterTable( m24 ),
 [ 276, 36, 12, 15, 0, 4, 8, 0, 6, 3, 0, 3, 3, 2, 2, 1, 0, 1, 1, 1, 
  0, 0, 0, 0, 0, 0 ] )
gap> Transitivity( pihom );
1

##  doc2/ctblpope.xml (227-237)
gap> pi2s:= piup - pi;
VirtualCharacter( CharacterTable( m24 ),
 [ 276, 36, 12, 15, 0, 4, 8, 0, 6, 3, 0, 3, 3, 2, 2, 1, 0, 1, 1, 1, 
  0, 0, 0, 0, 0, 0 ] )
gap> pi2s = pihom;
true
gap> HasIrr( g );  HasIrr( CharacterTable( g ) );
false
false

##  doc2/ctblpope.xml (253-256)
gap> IsPrimitive( g, comb, OnSets );
true

##  doc2/ctblpope.xml (274-286)
gap> tbl:= CharacterTable( "M24" );
CharacterTable( "M24" )
gap> maxes:= Maxes( tbl );
[ "M23", "M22.2", "2^4:a8", "M12.2", "2^6:3.s6", "L3(4).3.2_2", 
  "2^6:(psl(3,2)xs3)", "L2(23)", "L3(2)" ]
gap> s:= CharacterTable( maxes[2] );
CharacterTable( "M22.2" )
gap> TrivialCharacter( s )^tbl;
Character( CharacterTable( "M24" ),
 [ 276, 36, 12, 15, 0, 4, 8, 0, 6, 3, 0, 3, 3, 2, 2, 1, 1, 0, 1, 1, 
  0, 0, 0, 0, 0, 0 ] )

##  doc2/ctblpope.xml (312-357)
gap> m11:= CharacterTable( "M11" );;
gap> SetName( m11, "m11" );
gap> perms:= PermChars( m11 );
[ Character( m11, [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ), Character( m11,
  [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ), Character( m11,
  [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ), Character( m11,
  [ 22, 6, 4, 2, 2, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ), Character( m11,
  [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ), Character( m11,
  [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ), Character( m11,
  [ 110, 6, 2, 6, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 110, 14, 2, 2, 0, 2, 0, 0, 0, 0 ] ), Character( m11,
  [ 132, 12, 6, 0, 2, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 144, 0, 0, 0, 4, 0, 0, 0, 1, 1 ] ), Character( m11,
  [ 165, 13, 3, 1, 0, 1, 1, 1, 0, 0 ] ), Character( m11,
  [ 220, 4, 4, 0, 0, 4, 0, 0, 0, 0 ] ), Character( m11,
  [ 220, 12, 4, 4, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 220, 20, 4, 0, 0, 2, 0, 0, 0, 0 ] ), Character( m11,
  [ 330, 2, 6, 2, 0, 2, 0, 0, 0, 0 ] ), Character( m11,
  [ 330, 18, 6, 2, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 396, 12, 0, 4, 1, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 440, 8, 8, 0, 0, 2, 0, 0, 0, 0 ] ), Character( m11,
  [ 440, 24, 8, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 495, 15, 0, 3, 0, 0, 1, 1, 0, 0 ] ), Character( m11,
  [ 660, 4, 3, 4, 0, 1, 0, 0, 0, 0 ] ), Character( m11,
  [ 660, 12, 3, 0, 0, 3, 0, 0, 0, 0 ] ), Character( m11,
  [ 660, 12, 12, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 660, 28, 3, 0, 0, 1, 0, 0, 0, 0 ] ), Character( m11,
  [ 720, 0, 0, 0, 0, 0, 0, 0, 5, 5 ] ), Character( m11,
  [ 792, 24, 0, 0, 2, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 880, 0, 16, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 990, 6, 0, 2, 0, 0, 2, 2, 0, 0 ] ), Character( m11,
  [ 990, 6, 0, 6, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 990, 30, 0, 2, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 1320, 8, 6, 0, 0, 2, 0, 0, 0, 0 ] ), Character( m11,
  [ 1320, 24, 6, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 1584, 0, 0, 0, 4, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 1980, 12, 0, 4, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 1980, 36, 0, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 2640, 0, 12, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 3960, 24, 0, 0, 0, 0, 0, 0, 0, 0 ] ), Character( m11,
  [ 7920, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> Length( perms );
39

##  doc2/ctblpope.xml (374-382)
gap> degrees:= DivisorsInt( Size( m11 ) );;
gap> perms2:= [];;
gap> for d in degrees do
>      Append( perms2, PermChars( m11, d ) );
>    od;
gap> Set( perms ) = Set( perms2 );
true

##  doc2/ctblpope.xml (391-398)
gap> perms3:= [];;
gap> for d in degrees do
>      Append( perms3, PermChars( m11, rec( torso:= [ d ] ) ) );
>    od;
gap> Set( perms ) = Set( perms3 );
true

##  doc2/ctblpope.xml (412-421)
gap> newperms:= TestPerm4( m11, perms );;
gap> newperms = perms;
true
gap> newperms:= TestPerm5( m11, perms, m11 mod 11 );;
gap> newperms = perms;
false
gap> Difference( perms, newperms );
[ Character( m11, [ 220, 4, 4, 0, 0, 4, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (433-444)
gap> tom:= TableOfMarks( "M11" );
TableOfMarks( "M11" )
gap> trueperms:= PermCharsTom( m11, tom );;
gap> Length( trueperms );  Length( Set( trueperms ) );
39
36
gap> Difference( perms, trueperms );
[ Character( m11, [ 220, 4, 4, 0, 0, 4, 0, 0, 0, 0 ] ), 
  Character( m11, [ 660, 4, 3, 4, 0, 1, 0, 0, 0, 0 ] ), 
  Character( m11, [ 660, 12, 3, 0, 0, 3, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (466-478)
gap> u62:= CharacterTable( "U6(2)" );;
gap> m22:= CharacterTable( "M22" );;
gap> fus:= PossibleClassFusions( m22, u62 );
[ [ 1, 3, 7, 10, 14, 15, 22, 24, 24, 26, 33, 34 ], 
  [ 1, 3, 7, 10, 14, 15, 22, 24, 24, 26, 34, 33 ], 
  [ 1, 3, 7, 11, 14, 15, 22, 24, 24, 27, 33, 34 ], 
  [ 1, 3, 7, 11, 14, 15, 22, 24, 24, 27, 34, 33 ], 
  [ 1, 3, 7, 12, 14, 15, 22, 24, 24, 28, 33, 34 ], 
  [ 1, 3, 7, 12, 14, 15, 22, 24, 24, 28, 34, 33 ] ]
gap> RepresentativesFusions( m22, fus, u62 );
[ [ 1, 3, 7, 10, 14, 15, 22, 24, 24, 26, 33, 34 ] ]

##  doc2/ctblpope.xml (487-512)
gap> cand:= Set( fus,
>  x -> Induced( m22, u62, [ TrivialCharacter( m22 ) ], x )[1] );
[ Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 0, 0, 48, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 0, 0, 4, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ), Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 0, 48, 0, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ), Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 48, 0, 0, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 4, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( u62, cand ).ATLAS;
[ "1a+22a+252a+616a+1155c+1386a+8064a+9240c", 
  "1a+22a+252a+616a+1155b+1386a+8064a+9240b", 
  "1a+22a+252a+616a+1155a+1386a+8064a+9240a" ]
gap> aut:= AutomorphismsOfTable( u62 );;  Size( aut );
24
gap> elms:= Filtered( Elements( aut ), x -> Order( x ) = 3 );
[ (10,11,12)(26,27,28)(40,41,42), (10,12,11)(26,28,27)(40,42,41) ]
gap> Position( cand, Permuted( cand[1], elms[1] ) );
3
gap> Position( cand, Permuted( cand[3], elms[1] ) );
2

##  doc2/ctblpope.xml (534-548)
gap> u622:= CharacterTable( "U6(2).2" );;
gap> m222:= CharacterTable( "M22.2" );;
gap> fus:= PossibleClassFusions( m222, u622 );
[ [ 1, 3, 7, 10, 13, 14, 20, 22, 22, 24, 29, 38, 39, 42, 41, 46, 50, 
      53, 58, 59, 59 ] ]
gap> cand:= Induced( m222, u622, [ TrivialCharacter( m222 ) ], fus[1] );
[ Character( CharacterTable( "U6(2).2" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 48, 0, 0, 16, 6, 0, 0, 0, 0, 0, 
      6, 0, 2, 0, 4, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1080, 72, 
      0, 48, 8, 0, 0, 0, 18, 0, 0, 0, 8, 0, 0, 2, 0, 0, 0, 0, 2, 2, 
      0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( u622, cand ).ATLAS;
[ "1a+22a+252a+616a+1155a+1386a+8064a+9240a" ]

##  doc2/ctblpope.xml (673-747)
gap> o8p3:= CharacterTable("O8+(3)");;
gap> Size( o8p3 ) / (2^9*168);
57572775
gap> o8p2:= CharacterTable( "O8+(2)" );;
gap> fus:= PossibleClassFusions( o8p2, o8p3 );;
gap> Length( fus );
24
gap> rep:= RepresentativesFusions( o8p2, fus, o8p3 );
[ [ 1, 5, 2, 3, 4, 5, 7, 8, 12, 16, 17, 19, 23, 20, 21, 22, 23, 24, 
      25, 26, 37, 38, 42, 31, 32, 36, 49, 52, 51, 50, 43, 44, 45, 53, 
      55, 56, 57, 71, 71, 71, 72, 73, 74, 78, 79, 83, 88, 89, 90, 94, 
      100, 101, 105 ] ]
gap> fus:= rep[1];;
gap> Size( o8p2 ) / (2^9*168);
2025
gap> sub:= CharacterTable( "2^6:A8" );;
gap> subfus:= GetFusionMap( sub, o8p2 );
[ 1, 3, 2, 2, 4, 5, 6, 13, 3, 6, 12, 13, 14, 7, 21, 24, 11, 30, 29, 
  31, 13, 17, 15, 16, 14, 17, 36, 37, 18, 41, 24, 44, 48, 28, 33, 32, 
  34, 35, 35, 51, 51 ]
gap> fus:= CompositionMaps( fus, subfus );
[ 1, 2, 5, 5, 3, 4, 5, 23, 2, 5, 19, 23, 20, 7, 37, 31, 17, 50, 51, 
  43, 23, 23, 21, 22, 20, 23, 56, 57, 24, 72, 31, 78, 89, 52, 45, 44, 
  53, 55, 55, 100, 100 ]
gap> Size( sub ) / (2^9*168);
15
gap> List( Irr( sub ), Degree );
[ 1, 7, 14, 20, 21, 21, 21, 28, 35, 45, 45, 56, 64, 70, 28, 28, 35, 
  35, 35, 35, 70, 70, 70, 70, 140, 140, 140, 140, 140, 210, 210, 252, 
  252, 280, 280, 315, 315, 315, 315, 420, 448 ]
gap> cand:= PermChars( sub, 15 );
[ Character( CharacterTable( "2^6:A8" ),
  [ 15, 15, 15, 7, 7, 7, 7, 7, 3, 3, 3, 3, 3, 0, 0, 0, 3, 3, 3, 3, 3, 
      3, 3, 3, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0 ] ) ]
gap> ind:= Induced( sub, o8p3, cand, fus );
[ Character( CharacterTable( "O8+(3)" ),
  [ 57572775, 59535, 59535, 59535, 3591, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 2187, 0, 27, 135, 135, 135, 243, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 27, 27, 0, 0, 0, 0, 27, 
      27, 27, 27, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0 ] ) ]
gap> o8p33:= CharacterTable( "O8+(3).3" );;
gap> inv:= InverseMap( GetFusionMap( o8p3, o8p33 ) );
[ 1, [ 2, 3, 4 ], 5, 6, [ 7, 8, 9 ], [ 10, 11, 12 ], 13, 
  [ 14, 15, 16 ], 17, 18, 19, [ 20, 21, 22 ], 23, [ 24, 25, 26 ], 
  [ 27, 28, 29 ], 30, [ 31, 32, 33 ], [ 34, 35, 36 ], [ 37, 38, 39 ], 
  [ 40, 41, 42 ], [ 43, 44, 45 ], 46, [ 47, 48, 49 ], 50, 
  [ 51, 52, 53 ], 54, 55, 56, 57, [ 58, 59, 60 ], [ 61, 62, 63 ], 64, 
  [ 65, 66, 67 ], 68, [ 69, 70, 71 ], [ 72, 73, 74 ], [ 75, 76, 77 ], 
  [ 78, 79, 80 ], [ 81, 82, 83 ], 84, 85, [ 86, 87, 88 ], 
  [ 89, 90, 91 ], [ 92, 93, 94 ], 95, 96, [ 97, 98, 99 ], 
  [ 100, 101, 102 ], [ 103, 104, 105 ], [ 106, 107, 108 ], 
  [ 109, 110, 111 ], [ 112, 113, 114 ] ]
gap> ext:= CompositionMaps( ind[1], inv );
[ 57572775, 59535, 3591, 0, 0, 0, 0, 0, 2187, 0, 27, 135, 243, 0, 0, 
  0, 0, 0, 0, 0, 27, 0, 0, 27, 27, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
gap> perms:= PermChars( o8p33, rec( torso:= ext ) );
[ Character( CharacterTable( "O8+(3).3" ),
  [ 57572775, 59535, 3591, 0, 0, 0, 0, 0, 2187, 0, 27, 135, 243, 0, 
      0, 0, 0, 0, 0, 0, 27, 0, 0, 27, 27, 0, 8, 1, 1, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3159, 
      3159, 243, 243, 39, 39, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 
      3, 3, 3, 0, 0, 0, 0, 0, 0, 2, 2, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0 ] ) ]
gap> PermCharInfo( o8p33, perms ).ATLAS;
[ "1a+780aabb+2457a+2808abc+9450aaabbcc+18200abcdddef+24192a+54600a^{5\
}b+70200aabb+87360ab+139776a^{5}+147420a^{4}b^{4}+163800ab+184275aabc+\
199017aa+218700a+245700a+291200aef+332800a^{4}b^{5}c^{5}+491400aaabcd+\
531441a^{5}b^{4}c^{4}+552825a^{4}+568620aabb+698880a^{4}b^{4}+716800aa\
abbccdddeeff+786240aabb+873600aa+998400aa+1257984a^{6}+1397760aa" ]

##  doc2/ctblpope.xml (777-783)
gap> o73:= CharacterTable( "O7(3)" );;
gap> a7:= CharacterTable( "A7" );;
gap> fus:= PossibleClassFusions( a7, o73 );
[ [ 1, 3, 6, 10, 15, 16, 24, 33, 33 ], 
  [ 1, 3, 7, 10, 15, 16, 22, 33, 33 ] ]

##  doc2/ctblpope.xml (794-810)
gap> ind:= List( fus,
>       x -> Induced( a7, o73, [ TrivialCharacter( a7 ) ], x )[1] );;
gap> mat:= MatScalarProducts( o73, Irr( o73 ), ind );;
gap> sum:= Sum( mat );
[ 2, 6, 2, 0, 8, 6, 2, 4, 4, 8, 3, 0, 4, 4, 9, 3, 5, 0, 0, 9, 0, 10, 
  5, 6, 15, 1, 12, 1, 15, 7, 2, 4, 14, 16, 0, 12, 12, 7, 8, 8, 14, 
  12, 12, 14, 6, 6, 20, 16, 12, 12, 12, 10, 10, 12, 12, 8, 12, 6 ]
gap> const:= Filtered( [ 1 .. Length( sum ) ], x -> sum[x] <> 0 );
[ 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 20, 22, 23, 24, 
  25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 
  43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 ]
gap> Length( const );
52
gap> const:= Irr( o73 ){ const };;
gap> rat:= RationalizedMat( const );;

##  doc2/ctblpope.xml (819-837)
gap> names:= ClassNames( o73 );
[ "1a", "2a", "2b", "2c", "3a", "3b", "3c", "3d", "3e", "3f", "3g", 
  "4a", "4b", "4c", "4d", "5a", "6a", "6b", "6c", "6d", "6e", "6f", 
  "6g", "6h", "6i", "6j", "6k", "6l", "6m", "6n", "6o", "6p", "7a", 
  "8a", "8b", "9a", "9b", "9c", "9d", "10a", "10b", "12a", "12b", 
  "12c", "12d", "12e", "12f", "12g", "12h", "13a", "13b", "14a", 
  "15a", "18a", "18b", "18c", "18d", "20a" ]
gap> List( fus, x -> names{ x } );
[ [ "1a", "2b", "3b", "3f", "4d", "5a", "6h", "7a", "7a" ], 
  [ "1a", "2b", "3c", "3f", "4d", "5a", "6f", "7a", "7a" ] ]
gap> torso:= [ 28431 ];;
gap> zeros:= [ 5, 8, 9, 11, 17, 20, 23, 28, 29, 32, 36, 37, 38,
>              43, 46, 47, 48, 53, 54, 55, 56, 57, 58 ];;
gap> names{ zeros };
[ "3a", "3d", "3e", "3g", "6a", "6d", "6g", "6l", "6m", "6p", "9a", 
  "9b", "9c", "12b", "12e", "12f", "12g", "15a", "18a", "18b", "18c", 
  "18d", "20a" ]

##  doc2/ctblpope.xml (854-869)
gap> for i in zeros do
>      torso[i]:= 0;
>    od;
gap> torso;
[ 28431,,,, 0,,, 0, 0,, 0,,,,,, 0,,, 0,,, 0,,,,, 0, 0,,, 0,,,, 0, 0, 
  0,,,,, 0,,, 0, 0, 0,,,,, 0, 0, 0, 0, 0, 0 ]
gap> perms:= PermChars( o73, rec( torso:= torso, chars:= rat ) );
[ Character( CharacterTable( "O7(3)" ),
  [ 28431, 567, 567, 111, 0, 0, 243, 0, 0, 81, 0, 15, 3, 27, 15, 6, 
      0, 0, 27, 0, 3, 27, 0, 0, 0, 3, 9, 0, 0, 3, 3, 0, 4, 1, 1, 0, 
      0, 0, 0, 2, 2, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0 ] ) ]
gap> PermCharInfo( o73, perms ).ATLAS;
[ "1a+78a+168a+182a+260ab+1092a+2457a+2730a+4095b+5460a+11648a" ]

##  doc2/ctblpope.xml (895-917)
gap> o8p3:= CharacterTable( "O8+(3)" );;
gap> o8p2:= CharacterTable( "O8+(2)" );;
gap> fus:= PossibleClassFusions( o8p2, o8p3 );;
gap> NamesOfFusionSources( o8p2 );
[ "A9", "2^8:O8+(2)", "(D10xD10).2^2", "(3x3^3:S3):2", 
  "(3x3^(1+2)+:2A4).2", "2^(3+3+3).L3(2)", "NRS(O8+(2),2^(3+3+3)_a)", 
  "NRS(O8+(2),2^(3+3+3)_b)", "O8+(2)N2", "O8+(2)M2", "O8+(2)M3", 
  "O8+(2)M5", "O8+(2)M6", "O8+(2)M8", "O8+(2)M9", "(3xU4(2)):2", 
  "O8+(2)M11", "O8+(2)M12", "2^(1+8)_+:(S3xS3xS3)", "3^4:2^3.S4(a)", 
  "(A5xA5):2^2", "O8+(2)M16", "O8+(2)M17", "2^(1+8)+.O8+(2)", "7:6", 
  "(A5xD10).2", "(D10xA5).2", "O8+(2)N5C", "2^6:A8", "2.O8+(2)", 
  "2^2.O8+(2)", "S6(2)" ]
gap> sub:= CharacterTable( "2^6:A8" );;
gap> subfus:= GetFusionMap( sub, o8p2 );
[ 1, 3, 2, 2, 4, 5, 6, 13, 3, 6, 12, 13, 14, 7, 21, 24, 11, 30, 29, 
  31, 13, 17, 15, 16, 14, 17, 36, 37, 18, 41, 24, 44, 48, 28, 33, 32, 
  34, 35, 35, 51, 51 ]
gap> fus:= List( fus, x -> CompositionMaps( x, subfus ) );;
gap> fus:= Set( fus );;
gap> Length( fus );
24

##  doc2/ctblpope.xml (926-932)
gap> ind:= List( fus, x -> Induced( sub, o8p3,
>                              [ TrivialCharacter( sub ) ], x )[1] );;
gap> ind:= Set( ind );;
gap> Length( ind );
6

##  doc2/ctblpope.xml (942-957)
gap> o8p32:= CharacterTable( "O8+(3).2_1" );;
gap> fus:= GetFusionMap( o8p3, o8p32 );;
gap> ext:= List( ind, x -> CompositionMaps( x, InverseMap( fus ) ) );;
gap> ext:= Filtered( ext, x -> ForAll( x, IsInt ) );
[ [ 3838185, 17577, 8505, 8505, 873, 0, 0, 0, 0, 6561, 0, 0, 729, 0, 
      9, 105, 45, 45, 105, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 189, 0, 0, 
      0, 9, 9, 27, 27, 0, 0, 27, 9, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 
      0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 
      0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0 ], 
  [ 3838185, 17577, 8505, 8505, 873, 0, 6561, 0, 0, 0, 0, 0, 729, 0, 
      9, 105, 45, 45, 105, 30, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 9, 0, 
      0, 0, 9, 27, 27, 0, 0, 9, 27, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 
      0, 2, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 
      0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]

##  doc2/ctblpope.xml (970-985)
gap> perms:= PermChars( o8p32, rec( torso:= ext[1] ) );
[ Character( CharacterTable( "O8+(3).2_1" ),
  [ 3838185, 17577, 8505, 8505, 873, 0, 0, 0, 0, 6561, 0, 0, 729, 0, 
      9, 105, 45, 45, 105, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 189, 0, 0, 
      0, 9, 9, 27, 27, 0, 0, 27, 9, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 
      0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 
      0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 3159, 1575, 567, 63, 87, 
      15, 0, 0, 45, 0, 81, 9, 27, 0, 0, 3, 3, 3, 3, 5, 5, 0, 0, 0, 4, 
      0, 0, 27, 0, 9, 0, 0, 15, 0, 3, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( o8p32, perms ).ATLAS;
[ "1a+260abc+520ab+819a+2808b+9450aab+18200a+23400ac+29120b+36400aab+4\
6592abce+49140d+66339a+98280ab+163800a+189540d+232960d+332800ab+368550\
a+419328a+531441ab" ]

##  doc2/ctblpope.xml (994-1013)
gap> o8p32:= CharacterTable( "O8+(3).2_2" );;
gap> fus:= GetFusionMap( o8p3, o8p32 );;
gap> ext:= List( ind, x -> CompositionMaps( x, InverseMap( fus ) ) );;
gap> ext:= Filtered( ext, x -> ForAll( x, IsInt ) );;
gap> perms:= PermChars( o8p32, rec( torso:= ext[1] ) );
[ Character( CharacterTable( "O8+(3).2_2" ),
  [ 3838185, 17577, 8505, 873, 0, 0, 0, 6561, 0, 0, 0, 0, 729, 0, 9, 
      105, 45, 105, 30, 0, 0, 0, 0, 0, 0, 189, 0, 0, 0, 9, 0, 9, 27, 
      0, 0, 0, 27, 27, 9, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      2, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 
      0, 6, 0, 0, 0, 0, 0, 0, 0, 199017, 2025, 297, 441, 73, 9, 0, 
      1215, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 27, 27, 0, 1, 9, 12, 0, 0, 
      45, 0, 0, 1, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 
      0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( o8p32, perms ).ATLAS;
[ "1a+260aac+520ab+819a+2808a+9450aaa+18200accee+23400ac+29120a+36400a\
+46592aa+49140c+66339a+93184a+98280ab+163800a+184275ac+189540c+232960c\
+332800aa+419328a+531441aa" ]

##  doc2/ctblpope.xml (1026-1049)
gap> o8p322:= CharacterTable( "O8+(3).(2^2)_{122}" );;
gap> fus:= GetFusionMap( o8p32, o8p322 );;
gap> ext:= List( perms, x -> CompositionMaps( x, InverseMap( fus ) ) );;
gap> ext:= Filtered( ext, x -> ForAll( x, IsInt ) );;
gap> perms:= PermChars( o8p322, rec( torso:= ext[1] ) );
[ Character( CharacterTable( "O8+(3).(2^2)_{122}" ),
  [ 3838185, 17577, 8505, 873, 0, 0, 0, 6561, 0, 0, 729, 0, 9, 105, 
      45, 105, 30, 0, 0, 0, 0, 0, 0, 189, 0, 0, 9, 9, 27, 0, 0, 27, 
      9, 0, 8, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 9, 0, 0, 
      0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3159, 1575, 
      567, 63, 87, 15, 0, 0, 45, 0, 81, 9, 27, 0, 0, 3, 3, 3, 5, 0, 
      0, 4, 0, 0, 27, 0, 9, 0, 0, 15, 0, 3, 0, 0, 2, 0, 0, 0, 3, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 199017, 2025, 297, 441, 73, 9, 0, 
      1215, 0, 0, 0, 0, 81, 0, 0, 0, 27, 27, 0, 1, 9, 12, 0, 0, 45, 
      0, 0, 1, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 
      0, 28431, 1647, 135, 63, 87, 39, 0, 0, 243, 27, 0, 0, 81, 63, 
      0, 0, 0, 9, 0, 3, 3, 6, 2, 0, 0, 0, 9, 0, 0, 3, 3, 3, 0, 4, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0 ] ) ]
gap> PermCharInfo( o8p322, perms ).ATLAS;
[ "1a+260ace+819a+1040a+2808c+9450aac+18200a+23400ae+29120c+36400aac+4\
6592ac+49140g+66339a+93184a+163800b+189540g+196560a+232960g+332800ac+3\
68550a+419328a+531441ac" ]

##  doc2/ctblpope.xml (1079-1083)
gap> s444:= CharacterTable( "S4(4).4" );;
gap> NamesOfFusionSources( s444 );
[ "(L3(2)xS4(4):2).2", "S4(4)", "S4(4).2" ]

##  doc2/ctblpope.xml (1093-1105)
gap> perms:= PermChars( s444,
>                rec( torso:= [ Size( s444 ) / ( 5^2*2^5 ) ] ) );
[ Character( CharacterTable( "S4(4).4" ),
  [ 4896, 384, 96, 0, 16, 32, 36, 16, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "S4(4).4" ),
  [ 4896, 192, 32, 0, 0, 8, 6, 1, 0, 2, 0, 0, 36, 0, 12, 0, 0, 0, 1, 
      0, 6, 6, 2, 2, 0, 0, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "S4(4).4" ),
  [ 4896, 240, 64, 0, 8, 8, 36, 16, 0, 0, 0, 0, 0, 12, 8, 0, 4, 4, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (1116-1121)
gap> PermCharInfo( s444, perms ).ATLAS;
[ "1abcd+50abcd+153abcd+170a^{4}b^{4}+680aabb", 
  "1a+50ac+153a+170aab+256a+680abb+816a+1020a", 
  "1ac+50ac+68a+153abcd+170aabbb+204a+680abb+1020a" ]

##  doc2/ctblpope.xml (1147-1150)
gap> t:= CharacterTable( "Co1" );
CharacterTable( "Co1" )

##  doc2/ctblpope.xml (1162-1169)
gap> s:= CharacterTable( Maxes( t )[5] );
CharacterTable( "2^(1+8)+.O8+(2)" )
gap> ind:= Induced( s, t, [ TrivialCharacter( s ) ] );;
gap> PermCharInfo( t, ind ).ATLAS;
[ "1a+299a+17250a+27300a+80730a+313950a+644644a+2816856a+5494125a+1243\
2420a+24794000a" ]

##  doc2/ctblpope.xml (1181-1189)
gap> centorder:= SizesCentralizers( t )[3];;
gap> maxes:= List( Maxes( t ), CharacterTable );;
gap> cand:= Filtered( maxes, x -> Size( x ) mod centorder = 0 );
[ CharacterTable( "(A4xG2(4)):2" ) ]
gap> u:= cand[1];;
gap> index:= Size( u ) / centorder;
3

##  doc2/ctblpope.xml (1210-1236)
gap> subperm:= PermChars( u, rec( degree := index, bounds := false ) );
[ Character( CharacterTable( "(A4xG2(4)):2" ),
  [ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 
      3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 
      3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1, 1, 1, 1 ] ) ]
gap> subperm = PermChars( u, rec( torso := [ 3 ] ) );
true
gap> ind:= Induced( u, t, subperm );
[ Character( CharacterTable( "Co1" ),
  [ 2065694400, 181440, 119408, 38016, 2779920, 0, 0, 378, 30240, 
      864, 0, 720, 316, 80, 2520, 30, 0, 6480, 1508, 0, 0, 0, 0, 0, 
      38, 18, 105, 0, 600, 120, 56, 24, 0, 12, 0, 0, 0, 120, 48, 18, 
      0, 0, 6, 0, 360, 144, 108, 0, 0, 10, 0, 0, 0, 0, 0, 4, 2, 3, 9, 
      0, 0, 15, 3, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 
      12, 8, 0, 6, 0, 0, 3, 0, 1, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 3, 
      0 ] ) ]
gap> PermCharInfo( t, ind ).ATLAS;
[ "1a+1771a+8855a+27300aa+313950a+345345a+644644aa+871884aaa+1771000a+\
2055625a+4100096a+7628985a+9669660a+12432420aa+21528000aa+23244375a+24\
174150aa+24794000a+31574400aa+40370176a+60435375a+85250880aa+100725625\
a+106142400a+150732800a+184184000a+185912496a+207491625a+299710125a+30\
2176875a" ]

##  doc2/ctblpope.xml (1244-1248)
gap> centorder:= SizesCentralizers( t )[4];;
gap> cand:= Filtered( maxes, x -> Size( x ) mod centorder = 0 );
[ CharacterTable( "Co2" ), CharacterTable( "2^11:M24" ) ]

##  doc2/ctblpope.xml (1258-1269)
gap> u:= cand[1];;
gap> GetFusionMap( u, t );
[ 1, 2, 2, 4, 7, 6, 9, 11, 11, 10, 11, 12, 14, 17, 16, 21, 23, 20, 
  22, 22, 24, 28, 30, 33, 31, 32, 33, 33, 37, 42, 41, 43, 44, 48, 52, 
  49, 53, 55, 53, 52, 54, 60, 60, 60, 64, 65, 65, 67, 66, 70, 73, 72, 
  78, 79, 84, 85, 87, 92, 93, 93 ]
gap> centorder;
389283840
gap> SizesCentralizers( u )[4];
1474560

##  doc2/ctblpope.xml (1277-1307)
gap> u:= cand[2];
CharacterTable( "2^11:M24" )
gap> index:= Size( u ) / centorder;
1288
gap> subperm:= PermChars( u, rec( torso := [ index ] ) );
[ Character( CharacterTable( "2^11:M24" ),
  [ 1288, 1288, 1288, 56, 56, 56, 56, 56, 56, 48, 48, 48, 48, 48, 10, 
      10, 10, 10, 7, 7, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 
      4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 0, 0, 0, 0, 2, 2, 2, 
      2, 3, 3, 3, 1, 1, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0 ] ) ]
gap> subperm = PermChars( u, rec( degree:= index, bounds := false ) );
true
gap> ind:= Induced( u, t, subperm );
[ Character( CharacterTable( "Co1" ),
  [ 10680579000, 1988280, 196560, 94744, 0, 17010, 0, 945, 7560, 
      3432, 2280, 1728, 252, 308, 0, 225, 0, 0, 0, 270, 0, 306, 0, 
      46, 45, 25, 0, 0, 120, 32, 12, 52, 36, 36, 0, 0, 0, 0, 0, 45, 
      15, 0, 9, 3, 0, 0, 0, 0, 18, 0, 30, 0, 6, 18, 0, 3, 5, 0, 0, 0, 
      0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
      6, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( t, ind ).ATLAS;
[ "1a+17250aa+27300a+80730aa+644644aaa+871884a+1821600a+2055625aaa+281\
6856a+5494125a^{4}+12432420aa+16347825aa+23244375a+24174150aa+24667500\
aa+24794000aaa+31574400a+40370176a+55255200a+66602250a^{4}+83720000aa+\
85250880aaa+91547820aa+106142400a+150732800a+184184000aaa+185912496aaa\
+185955000aaa+207491625aaa+215547904aa+241741500aaa+247235625a+2578576\
00aa+259008750a+280280000a+302176875a+326956500a+387317700a+402902500a\
+464257024a+469945476b+502078500a+503513010a+504627200a+522161640a" ]

##  doc2/ctblpope.xml (1330-1351)
gap> t:= CharacterTable( "G2(3)" );
CharacterTable( "G2(3)" )
gap> t:= CharacterTable( "G2(3)" );;
gap> n:= Length( RationalizedMat( Irr( t ) ) );;
gap> maxmult:= List( [ 1 .. n ], i -> 1 );;
gap> perms:= [];;
gap> divs:= DivisorsInt( Size( t ) );;
gap> for d in divs do
>      Append( perms,
>              PermChars( t, rec( bounds  := false,
>                                 degree  := d,
>                                 maxmult := maxmult ) ) );
>    od;
gap> Length( perms );
42
gap> List( perms, Degree );
[ 1, 351, 351, 364, 364, 378, 378, 546, 546, 546, 546, 546, 702, 702, 
  728, 728, 1092, 1092, 1092, 1092, 1092, 1092, 1092, 1092, 1456, 
  1456, 1638, 1638, 2184, 2184, 2457, 2457, 2457, 2457, 3159, 3276, 
  3276, 3276, 3276, 4368, 6552, 6552 ]

##  doc2/ctblpope.xml (1370-1384)
gap> tom:= TableOfMarks( "G2(3)" );
TableOfMarks( "G2(3)" )
gap> tbl:= CharacterTable( "G2(3)" );
CharacterTable( "G2(3)" )
gap> permstom:= PermCharsTom( tbl, tom );;
gap> Length( permstom );
433
gap> multfree:= Intersection( perms, permstom );;
gap> Length( multfree );
15
gap> List( multfree, Degree );
[ 1, 351, 351, 364, 364, 378, 378, 702, 702, 728, 728, 1092, 1092, 
  2184, 2184 ]

##  doc2/ctblpope.xml (1404-1409)
gap> tbl2:= CharacterTable("O8+(2).2");;
gap> s3:= CharacterTable( "Symmetric", 3 );;
gap> s:= CharacterTableWreathSymmetric( s3, 4 );
CharacterTable( "Sym(3)wrS4" )

##  doc2/ctblpope.xml (1419-1442)
gap> fus:= PossibleClassFusions( s, tbl2 );
[ [ 1, 41, 6, 3, 48, 9, 42, 19, 51, 8, 5, 50, 24, 49, 7, 2, 44, 22, 
      42, 12, 53, 17, 58, 21, 5, 47, 26, 50, 37, 52, 23, 60, 18, 4, 
      46, 25, 14, 61, 20, 9, 53, 30, 51, 26, 64, 8, 52, 31, 13, 56, 
      38 ] ]
gap> pi:= Induced( s, tbl2, [ TrivialCharacter( s ) ], fus[1] )[1];
Character( CharacterTable( "O8+(2).2" ),
 [ 11200, 256, 160, 160, 80, 40, 40, 76, 13, 0, 0, 8, 8, 4, 0, 0, 16, 
  16, 4, 4, 4, 1, 1, 1, 1, 5, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2, 0, 
  0, 1120, 96, 0, 16, 0, 16, 8, 10, 4, 6, 7, 12, 3, 0, 0, 2, 0, 4, 0, 
  1, 1, 0, 0, 1, 0, 0, 0 ] )
gap> PermCharInfo( tbl2, pi ).ATLAS;
[ "1a+84a+168a+175a+300a+700c+972a+1400a+3200a+4200b" ]
gap> tbl:= CharacterTable( "O8+(2)" );
CharacterTable( "O8+(2)" )
gap> rest:= RestrictedClassFunction( pi, tbl );
Character( CharacterTable( "O8+(2)" ),
 [ 11200, 256, 160, 160, 160, 80, 40, 40, 40, 76, 13, 0, 0, 8, 8, 8, 
  4, 0, 0, 0, 16, 16, 16, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 5, 0, 0, 0, 
  1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0 ] )
gap> PermCharInfo( tbl, rest ).ATLAS;
[ "1a+84abc+175a+300a+700bcd+972a+3200a+4200a" ]

##  doc2/ctblpope.xml (1463-1489)
gap> tbl:= CharacterTable( "M22" );
CharacterTable( "M22" )
gap> perms:= PermChars( tbl, rec( torso:= [ 56 ] ) );
[ Character( CharacterTable( "M22" ),
  [ 56, 8, 2, 4, 0, 1, 2, 0, 0, 2, 1, 1 ] ) ]
gap> pi:= perms[1];;
gap> Norm( pi );
2
gap> Display( tbl, rec( chars:= perms ) );
M22

     2  7  7  2  5  4  .  2  .  .  3   .   .
     3  2  1  2  .  .  .  1  .  .  .   .   .
     5  1  .  .  .  .  1  .  .  .  .   .   .
     7  1  .  .  .  .  .  .  1  1  .   .   .
    11  1  .  .  .  .  .  .  .  .  .   1   1

       1a 2a 3a 4a 4b 5a 6a 7a 7b 8a 11a 11b
    2P 1a 1a 3a 2a 2a 5a 3a 7a 7b 4a 11b 11a
    3P 1a 2a 1a 4a 4b 5a 2a 7b 7a 8a 11a 11b
    5P 1a 2a 3a 4a 4b 1a 6a 7b 7a 8a 11a 11b
    7P 1a 2a 3a 4a 4b 5a 6a 1a 1a 8a 11b 11a
   11P 1a 2a 3a 4a 4b 5a 6a 7a 7b 8a  1a  1a

Y.1    56  8  2  4  .  1  2  .  .  2   1   1

##  doc2/ctblpope.xml (1501-1505)
gap> perms:= PermChars( tbl, rec( torso:= [ 56 * 55 ] ) );;
gap> Length( perms );
16

##  doc2/ctblpope.xml (1517-1529)
gap> OrdersClassRepresentatives( tbl );
[ 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 11, 11 ]
gap> perms:= Filtered( perms, x -> x[5] = 0 and x[10] <> 0 );
[ Character( CharacterTable( "M22" ),
  [ 3080, 56, 2, 12, 0, 0, 2, 0, 0, 2, 0, 0 ] ), 
  Character( CharacterTable( "M22" ),
  [ 3080, 8, 2, 8, 0, 0, 2, 0, 0, 4, 0, 0 ] ), 
  Character( CharacterTable( "M22" ),
  [ 3080, 24, 11, 4, 0, 0, 3, 0, 0, 2, 0, 0 ] ), 
  Character( CharacterTable( "M22" ),
  [ 3080, 24, 20, 4, 0, 0, 0, 0, 0, 2, 0, 0 ] ) ]

##  doc2/ctblpope.xml (1539-1569)
gap> infoperms:= PermCharInfo( tbl, perms );;
gap> Display( tbl, infoperms.display );
M22

      2    7  7  2  5  2  3
      3    2  1  2  .  1  .
      5    1  .  .  .  .  .
      7    1  .  .  .  .  .
     11    1  .  .  .  .  .

          1a 2a 3a 4a 6a 8a
     2P   1a 1a 3a 2a 3a 4a
     3P   1a 2a 1a 4a 2a 8a
     5P   1a 2a 3a 4a 6a 8a
     7P   1a 2a 3a 4a 6a 8a
    11P   1a 2a 3a 4a 6a 8a

I.1     3080 56  2 12  2  2
I.2        1 21  8 54 24 36
I.3        1  3  4  9 12 18
I.4     3080  8  2  8  2  4
I.5        1  3  8 36 24 72
I.6        1  3  4  9 12 18
I.7     3080 24 11  4  3  2
I.8        1  9 44 18 36 36
I.9        1  3  4  9 12 18
I.10    3080 24 20  4  .  2
I.11       1  9 80 18  . 36
I.12       1  3  4  9 12 18

##  doc2/ctblpope.xml (1659-1670)
gap> ly:= CharacterTable( "Ly" );;
gap> mcl:= CharacterTable( "McL" );;
gap> mcl2:= CharacterTable( "McL.2" );;
gap> 3mcl2:= CharacterTable( "3.McL.2" );;
gap> perms:= PermChars( mcl, rec( degree:= 15400 ) );
[ Character( CharacterTable( "McL" ),
  [ 15400, 56, 91, 10, 12, 25, 0, 11, 2, 0, 0, 2, 1, 1, 1, 0, 0, 3, 
      0, 0, 1, 1, 1, 1 ] ), Character( CharacterTable( "McL" ),
  [ 15400, 280, 10, 37, 20, 0, 5, 10, 1, 0, 0, 2, 1, 1, 0, 0, 0, 2, 
      0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (1682-1692)
gap> ord10:= Filtered( [ 1 .. NrConjugacyClasses( mcl ) ],
>                      i -> OrdersClassRepresentatives( mcl )[i] = 10 );
[ 15 ]
gap> List( perms, pi -> pi[ ord10[1] ] );
[ 1, 0 ]
gap> pi:= perms[1];
Character( CharacterTable( "McL" ),
 [ 15400, 56, 91, 10, 12, 25, 0, 11, 2, 0, 0, 2, 1, 1, 1, 0, 0, 3, 0, 
  0, 1, 1, 1, 1 ] )

##  doc2/ctblpope.xml (1707-1722)
gap> map:= InverseMap( GetFusionMap( mcl, mcl2 ) );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, [ 10, 11 ], 12, [ 13, 14 ], 15, 16, 17, 
  18, [ 19, 20 ], [ 21, 22 ], [ 23, 24 ] ]
gap> torso:= CompositionMaps( pi, map );
[ 15400, 56, 91, 10, 12, 25, 0, 11, 2, 0, 2, 1, 1, 0, 0, 3, 0, 1, 1 ]
gap> perms:= PermChars( mcl2, rec( torso:= torso ) );
[ Character( CharacterTable( "McL.2" ),
  [ 15400, 56, 91, 10, 12, 25, 0, 11, 2, 0, 2, 1, 1, 0, 0, 3, 0, 1, 
      1, 110, 26, 2, 4, 0, 0, 5, 2, 1, 1, 0, 0, 1, 1 ] ) ]
gap> pi:= Inflated( perms[1], 3mcl2 );
Character( CharacterTable( "3.McL.2" ),
 [ 15400, 15400, 56, 56, 91, 91, 10, 12, 12, 25, 25, 0, 0, 11, 11, 2, 
  2, 0, 0, 0, 2, 2, 1, 1, 1, 0, 0, 0, 0, 3, 3, 0, 0, 0, 1, 1, 1, 1, 
  1, 1, 110, 26, 2, 4, 0, 0, 5, 2, 1, 1, 0, 0, 1, 1 ] )

##  doc2/ctblpope.xml (1732-1738)
gap> fus:= PossibleClassFusions( 3mcl2, ly );;  Length( fus );
4
gap> g:= AutomorphismsOfTable( ly );;
gap> OrbitLengths( g, fus, OnTuples );    
[ 4 ]

##  doc2/ctblpope.xml (1744-1750)
gap> pi:= Induced( 3mcl2, ly, [ pi ], fus[1] )[1];
Character( CharacterTable( "Ly" ),
 [ 147934325000, 286440, 1416800, 1082, 784, 12500, 0, 672, 42, 24, 
  0, 40, 0, 2, 20, 0, 0, 0, 64, 10, 0, 50, 2, 0, 0, 4, 0, 0, 0, 0, 4, 
  0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] )

##  doc2/ctblpope.xml (1773-1787)
gap> orders:= OrdersClassRepresentatives( ly );
[ 1, 2, 3, 3, 4, 5, 5, 6, 6, 6, 7, 8, 8, 9, 10, 10, 11, 11, 12, 12, 
  14, 15, 15, 15, 18, 20, 21, 21, 22, 22, 24, 24, 24, 25, 28, 30, 30, 
  31, 31, 31, 31, 31, 33, 33, 37, 37, 40, 40, 42, 42, 67, 67, 67 ]
gap> torso:= [];;                                   
gap> for i in [ 1 .. Length( orders ) ] do
>      if orders[i] mod 2 = 1 then
>        torso[i]:= pi[i]/2;
>      fi;
>    od;
gap> torso;
[ 73967162500,, 708400, 541,, 6250, 0,,,, 0,,, 1,,, 0, 0,,,, 25, 1, 0,
  ,, 0, 0,,,,,, 0,,,, 0, 0, 0, 0, 0, 0, 0, 0, 0,,,,, 0, 0, 0 ]

##  doc2/ctblpope.xml (1796-1807)
gap> perms:= PermChars( ly, rec( torso:= torso ) );;
gap> Length( perms );
43
gap> perms:= Filtered( perms, cand -> ForAll( [ 1 .. Length( orders ) ],
>        i -> cand[i] >= pi[i] / 2 ) );
[ Character( CharacterTable( "Ly" ),
  [ 73967162500, 204820, 708400, 541, 392, 6250, 0, 1456, 61, 25, 0, 
      22, 10, 1, 10, 0, 0, 0, 32, 5, 0, 25, 1, 0, 1, 2, 0, 0, 0, 0, 
      4, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 
      0, 0 ] ) ]

##  doc2/ctblpope.xml (1831-1843)
gap> tbl:= CharacterTable( "U3(5).3.2" );
CharacterTable( "U3(5).3.2" )
gap> deg:= Size( tbl ) / ( 2^4*3^3 );
1750
gap> pi:= PermChars( tbl, rec( torso:= [ deg ] ) );
[ Character( CharacterTable( "U3(5).3.2" ),
  [ 1750, 70, 13, 2, 0, 0, 1, 0, 0, 0, 10, 7, 10, 4, 2, 0, 0, 0, 0, 
      0, 0, 30, 10, 3, 0, 0, 1, 0, 0 ] ), 
  Character( CharacterTable( "U3(5).3.2" ),
  [ 1750, 30, 4, 6, 0, 0, 0, 0, 0, 0, 40, 7, 0, 6, 0, 0, 0, 0, 0, 0, 
      0, 20, 0, 2, 2, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (1854-1860)
gap> ord8:= Filtered( [ 1 .. NrConjugacyClasses( tbl ) ],
>               i -> OrdersClassRepresentatives( tbl )[i] = 8 );
[ 9, 25 ]
gap> List( pi, x -> x{ ord8 } );
[ [ 0, 0 ], [ 0, 2 ] ]

##  doc2/ctblpope.xml (1874-1882)
gap> subtbl:= CharacterTable( "U3(5)" );
CharacterTable( "U3(5)" )
gap> rest:= RestrictedClassFunctions( pi, subtbl );
[ Character( CharacterTable( "U3(5)" ),
  [ 1750, 70, 13, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U3(5)" ),
  [ 1750, 30, 4, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (1893-1899)
gap> ord6:= Filtered( [ 1 .. NrConjugacyClasses( subtbl ) ],
>               i -> OrdersClassRepresentatives( subtbl )[i] = 6 );
[ 9 ]
gap> List( rest, x -> x{ ord6 } );
[ [ 1 ], [ 0 ] ]

##  doc2/ctblpope.xml (1910-1916)
gap> tom:= TableOfMarks( "U3(5)" );
TableOfMarks( "U3(5)" )
gap> perms:= PermCharsTom( subtbl, tom );;
gap> Set( Filtered( perms, x -> x[1] = deg ) ) = Set( rest );
true

##  doc2/ctblpope.xml (1928-1932)
gap> PermCharInfo( tbl, pi ).ATLAS;
[ "1a+21a+42a+84aac+105a+125a+126a+250a+252a+288bc", 
  "1a+42a+84ac+105ab+125a+126a+250a+252b+288bc" ]

##  doc2/ctblpope.xml (1942-1953)
gap> subtbl2:= CharacterTable( "U3(5).2" );;
gap> rest2:= RestrictedClassFunctions( pi, subtbl2 );;
gap> PermCharInfo( subtbl2, rest2 ).ATLAS;
[ "1a+21aab+28aa+56aa+84a+105a+125aab+126aab+288aa", 
  "1a+21ab+28a+56a+84a+105ab+125aab+126a+252a+288aa" ]
gap> subtbl3:= CharacterTable( "U3(5).3" );;
gap> rest3:= RestrictedClassFunctions( pi, subtbl3 );;
gap> PermCharInfo( subtbl3, rest3 ).ATLAS;
[ "1a+21abc+84aab+105a+125abc+126abc+144bcef", 
  "1a+21bc+84ab+105aa+125abc+126adg+144bcef" ]

##  doc2/ctblpope.xml (1985-1997)
gap> t:= CharacterTable( "O8+(2).3.2" );;
gap> s:= CharacterTable( "O8+(2)" );;
gap> tom:= TableOfMarks( s );;
gap> perms:= PermCharsTom( s, tom );;
gap> deg:= 3^4*5^2*7;
14175
gap> perms:= Filtered( perms, x -> x[1] = deg );;
gap> Length( perms );
4
gap> Length( Set( perms ) );
1

##  doc2/ctblpope.xml (2010-2029)
gap> fus:= PossibleClassFusions( s, t );
[ [ 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7, 8, 9, 10, 10, 10, 11, 12, 12, 
      12, 13, 13, 13, 14, 14, 14, 15, 16, 16, 16, 17, 17, 17, 18, 19, 
      20, 21, 22, 22, 22, 23, 23, 23, 24, 24, 24, 25, 26, 26, 26, 27, 
      27, 27 ] ]
gap> fus:= fus[1];;
gap> inv:= InverseMap( fus );;
gap> comp:= CompositionMaps( perms[1], inv );
[ 14175, 1215, 375, 79, 0, 0, 27, 27, 99, 15, 7, 0, 0, 0, 0, 9, 3, 1, 
  0, 1, 1, 0, 0, 0, 0, 0, 0 ]
gap> ext:= PermChars( t, rec( torso:= comp ) );
[ Character( CharacterTable( "O8+(2).3.2" ),
  [ 14175, 1215, 375, 79, 0, 0, 27, 27, 99, 15, 7, 0, 0, 0, 0, 9, 3, 
      1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 63, 9, 15, 7, 1, 0, 3, 3, 3, 1, 
      0, 0, 1, 1, 945, 129, 45, 69, 21, 25, 13, 0, 0, 0, 9, 0, 3, 3, 
      7, 1, 0, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfo( t, ext[1] ).ATLAS;
[ "1a+50b+100a+252bb+300b+700b+972bb+1400a+1944a+3200b+4032b" ]

##  doc2/ctblpope.xml (2220-2230)
gap> co1:= CharacterTable( "Co1" );;
gap> order:= 2^(2+11+22-25) * 2 * Size( CharacterTable( "M24" ) );
501397585920
gap> maxes:= List( Maxes( co1 ), CharacterTable );;
gap> filt:= Filtered( maxes, t -> Size( t ) mod order = 0 );
[ CharacterTable( "2^11:M24" ) ]
gap> List( filt, t -> Size( t ) / order );
[ 1 ]
gap> k:= filt[1];;

##  doc2/ctblpope.xml (2251-2262)
gap> f:= CharacterTable( "Symmetric", 3 );
CharacterTable( "Sym(3)" )
gap> OrdersClassRepresentatives( f );
[ 1, 2, 3 ]
gap> deg3:= PermChars( f, 3 );
[ Character( CharacterTable( "Sym(3)" ), [ 3, 1, 0 ] ) ]
gap> deg6:= PermChars( f, 6 );
[ Character( CharacterTable( "Sym(3)" ), [ 6, 0, 0 ] ) ]
gap> deg3[1] - 1/3 * deg6[1];
ClassFunction( CharacterTable( "Sym(3)" ), [ 1, 1, 0 ] )

##  doc2/ctblpope.xml (2274-2280)
gap> m:= CharacterTable( "M" );
CharacterTable( "M" )
gap> g:= CharacterTable( "MC2B" );
CharacterTable( "2^1+24.Co1" )
gap> pi:= RestrictedClassFunction( TrivialCharacter( k )^co1, g );;

##  doc2/ctblpope.xml (2296-2302)
gap> zclasses:= ClassPositionsOfCentre( g );;
gap> gmodz:= g / zclasses;
CharacterTable( "2^1+24.Co1/[ 1, 2 ]" )
gap> invmap:= InverseMap( GetFusionMap( g, gmodz ) );;
gap> pibar:= CompositionMaps( pi, invmap );;

##  doc2/ctblpope.xml (2319-2332)
gap> factorders:= OrdersClassRepresentatives( gmodz );;
gap> phibar:= [];;
gap> for i in [ 1 .. NrConjugacyClasses( gmodz ) ] do
>      if factorders[i] mod 2 = 1 then
>        phibar[i]:= 2 * pibar[i];
>      elif pibar[i] = 0 then
>        phibar[i]:= 0;
>      fi;
>    od;
gap> cand:= PermChars( gmodz, rec( torso:= phibar ) );;
gap> Length( cand );
1

##  doc2/ctblpope.xml (2341-2351)
gap> phi:= RestrictedClassFunction( cand[1], g )^m;;
gap> pi:= pi^m;;
gap> cand:= ShallowCopy( pi - 1/3 * phi );;
gap> morders:= OrdersClassRepresentatives( m );;
gap> for i in [ 1 .. Length( morders ) ] do
>      if morders[i] mod 3 = 0 and phi[ PowerMap( m, 3 )[i] ] <> 0 then
>        Unbind( cand[i] );
>      fi;
>    od;

##  doc2/ctblpope.xml (2422-2425)
gap> constit:= Filtered( RationalizedMat( Irr( m ) ),
>                        chi -> ScalarProduct( m, chi, pi ) <> 0 );;

##  doc2/ctblpope.xml (2436-2458)
gap> cand:= PermChars( m,
>      rec( torso:= cand, chars:= constit,
>           lower:= ShallowCopy( pi - 1/3 * phi ),
>           normalsubgroup:= [ 1 .. NrConjugacyClasses( m ) ],
>           nonfaithful:= TrivialCharacter( m ) ) );
[ Character( CharacterTable( "M" ),
  [ 16009115629875684006343550944921875, 7774182899642733721875, 
      120168544413337875, 4436049512692980, 215448838605, 
      131873639625, 760550656275, 110042727795, 943894035, 568854195, 
      1851609375, 0, 4680311220, 405405, 78624756, 14467005, 178605, 
      248265, 874650, 0, 76995, 591163, 224055, 34955, 29539, 20727, 
      0, 0, 375375, 15775, 0, 0, 0, 495, 116532, 3645, 62316, 1017, 
      11268, 357, 1701, 45, 117, 705, 0, 0, 4410, 1498, 0, 3780, 810, 
      0, 0, 83, 135, 31, 0, 0, 0, 0, 0, 0, 0, 255, 195, 0, 215, 0, 0, 
      210, 0, 42, 0, 35, 15, 1, 1, 160, 48, 9, 92, 25, 9, 9, 5, 1, 
      21, 0, 0, 0, 0, 0, 98, 74, 42, 0, 0, 0, 120, 76, 10, 0, 0, 0, 
      0, 0, 1, 1, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 3, 0, 
      0, 0, 18, 0, 10, 0, 3, 3, 0, 1, 1, 1, 1, 0, 0, 2, 0, 0, 0, 0, 
      0, 0, 2, 0, 0, 0, 0, 0, 6, 12, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 1, 
      0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (2473-2479)
gap> h:= CharacterTable( "2^(2+11+22).(M24xS3)" );;
gap> fus:= PossibleClassFusions( h, m );;
gap> cand = Set( fus, map -> InducedClassFunctionsByFusionMap( h, m,
>                              [ TrivialCharacter( h ) ], map )[1] );
true

##  doc2/ctblpope.xml (2518-2532)
gap> co1:= CharacterTable( "Co1" );;
gap> order:= 2^(3+6+12+18-25) * 168 * 3 * Factorial( 6 ) / 7;
849346560
gap> maxes:= List( Maxes( co1 ), CharacterTable );;
gap> filt:= Filtered( maxes, t -> Size( t ) mod order = 0 );
[ CharacterTable( "2^(1+8)+.O8+(2)" ), 
  CharacterTable( "2^(4+12).(S3x3S6)" ) ]
gap> List( filt, t -> Size( t ) / order );
[ 105, 1 ]
gap> o8p2:= CharacterTable( "O8+(2)" );;
gap> PermChars( o8p2, rec( torso:= [ 105 ] ) );
[  ]
gap> k:= filt[2];;

##  doc2/ctblpope.xml (2584-2598)
gap> f:= CharacterTable( "L3(2)" );
CharacterTable( "L3(2)" )
gap> OrdersClassRepresentatives( f );
[ 1, 2, 3, 4, 7, 7 ]
gap> deg7:= PermChars( f, 7 );
[ Character( CharacterTable( "L3(2)" ), [ 7, 3, 1, 1, 0, 0 ] ) ]
gap> deg42:= PermChars( f, 42 );
[ Character( CharacterTable( "L3(2)" ), [ 42, 2, 0, 2, 0, 0 ] ), 
  Character( CharacterTable( "L3(2)" ), [ 42, 6, 0, 0, 0, 0 ] ) ]
gap> deg168:= PermChars( f, 168 );
[ Character( CharacterTable( "L3(2)" ), [ 168, 0, 0, 0, 0, 0 ] ) ]
gap> deg7[1] - 1/3 * deg42[2] + 1/21 * deg168[1];
ClassFunction( CharacterTable( "L3(2)" ), [ 1, 1, 1, 1, 0, 0 ] )

##  doc2/ctblpope.xml (2616-2622)
gap> m:= CharacterTable( "M" );
CharacterTable( "M" )
gap> g:= CharacterTable( "MC2B" );
CharacterTable( "2^1+24.Co1" )
gap> pi:= RestrictedClassFunction( TrivialCharacter( k )^co1, g );;

##  doc2/ctblpope.xml (2633-2643)
gap> nsg:= ClassPositionsOfNormalSubgroups( k );;
gap> nsgsizes:= List( nsg, x -> Sum( SizesConjugacyClasses( k ){ x } ) );;
gap> nn:= nsg[ Position( nsgsizes, Size( k ) / 6 ) ];;
gap> psi:= 0 * [ 1 .. NrConjugacyClasses( k ) ];;
gap> for i in nn do
>      psi[i]:= 6;
>    od;
gap> psi:= InducedClassFunction( k, psi, co1 );;
gap> psi:= RestrictedClassFunction( psi, g );;

##  doc2/ctblpope.xml (2658-2664)
gap> zclasses:= ClassPositionsOfCentre( g );;
gap> gmodz:= g / zclasses;
CharacterTable( "2^1+24.Co1/[ 1, 2 ]" )
gap> invmap:= InverseMap( GetFusionMap( g, gmodz ) );;
gap> psibar:= CompositionMaps( psi, invmap );;

##  doc2/ctblpope.xml (2682-2700)
gap> factorders:= OrdersClassRepresentatives( gmodz );;
gap> phibar:= [];;
gap> upperphibar:= [];;
gap> for i in [ 1 .. NrConjugacyClasses( gmodz ) ] do
>      if factorders[i] mod 2 = 1 then
>        phibar[i]:= 2 * psibar[i];
>      elif psibar[i] = 0 then
>        phibar[i]:= 0;
>      fi;
>      upperphibar[i]:= 2 * psibar[i];
>    od;
gap> cand:= PermChars( gmodz, rec( torso:= phibar,
>             upper:= upperphibar,
>             normalsubgroup:= [ 1 .. NrConjugacyClasses( gmodz ) ],
>             nonfaithful:= TrivialCharacter( gmodz ) ) );;
gap> Length( cand );
3

##  doc2/ctblpope.xml (2711-2720)
gap> nn:= First( ClassPositionsOfNormalSubgroups( gmodz ),
>                x -> Sum( SizesConjugacyClasses( gmodz ){x} ) = 2^24 );
[ 1 .. 4 ]
gap> cont:= PermCharInfo( gmodz, cand ).contained;;
gap> cand:= cand{ Filtered( [ 1 .. Length( cand ) ],
>                           i -> Sum( cont[i]{ nn } ) < 2^24 ) };;
gap> Length( cand );
2

##  doc2/ctblpope.xml (2731-2757)
gap> poss:= [];;
gap> for v in cand do
>      phibar:= [];
>      upperphibar:= [];
>      for i in [ 1 .. NrConjugacyClasses( gmodz ) ] do
>        if factorders[i] mod 2 = 1 then
>          phibar[i]:= 2 * v[i];
>        elif v[i] = 0 then
>          phibar[i]:= 0;
>        fi;
>        upperphibar[i]:= 2 * v[i];
>      od;
>      Append( poss, PermChars( gmodz, rec( torso:= phibar,
>                      upper:= upperphibar,
>                      normalsubgroup:= [ 1 .. NrConjugacyClasses( gmodz ) ],
>                      nonfaithful:= TrivialCharacter( gmodz ) ) ) );
>    od;
gap> Length( poss );
6
gap> cont:= PermCharInfo( gmodz, poss ).contained;;
gap> poss:= poss{ Filtered( [ 1 .. Length( poss ) ],
>                           i -> Sum( cont[i]{ nn } ) < 2^23 ) };;
gap> Length( poss );
4
gap> phicand:= RestrictedClassFunctions( poss, g );;

##  doc2/ctblpope.xml (2768-2783)
gap> phicand:= RestrictedClassFunctions( poss, g );;
gap> phicand:= InducedClassFunctions( phicand, m );;
gap> psi:= psi^m;;
gap> pi:= pi^m;;
gap> cand:= List( phicand,
>             phi -> ShallowCopy( pi - 1/3 * psi + 1/21 * phi ) );;
gap> morders:= OrdersClassRepresentatives( m );;
gap> for x in cand do
>      for i in [ 1 .. Length( morders ) ] do
>        if morders[i] mod 7 = 0 then
>          Unbind( x[i] );
>        fi;
>      od;
>    od;

##  doc2/ctblpope.xml (2791-2807)
gap> cand:= Filtered( cand, x -> ForAll( x, IsInt ) );
[ [ 4050306254358548053604918389065234375, 148844831270071996434375, 
      2815847622206994375, 14567365753025085, 3447181417680, 
      659368198125, 3520153823175, 548464353255, 5706077895, 
      3056566695, 264515625, 0, 19572895485, 6486480, 186109245, 
      61410960, 758160, 688365,,, 172503, 1264351, 376155, 137935, 
      99127, 52731, 0, 0, 119625, 3625, 0, 0, 0, 0, 402813, 29160, 
      185301, 2781, 21069, 1932, 4212, 360, 576, 1125, 0, 0,,,, 2160, 
      810, 0, 0, 111, 179, 43, 0, 0, 0, 0, 0, 0, 0, 185, 105, 0, 65, 
      0, 0,,,,, 0, 0, 0, 0, 337, 105, 36, 157, 37, 18, 18, 16, 4, 21, 
      0, 0, 0, 0, 0,,,,, 0, 0, 60, 40, 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 
      0,,, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0,,,,, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0,,,, 0, 0, 0, 6, 8, 0, 0, 2, 
      0, 0, 0, 0, 0, 0, 0, 0,,, 0, 0, 0, 0, 0,,,, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0,, 0 ] ]

##  doc2/ctblpope.xml (2816-2819)
gap> constit:= Filtered( RationalizedMat( Irr( m ) ),
>                        chi -> ScalarProduct( m, chi, pi ) <> 0 );;

##  doc2/ctblpope.xml (2829-2847)
gap> cand:= PermChars( m, rec( torso:= cand[1], chars:= constit ) );
[ Character( CharacterTable( "M" ),
  [ 4050306254358548053604918389065234375, 148844831270071996434375, 
      2815847622206994375, 14567365753025085, 3447181417680, 
      659368198125, 3520153823175, 548464353255, 5706077895, 
      3056566695, 264515625, 0, 19572895485, 6486480, 186109245, 
      61410960, 758160, 688365, 58310, 0, 172503, 1264351, 376155, 
      137935, 99127, 52731, 0, 0, 119625, 3625, 0, 0, 0, 0, 402813, 
      29160, 185301, 2781, 21069, 1932, 4212, 360, 576, 1125, 0, 0, 
      1302, 294, 0, 2160, 810, 0, 0, 111, 179, 43, 0, 0, 0, 0, 0, 0, 
      0, 185, 105, 0, 65, 0, 0, 224, 0, 14, 0, 0, 0, 0, 0, 337, 105, 
      36, 157, 37, 18, 18, 16, 4, 21, 0, 0, 0, 0, 0, 70, 38, 14, 0, 
      0, 0, 60, 40, 10, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 10, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 24, 0, 6, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 6, 8, 0, 0, 2, 
      0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 4, 0, 2, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (2865-2869)
gap> h:= CharacterTable( "2^[39].(L3(2)x3.S6)" );;
gap> cand[1] = TrivialCharacter( h )^m;
true

##  doc2/ctblpope.xml (2905-2925)
gap> co1:= CharacterTable( "Co1" );;
gap> order:= 2^35*Size( CharacterTable( "L5(2)" ) )*6 / 2^25 / 31;
1981808640
gap> maxes:= List( Maxes( co1 ), CharacterTable );;
gap> filt:= Filtered( maxes, t -> Size( t ) mod order = 0 );
[ CharacterTable( "2^11:M24" ), CharacterTable( "2^(1+8)+.O8+(2)" ), 
  CharacterTable( "2^(2+12):(A8xS3)" ) ]
gap> List( filt, t -> Size( t ) / order );
[ 253, 45, 1 ]
gap> m24:= CharacterTable( "M24" );;
gap> cand:= PermChars( m24, rec( torso:=[ 253 ] ) );
[ Character( CharacterTable( "M24" ),
  [ 253, 29, 13, 10, 1, 5, 5, 1, 3, 2, 1, 1, 1, 1, 3, 0, 2, 1, 1, 1, 
      0, 0, 1, 1, 0, 0 ] ) ]
gap> TestPerm5( m24, cand, m24 mod 11 );
[  ]
gap> PermChars( CharacterTable( "O8+(2)" ), rec( torso:=[ 45 ] ) );
[  ]
gap> k:= filt[3];;

##  doc2/ctblpope.xml (2963-2972)
gap> subtbl:= CharacterTable( "2^4:A8" );;
gap> subtom:= TableOfMarks( subtbl );;
gap> perms:= PermCharsTom( subtbl, subtom );;
gap> nsg:= ClassPositionsOfNormalSubgroups( subtbl );
[ [ 1 ], [ 1, 2 ], [ 1 .. 25 ] ]
gap> above:= Filtered( perms, x -> x[1] = x[2] );;
gap> tbl:= CharacterTable( "L5(2)" );;
gap> above:= Set( Induced( subtbl, tbl, above ) );;

##  doc2/ctblpope.xml (2985-2990)
gap> index2:= Filtered( perms,
>      x -> Sum( PermCharInfo( subtbl, [x] ).contained[1]{ [1,2] } ) = 8 );;
gap> index2:= Filtered( index2, x -> not x[1] in [ 630, 840, 1260, 1680 ] );;
gap> index2:= Set( Induced( subtbl, tbl, index2 ) );;

##  doc2/ctblpope.xml (2999-3023)
gap> orders:= OrdersClassRepresentatives( tbl );;
gap> goodclasses:= Filtered( [ 1 .. NrConjugacyClasses( tbl ) ],
>                            i -> not orders[i] in [ 21, 31 ] );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 ]
gap> matrix:= List( Concatenation( above, index2 ), x -> x{ goodclasses } );;
gap> sol:= SolutionMat( matrix,
>              ListWithIdenticalEntries( Length( goodclasses ), 1 ) );
[ 692/651, 57/217, -78/217, -26/217, 0, 74/651, 11/217, 0, 3/217, 
  151/651, 0, 22/651, 0, 0, 0, -11/217, 0, 0, 0, 0, 0, 0, 0, 0, 
  -115/651, 0, -3/31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -34/93, 
  -11/651, 0, 2/21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1/31, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
gap> nonzero:= Filtered( [ 1 .. Length( sol ) ], i -> sol[i] <> 0 );
[ 1, 2, 3, 4, 6, 7, 9, 10, 12, 16, 25, 27, 106, 107, 109, 120 ]
gap> sol:= sol{ nonzero };;

##  doc2/ctblpope.xml (3041-3065)
gap> a8degrees:= List( above{ Filtered( nonzero,
>                                 x -> x <= Length( above ) ) },
>                      x -> x[1] ) / 31;
[ 1, 8, 15, 28, 56, 56, 70, 105, 120, 168, 336, 336 ]
gap> a8tbl:= subtbl / [ 1, 2 ];;
gap> invtoa8:= InverseMap( GetFusionMap( subtbl, a8tbl ) );;
gap> nsg:= ClassPositionsOfNormalSubgroups( k );;
gap> nn:= First( nsg, x -> Sum( SizesConjugacyClasses( k ){ x } ) = 6*2^14 );;
gap> a8tbl_other:= k / nn;;
gap> g:= CharacterTable( "MC2B" );
CharacterTable( "2^1+24.Co1" )
gap> constit:= [];;
gap> for i in [ 1 .. Length( a8degrees ) ] do
>      cand:= PermChars( a8tbl_other, rec( torso:= [ a8degrees[i] ] ) );
>      filt:= Filtered( perms, x -> x^tbl = above[ nonzero[i] ] );
>      filt:= List( filt, x -> CompositionMaps( x, invtoa8 ) );
>      cand:= Filtered( cand,
>               x -> ForAny( filt, y -> Collected( x ) = Collected(y) ) );
>      Add( constit, List( Induced( Restricted( Induced(
>        Restricted( cand, k ), co1 ), g ), m ), ValuesOfClassFunction ) );
>    od;
gap> List( constit, Length );
[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]

##  doc2/ctblpope.xml (3082-3123)
gap> downdegrees:= List( index2{ Filtered( nonzero,
>                                    x -> x > Length( above ) )
>                                - Length( above ) },
>                        x -> x[1] ) / 31;
[ 30, 210, 210, 1920 ]
gap> f:= g / ClassPositionsOfCentre( g );;
gap> forders:= OrdersClassRepresentatives( f );;
gap> inv:= InverseMap( GetFusionMap( g, f ) );;
gap> for j in [ 1 .. Length( downdegrees ) ] do
>      chars:= [];
>      cand:= PermChars( a8tbl_other, rec( torso:= [ downdegrees[j]/2 ] ) );
>      filt:= Filtered( perms, x -> x^tbl = index2[ nonzero[
>                   j + Length( a8degrees ) ] - Length( above ) ] );
>      filt:= Induced( subtbl, a8tbl, filt,
>                      GetFusionMap( subtbl, a8tbl ));
>      cand:= Filtered( cand, x -> ForAny( filt,
>                 y -> Collected( x ) = Collected( y ) ) );
>      cand:= Restricted( Induced( Restricted( cand, k ), co1 ), g );
>      for chi in cand do
>        cchi:= CompositionMaps( chi, inv );
>        upper:= [];
>        pphi:= [];
>        for i in [ 1 .. NrConjugacyClasses( f ) ] do
>          if forders[i] mod 2 = 1 then
>            pphi[i]:= 2 * cchi[i];
>          elif cchi[i] = 0 then
>            pphi[i]:= 0;
>          fi;
>          upper[i]:= 2* cchi[i];
>        od;
>        Append( chars, PermChars( f, rec( torso:= ShallowCopy( pphi ),
>            upper:= upper,
>            normalsubgroup:= [ 1 .. 4 ],
>            nonfaithful:= cchi ) ) );
>      od;
>      Add( constit, List( Induced( Restricted( chars, g ), m ),
>                          ValuesOfClassFunction ) );
>    od;
gap> List( constit, Length );
[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 10, 10, 2 ]

##  doc2/ctblpope.xml (3131-3143)
gap> cand:= List( Cartesian( constit ), l -> sol * l );;
gap> m:= CharacterTable( "M" );
CharacterTable( "M" )
gap> morders:= OrdersClassRepresentatives( m );;
gap> for x in cand do
>      for i in [ 1 .. Length( morders ) ] do
>        if morders[i] mod 31 = 0 or morders[i] mod 21 = 0 then
>          Unbind( x[i] );
>        fi;
>      od;
>    od;

##  doc2/ctblpope.xml (3151-3167)
gap> cand:= Filtered( cand, x -> ForAll( x, IsInt ) );
[ [ 391965121389536908413379198941796875, 23914487292951376996875, 
      474163138042468875, 9500455925885925, 646346515815, 
      334363486275, 954161764875, 147339103275, 1481392395, 
      1313281515, 0, 8203125, 9827885925, 1216215, 91556325, 9388791, 
      115911, 587331, 874650, 0, 79515, 581955, 336375, 104371, 
      62331, 36855, 0, 0, 0, 0, 28125, 525, 1125, 0, 188325, 16767, 
      88965, 2403, 9477, 1155, 891, 207, 351, 627, 0, 0, 4410, 1498, 
      0, 0, 0, 30, 150, 91, 151, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 125, 
      0, 5, 5,,,,, 0, 0, 0, 0, 141, 45, 27, 61, 27, 9, 9, 7, 3, 15, 
      0, 0, 0, 0, 0, 98, 74, 42, 0, 0, 30, 0, 0, 0, 6, 6, 6,,, 1, 1, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0,,,,, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 
      0, 0, 2, 2, 0, 2,,, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,,,, 0, 
      0, 0, 0, 0, 0,,, 0, 0, 0, 0, 0, 0,, 0, 0, 0 ] ]

##  doc2/ctblpope.xml (3176-3194)
gap> cand:= PermChars( m, rec( torso:= cand[1] ) );
[ Character( CharacterTable( "M" ),
  [ 391965121389536908413379198941796875, 23914487292951376996875, 
      474163138042468875, 9500455925885925, 646346515815, 
      334363486275, 954161764875, 147339103275, 1481392395, 
      1313281515, 0, 8203125, 9827885925, 1216215, 91556325, 9388791, 
      115911, 587331, 874650, 0, 79515, 581955, 336375, 104371, 
      62331, 36855, 0, 0, 0, 0, 28125, 525, 1125, 0, 188325, 16767, 
      88965, 2403, 9477, 1155, 891, 207, 351, 627, 0, 0, 4410, 1498, 
      0, 0, 0, 30, 150, 91, 151, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 125, 
      0, 5, 5, 210, 0, 42, 0, 0, 0, 0, 0, 141, 45, 27, 61, 27, 9, 9, 
      7, 3, 15, 0, 0, 0, 0, 0, 98, 74, 42, 0, 0, 30, 0, 0, 0, 6, 6, 
      6, 3, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      1, 1, 0, 18, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
      0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 2, 3, 3, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (3211-3217)
gap> h:= CharacterTable( "2^(5+10+20).(S3xL5(2))" );;
gap> fus:= PossibleClassFusions( h, m );;
gap> cand = Set( fus, map -> InducedClassFunctionsByFusionMap( h, m,
>                              [ TrivialCharacter( h ) ], map )[1] );
true

##  doc2/ctblpope.xml (3248-3258)
gap> Hbar:= CharacterTable( "O10+(2)" );;
gap> U_Abar:= CharacterTable( "O10+(2)M1" );
CharacterTable( "S8(2)" )
gap> Index( Hbar, U_Abar );
496
gap> U_Bbar:= CharacterTable( "O10+(2)M2" );
CharacterTable( "2^8:O8+(2)" )
gap> Index( Hbar, U_Bbar );
527

##  doc2/ctblpope.xml (3276-3290)
gap> b:= CharacterTable( "B" );
CharacterTable( "B" )
gap> Horder:= 2^26 * Size( Hbar );
1577011055923770163200
gap> order:= Horder / ( 2 * 496 );
1589728887019929600
gap> maxes:= List( Maxes( b ), CharacterTable );;
gap> filt:= Filtered( maxes, t -> Size( t ) mod order = 0 );
[ CharacterTable( "2^(9+16).S8(2)" ) ]
gap> List( filt, t -> Size( t ) / order );
[ 1 ]
gap> u1:= filt[1];
CharacterTable( "2^(9+16).S8(2)" )

##  doc2/ctblpope.xml (3307-3318)
gap> co1:= CharacterTable( "Co1" );;
gap> order:= Horder / ( 2^25 * 527 );
89181388800
gap> maxes:= List( Maxes( co1 ), CharacterTable );;
gap> filt:= Filtered( maxes, t -> Size( t ) mod order = 0 );
[ CharacterTable( "2^(1+8)+.O8+(2)" ) ]
gap> List( filt, t -> Size( t ) / order );
[ 1 ]
gap> u2:= filt[1];
CharacterTable( "2^(1+8)+.O8+(2)" )

##  doc2/ctblpope.xml (3327-3336)
gap> m:= CharacterTable( "M" );
CharacterTable( "M" )
gap> 2b:= CharacterTable( "MC2A" );
CharacterTable( "2.B" )
gap> mm:= CharacterTable( "MC2B" );
CharacterTable( "2^1+24.Co1" )
gap> pi_A:= RestrictedClassFunction( TrivialCharacter( u1 )^b, 2b )^m;;
gap> pi_B:= RestrictedClassFunction( TrivialCharacter( u2 )^co1, mm )^m;;

##  doc2/ctblpope.xml (3344-3347)
gap> torso:= [ Size( m ) / Horder ];
[ 512372707698741056749515292734375 ]

##  doc2/ctblpope.xml (3389-3429)
gap> morders:= OrdersClassRepresentatives( m );;
gap> 2parts:= Union( [ 1 ], Filtered( Set( morders ),
>                          x -> IsPrimePowerInt( x ) and IsEvenInt( x ) ) );
[ 1, 2, 4, 8, 16, 32 ]
gap> factorders:= Set( OrdersClassRepresentatives( Hbar ) );;
gap> primes_A:= Filtered( PrimeDivisors( Horder ), p -> 496 mod p <> 0 );
[ 3, 5, 7, 17 ]
gap> primes_B:= Filtered( PrimeDivisors( Horder ), p -> 527 mod p <> 0 );
[ 2, 3, 5, 7 ]
gap> primes:= Union( primes_A, primes_B );;
gap> n:= NrConjugacyClasses( m );;
gap> for i in [ 1 .. n ] do
>   if Horder mod morders[i] <> 0 then
>     torso[i]:= 0;
>   elif ForAll( factorders, x -> not morders[i] / x in 2parts ) then
>     torso[i]:= 0;
>   else
>     for p in primes do
>       if morders[i] mod p = 0 then
>         pprime:= morders[i];
>         while pprime mod p = 0 do pprime:= pprime / p; od;
>         pos:= PowerMap( m, pprime )[i];
>         if p in primes_A and pi_A[ pos ] = 0 then
>           torso[i]:= 0;
>         elif p in primes_B and pi_B[ pos ] = 0 then
>           torso[i]:= 0;
>         fi;
>       fi;
>     od;
>   fi;
> od;
gap> torso;
[ 512372707698741056749515292734375,,,,, 0,,,,,,,,,,,, 0,, 0,,,,,,,,,,
  ,,,, 0,,,, 0,,,,,, 0, 0, 0,,, 0,,,, 0,,,,,,,,,, 0,,,,,,,, 0, 0, 0, 
  0, 0, 0, 0,,,,, 0,,,,, 0, 0, 0, 0, 0, 0,,,, 0, 0,,,,, 0,,,,,,, 0, 0,
  , 0, 0,,,,, 0, 0, 0, 0, 0,,,,, 0,, 0, 0, 0, 0, 0,, 0, 0, 0, 0, 0, 0,
  , 0,, 0, 0, 0, 0,, 0, 0, 0, 0, 0,,,,,, 0,,, 0, 0,, 0, 0, 0, 0, 0, 
  0, 0, 0, 0,, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0 ]

##  doc2/ctblpope.xml (3480-3504)
gap> cand:= [ [ pi_A ], [ pi_B ] ];;
gap> candbar:= [ TrivialCharacter( U_Abar )^Hbar,
>                TrivialCharacter( U_Bbar )^Hbar ];;
gap> AddSubgroupOfS82:= function( subname )
>   local psis82;
> 
>   psis82:= TrivialCharacter( CharacterTable( subname ) )^U_Abar;
>   Add( cand, [ Restricted( Restricted( psis82, u1 )^b, 2b )^m ] );
>   Add( candbar, psis82 ^ Hbar );
> end;;
gap> tt1:= CharacterTable( "O8+(2)" );
CharacterTable( "O8+(2)" )
gap> AddSubgroupOfO8p2:= function( subname )
>   local psi, list, char;
> 
>   psi:= TrivialCharacter( CharacterTable( subname ) )^tt1;
>   list:= [];
>   for char in Orbit( AutomorphismsOfTable( tt1 ), psi, Permuted ) do
>     AddSet( list, Restricted( Restricted( char, u2 ) ^ co1, mm ) ^ m );
>   od;
>   Add( cand, list );
>   Add( candbar, Restricted( psi, U_Bbar ) ^ Hbar );
> end;;

##  doc2/ctblpope.xml (3513-3525)
gap> AddSubgroupOfS82( "O8+(2).2" );
gap> AddSubgroupOfO8p2( "S6(2)" );
gap> AddSubgroupOfS82( "O8-(2).2" );
gap> AddSubgroupOfS82( "A10.2" );
gap> AddSubgroupOfS82( "S4(4).2" );
gap> AddSubgroupOfS82( "L2(17)" );
gap> AddSubgroupOfO8p2( "A9" );
gap> AddSubgroupOfO8p2( "2^6:A8" );
gap> AddSubgroupOfO8p2( "(3xU4(2)):2" );
gap> AddSubgroupOfO8p2( "(A5xA5):2^2" );
gap> AddSubgroupOfS82( "S8(2)M4" );

##  doc2/ctblpope.xml (3538-3548)
gap> a5:= CharacterTable( "A5" );;
gap> fus:= PossibleClassFusions( a5, U_Abar )[1];;
gap> NrPolyhedralSubgroups( U_Abar, fus[2], fus[3], fus[4] );
rec( number := 548352, type := "A5" )
gap> psis82:= Induced( a5, U_Abar, [ TrivialCharacter( a5 ) ], fus )[1];;
gap> Add( cand, [ Restricted( Restricted( psis82, u1 )^b, 2b )^m ] );
gap> Add( candbar, psis82 ^ Hbar );
gap> List( cand, Length );
[ 1, 1, 1, 2, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1 ]

##  doc2/ctblpope.xml (3563-3598)
gap> Hbarorders:= OrdersClassRepresentatives( Hbar );;
gap> TryCondition:= function( cond )
>   local pos, sol, lincomb, oldknown, i;
> 
>   pos:= Filtered( [ 1 .. Length( Hbarorders ) ],
>             i -> cond( Hbarorders[i] ) );
>   sol:= SolutionMat( candbar{[1..Length(candbar)]}{ pos },
>             ListWithIdenticalEntries( Length( pos ), 1 ) );
>   if sol = fail then
>     return "no solution";
>   fi;
> 
>   pos:= Filtered( [ 1 .. Length( morders) ], i -> cond( morders[i] ) );
>   lincomb:= Filtered( Set( Cartesian( cand ), x -> sol * x ),
>                 x -> ForAll( pos, i -> IsPosInt( x[i] ) or x[i] = 0 ) );
>   if Length( lincomb ) <> 1 then
>     return "solution is not unique";
>   fi;
> 
>   lincomb:= lincomb[1];;
>   oldknown:= Number( torso );
>   for i in pos do
>     if IsBound( torso[i] ) then
>       if torso[i] <> lincomb[i] then
>         Error( "contradiction of new and known value at position ", i );
>       fi;
>     elif not IsInt( lincomb[i] ) or lincomb[i] < 0 then
>       Error( "new value at position ", i, " is not a nonneg. integer" );
>     fi;
>     torso[i]:= lincomb[i];
>   od;
>   return Concatenation( "now ", String( Number( torso ) ), " values (",
>              String( Number( torso ) - oldknown ), " new)" );
> end;;

##  doc2/ctblpope.xml (3618-3631)
gap> TryCondition( x -> x mod 7 = 0 and x mod 3 <> 0 );
"now 99 values (7 new)"
gap> TryCondition( x -> x mod 17 = 0 and x mod 3 <> 0 );
"now 102 values (3 new)"
gap> TryCondition( x -> x mod 5 = 0 and x mod 3 <> 0 );
"now 119 values (17 new)"
gap> TryCondition( x -> 4 mod x = 0 );
"now 125 values (6 new)"
gap> TryCondition( x -> 9 mod x = 0 );
"now 129 values (4 new)"
gap> TryCondition( x -> x in [ 9, 18, 36 ] );
"now 138 values (9 new)"

##  doc2/ctblpope.xml (3640-3644)
gap> constit:= Filtered( RationalizedMat( Irr( m ) ),
>               x -> ScalarProduct( m, x, pi_A ) <> 0
>                    and ScalarProduct( m, x, pi_B ) <> 0 );;

##  doc2/ctblpope.xml (3657-3668)
gap> lower:= [];;
gap> Hindex:= Size( m ) / Horder;
512372707698741056749515292734375
gap> for i in [ 1 .. NrConjugacyClasses( m ) ] do
>   lower[i]:= Maximum( pi_A[i] / ( pi_A[1] / Hindex ),
>                       pi_B[i] / ( pi_B[1] / Hindex ) );
>   if not IsInt( lower[i] ) then
>     lower[i]:= Int( lower[i] + 1 );
>   fi;
> od;

##  doc2/ctblpope.xml (3679-3699)
gap> cand:= PermChars( m, rec( torso:= torso, chars:= constit,
>      lower:= lower, normalsubgroup:= [ 1 .. NrConjugacyClasses( m ) ],
>      nonfaithful:= TrivialCharacter( m ) ) );
[ Character( CharacterTable( "M" ),
  [ 512372707698741056749515292734375, 405589064025344574375, 
      29628786742129575, 658201521662685, 215448838605, 0, 
      121971774375, 28098354375, 335229607, 108472455, 164587500, 
      4921875, 2487507165, 2567565, 26157789, 6593805, 398925, 0, 
      437325, 0, 44983, 234399, 90675, 21391, 41111, 12915, 6561, 
      6561, 177100, 7660, 6875, 315, 275, 0, 113373, 17901, 57213, 0, 
      4957, 1197, 909, 301, 397, 0, 0, 0, 3885, 525, 0, 2835, 90, 45, 
      0, 103, 67, 43, 28, 81, 189, 9, 9, 9, 0, 540, 300, 175, 20, 15, 
      7, 420, 0, 0, 0, 0, 0, 0, 0, 165, 61, 37, 37, 0, 9, 9, 13, 5, 
      0, 0, 0, 0, 0, 0, 77, 45, 13, 0, 0, 45, 115, 19, 10, 0, 5, 5, 
      9, 9, 1, 1, 0, 0, 4, 0, 0, 9, 9, 3, 1, 0, 0, 0, 0, 0, 0, 4, 1, 
      1, 0, 24, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 1, 0, 4, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 0, 3, 3, 1, 1, 2, 0, 3, 3, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ) ]

##  doc2/ctblpope.xml (3714-3720)
gap> h:= CharacterTable( "2^(10+16).O10+(2)" );;
gap> fus:= PossibleClassFusions( h, m );;
gap> cand = Set( fus, map -> InducedClassFunctionsByFusionMap( h, m,
>                              [ TrivialCharacter( h ) ], map )[1] );
true

##  doc2/ctblpope.xml (3745-3750)
gap> t:= CharacterTable( "S5" );
CharacterTable( "A5.2" )
gap> pi:= PermChars( t, rec( torso:= [ 15 ] ) );
[ Character( CharacterTable( "A5.2" ), [ 15, 3, 0, 0, 3, 1, 0 ] ) ]

##  doc2/ctblpope.xml (3759-3768)
gap> m222:= CharacterTable( "M22.2" );
CharacterTable( "M22.2" )
gap> mx:= List( Maxes( m222 ), CharacterTable );;
gap> mx:= Filtered( mx, x -> Size( m222 ) / Size( x ) = 231 );
[ CharacterTable( "M22.2M4" ) ]
gap> pi:= pi[1]{ GetFusionMap( mx[1], t ) };
[ 15, 15, 3, 3, 3, 0, 0, 3, 3, 1, 1, 0, 15, 15, 3, 3, 3, 0, 0, 3, 3, 
  1, 1, 0 ]

##  doc2/ctblpope.xml (3778-3783)
gap> pi:= InducedClassFunction( mx[1], pi, m222 );
ClassFunction( CharacterTable( "M22.2" ),
 [ 3465, 105, 0, 9, 5, 0, 0, 0, 0, 1, 0, 189, 45, 9, 13, 0, 1, 0, 0, 
  0, 0 ] )

##  doc2/ctblpope.xml (3793-3805)
gap> co2:= CharacterTable( "Co2" );
CharacterTable( "Co2" )
gap> mx:= List( Maxes( co2 ), CharacterTable );;
gap> mx:= Filtered( mx, x -> Size( co2 ) / Size( x ) = 46575 );
[ CharacterTable( "2^10:m22:2" ) ]
gap> pi:= pi{ GetFusionMap( mx[1], m222 ) };
[ 3465, 3465, 3465, 3465, 105, 105, 105, 105, 105, 105, 105, 105, 0, 
  0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 1, 1, 1, 0, 189, 189, 189, 189, 189, 189, 45, 45, 45, 45, 
  9, 9, 9, 9, 13, 13, 13, 13, 13, 13, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 
  0, 0, 0, 0, 0, 0, 0 ]

##  doc2/ctblpope.xml (3813-3820)
gap> pi:= InducedClassFunction( mx[1], pi, co2 );
ClassFunction( CharacterTable( "Co2" ),
 [ 161382375, 626535, 162855, 27495, 0, 0, 6615, 3975, 2727, 855, 
  567, 975, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 51, 19, 27, 35, 7, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0 ] )

##  doc2/ctblpope.xml (3831-3840)
gap> b:= CharacterTable( "B" );
CharacterTable( "B" )
gap> mx:= List( Maxes( b ), CharacterTable );;
gap> mx:= Filtered( mx, x -> Size( b ) / Size( x ) = 11707448673375 );
[ CharacterTable( "2^(1+22).Co2" ) ]
gap> pi:= pi{ GetFusionMap( mx[1], co2 ) };;
gap> pi[1];
161382375

##  doc2/ctblpope.xml (3848-3863)
gap> pi:= InducedClassFunction( mx[1], pi, b );
ClassFunction( CharacterTable( "B" ),
 [ 1889375872099856765625, 2609385408855225, 62316674429625, 
  207818526825, 268788490425, 0, 0, 13052741625, 7537207545, 
  128298681, 270580905, 46366425, 74315385, 35633385, 3937689, 
  201825, 1233225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 713097, 
  241425, 320625, 88521, 275265, 57705, 19305, 20089, 9441, 6489, 
  2577, 1825, 5345, 753, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  273, 417, 105, 97, 185, 33, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] )

##  doc2/ctblpope.xml (3922-3932)
gap> mcl:= CharacterTable( "McL" );
CharacterTable( "McL" )
gap> co2:= CharacterTable( "Co2" );
CharacterTable( "Co2" )
gap> ind:= Induced( mcl, co2, [ TrivialCharacter( mcl ) ] )[1];
Character( CharacterTable( "Co2" ),
 [ 47104, 0, 1024, 0, 16, 160, 0, 0, 0, 0, 64, 0, 0, 4, 24, 16, 0, 0, 
  0, 16, 0, 8, 0, 0, 0, 0, 0, 8, 4, 4, 0, 0, 2, 0, 0, 0, 0, 0, 0, 4, 
  0, 0, 2, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ] )

##  doc2/ctblpope.xml (3941-3968)
gap> m:= CharacterTable( "BM2" );
CharacterTable( "2^(1+22).Co2" )
gap> infl:= ind{ GetFusionMap( m, co2 ) };
[ 47104, 47104, 47104, 47104, 47104, 47104, 47104, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 1024, 1024, 1024, 1024, 1024, 1024, 1024, 1024, 
  1024, 1024, 1024, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 16, 16, 16, 16, 160, 160, 160, 160, 160, 160, 160, 160, 
  160, 160, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 4, 4, 4, 24, 24, 24, 24, 24, 24, 24, 24, 16, 16, 16, 
  16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 
  16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 
  8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 
  4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 
  2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 
  4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 
  2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  1, 1, 1, 1 ]

##  doc2/ctblpope.xml (3976-3993)
gap> b:= CharacterTable( "B" );
CharacterTable( "B" )
gap> ind:= Induced( m, b, [ infl ] )[1];
ClassFunction( CharacterTable( "B" ),
 [ 551467662310656000, 186911262720, 272993634304, 0, 634521600, 
  194594400, 69984, 8495104, 17465344, 129024, 276480, 2073600, 
  16384, 798720, 46080, 0, 5120, 138600, 1000, 110880, 252000, 
  112480, 432, 12960, 0, 1312, 8352, 864, 432, 0, 2520, 0, 2880, 
  2880, 3072, 2880, 0, 0, 256, 64, 1152, 576, 640, 192, 96, 0, 108, 
  2520, 744, 0, 104, 120, 40, 30, 160, 16, 1120, 1024, 0, 0, 96, 288, 
  64, 144, 0, 96, 0, 108, 16, 48, 0, 32, 12, 0, 0, 0, 168, 0, 104, 
  48, 0, 4, 0, 0, 0, 0, 32, 16, 8, 8, 0, 24, 12, 4, 0, 0, 0, 0, 24, 
  4, 24, 24, 0, 0, 0, 0, 4, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 8, 0, 16, 8, 4, 0, 0, 0, 0, 0, 4, 2, 
  2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] )

##  doc2/ctblpope.xml (4001-4021)
gap> 2b:= CharacterTable( "2.B" );
CharacterTable( "2.B" )
gap> infl:= ind{ GetFusionMap( 2b, b ) };
[ 551467662310656000, 551467662310656000, 186911262720, 272993634304, 
  272993634304, 0, 634521600, 194594400, 194594400, 69984, 69984, 
  8495104, 17465344, 129024, 276480, 2073600, 2073600, 16384, 798720, 
  46080, 0, 5120, 138600, 138600, 1000, 1000, 110880, 252000, 112480, 
  112480, 432, 12960, 0, 1312, 1312, 8352, 864, 864, 432, 0, 2520, 
  2520, 0, 2880, 2880, 3072, 2880, 0, 0, 256, 64, 1152, 576, 576, 
  640, 192, 96, 0, 0, 108, 108, 2520, 744, 744, 0, 104, 104, 120, 40, 
  40, 30, 30, 160, 16, 1120, 1024, 0, 0, 0, 96, 288, 64, 144, 144, 0, 
  96, 0, 108, 108, 16, 48, 0, 32, 12, 12, 0, 0, 0, 0, 168, 0, 104, 
  104, 48, 0, 0, 4, 4, 0, 0, 0, 0, 32, 16, 8, 8, 8, 0, 0, 24, 12, 4, 
  4, 0, 0, 0, 0, 0, 0, 24, 4, 24, 24, 0, 0, 0, 0, 0, 4, 0, 0, 0, 6, 
  6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 
  0, 0, 0, 0, 0, 0, 8, 0, 16, 8, 4, 4, 0, 0, 0, 0, 0, 0, 4, 4, 2, 2, 
  2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

##  doc2/ctblpope.xml (4042-4078)
gap> centre:= ClassPositionsOfCentre( 2b );
[ 1, 2 ]
gap> pi:= PermChars( 2b, rec( torso:= [ 2 * infl[1], 0 ],
>                             normalsubgroup:= centre,
>                             nonfaithful:= infl ) );
[ Character( CharacterTable( "2.B" ),
  [ 1102935324621312000, 0, 186911262720, 541790208000, 4197060608, 
      0, 634521600, 389188800, 0, 139968, 0, 8495104, 17465344, 
      129024, 276480, 4026240, 120960, 16384, 798720, 46080, 0, 5120, 
      277200, 0, 2000, 0, 110880, 252000, 190080, 34880, 432, 12960, 
      0, 2592, 32, 8352, 1728, 0, 432, 0, 5040, 0, 0, 2880, 2880, 
      3072, 2880, 0, 0, 256, 64, 1152, 1008, 144, 640, 192, 96, 0, 0, 
      216, 0, 2520, 960, 528, 0, 200, 8, 120, 80, 0, 60, 0, 160, 16, 
      1120, 1024, 0, 0, 0, 96, 288, 64, 216, 72, 0, 96, 0, 216, 0, 
      16, 48, 0, 32, 24, 0, 0, 0, 0, 0, 168, 0, 160, 48, 48, 0, 0, 8, 
      0, 0, 0, 0, 0, 32, 16, 8, 12, 4, 0, 0, 24, 12, 0, 8, 0, 0, 0, 
      0, 0, 0, 24, 4, 24, 24, 0, 0, 0, 0, 0, 4, 0, 0, 0, 6, 6, 8, 4, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 
      0, 0, 0, 0, 8, 0, 16, 8, 8, 0, 0, 0, 0, 0, 0, 0, 8, 0, 2, 2, 2, 
      2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> MatScalarProducts( 2b, Irr( 2b ), pi );
[ [ 1, 1, 2, 1, 2, 0, 2, 3, 2, 0, 0, 1, 4, 1, 2, 0, 3, 2, 0, 2, 0, 0, 
      2, 2, 0, 0, 2, 3, 1, 5, 0, 4, 3, 2, 0, 0, 3, 2, 0, 6, 4, 0, 1, 
      1, 0, 0, 0, 0, 3, 0, 1, 0, 0, 5, 0, 5, 2, 0, 0, 2, 0, 0, 4, 1, 
      0, 2, 0, 4, 2, 4, 4, 3, 0, 2, 4, 2, 4, 0, 3, 0, 3, 2, 5, 0, 1, 
      0, 3, 1, 0, 1, 1, 2, 5, 3, 1, 1, 4, 5, 1, 1, 0, 3, 0, 0, 3, 2, 
      1, 1, 2, 1, 1, 4, 0, 3, 2, 3, 1, 3, 0, 1, 3, 0, 2, 2, 1, 3, 3, 
      0, 0, 2, 0, 0, 0, 0, 3, 0, 3, 3, 3, 1, 0, 3, 0, 4, 0, 1, 0, 0, 
      2, 0, 0, 2, 0, 0, 2, 1, 1, 0, 0, 0, 0, 1, 2, 1, 1, 1, 0, 1, 1, 
      1, 1, 1, 1, 0, 2, 1, 1, 3, 3, 0, 0, 0, 1, 1, 1, 1, 2, 3, 2, 0, 
      0, 2, 2, 4, 3, 5, 2, 4, 0, 0, 0, 0, 5, 2, 0, 0, 0, 1, 1, 0, 0, 
      0, 0, 0, 0, 7, 0, 0, 1, 7, 7, 0, 0, 0, 1, 6, 4, 5, 0, 0, 3, 0, 
      0, 0, 0, 0, 4, 1, 1, 3, 8, 3, 2, 2, 5, 0, 1 ] ]

##  doc2/ctblpope.xml (4180-4201)
gap> names:= AllCharacterTableNames( IsSporadicSimple, true,
>            IsDuplicateTable, false : OrderedBy:= Size );
[ "M11", "M12", "J1", "M22", "J2", "M23", "HS", "J3", "M24", "McL", 
  "He", "Ru", "Suz", "ON", "Co3", "Co2", "Fi22", "HN", "Ly", "Th", 
  "Fi23", "Co1", "J4", "F3+", "B", "M" ]
gap> normindices:= rec( Co1:= 1, J4:= 1, F3\+:= 1, B:= 1, M:= 1 );;
gap> for name in names do
>      n:= CharacterTable( Concatenation( name, "N2" ) );
>      if n = fail then
>        Print( name, "\n" );
>      else
>        2part:= 2^Length( Positions( Factors( Size( n ) ), 2 ) );
>        normindices.( name ):= Size( n ) / 2part;
>      fi;
>    od;
Co1
J4
F3+
B
M

##  doc2/ctblpope.xml (4212-4226)
gap> maxbound:= [];;
gap> for name in names do
>      t:= CharacterTable( name );
>      mx:= List( Maxes( t ), CharacterTable );
>      odd:= Filtered( mx, s -> ( Size( t ) / Size( s ) ) mod 2 <> 0 );
>      primperm:= List( odd, s -> TrivialCharacter( s )^t );
>      sum:= normindices.( name ) * Sum( primperm, pi -> pi / pi[1] );
>      Add( maxbound,
>           [ name, Maximum( sum{ [ 2 .. Length( sum ) ] } ) ] );
>    od;
gap> SortBy( maxbound, x -> - x[2] );
gap> maxbound[1];
[ "J2", 3/5 ]

##  doc2/ctblpope.xml (4279-4336)
gap> upper_bound:= function( tblS, tblM, p )
>    local ppart, ppartposS, ppartposM, n, N_S, f, subname, u;
> 
>    ppart:= Product( Filtered( Factors( Size( tblS ) ), x -> x = p ), 1 );
>    ppartposS:= Positions( OrdersClassRepresentatives( tblS ), ppart );
>    if 0 < Length( ppartposS ) then
>      # P is cyclic.
>      if tblM = fail then
>        return ( SizesCentralizers( tblS )[ ppartposS[1] ] * Phi( ppart )
>                 / Length( ppartposS ) ) / ppart;
>      else
>        ppartposM:= Positions( OrdersClassRepresentatives( tblM ), ppart );
>        return ( SizesCentralizers( tblS )[ ppartposS[1] ] * Phi( ppart )
>                 / Length( ppartposS ) ) /
>               ( SizesCentralizers( tblM )[ ppartposM[1] ] * Phi( ppart )
>                 / Length( ppartposM ) );
>      fi;
>    fi;
>  
>    # Compute |N_S(P)|.
>    n:= CharacterTable( Concatenation( Identifier( tblS ), "N",
>                            String( p ) ) );
>    if n <> fail then
>      N_S:= Size( n );
>    elif p = 2 then
>      N_S:= ppart * normindices.( Identifier( tblS ) );
>    elif Identifier( tblS ) = "M" and p = 3 then
>      # The Sylow 3-normalizer is contained in 3^(3+2+6+6):(L3(3)xSD16)
>      N_S:= ppart * 2^6;
>    elif Identifier( tblS ) = "F3+" and p = 3 then
>      N_S:= ppart * 8;
>    else
>      Error( "cannot compute |N_S(P)|" );
>    fi;
>  
>    if tblM = fail then
>      return N_S / ppart;
>    elif Sum( SizesConjugacyClasses( tblM ){
>                  ClassPositionsOfPCore( tblM, p ) } ) = ppart then
>      # P is normal in M.
>      return N_S / Size( tblM );
>    fi;
> 
>    # Inspect known character tables of subgroups of M.
>    f:= N_S / ppart;
>    for subname in NamesOfFusionSources( tblM ) do
>      u:= CharacterTable( subname );
>      if ClassPositionsOfKernel( GetFusionMap( u, tblM ) ) = [ 1 ] and
>         Sum( SizesConjugacyClasses( u ){
>                  ClassPositionsOfPCore( u, p ) } ) = ppart then
>        f:= Minimum( f, N_S / Size( u ) );
>      fi;
>    od;
> 
>    return f;
>  end;;

##  doc2/ctblpope.xml (4380-4438)
gap> badcases_thm:= [];;
gap> badcases_strong:= [];;
gap> good:= "dummy";;   #  Avoid a message about an unbound variable ...
gap> for name in Filtered( names, x -> x <> "M" ) do
>      t:= CharacterTable( name );
>      orders:= OrdersClassRepresentatives( t );
>      n:= NrConjugacyClasses( t );
>      mx:= List( Maxes( t ), CharacterTable );
>      for p in PrimeDivisors( Size( t ) ) do
>        good:= Filtered( mx, s -> ( Size( t ) / Size( s ) ) mod p <> 0 );
>        primperm:= [];
>        for s in good do
>          if GetFusionMap( s, t ) <> fail then
>            Add( primperm, TrivialCharacter( s )^t );
>          else
>            ind:= Set( PossibleClassFusions( s, t ),
>                       map -> InducedClassFunctionsByFusionMap( s, t,
>                                  [ TrivialCharacter( s ) ], map )[1] );
>            if Length( ind ) <> 1 then
>              Error( "permutation character not uniquely determined" );
>            fi;
>            Add( primperm, ind[1] );
>          fi;
>        od;
>        sum:= Sum( [ 1 .. Length( good ) ],
>                   i -> upper_bound( t, good[i], p )
>                        * primperm[i] / primperm[i][1] );
>        badpos:= Filtered( [ 2 .. Length( sum ) ], i -> sum[i] >= 1 );
>        if badpos <> [] then
>          Add( badcases_strong, [ name, p, ShallowCopy( badpos ) ] );
>          for i in ShallowCopy( badpos ) do
>            q:= SmallestRootInt( orders[i] );
>            if IsPrimeInt( q ) then
>              if ForAny( [ 2 .. n ],
>                         j -> SmallestRootInt( orders[j] ) = q
>                              and not j in badpos ) then
>                RemoveSet( badpos, i );
>              fi;
>            fi;
>          od;
>          if not IsEmpty( badpos ) then
>            Add( badcases_thm, [ name, p, badpos ] );
>          fi;
>        fi;
>      od;
>    od;
gap> badcases_thm;
[ [ "M23", 3, [ 3 ] ], [ "HS", 3, [ 4, 11 ] ] ]
gap> badcases_strong;
[ [ "M11", 5, [ 2 ] ], [ "M12", 5, [ 3, 4 ] ], [ "M22", 3, [ 2 ] ], 
  [ "M22", 5, [ 2 ] ], [ "J2", 3, [ 2 ] ], [ "M23", 3, [ 2, 3 ] ], 
  [ "M23", 5, [ 2 ] ], [ "M23", 7, [ 2 ] ], 
  [ "HS", 3, [ 2, 3, 4, 5, 6, 7, 9, 11 ] ], [ "HS", 5, [ 2, 3, 5 ] ], 
  [ "M24", 5, [ 2, 4 ] ], [ "M24", 7, [ 2, 4 ] ], [ "He", 5, [ 2 ] ], 
  [ "Co2", 3, [ 2, 3 ] ], [ "Fi22", 5, [ 2 ] ], [ "Fi22", 7, [ 2 ] ], 
  [ "Fi23", 5, [ 2, 3, 5 ] ], [ "Fi23", 7, [ 2 ] ], [ "B", 7, [ 2 ] ] 
 ]

##  doc2/ctblpope.xml (4461-4496)
gap> prove_generation:= function( name, p )
>    local S, prg, P, reps, good, x, g, U;
> 
>    prg:= AtlasProgram( name, "classes" );
>    if prg = fail then
>      return fail;
>    fi;
> 
>    S:= AtlasGroup( name );
>    P:= SylowSubgroup( S, p );
>    reps:= ResultOfStraightLineProgram( prg.program, GeneratorsOfGroup( S ) );
>    good:= [];
>    for x in Filtered( reps, x -> Order( x ) <> 1 ) do
>      repeat
>        g:= Random( S );
>        U:= ClosureGroup( P, x^g );
>      until Size( U ) = Size( S );
>      Add( good, x^g );
>    od;
> 
>    return [ P, good ];
>  end;;
gap> for entry in badcases_strong do
>      res:= prove_generation( entry[1], entry[2] );
>      if res = fail then
>        Print( "no classes script for ", entry, "\n" );
>      fi;
>    od;
no classes script for [ "He", 5, [ 2 ] ]
no classes script for [ "Fi22", 5, [ 2 ] ]
no classes script for [ "Fi22", 7, [ 2 ] ]
no classes script for [ "Fi23", 5, [ 2, 3, 5 ] ]
no classes script for [ "Fi23", 7, [ 2 ] ]
no classes script for [ "B", 7, [ 2 ] ]

##  doc2/ctblpope.xml (4511-4522)
gap> S:= AtlasGroup( "He" );;
gap> repeat
>      x:= Random( S );
>    until Order( x ) = 10;
gap> x:= x^5;;
gap> P5:= SylowSubgroup( S, 5 );;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P5, x^g );
>    until Size( U ) = Size( S );

##  doc2/ctblpope.xml (4531-4547)
gap> S:= AtlasGroup( "Fi22" );;
gap> repeat
>      x:= Random( S );
>    until Order( x ) = 30;
gap> x:= x^15;;
gap> P5:= SylowSubgroup( S, 5 );;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P5, x^g );
>    until Size( U ) = Size( S );
gap> P7:= SylowSubgroup( S, 7 );;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P7, x^g );
>    until Size( U ) = Size( S );

##  doc2/ctblpope.xml (4556-4572)
gap> S:= AtlasGroup( "Fi23" );;
gap> repeat
>      x:= Random( S );
>    until Order( x ) = 42;
gap> x:= x^21;;
gap> P5:= SylowSubgroup( S, 5 );;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P5, x^g );
>    until Size( U ) = Size( S );
gap> P7:= SylowSubgroup( S, 7 );;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P7, x^g );
>    until Size( U ) = Size( S );

##  doc2/ctblpope.xml (4581-4590)
gap> repeat
>      x:= Random( S );
>    until Order( x ) = 60;
gap> x:= x^30;;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P5, x^g );
>    until Size( U ) = Size( S );

##  doc2/ctblpope.xml (4599-4608)
gap> repeat
>      x:= Random( S );
>    until Order( x ) = 60;
gap> x:= x^20;;
gap> repeat
>      g:= Random( S );
>      U:= ClosureGroup( P5, x^g );
>    until Size( U ) = Size( S );

##  doc2/ctblpope.xml (4624-4635)
gap> t:= CharacterTable( "B" );;
gap> 7pos:= Positions( OrdersClassRepresentatives( t ), 7 );
[ 31 ]
gap> 47pos:= Positions( OrdersClassRepresentatives( t ), 47 );
[ 172, 173 ]
gap> ClassMultiplicationCoefficient( t, 2, 7pos[1], 47pos[1] );
7332
gap> Filtered( Maxes( t ),
>        x -> Size( CharacterTable( x ) ) mod 47 = 0 );
[ "47:23" ]

##  doc2/ctblpope.xml (4668-4699)
gap> dir:= DirectoriesPackageLibrary( "ctbllib", "data" );;
gap> filename:= Filename( dir, "prim_perm_M.json" );;
gap> Monster_prim_data:= EvalString( StringFile( filename ) )[2];;
gap> Length( Monster_prim_data );
46
gap> t:= CharacterTable( "M" );;
gap> monstermaxindices:= [];;
gap> monstermaxtables:= [];;
gap> for entry in Monster_prim_data do
>      if Length( entry ) = 1 then
>        s:= CharacterTable( entry[1] );
>        Add( monstermaxtables, s );
>        Add( monstermaxindices, Size( t ) / Size( s ) );
>      else
>        Add( monstermaxtables, fail );
>        Add( monstermaxindices, entry[2][1] );
>      fi;
>    od;
gap> odd_prim:= [];;
gap> for i in [ 1 .. Length( Monster_prim_data ) ] do
>      if monstermaxindices[i] mod 2 <> 0 then
>        if monstermaxtables[i] <> fail then
>          Add( odd_prim, TrivialCharacter( monstermaxtables[i] )^t );
>        else
>          Add( odd_prim, Monster_prim_data[i][2] );
>        fi;
>      fi;
>    od;
gap> Length( odd_prim );
5

##  doc2/ctblpope.xml (4707-4713)
gap> sum:= normindices.M * Sum( odd_prim, pi -> pi / pi[1] );;
gap> max:= Maximum( sum{ [ 2 .. Length( sum ) ] } );
12784979/103007903752128375
gap> max < 10^-9;
true

##  doc2/ctblpope.xml (4745-4780)
gap> t:= CharacterTable( "M" );;
gap> orders:= OrdersClassRepresentatives( t );;
gap> for p in Difference( PrimeDivisors( Size( t ) ), [ 19 ] ) do
>   goodpos:= Filtered( [ 1 .. Length( Monster_prim_data ) ],
>                       i -> monstermaxindices[i] mod p <> 0 );
>   sum:= ListWithIdenticalEntries( NrConjugacyClasses( t ), 0 );
>   for i in goodpos do
>     if Length( Monster_prim_data[i] ) = 2 then
>       # We know the permutation character but not the subgroup table.
>       sum:= sum + upper_bound( t, fail, p )
>                   * Monster_prim_data[i][2] / monstermaxindices[i];
>     else
>       s:= monstermaxtables[i];
>       if GetFusionMap( s, t ) <> fail then
>         # We can compute the permutation character.
>         sum:= sum + upper_bound( t, s, p )
>                     * TrivialCharacter( s )^t / monstermaxindices[i];
>       else
>         # We get only candidates for the permutation character.
>         cand:= Set( PossibleClassFusions( s, t ),
>                     map -> InducedClassFunctionsByFusionMap( s, t,
>                                [ TrivialCharacter( s ) ], map )[1] );
>         # For each class, take the maximum of the possible values.
>         sum:= sum + upper_bound( t, s, p )
>                     * List( TransposedMat( cand ), Maximum )
>                     / monstermaxindices[i];
>       fi;
>     fi;
>   od;
>   badpos:= Filtered( [ 2 .. Length( sum ) ], i -> sum[i] >= 1 );
>   if badpos <> [] then
>     Error( "check open cases in ", badpos, "\n" );
>   fi;
> od;

##  doc2/ctblpope.xml (4795-4808)
gap> pos19:= Positions( OrdersClassRepresentatives( t ), 19 );
[ 63 ]
gap> pos71:= Positions( OrdersClassRepresentatives( t ), 71 );
[ 169, 170 ]
gap> ClassMultiplicationCoefficient( t, pos19[1], pos19[1], pos71[1] );
621743152370566020417806353602387433415016198936
gap> ForAny( monstermaxindices,
>            x -> ( Size( t ) / x ) mod ( 19 * 71 ) = 0 );
false
gap> ForAny( [ "L2(13)", "U3(4)", "U3(8)", "Sz(8)" ],
>            x -> Size( CharacterTable( x ) ) mod 71 = 0 );
false

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "ctblpope.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
