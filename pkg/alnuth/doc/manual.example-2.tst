gap> x := Indeterminate( Rationals, "x" );;
gap> pol := 2*x^7+2*x^5+8*x^4+8*x^2;
2*x^7+2*x^5+8*x^4+8*x^2
gap> L := FieldByPolynomial( x^3-4 );
<algebraic extension over the Rationals of degree 3>
gap> y := Indeterminate( L, "y" );;
gap> FactorsPolynomialAlgExt( L, pol );
[ !2*y, y, y+(a), y^2+!1, y^2+((-1*a))*y+(a^2) ]
gap> FactorsPolynomialPari( last[5] );
[ y^2+((-1*a))*y+(a^2) ]
gap>
                    degree over Q  number of generators  dim. of generators
ExampleMatField(1)              4                     4                   4
ExampleMatField(2)              4                     4                   4
ExampleMatField(3)              4                     4                   4
ExampleMatField(4)              4                    13                   4
ExampleMatField(5)              4                    13                   4
ExampleMatField(6)              4                     7                   4
ExampleMatField(7)              4                    18                   4
ExampleMatField(8)              4                    13                   4
ExampleMatField(9)              4                     7                   4
