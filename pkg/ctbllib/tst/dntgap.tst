# This file was created automatically, do not edit!
#############################################################################
##
#W  dntgap.tst              GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "dntgap.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "dntgap.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/dntgap.xml (46-55)
gap> LoadPackage( "AtlasRep", "1.5", false );
true
gap> LoadPackage( "cohomolo", "1.6", false );
true
gap> LoadPackage( "CTblLib", "1.2", false );
true
gap> LoadPackage( "TomLib", "1.2.1", false );
true

##  doc2/dntgap.xml (70-94)
gap> p:= 2;;  d:= 12;;
gap> t:= CharacterTable( "Sz(8)" ) mod p;
BrauerTable( "Sz(8)", 2 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
Sz(8)mod2

       1a 5a 7a 7b 7c 13a 13b 13c

Y.1     1  1  1  1  1   1   1   1
Y.2     4 -1  A  C  B   D   F   E
Y.3     4 -1  B  A  C   E   D   F
Y.4     4 -1  C  B  A   F   E   D

A = E(7)^2+E(7)^3+E(7)^4+E(7)^5
B = E(7)+E(7)^2+E(7)^5+E(7)^6
C = E(7)+E(7)^3+E(7)^4+E(7)^6
D = E(13)+E(13)^5+E(13)^8+E(13)^12
E = E(13)^4+E(13)^6+E(13)^7+E(13)^9
F = E(13)^2+E(13)^3+E(13)^10+E(13)^11
gap> List( irr, x -> SizeOfFieldOfDefinition( x, p ) );
[ 2, 8, 8, 8 ]

##  doc2/dntgap.xml (105-117)
gap> info:= OneAtlasGeneratingSetInfo( "Sz(8)", Dimension, 4,
>               Characteristic, p );
rec( charactername := "4a", constituents := [ 2 ], contents := "core",
  dim := 4, groupname := "Sz(8)", id := "a", 
  identifier := [ "Sz(8)", [ "Sz8G1-f8r4aB0.m1", "Sz8G1-f8r4aB0.m2" ],
      1, 8 ], repname := "Sz8G1-f8r4aB0", repnr := 17, 
  ring := GF(2^3), size := 29120, standardization := 1, 
  type := "matff" )
gap> gens_dim4:= AtlasGenerators( info ).generators;;
gap> b:= Basis( GF(8) );; 
gap> gens_dim12:= List( gens_dim4, x -> BlownUpMatrix( b, x ) );;

##  doc2/dntgap.xml (125-132)
gap> s:= AtlasGroup( "Sz(8)", IsPermGroup, true );;
gap> chr:= CHR( s, p, 0, gens_dim12 );;
gap> SizeScreen( [ 100 ] );;
gap> SecondCohomologyDimension( chr );
0
gap> SizeScreen( [ 72 ] );;

##  doc2/dntgap.xml (159-171)
gap> mats:= List( [1 .. 3 ], x -> IdentityMat( d+1, GF(p) ) );;
gap> v:= mats[1][ d+1 ];;
gap> mats[1]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_dim12[1];;
gap> mats[2]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_dim12[2];;
gap> mats[3][ d+1 ][1]:= Z(p)^0;;
gap> grp:= Group( mats );;
gap> g:= Image( IsomorphismPermGroup( grp ) );;
gap> Size( g );
119275520
gap> NrConjugacyClasses( g );
41

##  doc2/dntgap.xml (195-205)
gap> iso:= IsomorphismTypeInfoFiniteSimpleGroup( s );
rec( name := "2B(2,8) = 2C(2,8) = Sz(8)", parameter := 8, 
  series := "2B", shortname := "Sz(8)" )
gap> names:= AllCharacterTableNames( Size, 2^12 * Size( s ) );;
gap> cand:= List( names, CharacterTable );;
gap> cand:= Filtered( cand,
>      t -> ForAny( ClassPositionsOfMinimalNormalSubgroups( t ),
>             n -> IsomorphismTypeInfoFiniteSimpleGroup( t / n ) = iso ) );
[ CharacterTable( "2^12:Sz(8)" ) ]

##  doc2/dntgap.xml (214-219)
gap> t:= cand[1];;
gap> rationals:= Filtered( Irr( t ), x -> IsSubset( Integers, x ) );;
gap> Collected( List( rationals, x -> x[1] ) );
[ [ 1, 1 ], [ 64, 1 ], [ 91, 1 ], [ 455, 8 ], [ 3640, 8 ] ]

##  doc2/dntgap.xml (234-253)
gap> p:= 2;;  d:= 10;;
gap> t:= CharacterTable( "M22" ) mod p;
BrauerTable( "M22", 2 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
M22mod2

       1a 3a 5a 7a 7b 11a 11b

Y.1     1  1  1  1  1   1   1
Y.2    10  1  .  A /A  -1  -1
Y.3    10  1  . /A  A  -1  -1

A = E(7)+E(7)^2+E(7)^4
  = (-1+Sqrt(-7))/2 = b7
gap> List( irr, x -> SizeOfFieldOfDefinition( x, p ) );
[ 2, 2, 2 ]

##  doc2/dntgap.xml (264-280)
gap> info:= AllAtlasGeneratingSetInfos( "M22", Dimension, d,
>               Characteristic, p );
[ rec( charactername := "10a", constituents := [ 2 ], 
      contents := "core", dim := 10, groupname := "M22", id := "a", 
      identifier := 
        [ "M22", [ "M22G1-f2r10aB0.m1", "M22G1-f2r10aB0.m2" ], 1, 2 ],
      repname := "M22G1-f2r10aB0", repnr := 13, ring := GF(2), 
      size := 443520, standardization := 1, type := "matff" ), 
  rec( charactername := "10b", constituents := [ 3 ], 
      contents := "core", dim := 10, groupname := "M22", id := "b", 
      identifier := 
        [ "M22", [ "M22G1-f2r10bB0.m1", "M22G1-f2r10bB0.m2" ], 1, 2 ],
      repname := "M22G1-f2r10bB0", repnr := 14, ring := GF(2), 
      size := 443520, standardization := 1, type := "matff" ) ]
gap> gens:= List( info, r -> AtlasGenerators( r ).generators );;

##  doc2/dntgap.xml (289-299)
gap> s:= AtlasGroup( "M22", IsPermGroup, true );;
gap> chr:= CHR( s, p, 0, gens[1] );;
gap> SizeScreen( [ 100 ] );;
gap> SecondCohomologyDimension( chr );
0
gap> chr:= CHR( s, p, 0, gens[2] );;
gap> SecondCohomologyDimension( chr );
0
gap> SizeScreen( [ 72 ] );;

##  doc2/dntgap.xml (314-333)
gap> gens_1:= gens[1];;
gap> mats:= List( [1 .. 3 ], x -> IdentityMat( d+1, GF(p) ) );;
gap> v:= mats[1][ d+1 ];;
gap> mats[1]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_1[1];;
gap> mats[2]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_1[2];;
gap> mats[3][ d+1 ][1]:= Z(p)^0;;
gap> grp_1:= Group( mats );;
gap> Size( grp_1 );
454164480
gap> gens_2:= gens[1];;
gap> mats:= List( [1 .. 3 ], x -> IdentityMat( d+1, GF(p) ) );;
gap> v:= mats[1][ d+1 ];;
gap> mats[1]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_2[1];;
gap> mats[2]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_2[2];;
gap> mats[3][ d+1 ][1]:= Z(p)^0;;
gap> grp_2:= Group( mats );;
gap> Size( grp_2 );
454164480

##  doc2/dntgap.xml (343-354)
gap> iso:= IsomorphismTypeInfoFiniteSimpleGroup( s );
rec( name := "M(22)", series := "Spor", shortname := "M22" )
gap> names:= AllCharacterTableNames( Size, 2^10 * Size( s ) );;
gap> cand:= List( names, CharacterTable );;
gap> cand:= Filtered( cand,
>      t -> ForAny( ClassPositionsOfMinimalNormalSubgroups( t ),
>             n -> IsomorphismTypeInfoFiniteSimpleGroup( t / n ) = iso ) );
[ CharacterTable( "2^10:M22'" ), CharacterTable( "2^10:m22" ) ]
gap> List( cand, NrConjugacyClasses );
[ 47, 43 ]

##  doc2/dntgap.xml (363-379)
gap> t:= cand[1];;
gap> rationals:= Filtered( Irr( t ), x -> IsSubset( Integers, x ) );;
gap> Collected( List( rationals, x -> x[1] ) );
[ [ 1, 1 ], [ 21, 1 ], [ 22, 1 ], [ 55, 1 ], [ 99, 1 ], [ 154, 1 ], 
  [ 210, 1 ], [ 231, 3 ], [ 385, 1 ], [ 440, 1 ], [ 770, 5 ], 
  [ 924, 2 ], [ 1155, 2 ], [ 1386, 1 ], [ 1408, 1 ], [ 3080, 2 ], 
  [ 3465, 4 ], [ 4620, 2 ], [ 6930, 3 ], [ 9240, 1 ] ]
gap> t:= cand[2];;
gap> rationals:= Filtered( Irr( t ), x -> IsSubset( Integers, x ) );;
gap> Collected( List( rationals, x -> x[1] ) );
[ [ 1, 1 ], [ 21, 1 ], [ 55, 1 ], [ 77, 1 ], [ 99, 1 ], [ 154, 1 ], 
  [ 210, 1 ], [ 231, 1 ], [ 330, 1 ], [ 385, 3 ], [ 616, 2 ], 
  [ 693, 1 ], [ 770, 1 ], [ 1155, 2 ], [ 1980, 1 ], [ 2310, 4 ], 
  [ 2640, 1 ], [ 3465, 2 ], [ 4620, 1 ], [ 5544, 2 ], [ 6160, 1 ], 
  [ 6930, 2 ], [ 9856, 1 ] ]

##  doc2/dntgap.xml (396-419)
gap> p:= 2;;  d:= 12;;
gap> t:= CharacterTable( "J2" ) mod p;
BrauerTable( "J2", 2 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
J2mod2

       1a 3a 3b 5a 5b 5c 5d 7a 15a 15b

Y.1     1  1  1  1  1  1  1  1   1   1
Y.2     6 -3  .  A *A  B *B -1   C  *C
Y.3     6 -3  . *A  A *B  B -1  *C   C

A = -2*E(5)-2*E(5)^4
  = 1-Sqrt(5) = 1-r5
B = E(5)+2*E(5)^2+2*E(5)^3+E(5)^4
  = (-3-Sqrt(5))/2 = -2-b5
C = E(5)+E(5)^4
  = (-1+Sqrt(5))/2 = b5
gap> List( irr, x -> SizeOfFieldOfDefinition( x, p ) );
[ 2, 4, 4 ]

##  doc2/dntgap.xml (430-441)
gap> info:= OneAtlasGeneratingSetInfo( "J2", Dimension, 6,
>               Characteristic, p );
rec( charactername := "6a", constituents := [ 2 ], contents := "core",
  dim := 6, groupname := "J2", id := "a", 
  identifier := [ "J2", [ "J2G1-f4r6aB0.m1", "J2G1-f4r6aB0.m2" ], 1, 
      4 ], repname := "J2G1-f4r6aB0", repnr := 16, ring := GF(2^2), 
  size := 604800, standardization := 1, type := "matff" )
gap> gens_dim6:= AtlasGenerators( info ).generators;;
gap> b:= Basis( GF(4) );;
gap> gens_dim12:= List( gens_dim6, x -> BlownUpMatrix( b, x ) );;

##  doc2/dntgap.xml (449-456)
gap> s:= AtlasGroup( "J2", IsPermGroup, true );;
gap> chr:= CHR( s, p, 0, gens_dim12 );;
gap> SizeScreen( [ 100 ] );;
gap> SecondCohomologyDimension( chr );
0
gap> SizeScreen( [ 72 ] );;

##  doc2/dntgap.xml (469-479)
gap> mats:= List( [ 1 .. 3 ], x -> IdentityMat( d+1, GF(p) ) );;
gap> v:= mats[1][ d+1 ];;
gap> mats[1]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_dim12[1];;
gap> mats[2]{ [ 1 .. d ] }{ [ 1 .. d ] }:= gens_dim12[2];;
gap> mats[3][ d+1 ][1]:= Z(p)^0;;
gap> grp:= Group( mats );;
gap> g:= Image( IsomorphismPermGroup( grp ) );;
gap> Size( g );
2477260800

##  doc2/dntgap.xml (489-499)
gap> iso:= IsomorphismTypeInfoFiniteSimpleGroup( s );
rec( name := "HJ = J(2) = F(5-)", series := "Spor", shortname := "J2" 
 )
gap> names:= AllCharacterTableNames( Size, 2^12 * Size( s ) );;
gap> cand:= List( names, CharacterTable );;
gap> cand:= Filtered( cand,
>      t -> ForAny( ClassPositionsOfMinimalNormalSubgroups( t ),
>             n -> IsomorphismTypeInfoFiniteSimpleGroup( t / n ) = iso ) );
[ CharacterTable( "2^12:J2" ) ]

##  doc2/dntgap.xml (508-516)
gap> t:= cand[1];;
gap> rationals:= Filtered( Irr( t ), x -> IsSubset( Integers, x ) );;
gap> Collected( List( rationals, x -> x[1] ) );
[ [ 1, 1 ], [ 36, 1 ], [ 63, 1 ], [ 90, 1 ], [ 126, 1 ], [ 160, 1 ], 
  [ 175, 1 ], [ 225, 1 ], [ 288, 1 ], [ 300, 1 ], [ 336, 1 ], 
  [ 1575, 2 ], [ 2520, 4 ], [ 3150, 1 ], [ 4725, 6 ], [ 9450, 1 ], 
  [ 10080, 4 ], [ 12600, 4 ], [ 18900, 2 ] ]

##  doc2/dntgap.xml (531-544)
gap> p:= 5;;  d:= 14;;
gap> t:= CharacterTable( "J2" ) mod p;
BrauerTable( "J2", 5 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
J2mod5

       1a 2a 2b 3a 3b 4a 6a 6b 7a 8a 12a

Y.1     1  1  1  1  1  1  1  1  1  1   1
Y.2    14 -2  2  5 -1  2  1 -1  .  .  -1

##  doc2/dntgap.xml (576-613)
gap> orbits_from_tom:= function( tom, matgens, q )
>     local slp, fixed, idmat, i, rest, decomp, nonzeropos;
> 
>     slp:= StraightLineProgramsTom( tom );
>     fixed:= [];
>     idmat:= matgens[1]^0;
>     for i in [ 1 .. Length( slp ) ] do
>       if IsList( slp[i] ) then
>         # Each subgroup generator has a program of its own.
>         rest:= List( slp[i],
>                      prg -> ResultOfStraightLineProgram( prg, gens ) );
>       else
>         # The subgroup generators are computed with one common program.
>         rest:= ResultOfStraightLineProgram( slp[i], gens );
>       fi;
>       if IsEmpty( rest ) then
>         # The subgroup is trivial.
>         fixed[i]:= q^Length( idmat );
>       else
>         # Compute the intersection of fixed spaces of the transposed
>         # matrices, since we act on Irr(N) not on N.
>         fixed[i]:= q^Length( NullspaceMat( TransposedMat( Concatenation(
>                        List( rest, x -> x - idmat ) ) ) ) );
>       fi;
>     od;
> 
>     decomp:= DecomposedFixedPointVector( tom, fixed );
>     nonzeropos:= Filtered( [ 1 .. Length( decomp ) ],
>                            i -> decomp[i] <> 0 );
> 
>     return rec( fixed:= fixed,
>                 decomp:= decomp,
>                 nonzeropos:= nonzeropos,
>                 staborders:= OrdersTom( tom ){ nonzeropos },
>               );
> end;;

##  doc2/dntgap.xml (627-637)
gap> tom:= TableOfMarks( "J2" );
TableOfMarks( "J2" )
gap> StandardGeneratorsInfo( tom );
[ rec( ATLAS := true, 
      description := "|z|=10, z^5=a, |b|=3, |C(b)|=36, |ab|=7", 
      generators := "a, b", 
      script := 
        [ [ 1, 10, 5 ], [ 2, 3 ], [ [ 2, 1 ], [ "|C(",, ")|" ], 36 ], 
          [ 1, 1, 2, 1, 7 ] ], standardization := 1 ) ]

##  doc2/dntgap.xml (646-659)
gap> info:= OneAtlasGeneratingSetInfo( "J2", Dimension, d, Ring, GF(p) );
rec( charactername := "14a", constituents := [ 2 ], 
  contents := "core", dim := 14, givenRing := GF(5), 
  groupname := "J2", id := "", 
  identifier := [ "J2", [ "J2G1-f5r14B0.m1", "J2G1-f5r14B0.m2" ], 1, 
      5 ], repname := "J2G1-f5r14B0", repnr := 19, ring := GF(5), 
  size := 604800, standardization := 1, type := "matff" )
gap> gens:= AtlasGenerators( info ).generators;;
gap> map:= GroupGeneralMappingByImages( UnderlyingGroup( tom ),
>      Group( gens ), GeneratorsOfGroup( UnderlyingGroup( tom ) ), gens );;
gap> IsGroupHomomorphism( map );
true

##  doc2/dntgap.xml (667-693)
gap> orbits_from_tom( tom, gens, p );
rec( 
  decomp := [ 8600, 0, 2512, 359, 10, 0, 0, 212, 5, 0, 0, 4, 0, 240, 
      16, 10, 0, 0, 0, 0, 10, 0, 0, 0, 0, 2, 0, 0, 36, 0, 0, 0, 26, 
      0, 0, 0, 0, 0, 0, 0, 20, 0, 10, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 10, 0, 0, 5, 0, 0, 0, 26, 0, 10, 0, 0, 0, 0, 10, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 2, 0, 
      0, 0, 0, 2, 4, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 4, 0, 0, 0, 4, 0, 0, 1 ], 
  fixed := [ 6103515625, 15625, 390625, 390625, 625, 25, 3125, 3125, 
      625, 625, 625, 625, 5, 3125, 125, 625, 25, 25, 125, 5, 125, 25, 
      125, 25, 25, 25, 5, 125, 125, 125, 25, 25, 3125, 1, 1, 5, 5, 
      25, 5, 25, 125, 5, 25, 25, 25, 25, 25, 25, 5, 25, 25, 5, 25, 5, 
      5, 5, 5, 25, 25, 1, 125, 1, 5, 5, 125, 1, 25, 5, 25, 1, 5, 25, 
      5, 5, 25, 25, 5, 5, 5, 1, 5, 5, 1, 1, 1, 5, 1, 25, 25, 25, 1, 
      5, 25, 5, 5, 1, 1, 125, 5, 5, 5, 25, 5, 5, 5, 1, 1, 5, 5, 1, 5, 
      1, 5, 1, 1, 25, 5, 5, 1, 1, 1, 1, 5, 1, 1, 25, 1, 1, 5, 1, 1, 
      5, 1, 5, 1, 1, 5, 1, 5, 1, 1, 1, 5, 1, 1, 1 ], 
  nonzeropos := [ 1, 3, 4, 5, 8, 9, 12, 14, 15, 16, 21, 26, 29, 33, 
      41, 43, 44, 58, 61, 65, 67, 72, 89, 93, 98, 99, 105, 116, 126, 
      139, 143, 146 ], 
  staborders := [ 1, 2, 3, 3, 4, 4, 5, 6, 6, 6, 8, 9, 10, 12, 12, 12, 
      14, 20, 24, 24, 24, 30, 48, 50, 60, 60, 72, 120, 192, 600, 
      1920, 604800 ] )

##  doc2/dntgap.xml (715-742)
gap> p:= 2;;  d:= 28;;
gap> t:= CharacterTable( "J2" ) mod p;
BrauerTable( "J2", 2 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
J2mod2

       1a 3a 3b 5a 5b  5c  5d 7a 15a 15b

Y.1     1  1  1  1  1   1   1  1   1   1
Y.2     6 -3  .  A *A   C  *C -1   D  *D
Y.3     6 -3  . *A  A  *C   C -1  *D   D
Y.4    14  5 -1  B *B  -C -*C  .   .   .
Y.5    14  5 -1 *B  B -*C  -C  .   .   .

A = -2*E(5)-2*E(5)^4
  = 1-Sqrt(5) = 1-r5
B = -3*E(5)-3*E(5)^4
  = (3-3*Sqrt(5))/2 = -3b5
C = E(5)+2*E(5)^2+2*E(5)^3+E(5)^4
  = (-3-Sqrt(5))/2 = -2-b5
D = E(5)+E(5)^4
  = (-1+Sqrt(5))/2 = b5
gap> List( irr, x -> SizeOfFieldOfDefinition( x, p ) );
[ 2, 4, 4, 4, 4 ]

##  doc2/dntgap.xml (750-780)
gap> tom:= TableOfMarks( "J2" );;
gap> info:= OneAtlasGeneratingSetInfo( "J2", Dimension, 14, Ring, GF(4) );;
gap> gens:= List( AtlasGenerators( info ).generators,
>                 x -> BlownUpMat( Basis(GF(4)), x ) );;
gap> orbits_from_tom( tom, gens, p );
rec( 
  decomp := [ 235, 33, 282, 38, 0, 0, 6, 31, 36, 0, 0, 0, 3, 66, 9, 
      0, 0, 0, 0, 0, 0, 2, 18, 0, 0, 1, 0, 0, 15, 0, 0, 0, 6, 0, 0, 
      0, 0, 0, 0, 0, 12, 0, 0, 5, 0, 1, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 3, 1, 3, 0, 9, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
      3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 3, 0, 
      0, 0, 3, 0, 0, 1 ], 
  fixed := [ 268435456, 65536, 65536, 65536, 256, 1024, 4096, 1024, 
      1024, 256, 256, 256, 64, 1024, 64, 256, 16, 16, 64, 64, 64, 
      256, 256, 64, 16, 16, 64, 64, 64, 64, 16, 16, 1024, 4, 4, 4, 4, 
      16, 16, 16, 64, 16, 16, 16, 16, 64, 16, 16, 16, 64, 16, 16, 16, 
      16, 4, 16, 16, 16, 16, 1, 64, 4, 16, 4, 64, 4, 16, 4, 16, 1, 4, 
      16, 4, 4, 16, 16, 4, 4, 16, 1, 4, 16, 1, 1, 1, 16, 4, 16, 16, 
      16, 1, 4, 16, 4, 4, 1, 4, 64, 4, 4, 4, 16, 4, 4, 4, 1, 1, 4, 
      16, 1, 4, 1, 4, 1, 4, 16, 4, 4, 1, 1, 1, 1, 4, 1, 1, 16, 1, 1, 
      4, 1, 4, 4, 1, 4, 1, 1, 4, 1, 4, 1, 1, 1, 4, 1, 1, 1 ], 
  nonzeropos := [ 1, 2, 3, 4, 7, 8, 9, 13, 14, 15, 22, 23, 26, 29, 
      33, 41, 44, 46, 50, 61, 62, 63, 65, 72, 82, 93, 99, 105, 109, 
      116, 126, 131, 139, 143, 146 ], 
  staborders := [ 1, 2, 2, 3, 4, 4, 4, 6, 6, 6, 8, 8, 9, 10, 12, 12, 
      14, 16, 16, 24, 24, 24, 24, 30, 40, 50, 60, 72, 96, 120, 192, 
      240, 600, 1920, 604800 ] )

##  doc2/dntgap.xml (801-830)
gap> p:= 2;;  d:= 26;;
gap> t:= CharacterTable( "3D4(2)" ) mod p;
BrauerTable( "3D4(2)", 2 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
3D4(2)mod2

       1a 3a 3b 7a 7b 7c 7d 9a 9b 9c 13a 13b 13c 21a 21b 21c

Y.1     1  1  1  1  1  1  1  1  1  1   1   1   1   1   1   1
Y.2     8  2 -1  A  C  B  1  D  F  E   G   I   H   J   L   K
Y.3     8  2 -1  B  A  C  1  E  D  F   H   G   I   K   J   L
Y.4     8  2 -1  C  B  A  1  F  E  D   I   H   G   L   K   J
Y.5    26 -1 -1  5  5  5 -2  2  2  2   .   .   .  -1  -1  -1

A = 3*E(7)^2+E(7)^3+E(7)^4+3*E(7)^5
B = 3*E(7)+E(7)^2+E(7)^5+3*E(7)^6
C = E(7)+3*E(7)^3+3*E(7)^4+E(7)^6
D = -E(9)^2+E(9)^3-2*E(9)^4-2*E(9)^5+E(9)^6-E(9)^7
E = -E(9)^2+E(9)^3+E(9)^4+E(9)^5+E(9)^6-E(9)^7
F = 2*E(9)^2+E(9)^3+E(9)^4+E(9)^5+E(9)^6+2*E(9)^7
G = E(13)+E(13)^2+E(13)^3+E(13)^5+E(13)^8+E(13)^10+E(13)^11+E(13)^12
H = E(13)+E(13)^4+E(13)^5+E(13)^6+E(13)^7+E(13)^8+E(13)^9+E(13)^12
I = E(13)^2+E(13)^3+E(13)^4+E(13)^6+E(13)^7+E(13)^9+E(13)^10+E(13)^11
J = E(7)^3+E(7)^4
K = E(7)^2+E(7)^5
L = E(7)+E(7)^6

##  doc2/dntgap.xml (838-853)
gap> tom:= TableOfMarks( "3D4(2)" );
TableOfMarks( "3D4(2)" )
gap> StandardGeneratorsInfo( tom );
[ rec( ATLAS := true, 
      description := "|z|=8, z^4=a, |b|=9, |ab|=13, |abb|=8", 
      generators := "a, b", 
      script := [ [ 1, 8, 4 ], [ 2, 9 ], [ 1, 1, 2, 1, 13 ], 
          [ 1, 1, 2, 1, 2, 1, 8 ] ], standardization := 1 ) ]
gap> info:= OneAtlasGeneratingSetInfo( "3D4(2)", Dimension, 26, Ring, GF(2) );;
gap> gens:= AtlasGenerators( info ).generators;;
gap> map:= GroupGeneralMappingByImages( UnderlyingGroup( tom ),
>      Group( gens ), GeneratorsOfGroup( UnderlyingGroup( tom ) ), gens );;
gap> IsGroupHomomorphism( map );
true

##  doc2/dntgap.xml (861-867)
gap> orbsinfo:= orbits_from_tom( tom, gens, p );;
gap> orbsinfo.fixed[1];
67108864
gap> orbsinfo.decomp[1];
0

##  doc2/dntgap.xml (878-890)
gap> orbsinfo.staborders;
[ 16, 16, 18, 42, 48, 52, 64, 72, 392, 1008, 1536, 3024, 3072, 3584, 
  258048, 211341312 ]
gap> orbsinfo.nonzeropos[3];
446
gap> orbsinfo.decomp[446];
1
gap> u:= RepresentativeTom( tom, 446 );
<permutation group of size 18 with 2 generators>
gap> IsDihedralGroup( u );
true

##  doc2/dntgap.xml (904-912)
gap> cand:= Filtered( AllSmallGroups( 36 ),
>             x -> Size( Centre( x ) ) = 2 and
>                  IsDihedralGroup( x / Centre( x ) ) );
[ <pc group of size 36 with 4 generators>, 
  <pc group of size 36 with 4 generators> ]
gap> List( cand, StructureDescription );
[ "C9 : C4", "D36" ]

##  doc2/dntgap.xml (929-950)
gap> Display( CharacterTable( "Dihedral", 18 ) );
Dihedral(18)

     2  1  .  .  .  .  1
     3  2  2  2  2  2  .

       1a 9a 9b 3a 9c 2a
    2P 1a 9b 9c 3a 9a 1a
    3P 1a 3a 3a 1a 3a 2a

X.1     1  1  1  1  1  1
X.2     1  1  1  1  1 -1
X.3     2  A  B -1  C  .
X.4     2  B  C -1  A  .
X.5     2 -1 -1  2 -1  .
X.6     2  C  A -1  B  .

A = -E(9)^2-E(9)^4-E(9)^5-E(9)^7
B = E(9)^2+E(9)^7
C = E(9)^4+E(9)^5

##  doc2/dntgap.xml (970-988)
gap> p:= 3;;  d:= 25;;
gap> t:= CharacterTable( "3D4(2)" ) mod p;
BrauerTable( "3D4(2)", 3 )
gap> irr:= Filtered( Irr( t ), x -> x[1] <= d );;
gap> Display( t, rec( chars:= irr, powermap:= false,
>                     centralizers:= false ) );
3D4(2)mod3

       1a 2a 2b 4a 4b 4c 7a 7b 7c 7d 8a 8b 13a 13b 13c 14a 14b 14c 28a

Y.1     1  1  1  1  1  1  1  1  1  1  1  1   1   1   1   1   1   1   1
Y.2    25 -7  1  5 -3  1  4  4  4 -3 -1 -1  -1  -1  -1   .   .   .  -2

       28b 28c

Y.1      1   1
Y.2     -2  -2

##  doc2/dntgap.xml (996-1005)
gap> tom:= TableOfMarks( "3D4(2)" );;
gap> info:= OneAtlasGeneratingSetInfo( "3D4(2)", Dimension, d, Ring, GF(p) );;
gap> gens:= AtlasGenerators( info ).generators;;
gap> orbsinfo:= orbits_from_tom( tom, gens, p );;
gap> orbsinfo.fixed[1];
847288609443
gap> orbsinfo.decomp[1];
3551

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "dntgap.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
