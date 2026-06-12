# This file was created from xpl/multfre2.xpl, do not edit!
############################################################################# \\
##
#W  multfre2.tst              GAP applications              Thomas Breuer
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `Test( "multfre2.tst" );`.
##
gap> START_TEST( "multfre2.tst" );

##
gap> LoadPackage( "ctbllib", false );
true
gap> LoadPackage( "atlasrep", false );
true

##
gap> if not IsBound( PossiblePermutationCharactersWithBoundedMultiplicity )
>       then
>      ReadPackage( "ctbllib", "tst/multfree.g" );
>    fi;
gap> if not IsBound( MultFreeEndoRingCharacterTables ) then
>      ReadPackage( "ctbllib", "tst/mferctbl.gap" );
---------------------------------------------------------------------------
Loading the database of character tables of endomorphism rings of
multiplicity-free permutation modules of the sporadic simple groups and
their cyclic and bicyclic extensions, compiled by T. Breuer and J. Mueller.
---------------------------------------------------------------------------
>    fi;
gap> if not IsBound( PossiblePermutationCharactersWithBoundedMultiplicity ) or
>       not IsBound( MultFreeEndoRingCharacterTables ) then
>      Print( "Sorry, the data files are not available!\n" );
>    fi;

##
gap> PossiblePermutationCharacters:= function( sub, tbl )
>    local fus, triv;
> 
>    fus:= PossibleClassFusions( sub, tbl );
>    if fus = fail then
>      return fail;
>    fi;
>    triv:= [ TrivialCharacter( sub ) ];
> 
>    return Set( List( fus, map -> Induced( sub, tbl, triv, map )[1] ) );
>    end;;

##
gap> FaithfulCandidates:= function( tbl, factname )
>    local factinfo, factchars, facttbl, fus, sizeN, faith, i;
> 
>    # Fetch the data for the factor group.
>    factinfo:= MultFreeEndoRingCharacterTables( factname );
>    factchars:= List( factinfo, x -> x.character );
>    facttbl:= UnderlyingCharacterTable( factchars[1] );
>    fus:= GetFusionMap( tbl, facttbl );
>    sizeN:= Size( tbl ) / Size( facttbl );
> 
>    # Compute faithful possible permutation characters.
>    faith:= List( factchars, pi -> PermChars( tbl,
>                      rec( torso:= [ sizeN * pi[1] ],
>                           normalsubgroup:= ClassPositionsOfKernel( fus ),
>                           nonfaithful:= pi{ fus } ) ) );
> 
>    # Take only the multiplicity-free ones.
>    faith:= List( faith, x -> Filtered( x, pi -> ForAll( Irr( tbl ),
>                      chi -> ScalarProduct( tbl, pi, chi ) < 2 ) ) );
> 
>    # Print info about the candidates.
>    for i in [ 1 .. Length( faith ) ] do
>      if not IsEmpty( faith[i] ) then
>        Print( i, ":  subgroup ", factinfo[i].subgroup,
>               ", degree ", faith[i][1][1],
>               " (", Length( faith[i] ), " cand.)\n" );
>      fi;
>    od;
> 
>    # Return the candidates.
>    return faith;
>    end;;

##
gap> VerifyCandidates:= function( s, tbl, tbl2, candidates, admissible )
>    local fus, der, pi;
> 
>    if tbl2 = 0 then
>      tbl2:= tbl;
>    fi;
> 
>    # Compute the possible class fusions, and induce the trivial character.
>    fus:= PossibleClassFusions( s, tbl2 );
>    if admissible = "extending" then
>      der:= Set( GetFusionMap( tbl, tbl2 ) );
>      fus:= Filtered( fus, map -> not IsSubset( der, map ) );
>    fi;
>    pi:= Set( List( fus, map -> Induced( s, tbl2,
>            [ TrivialCharacter( s ) ], map )[1] ) );
> 
>    # Compare the two lists.
>    if pi = SortedList( candidates ) then
>      Print( "G = ", Identifier( tbl2 ), ":  point stabilizer ",
>             Identifier( s ), ", ranks ",
>             List( pi, x -> Length( ConstituentsOfCharacter(x) ) ), "\n" );
>      if Size( tbl ) = Size( tbl2 ) then
>        Print( PermCharInfo( tbl, pi ).ATLAS, "\n" );
>      else
>        Print( PermCharInfoRelative( tbl, tbl2, pi ).ATLAS, "\n" );
>      fi;
>    elif IsEmpty( Intersection( pi, candidates ) ) then
>      Print( "G = ", Identifier( tbl2 ), ":  no ", Identifier( s ), "\n" );
>    else
>      Error( "problem with verify" );
>    fi;
>    end;;

##
gap> CheckConditionsForLemma3:= function( s0, s, fact, tbl, admissible )
>    local s0fuss, poss, der, sfusfact, outerins, outerinfact, preim,
>          squares, dp,  dpfustbl, s0indp, other, goodclasses;
> 
>    if Size( s ) <> 2 * Size( s0 ) then
>      Error( "<s> must be twice as large as <s0>" );
>    fi;
> 
>    s0fuss:= GetFusionMap( s0, s );
>    if s0fuss = fail then
>      poss:= Set( List( PossiblePermutationCharacters( s0, s ),
>                        pi -> Filtered( [ 1 .. Length( pi ) ],
>                                        i -> pi[i] <> 0 ) ) );
>      if Length( poss ) = 1 then
>        s0fuss:= poss[1];
>      else
>        Error( "classes of <s0> in <s> not determined" );
>      fi;
>    fi;
>    sfusfact:= PossibleClassFusions( s, fact );
>    if admissible = "extending" then
>      der:= ClassPositionsOfDerivedSubgroup( fact );
>      sfusfact:= Filtered( sfusfact, map -> not IsSubset( der, map ) );
>    fi;
>    outerins:= Difference( [ 1 .. NrConjugacyClasses( s ) ], s0fuss );
>    outerinfact:= Set( List( sfusfact, map -> Set( map{ outerins } ) ) );
>    if Length( outerinfact ) <> 1 then 
>      Error( "classes of `", s, "' inside `", fact, "' not determined" );
>    fi;
> 
>    preim:= Flat( InverseMap( GetFusionMap( tbl, fact ) ){ outerinfact[1] } );
>    squares:= Set( PowerMap( tbl, 2 ){ preim } );
>    dp:= s0 * CharacterTable( "Cyclic", 2 );
>    dpfustbl:= PossibleClassFusions( dp, tbl ); 
>    s0indp:= GetFusionMap( s0, dp );
>    other:= Difference( [ 1 .. NrConjugacyClasses( dp ) ], s0indp );
>    goodclasses:= List( dpfustbl, map -> Intersection( squares,
>                            Difference( map{ s0indp }, map{ other } ) ) );
>    if not IsEmpty( Intersection( goodclasses ) ) then
>      Print( Identifier( tbl ), ":  ", Identifier( s ),
>             " lifts to a direct product,\n",
>             "proved by squares in ", Intersection( goodclasses ), ".\n" );
>    elif ForAll( goodclasses, IsEmpty ) then
>      Print( Identifier( tbl ), ":  ", Identifier( s ),
>             " lifts to a nonsplit extension.\n" );
>    else
>      Print( "sorry, no proof of the splitting!\n" );
>    fi;
>    end;;

##
gap> NecessarilyDifferentPermChars:= function( fusion, factfus, inner )
>    local outer, inv;
> 
>    outer:= Difference( [ 1 .. Length( fusion ) ], inner );
>    fusion:= fusion{ outer };
>    inv:= Filtered( InverseMap( factfus ), IsList );
>    return ForAny( inv, pair -> Length( Intersection( pair, fusion ) ) = 1 );
>    end;;

##
gap> ProofOfD8Factor:= function( tblG, piU, piM, piN )
>    local D, map, D1, D2;
> 
>    D:= Filtered( [ 1 .. Length( piU ) ], i -> piM[i] <> 0 and piN[i] = 0 );
>    map:= PowerMap( tblG, 2 );
>    D1:= Filtered( D, i -> piU[ map[i] ] = 0 );
>    D2:= Filtered( D, i -> OrdersClassRepresentatives( tblG )[i] = 2 );
>    return [ D1, D2 ];
>    end;;

##
gap> IsoclinicTable:= function( tbl, tbl2, facttbl )
>    local subfus, factfus;
> 
>    subfus:= GetFusionMap( tbl, tbl2 );
>    factfus:= GetFusionMap( tbl2, facttbl );
>    tbl2:= CharacterTableIsoclinic( tbl2 );
>    StoreFusion( tbl, subfus, tbl2 );
>    StoreFusion( tbl2, factfus, facttbl );
>    return tbl2;
>    end;;

##
gap> CompareWithDatabase:= function( name, chars )
>    local info;
> 
>    info:= MultFreeEndoRingCharacterTables( name );
>    info:= List( info, x -> x.character );;
>    if SortedList( info ) <> SortedList( Concatenation( chars ) ) then
>      Error( "contradiction 1 for ", name );
>    fi;
>    end;;

##
gap> CompareWithCandidatesByMaxes:= function( name, faith )
>    local tbl, poss;
> 
>    tbl:= CharacterTable( name );
>    if not HasMaxes( tbl ) then
>      Error( "no maxes stored for ", name );
>    fi;
>    poss:= PossiblePermutationCharactersWithBoundedMultiplicity( tbl, 1 );
>    poss:= List( poss.permcand, l -> Filtered( l,
>                 pi -> ClassPositionsOfKernel( pi ) = [ 1 ] ) );
>    if SortedList( Concatenation( poss ) )
>       <> SortedList( Concatenation( faith ) ) then
>      Error( "contradiction 2 for ", name );
>    fi;
>    end;;

##
gap> tbl:= CharacterTable( "2.M12" );;
gap> faith:= FaithfulCandidates( tbl, "M12" );;
1:  subgroup $M_{11}$, degree 24 (1 cand.)
2:  subgroup $M_{11}$, degree 24 (1 cand.)
5:  subgroup $A_6.2_1 \leq A_6.2^2$, degree 264 (1 cand.)
8:  subgroup $A_6.2_1 \leq A_6.2^2$, degree 264 (1 cand.)
11:  subgroup $3^2.2.S_4$, degree 440 (2 cand.)
12:  subgroup $3^2:2.A_4 \leq 3^2.2.S_4$, degree 880 (1 cand.)
13:  subgroup $3^2.2.S_4$, degree 440 (2 cand.)
14:  subgroup $3^2:2.A_4 \leq 3^2.2.S_4$, degree 880 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "M11" ), tbl, 0,
>        Concatenation( faith[1], faith[2] ), "all" );
G = 2.M12:  point stabilizer M11, ranks [ 3, 3 ]
[ "1a+11a+12a", "1a+11b+12a" ]

##
gap> Maxes( tbl );
[ "2xM11", "2.M12M2", "A6.D8", "2.M12M4", "2.L2(11)", "2x3^2.2.S4", 
  "2.M12M7", "2.M12M8", "2.M12M9", "2.M12M10", "2.A4xS3" ]
gap> faith[5] = faith[8];
true
gap> VerifyCandidates( CharacterTable( "A6.2_1" ), tbl, 0, faith[5], "all" );
G = 2.M12:  point stabilizer A6.2_1, ranks [ 7 ]
[ "1a+11ab+12a+54a+55a+120b" ]

##
gap> s:= CharacterTable( "3^2.2.S4" );;
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> facttbl:= CharacterTable( "M12" );;
gap> factfus:= GetFusionMap( tbl, facttbl );;
gap> ForAll( PossibleClassFusions( s, tbl ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, 0, Concatenation( faith[11], faith[13] ), "all" );
G = 2.M12:  point stabilizer 3^2.2.S4, ranks [ 7, 7, 9, 9 ]
[ "1a+11a+54a+55a+99a+110ab", "1a+11b+54a+55a+99a+110ab", 
  "1a+11a+12a+44ab+54a+55a+99a+120b", "1a+11b+12a+44ab+54a+55a+99a+120b" ]

##
gap> fus:= PossibleClassFusions( s, tbl );;
gap> deg2:= PermChars( s, 2 );
[ Character( CharacterTable( "3^2.2.S4" ),
  [ 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0 ] ) ]
gap> pi:= Set( List( fus, map -> Induced( s, tbl, deg2, map )[1] ) );;
gap> pi = SortedList( Concatenation( faith[12], faith[14] ) );
true
gap> PermCharInfo( tbl, pi ).ATLAS;
[ "1a+11a+12a+44ab+45a+54a+55ac+99a+110ab+120ab", 
  "1a+11b+12a+44ab+45a+54a+55ab+99a+110ab+120ab" ]
gap> CompareWithDatabase( "2.M12", faith );
gap> CompareWithCandidatesByMaxes( "2.M12", faith );

##
gap> tbl2:= CharacterTable( "2.M12.2" );;
gap> faith:= FaithfulCandidates( tbl2, "M12.2" );;
1:  subgroup $M_{11}$, degree 48 (1 cand.)
2:  subgroup $L_2(11).2$, degree 288 (2 cand.)

##
gap> VerifyCandidates( CharacterTable( "M11" ), tbl, tbl2, faith[1], "all" );
G = 2.M12.2:  point stabilizer M11, ranks [ 5 ]
[ "1a^{\\pm}+11ab+12a^{\\pm}" ]

##
gap> s:= CharacterTable( "L2(11).2" );;
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> facttbl:= CharacterTable( "M12.2" );;
gap> factfus:= GetFusionMap( tbl2, facttbl );;
gap> ForAll( PossibleClassFusions( s, tbl2 ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, tbl2, faith[2], "all" );
G = 2.M12.2:  point stabilizer L2(11).2, ranks [ 7, 7 ]
[ "1a^++11ab+12a^{\\pm}+55a^++66a^++120b^-", 
  "1a^++11ab+12a^{\\pm}+55a^++66a^++120b^+" ]
gap> CompareWithDatabase( "2.M12.2", faith );

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "M12.2" );;
1:  subgroup $M_{11}$, degree 48 (1 cand.)
gap> CompareWithDatabase( "Isoclinic(2.M12.2)", faith );

##
gap> PossibleClassFusions( CharacterTable( "L2(11).2" ), tbl2 );
[  ]

##
gap> tbl:= CharacterTable( "2.M22" );;
gap> faith:= FaithfulCandidates( tbl, "M22" );;
3:  subgroup $2^4:A_5 \leq 2^4:A_6$, degree 924 (1 cand.)
4:  subgroup $A_7$, degree 352 (1 cand.)
5:  subgroup $A_7$, degree 352 (1 cand.)
7:  subgroup $2^3:L_3(2)$, degree 660 (1 cand.)

##
gap> Maxes( tbl );
[ "2.L3(4)", "2.M22M2", "2xA7", "2xA7", "2.M22M5", "2x2^3:L3(2)", 
  "(2xA6).2_3", "2xL2(11)" ]
gap> s:= CharacterTable( "P1/G1/L1/V1/ext2" );;
gap> VerifyCandidates( s, tbl, 0, faith[3], "all" );
G = 2.M22:  point stabilizer P1/G1/L1/V1/ext2, ranks [ 8 ]
[ "1a+21a+55a+126ab+154a+210b+231a" ]
gap> faith[4] = faith[5];
true
gap> VerifyCandidates( CharacterTable( "A7" ), tbl, 0, faith[4], "all" );
G = 2.M22:  point stabilizer A7, ranks [ 5 ]
[ "1a+21a+56a+120a+154a" ]
gap> VerifyCandidates( CharacterTable( "M22M6" ), tbl, 0, faith[7], "all" );
G = 2.M22:  point stabilizer 2^3:sl(3,2), ranks [ 7 ]
[ "1a+21a+55a+99a+120a+154a+210b" ]
gap> CompareWithDatabase( "2.M22", faith );
gap> CompareWithCandidatesByMaxes( "2.M22", faith );

##
gap> tbl2:= CharacterTable( "2.M22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
6:  subgroup $2^4:S_5 \leq 2^4:S_6$, degree 924 (2 cand.)
7:  subgroup $A_7$, degree 704 (1 cand.)
11:  subgroup $2^3:L_3(2) \times 2$, degree 660 (2 cand.)
12:  subgroup $2^3:L_3(2) \leq 2^3:L_3(2) \times 2$, degree 1320 (2 cand.)
16:  subgroup $L_2(11).2$, degree 1344 (2 cand.)

##
gap> s:= CharacterTable( "w(d5)" );;
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> facttbl:= CharacterTable( "M22.2" );;
gap> factfus:= GetFusionMap( tbl2, facttbl );;
gap> ForAll( PossibleClassFusions( s, tbl2 ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, tbl2, faith[6], "all" );
G = 2.M22.2:  point stabilizer w(d5), ranks [ 7, 7 ]
[ "1a^++21a^++55a^++126ab+154a^++210b^-+231a^-", 
  "1a^++21a^++55a^++126ab+154a^++210b^++231a^-" ]

##
gap> VerifyCandidates( CharacterTable( "A7" ), tbl, tbl2, faith[7], "all" );
G = 2.M22.2:  point stabilizer A7, ranks [ 10 ]
[ "1a^{\\pm}+21a^{\\pm}+56a^{\\pm}+120a^{\\pm}+154a^{\\pm}" ]

##
gap> s:= CharacterTable( "2x2^3:L3(2)" );;
gap> s0:= CharacterTable( "2^3:sl(3,2)" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "extending" );
2.M22.2:  2x2^3:L3(2) lifts to a direct product,
proved by squares in [ 1, 5, 14, 16 ].
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> ForAll( PossibleClassFusions( s, tbl2 ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, tbl2, faith[11], "extending" );
G = 2.M22.2:  point stabilizer 2x2^3:L3(2), ranks [ 7, 7 ]
[ "1a^++21a^++55a^++99a^++120a^-+154a^++210b^-", 
  "1a^++21a^++55a^++99a^++120a^++154a^++210b^+" ]

##
gap> s:= CharacterTable( "M22M6" );;
gap> pi1320:= PossiblePermutationCharacters( s, tbl2 );;
gap> Length( pi1320 );
1
gap> IsSubset( faith[12], pi1320 );
true
gap> faith[12]:= pi1320;;
gap> VerifyCandidates( s, tbl, tbl2, faith[12], "all" );
G = 2.M22.2:  point stabilizer 2^3:sl(3,2), ranks [ 14 ]
[ "1a^{\\pm}+21a^{\\pm}+55a^{\\pm}+99a^{\\pm}+120a^{\\pm}+154a^{\\pm}+210b^{\\\
pm}" ]

##
gap> s:= CharacterTable( "L2(11).2" );;
gap> s0:= CharacterTable( "L2(11)" );;    
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
2.M22.2:  L2(11).2 lifts to a direct product,
proved by squares in [ 1, 4, 10, 13 ].
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> ForAll( PossibleClassFusions( s, tbl2 ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( CharacterTable( "L2(11).2" ), tbl, tbl2, faith[16], "all" );
G = 2.M22.2:  point stabilizer L2(11).2, ranks [ 10, 10 ]
[ "1a^++21a^-+55a^++56a^{\\pm}+120a^-+154a^++210a^-+231a^-+440a^+", 
  "1a^++21a^-+55a^++56a^{\\pm}+120a^++154a^++210a^-+231a^-+440a^-" ]
gap> CompareWithDatabase( "2.M22.2", faith );

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
7:  subgroup $A_7$, degree 704 (1 cand.)
12:  subgroup $2^3:L_3(2) \leq 2^3:L_3(2) \times 2$, degree 1320 (2 cand.)
gap> faith[12]:= Filtered( faith[12], chi -> chi in pi1320 );;
gap> CompareWithDatabase( "Isoclinic(2.M22.2)", faith );

##
gap> tbl:= CharacterTable( "3.M22" );;
gap> faith:= FaithfulCandidates( tbl, "M22" );;
3:  subgroup $2^4:A_5 \leq 2^4:A_6$, degree 1386 (1 cand.)
6:  subgroup $2^4:S_5$, degree 693 (1 cand.)
7:  subgroup $2^3:L_3(2)$, degree 990 (1 cand.)
9:  subgroup $L_2(11)$, degree 2016 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "P1/G1/L1/V1/ext2" ), tbl, 0, faith[3], "all" );
G = 3.M22:  point stabilizer P1/G1/L1/V1/ext2, ranks [ 13 ]
[ "1a+21abc+55a+105abcd+154a+231abc" ]
gap> VerifyCandidates( CharacterTable( "M22M5" ), tbl, 0, faith[6], "all" );
G = 3.M22:  point stabilizer 2^4:s5, ranks [ 10 ]
[ "1a+21abc+55a+105abcd+154a" ]
gap> VerifyCandidates( CharacterTable( "M22M6" ), tbl, 0, faith[7], "all" );
G = 3.M22:  point stabilizer 2^3:sl(3,2), ranks [ 13 ]
[ "1a+21abc+55a+99abc+105abcd+154a" ]
gap> VerifyCandidates( CharacterTable( "M22M8" ), tbl, 0, faith[9], "all" );
G = 3.M22:  point stabilizer L2(11), ranks [ 16 ]
[ "1a+21abc+55a+105abcd+154a+210abc+231abc" ]
gap> CompareWithDatabase( "3.M22", faith );
gap> CompareWithCandidatesByMaxes( "3.M22", faith );

##
gap> tbl2:= CharacterTable( "3.M22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
6:  subgroup $2^4:S_5 \leq 2^4:S_6$, degree 1386 (1 cand.)
8:  subgroup $2^5:S_5$, degree 693 (1 cand.)
10:  subgroup $2^4:(A_5 \times 2) \leq 2^5:S_5$, degree 1386 (1 cand.)
11:  subgroup $2^3:L_3(2) \times 2$, degree 990 (1 cand.)
16:  subgroup $L_2(11).2$, degree 2016 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "w(d5)" ), tbl, tbl2, faith[6], "all" );
G = 3.M22.2:  point stabilizer w(d5), ranks [ 9 ]
[ "1a^++21a^+bc+55a^++105abcd+154a^++231a^-bc" ]
gap> VerifyCandidates( CharacterTable( "M22.2M4" ), tbl, tbl2, faith[8], "all" );
G = 3.M22.2:  point stabilizer M22.2M4, ranks [ 7 ]
[ "1a^++21a^+bc+55a^++105abcd+154a^+" ]
gap> VerifyCandidates( CharacterTable( "2x2^3:L3(2)" ), tbl, tbl2, faith[11], "all" );
G = 3.M22.2:  point stabilizer 2x2^3:L3(2), ranks [ 9 ]
[ "1a^++21a^+bc+55a^++99a^+bc+105abcd+154a^+" ]
gap> VerifyCandidates( CharacterTable( "L2(11).2" ), tbl, tbl2, faith[16], "all" );
G = 3.M22.2:  point stabilizer L2(11).2, ranks [ 11 ]
[ "1a^++21a^-bc+55a^++105abcd+154a^++210a^-bc+231a^-bc" ]

##
gap> s:= CharacterTable( "M22.2M4" );;
gap> lin:= LinearCharacters( s );
[ Character( CharacterTable( "M22.2M4" ),
  [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] )
    , Character( CharacterTable( "M22.2M4" ),
  [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
      -1, -1, -1 ] ), Character( CharacterTable( "M22.2M4" ),
  [ 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 
      -1, -1 ] ), Character( CharacterTable( "M22.2M4" ),
  [ 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 
      1, 1, 1, 1 ] ) ]
gap> perms:= List( lin{ [ 2 .. 4 ] }, chi -> chi + lin[1] );;
gap> sfustbl2:= PossibleClassFusions( s, tbl2 );;
gap> Length( sfustbl2 );
2
gap> ind1:= Induced( s, tbl2, perms, sfustbl2[1] );;
gap> ind2:= Induced( s, tbl2, perms, sfustbl2[2] );;
gap> PermCharInfo( tbl2, ind1 ).ATLAS;
[ "1ab+21ab+42aa+55ab+154ab+210ccdd", "1a+21ab+42a+55a+154a+210bcd+462a", 
  "1a+21aa+42a+55a+154a+210acd+462a" ]
gap> PermCharInfo( tbl2, ind2 ).ATLAS;
[ "1a+21aa+42a+55a+154a+210acd+462a", "1a+21ab+42a+55a+154a+210bcd+462a", 
  "1ab+21ab+42aa+55ab+154ab+210ccdd" ]
gap> ind1[2] = ind2[2];
true
gap> [ ind1[2] ] = faith[10];
true
gap> CompareWithDatabase( "3.M22.2", faith );

##
gap> tbl:= CharacterTable( "4.M22" );;
gap> faith:= FaithfulCandidates( tbl, "2.M22" );;
gap> CompareWithDatabase( "4.M22", faith );
gap> CompareWithCandidatesByMaxes( "4.M22", faith );

##
gap> tbl2:= CharacterTable( "4.M22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
gap> CompareWithDatabase( "4.M22.2", faith );
gap> CompareWithDatabase( "12.M22.2", [] );
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
gap> CompareWithDatabase( "Isoclinic(4.M22.2)", faith );
gap> CompareWithDatabase( "Isoclinic(12.M22.2)", [] );

##
gap> tbl:= CharacterTable( "6.M22" );;
gap> faith:= FaithfulCandidates( tbl, "3.M22" );;
1:  subgroup $2^4:A_5 \rightarrow (M_{22},3)$, degree 2772 (1 cand.)
3:  subgroup $2^3:L_3(2) \rightarrow (M_{22},7)$, degree 1980 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "P1/G1/L1/V1/ext2" ), tbl, 0, faith[1], "all" );
G = 6.M22:  point stabilizer P1/G1/L1/V1/ext2, ranks [ 22 ]
[ "1a+21abc+55a+105abcd+126abcdef+154a+210bef+231abc" ]
gap> VerifyCandidates( CharacterTable( "M22M6" ), tbl, 0, faith[3], "all" );
G = 6.M22:  point stabilizer 2^3:sl(3,2), ranks [ 17 ]
[ "1a+21abc+55a+99abc+105abcd+120a+154a+210b+330de" ]
gap> CompareWithDatabase( "6.M22", faith );
gap> CompareWithCandidatesByMaxes( "6.M22", faith );

##
gap> tbl2:= CharacterTable( "6.M22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
6:  subgroup $2^4:S_5 \leq 2^4:S_6$, degree 2772 (2 cand.)
11:  subgroup $2^3:L_3(2) \times 2$, degree 1980 (2 cand.)
16:  subgroup $L_2(11).2$, degree 4032 (2 cand.)

##
gap> s:= CharacterTable( "w(d5)" );;
gap> VerifyCandidates( s, tbl, tbl2, faith[6], "all" );
G = 6.M22.2:  point stabilizer w(d5), ranks [ 14, 14 ]
[ "1a^++21a^+bc+55a^++105abcd+126abcdef+154a^++210b^-ef+231a^-bc", 
  "1a^++21a^+bc+55a^++105abcd+126abcdef+154a^++210b^+ef+231a^-bc" ]

##
gap> s:= CharacterTable( "2x2^3:L3(2)" );;
gap> VerifyCandidates( s, tbl, tbl2, faith[11], "extending" );
G = 6.M22.2:  point stabilizer 2x2^3:L3(2), ranks [ 12, 12 ]
[ "1a^++21a^+bc+55a^++99a^+bc+105abcd+120a^-+154a^++210b^-+330de", 
  "1a^++21a^+bc+55a^++99a^+bc+105abcd+120a^++154a^++210b^++330de" ]
gap> VerifyCandidates( CharacterTable( "L2(11).2" ), tbl, tbl2, faith[16], "all" );
G = 6.M22.2:  point stabilizer L2(11).2, ranks [ 20, 20 ]
[ "1a^++21a^-bc+55a^++56a^{\\pm}+66abcd+105abcd+120a^-bc+154a^++210a^-cdghij+2\
31a^-bc+440a^+", 
  "1a^++21a^-bc+55a^++56a^{\\pm}+66abcd+105abcd+120a^+bc+154a^++210a^-cdghij+2\
31a^-bc+440a^-" ]
gap> CompareWithDatabase( "6.M22.2", faith );

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "M22.2" );;
gap> CompareWithDatabase( "Isoclinic(6.M22.2)", faith );

##
gap> tbl:= CharacterTable( "2.J2" );;
gap> faith:= FaithfulCandidates( tbl, "J2" );;
1:  subgroup $U_3(3)$, degree 200 (1 cand.)
gap> VerifyCandidates( CharacterTable( "U3(3)" ), tbl, 0, faith[1], "all" );
G = 2.J2:  point stabilizer U3(3), ranks [ 5 ]
[ "1a+36a+50ab+63a" ]
gap> CompareWithDatabase( "2.J2", faith );
gap> CompareWithCandidatesByMaxes( "2.J2", faith );

##
gap> tbl2:= CharacterTable( "2.J2.2" );;
gap> faith:= FaithfulCandidates( tbl2, "J2.2" );;
gap> CompareWithDatabase( "2.J2.2", faith );

##
gap> facttbl:= CharacterTable( "J2.2" );;
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "J2.2" );;
1:  subgroup $U_3(3).2$, degree 200 (1 cand.)
5:  subgroup $3.A_6.2_3 \leq 3.A_6.2^2$, degree 1120 (1 cand.)

##
gap> s0:= CharacterTable( "U3(3)" );;
gap> s:= CharacterTable( "U3(3).2" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
Isoclinic(2.J2.2):  U3(3).2 lifts to a direct product,
proved by squares in [ 1, 3, 8, 16 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[1], "all" );
G = Isoclinic(2.J2.2):  point stabilizer U3(3).2, ranks [ 4 ]
[ "1a^++36a^++50ab+63a^+" ]

##
gap> s0:= CharacterTable( "3.A6" );;
gap> s:= CharacterTable( "3.A6.2_3" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
Isoclinic(2.J2.2):  3.A6.2_3 lifts to a direct product,
proved by squares in [ 3, 10, 16, 25 ].

##
gap> tblMbar:= CharacterTable( "3.A6.2^2" );;
gap> piMbar:= PossiblePermutationCharacters( tblMbar, facttbl );
[ Character( CharacterTable( "J2.2" ),
  [ 280, 40, 12, 1, 4, 4, 10, 0, 1, 0, 0, 2, 2, 0, 1, 1, 14, 10, 0, 2, 4, 0, 
      1, 0, 0, 1, 1 ] ) ]
gap> piM:= piMbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> piNbar:= PossiblePermutationCharacters( s, facttbl );
[ Character( CharacterTable( "J2.2" ),
  [ 560, 80, 0, 2, 8, 8, 20, 0, 2, 0, 0, 0, 0, 0, 2, 2, 0, 8, 0, 0, 8, 0, 2, 
      0, 0, 2, 2 ] ) ]
gap> piN:= piNbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> piU:= PossiblePermutationCharacters( s0, tbl2 );
[ Character( CharacterTable( "Isoclinic(2.J2.2)" ),
  [ 2240, 0, 320, 0, 0, 8, 0, 32, 0, 32, 0, 80, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 
      0, 0, 8, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
     ] ) ]
gap> ProofOfD8Factor( tbl2, piU[1], piM, piN );
[ [ 5, 21, 22 ], [ 29 ] ]

##
gap> VerifyCandidates( s, tbl, tbl2, faith[5], "all" );
G = Isoclinic(2.J2.2):  point stabilizer 3.A6.2_3, ranks [ 12 ]
[ "1a^++14c^{\\pm}+21ab+50ab+63a^{\\pm}+90a^++126a^++175a^-+216a^{\\pm}" ]
gap> faith[1]:= faith[1]{ [ 1, 1 ] };;
gap> CompareWithDatabase( "Isoclinic(2.J2.2)", faith );

##
gap> tbl:= CharacterTable( "2.HS" );;
gap> faith:= FaithfulCandidates( tbl, "HS" );;
3:  subgroup $U_3(5) \leq U_3(5).2$, degree 704 (1 cand.)
5:  subgroup $U_3(5) \leq U_3(5).2$, degree 704 (1 cand.)
8:  subgroup $A_8 \leq A_8.2$, degree 4400 (1 cand.)
10:  subgroup $M_{11}$, degree 11200 (1 cand.)
11:  subgroup $M_{11}$, degree 11200 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "U3(5)" ), tbl, 0,
>       Concatenation( faith[3], faith[5] ), "all" );
G = 2.HS:  point stabilizer U3(5), ranks [ 6, 6 ]
[ "1a+22a+154c+175a+176ab", "1a+22a+154b+175a+176ab" ]
gap> PossibleClassFusions( CharacterTable( "2.A8" ), tbl );
[  ]
gap> VerifyCandidates( CharacterTable( "A8" ), tbl, 0, faith[8], "all" );
G = 2.HS:  point stabilizer A8, ranks [ 13 ]
[ "1a+22a+77a+154abc+175a+176ab+693a+770a+924ab" ]
gap> VerifyCandidates( CharacterTable( "M11" ), tbl, 0,
>       Concatenation( faith[10], faith[11] ), "all" );
G = 2.HS:  point stabilizer M11, ranks [ 16, 16 ]
[ "1a+22a+56a+77a+154c+175a+176ab+616ab+770a+825a+1056a+1980ab+2520a", 
  "1a+22a+56a+77a+154b+175a+176ab+616ab+770a+825a+1056a+1980ab+2520a" ]
gap> CompareWithDatabase( "2.HS", faith );
gap> CompareWithCandidatesByMaxes( "2.HS", faith );

##
gap> tbl2:= CharacterTable( "2.HS.2" );;
gap> faith:= FaithfulCandidates( tbl2, "HS.2" );;
10:  subgroup $A_8 \times 2 \leq A_8.2 \times 2$, degree 4400 (1 cand.)
11:  subgroup $A_8.2 \leq A_8.2 \times 2$, degree 4400 (1 cand.)

##
gap> facttbl:= CharacterTable( "HS.2" );;
gap> factfus:= GetFusionMap( tbl2, facttbl );;
gap> s0:= CharacterTable( "A8" );;
gap> s:= s0 * CharacterTable( "Cyclic", 2 );
CharacterTable( "A8xC2" )
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
2.HS.2:  A8xC2 lifts to a direct product,
proved by squares in [ 1, 6, 13, 20, 30 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[10], "extending" );
G = 2.HS.2:  point stabilizer A8xC2, ranks [ 10 ]
[ "1a^++22a^++77a^++154a^+bc+175a^++176ab+693a^++770a^++924ab" ]
gap> s:= CharacterTable( "A8.2" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "extending" );
2.HS.2:  A8.2 lifts to a direct product,
proved by squares in [ 1, 6, 13 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[11], "all" );
G = 2.HS.2:  point stabilizer A8.2, ranks [ 10 ]
[ "1a^++22a^-+77a^++154a^+bc+175a^++176ab+693a^++770a^-+924ab" ]
gap> CompareWithDatabase( "2.HS.2", faith );

##
gap> tblMbar:= CharacterTable( "A8.2" ) * CharacterTable( "Cyclic", 2 );;
gap> piMbar:= PossiblePermutationCharacters( tblMbar, facttbl );
[ Character( CharacterTable( "HS.2" ),
  [ 1100, 60, 32, 11, 40, 16, 4, 0, 10, 0, 5, 3, 1, 2, 0, 0, 2, 0, 1, 1, 0, 
      134, 30, 10, 10, 0, 11, 5, 3, 0, 4, 4, 0, 1, 1, 0, 0, 0, 1 ] ) ]
gap> piM:= piMbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> s:= s0 * CharacterTable( "Cyclic", 2 );;
gap> piNbar:= PossiblePermutationCharacters( s, facttbl );
[ Character( CharacterTable( "HS.2" ),
  [ 2200, 120, 0, 22, 0, 16, 8, 0, 20, 0, 0, 6, 2, 0, 0, 0, 0, 0, 0, 2, 0, 
      212, 20, 20, 12, 0, 2, 8, 2, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2 ] ) ]
gap> piN:= piNbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> piU:= PossiblePermutationCharacters( s0, tbl2 );
[ Character( CharacterTable( "2.HS.2" ),
  [ 8800, 0, 320, 160, 0, 88, 0, 0, 32, 16, 0, 0, 80, 0, 0, 0, 0, 8, 16, 8, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> ProofOfD8Factor( tbl2, piU[1], piM, piN );
[ [ 5, 17, 26 ], [  ] ]

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "HS.2" );;
gap> CompareWithDatabase( "Isoclinic(2.HS.2)", faith );

##
gap> tbl:= CharacterTable( "3.J3" );;
gap> faith:= FaithfulCandidates( tbl, "J3" );;
gap> CompareWithDatabase( "3.J3", faith );

##
gap> tbl2:= CharacterTable( "3.J3.2" );;
gap> faith:= FaithfulCandidates( tbl2, "J3.2" );;
gap> CompareWithDatabase( "3.J3.2", faith );

##
gap> tbl:= CharacterTable( "3.McL" );;
gap> faith:= FaithfulCandidates( tbl, "McL" );;
6:  subgroup $2.A_8$, degree 66825 (1 cand.)
gap> VerifyCandidates( CharacterTable( "2.A8" ), tbl, 0, faith[6], "all" );
G = 3.McL:  point stabilizer 2.A8, ranks [ 14 ]
[ "1a+252a+1750a+2772ab+5103abc+5544a+6336ab+8064ab+9625a" ]
gap> CompareWithDatabase( "3.McL", faith );
gap> CompareWithCandidatesByMaxes( "3.McL", faith );

##
gap> tbl2:= CharacterTable( "3.McL.2" );;
gap> faith:= FaithfulCandidates( tbl2, "McL.2" );;
9:  subgroup $2.S_8$, degree 66825 (1 cand.)
gap> s:= CharacterTable( "Isoclinic(2.A8.2)" );;
gap> VerifyCandidates( s, tbl, tbl2, faith[9], "all" );
G = 3.McL.2:  point stabilizer Isoclinic(2.A8.2), ranks [ 10 ]
[ "1a^++252a^++1750a^++2772ab+5103a^+bc+5544a^++6336ab+8064ab+9625a^+" ]
gap> CompareWithDatabase( "3.McL.2", faith );

##
gap> tbl:= CharacterTable( "2.Ru" );;
gap> faith:= FaithfulCandidates( tbl, "Ru" );;
2:  subgroup ${^2F_4(2)^{\prime}} \leq {^2F_4(2)^{\prime}}.2$, degree 16240 (
1 cand.)
gap> VerifyCandidates( CharacterTable( "2F4(2)'" ), tbl, 0, faith[2], "all" );
G = 2.Ru:  point stabilizer 2F4(2)', ranks [ 9 ]
[ "1a+28ab+406a+783a+3276a+3654a+4032ab" ]
gap> CompareWithDatabase( "2.Ru", faith );

##
gap> tbl:= CharacterTable( "2.Suz" );;
gap> faith:= FaithfulCandidates( tbl, "Suz" );;
4:  subgroup $U_5(2)$, degree 65520 (1 cand.)
gap> VerifyCandidates( CharacterTable( "U5(2)" ), tbl, 0, faith[4], "all" );
G = 2.Suz:  point stabilizer U5(2), ranks [ 10 ]
[ "1a+143a+364abc+5940a+12012a+14300a+16016ab" ]
gap> CompareWithDatabase( "2.Suz", faith );

##
gap> tbl2:= CharacterTable( "2.Suz.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Suz.2" );;
8:  subgroup $U_5(2).2$, degree 65520 (1 cand.)
12:  subgroup $3^5:(M_{11} \times 2)$, degree 465920 (1 cand.)

##
gap> s0:= CharacterTable( "U5(2)" );;
gap> s:= CharacterTable( "U5(2).2" );; 
gap> facttbl:= CharacterTable( "Suz.2" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
2.Suz.2:  U5(2).2 lifts to a direct product,
proved by squares in [ 1, 8, 13, 19, 31, 44 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[8], "all" );
G = 2.Suz.2:  point stabilizer U5(2).2, ranks [ 8 ]
[ "1a^++143a^-+364a^+bc+5940a^++12012a^-+14300a^-+16016ab" ]
gap> s0:= CharacterTable( "SuzM5" );
CharacterTable( "3^5:M11" )
gap> s:= CharacterTable( "Suz.2M6" );
CharacterTable( "3^5:(M11x2)" )
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
2.Suz.2:  3^5:(M11x2) lifts to a direct product,
proved by squares in [ 1, 4, 8, 10, 19, 22, 26, 39 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[12], "all" );
G = 2.Suz.2:  point stabilizer 3^5:(M11x2), ranks [ 14 ]
[ "1a^++364a^{\\pm}bc+5940a^++12012a^-+14300a^-+15015ab+15795a^++16016ab+54054\
a^++100100a^-b^{\\pm}" ]
gap> faith[8]:= faith[8]{ [ 1, 1 ] };;
gap> faith[12]:= faith[12]{ [ 1, 1 ] };;
gap> CompareWithDatabase( "2.Suz.2", faith );

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "Suz.2" );;
gap> CompareWithDatabase( "Isoclinic(2.Suz.2)", faith );

##
gap> tbl:= CharacterTable( "3.Suz" );;
gap> faith:= FaithfulCandidates( tbl, "Suz" );;
1:  subgroup $G_2(4)$, degree 5346 (1 cand.)
4:  subgroup $U_5(2)$, degree 98280 (1 cand.)
5:  subgroup $2^{1+6}_-.U_4(2)$, degree 405405 (1 cand.)
6:  subgroup $2^{4+6}:3A_6$, degree 1216215 (1 cand.)
gap> Maxes( tbl );
[ "3xG2(4)", "3^2.U4(3).2_3'", "3xU5(2)", "3x2^(1+6)_-.U4(2)", "3^6.M11", 
  "3xJ2.2", "3x2^(4+6).3A6", "(A4x3.L3(4)).2", "3x2^(2+8):(A5xS3)", 
  "3xM12.2", "3.3^(2+4):2(A4x2^2).2", "(3.A6xA5):2", "(3^(1+2):4xA6).2", 
  "3xL3(3).2", "3xL3(3).2", "3xL2(25)", "3.A7" ]
gap> VerifyCandidates( CharacterTable( "G2(4)" ), tbl, 0, faith[1], "all" );
G = 3.Suz:  point stabilizer G2(4), ranks [ 7 ]
[ "1a+66ab+780a+1001a+1716ab" ]
gap> VerifyCandidates( CharacterTable( "U5(2)" ), tbl, 0, faith[4], "all" );
G = 3.Suz:  point stabilizer U5(2), ranks [ 14 ]
[ "1a+78ab+143a+364a+1365ab+4290ab+5940a+12012a+14300a+27027ab" ]
gap> VerifyCandidates( CharacterTable( "SuzM4" ), tbl, 0, faith[5], "all" );
G = 3.Suz:  point stabilizer 2^1+6.u4q2, ranks [ 23 ]
[ "1a+66ab+143a+429ab+780a+1716ab+3432a+5940a+6720ab+14300a+18954abc+25025a+42\
900ab+64350cd+66560a" ]
gap> VerifyCandidates( CharacterTable( "SuzM7" ), tbl, 0, faith[6], "all" );
G = 3.Suz:  point stabilizer 2^4+6:3a6, ranks [ 27 ]
[ "1a+364a+780a+1001a+1365ab+4290ab+5940a+12012a+14300a+15795a+25025a+27027ab+\
42900ab+66560a+75075a+85800ab+88452a+100100a+104247ab+139776ab" ]
gap> CompareWithDatabase( "3.Suz", faith );

##
gap> tbl2:= CharacterTable( "3.Suz.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Suz.2" );;
1:  subgroup $G_2(4).2$, degree 5346 (1 cand.)
8:  subgroup $U_5(2).2$, degree 98280 (1 cand.)
10:  subgroup $2^{1+6}_-.U_4(2).2$, degree 405405 (1 cand.)
13:  subgroup $2^{4+6}:3S_6$, degree 1216215 (1 cand.)
gap> Maxes( CharacterTable( "Suz.2" ) );
[ "Suz", "G2(4).2", "3_2.U4(3).(2^2)_{133}", "U5(2).2", "2^(1+6)_-.U4(2).2", 
  "3^5:(M11x2)", "J2.2x2", "2^(4+6):3S6", "(A4xL3(4):2_3):2", 
  "2^(2+8):(S5xS3)", "M12.2x2", "3^(2+4):2(S4xD8)", "(A6:2_2xA5).2", 
  "(3^2:8xA6).2", "L2(25).2_2", "A7.2" ]
gap> VerifyCandidates( CharacterTable( "G2(4).2" ), tbl, tbl2, faith[1], "all" );
G = 3.Suz.2:  point stabilizer G2(4).2, ranks [ 5 ]
[ "1a^++66ab+780a^++1001a^++1716ab" ]
gap> VerifyCandidates( CharacterTable( "U5(2).2" ), tbl, tbl2, faith[8], "all" );
G = 3.Suz.2:  point stabilizer U5(2).2, ranks [ 10 ]
[ "1a^++78ab+143a^-+364a^++1365ab+4290ab+5940a^++12012a^-+14300a^-+27027ab" ]
gap> VerifyCandidates( CharacterTable( "Suz.2M5" ), tbl, tbl2, faith[10], "all" );
G = 3.Suz.2:  point stabilizer 2^(1+6)_-.U4(2).2, ranks [ 16 ]
[ "1a^++66ab+143a^-+429ab+780a^++1716ab+3432a^++5940a^++6720ab+14300a^-+18954a\
^-bc+25025a^++42900ab+64350cd+66560a^+" ]
gap> VerifyCandidates( CharacterTable( "Suz.2M8" ), tbl, tbl2, faith[13], "all" );
G = 3.Suz.2:  point stabilizer 2^(4+6):3S6, ranks [ 20 ]
[ "1a^++364a^++780a^++1001a^++1365ab+4290ab+5940a^++12012a^-+14300a^-+15795a^+\
+25025a^++27027ab+42900ab+66560a^++75075a^++85800ab+88452a^++100100a^++104247a\
b+139776ab" ]
gap> CompareWithDatabase( "3.Suz.2", faith );

##
gap> tbl:= CharacterTable( "6.Suz" );;
gap> faith:= FaithfulCandidates( tbl, "2.Suz" );;
1:  subgroup $U_5(2) \rightarrow (Suz,4)$, degree 196560 (1 cand.)
gap> VerifyCandidates( CharacterTable( "U5(2)" ), tbl, 0, faith[1], "all" );
G = 6.Suz:  point stabilizer U5(2), ranks [ 26 ]
[ "1a+12ab+78ab+143a+364abc+924ab+1365ab+4290ab+4368ab+5940a+12012a+14300a+160\
16ab+27027ab+27456ab" ]
gap> CompareWithDatabase( "6.Suz", faith );

##
gap> tbl2:= CharacterTable( "6.Suz.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Suz.2" );;
8:  subgroup $U_5(2).2$, degree 196560 (1 cand.)
gap> VerifyCandidates( CharacterTable( "U5(2).2" ), tbl, tbl2, faith[8], "all" );
G = 6.Suz.2:  point stabilizer U5(2).2, ranks [ 16 ]
[ "1a^++12ab+78ab+143a^-+364a^+bc+924ab+1365ab+4290ab+4368ab+5940a^++12012a^-+\
14300a^-+16016ab+27027ab+27456ab" ]
gap> faith[8]:= faith[8]{ [ 1, 1 ] };;
gap> CompareWithDatabase( "6.Suz.2", faith );

##
gap> CompareWithDatabase( "Isoclinic(6.Suz.2)", [] );

##
gap> tbl:= CharacterTable( "3.ON" );;
gap> faith:= FaithfulCandidates( tbl, "ON" );;
1:  subgroup $L_3(7).2$, degree 368280 (1 cand.)
2:  subgroup $L_3(7) \leq L_3(7).2$, degree 736560 (1 cand.)
3:  subgroup $L_3(7).2$, degree 368280 (1 cand.)
4:  subgroup $L_3(7) \leq L_3(7).2$, degree 736560 (1 cand.)
gap> VerifyCandidates( CharacterTable( "L3(7).2" ), tbl, 0,
>        Concatenation( faith[1], faith[3] ), "all" );
G = 3.ON:  point stabilizer L3(7).2, ranks [ 11, 11 ]
[ "1a+495ab+10944a+26752a+32395b+52668a+58653bc+63612ab", 
  "1a+495cd+10944a+26752a+32395a+52668a+58653bc+63612ab" ]
gap> VerifyCandidates( CharacterTable( "L3(7)" ), tbl, 0,
>        Concatenation( faith[2], faith[4] ), "all" );
G = 3.ON:  point stabilizer L3(7), ranks [ 15, 15 ]
[ "1a+495ab+10944a+26752a+32395b+37696a+52668a+58653bc+63612ab+85064a+122760ab\
", 
  "1a+495cd+10944a+26752a+32395a+37696a+52668a+58653bc+63612ab+85064a+122760ab\
" ]
gap> CompareWithDatabase( "3.ON", faith );

##
gap> tbl2:= CharacterTable( "3.ON.2" );;
gap> faith:= FaithfulCandidates( tbl2, "ON.2" );;
gap> CompareWithDatabase( "3.ON.2", faith );

##
gap> tbl:= CharacterTable( "2.Fi22" );;
gap> faith:= FaithfulCandidates( tbl, "Fi22" );;
2:  subgroup $O_7(3)$, degree 28160 (2 cand.)
3:  subgroup $O_7(3)$, degree 28160 (2 cand.)
4:  subgroup $O_8^+(2):S_3$, degree 123552 (2 cand.)
5:  subgroup $O_8^+(2):3 \leq O_8^+(2):S_3$, degree 247104 (1 cand.)
6:  subgroup $O_8^+(2):2 \leq O_8^+(2):S_3$, degree 370656 (2 cand.)

##
gap> faith[2] = faith[3];
true
gap> tbl2:= CharacterTable( "2.Fi22.2" );;
gap> embed:= GetFusionMap( tbl, tbl2 );;
gap> swapped:= Filtered( InverseMap( embed ), IsList );
[ [ 3, 4 ], [ 17, 18 ], [ 25, 26 ], [ 27, 28 ], [ 33, 34 ], [ 36, 37 ], 
  [ 42, 43 ], [ 51, 52 ], [ 59, 60 ], [ 63, 65 ], [ 64, 66 ], [ 71, 72 ], 
  [ 73, 75 ], [ 74, 76 ], [ 81, 82 ], [ 85, 87 ], [ 86, 88 ], [ 89, 90 ], 
  [ 93, 94 ], [ 95, 98 ], [ 96, 97 ], [ 99, 100 ], [ 103, 104 ], 
  [ 107, 110 ], [ 108, 109 ], [ 113, 114 ] ]
gap> perm:= Product( List( swapped, pair -> ( pair[1], pair[2] ) ) );;
gap> Permuted( faith[2][1], perm ) = faith[2][2];
true
gap> VerifyCandidates( CharacterTable( "O7(3)" ), tbl, 0, faith[2], "all" );
G = 2.Fi22:  point stabilizer O7(3), ranks [ 5, 5 ]
[ "1a+352a+429a+13650a+13728b", "1a+352a+429a+13650a+13728a" ]
gap> faith[2]:= [ faith[2][1] ];;
gap> faith[3]:= [ faith[3][2] ];;

##
gap> s:= CharacterTable( "O8+(2).S3" );;
gap> s0:= CharacterTable( "O8+(2).3" );;
gap> facttbl:= CharacterTable( "Fi22" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl, "all" );
2.Fi22:  O8+(2).3.2 lifts to a direct product,
proved by squares in [ 1, 8, 10, 12, 20, 23, 30, 46, 55, 61, 91 ].
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> factfus:= GetFusionMap( tbl, facttbl );;
gap> ForAll( PossibleClassFusions( s, tbl ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( CharacterTable( "O8+(2).S3" ), tbl, 0, faith[4], "all" );
G = 2.Fi22:  point stabilizer O8+(2).3.2, ranks [ 6, 6 ]
[ "1a+3080a+13650a+13728b+45045a+48048c", 
  "1a+3080a+13650a+13728a+45045a+48048b" ]

##
gap> VerifyCandidates( CharacterTable( "O8+(2).3" ), tbl, 0, faith[5], "all" );
G = 2.Fi22:  point stabilizer O8+(2).3, ranks [ 11 ]
[ "1a+1001a+3080a+10725a+13650a+13728ab+45045a+48048bc+50050a" ]
gap> VerifyCandidates( CharacterTable( "O8+(2).2" ), tbl, 0, faith[6], "all" );
G = 2.Fi22:  point stabilizer O8+(2).2, ranks [ 11, 11 ]
[ "1a+352a+429a+3080a+13650a+13728b+45045a+48048ac+75075a+123200a", 
  "1a+352a+429a+3080a+13650a+13728a+45045a+48048ab+75075a+123200a" ]
gap> CompareWithDatabase( "2.Fi22", faith );

##
gap> tbl2:= CharacterTable( "2.Fi22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Fi22.2" );;
3:  subgroup $O_7(3)$, degree 56320 (1 cand.)
5:  subgroup $O_8^+(2):S_3 \leq O_8^+(2):S_3 \times 2$, degree 247104 (
1 cand.)
6:  subgroup $O_8^+(2):3 \times 2 \leq O_8^+(2):S_3 \times 2$, degree 247104 (
1 cand.)
10:  subgroup $O_8^+(2):2 \leq O_8^+(2):S_3 \times 2$, degree 741312 (1 cand.)
16:  subgroup ${^2F_4(2)^{\prime}}.2$, degree 7185024 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "O7(3)" ), tbl, tbl2, faith[3], "all" );
G = 2.Fi22.2:  point stabilizer O7(3), ranks [ 9 ]
[ "1a^{\\pm}+352a^{\\pm}+429a^{\\pm}+13650a^{\\pm}+13728ab" ]
gap> VerifyCandidates( CharacterTable( "O8+(2).S3" ), tbl, tbl2, faith[5], "all" );
G = 2.Fi22.2:  point stabilizer O8+(2).3.2, ranks [ 10 ]
[ "1a^{\\pm}+3080a^{\\pm}+13650a^{\\pm}+13728ab+45045a^{\\pm}+48048bc" ]
gap> VerifyCandidates( CharacterTable( "O8+(2).2" ), tbl, tbl2, faith[10], "all" );
G = 2.Fi22.2:  point stabilizer O8+(2).2, ranks [ 20 ]
[ "1a^{\\pm}+352a^{\\pm}+429a^{\\pm}+3080a^{\\pm}+13650a^{\\pm}+13728ab+45045a\
^{\\pm}+48048a^{\\pm}bc+75075a^{\\pm}+123200a^{\\pm}" ]

##
gap> tbl2:= CharacterTable( "2.Fi22.2" );;
gap> facttbl:= CharacterTable( "Fi22.2" );;
gap> tblMbar:= CharacterTable( "O8+(2).S3" ) * CharacterTable( "Cyclic", 2 );;
gap> piMbar:= PossiblePermutationCharacters( tblMbar, facttbl );
[ Character( CharacterTable( "Fi22.2" ),
  [ 61776, 6336, 656, 288, 666, 216, 36, 27, 40, 76, 16, 12, 20, 1, 36, 72, 
      8, 26, 18, 36, 24, 12, 8, 6, 3, 1, 4, 8, 0, 2, 6, 3, 0, 1, 1, 0, 4, 10, 
      4, 4, 0, 0, 4, 2, 4, 3, 0, 1, 1, 0, 0, 3, 2, 1, 1, 0, 2, 4, 1, 1576, 
      216, 316, 168, 56, 36, 32, 4, 46, 64, 10, 16, 10, 30, 10, 1, 9, 6, 4, 
      4, 8, 0, 6, 1, 1, 1, 24, 6, 6, 6, 8, 6, 6, 0, 2, 1, 1, 1, 0, 4, 1, 1, 
      0, 1, 4, 2, 0, 0, 0, 1, 1, 0, 1 ] ) ]
gap> piM:= piMbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> tblNbar:= CharacterTable( "O8+(2).3" ) * CharacterTable( "Cyclic", 2 );;
gap> piNbar:= PossiblePermutationCharacters( tblNbar, facttbl );
[ Character( CharacterTable( "Fi22.2" ),
  [ 123552, 0, 1312, 192, 1332, 432, 72, 54, 80, 0, 0, 24, 16, 2, 0, 0, 16, 
      52, 0, 48, 0, 24, 16, 0, 6, 2, 4, 4, 0, 0, 12, 6, 0, 0, 2, 0, 8, 20, 8, 
      0, 0, 0, 0, 4, 0, 6, 0, 0, 2, 0, 0, 0, 4, 0, 2, 0, 4, 4, 0, 3152, 432, 
      0, 48, 80, 48, 0, 8, 92, 128, 20, 0, 20, 60, 0, 2, 18, 12, 0, 4, 4, 0, 
      0, 2, 0, 2, 24, 12, 12, 0, 8, 12, 0, 0, 0, 2, 2, 0, 0, 8, 2, 0, 0, 0, 
      4, 4, 0, 0, 0, 2, 0, 0, 2 ] ) ]
gap> piN:= piNbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> tblU:= CharacterTable( "O8+(2).3" );;
gap> piU:= PossiblePermutationCharacters( tblU, tbl2 );
[ Character( CharacterTable( "2.Fi22.2" ),
  [ 494208, 0, 0, 4608, 640, 384, 5328, 0, 1728, 0, 288, 0, 216, 0, 160, 0, 
      0, 96, 0, 32, 8, 0, 0, 0, 0, 64, 96, 112, 0, 96, 0, 0, 96, 48, 16, 0, 
      0, 24, 8, 0, 8, 8, 0, 0, 48, 0, 24, 0, 0, 0, 0, 8, 0, 0, 0, 16, 64, 16, 
      16, 0, 0, 0, 0, 0, 0, 8, 0, 24, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 16, 0, 
      8, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> ProofOfD8Factor( tbl2, piU[1], piM, piN );
[ [ 91, 101, 104, 110, 114, 116, 124, 130, 135, 138, 146 ], [ 3 ] ]

##
gap> s:= CharacterTable( "O8+(2).3" ) * CharacterTable( "Cyclic", 2 );;
gap> VerifyCandidates( s, tbl, tbl2, faith[6], "extending" );
G = 2.Fi22.2:  point stabilizer O8+(2).3xC2, ranks [ 9 ]
[ "1a^++1001a^-+3080a^++10725a^++13650a^++13728ab+45045a^++48048bc+50050a^+" ]

##
gap> facttbl:= CharacterTable( "Fi22.2" );;
gap> s0:= CharacterTable( "2F4(2)'" );;
gap> s:= CharacterTable( "2F4(2)" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "all" );
2.Fi22.2:  2F4(2)'.2 lifts to a direct product,
proved by squares in [ 5, 38, 53 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[16], "all" );
G = 2.Fi22.2:  point stabilizer 2F4(2)'.2, ranks [ 13 ]
[ "1a^++1001a^++1430a^++13650a^++30030a^++133056a^{\\pm}+289575a^-+400400ab+57\
9150a^++675675a^-+1201200a^-+1663200ab" ]
gap> faith[16]:= faith[16]{ [ 1, 1 ] };;
gap> CompareWithDatabase( "2.Fi22.2", faith );

##
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "Fi22.2" );;
3:  subgroup $O_7(3)$, degree 56320 (1 cand.)
5:  subgroup $O_8^+(2):S_3 \leq O_8^+(2):S_3 \times 2$, degree 247104 (
1 cand.)
7:  subgroup $O_8^+(2):S_3 \leq O_8^+(2):S_3 \times 2$, degree 247104 (
1 cand.)
10:  subgroup $O_8^+(2):2 \leq O_8^+(2):S_3 \times 2$, degree 741312 (1 cand.)
11:  subgroup $O_8^+(2):2 \leq O_8^+(2):S_3 \times 2$, degree 741312 (1 cand.)

##
gap> tblU:= CharacterTable( "O8+(2).3" );;
gap> tblNbar:= CharacterTable( "O8+(2).S3" );;
gap> CheckConditionsForLemma3( tblU, tblNbar, facttbl, tbl2, "extending" );
Isoclinic(2.Fi22.2):  O8+(2).3.2 lifts to a direct product,
proved by squares in [ 1, 7, 9, 11, 18, 21, 26, 39, 47, 52, 73 ].

##
gap> tblNbar:= CharacterTable( "O8+(2).S3" );;
gap> piNbar:= PossiblePermutationCharacters( tblNbar, facttbl );
[ Character( CharacterTable( "Fi22.2" ),
  [ 123552, 0, 1312, 192, 1332, 432, 72, 54, 80, 0, 0, 24, 16, 2, 0, 0, 16, 
      52, 0, 48, 0, 24, 16, 0, 6, 2, 4, 4, 0, 0, 12, 6, 0, 0, 2, 0, 8, 20, 8, 
      0, 0, 0, 0, 4, 0, 6, 0, 0, 2, 0, 0, 0, 4, 0, 2, 0, 4, 4, 0, 0, 0, 632, 
      288, 32, 24, 64, 0, 0, 0, 0, 32, 0, 0, 20, 0, 0, 0, 8, 4, 12, 0, 12, 0, 
      2, 0, 24, 0, 0, 12, 8, 0, 12, 0, 4, 0, 0, 2, 0, 0, 0, 2, 0, 2, 4, 0, 0, 
      0, 0, 0, 2, 0, 0 ] ), Character( CharacterTable( "Fi22.2" ),
  [ 123552, 12672, 1312, 576, 1332, 432, 72, 54, 80, 152, 32, 24, 40, 2, 72, 
      144, 16, 52, 36, 72, 48, 24, 16, 12, 6, 2, 8, 16, 0, 4, 12, 6, 0, 2, 2, 
      0, 8, 20, 8, 8, 0, 0, 8, 4, 8, 6, 0, 2, 2, 0, 0, 6, 4, 2, 2, 0, 4, 8, 
      2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0 ] ) ]
gap> piN:= piNbar[1]{ GetFusionMap( tbl2, facttbl ) };;
gap> ProofOfD8Factor( tbl2, piU[1], piM, piN );
[ [ 89, 90, 97, 98, 99, 100, 102, 103, 105, 106, 107, 108, 109, 115, 117, 
      119, 127, 128, 129, 132, 133, 134, 145, 149, 150 ], [ 3 ] ]

##
gap> s0:= CharacterTable( "O8+(2).3" );;
gap> s:= CharacterTable( "O8+(2).S3" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl2, "extending" );
Isoclinic(2.Fi22.2):  O8+(2).3.2 lifts to a direct product,
proved by squares in [ 1, 7, 9, 11, 18, 21, 26, 39, 47, 52, 73 ].
gap> VerifyCandidates( s, tbl, tbl2, faith[7], "extending" );
G = Isoclinic(2.Fi22.2):  point stabilizer O8+(2).3.2, ranks [ 9 ]
[ "1a^++1001a^++3080a^++10725a^-+13650a^++13728ab+45045a^++48048bc+50050a^-" ]

##
gap> s:= CharacterTable( "O8+(2).2" );;
gap> VerifyCandidates( s, tbl, tbl2, faith[11], "extending" );
G = Isoclinic(2.Fi22.2):  point stabilizer O8+(2).2, ranks [ 19 ]
[ "1a^++352a^{\\pm}+429a^{\\pm}+1001a^++3080a^++10725a^-+13650a^++13728ab+4504\
5a^++48048a^{\\pm}bc+50050a^-+75075a^{\\pm}+123200a^{\\pm}" ]
gap> CompareWithDatabase( "Isoclinic(2.Fi22.2)", faith );

##
gap> tbl:= CharacterTable( "3.Fi22" );;
gap> faith:= FaithfulCandidates( tbl, "Fi22" );;
4:  subgroup $O_8^+(2):S_3$, degree 185328 (1 cand.)
5:  subgroup $O_8^+(2):3 \leq O_8^+(2):S_3$, degree 370656 (2 cand.)
6:  subgroup $O_8^+(2):2 \leq O_8^+(2):S_3$, degree 555984 (1 cand.)
8:  subgroup $2^6:S_6(2)$, degree 2084940 (1 cand.)
9:  subgroup ${^2F_4(2)^{\prime}}$, degree 10777536 (1 cand.)

##
gap> VerifyCandidates( CharacterTable( "O8+(2).S3" ), tbl, 0, faith[4], "all" );
G = 3.Fi22:  point stabilizer O8+(2).3.2, ranks [ 10 ]
[ "1a+351ab+3080a+13650a+19305ab+42120ab+45045a" ]
gap> s:= CharacterTable( "O8+(2).3" );;
gap> fus:= PossibleClassFusions( s, tbl );;
gap> facttbl:= CharacterTable( "Fi22" );;
gap> factfus:= GetFusionMap( tbl, facttbl );;
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( s ) ],
>                ClassPositionsOfDerivedSubgroup( s ) );;
gap> outerfus:= List( fus, map -> map{ outer } );
[ [ 13, 13, 18, 18, 46, 46, 50, 50, 59, 59, 75, 75, 95, 95, 98, 98, 95, 95, 
      116, 116, 142, 142, 148, 148, 157, 157, 160, 160 ], 
  [ 14, 15, 18, 18, 47, 48, 51, 52, 59, 59, 76, 77, 96, 97, 99, 100, 96, 97, 
      116, 116, 143, 144, 149, 150, 158, 159, 161, 162 ], 
  [ 15, 14, 18, 18, 48, 47, 52, 51, 59, 59, 77, 76, 97, 96, 100, 99, 97, 96, 
      116, 116, 144, 143, 150, 149, 159, 158, 162, 161 ] ]
gap> preim:= InverseMap( factfus )[5];
[ 13, 14, 15 ]
gap> List( outerfus, x -> List( preim, i -> i in x ) );
[ [ true, false, false ], [ false, true, true ], [ false, true, true ] ]
gap> VerifyCandidates( s, tbl, 0, faith[5], "all" );
G = 3.Fi22:  point stabilizer O8+(2).3, ranks [ 11, 17 ]
[ "1a+1001a+3080a+10725a+13650a+27027ab+45045a+50050a+96525ab", 
  "1a+351ab+1001a+3080a+7722ab+10725a+13650a+19305ab+42120ab+45045a+50050a+540\
54ab" ]
gap> VerifyCandidates( CharacterTable( "O8+(2).2" ), tbl, 0, faith[6], "all" );
G = 3.Fi22:  point stabilizer O8+(2).2, ranks [ 17 ]
[ "1a+351ab+429a+3080a+13650a+19305ab+27027ab+42120ab+45045a+48048a+75075a+965\
25ab" ]

##
gap> VerifyCandidates( CharacterTable( "2^6:s6f2" ), tbl, 0, faith[8], "all" );
G = 3.Fi22:  point stabilizer 2^6:s6f2, ranks [ 24 ]
[ "1a+351ab+429a+1430a+3080a+13650a+19305ab+27027ab+30030a+42120ab+45045a+7507\
5a+96525ab+123552ab+205920a+320320a+386100ab" ]
gap> VerifyCandidates( CharacterTable( "2F4(2)'" ), tbl, 0, faith[9], "all" );
G = 3.Fi22:  point stabilizer 2F4(2)', ranks [ 25 ]
[ "1a+1001a+1430a+13650a+19305ab+27027ab+30030a+51975ab+289575a+386100ab+40040\
0ab+405405ab+579150a+675675a+1201200a+1351350efgh" ]
gap> CompareWithDatabase( "3.Fi22", faith );

##
gap> tbl2:= CharacterTable( "3.Fi22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Fi22.2" );;
4:  subgroup $O_8^+(2):S_3 \times 2$, degree 185328 (1 cand.)
6:  subgroup $O_8^+(2):3 \times 2 \leq O_8^+(2):S_3 \times 2$, degree 370656 (
1 cand.)
7:  subgroup $O_8^+(2):S_3 \leq O_8^+(2):S_3 \times 2$, degree 370656 (
2 cand.)
8:  subgroup $O_8^+(2):2 \times 2 \leq O_8^+(2):S_3 \times 2$, degree 555984 (
1 cand.)
9:  subgroup $O_8^+(2):3 \leq O_8^+(2):S_3 \times 2$, degree 741312 (1 cand.)
14:  subgroup $2^7:S_6(2)$, degree 2084940 (1 cand.)
16:  subgroup ${^2F_4(2)^{\prime}}.2$, degree 10777536 (1 cand.)

##
gap> s:= CharacterTable( "O8+(2).S3" ) * CharacterTable( "Cyclic", 2 );;
gap> VerifyCandidates( s, tbl, tbl2, faith[4], "all" );
G = 3.Fi22.2:  point stabilizer O8+(2).3.2xC2, ranks [ 7 ]
[ "1a^++351ab+3080a^++13650a^++19305ab+42120ab+45045a^+" ]
gap> s:= CharacterTable( "O8+(2).3" ) * CharacterTable( "Cyclic", 2 );;
gap> VerifyCandidates( s, tbl, tbl2, faith[6], "all" );
G = 3.Fi22.2:  point stabilizer O8+(2).3xC2, ranks [ 12 ]
[ "1a^++351ab+1001a^-+3080a^++7722ab+10725a^++13650a^++19305ab+42120ab+45045a^\
++50050a^++54054ab" ]
gap> s:= CharacterTable( "O8+(2).2" ) * CharacterTable( "Cyclic", 2 );;
gap> VerifyCandidates( s, tbl, tbl2, faith[8], "all" );
G = 3.Fi22.2:  point stabilizer O8+(2).2xC2, ranks [ 12 ]
[ "1a^++351ab+429a^++3080a^++13650a^++19305ab+27027ab+42120ab+45045a^++48048a^\
++75075a^++96525ab" ]

##
gap> s:= CharacterTable( "O8+(2).S3" );;
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> facttbl:= CharacterTable( "Fi22.2" );;
gap> sfustbl2:= PossibleClassFusions( s, tbl2,
>        rec( permchar:= faith[7][1] ) );;
gap> ForAll( sfustbl2,
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, tbl2, faith[7], "extending" );
G = 3.Fi22.2:  point stabilizer O8+(2).3.2, ranks [ 9, 12 ]
[ "1a^++1001a^++3080a^++10725a^-+13650a^++27027ab+45045a^++50050a^-+96525ab", 
  "1a^++351ab+1001a^++3080a^++7722ab+10725a^-+13650a^++19305ab+42120ab+45045a^\
++50050a^-+54054ab" ]

##
gap> VerifyCandidates( CharacterTable( "O8+(2).3" ), tbl, tbl2, faith[9], "all" );
G = 3.Fi22.2:  no O8+(2).3
gap> faith[9]:= [];;

##
gap> VerifyCandidates( CharacterTable( "2^7:S6(2)" ), tbl, tbl2, faith[14], "all" );
G = 3.Fi22.2:  point stabilizer 2^7:S6(2), ranks [ 17 ]
[ "1a^++351ab+429a^++1430a^++3080a^++13650a^++19305ab+27027ab+30030a^++42120ab\
+45045a^++75075a^++96525ab+123552ab+205920a^++320320a^++386100ab" ]
gap> VerifyCandidates( CharacterTable( "2F4(2)" ), tbl, tbl2, faith[16], "all" );
G = 3.Fi22.2:  point stabilizer 2F4(2)'.2, ranks [ 17 ]
[ "1a^++1001a^++1430a^++13650a^++19305ab+27027ab+30030a^++51975ab+289575a^-+38\
6100ab+400400ab+405405ab+579150a^++675675a^-+1201200a^-+1351350efgh" ]
gap> CompareWithDatabase( "3.Fi22.2", faith );

##
gap> tbl:= CharacterTable( "6.Fi22" );;
gap> facttbl:= CharacterTable( "3.Fi22" );;
gap> faith:= FaithfulCandidates( tbl, "3.Fi22" );;
1:  subgroup $O_8^+(2):S_3 \rightarrow (Fi_{22},4)$, degree 370656 (2 cand.)
2:  subgroup $O_8^+(2):3 \rightarrow (Fi_{22},5)$, degree 741312 (1 cand.)
3:  subgroup $O_8^+(2):3 \rightarrow (Fi_{22},5)$, degree 741312 (1 cand.)
4:  subgroup $O_8^+(2):2 \rightarrow (Fi_{22},6)$, degree 1111968 (2 cand.)

##
gap> s:= CharacterTable( "O8+(2).S3" );;
gap> s0:= CharacterTable( "O8+(2).3" );;
gap> CheckConditionsForLemma3( s0, s, facttbl, tbl, "all" );       
6.Fi22:  O8+(2).3.2 lifts to a direct product,
proved by squares in [ 1, 22, 28, 30, 46, 55, 76, 104, 131, 141, 215 ].
gap> derpos:= ClassPositionsOfDerivedSubgroup( s );;
gap> factfus:= GetFusionMap( tbl, facttbl );; 
gap> ForAll( PossibleClassFusions( s, tbl ),
>        map -> NecessarilyDifferentPermChars( map, factfus, derpos ) );
true
gap> VerifyCandidates( s, tbl, 0, faith[1], "all" );
G = 6.Fi22:  point stabilizer O8+(2).3.2, ranks [ 14, 14 ]
[ "1a+351ab+3080a+13650a+13728b+19305ab+42120ab+45045a+48048c+61776cd", 
  "1a+351ab+3080a+13650a+13728a+19305ab+42120ab+45045a+48048b+61776ab" ]

##
gap> VerifyCandidates( CharacterTable( "O8+(2).3" ), tbl, 0,
>        Concatenation( faith[2], faith[3] ), "all" );
G = 6.Fi22:  point stabilizer O8+(2).3, ranks [ 17, 25 ]
[ "1a+1001a+3080a+10725a+13650a+13728ab+27027ab+45045a+48048bc+50050a+96525ab+\
123552cd", 
  "1a+351ab+1001a+3080a+7722ab+10725a+13650a+13728ab+19305ab+42120ab+45045a+48\
048bc+50050a+54054ab+61776abcd" ]

##
gap> VerifyCandidates( CharacterTable( "O8+(2).2" ), tbl, 0, faith[4], "all" );
G = 6.Fi22:  point stabilizer O8+(2).2, ranks [ 25, 25 ]
[ "1a+351ab+352a+429a+3080a+13650a+13728b+19305ab+27027ab+42120ab+45045a+48048\
ac+61776cd+75075a+96525ab+123200a+123552cd", 
  "1a+351ab+352a+429a+3080a+13650a+13728a+19305ab+27027ab+42120ab+45045a+48048\
ab+61776ab+75075a+96525ab+123200a+123552cd" ]
gap> CompareWithDatabase( "6.Fi22", faith );

##
gap> tbl2:= CharacterTable( "6.Fi22.2" );;
gap> faith:= FaithfulCandidates( tbl2, "Fi22.2" );;
6:  subgroup $O_8^+(2):3 \times 2 \leq O_8^+(2):S_3 \times 2$, degree 741312 (
1 cand.)
16:  subgroup ${^2F_4(2)^{\prime}}.2$, degree 21555072 (1 cand.)

##
gap> s:= CharacterTable( "O8+(2).3" ) * CharacterTable( "Cyclic", 2 );;
gap> VerifyCandidates( s, tbl, tbl2, faith[6], "extending" );
G = 6.Fi22.2:  point stabilizer O8+(2).3xC2, ranks [ 16 ]
[ "1a^++351ab+1001a^-+3080a^++7722ab+10725a^++13650a^++13728ab+19305ab+42120ab\
+45045a^++48048bc+50050a^++54054ab+61776abcd" ]

##
gap> VerifyCandidates( CharacterTable( "2F4(2)" ), tbl, tbl2, faith[16], "all" );
G = 6.Fi22.2:  point stabilizer 2F4(2)'.2, ranks [ 22 ]
[ "1a^++1001a^++1430a^++13650a^++19305ab+27027ab+30030a^++51975ab+133056a^{\\p\
m}+289575a^-+386100ab+400400ab+405405ab+579150a^++675675a^-+1201200a^-+1351350\
efgh+1663200ab+1796256abcd" ]
gap> faith[16]:= faith[16]{ [ 1, 1 ] };;
gap> CompareWithDatabase( "6.Fi22.2", faith );

##
gap> facttbl:= CharacterTable( "Fi22.2" );;
gap> tbl2:= IsoclinicTable( tbl, tbl2, facttbl );;
gap> faith:= FaithfulCandidates( tbl2, "Fi22.2" );;
7:  subgroup $O_8^+(2):S_3 \leq O_8^+(2):S_3 \times 2$, degree 741312 (
2 cand.)

##
gap> s:= CharacterTable( "O8+(2).S3" ) * CharacterTable( "Cyclic", 6 );;
gap> fact:= s / ClassPositionsOfSolvableResiduum( s );;
gap> Size( fact );
36
gap> OrdersClassRepresentatives( fact );
[ 1, 6, 3, 2, 3, 6, 3, 6, 3, 6, 3, 6, 2, 6, 6, 2, 6, 6 ]
gap> SizesCentralizers( fact );
[ 36, 36, 36, 36, 36, 36, 18, 18, 18, 18, 18, 18, 12, 12, 12, 12, 12, 12 ]
gap> ind:= InducedCyclic( fact, [ 7, 9, 11 ] );;
gap> List( ind, ValuesOfClassFunction );
[ [ 12, 0, 0, 0, 0, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 0, 0, 0 ], 
  [ 12, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]

##
gap> rest:= RestrictedClassFunctions( ind, s );;
gap> fus:= PossibleClassFusions( s, tbl );;
gap> Length( fus );
4
gap> ind:= Set( List( fus, map -> Induced( s, tbl, rest, map ) ) );;
gap> Length( ind );
1
gap> rest:= RestrictedClassFunctions( faith[7], tbl );;
gap> List( ind[1], pi -> Position( rest, pi ) );
[ 1, 2 ]

##
gap> s:= CharacterTable( "O8+(2).S3" );;
gap> VerifyCandidates( s, tbl, tbl2, faith[7], "extending" );
G = Isoclinic(6.Fi22.2):  point stabilizer O8+(2).3.2, ranks [ 12, 16 ]
[ "1a^++1001a^++3080a^++10725a^-+13650a^++13728ab+27027ab+45045a^++48048bc+500\
50a^-+96525ab+123552cd", 
  "1a^++351ab+1001a^++3080a^++7722ab+10725a^-+13650a^++13728ab+19305ab+42120ab\
+45045a^++48048bc+50050a^-+54054ab+61776abcd" ]
gap> faith[7]:= faith[7]{ [ 1, 1, 2 ] };;
gap> CompareWithDatabase( "Isoclinic(6.Fi22.2)", faith );

##
gap> tbl:= CharacterTable( "2.Co1" );;
gap> faith:= FaithfulCandidates( tbl, "Co1" );;
1:  subgroup $Co_2$, degree 196560 (1 cand.)
5:  subgroup $Co_3$, degree 16773120 (1 cand.)
gap> VerifyCandidates( CharacterTable( "Co2" ), tbl, 0, faith[1], "all" );
G = 2.Co1:  point stabilizer Co2, ranks [ 7 ]
[ "1a+24a+299a+2576a+17250a+80730a+95680a" ]
gap> VerifyCandidates( CharacterTable( "Co3" ), tbl, 0, faith[5], "all" );
G = 2.Co1:  point stabilizer Co3, ranks [ 12 ]
[ "1a+24a+299a+2576a+17250a+80730a+95680a+376740a+1841840a+2417415a+5494125a+6\
446440a" ]
gap> CompareWithDatabase( "2.Co1", faith );

##
gap> tbl:= CharacterTable( "3.F3+" );;
gap> faith:= FaithfulCandidates( tbl, "F3+" );;
1:  subgroup $Fi_{23}$, degree 920808 (1 cand.)
2:  subgroup $O_{10}^-(2)$, degree 150532080426 (1 cand.)
gap> VerifyCandidates( CharacterTable( "Fi23" ), tbl, 0, faith[1], "all" );
G = 3.F3+:  point stabilizer Fi23, ranks [ 7 ]
[ "1a+783ab+57477a+249458a+306153ab" ]
gap> VerifyCandidates( CharacterTable( "O10-(2)" ), tbl, 0, faith[2], "all" );
G = 3.F3+:  point stabilizer O10-(2), ranks [ 43 ]
[ "1a+783ab+8671a+57477a+64584ab+249458a+306153ab+555611a+1666833a+6724809ab+1\
9034730ab+35873145a+43779879ab+48893768a+79452373a+195019461ab+203843871ab+415\
098112a+1050717096ab+1264015025a+1540153692a+1818548820ab+2346900864a+32086535\
25a+10169903744a+10726070355ab+13904165275a+15016498497ab+17161712568a+2109675\
1104ab" ]
gap> CompareWithDatabase( "3.F3+", faith );

##
gap> tbl2:= CharacterTable( "3.F3+.2" );;
gap> faith:= FaithfulCandidates( tbl2, "F3+.2" );;
1:  subgroup $Fi_{23} \times 2$, degree 920808 (1 cand.)
3:  subgroup $O_{10}^-(2).2$, degree 150532080426 (1 cand.)
gap> VerifyCandidates( CharacterTable( "2xFi23" ), tbl, tbl2, faith[1], "all" );
G = 3.F3+.2:  point stabilizer 2xFi23, ranks [ 5 ]
[ "1a^++783ab+57477a^++249458a^++306153ab" ]
gap> VerifyCandidates( CharacterTable( "O10-(2).2" ), tbl, tbl2, faith[3], "all" );
G = 3.F3+.2:  point stabilizer O10-(2).2, ranks [ 30 ]
[ "1a^++783ab+8671a^-+57477a^++64584ab+249458a^++306153ab+555611a^-+1666833a^+\
+6724809ab+19034730ab+35873145a^++43779879ab+48893768a^-+79452373a^++195019461\
ab+203843871ab+415098112a^-+1050717096ab+1264015025a^++1540153692a^++181854882\
0ab+2346900864a^-+3208653525a^++10169903744a^-+10726070355ab+13904165275a^++15\
016498497ab+17161712568a^++21096751104ab" ]
gap> CompareWithDatabase( "3.F3+.2", faith );

##
gap> tbl:= CharacterTable( "2.B" );;
gap> faith:= FaithfulCandidates( tbl, "B" );;
4:  subgroup $Fi_{23}$, degree 2031941058560000 (1 cand.)
gap> VerifyCandidates( CharacterTable( "Fi23" ), tbl, 0, faith[4], "all" );
G = 2.B:  point stabilizer Fi23, ranks [ 34 ]
[ "1a+4371a+96255a+96256a+9458750a+10506240a+63532485a+347643114a+356054375a+4\
10132480a+4221380670a+4275362520a+8844386304a+9287037474a+13508418144a+3665765\
3760a+108348770530a+309720864375a+635966233056a+864538761216a+1095935366250a+4\
322693806080a+6145833622500a+6619124890560a+10177847623680a+12927978301875a+38\
348970335820a+60780833777664a+89626740328125a+110949141022720a+211069033500000\
a+284415522641250b+364635285437500a+828829551513600a" ]
gap> CompareWithDatabase( "2.B", faith );

##
gap> tbl:= CharacterTable( "2.M22" );;
gap> PossibleClassFusions( CharacterTable( "2.A6" ), tbl );
[  ]

##
gap> info:= OneAtlasGeneratingSetInfo( "2.M22", NrMovedPoints, 352 );;
gap> gens:= AtlasGenerators( info.identifier );;
gap> slp:= AtlasStraightLineProgram( "M22", "maxes", 2 );;
gap> sgens:= ResultOfStraightLineProgram( slp.program, gens.generators );;
gap> s:= Group( sgens );;  Size( s );
11520
gap> 2^5 * 360;
11520

##
gap> orbs:= Orbits( s, MovedPoints( s ) );;           
gap> List( orbs, Length );             
[ 160, 192 ]
gap> s:= Action( s, orbs[2] );;
gap> Size( s );       
11520
gap> syl2:= SylowSubgroup( s, 2 );;
gap> repeat
>   x:= Random( syl2 );                      
>   n:= NormalClosure( s, SubgroupNC( s, [ x ] ) );
> until Size( n ) = 32; 

##
gap> stab:= Stabilizer( s, 192 );;
gap> sub:= ClosureGroup( n, stab );;
gap> Size( sub );
1920
gap> Set( List( Elements( n ),
>         x -> Size( NormalClosure( sub, SubgroupNC( sub, [ x ] ) ) ) ) );
[ 1, 2, 32 ]

##
gap> syl3:= SylowSubgroup( s, 3 );;
gap> repeat three:= Random( stab ); until Order( three ) = 3;
gap> repeat other:= Random( syl3 );
>        until Order( other ) = 3 and not IsConjugate( s, three, other );
gap> syl5:= SylowSubgroup( s, 5 );;
gap> repeat y:= Random( syl5 )^Random( s ); until Order( other*y ) = 2;
gap> a5:= Group( other, y );;
gap> IsConjugate( s, a5, stab );
false
gap> sub:= ClosureGroup( n, a5 );;
gap> Size( sub );
1920
gap> Set( List( Elements( n ),
>         x -> Size( NormalClosure( sub, SubgroupNC( sub, [ x ] ) ) ) ) );
[ 1, 2, 16, 32 ]

##
gap> g:= First( Elements( n ), 
>       x -> Size( NormalClosure( sub, SubgroupNC( sub, [ x ] ) ) ) = 16 );;
gap> compl:= ClosureGroup( a5, g );;             
gap> Size( compl );
960
gap> tbl:= CharacterTable( compl );;
gap> IsRecord( TransformingPermutationsCharacterTables( tbl,
>        CharacterTable( "P1/G1/L1/V1/ext2" ) ) );
true

##
gap> info:= OneAtlasGeneratingSetInfo( "HS.2", NrMovedPoints, 100 );;
gap> gens:= AtlasGenerators( info.identifier );;
gap> stab:= Stabilizer( Group( gens.generators ), 100 );;
gap> orbs:= Orbits( stab, MovedPoints( stab ) );;
gap> List( orbs, Length );
[ 77, 22 ]
gap> pnt:= First( orbs, x -> Length( x ) = 77 )[1];;
gap> m:= Stabilizer( stab, pnt );;
gap> Size( m );
11520

##
gap> orbs:= Orbits( m, MovedPoints( m ) );;
gap> List( orbs, Length );
[ 60, 16, 6, 16 ]
gap> six:= First( orbs, x -> Length( x ) = 6 );;
gap> p:= ( six[1], six[2] )( six[3], six[4] )( six[5], six[6] );;
gap> conj:= ( six[2], six[4], six[5], six[6], six[3] );;
gap> total:= List( [ 0 .. 4 ], i -> p^( conj^i ) );;
gap> stab1:= Stabilizer( m, six[1] );;
gap> stab2:= Stabilizer( m, Set( total ), OnSets );;
gap> IsConjugate( m, stab1, stab2 );
false

##
gap> s1:= CharacterTable( stab1 );;
gap> s2:= CharacterTable( stab2 );;
gap> NrConjugacyClasses( s1 );  NrConjugacyClasses( s2 );
12
18
gap> lib1:= CharacterTable( "2^4:s5" );;
gap> IsRecord( TransformingPermutationsCharacterTables( lib1, s1 ) );
true
gap> lib2:= CharacterTable( "w(d5)" );;                              
gap> IsRecord( TransformingPermutationsCharacterTables( lib2, s2 ) );
true

##
gap> tbl:= CharacterTable( "M22" );;
gap> tbl2:= CharacterTable( "M22.2" );;
gap> pi:= PossiblePermutationCharacters( s1, tbl2 );
[ Character( CharacterTable( "M22.2" ),
  [ 462, 30, 12, 2, 2, 2, 0, 0, 0, 0, 0, 56, 0, 0, 12, 2, 2, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M22.2" ),
  [ 462, 46, 12, 6, 6, 2, 4, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> PermCharInfoRelative( tbl, tbl2, pi ).ATLAS;
[ "1a^++21(a^+)^{2}+55a^++154a^++210a^+", 
  "1a^{\\pm}+21a^{\\pm}+55a^{\\pm}+154a^{\\pm}" ]

##
gap> pi:= PossiblePermutationCharacters( s2, tbl2 );
[ Character( CharacterTable( "M22.2" ),
  [ 462, 30, 3, 2, 2, 2, 3, 0, 0, 0, 0, 28, 20, 4, 8, 1, 2, 0, 1, 0, 0 ] ) ]
gap> PermCharInfoRelative( tbl, tbl2, pi ).ATLAS;
[ "1a^++21a^++55a^++154a^++231a^-" ]

##
gap> id_d8:= IdGroup( DihedralGroup( 8 ) );;                                 
gap> id_2xs3:= IdGroup( DirectProduct( CyclicGroup(2), SymmetricGroup(3) ) );;
gap> id_6xs3:= IdGroup( DirectProduct( CyclicGroup(6), SymmetricGroup(3) ) );;
gap> grps:= AllSmallGroups( Size, 72,                                    
>               g -> IdGroup( SylowSubgroup( g, 2 ) ) = id_d8 and 
>                    ForAny( NormalSubgroups( g ),
>                            n -> IdGroup( n ) = id_6xs3 ) and
>                    ForAll( AbelianInvariants(g), IsEvenInt ), true );
[ <pc group of size 72 with 5 generators>, 
  <pc group of size 72 with 5 generators> ]
gap> List( grps, IdGroup );
[ [ 72, 22 ], [ 72, 23 ] ]
gap> is_good_1:= function( R, N )
>    return Size( R ) = 6 and IsCyclic( R ) and
>           Size( Intersection( R, Centre( N ) ) ) = 1;
> end;;
gap> is_good_2:= function( R, N )
>    return Size( R ) = 6 and not IsCyclic( R ) and
>           not IsSubset( N, R ) and
>           Size( Intersection( R, Centre( N ) ) ) = 1;
> end;;
gap> cand:= Filtered( NormalSubgroups( grps[1] ),
>                     n -> IdGroup( n ) = id_6xs3 );;
gap> classreps:= List( ConjugacyClassesSubgroups( grps[1] ),
>                      Representative );;
gap> List( cand, N -> Number( classreps, R -> is_good_1( R, N ) ) );
[ 1, 1 ]
gap> List( cand, N -> Number( classreps, R -> is_good_2( R, N ) ) );
[ 0, 0 ]
gap> cand:= Filtered( NormalSubgroups( grps[2] ),
>                     n -> IdGroup( n ) = id_6xs3 );;
gap> classreps:= List( ConjugacyClassesSubgroups( grps[2] ),
>                      Representative );;
gap> List( cand, N -> Number( classreps, R -> is_good_1( R, N ) ) );
[ 0 ]
gap> List( cand, N -> Number( classreps, R -> is_good_2( R, N ) ) );
[ 3 ]
gap> N:= cand[1];;
gap> subs:= Filtered( classreps, R -> is_good_2( R, N ) );;
gap> syl3:= List( subs, x -> SylowSubgroup( x, 3 ) );;
gap> Length( Set( syl3 ) );
3
gap> Number( syl3, x -> IsNormal( N, x ) );
1

##
gap> STOP_TEST( "multfre2.tst" );

#############################################################################
##
#E

