# This file was created from xpl/multfree.xpl, do not edit!
#############################################################################
##
#W  multfree.g      database of mult.-free perm. characters     Thomas Breuer
#W                                                                  Klaus Lux
##
##  This file contains the following {\GAP} objects.
##
##  `MultFreeFromTomAndTable'
##      is a function that computes the multiplicity-free permutation
##      characters of a group from its table of marks.
##
##  `MultFree'
##      is a function that can be used for computing multiplicity-free
##      characters that are possible permutation characters,
##      relative to a given table of a subgroup.
##
##  These functions are {\GAP}~4 equivalents of those functions that had
##  been used to compute the characters listed in~\cite{BL96}.
##


#############################################################################
##
##  Print the banner if wanted.
##
if not GAPInfo.CommandLineOptions.q and not GAPInfo.CommandLineOptions.b then
  Print(
    "--------------------------------------------------------------------\n",
    "Loading Functions to compute Multiplicity-Free (Permutation)\n",
    "Characters;\n",
    "similar functions were used in the classification\n",
    "of the Multiplicity-Free Permutation Characters\n",
    "of the Sporadic Simple Groups and Their Automorphism Groups,\n",
    "by T. Breuer and K. Lux;\n",
    "call `MultFreeFromTomAndTable( <tbl> )' for computing the\n",
    "multiplicity-free permutation characters for the character table\n",
    "<tbl>,\n",
    "call `MultFree( <G>, <H> )' for computing those multiplicity-free\n",
    "possible permutation characters for the character table\n",
    "with identifier <G> that are induced from possible permutation\n",
    "characters of the subgroup whose character table has identifier <H>.\n",
    "--------------------------------------------------------------------\n"
  );
fi;


#############################################################################
##
#F  MultFreeFromTomAndTable( <tbl> )
##
##  For a character table <tbl> for which the table of marks is available in
##  the {\GAP} library,
##  `MultFreeFromTomAndTable' returns the list of all multiplicity-free
##  permutation characters of <tbl>.
##
BindGlobal( "MultFreeFromTomAndTable", function( tbl )
    local tom,     # the table of marks
          fus,     # fusion map from `t' to `tom'
          perms;   # perm. characters of `t'

    if HasFusionToTom( tbl ) or HasUnderlyingGroup( tbl ) then
      tom:= TableOfMarks( tbl );
    else
      Error( "no table of marks for character table <tbl> available" );
    fi;
    fus:= FusionCharTableTom( tbl, tom );
    if fus = fail then
      Error( "no unique fusion from <tbl> to the table of marks" );
    fi;
    perms:= PermCharsTom( tbl, tom );
    return Filtered( perms,
               x -> ForAll( Irr( tbl ),
                            y -> ScalarProduct( tbl, x, y ) <= 1 ) );
    end );


############################################################################
##
#F  TestPerm( <tbl>, <pi> )
##
##  `TestPerm' calls the {\GAP} library functions `TestPerm1', `TestPerm2',
##  and `TestPerm3'; the return value is `true' if the argument `<pi>' is
##  a possible permutation character of the character table `<tbl>',
##  and `false' otherwise.
##
BindGlobal( "TestPerm", function( tbl, pi )
    return     TestPerm1( tbl, pi ) = 0
           and TestPerm2( tbl, pi ) = 0
           and not IsEmpty( TestPerm3( tbl, [ pi ] ) );
    end );


#############################################################################
##
#F  CharactersInducingWithBoundedMultiplicity( <H>, <S>, <psi>, <scprS>,
#F      <scprpsi>, <k> )
##
##  Let <H> be a character table, <S> be a list of characters of <H>,
##  <psi> a character of <H>, <scprS> a matrix, the $i$-th entry being the
##  coefficients of the decomposition of the induced character of $<S>[i]$
##  to a supergroup $G$, say, of <H>, <scprpsi> the decomposition of <psi>
##  induced to $G$, and <k> a positive integer.
##
##  `CharactersInducingWithBoundedMultiplicity' returns the list
##  $C( <S>, <psi>, <k> )$;
##  this is the list of all those characters $<psi> + \vartheta$ of
##  multiplicity at most <k> such that all constituents of $\vartheta$ are
##  contained in the list <S>.
##
##  Let $G$ be a group and $H$ a subgroup of $G$.  For a set $S$ of
##  characters of $H$ and a character $\chi$ of $H$, define $C( S, \chi, k )$
##  to be the set of all those possible permutation characters $\pi$ of $H$
##  of the form $\pi = \chi + \sum_{\varphi \in S^{\prime}} \varphi$,
##  for a subset $S^{\prime}$ of $S$, with the property that $\pi^G$ has
##  multiplicity at most $k$.
##
##  Then the following holds.
##  \begin{items}
##  \item
##      We need to consider only elements in the set $Rat(H)$ of rational
##      irreducible characters of $H$ as constituents of $\pi$ since Galois
##      conjugate constituents in a permutation character have the same
##      multiplicity.
##
##  \item
##      If $\pi$ is a possible permutation character of $H$ such that $\pi^G$
##      has multiplicity at most $k$ then
##      $C( \emptyset, \pi, k ) = \{ \pi \}$,
##      otherwise $C( \emptyset, \pi, k ) = \emptyset$.
##
##  \item
##      Given a character $\psi$ of $H$ and $S \not= \emptyset$,
##      fix $\chi \in S$ and set
##      \[
##         S^{\prime}_i =
##              \{ \varphi \in S |
##                 (\varphi^G + i \cdot \chi^G, \vartheta) \leq k
##                 \forall \vartheta \in Irr(H) \} .
##      \]
##      Then $C( S, \psi, k ) = C( S \setminus \{ \chi \}, \psi, k )
##      \cup \bigcup_{i=1}^k C( S^{\prime}, \psi + i \cdot \chi, k )$.
##
##  \item
##      $C( Rat(H), 1_H, k )$ is the set of all possible permutation
##      characters $\pi$ of $H$
##      such that $\pi^G$ has multiplicity at most $k$.
##
##  \item
##      Each nontrivial irreducible constituent of each character in
##      $C( Rat(H), 1_H, k )$ is contained in the set
##      \[
##         S_0 = \{ \chi \in Rat(H) | \chi \not= 1_H,
##              \chi^G + 1_H^G \mbox{\ has multiplicity at most $k$\ } \} ,
##      \]
##      so $C( Rat(H), 1_H, k ) = C( S_0, 1_H, k )$.
##  \end{items}
##
##  (For the case $k = 1$, complex irreducible characters whose second
##  Frobenius-Schur indicator is $-1$ could be excluded from the list of
##  possible constituents.)
##
DeclareGlobalFunction( "CharactersInducingWithBoundedMultiplicity" );
InstallGlobalFunction( CharactersInducingWithBoundedMultiplicity,
    function( H, S, psi, scprS, scprpsi, k )
    local result,       # the list $S( .. )$
          chi,          # $\chi$
          scprchi,      # decomposition of $\chi^G$
          i,            # loop from `1' to `k'
          allowed,      # indices of possible constituents
          Sprime,       # $S^{\prime}_i$
          scprSprime;   # decomposition of characters in $S^{\prime}_i$,
                        # induced to $G$

    if IsEmpty( S ) then

      # Test whether `psi' is a possible permutation character.
      if TestPerm( H, psi ) then
        result:= [ psi ];
      else
        result:= [];
      fi;

    else

      # Fix a character $\chi$.
      chi     := S[1];
      scprchi := scprS[1];

      # Form the union.
      result:= CharactersInducingWithBoundedMultiplicity( H,
                   S{ [ 2 .. Length( S ) ] }, psi,
                   scprS{ [ 2 .. Length( S ) ] }, scprpsi, k );
      for i in [ 1 .. k ] do
        allowed    := Filtered( [ 2 .. Length( S ) ],
                          j -> Maximum( i * scprchi + scprS[j] ) <= k );
        Sprime     := S{ allowed };
        scprSprime := scprS{ allowed };

        Append( result, CharactersInducingWithBoundedMultiplicity( H,
                            Sprime, psi + i * chi,
                            scprSprime, scprpsi + i * scprchi, k ) );
      od;

    fi;

    return result;
    end );


#############################################################################
##
#F  MultAtMost( <G>, <H>, <k> )
##
##  Let <G> and <H> be character tables of groups $G$ and $H$, respectively,
##  such that $H$ is a subgroup of $G$ and the class fusion from <H> to <G>
##  is stored on <H>.
##  `MultAtMost' returns the list of all characters $\varphi^G$ of $G$
##  of multiplicity at most <k> such that $\varphi$ is a possible permutation
##  character of $H$.
##
BindGlobal( "MultAtMost", function( G, H, k )
    local triv,     # $1_H$
          permch,   # $(1_H)^G$
          scpr1H,   # decomposition of $(1_H)^G$
          rat,      # rational irreducible characters of $H$
          ind,      # induced rational irreducible characters
          mat,      # decomposition of `ind'
          allowed,  # indices of possible constituents
          S0,       # $S_0$
          scprS0,   # decomposition of characters in $S_0$,
                    # induced to $G$, with $Irr(G)$
          cand;     # list of multiplicity-free candidates, result

    # Compute $(1_H)^G$ and its decomposition into irreducibles of $G$.
    triv   := TrivialCharacter( H );
    permch := Induced( H, G, [ triv ] );
    scpr1H := MatScalarProducts( G, Irr( G ), permch )[1];

    # If $(1_H)^G$ has multiplicity larger than `k' then we are done.
    if Maximum( scpr1H ) > k then
      return [];
    fi;

    # Compute the set $S_0$ of all possible nontrivial
    # rational constituents of a candidate of multiplicity at most `k',
    # that is, all those rational irreducible characters of
    # $H$ that induce to $G$ with multiplicity at most `k'.
    rat:= RationalizedMat( Irr( H ) );
    ind:= Induced( H, G, rat );
    mat:= MatScalarProducts( G, Irr( G ), ind );
    allowed:= Filtered( [ 1.. Length( mat ) ],
                        x -> Maximum( mat[x] + scpr1H ) <= k );
    S0     := rat{ allowed };
    scprS0 := mat{ allowed };

    # Compute $C( S_0, 1_H, k )$.
    cand:= CharactersInducingWithBoundedMultiplicity( H,
               S0, triv, scprS0, scpr1H, k );

    # Induce the candidates to $G$, and return the sorted list.
    cand:= Induced( H, G, cand );
    Sort( cand );
    return cand;
    end );


############################################################################
##
#F  MultFree( <G>, <H> )
##
##  `MultFree' returns `MultAtMost( <G>, <H>, 1 )'.
##
BindGlobal( "MultFree", function( G, H )
    return MultAtMost( G, H, 1 );
    end );


############################################################################
##
#F  PossiblePermutationCharactersWithBoundedMultiplicity( <tbl>, <k> )
##
##  Let <tbl> be a character table with known `Maxes' value,
##  and <k> be a positive integer.
##  The function `PossiblePermutationCharactersWithBoundedMultiplicity'
##  returns a record with the following components.
##  \beginitems
##  `identifier' &
##      the `Identifier' value of <tbl>,
##
##  `maxnames' &
##      the list of names of the maximal subgroups of <tbl>,
##
##  `permcand' &
##      at the $i$-th position the list of those possible permutation
##      characters of <tbl> whose multiplicity is at most <k>
##      and which are induced from the $i$-th maximal subgroup of <tbl>,
##      and
##
##  `k' &
##      the given bound <k> for the multiplicity.
##  \enditems
##
BindGlobal( "PossiblePermutationCharactersWithBoundedMultiplicity",
    function( tbl, k )
    local permcand, # list of all mult. free perm. character candidates
          maxname,  # loop over tables of maximal subgroups
          max;      # one table of a maximal subgroup

    if not HasMaxes( tbl ) then
      return fail;
    fi;

    permcand:= [];

    # Loop over the tables of maximal subgroups.
    for maxname in Maxes( tbl ) do

      max:= CharacterTable( maxname );
      if max = fail or GetFusionMap( max, tbl ) = fail then

        Print( "#E  no fusion `", maxname, "' -> `", Identifier( tbl ),
               "' stored\n" );
        Add( permcand, Unknown() );

      else

        # Compute the possible perm. characters inducing through `max'.
        Add( permcand, MultAtMost( tbl, max, k ) );

      fi;
    od;

    # Return the result record.
    return rec( identifier := Identifier( tbl ),
                maxnames   := Maxes( tbl ),
                permcand   := permcand,
                k          := k );
    end );


#############################################################################
##
#E

