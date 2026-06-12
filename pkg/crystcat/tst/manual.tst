gap> START_TEST( "Crystcat: manual.tst" );

gap> SetAssertionLevel(1);

gap> n := NrCrystalFamilies( 4 );
23

gap> DisplayCrystalFamily( 4, 17 );
#I Family XVII: cubic orthogonal; 2 free parameters;
#I  Q-decomposition pattern 1+3; R-decomposition pattern 1+3;
#I  2 crystal systems; 6 Bravais flocks

gap> DisplayCrystalFamily( 4, 18 );
#I Family XVIII: octagonal; 2 free parameters;
#I  Q-irreducible; R-decomposition pattern 2+2;
#I  1 crystal system; 1 Bravais flock

gap> DisplayCrystalFamily( 4, 21 );
#I Family XXI: di-isohexagonal orthogonal; 1 free parameter;
#I  R-irreducible; 2 crystal systems; 2 Bravais flocks

gap> n := NrCrystalSystems( 2 );
4

gap> for sys in [ 1 .. 4 ] do  DisplayCrystalSystem( 2, sys );  od;
#I  Crystal system 1: 2 Q-classes; holohedry (2,1,2)
#I  Crystal system 2: 2 Q-classes; holohedry (2,2,2)
#I  Crystal system 3: 2 Q-classes; holohedry (2,3,2)
#I  Crystal system 4: 4 Q-classes; holohedry (2,4,4)

gap> DisplayQClass( "p2" );
#I   Q-class H (2,1,2): size 2; isomorphism type 2.1 = C2;
#I    Q-constituents 2*(2,1,2); cc; 1 Z-class; 1 space group

gap> DisplayQClass( "R-3" );
#I   Q-class (3,5,2): size 6; isomorphism type 6.1 = C6;
#I    Q-constituents (3,1,2)+(3,4,3); ncc; 2 Z-classes; 2 space grps

gap> DisplayQClass( 3, 195 );
#I   Q-class (3,7,1): size 12; isomorphism type 12.5 = A4;
#I    C-irreducible; 3 Z-classes; 5 space grps

gap> DisplayQClass( 4, 27, 4 );
#I   Q-class H (4,27,4): size 20; isomorphism type 20.3 = D10xC2;
#I    Q-irreducible; 1 Z-class; 1 space group

gap> DisplayQClass( 4, 29, 1 );
#I  *Q-class (4,29,1): size 18; isomorphism type 18.3 = D6xC3;
#I    R-irreducible; 3 Z-classes; 5 space grps

gap> F := FpGroupQClass( 4, 20, 3 );
FpGroupQClass( 4, 20, 3 )

gap> GeneratorsOfGroup( F );
[ f1, f2 ]

gap> RelatorsOfFpGroup( F );
[ f1^2*f2^-3, f2^6, f2^-1*f1^-1*f2*f1*f2^-4 ]

gap> Size( F );
12

gap> CrystCatRecord( F ).parameters;
[ 4, 20, 3 ]

gap> P := PcGroupQClass( 4, 31, 3 );
#I  Warning: a non-solvable group can't be represented as a pc group
fail

gap> P := PcGroupQClass( 4, 20, 3 );
#I  Warning: the presentation has been extended to get a prime order pcgs
PcGroupQClass( 4, 20, 3 )

gap> GeneratorsOfGroup( P );
[ f1, f2, f3 ]

gap> Size( P );
12

gap> CrystCatRecord( P ).parameters;
[ 4, 20, 3 ]

gap> T := CharTableQClass( 4, 20, 3 );;

gap> Display( T );
CharTableQClass( 4, 20, 3 )

     2  2  2  1  1  2  2
     3  1  .  1  1  .  1

       1a 4a 6a 3a 4b 2a
    2P 1a 2a 3a 3a 2a 1a
    3P 1a 4b 2a 1a 4a 2a
    5P 1a 4a 6a 3a 4b 2a

X.1     1  1  1  1  1  1
X.2     1 -1  1  1 -1  1
X.3     1  A -1  1 -A -1
X.4     1 -A -1  1  A -1
X.5     2  .  1 -1  . -2
X.6     2  . -1 -1  .  2

A = -E(4)
  = -Sqrt(-1) = -i

gap> DisplayZClass( 2, 3 );
#I    Z-class (2,2,1,1) = Z(pm): Bravais type II/I; fully Z-reducible;
#I     2 space groups; cohomology group size 2

gap> DisplayZClass( "F-43m" );
#I    Z-class (3,7,4,2) = Z(F-43m): Bravais type VI/II; Z-irreducible;
#I     2 space groups; cohomology group size 2

gap> DisplayZClass( 4, 2, 3, 2 );
#I    Z-class B (4,2,3,2): Bravais type II/II; Z-decomposable;
#I     2 space groups; cohomology group size 4

gap> DisplayZClass( 4, 21, 3, 1 );
#I   *Z-class (4,21,3,1): Bravais type XVI/I; Z-reducible;
#I     1 space group; cohomology group size 1

gap> M := MatGroupZClass( 4, 20, 3, 1 );
MatGroupZClass( 4, 20, 3, 1 )

gap> for g in GeneratorsOfGroup( M ) do
>  Print( "\n" ); PrintArray( g ); od; Print( "\n" );

[ [   0,   1,   0,   0 ],
  [  -1,   0,   0,   0 ],
  [   0,   0,  -1,  -1 ],
  [   0,   0,   0,   1 ] ]

[ [  -1,   0,   0,   0 ],
  [   0,  -1,   0,   0 ],
  [   0,   0,  -1,  -1 ],
  [   0,   0,   1,   0 ] ]

gap> Size( M );
12

gap> CrystCatRecord( M ).parameters;
[ 4, 20, 3, 1 ]

gap> N := NormalizerZClass( 4, 20, 3, 1 );
NormalizerZClass( 4, 20, 3, 1 )

gap> for g in GeneratorsOfGroup( N ) do
>  Print( "\n" ); PrintArray( g ); od; Print( "\n" );

[ [   1,   0,   0,   0 ],
  [   0,   1,   0,   0 ],
  [   0,   0,   1,   0 ],
  [   0,   0,  -1,  -1 ] ]

[ [   1,   0,   0,   0 ],
  [   0,  -1,   0,   0 ],
  [   0,   0,  -1,  -1 ],
  [   0,   0,   1,   0 ] ]

[ [   0,   1,   0,   0 ],
  [  -1,   0,   0,   0 ],
  [   0,   0,   1,   0 ],
  [   0,   0,   0,   1 ] ]

[ [  -1,   0,   0,   0 ],
  [   0,  -1,   0,   0 ],
  [   0,   0,  -1,   0 ],
  [   0,   0,   0,  -1 ] ]

gap> Size( N );
96

gap> CrystCatRecord( N ).parameters;
[ 4, 20, 22, 1 ]

gap> CrystCatRecord( N ).conjugator = One( N );
true

gap> L := NormalizerZClass( 3, 42 );
NormalizerZClass( 3, 3, 2, 4 )

gap> Size( L );
16

gap> CrystCatRecord( L ).parameters;
[ 3, 4, 7, 2 ]

gap> CrystCatRecord( L ).conjugator;
[ [ 0, 0, -1 ], [ 1, 0, 0 ], [ 0, -1, -1 ] ]

gap> M := NormalizerZClass( "C2/m" );
<matrix group of size infinity with 5 generators>

gap> Size( M );
infinity

gap> HasCrystCatRecord( M );
false

gap> NrDadeGroups( 4 );
9

gap> D := DadeGroup( 4, 7 );
MatGroupZClass( 4, 31, 7, 2 )

gap> dadeNums := DadeGroupNumbersZClass( 4, 4, 1, 2 );
[ 1, 5, 8 ]

gap> for d in dadeNums do
>     D := DadeGroup( 4, d );
>     Print( D, " of size ", Size( D ), "\n" );
> od;
MatGroupZClass( 4, 20, 22, 1 ) of size 96
MatGroupZClass( 4, 30, 13, 1 ) of size 288
MatGroupZClass( 4, 32, 21, 1 ) of size 384

gap> DadeGroupNumbersZClass( 2, 2, 1, 2 );
[ 1, 2 ]

gap> ZClassRepsDadeGroup( 2, 2, 1, 2, 1 );
[ MatGroupZClass( 2, 2, 1, 2 )^[ [ 0, 1 ], [ -1, 0 ] ] ]

gap> ZClassRepsDadeGroup( 2, 2, 1, 2, 2 );
[ MatGroupZClass( 2, 2, 1, 2 )^[ [ 1, -1 ], [ 0, -1 ] ], 
  MatGroupZClass( 2, 2, 1, 2 )^[ [ 1, 0 ], [ -1, 1 ] ] ]

gap> R := last[2];;

gap> CrystCatRecord( R ).parameters;
[ 2, 2, 1, 2 ]

gap> CrystCatRecord( R ).conjugator;
[ [ 1, 0 ], [ -1, 1 ] ]

gap> N := NrSpaceGroupTypesZClass( 4, 4, 1, 1 );
13

gap> DisplaySpaceGroupType( 2, 17 );
#I     Space-group type (2,4,4,1,1); IT(17) = p6mm; orbit size 1

gap> DisplaySpaceGroupType( "Pm-3" );
#I     Space-group type (3,7,2,1,1); IT(200) = Pm-3; orbit size 1

gap> DisplaySpaceGroupType( 4, 32, 10, 2, 4 );
#I    *Space-group type (4,32,10,2,4); orbit size 18

gap> DisplaySpaceGroupType( 3, 6, 1, 1, 4 );
#I    *Space-group type (3,6,1,1,4); IT(169) = P61, IT(170) = P65;
#I      orbit size 2; fp-free

gap> DisplaySpaceGroupGenerators( "P61" );
#I  Non-translation generators of SpaceGroupOnLeftBBNWZ( 3, 6, 1, 1, 4 )

[ [   -1,    0,    0,    0 ],
  [    0,   -1,    0,    0 ],
  [    0,    0,    1,  1/2 ],
  [    0,    0,    0,    1 ] ]

[ [    0,   -1,    0,    0 ],
  [    1,   -1,    0,    0 ],
  [    0,    0,    1,  1/3 ],
  [    0,    0,    0,    1 ] ]
gap> S := SpaceGroupOnLeftBBNWZ( "P61" );
SpaceGroupOnLeftBBNWZ( 3, 6, 1, 1, 4 )

gap> for s in GeneratorsOfGroup( S ) do
>  Print( "\n" ); PrintArray( s ); od; Print( "\n" );

[ [   -1,    0,    0,    0 ],
  [    0,   -1,    0,    0 ],
  [    0,    0,    1,  1/2 ],
  [    0,    0,    0,    1 ] ]

[ [    0,   -1,    0,    0 ],
  [    1,   -1,    0,    0 ],
  [    0,    0,    1,  1/3 ],
  [    0,    0,    0,    1 ] ]

[ [  1,  0,  0,  1 ],
  [  0,  1,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  0,  0,  0,  1 ] ]

[ [  1,  0,  0,  0 ],
  [  0,  1,  0,  1 ],
  [  0,  0,  1,  0 ],
  [  0,  0,  0,  1 ] ]

[ [  1,  0,  0,  0 ],
  [  0,  1,  0,  0 ],
  [  0,  0,  1,  1 ],
  [  0,  0,  0,  1 ] ]

gap> CrystCatRecord( S ).parameters;
[ 3, 6, 1, 1, 4 ]

gap> T := SpaceGroupOnRightBBNWZ( S );
SpaceGroupOnRightBBNWZ( 3, 6, 1, 1, 4 )

gap> for m in GeneratorsOfGroup( T ) do
>  Print( "\n" ); PrintArray( m ); od; Print( "\n" );

[ [   -1,    0,    0,    0 ],
  [    0,   -1,    0,    0 ],
  [    0,    0,    1,    0 ],
  [    0,    0,  1/2,    1 ] ]

[ [    0,    1,    0,    0 ],
  [   -1,   -1,    0,    0 ],
  [    0,    0,    1,    0 ],
  [    0,    0,  1/3,    1 ] ]

[ [  1,  0,  0,  0 ],
  [  0,  1,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  1,  0,  0,  1 ] ]

[ [  1,  0,  0,  0 ],
  [  0,  1,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  0,  1,  0,  1 ] ]

[ [  1,  0,  0,  0 ],
  [  0,  1,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  0,  0,  1,  1 ] ]

gap> G := FpGroupSpaceGroupBBNWZ( S );    
FpGroupSpaceGroupOnLeftBBNWZ( 3, 6, 1, 1, 4 )

gap> for rel in RelatorsOfFpGroup( G ) do Print( rel, "\n" ); od;
g1^2*g5^-1
g2^3*g5^-1
g2^-1*g1^-1*g2*g1
g3^-1*g1^-1*g3*g1*g3^2
g3^-1*g2^-1*g3*g2*g4*g3^2
g4^-1*g1^-1*g4*g1*g4^2
g4^-1*g2^-1*g4*g2*g4*g3^-1
g4^-1*g3^-1*g4*g3
g5^-1*g1^-1*g5*g1
g5^-1*g2^-1*g5*g2
g5^-1*g3^-1*g5*g3
g5^-1*g4^-1*g5*g4

gap> # Verify that the matrix generators of S satisfy the relators of G.
gap> ForAll( RelatorsOfFpGroup( G ), rel -> One(S) =
>  MappedWord( rel, FreeGeneratorsOfFpGroup(G), GeneratorsOfGroup(S) ) );
true

gap> STOP_TEST( "manual.tst", 10000 );
