# This file was created automatically, do not edit!
#############################################################################
##
#W  o8p2s3_o8p5s3.tst       GAP 4 package CTblLib               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "o8p2s3_o8p5s3.tst" );'.
##  
gap> LoadPackage( "CTblLib", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "o8p2s3_o8p5s3.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc2/o8p2s3_o8p5s3.xml (141-156)
gap> rootvectors:= [];;
gap> for i in Combinations( [ 1 .. 8 ], 2 ) do
>      v:= 0 * [ 1 .. 8 ];
>      v{i}:= [ 1, 1 ];
>      Add( rootvectors, v );
>      v:= 0 * [ 1 .. 8 ];
>      v{i}:= [ 1, -1 ];
>      Add( rootvectors, v );
>    od;
gap> Append( rootvectors,
>      1/2 * Filtered( Tuples( [ -1, 1 ], 8 ),
>              x -> x[1] = 1 and Number( x, y -> y = 1 ) mod 2 = 0 ) );
gap> we8:= Group( List( rootvectors, ReflectionMat ) );
<matrix group with 120 generators>

##  doc2/o8p2s3_o8p5s3.xml (170-174)
gap> I:= IdentityMat( 8 );;
gap> ForAll( GeneratorsOfGroup( we8 ), x -> x * TransposedMat(x) = I );
true

##  doc2/o8p2s3_o8p5s3.xml (186-197)
gap> largegroup:= GO(1,8,5);;
gap> Display( InvariantBilinearForm( largegroup ).matrix );
 . 1 . . . . . .
 1 . . . . . . .
 . . 2 . . . . .
 . . . 2 . . . .
 . . . . 2 . . .
 . . . . . 2 . .
 . . . . . . 2 .
 . . . . . . . 2

##  doc2/o8p2s3_o8p5s3.xml (208-218)
gap> T:= [ [ 1, 2 ], [ 4, 2 ] ] * One( GF(5) );;
gap> Display( 2 * T * TransposedMat( T ) );
 . 1
 1 .
gap> I:= IdentityMat( 8, GF(5) );;
gap> I{ [ 1, 2 ] }{ [ 1, 2 ] }:= T;;
gap> conj:= List( GeneratorsOfGroup( we8 ), x -> I * x * I^-1 );;
gap> IsSubset( largegroup, conj );
true

##  doc2/o8p2s3_o8p5s3.xml (236-245)
gap> orbs:= OrbitsDomain( largegroup, NormedRowVectors( GF(5)^8 ),
>                         OnLines );;
gap> List( orbs, Length );
[ 39000, 39000, 19656 ]
gap> N:= Length( orbs[3] );
19656
gap> orbN:= SortedList( orbs[3] );;
gap> largepermgroup:= Action( largegroup, orbN, OnLines );;

##  doc2/o8p2s3_o8p5s3.xml (257-267)
gap> orbwe8:= SortedList( Orbit( we8, rootvectors[1], OnLines ) );;
gap> Length( orbwe8 );
120
gap> we8_to_m2:= ActionHomomorphism( we8, orbwe8, OnLines );;
gap> m2_120:= Image( we8_to_m2 );;
gap> m_120:= DerivedSubgroup( m2_120 );;
gap> sml:= SmallGeneratingSet( m_120 );;  Length( sml );
2
gap> gens_m:= List( sml, x -> PreImagesRepresentative( we8_to_m2, x ) );;

##  doc2/o8p2s3_o8p5s3.xml (278-287)
gap> gens_m_N:= List( gens_m,
>      x -> Permutation( I * x * I^-1, orbN, OnLines ) );;
gap> m_N:= Group( gens_m_N );;
gap> b:= I * we8.1 * I^-1;;
gap> DeterminantMat( b );
Z(5)^2
gap> b_N:= Permutation( b, orbN, OnLines );;
gap> m2_N:= ClosureGroup( m_N, b_N );;

##  doc2/o8p2s3_o8p5s3.xml (301-304)
gap> s_N:= DerivedSubgroup( largepermgroup );;
gap> s2_N:= ClosureGroup( s_N, b_N );;

##  doc2/o8p2s3_o8p5s3.xml (428-430)
gap> aut_m:= AutomorphismGroup( m_120 );;

##  doc2/o8p2s3_o8p5s3.xml (438-447)
gap> nice_aut_m:= NiceMonomorphism( aut_m );;
gap> der:= DerivedSubgroup( Image( nice_aut_m ) );;
gap> der2:= DerivedSubgroup( der );;
gap> repeat x:= Random( der );
>      ord:= Order( x );
>    until ord mod 3 = 0 and ord mod 9 <> 0 and not x in der2;
gap> x:= x^( ord / 3 );;
gap> alpha_120:= PreImagesRepresentative( nice_aut_m, x );;

##  doc2/o8p2s3_o8p5s3.xml (457-468)
gap> sml_alpha:= List( sml, x -> Image( alpha_120, x ) );;
gap> sml_alpha_2:= List( sml_alpha, x -> Image( alpha_120, x ) );;
gap> gens_m_alpha:= List( sml_alpha,
>                     x -> PreImagesRepresentative( we8_to_m2, x ) );;
gap> gens_m_alpha_2:= List( sml_alpha_2,
>                       x -> PreImagesRepresentative( we8_to_m2, x ) );;
gap> gens_m_N_alpha:= List( gens_m_alpha,
>      x -> Permutation( I * x * I^-1, orbN, OnLines ) );;
gap> gens_m_N_alpha_2:= List( gens_m_alpha_2,
>      x -> Permutation( I * x * I^-1, orbN, OnLines ) );;

##  doc2/o8p2s3_o8p5s3.xml (478-488)
gap> alpha_3N:= PermList( Concatenation( [ [ 1 .. N ] + 2*N,
>                                          [ 1 .. N ],
>                                          [ 1 .. N ] + N ] ) );;
gap> gens_m_3N:= List( [ 1 .. Length( gens_m_N ) ],
>      i -> gens_m_N[i] *
>           ( gens_m_N_alpha[i]^alpha_3N ) *
>           ( gens_m_N_alpha_2[i]^(alpha_3N^2) ) );;
gap> m_3N:= Group( gens_m_3N );;
gap> m3_3N:= ClosureGroup( m_3N, alpha_3N );;

##  doc2/o8p2s3_o8p5s3.xml (540-567)
gap> alpha:= GroupHomomorphismByImagesNC( m_N, m_N,
>                gens_m_N, gens_m_N_alpha );;
gap> CheapTestForHomomorphism:= function( gens, genimages, x, cand )
>        return Order( x ) = Order( cand ) and
>               ForAll( [ 1 .. Length( gens ) ],
>            i -> Order( gens[i] * x ) = Order( genimages[i] * cand ) );
> end;;
gap> repeat
>      repeat
>        x:= Random( m_N );
>      until Order( x ) = 9;
>      c_s:= Centralizer( s_N, x );
>      repeat
>        s:= Random( c_s );
>      until Order( s ) = 63;
>      c_m_alpha:= Images( alpha, Centralizer( m_N, s ) );
>      good:= Filtered( Elements( Centralizer( s_N, c_m_alpha ) ),
>               x -> CheapTestForHomomorphism( gens_m_N,
>                      gens_m_N_alpha, s, x ) );
>    until Length( good ) = 1;
gap> s_alpha:= good[1];;
gap> c_m_alpha_2:= Images( alpha, c_m_alpha );;
gap> good:= Filtered( Elements( Centralizer( s_N, c_m_alpha_2 ) ),
>      x -> CheapTestForHomomorphism( gens_m_N_alpha, gens_m_N_alpha_2,
>                                     s_alpha, x ) );;
gap> s_alpha_2:= good[1];;

##  doc2/o8p2s3_o8p5s3.xml (619-622)
gap> outer:= s * ( s_alpha^alpha_3N ) * ( s_alpha_2^(alpha_3N^2) );;
gap> s3_3N:= ClosureGroup( m3_3N, outer );;

##  doc2/o8p2s3_o8p5s3.xml (632-634)
gap> s_3N:= ClosureGroup( m_3N, outer );;

##  doc2/o8p2s3_o8p5s3.xml (729-743)
gap> b_120:= Permutation( we8.1, orbwe8, OnLines );;
gap> g_120:= RepresentativeAction( m_120,
>                List( sml_alpha_2, x -> x^b_120 ),
>                List( sml, x -> (x^b_120)^alpha_120 ), OnTuples );;
gap> g_120_alpha:= g_120^alpha_120;;
gap> g_N:= Permutation( I * PreImagesRepresentative( we8_to_m2, g_120 )
>                         * I^-1, orbN, OnLines );;
gap> g_N_alpha:= Permutation( I * PreImagesRepresentative( we8_to_m2,
>                  g_120_alpha ) * I^-1, orbN, OnLines );;
gap> inv:= PermList( Concatenation(
>                      ListPerm( b_N ),
>                      ListPerm( b_N * g_N ) + 2*N,
>                      ListPerm( b_N * g_N * g_N_alpha ) + N ) );;

##  doc2/o8p2s3_o8p5s3.xml (751-754)
gap> h:= ClosureGroup( m3_3N, inv );;
gap> g:= ClosureGroup( s3_3N, inv );;

##  doc2/o8p2s3_o8p5s3.xml (778-783)
gap> repeat
>      conj:= Random( s_3N );
>      inter:= Intersection( h, h^conj );
>    until Size( inter ) = 1;

##  doc2/o8p2s3_o8p5s3.xml (840-856)
gap> orbs:= Orbits( h, MovedPoints( h ) );;
gap> List( orbs, Length );
[ 22680, 36288 ]
gap> orb:= orbs[1];;
gap> bl:= Blocks( h, orb );;  Length( bl[1] );
2
gap> actbl:= Action( h, bl, OnSets );;
gap> bll:= Blocks( actbl, MovedPoints( actbl ) );;  Length( bll );  
405
gap> oneblock:= Union( bl{ bll[1] } );;
gap> orb:= SortedList( Orbit( h, oneblock, OnSets ) );;
gap> acthom:= ActionHomomorphism( h, orb, OnSets );;
gap> ccl:= ConjugacyClasses( Image( acthom ) );;
gap> reps:= List( ccl, x -> PreImagesRepresentative( acthom,
>                               Representative( x ) ) );;

##  doc2/o8p2s3_o8p5s3.xml (866-889)
gap> reps:= List( ccl, x -> PreImagesRepresentative( acthom,
>                               Representative( x ) ) );;
gap> fusion:= [];;
gap> centralizers:= [];;
gap> fusreps:= [];;
gap> for i in [ 1 .. Length( reps ) ] do
>      found:= false;
>      cen:= Size( Centralizer( g, reps[i] ) );
>      for j in [ 1 .. Length( fusreps ) ] do
>        if cen = centralizers[j] and
>           IsConjugate( g, fusreps[j], reps[i] ) then
>          fusion[i]:= j;
>          found:= true;
>          break;
>        fi;
>      od;
>      if not found then
>        Add( fusreps, reps[i] );
>        Add( fusion, Length( fusreps ) );
>        Add( centralizers, cen );
>      fi;
>    od;

##  doc2/o8p2s3_o8p5s3.xml (905-912)
gap> pi:= 0 * [ 1 .. Length( fusreps ) ];;
gap> for i in [ 1 .. Length( ccl ) ] do
>      pi[ fusion[i] ]:= pi[ fusion[i] ] + centralizers[ fusion[i] ] *
>                                              Size( ccl[i] );
>    od;
gap> pi:= pi{ fusion } / Size( h );;

##  doc2/o8p2s3_o8p5s3.xml (922-931)
gap> tblh:= CharacterTable( "O8+(2).S3" );;
gap> map:= CompatibleConjugacyClasses( Image( acthom ), ccl, tblh );;
gap> pi:= pi{ map }; 
[ 51162109375, 69375, 1259375, 69375, 568750, 1750, 4000, 375, 135, 
  975, 135, 625, 150, 650, 30, 72, 80, 72, 27, 27, 3, 7, 25, 30, 6, 
  12, 25, 484375, 1750, 375, 375, 30, 40, 15, 15, 15, 6, 6, 3, 3, 3, 
  157421875, 121875, 4875, 475, 75, 3875, 475, 13000, 1750, 300, 400, 
  30, 60, 15, 15, 15, 125, 10, 30, 4, 8, 6, 9, 7, 5, 6, 5 ]

##  doc2/o8p2s3_o8p5s3.xml (951-958)
gap> tblm2:= CharacterTable( "O8+(2).2" );;
gap> tblm3:= CharacterTable( "O8+(2).3" );;
gap> tblm:= CharacterTable( "O8+(2)" );;
gap> pi_m2:= pi{ GetFusionMap( tblm2, tblh ) };;
gap> pi_m3:= pi{ GetFusionMap( tblm3, tblh ) };;
gap> pi_m:= pi_m3{ GetFusionMap( tblm, tblm3 ) };;

##  doc2/o8p2s3_o8p5s3.xml (973-980)
gap> n:= ScalarProduct( tblm, pi_m, TrivialCharacter( tblm ) );
483
gap> n * Size( tblm ) / 2;
42065049600
gap> pi[1];
51162109375

##  doc2/o8p2s3_o8p5s3.xml (996-1005)
gap> inv:= Filtered( [ 1 .. NrConjugacyClasses( tblm ) ],
>              i -> OrdersClassRepresentatives( tblm )[i] = 2 );
[ 2, 3, 4, 5, 6 ]
gap> n2:= List( inv,
>           i -> Int( 2 * pi_m[i] / SizesCentralizers( tblm )[i] ) );
[ 1, 54, 54, 54, 45 ]
gap> Sum( n2 );
208

##  doc2/o8p2s3_o8p5s3.xml (1014-1019)
gap> First( [ 1 .. 483 ],                                           
>      i -> i * Size( tblm ) + 208 * Size( tblm ) / 2
>           + ( 483 - i - 208 - 1 ) * Size( tblm ) / 3 + 1 >= pi[1] );
148

##  doc2/o8p2s3_o8p5s3.xml (1037-1047)
gap> inv:= Filtered( [ 1 .. NrConjugacyClasses( tblm2 ) ],
>              i -> OrdersClassRepresentatives( tblm2 )[i] = 2 and
>                   not i in ClassPositionsOfDerivedSubgroup( tblm2 ) );
[ 41, 42 ]
gap> n2:= List( inv,
>           i -> Int( 2 * pi_m2[i] / SizesCentralizers( tblm2 )[i] ) );
[ 108, 26 ]
gap> Sum( n2 );
134

##  doc2/o8p2s3_o8p5s3.xml (1061-1076)
gap> n:= ScalarProduct( tblm3, pi_m3, TrivialCharacter( tblm3 ) );
205
gap> inv:= Filtered( [ 1 .. NrConjugacyClasses( tblm3 ) ],
>              i -> OrdersClassRepresentatives( tblm3 )[i] = 2 );
[ 2, 3, 4 ]
gap> n2:= List( inv,
>           i -> Int( 2 * pi_m3[i] / SizesCentralizers( tblm3 )[i] ) );
[ 0, 54, 15 ]
gap> Sum( n2 );
69
gap> 69 * Size( tblm3 ) / 2 + ( n - 69 - 1 ) * Size( tblm3 ) / 3 + 1;
41542502401
gap> pi[1];
51162109375

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "o8p2s3_o8p5s3.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
