gap> IndicesIrreducibleSolubleMatrixGroups(6, 2, 2);
[ 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12 ]
gap> inds := IndicesMaximalAbsolutelyIrreducibleSolubleMatrixGroups(2,3);
[ 2 ]
gap> IrreducibleSolubleMatrixGroup(2,3,1,2) = GL(2,3); # it is the whole GL
true
# get just those groups with trace field GF(9)
gap> l := AllIrreducibleSolubleMatrixGroups(Degree, 1, Field, GF(9));;
gap> List(l, Order);
[ 4, 8 ]

# get all irreducible subgroups
gap> l := AllIrreducibleSolubleMatrixGroups(Degree, 1, Field, Subfields(GF(9)));;
gap> List(l, Order);
[ 1, 2, 4, 8 ]

# get only maximal absolutely irreducible ones
gap> l := AllIrreducibleSolubleMatrixGroups(Degree, 4, Field, GF(3),
>             IsMaximalAbsolutelyIrreducibleSolubleMatrixGroup, true);;
gap> SortedList(List(l, Order));
[ 320, 640, 2304, 4608 ]

# get only absolutely irreducible groups
gap> l := AllIrreducibleSolubleMatrixGroups(Degree, 4, Field, GF(3),
> IsAbsolutelyIrreducibleMatrixGroup, true);;
gap> Collected(List(l, Order));
[ [ 20, 1 ], [ 32, 7 ], [ 40, 2 ], [ 64, 10 ], [ 80, 2 ], [ 96, 6 ],
  [ 128, 9 ], [ 160, 3 ], [ 192, 9 ], [ 256, 6 ], [ 288, 1 ], [ 320, 2 ],
  [ 384, 4 ], [ 512, 1 ], [ 576, 3 ], [ 640, 1 ], [ 768, 1 ], [ 1152, 4 ],
  [ 2304, 3 ], [ 4608, 1 ] ]
