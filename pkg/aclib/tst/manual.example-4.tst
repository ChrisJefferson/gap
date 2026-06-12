gap> START_TEST("");
gap> G:=AlmostCrystallographicPcpDim4("013",[8,0,1,0,1,0]);
Pcp-group with orders [ 2, 2, 0, 0, 0, 0 ]
gap> IsTorsionFree(G);
true
gap> G:=AlmostCrystallographicPcpDim4("013",[9,0,1,0,1,0]);
Pcp-group with orders [ 2, 2, 0, 0, 0, 0 ]
gap> IsTorsionFree(G);
false
gap> G:=AlmostCrystallographicPcpDim4("013",[10,0,2,0,1,0]);
Pcp-group with orders [ 2, 2, 0, 0, 0, 0 ]
gap> IsTorsionFree(G);
false
gap> G:=AlmostCrystallographicPcpDim4("013",[10,0,3,0,1,9]);
Pcp-group with orders [ 2, 2, 0, 0, 0, 0 ]
gap> IsTorsionFree(G);
true
gap> G:=AlmostCrystallographicPcpGroup(4, "085", false);
Pcp-group with orders [ 2, 4, 0, 0, 0, 0 ]
gap> GroupGeneratedByd:=Subgroup(G, [G.6] );
Pcp-group with orders [ 0 ]
gap> Q:=G/GroupGeneratedByd;
Pcp-group with orders [ 2, 4, 0, 0, 0 ]
gap> action:=List( Pcp(Q), x -> [[1]] );
[ [ [ 1 ] ], [ [ 1 ] ], [ [ 1 ] ], [ [ 1 ] ], [ [ 1 ] ] ]
gap> C:=CRRecordByMats( Q, action);;
gap> TwoCohomologyCR( C ).factor.rels;
[ 2, 2, 4, 0 ]
gap> G := AlmostCrystallographicPcpGroup(3, 17, [2,0,0,0] );
Pcp-group with orders [ 2, 6, 0, 0, 0 ]
gap> projection := NaturalHomomorphismOnHolonomyGroup( G );
[ g1, g2, g3, g4, g5 ] -> [ g1, g2, id, id, id ]
gap> F := HolonomyGroup( G );
Pcp-group with orders [ 2, 6 ]
gap> IPprimeD6 := Subgroup( F , [F.2^2] );
Pcp-group with orders [ 3 ]
gap> K := PreImage( projection, IPprimeD6 );
Pcp-group with orders [ 3, 0, 0, 0 ]
gap> PrintPcpPresentation( K );
g1^3 = id 
g2 ^ g1 = g2^-1 * g3^-1
g3 ^ g1 = g2 * g4^2
g3 ^ g2 = g3 * g4^2
g3 ^ g2^-1 = g3 * g4^-2
gap> Gamma3K := CommutatorSubgroup( K, CommutatorSubgroup( K, K ));
Pcp-group with orders [ 0, 0, 0 ]
gap> quotient := G/Gamma3K;
Pcp-group with orders [ 2, 6, 3, 3, 2 ]
gap> S := SylowSubgroup( quotient, 3);
Pcp-group with orders [ 3, 3, 3 ]
gap> N := NormalClosure( quotient, S);
Pcp-group with orders [ 3, 3, 3 ]
gap> localization := quotient/N;
Pcp-group with orders [ 2, 2, 2 ]
gap> PrintPcpPresentation( localization );
g1^2 = id 
g2^2 = id 
g3^2 = id 
gap> G := AlmostCrystallographicPcpGroup(3, 17, [2,0,0,1]);;
gap> projection := NaturalHomomorphismOnHolonomyGroup( G );;
gap> F := HolonomyGroup( G );;
gap> IPprimeD6 := Subgroup( F , [F.2^2] );;
gap> K := PreImage( projection, IPprimeD6 );;
gap> Gamma3K := CommutatorSubgroup( K, CommutatorSubgroup( K, K ));;
gap> quotient := G/Gamma3K;;
gap> S := SylowSubgroup( quotient, 3);;
gap> N := NormalClosure( quotient, S);;
gap> localization := quotient/N;
Pcp-group with orders [ 2, 2, 2 ]
gap> PrintPcpPresentation( localization );
g1^2 = id 
g2^2 = g3
g3^2 = id 
g2 ^ g1 = g2 * g3

#
gap> STOP_TEST( "" ,1);
