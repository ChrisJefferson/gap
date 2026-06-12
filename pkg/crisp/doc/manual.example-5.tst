gap> myNilpotentGroups := FittingClass(rec(\in := IsNilpotentGroup,
>    rad := FittingSubgroup));
FittingClass(in:=<Property "IsNilpotentGroup">, rad:=<Attribute "FittingSubgr\
oup">)
gap> myTwoGroups := FittingClass(rec(
>    \in := G -> IsSubset([2], Set(Factors(Size(G)))),
>    rad :=  G -> PCore(G,2),
>    inj := G -> SylowSubgroup(G,2)));
FittingClass(in:=function( G ) ... end, rad:=function( G ) ... end, inj:=func\
tion( G ) ... end)
gap> myL2_Nilp := FittingClass(rec(\in :=
>     G -> IsSolvableGroup(G)
>          and Index(G, Injector(G, myNilpotentGroups)) mod 2 <> 0));
FittingClass(in:=function( G ) ... end)
gap> SymmetricGroup(3) in myL2_Nilp;
false
gap> SymmetricGroup(4) in myL2_Nilp;
true
gap> FittingProduct(myNilpotentGroups, myTwoGroups);
FittingProduct(FittingClass(in:=<Property "IsNilpotentGroup">, rad:=<Attribu\
te "FittingSubgroup">), FittingClass(in:=function( G ) ... end, rad:=function\
( G ) ... end, inj:=function( G ) ... end))
gap> FittingProduct(myNilpotentGroups, myL2_Nilp);
FittingProduct(FittingClass(in:=<Property "IsNilpotentGroup">, rad:=<Attribu\
te "FittingSubgroup">), FittingClass(in:=function( G ) ... end))
gap>  fitset := FittingSet(SymmetricGroup(4), rec(
>        \in := S -> IsSubgroup(AlternatingGroup(4), S),
>        rad := S -> Intersection(AlternatingGroup(4), S),
>        inj := S -> Intersection(AlternatingGroup(4), S)));
FittingSet(SymmetricGroup(
[ 1 .. 4 ] ), rec(in:=function( S ) ... end, rad:=function( S ) ... end, inj:\
=function( S ) ... end))
gap> FittingSet(SymmetricGroup(3), rec(
>       \in := H -> H in [Group(()), Group((1,2)), Group((1,3)), Group((2,3))]));
FittingSet(SymmetricGroup( [ 1 .. 3 ] ), rec(in:=function( H ) ... end))
gap> alpha := GroupHomomorphismByImages(SymmetricGroup(4), SymmetricGroup(3),
>  [(1,2),(1,3),(1,4)], [(1,2),(1,3),(2,3)]);;
gap> im := ImageFittingSet(alpha, fitset);
FittingSet(Group( [(1,2),(1,3),(2,3)
 ] ), rec(inj:=function( G ) ... end))
gap> Radical(Image(alpha), im);
Group([ (), (), (1,2,3), (1,3,2) ])
gap> pre := PreImageFittingSet(alpha, NilpotentGroups);
FittingSet(SymmetricGroup( [ 1 .. 4 ] ), rec(inj:=function( G ) ... end))
gap> Injector(Source(alpha), pre);
Group([ (1,2,3), (1,2)(3,4) ])
gap> F1 := FittingSet(SymmetricGroup(3),
> rec(\in := IsNilpotentGroup, rad := FittingSubgroup));
FittingSet(SymmetricGroup(
[ 1 .. 3 ] ), rec(in:=<Property "IsNilpotentGroup">, rad:=<Attribute "Fitting\
Subgroup">))
gap> F2 := FittingSet(AlternatingGroup(4),
> rec(\in := ReturnTrue, rad := H -> H));
FittingSet(AlternatingGroup(
[ 1 .. 4 ] ), rec(in:=function( arg ) ... end, rad:=function( H ) ... end))
gap> F := Intersection(F1, F2);
FittingSet(Group(
[ (1,2,3) ] ), rec(in:=function( x ) ... end, rad:=function( G ) ... end))
gap> Intersection(F1, PiGroups([2,5]));
FittingSet(SymmetricGroup(
[ 1 .. 3 ] ), rec(in:=function( x ) ... end, rad:=function( G ) ... end))
gap> Radical(SymmetricGroup(4), FittingClass(rec(\in := IsNilpotentGroup)));
Group([(1,4)(2,3),(1,3)(2,4) ])
gap> Radical(SymmetricGroup(4), myL2_Nilp);
Sym( [ 1 .. 4 ] )
gap> Radical(SymmetricGroup(3), myL2_Nilp);
Group([ (1,2,3) ])
gap> Injector(SymmetricGroup(4), FittingClass(rec(\in := IsNilpotentGroup)));
Group([ (1,4)(2,3), (1,3)(2,4), (3,4) ])
gap> D := DihedralGroup(8);;
gap> AllInvariantSubgroupsWithNProperty(
> D, D,
>     ReturnFail,
>     function(R, S, data)
>         return IsAbelian(R);
>     end,
>     fail);
[ Group([ f3 ]), <pc group with 2 generators>, <pc group with 2 generators>,
  Group([ f1, f3 ]), Group([  ]) ]
