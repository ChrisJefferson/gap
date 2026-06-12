gap> GroupClass(IsNilpotent);
GroupClass(in:=<Operation "IsNilpotent">)
gap> GroupClass([CyclicGroup(2), CyclicGroup(3)]);
GroupClass([ <pc group of size 2 with 1 generators>,
  <pc group of size 3 with 1 generators> ])
gap> AbelianIsomorphismTest := function(A,B)
>     if IsAbelian(A) then
>         if IsAbelian(B) then
>             return AbelianInvariants(A) = AbelianInvariants(B);
>         else
>             return false;
>         fi;
>     elif IsAbelian(B) then
>         return false;
>     else # this will not happen if called from GroupClass
>         Error("At least one of the groups <A> and <B> must be abelian");
>     fi;
> end;
function( A, B ) ... end
gap> cl := GroupClass([AbelianGroup([2,2]), AbelianGroup([3,5])],
> AbelianIsomorphismTest);
GroupClass([ <pc group of size 4 with 2 generators>,
  <pc group of size 15 with 2 generators> ], function( A, B ) ... end)
gap> Group((1,2),(3,4)) in cl;
true
gap> nilp := GroupClass(IsNilpotent);
GroupClass(in:=<Operation "IsNilpotent">)
gap> SetIsFittingClass(nilp, true);
gap> nilp;
FittingClass(in:=<Operation "IsNilpotent">)
