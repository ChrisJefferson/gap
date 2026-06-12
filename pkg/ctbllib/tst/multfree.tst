# This file was created from xpl/multfree.xpl, do not edit!
#############################################################################
##
#W  multfree.tst              GAP applications              Thomas Breuer
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `Test( "multfree.tst" );`.
##
gap> START_TEST( "multfree.tst" );

##
gap> LoadPackage( "ctbllib", false );
true
gap> if not IsBound( MultFreePermChars ) then
> ReadPackage( "ctbllib", "tst/multfree.dat" );
--------------------------------------------------------------------
Loading the Database of Multiplicity-Free Permutation Characters
of the Sporadic Simple Groups and Their Automorphism Groups,
by T. Breuer and K. Lux;
call `MultFreePermChars( <name> )' for accessing the data
for the group whose character table has identifier <name>.
--------------------------------------------------------------------
> fi;

##
gap> info:= MultFreePermChars( "M11" );
[ rec( ATLAS := "1a+10a", character := Character( CharacterTable( "M11" ),
      [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ), group := "$M_{11}$", rank := 2, 
      subgroup := "$A_6.2_3$" ), 
  rec( ATLAS := "1a+10a+11a", character := Character( CharacterTable( "M11" ),
     [ 22, 6, 4, 2, 2, 0, 0, 0, 0, 0 ] ), group := "$M_{11}$", rank := 3, 
      subgroup := "$A_6 \\leq A_6.2_3$" ), 
  rec( ATLAS := "1a+11a", character := Character( CharacterTable( "M11" ),
      [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ), group := "$M_{11}$", rank := 2, 
      subgroup := "$L_2(11)$" ), 
  rec( ATLAS := "1a+11a+16ab+45a+55a", 
      character := Character( CharacterTable( "M11" ),
      [ 144, 0, 0, 0, 4, 0, 0, 0, 1, 1 ] ), group := "$M_{11}$", rank := 6, 
      subgroup := "$11:5 \\leq L_2(11)$" ), 
  rec( ATLAS := "1a+10a+44a", character := Character( CharacterTable( "M11" ),
     [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ), group := "$M_{11}$", rank := 3, 
      subgroup := "$3^2:Q_8.2$" ), 
  rec( ATLAS := "1a+10a+44a+55a", 
      character := Character( CharacterTable( "M11" ),
      [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ), group := "$M_{11}$", rank := 4, 
      subgroup := "$3^2:8 \\leq 3^2:Q_8.2$" ), 
  rec( ATLAS := "1a+10a+11a+44a", 
      character := Character( CharacterTable( "M11" ),
      [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ), group := "$M_{11}$", rank := 4, 
      subgroup := "$A_5.2$" ) ]
gap> List( info, x -> x.rank );
[ 2, 3, 2, 6, 3, 4, 4 ]
gap> chars:= List( info, x -> x.character );;
gap> degrees:= List( chars, x -> x[1] );
[ 11, 22, 12, 144, 55, 110, 66 ]

##
gap> tbl:= CharacterTable( "M11" );
CharacterTable( "M11" )
gap> Display( tbl, rec( chars:= chars ) );
M11

     2   4  4  1  3  .  1  3  3   .   .
     3   2  1  2  .  .  1  .  .   .   .
     5   1  .  .  .  1  .  .  .   .   .
    11   1  .  .  .  .  .  .  .   1   1

        1a 2a 3a 4a 5a 6a 8a 8b 11a 11b
    2P  1a 1a 3a 2a 5a 3a 4a 4a 11b 11a
    3P  1a 2a 1a 4a 5a 2a 8a 8b 11a 11b
    5P  1a 2a 3a 4a 1a 6a 8b 8a 11a 11b
   11P  1a 2a 3a 4a 5a 6a 8a 8b  1a  1a

Y.1     11  3  2  3  1  .  1  1   .   .
Y.2     22  6  4  2  2  .  .  .   .   .
Y.3     12  4  3  .  2  1  .  .   1   1
Y.4    144  .  .  .  4  .  .  .   1   1
Y.5     55  7  1  3  .  1  1  1   .   .
Y.6    110  6  2  2  .  .  2  2   .   .
Y.7     66 10  3  2  1  1  .  .   .   .

##
gap> subgroups:= List( info, x -> x.subgroup );
[ "$A_6.2_3$", "$A_6 \\leq A_6.2_3$", "$L_2(11)$", "$11:5 \\leq L_2(11)$", 
  "$3^2:Q_8.2$", "$3^2:8 \\leq 3^2:Q_8.2$", "$A_5.2$" ]

##
gap> Print( subgroups[2], "\n" );
$A_6 \leq A_6.2_3$

##
gap> info:= MultFreePermChars( "M12.2" );;
gap> Length( info );
13
gap> info[1];
rec( ATLAS := "1a^{\\pm}+11ab", 
  character := Character( CharacterTable( "M12.2" ),
  [ 24, 0, 8, 6, 0, 4, 4, 0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  group := "$M_{12}.2$", rank := 3, subgroup := "$M_{11}$" )
gap> info[2];
rec( ATLAS := "1a^++11ab+55a^++66a^+", 
  character := Character( CharacterTable( "M12.2" ),
  [ 144, 0, 16, 9, 0, 0, 4, 0, 1, 0, 0, 1, 12, 4, 0, 0, 2, 2, 0, 1, 1 ] ), 
  group := "$M_{12}.2$", rank := 4, subgroup := "$L_2(11).2$" )

##
gap> m12:= CharacterTable( "M12" );;
gap> m122:= UnderlyingCharacterTable( info[1].character );;
gap> fus:= GetFusionMap( m12, m122 );
[ 1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 10, 11, 12, 12 ]
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( m122 ) ], fus );
[ 13, 14, 15, 16, 17, 18, 19, 20, 21 ]
gap> info[1].character{ outer };
[ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
gap> info[2].character{ outer };
[ 12, 4, 0, 0, 2, 2, 0, 1, 1 ]

##
gap> info[4];
rec( ATLAS := "1a^{\\pm}+11ab+54a^{\\pm}+66a^{\\pm}", 
  character := Character( CharacterTable( "M12.2" ),
  [ 264, 24, 24, 12, 0, 4, 4, 0, 0, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  group := "$M_{12}.2$", rank := 7, subgroup := "$A_6.2_2 \\leq A_6.2^2$" )
gap> info[9];
rec( 
  ATLAS := "1a^++16ab+45a^++54a^{\\pm}+55a^-+66a^{\\pm}+99a^-+144a^++176a^-", 
  character := Character( CharacterTable( "M12.2" ),
  [ 792, 32, 24, 0, 6, 0, 2, 2, 0, 0, 2, 0, 0, 0, 8, 0, 0, 0, 2, 0, 0 ] ), 
  group := "$M_{12}.2$", rank := 11, 
  subgroup := "$(2 \\times A_5).2 \\leq (2^2 \\times A_5).2$" )

##
gap> info:= MultFreePermChars( "all" );;
gap> Length( info );
267
gap> Length( Set( info ) );
262
gap> chars:= List( info, x -> x.character );;
gap> Length( Set( chars ) );
261

##
gap> distrib:= List( info, x -> Position( chars, x.character ) );;
gap> ambiguous:= Filtered( InverseMap( distrib ), IsList );
[ [ 12, 15 ], [ 40, 41 ], [ 83, 84 ], [ 88, 90 ], [ 132, 133 ], [ 202, 203 ] ]
gap> except:= Filtered( ambiguous, x -> info[ x[1] ] <> info[ x[2] ] );
[ [ 83, 84 ] ]
gap> ambiguous:= Difference( ambiguous, except );;
gap> info{ except[1] };
[ rec( ATLAS := "1a+22a+230a", 
      character := Character( CharacterTable( "M23" ),
      [ 253, 29, 10, 5, 3, 2, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0 ] ), 
      group := "$M_{23}$", rank := 3, subgroup := "$L_3(4).2_2$" ), 
  rec( ATLAS := "1a+22a+230a", 
      character := Character( CharacterTable( "M23" ),
      [ 253, 29, 10, 5, 3, 2, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0 ] ), 
      group := "$M_{23}$", rank := 3, subgroup := "$2^4:A_7$" ) ]

##
gap> ambiginfo:= info{ List( ambiguous, x -> x[1] ) };;
gap> for pair in ambiginfo do
>      Print( pair.group, ", ", pair.subgroup, ", ", pair.ATLAS, "\n" );
> od;
$M_{12}$, $A_6.2_1 \leq A_6.2^2$, 1a+11ab+54a+55a
$M_{22}$, $A_7$, 1a+21a+154a
$HS$, $U_3(5).2$, 1a+175a
$McL$, $M_{22}$, 1a+22a+252a+1750a
$Fi_{22}$, $O_7(3)$, 1a+429a+13650a

##
gap> Collected( List( info, x -> x.rank ) );
[ [ 2, 11 ], [ 3, 31 ], [ 4, 25 ], [ 5, 43 ], [ 6, 24 ], [ 7, 21 ], 
  [ 8, 26 ], [ 9, 16 ], [ 10, 17 ], [ 11, 9 ], [ 12, 9 ], [ 13, 8 ], 
  [ 14, 4 ], [ 15, 3 ], [ 16, 3 ], [ 17, 5 ], [ 18, 5 ], [ 19, 2 ], 
  [ 20, 2 ], [ 23, 1 ], [ 26, 1 ], [ 34, 1 ] ]
gap> max:= Filtered( info, x -> x.rank = 34 );;
gap> max[1].group;  max[1].subgroup;  max[1].character[1]; 
"$F_{3+}.2$"
"$O_{10}^-(2) \\leq O_{10}^-(2).2$"
100354720284

##
gap> nonsimple:= Filtered( info,
>        x -> not IsSimple( UnderlyingCharacterTable( x.character ) ) );;
gap> Length( nonsimple );
120
gap> ind:= Filtered( nonsimple, x -> ScalarProduct( x.character,
>              Irr( UnderlyingCharacterTable( x.character ) )[2] ) = 1 );;
gap> Length( ind );
48

##
gap> ind[1];
rec( ATLAS := "1a^{\\pm}+11ab", 
  character := Character( CharacterTable( "M12.2" ),
  [ 24, 0, 8, 6, 0, 4, 4, 0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  group := "$M_{12}.2$", rank := 3, subgroup := "$M_{11}$" )
gap> ForAll( ind, x -> x.ATLAS{ [ 1 .. 8 ] } = "1a^{\\pm}" );
true

##
#############################################################################
##
#F  MultFreeFromTomAndTable( <tbl> )
##
##  For a character table <tbl> for which the table of marks is available in
##  the {\GAP} library,
##  `MultFreeFromTomAndTable' returns the list of all multiplicity-free
##  permutation characters of <tbl>.
##
gap> BindGlobal( "MultFreeFromTomAndTable", function( tbl )
>     local tom,     # the table of marks
>           fus,     # fusion map from `t' to `tom'
>           perms;   # perm. characters of `t'
> 
>     if HasFusionToTom( tbl ) or HasUnderlyingGroup( tbl ) then
>       tom:= TableOfMarks( tbl );
>     else
>       Error( "no table of marks for character table <tbl> available" );
>     fi;
>     fus:= FusionCharTableTom( tbl, tom );
>     if fus = fail then
>       Error( "no unique fusion from <tbl> to the table of marks" );
>     fi;
>     perms:= PermCharsTom( tbl, tom );
>     return Filtered( perms,
>                x -> ForAll( Irr( tbl ),
>                             y -> ScalarProduct( tbl, x, y ) <= 1 ) );
>     end );

##
############################################################################
##
#F  TestPerm( <tbl>, <pi> )
##
##  `TestPerm' calls the {\GAP} library functions `TestPerm1', `TestPerm2',
##  and `TestPerm3'; the return value is `true' if the argument `<pi>' is
##  a possible permutation character of the character table `<tbl>',
##  and `false' otherwise.
##
gap> BindGlobal( "TestPerm", function( tbl, pi )
>     return     TestPerm1( tbl, pi ) = 0
>            and TestPerm2( tbl, pi ) = 0
>            and not IsEmpty( TestPerm3( tbl, [ pi ] ) );
>     end );

##
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
gap> DeclareGlobalFunction( "CharactersInducingWithBoundedMultiplicity" );
gap> InstallGlobalFunction( CharactersInducingWithBoundedMultiplicity,
>     function( H, S, psi, scprS, scprpsi, k )
>     local result,       # the list $S( .. )$
>           chi,          # $\chi$
>           scprchi,      # decomposition of $\chi^G$
>           i,            # loop from `1' to `k'
>           allowed,      # indices of possible constituents
>           Sprime,       # $S^{\prime}_i$
>           scprSprime;   # decomposition of characters in $S^{\prime}_i$,
>                         # induced to $G$
> 
>     if IsEmpty( S ) then
> 
>       # Test whether `psi' is a possible permutation character.
>       if TestPerm( H, psi ) then
>         result:= [ psi ];
>       else
>         result:= [];
>       fi;
> 
>     else
> 
>       # Fix a character $\chi$.
>       chi     := S[1];
>       scprchi := scprS[1];
> 
>       # Form the union.
>       result:= CharactersInducingWithBoundedMultiplicity( H,
>                    S{ [ 2 .. Length( S ) ] }, psi,
>                    scprS{ [ 2 .. Length( S ) ] }, scprpsi, k );
>       for i in [ 1 .. k ] do
>         allowed    := Filtered( [ 2 .. Length( S ) ],
>                           j -> Maximum( i * scprchi + scprS[j] ) <= k );
>         Sprime     := S{ allowed };
>         scprSprime := scprS{ allowed };
> 
>         Append( result, CharactersInducingWithBoundedMultiplicity( H,
>                             Sprime, psi + i * chi,
>                             scprSprime, scprpsi + i * scprchi, k ) );
>       od;
> 
>     fi;
> 
>     return result;
>     end );

##
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
gap> BindGlobal( "MultAtMost", function( G, H, k )
>     local triv,     # $1_H$
>           permch,   # $(1_H)^G$
>           scpr1H,   # decomposition of $(1_H)^G$
>           rat,      # rational irreducible characters of $H$
>           ind,      # induced rational irreducible characters
>           mat,      # decomposition of `ind'
>           allowed,  # indices of possible constituents
>           S0,       # $S_0$
>           scprS0,   # decomposition of characters in $S_0$,
>                     # induced to $G$, with $Irr(G)$
>           cand;     # list of multiplicity-free candidates, result
> 
>     # Compute $(1_H)^G$ and its decomposition into irreducibles of $G$.
>     triv   := TrivialCharacter( H );
>     permch := Induced( H, G, [ triv ] );
>     scpr1H := MatScalarProducts( G, Irr( G ), permch )[1];
> 
>     # If $(1_H)^G$ has multiplicity larger than `k' then we are done.
>     if Maximum( scpr1H ) > k then
>       return [];
>     fi;
> 
>     # Compute the set $S_0$ of all possible nontrivial
>     # rational constituents of a candidate of multiplicity at most `k',
>     # that is, all those rational irreducible characters of
>     # $H$ that induce to $G$ with multiplicity at most `k'.
>     rat:= RationalizedMat( Irr( H ) );
>     ind:= Induced( H, G, rat );
>     mat:= MatScalarProducts( G, Irr( G ), ind );
>     allowed:= Filtered( [ 1.. Length( mat ) ],
>                         x -> Maximum( mat[x] + scpr1H ) <= k );
>     S0     := rat{ allowed };
>     scprS0 := mat{ allowed };
> 
>     # Compute $C( S_0, 1_H, k )$.
>     cand:= CharactersInducingWithBoundedMultiplicity( H,
>                S0, triv, scprS0, scpr1H, k );
> 
>     # Induce the candidates to $G$, and return the sorted list.
>     cand:= Induced( H, G, cand );
>     Sort( cand );
>     return cand;
>     end );

##
############################################################################
##
#F  MultFree( <G>, <H> )
##
##  `MultFree' returns `MultAtMost( <G>, <H>, 1 )'.
##
gap> BindGlobal( "MultFree", function( G, H )
>     return MultAtMost( G, H, 1 );
>     end );

##
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
gap> BindGlobal( "PossiblePermutationCharactersWithBoundedMultiplicity",
>     function( tbl, k )
>     local permcand, # list of all mult. free perm. character candidates
>           maxname,  # loop over tables of maximal subgroups
>           max;      # one table of a maximal subgroup
> 
>     if not HasMaxes( tbl ) then
>       return fail;
>     fi;
> 
>     permcand:= [];
> 
>     # Loop over the tables of maximal subgroups.
>     for maxname in Maxes( tbl ) do
> 
>       max:= CharacterTable( maxname );
>       if max = fail or GetFusionMap( max, tbl ) = fail then
> 
>         Print( "#E  no fusion `", maxname, "' -> `", Identifier( tbl ),
>                "' stored\n" );
>         Add( permcand, Unknown() );
> 
>       else
> 
>         # Compute the possible perm. characters inducing through `max'.
>         Add( permcand, MultAtMost( tbl, max, k ) );
> 
>       fi;
>     od;
> 
>     # Return the result record.
>     return rec( identifier := Identifier( tbl ),
>                 maxnames   := Maxes( tbl ),
>                 permcand   := permcand,
>                 k          := k );
>     end );

##
gap> tbl:= CharacterTable( "A5" );;
gap> chars:= MultFreeFromTomAndTable( tbl );
[ Character( CharacterTable( "A5" ), [ 12, 0, 0, 2, 2 ] ), 
  Character( CharacterTable( "A5" ), [ 10, 2, 1, 0, 0 ] ), 
  Character( CharacterTable( "A5" ), [ 6, 2, 0, 1, 1 ] ), 
  Character( CharacterTable( "A5" ), [ 5, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A5" ), [ 1, 1, 1, 1, 1 ] ) ]

##
gap> PermCharInfo( tbl, chars ).ATLAS;
[ "1a+3ab+5a", "1a+4a+5a", "1a+5a", "1a+4a", "1a" ]

##
gap> tbl:= CharacterTable( "M12.2" );;
gap> chars:= MultFreeFromTomAndTable( tbl );;
gap> lib:= MultFreePermChars( "M12.2" );;
gap> Length( lib );  Length( chars );
13
15
gap> Difference( chars, List( lib, x -> x.character ) );
[ Character( CharacterTable( "M12.2" ),
  [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ), 
  Character( CharacterTable( "M12.2" ),
  [ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]

##
gap> tblsimple:= CharacterTable( "M12" );;
gap> PermCharInfoRelative( tblsimple, tbl, chars ).ATLAS;
[ "1a^++16ab+45a^-+54a^{\\pm}+55a^{\\pm}bc+66a^++99a^{\\pm}+144a^++176a^+", 
  "1a^++11ab+45a^-+54a^{\\pm}+55a^++66a^{\\pm}+99a^-+120a^{\\pm}+144a^{\\pm}",
  "1a^{\\pm}+11ab+45a^{\\pm}+54a^{\\pm}+55a^{\\pm}bc+99a^{\\pm}+120a^{\\pm}", 
  "1a^++16ab+45a^++54a^{\\pm}+55a^-+66a^{\\pm}+99a^-+144a^++176a^-", 
  "1a^++16ab+45a^-+54a^{\\pm}+66a^++99a^-+144a^+", 
  "1a^++11ab+54a^{\\pm}+55a^++66a^++99a^-+144a^+", 
  "1a^{\\pm}+11ab+54a^{\\pm}+55a^{\\pm}+99a^{\\pm}", 
  "1a^++16ab+45a^++54a^{\\pm}+66a^++144a^+", 
  "1a^{\\pm}+11ab+54a^{\\pm}+66a^{\\pm}", "1a^++16ab+45a^++66a^+", 
  "1a^++11ab+55a^++66a^+", "1a^{\\pm}+11ab+54a^{\\pm}", "1a^{\\pm}+11ab", 
  "1a^{\\pm}", "1a^+" ]

##
gap> tbl:= CharacterTable( "M11" );;
gap> perms:= PermChars( tbl );;
gap> multfree:= Filtered( perms,
>        x -> ForAll( Irr( tbl ), chi -> ScalarProduct( chi, x ) <= 1 ) );
[ Character( CharacterTable( "M11" ), [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ), 
  Character( CharacterTable( "M11" ), [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "M11" ), [ 22, 6, 4, 2, 2, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 144, 0, 0, 0, 4, 0, 0, 0, 1, 1 ] ) ]
gap> Length( multfree );
8

##
gap> tbl:= CharacterTable( "M11" );
CharacterTable( "M11" )
gap> maxes:= Maxes( tbl );
[ "A6.2_3", "L2(11)", "3^2:Q8.2", "A5.2", "2.S4" ]
gap> name:= maxes[1];;
gap> MultFree( tbl, CharacterTable( name ) );
[ Character( CharacterTable( "M11" ), [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 22, 6, 4, 2, 2, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ) ]

##
gap> cand:= [];;
gap> for name in maxes do
>      max:= CharacterTable( name );
>      Append( cand, List( MultFree( tbl, max ),
>                     chi -> [ name, Size( tbl ) / Size( max ), chi ] ) );
> od;
gap> cand;
[ [ "A6.2_3", 11, Character( CharacterTable( "M11" ),
      [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ) ], 
  [ "A6.2_3", 11, Character( CharacterTable( "M11" ),
      [ 22, 6, 4, 2, 2, 0, 0, 0, 0, 0 ] ) ], 
  [ "A6.2_3", 11, Character( CharacterTable( "M11" ),
      [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ) ], 
  [ "L2(11)", 12, Character( CharacterTable( "M11" ),
      [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ) ], 
  [ "L2(11)", 12, Character( CharacterTable( "M11" ),
      [ 144, 0, 0, 0, 4, 0, 0, 0, 1, 1 ] ) ], 
  [ "3^2:Q8.2", 55, Character( CharacterTable( "M11" ),
      [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ) ], 
  [ "3^2:Q8.2", 55, Character( CharacterTable( "M11" ),
      [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ) ], 
  [ "A5.2", 66, Character( CharacterTable( "M11" ),
      [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ) ] ]
gap> Length( cand );  Length( Set( cand, x -> x[3] ) );
8
7

##
gap> max1:= CharacterTable( maxes[1] );;
gap> perms1:= PermChars( max1, [ 2 ] );
[ Character( CharacterTable( "A6.2_3" ), [ 2, 2, 2, 2, 2, 0, 0, 0 ] ) ]
gap> perms1[1]^tbl = cand[2][3];
true
gap> max2:= CharacterTable( maxes[2] );;
gap> perms2:= PermChars( max2, [ 12 ] );
[ Character( CharacterTable( "L2(11)" ), [ 12, 0, 0, 2, 2, 0, 1, 1 ] ) ]
gap> perms2[1]^tbl = cand[5][3];
true

##
gap> PermChars( max1, [ 10 ] );
[ Character( CharacterTable( "A6.2_3" ), [ 10, 2, 1, 2, 0, 0, 2, 2 ] ), 
  Character( CharacterTable( "A6.2_3" ), [ 10, 2, 1, 2, 0, 2, 0, 0 ] ) ]
gap> OrdersClassRepresentatives( max1 );
[ 1, 2, 3, 4, 5, 4, 8, 8 ]

##
gap> max3:= CharacterTable( maxes[3] );;
gap> classes:= SizesConjugacyClasses( max3 );;
gap> Filtered( ClassPositionsOfNormalSubgroups( max3 ),
>              x -> Sum( classes{ x } ) = Size( max3 ) / 2 );
[ [ 1, 2, 4, 5, 6 ], [ 1, 2, 3, 4, 5, 7 ], [ 1, 2, 4, 5, 8, 9 ] ]
gap> perms3:= PermChars( max3, [ 2 ] );
[ Character( CharacterTable( "3^2:Q8.2" ), [ 2, 2, 0, 2, 2, 0, 0, 2, 2 ] ), 
  Character( CharacterTable( "3^2:Q8.2" ), [ 2, 2, 0, 2, 2, 2, 0, 0, 0 ] ), 
  Character( CharacterTable( "3^2:Q8.2" ), [ 2, 2, 2, 2, 2, 0, 2, 0, 0 ] ) ]
gap> induced:= List( perms3, x -> x^tbl );
[ Character( CharacterTable( "M11" ), [ 110, 6, 2, 2, 0, 0, 2, 2, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 110, 6, 2, 6, 0, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 110, 14, 2, 2, 0, 2, 0, 0, 0, 0 ] ) ]
gap> Position( induced, cand[3][3] );
1

##
gap> info:= MultFreePermChars( "M12.2" );;
gap> perms:= Set( List( info, x -> x.character ) );;
gap> Length( info );  Length( perms );
13
13
gap> tbl:= CharacterTable( "M12.2" );;
gap> maxes:= Maxes( tbl );
[ "M12", "L2(11).2", "M12.2M3", "(2^2xA5):2", "2^3.(S4x2)", "4^2:D12.2", 
  "3^(1+2):D8", "S4xS3", "A5.2" ]
gap> cand:= [];;
gap> for name in maxes do
>      max:= CharacterTable( name );
>      Append( cand, List( MultFree( tbl, max ),
>                     chi -> [ name, Size( tbl ) / Size( max ), chi ] ) );
> od;
gap> Length( cand );  Length( Set( List( cand, x -> x[3] ) ) );
25
17
gap> toexclude:= Set( Filtered( cand, x -> not x[3] in perms ) );
[ [ "M12", 2, Character( CharacterTable( "M12.2" ),
      [ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ], 
  [ "M12", 2, Character( CharacterTable( "M12.2" ),
      [ 440, 0, 24, 8, 8, 8, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
    , [ "M12", 2, Character( CharacterTable( "M12.2" ),
      [ 1320, 0, 8, 6, 0, 8, 0, 0, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
    , [ "M12", 2, Character( CharacterTable( "M12.2" ),
      [ 1320, 0, 24, 6, 0, 4, 0, 0, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) 
     ] ]

##
gap> m12:= CharacterTable( "M12" );;
gap> subcand:= [];;
gap> submaxes:= Maxes( m12 );
[ "M11", "M12M2", "A6.2^2", "M12M4", "L2(11)", "3^2.2.S4", "M12M7", "2xS5", 
  "M8.S4", "4^2:D12", "A4xS3" ]
gap> for name in submaxes do
>      max:= CharacterTable( name );
>      Append( subcand, MultFree( m12, max ) );
> od;
gap> induced:= List( subcand, x -> x^tbl );;
gap> Intersection( induced, List( toexclude, x -> x[3] ) );
[  ]

##
gap> STOP_TEST( "multfree.tst" );

#############################################################################
##
#E

