gap> nilp := SchunckClass(rec(bound := G -> not IsCyclic(G),
>        name := "class of all nilpotent groups"));
class of all nilpotent groups
gap> DihedralGroup(8) in nilp;
true
gap> SymmetricGroup(3) in nilp;
false
gap> H := SchunckClass(rec(bound := G -> Size(G) = 6));
SchunckClass(bound:=function( G ) ... end)
gap> Size(Projector(GL(2,3), H));
16
gap> # H-projectors coincide with Sylow subgroups
gap> U := SchunckClass(rec( # class of all supersoluble groups
>    bound := G -> not IsPrimeInt( Size(Socle(G)))
> ));
SchunckClass(bound:=function( G ) ... end)
gap> Size(Projector(SymmetricGroup(4), U));
6
gap> # the projectors are the point stabilizers
gap> der3 := OrdinaryFormation(rec(
>    res := G -> DerivedSubgroup(DerivedSubgroup(DerivedSubgroup(G)))
> ));
OrdinaryFormation(res:=function( G ) ... end)
gap> SymmetricGroup(4) in der3;
true
gap> GL(2,3) in der3;
false
gap> exp6 := OrdinaryFormation(rec(
>    \in := G -> 6 mod Exponent(G) = 0,
>    char := [2,3]));
OrdinaryFormation(in:=function( G ) ... end)
gap> nilp := SaturatedFormation(rec(
>      locdef := function(G, p)
>          return GeneratorsOfGroup(G);
>      end));
SaturatedFormation(locdef:=function( G, p ) ... end)
gap> form := SaturatedFormation(rec(
>    locdef := function(G, p)
>        if p = 2 then
>           return GeneratorsOfGroup(G);
>        elif p mod 4 = 3 then
>           return GeneratorsOfGroup(DerivedSubgroup(G));
>        else
>           return fail;
>        fi;
>     end));
SaturatedFormation(locdef:=function( G, p ) ... end)
gap> Projector(GL(2,3), form);
Group([ [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0 ] ],
  [ [ Z(3)^0, Z(3) ], [ 0*Z(3), Z(3)^0 ] ],
  [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ] ])
gap> nilp := SaturatedFormation(rec(\in := IsNilpotent, name := "nilp"));
nilp
gap> FormationProduct(nilp, der3); # no characteristic known
FormationProduct(nilp, OrdinaryFormation(res:=function( G ) ... end))
gap> HasIsSaturated(last);HasCharacteristic(nilp);
false
false
gap> SetCharacteristic(nilp, AllPrimes);
gap> FormationProduct(nilp, der3); # try with characteristic
FormationProduct(nilp, OrdinaryFormation(res:=function( G ) ... end))
gap> IsSaturated(last);
true
gap> nilp := FittingFormation(rec(\in := IsNilpotent, name := "nilp"));;
gap> FormationProduct(nilp, nilp);
FittingFormationProduct(nilp, nilp)
gap> FittingProduct(nilp, nilp);
FittingFormationProduct(nilp, nilp)
gap> FittingFormationProduct(nilp, nilp);
FittingFormationProduct(nilp, nilp)
gap> G := DirectProduct(SL(2,3), CyclicGroup(2));;
gap> data := rec(gens := GeneratorsOfGroup(G),
>    comms := List(Combinations(GeneratorsOfGroup(G), 2),
>       x -> Comm(x[1],x[2])));;
gap> OneInvariantSubgroupMinWrtQProperty(
>    G, G,
>    function(U, V, R, data) # test if U/V is central in G
>        if ForAny(ModuloPcgs(U, V), y ->
>           ForAny(data.gens, x -> not Comm(x, y) in V)) then
>           return false;
>        else
>           return fail;
>        fi;
>     end,
>     function(S, R, data)
>        return ForAll(data.comms, x -> x in S);
>     end,
>     data) = DerivedSubgroup(G); # compare results
true
gap> G := GL(2,3);
GL(2,3)
gap> normsWithSupersolubleFactorGroups :=
> AllInvariantSubgroupsWithQProperty(G, G,
>    function(U, V, R, data)
>       return IsPrimeInt(Index(U, V));
>    end,
>    ReturnFail, # pretest is sufficient
>    fail); # no data required
[ GL(2,3),
  Group([ [ [ Z(3)^0, Z(3) ], [ 0*Z(3), Z(3)^0 ] ],
      [ [ Z(3), Z(3)^0 ], [ Z(3)^0, Z(3)^0 ] ],
      [ [ 0*Z(3), Z(3)^0 ], [ Z(3), 0*Z(3) ] ],
      [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ] ]),
  Group([ [ [ Z(3), Z(3)^0 ], [ Z(3)^0, Z(3)^0 ] ],
      [ [ 0*Z(3), Z(3)^0 ], [ Z(3), 0*Z(3) ] ],
      [ [ Z(3), 0*Z(3) ], [ 0*Z(3), Z(3) ] ] ]) ]
