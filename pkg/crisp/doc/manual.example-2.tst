gap> FermatPrimes := Class(p -> IsPrime(p) and p = 2^LogInt(p, 2) + 1);
Class(in:=function( p ) ... end)
gap> cmpl := Complement([1,2]);
Complement([ 1, 2 ])
gap> Complement(cmpl);
[ 1, 2 ]
gap> Intersection(Class(IsPrimeInt), [1..10]);
[ 2, 3, 5, 7 ]
gap> Intersection(Class(IsPrimeInt), Class(n -> n = 2^LogInt(n+1, 2) - 1));
Intersection([ Class(in:=function( N ) ... end),
  Class(in:=function( n ) ... end) ])
gap> Union(Class(n -> n mod 2 = 0), Class(n -> n mod 3 = 0));
Union([ Class(in:=function( n ) ... end), Class(in:=function( n ) ... end)
 ])
gap> Difference(Class(IsPrimePowerInt), Class(IsPrimeInt));
Intersection([ Class(in:=function( n ) ... end),
  Complement(Class(in:=function( N ) ... end)) ])
gap> Difference([1..10], Class(IsPrimeInt));
[ 1, 4, 6, 8, 9, 10 ]
