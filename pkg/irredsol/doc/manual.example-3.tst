gap> G := IrreducibleSolubleMatrixGroup(12, 2, 3, 52)^RandomInvertibleMat(12, GF(2));;
# <matrix group of size 2340 with 6 generators>
gap> IdIrreducibleSolubleMatrixGroup(G);
[ 12, 2, 3, 52 ]
gap> G := IrreducibleSolubleMatrixGroup(6, 2, 3, 5) ^
>         RandomInvertibleMat(6, GF(4));
<matrix group of size 42 with 3 generators>
gap> r := RecognitionIrreducibleSolubleMatrixGroup(G, true, false);;
gap> r.id;
[ 6, 2, 3, 5 ]
gap> G^r.mat = CallFuncList(IrreducibleSolubleMatrixGroup, r.id);
true
gap> IdIrreducibleSolubleMatrixGroupIndexMS(6, 2, 5);
[ 6, 2, 2, 4 ]
gap> G := IrreducibleSolubleGroupMS(6,2,5);
<matrix group of size 27 with 2 generators>
gap> H := IrreducibleSolubleMatrixGroup(6, 2, 2, 4);
<matrix group of size 27 with 3 generators>
gap> G = H;
false
# groups in the libraries need not be the same
gap> r := RecognitionIrreducibleSolubleMatrixGroup(G, true, false);;
gap> G^r.mat = H;
true
gap> IndexMSIdIrreducibleSolubleMatrixGroup(6, 2, 2, 7);
[ 6, 2, 13 ]
gap> G := IrreducibleSolubleGroupMS(6,2,13);
<matrix group of size 63 with 3 generators>
gap> H := IrreducibleSolubleMatrixGroup(6, 2, 2, 7);
<matrix group of size 63 with 3 generators>
gap> G = H;
false
gap> r := RecognitionIrreducibleSolubleMatrixGroup(G, true, false);;
gap> G^r.mat = H;
true
