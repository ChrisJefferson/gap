gap> START_TEST("");
gap> G := AlmostCrystallographicGroup( 4, 50, [ 1, -4, 1, 2 ] );
<matrix group of size infinity with 5 generators>
gap> DimensionOfMatrixGroup( G );
5
gap> FieldOfMatrixGroup( G );
Rationals
gap> GeneratorsOfGroup( G );
[ [ [ 1, 0, -1/2, 0, 0 ], [ 0, 1, 0, 0, 1 ], [ 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 1/2, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 0, 1, 0, 1 ], 
      [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 1, 1 ], [ 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 1 ], [ 0, 1, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ], 
  [ [ 1, -4, 1, 0, 1/2 ], [ 0, 0, -1, 0, 0 ], [ 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 1/4 ], [ 0, 0, 0, 0, 1 ] ] ]
gap> G.1;
[ [ 1, 0, -1/2, 0, 0 ], [ 0, 1, 0, 0, 1 ], [ 0, 0, 1, 0, 0 ], 
  [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ]
gap> ACDim4Types[50];
"076"
gap> ACDim4Param[50];
4
gap> G := AlmostCrystallographicPcpGroup( 4, 50, [ 1, -4, 1, 2 ] );
Pcp-group with orders [ 4, 0, 0, 0, 0 ]
gap> Cgs(G);
[ g1, g2, g3, g4, g5 ]
gap> F := FittingSubgroup( G );
Pcp-group with orders [ 0, 0, 0, 0 ]
gap> Centre(F);
Pcp-group with orders [ 0, 0 ]
gap> LowerCentralSeries(F);
[ Pcp-group with orders [ 0, 0, 0, 0 ], Pcp-group with orders [ 0 ], 
  Pcp-group with orders [  ] ]
gap> UpperCentralSeries(F);
[ Pcp-group with orders [ 0, 0, 0, 0 ], Pcp-group with orders [ 0, 0 ], 
  Pcp-group with orders [  ] ]
gap> MinimalGeneratingSet(F);
[ g2, g3, g4 ]
gap> H := HolonomyGroup( G );
Pcp-group with orders [ 4 ]
gap> hom := NaturalHomomorphismOnHolonomyGroup( G );
[ g1, g2, g3, g4, g5 ] -> [ g1, id, id, id, id ]
gap> U := Subgroup( H, [Pcp(H)[1]^2] );
Pcp-group with orders [ 2 ]
gap> PreImage( hom, U );
Pcp-group with orders [ 2, 0, 0, 0, 0 ]
gap> Reset(GlobalMersenneTwister,1);;
gap> G := AlmostCrystallographicGroup( 4, 70, false );
<matrix group of size infinity with 5 generators>
gap> IsAlmostCrystallographic(G);
true
gap> AlmostCrystallographicInfo(G);
rec( dim := 4, param := [ -3, 2, -1, -2, -1 ], type := 70 )
gap> G := AlmostCrystallographicPcpGroup( 4, 70, false );
Pcp-group with orders [ 6, 0, 0, 0, 0 ]
gap> IsAlmostCrystallographic(G);
true
gap> AlmostCrystallographicInfo(G);
rec( dim := 4, param := [ -1, 1, -4, 1, 0 ], type := 70 )
gap> ACDim3Funcs[15];
function( k1, k2, k3, k4 ) ... end
gap> ACDim3Funcs[15](1,1,1,1);
<matrix group with 5 generators>
gap> ACPcpDim3Funcs[1](1);
Pcp-group with orders [ 0, 0, 0 ]
gap> G:=AlmostCrystallographicDim4("013",[8,0,1,0,1,0]);
<matrix group of size infinity with 6 generators>
gap> G.5;
[ [ 1, 4, 0, 0, 1/2 ], [ 0, -1, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
  [ 0, 0, 0, -1, 1/2 ], [ 0, 0, 0, 0, 1 ] ]
gap> G.6;
[ [ 1, 8, 0, 0, 1/2 ], [ 0, -1, 0, 0, 0 ], [ 0, 0, -1, 0, 0 ], 
  [ 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 1 ] ]

#
gap> STOP_TEST( "" ,1);
