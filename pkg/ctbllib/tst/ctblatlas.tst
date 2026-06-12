# This file was created from xpl/ctblatlas.xpl, do not edit!
#############################################################################
##
#W  ctblatlas.tst             GAP applications              Thomas Breuer
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `Test( "ctblatlas.tst" );`.
##
gap> START_TEST( "ctblatlas.tst" );

##
gap> LoadPackage( "ctbllib", false );
true

##
gap> lib:= CharacterTable( "Th" );;
gap> parrottnames:= [
>      "1A", "z", "c2", "c3", "c1", "r1", "v", "b", "zc1", "zc2",
>      "zc3", "a", "us1", "w", "f1", "f3", "f2", "zb",
>      "r1c2", "(r1c2)^-1", "r1c3", "vc1", "l", "za",
>      "c1b", "(c1b)^-1", "zf1", "zf2", "19A", "vb", "c2a2",
>      "us1c2", "(us1c2)^-1", "wc1", "(wc1)^-1",
>      "f4", "f5", "(f5)^-1", "r1a", "zbc1", "(zbc1)^-1",
>      "31A", "31B", "r1f1", "s1f1", "(s1f1)^-1",
>      "c2l", "(c2l)^-1" ];;
gap> orders:= OrdersClassRepresentatives( lib );;
gap> centralizers:= SizesCentralizers( lib );;
gap> descr:= TransposedMat( [ parrottnames, orders, centralizers ] );;
gap> for entry in descr do
>      Print( String( entry[1], -12 ),
>             String( entry[2], 2 ), "  ",
>             StringPP( entry[3] ), "\n" );
>    od;
1A           1  2^15*3^10*5^3*7^2*13*19*31
z            2  2^15*3^4*5*7
c2           3  2^6*3^7*7*13
c3           3  2^3*3^10
c1           3  2^4*3^7*5
r1           4  2^11*3^3*7
v            4  2^9*3*5
b            5  2^3*3*5^3
zc1          6  2^4*3^3*5
zc2          6  2^6*3^3
zc3          6  2^3*3^4
a            7  2^3*3*7^2
us1          8  2^7*3
w            8  2^5*3
f1           9  2^3*3^6
f3           9  3^6
f2           9  2*3^4
zb          10  2^3*3*5
r1c2        12  2^5*3^2
(r1c2)^-1   12  2^5*3^2
r1c3        12  2^2*3^3
vc1         12  2^3*3
l           13  3*13
za          14  2^3*7
c1b         15  2*3*5
(c1b)^-1    15  2*3*5
zf1         18  2^3*3^2
zf2         18  2*3^2
19A         19  19
vb          20  2^2*5
c2a2        21  3*7
us1c2       24  2^3*3
(us1c2)^-1  24  2^3*3
wc1         24  2^3*3
(wc1)^-1    24  2^3*3
f4          27  3^3
f5          27  3^3
(f5)^-1     27  3^3
r1a         28  2^2*7
zbc1        30  2*3*5
(zbc1)^-1   30  2*3*5
31A         31  31
31B         31  31
r1f1        36  2^2*3^2
s1f1        36  2^2*3^2
(s1f1)^-1   36  2^2*3^2
c2l         39  3*13
(c2l)^-1    39  3*13

##
gap> th:= rec( UnderlyingCharacteristic:= 0,
>              OrdersClassRepresentatives:= orders,
>              SizesCentralizers:= centralizers,
>              Size:= centralizers[1] );;
gap> ConvertToCharacterTableNC( th );;

##
gap> g:= AtlasGroup( "2^5.L5(2)" );;
gap> bl:= Blocks( g, MovedPoints( g ) );;
gap> Length( bl[1] );
2
gap> acthom:= ActionHomomorphism( g, bl, OnSets );;
gap> img:= Image( acthom );;
gap> Size( g ) / Size( img );
32
gap> sm:= SmallerDegreePermutationRepresentation( img );;
gap> NrMovedPoints( Image( sm ) );
31
gap> f:= CharacterTable( Image( sm ) );;
gap> d:= CharacterTable( g );;
gap> fus:= List( ConjugacyClasses( d ),
>            c -> PositionProperty( ConjugacyClasses( f ),
>                   cc -> ( Representative( c )^acthom )^sm in cc ) );;
gap> infl:= List( Irr( f ), x -> x{ fus } );;

##
gap> indcyc:= InducedCyclic( d, [ 2 .. NrConjugacyClasses( d ) ], "all" );;
gap> nat:= NaturalCharacter( g );;
gap> red:= ReducedOrdinary( d, infl, Concatenation( indcyc, [ nat ] ) );;
gap> Length( red.irreducibles );
1
gap> faithirr:= ShallowCopy( red.irreducibles );;
gap> ten:= Set( Tensored( infl, faithirr ) );;
gap> ten:= Reduced( d, faithirr, ten );;
gap> lll:= LLL( d, Concatenation( red.remainders, ten.remainders ) );;
gap> Length( lll.irreducibles );
5
gap> Append( faithirr, lll.irreducibles );

##
gap> sym2:= Symmetrizations( d, faithirr, 2 );;
gap> sym3:= Symmetrizations( d, faithirr, 3 );;
gap> irr:= Concatenation( infl, faithirr );;
gap> sym:= Reduced( d, irr, Concatenation( sym2, sym3 ) );;
gap> lll:= LLL( d, Concatenation( lll.remainders, sym.remainders ) );;
gap> Length( lll.irreducibles );
4
gap> Append( irr, lll.irreducibles );

##
gap> gram:= MatScalarProducts( d, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram );;                           
gap> Length( emb.solutions );
3
gap> dec:= List( emb.solutions,
>                x -> Decreased( d, lll.remainders, emb.vectors{ x } ) );;
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> Length( dec );
2

##
gap> sym:= List( [ 1, 2 ],
>            i -> Symmetrizations( d, [ dec[i].irreducibles[1] ], 2 ) );;
gap> good:= Filtered( [ 1, 2 ],
>             i -> ForAll( dec[i].irreducibles,
>                    x -> IsInt( ScalarProduct( d, sym[i][1], x ) ) ) );;
gap> Length( good );
1
gap> SetIrr( d, Concatenation( irr, dec[ good[1] ].irreducibles ) );

##
gap> nsg:= ClassPositionsOfNormalSubgroups( d );
[ [ 1 ], [ 1, 2 ], [ 1 .. 41 ] ]
gap> SizesConjugacyClasses( d ){ nsg[2] };
[ 1, 31 ]
gap> OrdersClassRepresentatives( d ){ nsg[2] };
[ 1, 2 ]

##
gap> f:= d / nsg[2];;
gap> PossibleClassFusions( f, d );
[  ]

##
gap> n:= PCore( g, 2 );
<permutation group with 5 generators>
gap> Size( n );
32
gap> IsomorphismGroups( g / n, GL(5,2) ) = fail;
false

##
gap> libsub:= CharacterTable( "2^5.L5(2)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( d, libsub ) );
true
gap> d:= libsub;;

##
gap> powinfo:= [
>     [ "zc3", 2, "c3" ],     # c3 commutes with z
>     [ "zf2", 2, "f2" ],     # f2 commutes with z
>     [ "r1c3", 2, "zc3" ],   # r1 commutes with c3
>     [ "vc1", 2, "zc1" ],    # v squares to z and commutes with c1
>     [ "wc1", 2, "vc1" ],    # w squares to v and commutes with c1
>     [ "(wc1)^-1", 2, "vc1" ],
>     [ "us1c2", 2, "r1c2" ], # us1 squares to r1
>     [ "(us1c2)^-1", 2, "(r1c2)^-1" ],
>     [ "us1", 2, "r1" ],     # (5.1)
>     [ "w", 2, "v" ],        # (5.1)
>     [ "zbc1", 2, "c1b" ],
>     [ "(zbc1)^-1", 2, "(c1b)^-1" ],
>     [ "f1", 3, "c3" ],
>     [ "f2", 3, "c3" ],
>     [ "f3", 3, "c3" ],
>     [ "vc1", 3, "v" ],      # v commutes with c1
>     [ "zf1", 3, "zc3" ],
>     [ "zf2", 3, "zc3" ],
>     [ "us1c2", 3, "us1" ],
>     [ "(us1c2)^-1", 3, "us1" ],
>     [ "wc1", 3, "w" ],
>     [ "(wc1)^-1", 3, "w" ],
>     [ "f4", 3, "f3" ],
>     [ "f5", 3, "f3" ],
>     [ "(f5)^-1", 3, "f3" ],
>     [ "r1f1", 3, "r1c3" ],
>     [ "s1f1", 3, "r1c3" ],
>     [ "(s1f1)^-1", 3, "r1c3" ],
>     ];;

##
gap> maxorder:= Maximum( OrdersClassRepresentatives( th ) );
39
gap> primes:= Filtered( [ 1 .. maxorder ], IsPrimeInt );;

##
gap> for p in primes do
>      if 36 mod p <> 0 then
>        Add( powinfo, [ "r1f1", p, "r1f1" ] );
>      fi;
>      if 27 mod p <> 0 then
>        Add( powinfo, [ "f4", p, "f4" ] );
>      fi;
>    od;

##
gap> powermaps:= [];;
gap> for p in primes do
>      powermaps[p]:= InitPowerMap( th, p );
>    od;
gap> for entry in powinfo do
>      p:= entry[2];
>      pow:= powermaps[p];
>      src:= Position( parrottnames, entry[1] );
>      trg:= Position( parrottnames, entry[3] );
>      if IsInt( pow[ src ] ) then
>        if pow[ src ] <> trg then
>          Error( "contradiction!" );
>        fi;
>      elif not trg in pow[ src ] then
>        Error( "contradiction!" );
>      else
>        pow[ src ]:= trg;
>      fi;
>    od;
gap> SetComputedPowerMaps( th, powermaps );

##
gap> setGaloisInfo:= function( powermaps, classes, orders, primes, x )
>    local ord, p;
>    ord:= orders[ classes[1] ];
>    for p in primes do
>      if ord mod p <> 0 then
>        if GaloisCyc( x, p ) = x then
>          powermaps[p]{ classes }:= classes;
>        else
>          powermaps[p]{ classes }:= classes{ [ 2, 1 ] };
>        fi;
>      fi;
>    od;
>    end;;

##
gap> pos:= Positions( OrdersClassRepresentatives( d ), 15 );
[ 22, 24 ]
gap> f:= Field( List( Irr( d ), x -> x[ pos[1] ] ) );
NF(15,[ 1, 2, 4, 8 ])
gap> Sqrt( -15 ) in f;
true
gap> pos:= Positions( orders, 15 );
[ 25, 26 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -15 ) );
gap> pos:= Positions( OrdersClassRepresentatives( d ), 30 );
[ 23, 25 ]
gap> f:= Field( List( Irr( d ), x -> x[ pos[1] ] ) );
NF(15,[ 1, 2, 4, 8 ])
gap> pos:= Positions( orders, 30 );
[ 40, 41 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -15 ) );

##
gap> setGaloisInfo( powermaps,
>        List( [ "f5", "(f5)^-1" ], x -> Position( parrottnames, x ) ),
>        orders, primes, Sqrt( -3 ) );
gap> setGaloisInfo( powermaps, Positions( orders, 31 ), orders, primes,
>                   Sqrt( -31 ) );

##
gap> pos:= Positions( orders, 39 );
[ 47, 48 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -3 ) );
gap> indcyc:= InducedCyclic( th, [ pos[1] ], "all" );;
gap> ForAll( indcyc, x -> IsInt( ScalarProduct( th, x, x ) ) );
false
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -39 ) );
gap> indcyc:= InducedCyclic( th, [ pos[1] ], "all" );;
gap> ForAll( indcyc, x -> IsInt( ScalarProduct( th, x, x ) ) );
true

##
gap> pos:= Positions( orders, 36 );
[ 44, 45, 46 ]
gap> parrottnames{ pos };
[ "r1f1", "s1f1", "(s1f1)^-1" ]
gap> setGaloisInfo( powermaps, [ 45, 46 ], orders, primes, Sqrt( -3 ) );
gap> indcyc:= InducedCyclic( th, [ 45 ], "all" );;    
gap> ForAll( indcyc, x -> IsInt( ScalarProduct( th, x, x ) ) );
true
gap> setGaloisInfo( powermaps, [ 45, 46 ], orders, primes, Sqrt( -1 ) );
gap> indcyc:= InducedCyclic( th, [ 45 ], "all" );;
gap> ForAll( indcyc, x -> IsInt( ScalarProduct( th, x, x ) ) );
false
gap> setGaloisInfo( powermaps, [ 45, 46 ], orders, primes, Sqrt( -3 ) );

##
gap> List( [ "wc1", "(wc1)^-1" ], x -> Position( parrottnames, x ) );
[ 34, 35 ]
gap> vals:= [ Sqrt( -3 ), Sqrt( -1 ), Sqrt( -2 ), Sqrt( -6 ) ];
[ E(3)-E(3)^2, E(4), E(8)+E(8)^3, E(24)+E(24)^11-E(24)^17-E(24)^19 ]
gap> good:= [];;
gap> for val in vals do
>      setGaloisInfo( powermaps, [ 34, 35 ], orders, primes, val );
>      indcyc:= InducedCyclic( th, [ 34 ], "all" );
>      if ForAll( indcyc, x -> IsInt( ScalarProduct( th, x, x ) ) ) then
>        Add( good, val );
>      fi;
>    od;
gap> good;
[ E(24)+E(24)^11-E(24)^17-E(24)^19 ]
gap> setGaloisInfo( powermaps, [ 34, 35 ], orders, primes, good[1] );

##
gap> parrottnames{ [ 19, 20, 32, 33 ] };
[ "r1c2", "(r1c2)^-1", "us1c2", "(us1c2)^-1" ]
gap> fus:= InitFusion( d, th );;
gap> pos:= Positions( OrdersClassRepresentatives( d ), 12 );
[ 12, 15, 16 ]
gap> fus{ pos };
[ [ 19, 20, 21, 22 ], [ 19, 20 ], [ 19, 20 ] ]
gap> List( pos, x -> Field( List( Irr( d ), chi -> chi[x] ) ) );
[ Rationals, CF(3), CF(3) ]
gap> Sqrt( -3 ) in CF(3);
true
gap> setGaloisInfo( powermaps, [ 19, 20 ], orders, primes, Sqrt( -3 ) );
gap> setGaloisInfo( powermaps, [ 32, 33 ], orders, primes, Sqrt( -3 ) );

##
gap> indcyc:= InducedCyclic( th, [ 2 .. NrConjugacyClasses( th ) ], "all" );;

##
gap> fus:= InitFusion( d, th );
[ 1, 2, 2, 6, [ 6, 7 ], [ 6, 7 ], 13, [ 13, 14 ], [ 13, 14 ], 5, 9, 
  [ 19, 20, 21, 22 ], 3, 10, [ 19, 20 ], [ 19, 20 ], [ 9, 10 ], 
  [ 32, 33, 34, 35 ], [ 32, 33, 34, 35 ], 8, 18, [ 25, 26 ], [ 40, 41 ], 
  [ 25, 26 ], [ 40, 41 ], 12, 24, 24, 39, 31, 12, 24, 24, 39, 31, [ 42, 43 ], 
  [ 42, 43 ], [ 42, 43 ], [ 42, 43 ], [ 42, 43 ], [ 42, 43 ] ]
gap> Positions( OrdersClassRepresentatives( d ), 31 );
[ 36, 37, 38, 39, 40, 41 ]
gap> fus[36];
[ 42, 43 ]
gap> fus[36]:= 42;;
gap> TestConsistencyMaps( ComputedPowerMaps( d ), fus,
>        ComputedPowerMaps( th ) );
true
gap> possfus:= FusionsAllowedByRestrictions( d, th, Irr( d ), indcyc, fus,
>      rec( maxlen:= 10, minamb:= 1, maxamb:= 10^6, quick:= false,
>           contained:= ContainedPossibleCharacters ) );;
gap> possfus:= RepresentativesFusions( d, possfus, Group( () ) );
[ [ 1, 2, 2, 6, 7, 6, 13, 14, 13, 5, 9, 22, 3, 10, 19, 20, 10, 33, 32, 8, 18, 
      25, 40, 26, 41, 12, 24, 24, 39, 31, 12, 24, 24, 39, 31, 42, 43, 42, 42, 
      43, 43 ], 
  [ 1, 2, 2, 6, 7, 7, 13, 14, 14, 5, 9, 22, 3, 10, 19, 20, 10, 33, 32, 8, 18, 
      25, 40, 26, 41, 12, 24, 24, 39, 31, 12, 24, 24, 39, 31, 42, 43, 42, 42, 
      43, 43 ] ]

##
gap> indd:= InducedClassFunctionsByFusionMap( d, th, Irr( d ), possfus[1] );;
gap> ForAll( indd, x -> IsInt( ScalarProduct( th, x, x ) ) );
false
gap> indd:= InducedClassFunctionsByFusionMap( d, th, Irr( d ), possfus[2] );;
gap> ForAll( indd, x -> IsInt( ScalarProduct( th, x, x ) ) );
true

##
gap> irr:= [ TrivialCharacter( th ) ];;
gap> red:= ReducedOrdinary( th, irr, Concatenation( indcyc, indd ) );;
gap> lll:= LLL( th, red.remainders );;
gap> Length( lll.irreducibles );
4
gap> Append( irr, lll.irreducibles );

##
gap> sym:= Concatenation( List( [ 2, 3, 4, 5 ],
>              p -> Symmetrizations( th, irr, p ) ) );;
gap> sym:= ReducedOrdinary( th, irr, sym );;
gap> ten:= Set( Tensored( irr, irr ) );;
gap> ten:= ReducedOrdinary( th, irr, ten );;
gap> lll:= LLL( th, Concatenation( lll.remainders, sym.remainders,
>                               ten.remainders ) );;
gap> Length( lll.irreducibles );
3
gap> Append( irr, lll.irreducibles );
gap> DimensionsMat( irr );
[ 8, 48 ]

##
gap> indcyc:= ReducedOrdinary( th, irr, indcyc );;
gap> indd:= ReducedOrdinary( th, irr, indd );;
gap> sym:= ReducedOrdinary( th, irr, sym.remainders );;
gap> ten:= ReducedOrdinary( th, irr, ten.remainders );;
gap> lll:= LLL( th, Concatenation( indcyc.remainders, indd.remainders,
>                       sym.remainders, ten.remainders ) );;
gap> gram:= MatScalarProducts( th, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 40 );;
gap> Length( emb.solutions );
4

##
gap> dec:= List( emb.solutions,
>                x -> Decreased( th, lll.remainders, emb.vectors{ x } ) );;
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> Length( dec );
2

##
gap> SetIrr( th, List( Concatenation( irr, dec[1].irreducibles ),
>                      x -> Character( th, x ) ) );
gap> IsRecord( TransformingPermutationsCharacterTables( th, lib ) );
true

##
gap> ResetFilterObj( th, HasIrr );
gap> SetIrr( th, List( Concatenation( irr, dec[2].irreducibles ),
>                      x -> Character( th, x ) ) );
gap> IsRecord( TransformingPermutationsCharacterTables( th, lib ) );
true

##
gap> lib:= CharacterTable( "J4" );;
gap> pos:= [ 1 .. NrConjugacyClasses( lib ) ];;
gap> orders:= OrdersClassRepresentatives( lib );;
gap> centralizers:= SizesCentralizers( lib );;
gap> descr:= TransposedMat( [ pos, orders, centralizers ] );;
gap> for entry in descr do
>      Print( String( entry[1], 2 ), "  ",
>             String( entry[2], 2 ), "  ",
>             StringPP( entry[3] ), "\n" );
>    od;
 1   1  2^21*3^3*5*7*11^3*23*29*31*37*43
 2   2  2^21*3^3*5*7*11
 3   2  2^19*3^2*5*7*11
 4   3  2^8*3^3*5*7*11
 5   4  2^15*3*5*11
 6   4  2^15*3
 7   4  2^11*3*7
 8   5  2^6*3*5*7
 9   6  2^8*3^3*5*7*11
10   6  2^8*3^2
11   6  2^8*3^2
12   7  2^3*3*5*7
13   7  2^3*3*5*7
14   8  2^8*5
15   8  2^8*3
16   8  2^9
17  10  2^6*3*5
18  10  2^4*5
19  11  2^3*3*11^3
20  11  2*11^2
21  12  2^6*3
22  12  2^6*3
23  12  2^4*3
24  14  2^2*3*7
25  14  2^2*3*7
26  14  2^3*7
27  14  2^3*7
28  15  2*3*5
29  16  2^5
30  20  2^5*5
31  20  2^5*5
32  21  2*3*7
33  21  2*3*7
34  22  2^3*3*11
35  22  2*11
36  23  23
37  24  2^4*3
38  24  2^4*3
39  28  2^2*7
40  28  2^2*7
41  29  29
42  30  2*3*5
43  31  31
44  31  31
45  31  31
46  33  2*3*11
47  33  2*3*11
48  35  5*7
49  35  5*7
50  37  37
51  37  37
52  37  37
53  40  2^3*5
54  40  2^3*5
55  42  2*3*7
56  42  2*3*7
57  43  43
58  43  43
59  43  43
60  44  2^2*11
61  66  2*3*11
62  66  2*3*11

##
gap> j4:= rec( UnderlyingCharacteristic:= 0,
>              OrdersClassRepresentatives:= orders,
>              SizesCentralizers:= centralizers,
>              Size:= centralizers[1] );;
gap> ConvertToCharacterTableNC( j4 );;

##
gap> u:= CharacterTable( "J4M1" );
CharacterTable( "mx1j4" )

##
gap> powinfo:= [
>     [  5,  2,  2 ],
>     [  6,  2,  2 ],
>     [  7,  2,  3 ],
>     [ 10,  3,  2 ],
>     [ 11,  3,  3 ],
>     [ 15,  2,  6 ],
>     [ 16,  2,  6 ],
>     [ 17,  5,  2 ],
>     [ 18,  5,  3 ],
>     [ 21,  3,  5 ],
>     [ 22,  3,  6 ],
>     [ 23,  3,  7 ],
>     [ 24,  7,  2 ],
>     [ 25,  7,  2 ],
>     [ 26,  7,  3 ],
>     [ 27,  7,  3 ],
>     [ 29,  2, 16 ],
>     [ 34, 11,  2 ],
>     [ 35, 11,  3 ],
>     ];;

##
gap> maxorder:= Maximum( OrdersClassRepresentatives( j4 ) );
66
gap> primes:= Filtered( [ 1 .. maxorder ], IsPrimeInt );;

##
gap> pos:= Union( Positions( orders, 6 ), Positions( orders, 12 ) );
[ 9, 10, 11, 21, 22, 23 ]
gap> for p in primes do
>      if 6 mod p <> 0 then
>        for i in pos do
>          Add( powinfo, [ i, p, i ] );
>        od;
>      fi;
>    od;

##
gap> Add( powinfo, [ 24, 2, 12 ] );
gap> Add( powinfo, [ 25, 2, 13 ] );
gap> Add( powinfo, [ 26, 2, 12 ] );
gap> Add( powinfo, [ 27, 2, 13 ] );
gap> Add( powinfo, [ 39, 2, 26 ] );
gap> Add( powinfo, [ 40, 2, 27 ] );
gap> Add( powinfo, [ 55, 2, 32 ] );
gap> Add( powinfo, [ 56, 2, 33 ] );
gap> Add( powinfo, [ 55, 3, 25 ] );
gap> Add( powinfo, [ 56, 3, 24 ] );
gap> Add( powinfo, [ 32, 3, 13 ] );
gap> Add( powinfo, [ 33, 3, 12 ] );

##
gap> powermaps:= [];;
gap> for p in primes do
>      powermaps[p]:= InitPowerMap( j4, p );
>    od;
gap> for entry in powinfo do
>      p:= entry[2];
>      pow:= powermaps[p];
>      src:= entry[1];
>      trg:= entry[3];
>      if IsInt( pow[ src ] ) then
>        if pow[ src ] <> trg then
>          Error( "contradiction!" );
>        fi;
>      elif not trg in pow[ src ] then
>        Error( "contradiction!" );
>      else
>        pow[ src ]:= trg;
>      fi;
>    od;
gap> SetComputedPowerMaps( j4, powermaps );

##
gap> x:= Sqrt( -7 );;
gap> pos:= Positions( orders, 7 );
[ 12, 13 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, x );
gap> setGaloisInfo( powermaps, [ 24, 25 ], orders, primes, x );
gap> setGaloisInfo( powermaps, [ 26, 27 ], orders, primes, x );
gap> pos:= Positions( orders, 21 );
[ 32, 33 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, x );
gap> pos:= Positions( orders, 28 );
[ 39, 40 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, x );
gap> pos:= Positions( orders, 35 );
[ 48, 49 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, x );
gap> pos:= Positions( orders, 42 );
[ 55, 56 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, x );

##
gap> powermaps[5]{ [ 48, 49 ] }:= [ 13, 12 ];;

##
gap> pos:= Positions( orders, 33 );
[ 46, 47 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, 1 );
gap> ind:= InducedCyclic( j4, [ 46 ], "all" );;
gap> ForAll( ind, x -> IsInt( ScalarProduct( j4, x, x ) ) );
false
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -3 ) );
gap> ind:= InducedCyclic( j4, [ 46 ], "all" );;
gap> ForAll( ind, x -> IsInt( ScalarProduct( j4, x, x ) ) );
false
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( -11 ) );
gap> ind:= InducedCyclic( j4, [ 46 ], "all" );;
gap> ForAll( ind, x -> IsInt( ScalarProduct( j4, x, x ) ) );
false
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( 33 ) );
gap> ind:= InducedCyclic( j4, [ 46 ], "all" );;
gap> ForAll( ind, x -> IsInt( ScalarProduct( j4, x, x ) ) );
true

##
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( 33 ) );
gap> pos:= Positions( orders, 66 );
[ 61, 62 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( 33 ) );
gap> powermaps[2]{ pos }:= [ 46, 47 ];;

##
gap> pos:= Positions( orders, 20 );
[ 30, 31 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, 1 );
gap> ind:= InducedCyclic( j4, [ 30 ], "all" );;
gap> ForAll( ind, x -> IsInt( ScalarProduct( j4, x, x ) ) );
false
gap> u:= CharacterTable( "J4M1" );
CharacterTable( "mx1j4" )
gap> pos:= Positions( OrdersClassRepresentatives( u ), 20 );
[ 60, 61 ]
gap> flds:= List( pos, i -> Field( List( Irr( u ), x -> x[i] ) ) );
[ NF(5,[ 1, 4 ]), NF(5,[ 1, 4 ]) ]
gap> x:= Sqrt(5);;
gap> ForAll( flds, f -> x in f );
true
gap> setGaloisInfo( powermaps, Positions( orders, 20 ), orders, primes, x );

##
gap> pos:= Positions( orders, 40 );
[ 53, 54 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( 5 ) );
gap> powermaps[2]{ pos }:= [ 31, 30 ];;

##
gap> x:= EC( 31 );;
gap> classes:= [ 43 .. 45 ];;
gap> vals:= List( [ 1, 5, 25 ], k -> GaloisCyc( x, k ) );;
gap> for p in primes do
>   if p mod 31 <> 0 then
>     for i in [ 1 .. 3 ] do
>       powermaps[p][ classes[i] ]:=
>         classes[ Position( vals, GaloisCyc( vals[i], p ) ) ];
>     od;
>   fi;
> od;
gap> x:= EC( 37 );;
gap> classes:= [ 50 .. 52 ];;
gap> vals:= List( [ 1, 2, 4 ], k -> GaloisCyc( x, k ) );;
gap> for p in primes do
>   if p mod 37 <> 0 then
>     for i in [ 1 .. 3 ] do
>       powermaps[p][ classes[i] ]:=
>         classes[ Position( vals, GaloisCyc( vals[i], p ) ) ];
>     od;
>   fi;
> od;
gap> x:= EC( 43 );;
gap> classes:= [ 57 .. 59 ];;
gap> vals:= List( [ 1, 6, 36 ], k -> GaloisCyc( x, k ) );;
gap> for p in primes do
>   if p mod 43 <> 0 then
>     for i in [ 1 .. 3 ] do
>       powermaps[p][ classes[i] ]:=
>         classes[ Position( vals, GaloisCyc( vals[i], p ) ) ];
>     od;
>   fi;
> od;

##
gap> pos:= PositionsProperty( powermaps[2], IsList );
[ 21, 22, 23, 35, 37, 38 ]
gap> orders{ pos };
[ 12, 12, 12, 22, 24, 24 ]

##
gap> powermaps[2]{ [ 34, 35 ] };
[ 19, [ 19, 20 ] ]
gap> powermaps[2][35]:= 20;;

##
gap> powermaps[2]{ [ 21, 22, 23 ] }:= [ [ 9, 10 ], [ 9, 10 ], 11 ];;

##
gap> powermaps[2]{ [ 37, 38 ] }:= [ 22, 22 ];;

##
gap> poss:= [];;
gap> for cand in [ [ 9, 9 ], [ 9, 10 ], [ 10, 9 ] ] do
>   powermaps[2]{ [ 21, 22 ] }:= cand;
>   fus:= InitFusion( u, j4 );
>   TestConsistencyMaps( ComputedPowerMaps( u ), fus, powermaps );
>   indcyc:= InducedCyclic( j4, [ 21, 22 ], "all" );
>   possfus:= FusionsAllowedByRestrictions( u, j4, Irr( u ), indcyc, fus,
>        rec( maxlen:= 10, minamb:= 1, maxamb:= 10^6, quick:= false,
>             contained:= ContainedPossibleCharacters ) );
>   Add( poss, Length( possfus ) );
> od;
gap> poss;
[ 0, 0, 0 ]
gap> powermaps[2]{ [ 21, 22 ] }:= [ 10, 10 ];;

##
gap> pos:= Positions( orders, 24 );
[ 37, 38 ]
gap> setGaloisInfo( powermaps, pos, orders, primes, 1 );
gap> indcyc:= InducedCyclic( j4, pos, "all" );;
gap> ForAll( indcyc, x -> IsInt( ScalarProduct( j4, x, x ) ) );
false

##
gap> setGaloisInfo( powermaps, pos, orders, primes, Sqrt( 3 ) );

##
gap> indcyc:= InducedCyclic( j4, [ 2 .. NrConjugacyClasses( j4 ) ], "all" );;

##
gap> u:= CharacterTable( "J4M1" );
CharacterTable( "mx1j4" )
gap> fus:= InitFusion( u, j4 );
[ 1, [ 2, 3 ], 2, [ 2, 3 ], [ 2, 3 ], [ 2, 3 ], [ 2, 3 ], 4, 4, 5, [ 5, 6 ], 
  [ 5, 6 ], 7, [ 5, 6 ], [ 5, 6, 7 ], [ 5, 6, 7 ], [ 5, 6, 7 ], [ 5, 6, 7 ], 
  [ 5, 6, 7 ], [ 5, 6, 7 ], [ 5, 6, 7 ], [ 5, 6, 7 ], 8, 9, [ 9, 10, 11 ], 
  [ 9, 10, 11 ], [ 9, 10, 11 ], [ 9, 10, 11 ], [ 9, 10, 11 ], [ 9, 10, 11 ], 
  [ 9, 10, 11 ], [ 12, 13 ], [ 12, 13 ], 15, 16, [ 14, 15, 16 ], 
  [ 14, 15, 16 ], [ 14, 15, 16 ], [ 14, 15, 16 ], 17, [ 17, 18 ], [ 17, 18 ], 
  [ 17, 18 ], [ 19, 20 ], [ 21, 22 ], [ 21, 22 ], [ 21, 22, 23 ], 
  [ 21, 22, 23 ], [ 21, 22, 23 ], [ 21, 22, 23 ], [ 21, 22, 23 ], 
  [ 21, 22, 23 ], [ 26, 27 ], [ 26, 27 ], [ 24, 25, 26, 27 ], 
  [ 24, 25, 26, 27 ], 28, 28, 29, [ 30, 31 ], [ 30, 31 ], [ 32, 33 ], 
  [ 32, 33 ], [ 34, 35 ], 36, 36, [ 37, 38 ], [ 37, 38 ], [ 39, 40 ], 
  [ 39, 40 ], 42, 42 ]
gap> Print( AutomorphismsOfTable( u ), "\n" );
Group( [ (67,68), (65,66), (60,61), (57,58)(71,72), (57,58)(67,68)(71,72), 
  (57,58)(60,61)(71,72), (32,33)(53,54)(55,56)(62,63)(69,70), 
  ( 5, 6)(15,16)(21,22)(30,31)(42,43)(49,50)(51,52) ] )
gap> fus{ [ 60, 61, 67, 68, 69, 70 ] };
[ [ 30, 31 ], [ 30, 31 ], [ 37, 38 ], [ 37, 38 ], [ 39, 40 ], [ 39, 40 ] ]
gap> fus[60]:= 30;;
gap> fus[67]:= 37;;
gap> fus[69]:= 40;;
gap> TestConsistencyMaps( ComputedPowerMaps( u ), fus,
>        ComputedPowerMaps( j4 ) );
true

##
gap> irr:= [ TrivialCharacter( j4 ) ];;
gap> indcyc:= ReducedOrdinary( j4, irr, indcyc );;
gap> possfus:= FusionsAllowedByRestrictions( u, j4, Irr( u ),
>      indcyc.remainders, fus,
>      rec( maxlen:= 10, minamb:= 1, maxamb:= 10^3, quick:= false,
>           contained:= ContainedPossibleCharacters ) );;
gap> Length( possfus );
1440
gap> reps:= RepresentativesFusions( u, possfus, Group(()) );;
gap> Length( reps );
720

##
gap> reps:= Filtered( reps,
>      map -> ForAll( InducedClassFunctionsByFusionMap( u, j4, Irr(u), map ),
>                     x -> IsPosInt( ScalarProduct( j4, x, x ) ) ) );;
gap> Length( reps );
2
gap> inds:= List( reps,
>      map -> InducedClassFunctionsByFusionMap( u, j4, Irr( u ), map ) );;
gap> ForAll( Flat( MatScalarProducts( j4, inds[1], inds[1] ) ), IsInt );
false
gap> ForAll( Flat( MatScalarProducts( j4, inds[2], inds[2] ) ), IsInt );
true

##
gap> ind:= ReducedOrdinary( j4, irr, inds[2] );;
gap> Length( ind.irreducibles );
0
gap> lll:= LLL( j4, Concatenation( indcyc.remainders, ind.remainders ) );;
gap> Length( lll.irreducibles );
29
gap> Append( irr, lll.irreducibles );

##
gap> lll.norms;
[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 
  2, 2, 2, 2, 2, 2, 2 ]
gap> dn:= DnLatticeIterative( j4, lll.remainders );;
gap> Length( dn.irreducibles );
28
gap> Append( irr, dn.irreducibles );

##
gap> gram:= MatScalarProducts( j4, dn.remainders, dn.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 4 );;
gap> Length( emb.solutions );
3

##
gap> dec:= List( emb.solutions,
>                x -> Decreased( j4, dn.remainders, emb.vectors{ x } ) );;
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> Length( dec );
2

##
gap> possirr:= List( dec, x -> x.irreducibles );;
gap> chi:= possirr[1][1];;
gap> sym:= Symmetrizations( j4, [ chi ], 2 );;
gap> ForAll( sym, x -> IsInt( ScalarProduct( j4, x, chi ) ) );
false

##
gap> SetIrr( j4, List( Concatenation( irr, possirr[2] ),
>                      x -> Character( j4, x ) ) );
gap> IsRecord( TransformingPermutationsCharacterTables( lib, j4 ) );
true

##
gap> t:= CharacterTable( "2E6(2)" );;
gap> t2:= CharacterTable( "2E6(2).2" );;
gap> aut:= AutomorphismsOfTable( t );;
gap> Factors( Size( aut ) );
[ 2, 2, 2, 2, 2, 2, 2, 2, 3 ]
gap> syl:= SylowSubgroup( aut, 3 );;
gap> IsNormal( aut, syl );
true
gap> orbs:= Orbits( syl, [ 1 .. NrConjugacyClasses( t ) ] );;
gap> orbsalpha:= List( Filtered( orbs, l -> Length( l ) <> 1 ), Set );
[ [ 11, 12, 13 ], [ 16, 17, 18 ], [ 39, 40, 41 ], [ 43, 44, 45 ], 
  [ 46, 47, 48 ], [ 64, 65, 66 ], [ 67, 68, 69 ], [ 75, 76, 77 ], 
  [ 78, 79, 80 ], [ 88, 89, 90 ], [ 91, 92, 93 ], [ 94, 95, 96 ], 
  [ 114, 115, 116 ], [ 117, 118, 119 ] ]

##
gap> tfust2:= PossibleClassFusions( t, t2 );;
gap> poss:= Set( List( tfust2, l -> Filtered( InverseMap( l ), IsList ) ) );
[ [ [ 11, 12 ], [ 16, 17 ], [ 39, 40 ], [ 43, 44 ], [ 46, 47 ], [ 55, 56 ], 
      [ 61, 62 ], [ 64, 65 ], [ 67, 68 ], [ 75, 76 ], [ 78, 79 ], [ 88, 89 ], 
      [ 91, 92 ], [ 94, 95 ], [ 99, 100 ], [ 103, 104 ], [ 109, 110 ], 
      [ 114, 115 ], [ 117, 118 ], [ 123, 124 ], [ 125, 126 ] ], 
  [ [ 11, 13 ], [ 16, 18 ], [ 39, 41 ], [ 43, 45 ], [ 46, 48 ], [ 55, 56 ], 
      [ 61, 62 ], [ 64, 66 ], [ 67, 69 ], [ 75, 77 ], [ 78, 80 ], [ 88, 90 ], 
      [ 91, 93 ], [ 94, 96 ], [ 99, 100 ], [ 103, 104 ], [ 109, 110 ], 
      [ 114, 116 ], [ 117, 119 ], [ 123, 124 ], [ 125, 126 ] ], 
  [ [ 12, 13 ], [ 17, 18 ], [ 40, 41 ], [ 44, 45 ], [ 47, 48 ], [ 55, 56 ], 
      [ 61, 62 ], [ 65, 66 ], [ 68, 69 ], [ 76, 77 ], [ 79, 80 ], [ 89, 90 ], 
      [ 92, 93 ], [ 95, 96 ], [ 99, 100 ], [ 103, 104 ], [ 109, 110 ], 
      [ 115, 116 ], [ 118, 119 ], [ 123, 124 ], [ 125, 126 ] ] ]
gap> orbsbeta:= poss[3];;

##
gap> orders:= OrdersClassRepresentatives( t );;
gap> mustsplit:= PositionsProperty( orders, IsOddInt );
[ 1, 5, 6, 7, 23, 33, 34, 51, 52, 55, 56, 83, 86, 87, 97, 98, 103, 104, 107, 
  108, 123, 124, 125, 126 ]

##
gap> selfCentralizingClassesSplit:= function( t, mustsplit )
>      local centralizers, orders, i;
> 
>      centralizers:= SizesCentralizers( t );
>      orders:= OrdersClassRepresentatives( t );
>      for i in [ 1 .. Length( centralizers ) ] do
>        if centralizers[i] = orders[i] and not i in mustsplit then
>          Print( "#I  class ", i, " splits (self-centralizing)\n" );
>          AddSet( mustsplit, i );
>        fi;
>      od;
>    end;;
gap> selfCentralizingClassesSplit( t, mustsplit );
#I  class 109 splits (self-centralizing)
#I  class 110 splits (self-centralizing)
#I  class 120 splits (self-centralizing)
#I  class 122 splits (self-centralizing)

##
gap> oddRootsOfSplittingClassesSplit:= function( t, mustsplit )
>      local powmaps, found, p, map, i;
> 
>      powmaps:= ComputedPowerMaps( t );
>      repeat
>        found:= false;
>        for p in [ 1 .. Length( powmaps ) ] do
>          if p mod 2 = 1 and IsBound( powmaps[p] ) then
>            map:= powmaps[p];
>            for i in [ 1 .. Length( map ) ] do
>              if map[i] in mustsplit and not i in mustsplit then
>                Print( "#I  class ", i, " splits (",
>                       Ordinal( p ), " root of ", map[i], ")\n" );
>                found:= true;
>                AddSet( mustsplit, i );
>              fi;
>            od;
>          fi;
>        od;
>      until found = false;
>    end;;

##
gap> notSplittingClassesOfSubgroupDoNotSplit:= function( 2sfuss, sfust,
>                                                  mustnotsplit )
>      local new, i;
> 
>      new:= sfust{ PositionsProperty( InverseMap( 2sfuss ), IsInt ) };
>      for i in Set( new ) do
>        if not i in mustnotsplit then
>          Print( "#I  class ", i, " does not split (as in subgroup)\n" );
>        fi;
>      od;
>      UniteSet( mustnotsplit, new );
>    end;;

##
gap> splittingClassesWithOddCentralizerIndexSplit:= function( s, t,
>        sfust, 2sfuss, mustsplit )
>      local inv, scents, tcents, i;
> 
>      inv:= InverseMap( 2sfuss );
>      scents:= SizesCentralizers( s );
>      tcents:= SizesCentralizers( t );
>      for i in [ 1 .. Length( sfust ) ] do
>        if IsList( inv[i] ) and
>           IsOddInt( tcents[ sfust[i] ] / scents[i] ) then
>          if not sfust[i] in mustsplit then
>            Print( "#I  class ", sfust[i],
>                   " splits (odd centralizer index)\n" );
>            AddSet( mustsplit, sfust[i] );
>          fi;
>        fi;
>      od;
>      oddRootsOfSplittingClassesSplit( t, mustsplit );
>    end;;

##
gap> contributionData:= function( s, t, inv, chiprime, mustsplit )
>      local contrib, zeroonlyifnonsplit, safepart, n, tcents,
>            sclasses, i, j, val, choices, signs, cand;
> 
>      contrib:= [];
>      zeroonlyifnonsplit:= [];
>      safepart:= 0;
>      n:= 1;
>      tcents:= SizesCentralizers( t );
>      sclasses:= SizesConjugacyClasses( s );
>      for i in [ 1 .. Length( inv ) ] do
>        if IsBound( inv[i] ) then
>          # The subgroup contains elements in the 'i'-th class.
>          if IsInt( inv[i] ) then
>            # Only one class of the subgroup fuses into the 'i'-th class.
>            j:= inv[i];
>            val:= sclasses[j] * chiprime[j];
>            val:= tcents[i] / Size(s)^2 * val * GaloisCyc( val, -1 );
>            if not IsInt( val ) then
>              if i in mustsplit then
>                # The summand is known, add it to 'safepart'.
>                safepart:= safepart + val;
>              else
>                # The class may or may not split.
>                # If it splits then 'val' is the contribution to the norm.
>                contrib[i]:= [ 0, val ];
>                zeroonlyifnonsplit[i]:= true;
>                n:= n * 2;
>              fi;
>            fi;
>          else
>            # Several classes of the subgroup fuse into the 'i'-th class.
>            choices:= List( inv[i], j -> sclasses[j] * chiprime[j] );
>            signs:= Tuples( [ 1, -1 ], Length( choices ) );
>            cand:= signs * choices;
>            cand:= tcents[i] / Size(s)^2 *
>                     Set( List( cand, x -> x * GaloisCyc( x, -1 ) ) );
>            if not ForAll( cand, IsInt ) then
>              if Length( cand ) = 1 then
>                if i in mustsplit then
>                  # We get a contribution to 'safepart'.
>                  safepart:= safepart + cand[1];
>                else
>                  UniteSet( cand, [ 0 ] );
>                  contrib[i]:= cand;
>                  zeroonlyifnonsplit[i]:= true;
>                  n:= n * Length( cand );
>                fi;
>              else
>                if not i in mustsplit then
>                  if not 0 in cand then
>                    UniteSet( cand, [ 0 ] );
>                    zeroonlyifnonsplit[i]:= true;
>                  fi;
>                fi;
>                contrib[i]:= cand;
>                n:= n * Length( cand );
>              fi;
>            fi;
>          fi;
>        fi;
>      od;
> 
>      return rec( safepart:= safepart,
>                  contrib:= contrib,
>                  size:= n,
>                  bound:= Filtered( [ 1 .. Length( contrib ) ],
>                                    x -> IsBound( contrib[x] ) ),
>                  zeroonlyifnonsplit:= zeroonlyifnonsplit,
>                );
>    end;;

##
gap> integralContributions:= function( r )
>      local positions, len, images, number, index, direction, initial,
>            norm, solutions, i;
> 
>      # Initialize the counter and the list of solutions.
>      positions:= r.bound;
>      len:= Length( positions );
>      images:= r.contrib{ positions };
>      number:= List( images, Length );
>      index:= ListWithIdenticalEntries( len, 1 );
>      direction:= ShallowCopy( index );  # 1 means up, -1 means down
>      initial:= List( images, l -> l[1] );
>      norm:= r.safepart + Sum( initial );
>      solutions:= [];
>      if IsInt( norm ) then
>        solutions[1]:= initial;
>      fi;
> 
>      while true do
>        # Increase the counter. (Change only one position in each step.)
>        i:= 1;
>        while i <= len and
>              ( ( index[i] = number[i] and direction[i] = 1 ) or
>                ( index[i] = 1 and direction[i] = -1 ) ) do
>          direction[i]:= - direction[i];
>          i:= i+1;
>        od;
> 
>        if len < i then
>          # We are done.
>          return solutions;
>        fi;
> 
>        # Update at position 'i'.
>        norm:= norm - images[i][ index[i] ];
>        index[i]:= index[i] + direction[i];
>        norm:= norm + images[i][ index[i] ];
> 
>        if IsInt( norm ) then
>          # We have found a solution.
>          Add( solutions,
>               List( [ 1 .. len ], i -> images[i][ index[i] ] ) );
>        fi;
>      od;
>    end;;

##
gap> evaluateContributions:= function( r, res, sfust,
>                                      mustsplit, mustnotsplit )
>      local param, i, c;
> 
>      param:= Parametrized( res );
>      for i in [ 1 .. Length( r.bound ) ] do
>        c:= r.bound[i];
>        if param[i] = 0 then
>          # If contribution zero cannot arise as a sum of values
>          # then the class cannot split.
>          if IsBound( r.zeroonlyifnonsplit[c] ) and
>             r.zeroonlyifnonsplit[c] = true and
>             not c in mustnotsplit then
>            Print( "#I  class ", c,
>                   " does not split (contribution criterion)\n" );
>            if c in mustsplit then
>              Error( "contradiction for class ", c );
>            fi;
>            AddSet( mustnotsplit, c );
>          fi;
>        elif IsRat( param[i] ) then
>          if not c in mustsplit then
>            Print( "#I  class ", c, " splits (contribution criterion)\n" );
>            if c in mustnotsplit then
>              Error( "contradiction for class ", c );
>            fi;
>            AddSet( mustsplit, c );
>          fi;
>        elif IsList( param[i] ) and not 0 in param[i] then
>          # If no zero occurs then the class must split.
>          if not c in mustsplit then
>            Print( "#I  class ", c, " splits (contribution criterion)\n" );
>            if c in mustnotsplit then
>              Error( "contradiction for class ", c );
>            fi;
>            AddSet( mustsplit, c );
>          fi;
>        fi;
>      od;
>    end;;

##
gap> computeContributions:= function( s, t, sfust, classfuns, bound,
>                                     mustsplit, mustnotsplit )
>      local inv, i, known, candidates, r, res;
> 
>      inv:= InverseMap( sfust );
> 
>      repeat
>        for i in mustnotsplit do
>          # The induced character is zero at the preimage of 'i',
>          # there is no contribution to the norm.
>          Unbind( inv[i] );
>        od;
>        known:= [ ShallowCopy( mustsplit ), ShallowCopy( mustnotsplit ) ];
>        candidates:= List( classfuns,
>            chi -> contributionData( s, t, inv, chi, mustsplit ) );
>        candidates:= Filtered( candidates, r -> r.size < bound );
>        SortParallel( List( candidates, r -> r.size ), candidates );
>        for r in candidates do
>          res:= integralContributions( r );
>          if Length( res ) = 0 then
>            Error( "no solution" );
>          fi;
>          evaluateContributions( r, res, sfust, mustsplit, mustnotsplit );
>          oddRootsOfSplittingClassesSplit( t, mustsplit );
>        od;
>      until known = [ mustsplit, mustnotsplit ];
>    end;;

##
gap> s:= CharacterTable( "F4(2)" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> rep:= RepresentativesFusions( s, fus, Group( () ) );;
gap> Length( rep );
3
gap> oneorbit:= orbsalpha[1];
[ 11, 12, 13 ]
gap> List( rep, map -> Intersection( map, oneorbit ) );
[ [ 11 ], [ 12 ], [ 13 ] ]

##
gap> m3:= s;;  m3fust:= rep[1];;
gap> m4:= s;;  m4fust:= rep[2];;
gap> m5:= s;;  m5fust:= rep[3];;

##
gap> 2m3:= CharacterTable( "Cyclic", 2 ) * m3;;
gap> 2m4:= CharacterTable( "2.F4(2)" );;
gap> 2m5:= 2m4;;

##
gap> splittingClassesWithOddCentralizerIndexSplit( m3, t, m3fust,
>        GetFusionMap( 2m3, m3 ), mustsplit );
#I  class 73 splits (odd centralizer index)
#I  class 85 splits (odd centralizer index)
#I  class 101 splits (odd centralizer index)
#I  class 106 splits (odd centralizer index)
gap> splittingClassesWithOddCentralizerIndexSplit( m4, t, m4fust,
>        GetFusionMap( 2m4, m4 ), mustsplit );
gap> splittingClassesWithOddCentralizerIndexSplit( m5, t, m5fust,
>        GetFusionMap( 2m5, m5 ), mustsplit );
gap> mustnotsplit:= [];;
gap> notSplittingClassesOfSubgroupDoNotSplit( GetFusionMap( 2m4, m4 ),
>        m4fust, mustnotsplit );
#I  class 9 does not split (as in subgroup)
#I  class 12 does not split (as in subgroup)
#I  class 14 does not split (as in subgroup)
#I  class 17 does not split (as in subgroup)
#I  class 20 does not split (as in subgroup)
#I  class 21 does not split (as in subgroup)
#I  class 22 does not split (as in subgroup)
#I  class 44 does not split (as in subgroup)
#I  class 47 does not split (as in subgroup)
#I  class 49 does not split (as in subgroup)
#I  class 58 does not split (as in subgroup)
#I  class 68 does not split (as in subgroup)
#I  class 72 does not split (as in subgroup)
#I  class 79 does not split (as in subgroup)
#I  class 81 does not split (as in subgroup)
#I  class 82 does not split (as in subgroup)
#I  class 92 does not split (as in subgroup)
gap> notSplittingClassesOfSubgroupDoNotSplit( GetFusionMap( 2m5, m5 ),
>        m5fust, mustnotsplit );
#I  class 13 does not split (as in subgroup)
#I  class 18 does not split (as in subgroup)
#I  class 45 does not split (as in subgroup)
#I  class 48 does not split (as in subgroup)
#I  class 69 does not split (as in subgroup)
#I  class 80 does not split (as in subgroup)
#I  class 93 does not split (as in subgroup)

##
gap> computeContributions( m3, t, m3fust, Irr( m3 ), 10^7,
>        mustsplit, mustnotsplit );
#I  class 2 splits (contribution criterion)
#I  class 24 splits (3rd root of 2)
#I  class 25 splits (3rd root of 2)
#I  class 27 splits (3rd root of 2)
#I  class 99 splits (3rd root of 27)
#I  class 100 splits (3rd root of 27)
#I  class 53 splits (5th root of 2)
#I  class 8 splits (contribution criterion)
#I  class 63 splits (3rd root of 8)
#I  class 105 splits (5th root of 8)
#I  class 15 splits (contribution criterion)
#I  class 70 splits (3rd root of 15)
#I  class 4 does not split (contribution criterion)
#I  class 16 splits (contribution criterion)
#I  class 78 splits (3rd root of 16)
#I  class 59 splits (contribution criterion)
#I  class 30 splits (contribution criterion)
#I  class 102 splits (3rd root of 30)
#I  class 3 splits (contribution criterion)
#I  class 84 splits (contribution criterion)
#I  class 26 splits (3rd root of 3)
#I  class 28 splits (3rd root of 3)
#I  class 54 splits (5th root of 3)
#I  class 121 splits (5th root of 28)
#I  class 32 splits (contribution criterion)
#I  class 11 splits (contribution criterion)
#I  class 67 splits (contribution criterion)
#I  class 75 splits (contribution criterion)
#I  class 117 splits (contribution criterion)
#I  class 64 splits (3rd root of 11)
#I  class 71 does not split (contribution criterion)
gap> proj:= Filtered( Irr( 2m4 ), x -> x[1] <> x[2] );;
gap> projmap:= ProjectionMap( GetFusionMap( 2m4, m4 ) );;
gap> proj:= List( proj, x -> x{ projmap } );;
gap> computeContributions( m4, t, m4fust, proj, 10^7,
>        mustsplit, mustnotsplit );
#I  class 118 does not split (contribution criterion)
#I  class 31 splits (contribution criterion)
#I  class 29 does not split (contribution criterion)
gap> computeContributions( m5, t, m5fust, proj, 10^7,
>        mustsplit, mustnotsplit );
#I  class 119 does not split (contribution criterion)
gap> mustsplit;
[ 1, 2, 3, 5, 6, 7, 8, 11, 15, 16, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 
  34, 51, 52, 53, 54, 55, 56, 59, 63, 64, 67, 70, 73, 75, 78, 83, 84, 85, 86, 
  87, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 117, 
  120, 121, 122, 123, 124, 125, 126 ]
gap> mustnotsplit;
[ 4, 9, 12, 13, 14, 17, 18, 20, 21, 22, 29, 44, 45, 47, 48, 49, 58, 68, 69, 
  71, 72, 79, 80, 81, 82, 92, 93, 118, 119 ]

##
gap> invol:= Positions( orders, 2 );
[ 2, 3, 4 ]
gap> Difference( invol, m3fust );
[  ]

##
gap> open:= Difference( m3fust, Union( mustsplit, mustnotsplit ) );
[ 19, 35, 36, 39, 43, 46, 50, 91, 94, 111, 112, 114 ]

##
gap> orders{ open };
[ 4, 8, 8, 8, 8, 8, 8, 16, 16, 24, 24, 24 ]
gap> PowerMap( t, 3 ){ [ 111, 112, 114 ] };
[ 35, 36, 39 ]
gap> poss:= Filtered( Combinations( open ),
>               x -> ( not 35 in x or 111 in x ) and
>                    ( not 36 in x or 112 in x ) and
>                    ( not 39 in x or 114 in x ) );;
gap> Length( poss );
1728

##
gap> tableHead:= function( t, tosplit, invmustlift, invmaylift )
>      local tcents, orders, splcentralizers, spl, splorders, mustlift,
>            maylift, i, pow, ord;
> 
>      tcents:= SizesCentralizers( t );
>      orders:= OrdersClassRepresentatives( t );
>      splcentralizers:= [];
>      spl:= [];
>      splorders:= [];
>      mustlift:= ShallowCopy( invmustlift );
>      maylift:= ShallowCopy( invmaylift );
> 
>      if invmaylift <> [] or invmustlift <> [] then
>        for i in [ 2 .. NrConjugacyClasses( t ) ] do
>          if orders[i] mod 2 = 0 then
>            pow:= PowerMap( t, orders[i] / 2 )[i];
>            if pow in invmustlift then
>              Add( mustlift, i );
>            elif pow in invmaylift then
>              Add( maylift, i );
>            fi;
>          fi;
>        od;
>      fi;
> 
>      for i in [ 1 .. NrConjugacyClasses( t ) ] do
>        ord:= orders[i];
>        if i in tosplit then
>          Append( spl, [ i, i ] );
>          Append( splcentralizers, tcents[i] * [ 2, 2 ] );
>          if orders[i] mod 2 = 1 then
>            Append( splorders, [ ord, 2 * ord ] );
>          elif i in mustlift then
>            Append( splorders, [ 2 * ord, 2 * ord ] );
>          elif i in maylift then
>            Append( splorders, [ [ ord, 2 * ord ], [ ord, 2 * ord ] ] );
>          else
>            Append( splorders, [ ord, ord ] );
>          fi;
>        else
>          Add( spl, i );
>          Add( splcentralizers, tcents[i] );
>          if i in mustlift then
>            Add( splorders, 2 * ord );
>          elif i in maylift then
>            Add( splorders, [ ord, 2 * ord ] );
>          else
>            Add( splorders, ord );
>          fi;
>        fi;
>      od;
> 
>      return ConvertToCharacterTableNC( rec(
>                 UnderlyingCharacteristic:= 0,
>                 OrdersClassRepresentatives:= splorders,
>                 SizesCentralizers:= splcentralizers,
>                 Size:= splcentralizers[1],
>                 ComputedClassFusions:= [ rec( name:= Identifier( t ),
>                     map:= spl ) ],
>               ) );
>  end;;

##
gap> initialFusion:= function( 2s, 2t, 2sfuss, 2tfust, sfust, defined )
>      local fus, comp, pre, imgs;
> 
>      # Use element orders and centralizer orders.
>      fus:= InitFusion( 2s, 2t );
> 
>      # Use the commutative diagram.
>      comp:= CompositionMaps( InverseMap( 2tfust ),
>                              CompositionMaps( sfust, 2sfuss ) );
>      if MeetMaps( fus, comp ) <> true then
>        return fail;
>      fi;
> 
>      # Define classes that are not yet defined.
>      defined:= ShallowCopy( defined );
>      for pre in InverseMap( 2sfuss ) do
>        if IsList( pre ) then
>          imgs:= fus{ pre };
>          if imgs[1] = imgs[2] and IsList( imgs[1] ) then
>            if Intersection( defined, 2tfust{ imgs[1] } ) = [] then
>              # The classes in preimage and image split, and we may choose.
>              fus[ pre[1] ]:= imgs[1][1];
>              fus[ pre[2] ]:= imgs[1][2];
>              UniteSet( defined, 2tfust{ imgs[1] } );
>            fi;
>          fi;
>        elif IsList( fus[ pre ] ) then
>          # The class splits in the image but not in the preimage,
>          # we should have noticed this earlier.
>          return fail;
>        fi;
>      od;
> 
>      return fus;
>    end;;

##
gap> useInducedClassFunction:= function( 2s, 2t, chi, 2sfuss, 2sfus2t )
>      local localfus, unknown, i, swaps, inv, pair, poss, choices, choice,
>            map, ind, para, new;
> 
>      # Remove indet. in places where the character is zero.
>      localfus:= ShallowCopy( 2sfus2t );
>      unknown:= [];
>      for i in [ 1 .. Length( 2sfus2t ) ] do
>        if IsList( 2sfus2t[i] ) then
>          if chi[i] = 0 then
>            localfus[i]:= localfus[i][1];
>          else
>            Add( unknown, i );
>          fi;
>        fi;
>      od;
> 
>      # Collect the possible swaps.
>      swaps:= [];
>      inv:= InverseMap( 2sfuss );
>      for i in [ 1 .. Length( localfus ) ] do
>        if IsList( localfus[i] ) then
>          pair:= inv[ 2sfuss[i] ];
>          Add( swaps, ( pair[1], pair[2] ) );
>          localfus{ pair }:= localfus[i];
>        fi;
>      od;
> 
>      # Try all possibilities (hopefully not too many).
>      poss:= [];
>      if IsEmpty( swaps ) then
>        choices:= [ [] ];
>      else
>        choices:= IteratorOfCombinations( swaps );
>      fi;
>      for choice in choices do
>        map:= Permuted( localfus, Product( choice, () ) );
>        ind:= InducedClassFunctionsByFusionMap( 2s, 2t, [ chi ], map )[1];
>        if IsInt( ScalarProduct( 2t, ind, ind ) ) then
>          Add( poss, map );
>        fi;
>      od;
> 
>      if poss = [] then
>        return false;
>      fi;
> 
>      para:= Parametrized( poss );
>      new:= Filtered( unknown, i -> IsInt( para[i] ) );
>      if new <> [] then
>        2sfus2t{ new }:= para{ new };
>      fi;
> 
>      return true;
>    end;;

##
gap> good:= [];;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m3, m3 ) );;
gap> testcharsm3:= Filtered( Irr( 2m3 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> runOneTest:= function( s, 2s, t, 2t, sfust, testchars, defined )
>      local fus, pos, l, chi;
>      fus:= initialFusion( 2s, 2t, GetFusionMap( 2s, s ),
>                           GetFusionMap( 2t, t ), sfust, defined );
>      # Process the irreducible characters,
>      # ordered by increasing indeterminateness.
>      pos:= PositionsProperty( fus, IsList );
>      testchars:= ShallowCopy( testchars );
>      l:= - List( testchars, x -> Number( pos, i -> x[i] = 0 ) );
>      SortParallel( l, testchars );
>      for chi in testchars do
>        if useInducedClassFunction( 2s, 2t, chi, GetFusionMap( 2s, s ),
>                                    fus ) = false then
>          # This splitting is not possible.
>          return fail;
>        fi;
>      od;
>      return fus;
>    end;;
gap> defined:= [];;
gap> for choice in poss do
>      2t:= tableHead( t, Union( mustsplit, choice ), [], [] );
>      fus:= runOneTest( m3, 2m3, t, 2t, m3fust, testcharsm3, defined );
>      if fus <> fail then
>        Add( good, choice );
>      fi;
>    od;
gap> Length( good );
1

##
gap> choice:= good[1];
[ 19, 36, 39, 43, 46, 50, 91, 94, 111, 112, 114 ]
gap> UniteSet( mustsplit, choice );
gap> oddRootsOfSplittingClassesSplit( t, mustsplit );
#I  class 74 splits (3rd root of 19)
#I  class 76 splits (3rd root of 19)
#I  class 77 splits (3rd root of 19)
gap> UniteSet( mustnotsplit, Difference( open, choice ) );
gap> Difference( [ 1 .. Length( orders ) ],
>                Union( mustsplit, mustnotsplit ) );
[ 10, 37, 38, 40, 41, 42, 57, 60, 61, 62, 65, 66, 88, 89, 90, 95, 96, 113, 
  115, 116 ]
gap> 2t:= tableHead( t, mustsplit, [], [] );;
gap> NrConjugacyClasses( 2t );
202
gap> 2m3fus2t:= runOneTest( m3, 2m3, t, 2t, m3fust, testcharsm3, defined );
[ 1, 3, 5, 5, 7, 8, 10, 12, 16, 18, 14, 18, 23, 23, 22, 25, 26, 31, 23, 29, 
  31, 32, 33, 34, 36, 44, 40, 38, 42, 47, 40, 44, 46, 49, 51, 55, 53, 71, 71, 
  57, 62, 58, 63, 67, 71, 68, 75, 76, 80, 78, 82, 84, 84, 99, 92, 91, 103, 
  107, 111, 107, 111, 99, 97, 109, 111, 110, 121, 115, 125, 126, 127, 131, 
  129, 135, 133, 144, 145, 140, 140, 148, 150, 156, 158, 166, 166, 170, 168, 
  181, 176, 182, 178, 189, 185, 193, 191, 2, 4, 6, 6, 7, 9, 11, 13, 16, 19, 
  15, 19, 24, 24, 22, 26, 25, 31, 24, 30, 31, 32, 33, 35, 37, 45, 41, 39, 43, 
  48, 41, 45, 46, 50, 52, 56, 54, 72, 72, 57, 63, 59, 62, 68, 72, 67, 75, 77, 
  81, 79, 83, 85, 85, 100, 93, 91, 104, 108, 112, 108, 112, 100, 98, 109, 
  112, 110, 122, 116, 125, 126, 128, 132, 130, 136, 134, 145, 144, 141, 141, 
  149, 151, 157, 159, 167, 167, 171, 169, 182, 177, 181, 179, 190, 186, 194, 
  192 ]
gap> defined:= Set( m3fust );;

##
gap> ind2m3:= InducedClassFunctionsByFusionMap( 2m3, 2t, testcharsm3,
>                 2m3fus2t );;

##
gap> s:= CharacterTable( "Fi22" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> rep:= RepresentativesFusions( s, fus, Group( () ) );;
gap> Length( rep );
3
gap> List( rep, map -> Intersection( map, oneorbit ) );
[ [ 11 ], [ 12 ], [ 13 ] ]

##
gap> m7:= s;;  m7fust:= rep[1];;
gap> m8:= s;;  m8fust:= rep[2];;
gap> m9:= s;;  m9fust:= rep[3];;

##
gap> open:= Difference( m7fust, Union( mustsplit, mustnotsplit ) );
[  ]
gap> 2s:= CharacterTable( "2.Fi22" );;
gap> initialFusion( 2s, 2t, GetFusionMap( 2s, m7 ),
>        GetFusionMap( 2t, t ), m7fust, defined );
fail

##
gap> 2m7:= CharacterTable( "Cyclic", 2 ) * m7;;

##
gap> parametersFABR:= rec( maxlen:= 10, minamb:= 1, maxamb:= 10^6,
>        quick:= false, contained:= ContainedPossibleCharacters );;

##
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m7, m7 ) );;
gap> testcharsm7:= Filtered( Irr( 2m7 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> fus:= initialFusion( 2m7, 2t, GetFusionMap( 2m7, m7 ),
>              GetFusionMap( 2t, t ), m7fust, defined );;
gap> possfus:= FusionsAllowedByRestrictions( 2m7, 2t, testcharsm7,
>                  ind2m3, fus, parametersFABR );
[ [ 1, 4, 5, 7, 8, 12, 10, 12, 18, 24, 26, 29, 31, 34, 37, 43, 47, 40, 39, 
      46, 52, 49, 44, 50, 51, 55, 63, 62, 68, 75, 78, 80, 80, 83, 84, 86, 88, 
      103, 99, 99, 108, 117, 119, 113, 122, 109, 112, 115, 127, 127, 132, 
      135, 140, 140, 152, 154, 157, 158, 167, 170, 172, 174, 181, 182, 194, 
      2, 3, 6, 7, 9, 13, 11, 13, 19, 23, 25, 30, 31, 35, 36, 42, 48, 41, 38, 
      46, 51, 50, 45, 49, 52, 56, 62, 63, 67, 75, 79, 81, 81, 82, 85, 87, 89, 
      104, 100, 100, 107, 118, 120, 114, 121, 109, 111, 116, 128, 128, 131, 
      136, 141, 141, 153, 155, 156, 159, 166, 171, 173, 175, 182, 181, 193 ], 
  [ 1, 4, 5, 7, 8, 12, 10, 12, 18, 24, 26, 29, 31, 34, 37, 43, 47, 40, 39, 
      46, 52, 49, 44, 50, 51, 55, 62, 63, 68, 75, 78, 80, 80, 83, 84, 86, 88, 
      103, 99, 99, 108, 117, 119, 113, 122, 109, 112, 115, 127, 127, 132, 
      135, 140, 140, 152, 154, 157, 158, 167, 170, 172, 174, 182, 181, 194, 
      2, 3, 6, 7, 9, 13, 11, 13, 19, 23, 25, 30, 31, 35, 36, 42, 48, 41, 38, 
      46, 51, 50, 45, 49, 52, 56, 63, 62, 67, 75, 79, 81, 81, 82, 85, 87, 89, 
      104, 100, 100, 107, 118, 120, 114, 121, 109, 111, 116, 128, 128, 131, 
      136, 141, 141, 153, 155, 156, 159, 166, 171, 173, 175, 181, 182, 193 ] ]
gap> poss2m7fus2t:= possfus;;
gap> UniteSet( defined, Set( m7fust ) );
gap> possind2m7:= List( poss2m7fus2t,
>        map -> Set( InducedClassFunctionsByFusionMap( 2m7, 2t,
>                        testcharsm7, map ) ) );;
gap> List( possind2m7, Length );
[ 63, 63 ]
gap> Length( Intersection( possind2m7 ) );
39

##
gap> 2s:= 2m7;
CharacterTable( "C2xFi22" )
gap> open:= Difference( m8fust, Union( mustsplit, mustnotsplit ) );
[ 40, 65, 115 ]
gap> good:= [];;
gap> for choice in Combinations( open ) do
>      2t:= tableHead( t, Union( mustsplit, choice ), [], [] );
>      fus:= initialFusion( 2s, 2t, GetFusionMap( 2s, m8 ),
>                GetFusionMap( 2t, t ), m8fust, defined );;
>      if FusionsAllowedByRestrictions( 2s, 2t, testcharsm7, ind2m3, fus,
>             parametersFABR ) <> [] then
>        Add( good, choice );
>      fi;
>    od;
gap> good;
[  ]

##
gap> 2m8:= CharacterTable( "2.Fi22" );;

##
gap> notSplittingClassesOfSubgroupDoNotSplit( GetFusionMap( 2m8, m8 ),
> m8fust, mustnotsplit );
#I  class 40 does not split (as in subgroup)
#I  class 65 does not split (as in subgroup)
#I  class 115 does not split (as in subgroup)
gap> 2t:= tableHead( t, mustsplit, [], [] );;

##
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m8, m8 ) );;
gap> testcharsm8:= Filtered( Irr( 2m8 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> fus:= initialFusion( 2m8, 2t, GetFusionMap( 2m8, m8 ),
>        GetFusionMap( 2t, t ), m8fust, defined );;
gap> ind:= Concatenation( ind2m3, Intersection( possind2m7 ) );;
gap> possfus:= FusionsAllowedByRestrictions( 2m8, 2t, testcharsm8, ind,
>        fus, parametersFABR );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 10, 11, 12, 13, 20, 23, 24, 27, 29, 
      30, 31, 34, 35, 36, 37, 42, 43, 47, 48, 40, 41, 38, 39, 46, 51, 52, 49, 
      50, 44, 45, 49, 50, 51, 52, 55, 56, 64, 64, 69, 75, 75, 78, 79, 80, 81, 
      80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 105, 101, 101, 101, 107, 108, 
      116, 115, 120, 119, 113, 114, 123, 109, 111, 112, 117, 118, 127, 128, 
      127, 128, 131, 132, 135, 136, 142, 142, 153, 152, 155, 154, 156, 157, 
      158, 159, 166, 167, 170, 171, 173, 172, 175, 174, 183, 183, 193, 194 ] ]
gap> 2m8fus2t:= possfus[1];;
gap> UniteSet( defined, m8fust );
gap> ind2m8:= InducedClassFunctionsByFusionMap( 2m8, 2t, testcharsm8,
>                 2m8fus2t );;

##
gap> Filtered( orbsbeta, l -> Intersection( l, [ 40, 65, 115 ] ) <> [] );
[ [ 40, 41 ], [ 65, 66 ], [ 115, 116 ] ]
gap> UniteSet( mustnotsplit, [ 41, 66, 116 ] );
gap> open:= Difference( m9fust, Union( mustsplit, mustnotsplit ) );
[  ]
gap> 2m9:= 2m8;;
gap> testcharsm9:= testcharsm8;;
gap> fus:= initialFusion( 2m9, 2t, GetFusionMap( 2m9, m9 ),
>        GetFusionMap( 2t, t ), m9fust, defined );;
gap> ind:= Concatenation( ind2m3, Intersection( possind2m7 ), ind2m8 );;
gap> possfus:= FusionsAllowedByRestrictions( 2m9, 2t, testcharsm9, ind,
>        fus, parametersFABR );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 10, 11, 12, 13, 21, 23, 24, 28, 29, 
      30, 31, 34, 35, 36, 37, 42, 43, 47, 48, 40, 41, 38, 39, 46, 51, 52, 49, 
      50, 44, 45, 49, 50, 51, 52, 55, 56, 65, 65, 70, 75, 75, 78, 79, 80, 81, 
      80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 106, 102, 102, 102, 107, 108, 
      116, 115, 118, 117, 113, 114, 124, 109, 111, 112, 119, 120, 127, 128, 
      127, 128, 131, 132, 135, 136, 143, 143, 153, 152, 155, 154, 156, 157, 
      158, 159, 166, 167, 170, 171, 173, 172, 175, 174, 184, 184, 193, 194 ] ]
gap> 2m9fus2t:= possfus[1];;
gap> UniteSet( defined, m9fust );
gap> ind2m9:= InducedClassFunctionsByFusionMap( 2m9, 2t, testcharsm9,
>                 2m9fus2t );;

##
gap> open:= Difference( m4fust, Union( mustsplit, mustnotsplit ) );
[ 95 ]
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m4, m4 ) );;
gap> testcharsm4:= Filtered( Irr( 2m4 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> good:= [];;
gap> for choice in Combinations( open ) do
>      2t:= tableHead( t, Union( mustsplit, choice ), [], [] );
>      fus:= runOneTest( m4, 2m4, t, 2t, m4fust, testcharsm4, [] );
>      if fus <> fail then
>        Add( good, [ choice, 2t ] );
>      fi;
>    od;
gap> List( good, l -> l[1] );
[ [  ] ]
gap> UniteSet( mustnotsplit, open );
gap> 2t:= good[1][2];;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> fus:= initialFusion( 2m4, 2t, GetFusionMap( 2m4, m4 ),
>                         2tfust, m4fust, defined );;
gap> ind:= Concatenation( ind2m3, Intersection( possind2m7 ), ind2m8,
>                         ind2m9 );;
gap> possfus:= FusionsAllowedByRestrictions( 2m4, 2t, testcharsm4, ind,
>        fus, parametersFABR );
[ [ 1, 2, 3, 4, 6, 5, 5, 6, 7, 7, 8, 9, 10, 11, 12, 13, 16, 20, 14, 15, 20, 
      20, 24, 23, 24, 23, 22, 27, 27, 27, 31, 31, 23, 24, 29, 30, 31, 32, 33, 
      34, 35, 36, 37, 45, 44, 41, 40, 38, 39, 42, 43, 48, 47, 40, 41, 44, 45, 
      46, 46, 50, 49, 52, 51, 55, 56, 53, 54, 73, 73, 73, 57, 57, 64, 64, 58, 
      59, 64, 64, 69, 73, 69, 75, 76, 77, 80, 81, 78, 79, 82, 83, 85, 84, 84, 
      85, 101, 101, 92, 93, 91, 105, 108, 107, 112, 111, 108, 107, 112, 111, 
      101, 101, 97, 98, 109, 109, 111, 112, 110, 123, 117, 118, 125, 126, 
      127, 128, 131, 132, 130, 129, 135, 136, 133, 134, 146, 146, 146, 146, 
      142, 142, 148, 149, 150, 151, 156, 157, 159, 158, 167, 166, 167, 166, 
      170, 171, 168, 169, 183, 183, 177, 176, 183, 183, 178, 179, 189, 190, 
      187, 187, 194, 193, 192, 191 ] ]
gap> 2m4fus2t:= possfus[1];;
gap> UniteSet( defined, Set( m4fust ) );
gap> ind2m4:= InducedClassFunctionsByFusionMap( 2m4, 2t, testcharsm4,
>                 2m4fus2t );;

##
gap> open:= Difference( m5fust, Union( mustsplit, mustnotsplit ) );
[ 96 ]
gap> UniteSet( mustnotsplit, open );

##
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m5, m5 ) );;
gap> testcharsm5:= Filtered( Irr( 2m5 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> fus:= initialFusion( 2m5, 2t, GetFusionMap( 2m5, m5 ),
>              GetFusionMap( 2t, t ), m5fust, defined );;
gap> ind:= Concatenation( ind2m3, Intersection( possind2m7 ), ind2m8,
>              ind2m9, ind2m4 );;
gap> possfus:= FusionsAllowedByRestrictions( 2m5, 2t, testcharsm5,
>                  ind, fus, parametersFABR );
[ [ 1, 2, 3, 4, 6, 5, 5, 6, 7, 7, 8, 9, 10, 11, 12, 13, 16, 21, 14, 15, 21, 
      21, 24, 23, 24, 23, 22, 28, 28, 28, 31, 31, 23, 24, 29, 30, 31, 32, 33, 
      34, 35, 36, 37, 45, 44, 41, 40, 38, 39, 42, 43, 48, 47, 40, 41, 44, 45, 
      46, 46, 50, 49, 52, 51, 55, 56, 53, 54, 74, 74, 74, 57, 57, 65, 65, 58, 
      59, 65, 65, 70, 74, 70, 75, 76, 77, 80, 81, 78, 79, 82, 83, 85, 84, 84, 
      85, 102, 102, 92, 93, 91, 106, 108, 107, 112, 111, 108, 107, 112, 111, 
      102, 102, 97, 98, 109, 109, 111, 112, 110, 124, 119, 120, 125, 126, 
      127, 128, 131, 132, 130, 129, 135, 136, 133, 134, 147, 147, 147, 147, 
      143, 143, 148, 149, 150, 151, 156, 157, 159, 158, 167, 166, 167, 166, 
      170, 171, 168, 169, 184, 184, 177, 176, 184, 184, 178, 179, 189, 190, 
      188, 188, 194, 193, 192, 191 ] ]
gap> 2m5fus2t:= possfus[1];;
gap> UniteSet( defined, Set( m5fust ) );
gap> ind2m5:= InducedClassFunctionsByFusionMap( 2m5, 2t, testcharsm5,
>                 2m5fus2t );;

##
gap> s:= CharacterTable( "U6(2)" );;
gap> InitFusion( CharacterTable( "C6" ) * s, 2t );
fail

##
gap> 2s:= CharacterTable( "2.U6(2)" );;
gap> 2u12:= CharacterTable( "C3" ) * 2s;;
gap> orders2u12:= OrdersClassRepresentatives( 2u12 );;
gap> inv:= First( ClassPositionsOfCentre( 2u12 ), 
>                 i -> orders2u12[i] = 2 );;
gap> ker:= [ 1, inv ];;
gap> u12:= 2u12 / ker;;
gap> testcharsu12:= Filtered( Irr( 2u12 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;

##
gap> fus:= PossibleClassFusions( u12, t );;
gap> rep:= RepresentativesFusions( u12, fus, Group( () ) );;
gap> Length( rep );
2
gap> possu12fust:= rep;;

##
gap> List( possu12fust, map -> Difference( map,
>                         Union( mustsplit, mustnotsplit ) ) );
[ [ 10, 37, 57, 60, 61, 62, 113 ], [ 10, 37, 57, 60, 61, 62, 113 ] ]
gap> possnotsplit:= List( [ 1, 2 ], i -> ShallowCopy( mustnotsplit ) );;
gap> for i in [ 1, 2 ] do
>      notSplittingClassesOfSubgroupDoNotSplit(
>          GetFusionMap( 2u12, u12 ), rep[i], possnotsplit[i] );
>    od;
#I  class 10 does not split (as in subgroup)
#I  class 37 does not split (as in subgroup)
#I  class 57 does not split (as in subgroup)
#I  class 60 does not split (as in subgroup)
#I  class 61 does not split (as in subgroup)
#I  class 62 does not split (as in subgroup)
#I  class 113 does not split (as in subgroup)
#I  class 10 does not split (as in subgroup)
#I  class 37 does not split (as in subgroup)
#I  class 57 does not split (as in subgroup)
#I  class 60 does not split (as in subgroup)
#I  class 61 does not split (as in subgroup)
#I  class 62 does not split (as in subgroup)
#I  class 113 does not split (as in subgroup)
gap> Set( possnotsplit );
[ [ 4, 9, 10, 12, 13, 14, 17, 18, 20, 21, 22, 29, 35, 37, 40, 41, 44, 45, 47, 
      48, 49, 57, 58, 60, 61, 62, 65, 66, 68, 69, 71, 72, 79, 80, 81, 82, 92, 
      93, 95, 96, 113, 115, 116, 118, 119 ] ]
gap> mustnotsplit:= possnotsplit[1];;

##
gap> s:= CharacterTable( "O10-(2)" );;
gap> fus:= PossibleClassFusions( s, t );;
gap> rep:= RepresentativesFusions( s, fus, Group( () ) );;
gap> Length( rep );
2
gap> m10:= s;;  possm10fust:= rep;;

##
gap> 2m10:= CharacterTable( "Cyclic", 2 ) * m10;;

##
gap> List( possm10fust, map -> Difference( map,
>                         Union( mustsplit, mustnotsplit ) ) );
[ [ 42 ], [ 42 ] ]
gap> possnotsplit:= List( [ 1, 2 ], i -> ShallowCopy( mustnotsplit ) );;
gap> for i in [ 1, 2 ] do
>      computeContributions( m10, t, possm10fust[i], Irr( m10 ), 10^7,
>          ShallowCopy( mustsplit ), possnotsplit[i] );
>    od;
#I  class 42 does not split (contribution criterion)
#I  class 42 does not split (contribution criterion)
gap> Set( possnotsplit );
[ [ 4, 9, 10, 12, 13, 14, 17, 18, 20, 21, 22, 29, 35, 37, 40, 41, 42, 44, 45, 
      47, 48, 49, 57, 58, 60, 61, 62, 65, 66, 68, 69, 71, 72, 79, 80, 81, 82, 
      92, 93, 95, 96, 113, 115, 116, 118, 119 ] ]
gap> mustnotsplit:= possnotsplit[1];;

##
gap> fus:= List( rep, map -> initialFusion( 2m10, 2t,
>                 GetFusionMap( 2m10, m10 ), GetFusionMap( 2t, t ),
>                 map, defined ) );;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2m10, m10 ) );;
gap> testcharsm10:= Filtered( Irr( 2m10 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> ind:= Concatenation( ind2m3, ind2m4, ind2m5,
>              Intersection( possind2m7 ), ind2m8, ind2m9 );;
gap> possfus:= List( fus, map -> FusionsAllowedByRestrictions( 2m10, 2t,
>                  testcharsm10, ind, map, parametersFABR ) );
[ [ [ 1, 3, 5, 5, 7, 10, 8, 8, 8, 10, 12, 16, 14, 17, 23, 22, 23, 31, 29, 33, 
          34, 34, 38, 36, 36, 36, 44, 44, 44, 40, 40, 36, 49, 42, 42, 38, 40, 
          42, 47, 40, 44, 47, 47, 46, 51, 53, 58, 57, 60, 66, 75, 76, 78, 78, 
          78, 78, 82, 84, 84, 86, 88, 92, 90, 90, 97, 94, 94, 90, 111, 111, 
          111, 92, 91, 94, 107, 107, 113, 107, 95, 96, 111, 110, 109, 129, 
          133, 133, 133, 135, 133, 135, 135, 148, 150, 153, 155, 153, 155, 
          158, 164, 166, 168, 178, 176, 180, 180, 191, 191, 191, 193, 195, 
          197, 197, 195, 199, 201, 2, 4, 6, 6, 7, 11, 9, 9, 9, 11, 13, 16, 
          15, 17, 24, 22, 24, 31, 30, 33, 35, 35, 39, 37, 37, 37, 45, 45, 45, 
          41, 41, 37, 50, 43, 43, 39, 41, 43, 48, 41, 45, 48, 48, 46, 52, 54, 
          59, 57, 60, 66, 75, 77, 79, 79, 79, 79, 83, 85, 85, 87, 89, 93, 90, 
          90, 98, 94, 94, 90, 112, 112, 112, 93, 91, 94, 108, 108, 114, 108, 
          95, 96, 112, 110, 109, 130, 134, 134, 134, 136, 134, 136, 136, 149, 
          151, 152, 154, 152, 154, 159, 165, 167, 169, 179, 177, 180, 180, 
          192, 192, 192, 194, 196, 198, 198, 196, 200, 202 ] ], 
  [ [ 1, 3, 5, 5, 7, 10, 8, 8, 8, 10, 12, 16, 14, 17, 23, 22, 23, 31, 29, 33, 
          34, 34, 38, 36, 36, 36, 44, 44, 44, 40, 40, 36, 49, 42, 42, 38, 40, 
          42, 47, 40, 44, 47, 47, 46, 51, 53, 58, 57, 60, 66, 75, 76, 78, 78, 
          78, 78, 82, 84, 84, 86, 88, 92, 90, 90, 97, 94, 94, 90, 111, 111, 
          111, 92, 91, 94, 107, 107, 113, 107, 95, 96, 111, 110, 109, 129, 
          133, 133, 133, 135, 133, 135, 135, 148, 150, 155, 153, 155, 153, 
          158, 164, 166, 168, 178, 176, 180, 180, 191, 191, 191, 193, 195, 
          197, 197, 195, 199, 201, 2, 4, 6, 6, 7, 11, 9, 9, 9, 11, 13, 16, 
          15, 17, 24, 22, 24, 31, 30, 33, 35, 35, 39, 37, 37, 37, 45, 45, 45, 
          41, 41, 37, 50, 43, 43, 39, 41, 43, 48, 41, 45, 48, 48, 46, 52, 54, 
          59, 57, 60, 66, 75, 77, 79, 79, 79, 79, 83, 85, 85, 87, 89, 93, 90, 
          90, 98, 94, 94, 90, 112, 112, 112, 93, 91, 94, 108, 108, 114, 108, 
          95, 96, 112, 110, 109, 130, 134, 134, 134, 136, 134, 136, 136, 149, 
          151, 154, 152, 154, 152, 159, 165, 167, 169, 179, 177, 180, 180, 
          192, 192, 192, 194, 196, 198, 198, 196, 200, 202 ] ] ]
gap> List( possfus, Length );
[ 1, 1 ]
gap> poss2m10fus2t:= Concatenation( possfus );;
gap> Set( possm10fust[1] ) = Set( possm10fust[2] );
true
gap> UniteSet( defined, possm10fust[1] );

##
gap> possind2m10:= List( poss2m10fus2t,
>        map -> Set( InducedClassFunctionsByFusionMap( 2m10, 2t,
>                        testcharsm10, map ) ) );;
gap> possind2m10[1] = possind2m10[2];
true
gap> ind2m10:= possind2m10[1];;

##
gap> fus:= List( possu12fust, map -> initialFusion( 2u12, 2t,
>                 GetFusionMap( 2u12, u12 ), GetFusionMap( 2t, t ),
>                 map, defined ) );;
gap> ind:= Concatenation( ind2m3, ind2m4, ind2m5,
>              Intersection( possind2m7 ), ind2m8, ind2m9, ind2m10 );;
gap> possfus:= List( fus, map -> FusionsAllowedByRestrictions( 2u12, 2t,
>                  testcharsu12, ind, map, parametersFABR ) );
[ [ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 10, 11, 16, 17, 18, 19, 20, 21, 23, 
          24, 31, 34, 35, 42, 43, 42, 43, 36, 37, 47, 48, 40, 41, 38, 39, 44, 
          45, 49, 50, 55, 56, 60, 62, 63, 64, 65, 78, 79, 78, 79, 80, 81, 82, 
          83, 86, 87, 88, 89, 91, 91, 90, 90, 95, 96, 103, 104, 105, 106, 
          107, 108, 135, 136, 153, 152, 155, 154, 8, 9, 36, 37, 40, 41, 46, 
          10, 11, 8, 9, 12, 13, 90, 94, 99, 100, 101, 102, 107, 108, 109, 
          135, 136, 36, 37, 36, 37, 38, 39, 40, 41, 44, 45, 42, 43, 47, 48, 
          51, 52, 170, 171, 180, 181, 182, 183, 184, 78, 79, 78, 79, 80, 81, 
          193, 194, 195, 196, 197, 198, 90, 90, 92, 93, 94, 94, 99, 100, 101, 
          102, 111, 112, 133, 134, 153, 152, 155, 154, 8, 9, 36, 37, 40, 41, 
          46, 10, 11, 8, 9, 12, 13, 90, 94, 99, 100, 101, 102, 107, 108, 109, 
          135, 136, 36, 37, 36, 37, 38, 39, 40, 41, 44, 45, 42, 43, 47, 48, 
          51, 52, 170, 171, 180, 181, 182, 183, 184, 78, 79, 78, 79, 80, 81, 
          193, 194, 195, 196, 197, 198, 90, 90, 92, 93, 94, 94, 99, 100, 101, 
          102, 111, 112, 133, 134, 153, 152, 155, 154 ] ], 
  [ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 10, 11, 16, 17, 18, 19, 20, 21, 23, 
          24, 31, 34, 35, 42, 43, 42, 43, 36, 37, 47, 48, 40, 41, 38, 39, 44, 
          45, 49, 50, 55, 56, 60, 62, 63, 64, 65, 78, 79, 78, 79, 80, 81, 82, 
          83, 86, 87, 88, 89, 91, 91, 90, 90, 95, 96, 103, 104, 105, 106, 
          107, 108, 135, 136, 155, 154, 153, 152, 8, 9, 36, 37, 40, 41, 46, 
          10, 11, 8, 9, 12, 13, 90, 94, 99, 100, 101, 102, 107, 108, 109, 
          135, 136, 36, 37, 36, 37, 38, 39, 40, 41, 44, 45, 42, 43, 47, 48, 
          51, 52, 170, 171, 180, 181, 182, 183, 184, 78, 79, 78, 79, 80, 81, 
          193, 194, 195, 196, 197, 198, 90, 90, 92, 93, 94, 94, 99, 100, 101, 
          102, 111, 112, 133, 134, 155, 154, 153, 152, 8, 9, 36, 37, 40, 41, 
          46, 10, 11, 8, 9, 12, 13, 90, 94, 99, 100, 101, 102, 107, 108, 109, 
          135, 136, 36, 37, 36, 37, 38, 39, 40, 41, 44, 45, 42, 43, 47, 48, 
          51, 52, 170, 171, 180, 181, 182, 183, 184, 78, 79, 78, 79, 80, 81, 
          193, 194, 195, 196, 197, 198, 90, 90, 92, 93, 94, 94, 99, 100, 101, 
          102, 111, 112, 133, 134, 155, 154, 153, 152 ] ] ]
gap> List( possfus, Length );
[ 1, 1 ]
gap> poss2u12fus2t:= Concatenation( possfus );;
gap> Set( possu12fust[1] ) = Set( possu12fust[2] );
true
gap> UniteSet( defined, possu12fust[1] );

##
gap> possind2u12:= List( poss2u12fus2t,
>        map -> Set( InducedClassFunctionsByFusionMap( 2u12, 2t,
>                        testcharsu12, map ) ) );;
gap> possind2u12[1] = possind2u12[2];
true
gap> ind2u12:= possind2u12[1];;

##
gap> posssplit:= Difference( [ 1 .. Length( orders ) ],
>                            Union( mustsplit, mustnotsplit ) );
[ 38, 88, 89, 90 ]
gap> NrConjugacyClasses( t );
126
gap> NrConjugacyClasses( 2t );
202

##
gap> ForAll( ind2u12,
>        chi -> ForAll( possind2m7[1],
>                   psi -> IsInt( ScalarProduct( 2t, chi, psi ) ) ) );
false

##
gap> 2m7fus2t:= poss2m7fus2t[2];;
gap> ind2m7:= possind2m7[2];;

##
gap> nothit:= Difference( [ 1 .. Length( orders ) ],
>                 Flat( [ m3fust, m4fust, m5fust, m7fust, m8fust, m9fust,
>                         possm10fust, possu12fust ] ) );
[ 38, 88, 89, 90, 103, 104 ]
gap> orders{ nothit };
[ 8, 16, 16, 16, 19, 19 ]

##
gap> for p in [ 2 .. Maximum( OrdersClassRepresentatives( 2t ) ) ] do
>      if IsPrimeInt( p ) then
>        PowerMap( t, p );
>        pow:= InitPowerMap( 2t, p );
>        comp:= CompositionMaps( InverseMap( GetFusionMap( 2t, t ) ),
>                   CompositionMaps( PowerMap( t, p ),
>                      GetFusionMap( 2t, t ) ) );
>        MeetMaps( pow, comp );
>        ComputedPowerMaps( 2t )[p]:= pow;
>      fi;
>    od;

##
gap> pos:= Positions( OrdersClassRepresentatives( 2t ), 38 );
[ 161, 163 ]
gap> indcyc:= Filtered( InducedCyclic( 2t, pos, "all" ),
>                       chi -> chi[1] = - chi[2] );;

##
gap> pow:= ComputedPowerMaps( 2t )[5];;
gap> comp:= CompositionMaps( CompositionMaps( 2m3fus2t, PowerMap( 2m3, 5 ) ),
>                            InverseMap( 2m3fus2t ) );;
gap> MeetMaps( pow, comp );
true
gap> comp:= CompositionMaps( CompositionMaps( 2m7fus2t, PowerMap( 2m7, 5 ) ),
>                            InverseMap( 2m7fus2t ) );;
gap> MeetMaps( pow, comp );
true
gap> fus:= Parametrized( poss2m10fus2t );;
gap> comp:= CompositionMaps( CompositionMaps( fus, PowerMap( 2m10, 5 ) ),
>                            InverseMap( fus ) );;
gap> MeetMaps( pow, comp );
true
gap> ForAll( pow, IsInt );
true
gap> Intersection( PowerMap( t, 5 ), posssplit ) = posssplit;
true
gap> ForAll( posssplit, i -> Positions( PowerMap( t, 5 ), i ) = [ i ] );
true
gap> ind:= Concatenation(
>              [ ind2m3, ind2m4, ind2m5, ind2m7, ind2m8, ind2m9 ] );;
gap> minus:= List( ind, chi -> MinusCharacter( chi, pow, 5 ) );;
gap> ind:= Concatenation(
>              [ ind2m3, ind2m4, ind2m5, minus, ind2m7, ind2m8, ind2m9,
>                ind2u12, ind2m10, indcyc ] );;

##
gap> lll:= LLL( 2t, ind );;
gap> Length( lll.irreducibles );
2
gap> irr:= Set( lll.irreducibles );;
gap> red:= Reduced( 2t, irr, lll.remainders );;
gap> lll:= LLL( 2t, red.remainders );;
gap> Length( lll.irreducibles );
2
gap> UniteSet( irr, lll.irreducibles );
gap> red:= Reduced( 2t, irr, lll.remainders );;
gap> lll:= LLL( 2t, red.remainders );;
gap> Sum( lll.norms );
772
gap> lll:= LLL( 2t, lll.remainders, "sort" );;
gap> Sum( lll.norms );
729
gap> Length( lll.irreducibles );
0
gap> red:= Reduced( 2t, irr, lll.remainders );;
gap> lll:= LLL( 2t, red.remainders );;
gap> Sum( lll.norms );
710

##
gap> Length( lll.norms );
72
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 72 + 4 );;
gap> Length( emb.solutions );
1
gap> Length( emb.solutions[1] );
72

##
gap> dec:= Decreased( 2t, lll.remainders,
>                     emb.vectors{ emb.solutions[1] } );;
gap> Length( dec.irreducibles );
72
gap> UniteSet( irr, dec.irreducibles );
gap> factchars:= RestrictedClassFunctions( Irr( t ), 2t );;
gap> irr:= Concatenation( factchars, irr );;
gap> DimensionsMat( irr );
[ 202, 202 ]

##
gap> Size( 2t ) = Sum( List( irr, chi -> chi[1]^2 ) );
true
gap> SetIrr( 2t, List( irr, x -> Character( 2t, x ) ) );

##
gap> for p in [ 2 .. Maximum( OrdersClassRepresentatives( 2t ) ) ] do
>      if IsPrimeInt( p ) then
>        poss:= PossiblePowerMaps( 2t, p,
>                   rec( powermap:= ComputedPowerMaps( 2t )[p] ) );
>        if Length( poss ) <> 1 then
>          Error( "problem with ", Ordinal( p ), " power map" );
>        fi;
>        ComputedPowerMaps( 2t )[p]:= poss[1];
>      fi;
>    od;
gap> lib:= CharacterTable( "2.2E6(2)" );;
gap> tr:= TransformingPermutationsCharacterTables( lib, 2t );;
gap> IsRecord( tr );
true

##
gap> tr.columns;
(25,26)(62,63)(67,68)(121,122)(144,145)(152,153)(154,155)(172,173)(174,
175)(181,182)

##
gap> t:= CharacterTable( "2E6(2)" );;
gap> t2:= CharacterTable( "2E6(2).2" );;
gap> 2t:= CharacterTable( "2.2E6(2)" );;
gap> tfust2:= GetFusionMap( t, t2 );;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> orbsbeta:= Filtered( InverseMap( tfust2 ), IsList );
[ [ 12, 13 ], [ 17, 18 ], [ 40, 41 ], [ 44, 45 ], [ 47, 48 ], [ 55, 56 ], 
  [ 61, 62 ], [ 65, 66 ], [ 68, 69 ], [ 76, 77 ], [ 79, 80 ], [ 89, 90 ], 
  [ 92, 93 ], [ 95, 96 ], [ 99, 100 ], [ 103, 104 ], [ 109, 110 ], 
  [ 115, 116 ], [ 118, 119 ], [ 123, 124 ], [ 125, 126 ] ]
gap> beta:= Product( List( orbsbeta, x -> ( x[1], x[2] ) ) );
(12,13)(17,18)(40,41)(44,45)(47,48)(55,56)(61,62)(65,66)(68,69)(76,77)(79,
80)(89,90)(92,93)(95,96)(99,100)(103,104)(109,110)(115,116)(118,119)(123,
124)(125,126)
gap> aut:= AutomorphismsOfTable( 2t );;
gap> Size( aut );
256
gap> filt:= Filtered( Elements( aut ),
>               x -> OnTuples( 2tfust, beta ) = Permuted( 2tfust, x ) );;
gap> Length( filt );
1
gap> betalift:= filt[1];;

##
gap> 2tfus2t2:= [];;
gap> max:= 0;;
gap> for i in [ 1 .. NrConjugacyClasses( 2t ) ] do
>      img:= i^betalift;
>      if img = i then
>        # no fusion
>        max:= max + 1;
>        2tfus2t2[i]:= max;
>      elif i < img then
>        # fusion of two classes
>        max:= max + 1;
>        2tfus2t2[i]:= max;
>        2tfus2t2[ img ]:= max;
>      fi;
>    od;
gap> max;
174

##
gap> n:= NrConjugacyClasses( 2t );
202
gap> f:= NrMovedPoints( betalift ) / 2;
28
gap> 2 * n - 3 * f;  n - f;  n - 2 * f;
320
174
146

##
gap> NrConjugacyClasses( t2 ) - Maximum( tfust2 );
84
gap> 320 - NrConjugacyClasses( t2 );
131

##
gap> inv:= InverseMap( 2tfust );;
gap> nonsplit:= PositionsProperty( inv, IsInt);;
gap> mustnotsplit:= Set( tfust2{ nonsplit } );
[ 4, 9, 10, 12, 13, 16, 18, 19, 20, 27, 33, 35, 36, 38, 39, 41, 43, 44, 51, 
  52, 54, 55, 58, 60, 62, 63, 69, 70, 71, 77, 78, 80, 82, 96, 98, 100 ]
gap> split:= PositionsProperty( inv, IsList );;
gap> mustsplit:= Set( tfust2{ split } );
[ 1, 2, 3, 5, 6, 7, 8, 11, 14, 15, 17, 21, 22, 23, 24, 25, 26, 28, 29, 30, 
  31, 32, 34, 37, 40, 42, 45, 46, 47, 48, 49, 50, 53, 56, 57, 59, 61, 64, 65, 
  66, 67, 68, 72, 73, 74, 75, 76, 79, 81, 83, 84, 85, 86, 87, 88, 89, 90, 91, 
  92, 93, 94, 95, 97, 99, 101, 102, 103, 104, 105 ]
gap> selfCentralizingClassesSplit( t2, mustsplit );
#I  class 172 splits (self-centralizing)
#I  class 180 splits (self-centralizing)
#I  class 181 splits (self-centralizing)
#I  class 182 splits (self-centralizing)
#I  class 183 splits (self-centralizing)
#I  class 184 splits (self-centralizing)
#I  class 185 splits (self-centralizing)
#I  class 188 splits (self-centralizing)
#I  class 189 splits (self-centralizing)

##
gap> c2:= CharacterTable( "C2" );;
gap> s:= CharacterTable( "F4(2)" );;
gap> s2:= c2 * s;;
gap> 2s:= s * c2;;
gap> 2s2:= s2 * c2;;
gap> sfuss2:= GetFusionMap( s, s2 );;
gap> 2sfuss:= GetFusionMap( 2s, s );;
gap> 2s2fuss2:= GetFusionMap( 2s2, s2 );;

##
gap> 2s2alt:= c2 * 2s;;
gap> Irr( 2s2alt ) = Irr( 2s2 );
true
gap> ComputedPowerMaps( 2s2alt ) = ComputedPowerMaps( 2s2 );
true
gap> 2sfus2s2:= GetFusionMap( 2s, 2s2alt );;

##
gap> CompositionMaps( sfuss2, 2sfuss )
>        = CompositionMaps( 2s2fuss2, 2sfus2s2 );
true

##
gap> sfust:= PossibleClassFusions( s, t );;
gap> rep:= RepresentativesFusions( AutomorphismsOfTable( s ),
>              sfust, Group( () ) );;
gap> Length( rep );
3
gap> comp:= List( rep, map -> CompositionMaps( InverseMap( 2tfust ),
>                                 CompositionMaps( map, 2sfuss ) ) );;
gap> poss:= List( comp, map -> PossibleClassFusions( 2s, 2t,
>                                  rec( fusionmap:= map ) ) );;
gap> List( poss, Length );
[ 1, 0, 0 ]
gap> sfust:= rep[1];;
gap> 2sfus2t:= poss[1][1];;
gap> CompositionMaps( sfust, 2sfuss )
>        = CompositionMaps( 2tfust, 2sfus2t );
true

##
gap> comp:= CompositionMaps( CompositionMaps( tfust2, sfust ),
>                            InverseMap( sfuss2 ) );;
gap> poss:= PossibleClassFusions( s2, t2, rec( fusionmap:= comp ) );;
gap> Length(  poss );
1
gap> s2fust2:= poss[1];;
gap> CompositionMaps( tfust2, sfust )
>        = CompositionMaps( s2fust2, sfuss2 );
true

##
gap> splittingClassesWithOddCentralizerIndexSplit( s2, t2, s2fust2,
>        2s2fuss2, mustsplit );
#I  class 106 splits (odd centralizer index)
#I  class 107 splits (odd centralizer index)
#I  class 114 splits (odd centralizer index)
#I  class 115 splits (odd centralizer index)
#I  class 117 splits (odd centralizer index)
#I  class 133 splits (odd centralizer index)
#I  class 116 splits (odd centralizer index)
#I  class 118 splits (odd centralizer index)
#I  class 119 splits (odd centralizer index)
#I  class 148 splits (odd centralizer index)
#I  class 147 splits (odd centralizer index)
#I  class 156 splits (odd centralizer index)
#I  class 155 splits (odd centralizer index)
#I  class 134 splits (odd centralizer index)
#I  class 140 splits (odd centralizer index)
#I  class 143 splits (odd centralizer index)
#I  class 149 splits (odd centralizer index)
#I  class 176 splits (odd centralizer index)
#I  class 175 splits (odd centralizer index)
#I  class 157 splits (odd centralizer index)
#I  class 174 splits (odd centralizer index)
#I  class 177 splits (odd centralizer index)

##
gap> c3:= CharacterTable( "Cyclic", 3 );;
gap> h:= c3 * CharacterTable( "U6(2)" );;
gap> poss:= PossibleClassFusions( h, t );;
gap> cen:= ClassPositionsOfCentre( h );
[ 1, 47, 93 ]
gap> Set( List( poss, x -> x{ cen } ) );
[ [ 1, 5, 5 ] ]
gap> SizesCentralizers( t )[5] = Size( h );
true

##
gap> h:= CharacterTable( "U6(2)" );;
gap> pos:= PositionsProperty( SizesCentralizers( t2 ),
>                             x -> x mod Size( h ) = 0 );
[ 1, 2, 5 ]
gap> Difference( pos, tfust2 );
[  ]

##
gap> h:= c3 * CharacterTable( "U6(2).2" );;
gap> possfus:= PossibleClassFusions( h, t2 );;
gap> inv:= Positions( OrdersClassRepresentatives( h ), 2 );
[ 2, 3, 4, 38, 39 ]
gap> outerinv:= Difference( inv, ClassPositionsOfDerivedSubgroup( h ) );
[ 38, 39 ]
gap> imgs:= Set( List( possfus, x -> x{ outerinv } ) );
[ [ 106, 107 ] ]
gap> List( imgs[1], x -> Positions( s2fust2, x ) );
[ [ 96, 98 ], [ 97, 99, 100 ] ]
gap> h:= CharacterTable( "2.U6(2).2" );
CharacterTable( "2.U6(2).2" )
gap> Positions( OrdersClassRepresentatives( h ), 2 );
[ 2, 3, 4, 5, 6, 7, 65, 66, 67, 68 ]

##
gap> c3:= CharacterTable( "Cyclic", 3 );;
gap> 2u:= c3 * CharacterTable( "2.U6(2)" );;
gap> 2uorders:= OrdersClassRepresentatives( 2u );;
gap> ker:= First( ClassPositionsOfCentre( 2u ), i -> 2uorders[i] = 2 );
2
gap> u:= 2u / [ 1, ker ];;
gap> 2u2:= c3 * CharacterTable( "2.U6(2).2" );;
gap> 2u2orders:= OrdersClassRepresentatives( 2u2 );;
gap> ker:= First( ClassPositionsOfCentre( 2u2 ), i -> 2u2orders[i] = 2 );
2
gap> u2:= 2u2 / [ 1, ker ];;
gap> 2ufusu:= GetFusionMap( 2u, u );;
gap> 2u2fusu2:= GetFusionMap( 2u2, u2 );;
gap> poss:= PossibleClassFusions( 2u, 2u2 );;
gap> rep:= RepresentativesFusions( 2u, poss, Group( () ) );;
gap> Length( rep );
1
gap> 2ufus2u2:= rep[1];;
gap> ufusu2:= CompositionMaps( 2u2fusu2,
>              CompositionMaps( 2ufus2u2, InverseMap( 2ufusu ) ) );;

##
gap> CompositionMaps( ufusu2, 2ufusu )
>        = CompositionMaps( 2u2fusu2, 2ufus2u2 );
true

##
gap> poss:= PossibleClassFusions( 2u, 2t );;
gap> rep:= RepresentativesFusions( 2u, poss, Group( () ) );;
gap> Length( rep );
2
gap> poss2ufus2t:= rep;;
gap> possufust:= List( rep, map -> CompositionMaps( 2tfust,
>        CompositionMaps( map, InverseMap( 2ufusu ) ) ) );;
gap> Length( Set( possufust ) );
2

##
gap> comp1:= CompositionMaps(
>                CompositionMaps( tfust2, possufust[1] ),
>                    InverseMap( ufusu2 ) );;
gap> poss1:= PossibleClassFusions( u2, t2, rec( fusionmap:= comp1 ) );;
gap> Length( poss1 );
2
gap> comp2:= CompositionMaps(
>                CompositionMaps( tfust2, possufust[2] ),
>                    InverseMap( ufusu2 ) );;
gap> poss2:= PossibleClassFusions( u2, t2, rec( fusionmap:= comp2 ) );;
gap> Length(  poss2 );
2
gap> poss1 = poss2;
true
gap> rep:= RepresentativesFusions( u2, poss1, Group( () ) );;
gap> Length( rep );
1
gap> u2fust2:= rep[1];;

##
gap> splittingClassesWithOddCentralizerIndexSplit( u2, t2, u2fust2,
>        2u2fusu2, mustsplit );
#I  class 135 splits (odd centralizer index)
#I  class 139 splits (odd centralizer index)
#I  class 141 splits (odd centralizer index)
#I  class 161 splits (odd centralizer index)
gap> notSplittingClassesOfSubgroupDoNotSplit( 2u2fusu2, u2fust2,
>        mustnotsplit );
#I  class 120 does not split (as in subgroup)
#I  class 126 does not split (as in subgroup)
#I  class 127 does not split (as in subgroup)
#I  class 150 does not split (as in subgroup)
#I  class 151 does not split (as in subgroup)
#I  class 163 does not split (as in subgroup)
#I  class 164 does not split (as in subgroup)
#I  class 165 does not split (as in subgroup)
#I  class 186 does not split (as in subgroup)
#I  class 187 does not split (as in subgroup)

##
gap> computeContributions2:= function( s2, 2s, t2, 2t, s2fust2, 2sfus2s2,
>                                2sfus2t, tfust2,
>                                characters, bound,
>                                mustsplit, mustnotsplit, proj )
>      local inv, i, known, candidates, r, psi, res;
> 
>      inv:= InverseMap( s2fust2 );
> 
>      repeat
>        for i in Union( mustnotsplit, tfust2 ) do
>          # The induced character is either zero at the preimage of 'i',
>          # and there is no contribution to the norm,
>          # or the preimage of 'i' lies inside the subgroup of index 2.
>          Unbind( inv[i] );
>        od;
>        known:= [ ShallowCopy( mustsplit ), ShallowCopy( mustnotsplit ) ];
>        candidates:= [];
>        for i in [ 1 .. Length( characters ) ] do
>          r:= contributionData( s2, t2, inv, characters[i]{ proj },
>                                mustsplit );
>          if r.size < bound then
>            # Restrict the character to 2.U, and induce it to 2.G.
>            psi:= InducedClassFunctionsByFusionMap( 2s, 2t,
>                      [ characters[i]{ 2sfus2s2 } ], 2sfus2t )[1];
>            r.safepart:= r.safepart + ScalarProduct( 2t, psi, psi ) / 2;
>            Add( candidates, r );
>          fi;
>        od;
>        SortParallel( List( candidates, r -> r.size ), candidates );
>        for r in candidates do
>          res:= integralContributions( r );
>          if Length( res ) = 0 then
>            Error( "no solution" );
>          fi;
>          evaluateContributions( r, res, s2fust2, mustsplit, mustnotsplit );
>          oddRootsOfSplittingClassesSplit( t2, mustsplit );
>        od;
>      until known = [ mustsplit, mustnotsplit ];
>    end;;

##
gap> ker:= ClassPositionsOfKernel( 2s2fuss2 );;
gap> testchars:= Filtered( Irr( 2s2 ), x -> x[ ker[1] ] <> x[ ker[2] ]  );;
gap> computeContributions2( s2, 2s, t2, 2t, s2fust2, 2sfus2s2, 2sfus2t,
>        tfust2, testchars, 10^7, mustsplit, mustnotsplit,
>        ProjectionMap( 2s2fuss2 ) );
#I  class 109 splits (contribution criterion)
#I  class 136 splits (contribution criterion)
#I  class 158 splits (5th root of 109)
#I  class 173 splits (7th root of 109)
#I  class 110 splits (contribution criterion)
#I  class 108 splits (contribution criterion)
#I  class 137 splits (contribution criterion)
#I  class 159 splits (contribution criterion)
#I  class 138 splits (3rd root of 108)
#I  class 111 splits (contribution criterion)
#I  class 112 splits (contribution criterion)
#I  class 142 splits (3rd root of 111)
#I  class 144 splits (3rd root of 111)
#I  class 145 splits (3rd root of 112)

##
gap> orders:= OrdersClassRepresentatives( t2 );;
gap> invol:= Positions( orders, 2 );;
gap> Difference( invol, s2fust2 );
[  ]

##
gap> open:= Difference( s2fust2, Union( mustsplit, mustnotsplit ) );
[ 113, 121, 122, 123, 125, 128, 129, 131, 132, 146, 153, 154, 162, 166 ]

##
gap> PowerMap( t2, 3 ){ [ 146, 162, 166 ] };
[ 113, 123, 121 ]
gap> poss:= Filtered( Combinations( open ),
>               x -> ( not 113 in x or 146 in x ) and
>                    ( not 123 in x or 162 in x ) and
>                    ( not 121 in x or 166 in x ) );;
gap> Length( poss );
6912

##
gap> initialFusion2:= function( 2s2, 2t2,
>                               2s2fuss2, 2t2fust2, s2fust2,
>                               2sfus2s2, 2tfus2t2, 2sfus2t,
>                               defined )
>      local fus, comp, pre, imgs;
> 
>      # Use element orders and centralizer orders.
>      fus:= InitFusion( 2s2, 2t2 );
> 
>      # Use the commutative diagram on the right of the cube.
>      comp:= CompositionMaps( InverseMap( 2t2fust2 ),
>                 CompositionMaps( s2fust2, 2s2fuss2 ) );
>      if not MeetMaps( fus, comp ) then
>        return fail;
>      fi;
> 
>      # Use the commutative diagram on the bottom of the cube.
>      comp:= CompositionMaps( 2tfus2t2,
>                 CompositionMaps( 2sfus2t, InverseMap( 2sfus2s2 ) ) );
> 
>      if not MeetMaps( fus, comp ) then
>        return fail;
>      fi;
> 
>      # Define classes that are not yet defined.
>      defined:= ShallowCopy( defined );
>      for pre in InverseMap( 2s2fuss2 ) do
>        if IsList( pre ) then
>          imgs:= fus{ pre };
>          if imgs[1] = imgs[2] and IsList( imgs[1] )
>             and Intersection( defined, imgs[1] ) = [] then
>            # The classes in preimage and image split, and we may choose.
>            fus[ pre[1] ]:= imgs[1][1];
>            fus[ pre[2] ]:= imgs[1][2];
>            UniteSet( defined, imgs[1] );
>          fi;
>        elif IsList( fus[ pre ] ) then
>          # The class splits in the image but not in the preimage,
>          # something must be wrong.
>          return fail;
>        fi;
>      od;
> 
>      return fus;
>    end;;

##
gap> good:= [];;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2s2, s2 ) );;
gap> testcharss:= Filtered( Irr( 2s2 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> runOneTest2:= function( s2, 2s2, t2, 2t2, s2fust2,
>                            2sfus2s2, 2tfus2t2, 2sfus2t,
>                            testchars, defined )
>      local fus, pos, l, chi;
> 
>      fus:= initialFusion2( 2s2, 2t2,
>                            GetFusionMap( 2s2, s2 ),
>                            GetFusionMap( 2t2, t2 ),
>                            s2fust2,
>                            2sfus2s2, 2tfus2t2, 2sfus2t,
>                            defined );
> 
>      # Process the irreducible characters,
>      # ordered by increasing indeterminateness.
>      pos:= PositionsProperty( fus, IsList );
>      testchars:= ShallowCopy( testchars );
>      l:= - List( testchars, x -> Number( pos, i -> x[i] = 0 ) );
>      SortParallel( l, testchars );
>      for chi in testchars do
>        if useInducedClassFunction( 2s2, 2t2, chi,
>               GetFusionMap( 2s2, s2 ), fus ) = false then
>          # This splitting is not possible.
>          return fail;
>        fi;
>      od;
>      return fus;
>    end;;
gap> defined:= [];;
gap> for choice in poss do
>      2t2:= tableHead( t2, Union( mustsplit, choice ), [], [] );
>      fus:= runOneTest2( s2, 2s2, t2, 2t2, s2fust2,
>                   2sfus2s2, 2tfus2t2, 2sfus2t,
>                testcharss, defined );
>      if fus <> fail then
>        Add( good, choice );
>      fi;
>    od;
gap> Length( good );
1

##
gap> choice:= good[1];
[ 113, 121, 122, 123, 125, 131, 146, 153, 154, 162, 166 ]
gap> UniteSet( mustsplit, choice );
gap> UniteSet( mustnotsplit, Difference( open, choice ) );
gap> oddRootsOfSplittingClassesSplit( t2, mustsplit );
#I  class 168 splits (3rd root of 122)
#I  class 171 splits (3rd root of 131)

##
gap> 2t2:= tableHead( t2, mustsplit, [], [] );;
gap> 2s2fus2t2:= runOneTest2( s2, 2s2, t2, 2t2, s2fust2,
>                       2sfus2s2, 2tfus2t2, 2sfus2t,
>                       testcharss, defined );;
gap> NrConjugacyClasses( 2t2 );
320
gap> defined:= Set( 2s2fus2t2 );;
gap> inds:= Set( InducedClassFunctionsByFusionMap( 2s2, 2t2, testcharss,
>                                                  2s2fus2t2 ) );;

##
gap> poss2u2fus2t2:= List( poss2ufus2t, map ->
>                              initialFusion2( 2u2, 2t2,
>                                  GetFusionMap( 2u2, u2 ),
>                                  GetFusionMap( 2t2, t2 ),
>                                  u2fust2,
>                                  2ufus2u2, 2tfus2t2, map,
>                                  defined ) );;
gap> Length( Set( poss2u2fus2t2 ) );
1
gap> fus:= poss2u2fus2t2[1];;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2u2, u2 ) );;
gap> testcharsu:= Filtered( Irr( 2u2 ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> possfus:= FusionsAllowedByRestrictions( 2u2, 2t2, testcharsu,
>                  inds, fus, parametersFABR );;
gap> List( possfus, Indeterminateness );
[ 16, 16 ]

##
gap> good:= [];;
gap> for map in Set( Concatenation( List( possfus, ContainedMaps ) ) ) do
>      indu:= Set( InducedClassFunctionsByFusionMap( 2u2, 2t2,
>                      testcharsu, map ) );
>      if ForAll( indu, x -> IsInt( ScalarProduct( 2t2, x, x ) ) ) then
>        Add( good, map );
>      fi;
>    od;
gap> Length( good );
2
gap> poss2u2fus2t2:= good;;
gap> indu:= List( good,
>                 map -> Set( InducedClassFunctionsByFusionMap( 2u2, 2t2,
>                                 testcharsu, map ) ) );;
gap> List( indu, Length );
[ 98, 98 ]
gap> Length( Intersection( indu ) );
34
gap> Set( poss2u2fus2t2[1] ) = Set( poss2u2fus2t2[2] );
true
gap> UniteSet( defined, Set( poss2u2fus2t2[1] ) );

##
gap> 2t2fust2:= GetFusionMap( 2t2, t2 );;
gap> p:= 5;;
gap> pow5:= InitPowerMap( 2t2, p );;
gap> comp:= CompositionMaps( InverseMap( 2t2fust2 ),
>            CompositionMaps( PowerMap( t2, p ), 2t2fust2 ) );;
gap> MeetMaps( pow5, comp );
true
gap> comp:= CompositionMaps( 2tfus2t2,
>            CompositionMaps( PowerMap( 2t, p ),
>                InverseMap( 2tfus2t2 ) ) );;
gap> MeetMaps( pow5, comp );
true
gap> comp:= CompositionMaps( 2s2fus2t2,
>            CompositionMaps( PowerMap( 2s2, p ),
>                InverseMap( 2s2fus2t2 ) ) );;
gap> MeetMaps( pow5, comp );
true
gap> para:= Parametrized( poss2u2fus2t2 );;
gap> comp:= CompositionMaps( para,
>            CompositionMaps( PowerMap( 2u2, p ),
>                InverseMap( para ) ) );;
gap> MeetMaps( pow5, comp );
true
gap> Indeterminateness( pow5 );
4096

##
gap> ambig:= PositionsProperty( pow5, IsList );
[ 283, 284, 287, 288, 307, 308, 309, 310, 317, 318, 319, 320 ]
gap> ambig:= Filtered( ambig,
>                i -> OrdersClassRepresentatives( 2t2 )[i] mod 5 = 0 );
[ 309, 310, 319, 320 ]
gap> Intersection( ambig, defined );
[  ]
gap> pow5{ ambig };
[ [ 204, 205 ], [ 204, 205 ], [ 227, 228 ], [ 227, 228 ] ]
gap> pow5{ ambig }:= [ 204, 205, 227, 228 ];;
gap> UniteSet( defined, ambig );

##
gap> p:= 3;;
gap> pow3:= InitPowerMap( 2t2, p );;
gap> comp:= CompositionMaps( InverseMap( 2t2fust2 ),
>            CompositionMaps( PowerMap( t2, p ), 2t2fust2 ) );;
gap> MeetMaps( pow3, comp );
true
gap> comp:= CompositionMaps( 2tfus2t2,
>            CompositionMaps( PowerMap( 2t, p ),
>                InverseMap( 2tfus2t2 ) ) );;
gap> MeetMaps( pow3, comp );
true
gap> comp:= CompositionMaps( 2s2fus2t2,
>            CompositionMaps( PowerMap( 2s2, p ),
>                InverseMap( 2s2fus2t2 ) ) );;
gap> MeetMaps( pow3, comp );
true
gap> para:= Parametrized( poss2u2fus2t2 );;
gap> comp:= CompositionMaps( para,
>            CompositionMaps( PowerMap( 2u2, p ),
>                InverseMap( para ) ) );;
gap> MeetMaps( pow3, comp );
true
gap> Indeterminateness( pow3 );
65536
gap> CommutativeDiagram( pow3, pow5, pow5, pow3 );
rec( imp1 := [ 309, 310, 319, 320 ], imp2 := [  ], imp3 := [  ], imp4 := [  ] 
 )
gap> Indeterminateness( pow3 );
4096
gap> ambig:= PositionsProperty( pow3, IsList );
[ 239, 240, 273, 274, 283, 284, 287, 288, 307, 308, 317, 318 ]
gap> ambig:=  Difference( ambig, defined );
[ 283, 284, 287, 288, 307, 308, 317, 318 ]
gap> pow3{ ambig };
[ [ 206, 207 ], [ 206, 207 ], [ 218, 219 ], [ 218, 219 ], [ 231, 232 ], 
  [ 231, 232 ], [ 317, 318 ], [ 317, 318 ] ]
gap> pow3{ [ 283, 284, 287, 288, 307, 308 ] }:=
>              [ 206, 207, 218, 219, 231, 232 ];;
gap> CommutativeDiagram( pow3, pow5, pow5, pow3 );
rec( imp1 := [  ], imp2 := [  ], imp3 := [ 283, 284, 287, 288, 307, 308 ], 
  imp4 := [  ] )

##
gap> poss3:= [];;
gap> for possindu in indu do
>      testchars:= Concatenation( inds, possindu );
>      Add( poss3, PowerMapsAllowedBySymmetrizations( 2t2, testchars,
>                      testchars, StructuralCopy( pow3 ), p,
>                      parametersFABR ) );
>    od;
gap> List( poss3, Length );
[ 1, 1 ]
gap> poss3:= List( poss3, l -> l[1] );;
gap> List( poss3, Indeterminateness );
[ 4, 4 ]

##
gap> p:= 2;;
gap> pow2:= InitPowerMap( 2t2, p );;
gap> comp:= CompositionMaps( InverseMap( 2t2fust2 ),
>               CompositionMaps( PowerMap( t2, p ), 2t2fust2 ) );;
gap> MeetMaps( pow2, comp );
true
gap> comp:= CompositionMaps( 2tfus2t2,
>               CompositionMaps( PowerMap( 2t, p ),
>                   InverseMap( 2tfus2t2 ) ) );;
gap> MeetMaps( pow2, comp );
true
gap> comp:= CompositionMaps( 2s2fus2t2,
>               CompositionMaps( PowerMap( 2s2, p ),
>                   InverseMap( 2s2fus2t2 ) ) );;
gap> MeetMaps( pow2, comp );
true
gap> para:= Parametrized( poss2u2fus2t2 );;
gap> comp:= CompositionMaps( para,
>               CompositionMaps( PowerMap( 2u2, p ),
>                   InverseMap( para ) ) );;
gap> MeetMaps( pow2, comp );
true
gap> Indeterminateness( pow2 );
131072
gap> CommutativeDiagram( pow3, pow2, pow2, pow3 );
rec( imp1 := [  ], imp2 := [  ], 
  imp3 := [ 283, 284, 287, 288, 307, 308, 319, 320 ], imp4 := [  ] )
gap> Indeterminateness( pow2 );
512
gap> CommutativeDiagram( pow5, pow2, pow2, pow5 );
rec( imp1 := [  ], imp2 := [  ], imp3 := [ 309, 310 ], imp4 := [  ] )
gap> Indeterminateness( pow2 );
128

##
gap> indt:= Set( InducedClassFunctionsByFusionMap( 2t, 2t2,
>               Filtered( Irr( 2t ), x -> x[1] <> x[2] ), 2tfus2t2 ) );;
gap> irr:= Filtered( indt, x -> ScalarProduct( 2t2, x, x ) = 1 );;
gap> Length( irr ); 
7

##
gap> red:= Reduced( 2t2, irr, Concatenation( indt, inds ) );;
gap> Length( red.irreducibles );
0
gap> lll:= LLL( 2t2, red.remainders, 99/100 );;
gap> Length( lll.irreducibles );
4
gap> UniteSet( irr, lll.irreducibles );
gap> Length( irr ); 
11
gap> missing:= NrConjugacyClasses( 2t2 ) - NrConjugacyClasses( t2 )
>                  - Length( irr );
120
gap> redindu:= List( indu, l -> ReducedCharacters( 2t2, irr, l ) );;
gap> List( redindu, r -> r.irreducibles );
[ [  ], [  ] ]
gap> redindu:= List( redindu, r -> r.remainders );;

##
gap> inducand:= redindu[1];;
gap> testchars:= Concatenation( irr, red.remainders, inducand );;
gap> minus5:= List( testchars, x -> MinusCharacter( x, pow5, 5 ) );;
gap> minus3:= List( testchars, x -> MinusCharacter( x, poss3[1], 3 ) );;
gap> minus:= Reduced( 2t2, irr, Concatenation( minus5, minus3 ) );;
gap> Length( minus.irreducibles );
0
gap> lll2:= LLL( 2t2, Concatenation( lll.remainders, inducand,
>                         minus.remainders ), 99/100 );;
gap> Length( lll2.irreducibles );
0
gap> Length( lll2.norms );
119
gap> gram:= MatScalarProducts( 2t2, lll2.remainders, lll2.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, missing );;
gap> Length( emb.solutions );
1
gap> dec:= Decreased( 2t2, lll2.remainders, emb.vectors{ emb.solutions[1] } );;
gap> Length( dec.irreducibles );
118
gap> Length( dec.remainders );
1

##
gap> redt:= Reduced( 2t2, Concatenation( irr, dec.irreducibles ), indt );;
gap> Length( redt.remainders );
1
gap> redt.remainders[1] in indt;
true

##
gap> split:= Union( Filtered( InverseMap( 2t2fust2 ), IsList ) );;
gap> Filtered( split, i -> ForAll( Concatenation( irr, dec.irreducibles ),
>                                  x -> x[i] = 0 ) );
[ 317, 318 ]
gap> Positions( OrdersClassRepresentatives( 2t2 ), 56 );
[ 317, 318 ]
gap> SizesCentralizers( 2t2 )[317];
112

##
gap> factirr:= List( Irr( t2 ), x -> x{ 2t2fust2 } );;
gap> poss2:= PowerMapsAllowedBySymmetrizations( 2t2, factirr,
>                dec.irreducibles, StructuralCopy( pow2 ), 2,
>                parametersFABR );;
gap> Length( poss2 );
1
gap> Indeterminateness( poss2[1] );
1
gap> cand:= ShallowCopy( redt.remainders[1] / 2 );;
gap> cand{ [ 317, 318 ] }:= [ 1, -1 ] * ( 2 * Sqrt(-7) );;
gap> minus2:= MinusCharacter( cand, poss2[1], 2 );;
gap> ForAll( Flat( MatScalarProducts( 2t2, factirr, [ minus2 ] ) ), IsInt );
false
gap> cand{ [ 317, 318 ] }:= [ 1, -1 ] * ( 2 * Sqrt(7) );;
gap> minus2:= MinusCharacter( cand, poss2[1], 2 );;
gap> ForAll( Flat( MatScalarProducts( 2t2, factirr, [ minus2 ] ) ), IsInt );
true

##
gap> cand2:= ShallowCopy( cand );;
gap> cand2{ [ 317, 318 ] }:= [ -1, 1 ] * ( 2 * Sqrt(7) );;
gap> SetIrr( 2t2, Concatenation( factirr, irr, dec.irreducibles,
>                     [ cand, cand2 ] ) );
gap> for p in [ 2 .. Maximum( OrdersClassRepresentatives( 2t2 ) ) ] do
>      if IsPrimeInt( p ) then
>        if p = 2 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= poss2[1] ) );
>        elif p = 3 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= StructuralCopy( pow3 ) ) );
>        elif p = 5 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= StructuralCopy( pow5 ) ) );
>        else
>          poss:= PossiblePowerMaps( 2t2, p );
>        fi;
>        if Length( poss ) <> 1 then
>          Error( "not expected" );
>        fi;
>        ComputedPowerMaps( 2t2 )[p]:= poss[1];
>      fi;
>    od;
gap> lib:= CharacterTable( "2.2E6(2).2" );;
gap> tr:= TransformingPermutationsCharacterTables( lib, 2t2 );;
gap> tr.columns;
(177,178)(179,180)(183,184)(185,186)(189,190)(195,196)(199,200)(201,202)(204,
205)(206,207)(208,209)(218,219)(223,224)(225,226)(227,228)(231,232)(233,
234)(235,236)(241,242)(243,244)(245,246)(247,248)(253,254)(258,259)(260,
261)(266,267)(268,269)(273,274)(275,276)(280,281)(283,284)(287,288)(293,
294)(299,300)(307,308)(309,310)

##
gap> 2t2:= tableHead( t2, mustsplit, [], [] );;
gap> inducand:= redindu[2];;
gap> testchars:= Concatenation( irr, red.remainders, inducand );;
gap> minus5:= List( testchars, x -> MinusCharacter( x, pow5, 5 ) );;
gap> minus3:= List( testchars, x -> MinusCharacter( x, poss3[2], 3 ) );;
gap> minus:= Reduced( 2t2, irr, Concatenation( minus5, minus3 ) );;
gap> Length( minus.irreducibles );
0
gap> lll2:= LLL( 2t2, Concatenation( lll.remainders, inducand,
>                         minus.remainders ), 99/100 );;
gap> Length( lll2.irreducibles );
0
gap> Length( lll2.norms );
119
gap> gram:= MatScalarProducts( 2t2, lll2.remainders, lll2.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, missing );;
gap> Length( emb.solutions );
1
gap> dec:= Decreased( 2t2, lll2.remainders, emb.vectors{ emb.solutions[1] } );;
gap> Length( dec.irreducibles );
118
gap> Length( dec.remainders );
1
gap> redt:= Reduced( 2t2, Concatenation( irr, dec.irreducibles ), indt );;
gap> Length( redt.remainders );
1
gap> redt.remainders[1] in indt;
true
gap> poss2:= PowerMapsAllowedBySymmetrizations( 2t2, factirr,
>                dec.irreducibles, StructuralCopy( pow2 ), 2,
>                parametersFABR );;
gap> Length( poss2 );
1
gap> Indeterminateness( poss2[1] );
1
gap> cand:= ShallowCopy( redt.remainders[1] / 2 );;
gap> cand{ [ 317, 318 ] }:= [ 1, -1 ] * ( 2 * Sqrt(-7) );;
gap> minus2:= MinusCharacter( cand, poss2[1], 2 );;
gap> ForAll( Flat( MatScalarProducts( 2t2, factirr, [ minus2 ] ) ), IsInt );
false
gap> cand{ [ 317, 318 ] }:= [ 1, -1 ] * ( 2 * Sqrt(7) );;
gap> minus2:= MinusCharacter( cand, poss2[1], 2 );;
gap> ForAll( Flat( MatScalarProducts( 2t2, factirr, [ minus2 ] ) ), IsInt );
true
gap> cand2:= ShallowCopy( cand );;
gap> cand2{ [ 317, 318 ] }:= [ -1, 1 ] * ( 2 * Sqrt(7) );;
gap> SetIrr( 2t2, Concatenation( factirr, irr, dec.irreducibles,
>                     [ cand, cand2 ] ) );
gap> for p in [ 2 .. Maximum( OrdersClassRepresentatives( 2t2 ) ) ] do
>      if IsPrimeInt( p ) then
>        if p = 2 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= poss2 ) );
>        elif p = 3 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= StructuralCopy( pow3 ) ) );
>        elif p = 5 then
>          poss:= PossiblePowerMaps( 2t2, p,
>                     rec( powermap:= StructuralCopy( pow5 ) ) );
>        else
>          poss:= PossiblePowerMaps( 2t2, p );
>        fi;
>        if Length( poss ) <> 1 then
>          Error( "not expected" );
>        fi;
>        ComputedPowerMaps( 2t2 )[p]:= poss[1];
>      fi;
>    od;
gap> tr:= TransformingPermutationsCharacterTables( lib, 2t2 );;
gap> tr.columns;
(177,178)(179,180)(183,184)(185,186)(189,190)(195,196)(199,200)(201,202)(204,
205)(206,207)(208,209)(218,219)(223,224)(225,226)(227,228)(231,232)(233,
234)(235,236)(239,240)(241,242)(243,244)(245,246)(247,248)(253,254)(258,
259)(260,261)(266,267)(268,269)(275,276)(280,281)(283,284)(287,288)(293,
294)(299,300)(307,308)(309,310)

##
gap> t:= CharacterTable( "B" );;
gap> s:= CharacterTable( "2.2E6(2).2" );;
gap> 2s:= CharacterTable( "2^2.2E6(2).2" );;
gap> 2sfuss:= GetFusionMap( 2s, s );;

##
gap> fus:= PossibleClassFusions( s, t );;
gap> Length( fus );
16
gap> n:= NrConjugacyClasses( 2s );;
gap> indperm:= pi -> PermList( CompositionMaps( 2sfuss,
>        CompositionMaps( ListPerm( pi, n ), InverseMap( 2sfuss ) ) ) );;
gap> ind:= Group( List( GeneratorsOfGroup( AutomorphismsOfTable( 2s ) ),
>                       indperm ) );;
gap> Size( ind );
16
gap> rep:= RepresentativesFusions( ind, fus, Group( () ) );;
gap> Length( rep );
2

##
gap> List( rep, map -> map{ ClassPositionsOfCentre( s ) } );
[ [ 1, 2 ], [ 1, 2 ] ]
gap> List( rep, map -> Positions( map, 2 ) );
[ [ 2, 4, 175 ], [ 2, 4, 176 ] ]
gap> pos:= List( [ 175, 176 ], i -> Positions( 2sfuss, i ) );
[ [ 251 ], [ 252 ] ]
gap> OrdersClassRepresentatives( 2s ){ [ 251, 252 ] };
[ 2, 4 ]
gap> sfust:= rep[1];;

##
gap> orders:= OrdersClassRepresentatives( t );;
gap> mustsplit:= PositionsProperty( orders, IsOddInt );
[ 1, 6, 7, 18, 19, 31, 46, 47, 54, 75, 81, 82, 91, 98, 109, 112, 113, 128, 
  131, 145, 146, 151, 155, 160, 172, 173, 177 ]
gap> selfCentralizingClassesSplit( t, mustsplit );
#I  class 158 splits (self-centralizing)
#I  class 159 splits (self-centralizing)
#I  class 165 splits (self-centralizing)
#I  class 169 splits (self-centralizing)
#I  class 170 splits (self-centralizing)
#I  class 171 splits (self-centralizing)
#I  class 176 splits (self-centralizing)
#I  class 182 splits (self-centralizing)
#I  class 183 splits (self-centralizing)
#I  class 184 splits (self-centralizing)
gap> splittingClassesWithOddCentralizerIndexSplit( s, t, sfust,
>        2sfuss, mustsplit );
#I  class 110 splits (odd centralizer index)
#I  class 68 splits (odd centralizer index)
#I  class 73 splits (odd centralizer index)
#I  class 79 splits (odd centralizer index)
#I  class 94 splits (odd centralizer index)
#I  class 136 splits (odd centralizer index)
#I  class 140 splits (odd centralizer index)
gap> mustnotsplit:= [];;
gap> notSplittingClassesOfSubgroupDoNotSplit( 2sfuss, sfust, mustnotsplit );
#I  class 2 does not split (as in subgroup)
#I  class 4 does not split (as in subgroup)
#I  class 5 does not split (as in subgroup)
#I  class 8 does not split (as in subgroup)
#I  class 9 does not split (as in subgroup)
#I  class 10 does not split (as in subgroup)
#I  class 11 does not split (as in subgroup)
#I  class 13 does not split (as in subgroup)
#I  class 14 does not split (as in subgroup)
#I  class 15 does not split (as in subgroup)
#I  class 17 does not split (as in subgroup)
#I  class 20 does not split (as in subgroup)
#I  class 21 does not split (as in subgroup)
#I  class 23 does not split (as in subgroup)
#I  class 24 does not split (as in subgroup)
#I  class 25 does not split (as in subgroup)
#I  class 27 does not split (as in subgroup)
#I  class 29 does not split (as in subgroup)
#I  class 30 does not split (as in subgroup)
#I  class 32 does not split (as in subgroup)
#I  class 33 does not split (as in subgroup)
#I  class 34 does not split (as in subgroup)
#I  class 35 does not split (as in subgroup)
#I  class 36 does not split (as in subgroup)
#I  class 37 does not split (as in subgroup)
#I  class 38 does not split (as in subgroup)
#I  class 39 does not split (as in subgroup)
#I  class 40 does not split (as in subgroup)
#I  class 41 does not split (as in subgroup)
#I  class 44 does not split (as in subgroup)
#I  class 48 does not split (as in subgroup)
#I  class 50 does not split (as in subgroup)
#I  class 52 does not split (as in subgroup)
#I  class 55 does not split (as in subgroup)
#I  class 56 does not split (as in subgroup)
#I  class 57 does not split (as in subgroup)
#I  class 58 does not split (as in subgroup)
#I  class 59 does not split (as in subgroup)
#I  class 61 does not split (as in subgroup)
#I  class 62 does not split (as in subgroup)
#I  class 63 does not split (as in subgroup)
#I  class 65 does not split (as in subgroup)
#I  class 66 does not split (as in subgroup)
#I  class 67 does not split (as in subgroup)
#I  class 69 does not split (as in subgroup)
#I  class 70 does not split (as in subgroup)
#I  class 71 does not split (as in subgroup)
#I  class 72 does not split (as in subgroup)
#I  class 76 does not split (as in subgroup)
#I  class 77 does not split (as in subgroup)
#I  class 78 does not split (as in subgroup)
#I  class 80 does not split (as in subgroup)
#I  class 83 does not split (as in subgroup)
#I  class 84 does not split (as in subgroup)
#I  class 85 does not split (as in subgroup)
#I  class 86 does not split (as in subgroup)
#I  class 87 does not split (as in subgroup)
#I  class 88 does not split (as in subgroup)
#I  class 92 does not split (as in subgroup)
#I  class 93 does not split (as in subgroup)
#I  class 95 does not split (as in subgroup)
#I  class 97 does not split (as in subgroup)
#I  class 99 does not split (as in subgroup)
#I  class 101 does not split (as in subgroup)
#I  class 102 does not split (as in subgroup)
#I  class 103 does not split (as in subgroup)
#I  class 114 does not split (as in subgroup)
#I  class 115 does not split (as in subgroup)
#I  class 116 does not split (as in subgroup)
#I  class 117 does not split (as in subgroup)
#I  class 118 does not split (as in subgroup)
#I  class 119 does not split (as in subgroup)
#I  class 120 does not split (as in subgroup)
#I  class 122 does not split (as in subgroup)
#I  class 123 does not split (as in subgroup)
#I  class 124 does not split (as in subgroup)
#I  class 126 does not split (as in subgroup)
#I  class 129 does not split (as in subgroup)
#I  class 130 does not split (as in subgroup)
#I  class 132 does not split (as in subgroup)
#I  class 133 does not split (as in subgroup)
#I  class 134 does not split (as in subgroup)
#I  class 135 does not split (as in subgroup)
#I  class 137 does not split (as in subgroup)
#I  class 138 does not split (as in subgroup)
#I  class 139 does not split (as in subgroup)
#I  class 141 does not split (as in subgroup)
#I  class 149 does not split (as in subgroup)
#I  class 150 does not split (as in subgroup)
#I  class 152 does not split (as in subgroup)
#I  class 153 does not split (as in subgroup)
#I  class 154 does not split (as in subgroup)
#I  class 156 does not split (as in subgroup)
#I  class 157 does not split (as in subgroup)
#I  class 161 does not split (as in subgroup)
#I  class 163 does not split (as in subgroup)
#I  class 166 does not split (as in subgroup)
#I  class 167 does not split (as in subgroup)
#I  class 168 does not split (as in subgroup)
#I  class 175 does not split (as in subgroup)
#I  class 178 does not split (as in subgroup)
#I  class 179 does not split (as in subgroup)
#I  class 180 does not split (as in subgroup)
#I  class 181 does not split (as in subgroup)
gap> proj:= Filtered( Irr( 2s ), x -> x[1] <> x[2] );;
gap> projmap:= ProjectionMap( 2sfuss );;
gap> proj:= List( proj, x -> x{ projmap } );;
gap> computeContributions( s, t, sfust, proj, 10^6,
>        mustsplit, mustnotsplit );
#I  class 3 splits (contribution criterion)
#I  class 12 splits (contribution criterion)
#I  class 42 splits (contribution criterion)
#I  class 22 splits (3rd root of 3)
#I  class 26 splits (3rd root of 3)
#I  class 60 splits (3rd root of 12)
#I  class 64 splits (3rd root of 12)
#I  class 125 splits (3rd root of 42)
#I  class 49 splits (5th root of 3)
#I  class 51 splits (5th root of 3)
#I  class 105 splits (5th root of 12)
#I  class 143 splits (5th root of 26)
#I  class 144 splits (5th root of 26)
#I  class 111 splits (11th root of 3)
#I  class 104 does not split (contribution criterion)
#I  class 28 splits (contribution criterion)
#I  class 142 splits (5th root of 28)

##
gap> invol:= Positions( OrdersClassRepresentatives( t ), 2 );
[ 2, 3, 4, 5 ]
gap> IsSubset( sfust, invol );
true
gap> invols:= List( invol, i -> Positions( sfust, i ) );
[ [ 2, 4, 175 ], [ 3, 5 ], [ 176, 177 ], [ 6, 7, 178 ] ]
gap> preim2s:= List( invols,
>        l -> PositionsProperty( 2sfuss, x -> x in l ) );
[ [ 3, 6, 251 ], [ 4, 5, 7, 8 ], [ 252, 253 ], [ 9, 10, 254 ] ]
gap> List( preim2s, l -> OrdersClassRepresentatives( 2s ){ l } );
[ [ 2, 2, 2 ], [ 2, 2, 2, 2 ], [ 4, 4 ], [ 2, 2, 2 ] ]
gap> invmustlift:= [ 4 ];;
gap> invmaylift:= [];;

##
gap> open:= Difference( sfust, Union( mustsplit, mustnotsplit ) );
[ 89, 90 ]
gap> defined:= [];;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2s, s ) );
[ 1, 2 ]
gap> testcharss:= Filtered( Irr( 2s ),
>        chi -> not IsSubset( ClassPositionsOfKernel( chi ), ker ) );;
gap> good:= [];;
gap> for choice in Combinations( open ) do
>      2t:= tableHead( t, Union( mustsplit, choice ),
>                      invmustlift, invmaylift ); 
>      fus:= runOneTest( s, 2s, t, 2t, sfust, testcharss, defined );
>      if fus <> fail then
>        Add( good, rec( choice:= choice, table:= 2t, map:= fus ) );
>      fi;
>    od;
gap> List( good, x -> x.choice );
[ [ 89 ], [ 90 ] ]

##
gap> List( good, x -> Indeterminateness( x.map ) );
[ 4, 4 ]
gap> goodfus:= [];;
gap> for map in ContainedMaps( good[1].map ) do
>      2t:= good[1].table;
>      ind:= InducedClassFunctionsByFusionMap( 2s, 2t, testcharss, map );
>      if ForAll( Flat( MatScalarProducts( 2t, ind, ind ) ), IsInt ) then
>        Add( goodfus, map );
>      fi;
>    od;
gap> Length( goodfus );
0
gap> 2t:= good[2].table;;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> AddSet( mustnotsplit, 89 );
gap> AddSet( mustsplit, 90 );

##
gap> inds:= [];;
gap> for map in ContainedMaps( good[2].map ) do
>      ind:= InducedClassFunctionsByFusionMap( 2s, 2t, testcharss, map );
>      if ForAll( Flat( MatScalarProducts( 2t, ind, ind ) ), IsInt ) then
>        Add( inds, rec( 2tfust:= 2tfust, characters:= ind, map:= map ) );
>      fi;
>    od;
gap> Length( inds );
2

##
gap> p:= 2;;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> for testinds in inds do
>      pow:= InitPowerMap( 2t, p );
>      Congruences( 2t, testinds.characters, pow, p, false );
>      TransferDiagram( pow, 2tfust, PowerMap( t, p ) );
>      TransferDiagram( PowerMap( 2s, p ), testinds.map, pow );
>      factirr:= List( Irr( t ), x -> x{ 2tfust } );
>      testinds.pow2:= PowerMapsAllowedBySymmetrizations( 2t, factirr,
>                          testinds.characters, pow, p, parametersFABR );
>    od;
gap> List( inds, x -> Length( x.pow2 ) );
[ 1, 0 ]
gap> inds:= inds[1];;

##
gap> Length( Difference( [ 1 .. NrConjugacyClasses( t ) ],
>            Union( mustsplit, mustnotsplit ) ) );
17

##
gap> th:= CharacterTable( "Th" );;
gap> poss:= PossibleClassFusions( th, t );;
gap> Length( poss );
2
gap> rep:= RepresentativesFusions( th, poss, Group( () ) );;
gap> Length( rep );
1
gap> thfust:= rep[1];;
gap> 2th:= CharacterTable( "Cyclic", 2 ) * th;;
gap> 2thfusth:= GetFusionMap( 2th, th );;
gap> splittingClassesWithOddCentralizerIndexSplit( th, t, thfust,
>        2thfusth, mustsplit );
#I  class 96 splits (odd centralizer index)

##
gap> splitFusionAndCharacters:= function( r, t, tosplit_in_t )
>      local 2tfust, inv, tosplit_in_2t, result, shift, j, i, spl;
> 
>      2tfust:= r.2tfust;
>      inv:= InverseMap( 2tfust );
>      tosplit_in_2t:= inv{ tosplit_in_t };
>      if ForAny( inv{ tosplit_in_t }, IsList ) then
>        Error( "the classes in ",
>               Filtered( tosplit_in_t, i -> IsList( inv[i] ) ),
>               " were already split" );
>      elif ForAny( r.characters,
>                   x -> not IsZero( x{ tosplit_in_2t } ) ) then
>        Error( "all characters must vanish on the classes to be split" );
>      fi;
> 
>      # Adjust the characters of '2t'.
>      spl:= Concatenation( [ 1 .. Length( r.characters[1] ) ],
>                           tosplit_in_2t );
>      Sort( spl );
>      result:= rec( characters:= List( r.characters, chi -> chi{ spl } ),
>                    2tfust:= 2tfust{ spl } );
> 
>      if IsBound( r.map ) then
>        if Intersection( tosplit_in_2t, r.map ) <> [] then
>          Error( "the classes to be split must not occur in the subgroup" );
>        fi;
> 
>        # Adjust the fusion from a subgroup to '2t'.
>        Add( tosplit_in_2t, Length( 2tfust ) + 1 );
>        shift:= [];
>        for j in [ 1 .. tosplit_in_2t[1] - 1 ] do
>          shift[j]:= 0;
>        od;
>        for i in [ 1 .. Length( tosplit_in_2t ) - 1 ] do
>          for j in [ tosplit_in_2t[i] .. tosplit_in_2t[ i+1 ] - 1 ] do
>            shift[j]:= i;
>          od;
>        od;
>        result.map:= r.map + shift{ r.map };
>      fi;
> 
>      return result;
> end;;
gap> inds:= splitFusionAndCharacters( inds, t, [ 96 ] );;

##
gap> open:= Difference( thfust, Union( mustsplit, mustnotsplit ) );
[ 45, 53, 108, 127 ]
gap> defined:= Set( sfust );;
gap> ker:= ClassPositionsOfKernel( GetFusionMap( 2th, th ) );
[ 1, 49 ]
gap> testcharsth:= Filtered( Irr( 2th ),
>               x -> not IsSubset( ClassPositionsOfKernel( x ), ker ) );;
gap> good:= [];;
gap> for choice in Combinations( open ) do
>      2t:= tableHead( t, Union( mustsplit, choice ),
>                      invmustlift, invmaylift );
>      fus:= runOneTest( th, 2th, t, 2t, thfust, testcharsth, defined );
>      if fus <> fail then
>        Add( good, rec( choice:= choice, map:= fus, table:= 2t ) );
>      fi;
>    od;
gap> List( good, x -> x.choice );
[ [ 45, 53, 127 ], [ 53 ], [ 53, 127 ] ]

##
gap> UniteSet( mustsplit, [ 53 ] );
gap> UniteSet( mustnotsplit, [ 108 ] );

##
gap> good2:= [];;
gap> for r in good do
>      splitinds:= splitFusionAndCharacters( inds, t, r.choice );
>      2t:= r.table;;
>      fus:= StructuralCopy( r.map );;
>      2tfust:= GetFusionMap( 2t, t );;
>      factirr:= List( Irr( t ), x -> x{ 2tfust } );;
>      possfus:= FusionsAllowedByRestrictions( 2th, 2t, testcharsth,
>                   splitinds.characters, fus, parametersFABR );;
>      for paramap in possfus do
>        for map in ContainedMaps( paramap ) do
>          indth:= Set( InducedClassFunctionsByFusionMap( 2th, 2t,
>                           testcharsth, map ) );
>          if ForAll( Flat( MatScalarProducts( 2t, indth, indth ) ),
>                     IsInt ) and
>             ForAll( Flat( MatScalarProducts( 2t, indth,
>                               splitinds.characters ) ), IsInt ) then
>            # Use the 2-nd power map.
>            ind:= Concatenation( splitinds.characters, indth );
>            pow:= InitPowerMap( 2t, p );
>            if Congruences( 2t, ind, pow, p, false ) = true and
>               TransferDiagram( pow, 2tfust, PowerMap( t, p ) ) <> fail and
>               TransferDiagram( PowerMap( 2th, p ), map, pow ) <> fail and
>               TransferDiagram( PowerMap( 2s, p ), splitinds.map,
>                                pow ) <> fail then
>              poss:= PowerMapsAllowedBySymmetrizations( 2t, factirr, ind,
>                         pow, p, parametersFABR );
>              if Length( poss ) <> 0 then
>                r.pow2:= poss;
>                Add( good2, rec( table:= 2t,
>                                 choice:= r.choice,
>                                 2thfus2t:= map,
>                                 ind:= ind,
>                                 2sfus2t:= splitinds.map ) );
>              fi;
>            fi;
>          fi;
>        od;
>      od;
>    od;
gap> List( good2, x -> x.choice );
[ [ 45, 53, 127 ], [ 53 ], [ 53, 127 ] ]

##
gap> 2t:= good2[2].table;;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> 2thfus2t:= good2[2].2thfus2t;;
gap> 2sfus2t:= good2[2].2sfus2t;;
gap> ind:= good2[2].ind;;
gap> factirr:= List( Irr( t ), x -> x{ 2tfust } );;

##
gap> nothit_in_t:= Difference( mustsplit, Union( thfust, sfust ) );;
gap> nothit_in_2t:= PositionsProperty( 2tfust, i -> i in nothit_in_t );
[ 66, 67, 136, 137, 147, 148, 149, 150, 162, 163, 166, 167, 186, 187, 188, 
  189, 217, 218, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 234, 235, 
  236, 237, 242, 243 ]
gap> orders_2t:= OrdersClassRepresentatives( 2t );;
gap> orders_2t{ nothit_in_2t };
[ 10, 10, 20, 20, 23, 46, 23, 46, 24, 24, 25, 50, 30, 30, 30, 30, 40, 40, 44, 
  44, 46, 46, 46, 46, 47, 94, 47, 94, 104, 104, 55, 110, 60, 60 ]

##
gap> powermaps:= ComputedPowerMaps( 2t );;
gap> primes:= Filtered( [ 1 .. Maximum( orders_2t ) ], IsPrimeInt );;
gap> for p in primes do
>      pow:= InitPowerMap( 2t, p );
>      if TransferDiagram( pow, 2tfust, PowerMap( t, p ) ) = fail or
>         TransferDiagram( PowerMap( 2th, p ), 2thfus2t, pow ) = fail or
>         TransferDiagram( PowerMap( 2s, p ), 2sfus2t, pow ) = fail or
>         ConsiderSmallerPowerMaps( 2t, pow, p, false ) <> true or
>         Congruences( 2t, ind, pow, p, false ) <> true then
>        Error( "contradiction" );
>      fi;
>      poss:= PowerMapsAllowedBySymmetrizations( 2t, ind, ind,
>                 pow, p, parametersFABR );
>      if Length( poss ) = 1 then
>        powermaps[p]:= poss[1];
>      else
>        powermaps[p]:= pow;
>      fi;
>    od;

##
gap> known:= Filtered( nothit_in_2t,
>                i -> ForAll( powermaps, map -> IsInt( map[i] ) ) );
[ 147, 148, 149, 150, 166, 167, 228, 229, 230, 231, 236, 237 ]

##
gap> List( Difference( nothit_in_2t, known ),
>          i -> Number( powermaps, map -> IsList( map[i] ) ) );
[ 22, 22, 25, 25, 26, 26, 26, 26, 26, 26, 27, 27, 26, 26, 27, 27, 27, 27, 27, 
  27, 27, 27 ]
gap> oddprimes:= Difference( primes, [ 2 ] );;
gap> inv:= InverseMap( 2tfust );;
gap> for i in [ 1 .. Length( inv ) ] do
>      if IsList( inv[i] ) then
>        # the classes of g and g*z
>        pair:= inv[i];
>        for p in oddprimes do
>          if powermaps[p]{ pair } = [ pair, pair ] then
>            # the p-th powers of g and g*z are conj. to g or g*z
>            for k in Filtered( oddprimes,
>                               x -> orders_2t[ pair[1] ] mod x = 0 ) do
>              img:= powermaps[k][ pair[1] ];
>              if IsList( img ) then
>                if powermaps[p]{ img } = img then
>                  # the p-th power of g^k is conj. to g^k 
>                  powermaps[p]{ pair }:= pair;
>                elif powermaps[p]{ img } = Reversed( img ) then
>                  # the p-th power of g^k is conj. to g^k*z
>                  powermaps[p]{ pair }:= pair{ [ 2, 1 ] };
>                fi;
>              fi;
>            od;
>          fi;
>        od;
>      fi;
>    od;
gap> List( Difference( nothit_in_2t, known ),
>          i -> Number( powermaps, map -> IsList( map[i] ) ) );
[ 1, 1, 1, 1, 1, 1, 17, 17, 17, 17, 27, 27, 26, 26, 18, 18, 18, 18, 27, 27, 
  2, 2 ]

##
gap> pos:= [ 66, 67, 136, 137 ];;
gap> powermaps[5]{ pos };
[ [ 4, 5 ], [ 4, 5 ], [ 16, 17 ], [ 16, 17 ] ]
gap> powermaps[5]{ pos }:= [ 4, 5, 16, 17 ];;
gap> pos:= [ 162, 163 ];;
gap> powermaps[3]{ pos };
[ [ 53, 54 ], [ 53, 54 ] ]
gap> powermaps[3]{ pos }:= [ 53, 54 ];;

##
gap> pos:= [ 242, 243 ];;
gap> powermaps[3]{ pos };
[ [ 136, 137 ], [ 136, 137 ] ]
gap> powermaps[5]{ pos };
[ [ 78, 79 ], [ 78, 79 ] ]
gap> powermaps[3]{ [ 78, 79 ] };
[ 16, 17 ]
gap> powermaps[3]{ pos }:= [ 136, 137 ];;
gap> powermaps[5]{ pos }:= [ 78, 79 ];;

##
gap> pos:= Intersection( Difference( nothit_in_2t, known ),
>                        Positions( orders_2t, 46 ) );
[ 224, 225, 226, 227 ]
gap> powermaps[5]{ pos };
[ [ 226, 227 ], [ 226, 227 ], [ 224, 225 ], [ 224, 225 ] ]
gap> setGaloisInfo( powermaps, [ 224, 226 ], orders_2t, primes, Sqrt(-23) );
gap> setGaloisInfo( powermaps, [ 225, 227 ], orders_2t, primes, Sqrt(-23) );

##
gap> powermaps[23]{ pos };                                            
[ [ 4, 5 ], [ 4, 5 ], [ 4, 5 ], [ 4, 5 ] ]
gap> powermaps[23]{ pos }:= [ 4, 5, 4, 5 ];;
gap> ForAll( List( powermaps, x -> x{ pos } ), IsPositionsList );
true

##
gap> pos:= Intersection( nothit_in_2t, Positions( orders_2t, 30 ) );
[ 186, 187, 188, 189 ]
gap> Field( Flat( List( factirr, x -> x{ pos } ) ) )
>    = Field( Rationals, [ Sqrt( -15 ) ] );
true

##
gap> List( powermaps, x -> x[66] );
[ , 25, 66,, 4,, 66,,,, 66,, 66,,,, 66,, 66,,,, 66,,,,,, 66,, 66,,,,,, 66,,,, 
  66,, 66,,,, 66,,,,,, 66,,,,,, 66,, 66,,,,,, 66,,,, 66,, 66,,,,,, 66,,,, 66,,
  ,,,, 66,,,,,,,, 66,,,, 66,, 66,,,, 66,, 66 ]
gap> setGaloisInfo( powermaps, [ 186, 188 ], orders_2t, primes, Sqrt(-15) );
gap> setGaloisInfo( powermaps, [ 187, 189 ], orders_2t, primes, Sqrt(-15) );
gap> powermaps[3]{ pos };
[ [ 66, 67 ], [ 66, 67 ], [ 66, 67 ], [ 66, 67 ] ]
gap> powermaps[3]{ pos }:= [ 66, 67, 66, 67 ];;
gap> powermaps[5]{ pos };
[ [ 34, 35 ], [ 34, 35 ], [ 34, 35 ], [ 34, 35 ] ]
gap> powermaps[3]{ [ 34, 35 ] };
[ 4, 5 ]
gap> powermaps[5]{ [ 66, 67 ] };
[ 4, 5 ]
gap> powermaps[5]{ pos }:= [ 34, 35, 34, 35 ];;
gap> ForAll( List( powermaps, x -> x{ pos } ), IsPositionsList ); #  true
true

##
gap> pos:= Intersection( nothit_in_2t, Positions( orders_2t, 44 ) );
[ 222, 223 ]
gap> vals:= List( [ 1, -1, 11, -11 ], Sqrt );;
gap> good:= [];;
gap> for val in vals do
>      setGaloisInfo( powermaps, pos, orders_2t, primes, val );
>      indcyc:= InducedCyclic( 2t, pos, "all" );
>      if ForAll( indcyc, x -> IsInt( ScalarProduct( 2t, x, x ) ) ) then
>        minus:= MinusCharacter( indcyc[1], powermaps[2], 2 );
>        if ForAll( List( factirr, x -> ScalarProduct( 2t, x, minus ) ), 
>                   IsInt ) then
>          Add( good, val );
>        fi;
>      fi;
>    od;
gap> good = [ Sqrt( -11 ) ];
true
gap> setGaloisInfo( powermaps, pos, orders_2t, primes, good[1] );

##
gap> pos:= Intersection( nothit_in_2t, Positions( orders_2t, 104 ) );
[ 234, 235 ]
gap> vals:= List( [ 1, -1, 2, -2, 13, -13, 26, -26 ], Sqrt );;
gap> good:= [];;
gap> for val in vals do
>      setGaloisInfo( powermaps, pos, orders_2t, primes, val );
>      indcyc:= InducedCyclic( 2t, pos, "all" );
>      if ForAll( indcyc, x -> IsInt( ScalarProduct( 2t, x, x ) ) ) then
>        minus:= MinusCharacter( indcyc[1], powermaps[2], 2 );
>        if ForAll( List( factirr, x -> ScalarProduct( 2t, x, minus ) ), 
>                   IsInt ) then
>          Add( good, val );
>        fi;
>      fi;
>    od;
gap> good = [ Sqrt( -26 ) ];
true
gap> setGaloisInfo( powermaps, pos, orders_2t, primes, good[1] );

##
gap> pos:= Intersection( nothit_in_2t, Positions( orders_2t, 40 ) );
[ 217, 218 ]

##
gap> powermaps[2]{ pos };
[ [ 136, 137 ], [ 136, 137 ] ]
gap> TransferDiagram( powermaps[5], powermaps[2], powermaps[5] );
rec( impbetween := [ 131, 139, 217, 218 ], impinside1 := [  ], 
  impinside2 := [  ] )
gap> IsPositionsList( powermaps[2] );
true

##
gap> vals:= List( [ 1, -1, 2, -2, 5, -5, 10, -10 ], Sqrt );;
gap> good:= [];;
gap> for val in vals do
>      setGaloisInfo( powermaps, pos, orders_2t, primes, val );
>      indcyc:= InducedCyclic( 2t, pos, "all" );
>      if ForAll( indcyc, x -> IsInt( ScalarProduct( 2t, x, x ) ) ) then
>        minus:= MinusCharacter( indcyc[1], powermaps[2], 2 );
>        if ForAll( List( factirr, x -> ScalarProduct( 2t, x, minus ) ),
>                   IsInt ) then
>          Add( good, val );
>        fi;
>      fi;
>    od;
gap> good = [ Sqrt( 5 ), Sqrt( -5 ) ];
true

##
gap> indcyc:= InducedCyclic( 2t, Difference( nothit_in_2t, pos ), "all" );;
gap> indcyc:= Reduced( 2t, factirr, indcyc ).remainders;;
gap> setGaloisInfo( powermaps, pos, orders_2t, primes, Sqrt( 5 ) );
gap> indcyc40r5:= InducedCyclic( 2t, pos, "all" );;
gap> indcyc40r5:= Reduced( 2t, factirr, indcyc40r5 ).remainders;;
gap> testind:= Concatenation( ind, indcyc, indcyc40r5 );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> Length( lll.norms );
63
gap> Length( mustsplit );
63
gap> Length( Difference( [ 1 .. NrConjugacyClasses( t ) ],
>            Union( mustsplit, mustnotsplit ) ) );
14
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 63 + 14 );;
gap> List( emb.solutions, Length );
[ 63, 63, 63, 65, 65, 65 ]
gap> dec:= List( emb.solutions,
>              x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 1, 2, 3, 6 ]

##
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 61, 61 ]

##
gap> degreesum:= List( dec,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> Set( degreesum );
[ 4154780380522839827726467072000000 ]
gap> n:= Size( t ) - degreesum[1];
1100703586363451113472000000

##
gap> red:= List( dec, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> norm2[1] = norm2[2];
true
gap> norm2[1][1] = Sqrt( 2 * n );
true

##
gap> setGaloisInfo( powermaps, pos, orders_2t, primes, Sqrt( -5 ) );
gap> indcyc40i5:= InducedCyclic( 2t, pos, "all" );;
gap> indcyc40i5:= Reduced( 2t, factirr, indcyc40i5 ).remainders;;
gap> testind:= Concatenation( ind, indcyc, indcyc40i5 );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 63 + 14 );;
gap> List( emb.solutions, Length );
[ 63, 63, 63, 65, 65, 65 ]
gap> dec:= List( emb.solutions,
>              x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 3, 6 ]
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 63, 63, 61, 61 ]

##
gap> dec1:= dec{ [ 1, 2 ] };;
gap> dec2:= dec{ [ 3, 4 ] };;
gap> degreesum:= List( dec2,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> Set( degreesum );
[ 4154780380522839827726467072000000 ]
gap> n:= Size( t ) - degreesum[1];
1100703586363451113472000000
gap> red:= List( dec2, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> Length( Set( norm2 ) );
1
gap> norm2[1][1] = Sqrt( 2 * n );
true

##
gap> HasIrr( 2t );
false
gap> SetIrr( 2t, Concatenation( factirr, dec1[1].irreducibles ) );
gap> lib:= CharacterTable( "2.B" );;
gap> TransformingPermutationsCharacterTables( 2t, lib );
rec( columns := (4,5)(29,30)(34,35)(63,64)(66,67)(122,123)(125,126)(145,
    146)(186,187)(188,189)(224,225)(226,227), 
  group := <permutation group with 17 generators>, 
  rows := (185,213,243,236,191,205,225,229,247,200,232,222,207,216,187,206,
    212,234,194,244,217,202,245,199,238,235,221,192,214,230,201,186,211,227,
    226,208,198,242,218,193,209,220,196,210,241,203,189,224,219,197,204,223,
    240,190,215,195,233)(188,239)(231,246,237) )
gap> ResetFilterObj( 2t, HasIrr );
gap> SetIrr( 2t, Concatenation( factirr, dec1[2].irreducibles ) );
gap> TransformingPermutationsCharacterTables( 2t, lib );
rec( columns := (4,5)(29,30)(34,35)(63,64)(66,67)(122,123)(125,126)(143,
    144)(145,146)(186,187)(188,189)(224,225)(226,227)(244,245), 
  group := <permutation group with 17 generators>, 
  rows := (185,212,234,194,244,217,202,245,199,238,190,215,195,233)(186,211,
    227,226,208,198,242,218,193,209,220,196,210,241,203,189,224,219,197,204,
    223,240,235,221,192,214,230,201)(187,206,213,243,191,205,225,229,247,200,
    232,222,207,216)(188,239)(231,246,237) )

##
gap> good2[3].choice;
[ 53, 127 ]
gap> pos:= Positions( 2tfust, 127 );
[ 165 ]
gap> 2t:= good2[3].table;;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> 2thfus2t:= good2[3].2thfus2t;;
gap> 2sfus2t:= good2[3].2sfus2t;;
gap> ind:= good2[3].ind;;
gap> factirr:= List( Irr( t ), x -> x{ 2tfust } );;
gap> UniteSet( mustsplit, good2[3].choice );
gap> spl:= SortedList( Concatenation( [ 1 .. 247 ], pos ) );;
gap> testind:= Concatenation( good2[3].ind,
>        List( Concatenation( indcyc, indcyc40r5 ), x -> x{ spl } ) );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> Length( lll.norms );
64
gap> Length( mustsplit );
64
gap> Length( Difference( [ 1 .. NrConjugacyClasses( t ) ],
>            Union( mustsplit, mustnotsplit ) ) );
13
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 64+13 );;
gap> List( emb.solutions, Length );
[ 64, 64, 64, 65, 65, 65, 66, 66, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 69, 
  69, 69 ]
gap> dec:= List( emb.solutions,
>            x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 1, 2, 3, 6, 7, 8, 9, 16, 17, 18, 21 ]
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 61, 61, 63, 61, 61, 63, 61, 61, 61, 61 ]
gap> degreesum:= List( dec,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> degreesumset:= Set( degreesum );
[ 4154780380522839827726467072000000, 4154781481226426191177580544000000 ]
gap> n:= Size( t ) - degreesumset;
[ 1100703586363451113472000000, 0 ]
gap> List( degreesumset, x -> Positions( degreesum, x ) );
[ [ 1, 2, 4, 5, 7, 8, 9, 10 ], [ 3, 6 ] ]
gap> dec:= dec{ Positions( degreesum, degreesumset[1] ) };;
gap> red:= List( dec, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> Length( Set( norm2 ) );
1
gap> norm2[1][1] = Sqrt( 2 * n[1] );
true

##
gap> testind:= Concatenation( good2[3].ind,
>        List( Concatenation( indcyc, indcyc40i5 ), x -> x{ spl } ) );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 64+13 );;
gap> List( emb.solutions, Length );
[ 64, 64, 64, 65, 65, 65, 66, 66, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 69, 
  69, 69 ]
gap> dec:= List( emb.solutions,
>            x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 1, 2, 3, 6, 7, 8, 9, 16, 17, 18, 21 ]
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 61, 61, 63, 61, 61, 63, 61, 61, 61, 61 ]
gap> degreesum:= List( dec,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> degreesumset:= Set( degreesum );
[ 4154780380522839827726467072000000, 4154781481226426191177580544000000 ]
gap> n:= Size( t ) - degreesumset;
[ 1100703586363451113472000000, 0 ]
gap> List( degreesumset, x -> Positions( degreesum, x ) );
[ [ 1, 2, 4, 5, 7, 8, 9, 10 ], [ 3, 6 ] ]
gap> dec:= dec{ Positions( degreesum, degreesumset[1] ) };;
gap> red:= List( dec, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> Length( Set( norm2 ) );
1
gap> norm2[1][1] = Sqrt( 2 * n[1] );
true

##
gap> good2[1].choice;
[ 45, 53, 127 ]
gap> 2tfust:= GetFusionMap( good2[2].table, t );;
gap> pos:= Union( Positions( 2tfust, 45 ), Positions( 2tfust, 127 ) );
[ 57, 165 ]
gap> 2t:= good2[1].table;;
gap> 2tfust:= GetFusionMap( 2t, t );;
gap> 2thfus2t:= good2[1].2thfus2t;;
gap> 2sfus2t:= good2[1].2sfus2t;;
gap> ind:= good2[1].ind;;
gap> factirr:= List( Irr( t ), x -> x{ 2tfust } );;
gap> UniteSet( mustsplit, good2[1].choice );
gap> spl:= SortedList( Concatenation( [ 1 .. 247 ], pos ) );;
gap> testind:= Concatenation( good2[1].ind,
>        List( Concatenation( indcyc, indcyc40r5 ), x -> x{ spl } ) );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> Length( lll.norms );
65
gap> Length( mustsplit );
65
gap> Length( Difference( [ 1 .. NrConjugacyClasses( t ) ],
>            Union( mustsplit, mustnotsplit ) ) );
12
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 65+12 );;
gap> List( emb.solutions, Length );
[ 66, 66, 66, 66, 66, 66, 66, 66, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 
  67, 67, 67, 67, 67, 67, 67, 67, 68, 68, 68, 69, 69, 69, 69, 69, 69, 69, 69, 
  69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 71, 71, 71 ]
gap> dec:= List( emb.solutions,
>            x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 24, 25, 26, 27, 28, 29, 30, 33, 
  34, 35, 36, 45, 46, 47, 48, 51 ]
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 63, 63, 63, 61, 61, 61, 63, 61, 61, 61, 63, 63, 63, 61, 61, 61, 63, 61, 61, 
  61, 61, 61 ]
gap> degreesum:= List( dec,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> degreesumset:= Set( degreesum );
[ 4154780380522839827726467072000000, 4154781481226426191177580544000000 ]
gap> Size( t ) - degreesumset;
[ 1100703586363451113472000000, 0 ]
gap> Positions( degreesum, degreesumset[2] );
[ 1, 2, 3, 7, 11, 12, 13, 17 ]
gap> dec:= dec{ Positions( degreesum, degreesumset[1] ) };;
gap> red:= List( dec, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> Length( Set( norm2 ) );
1
gap> norm2[1][1];
0

##
gap> testind:= Concatenation( good2[1].ind,
>        List( Concatenation( indcyc, indcyc40i5 ), x -> x{ spl } ) );;
gap> lll:= LLL( 2t, testind, 99/100 );;
gap> gram:= MatScalarProducts( 2t, lll.remainders, lll.remainders );;
gap> emb:= OrthogonalEmbeddings( gram, 65+12 );;
gap> List( emb.solutions, Length );
[ 66, 66, 66, 66, 66, 66, 66, 66, 66, 67, 67, 67, 67, 67, 67, 67, 67, 67, 67, 
  67, 67, 67, 67, 67, 67, 67, 67, 68, 68, 68, 69, 69, 69, 69, 69, 69, 69, 69, 
  69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 71, 71, 71 ]
gap> dec:= List( emb.solutions,
>            x -> Decreased( 2t, lll.remainders, emb.vectors{ x } ) );;
gap> Positions( dec, fail );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 24, 25, 26, 27, 28, 29, 30, 33, 
  34, 35, 36, 45, 46, 47, 48, 51 ]
gap> dec:= Filtered( dec, x -> x <> fail );;
gap> List( dec, r -> Length( r.irreducibles ) );
[ 63, 63, 63, 61, 61, 61, 63, 61, 61, 61, 63, 63, 63, 61, 61, 61, 63, 61, 61, 
  61, 61, 61 ]
gap> degreesum:= List( dec,
>        r -> Sum( List( r.irreducibles, x -> x[1]^2 ) ) );;
gap> degreesumset:= Set( degreesum );
[ 4154780380522839827726467072000000, 4154781481226426191177580544000000 ]
gap> Size( t ) - degreesumset;
[ 1100703586363451113472000000, 0 ]
gap> Positions( degreesum, degreesumset[2] );
[ 1, 2, 3, 7, 11, 12, 13, 17 ]
gap> dec:= dec{ Positions( degreesum, degreesumset[1] ) };;
gap> red:= List( dec, r -> Reduced( 2t, r.irreducibles, testind ) );;
gap> norm2:= List( red, r -> First( r.remainders,
>                              x -> ScalarProduct( 2t, x, x ) = 2 ) );;
gap> Length( Set( norm2 ) );
1
gap> norm2[1][1];
0

##
gap> STOP_TEST( "ctblatlas.tst" );

#############################################################################
##
#E

