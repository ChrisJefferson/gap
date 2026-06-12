gap> PrimitivePcGroupIrreducibleMatrixGroup(
>       IrreducibleSolubleMatrixGroup(4,2,2,3));
<pc group of size 160 with 6 generators>
gap> PrimitivePermGroupIrreducibleMatrixGroup(
>       IrreducibleSolubleMatrixGroup(4,2,2,3));
<permutation group of size 160 with 6 generators>
gap> IrreducibleMatrixGroupPrimitiveSolubleGroup(SymmetricGroup(4));
Group([ <an immutable 2x2 matrix over GF2>,
  <an immutable 2x2 matrix over GF2> ])
gap> AllPrimitivePcGroups(Degree, [1..255], Order, [168]);
[ <pc group of size 168 with 5 generators> ]
gap> OnePrimitivePcGroup(Degree, [256], Order, [256*255]);
<pc group of size 65280 with 11 generators>
gap> AllPrimitiveSolublePermGroups(Degree, [1..100], Order, [72]);
[ Group([ (1,4,7)(2,5,8)(3,6,9), (1,2,3)(4,5,6)(7,8,9), (2,4)(3,7)(6,8),
      (2,3)(5,6)(8,9), (4,7)(5,8)(6,9) ]),
  Group([ (1,4,7)(2,5,8)(3,6,9), (1,2,3)(4,5,6)(7,8,9), (2,5,3,9)(4,8,7,6),
      (2,7,3,4)(5,8,9,6), (2,3)(4,7)(5,9)(6,8) ]),
  Group([ (1,4,7)(2,5,8)(3,6,9), (1,2,3)(4,5,6)(7,8,9), (2,5,6,7,3,9,8,4) ]) ]
gap> List(last, IdGroup);
[ [ 72, 40 ], [ 72, 41 ], [ 72, 39 ] ]
gap> OnePrimitiveSolublePermGroup(Degree, [1..100], Size, [123321]);
fail
gap> G := SmallGroup(432, 734);
<pc group of size 432 with 7 generators>
gap> IdPrimitiveSolubleGroup(G);
[ 2, 3, 1, 2 ]
gap> G := AlternatingGroup(4);
Alt( [ 1 .. 4 ] )
gap> IdPrimitiveSolubleGroup(G);
[ 2, 2, 2, 1 ]
