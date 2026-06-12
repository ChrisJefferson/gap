# This file was created automatically, do not edit!
#############################################################################
##
#W  hamilcyc.tst            GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "hamilcyc.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "hamilcyc.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/hamilcyc.xml (140-148)
gap> if not CompareVersionNumbers( GAPInfo.Version, "4.5" ) then
>      Error( "need GAP in version at least 4.5" );
>    fi;
gap> LoadPackage( "ctbllib", "1.2", false );
true
gap> LoadPackage( "tomlib", "1.1.1", false );
true

##  doc2/hamilcyc.xml (586-598)
gap> IsGeneratorsOfTransPermGroup:= function( G, list )
>     local S;
> 
>     if not IsTransitive( G ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
>     S:= SubgroupNC( G, list );
> 
>     return IsTransitive( S, MovedPoints( G ) )
>            and Size( S ) = Size( G );
> end;;

##  doc2/hamilcyc.xml (689-763)
gap> BindGlobal( "VertexDegreesGeneratingGraph",
>     function( G, classes, normalsubgroups )
>     local nccl, matrix, cents, powers, normalsubgroupspos, i, j, g_i,
>           nsg, g_j, gen, pair, d, pow;
> 
>     if not IsTransitive( G ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
> 
>     classes:= Filtered( classes,
>                         C -> Order( Representative( C ) ) <> 1 );
>     nccl:= Length( classes );
>     matrix:= [];
>     cents:= [];
>     powers:= [];
>     normalsubgroupspos:= [];
>     for i in [ 1 .. nccl ] do
>       matrix[i]:= [];
>       if IsBound( powers[i] ) then
>         # The i-th row equals the earlier row 'powers[i]'.
>         for j in [ 1 .. i ] do
>           matrix[i][j]:= matrix[ powers[i] ][j];
>           matrix[j][i]:= matrix[j][ powers[i] ];
>         od;
>       else
>         # We have to compute the values.
>         g_i:= Representative( classes[i] );
>         nsg:= Filtered( [ 1 .. Length( normalsubgroups ) ],
>                         i -> g_i in normalsubgroups[i] );
>         normalsubgroupspos[i]:= nsg;
>         cents[i]:= Centralizer( G, g_i );
>         for j in [ 1 .. i ] do
>           g_j:= Representative( classes[j] );
>           if IsBound( powers[j] ) then
>             matrix[i][j]:= matrix[i][ powers[j] ];
>             matrix[j][i]:= matrix[ powers[j] ][i];
>           elif not IsEmpty( Intersection( nsg, normalsubgroupspos[j] ) )
>                or ( Order( g_i ) = 2 and Order( g_j ) = 2
>                     and not IsDihedralGroup( G ) ) then
>             matrix[i][j]:= 0;
>             matrix[j][i]:= 0;
>           else
>             # Compute $d(g_i, g_j^G)$.
>             gen:= 0;
>             for pair in DoubleCosetRepsAndSizes( G, cents[j],
>                             cents[i] ) do
>               if IsGeneratorsOfTransPermGroup( G,
>                      [ g_i, g_j^pair[1] ] ) then
>                 gen:= gen + pair[2];
>               fi;
>             od;
>             matrix[i][j]:= gen / Size( cents[j] );
>             if i <> j then
>               matrix[j][i]:= gen / Size( cents[i] );
>             fi;
>           fi;
>         od;
> 
>         # For later, provide information about algebraic conjugacy.
>         for d in Difference( PrimeResidues( Order( g_i ) ), [ 1 ] ) do
>           pow:= g_i^d;
>           for j in [ i+1 .. nccl ] do
>             if not IsBound( powers[j] ) and pow in classes[j] then
>               powers[j]:= i;
>               break;
>             fi;
>           od;
>         od;
>       fi;
>     od;
> 
>     return matrix;
> end );

##  doc2/hamilcyc.xml (843-883)
gap> DeclareAttribute( "PrimitivePermutationCharacters",
>                      IsCharacterTable );
gap> InstallOtherMethod( PrimitivePermutationCharacters,
>     [ IsCharacterTable ],
>     function( tbl )
>     local maxes, i, fus, poss, tom, G;
> 
>     if HasMaxes( tbl ) then
>       maxes:= List( Maxes( tbl ), CharacterTable );
>       for i in [ 1 .. Length( maxes ) ] do
>         fus:= GetFusionMap( maxes[i], tbl );
>         if fus = fail then
>           fus:= PossibleClassFusions( maxes[i], tbl );
>           poss:= Set( fus,
>             map -> InducedClassFunctionsByFusionMap(
>                        maxes[i], tbl,
>                        [ TrivialCharacter( maxes[i] ) ], map )[1] );
>           if Length( poss ) = 1 then
>             maxes[i]:= poss[1];
>           else
>             return fail;
>           fi;
>         else
>           maxes[i]:= TrivialCharacter( maxes[i] )^tbl;
>         fi;
>       od;
>       return maxes;
>     elif HasFusionToTom( tbl ) then
>       tom:= TableOfMarks( tbl );
>       maxes:= MaximalSubgroupsTom( tom );
>       return PermCharsTom( tbl, tom ){ maxes[1] };
>     elif HasUnderlyingGroup( tbl ) then
>       G:= UnderlyingGroup( tbl );
>       return List( MaximalSubgroupClassReps( G ),
>                    M -> TrivialCharacter( M )^tbl );
>     fi;
> 
>     return fail;
> end );

##  doc2/hamilcyc.xml (915-926)
gap> LowerBoundsVertexDegrees:= function( classlengths, prim )
>     local sizes, nccl;
> 
>     nccl:= Length( classlengths );
>     return List( [ 2 .. nccl ],
>              i -> List( [ 2 .. nccl ],
>                     j -> Maximum( 0, classlengths[j] - Sum( prim,
>                     pi -> classlengths[j] * pi[j] * pi[i]
>                               / pi[1] ) ) ) );
> end;;

##  doc2/hamilcyc.xml (974-991)
gap> LowerBoundsVertexDegreesOfClosure:= function( classlengths, bounds )
>     local delta, newbounds, size, i, j;
> 
>     delta:= List( bounds, Sum );
>     newbounds:= List( bounds, ShallowCopy );
>     size:= Sum( classlengths );
>     for i in [ 1 .. Length( bounds ) ] do
>       for j in [ 1 .. Length( bounds ) ] do
>         if delta[i] + delta[j] >= size - 1 then
>           newbounds[i][j]:= classlengths[ j+1 ];
>         fi;
>       od;
>     od;
> 
>     return newbounds;
> end;;

##  doc2/hamilcyc.xml (1066-1112)
gap> CheckCriteriaOfPosaAndChvatal:= function( classlengths, bounds )
>     local size, degs, addinterval, badForPosa, badForChvatal1, pos,
>           half, i, low1, upp2, upp1, low2, badForChvatal, interval1,
>           interval2;
> 
>     size:= Sum( classlengths );
>     degs:= List( [ 2 .. Length( classlengths ) ],
>                  i -> [ Sum( bounds[ i-1 ] ), classlengths[i], i ] );
>     Sort( degs );
> 
>     addinterval:= function( intervals, low, upp )
>       if low <= upp then
>         Add( intervals, [ low, upp ] );
>       fi;
>     end;
> 
>     badForPosa:= [];
>     badForChvatal1:= [];
>     pos:= 1;
>     half:= Int( size / 2 ) - 1;
>     for i in [ 1 .. Length( degs ) ] do
>       # We have pos = c_1 + c_2 + \cdots + c_{i-1} + 1
>       low1:= Maximum( pos, degs[i][1] );  # L_i
>       upp2:= Minimum( half, size-1-pos, size-1-degs[i][1] ); # U'_i
>       pos:= pos + degs[i][2];
>       upp1:= Minimum( half, pos-1 ); # U_i
>       low2:= Maximum( 1, size-pos ); # L'_i
>       addinterval( badForPosa, low1, upp1 );
>       addinterval( badForChvatal1, low2, upp2 );
>     od;
> 
>     # Intersect intervals.
>     badForChvatal:= [];
>     for interval1 in badForPosa do
>       for interval2 in badForChvatal1 do
>         addinterval( badForChvatal,
>                      Maximum( interval1[1], interval2[1] ),
>                      Minimum( interval1[2], interval2[2] ) );
>       od;
>     od;
> 
>     return rec( badForPosa:= badForPosa,
>                 badForChvatal:= Set( badForChvatal ),
>                 data:= degs );
> end;;

##  doc2/hamilcyc.xml (1144-1180)
gap> HamiltonianCycleInfo:= function( classlengths, bounds )
>     local i, result, res, oldbounds;
> 
>     i:= 0;
>     result:= rec( Posa:= fail, Chvatal:= fail );
>     repeat
>       res:= CheckCriteriaOfPosaAndChvatal( classlengths, bounds );
>       if result.Posa = fail and IsEmpty( res.badForPosa ) then
>         result.Posa:= i;
>       fi;
>       if result.Chvatal = fail and IsEmpty( res.badForChvatal ) then
>         result.Chvatal:= i;
>       fi;
>       i:= i+1;
>       oldbounds:= bounds;
>       bounds:= LowerBoundsVertexDegreesOfClosure( classlengths,
>                    bounds );
>     until oldbounds = bounds;
> 
>     if result.Posa <> fail then
>       if result.Posa <> result.Chvatal then
>         return Concatenation(
>             "Chvatal for ", Ordinal( result.Chvatal ), " closure, ",
>             "Posa for ", Ordinal( result.Posa ), " closure" );
>       else
>         return Concatenation( "Posa for ", Ordinal( result.Posa ),
>             " closure" );
>       fi;
>     elif result.Chvatal <> fail then
>       return Concatenation( "Chvatal for ", Ordinal( result.Chvatal ),
>                             " closure" );
>     else
>       return "no decision";
>     fi;
> end;;

##  doc2/hamilcyc.xml (1221-1233)
gap> HamiltonianCycleInfoFromCharacterTable:= function( tbl )
>     local prim, classlengths, bounds;
> 
>     prim:= PrimitivePermutationCharacters( tbl );
>     if prim = fail then
>       return "no prim. perm. characters";
>     fi;
>     classlengths:= SizesConjugacyClasses( tbl );
>     bounds:= LowerBoundsVertexDegrees( classlengths, prim );
>     return HamiltonianCycleInfo( classlengths, bounds );
> end;;

##  doc2/hamilcyc.xml (1255-1267)
gap> spornames:= AllCharacterTableNames( IsSporadicSimple, true,
>                    IsDuplicateTable, false );
[ "B", "Co1", "Co2", "Co3", "F3+", "Fi22", "Fi23", "HN", "HS", "He", 
  "J1", "J2", "J3", "J4", "Ly", "M", "M11", "M12", "M22", "M23", 
  "M24", "McL", "ON", "Ru", "Suz", "Th" ]
gap> for tbl in List( spornames, CharacterTable ) do
>      info:= HamiltonianCycleInfoFromCharacterTable( tbl );
>      if info <> "Posa for 0th closure" then
>        Print( Identifier( tbl ), ": ", info, "\n" );
>      fi;
>    od;

##  doc2/hamilcyc.xml (1337-1344)
gap> dir:= DirectoriesPackageLibrary( "ctbllib", "data" );;
gap> filename:= Filename( dir, "prim_perm_M.json" );;
gap> primdata:= EvalString( StringFile( filename ) )[2];;
gap> Length( primdata );
46
gap> m:= CharacterTable( "M" );;

##  doc2/hamilcyc.xml (1355-1368)
gap> s:= "dummy";;      #  Avoid a message about an unbound variable ...
gap> poss:= "dummy";;   #  Avoid a message about an unbound variable ...
gap> for entry in primdata do
>      if not IsBound( entry[2] ) then
>        s:= CharacterTable( entry[1] );
>        poss:= Set( PossibleClassFusions( s, m ),
>                    x -> InducedClassFunctionsByFusionMap( s, m,
>                             [ TrivialCharacter( s ) ], x )[1] );
>        entry[2]:= List( [ 1 .. NrConjugacyClasses( m ) ],
>                         i -> Maximum( List( poss, x -> x[i] ) ) );
>      fi;
>    od;

##  doc2/hamilcyc.xml (1398-1402)
gap> prim:= List( primdata, x -> x[2] );;
gap> classlengths:= SizesConjugacyClasses( m );;
gap> bounds:= LowerBoundsVertexDegrees( classlengths, prim );;

##  doc2/hamilcyc.xml (1414-1418)
gap> degs:= List( bounds, Sum );;
gap> Int( 100000000 * Minimum( degs ) / Size( m ) );
99999987

##  doc2/hamilcyc.xml (1469-1506)
gap> PossibleClassFusions( CharacterTable( "U3(8).3_2" ), m );
[  ]
gap> badclasses:= [];;
gap> names:= [
>    [ "L2(13)", "L2(13).2" ],
>    [ "Sz(8)", "Sz(8).3" ],
>    [ "U3(4)", "U3(4).2", "U3(4).4" ],
>    [ "U3(8)", "U3(8).2", "U3(8).3_1", "U3(8).3_2", "U3(8).3_3",
>               "U3(8).6" ],
>    ];;
gap> for list in names do
>      t:= CharacterTable( list[1] );
>      tfusm:= PossibleClassFusions( t, m );
>      UniteSet( badclasses, Flat( tfusm ) );
>      for nam in list{ [ 2 .. Length( list ) ] } do
>        ext:= CharacterTable( nam );
>        for map1 in PossibleClassFusions( t, ext ) do
>          inv:= InverseMap( map1 );
>          for map2 in tfusm do
>            init:= CompositionMaps( map2, inv );
>            UniteSet( badclasses, Flat( PossibleClassFusions( ext, m,
>                rec( fusionmap:= init ) ) ) );
>          od;
>        od;
>      od;
>    od;
gap> badclasses;
[ 1, 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 17, 18, 19, 20, 21, 22, 
  24, 25, 27, 28, 30, 32, 33, 35, 36, 38, 39, 40, 42, 43, 44, 45, 46, 
  48, 49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 70, 72, 73, 78, 
  82, 85, 86 ]
gap> Length( badclasses );
55
gap> bad:= Sum( classlengths{ badclasses } ) / Size( m );;
gap> Int( 10000 * bad ); 
97

##  doc2/hamilcyc.xml (1568-1577)
gap> prim:= List( primdata, x -> x[2] );;
gap> badpos:= Difference( badclasses, [ 1 ] ) - 1;;
gap> bounds:= LowerBoundsVertexDegrees( classlengths, prim );;
gap> for i in badpos do
>      for j in badpos do
>        bounds[i][j]:= 0;
>      od;
>    od;

##  doc2/hamilcyc.xml (1605-1613)
gap> degs:= List( bounds, Sum );;
gap> Int( 10000 * Minimum( degs ) / Size( m ) );
9902
gap> goodpos:= Difference( [ 1 .. NrConjugacyClasses( m ) - 1 ],
>                          badpos );;
gap> Int( 100000000 * Minimum( degs{ goodpos } ) / Size( m ) );
99999987

##  doc2/hamilcyc.xml (1630-1655)
gap> spornames:= AllCharacterTableNames( IsSporadicSimple, true,
>                    IsDuplicateTable, false );;
gap> sporautnames:= AllCharacterTableNames( IsSporadicSimple, true,
>                       IsDuplicateTable, false,
>                       OfThose, AutomorphismGroup );;
gap> sporautnames:= Difference( sporautnames, spornames );
[ "F3+.2", "Fi22.2", "HN.2", "HS.2", "He.2", "J2.2", "J3.2", "M12.2", 
  "M22.2", "McL.2", "ON.2", "Suz.2" ]
gap> for tbl in List( sporautnames, CharacterTable ) do
>      info:= HamiltonianCycleInfoFromCharacterTable( tbl );
>      Print( Identifier( tbl ), ": ", info, "\n" );
>    od;
F3+.2: Chvatal for 0th closure, Posa for 1st closure
Fi22.2: Chvatal for 0th closure, Posa for 1st closure
HN.2: Chvatal for 0th closure, Posa for 1st closure
HS.2: Chvatal for 1st closure, Posa for 2nd closure
He.2: Chvatal for 0th closure, Posa for 1st closure
J2.2: Chvatal for 0th closure, Posa for 1st closure
J3.2: Chvatal for 0th closure, Posa for 1st closure
M12.2: Chvatal for 0th closure, Posa for 1st closure
M22.2: Posa for 1st closure
McL.2: Chvatal for 0th closure, Posa for 1st closure
ON.2: Chvatal for 0th closure, Posa for 1st closure
Suz.2: Chvatal for 0th closure, Posa for 1st closure

##  doc2/hamilcyc.xml (1672-1680)
gap> for tbl in List( [ 5 .. 13 ], i -> CharacterTable(
>                 Concatenation( "A", String( i ) ) ) )  do
>      info:= HamiltonianCycleInfoFromCharacterTable( tbl );
>      if info <> "Posa for 0th closure" then
>        Print( Identifier( tbl ), ": ", info, "\n" );
>      fi;
>    od;

##  doc2/hamilcyc.xml (1689-1704)
gap> for tbl in List( [ 5 .. 13 ], i -> CharacterTable(
>                 Concatenation( "S", String( i ) ) ) )  do
>      info:= HamiltonianCycleInfoFromCharacterTable( tbl );
>      Print( Identifier( tbl ), ": ", info, "\n" );
>    od;
A5.2: no decision
A6.2_1: Chvatal for 4th closure, Posa for 5th closure
A7.2: Posa for 1st closure
A8.2: Chvatal for 2nd closure, Posa for 3rd closure
A9.2: Chvatal for 2nd closure, Posa for 3rd closure
A10.2: Chvatal for 2nd closure, Posa for 3rd closure
A11.2: Posa for 1st closure
A12.2: Chvatal for 2nd closure, Posa for 3rd closure
A13.2: Posa for 1st closure

##  doc2/hamilcyc.xml (1770-1785)
gap> HamiltonianCycleInfoFromGroup:= function( G )
>     local ccl, nsg, der, degrees, classlengths;
>     ccl:= ConjugacyClasses( G );
>     if IsPerfect( G ) then
>       nsg:= [];
>     else
>       der:= DerivedSubgroup( G );
>       nsg:= Concatenation( [ der ],
>                 IntermediateSubgroups( G, der ).subgroups );
>     fi;
>     degrees:= VertexDegreesGeneratingGraph( G, ccl, nsg );
>     classlengths:= List( ccl, Size );
>     return HamiltonianCycleInfo( classlengths, degrees );        
> end;;

##  doc2/hamilcyc.xml (1797-1819)
gap> grps:= AllSmallNonabelianSimpleGroups( [ 1 .. 10^6 ] );;         
gap> Length( grps );
56
gap> List( grps, StructureDescription );
[ "A5", "PSL(3,2)", "A6", "PSL(2,8)", "PSL(2,11)", "PSL(2,13)", 
  "PSL(2,17)", "A7", "PSL(2,19)", "PSL(2,16)", "PSL(3,3)", 
  "PSU(3,3)", "PSL(2,23)", "PSL(2,25)", "M11", "PSL(2,27)", 
  "PSL(2,29)", "PSL(2,31)", "A8", "PSL(3,4)", "PSL(2,37)", "O(5,3)", 
  "Sz(8)", "PSL(2,32)", "PSL(2,41)", "PSL(2,43)", "PSL(2,47)", 
  "PSL(2,49)", "PSU(3,4)", "PSL(2,53)", "M12", "PSL(2,59)", 
  "PSL(2,61)", "PSU(3,5)", "PSL(2,67)", "J1", "PSL(2,71)", "A9", 
  "PSL(2,73)", "PSL(2,79)", "PSL(2,64)", "PSL(2,81)", "PSL(2,83)", 
  "PSL(2,89)", "PSL(3,5)", "M22", "PSL(2,97)", "PSL(2,101)", 
  "PSL(2,103)", "HJ", "PSL(2,107)", "PSL(2,109)", "PSL(2,113)", 
  "PSL(2,121)", "PSL(2,125)", "O(5,4)" ]
gap> for g in grps do                                             
>      info:= HamiltonianCycleInfoFromGroup( g );
>      if info <> "Posa for 0th closure" then
>        Print( StructureDescription( g ), ": ", info, "\n" );
>      fi;
>    od;

##  doc2/hamilcyc.xml (1957-1972)
gap> orders:= Filtered( [ 10^6+4, 10^6+8 .. 10^7 ],
>      n -> IsomorphismTypeInfoFiniteSimpleGroup( n ) <> fail );
[ 1024128, 1123980, 1285608, 1342740, 1451520, 1653900, 1721400, 
  1814400, 1876896, 1934868, 2097024, 2165292, 2328648, 2413320, 
  2588772, 2867580, 2964780, 3265920, 3483840, 3594432, 3822588, 
  3940200, 4245696, 4680000, 4696860, 5515776, 5544672, 5663616, 
  5848428, 6004380, 6065280, 6324552, 6825840, 6998640, 7174332, 
  7906500, 8487168, 9095592, 9732420, 9951120, 9999360 ]
gap> Length( orders );
41
gap> info:= List( orders, IsomorphismTypeInfoFiniteSimpleGroup );;
gap> Number( info, x -> IsBound( x.series ) and x.series = "L"
>                       and x.parameter[1] = 2 );
31

##  doc2/hamilcyc.xml (1987-2018)
gap> info:= Filtered( info, x -> not IsBound( x.series ) or
>             x.series <> "L" or x.parameter[1] <> 2 );
[ rec( name := "B(3,2) = O(7,2) ~ C(3,2) = S(6,2)", 
      parameter := [ 3, 2 ], series := "B", shortname := "S6(2)" ), 
  rec( name := "A(10)", parameter := 10, series := "A", 
      shortname := "A10" ), 
  rec( name := "A(2,7) = L(3,7) ", parameter := [ 3, 7 ], 
      series := "L", shortname := "L3(7)" ), 
  rec( name := "2A(3,3) = U(4,3) ~ 2D(3,3) = O-(6,3)", 
      parameter := [ 3, 3 ], series := "2A", shortname := "U4(3)" ), 
  rec( name := "G(2,3)", parameter := 3, series := "G", 
      shortname := "G2(3)" ), 
  rec( name := "B(2,5) = O(5,5) ~ C(2,5) = S(4,5)", 
      parameter := [ 2, 5 ], series := "B", shortname := "S4(5)" ), 
  rec( name := "2A(2,8) = U(3,8)", parameter := [ 2, 8 ], 
      series := "2A", shortname := "U3(8)" ), 
  rec( name := "2A(2,7) = U(3,7)", parameter := [ 2, 7 ], 
      series := "2A", shortname := "U3(7)" ), 
  rec( name := "A(3,3) = L(4,3) ~ D(3,3) = O+(6,3) ", 
      parameter := [ 4, 3 ], series := "L", shortname := "L4(3)" ), 
  rec( name := "A(4,2) = L(5,2) ", parameter := [ 5, 2 ], 
      series := "L", shortname := "L5(2)" ) ]
gap> names:= [ "S6(2)", "A10", "L3(7)", "U4(3)", "G2(3)", "S4(5)",
>              "U3(8)", "U3(7)", "L4(3)", "L5(2)" ];;
gap> for tbl in List( names, CharacterTable ) do
>      info:= HamiltonianCycleInfoFromCharacterTable( tbl );
>      if info <> "Posa for 0th closure" then
>        Print( Identifier( tbl ), ": ", info, "\n" );
>      fi;
>    od;

##  doc2/hamilcyc.xml (2049-2180)
gap> grps:= AllSmallNonabelianSimpleGroups( [ 1 .. 10^6 ] );;         
gap> epi:= "dummy";;   #  Avoid a message about an unbound variable ...
gap> for simple in grps do
>      for n in [ 1 .. LogInt( 10^6, Size( simple ) ) ] do
>        # Compute the n-fold direct product S^n.
>        soc:= CallFuncList( DirectProduct,
>                            ListWithIdenticalEntries( n, simple ) );
>        # Compute Aut(S^n) as a permutation group.
>        aut:= Image( IsomorphismPermGroup( AutomorphismGroup( soc ) ) );
>        aut:= Image( SmallerDegreePermutationRepresentation( aut ) );
>        # Compute class representatives of subgroups of
>        # Aut(S^n)/Inn(S^n).
>        socle:= Socle( aut );
>        epi:= NaturalHomomorphismByNormalSubgroup( aut, socle );
>        # Compute the candidates for G.  (By the above computations,
>        # we need not consider simple groups.)
>        reps:= List( ConjugacyClassesSubgroups( Image( epi ) ),
>                     Representative );
>        reps:= Filtered( reps, x -> IsCyclic( x ) and Size( x ) <> 1 );
>        greps:= Filtered( List( reps, x -> PreImages( epi, x ) ),
>                      x -> Length( MinimalNormalSubgroups( x ) ) = 1 );
>        for g in greps do
>          # We have to deal with a *transitive* permutation group.
>          # (Each group in question acts faithfully on an orbit.)
>          if not IsTransitive( g ) then
>            g:= First( List( Orbits( g, MovedPoints( g ) ),
>                             x -> Action( g, x ) ),
>                       x -> Size( x ) = Size( g ) );
>          fi;
>          # Check this group G.
>          info:= HamiltonianCycleInfoFromGroup( g );
>          Print( Name( simple ), "^", n, ".", Size( g ) / Size( soc ),
>                 ": ", info, "\n" );
>        od;
>      od;
>    od;
A5^1.2: Posa for 2nd closure
A5^2.2: Posa for 0th closure
A5^2.4: Posa for 0th closure
A5^3.3: Posa for 0th closure
A5^3.6: Chvatal for 1st closure, Posa for 2nd closure
PSL(2,7)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,7)^2.2: Posa for 0th closure
PSL(2,7)^2.4: Posa for 0th closure
A6^1.2: Chvatal for 0th closure, Posa for 1st closure
A6^1.2: Chvatal for 4th closure, Posa for 5th closure
A6^1.2: Chvatal for 0th closure, Posa for 1st closure
A6^2.2: Posa for 0th closure
A6^2.4: Posa for 0th closure
A6^2.4: Posa for 0th closure
A6^2.4: Posa for 0th closure
PSL(2,8)^1.3: Posa for 0th closure
PSL(2,8)^2.2: Posa for 0th closure
PSL(2,8)^2.6: Chvatal for 0th closure, Posa for 1st closure
PSL(2,11)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,11)^2.2: Posa for 0th closure
PSL(2,11)^2.4: Posa for 0th closure
PSL(2,13)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,17)^1.2: Chvatal for 0th closure, Posa for 1st closure
A7^1.2: Posa for 1st closure
PSL(2,19)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,16)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,16)^1.4: Chvatal for 0th closure, Posa for 1st closure
PSL(3,3)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSU(3,3)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,23)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,25)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,25)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,25)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,27)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,27)^1.3: Posa for 0th closure
PSL(2,27)^1.6: Chvatal for 0th closure, Posa for 1st closure
PSL(2,29)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,31)^1.2: Chvatal for 0th closure, Posa for 1st closure
A8^1.2: Chvatal for 2nd closure, Posa for 3rd closure
PSL(3,4)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(3,4)^1.2: Chvatal for 1st closure, Posa for 2nd closure
PSL(3,4)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(3,4)^1.3: Posa for 0th closure
PSL(3,4)^1.6: Chvatal for 0th closure, Posa for 1st closure
PSL(2,37)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSp(4,3)^1.2: Chvatal for 1st closure, Posa for 2nd closure
Sz(8)^1.3: Posa for 0th closure
PSL(2,32)^1.5: Posa for 0th closure
PSL(2,41)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,43)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,47)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,49)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,49)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,49)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSU(3,4)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSU(3,4)^1.4: Chvatal for 0th closure, Posa for 1st closure
PSL(2,53)^1.2: Chvatal for 0th closure, Posa for 1st closure
M12^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,59)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,61)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSU(3,5)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSU(3,5)^1.3: Posa for 0th closure
PSL(2,67)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,71)^1.2: Chvatal for 0th closure, Posa for 1st closure
A9^1.2: Chvatal for 2nd closure, Posa for 3rd closure
PSL(2,73)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,79)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,64)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,64)^1.3: Posa for 0th closure
PSL(2,64)^1.6: Chvatal for 0th closure, Posa for 1st closure
PSL(2,81)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,81)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,81)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,81)^1.4: Chvatal for 0th closure, Posa for 1st closure
PSL(2,81)^1.4: Chvatal for 0th closure, Posa for 1st closure
PSL(2,83)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,89)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(3,5)^1.2: Chvatal for 0th closure, Posa for 1st closure
M22^1.2: Posa for 1st closure
PSL(2,97)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,101)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,103)^1.2: Chvatal for 0th closure, Posa for 1st closure
J_2^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,107)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,109)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,113)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,121)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,121)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,121)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,125)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSL(2,125)^1.3: Posa for 0th closure
PSL(2,125)^1.6: Chvatal for 0th closure, Posa for 1st closure
PSp(4,4)^1.2: Chvatal for 0th closure, Posa for 1st closure
PSp(4,4)^1.4: Posa for 0th closure

##  doc2/hamilcyc.xml (2546-2574)
gap> TestL2q:= function( t )
>    local name, orders, nccl, cl, prim, bds, n, ord;
> 
>    name:= Identifier( t );
>    orders:= OrdersClassRepresentatives( t );
>    nccl:= Length( orders );
>    cl:= SizesConjugacyClasses( t );
>    prim:= PrimitivePermutationCharacters( t );
>    bds:= List( LowerBoundsVertexDegrees( cl, prim ), Sum );
>    n:= List( [ 1 .. 5 ], i -> Sum( cl{ Filtered( [ 1 .. nccl ],
>                                        x -> orders[x] = i ) } ) );
>    if ForAny( Filtered( [ 1 .. nccl ], i -> orders[i] > 5 ),
>               i -> bds[i-1] <= Size( t ) / 2 ) then
>      Error( "problem with large orders for ", name );
>    elif ForAny( Filtered( [ 1 .. nccl ], i -> orders[i] = 2 ),
>                 i -> bds[i-1] <= n[2] ) then
>      Error( "problem with order 2 for ", name, "\n" );
>    elif ForAny( Filtered( [ 1 .. nccl ],
>                           i -> orders[i] in [ 3 .. 5 ] ),
>                 i -> bds[i-1] <= Sum( n{ [ 2 .. 5 ] } ) ) then
>      Error( "problem with order in [ 3 .. 5 ] for ", name );
>    fi;
> end;;
gap> for q in Filtered( [ 13 .. 59 ], IsPrimePowerInt ) do
>      TestL2q( CharacterTable(
>                   Concatenation( "L2(", String( q ), ")" ) ) );
>    od;

##  doc2/hamilcyc.xml (2584-2591)
gap> for q in Filtered( [ 2 .. 11 ], IsPrimePowerInt ) do
>      info:= HamiltonianCycleInfoFromGroup( PSL( 2, q ) );
>      if info <> "Posa for 0th closure" then
>        Print( q, ": ", info, "\n" );
>      fi;
>    od;

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "hamilcyc.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
