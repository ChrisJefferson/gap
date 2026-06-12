# This file was created automatically, do not edit!
#############################################################################
##
#W  probgen.tst             GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "probgen.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "probgen.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/probgen.xml (557-566)
gap> CompareVersionNumbers( GAPInfo.Version, "4.5.0" );
true
gap> LoadPackage( "ctbllib", "1.2", false );
true
gap> LoadPackage( "tomlib", "1.2", false );
true
gap> LoadPackage( "atlasrep", "1.5", false );
true

##  doc2/probgen.xml (577-585)
gap> max:= GAPInfo.CommandLineOptions.o;;
gap> if not ( ( IsSubset( max, "m" ) and
>               Int( Filtered( max, IsDigitChar ) ) >= 800 ) or
>             ( IsSubset( max, "g" ) and
>               Int( Filtered( max, IsDigitChar ) ) >= 1 ) ) then
>      Print( "the maximal allowed memory might be too small\n" );
>    fi;

##  doc2/probgen.xml (604-611)
gap> staterandom:= [ State( GlobalRandomSource ),
>                    State( GlobalMersenneTwister ) ];;
gap> ResetGlobalRandomNumberGenerators:= function()
>     Reset( GlobalRandomSource, staterandom[1] );
>     Reset( GlobalMersenneTwister, staterandom[2] );
> end;;

##  doc2/probgen.xml (948-954)
gap> if not IsBound( PositionsProperty ) then
>      PositionsProperty:= function( list, prop )
>        return Filtered( [ 1 .. Length( list ) ], i -> prop( list[i] ) );
>      end;
>    fi;

##  doc2/probgen.xml (1019-1054)
gap> BindGlobal( "TripleWithProperty", function( threelists, prop )
>     local i, j, k, test;
> 
>     for i in threelists[1] do
>       for j in threelists[2] do
>         for k in threelists[3] do
>           test:= [ i, j, k ];
>           if prop( test ) then
>               return test;
>           fi;
>         od;
>       od;
>     od;
> 
>     return fail;
> end );
gap> BindGlobal( "QuadrupleWithProperty", function( fourlists, prop )
>     local i, j, k, l, test;
> 
>     for i in fourlists[1] do
>       for j in fourlists[2] do
>         for k in fourlists[3] do
>           for l in fourlists[4] do
>             test:= [ i, j, k, l ];
>             if prop( test ) then
>               return test;
>             fi;
>           od;
>         od;
>       od;
>     od;
> 
>     return fail;
> end );

##  doc2/probgen.xml (1089-1101)
gap> BindGlobal( "PrintFormattedArray", function( array )
>      local colwidths, n, row;
>      array:= List( array, row -> List( row, String ) );
>      colwidths:= List( TransposedMat( array ),
>                        col -> Maximum( List( col, Length ) ) );
>      n:= Length( array[1] );
>      for row in List( array, row -> List( [ 1 .. n ],
>                   i -> String( row[i], colwidths[i] ) ) ) do
>        Print( "  ", JoinStringsWithSeparator( row, " " ), "\n" );
>      od;
> end );

##  doc2/probgen.xml (1115-1132)
gap> BindGlobal( "NeededVariables", NamesUserGVars() );
gap> BindGlobal( "CleanWorkspace", function()
>       local name, record;
> 
>       for name in Difference( NamesUserGVars(), NeededVariables ) do
>        if not IsReadOnlyGlobal( name ) then
>          UnbindGlobal( name );
>        fi;
>      od;
>      for record in [ LIBTOMKNOWN, LIBTABLE ] do
>        for name in RecNames( record.LOADSTATUS ) do
>          Unbind( record.LOADSTATUS.( name ) );
>          Unbind( record.( name ) );
>        od;
>      od;
> end );

##  doc2/probgen.xml (1171-1186)
gap> if not IsBound( PossiblePermutationCharacters ) then
>      BindGlobal( "PossiblePermutationCharacters", function( sub, tbl )
>        local fus, triv;
> 
>        fus:= PossibleClassFusions( sub, tbl );
>        if fus = fail then
>          return fail;
>        fi;
>        triv:= [ TrivialCharacter( sub ) ];
> 
>        return Set(
>            List( fus, map -> Induced( sub, tbl, triv, map )[1] ) );
>      end );
>    fi;

##  doc2/probgen.xml (1256-1296)
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

##  doc2/probgen.xml (1365-1375)
gap> BindGlobal( "ApproxP", function( primitives, spos )
>     local sum;
> 
>     sum:= ShallowCopy( Sum( List( primitives,
>                                   pi -> pi[ spos ] * pi / pi[1] ) ) );
>     sum[1]:= 0;
> 
>     return sum;
> end );

##  doc2/probgen.xml (1423-1447)
gap> BindGlobal( "ProbGenInfoSimple", function( tbl )
>     local prim, max, min, bound, s;
>     prim:= PrimitivePermutationCharacters( tbl );
>     if prim = fail then
>       return fail;
>     fi;
>     max:= List( [ 1 .. NrConjugacyClasses( tbl ) ],
>                 i -> Maximum( ApproxP( prim, i ) ) );
>     min:= Minimum( max );
>     bound:= Inverse( min );
>     if IsInt( bound ) then
>       bound:= bound - 1;
>     else
>       bound:= Int( bound );
>     fi;
>     s:= PositionsProperty( max, x -> x = min );
>     s:= List( Set( s, i -> ClassOrbit( tbl, i ) ), i -> i[1] );
>     return [ Identifier( tbl ),
>              min,
>              bound,
>              AtlasClassNames( tbl ){ s },
>              Sum( List( prim, pi -> pi{ s } ) ) ];
> end );

##  doc2/probgen.xml (1492-1537)
gap> BindGlobal( "ProbGenInfoAlmostSimple", function( tblS, tblG, sposS )
>     local p, fus, inv, prim, sposG, outer, approx, l, max, min,
>           s, cards, i, names;
> 
>     p:= Size( tblG ) / Size( tblS );
>     if not IsPrimeInt( p )
>        or Length( ClassPositionsOfNormalSubgroups( tblG ) ) <> 3 then
>       return fail;
>     fi;
>     fus:= GetFusionMap( tblS, tblG );
>     if fus = fail then
>       return fail;
>     fi;
>     inv:= InverseMap( fus );
>     prim:= PrimitivePermutationCharacters( tblG );
>     if prim = fail then
>       return fail;
>     fi;
>     sposG:= Set( fus{ sposS } );
>     outer:= Difference( PositionsProperty(
>                 OrdersClassRepresentatives( tblG ), IsPrimeInt ), fus );
>     approx:= List( sposG, i -> ApproxP( prim, i ){ outer } );
>     if IsEmpty( outer ) then
>       max:= List( approx, x -> 0 );
>     else
>       max:= List( approx, Maximum );
>     fi;
>     min:= Minimum( max);
>     s:= sposG{ PositionsProperty( max, x -> x = min ) };
>     cards:= List( prim, pi -> pi{ s } );
>     for i in [ 1 .. Length( prim ) ] do
>       # Omit the character that is induced from the simple group.
>       if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
>         cards[i]:= 0;
>       fi;
>     od;
>     names:= AtlasClassNames( tblG ){ s };
>     Perform( names, ConvertToStringRep );
> 
>     return [ Identifier( tblG ),
>              min,
>              names,
>              Sum( cards ) ];
> end );

##  doc2/probgen.xml (1591-1613)
gap> BindGlobal( "SigmaFromMaxes", function( arg )
>     local t, sname, maxes, numpermchars, prim, spos, outer;
> 
>     t:= arg[1];
>     sname:= arg[2];
>     maxes:= arg[3];
>     numpermchars:= arg[4];
>     prim:= List( maxes, s -> PossiblePermutationCharacters( s, t ) );
>     spos:= Position( AtlasClassNames( t ), sname );
>     if ForAny( [ 1 .. Length( maxes ) ],
>                i -> Length( prim[i] ) <> numpermchars[i] ) then
>       return fail;
>     elif Length( arg ) = 5 and arg[5] = "outer" then
>       outer:= Difference(
>           PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>           ClassPositionsOfDerivedSubgroup( t ) );
>       return Maximum( ApproxP( Concatenation( prim ), spos ){ outer } );
>     else
>       return Maximum( ApproxP( Concatenation( prim ), spos ) );
>     fi;
> end );

##  doc2/probgen.xml (1641-1680)
gap> BindGlobal( "DisplayProbGenMaxesInfo", function( tbl, snames )
>     local mx, prim, i, spos, nonz, indent, j;
> 
>     if not HasMaxes( tbl ) then
>       Print( Identifier( tbl ), ": fail\n" );
>       return;
>     fi;
> 
>     # Now we are sure that the order of the characters returned by
>     # 'PrimitivePermutationCharacters' is compatible with 'Maxes( tbl )'.
>     mx:= List( Maxes( tbl ), CharacterTable );
>     prim:= List( PrimitivePermutationCharacters( tbl ), ShallowCopy );
>     for i in [ 1 .. Length( prim ) ] do
>       # Deal with the case that the subgroup is normal.
>       if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
>         prim[i]:= prim[i] / prim[i][1];
>       fi;
>     od;
> 
>     spos:= List( snames,
>                  nam -> Position( AtlasClassNames( tbl ), nam ) );
>     nonz:= List( spos, x -> PositionsProperty( prim, pi -> pi[x] <> 0 ) );
>     for i in [ 1 .. Length( spos ) ] do
>       Print( Identifier( tbl ), ", ", snames[i], ": " );
>       indent:= ListWithIdenticalEntries(
>           Length( Identifier( tbl ) ) + Length( snames[i] ) + 4, ' ' );
>       if not IsEmpty( nonz[i] ) then
>         Print( Identifier( mx[ nonz[i][1] ] ), "  (",
>                prim[ nonz[i][1] ][ spos[i] ], ")\n" );
>         for j in [ 2 .. Length( nonz[i] ) ] do
>           Print( indent, Identifier( mx[ nonz[i][j] ] ), "  (",
>                prim[ nonz[i][j] ][ spos[i] ], ")\n" );
>         od;
>       else
>         Print( "\n" );
>       fi;
>     od;
> end );

##  doc2/probgen.xml (1717-1725)
gap> BindGlobal( "PcConjugacyClassReps", function( G )
>      local iso;
> 
>      iso:= IsomorphismPcGroup( G );
>      return List( ConjugacyClasses( Image( iso ) ),
>               c -> PreImagesRepresentative( iso, Representative( c ) ) );
> end );

##  doc2/probgen.xml (1788-1809)
gap> BindGlobal( "ClassesOfPrimeOrder", function( G, primes, N )
>      local ccl, p, syl, Greps, reps, r, cr;
> 
>      ccl:= [];
>      for p in primes do
>        syl:= SylowSubgroup( G, p );
>        Greps:= [];
>        reps:= Filtered( PcConjugacyClassReps( syl ),
>                   r -> Order( r ) = p and not r in N );
>        for r in reps do
>          cr:= ConjugacyClass( G, r );
>          if ForAll( Greps, c -> c <> cr ) then
>            Add( Greps, cr );
>          fi;
>        od;
>        Append( ccl, Greps );
>      od;
> 
>      return ccl;
> end );

##  doc2/probgen.xml (1839-1853)
gap> if not IsBound( IsGeneratorsOfTransPermGroup) then
>      BindGlobal( "IsGeneratorsOfTransPermGroup", function( G, list )
>        local S;
> 
>        if not IsTransitive( G ) then
>          Error( "<G> must be transitive on its moved points" );
>        fi;
>        S:= SubgroupNC( G, list );
> 
>        return IsTransitive( S, MovedPoints( G ) ) and
>               Size( S ) = Size( G );
>      end );
>    fi;

##  doc2/probgen.xml (1880-1897)
gap> BindGlobal( "RatioOfNongenerationTransPermGroup", function( G, g, s )
>     local nongen, pair;
> 
>     if not IsTransitive( G ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
>     nongen:= 0;
>     for pair in DoubleCosetRepsAndSizes( G, Centralizer( G, g ),
>                     Centralizer( G, s ) ) do
>       if not IsGeneratorsOfTransPermGroup( G, [ s, g^pair[1] ] ) then
>         nongen:= nongen + pair[2];
>       fi;
>     od;
> 
>     return nongen / Size( G );
> end );

##  doc2/probgen.xml (1931-1948)
gap> BindGlobal( "DiagonalProductOfPermGroups", function( groups )
>     local prodgens, deg, i, gens, D, pi;
> 
>     prodgens:= GeneratorsOfGroup( groups[1] );
>     deg:= NrMovedPoints( prodgens );
>     for i in [ 2 .. Length( groups ) ] do
>       gens:= GeneratorsOfGroup( groups[i] );
>       D:= MovedPoints( gens );
>       pi:= MappingPermListList( D, [ deg+1 .. deg+Length( D ) ] );
>       deg:= deg + Length( D );
>       prodgens:= List( [ 1 .. Length( prodgens ) ],
>                        i -> prodgens[i] * gens[i]^pi );
>     od;
> 
>     return Group( prodgens );
> end );

##  doc2/probgen.xml (1981-2014)
gap> BindGlobal( "RepresentativesMaximallyCyclicSubgroups", function( tbl )
>     local n, result, orders, p, pmap, i, j;
> 
>     # Initialize.
>     n:= NrConjugacyClasses( tbl );
>     result:= BlistList( [ 1 .. n ], [ 1 .. n ] );
> 
>     # Omit powers of smaller order.
>     orders:= OrdersClassRepresentatives( tbl );
>     for p in PrimeDivisors( Size( tbl ) ) do
>       pmap:= PowerMap( tbl, p );
>       for i in [ 1 .. n ] do
>         if orders[ pmap[i] ] < orders[i] then
>           result[ pmap[i] ]:= false;
>         fi;
>       od;
>     od;
> 
>     # Omit Galois conjugates.
>     for i in [ 1 .. n ] do
>       if result[i] then
>         for j in ClassOrbit( tbl, i ) do
>           if i <> j then
>             result[j]:= false;
>           fi;
>         od;
>       fi;
>     od;
> 
>     # Return the result.
>     return ListBlist( [ 1 .. n ], result );
> end );

##  doc2/probgen.xml (2042-2054)
gap> BindGlobal( "ClassesPerhapsCorrespondingToTableColumns",
>    function( G, tbl, cols )
>     local orders, classes, invariants;
> 
>     orders:= OrdersClassRepresentatives( tbl );
>     classes:= SizesConjugacyClasses( tbl );
>     invariants:= List( cols, i -> [ orders[i], classes[i] ] );
> 
>     return Filtered( ConjugacyClasses( G ),
>         c -> [ Order( Representative( c ) ), Size(c) ] in invariants );
> end );

##  doc2/probgen.xml (2183-2276)
gap> BindGlobal( "UpperBoundFixedPointRatios",
>    function( G, maxesclasses, truetest )
>     local myIsConjugate, invs, info, c, r, o, inv, pos, sums, max, maxpos,
>           maxlen, reps, split, i, found, j;
> 
>     myIsConjugate:= function( G, x, y )
>       local movx, movy;
> 
>       movx:= MovedPoints( x );
>       movy:= MovedPoints( y );
>       if movx = movy then
>         G:= Stabilizer( G, movx, OnSets );
>       fi;
>       return IsConjugate( G, x, y );
>     end;
> 
>     invs:= [];
>     info:= [];
> 
>     # First distribute the classes according to invariants.
>     for c in Concatenation( maxesclasses ) do
>       r:= Representative( c );
>       o:= Order( r );
>       # Take only prime order representatives.
>       if IsPrimeInt( o ) then
>         inv:= [ o, Size( Centralizer( G, r ) ) ];
>         # Omit classes that are central in `G'.
>         if inv[2] <> Size( G ) then
>           if IsPerm( r ) then
>             Add( inv, NrMovedPoints( r ) );
>           fi;
>           pos:= First( [ 1 .. Length( invs ) ], i -> inv = invs[i] );
>           if pos = fail then
>             # This class is not `G'-conjugate to any of the previous ones.
>             Add( invs, inv );
>             Add( info, [ [ r, Size( c ) * inv[2] ] ] );
>           else
>             # This class may be conjugate to an earlier one.
>             Add( info[ pos ], [ r, Size( c ) * inv[2] ] );
>           fi;
>         fi;
>       fi;
>     od;
> 
>     if info = [] then
>       return [ 0, true ];
>     fi;
> 
>     repeat
>       # Compute the contributions of the classes with the same invariants.
>       sums:= List( info, x -> Sum( List( x, y -> y[2] ) ) );
>       max:= Maximum( sums );
>       maxpos:= Filtered( [ 1 .. Length( info ) ], i -> sums[i] = max );
>       maxlen:= List( maxpos, i -> Length( info[i] ) );
> 
>       # Split the sets with the same invariants if necessary
>       # and if we want to compute the exact value.
>       if truetest and not 1 in maxlen then
>         # Make one conjugacy test.
>         pos:= Position( maxlen, Minimum( maxlen ) );
>         reps:= info[ maxpos[ pos ] ];
>         if myIsConjugate( G, reps[1][1], reps[2][1] ) then
>           # Fuse the two classes.
>           reps[1][2]:= reps[1][2] + reps[2][2];
>           reps[2]:= reps[ Length( reps ) ];
>           Unbind( reps[ Length( reps ) ] );
>         else
>           # Split the list. This may require additional conjugacy tests.
>           Unbind( info[ maxpos[ pos ] ] );
>           split:= [ reps[1], reps[2] ];
>           for i in [ 3 .. Length( reps ) ] do
>             found:= false;
>             for j in split do
>               if myIsConjugate( G, reps[i][1], j[1] ) then
>                 j[2]:= reps[i][2] + j[2];
>                 found:= true;
>                 break;
>               fi;
>             od;
>             if not found then
>               Add( split, reps[i] );
>             fi;
>           od;
> 
>           info:= Compacted( Concatenation( info,
>                                            List( split, x -> [ x ] ) ) );
>         fi;
>       fi;
>     until 1 in maxlen or not truetest;
> 
>     return [ max / Size( G ), 1 in maxlen ];
> end );

##  doc2/probgen.xml (2354-2374)
gap> BindGlobal( "OrbitRepresentativesProductOfClasses",
>    function( G, classreps )
>     local cents, n, orbreps;
> 
>     cents:= List( classreps, x -> Centralizer( G, x ) );
>     n:= Length( classreps );
> 
>     orbreps:= function( reps, intersect, pos )
>       if pos > n then
>         return [ reps ];
>       fi;
>       return Concatenation( List(
>           DoubleCosetRepsAndSizes( G, cents[ pos ], intersect ),
>             r -> orbreps( Concatenation( reps, [ classreps[ pos ]^r[1] ] ),
>                  Intersection( intersect, cents[ pos ]^r[1] ), pos+1 ) ) );
>     end;
> 
>     return orbreps( [ classreps[1] ], cents[1], 2 );
> end );

##  doc2/probgen.xml (2412-2439)
gap> BindGlobal( "RandomCheckUniformSpread", function( G, classreps, s, try )
>     local elms, found, i, conj;
> 
>     if not IsTransitive( G, MovedPoints( G ) ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
> 
>     # Compute orbit representatives of G on the direct product,
>     # and try to find a good conjugate of s for each representative.
>     for elms in OrbitRepresentativesProductOfClasses( G, classreps ) do
>       found:= false;
>       for i in [ 1 .. try ] do
>         conj:= s^Random( G );
>         if ForAll( elms,
>               x -> IsGeneratorsOfTransPermGroup( G, [ x, conj ] ) ) then
>           found:= true;
>           break;
>         fi;
>       od;
>       if not found then
>         return elms;
>       fi;
>     od;
> 
>     return true;
> end );

##  doc2/probgen.xml (2514-2536)
gap> BindGlobal( "CommonGeneratorWithGivenElements",
>    function( G, classreps, tuple )
>     local inter, rep, repcen, pair;
> 
>     if not IsTransitive( G, MovedPoints( G ) ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
> 
>     inter:= Intersection( List( tuple, x -> Centralizer( G, x ) ) );
>     for rep in classreps do
>       repcen:= Centralizer( G, rep );
>       for pair in DoubleCosetRepsAndSizes( G, repcen, inter ) do
>         if ForAll( tuple,
>            x -> IsGeneratorsOfTransPermGroup( G, [ x, rep^pair[1] ] ) ) then
>           return rep;
>         fi;
>       od;
>     od;
> 
>     return fail;
> end );

##  doc2/probgen.xml (2582-2599)
gap> sporinfo:= [];;
gap> spornames:= AllCharacterTableNames( IsSporadicSimple, true,
>                                        IsDuplicateTable, false );;
gap> for tbl in List( spornames, CharacterTable ) do
>      info:= ProbGenInfoSimple( tbl );
>      if info <> fail then
>        # keep the table columns narrow
>        if info[2] <= 10^-13 then
>          info[2]:= "<= 10^-13";
>        fi;
>        if info[3] >= 10^13 then
>          info[3]:= ">= 10^13";
>        fi;
>        Add( sporinfo, info );
>      fi;
>    od;

##  doc2/probgen.xml (2607-2635)
gap> PrintFormattedArray( sporinfo );
     B      <= 10^-13     >= 10^13        [ "47A" ]    [ 1 ]
   Co1    421/1545600         3671        [ "35A" ]    [ 4 ]
   Co2          1/270          269        [ "23A" ]    [ 1 ]
   Co3        64/6325           98        [ "21A" ]    [ 4 ]
   F3+ 1/269631216855 269631216854        [ "29A" ]    [ 1 ]
  Fi22         43/585           13        [ "16A" ]    [ 7 ]
  Fi23   2651/2416635          911        [ "23A" ]    [ 2 ]
    HN        4/34375         8593        [ "19A" ]    [ 1 ]
    HS        64/1155           18        [ "15A" ]    [ 2 ]
    He          3/595          198        [ "14C" ]    [ 3 ]
    J1           1/77           76        [ "19A" ]    [ 1 ]
    J2           5/28            5        [ "10C" ]    [ 3 ]
    J3          2/153           76        [ "19A" ]    [ 2 ]
    J4   1/1647124116   1647124115        [ "29A" ]    [ 1 ]
    Ly     1/35049375     35049374        [ "37A" ]    [ 1 ]
     M      <= 10^-13     >= 10^13        [ "59A" ]    [ 1 ]
   M11            1/3            2        [ "11A" ]    [ 1 ]
   M12            1/3            2        [ "10A" ]    [ 3 ]
   M22           1/21           20        [ "11A" ]    [ 1 ]
   M23         1/8064         8063        [ "23A" ]    [ 1 ]
   M24       108/1265           11        [ "21A" ]    [ 2 ]
   McL      317/22275           70 [ "15A", "30A" ] [ 3, 3 ]
    ON       10/30723         3072        [ "31A" ]    [ 2 ]
    Ru         1/2880         2879        [ "29A" ]    [ 1 ]
   Suz       141/5720           40        [ "14A" ]    [ 3 ]
    Th       2/267995       133997 [ "27A", "27B" ] [ 2, 2 ]

##  doc2/probgen.xml (2643-2651)
gap> ProbGenInfoSimple( CharacterTable( "B" ) );
[ "B", 1/174702778623598780219392000000, 
  174702778623598780219391999999, [ "47A" ], [ 1 ] ]
gap> ProbGenInfoSimple( CharacterTable( "M" ) );
[ "M", 1/5622007631255133978225347923531983224832000000000, 
  5622007631255133978225347923531983224831999999999, [ "59A" ], [ 1 ] 
 ]

##  doc2/probgen.xml (2669-2726)
gap> for entry in sporinfo do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[4] );
> od;
B, 47A: 47:23  (1)
Co1, 35A: (A5xJ2):2  (1)
          (A6xU3(3)):2  (2)
          (A7xL2(7)):2  (1)
Co2, 23A: M23  (1)
Co3, 21A: U3(5).3.2  (2)
          L3(4).D12  (1)
          s3xpsl(2,8).3  (1)
F3+, 29A: 29:14  (1)
Fi22, 16A: 2^10:m22  (1)
           (2x2^(1+8)):U4(2):2  (1)
           2F4(2)'  (4)
           2^(5+8):(S3xA6)  (1)
Fi23, 23A: 2..11.m23  (1)
           L2(23)  (1)
HN, 19A: U3(8).3_1  (1)
HS, 15A: A8.2  (1)
         5:4xa5  (1)
He, 14C: 2^1+6.psl(3,2)  (1)
         7^2:2psl(2,7)  (1)
         7^(1+2):(S3x3)  (1)
J1, 19A: 19:6  (1)
J2, 10C: 2^1+4b:a5  (1)
         a5xd10  (1)
         5^2:D12  (1)
J3, 19A: L2(19)  (1)
         J3M3  (1)
J4, 29A: frob  (1)
Ly, 37A: 37:18  (1)
M, 59A: 59:29  (1)
M11, 11A: L2(11)  (1)
M12, 10A: A6.2^2  (1)
          M12M4  (1)
          2xS5  (1)
M22, 11A: L2(11)  (1)
M23, 23A: 23:11  (1)
M24, 21A: L3(4).3.2_2  (1)
          2^6:(psl(3,2)xs3)  (1)
McL, 15A: 3^(1+4):2S5  (1)
          2.A8  (1)
          5^(1+2):3:8  (1)
McL, 30A: 3^(1+4):2S5  (1)
          2.A8  (1)
          5^(1+2):3:8  (1)
ON, 31A: L2(31)  (1)
         ONM8  (1)
Ru, 29A: L2(29)  (1)
Suz, 14A: J2.2  (2)
          (a4xpsl(3,4)):2  (1)
Th, 27A: ThN3B  (1)
         ThM7  (1)
Th, 27B: ThN3B  (1)
         ThM7  (1)

##  doc2/probgen.xml (2770-2774)
gap> SigmaFromMaxes( CharacterTable( "B" ), "47A",
>        [ CharacterTable( "47:23" ) ], [ 1 ] );
1/174702778623598780219392000000

##  doc2/probgen.xml (2784-2788)
gap> SigmaFromMaxes( CharacterTable( "M" ), "59A",
>        [ CharacterTable( "59:29" ) ], [ 1 ] );
1/5622007631255133978225347923531983224832000000000

##  doc2/probgen.xml (2802-2812)
gap> t:= CharacterTable( "M" );;
gap> s:= CharacterTable( "L2(59)" );;
gap> pi:= PossiblePermutationCharacters( s, t );;
gap> Length( pi );
5
gap> spos:= Position( OrdersClassRepresentatives( t ), 59 );
152
gap> Set( pi, x -> Maximum( ApproxP( [ x ], spos ) ) );
[ 1/3385007637938037777290625 ]

##  doc2/probgen.xml (2828-2835)
gap> sporautnames:= AllCharacterTableNames( IsSporadicSimple, true,
>                       IsDuplicateTable, false,
>                       OfThose, AutomorphismGroup );;
gap> sporautnames:= Difference( sporautnames, spornames );
[ "F3+.2", "Fi22.2", "HN.2", "HS.2", "He.2", "J2.2", "J3.2", "M12.2", 
  "M22.2", "McL.2", "ON.2", "Suz.2" ]

##  doc2/probgen.xml (2861-2889)
gap> sporautinfo:= [];;
gap> fails:= [];;
gap> for name in sporautnames do
>      tbl:= CharacterTable( name{ [ 1 .. Position( name, '.' ) - 1 ] } );
>      tblG:= CharacterTable( name );
>      info:= ProbGenInfoSimple( tbl );
>      info:= ProbGenInfoAlmostSimple( tbl, tblG,
>          List( info[4], x -> Position( AtlasClassNames( tbl ), x ) ) );
>      if info = fail then
>        Add( fails, name );
>      else
>        Add( sporautinfo, info );
>      fi;
>    od;
gap> PrintFormattedArray( sporautinfo );
   F3+.2         0         [ "29AB" ]    [ 1 ]
  Fi22.2  251/3861         [ "16AB" ]    [ 7 ]
    HN.2    1/6875         [ "19AB" ]    [ 1 ]
    HS.2    36/275          [ "15A" ]    [ 2 ]
    He.2   37/9520         [ "14CD" ]    [ 3 ]
    J2.2      1/15         [ "10CD" ]    [ 3 ]
    J3.2    1/1080         [ "19AB" ]    [ 1 ]
   M12.2      4/99          [ "10A" ]    [ 1 ]
   M22.2      1/21         [ "11AB" ]    [ 1 ]
   McL.2      1/63 [ "15AB", "30AB" ] [ 3, 3 ]
    ON.2   1/84672         [ "31AB" ]    [ 1 ]
   Suz.2 661/46332          [ "14A" ]    [ 3 ]

##  doc2/probgen.xml (2904-2947)
gap> for entry in sporautinfo do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[3] );
> od;
F3+.2, 29AB: F3+  (1)
             frob  (1)
Fi22.2, 16AB: Fi22  (1)
              Fi22.2M4  (1)
              (2x2^(1+8)):(U4(2):2x2)  (1)
              2F4(2)'.2  (4)
              2^(5+8):(S3xS6)  (1)
HN.2, 19AB: HN  (1)
            U3(8).6  (1)
HS.2, 15A: HS  (1)
           S8x2  (1)
           5:4xS5  (1)
He.2, 14CD: He  (1)
            2^(1+6)_+.L3(2).2  (1)
            7^2:2.L2(7).2  (1)
            7^(1+2):(S3x6)  (1)
J2.2, 10CD: J2  (1)
            2^(1+4).S5  (1)
            (A5xD10).2  (1)
            5^2:(4xS3)  (1)
J3.2, 19AB: J3  (1)
            19:18  (1)
M12.2, 10A: M12  (1)
            (2^2xA5):2  (1)
M22.2, 11AB: M22  (1)
             L2(11).2  (1)
McL.2, 15AB: McL  (1)
             3^(1+4):4S5  (1)
             Isoclinic(2.A8.2)  (1)
             5^(1+2):(24:2)  (1)
McL.2, 30AB: McL  (1)
             3^(1+4):4S5  (1)
             Isoclinic(2.A8.2)  (1)
             5^(1+2):(24:2)  (1)
ON.2, 31AB: ON  (1)
            31:30  (1)
Suz.2, 14A: Suz  (1)
            J2.2x2  (2)
            (A4xL3(4):2_3):2  (1)

##  doc2/probgen.xml (2972-2976)
gap> SigmaFromMaxes( CharacterTable( "Fi24'.2" ), "29AB",
>        [ CharacterTable( "29:28" ) ], [ 1 ], "outer" );
0

##  doc2/probgen.xml (2989-2994)
gap> 16 in OrdersClassRepresentatives( CharacterTable( "U4(2).2" ) );
false
gap> 16 in OrdersClassRepresentatives( CharacterTable( "G2(3).2" ) );
false

##  doc2/probgen.xml (3006-3035)
gap> t2:= CharacterTable( "Fi22.2" );;
gap> prim:= List( [ "Fi22.2M4", "(2x2^(1+8)):(U4(2):2x2)", "2F4(2)" ],
>        n -> PossiblePermutationCharacters( CharacterTable( n ), t2 ) );;
gap> t:= CharacterTable( "Fi22" );;
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2^(5+8):(S3xA6)" ), t );
[ Character( CharacterTable( "Fi22" ),
  [ 3648645, 56133, 10629, 2245, 567, 729, 405, 81, 549, 165, 133, 
      37, 69, 20, 27, 81, 9, 39, 81, 19, 1, 13, 33, 13, 1, 0, 13, 13, 
      5, 1, 0, 0, 0, 8, 4, 0, 0, 9, 3, 15, 3, 1, 1, 1, 1, 3, 3, 1, 0, 
      0, 0, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2 ] ) ]
gap> torso:= CompositionMaps( pi[1], InverseMap( GetFusionMap( t, t2 ) ) );
[ 3648645, 56133, 10629, 2245, 567, 729, 405, 81, 549, 165, 133, 37, 
  69, 20, 27, 81, 9, 39, 81, 19, 1, 13, 33, 13, 1, 0, 13, 13, 5, 1, 
  0, 0, 0, 8, 4, 0, 9, 3, 15, 3, 1, 1, 1, 3, 3, 1, 0, 0, 2, 1, 0, 0, 
  0, 0, 0, 0, 1, 1, 2 ]
gap> ext:= PermChars( t2, rec( torso:= torso ) );;
gap> Add( prim, ext );
gap> prim:= Concatenation( prim );;  Length( prim );
4
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 16 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 4, 1 ]
gap> sigma:= ApproxP( prim, spos );;
gap> Maximum( sigma{ Difference( PositionsProperty(
>                        OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                        ClassPositionsOfDerivedSubgroup( t2 ) ) } );
251/3861

##  doc2/probgen.xml (3045-3049)
gap> SigmaFromMaxes( CharacterTable( "HN.2" ), "19AB",
>        [ CharacterTable( "U3(8).6" ) ], [ 1 ], "outer" );
1/6875

##  doc2/probgen.xml (3061-3067)
gap> SigmaFromMaxes( CharacterTable( "HS.2" ), "15A",
>      [ CharacterTable( "S8x2" ),
>        CharacterTable( "5:4" ) * CharacterTable( "A5.2" ) ], [ 1, 1 ],
>      "outer" );
36/275

##  doc2/probgen.xml (3081-3114)
gap> t:= CharacterTable( "He" );;
gap> t2:= CharacterTable( "He.2" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "14C" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );
[ [ 187425, 945, 449, 0, 21, 21, 25, 25, 0, 0, 5, 0, 0, 7, 1, 0, 0, 
      1, 0, 1, 0, 0, 0, 0, 0, 0 ], 
  [ 244800, 0, 64, 0, 84, 0, 0, 16, 0, 0, 4, 24, 45, 3, 4, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 0, 0 ], 
  [ 652800, 0, 512, 120, 72, 0, 0, 0, 0, 0, 8, 8, 22, 1, 0, 0, 0, 0, 
      0, 1, 0, 0, 1, 1, 2, 0 ] ]
gap> ext:= List( torso, x -> PermChars( t2, rec( torso:= x ) ) );
[ [ Character( CharacterTable( "He.2" ),
      [ 187425, 945, 449, 0, 21, 21, 25, 25, 0, 0, 5, 0, 0, 7, 1, 0, 
          0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 315, 15, 0, 0, 3, 7, 7, 3, 0, 
          0, 0, 1, 1, 0, 1, 1, 0, 0, 0 ] ) ], 
  [ Character( CharacterTable( "He.2" ),
      [ 244800, 0, 64, 0, 84, 0, 0, 16, 0, 0, 4, 24, 45, 3, 4, 0, 0, 
          0, 0, 1, 0, 0, 0, 0, 0, 0, 360, 0, 0, 0, 6, 0, 0, 0, 0, 0, 
          3, 2, 2, 0, 0, 0, 0, 0, 0 ] ) ], 
  [ Character( CharacterTable( "He.2" ),
      [ 652800, 0, 512, 120, 72, 0, 0, 0, 0, 0, 8, 8, 22, 1, 0, 0, 0, 
          0, 0, 1, 0, 0, 1, 1, 2, 0, 480, 0, 120, 0, 12, 0, 0, 0, 0, 
          0, 4, 0, 0, 0, 0, 0, 0, 1, 1 ] ) ] ]
gap> spos:= Position( AtlasClassNames( t2 ), "14CD" );;
gap> sigma:= ApproxP( Concatenation( ext ), spos );;
gap> Maximum( sigma{ Difference( PositionsProperty(
>                        OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                        ClassPositionsOfDerivedSubgroup( t2 ) ) } );
37/9520

##  doc2/probgen.xml (3124-3128)
gap> SigmaFromMaxes( CharacterTable( "ON.2" ), "31AB",
>        [ CharacterTable( "P:Q", [ 31, 30 ] ) ], [ 1 ], "outer" );
1/84672

##  doc2/probgen.xml (3147-3198)
gap> sporautinfo2:= [];;
gap> for name in List( sporautinfo, x -> x[1] ) do
>      Add( sporautinfo2, ProbGenInfoSimple( CharacterTable( name ) ) );
>    od;
gap> PrintFormattedArray( sporautinfo2 );
   F3+.2    19/5684  299        [ "42E" ]   [ 10 ]
  Fi22.2 1165/20592   17        [ "24G" ]    [ 3 ]
    HN.2     1/1425 1424        [ "24B" ]    [ 4 ]
    HS.2     21/550   26        [ "20C" ]    [ 4 ]
    He.2    33/4165  126        [ "24A" ]    [ 2 ]
    J2.2       1/15   14        [ "14A" ]    [ 1 ]
    J3.2   77/10260  133        [ "34A" ]    [ 1 ]
   M12.2    113/495    4        [ "12B" ]    [ 3 ]
   M22.2       8/33    4        [ "10A" ]    [ 4 ]
   McL.2      1/135  134        [ "22A" ]    [ 1 ]
    ON.2  61/109368 1792 [ "22A", "38A" ] [ 1, 1 ]
   Suz.2      1/351  350        [ "28A" ]    [ 1 ]
gap> for entry in sporautinfo2 do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[4] );
> od;
F3+.2, 42E: 2^12.M24  (2)
            2^2.U6(2):S3x2  (1)
            2^(3+12).(L3(2)xS6)  (2)
            (S3xS3xG2(3)):2  (1)
            S6xL2(8):3  (1)
            7:6xS7  (1)
            7^(1+2)_+:(6xS3).2  (2)
Fi22.2, 24G: Fi22.2M4  (1)
             2^(5+8):(S3xS6)  (1)
             3^5:(2xU4(2).2)  (1)
HN.2, 24B: 2^(1+8)_+.(A5xA5).2^2  (1)
           5^2.5.5^2.4S5  (2)
           HN.2M13  (1)
HS.2, 20C: (2xA6.2^2).2  (1)
           HS.2N5  (2)
           5:4xS5  (1)
He.2, 24A: 2^(1+6)_+.L3(2).2  (1)
           S4xL3(2).2  (1)
J2.2, 14A: L3(2).2x2  (1)
J3.2, 34A: L2(17)x2  (1)
M12.2, 12B: L2(11).2  (1)
            2^3.(S4x2)  (1)
            3^(1+2):D8  (1)
M22.2, 10A: M22.2M4  (1)
            A6.2^2  (1)
            L2(11).2  (2)
McL.2, 22A: 2xM11  (1)
ON.2, 22A: J1x2  (1)
ON.2, 38A: J1x2  (1)
Suz.2, 28A: (A4xL3(4):2_3):2  (1)

##  doc2/probgen.xml (3209-3217)
gap> sporautchoices:= [
>        [ "Fi22",  "Fi22.2",  42 ],
>        [ "Fi24'", "Fi24'.2", 46 ],
>        [ "He",    "He.2",    42 ],
>        [ "HN",    "HN.2",    44 ],
>        [ "HS",    "HS.2",    30 ],
>        [ "ON",    "ON.2",    38 ], ];;

##  doc2/probgen.xml (3226-3250)
gap> for triple in sporautchoices do
>      tbl:= CharacterTable( triple[1] );
>      tbl2:= CharacterTable( triple[2] );
>      spos2:= PowerMap( tbl2, 2,
>          Position( OrdersClassRepresentatives( tbl2 ), triple[3] ) );
>      spos:= Position( GetFusionMap( tbl, tbl2 ), spos2 );
>      DisplayProbGenMaxesInfo( tbl, AtlasClassNames( tbl ){ [ spos ] } );
>    od;
Fi22, 21A: O8+(2).3.2  (1)
           S3xU4(3).2_2  (1)
           A10.2  (1)
           A10.2  (1)
F3+, 23A: Fi23  (1)
          F3+M7  (1)
He, 21B: 3.A7.2  (1)
         7^(1+2):(S3x3)  (1)
         7:3xpsl(3,2)  (2)
HN, 22A: 2.HS.2  (1)
HS, 15A: A8.2  (1)
         5:4xa5  (1)
ON, 19B: L3(7).2  (1)
         ONM2  (1)
         J1  (1)

##  doc2/probgen.xml (3271-3276)
gap> 42 in OrdersClassRepresentatives( CharacterTable( "G2(3).2" ) );
false
gap> Size( CharacterTable( "U4(2)" ) ) mod 7 = 0;
false

##  doc2/probgen.xml (3285-3315)
gap> SigmaFromMaxes( CharacterTable( "Fi22.2" ), "42A",
>     [ CharacterTable( "O8+(2).3.2" ) * CharacterTable( "Cyclic", 2 ),
>       CharacterTable( "S3" ) * CharacterTable( "U4(3).(2^2)_{122}" ) ],
>     [ 1, 1 ] );
163/1170
gap> SigmaFromMaxes( CharacterTable( "Fi24'.2" ), "46A",
>      [ CharacterTable( "Fi23" ) * CharacterTable( "Cyclic", 2 ),
>        CharacterTable( "2^12.M24" ) ],
>      [ 1, 1 ] );
566/5481
gap> SigmaFromMaxes( CharacterTable( "He.2" ), "42A",
>      [ CharacterTable( "3.A7.2" ) * CharacterTable( "Cyclic", 2 ),
>        CharacterTable( "7^(1+2):(S3x6)" ),
>        CharacterTable( "7:6" ) * CharacterTable( "L3(2)" ) ],
>      [ 1, 1, 1 ] );
1/119
gap> SigmaFromMaxes( CharacterTable( "HN.2" ), "44A",
>      [ CharacterTable( "4.HS.2" ) ],
>      [ 1 ] );
997/192375
gap> SigmaFromMaxes( CharacterTable( "HS.2" ), "30A",
>      [ CharacterTable( "S8" ) * CharacterTable( "C2" ),
>        CharacterTable( "5:4" ) * CharacterTable( "S5" ) ],
>      [ 1, 1 ] );
36/275
gap> SigmaFromMaxes( CharacterTable( "ON.2" ), "38A",
>      [ CharacterTable( "J1" ) * CharacterTable( "C2" ) ],
>      [ 1 ] );
61/109368

##  doc2/probgen.xml (3336-3354)
gap> names:= AllCharacterTableNames( IsSimple, true, IsAbelian, false,
>                                    IsDuplicateTable, false );;
gap> names:= Difference( names, spornames );;
gap> fails:= [];;
gap> lessthan3:= [];;
gap> atleast3:= [];;
gap> for name in names do
>      tbl:= CharacterTable( name );
>      info:= ProbGenInfoSimple( tbl );
>      if info = fail then
>        Add( fails, name );
>      elif info[3] < 3 then
>        Add( lessthan3, info );
>      else
>        Add( atleast3, info );
>      fi;
>    od;

##  doc2/probgen.xml (3370-3379)
gap> fails;
[ "2E6(2)", "2F4(8)", "3D4(3)", "3D4(4)", "A14", "A15", "A16", "A17", 
  "A18", "A19", "E6(2)", "F4(3)", "G2(7)", "L4(4)", "L4(5)", "L4(9)", 
  "L5(3)", "L8(2)", "O10+(2)", "O10+(3)", "O10-(2)", "O10-(3)", 
  "O12+(2)", "O12+(3)", "O12-(2)", "O12-(3)", "O7(5)", "O8+(7)", 
  "O8-(3)", "O9(3)", "R(27)", "S10(2)", "S12(2)", "S4(7)", "S4(8)", 
  "S4(9)", "S6(4)", "S6(5)", "S8(3)", "U4(4)", "U4(5)", "U5(3)", 
  "U5(4)", "U6(4)", "U7(2)" ]

##  doc2/probgen.xml (3389-3401)
gap> PrintFormattedArray( lessthan3 );
      A5      1/3 2                [ "5A" ]       [ 1 ]
      A6      2/3 1                [ "5A" ]       [ 2 ]
      A7      2/5 2                [ "7A" ]       [ 2 ]
   O7(3)  199/351 1               [ "14A" ]       [ 3 ]
  O8+(2)  334/315 0 [ "15A", "15B", "15C" ] [ 7, 7, 7 ]
  O8+(3) 863/1820 2 [ "20A", "20B", "20C" ] [ 8, 8, 8 ]
   S6(2)      4/7 1                [ "9A" ]       [ 4 ]
   S8(2)     8/15 1               [ "17A" ]       [ 3 ]
   U4(2)    21/40 1               [ "12A" ]       [ 2 ]
   U4(3)   53/135 2                [ "7A" ]       [ 7 ]

##  doc2/probgen.xml (3420-3501)
gap> oldsize:= SizeScreen();;
gap> SizeScreen( [ 80 ] );;
gap> PrintFormattedArray( Filtered( atleast3, l -> l[1] <> "L7(2)" ) );
  2F4(2)'  118/1755   14                           [ "16A" ]             [ 2 ]
   3D4(2)    1/5292 5291                           [ "13A" ]             [ 1 ]
      A10      3/10    3                           [ "21A" ]             [ 1 ]
      A11     2/105   52                           [ "11A" ]             [ 2 ]
      A12       2/9    4                           [ "35A" ]             [ 1 ]
      A13    4/1155  288                           [ "13A" ]             [ 5 ]
       A8      3/14    4                           [ "15A" ]             [ 1 ]
       A9      9/35    3                      [ "9A", "9B" ]          [ 4, 4 ]
    F4(2)     9/595   66                           [ "13A" ]             [ 5 ]
    G2(3)       1/7    6                           [ "13A" ]             [ 3 ]
    G2(4)      1/21   20                           [ "13A" ]             [ 2 ]
    G2(5)      1/31   30                     [ "7A", "21A" ]         [ 10, 1 ]
  L2(101)     1/101  100                    [ "51A", "17A" ]          [ 1, 1 ]
  L2(103)   53/5253   99             [ "52A", "26A", "13A" ]       [ 1, 1, 1 ]
  L2(107)   55/5671  103 [ "54A", "27A", "18A", "9A", "6A" ] [ 1, 1, 1, 1, 1 ]
  L2(109)     1/109  108                    [ "55A", "11A" ]          [ 1, 1 ]
   L2(11)      7/55    7                            [ "6A" ]             [ 1 ]
  L2(113)     1/113  112                    [ "57A", "19A" ]          [ 1, 1 ]
  L2(121)     1/121  120                           [ "61A" ]             [ 1 ]
  L2(125)     1/125  124        [ "63A", "21A", "9A", "7A" ]    [ 1, 1, 1, 1 ]
   L2(13)      1/13   12                            [ "7A" ]             [ 1 ]
   L2(16)      1/15   14                           [ "17A" ]             [ 1 ]
   L2(17)      1/17   16                            [ "9A" ]             [ 1 ]
   L2(19)    11/171   15                           [ "10A" ]             [ 1 ]
   L2(23)    13/253   19                     [ "6A", "12A" ]          [ 1, 1 ]
   L2(25)      1/25   24                           [ "13A" ]             [ 1 ]
   L2(27)     5/117   23                     [ "7A", "14A" ]          [ 1, 1 ]
   L2(29)      1/29   28                           [ "15A" ]             [ 1 ]
   L2(31)    17/465   27                     [ "8A", "16A" ]          [ 1, 1 ]
   L2(32)      1/31   30              [ "3A", "11A", "33A" ]       [ 1, 1, 1 ]
   L2(37)      1/37   36                           [ "19A" ]             [ 1 ]
   L2(41)      1/41   40                     [ "21A", "7A" ]          [ 1, 1 ]
   L2(43)    23/903   39                    [ "22A", "11A" ]          [ 1, 1 ]
   L2(47)   25/1081   43        [ "24A", "12A", "8A", "6A" ]    [ 1, 1, 1, 1 ]
   L2(49)      1/49   48                           [ "25A" ]             [ 1 ]
   L2(53)      1/53   52                     [ "27A", "9A" ]          [ 1, 1 ]
   L2(59)   31/1711   55       [ "30A", "15A", "10A", "6A" ]    [ 1, 1, 1, 1 ]
   L2(61)      1/61   60                           [ "31A" ]             [ 1 ]
   L2(64)      1/63   62                    [ "65A", "13A" ]          [ 1, 1 ]
   L2(67)   35/2211   63                    [ "34A", "17A" ]          [ 1, 1 ]
   L2(71)   37/2485   67 [ "36A", "18A", "12A", "9A", "6A" ] [ 1, 1, 1, 1, 1 ]
   L2(73)      1/73   72                           [ "37A" ]             [ 1 ]
   L2(79)   41/3081   75       [ "40A", "20A", "10A", "8A" ]    [ 1, 1, 1, 1 ]
    L2(8)       1/7    6                      [ "3A", "9A" ]          [ 1, 1 ]
   L2(81)      1/81   80                           [ "41A" ]             [ 1 ]
   L2(83)   43/3403   79 [ "42A", "21A", "14A", "7A", "6A" ] [ 1, 1, 1, 1, 1 ]
   L2(89)      1/89   88              [ "45A", "15A", "9A" ]       [ 1, 1, 1 ]
   L2(97)      1/97   96                     [ "49A", "7A" ]          [ 1, 1 ]
   L3(11)    1/6655 6654                   [ "19A", "133A" ]          [ 1, 1 ]
    L3(2)       1/4    3                            [ "7A" ]             [ 1 ]
    L3(3)      1/24   23                           [ "13A" ]             [ 1 ]
    L3(4)       1/5    4                            [ "7A" ]             [ 3 ]
    L3(5)     1/250  249                           [ "31A" ]             [ 1 ]
    L3(7)    1/1372 1371                           [ "19A" ]             [ 1 ]
    L3(8)    1/1792 1791                           [ "73A" ]             [ 1 ]
    L3(9)    1/2880 2879                           [ "91A" ]             [ 1 ]
    L4(3)   53/1053   19                           [ "20A" ]             [ 1 ]
    L5(2)    1/5376 5375                           [ "31A" ]             [ 1 ]
    L6(2) 365/55552  152                    [ "21A", "63A" ]          [ 2, 2 ]
   O8-(2)      1/63   62                           [ "17A" ]             [ 1 ]
    S4(4)      4/15    3                           [ "17A" ]             [ 2 ]
    S4(5)       1/5    4                           [ "13A" ]             [ 1 ]
    S6(3)     1/117  116                           [ "14A" ]             [ 2 ]
   Sz(32)    1/1271 1270                     [ "5A", "25A" ]          [ 1, 1 ]
    Sz(8)      1/91   90                            [ "5A" ]             [ 1 ]
   U3(11)    1/6655 6654                           [ "37A" ]             [ 1 ]
    U3(3)     16/63    3                     [ "6A", "12A" ]          [ 2, 2 ]
    U3(4)     1/160  159                           [ "13A" ]             [ 1 ]
    U3(5)    46/525   11                           [ "10A" ]             [ 2 ]
    U3(7)    1/1372 1371                           [ "43A" ]             [ 1 ]
    U3(8)    1/1792 1791                           [ "19A" ]             [ 1 ]
    U3(9)    1/3600 3599                           [ "73A" ]             [ 1 ]
    U5(2)      1/54   53                           [ "11A" ]             [ 1 ]
    U6(2)      5/21    4                           [ "11A" ]             [ 4 ]
gap> SizeScreen( oldsize );;
gap> First( atleast3, l -> l[1] = "L7(2)" );
[ "L7(2)", 1/4388290560, 4388290559, [ "127A" ], [ 1 ] ]

##  doc2/probgen.xml (3622-3677)
gap> list:= [
>   [ "A5", "A5.2" ],
>   [ "A6", "A6.2_1" ],
>   [ "A6", "A6.2_2" ],
>   [ "A6", "A6.2_3" ],
>   [ "A7", "A7.2" ],
>   [ "A8", "A8.2" ],
>   [ "A9", "A9.2" ],
>   [ "A11", "A11.2" ],
>   [ "L3(2)", "L3(2).2" ],
>   [ "L3(3)", "L3(3).2" ],
>   [ "L3(4)", "L3(4).2_1" ],
>   [ "L3(4)", "L3(4).2_2" ],
>   [ "L3(4)", "L3(4).2_3" ],
>   [ "L3(4)", "L3(4).3" ],
>   [ "S4(4)", "S4(4).2" ],
>   [ "U3(3)", "U3(3).2" ],
>   [ "U3(5)", "U3(5).2" ],
>   [ "U3(5)", "U3(5).3" ],
>   [ "U4(2)", "U4(2).2" ],
>   [ "U4(3)", "U4(3).2_1" ],
>   [ "U4(3)", "U4(3).2_3" ],
> ];;
gap> autinfo:= [];;
gap> fails:= [];;
gap> for pair in list do
>      tbl:= CharacterTable( pair[1] );
>      tblG:= CharacterTable( pair[2] );
>      info:= ProbGenInfoSimple( tbl );
>      spos:= List( info[4], x -> Position( AtlasClassNames( tbl ), x ) );
>      Add( autinfo, ProbGenInfoAlmostSimple( tbl, tblG, spos ) );
>    od;
gap> PrintFormattedArray( autinfo );
       A5.2      0        [ "5AB" ]    [ 1 ]
     A6.2_1    2/3        [ "5AB" ]    [ 2 ]
     A6.2_2    1/6         [ "5A" ]    [ 1 ]
     A6.2_3      0        [ "5AB" ]    [ 1 ]
       A7.2   1/15        [ "7AB" ]    [ 1 ]
       A8.2  13/28       [ "15AB" ]    [ 1 ]
       A9.2    1/4        [ "9AB" ]    [ 1 ]
      A11.2  1/945       [ "11AB" ]    [ 1 ]
    L3(2).2    1/4        [ "7AB" ]    [ 1 ]
    L3(3).2   1/18       [ "13AB" ]    [ 1 ]
  L3(4).2_1   3/10        [ "7AB" ]    [ 3 ]
  L3(4).2_2  11/60         [ "7A" ]    [ 1 ]
  L3(4).2_3   1/12        [ "7AB" ]    [ 1 ]
    L3(4).3   1/64         [ "7A" ]    [ 1 ]
    S4(4).2      0       [ "17AB" ]    [ 2 ]
    U3(3).2    2/7 [ "6A", "12AB" ] [ 2, 2 ]
    U3(5).2   2/21        [ "10A" ]    [ 2 ]
    U3(5).3 46/525        [ "10A" ]    [ 2 ]
    U4(2).2  16/45       [ "12AB" ]    [ 2 ]
  U4(3).2_1 76/135         [ "7A" ]    [ 3 ]
  U4(3).2_3 31/162        [ "7AB" ]    [ 3 ]

##  doc2/probgen.xml (3700-3708)
gap> t:= CharacterTable( "L4(3)" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "20A" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );
[ Character( CharacterTable( "L4(3)" ),
  [ 2106, 106, 42, 0, 27, 27, 0, 46, 6, 6, 1, 7, 7, 0, 3, 3, 0, 0, 0, 
      1, 1, 1, 0, 0, 0, 0, 0, 1, 1 ] ) ]

##  doc2/probgen.xml (3714-3744)
gap> for name in [ "L4(3).2_1", "L4(3).2_2", "L4(3).2_3" ] do
>      t2:= CharacterTable( name );
>      map:= InverseMap( GetFusionMap( t, t2 ) );
>      torso:= List( prim, pi -> CompositionMaps( pi, map ) );
>      ext:= Concatenation( List( torso,
>                              x -> PermChars( t2, rec( torso:= x ) ) ) );
>      sigma:= ApproxP( ext, Position( OrdersClassRepresentatives( t2 ), 20 ) );
>      max:= Maximum( sigma{ Difference( PositionsProperty(
>                           OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                           ClassPositionsOfDerivedSubgroup( t2 ) ) } );
>      Print( name, ":\n", ext, "\n", max, "\n" );
> od;
L4(3).2_1:
[ Character( CharacterTable( "L4(3).2_1" ), 
    [ 2106, 106, 42, 0, 27, 0, 46, 6, 6, 1, 7, 0, 3, 0, 0, 1, 1, 0, 
      0, 0, 0, 0, 1, 1, 0, 4, 0, 0, 6, 6, 6, 6, 2, 0, 0, 0, 0, 0, 0, 
      1, 1, 1, 1 ] ) ]
0
L4(3).2_2:
[ Character( CharacterTable( "L4(3).2_2" ), 
    [ 2106, 106, 42, 0, 27, 27, 0, 46, 6, 6, 1, 7, 7, 0, 3, 3, 0, 0, 
      0, 1, 1, 1, 0, 0, 0, 1, 306, 306, 42, 6, 10, 10, 0, 0, 15, 15, 
      3, 3, 3, 3, 0, 0, 1, 1, 0, 1, 1, 0, 0 ] ) ]
17/117
L4(3).2_3:
[ Character( CharacterTable( "L4(3).2_3" ), 
    [ 2106, 106, 42, 0, 27, 0, 46, 6, 6, 1, 7, 0, 3, 0, 0, 1, 1, 0, 
      0, 0, 1, 36, 0, 0, 6, 6, 2, 2, 2, 1, 1, 0, 0, 0 ] ) ]
2/117

##  doc2/probgen.xml (3751-3755)
gap> SigmaFromMaxes( CharacterTable( "O8-(2).2" ), "17AB",
>        [ CharacterTable( "L2(16).4" ) ], [ 1 ], "outer" );
0

##  doc2/probgen.xml (3766-3793)
gap> t:= CharacterTable( "S6(3)" );;
gap> t2:= CharacterTable( "S6(3).2" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "14A" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );;
gap> ext:= List( torso, pi -> PermChars( t2, rec( torso:= pi ) ) );
[ [ Character( CharacterTable( "S6(3).2" ),
      [ 155520, 0, 288, 0, 0, 0, 216, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 6, 1, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 144, 288, 0, 0, 0, 
          6, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 
          0 ] ) ], 
  [ Character( CharacterTable( "S6(3).2" ),
      [ 189540, 1620, 568, 0, 486, 0, 0, 27, 540, 84, 24, 0, 0, 0, 0, 
          0, 54, 0, 0, 10, 0, 7, 1, 6, 6, 0, 0, 0, 0, 0, 0, 18, 0, 0, 
          0, 6, 12, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 234, 64, 
          30, 8, 0, 3, 90, 6, 0, 4, 10, 6, 0, 2, 1, 0, 0, 0, 0, 0, 0, 
          0, 1, 1, 0, 0 ] ) ] ]
gap> spos:= Position( AtlasClassNames( t2 ), "14A" );;
gap> sigma:= ApproxP( Concatenation( ext ), spos );;
gap> Maximum( sigma{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
7/3240

##  doc2/probgen.xml (3804-3808)
gap> SigmaFromMaxes( CharacterTable( "U5(2).2" ), "11AB",
>        [ CharacterTable( "L2(11).2" ) ], [ 1 ], "outer" );
1/288

##  doc2/probgen.xml (3816-3818)
gap> CleanWorkspace();

##  doc2/probgen.xml (3853-3857)
gap> SigmaFromMaxes( CharacterTable( "O8-(3)" ), "41A",
>    [ CharacterTable( "L2(81).2_1" ) ], [ 1 ] );
1/567

##  doc2/probgen.xml (3904-3917)
gap> ForAny( [ "S8(2)", "O8+(2)", "L5(2)", "O8-(2)", "A8" ],
>            x -> 45 in OrdersClassRepresentatives( CharacterTable( x ) ) );
false
gap> t:= CharacterTable( "O10+(2)" );;
gap> t2:= CharacterTable( "O10+(2).2" );;
gap> s2:= CharacterTable( "A5.2" ) * CharacterTable( "U4(2).2" );
CharacterTable( "A5.2xU4(2).2" )
gap> pi:= PossiblePermutationCharacters( s2, t2 );;
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 45 );;
gap> approx:= ApproxP( pi, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t2 ) } );
43/4216

##  doc2/probgen.xml (3926-3931)
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
23/248

##  doc2/probgen.xml (3939-3942)
gap> SigmaFromMaxes( t2, "45AB", [ s2 ], [ 1 ], "outer" );
23/248

##  doc2/probgen.xml (3987-3991)
gap> SigmaFromMaxes( CharacterTable( "O10-(2)" ), "33A",
>    [ CharacterTable( "Cyclic", 3 ) * CharacterTable( "U5(2)" ) ], [ 1 ] );
1/119

##  doc2/probgen.xml (4004-4024)
gap> tblG:= CharacterTable( "U5(2)" );;
gap> tblMG:= CharacterTable( "Cyclic", 3 ) * tblG;;
gap> tblGA:= CharacterTable( "U5(2).2" );;
gap> acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );;
gap> poss:= Concatenation( List( acts, pi ->
>            PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, pi,
>                "(3xU5(2)).2" ) ) );
[ rec( 
      MGfusMGA := [ 1, 2, 3, 4, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 12, 
          13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 21, 21, 
          22, 22, 23, 23, 24, 24, 25, 25, 26, 27, 27, 28, 28, 29, 29, 
          30, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 
          44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 
          59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 
          74, 75, 76, 77, 31, 32, 33, 35, 34, 37, 36, 38, 39, 40, 41, 
          42, 43, 45, 44, 47, 46, 49, 48, 51, 50, 52, 54, 53, 56, 55, 
          57, 58, 60, 59, 62, 61, 64, 63, 66, 65, 68, 67, 69, 71, 70, 
          73, 72, 75, 74, 77, 76 ], 
      table := CharacterTable( "(3xU5(2)).2" ) ) ]

##  doc2/probgen.xml (4032-4036)
gap> SigmaFromMaxes( CharacterTable( "O10-(2).2" ), "33AB",
>        [ poss[1].table ], [ 1 ], "outer" );
1/595

##  doc2/probgen.xml (4129-4137)
gap> t:= CharacterTable( "O12+(2).2" );;
gap> h1:= CharacterTable( "L4(4).2^2" );;
gap> psi:= PossiblePermutationCharacters( h1, t );;
gap> Length( psi );
1
gap> ForAny( psi[1], IsOddInt );
true

##  doc2/probgen.xml (4149-4153)
gap> SizesCentralizers( t ){ PositionsProperty(
>        OrdersClassRepresentatives( t ), x -> x = 17 ) } / 25;
[ 408/5, 408/5 ]

##  doc2/probgen.xml (4171-4176)
gap> h2:= CharacterTable( "S5" ) * CharacterTable( "O8-(2).2" );;
gap> phi:= PossiblePermutationCharacters( h2, t );;
gap> Length( phi );
1

##  doc2/probgen.xml (4191-4197)
gap> prim:= Concatenation( psi, phi );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 85 );
213
gap> List( prim, x -> x[ spos ] );
[ 2, 1 ]

##  doc2/probgen.xml (4217-4221)
gap> approx:= ApproxP( prim, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t ) } );
7675/1031184

##  doc2/probgen.xml (4232-4237)
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t ) ) } );
73/1008

##  doc2/probgen.xml (4294-4302)
gap> t:= CharacterTable( "O12-(2).2" );;
gap> s1:= CharacterTable( "U4(4).4" );;
gap> pi1:= PossiblePermutationCharacters( s1, t );;
gap> s2:= CharacterTable( "L2(64).6" );;
gap> pi2:= PossiblePermutationCharacters( s2, t );;
gap> prim:= Concatenation( pi1, pi2 );;  Length( prim );
2

##  doc2/probgen.xml (4311-4315)
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1 ]

##  doc2/probgen.xml (4324-4328)
gap> approx:= ApproxP( prim, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t ) } );
1/1023

##  doc2/probgen.xml (4336-4341)
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t ) ) } );
1/347820

##  doc2/probgen.xml (4389-4395)
gap> t:= CharacterTable( "S6(4)" );;
gap> degree:= Size( t ) / ( 2 * Size( CharacterTable( "U4(4)" ) ) );;
gap> pi1:= PermChars( t, rec( torso:= [ degree ] ) );;
gap> Length( pi1 );
1

##  doc2/probgen.xml (4408-4427)
gap> CharacterTable( "L2(64).3" );  CharacterTable( "U4(4).2" );
fail
fail
gap> s:= CharacterTable( "L2(64)" );;
gap> subpi:= PossiblePermutationCharacters( s, t );;
gap> Length( subpi );
1
gap> scp:= MatScalarProducts( t, Irr( t ), subpi );;
gap> nonzero:= PositionsProperty( scp[1], x -> x <> 0 );
[ 1, 11, 13, 14, 17, 18, 32, 33, 56, 58, 59, 73, 74, 77, 78, 79, 80, 
  93, 95, 96, 103, 116, 117, 119, 120 ]
gap> const:= RationalizedMat( Irr( t ){ nonzero } );;
gap> degree:= Size( t ) / ( 3 * Size( s ) );
5222400
gap> pi2:= PermChars( t, rec( torso:= [ degree ], chars:= const ) );;
gap> Length( pi2 );
1
gap> prim:= Concatenation( pi1, pi2 );;

##  doc2/probgen.xml (4436-4440)
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1 ]

##  doc2/probgen.xml (4448-4451)
gap> Maximum( ApproxP( prim, spos ) );
16/63

##  doc2/probgen.xml (4461-4486)
gap> t2:= CharacterTable( "S6(4).2" );;
gap> tfust2:= GetFusionMap( t, t2 );;
gap> cand:= List( prim, x -> CompositionMaps( x, InverseMap( tfust2 ) ) );;
gap> ext:= List( cand, pi -> PermChars( t2, rec( torso:= pi ) ) );
[ [ Character( CharacterTable( "S6(4).2" ),
      [ 2016, 512, 96, 128, 32, 120, 0, 6, 16, 40, 24, 0, 8, 136, 1, 
          6, 6, 1, 32, 0, 8, 6, 2, 0, 2, 0, 0, 4, 0, 16, 32, 1, 8, 2, 
          6, 2, 1, 2, 4, 0, 0, 1, 6, 0, 1, 10, 0, 1, 1, 0, 10, 10, 4, 
          0, 1, 0, 2, 0, 2, 1, 2, 2, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 
          0, 0, 0, 32, 0, 0, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 0, 
          0, 0, 2, 2, 0, 2, 2, 0, 2, 2, 2, 0, 0 ] ) ], 
  [ Character( CharacterTable( "S6(4).2" ),
      [ 5222400, 0, 0, 0, 1280, 0, 960, 120, 0, 0, 0, 0, 0, 0, 1600, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 1, 0, 0, 15, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 
          0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 
          0, 0, 960, 0, 0, 0, 16, 0, 24, 12, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 4, 1, 0, 0, 3, 0, 0, 0, 0, 0 ] ) ] ]
gap> spos2:= Position( OrdersClassRepresentatives( t2 ), 65 );;
gap> sigma:= ApproxP( Concatenation( ext ), spos2 );;
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
0

##  doc2/probgen.xml (4508-4513)
gap> SigmaFromMaxes( CharacterTable( "S6(4)" ), "85A",
>    [ CharacterTable( "L4(4).2_2" ),
>      CharacterTable( "A5" ) * CharacterTable( "S4(4)" ) ], [ 1, 1 ] );
142/455

##  doc2/probgen.xml (4522-4525)
gap> 16/63 < 142/455;
true

##  doc2/probgen.xml (4579-4590)
gap> t:= CharacterTable( "S6(5)" );;
gap> s1:= CharacterTable( "2.A5" );;
gap> s2:= CharacterTable( "2.S4(5)" );;
gap> dp:= s1 * s2;
CharacterTable( "2.A5x2.S4(5)" )
gap> c:= Difference( ClassPositionsOfCentre( dp ), Union(
>                        GetFusionMap( s1, dp ), GetFusionMap( s2, dp ) ) );
[ 62 ]
gap> s:= dp / c;
CharacterTable( "2.A5x2.S4(5)/[ 1, 62 ]" )

##  doc2/probgen.xml (4598-4601)
gap> SigmaFromMaxes( t, "78A", [ s ], [ 1 ] );
9/217

##  doc2/probgen.xml (4652-4659)
gap> t:= CharacterTable( "S8(3)" );;
gap> pi:= List( [ "S4(9).2_1", "S4(9).2_2", "S4(9).2_3" ],
>               name -> PossiblePermutationCharacters(
>                           CharacterTable( name ), t ) );;
gap> List( pi, Length );
[ 1, 0, 0 ]

##  doc2/probgen.xml (4668-4672)
gap> spos:= Position( OrdersClassRepresentatives( t ), 41 );;
gap> pi[1][1][ spos ];
1

##  doc2/probgen.xml (4680-4683)
gap> Maximum( ApproxP( pi[1], spos ) );
1/546

##  doc2/probgen.xml (4736-4743)
gap> g:= SU(4,4);;
gap> orbs:= OrbitsDomain( g, NormedRowVectors( GF(16)^4 ), OnLines );;
gap> orblen:= List( orbs, Length );
[ 1105, 3264 ]
gap> List( orblen, x -> x mod 13 );
[ 0, 1 ]

##  doc2/probgen.xml (4753-4758)
gap> t:= CharacterTable( "U4(4)" );;
gap> pi:= PermChars( t, rec( torso:= [ orblen[2] ] ) );;
gap> Length( pi );
1

##  doc2/probgen.xml (4766-4770)
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> Maximum( ApproxP( pi, spos ) );
209/3264

##  doc2/probgen.xml (4828-4853)
gap> t:= CharacterTable( "U6(2)" );;
gap> s1:= CharacterTable( "U5(2)" );;
gap> pi1:= PossiblePermutationCharacters( s1, t );;
gap> Length( pi1 );
1
gap> s2:= CharacterTable( "M22" );;
gap> pi2:= PossiblePermutationCharacters( s2, t );
[ Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 0, 0, 48, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 0, 0, 4, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ), Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 0, 48, 0, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ), Character( CharacterTable( "U6(2)" ),
  [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 48, 0, 0, 0, 16, 6, 0, 0, 0, 0, 
      0, 0, 6, 0, 2, 0, 4, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ) ]
gap> imgs:= Set( pi2, x -> Position( x, 48 ) );
[ 10, 11, 12 ]
gap> AtlasClassNames( t ){ imgs };
[ "4C", "4D", "4E" ]
gap> GetFusionMap( t, CharacterTable( "U6(2).3" ) ){ imgs };
[ 10, 10, 10 ]
gap> prim:= Concatenation( pi1, pi2 );;

##  doc2/probgen.xml (4862-4866)
gap> spos:= Position( OrdersClassRepresentatives( t ), 11 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 1, 1 ]

##  doc2/probgen.xml (4874-4877)
gap> Maximum( ApproxP( prim, spos ) );
5/21

##  doc2/probgen.xml (4887-4892)
gap> PossibleClassFusions(
>        CharacterTable( "Cyclic", 3 ) * CharacterTable( "M22" ),
>        CharacterTable( "3.U6(2)" ) );
[  ]

##  doc2/probgen.xml (4903-4912)
gap> SigmaFromMaxes( CharacterTable( "U6(2).2" ), "11AB",
>        [ CharacterTable( "U5(2).2" ), CharacterTable( "M22.2" ) ],
>        [ 1, 1 ], "outer" );
5/96
gap> SigmaFromMaxes( CharacterTable( "U6(2).3" ), "11A",
>        [ CharacterTable( "U5(2)" ) * CharacterTable( "Cyclic", 3 ) ],
>        [ 1 ], "outer" );
59/224

##  doc2/probgen.xml (4926-4928)
gap> CleanWorkspace();

##  doc2/probgen.xml (4953-4981)
gap> PrimitivesInfoForOddDegreeAlternatingGroup:= function( n )
>     local G, max, cycle, spos, prim, nonz;
> 
>     G:= AlternatingGroup( n );
> 
>     # Compute representatives of the classes of maximal subgroups.
>     max:= MaximalSubgroupClassReps( G );
> 
>     # Omit subgroups that cannot contain an `n'-cycle.
>     max:= Filtered( max, m -> IsTransitive( m, [ 1 .. n ] ) );
> 
>     # Compute the permutation characters.
>     cycle:= [];
>     cycle[ n-1 ]:= 1;
>     spos:= PositionProperty( ConjugacyClasses( CharacterTable( G ) ),
>                c -> CycleStructurePerm( Representative( c ) ) = cycle );
>     prim:= List( max, m -> TrivialCharacter( m )^G );
>     nonz:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
> 
>     # Compute the subgroup names and the multiplicities.
>     return rec( spos := spos,
>                 prim := prim{ nonz },
>                 grps := List( max{ nonz },
>                               m -> TransitiveGroup( n,
>                                        TransitiveIdentification( m ) ) ),
>                 mult := List( prim{ nonz }, x -> x[ spos ] ) );
> end;;

##  doc2/probgen.xml (4992-5010)
gap> for n in [ 5, 7 .. 23 ] do
>      prim:= PrimitivesInfoForOddDegreeAlternatingGroup( n );
>      bound:= Maximum( ApproxP( prim.prim, prim.spos ) );
>      Print( n, ": ", prim.grps, ", ", prim.mult, ", ", bound, "\n" );
> od;
5: [ D(5) = 5:2 ], [ 1 ], 1/3
7: [ L(7) = L(3,2), L(7) = L(3,2) ], [ 1, 1 ], 2/5
9: [ 1/2[S(3)^3]S(3), L(9):3=P|L(2,8) ], [ 1, 3 ], 9/35
11: [ M(11), M(11) ], [ 1, 1 ], 2/105
13: [ F_78(13)=13:6, L(13)=PSL(3,3), L(13)=PSL(3,3) ], [ 1, 2, 2 ], 4/
1155
15: [ 1/2[S(3)^5]S(5), 1/2[S(5)^3]S(3), L(15)=A_8(15)=PSL(4,2), 
  L(15)=A_8(15)=PSL(4,2) ], [ 1, 1, 1, 1 ], 29/273
17: [ L(17):4=PYL(2,16), L(17):4=PYL(2,16) ], [ 1, 1 ], 2/135135
19: [ F_171(19)=19:9 ], [ 1 ], 1/6098892800
21: [ t21n150, t21n161, t21n91 ], [ 1, 1, 2 ], 29/285
23: [ M(23), M(23) ], [ 1, 1 ], 2/130945815

##  doc2/probgen.xml (5108-5112)
gap> t:= CharacterTable( "A5" );;
gap> ProbGenInfoSimple( t );
[ "A5", 1/3, 2, [ "5A" ], [ 1 ] ]

##  doc2/probgen.xml (5123-5130)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 5, 5 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A5" ), [ 5, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A5" ), [ 6, 2, 0, 1, 1 ] ), 
  Character( CharacterTable( "A5" ), [ 10, 2, 1, 0, 0 ] ) ]

##  doc2/probgen.xml (5145-5160)
gap> g:= AlternatingGroup( 5 );;
gap> inv:= g.1^2 * g.2;
(1,4)(2,5)
gap> cclreps:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( cclreps, Order ), cclreps );
gap> List( cclreps, Order );
[ 1, 2, 3, 5, 5 ]
gap> Size( ConjugacyClass( g, inv ) );
15
gap> prop:= List( cclreps,
>                 r -> RatioOfNongenerationTransPermGroup( g, inv, r ) );
[ 1, 1, 3/5, 1/3, 1/3 ]
gap> Minimum( prop );
1/3

##  doc2/probgen.xml (5168-5172)
gap> triple:= [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];;
gap> CommonGeneratorWithGivenElements( g, cclreps, triple );
fail

##  doc2/probgen.xml (5247-5251)
gap> t:= CharacterTable( "A6" );;
gap> ProbGenInfoSimple( t );
[ "A6", 2/3, 1, [ "5A" ], [ 2 ] ]

##  doc2/probgen.xml (5262-5271)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 5 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A6" ), [ 6, 2, 3, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "A6" ), [ 6, 2, 0, 3, 0, 1, 1 ] ), 
  Character( CharacterTable( "A6" ), [ 10, 2, 1, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A6" ), [ 15, 3, 3, 0, 1, 0, 0 ] ), 
  Character( CharacterTable( "A6" ), [ 15, 3, 0, 3, 1, 0, 0 ] ) ]

##  doc2/probgen.xml (5286-5302)
gap> S:= AlternatingGroup( 6 );;
gap> inv:= (S.1*S.2)^2;
(1,3)(2,5)
gap> cclreps:= List( ConjugacyClasses( S ), Representative );;
gap> SortParallel( List( cclreps, Order ), cclreps );
gap> List( cclreps, Order );
[ 1, 2, 3, 3, 4, 5, 5 ]
gap> C:= ConjugacyClass( S, inv );;
gap> Size( C );
45
gap> prop:= List( cclreps,
>                 r -> RatioOfNongenerationTransPermGroup( S, inv, r ) );
[ 1, 1, 1, 1, 29/45, 5/9, 5/9 ]
gap> Minimum( prop );
5/9

##  doc2/probgen.xml (5311-5314)
gap> ApproxP( prim, 6 );
[ 0, 2/3, 1/2, 1/2, 0, 1/3, 1/3 ]

##  doc2/probgen.xml (5322-5326)
gap> triple:= [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];;
gap> CommonGeneratorWithGivenElements( S, cclreps, triple );
fail

##  doc2/probgen.xml (5335-5339)
gap> triple:= [ (1,3)(2,4), (1,5)(2,6), (3,6)(4,5) ];;
gap> CommonGeneratorWithGivenElements( S, cclreps, triple );
fail

##  doc2/probgen.xml (5347-5352)
gap> TripleWithProperty( [ [ inv ], C, C ],
>        l -> ForAll( S, elm ->
>   ForAny( l, x -> not IsGeneratorsOfTransPermGroup( S, [ elm, x ] ) ) ) );
[ (1,3)(2,5), (1,3)(2,6), (1,3)(2,4) ]

##  doc2/probgen.xml (5361-5370)
gap> s:= (1,2,3,4)(5,6);;
gap> reps:= Filtered( cclreps, x -> Order( x ) > 1 );;
gap> ResetGlobalRandomNumberGenerators();
gap> for pair in UnorderedTuples( reps, 2 ) do
>      if RandomCheckUniformSpread( S, pair, s, 40 ) <> true then
>        Print( "#E  nongeneration!\n" );
>      fi;
>    od;

##  doc2/probgen.xml (5392-5396)
gap> G:= SymmetricGroup( 6 );;
gap> RatioOfNongenerationTransPermGroup( G, s, (1,2) );
1

##  doc2/probgen.xml (5411-5422)
gap> goods:= Filtered( Elements( G ),
>      s -> IsGeneratorsOfTransPermGroup( G, [ s, (1,2) ] ) and
>           IsGeneratorsOfTransPermGroup( G, [ s, (3,4) ] ) );;
gap> Collected( List( goods, CycleStructurePerm ) );
[ [ [ ,,,, 1 ], 24 ] ]
gap> goods:= Filtered( Elements( G ),
>      s -> IsGeneratorsOfTransPermGroup( G, [ s, (1,2)(3,4)(5,6) ] ) and
>           IsGeneratorsOfTransPermGroup( G, [ s, (1,3)(2,4)(5,6) ] ) );;
gap> Collected( List( goods, CycleStructurePerm ) );
[ [ [ 1, 1 ], 24 ] ]

##  doc2/probgen.xml (5440-5455)
gap> Sgens:= GeneratorsOfGroup( S );;
gap> primord:= Filtered( List( ConjugacyClasses( G ), Representative ),
>                        x -> IsPrimeInt( Order( x ) ) );;
gap> for x in primord do
>      for y in primord do
>        for pair in DoubleCosetRepsAndSizes( G, Centralizer( G, y ),
>                        Centralizer( G, x ) ) do
>          if not ForAny( G, s -> IsSubset( Group( x,s ), S ) and 
>                                 IsSubset( Group( y^pair[1], s ), S ) ) then
>            Error( [ x, y ] );
>          fi;
>        od;
>      od;
>    od;

##  doc2/probgen.xml (5470-5474)
gap> filt:= Filtered( S, s -> IsSubset( Group( (1,2), s ), S ) );;
gap> Collected( List( filt, Order ) );
[ [ 5, 48 ] ]

##  doc2/probgen.xml (5493-5498)
gap> ProbGenInfoSimple( CharacterTable( "A6.2_2" ) );
[ "A6.2_2", 1/6, 5, [ "10A" ], [ 1 ] ]
gap> ProbGenInfoSimple( CharacterTable( "A6.2_3" ) );
[ "A6.2_3", 1/9, 8, [ "8C" ], [ 1 ] ]

##  doc2/probgen.xml (5509-5515)
gap> t:= CharacterTable( "A6" );;
gap> t2:= CharacterTable( "A6.2_2" );;
gap> spos:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 5 );;
gap> ProbGenInfoAlmostSimple( t, t2, spos );
[ "A6.2_2", 1/6, [ "5A", "5B" ], [ 1, 1 ] ]

##  doc2/probgen.xml (5560-5564)
gap> t:= CharacterTable( "A7" );;
gap> ProbGenInfoSimple( t );
[ "A7", 2/5, 2, [ "7A" ], [ 2 ] ]

##  doc2/probgen.xml (5575-5585)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A7" ), [ 7, 3, 4, 1, 1, 2, 0, 0, 0 ] ), 
  Character( CharacterTable( "A7" ), [ 15, 3, 0, 3, 1, 0, 0, 1, 1 ] ),
  Character( CharacterTable( "A7" ), [ 15, 3, 0, 3, 1, 0, 0, 1, 1 ] ),
  Character( CharacterTable( "A7" ), [ 21, 5, 6, 0, 1, 1, 2, 0, 0 ] ),
  Character( CharacterTable( "A7" ), [ 35, 7, 5, 2, 1, 0, 1, 0, 0 ] ) 
 ]

##  doc2/probgen.xml (5599-5613)
gap> g:= AlternatingGroup( 7 );;
gap> inv:= (g.1^3*g.2)^3;
(2,6)(3,7)
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> Size( ConjugacyClass( g, inv ) );
105
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, inv, r ) );
[ 1, 1, 1, 1, 89/105, 17/21, 19/35, 2/5, 2/5 ]
gap> Minimum( prop );
2/5

##  doc2/probgen.xml (5625-5644)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 7 );;
gap> SizesCentralizers( t );
[ 2520, 24, 36, 9, 4, 5, 12, 7, 7 ]
gap> ApproxP( prim, spos );
[ 0, 2/5, 0, 2/5, 2/15, 0, 0, 2/15, 2/15 ]
gap> s:= (1,2,3,4,5,6,7);;
gap> 3B:= (1,2,3)(4,5,6);;
gap> C3B:= ConjugacyClass( g, 3B );;
gap> Size( C3B );
280
gap> ResetGlobalRandomNumberGenerators();
gap> for triple in UnorderedTuples( [ inv, 3B ], 3 ) do
>      if RandomCheckUniformSpread( g, triple, s, 80 ) <> true then
>        Print( "#E  nongeneration!\n" );
>      fi;
>    od;

##  doc2/probgen.xml (5662-5700)
gap> tom:= TableOfMarks( "A7" );;
gap> a7:= UnderlyingGroup( tom );;
gap> tommaxes:= MaximalSubgroupsTom( tom );
[ [ 39, 38, 37, 36, 35 ], [ 7, 15, 15, 21, 35 ] ]
gap> index15:= List( tommaxes[1]{ [ 2, 3 ] },
>                    i -> RepresentativeTom( tom, i ) );
[ Group([ (1,3)(2,7), (1,5,7)(3,4,6) ]), 
  Group([ (1,4)(2,3), (2,4,6)(3,5,7) ]) ]
gap> deg15:= List( index15, s -> RightTransversal( a7, s ) );;
gap> reps:= List( deg15, l -> Action( a7, l, OnRight ) );
[ Group([ (1,5,7)(2,9,10)(3,11,4)(6,12,8)(13,14,15), (1,8,15,5,12)
      (2,13,11,3,10)(4,14,9,7,6) ]), 
  Group([ (1,2,3)(4,6,5)(7,8,9)(10,12,11)(13,15,14), (1,12,3,13,10)
      (2,9,15,4,11)(5,6,14,7,8) ]) ]
gap> g:= DiagonalProductOfPermGroups( reps );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 7;
gap> NrMovedPoints( s );
28
gap> mpg:= MovedPoints( g );;
gap> fixs:= Difference( mpg, MovedPoints( s ) );;
gap> orb_s:= Orbit( g, fixs, OnSets );;
gap> Length( orb_s );
120
gap> SizesCentralizers( t );
[ 2520, 24, 36, 9, 4, 5, 12, 7, 7 ]
gap> repeat 2a:= Random( g ); until Order( 2a ) = 2;
gap> repeat 3b:= Random( g );
>    until Order( 3b ) = 3 and Size( Centralizer( g, 3b ) ) = 9;
gap> orb2a:= Orbit( g, Difference( mpg, MovedPoints( 2a ) ), OnSets );;
gap> orb3b:= Orbit( g, Difference( mpg, MovedPoints( 3b ) ), OnSets );;
gap> orb2aor3b:= Union( orb2a, orb3b );;
gap> TripleWithProperty( [ [ orb2a[1], orb3b[1] ], orb2aor3b, orb2aor3b ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
fail

##  doc2/probgen.xml (5725-5731)
gap> QuadrupleWithProperty( [ [ orb2a[1] ], orb2a, orb2a, orb2a ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
[ [ 2, 5, 12, 18, 19, 26 ], [ 7, 8, 9, 16, 21, 25 ], 
  [ 1, 6, 10, 17, 20, 27 ], [ 13, 14, 15, 28, 29, 30 ] ]

##  doc2/probgen.xml (5740-5774)
gap> has6A:= List( tommaxes[1]{ [ 4, 5 ] },
>                  i -> RepresentativeTom( tom, i ) );
[ Group([ (1,2)(3,7), (2,6,5,4)(3,7) ]), 
  Group([ (2,3)(5,7), (1,2)(4,5,6,7), (2,3)(5,6) ]) ]
gap> trans:= List( has6A, s -> RightTransversal( a7, s ) );;
gap> reps:= List( trans, l -> Action( a7, l, OnRight ) );
[ Group([ (1,16,12)(2,17,13)(3,18,11)(4,19,14)(15,20,21), (1,4,7,9,10)
      (2,5,8,3,6)(11,12,15,14,13)(16,20,19,17,18) ]), 
  Group([ (2,16,6)(3,17,7)(4,18,8)(5,19,9)(10,20,26)(11,21,27)
      (12,22,28)(13,23,29)(14,24,30)(15,25,31), (1,2,3,4,5)
      (6,10,13,15,9)(7,11,14,8,12)(16,20,23,25,19)(17,21,24,18,22)
      (26,32,35,31,28)(27,33,29,34,30) ]) ]
gap> g:= DiagonalProductOfPermGroups( reps );;
gap> repeat s:= Random( g );
>    until Order( s ) = 6;
gap> NrMovedPoints( s );
53
gap> mpg:= MovedPoints( g );;
gap> fixs:= Difference( mpg, MovedPoints( s ) );;
gap> orb_s:= Orbit( g, fixs, OnSets );;
gap> Length( orb_s );
105
gap> repeat 3a:= Random( g );
>    until Order( 3a ) = 3 and Size( Centralizer( g, 3a ) ) = 36;
gap> orb3a:= Orbit( g, Difference( mpg, MovedPoints( 3a ) ), OnSets );;
gap> Length( orb3a );
35
gap> TripleWithProperty( [ [ orb3a[1] ], orb3a, orb3a ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
[ [ 1, 4, 6, 12, 14, 15, 34, 37, 40, 43, 49 ], 
  [ 1, 4, 6, 16, 19, 20, 27, 30, 33, 44, 49 ], 
  [ 2, 3, 4, 5, 7, 9, 26, 47, 48, 50, 53 ] ]

##  doc2/probgen.xml (5831-5862)
gap> RelativeSigmaL:= function( d, B )
>     local n, F, q, glgens, diag, pi, frob, i;
> 
>     n:= Length( B );
>     F:= LeftActingDomain( UnderlyingLeftModule( B ) );
>     q:= Size( F );
> 
>     # Create the generating matrices inside the linear subgroup.
>     glgens:= List( GeneratorsOfGroup( SL( d, q^n ) ),
>                    m -> BlownUpMat( B, m ) );
> 
>     # Create the matrix of a diagonal part that maps to determinant 1.
>     diag:= IdentityMat( d*n, F );
>     diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n)^(q-1) ] ] );
>     Add( glgens, diag );
> 
>     # Create the matrix that realizes the Frobenius action,
>     # and adjust the determinant.
>     pi:= List( B, b -> Coefficients( B, b^q ) );
>     frob:= NullMat( d*n, d*n, F );
>     for i in [ 0 .. d-1 ] do
>       frob{ [ 1 .. n ] + i*n }{ [ 1 .. n ] + i*n }:= pi;
>     od;
>     diag:= IdentityMat( d*n, F );
>     diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n) ] ] );
>     diag:= diag^LogFFE( Inverse( Determinant( frob ) ), Determinant( diag ) );
> 
>     # Return the result.
>     return Group( Concatenation( glgens, [ diag * frob ] ) );
> end;;

##  doc2/probgen.xml (5892-5925)
gap> ApproxPForSL:= function( d, q )
>     local G, epi, PG, primes, maxes, names, ccl;
> 
>     # Check whether this is an admissible case (see [Be00]).
>     if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Create the group SL(d,q), and the map to PSL(d,q).
>     G:= SL( d, q );
>     epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
>     PG:= ImagesSource( epi );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= PrimeDivisors( d );
>     maxes:= List( primes, p -> RelativeSigmaL( d/p,
>                                  Basis( AsField( GF(q), GF(q^p) ) ) ) );
>     names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
>                                  String( q^p ), ").", String( p ) ) );
>     if 2 < q then
>       names:= List( names, name -> Concatenation( name, " cap G" ) );
>     fi;
> 
>     # Compute the conjugacy classes of prime order elements in the maxes.
>     # (In order to avoid computing all conjugacy classes of these subgroups,
>     # we work in Sylow subgroups.)
>     ccl:= List( List( maxes, x -> ImagesSet( epi, x ) ),
>             M -> ClassesOfPrimeOrder( M, PrimeDivisors( Size( M ) ),
>                                       TrivialSubgroup( M ) ) );
> 
>     return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
> end;;

##  doc2/probgen.xml (5936-5962)
gap> pairs:= [ [ 3, 2 ], [ 3, 3 ], [ 4, 2 ], [ 4, 3 ], [ 4, 4 ],
>            [ 6, 2 ], [ 6, 3 ], [ 6, 4 ], [ 6, 5 ], [ 8, 2 ], [ 10, 2 ] ];;
gap> array:= [];;
gap> for pair in pairs do
>      d:= pair[1];  q:= pair[2];
>      approx:= ApproxPForSL( d, q );
>      Add( array, [ Concatenation( "SL(", String(d), ",", String(q), ")" ),
>                    (q^d-1)/(q-1),
>                    approx[1], approx[2] ] );
>    od;
gap> oldsize:= SizeScreen();;
gap> SizeScreen( [ 80 ] );;
gap> PrintFormattedArray( array );
   SL(3,2)    7                             [ "GL(1,8).3" ]             1/4
   SL(3,3)   13                      [ "GL(1,27).3 cap G" ]            1/24
   SL(4,2)   15                             [ "GL(2,4).2" ]            3/14
   SL(4,3)   40                       [ "GL(2,9).2 cap G" ]         53/1053
   SL(4,4)   85                      [ "GL(2,16).2 cap G" ]           1/108
   SL(6,2)   63                [ "GL(3,4).2", "GL(2,8).3" ]       365/55552
   SL(6,3)  364   [ "GL(3,9).2 cap G", "GL(2,27).3 cap G" ] 22843/123845436
   SL(6,4) 1365  [ "GL(3,16).2 cap G", "GL(2,64).3 cap G" ]         1/85932
   SL(6,5) 3906 [ "GL(3,25).2 cap G", "GL(2,125).3 cap G" ]        1/484220
   SL(8,2)  255                             [ "GL(4,4).2" ]          1/7874
  SL(10,2) 1023               [ "GL(5,4).2", "GL(2,32).5" ]        1/129794
gap> SizeScreen( oldsize );;

##  doc2/probgen.xml (5986-5992)
gap> t:= CharacterTable( "L6(2)" );;
gap> s1:= CharacterTable( "3.L3(4).3.2_2" );;
gap> s2:= CharacterTable( "(7xL2(8)).3" );;
gap> SigmaFromMaxes( t, "63A", [ s1, s2 ], [ 1, 1 ] );
365/55552

##  doc2/probgen.xml (6026-6042)
gap> UpperBoundForSL:= function( d, q )
>     local G, Msize, ccl;
> 
>     if not IsPrimeInt( d ) then
>       Error( "<d> must be a prime" );
>     fi;
> 
>     G:= SL( d, q );
>     Msize:= (q^d-1) * d;
>     ccl:= Filtered( ConjugacyClasses( G ),
>                     c ->     Msize mod Order( Representative( c ) ) = 0
>                          and Size( c ) <> 1 );
> 
>     return Msize / Minimum( List( ccl, Size ) );
> end;;

##  doc2/probgen.xml (6055-6080)
gap> NrConjugacyClasses( SL(11,4) );
1397660
gap> pairs:= [ [ 3, 2 ], [ 3, 3 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ],
>              [ 7, 2 ], [ 7, 3 ], [ 7, 4 ],
>              [ 11, 2 ], [ 11, 3 ] ];;
gap> array:= [];;
gap> for pair in pairs do
>      d:= pair[1];  q:= pair[2];
>      approx:= UpperBoundForSL( d, q );
>      Add( array, [ Concatenation( "SL(", String(d), ",", String(q), ")" ),
>                    (q^d-1)/(q-1),
>                    approx ] );
>    od;
gap> PrintFormattedArray( array );
   SL(3,2)     7                                   7/8
   SL(3,3)    13                                   3/4
   SL(5,2)    31                              31/64512
   SL(5,3)   121                                 10/81
   SL(5,4)   341                                15/256
   SL(7,2)   127                             7/9142272
   SL(7,3)  1093                                14/729
   SL(7,4)  5461                               21/4096
  SL(11,2)  2047 2047/34112245508649716682268134604800
  SL(11,3) 88573                              22/59049

##  doc2/probgen.xml (6095-6113)
gap> SigmaFromMaxes( CharacterTable( "L5(2)" ), "31A",
>        [ CharacterTable( "31:5" ) ], [ 1 ] );
1/5376
gap> t:= CharacterTable( "L7(2)" );;
gap> s:= CharacterTable( "P:Q", [ 127, 7 ] );;
gap> pi:= PossiblePermutationCharacters( s, t );;
gap> Length( pi );
2
gap> ord7:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 7 );
[ 38, 45, 76, 77, 83 ]
gap> sizes:= SizesCentralizers( t ){ ord7 };
[ 141120, 141120, 3528, 3528, 49 ]
gap> List( pi, x -> x[83] );
[ 42, 0 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 127 );;
gap> Maximum( ApproxP( pi{ [ 1 ] }, spos ) );
1/4388290560

##  doc2/probgen.xml (6174-6211)
gap> SymmetricBasis:= function( q, n )
>     local vectors, B, issymmetric;
> 
>     if   q = 2 and n = 2 then
>       vectors:= [ Z(2)^0, Z(2^2) ];
>     elif q = 2 and n = 3 then
>       vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
>     elif q = 2 and n = 5 then
>       vectors:= [ Z(2)^0, Z(2^5), Z(2^5)^4, Z(2^5)^25, Z(2^5)^26 ];
>     elif q = 3 and n = 2 then
>       vectors:= [ Z(3)^0, Z(3^2) ];
>     elif q = 3 and n = 3 then
>       vectors:= [ Z(3)^0, Z(3^3)^2, Z(3^3)^7 ];
>     elif q = 4 and n = 2 then
>       vectors:= [ Z(2)^0, Z(2^4)^3 ];
>     elif q = 4 and n = 3 then
>       vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
>     elif q = 5 and n = 2 then
>       vectors:= [ Z(5)^0, Z(5^2)^2 ];
>     elif q = 5 and n = 3 then
>       vectors:= [ Z(5)^0, Z(5^3)^9, Z(5^3)^27 ];
>     else
>       Error( "sorry, no basis for <q> and <n> stored" );
>     fi;
> 
>     B:= Basis( AsField( GF(q), GF(q^n) ), vectors );
> 
>     # Check that the basis really has the required property.
>     issymmetric:= M -> M = TransposedMat( M );
>     if not ForAll( B, b -> issymmetric( BlownUpMat( B, [ [ b ] ] ) ) ) then
>       Error( "wrong basis!" );
>     fi;
> 
>     # Return the result.
>     return B;
> end;;

##  doc2/probgen.xml (6265-6276)
gap> BindGlobal( "EmbeddedMatrix", function( F, mat, func )
>   local d, result;
> 
>   d:= Length( mat );
>   result:= NullMat( 2*d, 2*d, F );
>   result{ [ 1 .. d ] }{ [ 1 .. d ] }:= mat;
>   result{ [ d+1 .. 2*d ] }{ [ d+1 .. 2*d ] }:= func( mat );
> 
>   return result;
> end );

##  doc2/probgen.xml (6301-6347)
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut:= function( d, q )
>     local embedG, swap, G, orb, epi, PG, Gprime, primes, maxes, ccl, names;
> 
>     # Check whether this is an admissible case (see [Be00],
>     # note that a graph automorphism exists only for `d > 2').
>     if d = 2 or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Provide a function that constructs a block diagonal matrix.
>     embedG:= mat -> EmbeddedMatrix( GF( q ), mat,
>                                     M -> TransposedMat( M^-1 ) );
> 
>     # Create the matrix that exchanges the two blocks.
>     swap:= NullMat( 2*d, 2*d, GF(q) );
>     swap{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );
>     swap{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );
> 
>     # Create the group SL(d,q).2, and the map to the projective group.
>     G:= ClosureGroupDefault( Group( List( GeneratorsOfGroup( SL( d, q ) ),
>                                           embedG ) ),
>                       swap );
>     orb:= Orbit( G, One( G )[1], OnLines );
>     epi:= ActionHomomorphism( G, orb, OnLines );
>     PG:= ImagesSource( epi );
>     Gprime:= DerivedSubgroup( PG );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= PrimeDivisors( d );
>     maxes:= List( primes,
>               p -> ClosureGroupDefault( Group( List( GeneratorsOfGroup(
>                          RelativeSigmaL( d/p, SymmetricBasis( q, p ) ) ),
>                          embedG ) ),
>                      swap ) );
> 
>     # Compute conjugacy classes of outer involutions in the maxes.
>     # (In order to avoid computing all conjugacy classes of these subgroups,
>     # we work in the Sylow $2$ subgroups.)
>     maxes:= List( maxes, M -> ImagesSet( epi, M ) );
>     ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );
>     names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
>                                    String( q^p ), ").", String( p ) ) );
> 
>     return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
> end;;

##  doc2/probgen.xml (6354-6371)
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 4, 3 );
[ [ "GL(2,9).2" ], 17/117 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 4, 4 );
[ [ "GL(2,16).2" ], 73/1008 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 2 );
[ [ "GL(3,4).2", "GL(2,8).3" ], 41/1984 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 3 );
[ [ "GL(3,9).2", "GL(2,27).3" ], 541/352836 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 4 );
[ [ "GL(3,16).2", "GL(2,64).3" ], 3265/12570624 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 5 );
[ [ "GL(3,25).2", "GL(2,125).3" ], 13001/195250000 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 8, 2 );
[ [ "GL(4,4).2" ], 367/1007872 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 10, 2 );
[ [ "GL(5,4).2", "GL(2,32).5" ], 609281/476346056704 ]

##  doc2/probgen.xml (6390-6401)
gap> RelativeGammaL:= function( d, B )
>     local n, F, q, diag;
> 
>     n:= Length( B );
>     F:= LeftActingDomain( UnderlyingLeftModule( B ) );
>     q:= Size( F );
>     diag:= IdentityMat( d * n, F );
>     diag{[ 1 .. n ]}{[ 1 .. n ]}:= BlownUpMat( B, [ [ Z(q^n) ] ] );
>     return ClosureGroup( RelativeSigmaL( d, B ),  diag );
> end;;

##  doc2/probgen.xml (6422-6451)
gap> ApproxPForOuterClassesInGL:= function( d, q )
>     local G, epi, PG, Gprime, primes, maxes, names;
> 
>     # Check whether this is an admissible case (see [Be00]).
>     if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Create the group GL(d,q), and the map to PGL(d,q).
>     G:= GL( d, q );
>     epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
>     PG:= ImagesSource( epi );
>     Gprime:= ImagesSet( epi, SL( d, q ) );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= PrimeDivisors( d );
>     maxes:= List( primes, p -> RelativeGammaL( d/p,
>                                    Basis( AsField( GF(q), GF(q^p) ) ) ) );
>     maxes:= List( maxes, M -> ImagesSet( epi, M ) );
>     names:= List( primes, p -> Concatenation( "M(", String( d/p ), ",",
>                                    String( q^p ), ")" ) );
> 
>     return [ names,
>              UpperBoundFixedPointRatios( PG, List( maxes,
>                  M -> ClassesOfPrimeOrder( M,
>                           PrimeDivisors( Index( PG, Gprime ) ), Gprime ) ),
>                  true )[1] ];
> end;;

##  doc2/probgen.xml (6459-6468)
gap> ApproxPForOuterClassesInGL( 6, 3 );
[ [ "M(3,9)", "M(2,27)" ], 41/882090 ]
gap> ApproxPForOuterClassesInGL( 4, 3 );
[ [ "M(2,9)" ], 0 ]
gap> ApproxPForOuterClassesInGL( 6, 4 );
[ [ "M(3,16)", "M(2,64)" ], 1/87296 ]
gap> ApproxPForOuterClassesInGL( 6, 5 );
[ [ "M(3,25)", "M(2,125)" ], 821563/756593750000 ]

##  doc2/probgen.xml (6524-6530)
gap> matgrp:= SL(6,4);;
gap> dom:= NormedRowVectors( GF(4)^6 );;
gap> Gprime:= Action( matgrp, dom, OnLines );;
gap> pi:= PermList( List( dom, v -> Position( dom, List( v, x -> x^2 ) ) ) );;
gap> G:= ClosureGroup( Gprime, pi );;

##  doc2/probgen.xml (6541-6550)
gap> maxes:= List( [ 2, 3 ], p -> Normalizer( G,
>              Action( RelativeSigmaL( 6/p,
>                Basis( AsField( GF(4), GF(4^p) ) ) ), dom, OnLines ) ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 0, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 1/34467840, true ]

##  doc2/probgen.xml (6570-6586)
gap> embedFG:= function( F, mat )
>      return EmbeddedMatrix( F, mat,
>                 M -> List( TransposedMat( M^-1 ),
>                            row -> List( row, x -> x^2 ) ) );
>    end;;
gap> d:= 6;;  q:= 4;;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ),
>                          mat -> embedFG( GF(q), mat ) ) );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;

##  doc2/probgen.xml (6595-6606)
gap> maxes:= List( PrimeDivisors( d ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                mat -> embedFG( GF(q), mat ) ) ) );;
gap> maxes:= List( maxes, x -> Action( x, orb, OnLines ) );;
gap> maxes:= List( maxes, x -> Normalizer( G, x ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 0, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 1/10792960, true ]

##  doc2/probgen.xml (6620-6631)
gap> d:= 6;;  q:= 3;;
gap> diag:= IdentityMat( d, GF(q) );;
gap> diag[1][1]:= Z(q);;
gap> embedDG:= mat -> EmbeddedMatrix( GF(q), mat,
>                                     M -> TransposedMat( M^-1 )^diag );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ), embedDG ) );;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;

##  doc2/probgen.xml (6641-6654)
gap> maxes:= List( PrimeDivisors( d ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                embedDG ) ) );;
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;
gap> maxes:= List( maxes, M -> Normalizer( G, Action( M, orb, OnLines ) ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 1, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 25/352836, true ]

##  doc2/probgen.xml (6665-6680)
gap> d:= 6;;  q:= 5;;
gap> embedG:= mat -> EmbeddedMatrix( GF(q),
>                                    mat, M -> TransposedMat( M^-1 ) );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ), embedG ) );;
gap> maxes:= List( PrimeDivisors( d ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                embedG ) ) );;
gap> diag:= IdentityMat( d, GF(q) );;
gap> diag[1][1]:= Z(q);;
gap> diag:= embedG( diag );;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> G:= ClosureGroupDefault( Gprime, alpha * diag );;

##  doc2/probgen.xml (6691-6702)
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> maxes:= List( maxes, M -> Action( M, orb, OnLines ) );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 2, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 3863/6052750000, true ]

##  doc2/probgen.xml (6712-6729)
gap> diag:= Permutation( diag, orb, OnLines );;
gap> G:= ClosureGroupDefault( Gprime, diag );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 3, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 821563/756593750000, true ]
gap> alpha:= Permutation( alpha, orb, OnLines );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 2, 2 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 13001/195250000, true ]

##  doc2/probgen.xml (6827-6831)
gap> t:= CharacterTable( "L3(2)" );;
gap> ProbGenInfoSimple( t );
[ "L3(2)", 1/4, 3, [ "7A" ], [ 1 ] ]

##  doc2/probgen.xml (6842-6849)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 4, 7, 7 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "L3(2)" ), [ 7, 3, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "L3(2)" ), [ 7, 3, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "L3(2)" ), [ 8, 0, 2, 0, 1, 1 ] ) ]

##  doc2/probgen.xml (6860-6878)
gap> tom:= TableOfMarks( "L3(2)" );;
gap> g:= UnderlyingGroup( tom );
Group([ (2,4)(5,7), (1,2,3)(4,5,6) ])
gap> mx:= MaximalSubgroupsTom( tom );
[ [ 14, 13, 12 ], [ 7, 7, 8 ] ]
gap> maxes:= List( mx[1], i -> RepresentativeTom( tom, i ) );;
gap> tr:= List( maxes, s -> RightTransversal( g, s ) );;
gap> acts:= List( tr, x -> Action( g, x, OnRight ) );;
gap> g7:= acts[1];
Group([ (3,4)(6,7), (1,3,2)(4,6,5) ])
gap> g8:= acts[3];
Group([ (1,6)(2,5)(3,8)(4,7), (1,7,3)(2,5,8) ])
gap> g14:= DiagonalProductOfPermGroups( acts{ [ 1, 2 ] } );
Group([ (3,4)(6,7)(11,13)(12,14), (1,3,2)(4,6,5)(8,11,9)(10,12,13) ])
gap> g15:= DiagonalProductOfPermGroups( acts{ [ 2, 3 ] } );
Group([ (4,6)(5,7)(8,13)(9,12)(10,15)(11,14), (1,4,2)(3,5,6)(8,14,10)
  (9,12,15) ])

##  doc2/probgen.xml (6893-6905)
gap> ccl:= List( ConjugacyClasses( g7 ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 4, 7, 7 ]
gap> Size( ConjugacyClass( g7, ccl[3] ) );
56
gap> prop:= List( ccl,
>                 r -> RatioOfNongenerationTransPermGroup( g7, ccl[3], r ) );
[ 1, 5/7, 19/28, 2/7, 1/4, 1/4 ]
gap> Minimum( prop );
1/4

##  doc2/probgen.xml (6919-6929)
gap> x:= g7.1;
(3,4)(6,7)
gap> fix:= Difference( MovedPoints( g7 ), MovedPoints( x ) );
[ 1, 2, 5 ]
gap> orb:= Orbit( g7, fix, OnSets );
[ [ 1, 2, 5 ], [ 1, 3, 4 ], [ 2, 3, 6 ], [ 2, 4, 7 ], [ 1, 6, 7 ], 
  [ 3, 5, 7 ], [ 4, 5, 6 ] ]
gap> Union( orb{ [ 1, 2, 5 ] } ) = [ 1 .. 7 ];
true

##  doc2/probgen.xml (6942-6951)
gap> three:= g8.2;
(1,7,3)(2,5,8)
gap> fix:= Difference( MovedPoints( g8 ), MovedPoints( three ) );
[ 4, 6 ]
gap> orb:= Orbit( g8, fix, OnSets );;
gap> QuadrupleWithProperty( [ [ fix ], orb, orb, orb ],
>        list -> Union( list ) = [ 1 .. 8 ] );
[ [ 4, 6 ], [ 1, 7 ], [ 3, 8 ], [ 2, 5 ] ]

##  doc2/probgen.xml (6970-6986)
gap> x:= g15.1;
(4,6)(5,7)(8,13)(9,12)(10,15)(11,14)
gap> fixx:= Difference( MovedPoints( g15 ), MovedPoints( x ) );
[ 1, 2, 3 ]
gap> orbx:= Orbit( g15, fixx, OnSets );
[ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 1, 6, 7 ], [ 2, 4, 6 ], [ 3, 4, 7 ], 
  [ 3, 5, 6 ], [ 2, 5, 7 ] ]
gap> y:= g15.2;
(1,4,2)(3,5,6)(8,14,10)(9,12,15)
gap> fixy:= Difference( MovedPoints( g15 ), MovedPoints( y ) );
[ 7, 11, 13 ]
gap> orby:= Orbit( g15, fixy, OnSets );;
gap> QuadrupleWithProperty( [ [ fixy ], orby, orby, orby ],
>        l -> Difference( [ 1 .. 15 ], Union( l ) ) in orbx );
[ [ 7, 11, 13 ], [ 5, 8, 14 ], [ 1, 10, 15 ], [ 3, 9, 12 ] ]

##  doc2/probgen.xml (7009-7031)
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g14 );
>    until Order( s ) = 4;
gap> s;
(1,3)(2,6,7,5)(9,11,10,12)(13,14)
gap> fixs:= Difference( MovedPoints( g14 ), MovedPoints( s ) );
[ 4, 8 ]
gap> orbs:= Orbit( g14, fixs, OnSets );;
gap> Length( orbs );
21
gap> three:= g14.2;
(1,3,2)(4,6,5)(8,11,9)(10,12,13)
gap> fix:= Difference( MovedPoints( g14 ), MovedPoints( three ) );
[ 7, 14 ]
gap> orb:= Orbit( g14, fix, OnSets );;
gap> Length( orb );
28
gap> QuadrupleWithProperty( [ [ fix ], orb, orb, orb ],
>        l -> ForAll( orbs, o -> not IsEmpty( Intersection( o,
>                        Union( l ) ) ) ) );
fail

##  doc2/probgen.xml (7081-7085)
gap> t:= CharacterTable( "M11" );;
gap> ProbGenInfoSimple( t );
[ "M11", 1/3, 2, [ "11A" ], [ 1 ] ]

##  doc2/probgen.xml (7096-7112)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 4, 5, 6, 8, 8, 11, 11 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "M11" ),
  [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ),
  [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "M11" ),
  [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ),
  [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ),
  [ 165, 13, 3, 1, 0, 1, 1, 1, 0, 0 ] ) ]
gap> Maxes( t );
[ "A6.2_3", "L2(11)", "3^2:Q8.2", "A5.2", "2.S4" ]

##  doc2/probgen.xml (7123-7140)
gap> gens11:= OneAtlasGeneratingSet( "M11", NrMovedPoints, 11 );
rec( charactername := "1a+10a", constituents := [ 1, 2 ], 
  contents := "core", 
  generators := [ (2,10)(4,11)(5,7)(8,9), (1,4,3,8)(2,5,6,9) ], 
  groupname := "M11", id := "", 
  identifier := [ "M11", [ "M11G1-p11B0.m1", "M11G1-p11B0.m2" ], 1, 
      11 ], isPrimitive := true, maxnr := 1, p := 11, rankAction := 2,
  repname := "M11G1-p11B0", repnr := 1, size := 7920, 
  stabilizer := "A6.2_3", standardization := 1, transitivity := 4, 
  type := "perm" )
gap> g11:= GroupWithGenerators( gens11.generators );;
gap> gens12:= OneAtlasGeneratingSet( "M11", NrMovedPoints, 12 );;
gap> g12:= GroupWithGenerators( gens12.generators );;
gap> g23:= DiagonalProductOfPermGroups( [ g11, g12 ] );
Group([ (2,10)(4,11)(5,7)(8,9)(12,17)(13,20)(16,18)(19,21), (1,4,3,8)
  (2,5,6,9)(12,17,18,15)(13,19)(14,20)(16,22,23,21) ])

##  doc2/probgen.xml (7155-7169)
gap> inv:= g11.1;
(2,10)(4,11)(5,7)(8,9)
gap> ccl:= List( ConjugacyClasses( g11 ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 4, 5, 6, 8, 8, 11, 11 ]
gap> Size( ConjugacyClass( g11, inv ) );
165
gap> prop:= List( ccl,
>                 r -> RatioOfNongenerationTransPermGroup( g11, inv, r ) );
[ 1, 1, 1, 149/165, 25/33, 31/55, 23/55, 23/55, 1/3, 1/3 ]
gap> Minimum( prop );
1/3

##  doc2/probgen.xml (7191-7202)
gap> inv:= g12.1;
(1,6)(2,9)(5,7)(8,10)
gap> moved:= MovedPoints( inv );
[ 1, 2, 5, 6, 7, 8, 9, 10 ]
gap> orb12:= Orbit( g12, moved, OnSets );;
gap> Length( orb12 );
165
gap> TripleWithProperty( [ orb12{[1]}, orb12, orb12 ],
>        list -> IsEmpty( Intersection( list ) ) );
fail

##  doc2/probgen.xml (7220-7235)
gap> inv:= g23.1;
(2,10)(4,11)(5,7)(8,9)(12,17)(13,20)(16,18)(19,21)
gap> moved:= MovedPoints( inv );
[ 2, 4, 5, 7, 8, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 21 ]
gap> orb23:= Orbit( g23, moved, OnSets );;
gap> three:= ( g23.1*g23.2^2 )^2;
(2,6,10)(4,8,7)(5,9,11)(12,17,23)(15,18,16)(19,21,22)
gap> movedthree:= MovedPoints( three );;
gap> QuadrupleWithProperty( [ [ movedthree ], orb23, orb23, orb23 ],
>        list -> IsEmpty( Intersection( list ) ) );
[ [ 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 21, 22, 23 ],
  [ 1, 3, 4, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17, 18, 20, 21 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 11, 12, 13, 14, 15, 18, 19, 20, 23 ], 
  [ 1, 2, 3, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 20, 22, 23 ] ]

##  doc2/probgen.xml (7289-7293)
gap> t:= CharacterTable( "M12" );;
gap> ProbGenInfoSimple( t );
[ "M12", 1/3, 2, [ "10A" ], [ 3 ] ]

##  doc2/probgen.xml (7305-7315)
gap> spos:= Position( OrdersClassRepresentatives( t ), 10 );
13
gap> prim:= PrimitivePermutationCharacters( t );;
gap> List( prim, x -> x{ [ 1, spos ] } );
[ [ 12, 0 ], [ 12, 0 ], [ 66, 1 ], [ 66, 1 ], [ 144, 0 ], [ 220, 0 ], 
  [ 220, 0 ], [ 396, 1 ], [ 495, 0 ], [ 495, 0 ], [ 1320, 0 ] ]
gap> Maxes( t );
[ "M11", "M12M2", "A6.2^2", "M12M4", "L2(11)", "3^2.2.S4", "M12M7", 
  "2xS5", "M8.S4", "4^2:D12", "A4xS3" ]

##  doc2/probgen.xml (7324-7328)
gap> g:= MathieuGroup( 12 );
Group([ (1,2,3,4,5,6,7,8,9,10,11), (3,7,11,8)(4,10,5,6), (1,12)(2,11)
  (3,6)(4,8)(5,9)(7,10) ])

##  doc2/probgen.xml (7337-7352)
gap> approx:= ApproxP( prim, spos );
[ 0, 3/11, 1/3, 1/11, 1/132, 13/99, 13/99, 13/396, 1/132, 1/33, 1/33, 
  1/33, 13/396, 0, 0 ]
gap> 2B:= g.2^2;
(3,11)(4,5)(6,10)(7,8)
gap> Size( ConjugacyClass( g, 2B ) );
495
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 10;
gap> prop:= RatioOfNongenerationTransPermGroup( g, 2B, s );
31/99
gap> Filtered( approx, x -> x >= prop );
[ 1/3 ]

##  doc2/probgen.xml (7365-7379)
gap> x:= g.2^2;
(3,11)(4,5)(6,10)(7,8)
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, x, r ) );;
gap> SortedList( prop );
[ 7/55, 31/99, 5/9, 5/9, 39/55, 383/495, 383/495, 43/55, 29/33, 1, 1, 
  1, 1, 1, 1 ]
gap> bad:= Filtered( prop, x -> x < 31/99 );
[ 7/55 ]
gap> pos:= Position( prop, bad[1] );;
gap> [ Order( ccl[ pos ] ), NrMovedPoints( ccl[ pos ] ) ];
[ 6, 12 ]

##  doc2/probgen.xml (7388-7396)
gap> x:= g.3;
(1,12)(2,11)(3,6)(4,8)(5,9)(7,10)
gap> s:= ccl[ pos ];;
gap> prop:= RatioOfNongenerationTransPermGroup( g, x, s );
17/33
gap> prop > 31/99;
true

##  doc2/probgen.xml (7472-7534)
gap> t:= CharacterTable( "O7(3)" );;
gap> someprim:= [];;
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2.U4(3).2_2" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PermChars( t, rec( torso:= [ 364 ] ) );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "L4(3).2_2" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "G2(3)" ), t );
[ Character( CharacterTable( "O7(3)" ),
  [ 1080, 0, 0, 24, 108, 0, 0, 0, 27, 18, 9, 0, 12, 4, 0, 0, 0, 0, 0, 
      0, 0, 0, 12, 0, 0, 0, 0, 0, 3, 6, 0, 3, 2, 2, 2, 0, 0, 0, 3, 0, 
      0, 0, 0, 0, 0, 4, 0, 3, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "O7(3)" ),
  [ 1080, 0, 0, 24, 108, 0, 0, 27, 0, 18, 9, 0, 12, 4, 0, 0, 0, 0, 0, 
      0, 0, 0, 12, 0, 0, 0, 0, 3, 0, 0, 6, 3, 2, 2, 2, 0, 0, 3, 0, 0, 
      0, 0, 0, 0, 0, 4, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> Append( someprim, pi );
gap> pi:= PermChars( t, rec( torso:= [ 1120 ] ) );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "S6(2)" ), t );
[ Character( CharacterTable( "O7(3)" ),
  [ 3159, 567, 135, 39, 0, 81, 0, 0, 27, 27, 0, 15, 3, 3, 7, 4, 0, 
      27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 0, 3, 9, 3, 0, 2, 1, 1, 0, 0, 0, 
      3, 0, 2, 0, 0, 0, 3, 0, 0, 3, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "O7(3)" ),
  [ 3159, 567, 135, 39, 0, 81, 0, 27, 0, 27, 0, 15, 3, 3, 7, 4, 0, 
      27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 3, 0, 3, 9, 0, 2, 1, 1, 0, 0, 3, 
      0, 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] ) ]
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "S9" ), t );
[ Character( CharacterTable( "O7(3)" ),
  [ 12636, 1296, 216, 84, 0, 81, 0, 0, 108, 27, 0, 6, 0, 12, 10, 1, 
      0, 27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 0, 12, 9, 3, 0, 1, 0, 2, 0, 
      0, 0, 3, 1, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 
      1 ] ), Character( CharacterTable( "O7(3)" ),
  [ 12636, 1296, 216, 84, 0, 81, 0, 108, 0, 27, 0, 6, 0, 12, 10, 1, 
      0, 27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 12, 0, 3, 9, 0, 1, 0, 2, 0, 
      0, 3, 0, 1, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 
      1 ] ) ]
gap> Append( someprim, pi );
gap> t2:= CharacterTable( "O7(3).2" );;
gap> s2:= CharacterTable( "Dihedral", 8 ) * CharacterTable( "U4(2).2" );
CharacterTable( "Dihedral(8)xU4(2).2" )
gap> pi:= PossiblePermutationCharacters( s2, t2 );;  Length( pi );
1
gap> pi:= RestrictedClassFunctions( pi, t );;
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2^6:A7" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> List( someprim, x -> x[1] );
[ 351, 364, 378, 1080, 1080, 1120, 3159, 3159, 12636, 12636, 22113, 
  28431 ]

##  doc2/probgen.xml (7550-7558)
gap> cl:= PositionsProperty( AtlasClassNames( t ),
>                            x -> x in [ "3D", "3E" ] );
[ 8, 9 ]
gap> List( Filtered( someprim, x -> x[1] = 12636 ), pi -> pi{ cl } );
[ [ 0, 108 ], [ 108, 0 ] ]
gap> GetFusionMap( t, t2 ){ cl };
[ 8, 8 ]

##  doc2/probgen.xml (7567-7572)
gap> spos:= Position( OrdersClassRepresentatives( t ), 14 );
52
gap> Maximum( ApproxP( someprim, spos ) );
199/351

##  doc2/probgen.xml (7583-7588)
gap> approx:= List( [ 1 .. NrConjugacyClasses( t ) ],
>       i -> Maximum( ApproxP( someprim, i ) ) );;
gap> PositionsProperty( approx, x -> x <= 199/351 );
[ 52 ]

##  doc2/probgen.xml (7596-7601)
gap> pos:= PositionsProperty( someprim, x -> x[ spos ] <> 0 );
[ 1, 9, 10 ]
gap> List( someprim{ pos }, x -> x{ [ 1, spos ] } );
[ [ 351, 1 ], [ 12636, 1 ], [ 12636, 1 ] ]

##  doc2/probgen.xml (7619-7628)
gap> so73:= SpecialOrthogonalGroup( 7, 3 );;
gap> o73:= DerivedSubgroup( so73 );;
gap> orbs:= OrbitsDomain( o73, Elements( GF(3)^7 ) );;
gap> Set( orbs, Length );
[ 1, 702, 728, 756 ]
gap> g:= Action( o73, First( orbs, x -> Length( x ) = 702 ) );;
gap> Size( g ) = Size( t );
true

##  doc2/probgen.xml (7637-7649)
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 14;
gap> 2A:= s^7;;
gap> bad:= RatioOfNongenerationTransPermGroup( g, 2A, s );
155/351
gap> bad > 1/3;
true
gap> approx:= ApproxP( someprim, spos );;
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]

##  doc2/probgen.xml (7663-7683)
gap> consider:= RepresentativesMaximallyCyclicSubgroups( t );
[ 18, 19, 25, 26, 27, 30, 31, 32, 34, 35, 38, 39, 41, 42, 43, 44, 45, 
  46, 47, 48, 49, 50, 52, 53, 54, 56, 57, 58 ]
gap> Length( consider );
28
gap> consider:= ClassesPerhapsCorrespondingToTableColumns( g, t, consider );;
gap> Length( consider );
31
gap> consider:= List( consider, Representative );;
gap> SortParallel( List( consider, Order ), consider );
gap> app2A:= List( consider, c ->
>       RatioOfNongenerationTransPermGroup( g, 2A, c ) );;
gap> SortedList( app2A );
[ 1/3, 1/3, 155/351, 191/351, 67/117, 23/39, 23/39, 85/117, 10/13, 
  10/13, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
  1 ]
gap> test:= PositionsProperty( app2A, x -> x <= 155/351 );;
gap> List( test, i -> Order( consider[i] ) );
[ 13, 13, 14 ]

##  doc2/probgen.xml (7696-7705)
gap> C3A:= First( ConjugacyClasses( g ),
>               c -> Order( Representative( c ) ) = 3 and Size( c ) = 7280 );;
gap> repeat ss:= Random( g );
>    until Order( ss ) = 13;
gap> bad:= RatioOfNongenerationTransPermGroup( g, Representative( C3A ), ss );
17/35
gap> bad > 155/351;
true

##  doc2/probgen.xml (7721-7731)
gap> approx:= ApproxP( someprim, spos );;
gap> max:= Maximum( approx{ [ 3 .. Length( approx ) ] } );
59/351
gap> 155 + 2*59 < 351;
true
gap> third:= PositionsProperty( approx, x -> 2 * 155/351 + x >= 1 );
[ 2, 3, 6 ]
gap> ClassNames( t ){ third };
[ "2a", "2b", "3b" ]

##  doc2/probgen.xml (7740-7759)
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 20 );
[ 58 ]
gap> PowerMap( t, 10 ){ ord20 };
[ 3 ]
gap> repeat x:= Random( g );
>    until Order( x ) = 20;
gap> 2B:= x^10;;
gap> C2B:= ConjugacyClass( g, 2B );;
gap> ord15:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 15 );
[ 53 ]
gap> PowerMap( t, 10 ){ ord15 };
[ 6 ]
gap> repeat x:= Random( g );
>    until Order( x ) = 15;
gap> 3B:= x^5;;
gap> C3B:= ConjugacyClass( g, 3B );;

##  doc2/probgen.xml (7768-7777)
gap> repeat s:= Random( g );
>    until Order( s ) = 14;
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2B, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3B, 2A, 2A ], s, 50 );
true

##  doc2/probgen.xml (7790-7814)
gap> prim:= someprim{ [ 1 ] };
[ Character( CharacterTable( "O7(3)" ),
  [ 351, 127, 47, 15, 27, 45, 36, 0, 0, 9, 0, 15, 3, 3, 7, 6, 19, 19, 
      10, 11, 12, 8, 3, 5, 3, 6, 1, 0, 0, 3, 3, 0, 1, 1, 1, 6, 3, 0, 
      0, 2, 2, 0, 3, 0, 3, 3, 0, 0, 1, 0, 0, 1, 0, 4, 4, 1, 2, 0 ] ) ]
gap> spos:= Position( AtlasClassNames( t ), "14A" );;
gap> t2:= CharacterTable( "O7(3).2" );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );;
gap> ext:= List( torso, x -> PermChars( t2, rec( torso:= x ) ) );
[ [ Character( CharacterTable( "O7(3).2" ),
      [ 351, 127, 47, 15, 27, 45, 36, 0, 9, 0, 15, 3, 3, 7, 6, 19, 
          19, 10, 11, 12, 8, 3, 5, 3, 6, 1, 0, 3, 0, 1, 1, 1, 6, 3, 
          0, 2, 2, 0, 3, 0, 3, 3, 0, 1, 0, 0, 1, 0, 4, 1, 2, 0, 117, 
          37, 21, 45, 1, 13, 5, 1, 9, 9, 18, 15, 1, 7, 9, 6, 4, 0, 3, 
          0, 3, 3, 6, 2, 2, 9, 6, 1, 3, 1, 4, 1, 2, 1, 1, 0, 3, 1, 0, 
          0, 0, 0, 1, 1, 0, 0 ] ) ] ]
gap> approx:= ApproxP( Concatenation( ext ),
>        Position( AtlasClassNames( t2 ), "14A" ) );;
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
1/3

##  doc2/probgen.xml (7903-7907)
gap> t:= CharacterTable( "O8+(2)" );;
gap> ProbGenInfoSimple( t );
[ "O8+(2)", 334/315, 0, [ "15A", "15B", "15C" ], [ 7, 7, 7 ] ]

##  doc2/probgen.xml (7918-7923)
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 15 );;
gap> List( Filtered( prim, x -> x[ spos ] <> 0 ), l -> l{ [ 1, spos ] } );
[ [ 120, 1 ], [ 135, 2 ], [ 960, 2 ], [ 1120, 1 ], [ 12096, 1 ] ]

##  doc2/probgen.xml (7936-7950)
gap> matgroup:= DerivedSubgroup( GeneralOrthogonalGroup( 1, 8, 2 ) );;
gap> points:= NormedRowVectors( GF(2)^8 );;
gap> orbs:= OrbitsDomain( matgroup, points );;
gap> List( orbs, Length );
[ 135, 120 ]
gap> g:= Action( matgroup, orbs[2] );;
gap> Size( g );
174182400
gap> pi:= Sum( Irr( t ){ [ 1, 3, 7 ] } );
Character( CharacterTable( "O8+(2)" ),
 [ 120, 24, 32, 0, 0, 8, 36, 0, 0, 3, 6, 12, 4, 8, 0, 0, 0, 10, 0, 0, 
  12, 0, 0, 8, 0, 0, 3, 6, 0, 0, 2, 0, 0, 2, 1, 2, 2, 3, 0, 0, 2, 0, 
  0, 0, 0, 0, 3, 2, 0, 0, 1, 0, 0 ] )

##  doc2/probgen.xml (7963-7973)
gap> approx:= ApproxP( prim, spos );;
gap> testpos:= PositionsProperty( approx, x -> x >= 1/3 );
[ 2, 3, 7 ]
gap> AtlasClassNames( t ){ testpos };
[ "2A", "2B", "3A" ]
gap> approx{ testpos };
[ 254/315, 334/315, 1093/1120 ]
gap> ForAll( approx{ testpos }, x -> x > 1/2 );
true

##  doc2/probgen.xml (7996-8011)
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 15 and NrMovedPoints( g ) = 1 + NrMovedPoints( s );
gap> 3A:= s^5;;
gap> repeat x:= Random( g ); until Order( x ) = 8;
gap> 2A:= x^4;;
gap> repeat x:= Random( g ); until Order( x ) = 12 and
>      NrMovedPoints( g ) = 32 + NrMovedPoints( x^6 );
gap> 2B:= x^6;;
gap> prop15A:= List( [ 2A, 2B, 3A ],
>                    x -> RatioOfNongenerationTransPermGroup( g, x, s ) );
[ 23/35, 29/42, 149/224 ]
gap> Maximum( prop15A );
29/42

##  doc2/probgen.xml (8027-8040)
gap> test:= List( [ 2A, 2B, 3A ], x -> ConjugacyClass( g, x ) );;
gap> ccl:= ConjugacyClasses( g );;
gap> consider:= Filtered( ccl, c -> Size( c ) in List( test, Size ) );;
gap> Length( consider );
7
gap> filt:= Filtered( ccl, c -> ForAll( consider, cc ->
>       RatioOfNongenerationTransPermGroup( g, Representative( cc ),
>           Representative( c ) ) <= 29/42 ) );;
gap> Length( filt );
3
gap> List( filt, c -> Order( Representative( c ) ) );
[ 15, 15, 15 ]

##  doc2/probgen.xml (8062-8083)
gap> SizesConjugacyClasses( t );
[ 1, 1575, 3780, 3780, 3780, 56700, 2240, 2240, 2240, 89600, 268800, 
  37800, 340200, 907200, 907200, 907200, 2721600, 580608, 580608, 
  580608, 100800, 100800, 100800, 604800, 604800, 604800, 806400, 
  806400, 806400, 806400, 2419200, 2419200, 2419200, 7257600, 
  24883200, 5443200, 5443200, 6451200, 6451200, 6451200, 8709120, 
  8709120, 8709120, 1209600, 1209600, 1209600, 4838400, 7257600, 
  7257600, 7257600, 11612160, 11612160, 11612160 ]
gap> NrPolyhedralSubgroups( t, 2, 2, 2 );
rec( number := 14175, type := "V4" )
gap> repeat x:= Random( g );
>    until     Order( x ) mod 2 = 0
>          and NrMovedPoints( x^( Order(x)/2 ) ) = 120 - 24;
gap> x:= x^( Order(x)/2 );;
gap> repeat y:= x^Random( g );
>    until NrMovedPoints( x*y ) = 120 - 24;
gap> v4:= SubgroupNC( g, [ x, y ] );;
gap> n:= Normalizer( g, v4 );;
gap> Index( g, n );
14175

##  doc2/probgen.xml (8091-8099)
gap> maxorder:= RepresentativesMaximallyCyclicSubgroups( t );;
gap> maxorderreps:= List( ClassesPerhapsCorrespondingToTableColumns( g, t,
>        maxorder ), Representative );;
gap> Length( maxorderreps );
28
gap> CommonGeneratorWithGivenElements( g, maxorderreps, [ x, y, x*y ] );
fail

##  doc2/probgen.xml (8119-8127)
gap> reps:= List( ccl, Representative );;
gap> bading:= List( testpos, i -> Filtered( reps,
>        r -> Order( r ) = OrdersClassRepresentatives( t )[i] and
>             NrMovedPoints( r ) = 120 - pi[i] ) );;
gap> List( bading, Length );
[ 1, 1, 1 ]
gap> bading:= List( bading, x -> x[1] );;

##  doc2/probgen.xml (8140-8147)
gap> for pair in UnorderedTuples( bading, 2 ) do
>      test:= RandomCheckUniformSpread( g, pair, s, 80 );
>      if test <> true then
>        Error( test );
>      fi;
>    od;

##  doc2/probgen.xml (8250-8259)
gap> matgrp:= SO(1,8,2);;
gap> g2:= Image( IsomorphismPermGroup( matgrp ) );;
gap> IsTransitive( g2, MovedPoints( g2 ) );
true
gap> repeat x:= Random( g2 ); until Order( x ) = 14;
gap> 2F:= x^7;;
gap> Size( ConjugacyClass( g2, 2F ) );
120

##  doc2/probgen.xml (8268-8279)
gap> der:= DerivedSubgroup( g2 );;
gap> cclreps:= List( ConjugacyClasses( der ), Representative );;
gap> nongen:= List( cclreps,
>               x -> RatioOfNongenerationTransPermGroup( g2, 2F, x ) );;
gap> goodpos:= PositionsProperty( nongen, x -> x < 1 );;
gap> invariants:= List( goodpos, i -> [ Order( cclreps[i] ),
>      Size( Centralizer( g2, cclreps[i] ) ), nongen[i] ] );;
gap> SortedList( invariants );
[ [ 10, 20, 1/3 ], [ 10, 20, 1/3 ], [ 12, 24, 2/5 ], [ 12, 24, 2/5 ], 
  [ 15, 15, 0 ], [ 15, 15, 0 ] ]

##  doc2/probgen.xml (8325-8344)
gap> aut:= Group( AtlasGenerators( "Fi22", 1, 4 ).generators );;
gap> Size( aut ) = 6 * Size( t );
true
gap> g3:= DerivedSubgroup( aut );;
gap> orbs:= OrbitsDomain( g3, MovedPoints( g3 ) );;
gap> List( orbs, Length );
[ 3150, 360 ]
gap> g3:= Action( g3, orbs[2] );;
gap> repeat s:= Random( g3 ); until Order( s ) = 15;
gap> repeat x:= Random( g3 ); until Order( x ) = 21;
gap> 3F:= x^7;;
gap> RatioOfNongenerationTransPermGroup( g3, 3F, s );
0
gap> repeat x:= Random( g3 );
>    until Order( x ) = 12 and Size( Centralizer( g3, x^4 ) ) = 648;
gap> 3G:= x^4;;
gap> RatioOfNongenerationTransPermGroup( g3, 3G, s );
0

##  doc2/probgen.xml (8382-8406)
gap> t2:= CharacterTable( "O8+(2).2" );;
gap> s:= CharacterTable( "S6(2)" ) * CharacterTable( "Cyclic", 2 );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> prim:= pi;;
gap> pi:= PermChars( t2, rec( torso:= [ 135 ] ) );;
gap> Append( prim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "A9.2" ), t2 );;
gap> Append( prim, pi );
gap> s:= CharacterTable( "Dihedral(6)" ) * CharacterTable( "U4(2).2" );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> Append( prim, pi );
gap> s:= CharacterTableWreathSymmetric( CharacterTable( "S5" ), 2 );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> Append( prim, pi );
gap> Length( prim );
5
gap> ord15:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                               x -> x = 15 );
[ 39, 40 ]
gap> List( prim, pi -> pi{ ord15 } );
[ [ 1, 0 ], [ 2, 0 ], [ 2, 0 ], [ 1, 0 ], [ 1, 0 ] ]
gap> List( ord15, i -> Maximum( ApproxP( prim, i ) ) );
[ 307/120, 0 ]

##  doc2/probgen.xml (8414-8416)
gap> CleanWorkspace();

##  doc2/probgen.xml (8514-8518)
gap> t:= CharacterTable( "O8+(3)" );;
gap> ProbGenInfoSimple( t );
[ "O8+(3)", 863/1820, 2, [ "20A", "20B", "20C" ], [ 8, 8, 8 ] ]

##  doc2/probgen.xml (8527-8539)
gap> prim:= PrimitivePermutationCharacters( t );;
gap> ord:= OrdersClassRepresentatives( t );;
gap> spos:= Position( ord, 20 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
[ 1, 2, 7, 15, 18, 19, 24 ]
gap> Maxes( t ){ filt };
[ "O7(3)", "O8+(3)M2", "3^6:L4(3)", "2.U4(3).(2^2)_{122}", 
  "(A4xU4(2)):2", "O8+(3)M19", "(A6xA6):2^2" ]
gap> prim{ filt }{ [ 1, spos ] };
[ [ 1080, 1 ], [ 1080, 1 ], [ 1120, 2 ], [ 189540, 1 ], 
  [ 7960680, 1 ], [ 7960680, 1 ], [ 9552816, 1 ] ]

##  doc2/probgen.xml (8550-8562)
gap> ord:= OrdersClassRepresentatives( t );;
gap> ord20:= PositionsProperty( ord, x -> x = 20 );;
gap> cand:= [];;
gap> for i in ord20 do
>      approx:= ApproxP( prim, i );
>      Add( cand, PositionsProperty( approx, x -> x >= 1/3 ) );
>    od;
gap> cand;
[ [ 2, 6, 7, 10 ], [ 3, 6, 8, 11 ], [ 4, 6, 9, 12 ] ]
gap> AtlasClassNames( t ){ cand[1] };
[ "2A", "3A", "3B", "3E" ]

##  doc2/probgen.xml (8571-8576)
gap> t3:= CharacterTable( "O8+(3).3" );;
gap> tfust3:= GetFusionMap( t, t3 );;
gap> List( cand, x -> tfust3{ x } );
[ [ 2, 4, 5, 6 ], [ 2, 4, 5, 6 ], [ 2, 4, 5, 6 ] ]

##  doc2/probgen.xml (8592-8612)
gap> g:= Action( SO(1,8,3), NormedRowVectors( GF(3)^8 ), OnLines );;
gap> Size( g );
9904359628800
gap> g:= DerivedSubgroup( g );;  Size( g );
4952179814400
gap> orbs:= OrbitsDomain( g, MovedPoints( g ) );;
gap> List( orbs, Length );
[ 1080, 1080, 1120 ]
gap> g:= Action( g, orbs[1] );;
gap> PositionProperty( Irr( t ), chi -> chi[1] = 819 );
9
gap> permchar:= Sum( Irr( t ){ [ 1, 2, 9 ] } );
Character( CharacterTable( "O8+(3)" ),
 [ 1080, 128, 0, 0, 24, 108, 135, 0, 0, 108, 0, 0, 27, 27, 0, 0, 18, 
  9, 12, 16, 0, 0, 4, 15, 0, 0, 20, 0, 0, 12, 11, 0, 0, 20, 0, 0, 15, 
  0, 0, 12, 0, 0, 2, 0, 0, 3, 3, 0, 0, 6, 6, 0, 0, 3, 2, 2, 2, 18, 0, 
  0, 9, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 3, 0, 0, 12, 0, 0, 3, 0, 0, 0, 
  0, 0, 4, 3, 3, 0, 0, 1, 0, 0, 4, 0, 0, 1, 1, 2, 0, 0, 0, 0, 0, 3, 
  0, 0, 2, 0, 0, 5, 0, 0, 1, 0, 0 ] )

##  doc2/probgen.xml (8628-8661)
gap> permchar{ ord20 };
[ 1, 0, 0 ]
gap> AtlasClassNames( t )[ PowerMap( t, 10 )[ ord20[1] ] ];
"2A"
gap> ord18:= PositionsProperty( ord, x -> x = 18 );;
gap> Set( AtlasClassNames( t ){ PowerMap( t, 6 ){ ord18 } } );
[ "3A" ]
gap> ord15:= PositionsProperty( ord, x -> x = 15 );;
gap> PowerMap( t, 5 ){ ord15 };
[ 7, 8, 9, 10, 11, 12 ]
gap> AtlasClassNames( t ){ [ 7 .. 12 ] };
[ "3B", "3C", "3D", "3E", "3F", "3G" ]
gap> permchar{ [ 7 .. 12 ] };
[ 135, 0, 0, 108, 0, 0 ]
gap> mp:= NrMovedPoints( g );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat 20A:= Random( g );
>    until Order( 20A ) = 20 and mp - NrMovedPoints( 20A ) = 1;
gap> 2A:= 20A^10;;
gap> repeat x:= Random( g ); until Order( x ) = 18;
gap> 3A:= x^6;;
gap> repeat x:= Random( g );
>    until Order( x ) = 15 and mp - NrMovedPoints( x^5 ) = 135;
gap> 3B:= x^5;;
gap> repeat x:= Random( g );
>    until Order( x ) = 15 and mp - NrMovedPoints( x^5 ) = 108;
gap> 3E:= x^5;;
gap> nongen:= List( [ 2A, 3A, 3B, 3E ],
>                   c -> RatioOfNongenerationTransPermGroup( g, c, 20A ) );
[ 3901/9477, 194/455, 451/1092, 451/1092 ]
gap> Maximum( nongen );
194/455

##  doc2/probgen.xml (8678-8696)
gap> maxorder:= RepresentativesMaximallyCyclicSubgroups( t );;
gap> Length( maxorder );
57
gap> autt:= CharacterTable( "O8+(3).S4" );;
gap> fus:= PossibleClassFusions( t, autt );;
gap> orbreps:= Set( fus, map -> Set( ProjectionMap( map ) ) );
[ [ 1, 2, 5, 6, 7, 13, 17, 18, 19, 20, 23, 24, 27, 30, 31, 37, 43, 
      46, 50, 54, 55, 56, 57, 58, 64, 68, 72, 75, 78, 84, 85, 89, 95, 
      96, 97, 100, 106, 112 ] ]
gap> totest:= Intersection( maxorder, orbreps[1] );
[ 43, 50, 54, 56, 57, 64, 68, 75, 78, 84, 85, 89, 95, 97, 100, 106, 
  112 ]
gap> Length( totest );
17
gap> AtlasClassNames( t ){ totest };
[ "6Q", "6X", "6B1", "8A", "8B", "9G", "9K", "12A", "12D", "12J", 
  "12K", "12O", "13A", "14A", "15A", "18A", "20A" ]

##  doc2/probgen.xml (8709-8716)
gap> elementstotest:= [];;
gap> for elord in [ 13, 14, 15, 18 ] do
>      repeat s:= Random( g );
>      until Order( s ) = elord;
>      Add( elementstotest, s );
>    od;

##  doc2/probgen.xml (8732-8752)
gap> ordcent:= [ [ 6, 162 ], [ 9, 729 ], [ 9, 81 ], [ 12, 1728 ],
>                [ 12, 432 ], [ 12, 192 ], [ 12, 108 ], [ 12, 72 ] ];;
gap> cents:= SizesCentralizers( t );;
gap> for pair in ordcent do
>      Print( pair, ": ", AtlasClassNames( t ){
>          Filtered( [ 1 .. Length( ord ) ],
>                    i -> ord[i] = pair[1] and cents[i] = pair[2] ) }, "\n" );
>      repeat s:= Random( g );
>      until Order( s ) = pair[1] and Size( Centralizer( g, s ) ) = pair[2];
>      Add( elementstotest, s );
>    od;
[ 6, 162 ]: [ "6B1" ]
[ 9, 729 ]: [ "9G", "9H", "9I", "9J" ]
[ 9, 81 ]: [ "9K", "9L", "9M", "9N" ]
[ 12, 1728 ]: [ "12A", "12B", "12C" ]
[ 12, 432 ]: [ "12D", "12E", "12F", "12G", "12H", "12I" ]
[ 12, 192 ]: [ "12J" ]
[ 12, 108 ]: [ "12K", "12L", "12M", "12N" ]
[ 12, 72 ]: [ "12O", "12P", "12Q", "12R", "12S", "12T" ]

##  doc2/probgen.xml (8761-8771)
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> cents[i] = 648 and cents[ PowerMap( t, 2 )[i] ] = 52488
>                            and cents[ PowerMap( t, 3 )[i] ] = 26127360 ) };
[ "6Q", "6R", "6S" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 6 and Size( Centralizer( g, s ) ) = 648
>      and Size( Centralizer( g, s^2 ) ) = 52488
>      and Size( Centralizer( g, s^3 ) ) = 26127360;
gap> Add( elementstotest, s );

##  doc2/probgen.xml (8780-8790)
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> cents[i] = 648 and cents[ PowerMap( t, 2 )[i] ] = 52488
>                            and cents[ PowerMap( t, 3 )[i] ] = 331776 ) };
[ "6X", "6Y", "6Z", "6A1" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 6 and Size( Centralizer( g, s ) ) = 648
>      and Size( Centralizer( g, s^2 ) ) = 52488
>      and Size( Centralizer( g, s^3 ) ) = 331776;
gap> Add( elementstotest, s );

##  doc2/probgen.xml (8798-8811)
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> ord[i] = 8 and cents[ PowerMap( t, 2 )[i] ] = 13824 ) };
[ "8A" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 8 and Size( Centralizer( g, s^2 ) ) = 13824;
gap> Add( elementstotest, s );
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> ord[i] = 8 and cents[ PowerMap( t, 2 )[i] ] = 1536 ) };
[ "8B" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 8 and Size( Centralizer( g, s^2 ) ) = 1536;
gap> Add( elementstotest, s );

##  doc2/probgen.xml (8820-8827)
gap> nongen:= List( elementstotest,
>                   s -> RatioOfNongenerationTransPermGroup( g, 3A, s ) );;
gap> smaller:= PositionsProperty( nongen, x -> x < 194/455 );
[ 2, 3 ]
gap> nongen{ smaller };
[ 127/325, 1453/3640 ]

##  doc2/probgen.xml (8841-8855)
gap> repeat s:= Random( g );
>    until Order( s ) = 14 and NrMovedPoints( s ) = 1078;
gap> 2A:= s^7;;
gap> nongen:= RatioOfNongenerationTransPermGroup( g, 2A, s );
1573/3645
gap> nongen > 194/455;
true
gap> repeat s:= Random( g );
>    until Order( s ) = 15 and NrMovedPoints( s ) = 1080 - 3;
gap> nongen:= RatioOfNongenerationTransPermGroup( g, 2A, s );
490/1053
gap> nongen > 194/455;
true

##  doc2/probgen.xml (8866-8874)
gap> for tup in UnorderedTuples( [ 2A, 3A, 3B, 3E ], 3 ) do
>      cl:= ShallowCopy( tup );
>      test:= RandomCheckUniformSpread( g, cl, 20A, 100 );
>      if test <> true then
>        Error( test );
>      fi;
>    od;

##  doc2/probgen.xml (8887-8892)
gap> der:= DerivedSubgroup( SO(1,8,3) );;
gap> repeat x:= PseudoRandom( der ); until Order( x ) = 40;
gap> 40 in ord;
false

##  doc2/probgen.xml (8917-8921)
gap> u42:= CharacterTable( "U4(2)" );;
gap> Filtered( OrdersClassRepresentatives( u42 ), x -> x mod 5 = 0 );
[ 5 ]

##  doc2/probgen.xml (8934-8950)
gap> u:= CharacterTable( Maxes( t )[18] );
CharacterTable( "(A4xU4(2)):2" )
gap> 2u42:= CharacterTable( "2.U4(2)" );;
gap> OrdersClassRepresentatives( 2u42 )[4];
4
gap> GetFusionMap( 2u42, u42 )[4];
3
gap> OrdersClassRepresentatives( u42 )[3];
2
gap> List( PossibleClassFusions( u42, u ), x -> x[3] );
[ 8 ]
gap> PositionsProperty( SizesConjugacyClasses( u ), x -> x = 3 );
[ 2 ]
gap> ForAll( PossibleClassFusions( u, t ), x -> x[2] = x[8] );
true

##  doc2/probgen.xml (8976-8986)
gap> u:= CharacterTable( Maxes( t )[24] );
CharacterTable( "(A6xA6):2^2" )
gap> ClassPositionsOfDerivedSubgroup( u );
[ 1 .. 22 ]
gap> PositionsProperty( OrdersClassRepresentatives( u ), x -> x = 20 );
[ 8 ]
gap> List( ClassPositionsOfNormalSubgroups( u ),
>          x -> Sum( SizesConjugacyClasses( u ){ x } ) );
[ 1, 129600, 259200, 259200, 259200, 518400 ]

##  doc2/probgen.xml (9007-9015)
gap> t2:= CharacterTable( "O8+(3).2_1" );;
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                x -> x = 20 );;
gap> ord20:= Intersection( ord20, ClassPositionsOfDerivedSubgroup( t2 ) );
[ 84, 85, 86 ]
gap> List( ord20, x -> x in PowerMap( t2, 2 ) );
[ false, true, true ]

##  doc2/probgen.xml (9039-9044)
gap> tfust2:= GetFusionMap( t, t2 );;
gap> tfust2{ PositionsProperty( OrdersClassRepresentatives( t ),
>                x -> x = 20 ) };
[ 84, 85, 86 ]

##  doc2/probgen.xml (9058-9071)
gap> primt2:= [];;
gap> poss:= PossiblePermutationCharacters( CharacterTable( "O7(3)" ), t );;
gap> invfus:= InverseMap( tfust2 );;
gap> List( poss, pi -> ForAll( CompositionMaps( pi, invfus ), IsInt ) );
[ false, false, false, false, true, true ]
gap> PossiblePermutationCharacters(
>        CharacterTable( "O7(3)" ) * CharacterTable( "Cyclic", 2 ), t2 );
[  ]
gap> ext:= PossiblePermutationCharacters( CharacterTable( "O7(3).2" ), t2 );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 1, 0, 0 ], [ 1, 0, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9082-9087)
gap> ext:= PossiblePermutationCharacters( CharacterTable( "L4(3).2^2" ), t2 );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 0, 0, 1 ], [ 0, 1, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9101-9105)
gap> List( PossiblePermutationCharacters( CharacterTable( "L4(3).2_2" ) *
>              CharacterTable( "Cyclic", 2 ), t2 ), pi -> pi{ ord20 } );
[ [ 1, 0, 0 ] ]

##  doc2/probgen.xml (9115-9120)
gap> ext:= PermChars( t2, rec( torso:= [ 1120 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 2, 0, 0 ], [ 0, 0, 2 ], [ 0, 2, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9130-9138)
gap> filt:= Filtered( prim, x -> x[1] = 189540 );;
gap> cand:= List( filt, x -> CompositionMaps( x, invfus ) );;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9147-9153)
gap> ext:= PossiblePermutationCharacters( CharacterTable( "Symmetric", 4 ) *
>              CharacterTable( "U4(2).2" ), t2 );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 1, 0, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9163-9171)
gap> filt:= Filtered( prim, x -> x[1] = 9552816 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9185-9194)
gap> Length( primt2 );
15
gap> approx:= List( ord20, x -> ApproxP( primt2, x ) );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> List( approx, l -> Maximum( l{ outer } ) );
[ 574/1215, 83/567, 83/567 ]

##  doc2/probgen.xml (9208-9218)
gap> t2:= CharacterTable( "O8+(3).2_2" );;
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                x -> x = 20 );;
gap> ord20:= Intersection( ord20, ClassPositionsOfDerivedSubgroup( t2 ) );
[ 82, 83 ]
gap> tfust2:= GetFusionMap( t, t2 );;
gap> tfust2{ PositionsProperty( OrdersClassRepresentatives( t ),
>                x -> x = 20 ) };
[ 82, 83, 83 ]

##  doc2/probgen.xml (9240-9246)
gap> primt2:= [];;
gap> ext:= PermChars( t2, rec( torso:= [ 1080 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 1, 0 ], [ 1, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9257-9262)
gap> ext:= PermChars( t2, rec( torso:= [ 1120 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 2, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9272-9280)
gap> filt:= Filtered( prim, x -> x[1] = 189540 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9289-9297)
gap> filt:= Filtered( prim, x -> x[1] = 7960680 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ], [ 1, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9307-9313)
gap> ext:= PossiblePermutationCharacters( CharacterTableWreathSymmetric(
>              CharacterTable( "S6" ), 2 ), t2 );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ] ]
gap> Append( primt2, ext );

##  doc2/probgen.xml (9322-9331)
gap> Length( primt2 );
7
gap> approx:= List( ord20, x -> ApproxP( primt2, x ) );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> List( approx, l -> Maximum( l{ outer } ) );
[ 14/9, 0 ]

##  doc2/probgen.xml (9342-9352)
gap> approx:= ApproxP( primt2, ord20[1] );;
gap> bad:= Filtered( outer, i -> approx[i] >= 1/2 );
[ 84 ]
gap> OrdersClassRepresentatives( t2 ){ bad };
[ 2 ]
gap> SizesConjugacyClasses( t2 ){ bad };
[ 1080 ]
gap> Number( SizesConjugacyClasses( t2 ), x -> x = 1080 );
1

##  doc2/probgen.xml (9367-9379)
gap> go:= GO(1,8,3);;
gap> so:= SO(1,8,3);;
gap> outerelm:= First( GeneratorsOfGroup( go ), x -> not x in so );;
gap> g2:= ClosureGroup( DerivedSubgroup( so ), outerelm );;
gap> Size( g2 );
19808719257600
gap> dom:= NormedRowVectors( GF(3)^8 );;
gap> orbs:= OrbitsDomain( g2, dom, OnLines );;
gap> List( orbs, Length );
[ 1080, 1080, 1120 ]
gap> act:= Action( g2, orbs[1], OnLines );;

##  doc2/probgen.xml (9387-9393)
gap> Order( outerelm );
26
gap> g:= Permutation( outerelm^13, orbs[1], OnLines );;
gap> Size( ConjugacyClass( act, g ) );
1080

##  doc2/probgen.xml (9402-9416)
gap> ord20;
[ 82, 83 ]
gap> SizesCentralizers( t2 ){ ord20 };
[ 40, 20 ]
gap> der:= DerivedSubgroup( act );;
gap> repeat 20A:= Random( der );
>    until Order( 20A ) = 20 and Size( Centralizer( act, 20A ) ) = 40;
gap> RatioOfNongenerationTransPermGroup( act, g, 20A );
1
gap> repeat 20BC:= Random( der );
>    until Order( 20BC ) = 20 and Size( Centralizer( act, 20BC ) ) = 20;
gap> RatioOfNongenerationTransPermGroup( act, g, 20BC );
0

##  doc2/probgen.xml (9437-9450)
gap> ccl:= ConjugacyClasses( act );;
gap> der:= DerivedSubgroup( act );;
gap> reps:= Filtered( List( ccl, Representative ), x -> x in der );;
gap> Length( reps );
83
gap> ratios:= List( reps,
>                   s -> RatioOfNongenerationTransPermGroup( act, g, s ) );;
gap> cand:= PositionsProperty( ratios, x -> x < 1 );;
gap> ratios:= ratios{ cand };;
gap> SortParallel( ratios, cand );
gap> ratios;
[ 0, 1/10, 1/10, 16/135, 1/3, 1/3, 11/27, 7/15, 7/15 ]

##  doc2/probgen.xml (9463-9468)
gap> invs:= List( cand,
>       x -> [ Order( reps[x] ), Size( Centralizer( der, reps[x] ) ) ] );
[ [ 20, 20 ], [ 18, 108 ], [ 18, 108 ], [ 14, 28 ], [ 15, 45 ], 
  [ 15, 45 ], [ 10, 40 ], [ 12, 72 ], [ 12, 72 ] ]

##  doc2/probgen.xml (9486-9494)
gap> t3:= CharacterTable( "O8+(3).3" );;
gap> tfust3:= GetFusionMap( t, t3 );;
gap> inv:= InverseMap( tfust3 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );;
gap> ForAll( prim{ filt },
>            pi -> ForAny( CompositionMaps( pi, inv ), IsList ) );
true

##  doc2/probgen.xml (9510-9518)
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( t3 ) ],
>                ClassPositionsOfDerivedSubgroup( t3 ) );
[ 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 
  70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 
  87, 88, 89, 90, 91, 92, 93, 94 ]
gap> Set( OrdersClassRepresentatives( t3 ){ outer } );
[ 3, 6, 9, 12, 18, 21, 24, 27, 36, 39 ]

##  doc2/probgen.xml (9526-9528)
gap> CleanWorkspace();

##  doc2/probgen.xml (9612-9621)
gap> q:= 4;;  n:= 8;;
gap> G:= DerivedSubgroup( SO( 1, n, q ) );;
gap> points:= NormedRowVectors( GF(q)^n );;
gap> orbs:= OrbitsDomain( G, points, OnLines );;
gap> List( orbs, Length );
[ 5525, 16320 ]
gap> hom:= ActionHomomorphism( G, orbs[1], OnLines );;
gap> G:= Image( hom );;

##  doc2/probgen.xml (9632-9643)
gap> Collected( Factors( Size( G ) ) );
[ [ 2, 24 ], [ 3, 5 ], [ 5, 4 ], [ 7, 1 ], [ 13, 1 ], [ 17, 2 ] ]
gap> ResetGlobalRandomNumberGenerators();
gap> repeat x:= Random( G );
>    until Order( x ) mod 13 = 0;
gap> x:= x^( Order( x ) / 13 );;
gap> c:= Centralizer( G, x );;
gap> IsAbelian( c );  AbelianInvariants( c );
true
[ 5, 5, 13 ]

##  doc2/probgen.xml (9653-9660)
gap> t:= CharacterTable( "S6(4)" );;
gap> ord65:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 65 );
[ 105, 106, 107, 108, 109, 110, 111, 112 ]
gap> ord65 = ClassOrbit( t, ord65[1] );
true

##  doc2/probgen.xml (9677-9683)
gap> t:= CharacterTable( "U4(4)" );;
gap> ords:= OrdersClassRepresentatives( t );;
gap> ord65:= PositionsProperty( ords, x -> x = 65 );;
gap> ord65 = ClassOrbit( t, ord65[1] );
true

##  doc2/probgen.xml (9692-9701)
gap> syl5:= SylowSubgroup( c, 5 );;
gap> elms:= Filtered( Elements( syl5 ), y -> Order( y ) = 5 );;
gap> reps:= Set( elms, SmallestGeneratorPerm );;  Length( reps );
6
gap> reps65:= List( reps, y -> SubgroupNC( G, [ y * x ] ) );;
gap> pairs:= Combinations( reps65, 2 );;
gap> ForAny( pairs, p -> IsConjugate( G, p[1], p[2] ) );
false

##  doc2/probgen.xml (9710-9715)
gap> cand:= List( reps, y -> Normalizer( G, SubgroupNC( G, [ y ] ) ) );;
gap> cand:= Filtered( cand, y -> Size( y ) = 10 * Size( t ) );;
gap> Length( cand );
3

##  doc2/probgen.xml (9760-9764)
gap> norms:= List( reps65, y -> Normalizer( G, y ) );;
gap> ForAll( norms, y -> ForAll( cand, M -> IsSubset( M, y ) ) );
true

##  doc2/probgen.xml (9785-9792)
gap> syl5:= SylowSubgroup( cand[1], 5 );;
gap> Size( syl5 );  IsElementaryAbelian( syl5 );
625
true
gap> UpperBoundFixedPointRatios( G, List( cand, ConjugacyClasses ), false );
[ 34817/1645056, false ]

##  doc2/probgen.xml (9864-9873)
gap> frob:= PermList( List( orbs[1], v -> Position( orbs[1],
>              List( v, x -> x^2 ) ) ) );;
gap> G2:= ClosureGroupDefault( G, frob );;
gap> cand2:= List( cand, M -> Normalizer( G2, M ) );;
gap> ccl:= List( cand2,
>                M2 -> PcConjugacyClassReps( SylowSubgroup( M2, 2 ) ) );;
gap> List( ccl, l -> Number( l, x -> Order( x ) = 2 and not x in G ) );
[ 0, 0, 0 ]

##  doc2/probgen.xml (9894-9896)
gap> CleanWorkspace();

##  doc2/probgen.xml (10082-10092)
gap> g:= SO( 9, 3 );;
gap> g:= DerivedSubgroup( g );;
gap> Size( g );
65784756654489600
gap> orbs:= OrbitsDomain( g, NormedRowVectors( GF(3)^9 ), OnLines );;
gap> List( orbs, Length ) / 41;
[ 3240/41, 81, 80 ]
gap> Size( SO( 9, 3 ) ) / Size( GO( -1, 8, 3 ) );
3240

##  doc2/probgen.xml (10101-10128)
gap> t:= CharacterTable( "O9(3)" );;
gap> pi:= PermChars( t, rec( torso:= [ 3240 ] ) );
[ Character( CharacterTable( "O9(3)" ),
  [ 3240, 1080, 380, 132, 48, 324, 378, 351, 0, 0, 54, 27, 54, 27, 0, 
      118, 0, 36, 46, 18, 12, 2, 8, 45, 0, 108, 108, 135, 126, 0, 0, 
      56, 0, 0, 36, 47, 38, 27, 39, 36, 24, 12, 18, 18, 15, 24, 2, 
      18, 15, 9, 0, 0, 0, 2, 0, 18, 11, 3, 9, 6, 6, 9, 6, 3, 6, 3, 0, 
      6, 16, 0, 4, 6, 2, 45, 36, 0, 0, 0, 0, 0, 0, 0, 9, 9, 6, 3, 0, 
      0, 15, 13, 0, 5, 7, 36, 0, 10, 0, 10, 19, 6, 15, 0, 0, 0, 0, 
      12, 3, 10, 0, 3, 3, 7, 0, 6, 6, 2, 8, 0, 4, 0, 2, 0, 1, 3, 0, 
      0, 3, 0, 3, 2, 2, 3, 3, 6, 2, 2, 9, 6, 3, 0, 0, 18, 9, 0, 0, 
      12, 0, 0, 8, 0, 6, 9, 5, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 2, 1, 
      3, 3, 1, 0, 0, 4, 1, 0, 0, 1, 0, 3, 3, 1, 1, 2, 2, 0, 0, 1, 3, 
      4, 0, 1, 2, 0, 0, 1, 0, 4, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 
      1, 1, 1, 1, 0, 0, 1, 1, 1, 0 ] ) ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 41 );
208
gap> approx:= ApproxP( pi, spos );;
gap> Maximum( approx );
1/3
gap> PositionsProperty( approx, x -> x = 1/3 );
[ 2 ]
gap> SizesConjugacyClasses( t )[2];
3321
gap> OrdersClassRepresentatives( t )[2];
2

##  doc2/probgen.xml (10169-10175)
gap> g:= Action( g, orbs[1], OnLines );;
gap> repeat
>      repeat x:= Random( g ); ord:= Order( x ); until ord mod 2 = 0;
>      y:= x^(ord/2);
> until NrMovedPoints( y ) = 3240 - 1080;

##  doc2/probgen.xml (10185-10188)
gap> fp:= Difference( MovedPoints( g ), MovedPoints( y ) );;
gap> orb:= Orbit( g, fp, OnSets );;

##  doc2/probgen.xml (10199-10202)
gap> ForAny( orb, l -> IsEmpty( Intersection( l, fp ) ) );
false

##  doc2/probgen.xml (10247-10250)
gap> Size( GO(5,9) ) / 61;
6886425600/61

##  doc2/probgen.xml (10263-10269)
gap> t:= CharacterTable( "O10-(3)" );  s:= CharacterTable( "U5(3)" );
CharacterTable( "O10-(3)" )
CharacterTable( "U5(3)" )
gap> SigmaFromMaxes( t, "61A", [ s ], [ 1 ] );
1/1066

##  doc2/probgen.xml (10292-10325)
gap> m:= SU(5,3);;
gap> so:= SO(-1,10,3);;
gap> omega:= DerivedSubgroup( so );;
gap> om:= InvariantBilinearForm( so ).matrix;;
gap> Display( om );
 . 1 . . . . . . . .
 1 . . . . . . . . .
 . . 1 . . . . . . .
 . . . 2 . . . . . .
 . . . . 2 . . . . .
 . . . . . 2 . . . .
 . . . . . . 2 . . .
 . . . . . . . 2 . .
 . . . . . . . . 2 .
 . . . . . . . . . 2
gap> b:= Basis( GF(9), [ Z(3)^0, Z(3^2)^2 ] );
Basis( GF(3^2), [ Z(3)^0, Z(3^2)^2 ] )
gap> blow:= List( GeneratorsOfGroup( m ), x -> BlownUpMat( b, x ) );;
gap> form:= BlownUpMat( b, InvariantSesquilinearForm( m ).matrix );;
gap> ForAll( blow, x -> x * form * TransposedMat( x ) = form );
true
gap> Display( form );
 . . . . . . . . 1 .
 . . . . . . . . . 1
 . . . . . . 1 . . .
 . . . . . . . 1 . .
 . . . . 1 . . . . .
 . . . . . 1 . . . .
 . . 1 . . . . . . .
 . . . 1 . . . . . .
 1 . . . . . . . . .
 . 1 . . . . . . . .

##  doc2/probgen.xml (10336-10354)
gap> T1:= IdentityMat( 10, GF(3) );;
gap> T1{[1..3]}{[1..3]}:= [[1,1,0],[1,-1,1],[1,-1,-1]]*Z(3)^0;;
gap> pi:= PermutationMat( (1,10)(3,8), 10, GF(3) );;
gap> tr:= NullMat( 10,10,GF(3) );;
gap> tr{[1, 2]}{[1, 2]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[3, 4]}{[3, 4]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[7, 8]}{[7, 8]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[9,10]}{[9,10]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[5, 6]}{[5, 6]}:= [[1,0],[0,1]]*Z(3)^0;;
gap> tr2:= IdentityMat( 10,GF(3) );;
gap> tr2{[1,3]}{[1,3]}:= [[-1,1],[1,1]]*Z(3)^0;;
gap> tr2{[7,9]}{[7,9]}:= [[-1,1],[1,1]]*Z(3)^0;;
gap> T2:= tr2 * tr * pi;;
gap> D:= T1^-1 * T2;;
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( omega, tblow );
true

##  doc2/probgen.xml (10369-10380)
gap> orbs:= OrbitsDomain( omega, NormedRowVectors( GF(3)^10 ), OnLines );;
gap> List( orbs, Length );
[ 9882, 9882, 9760 ]
gap> permgrp:= Action( omega, orbs[3], OnLines );;
gap> M:= SubgroupNC( permgrp,
>            List( tblow, x -> Permutation( x, orbs[3], OnLines ) ) );;
gap> ccl:= ClassesOfPrimeOrder( M, PrimeDivisors( Size( M ) ),
>                               TrivialSubgroup( M ) );;
gap> UpperBoundFixedPointRatios( permgrp, [ ccl ], false );
[ 1/1066, true ]

##  doc2/probgen.xml (10395-10397)
gap> CleanWorkspace();

##  doc2/probgen.xml (10445-10462)
gap> o:= SO(-1,14,2);;
gap> g:= SU(7,2);;
gap> b:= Basis( GF(4) );;
gap> blow:= List( GeneratorsOfGroup( g ), x -> BlownUpMat( b, x ) );;
gap> form:= NullMat( 14, 14, GF(2) );;
gap> for i in [ 1 .. 14 ] do form[i][ 15-i ]:= Z(2); od;
gap> ForAll( blow, x -> x * form * TransposedMat( x ) = form );
true
gap> pi:= PermutationMat( (1,13)(3,11)(5,9), 14, GF(2) );;
gap> pi * form * TransposedMat( pi ) = InvariantBilinearForm( o ).matrix;
true
gap> pi2:= PermutationMat( (7,3)(8,4), 14, GF(2) );;
gap> D:= pi2 * pi;;
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( o, tblow );
true

##  doc2/probgen.xml (10471-10479)
gap> omega:= DerivedSubgroup( o );;
gap> IsSubset( omega, tblow );
true
gap> z:= Z(4) * One( g );;
gap> tz:= D * BlownUpMat( b, z ) * D^-1;;
gap> tz in omega;
true

##  doc2/probgen.xml (10491-10509)
gap> orbs:= OrbitsDomain( omega, NormedRowVectors( GF(2)^14 ), OnLines );;
gap> List( orbs, Length );
[ 8127, 8256 ]
gap> omega:= Action( omega, orbs[1], OnLines );;
gap> gens:= List( GeneratorsOfGroup( g ),
>             x -> Permutation( D * BlownUpMat( b, x ) * D^-1, orbs[1] ) );;
gap> g:= Group( gens );;
gap> ccl:= ClassesOfPrimeOrder( g, PrimeDivisors( Size( g ) ),
>                               TrivialSubgroup( g ) );;
gap> tz:= Permutation( tz, orbs[1] );;
gap> primereps:= List( ccl, Representative );;
gap> Add( primereps, () );
gap> reps:= Concatenation( List( primereps,
>               x -> List( [ 0 .. 2 ], i -> x * tz^i ) ) );;
gap> primereps:= Filtered( reps, x -> IsPrimeInt( Order( x ) ) );;
gap> Length( primereps );
48

##  doc2/probgen.xml (10519-10524)
gap> M:= ClosureGroup( g, tz );;
gap> bccl:= List( primereps, x -> ConjugacyClass( M, x ) );;
gap> UpperBoundFixedPointRatios( omega, [ bccl ], false );
[ 1/2015, true ]

##  doc2/probgen.xml (10540-10542)
gap> CleanWorkspace();

##  doc2/probgen.xml (10605-10649)
gap> so:= SO(+1,12,3);;
gap> Display( InvariantBilinearForm( so ).matrix );
 . 1 . . . . . . . . . .
 1 . . . . . . . . . . .
 . . 1 . . . . . . . . .
 . . . 2 . . . . . . . .
 . . . . 2 . . . . . . .
 . . . . . 2 . . . . . .
 . . . . . . 2 . . . . .
 . . . . . . . 2 . . . .
 . . . . . . . . 2 . . .
 . . . . . . . . . 2 . .
 . . . . . . . . . . 2 .
 . . . . . . . . . . . 2
gap> g:= GO(+1,6,9);;
gap> Z(9)^2 = Z(3)^0 + Z(9);
true
gap> b:= Basis( GF(9), [ Z(3)^0, Z(9) ] );
Basis( GF(3^2), [ Z(3)^0, Z(3^2) ] )
gap> blow:= List( GeneratorsOfGroup( g ), x -> BlownUpMat( b, x ) );;
gap> m:= BlownUpMat( b, InvariantBilinearForm( g ).matrix );;
gap> Display( m );
 . . 1 . . . . . . . . .
 . . . 1 . . . . . . . .
 1 . . . . . . . . . . .
 . 1 . . . . . . . . . .
 . . . . 2 . . . . . . .
 . . . . . 2 . . . . . .
 . . . . . . 2 . . . . .
 . . . . . . . 2 . . . .
 . . . . . . . . 2 . . .
 . . . . . . . . . 2 . .
 . . . . . . . . . . 2 .
 . . . . . . . . . . . 2
gap> pi:= PermutationMat( (2,3), 12, GF(3) );;
gap> tr:= IdentityMat( 12, GF(3) );;
gap> tr{[3,4]}{[3,4]}:= [[1,-1],[1,1]]*Z(3)^0;;
gap> D:= tr * pi;;
gap> D * m * TransposedMat( D ) = InvariantBilinearForm( so ).matrix;
true
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( so, tblow );
true

##  doc2/probgen.xml (10669-10675)
gap> orbs:= OrbitsDomain( so, NormedRowVectors( GF(3)^12 ), OnLines );;
gap> List( orbs, Length );
[ 88452, 88452, 88816 ]
gap> act:= Action( so, orbs[1], OnLines );;
gap> SetSize( act, Size( so ) / 2 );

##  doc2/probgen.xml (10698-10704)
gap> u:= SubgroupNC( act,
>            List( tblow, x -> Permutation( x, orbs[1], OnLines ) ) );;
gap> n:= Normalizer( act, u );;
gap> Size( n ) / Size( u );
2

##  doc2/probgen.xml (10724-10744)
gap> norbs:= OrbitsDomain( n, MovedPoints( n ) );;
gap> List( norbs, Length );
[ 58968, 29484 ]
gap> hom:= ActionHomomorphism( n, norbs[2] );;
gap> nact:= Image( hom );;
gap> Size( nact ) = Size( n );
true
gap> ccl:= ClassesOfPrimeOrder( nact, PrimeDivisors( Size( nact ) ),
>                               TrivialSubgroup( nact ) );;
gap> Length( ccl );
26
gap> preim:= List( ccl,
>        x -> PreImagesRepresentative( hom, Representative( x ) ) );;
gap> pccl:= List( preim, x -> ConjugacyClass( n, x ) );;
gap> for i in [ 1 .. Length( pccl ) ] do
>      SetSize( pccl[i], Size( ccl[i] ) );
>    od;
gap> UpperBoundFixedPointRatios( act, [ pccl ], false );
[ 2/88209, true ]

##  doc2/probgen.xml (10806-10836)
gap> sp:= SP(4,8);;
gap> Display( InvariantBilinearForm( sp ).matrix );
 . . . 1
 . . 1 .
 . 1 . .
 1 . . .
gap> z:= Z(64);;
gap> f:= AsField( GF(8), GF(64) );;
gap> repeat
>      b:= Basis( f, [ z, z^8 ] );
>      z:= z * Z(64);
> until b <> fail;
gap> sub:= SP(2,64);;
gap> Display( InvariantBilinearForm( sub ).matrix );
 . 1
 1 .
gap> ext:= Group( List( GeneratorsOfGroup( sub ),
>                       x -> BlownUpMat( b, x ) ) );;
gap> tr:= PermutationMat( (3,4), 4, GF(2) );;
gap> conj:= ConjugateGroup( ext, tr );;
gap> IsSubset( sp, conj );
true
gap> inv:= [[0,1,0,0],[1,0,0,0],[0,0,0,1],[0,0,1,0]] * Z(2);;
gap> inv in sp;
true
gap> inv in conj;
false
gap> Length( NullspaceMat( inv - inv^0 ) );
2

##  doc2/probgen.xml (10845-10852)
gap> so:= SO(-1,4,8);;
gap> der:= DerivedSubgroup( so );;
gap> x:= First( GeneratorsOfGroup( so ), x -> not x in der );;
gap> x:= x^( Order(x)/2 );;
gap> Length( NullspaceMat( x - x^0 ) );
3

##  doc2/probgen.xml (10881-10901)
gap> CharacterTable( "L2(64).2" );
fail
gap> t:= CharacterTable( "S4(8)" );;
gap> degree:= Size( t ) / ( 2 * Size( SL(2,64) ) );;
gap> pi:= PermChars( t, rec( torso:= [ degree ] ) );
[ Character( CharacterTable( "S4(8)" ),
  [ 2016, 0, 256, 32, 0, 36, 0, 8, 1, 0, 4, 0, 0, 0, 28, 28, 28, 0, 
      0, 0, 0, 0, 0, 36, 36, 36, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 
      4, 4, 4, 0, 0, 0, 4, 4, 4, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1 ] ), Character( CharacterTable( "S4(8)" ),
  [ 2016, 256, 0, 32, 36, 0, 0, 8, 1, 4, 0, 28, 28, 28, 0, 0, 0, 0, 
      0, 0, 36, 36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 4, 4, 4, 
      0, 0, 0, 4, 4, 4, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 
      1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1 ] ) ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( pi, x -> x[ spos ] );
[ 1, 1 ]

##  doc2/probgen.xml (10909-10912)
gap> Maximum( ApproxP( pi, spos ) );
8/63

##  doc2/probgen.xml (10920-10922)
gap> CleanWorkspace();

##  doc2/probgen.xml (10998-11002)
gap> t:= CharacterTable( "S6(2)" );;
gap> ProbGenInfoSimple( t );
[ "S6(2)", 4/7, 1, [ "9A" ], [ 4 ] ]

##  doc2/probgen.xml (11011-11021)
gap> prim:= PrimitivePermutationCharacters( t );;
gap> ord:= OrdersClassRepresentatives( t );;
gap> spos:= Position( ord, 9 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
[ 1, 8 ]
gap> Maxes( t ){ filt };
[ "U4(2).2", "L2(8).3" ]
gap> List( prim{ filt }, x -> x[ spos ] );
[ 1, 3 ]

##  doc2/probgen.xml (11035-11047)
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos9:= Position( ord, 9 );;
gap> approx9:= ApproxP( prim, spos9 );;
gap> filt9:= PositionsProperty( approx9, x -> x >= 1/3 );
[ 2, 6 ]
gap> AtlasClassNames( t ){ filt9 };
[ "2A", "3A" ]
gap> approx9{ filt9 };
[ 4/7, 5/14 ]
gap> List( Filtered( prim, x -> x[ spos9 ] <> 0 ), x -> x{ filt9 } );
[ [ 16, 10 ], [ 0, 0 ] ]

##  doc2/probgen.xml (11059-11070)
gap> spos15:= Position( ord, 15 );;
gap> approx15:= ApproxP( prim, spos15 );;
gap> filt15:= PositionsProperty( approx15, x -> x >= 1/3 );
[ 2, 3 ]
gap> PositionsProperty( ApproxP( prim{ [ 2 ] }, spos15 ), x -> x >= 1/3 );
[ 2, 3 ]
gap> AtlasClassNames( t ){ filt15 };
[ "2A", "2B" ]
gap> approx15{ filt15 };
[ 46/63, 8/21 ]

##  doc2/probgen.xml (11083-11090)
gap> transvection:= function( d )
>     local mat;
>     mat:= IdentityMat( d, Z(2) );
>     mat{ [ 1, d ] }{ [ 1, d ] }:= [ [ 0, 1 ], [ 1, 0 ] ] * Z(2);
>     return mat;
> end;;

##  doc2/probgen.xml (11101-11125)
gap> PositionsProperty( SizesConjugacyClasses( t ), x -> x in [ 63, 315 ] );
[ 2, 3 ]
gap> d:= 6;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> g:= Image( hom, matgrp );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s15:= Random( g );
>    until Order( s15 ) = 15;
gap> 2A:= Image( hom, transvection( d ) );;
gap> Size( ConjugacyClass( g, 2A ) );
63
gap> IsTransitive( g, MovedPoints( g ) );
true
gap> RatioOfNongenerationTransPermGroup( g, 2A, s15 );
11/21
gap> repeat 12C:= Random( g );
>    until Order( 12C ) = 12 and Size( Centralizer( g, 12C ) ) = 12;
gap> 2B:= 12C^6;;
gap> Size( ConjugacyClass( g, 2B ) );
315
gap> RatioOfNongenerationTransPermGroup( g, 2B, s15 );
8/21

##  doc2/probgen.xml (11137-11146)
gap> ccl:= ConjugacyClasses( g );;
gap> reps:= List( ccl, Representative );;
gap> nongen2A:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 2A, x ) );;
gap> min:= Minimum( nongen2A );
11/21
gap> Number( nongen2A, x -> x = min );
1

##  doc2/probgen.xml (11157-11168)
gap> nongen2B:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 2B, x ) );;
gap> 3A:= s15^5;;
gap> nongen3A:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 3A, x ) );;
gap> bad:= List( [ 1 .. NrConjugacyClasses( t ) ],
>                i -> Number( [ nongen2A, nongen2B, nongen3A ],
>                             x -> x[i] > 1/3 ) );;
gap> Minimum( bad );
2

##  doc2/probgen.xml (11177-11180)
gap> PositionsProperty( approx9, x -> x + approx9[2] >= 1 );
[ 2 ]

##  doc2/probgen.xml (11189-11194)
gap> repeat s9:= Random( g );
>    until Order( s9 ) = 9;
gap> RandomCheckUniformSpread( g, [ 2A, 2A ], s9, 20 );
true

##  doc2/probgen.xml (11249-11260)
gap> t:= CharacterTable( "S8(2)" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "O8-(2).2" ), t );;
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "S4(4).2" ), t );;
gap> pi3:= [ TrivialCharacter( CharacterTable( "L2(17)" ) )^t ];;
gap> prim:= Concatenation( pi1, pi2, pi3 );;
gap> Length( prim );
3
gap> spos:= Position( OrdersClassRepresentatives( t ), 17 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 1 ]

##  doc2/probgen.xml (11272-11280)
gap> approx:= ApproxP( prim, spos );;
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]
gap> Number( prim, pi -> pi[2] <> 0 and pi[ spos ] <> 0 );
1
gap> approx[2];
8/15

##  doc2/probgen.xml (11289-11292)
gap> PositionsProperty( approx, x -> x + approx[2] >= 1 );
[ 2 ]

##  doc2/probgen.xml (11301-11314)
gap> d:= 8;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> x:= Image( hom, transvection( d ) );;
gap> g:= Image( hom, matgrp );;
gap> C:= ConjugacyClass( g, x );;  Size( C );
255
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 17;
gap> RandomCheckUniformSpread( g, [ x, x ], s, 20 );
true

##  doc2/probgen.xml (11360-11368)
gap> t:= CharacterTable( "S10(2)" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "O10-(2).2" ), t );;
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "L2(32).5" ), t );;
gap> prim:= Concatenation( pi1, pi2 );;  Length( prim );
2
gap> spos:= Position( OrdersClassRepresentatives( t ), 33 );;
gap> approx:= ApproxP( prim, spos );;

##  doc2/probgen.xml (11380-11387)
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]
gap> Number( prim, pi -> pi[2] <> 0 and pi[ spos ] <> 0 );
1
gap> approx[2];
16/31

##  doc2/probgen.xml (11398-11411)
gap> d:= 10;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> x:= Image( hom, transvection( d ) );;
gap> g:= Image( hom, matgrp );;
gap> C:= ConjugacyClass( g, x );;  Size( C );
1023
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 33;
gap> RandomCheckUniformSpread( g, [ x, x ], s, 20 );
true

##  doc2/probgen.xml (11679-11683)
gap> t:= CharacterTable( "U4(2)" );;
gap> ProbGenInfoSimple( t );
[ "U4(2)", 21/40, 1, [ "12A" ], [ 2 ] ]

##  doc2/probgen.xml (11695-11709)
gap> OrdersClassRepresentatives( t );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "U4(2)" ),
  [ 27, 3, 7, 0, 0, 9, 0, 3, 1, 2, 0, 0, 3, 3, 0, 1, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U4(2)" ),
  [ 36, 12, 8, 0, 0, 6, 3, 0, 2, 1, 0, 0, 0, 0, 3, 2, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U4(2)" ),
  [ 40, 8, 0, 13, 13, 4, 4, 4, 0, 0, 5, 5, 2, 2, 2, 0, 1, 1, 1, 1 ] ),
  Character( CharacterTable( "U4(2)" ),
  [ 40, 16, 4, 4, 4, 1, 7, 0, 2, 0, 4, 4, 1, 1, 1, 1, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "U4(2)" ),
  [ 45, 13, 5, 9, 9, 6, 3, 1, 1, 0, 1, 1, 4, 4, 1, 2, 0, 0, 1, 1 ] ) ]

##  doc2/probgen.xml (11719-11725)
gap> g:= SU(4,2);;
gap> orbs:= OrbitsDomain( g, NormedRowVectors( GF(4)^4 ), OnLines );;
gap> List( orbs, Length );
[ 45, 40 ]
gap> g:= Action( g, orbs[2], OnLines );;

##  doc2/probgen.xml (11738-11753)
gap> spos:= Position( OrdersClassRepresentatives( t ), 9 );
17
gap> approx:= ApproxP( prim, spos );
[ 0, 3/5, 1/10, 17/40, 17/40, 1/8, 11/40, 1/10, 1/20, 0, 9/40, 9/40, 
  3/40, 3/40, 3/40, 1/40, 1/20, 1/20, 1/40, 1/40 ]
gap> badpos:= PositionsProperty( approx, x -> x >= 2/5 );
[ 2, 4, 5 ]
gap> PowerMap( t, 2 )[4];
5
gap> OrdersClassRepresentatives( t );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> SizesConjugacyClasses( t );
[ 1, 45, 270, 40, 40, 240, 480, 540, 3240, 5184, 360, 360, 720, 720, 
  1440, 2160, 2880, 2880, 2160, 2160 ]

##  doc2/probgen.xml (11762-11772)
gap> PowerMap( t, 3 )[ spos ];
4
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 9;
gap> Size( ConjugacyClass( g, s^3 ) );
40
gap> prop:= RatioOfNongenerationTransPermGroup( g, s^3, s );
13/40

##  doc2/probgen.xml (11780-11786)
gap> repeat x:= Random( g ); until Order( x ) = 12;
gap> Size( ConjugacyClass( g, x^6 ) );
45
gap> prop:= RatioOfNongenerationTransPermGroup( g, x^6, s );
2/5

##  doc2/probgen.xml (11796-11806)
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, x^6, r ) );
[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 5/9, 1, 1, 1, 1, 1, 1, 2/5, 2/5, 7/15, 
  7/15 ]
gap> Minimum( prop );
2/5

##  doc2/probgen.xml (11819-11835)
gap> approx[2]:= 2/5;;
gap> approx[4]:= 13/40;;
gap> primeord:= PositionsProperty( OrdersClassRepresentatives( t ),
>                                  IsPrimeInt );
[ 2, 3, 4, 5, 6, 7, 10 ]
gap> RemoveSet( primeord, 5 );
gap> primeord;
[ 2, 3, 4, 6, 7, 10 ]
gap> approx{ primeord };
[ 2/5, 1/10, 13/40, 1/8, 11/40, 0 ]
gap> AtlasClassNames( t ){ primeord };
[ "2A", "2B", "3A", "3C", "3D", "5A" ]
gap> triples:= Filtered( UnorderedTuples( primeord, 3 ),
>                  t -> Sum( approx{ t } ) >= 1 );
[ [ 2, 2, 2 ], [ 2, 2, 4 ], [ 2, 2, 7 ], [ 2, 4, 4 ], [ 2, 4, 7 ] ]

##  doc2/probgen.xml (11844-11860)
gap> repeat 6E:= Random( g );
>    until Order( 6E ) = 6 and Size( Centralizer( g, 6E ) ) = 18;
gap> 2A:= 6E^3;;
gap> 3A:= s^3;;
gap> 3D:= 6E^2;;
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 3A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3D, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2A, 3A, 3A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3D, 3A, 2A ], s, 50 );
true

##  doc2/probgen.xml (11869-11875)
gap> t:= CharacterTable( "U4(2)" );;
gap> t2:= CharacterTable( "U4(2).2" );;
gap> spos:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 9 );;
gap> ProbGenInfoAlmostSimple( t, t2, spos );
[ "U4(2).2", 7/20, [ "9AB" ], [ 2 ] ]

##  doc2/probgen.xml (12097-12101)
gap> t:= CharacterTable( "U4(3)" );;
gap> ProbGenInfoSimple( t );
[ "U4(3)", 53/135, 2, [ "7A" ], [ 7 ] ]

##  doc2/probgen.xml (12113-12120)
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 7 );
13
gap> List( Filtered( prim, x -> x[ spos ] <> 0 ), l -> l{ [ 1, spos ] } );
[ [ 162, 1 ], [ 162, 1 ], [ 540, 1 ], [ 1296, 1 ], [ 1296, 1 ], 
  [ 1296, 1 ], [ 1296, 1 ] ]

##  doc2/probgen.xml (12131-12137)
gap> matgrp:= DerivedSubgroup( SO( -1, 6, 3 ) );;
gap> orbs:= OrbitsDomain( matgrp, NormedRowVectors( GF(3)^6 ), OnLines );;
gap> List( orbs, Length );
[ 126, 126, 112 ]
gap> G:= Action( matgrp, orbs[3], OnLines );;

##  doc2/probgen.xml (12145-12161)
gap> approx:= ApproxP( prim, spos );
[ 0, 53/135, 1/10, 1/24, 1/24, 7/45, 4/45, 1/27, 1/36, 1/90, 1/216, 
  1/216, 7/405, 7/405, 1/270, 0, 0, 0, 0, 1/270 ]
gap> Filtered( approx, x -> x >= 43/135 );
[ 53/135 ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 7, 7, 8, 9, 9, 9, 9, 12 ]
gap> ResetGlobalRandomNumberGenerators();
gap> repeat g:= Random( G ); until Order(g) = 2;
gap> repeat s:= Random( G );
>    until Order(s) = 7;
gap> bad:= RatioOfNongenerationTransPermGroup( G, g, s );
43/135
gap> bad < 1/3;
true

##  doc2/probgen.xml (12181-12191)
gap> 4t:= CharacterTable( "4.U4(3)" );;
gap> Length( PossibleClassFusions( CharacterTable( "L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "2.L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "4_1.L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "4_2.L3(4)" ), 4t ) );
4

##  doc2/probgen.xml (12207-12213)
gap> 2t:= CharacterTable( "2.U4(3)" );;
gap> Length( PossibleClassFusions( CharacterTable( "2.A7" ), 2t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "A7" ), 4t ) );
0

##  doc2/probgen.xml (12227-12244)
gap> t2:= CharacterTable( "U4(3).2_2" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "U3(3).2" ), t2 );
[ Character( CharacterTable( "U4(3).2_2" ),
  [ 540, 12, 54, 0, 0, 9, 8, 0, 0, 6, 0, 0, 1, 2, 0, 0, 0, 2, 0, 24, 
      4, 0, 0, 0, 0, 0, 0, 3, 2, 0, 4, 0, 0, 0 ] ) ]
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "A7.2" ), t2 );
[ Character( CharacterTable( "U4(3).2_2" ),
  [ 1296, 48, 0, 27, 0, 9, 0, 4, 1, 0, 3, 0, 1, 0, 0, 0, 0, 0, 216, 
      24, 0, 4, 0, 0, 0, 9, 0, 3, 0, 1, 0, 1, 0, 0 ] ) ]
gap> prim:= Concatenation( pi1, pi2, pi2 );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 7 );;
gap> Maximum( ApproxP( prim, spos ){ outer } );
1/3

##  doc2/probgen.xml (12254-12277)
gap> matgrp:= SO( -1, 6, 3 );
SO(-1,6,3)
gap> orbs:= OrbitsDomain( matgrp, NormedRowVectors( GF(3)^6 ), OnLines );;
gap> List( orbs, Length );
[ 126, 126, 112 ]
gap> G:= Action( matgrp, orbs[3], OnLines );;
gap> repeat s:= Random( G );
>    until Order( s ) = 7;
gap> repeat
>      repeat 2B:= Random( G ); until Order( 2B ) mod 2 = 0;
>      2B:= 2B^( Order( 2B ) / 2 );
>      c:= Centralizer( G, 2B );
>    until Size( c ) = 12096;
gap> RatioOfNongenerationTransPermGroup( G, 2B, s );
13/27
gap> repeat
>      repeat 2C:= Random( G ); until Order( 2C ) mod 2 = 0;
>      2C:= 2C^( Order( 2C ) / 2 );
>      c:= Centralizer( G, 2C );
>    until Size( c ) = 1440;
gap> RatioOfNongenerationTransPermGroup( G, 2C, s );
0

##  doc2/probgen.xml (12326-12338)
gap> CharacterTable( "U6(3)" );
fail
gap> g:= SU(6,3);;
gap> orbs:= OrbitsDomain( g, NormedRowVectors( GF(9)^6 ), OnLines );;
gap> List( orbs, Length );
[ 22204, 44226 ]
gap> repeat x:= PseudoRandom( g ); until Order( x ) = 244;
gap> List( orbs, o -> Number( o, v -> OnLines( v, x ) = v ) );
[ 0, 1 ]
gap> g:= Action( g, orbs[2], OnLines );;
gap> M:= Stabilizer( g, 1 );;

##  doc2/probgen.xml (12351-12360)
gap> elms:= [];;
gap> for p in PrimeDivisors( Size( M ) ) do
>      syl:= SylowSubgroup( M, p );
>      Append( elms, Filtered( PcConjugacyClassReps( syl ),
>                              r -> Order( r ) = p ) );
>    od;
gap> 1 - Minimum( List( elms, NrMovedPoints ) ) / Length( orbs[2] );
353/3159

##  doc2/probgen.xml (12425-12447)
gap> CharacterTable( "U8(2)" );
fail
gap> g:= SU(8,2);;
gap> orbs:= OrbitsDomain( g, NormedRowVectors( GF(4)^8 ), OnLines );;
gap> List( orbs, Length );
[ 10965, 10880 ]
gap> repeat x:= PseudoRandom( g ); until Order( x ) = 129;
gap> List( orbs, o -> Number( o, v -> OnLines( v, x ) = v ) );
[ 0, 1 ]
gap> g:= Action( g, orbs[2], OnLines );;
gap> M:= Stabilizer( g, 1 );;
gap> elms:= [];;
gap> for p in PrimeDivisors( Size( M ) ) do
>      syl:= SylowSubgroup( M, p );
>      Append( elms, Filtered( PcConjugacyClassReps( syl ),
>                              r -> Order( r ) = p ) );
>    od;
gap> Length( elms );
611
gap> 1 - Minimum( List( elms, NrMovedPoints ) ) / Length( orbs[2] );
2753/10880

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "probgen.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
