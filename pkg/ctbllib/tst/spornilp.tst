# This file was created automatically, do not edit!
#############################################################################
##
#W  spornilp.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "spornilp.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "spornilp.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/spornilp.xml (267-349)
gap> ApplyTheLemma:= function( tbl, maxesinfo )
>     local Gname, Gsize, cents, orders, result, Mtbl, Msize, maxc, i,
>           pi, pipart, c, Mclasslengths, Fit, excluded, Kclasses, Mbar,
>           Ksize, Sclasses, Ssize, d;
>     Gname:= Identifier( tbl );
>     Gsize:= Size( tbl );
>     cents:= SizesCentralizers( tbl );
>     orders:= OrdersClassRepresentatives( tbl );
>     result:= [ true, Gname, 0 ];
>     # Run over the relevant maximal subgroups.
>     for Mtbl in maxesinfo do
>       Msize:= Size( Mtbl );
>       # Run over nonidentity class representatives g of squarefree
>       # order, compute the largest c that occurs.
>       maxc:= 1;
>       for i in [ 2 .. NrConjugacyClasses( tbl ) ] do
>         pi:= Factors( orders[i] );
>         if IsSet( pi ) then
>           # The elements in class `i' have squarefree order.
>           pipart:= Product( Filtered( Factors( cents[i] ),
>                                       x -> x in pi ) );
>           c:= Gcd( pipart, Msize );
>           if maxc < c then
>             maxc:= c;
>           fi;
>         fi;
>       od;
>       if maxc * Msize >= Gsize then
>         # Criterion (a) is satisfied, try to exclude (b) and (c).
>         result[3]:= result[3] + 1;
>         Print( Gname, ": consider M = ", Identifier( Mtbl ),
>                ", c = ", StringPP( maxc ),
>                ", c * |M| / |G| >= ", Int( maxc * Msize / Gsize ),
>                "\n" );
>         Mclasslengths:= SizesConjugacyClasses( Mtbl );
>         Fit:= Mclasslengths{ ClassPositionsOfFittingSubgroup( Mtbl ) };
>         if Sum( Fit ) * Msize >= Gsize then
>           # Criterion (b1) is satisfied.
>           Print( Gname, ": not excludable by (b1)\n" );
>           result[1]:= false;
>         elif maxc * Msize < 2 * Gsize then
>           # Criterion (b2) is not satisfied.
>           Print( Gname, ":     excluded by (b2)\n" );
>         else
>           # Run over the normal subgroups of M.
>           excluded:= false;
>           for Kclasses in ClassPositionsOfNormalSubgroups( Mtbl ) do
>             Mbar:= Mtbl / Kclasses;
>             Ksize:= Sum( Mclasslengths{ Kclasses } );
>             if IsAlmostSimpleCharacterTable( Mbar ) and
>                Ksize * Msize < Gsize then
>               # We are in the situation of criterion (c).
>               # The socle is the unique minimal normal subgroup.
>               Sclasses:= ClassPositionsOfMinimalNormalSubgroups(
>                              Mbar )[1];
>               Ssize:= Sum( SizesConjugacyClasses( Mbar ){ Sclasses } );
>               d:= Int( maxc * Msize * Size( Mbar )
>                   / ( Gsize * Ssize ) );
>               # Try to show that all subgroups of index up to d
>               # in Mbar contain the socle.
>               if ForAll( [ 2 .. d ],
>                    n -> ForAll( PermChars( Mbar, rec( torso:= [ n ] ) ),
>                           chi -> IsSubset(
>                                      ClassPositionsOfKernel( chi ),
>                                      Sclasses ) ) ) then
>                 Print( Gname, ":     excluded by (c), |K| = ",
>                        StringPP( Ksize ), ", degree bound ", d, "\n" );
>                 excluded:= true;
>                 break;
>               fi;
>             fi;
>           od;
>           if not excluded then
>             Print( Gname, ": not excludable by (c)\n" );
>             result[1]:= false;
>           fi;
>         fi;
>       fi;
>     od;
>     return result;
> end;;

##  doc2/spornilp.xml (374-377)
gap> LoadPackage( "ctbllib", false );
true

##  doc2/spornilp.xml (385-451)
gap> info:= [];;                                       
gap> for name in AllCharacterTableNames( IsSporadicSimple, true,
>                                        IsDuplicateTable, false ) do
>      tbl:= CharacterTable( name );
>      if HasMaxes( tbl ) then
>        mx:= List( Maxes( tbl ), CharacterTable );  
>      elif name = "M" then
>        mx:= [ CharacterTable( "2.B" ) ];
>      else
>        Error( "this should not happen ...");
>      fi;
>      Add( info, ApplyTheLemma( tbl, mx ) );
>    od;
B: consider M = 2.2E6(2).2, c = 2^38, c * |M| / |G| >= 20
B:     excluded by (c), |K| = 2, degree bound 40
Co1: consider M = Co2, c = 2^13*3^5, c * |M| / |G| >= 20
Co1:     excluded by (c), |K| = 1, degree bound 20
Co1: consider M = 3.Suz.2, c = 2^13*3^5, c * |M| / |G| >= 1
Co1:     excluded by (b2)
Co2: consider M = U6(2).2, c = 2^16, c * |M| / |G| >= 28
Co2:     excluded by (c), |K| = 1, degree bound 56
Co2: consider M = 2^10:m22:2, c = 2^18, c * |M| / |G| >= 5
Co2:     excluded by (c), |K| = 2^10, degree bound 11
Co2: consider M = 2^1+8:s6f2, c = 2^18, c * |M| / |G| >= 4
Co2:     excluded by (c), |K| = 2^9, degree bound 4
Co3: consider M = McL.2, c = 2^4*3^4, c * |M| / |G| >= 4
Co3:     excluded by (c), |K| = 1, degree bound 9
F3+: consider M = Fi23, c = 2^9*3^9, c * |M| / |G| >= 32
F3+:     excluded by (c), |K| = 1, degree bound 32
Fi22: consider M = 2.U6(2), c = 2^7*3^6, c * |M| / |G| >= 26
Fi22:     excluded by (c), |K| = 2, degree bound 26
Fi22: consider M = O7(3), c = 2^7*3^6, c * |M| / |G| >= 6
Fi22:     excluded by (c), |K| = 1, degree bound 6
Fi22: consider M = Fi22M3, c = 2^7*3^6, c * |M| / |G| >= 6
Fi22:     excluded by (c), |K| = 1, degree bound 6
Fi22: consider M = O8+(2).3.2, c = 2^7*3^6, c * |M| / |G| >= 1
Fi22:     excluded by (b2)
Fi23: consider M = 2.Fi22, c = 2^8*3^9, c * |M| / |G| >= 159
Fi23:     excluded by (c), |K| = 2, degree bound 159
Fi23: consider M = O8+(3).3.2, c = 2^8*3^9, c * |M| / |G| >= 36
Fi23:     excluded by (c), |K| = 1, degree bound 219
HS: consider M = M22, c = 2^7, c * |M| / |G| >= 1
HS:     excluded by (b2)
M11: consider M = A6.2_3, c = 2^4, c * |M| / |G| >= 1
M11:     excluded by (b2)
M12: consider M = M11, c = 2^4, c * |M| / |G| >= 1
M12:     excluded by (b2)
M12: consider M = M12M2, c = 2^4, c * |M| / |G| >= 1
M12:     excluded by (b2)
M22: consider M = L3(4), c = 2^6, c * |M| / |G| >= 2
M22:     excluded by (c), |K| = 1, degree bound 2
M22: consider M = 2^4:a6, c = 2^7, c * |M| / |G| >= 1
M22:     excluded by (b2)
M23: consider M = M22, c = 2^7, c * |M| / |G| >= 5
M23:     excluded by (c), |K| = 1, degree bound 5
M24: consider M = M23, c = 2^7, c * |M| / |G| >= 5
M24:     excluded by (c), |K| = 1, degree bound 5
M24: consider M = 2^4:a8, c = 2^10, c * |M| / |G| >= 1
M24:     excluded by (b2)
McL: consider M = U4(3), c = 3^6, c * |M| / |G| >= 2
McL:     excluded by (c), |K| = 1, degree bound 2
Ru: consider M = 2F4(2)'.2, c = 2^12, c * |M| / |G| >= 1
Ru:     excluded by (b2)
Suz: consider M = G2(4), c = 2^12, c * |M| / |G| >= 2
Suz:     excluded by (c), |K| = 1, degree bound 2

##  doc2/spornilp.xml (467-473)
gap> Filtered( info, x -> x[3] = 0 );
[ [ true, "HN", 0 ], [ true, "He", 0 ], [ true, "J1", 0 ], 
  [ true, "J2", 0 ], [ true, "J3", 0 ], [ true, "J4", 0 ], 
  [ true, "Ly", 0 ], [ true, "M", 0 ], [ true, "ON", 0 ], 
  [ true, "Th", 0 ] ]

##  doc2/spornilp.xml (489-492)
gap> LoadPackage( "tomlib", false );
true

##  doc2/spornilp.xml (504-525)
gap> maximalpairs:= function( tom )
>    local g, max, result, i, u, n, prod;
>    g:= UnderlyingGroup( tom );
>    max:= 1;
>    result:= [];
>    for i in [ 1 .. Length( OrdersTom( tom ) ) ] do
>      u:= RepresentativeTom( tom, i );
>      if not IsTrivial( u ) and IsNilpotent( u ) then
>        n:= Normalizer( g, u );
>        prod:= Size( u ) * Size( n );
>        if max < prod then
>          max:= prod;
>          result:= [ [ u, n ] ];
>        elif max = prod then
>          Add( result, [ u, n ] );
>        fi;
>      fi;
>    od;
>    return result;
> end;;

##  doc2/spornilp.xml (534-545)
gap> info:= [];;
gap> for name in AllCharacterTableNames( IsSporadicSimple, true,
>                                        IsDuplicateTable, false ) do
>      tom:= TableOfMarks( name );
>      if tom <> fail then
>        Add( info, [ name, tom, maximalpairs( tom ) ] );
>      fi;
>    od;
gap> Length( info );
12

##  doc2/spornilp.xml (564-593)
gap> List( info, x -> Length( x[3] ) );
[ 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1 ]
gap> mat:= [];;
gap> for entry in info do
>      pair:= entry[3][1];                          # [ U, N_G(U) ]
>      bound:= Size( pair[1] ) * Size( pair[2] );   # |U|*|N_G(U)|
>      size:= Size( UnderlyingGroup( entry[2] ) );  # |G|
>      Add( mat, [ entry[1],
>                  StringPP( Size( pair[1] ) ),
>                  StringPP( Size( pair[2] ) ),
>                  Int( 10^6 * bound / size ) ] );
>      if Size( pair[1] ) * Size( pair[2] ) >= 21/100 * size then
>        Error("!");
>      fi;
>    od;
gap> PrintArray( mat );
[ [           Co3,           3^5,  2^5*3^7*5*11,          1886 ],
  [            HS,           2^6,       2^9*3*7,         15515 ],
  [            He,           2^6,    2^10*3^3*5,          2195 ],
  [            J1,            19,        2*3*19,         12337 ],
  [            J2,           2^6,       2^7*3^2,        121904 ],
  [            J3,           3^5,       2^3*3^5,          9404 ],
  [           M11,           3^2,       2^4*3^2,        163636 ],
  [           M12,           2^5,         2^6*3,         64646 ],
  [           M22,           2^4,     2^7*3^2*5,        207792 ],
  [           M23,           2^4,   2^7*3^2*5*7,         63241 ],
  [           M24,           2^6,    2^10*3^3*5,         36137 ],
  [           McL,           3^5,     2^4*3^6*5,         15779 ] ]

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "spornilp.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
