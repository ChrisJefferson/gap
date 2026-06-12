# This file was created from probgen.xml, do not edit!
#############################################################################
##
#A  PositionsProperty( <list>, <prop> )
##
##  Let <list> be a dense list and <prop> be a unary function that returns
##  `true' or `false' when applied to the entries of <list>.
##  `PositionsProperty' returns the set of positions in <list> for which
##  `true' is returned.
##
if not IsBound( PositionsProperty ) then
     PositionsProperty:= function( list, prop )
       return Filtered( [ 1 .. Length( list ) ], i -> prop( list[i] ) );
     end;
   fi;


#############################################################################
##
#A  UnorderedTuplesNoSort( <list>, <k> )
##
##  Let <list> be a dense list and <k> be a nonnegative integer.
##  `UnorderedTuplesNoSort' returns a list of all unordered <k>-tuples with
##  repetitions of elements in <list>.
##  The only difference to the GAP library function `UnorderedTuples' is
##  that the entries in the result of `UnorderedTuplesNoSort' need not be
##  sorted.
##  This is advantageous when the comparison of elements in <list> is
##  expensive, e.~g., when these elements are conjugacy classes in a group.
##
BindGlobal( "UnorderedTuplesNoSort", function( list, k )
    return List( UnorderedTuples( [ 1 .. Length( list ) ], k ),
                 tuple -> list{ tuple } );
end );


#############################################################################
##
#F  TripleWithProperty( <threelists>, <prop> )
#F  QuadrupleWithProperty( <fourlists>, <prop> )
##
##  Let <threelists> be a list of three lists $l_1, l_2, l_3$,
##  and <prop> be a unary function that takes a triple $[ x_1, x_2, x_3 ]$
##  with $x_i \in l_i$ as its argument and returns either `true' or `false'.
##  `TripleWithProperty' returns a triple for which `prop' returns `true'
##  if such a triple exists, and `fail' otherwise.
##
##  Analogously, the first argument of `QuadrupleWithProperty' is a list
##  <fourlists> of four lists, and the second argument <prop> takes a
##  quadruple as its argument.
##
BindGlobal( "TripleWithProperty", function( threelists, prop )
    local i, j, k, test;
    for i in threelists[1] do
      for j in threelists[2] do
        for k in threelists[3] do
          test:= [ i, j, k ];
          if prop( test ) then
              return test;
          fi;
        od;
      od;
    od;
    return fail;
end );
BindGlobal( "QuadrupleWithProperty", function( fourlists, prop )
    local i, j, k, l, test;
    for i in fourlists[1] do
      for j in fourlists[2] do
        for k in fourlists[3] do
          for l in fourlists[4] do
            test:= [ i, j, k, l ];
            if prop( test ) then
              return test;
            fi;
          od;
        od;
      od;
    od;
    return fail;
end );


#############################################################################
##
#F  PrintFormattedArray( <array> )
##
##  Let <array> be a rectangular table.
##  `PrintFormattedArray' prints <array> such that each column is right
##  aligned.
##  The only difference to the GAP library function `PrintArray'
##  is that the latter prints all columns at the same width.
##
BindGlobal( "PrintFormattedArray", function( array )
     local colwidths, n, row;
     array:= List( array, row -> List( row, String ) );
     colwidths:= List( TransposedMat( array ),
                       col -> Maximum( List( col, Length ) ) );
     n:= Length( array[1] );
     for row in List( array, row -> List( [ 1 .. n ],
                  i -> String( row[i], colwidths[i] ) ) ) do
       Print( "  ", JoinStringsWithSeparator( row, " " ), "\n" );
     od;
end );


#############################################################################
##
#F  PossiblePermutationCharacters( <sub>, <tbl> )
##
##  For two ordinary character tables <sub> and <tbl>,
##  `PossiblePermutationCharacters' returns the set of all induced class
##  functions of the trivial character of <sub> to <tbl>,
##  w.r.t.~the possible class fusions from <sub> to <tbl>.
##
if not IsBound( PossiblePermutationCharacters ) then
     BindGlobal( "PossiblePermutationCharacters", function( sub, tbl )
       local fus, triv;
       fus:= PossibleClassFusions( sub, tbl );
       if fus = fail then
         return fail;
       fi;
       triv:= [ TrivialCharacter( sub ) ];
       return Set(
           List( fus, map -> Induced( sub, tbl, triv, map )[1] ) );
     end );
   fi;


#############################################################################
##
#A  PrimitivePermutationCharacters( <tbl> )
##
##  For an ordinary character table <tbl> for which either the value of one
##  of the attributes `Maxes' or `UnderlyingGroup' is stored or the table of
##  marks is contained in the GAP library of tables of marks,
##  `PrimitivePermutationCharacters' returns the list of all primitive
##  permutation characters of <tbl>.
##  Otherwise `fail' is returned.
##
##  We use 'InstallOtherMethod' not 'InstallMethod' because another test file
##  declares the same attribute and installs the same method.
##
DeclareAttribute( "PrimitivePermutationCharacters",
                     IsCharacterTable );
InstallOtherMethod( PrimitivePermutationCharacters,
    [ IsCharacterTable ],
    function( tbl )
    local maxes, i, fus, poss, tom, G;
    if HasMaxes( tbl ) then
      maxes:= List( Maxes( tbl ), CharacterTable );
      for i in [ 1 .. Length( maxes ) ] do
        fus:= GetFusionMap( maxes[i], tbl );
        if fus = fail then
          fus:= PossibleClassFusions( maxes[i], tbl );
          poss:= Set( fus,
            map -> InducedClassFunctionsByFusionMap(
                       maxes[i], tbl,
                       [ TrivialCharacter( maxes[i] ) ], map )[1] );
          if Length( poss ) = 1 then
            maxes[i]:= poss[1];
          else
            return fail;
          fi;
        else
          maxes[i]:= TrivialCharacter( maxes[i] )^tbl;
        fi;
      od;
      return maxes;
    elif HasFusionToTom( tbl ) then
      tom:= TableOfMarks( tbl );
      maxes:= MaximalSubgroupsTom( tom );
      return PermCharsTom( tbl, tom ){ maxes[1] };
    elif HasUnderlyingGroup( tbl ) then
      G:= UnderlyingGroup( tbl );
      return List( MaximalSubgroupClassReps( G ),
                   M -> TrivialCharacter( M )^tbl );
    fi;
    return fail;
end );


#############################################################################
##
#F  ApproxP( <primitives>, <spos> )
##
##  Let <primitives> be a list of primitive permutation characters of a group
##  $G$, say, and <spos> the position of the conjugacy class of the element
##  $s \in G$.
##  Assume that the elements in <primitives> have the form $1_M^G$,
##  for suitable maximal subgroups $M$ of $G$,
##  and let $\MM$ be the set of these groups $M$.
##  `ApproxP' returns the class function $\psi$ of $G$ that is defined by
##  $\psi(1) = 0$ and
##  \[
##     \psi(g) = \sum_{M \in \MM}
##                   \frac{1_M^G(s) \cdot 1_M^G(g)}{1_M^G(1)}
##  \]
##  otherwise.
##
##  If <primitives> contains all those primitive permutation characters
##  $1_M^G$ of $G$ (with multiplicity according to the number of conjugacy
##  classes of these maximal subgroups) that do not vanish at $s$,
##  and if all these $M$ are self-normalizing in $G$
##  --this holds for example if $G$ is a finite simple group--
##  then $\psi(g) = &total;( g, s )$ holds.
##
##  The latter is an upper bound for the proportion
##  $&prop;( g, s )$ of elements in the conjugacy class of $s$ that generate
##  together with $g$ a proper subgroup of $G$.
##
##  Note that if $&prop;( g, s )$ is less than $1/k$ for all
##  $g \in G^{\times}$ then $G$ has spread at least $k$.
##
BindGlobal( "ApproxP", function( primitives, spos )
    local sum;
    sum:= ShallowCopy( Sum( List( primitives,
                                  pi -> pi[ spos ] * pi / pi[1] ) ) );
    sum[1]:= 0;
    return sum;
end );


#############################################################################
##
#F  ProbGenInfoSimple( <tbl> )
##
##  Let <tbl> be the ordinary character table of a finite simple group $S$.
##  If the full list of primitive permutation characters of <tbl> cannot be
##  computed with `PrimitivePermutationCharacters' then `fail' is returned.
##  Otherwise `ProbGenInfoSimple' returns a list of length $5$, containing
##  the identifier of <tbl>,
##  the value $&total;(S)$,
##  the value $\sprtotal( S )$,
##  a list of {\ATLAS} names of the classes of elements $s$ for which
##  $&total;(S) = &total;( S, s )$ holds,
##  and the list of the corresponding cardinalities $|&M;(S,s)|$.
##
BindGlobal( "ProbGenInfoSimple", function( tbl )
    local prim, max, min, bound, s;
    prim:= PrimitivePermutationCharacters( tbl );
    if prim = fail then
      return fail;
    fi;
    max:= List( [ 1 .. NrConjugacyClasses( tbl ) ],
                i -> Maximum( ApproxP( prim, i ) ) );
    min:= Minimum( max );
    bound:= Inverse( min );
    if IsInt( bound ) then
      bound:= bound - 1;
    else
      bound:= Int( bound );
    fi;
    s:= PositionsProperty( max, x -> x = min );
    s:= List( Set( s, i -> ClassOrbit( tbl, i ) ), i -> i[1] );
    return [ Identifier( tbl ),
             min,
             bound,
             AtlasClassNames( tbl ){ s },
             Sum( List( prim, pi -> pi{ s } ) ) ];
end );


#############################################################################
##
#F  ProbGenInfoAlmostSimple( <tblS>, <tblG>, <sposS> )
##
##  Let <tblS> be the ordinary character table of a finite simple group $S$,
##  <tblG> be the character table of an automorphic extension $G$ of $S$
##  in which $S$ has prime index,
##  and <sposS> a list of class positions in <tblS>.
##
##  If the full list of primitive permutation characters of <tblG> cannot be
##  computed with `PrimitivePermutationCharacters' then `fail' is returned.
##  Otherwise `ProbGenInfoAlmostSimple' returns a list of length five,
##  containing
##  the identifier of <tblG>,
##  the maximum $m$ of $&total;^{\prime}( G, s )$,
##  for $s$ in the classes described by <sposS>,
##  a list of {\ATLAS} names (w.r.t. $G$) of the classes of elements $s$
##  for which this maximum is attained,
##  and the list of the corresponding cardinalities $|\M^{\prime}(G,s)|$.
##
BindGlobal( "ProbGenInfoAlmostSimple", function( tblS, tblG, sposS )
    local p, fus, inv, prim, sposG, outer, approx, l, max, min,
          s, cards, i, names;
    p:= Size( tblG ) / Size( tblS );
    if not IsPrimeInt( p )
       or Length( ClassPositionsOfNormalSubgroups( tblG ) ) <> 3 then
      return fail;
    fi;
    fus:= GetFusionMap( tblS, tblG );
    if fus = fail then
      return fail;
    fi;
    inv:= InverseMap( fus );
    prim:= PrimitivePermutationCharacters( tblG );
    if prim = fail then
      return fail;
    fi;
    sposG:= Set( fus{ sposS } );
    outer:= Difference( PositionsProperty(
                OrdersClassRepresentatives( tblG ), IsPrimeInt ), fus );
    approx:= List( sposG, i -> ApproxP( prim, i ){ outer } );
    if IsEmpty( outer ) then
      max:= List( approx, x -> 0 );
    else
      max:= List( approx, Maximum );
    fi;
    min:= Minimum( max);
    s:= sposG{ PositionsProperty( max, x -> x = min ) };
    cards:= List( prim, pi -> pi{ s } );
    for i in [ 1 .. Length( prim ) ] do
      # Omit the character that is induced from the simple group.
      if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
        cards[i]:= 0;
      fi;
    od;
    names:= AtlasClassNames( tblG ){ s };
    Perform( names, ConvertToStringRep );
    return [ Identifier( tblG ),
             min,
             names,
             Sum( cards ) ];
end );


#############################################################################
##
#F  SigmaFromMaxes( <tbl>, <sname>, <maxes>, <numpermchars> )
#F  SigmaFromMaxes( <tbl>, <sname>, <maxes>, <numpermchars>, <choice> )
##
##  Let <tbl> be the ordinary character table of a finite almost simple group
##  $G$ with socle $S$,
##  <sname> be the name of a class in <tbl>,
##  <maxes> be a list of character tables of all those maximal subgroups
##  of $G$ which contain elements $s$ in the class with the name <sname>.
##  Further let <numpermchars> be a list of integers such that the $i$-th
##  entry in <maxes> induces `<numpermchars>[i]' different permutation
##  characters.
##  (So if several classes of maximal subgroups in $G$ induce the same
##  permutation character then the table of this subgroup must occur with
##  this multiplicity in <maxes>, and the corresponding entries in
##  <numpermchars> must be $1$.
##  Conversely, if there are $n$ classes of isomorphic maximal subgroups
##  which induce $n$ different permutation characters then the table must
##  occur only once in <maxes>, and the corresponding multiplicity in
##  <numpermchars> must be $n$.)
##
##  The return value is `fail' if there is an entry `<maxes>[i]' such that
##  `PossiblePermutationCharacters' does not return a list of length
##  `<numpermchars>[i]' when its arguments are `<maxes>[i]' and <tbl>.
##
##  If the string `"outer"' is entered as the optional argument <choice> then
##  $G$ is assumed to be an automorphic extension of $S$,
##  with $[G:S]$ a prime,
##  and $&total;^{\prime}(G,s)$ is returned.
##
##  Otherwise `SigmaFromMaxes' returns $&total;(G,s)$.
##
BindGlobal( "SigmaFromMaxes", function( arg )
    local t, sname, maxes, numpermchars, prim, spos, outer;
    t:= arg[1];
    sname:= arg[2];
    maxes:= arg[3];
    numpermchars:= arg[4];
    prim:= List( maxes, s -> PossiblePermutationCharacters( s, t ) );
    spos:= Position( AtlasClassNames( t ), sname );
    if ForAny( [ 1 .. Length( maxes ) ],
               i -> Length( prim[i] ) <> numpermchars[i] ) then
      return fail;
    elif Length( arg ) = 5 and arg[5] = "outer" then
      outer:= Difference(
          PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
          ClassPositionsOfDerivedSubgroup( t ) );
      return Maximum( ApproxP( Concatenation( prim ), spos ){ outer } );
    else
      return Maximum( ApproxP( Concatenation( prim ), spos ) );
    fi;
end );


#############################################################################
##
#F  DisplayProbGenMaxesInfo( <tbl>, <snames> )
##
##  For a character table <tbl> with known `Maxes' value and a list <snames>
##  of class names in <tbl>,
##  `DisplayProbGenMaxesInfo' prints a description of the maximal subgroups
##  of <tbl> that contain an element $s$ in the classes with names in the
##  list <snames>.
##  Printed are the `Identifier' values of the tables of the maximal
##  subgroups and the number of conjugate subgroups in this class
##  that contain $s$.
##
BindGlobal( "DisplayProbGenMaxesInfo", function( tbl, snames )
    local mx, prim, i, spos, nonz, indent, j;
    if not HasMaxes( tbl ) then
      Print( Identifier( tbl ), ": fail\n" );
      return;
    fi;
    # Now we are sure that the order of the characters returned by
    # 'PrimitivePermutationCharacters' is compatible with 'Maxes( tbl )'.
    mx:= List( Maxes( tbl ), CharacterTable );
    prim:= List( PrimitivePermutationCharacters( tbl ), ShallowCopy );
    for i in [ 1 .. Length( prim ) ] do
      # Deal with the case that the subgroup is normal.
      if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
        prim[i]:= prim[i] / prim[i][1];
      fi;
    od;
    spos:= List( snames,
                 nam -> Position( AtlasClassNames( tbl ), nam ) );
    nonz:= List( spos, x -> PositionsProperty( prim, pi -> pi[x] <> 0 ) );
    for i in [ 1 .. Length( spos ) ] do
      Print( Identifier( tbl ), ", ", snames[i], ": " );
      indent:= ListWithIdenticalEntries(
          Length( Identifier( tbl ) ) + Length( snames[i] ) + 4, ' ' );
      if not IsEmpty( nonz[i] ) then
        Print( Identifier( mx[ nonz[i][1] ] ), "  (",
               prim[ nonz[i][1] ][ spos[i] ], ")\n" );
        for j in [ 2 .. Length( nonz[i] ) ] do
          Print( indent, Identifier( mx[ nonz[i][j] ] ), "  (",
               prim[ nonz[i][j] ][ spos[i] ], ")\n" );
        od;
      else
        Print( "\n" );
      fi;
    od;
end );


#############################################################################
##
#F  PcConjugacyClassReps( <G> )
##
##  Let <G> be a finite solvable group.
##  `PcConjugacyClassReps' returns a list of representatives of
##  the conjugacy classes of <G>,
##  which are computed using a polycyclic presentation for <G>.
##
BindGlobal( "PcConjugacyClassReps", function( G )
     local iso;
     iso:= IsomorphismPcGroup( G );
     return List( ConjugacyClasses( Image( iso ) ),
              c -> PreImagesRepresentative( iso, Representative( c ) ) );
end );


#############################################################################
##
#F  ClassesOfPrimeOrder( <G>, <primes>, <N> )
##
##  Let <G> be a finite group, <primes> be a list of primes,
##  and <N> be a normal subgroup of <G>.
##  `ClassesOfPrimeOrder' returns a list of those conjugacy classes of <G>
##  that are not contained in <N>
##  and whose elements' orders occur in <primes>.
##
##  For each prime $p$ in <primes>, first class representatives of order $p$
##  in a Sylow $p$ subgroup of <G> are computed,
##  then the representatives in <N> are discarded,
##  and then representatives w. r. t. conjugacy in <G> are computed.
##
##  (Note that this approach may be inappropriate if an elementary abelian
##  Sylow $p$ subgroup for a large prime $p$ occurs, and if the conjugacy
##  tests in <G> are expensive.)
##
BindGlobal( "ClassesOfPrimeOrder", function( G, primes, N )
     local ccl, p, syl, Greps, reps, r, cr;
     ccl:= [];
     for p in primes do
       syl:= SylowSubgroup( G, p );
       Greps:= [];
       reps:= Filtered( PcConjugacyClassReps( syl ),
                  r -> Order( r ) = p and not r in N );
       for r in reps do
         cr:= ConjugacyClass( G, r );
         if ForAll( Greps, c -> c <> cr ) then
           Add( Greps, cr );
         fi;
       od;
       Append( ccl, Greps );
     od;
     return ccl;
end );


#############################################################################
##
#F  IsGeneratorsOfTransPermGroup( <G>, <list> )
##
##  Let <G> be a finite group that acts *transitively* on its moved points,
##  and <list> a list of elements in <G>.
##
##  `IsGeneratorsOfTransPermGroup' returns `true' if the elements in <list>
##  generate <G>, and `false' otherwise.
##  The main point is that the return value `true' requires the group
##  generated by `list' to be transitive, and the check for transitivity
##  is much cheaper than the test whether this group is equal to `G'.
##
if not IsBound( IsGeneratorsOfTransPermGroup) then
     BindGlobal( "IsGeneratorsOfTransPermGroup", function( G, list )
       local S;
       if not IsTransitive( G ) then
         Error( "<G> must be transitive on its moved points" );
       fi;
       S:= SubgroupNC( G, list );
       return IsTransitive( S, MovedPoints( G ) ) and
              Size( S ) = Size( G );
     end );
   fi;


#############################################################################
##
#F  RatioOfNongenerationTransPermGroup( <G>, <g>, <s> )
##
##  Let <G> be a finite group that acts *transitively* on its moved points,
##  and <g> and <s> be two elements in <G>.
##
##  `RatioOfNongenerationTransPermGroup' returns the proportion
##  $&prop;(g,s)$.
##
BindGlobal( "RatioOfNongenerationTransPermGroup", function( G, g, s )
    local nongen, pair;
    if not IsTransitive( G ) then
      Error( "<G> must be transitive on its moved points" );
    fi;
    nongen:= 0;
    for pair in DoubleCosetRepsAndSizes( G, Centralizer( G, g ),
                    Centralizer( G, s ) ) do
      if not IsGeneratorsOfTransPermGroup( G, [ s, g^pair[1] ] ) then
        nongen:= nongen + pair[2];
      fi;
    od;
    return nongen / Size( G );
end );


#############################################################################
##
#F  DiagonalProductOfPermGroups( <groups> )
##
##  Let $G$ be a group, and let <groups> be a list
##  $[ G_1, G_2, \ldots, G_n ]$ of permutation groups such that $G_i$
##  describes the action of $G$ on a set $\Omega_i$, say.
##  Moreover, we require that for $1 \leq i, j \leq n$,
##  mapping the `GeneratorsOfGroup' list of $G_i$ to that of $G_j$
##  defines an isomorphism.
##
##  `DiagonalProductOfPermGroups' takes `groups' as its argument,
##  and returns the action of $G$ on the disjoint union of
##  $\Omega_1, \Omega_2, \ldots \Omega_n$.
##
BindGlobal( "DiagonalProductOfPermGroups", function( groups )
    local prodgens, deg, i, gens, D, pi;
    prodgens:= GeneratorsOfGroup( groups[1] );
    deg:= NrMovedPoints( prodgens );
    for i in [ 2 .. Length( groups ) ] do
      gens:= GeneratorsOfGroup( groups[i] );
      D:= MovedPoints( gens );
      pi:= MappingPermListList( D, [ deg+1 .. deg+Length( D ) ] );
      deg:= deg + Length( D );
      prodgens:= List( [ 1 .. Length( prodgens ) ],
                       i -> prodgens[i] * gens[i]^pi );
    od;
    return Group( prodgens );
end );


#############################################################################
##
#F  RepresentativesMaximallyCyclicSubgroups( <tbl> )
##
##  For an ordinary character table <tbl>,
##  `RepresentativesMaximallyCyclicSubgroups' returns a list of class
##  positions containing exactly one class of generators for each class of
##  maximally cyclic subgroups.
##
BindGlobal( "RepresentativesMaximallyCyclicSubgroups", function( tbl )
    local n, result, orders, p, pmap, i, j;
    # Initialize.
    n:= NrConjugacyClasses( tbl );
    result:= BlistList( [ 1 .. n ], [ 1 .. n ] );
    # Omit powers of smaller order.
    orders:= OrdersClassRepresentatives( tbl );
    for p in PrimeDivisors( Size( tbl ) ) do
      pmap:= PowerMap( tbl, p );
      for i in [ 1 .. n ] do
        if orders[ pmap[i] ] < orders[i] then
          result[ pmap[i] ]:= false;
        fi;
      od;
    od;
    # Omit Galois conjugates.
    for i in [ 1 .. n ] do
      if result[i] then
        for j in ClassOrbit( tbl, i ) do
          if i <> j then
            result[j]:= false;
          fi;
        od;
      fi;
    od;
    # Return the result.
    return ListBlist( [ 1 .. n ], result );
end );


#############################################################################
##
#F  ClassesPerhapsCorrespondingToTableColumns( <G>, <tbl>, <cols> )
##
##  For a group <G>, its ordinary character table <tbl>, and a list <cols>
##  of class positions in <tbl>,
##  `ClassesPerhapsCorrespondingToTableColumns' returns the sublist
##  of those conjugacy classes of `G' for which the corresponding column
##  in `tbl' can be contained in `cols',
##  according to element order and class length.
##
BindGlobal( "ClassesPerhapsCorrespondingToTableColumns",
   function( G, tbl, cols )
    local orders, classes, invariants;
    orders:= OrdersClassRepresentatives( tbl );
    classes:= SizesConjugacyClasses( tbl );
    invariants:= List( cols, i -> [ orders[i], classes[i] ] );
    return Filtered( ConjugacyClasses( G ),
        c -> [ Order( Representative( c ) ), Size(c) ] in invariants );
end );


#############################################################################
##
#F  UpperBoundFixedPointRatios( <G>, <maxesclasses>, <truetest> )
##
##  Let <G> be a finite group, and <maxesclasses> be a list
##  $[ l_1, l_2, ..., l_n ]$ such that each $l_i$ is a list of conjugacy
##  classes of maximal subgroups $M_i$ of <G>, such that all classes of
##  prime element order in $M_i$ are contained in $l_i$,
##  and such that the $M_i$ are all those maximal subgroups of <G>
##  (in particular, \emph{not} only conjugacy class representatives of
##  subgroups) that contain a fixed element $s \in G$.
##
##  `UpperBoundFixedPointRatios' returns a list $[ x, y ]$, where
##  \[
##     x = \max_{1 \not= p \mid |G|} \max_{g \in G \setminus Z(G), |g|=p}
##            \sum_{i=1}^n \sum_{h \in S(i,p,g)} |h^{M_i}| / |g^G|,
##  \]
##  and $S(i,p,g)$ is a set of representatives $h$ of all those classes in
##  $l_i$ that satisfy $|h| = p$ and $|C_G(h)| = |C_G(g)|$,
##  and in the case that $G$ is a permutation group additionally that
##  $h$ and $g$ move the same number of points.
##  Since $S(i,p,g) \supseteq g^G \cap M_i$ holds,
##  $x$ is an upper bound for $&total;(G,s)$.
##
##  The second entry is `true' if the first value is in fact equal to
##  $\max_{g \in G \setminus Z(G)} &fpr;(g,G/M}$, and `false' otherwise.
##
##  The third argument <truetest> must be `true' or `false',
##  where `true' means that the exact value of $&total;(G,s)$ is computed
##  not just an upper bound; this can be much more expensive.
##  (We try to reduce the number of conjugacy tests in this case,
##  the second half of the code is not completely straightforward.)
##
##  If $G$ is an automorphic extension of a simple group $S$,
##  with $[G:S] = p$ a prime, then `UpperBoundFixedPointRatios' can be used
##  to compute $&total;^{\prime}(G,s)$,
##  by choosing $M_i$ the maximal subgroups of $G$ containing $s$,
##  except $S$, such that $l_i$ contains only the classes of element order
##  $p$ in $M_i \setminus (M_i \cap S)$.
##
##  Note that in the case $n = 1$, we have $&total;(G,s) = &prop;(G,s)$,
##  so in this case the second entry `true' means that the first entry is
##  equal to $\max_{g \in G \setminus Z(G)} &fpr;(g,G/M_1}$.
##
BindGlobal( "UpperBoundFixedPointRatios",
   function( G, maxesclasses, truetest )
    local myIsConjugate, invs, info, c, r, o, inv, pos, sums, max, maxpos,
          maxlen, reps, split, i, found, j;
    myIsConjugate:= function( G, x, y )
      local movx, movy;
      movx:= MovedPoints( x );
      movy:= MovedPoints( y );
      if movx = movy then
        G:= Stabilizer( G, movx, OnSets );
      fi;
      return IsConjugate( G, x, y );
    end;
    invs:= [];
    info:= [];
    # First distribute the classes according to invariants.
    for c in Concatenation( maxesclasses ) do
      r:= Representative( c );
      o:= Order( r );
      # Take only prime order representatives.
      if IsPrimeInt( o ) then
        inv:= [ o, Size( Centralizer( G, r ) ) ];
        # Omit classes that are central in `G'.
        if inv[2] <> Size( G ) then
          if IsPerm( r ) then
            Add( inv, NrMovedPoints( r ) );
          fi;
          pos:= First( [ 1 .. Length( invs ) ], i -> inv = invs[i] );
          if pos = fail then
            # This class is not `G'-conjugate to any of the previous ones.
            Add( invs, inv );
            Add( info, [ [ r, Size( c ) * inv[2] ] ] );
          else
            # This class may be conjugate to an earlier one.
            Add( info[ pos ], [ r, Size( c ) * inv[2] ] );
          fi;
        fi;
      fi;
    od;
    if info = [] then
      return [ 0, true ];
    fi;
    repeat
      # Compute the contributions of the classes with the same invariants.
      sums:= List( info, x -> Sum( List( x, y -> y[2] ) ) );
      max:= Maximum( sums );
      maxpos:= Filtered( [ 1 .. Length( info ) ], i -> sums[i] = max );
      maxlen:= List( maxpos, i -> Length( info[i] ) );
      # Split the sets with the same invariants if necessary
      # and if we want to compute the exact value.
      if truetest and not 1 in maxlen then
        # Make one conjugacy test.
        pos:= Position( maxlen, Minimum( maxlen ) );
        reps:= info[ maxpos[ pos ] ];
        if myIsConjugate( G, reps[1][1], reps[2][1] ) then
          # Fuse the two classes.
          reps[1][2]:= reps[1][2] + reps[2][2];
          reps[2]:= reps[ Length( reps ) ];
          Unbind( reps[ Length( reps ) ] );
        else
          # Split the list. This may require additional conjugacy tests.
          Unbind( info[ maxpos[ pos ] ] );
          split:= [ reps[1], reps[2] ];
          for i in [ 3 .. Length( reps ) ] do
            found:= false;
            for j in split do
              if myIsConjugate( G, reps[i][1], j[1] ) then
                j[2]:= reps[i][2] + j[2];
                found:= true;
                break;
              fi;
            od;
            if not found then
              Add( split, reps[i] );
            fi;
          od;
          info:= Compacted( Concatenation( info,
                                           List( split, x -> [ x ] ) ) );
        fi;
      fi;
    until 1 in maxlen or not truetest;
    return [ max / Size( G ), 1 in maxlen ];
end );


#############################################################################
##
#F  OrbitRepresentativesProductOfClasses( <G>, <classreps> )
##
##  For a finite group <G> and a list
##  $<classreps> = [ g_1, g_2, \ldots, g_n ]$ of elements in <G>,
##  `OrbitRepresentativesProductOfClasses' returns a list of representatives
##  of <G>-orbits on the Cartesian product
##  $g_1^{<G>} \times g_2^{<G>} \times \cdots \times g_n^{<G>}$.
##
##  The idea behind this function is to choose $R(<G>, g_1) = \{ ( g_1 ) \}$
##  in the case $n = 1$,
##  and, for $n > 1$,
##  \[
##     R(<G>, g_1, g_2, \ldots, g_n) = \{ (h_1, h_2, \ldots, h_n);
##        (h_1, h_2, \ldots, h_{n-1}) \in R(<G>, g_1, g_2, \ldots, g_{n-1}),
##        k_n = g_n^d, \textrm{\ for\ } d \in D \} ,
##  \]
##  where $D$ is a set of representatives of double cosets
##  $C_{<G>}(g_n) \setminus <G> / \cap_{i=1}^{n-1} C_{<G>}(h_i)$.
##
BindGlobal( "OrbitRepresentativesProductOfClasses",
   function( G, classreps )
    local cents, n, orbreps;
    cents:= List( classreps, x -> Centralizer( G, x ) );
    n:= Length( classreps );
    orbreps:= function( reps, intersect, pos )
      if pos > n then
        return [ reps ];
      fi;
      return Concatenation( List(
          DoubleCosetRepsAndSizes( G, cents[ pos ], intersect ),
            r -> orbreps( Concatenation( reps, [ classreps[ pos ]^r[1] ] ),
                 Intersection( intersect, cents[ pos ]^r[1] ), pos+1 ) ) );
    end;
    return orbreps( [ classreps[1] ], cents[1], 2 );
end );


#############################################################################
##
#F  RandomCheckUniformSpread( <G>, <classreps>, <s>, <N> )
##
##  Let <G> be a finite permutation group that is transitive on its moved
##  points,
##  <classreps> be a list of elements in <G>,
##  <s> be an element in <G>,
##  and <N> be a positive integer.
##
##  `RandomCheckUniformSpread' computes representatives $X$ of <G>-orbits
##  on the Cartesian product of the conjugacy classes of <classreps>;
##  for each of them, up to <N> random conjugates $s^{\prime}$ of <s> are
##  checked whether $s^{\prime}$ generates <G> with each element in the
##  $n$-tuple of elements in $X$.
##  If such an element $s^{\prime}$ is found this way, for all $X$,
##  the function returns `true',
##  otherwise a representative $X$ is returned for which no good conjugate
##  of <s> is found.
##
BindGlobal( "RandomCheckUniformSpread", function( G, classreps, s, try )
    local elms, found, i, conj;
    if not IsTransitive( G, MovedPoints( G ) ) then
      Error( "<G> must be transitive on its moved points" );
    fi;
    # Compute orbit representatives of G on the direct product,
    # and try to find a good conjugate of s for each representative.
    for elms in OrbitRepresentativesProductOfClasses( G, classreps ) do
      found:= false;
      for i in [ 1 .. try ] do
        conj:= s^Random( G );
        if ForAll( elms,
              x -> IsGeneratorsOfTransPermGroup( G, [ x, conj ] ) ) then
          found:= true;
          break;
        fi;
      od;
      if not found then
        return elms;
      fi;
    od;
    return true;
end );


#############################################################################
##
#F  CommonGeneratorWithGivenElements( <G>, <classreps>, <tuple> )
##
##  Let <G> be a finite group,
##  and <classreps> and <tuple> be lists of elements in <G>.
##  `CommonGeneratorWithGivenElements' returns an element $g$ in the
##  <G>-conjugacy class of one of the elements in <classreps> with the
##  property that each element in <tuple> together with $g$ generates <G>,
##  if such an element $g$ exists.
##  Otherwise `fail' is returned.
##
BindGlobal( "CommonGeneratorWithGivenElements",
   function( G, classreps, tuple )
    local inter, rep, repcen, pair;
    if not IsTransitive( G, MovedPoints( G ) ) then
      Error( "<G> must be transitive on its moved points" );
    fi;
    inter:= Intersection( List( tuple, x -> Centralizer( G, x ) ) );
    for rep in classreps do
      repcen:= Centralizer( G, rep );
      for pair in DoubleCosetRepsAndSizes( G, repcen, inter ) do
        if ForAll( tuple,
           x -> IsGeneratorsOfTransPermGroup( G, [ x, rep^pair[1] ] ) ) then
          return rep;
        fi;
      od;
    od;
    return fail;
end );


#############################################################################
##
#F  RelativeSigmaL( <d>, <B> )
##
##  Let <d> be a positive integer and <B> a basis for a field extension
##  of degree $n$, say, over the field $F$ with $q$ elements.
##  `RelativeSigmaL' returns a group of $<d> n \times <d> n$ matrices
##  over $F$, which is the intersection of $&SL;(<d> n, q)$ and the split
##  extension of an extension field type subgroup isomorphic with
##  $&GL;(<d>, q^n)$ by the Frobenius automorphism that maps each matrix
##  entry to its $q$-th power.
##
##  (If $q$ is a prime then the return value is isomorphic with the
##  semilinear group $\SigmaL(<d>, q^n)$.)
##
RelativeSigmaL:= function( d, B )
    local n, F, q, glgens, diag, pi, frob, i;
    n:= Length( B );
    F:= LeftActingDomain( UnderlyingLeftModule( B ) );
    q:= Size( F );
    # Create the generating matrices inside the linear subgroup.
    glgens:= List( GeneratorsOfGroup( SL( d, q^n ) ),
                   m -> BlownUpMat( B, m ) );
    # Create the matrix of a diagonal part that maps to determinant 1.
    diag:= IdentityMat( d*n, F );
    diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n)^(q-1) ] ] );
    Add( glgens, diag );
    # Create the matrix that realizes the Frobenius action,
    # and adjust the determinant.
    pi:= List( B, b -> Coefficients( B, b^q ) );
    frob:= NullMat( d*n, d*n, F );
    for i in [ 0 .. d-1 ] do
      frob{ [ 1 .. n ] + i*n }{ [ 1 .. n ] + i*n }:= pi;
    od;
    diag:= IdentityMat( d*n, F );
    diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n) ] ] );
    diag:= diag^LogFFE( Inverse( Determinant( frob ) ), Determinant( diag ) );
    # Return the result.
    return Group( Concatenation( glgens, [ diag * frob ] ) );
end;;


#############################################################################
##
#F  ApproxPForSL( <d>, <q> )
##
##  For a positive integer <d> and a prime power <q>,
##  `ApproxPForSL' returns $[ &M;(G,s), &total;( G, s ) ]$,
##  where $G = &PSL;( <d>, <q> )$, $s \in G$ is the image of a Singer cycle
##  in $&SL;(d,q)$,
##  and $&M;(G,s)$ is the list of names of those maximal subgroups of $G$
##  that contain $s$.
##
ApproxPForSL:= function( d, q )
    local G, epi, PG, primes, maxes, names, ccl;
    # Check whether this is an admissible case (see [Be00]).
    if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
      return fail;
    fi;
    # Create the group SL(d,q), and the map to PSL(d,q).
    G:= SL( d, q );
    epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
    PG:= ImagesSource( epi );
    # Create the subgroups corresponding to the prime divisors of `d'.
    primes:= PrimeDivisors( d );
    maxes:= List( primes, p -> RelativeSigmaL( d/p,
                                 Basis( AsField( GF(q), GF(q^p) ) ) ) );
    names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
                                 String( q^p ), ").", String( p ) ) );
    if 2 < q then
      names:= List( names, name -> Concatenation( name, " cap G" ) );
    fi;
    # Compute the conjugacy classes of prime order elements in the maxes.
    # (In order to avoid computing all conjugacy classes of these subgroups,
    # we work in Sylow subgroups.)
    ccl:= List( List( maxes, x -> ImagesSet( epi, x ) ),
            M -> ClassesOfPrimeOrder( M, PrimeDivisors( Size( M ) ),
                                      TrivialSubgroup( M ) ) );
    return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
end;;


#############################################################################
##
#F  SymmetricBasis( <q>, <n> )
##
##  For a positive integer <n> and a prime power <q>,
##  `SymmetricBasis' returns a basis $B$ for the `GF(<q>)'-vector space
##  `GF(<q>^<n>)' with the property that $`BlownUpMat'( B, x )$
##  is symmetric for each element $x$ in `GF(<q>^<n>)'.
##
SymmetricBasis:= function( q, n )
    local vectors, B, issymmetric;
    if   q = 2 and n = 2 then
      vectors:= [ Z(2)^0, Z(2^2) ];
    elif q = 2 and n = 3 then
      vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
    elif q = 2 and n = 5 then
      vectors:= [ Z(2)^0, Z(2^5), Z(2^5)^4, Z(2^5)^25, Z(2^5)^26 ];
    elif q = 3 and n = 2 then
      vectors:= [ Z(3)^0, Z(3^2) ];
    elif q = 3 and n = 3 then
      vectors:= [ Z(3)^0, Z(3^3)^2, Z(3^3)^7 ];
    elif q = 4 and n = 2 then
      vectors:= [ Z(2)^0, Z(2^4)^3 ];
    elif q = 4 and n = 3 then
      vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
    elif q = 5 and n = 2 then
      vectors:= [ Z(5)^0, Z(5^2)^2 ];
    elif q = 5 and n = 3 then
      vectors:= [ Z(5)^0, Z(5^3)^9, Z(5^3)^27 ];
    else
      Error( "sorry, no basis for <q> and <n> stored" );
    fi;
    B:= Basis( AsField( GF(q), GF(q^n) ), vectors );
    # Check that the basis really has the required property.
    issymmetric:= M -> M = TransposedMat( M );
    if not ForAll( B, b -> issymmetric( BlownUpMat( B, [ [ b ] ] ) ) ) then
      Error( "wrong basis!" );
    fi;
    # Return the result.
    return B;
end;;


#############################################################################
##
#F  EmbeddedMatrix( <F>, <mat>, <func> )
##
##  For a field <F>, a matrix <mat> and a function <func> that takes a matrix
##  and returns a matrix of the same shape,
##  `EmbeddedMatrix' returns a block diagonal matrix over the field <F>
##  whose diagonal blocks are <mat> and `<func>( <mat> )'.
##
BindGlobal( "EmbeddedMatrix", function( F, mat, func )
  local d, result;
  d:= Length( mat );
  result:= NullMat( 2*d, 2*d, F );
  result{ [ 1 .. d ] }{ [ 1 .. d ] }:= mat;
  result{ [ d+1 .. 2*d ] }{ [ d+1 .. 2*d ] }:= func( mat );
  return result;
end );


#############################################################################
##
#F  ApproxPForOuterClassesInExtensionOfSLByGraphAut( <d>, <q> )
##
##  For a positive integer <d> and a prime power <q>,
##  `ApproxPForOuterClassesInExtensionOfSLByGraphAut' returns
##  $[ &M;(G,s), &total;^{\prime}( G, s ) ]$,
##  where $G$ is $&PSL;( <d>, <q> )$ extended by a graph automorphism,
##  $s \in G$ is the image of a Singer cycle in $&SL;(d,q)$,
##  and $&M;(G,s)$ is the list of names of those maximal subgroups of
##  $&PGL;( <d>, <q> )$ that contain $s$.
##
ApproxPForOuterClassesInExtensionOfSLByGraphAut:= function( d, q )
    local embedG, swap, G, orb, epi, PG, Gprime, primes, maxes, ccl, names;
    # Check whether this is an admissible case (see [Be00],
    # note that a graph automorphism exists only for `d > 2').
    if d = 2 or ( d = 3 and q = 4 ) then
      return fail;
    fi;
    # Provide a function that constructs a block diagonal matrix.
    embedG:= mat -> EmbeddedMatrix( GF( q ), mat,
                                    M -> TransposedMat( M^-1 ) );
    # Create the matrix that exchanges the two blocks.
    swap:= NullMat( 2*d, 2*d, GF(q) );
    swap{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );
    swap{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );
    # Create the group SL(d,q).2, and the map to the projective group.
    G:= ClosureGroupDefault( Group( List( GeneratorsOfGroup( SL( d, q ) ),
                                          embedG ) ),
                      swap );
    orb:= Orbit( G, One( G )[1], OnLines );
    epi:= ActionHomomorphism( G, orb, OnLines );
    PG:= ImagesSource( epi );
    Gprime:= DerivedSubgroup( PG );
    # Create the subgroups corresponding to the prime divisors of `d'.
    primes:= PrimeDivisors( d );
    maxes:= List( primes,
              p -> ClosureGroupDefault( Group( List( GeneratorsOfGroup(
                         RelativeSigmaL( d/p, SymmetricBasis( q, p ) ) ),
                         embedG ) ),
                     swap ) );
    # Compute conjugacy classes of outer involutions in the maxes.
    # (In order to avoid computing all conjugacy classes of these subgroups,
    # we work in the Sylow $2$ subgroups.)
    maxes:= List( maxes, M -> ImagesSet( epi, M ) );
    ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );
    names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
                                   String( q^p ), ").", String( p ) ) );
    return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
end;;


#############################################################################
##
#F  RelativeGammaL( <d>, <B> )
##
##  Let the arguments be as for `RelativeSigmaL'.
##  Then `RelativeGammaL' returns the extension field type subgroup of
##  $&GL;(d,q)$ that corresponds to the subgroup of $&SL;(d,q)$ returned by
##  `RelativeSigmaL'.
##
RelativeGammaL:= function( d, B )
    local n, F, q, diag;
    n:= Length( B );
    F:= LeftActingDomain( UnderlyingLeftModule( B ) );
    q:= Size( F );
    diag:= IdentityMat( d * n, F );
    diag{[ 1 .. n ]}{[ 1 .. n ]}:= BlownUpMat( B, [ [ Z(q^n) ] ] );
    return ClosureGroup( RelativeSigmaL( d, B ),  diag );
end;;


#############################################################################
##
#F  ApproxPForOuterClassesInGL( <d>, <q> )
##
##  Let the arguments be as for `ApproxPForSL'.
##  Then `ApproxPForOuterClassesInGL' returns the list of names of the
##  extension field type subgroups of $&GL;(<d>,<q>)$,
##  and $&total;^{\prime}(&GL;(<d>,<q>),s)$,
##  for a Singer cycle $s \in &SL;(d,q)$.
##
ApproxPForOuterClassesInGL:= function( d, q )
    local G, epi, PG, Gprime, primes, maxes, names;
    # Check whether this is an admissible case (see [Be00]).
    if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
      return fail;
    fi;
    # Create the group GL(d,q), and the map to PGL(d,q).
    G:= GL( d, q );
    epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
    PG:= ImagesSource( epi );
    Gprime:= ImagesSet( epi, SL( d, q ) );
    # Create the subgroups corresponding to the prime divisors of `d'.
    primes:= PrimeDivisors( d );
    maxes:= List( primes, p -> RelativeGammaL( d/p,
                                   Basis( AsField( GF(q), GF(q^p) ) ) ) );
    maxes:= List( maxes, M -> ImagesSet( epi, M ) );
    names:= List( primes, p -> Concatenation( "M(", String( d/p ), ",",
                                   String( q^p ), ")" ) );
    return [ names,
             UpperBoundFixedPointRatios( PG, List( maxes,
                 M -> ClassesOfPrimeOrder( M,
                          PrimeDivisors( Index( PG, Gprime ) ), Gprime ) ),
                 true )[1] ];
end;;


#############################################################################
##
#E

