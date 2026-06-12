gap> G := IrreducibleSolubleMatrixGroup(4, 2, 2, 3);
<matrix group of size 10 with 2 generators>
gap> IsIrreducibleMatrixGroup(G);
true
gap> IsIrreducibleMatrixGroup(G, GF(2));
true
gap> IsIrreducibleMatrixGroup(G, GF(4));
false
gap> G := IrreducibleSolubleMatrixGroup(4, 2, 2, 3);
<matrix group of size 10 with 2 generators>
gap> IsAbsolutelyIrreducibleMatrixGroup(G);
false
gap> G := IrreducibleSolubleMatrixGroup(2,3,1,4);;
gap> MinimalBlockDimension(G, GF(3));
2
gap> MinimalBlockDimension(G, GF(9));
1
gap> G := IrreducibleSolubleMatrixGroup(2,2,1,1);;
gap> IsPrimitiveMatrixGroup(G, GF(2));
true
gap> IsIrreducibleMatrixGroup(G, GF(4));
true
gap> IsPrimitiveMatrixGroup(G, GF(4));
false
gap> G := IrreducibleSolubleMatrixGroup(6, 2, 1, 9);
<matrix group of size 54 with 4 generators>
gap> impr := ImprimitivitySystems(G, GF(2));;
gap> List(ImprimitivitySystems(G, GF(2)), r -> Length(r.bases));
[ 3, 3, 1 ]
gap> List(ImprimitivitySystems(G, GF(4)),
>        r -> Action(G, r.bases, OnSubspacesByCanonicalBasis));
[ Group([ (), (1,2)(3,6)(4,5), (1,3,4)(2,5,6), (1,4,3)(2,6,5) ]),
  Group([ (1,2,4)(3,5,6), (1,3)(2,5)(4,6), (), () ]),
  Group([ (1,2,4)(3,5,6), (1,3)(2,5)(4,6), (1,2,4)(3,6,5), (1,4,2)(3,5,6) ]),
  Group([ (1,2,4)(3,5,6), (1,3)(2,5)(4,6), (1,4,2)(3,5,6), (1,2,4)(3,6,5) ]),
  Group([ (), (1,2), (), () ]), Group([ (1,2,3), (), (), () ]),
  Group([ (), (2,3), (1,2,3), (1,3,2) ]),
  Group([ (), (2,3), (1,2,3), (1,3,2) ]),
  Group([ (), (2,3), (1,2,3), (1,3,2) ]), Group(()) ]
gap> repeat
>        G := IrreducibleSolubleMatrixGroup(8, 2, 2, 7)^RandomInvertibleMat(8, GF(8));
>    until FieldOfMatrixGroup(G) = GF(8);
gap> TraceField(G);
GF(2)
gap> repeat
>       G := IrreducibleSolubleMatrixGroup(8, 2, 2, 7) ^
>                RandomInvertibleMat(8, GF(8));
>    until FieldOfMatrixGroup(G) = GF(8);
gap> FieldOfMatrixGroup(G^ConjugatingMatTraceField(G));
GF(2)
