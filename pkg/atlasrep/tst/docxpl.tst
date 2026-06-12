# This file was created automatically, do not edit!
#############################################################################
##
#W  docxpl.tst             GAP 4 package AtlasRep               Thomas Breuer
##
##  This file contains the GAP code of examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/atlasrep' directory, and calls 'Test( "docxpl.tst" );'.
##  

gap> LoadPackage( "AtlasRep", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "docxpl.tst" );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      oldinterval:= data.replayInterval;
>      data.replayInterval:= 1;
>    fi;

##  doc/tutorial.xml (31-38)
gap> LoadPackage( "AtlasRep", false );
true
gap> LoadPackage( "CTblLib", false );
true
gap> LoadPackage( "TomLib", false );
true

##  doc/tutorial.xml (56-59)
gap> origpref:= UserPreference( "AtlasRep", "DisplayFunction" );;
gap> SetUserPreference( "AtlasRep", "DisplayFunction", "Print" );

##  doc/tutorial.xml (69-74)
gap> priv:= Difference(
>     List( AtlasOfGroupRepresentationsInfo.notified, x -> x.ID ),
>     [ "core", "internal" ] );;
gap> Perform( priv, AtlasOfGroupRepresentationsForgetData );

##  doc/tutorial.xml (81-84)
gap> globallevel:= InfoLevel( InfoAtlasRep );;
gap> SetInfoLevel( InfoAtlasRep, 0 );

##  doc/tutorial.xml (169-180)
gap> g:= AtlasGroup( "M24" );
Group([ (1,4)(2,7)(3,17)(5,13)(6,9)(8,15)(10,19)(11,18)(12,21)(14,16)
  (20,24)(22,23), (1,4,6)(2,21,14)(3,9,15)(5,18,10)(13,17,16)
  (19,24,23) ])
gap> IsPermGroup( g );  NrMovedPoints( g );  Size( g );
true
24
244823040
gap> AtlasGroup( "J5" );
fail

##  doc/tutorial.xml (197-207)
gap> g:= AtlasSubgroup( "M24", 1 );
Group([ (2,10)(3,12)(4,14)(6,9)(8,16)(15,18)(20,22)(21,24), (1,7,2,9)
  (3,22,10,23)(4,19,8,12)(5,14)(6,18)(13,16,17,24) ])
gap> IsPermGroup( g );  NrMovedPoints( g );  Size( g );
true
23
10200960
gap> AtlasSubgroup( "M24", 100 );
fail

##  doc/tutorial.xml (235-244)
gap> s:= AtlasSubgroup( "ON", 3 );
<permutation group of size 175560 with 2 generators>
gap> NrMovedPoints( s );  Size( s );
122760
175560
gap> hom:= SmallerDegreePermutationRepresentation( s );;
gap> NrMovedPoints( Image( hom ) ) < 2000;
true

##  doc/tutorial.xml (254-259)
gap> j1:= AtlasGroup( "J1" );
<permutation group of size 175560 with 2 generators>
gap> NrMovedPoints( j1 );
266

##  doc/tutorial.xml (268-277)
gap> g:= AtlasGroup( "ON" );
<permutation group of size 460815505920 with 2 generators>
gap> s:= AtlasSubgroup( g, 3 );
<permutation group of size 175560 with 2 generators>
gap> IsSubset( g, s );
true
gap> IsSubset( g, j1 );
false

##  doc/tutorial.xml (292-326)
gap> DisplayAtlasInfo( "A5" );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 1: G <= Sym(5)                  3-trans., on cosets of A4 (1st max.)
 2: G <= Sym(6)                  2-trans., on cosets of D10 (2nd max.)
 3: G <= Sym(10)                 rank 3, on cosets of S3 (3rd max.)
 4: G <= GL(4a,2)                character 4a
 5: G <= GL(4b,2)                character 2ab
 6: G <= GL(4,3)                 character 4a
 7: G <= GL(6,3)                 character 3ab
 8: G <= GL(2a,4)                character 2a
 9: G <= GL(2b,4)                character 2b
10: G <= GL(3,5)                 character 3a
11: G <= GL(5,5)                 character 5a
12: G <= GL(3a,9)                character 3a
13: G <= GL(3b,9)                character 3b
14: G <= GL(4,Z)                 character 4a
15: G <= GL(5,Z)                 character 5a
16: G <= GL(6,Z)                 character 3ab
17: G <= GL(3a,Field([Sqrt(5)])) character 3a
18: G <= GL(3b,Field([Sqrt(5)])) character 3b

Programs for G = A5:    (all refer to std. generators 1)
--------------------
- class repres.*      
- presentation        
- maxes (all 3):
  1:  A4              
  2:  D10             
  3:  S3              
- std. gen. checker:
  (check)             
  (pres)              

##  doc/tutorial.xml (334-337)
gap> AtlasGroup( "A5", Position, 1 );
Group([ (1,2)(3,4), (1,3,5) ])

##  doc/tutorial.xml (348-353)
gap> AtlasGroup( "A5", NrMovedPoints, 10 );
Group([ (2,4)(3,5)(6,8)(7,10), (1,2,3)(4,6,7)(5,8,9) ])
gap> AtlasGroup( "A5", Dimension, 4, Ring, GF(2) );
<matrix group of size 60 with 2 generators>

##  doc/tutorial.xml (368-376)
gap> AtlasSubgroup( "A5", Dimension, 4, Ring, GF(2), 1 );
<matrix group of size 12 with 2 generators>
gap> g:= AtlasSubgroup( "A5", NrMovedPoints, 10, 3 );
Group([ (2,4)(3,5)(6,8)(7,10), (1,4)(3,8)(5,7)(6,10) ])
gap> Size( g );  NrMovedPoints( g );
6
9

##  doc/tutorial.xml (423-442)
gap> info:= OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, 10 );
rec( charactername := "1a+4a+5a", constituents := [ 1, 4, 5 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p10B0.m1", "A5G1-p10B0.m2" ], 1, 10 ],
  isPrimitive := true, maxnr := 3, p := 10, rankAction := 3, 
  repname := "A5G1-p10B0", repnr := 3, size := 60, stabilizer := "S3",
  standardization := 1, transitivity := 1, type := "perm" )
gap> info2:= AtlasGenerators( info );
rec( charactername := "1a+4a+5a", constituents := [ 1, 4, 5 ], 
  contents := "core", 
  generators := [ (2,4)(3,5)(6,8)(7,10), (1,2,3)(4,6,7)(5,8,9) ], 
  groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p10B0.m1", "A5G1-p10B0.m2" ], 1, 10 ],
  isPrimitive := true, maxnr := 3, p := 10, rankAction := 3, 
  repname := "A5G1-p10B0", repnr := 3, size := 60, stabilizer := "S3",
  standardization := 1, transitivity := 1, type := "perm" )
gap> info2.generators;
[ (2,4)(3,5)(6,8)(7,10), (1,2,3)(4,6,7)(5,8,9) ]

##  doc/tutorial.xml (453-462)
gap> g:= AtlasGroup( "A5", NrMovedPoints, 10 );;
gap> AtlasRepInfoRecord( g );
rec( charactername := "1a+4a+5a", constituents := [ 1, 4, 5 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p10B0.m1", "A5G1-p10B0.m2" ], 1, 10 ],
  isPrimitive := true, maxnr := 3, p := 10, rankAction := 3, 
  repname := "A5G1-p10B0", repnr := 3, size := 60, stabilizer := "S3",
  standardization := 1, transitivity := 1, type := "perm" )

##  doc/tutorial.xml (495-516)
gap> prginfo:= AtlasProgramInfo( "A5", "maxes", 1 );
rec( groupname := "A5", identifier := [ "A5", "A5G1-max1W1", 1 ], 
  size := 12, standardization := 1, subgroupname := "A4", 
  version := "1" )
gap> prg:= AtlasProgram( prginfo.identifier );
rec( groupname := "A5", identifier := [ "A5", "A5G1-max1W1", 1 ], 
  program := <straight line program>, size := 12, 
  standardization := 1, subgroupname := "A4", version := "1" )
gap> Display( prg.program );
# input:
r:= [ g1, g2 ];
# program:
r[3]:= r[1]*r[2];
r[4]:= r[2]*r[1];
r[5]:= r[3]*r[3];
r[1]:= r[5]*r[4];
# return values:
[ r[1], r[2] ]
gap> ResultOfStraightLineProgram( prg.program, info2.generators );
[ (1,10)(2,3)(4,9)(7,8), (1,2,3)(4,6,7)(5,8,9) ]

##  doc/tutorial.xml (538-543)
gap> tbl:= CharacterTable( "M11" );;
gap> modtbl:= tbl mod 2;;
gap> CharacterDegrees( modtbl );
[ [ 1, 1 ], [ 10, 1 ], [ 16, 2 ], [ 44, 1 ] ]

##  doc/tutorial.xml (559-568)
gap> DisplayAtlasInfo( "M11", Characteristic, 2 );
Representations for G = M11:    (all refer to std. generators 1)
----------------------------
 6: G <= GL(10,2)  character 10a
 7: G <= GL(32,2)  character 16ab
 8: G <= GL(44,2)  character 44a
16: G <= GL(16a,4) character 16a
17: G <= GL(16b,4) character 16b

##  doc/tutorial.xml (582-592)
gap> info:= OneAtlasGeneratingSetInfo( "M11", Characteristic, 2,
>                                             Dimension, 10 );;
gap> gens:= AtlasGenerators( info.identifier );;
gap> ccls:= AtlasProgram( "M11", gens.standardization, "classes" );
rec( groupname := "M11", identifier := [ "M11", "M11G1-cclsW1", 1 ], 
  outputs := [ "1A", "2A", "3A", "4A", "5A", "6A", "8A", "8B", "11A", 
      "11B" ], program := <straight line program>, 
  standardization := 1, version := "1" )
gap> reps:= ResultOfStraightLineProgram( ccls.program, gens.generators );;

##  doc/tutorial.xml (604-611)
gap> ord8prg:= RestrictOutputsOfSLP( ccls.program,
>                   Filtered( [ 1 .. 10 ], i -> ccls.outputs[i][1] = '8' ) );
<straight line program>
gap> ord8reps:= ResultOfStraightLineProgram( ord8prg, gens.generators );;
gap> List( ord8reps, m -> Position( reps, m ) );
[ 7, 8 ]

##  doc/tutorial.xml (619-622)
gap> List( reps, Order ) = OrdersClassRepresentatives( tbl );
true

##  doc/tutorial.xml (637-641)
gap> fus:= GetFusionMap( modtbl, tbl );
[ 1, 3, 5, 9, 10 ]
gap> modreps:= reps{ fus };;

##  doc/tutorial.xml (651-656)
gap> char:= List( modreps, BrauerCharacterValue );
[ 10, 1, 0, -1, -1 ]
gap> Position( Irr( modtbl ), char );
2

##  doc/tutorial.xml (673-679)
gap> grp:= Group( gens.generators );;
gap> v:= GF(2)^10;;
gap> orbs:= Orbits( grp, AsList( v ) );;
gap> List( orbs, Length );
[ 1, 396, 55, 330, 66, 165, 11 ]

##  doc/tutorial.xml (700-702)
gap> gens:= AtlasGenerators( "M11", 6, 1 );;

##  doc/tutorial.xml (710-716)
gap> id:= IdentityMat( 10, GF(2) );;
gap> sub1:= Subspace( v, NullspaceMat( gens.generators[1] - id ) );;
gap> sub2:= Subspace( v, NullspaceMat( gens.generators[2] - id ) );;
gap> fix:= Intersection( sub1, sub2 );
<vector space of dimension 1 over GF(2)>

##  doc/tutorial.xml (725-729)
gap> orb:= Orbit( grp, Basis( fix )[1] );;
gap> act:= Action( grp, orb );;  Print( act, "\n" );
Group( [ ( 1, 2)( 4, 6)( 5, 8)( 7,10), ( 1, 3, 5, 9)( 2, 4, 7,11) ] )

##  doc/tutorial.xml (741-749)
gap> permgrp:= Group( AtlasGenerators( "M11", 1 ).generators );;
gap> Print( permgrp, "\n" );
Group( [ ( 2,10)( 4,11)( 5, 7)( 8, 9), (1,4,3,8)(2,5,6,9) ] )
gap> permgrp = act;
false
gap> IsConjugate( SymmetricGroup(11), permgrp, act );
true

##  doc/tutorial.xml (764-789)
gap> DisplayAtlasInfo( "G2(3)", IsStraightLineProgram );
Programs for G = G2(3):    (all refer to std. generators 1)
-----------------------
- class repres.            
- presentation             
- repr. cyc. subg.         
- std. gen. checker        
- automorphisms:
  2                        
- maxes (all 10):
   1:  U3(3).2             
   2:  U3(3).2             
   3:  (3^(1+2)+x3^2):2S4  
   4:  (3^(1+2)+x3^2):2S4  
   5:  L3(3).2             
   6:  L3(3).2             
   7:  L2(8).3             
   8:  2^3.L3(2)           
   9:  L2(13)              
  10:  2^(1+4)+:3^2.2      
gap> prog:= AtlasProgram( "G2(3)", "automorphism", "2" ).program;;
gap> info:= OneAtlasGeneratingSetInfo( "G2(3)", Dimension, 7 );;
gap> gens:= AtlasGenerators( info ).generators;;
gap> imgs:= ResultOfStraightLineProgram( prog, gens );;

##  doc/tutorial.xml (802-806)
gap> g:= Group( gens );;
gap> aut:= GroupHomomorphismByImagesNC( g, g, gens, imgs );;
gap> SetIsBijective( aut, true );

##  doc/tutorial.xml (815-819)
gap> aut:= GroupHomomorphismByImages( g, g, gens, imgs );;
gap> IsBijective( aut );
true

##  doc/tutorial.xml (842-847)
gap> max1:= AtlasProgram( "G2(3)", 1 ).program;;
gap> mgens:= ResultOfStraightLineProgram( max1, gens );;
gap> comp:= CompositionOfStraightLinePrograms( max1, prog );;
gap> mimgs:= ResultOfStraightLineProgram( comp, gens );;

##  doc/tutorial.xml (862-865)
gap> mimgs = List( mgens, x -> x^aut );
true

##  doc/tutorial.xml (896-910)
gap> info:= OneAtlasGeneratingSetInfo( "M12", NrMovedPoints, 12 );
rec( charactername := "1a+11a", constituents := [ 1, 2 ], 
  contents := "core", groupname := "M12", id := "a", 
  identifier := [ "M12", [ "M12G1-p12aB0.m1", "M12G1-p12aB0.m2" ], 1, 
      12 ], isPrimitive := true, maxnr := 1, p := 12, rankAction := 2,
  repname := "M12G1-p12aB0", repnr := 1, size := 95040, 
  stabilizer := "M11", standardization := 1, transitivity := 5, 
  type := "perm" )
gap> gensM12:= AtlasGenerators( info.identifier );;
gap> restM11:= AtlasProgram( "M12", "maxes", 1 );;
gap> gensM11:= ResultOfStraightLineProgram( restM11.program,
>                                           gensM12.generators );
[ (3,9)(4,12)(5,10)(6,8), (1,4,11,5)(2,10,8,3) ]

##  doc/tutorial.xml (922-929)
gap> checkM11:= AtlasProgram( "M11", "check" );
rec( groupname := "M11", identifier := [ "M11", "M11G1-check1", 1, 1 ]
    , program := <straight line decision>, standardization := 1, 
  version := "1" )
gap> ResultOfStraightLineDecision( checkM11.program, gensM11 );
true

##  doc/tutorial.xml (938-945)
gap> restL211:= AtlasProgram( "M11", "maxes", 2 );;
gap> gensL211:= ResultOfStraightLineProgram( restL211.program, gensM11 );
[ (3,9)(4,12)(5,10)(6,8), (1,11,9)(2,12,8)(3,6,10) ]
gap> G:= Group( gensL211 );;  Size( G );  IsSimple( G );
660
true

##  doc/tutorial.xml (951-977)
gap> DisplayAtlasInfo( "M11", IsStraightLineProgram );
Programs for G = M11:    (all refer to std. generators 1)
---------------------
- presentation                                        
- repr. cyc. subg.                                    
- std. gen. finder                                    
- class repres.:
  (direct)                                            
  (composed)                                          
- maxes (all 5):
  1:  A6.2_3                                          
  1:  A6.2_3                                  (std. 1)
  2:  L2(11)                                          
  2:  L2(11)                                  (std. 1)
  3:  3^2:Q8.2                                        
  4:  S5                                              
  4:  S5                                      (std. 1)
  5:  2.S4                                            
- standardizations of maxes:
  from 1st max., version 1 to A6.2_3, std. 1          
  from 2nd max., version 1 to L2(11), std. 1          
  from 4th max., version 1 to A5.2, std. 1            
- std. gen. checker:
  (check)                                             
  (pres)                                              

##  doc/tutorial.xml (986-990)
gap> restL211std:= AtlasProgram( "M11", "maxes", 2, 1 );;
gap> ResultOfStraightLineProgram( restL211std.program, gensM11 );
[ (3,9)(4,12)(5,10)(6,8), (1,11,9)(2,12,8)(3,6,10) ]

##  doc/tutorial.xml (1007-1013)
gap> G:= MathieuGroup( 11 );;
gap> gens:= GeneratorsOfGroup( G );
[ (1,2,3,4,5,6,7,8,9,10,11), (3,7,11,8)(4,10,5,6) ]
gap> ResultOfStraightLineDecision( checkM11.program, gens );
false

##  doc/tutorial.xml (1023-1039)
gap> find:= AtlasProgram( "M11", "find" );
rec( groupname := "M11", identifier := [ "M11", "M11G1-find1", 1, 1 ],
  program := <black box program>, standardization := 1, 
  version := "1" )
gap> stdgens:= ResultOfBBoxProgram( find.program, Group( gens ) );;
gap> List( stdgens, Order );
[ 2, 4 ]
gap> ResultOfStraightLineDecision( checkM11.program, stdgens );
true
gap> gensL211:= ResultOfStraightLineProgram( restL211.program, stdgens );;
gap> List( gensL211, Order );
[ 2, 3 ]
gap> G:= Group( gensL211 );;  Size( G );  IsSimple( G );
660
true

##  doc/tutorial.xml (1070-1078)
gap> tom:= TableOfMarks( "A5" );
TableOfMarks( "A5" )
gap> info:= StandardGeneratorsInfo( tom );
[ rec( ATLAS := true, description := "|a|=2, |b|=3, |ab|=5", 
      generators := "a, b", 
      script := [ [ 1, 2 ], [ 2, 3 ], [ 1, 1, 2, 1, 5 ] ], 
      standardization := 1 ) ]

##  doc/tutorial.xml (1095-1120)
gap> info:= OneAtlasGeneratingSetInfo( "A5", Ring, Integers, Dimension, 4 );;
gap> stdgens:= AtlasGenerators( info.identifier );
rec( charactername := "4a", constituents := [ 4 ], contents := "core",
  dim := 4, 
  generators := 
    [ 
      [ [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], 
          [ -1, -1, -1, -1 ] ], 
      [ [ 0, 1, 0, 0 ], [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], 
          [ 1, 0, 0, 0 ] ] ], groupname := "A5", id := "", 
  identifier := [ "A5", "A5G1-Zr4B0.g", 1, 4 ], 
  repname := "A5G1-Zr4B0", repnr := 14, ring := Integers, size := 60, 
  standardization := 1, type := "matint" )
gap> orders:= OrdersTom( tom );
[ 1, 2, 3, 4, 5, 6, 10, 12, 60 ]
gap> pos:= Position( orders, 4 );
4
gap> sub:= RepresentativeTomByGeneratorsNC( tom, pos, stdgens.generators );
<matrix group of size 4 with 2 generators>
gap> GeneratorsOfGroup( sub );
[ [ [ 1, 0, 0, 0 ], [ -1, -1, -1, -1 ], [ 0, 0, 0, 1 ], 
      [ 0, 0, 1, 0 ] ], 
  [ [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], 
      [ -1, -1, -1, -1 ] ] ]

##  doc/tutorial.xml (1135-1143)
gap> tom:= TableOfMarks( "M22" );
TableOfMarks( "M22" )
gap> subord:= Size( UnderlyingGroup( tom ) ) / 770;
576
gap> ord:= OrdersTom( tom );;
gap> tomstabs:= Filtered( [ 1 .. Length( ord ) ], i -> ord[i] = subord );
[ 144 ]

##  doc/tutorial.xml (1152-1157)
gap> DisplayAtlasInfo( "M22", NrMovedPoints, 770 );
Representations for G = M22:    (all refer to std. generators 1)
----------------------------
12: G <= Sym(770) rank 9, on cosets of (A4xA4):4 < 2^4:A6

##  doc/tutorial.xml (1166-1172)
gap> maxtom:= MaximalSubgroupsTom( tom );
[ [ 155, 154, 153, 152, 151, 150, 146, 145 ], 
  [ 22, 77, 176, 176, 231, 330, 616, 672 ] ]
gap> List( tomstabs, i -> List( maxtom[1], j -> ContainedTom( tom, i, j ) ) );
[ [ 0, 10, 0, 0, 0, 0, 0, 0 ] ]

##  doc/tutorial.xml (1191-1197)
gap> g:= AtlasGroup( "M22", NrMovedPoints, 770 );
<permutation group of size 443520 with 2 generators>
gap> allbl:= AllBlocks( g );;
gap> List( allbl, Length );
[ 10 ]

##  doc/tutorial.xml (1206-1214)
gap> stab:= Stabilizer( g, 1 );;
gap> StructureDescription( stab : nice );
"(A4 x A4) : C4"
gap> blocks:= Orbit( g, allbl[1], OnSets );;
gap> act:= Action( g, blocks, OnSets );;
gap> StructureDescription( Stabilizer( act, 1 ) );
"(C2 x C2 x C2 x C2) : A6"

##  doc/tutorial.xml (1228-1235)
gap> DisplayAtlasInfo( "M22", NrMovedPoints, 462 );
Representations for G = M22:    (all refer to std. generators 1)
----------------------------
7: G <= Sym(462a) rank 5, on cosets of 2^4:A5 < 2^4:A6
8: G <= Sym(462b) rank 8, on cosets of 2^4:A5 < L3(4), 2^4:S5
9: G <= Sym(462c) rank 8, on cosets of 2^4:A5 < L3(4), 2^4:A6

##  doc/tutorial.xml (1250-1260)
gap> tom:= TableOfMarks( "M22" );
TableOfMarks( "M22" )
gap> genstom:= GeneratorsOfGroup( UnderlyingGroup( tom ) );;
gap> checkM22:= AtlasProgram( "M22", "check" );
rec( groupname := "M22", identifier := [ "M22", "M22G1-check1", 1, 1 ]
    , program := <straight line decision>, standardization := 1, 
  version := "1" )
gap> ResultOfStraightLineDecision( checkM22.program, genstom );
true

##  doc/tutorial.xml (1269-1273)
gap> ord:= OrdersTom( tom );;
gap> tomstabs:= Filtered( [ 1 .. Length( ord ) ], i -> ord[i] = 960 );
[ 147, 148, 149 ]

##  doc/tutorial.xml (1284-1318)
gap> atlasreps:= AllAtlasGeneratingSetInfos( "M22", NrMovedPoints, 462 );
[ rec( charactername := "1a+21a+55a+154a+231a", 
      constituents := [ 1, 2, 5, 7, 9 ], contents := "core", 
      groupname := "M22", id := "a", 
      identifier := 
        [ "M22", [ "M22G1-p462aB0.m1", "M22G1-p462aB0.m2" ], 1, 462 ],
      isPrimitive := false, p := 462, rankAction := 5, 
      repname := "M22G1-p462aB0", repnr := 7, size := 443520, 
      stabilizer := "2^4:A5 < 2^4:A6", standardization := 1, 
      transitivity := 1, type := "perm" ), 
  rec( charactername := "1a+21a^2+55a+154a+210a", 
      constituents := [ 1, [ 2, 2 ], 5, 7, 8 ], contents := "core", 
      groupname := "M22", id := "b", 
      identifier := 
        [ "M22", [ "M22G1-p462bB0.m1", "M22G1-p462bB0.m2" ], 1, 462 ],
      isPrimitive := false, p := 462, rankAction := 8, 
      repname := "M22G1-p462bB0", repnr := 8, size := 443520, 
      stabilizer := "2^4:A5 < L3(4), 2^4:S5", standardization := 1, 
      transitivity := 1, type := "perm" ), 
  rec( charactername := "1a+21a^2+55a+154a+210a", 
      constituents := [ 1, [ 2, 2 ], 5, 7, 8 ], contents := "core", 
      groupname := "M22", id := "c", 
      identifier := 
        [ "M22", [ "M22G1-p462cB0.m1", "M22G1-p462cB0.m2" ], 1, 462 ],
      isPrimitive := false, p := 462, rankAction := 8, 
      repname := "M22G1-p462cB0", repnr := 9, size := 443520, 
      stabilizer := "2^4:A5 < L3(4), 2^4:A6", standardization := 1, 
      transitivity := 1, type := "perm" ) ]
gap> atlasreps:= List( atlasreps, AtlasGroup );;
gap> tomstabreps:= List( atlasreps, G -> List( tomstabs,
> i -> RepresentativeTomByGenerators( tom, i, GeneratorsOfGroup( G ) ) ) );;
gap> List( tomstabreps, x -> List( x, NrMovedPoints ) );
[ [ 462, 462, 461 ], [ 460, 462, 462 ], [ 462, 461, 462 ] ]

##  doc/tutorial.xml (1334-1340)
gap> stabs:= List( atlasreps, G -> Stabilizer( G, 1 ) );;
gap> List( stabs, IdGroup );
[ [ 960, 11358 ], [ 960, 11357 ], [ 960, 11357 ] ]
gap> List( stabs, PerfectIdentification );
[ [ 960, 2 ], [ 960, 1 ], [ 960, 1 ] ]

##  doc/tutorial.xml (1350-1357)
gap> maxtom:= MaximalSubgroupsTom( tom );
[ [ 155, 154, 153, 152, 151, 150, 146, 145 ], 
  [ 22, 77, 176, 176, 231, 330, 616, 672 ] ]
gap> List( tomstabs, i -> List( maxtom[1], j -> ContainedTom( tom, i, j ) ) );
[ [ 21, 0, 0, 0, 1, 0, 0, 0 ], [ 21, 6, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 6, 0, 0, 0, 0, 0, 0 ] ]

##  doc/tutorial.xml (1388-1394)
gap> bl:= List( atlasreps, AllBlocks );;
gap> List( bl, Length );
[ 1, 3, 2 ]
gap> List( bl, l -> List( l, Length ) );
[ [ 6 ], [ 21, 21, 2 ], [ 21, 6 ] ]

##  doc/tutorial.xml (1421-1424)
gap> List( atlasreps, RankAction );
[ 5, 8, 8 ]

##  doc/tutorial.xml (1437-1447)
gap> t:= CharacterTable( "M22" );;
gap> perms:= PermChars( t, 462 );
[ Character( CharacterTable( "M22" ),
  [ 462, 30, 3, 2, 2, 2, 3, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M22" ),
  [ 462, 30, 12, 2, 2, 2, 0, 0, 0, 0, 0, 0 ] ) ]
gap> MatScalarProducts( t, Irr( t ), perms );
[ [ 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0 ], 
  [ 1, 2, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0 ] ]

##  doc/../gap/utils.gd (183-205)
gap> AtlasClassNames( CharacterTable( "L3(4).3" ) );
[ "1A", "2A", "3A", "4ABC", "5A", "5B", "7A", "7B", "3B", "3B'", 
  "3C", "3C'", "6B", "6B'", "15A", "15A'", "15B", "15B'", "21A", 
  "21A'", "21B", "21B'" ]
gap> AtlasClassNames( CharacterTable( "U3(5).2" ) );
[ "1A", "2A", "3A", "4A", "5A", "5B", "5CD", "6A", "7AB", "8AB", 
  "10A", "2B", "4B", "6D", "8C", "10B", "12B", "20A", "20B" ]
gap> AtlasClassNames( CharacterTable( "L2(27).6" ) );
[ "1A", "2A", "3AB", "7ABC", "13ABC", "13DEF", "14ABC", "2B", "4A", 
  "26ABC", "26DEF", "28ABC", "28DEF", "3C", "3C'", "6A", "6A'", 
  "9AB", "9A'B'", "6B", "6B'", "12A", "12A'" ]
gap> AtlasClassNames( CharacterTable( "L3(4).3.2_2" ) );
[ "1A", "2A", "3A", "4ABC", "5AB", "7A", "7B", "3B", "3C", "6B", 
  "15A", "15B", "21A", "21B", "2C", "4E", "6E", "8D", "14A", "14B" ]
gap> AtlasClassNames( CharacterTable( "3.A6" ) );
[ "1A_0", "1A_1", "1A_2", "2A_0", "2A_1", "2A_2", "3A_0", "3B_0", 
  "4A_0", "4A_1", "4A_2", "5A_0", "5A_1", "5A_2", "5B_0", "5B_1", 
  "5B_2" ]
gap> AtlasClassNames( CharacterTable( "2.A5.2" ) );
[ "1A_0", "1A_1", "2A_0", "3A_0", "3A_1", "5AB_0", "5AB_1", "2B_0", 
  "4A_0", "4A_1", "6A_0", "6A_1" ]

##  doc/../gap/utils.gd (251-254)
gap> AtlasCharacterNames( CharacterTable( "A5" ) );                   
[ "1a", "3a", "3b", "4a", "5a" ]

##  doc/../gap/interfac.gd (462-468)
gap> DisplayAtlasInfo( [ "M11", "A5" ] );
group |  # | maxes | cl | cyc | out | fnd | chk | prs
------+----+-------+----+-----+-----+-----+-----+----
M11   | 42 |     5 |  + |  +  |     |  +  |  +  |  + 
A5*   | 18 |     3 |  + |     |     |     |  +  |  + 

##  doc/../gap/interfac.gd (494-499)
gap> DisplayAtlasInfo( [ "M11", "A5" ], NrMovedPoints, 11 );
group | # | maxes | cl | cyc | out | fnd | chk | prs
------+---+-------+----+-----+-----+-----+-----+----
M11   | 1 |     5 |  + |  +  |     |  +  |  +  |  + 

##  doc/../gap/interfac.gd (510-522)
gap> DisplayAtlasInfo( "A5", IsPermGroup, true );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
1: G <= Sym(5)  3-trans., on cosets of A4 (1st max.)
2: G <= Sym(6)  2-trans., on cosets of D10 (2nd max.)
3: G <= Sym(10) rank 3, on cosets of S3 (3rd max.)
gap> DisplayAtlasInfo( "A5", NrMovedPoints, [ 4 .. 9 ] );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
1: G <= Sym(5) 3-trans., on cosets of A4 (1st max.)
2: G <= Sym(6) 2-trans., on cosets of D10 (2nd max.)

##  doc/../gap/interfac.gd (527-546)
gap> DisplayAtlasInfo( "A5", Dimension, [ 1 .. 3 ] );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 8: G <= GL(2a,4)                character 2a
 9: G <= GL(2b,4)                character 2b
10: G <= GL(3,5)                 character 3a
12: G <= GL(3a,9)                character 3a
13: G <= GL(3b,9)                character 3b
17: G <= GL(3a,Field([Sqrt(5)])) character 3a
18: G <= GL(3b,Field([Sqrt(5)])) character 3b
gap> DisplayAtlasInfo( "A5", Characteristic, 0 );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
14: G <= GL(4,Z)                 character 4a
15: G <= GL(5,Z)                 character 5a
16: G <= GL(6,Z)                 character 3ab
17: G <= GL(3a,Field([Sqrt(5)])) character 3a
18: G <= GL(3b,Field([Sqrt(5)])) character 3b

##  doc/../gap/interfac.gd (555-563)
gap> DisplayAtlasInfo( "A5", Identifier, "a" );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 4: G <= GL(4a,2)                character 4a
 8: G <= GL(2a,4)                character 2a
12: G <= GL(3a,9)                character 3a
17: G <= GL(3a,Field([Sqrt(5)])) character 3a

##  doc/../gap/interfac.gd (568-603)
gap> DisplayAtlasInfo( "A5", NrMovedPoints, IsPrimeInt );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
1: G <= Sym(5) 3-trans., on cosets of A4 (1st max.)
gap> DisplayAtlasInfo( "A5", Characteristic, IsOddInt );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 6: G <= GL(4,3)  character 4a
 7: G <= GL(6,3)  character 3ab
10: G <= GL(3,5)  character 3a
11: G <= GL(5,5)  character 5a
12: G <= GL(3a,9) character 3a
13: G <= GL(3b,9) character 3b
gap> DisplayAtlasInfo( "A5", Dimension, IsPrimeInt );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 8: G <= GL(2a,4)                character 2a
 9: G <= GL(2b,4)                character 2b
10: G <= GL(3,5)                 character 3a
11: G <= GL(5,5)                 character 5a
12: G <= GL(3a,9)                character 3a
13: G <= GL(3b,9)                character 3b
15: G <= GL(5,Z)                 character 5a
17: G <= GL(3a,Field([Sqrt(5)])) character 3a
18: G <= GL(3b,Field([Sqrt(5)])) character 3b
gap> DisplayAtlasInfo( "A5", Ring, IsFinite and IsPrimeField );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
 4: G <= GL(4a,2) character 4a
 5: G <= GL(4b,2) character 2ab
 6: G <= GL(4,3)  character 4a
 7: G <= GL(6,3)  character 3ab
10: G <= GL(3,5)  character 3a
11: G <= GL(5,5)  character 5a

##  doc/../gap/interfac.gd (613-626)
gap> DisplayAtlasInfo( "A5", IsStraightLineProgram, true );
Programs for G = A5:    (all refer to std. generators 1)
--------------------
- class repres.*      
- presentation        
- maxes (all 3):
  1:  A4              
  2:  D10             
  3:  S3              
- std. gen. checker:
  (check)             
  (pres)              

##  doc/../gap/interfac.gd (799-828)
gap> gens1:= AtlasGenerators( "A5", 1 );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
  groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> gens8:= AtlasGenerators( "A5", 8 );
rec( charactername := "2a", constituents := [ 2 ], contents := "core",
  dim := 2, 
  generators := [ [ [ Z(2)^0, 0*Z(2) ], [ Z(2^2), Z(2)^0 ] ], 
      [ [ 0*Z(2), Z(2)^0 ], [ Z(2)^0, Z(2)^0 ] ] ], groupname := "A5",
  id := "a", 
  identifier := [ "A5", [ "A5G1-f4r2aB0.m1", "A5G1-f4r2aB0.m2" ], 1, 
      4 ], repname := "A5G1-f4r2aB0", repnr := 8, ring := GF(2^2), 
  size := 60, standardization := 1, type := "matff" )
gap> gens17:= AtlasGenerators( "A5", 17 );
rec( charactername := "3a", constituents := [ 2 ], contents := "core",
  dim := 3, 
  generators := 
    [ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ -E(5)-E(5)^4, -E(5)-E(5)^4, 1 ] 
         ], [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ] ], 
  groupname := "A5", id := "a", 
  identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
  polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
  ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
  type := "matalg" )

##  doc/../gap/interfac.gd (833-850)
gap> gens1max2:= AtlasGenerators( "A5", 1, 2 );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", generators := [ (1,2)(3,4), (2,3)(4,5) ], 
  groupname := "D10", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5, 2 ],
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 10, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> id:= gens1max2.identifier;;
gap> gens1max2 = AtlasGenerators( id );
true
gap> max2:= Group( gens1max2.generators );;
gap> Size( max2 );
10
gap> IdGroup( max2 ) = IdGroup( DihedralGroup( 10 ) );
true

##  doc/../gap/interfac.gd (1166-1186)
gap> prog:= AtlasProgram( "A5", 2 );
rec( groupname := "A5", identifier := [ "A5", "A5G1-max2W1", 1 ], 
  program := <straight line program>, size := 10, 
  standardization := 1, subgroupname := "D10", version := "1" )
gap> StringOfResultOfStraightLineProgram( prog.program, [ "a", "b" ] );
"[ a, bbab ]"
gap> gens1:= AtlasGenerators( "A5", 1 );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
  groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> maxgens:= ResultOfStraightLineProgram( prog.program,
>                  gens1.generators );
[ (1,2)(3,4), (2,3)(4,5) ]
gap> maxgens = gens1max2.generators;
true

##  doc/../gap/interfac.gd (1201-1212)
gap> prog:= AtlasProgram( "J1", "cyclic" );
rec( groupname := "J1", identifier := [ "J1", "J1G1-cycW1", 1 ], 
  outputs := [ "6A", "7A", "10B", "11A", "15B", "19A" ], 
  program := <straight line program>, standardization := 1, 
  version := "1" )
gap> gens:= GeneratorsOfGroup( FreeGroup( "x", "y" ) );;
gap> ResultOfStraightLineProgram( prog.program, gens );
[ (x*y)^2*((y*x)^2*y^2*x)^2*y^2, x*y, (x*(y*x*y)^2)^2*y, 
  (x*y*x*(y*x*y)^3*x*y^2)^2*x*y*x*(y*x*y)^2*y, x*y*x*(y*x*y)^2*y, 
  (x*y)^2*y ]

##  doc/../gap/interfac.gd (903-907)
gap> AtlasProgramInfo( "J1", "cyclic" );
rec( groupname := "J1", identifier := [ "J1", "J1G1-cycW1", 1 ], 
  standardization := 1, version := "1" )

##  doc/../gap/interfac.gd (1297-1321)
gap> info:= OneAtlasGeneratingSetInfo( "A5" );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> gens:= AtlasGenerators( info.identifier );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
  groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> info = OneAtlasGeneratingSetInfo( "A5", IsPermGroup, true );
true
gap> info = OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, "minimal" );
true
gap> info = OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, [ 1 .. 10 ] );
true
gap> OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, 20 );
fail

##  doc/../gap/interfac.gd (1331-1415)
gap> info:= OneAtlasGeneratingSetInfo( "A5", IsMatrixGroup, true );
rec( charactername := "4a", constituents := [ 4 ], contents := "core",
  dim := 4, groupname := "A5", id := "a", 
  identifier := [ "A5", [ "A5G1-f2r4aB0.m1", "A5G1-f2r4aB0.m2" ], 1, 
      2 ], repname := "A5G1-f2r4aB0", repnr := 4, ring := GF(2), 
  size := 60, standardization := 1, type := "matff" )
gap> gens:= AtlasGenerators( info.identifier );
rec( charactername := "4a", constituents := [ 4 ], contents := "core",
  dim := 4, 
  generators := [ <an immutable 4x4 matrix over GF2>, 
      <an immutable 4x4 matrix over GF2> ], groupname := "A5", 
  id := "a", 
  identifier := [ "A5", [ "A5G1-f2r4aB0.m1", "A5G1-f2r4aB0.m2" ], 1, 
      2 ], repname := "A5G1-f2r4aB0", repnr := 4, ring := GF(2), 
  size := 60, standardization := 1, type := "matff" )
gap> info = OneAtlasGeneratingSetInfo( "A5", Dimension, 4 );
true
gap> info = OneAtlasGeneratingSetInfo( "A5", Characteristic, 2 );
true
gap> info2:= OneAtlasGeneratingSetInfo( "A5", Ring, GF(2) );;
gap> info.identifier = info2.identifier; 
true
gap> OneAtlasGeneratingSetInfo( "A5", Characteristic, [2,5], Dimension, 2 );
rec( charactername := "2a", constituents := [ 2 ], contents := "core",
  dim := 2, groupname := "A5", id := "a", 
  identifier := [ "A5", [ "A5G1-f4r2aB0.m1", "A5G1-f4r2aB0.m2" ], 1, 
      4 ], repname := "A5G1-f4r2aB0", repnr := 8, ring := GF(2^2), 
  size := 60, standardization := 1, type := "matff" )
gap> OneAtlasGeneratingSetInfo( "A5", Characteristic, [2,5], Dimension, 1 );
fail
gap> info:= OneAtlasGeneratingSetInfo( "A5", Characteristic, 0,
>                                            Dimension, 4 );
rec( charactername := "4a", constituents := [ 4 ], contents := "core",
  dim := 4, groupname := "A5", id := "", 
  identifier := [ "A5", "A5G1-Zr4B0.g", 1, 4 ], 
  repname := "A5G1-Zr4B0", repnr := 14, ring := Integers, size := 60, 
  standardization := 1, type := "matint" )
gap> gens:= AtlasGenerators( info.identifier );
rec( charactername := "4a", constituents := [ 4 ], contents := "core",
  dim := 4, 
  generators := 
    [ 
      [ [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], 
          [ -1, -1, -1, -1 ] ], 
      [ [ 0, 1, 0, 0 ], [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], 
          [ 1, 0, 0, 0 ] ] ], groupname := "A5", id := "", 
  identifier := [ "A5", "A5G1-Zr4B0.g", 1, 4 ], 
  repname := "A5G1-Zr4B0", repnr := 14, ring := Integers, size := 60, 
  standardization := 1, type := "matint" )
gap> info = OneAtlasGeneratingSetInfo( "A5", Ring, Integers );
true
gap> info2:= OneAtlasGeneratingSetInfo( "A5", Ring, CF(37) );;
gap> info = info2;
false
gap> Difference( RecNames( info2 ), RecNames( info ) );
[ "givenRing" ]
gap> info2.givenRing;
CF(37)
gap> OneAtlasGeneratingSetInfo( "A5", Ring, Integers mod 77 );
fail
gap> info:= OneAtlasGeneratingSetInfo( "A5", Ring, CF(5), Dimension, 3 );
rec( charactername := "3a", constituents := [ 2 ], contents := "core",
  dim := 3, givenRing := CF(5), groupname := "A5", id := "a", 
  identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
  polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
  ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
  type := "matalg" )
gap> gens:= AtlasGenerators( info );
rec( charactername := "3a", constituents := [ 2 ], contents := "core",
  dim := 3, 
  generators := 
    [ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ -E(5)-E(5)^4, -E(5)-E(5)^4, 1 ] 
         ], [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ] ], 
  givenRing := CF(5), groupname := "A5", id := "a", 
  identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
  polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
  ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
  type := "matalg" )
gap> gens2:= AtlasGenerators( info.identifier );;
gap> Difference( RecNames( gens ), RecNames( gens2 ) );
[ "givenRing" ]
gap> OneAtlasGeneratingSetInfo( "A5", Ring, GF(17) );
fail

##  doc/../gap/interfac.gd (1451-1474)
gap> AllAtlasGeneratingSetInfos( "A5", IsPermGroup, true );
[ rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
      contents := "core", groupname := "A5", id := "", 
      identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ]
        , isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
      repname := "A5G1-p5B0", repnr := 1, size := 60, 
      stabilizer := "A4", standardization := 1, transitivity := 3, 
      type := "perm" ), 
  rec( charactername := "1a+5a", constituents := [ 1, 5 ], 
      contents := "core", groupname := "A5", id := "", 
      identifier := [ "A5", [ "A5G1-p6B0.m1", "A5G1-p6B0.m2" ], 1, 6 ]
        , isPrimitive := true, maxnr := 2, p := 6, rankAction := 2, 
      repname := "A5G1-p6B0", repnr := 2, size := 60, 
      stabilizer := "D10", standardization := 1, transitivity := 2, 
      type := "perm" ), 
  rec( charactername := "1a+4a+5a", constituents := [ 1, 4, 5 ], 
      contents := "core", groupname := "A5", id := "", 
      identifier := [ "A5", [ "A5G1-p10B0.m1", "A5G1-p10B0.m2" ], 1, 
          10 ], isPrimitive := true, maxnr := 3, p := 10, 
      rankAction := 3, repname := "A5G1-p10B0", repnr := 3, 
      size := 60, stabilizer := "S3", standardization := 1, 
      transitivity := 1, type := "perm" ) ]

##  doc/../gap/interfac.gd (1616-1619)
gap> g:= AtlasGroup( "A5" );
Group([ (1,2)(3,4), (1,3,5) ])

##  doc/../gap/interfac.gd (1627-1639)
gap> info:= OneAtlasGeneratingSetInfo( "A5" );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> AtlasGroup( info );
Group([ (1,2)(3,4), (1,3,5) ])
gap> AtlasGroup( info.identifier );
Group([ (1,2)(3,4), (1,3,5) ])

##  doc/../gap/interfac.gd (1710-1715)
gap> g:= AtlasSubgroup( "A5", NrMovedPoints, 5, 1 );
Group([ (1,5)(2,3), (1,3,5) ])
gap> NrMovedPoints( g );
4

##  doc/../gap/interfac.gd (1725-1739)
gap> info:= OneAtlasGeneratingSetInfo( "A5" );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )
gap> AtlasSubgroup( info, 1 );
Group([ (1,5)(2,3), (1,3,5) ])
gap> AtlasSubgroup( info.identifier, 1 );
Group([ (1,5)(2,3), (1,3,5) ])
gap> AtlasSubgroup( AtlasGroup( "A5" ), 1 );
Group([ (1,5)(2,3), (1,3,5) ])

##  doc/../gap/interfac.gd (1512-1520)
gap> AtlasRepInfoRecord( AtlasGroup( "A5" ) );
rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
  contents := "core", groupname := "A5", id := "", 
  identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
  isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
  repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
  standardization := 1, transitivity := 3, type := "perm" )

##  doc/../gap/interfac.gd (1566-1574)
gap> AtlasRepInfoRecord( "A5" );
rec( name := "A5", nrMaxes := 3, size := 60, 
  sizesMaxes := [ 12, 10, 6 ], 
  slpMaxes := [ [ 1 .. 3 ], [ [ 1 ], [ 1 ], [ 1 ] ] ], 
  structureMaxes := [ "A4", "D10", "S3" ] )
gap> AtlasRepInfoRecord( "J5" );
rec(  )

##  doc/../gap/interfac.gd (1795-1817)
gap> g:= MathieuGroup( 12 );;
gap> gens:= GeneratorsOfGroup( g );;  # switch to 2 generators
gap> g:= Group( gens[1] * gens[3], gens[2] * gens[3] );;
gap> EvaluatePresentation( g, "J0" );  # no pres. for group "J0"
fail
gap> relimgs:= EvaluatePresentation( g, "M11" );;
gap> List( relimgs, Order );  # wrong group
[ 3, 1, 5, 4, 10 ]
gap> relimgs:= EvaluatePresentation( g, "M12" );;
gap> List( relimgs, Order );  # generators are not standard
[ 3, 4, 5, 4, 4 ]
gap> g:= AtlasGroup( "M12" );;
gap> relimgs:= EvaluatePresentation( g, "M12", 1 );;
gap> List( relimgs, Order );  # right group, std. generators
[ 1, 1, 1, 1, 1 ]
gap> g:= AtlasGroup( "2.M12" );;
gap> relimgs:= EvaluatePresentation( g, "M12", 1 );;
gap> List( relimgs, Order );  # std. generators for extension
[ 1, 2, 1, 1, 2 ]
gap> Size( NormalClosure( g, SubgroupNC( g, relimgs ) ) );
2

##  doc/../gap/interfac.gd (1952-1960)
gap> StandardGeneratorsData( MathieuGroup( 11 ), "J0" );
fail
gap> StandardGeneratorsData( MathieuGroup( 11 ), "M12" );
"timeout"
gap> repeat
>      res:= StandardGeneratorsData( MathieuGroup( 12 ), "M11" );
>    until res = fail;

##  doc/../gap/interfac.gd (1968-1982)
gap> gens:= GeneratorsOfGroup( MathieuGroup( 12 ) );;
gap> std:= 1;;
gap> res:= StandardGeneratorsData( gens, "M12", std );;
gap> Set( RecNames( res ) );
[ "gapname", "givengens", "givengenstostdgens", "std", "stdgens" ]
gap> gens = res.givengens;
true
gap> ResultOfStraightLineProgram( res.givengenstostdgens, gens )
>    = res.stdgens;
true
gap> evl:= EvaluatePresentation( res.stdgens, "M12", std );;
gap> ForAll( evl, IsOne );
true

##  doc/../gap/interfac.gd (1993-2007)
gap> g:= AtlasGroup( "2.M12", IsMatrixGroup, Characteristic, IsPosInt );;
gap> gens:= Permuted( GeneratorsOfGroup( g ), (1,2) );;
gap> res:= StandardGeneratorsData( gens, "M12", std : projective );;
gap> gens = res.givengens;
true
gap> ResultOfStraightLineProgram( res.givengenstostdgens, gens )
>    = res.stdgens;
true
gap> evl:= EvaluatePresentation( res.stdgens, "M12", std );;
gap> ForAll( evl, IsOne );
false
gap> ForAll( evl, x -> IsCentral( g, x ) );
true

##  doc/../gap/brmindeg.g (29-44)
gap> if IsBound( BrowseMinimalDegrees ) then
>   down:= NCurses.keys.DOWN;;  DOWN:= NCurses.keys.NPAGE;;
>   right:= NCurses.keys.RIGHT;;  END:= NCurses.keys.END;;
>   enter:= NCurses.keys.ENTER;;  nop:= [ 14, 14, 14 ];;
>   # just scroll in the table
>   BrowseData.SetReplay( Concatenation( [ DOWN, DOWN, DOWN,
>          right, right, right ], "sedddrrrddd", nop, nop, "Q" ) );
>   BrowseMinimalDegrees();;
>   # restrict the table to the groups with minimal ordinary degree 6
>   BrowseData.SetReplay( Concatenation( "scf6",
>        [ down, down, right, enter, enter ] , nop, nop, "Q" ) );
>   BrowseMinimalDegrees();;
>   BrowseData.SetReplay( false );
> fi;

##  doc/../gap/brmindeg.g (55-62)
gap> if IsBound( BrowseMinimalDegrees ) then
>   # just scroll in the table
>   BrowseData.SetReplay( Concatenation( [ DOWN, DOWN, DOWN, END ],
>          "rrrrrrrrrrrrrr", nop, nop, "Q" ) );
>   BrowseMinimalDegrees( BibliographySporadicSimple.groupNamesJan05 );;
> fi;

##  doc/../gap/brspor.g (163-176)
gap> if IsBound( BrowseBibliographySporadicSimple ) then
>   enter:= NCurses.keys.ENTER;;  nop:= [ 14, 14, 14 ];;
>   BrowseData.SetReplay( Concatenation(
>     # choose the application
>     "/Bibliography of Sporadic Simple Groups", [ enter, enter ],
>     # search in the title column for the Atlas of Finite Groups
>     "scr/Atlas of finite groups", [ enter,
>     # and quit
>     nop, nop, nop, nop ], "Q" ) );
>   BrowseGapData();;
>   BrowseData.SetReplay( false );
> fi;

##  doc/extend.xml (126-129)
gap> locallevel:= InfoLevel( InfoAtlasRep );;
gap> SetInfoLevel( InfoAtlasRep, 1 );

##  doc/extend.xml (174-191)
gap> prv:= DirectoryTemporary( "privdir" );;
gap> FileString( Filename( prv, "C4G1-p4B0.m1" ),
>                MeatAxeString( [ (1,2,3,4) ], 4 ) );;
gap> FileString( Filename( prv, "C4G1-max1W1" ),
>                "inp 1\npwr 2 1 2\noup 1 2\n" );;
gap> FileString( Filename( prv, "C4G1-XtestW1" ),
>                "inp 1\npwr 2 1 2\noup 1 2\n" );;
gap> FileString( Filename( prv, "C4G1-a2W1" ),
>                "inp 1\npwr 3 1 2\noup 1 2\n" );;
gap> FileString( Filename( prv, "C4G1-Ar1aB0.g" ),
>                "return rec( generators:= [ [[E(4)]] ] );\n" );;
gap> points:= Elements( AlternatingGroup( 5 ) );;
gap> FileString( Filename( prv, "A5G1-p60B0.m1" ),
>      MeatAxeString( [ Permutation( (1,2)(3,4), points, OnRight ) ], 60 ) );;
gap> FileString( Filename( prv, "A5G1-p60B0.m2" ),
>      MeatAxeString( [ Permutation( (1,3,5), points, OnRight ) ], 60 ) );;

##  doc/extend.xml (213-228)
gap> FileString( Filename( prv, "toc.json" ), Concatenation( [ "{\n",
>        "\"ID\":\"priv\",\n",
>        "\"Data\":[\n",
>        "[\"GNAN\",[\"C4\",\"C4\"]],\n",
>        "[\"GRS\",[\"C4\",4]],\n",
>        "[\"MXN\",[\"C4\",1]],\n",
>        "[\"MXO\",[\"C4\",[2]]],\n",
>        "[\"MXS\",[\"C4\",[\"C2\"]]],\n",
>        "[\"RNG\",[\"C4G1-Ar1aB0\",\"CF(4)\",",
>                  "[\"QuadraticField\",-1],[1,0,1]]],\n",
>        "[\"API\",[\"C4G1-p4B0\",[1,4,\"imprim\",\"1 < C2\"]]],\n",
>        "[\"API\",[\"A5G1-p60B0\",[1,60,\"imprim\",\"1 < S3\"]]]\n",
>        "]\n",
>        "}\n" ] ) );;

##  doc/extend.xml (236-239)
gap> AtlasOfGroupRepresentationsNotifyData( prv, "priv", true );
true

##  doc/extend.xml (247-328)
gap> DisplayAtlasInfo( [ "C4" ] );
group | # | maxes | cl | cyc | out | fnd | chk | prs
------+---+-------+----+-----+-----+-----+-----+----
C4*   | 2 |     1 |    |     |   2 |     |     |    
gap> DisplayAtlasInfo( "C4" );
Representations for G = C4:    (all refer to std. generators 1)
---------------------------
1: G <= Sym(4)*       rank 4, on cosets of 1 < C2
2: G <= GL(1a,CF(4))* 

Programs for G = C4:    (all refer to std. generators 1)
--------------------
- automorphisms*:
  2*               
- maxes (all 1):
  1*:  C2          
- other scripts*:
  "test"*          
gap> DisplayAtlasInfo( "C4", IsPermGroup, true );
Representations for G = C4:    (all refer to std. generators 1)
---------------------------
1: G <= Sym(4)* rank 4, on cosets of 1 < C2
gap> DisplayAtlasInfo( "C4", IsMatrixGroup );
Representations for G = C4:    (all refer to std. generators 1)
---------------------------
2: G <= GL(1a,CF(4))* 
gap> DisplayAtlasInfo( "C4", Dimension, 2 );
gap> DisplayAtlasInfo( "A5", NrMovedPoints, 60 );
Representations for G = A5:    (all refer to std. generators 1)
---------------------------
4: G <= Sym(60)* rank 60, on cosets of 1 < S3
gap> info:= OneAtlasGeneratingSetInfo( "C4" );
rec( contents := "priv", groupname := "C4", id := "", 
  identifier := [ "C4", [ [ "priv", "C4G1-p4B0.m1" ] ], 1, 4 ], 
  isPrimitive := false, p := 4, rankAction := 4, 
  repname := "C4G1-p4B0", repnr := 1, size := 4, 
  stabilizer := "1 < C2", standardization := 1, transitivity := 1, 
  type := "perm" )
gap> AtlasGenerators( info.identifier );
rec( contents := "priv", generators := [ (1,2,3,4) ], 
  groupname := "C4", id := "", 
  identifier := [ "C4", [ [ "priv", "C4G1-p4B0.m1" ] ], 1, 4 ], 
  isPrimitive := false, p := 4, rankAction := 4, 
  repname := "C4G1-p4B0", repnr := 1, size := 4, 
  stabilizer := "1 < C2", standardization := 1, transitivity := 1, 
  type := "perm" )
gap> AtlasProgram( "C4", 1 );
rec( groupname := "C4", 
  identifier := [ "C4", [ [ "priv", "C4G1-max1W1" ] ], 1 ], 
  program := <straight line program>, size := 2, standardization := 1,
  subgroupname := "C2", version := "1" )
gap> AtlasProgram( "C4", "maxes", 1 );
rec( groupname := "C4", 
  identifier := [ "C4", [ [ "priv", "C4G1-max1W1" ] ], 1 ], 
  program := <straight line program>, size := 2, standardization := 1,
  subgroupname := "C2", version := "1" )
gap> AtlasProgram( "C4", "maxes", 2 );
fail
gap> AtlasGenerators( "C4", 1 );
rec( contents := "priv", generators := [ (1,2,3,4) ], 
  groupname := "C4", id := "", 
  identifier := [ "C4", [ [ "priv", "C4G1-p4B0.m1" ] ], 1, 4 ], 
  isPrimitive := false, p := 4, rankAction := 4, 
  repname := "C4G1-p4B0", repnr := 1, size := 4, 
  stabilizer := "1 < C2", standardization := 1, transitivity := 1, 
  type := "perm" )
gap> AtlasGenerators( "C4", 2 );
rec( contents := "priv", dim := 1, generators := [ [ [ E(4) ] ] ], 
  groupname := "C4", id := "a", 
  identifier := [ "C4", [ [ "priv", "C4G1-Ar1aB0.g" ] ], 1, 1 ], 
  polynomial := [ 1, 0, 1 ], repname := "C4G1-Ar1aB0", repnr := 2, 
  ring := GaussianRationals, size := 4, standardization := 1, 
  type := "matalg" )
gap> AtlasGenerators( "C4", 3 );
fail
gap> AtlasProgram( "C4", "other", "test" );
rec( groupname := "C4", 
  identifier := [ "C4", [ [ "priv", "C4G1-XtestW1" ] ], 1 ], 
  program := <straight line program>, standardization := 1, 
  version := "1" )

##  doc/extend.xml (337-343)
gap> DisplayAtlasInfo( "contents", "priv" );
group | # | maxes | cl | cyc | out | fnd | chk | prs
------+---+-------+----+-----+-----+-----+-----+----
A5*   | 1 |       |    |     |     |     |     |    
C4*   | 2 |     1 |    |     |   2 |     |     |    

##  doc/extend.xml (352-372)
gap> AGR.Test.Words( "priv" );
true
gap> AGR.Test.FileHeaders( "priv" );
true
gap> AGR.Test.Files( "priv" );
true
gap> AGR.Test.BinaryFormat( "priv" );
true
gap> AGR.Test.Primitivity( "priv" : TryToExtendData );
true
gap> AGR.Test.Characters( "priv" : TryToExtendData );
#I  AGR.Test.Character:
#I  add new info
["CHAR",["A5","A5G1-p60B0",
0,[1,[2,3],[3,3],[4,4],[5,5]],"1a+3a^3b^3+4a^4+5a^5"]],
#I  AGR.Test.Character:
#I  add new info
["CHAR",["C4","C4G1-p4B0",0,[1,2,3,4],"1abcd"]],
true

##  doc/extend.xml (395-409)
gap> AGR.CHAR("A5","A5G1-p60B0",
> 0,[1,[2,3],[3,3],[4,4],[5,5]],"1a+3a^3b^3+4a^4+5a^5", "priv" );
gap> AGR.CHAR("C4","C4G1-p4B0",0,[1,2,3,4],"1abcd", "priv" );
gap> AGR.Test.Characters( "priv" );
true
gap> OneAtlasGeneratingSetInfo( "C4" );
rec( charactername := "1abcd", constituents := [ 1, 2, 3, 4 ], 
  contents := "priv", groupname := "C4", id := "", 
  identifier := [ "C4", [ [ "priv", "C4G1-p4B0.m1" ] ], 1, 4 ], 
  isPrimitive := false, p := 4, rankAction := 4, 
  repname := "C4G1-p4B0", repnr := 1, size := 4, 
  stabilizer := "1 < C2", standardization := 1, transitivity := 1, 
  type := "perm" )

##  doc/extend.xml (417-442)
gap> Print( StringOfAtlasTableOfContents( "priv" ) );
{
"ID":"priv",
"Data":[
["GNAN",["C4","C4"]],

["GRS",["C4",4]],

["MXN",["C4",1]],

["MXO",["C4",[2]]],

["MXS",["C4",["C2"]]],

["RNG",["C4G1-Ar1aB0","CF(4)",["QuadraticField",-1],[1,0,1]]],

["API",["A5G1-p60B0",[1,60,"imprim","1 < S3"]]],
["API",["C4G1-p4B0",[1,4,"imprim","1 < C2"]]],

["CHAR",["A5","A5G1-p60B0",0,[1,[2,3],[3,3],[4,4],[5,5]],"1a+3a^3b^3+4\
a^4+5a^5"]],
["CHAR",["C4","C4G1-p4B0",0,[1,2,3,4],"1abcd"]]
]
}

##  doc/extend.xml (452-486)
gap> Print( StringOfAtlasTableOfContents(
>               rec( ID:= "priv", DataURL:= "http://someurl" ) ) );
{
"ID":"priv",
"DataURL":"http://someurl",
"Data":[
["GNAN",["C4","C4"]],

["GRS",["C4",4]],

["MXN",["C4",1]],

["MXO",["C4",[2]]],

["MXS",["C4",["C2"]]],

["TOC",["perm","A5G1-p60B0.m",[118815263,24584221]]],
["TOC",["matalg","C4G1-Ar1aB0.g",[49815028]]],
["TOC",["otherscripts","C4G1-XtestW1",[-27672877]]],
["TOC",["out","C4G1-a2W1",[126435524]]],
["TOC",["maxes","C4G1-max1W1",[-27672877]]],
["TOC",["perm","C4G1-p4B0.m",[102601978]]],

["RNG",["C4G1-Ar1aB0","CF(4)",["QuadraticField",-1],[1,0,1]]],

["API",["A5G1-p60B0",[1,60,"imprim","1 < S3"]]],
["API",["C4G1-p4B0",[1,4,"imprim","1 < C2"]]],

["CHAR",["A5","A5G1-p60B0",0,[1,[2,3],[3,3],[4,4],[5,5]],"1a+3a^3b^3+4\
a^4+5a^5"]],
["CHAR",["C4","C4G1-p4B0",0,[1,2,3,4],"1abcd"]]
]
}

##  doc/extend.xml (497-500)
gap> AtlasOfGroupRepresentationsForgetData( "priv" );
gap> SetInfoLevel( InfoAtlasRep, locallevel );

##  doc/../gap/bbox.gd (551-558)
gap> dec:= StraightLineDecision( [ [ [ 1, 1, 2, 1 ], 3 ],
> [ "Order", 1, 2 ], [ "Order", 2, 3 ], [ "Order", 3, 5 ] ] );
<straight line decision>
gap> LinesOfStraightLineDecision( dec );
[ [ [ 1, 1, 2, 1 ], 3 ], [ "Order", 1, 2 ], [ "Order", 2, 3 ], 
  [ "Order", 3, 5 ] ]

##  doc/../gap/bbox.gd (581-584)
gap> NrInputsOfStraightLineDecision( dec );
2

##  doc/../gap/scanmtx.gd (670-685)
gap> str:= "inp 2\nchor 1 2\nchor 2 3\nmu 1 2 3\nchor 3 5";;
gap> prg:= ScanStraightLineDecision( str );
rec( program := <straight line decision> )
gap> prg:= prg.program;;
gap> Display( prg );
# input:
r:= [ g1, g2 ];
# program:
if Order( r[1] ) <> 2 then  return false;  fi;
if Order( r[2] ) <> 3 then  return false;  fi;
r[3]:= r[1]*r[2];
if Order( r[3] ) <> 5 then  return false;  fi;
# return value:
true

##  doc/../gap/bbox.gd (648-653)
gap> dec:= StraightLineDecision( [ ], 1 );
<straight line decision>
gap> ResultOfStraightLineDecision( dec, [ () ] );
true

##  doc/../gap/bbox.gd (658-669)
gap> dec:= StraightLineDecision( [ [ [ 1, 1, 2, 1 ], 3 ],
>       [ "Order", 1, 2 ], [ "Order", 2, 3 ], [ "Order", 3, 5 ] ] );
<straight line decision>
gap> LinesOfStraightLineDecision( dec );
[ [ [ 1, 1, 2, 1 ], 3 ], [ "Order", 1, 2 ], [ "Order", 2, 3 ], 
  [ "Order", 3, 5 ] ]
gap> ResultOfStraightLineDecision( dec, [ (), () ] );
false
gap> ResultOfStraightLineDecision( dec, [ (1,2)(3,4), (1,4,5) ] );
true

##  doc/../gap/bbox.gd (762-790)
gap> check:= AtlasProgram( "L2(8)", "check" );
rec( groupname := "L2(8)", 
  identifier := [ "L2(8)", "L28G1-check1", 1, 1 ], 
  program := <straight line decision>, standardization := 1, 
  version := "1" )
gap> gens:= AtlasGenerators( "L2(8)", 1 );
rec( charactername := "1a+8a", constituents := [ 1, 6 ], 
  contents := "core", 
  generators := [ (1,2)(3,4)(6,7)(8,9), (1,3,2)(4,5,6)(7,8,9) ], 
  groupname := "L2(8)", id := "", 
  identifier := [ "L2(8)", [ "L28G1-p9B0.m1", "L28G1-p9B0.m2" ], 1, 9 
     ], isPrimitive := true, maxnr := 1, p := 9, rankAction := 2, 
  repname := "L28G1-p9B0", repnr := 1, size := 504, 
  stabilizer := "2^3:7", standardization := 1, transitivity := 3, 
  type := "perm" )
gap> ResultOfStraightLineDecision( check.program, gens.generators );
true
gap> gens:= AtlasGenerators( "L3(2)", 1 );
rec( contents := "core", generators := [ (2,4)(3,5), (1,2,3)(5,6,7) ],
  groupname := "L3(2)", id := "a", 
  identifier := [ "L3(2)", [ "L27G1-p7aB0.m1", "L27G1-p7aB0.m2" ], 1, 
      7 ], isPrimitive := true, maxnr := 1, p := 7, rankAction := 2, 
  repname := "L27G1-p7aB0", repnr := 1, size := 168, 
  stabilizer := "S4", standardization := 1, transitivity := 2, 
  type := "perm" )
gap> ResultOfStraightLineDecision( check.program, gens.generators );
true

##  doc/../gap/bbox.gd (978-990)
gap> lines:= [ [ "Order", 1, 2 ], [ "Order", 2, 3 ],
>              [ [ 1, 1, 2, 1 ], 3 ], [ "Order", 3, 5 ] ];;
gap> dec:= StraightLineDecision( lines, 2 );
<straight line decision>
gap> bboxdec:= AsBBoxProgram( dec );
<black box program>
gap> asdec:= AsStraightLineDecision( bboxdec );
<straight line decision>
gap> LinesOfStraightLineDecision( asdec );
[ [ "Order", 1, 2 ], [ "Order", 2, 3 ], [ [ 1, 1, 2, 1 ], 3 ], 
  [ "Order", 3, 5 ] ]

##  doc/../gap/bbox.gd (828-850)
gap> dec:= StraightLineDecision( [ [ [ 1, 1, 2, 1 ], 3 ],
> [ "Order", 1, 2 ], [ "Order", 2, 3 ], [ "Order", 3, 5 ] ] );
<straight line decision>
gap> prog:= StraightLineProgramFromStraightLineDecision( dec );
<straight line program>
gap> Display( prog );
# input:
r:= [ g1, g2 ];
# program:
r[3]:= r[1]*r[2];
r[4]:= r[1]^2;
r[5]:= r[2]^3;
r[6]:= r[3]^5;
# return values:
[ r[4], r[5], r[6] ]
gap> StringOfResultOfStraightLineProgram( prog, [ "a", "b" ] );
"[ a^2, b^3, (ab)^5 ]"
gap> gens:= GeneratorsOfGroup( FreeGroup( "a", "b" ) );
[ a, b ]
gap> ResultOfStraightLineProgram( prog, gens );
[ a^2, b^3, (a*b)^5 ]

##  doc/../gap/bbox.gd (188-219)
gap> findstr:= "\
>   set V 0\n\
> lbl START1\n\
>   rand 1\n\
>   ord 1 A\n\
>   incr V\n\
>   if V gt 100 then timeout\n\
>   if A notin 1 2 3 5 then fail\n\
>   if A noteq 2 then jmp START1\n\
> lbl START2\n\
>   rand 2\n\
>   ord 2 B\n\
>   incr V\n\
>   if V gt 100 then timeout\n\
>   if B notin 1 2 3 5 then fail\n\
>   if B noteq 3 then jmp START2\n\
>   # The elements 1 and 2 have the orders 2 and 3, respectively.\n\
>   set X 0\n\
> lbl CONJ\n\
>   incr X\n\
>   if X gt 100 then timeout\n\
>   rand 3\n\
>   cjr 2 3\n\
>   mu 1 2 4   # ab\n\
>   ord 4 C\n\
>   if C notin 2 3 5 then fail\n\
>   if C noteq 5 then jmp CONJ\n\
>   oup 2 1 2";;
gap> find:= ScanBBoxProgram( findstr );
rec( program := <black box program> )

##  doc/../gap/bbox.gd (224-232)
gap> checkstr:= "\
> chor 1 2\n\
> chor 2 3\n\
> mu 1 2 3\n\
> chor 3 5";;
gap> check:= ScanBBoxProgram( checkstr );
rec( program := <black box program> )

##  doc/../gap/bbox.gd (328-348)
gap> g:= AlternatingGroup( 5 );;
gap> res:= RunBBoxProgram( find.program, g, [], rec() );;
gap> IsBound( res.gens );  IsBound( res.result );
true
false
gap> List( res.gens, Order );
[ 2, 3 ]
gap> Order( Product( res.gens ) );
5
gap> res:= RunBBoxProgram( check.program, "dummy", res.gens, rec() );;
gap> IsBound( res.gens );  IsBound( res.result );
false
true
gap> res.result;
true
gap> othergens:= GeneratorsOfGroup( g );;
gap> res:= RunBBoxProgram( check.program, "dummy", othergens, rec() );;
gap> res.result;
false

##  doc/../gap/bbox.gd (386-398)
gap> g:= AlternatingGroup( 5 );;
gap> res:= ResultOfBBoxProgram( find.program, g );;
gap> List( res, Order );
[ 2, 3 ]
gap> Order( Product( res ) );
5
gap> res:= ResultOfBBoxProgram( check.program, res );
true
gap> othergens:= GeneratorsOfGroup( g );;
gap> res:= ResultOfBBoxProgram( check.program, othergens );
false

##  doc/../gap/bbox.gd (884-908)
gap> f:= FreeGroup( "x", "y" );;  gens:= GeneratorsOfGroup( f );;
gap> slp:= StraightLineProgram( [ [1,2,2,3], [3,-1] ], 2 );
<straight line program>
gap> ResultOfStraightLineProgram( slp, gens );
y^-3*x^-2
gap> bboxslp:= AsBBoxProgram( slp );
<black box program>
gap> ResultOfBBoxProgram( bboxslp, gens );
[ y^-3*x^-2 ]
gap> lines:= [ [ "Order", 1, 2 ], [ "Order", 2, 3 ],
>              [ [ 1, 1, 2, 1 ], 3 ], [ "Order", 3, 5 ] ];;
gap> dec:= StraightLineDecision( lines, 2 );
<straight line decision>
gap> ResultOfStraightLineDecision( dec, [ (1,2)(3,4), (1,3,5) ] );
true
gap> ResultOfStraightLineDecision( dec, [ (1,2)(3,4), (1,3,4) ] );
false
gap> bboxdec:= AsBBoxProgram( dec );
<black box program>
gap> ResultOfBBoxProgram( bboxdec, [ (1,2)(3,4), (1,3,5) ] );
true
gap> ResultOfBBoxProgram( bboxdec, [ (1,2)(3,4), (1,3,4) ] );
false

##  doc/../gap/bbox.gd (937-950)
gap> Display( AsStraightLineProgram( bboxslp ) );
# input:
r:= [ g1, g2 ];
# program:
r[3]:= r[1]^2;
r[4]:= r[2]^3;
r[5]:= r[3]*r[4];
r[3]:= r[5]^-1;
# return values:
[ r[3] ]
gap> AsStraightLineProgram( bboxdec );
fail

##  doc/../gap/mindeg.gd (192-203)
gap> MinimalRepresentationInfo( "A5", NrMovedPoints );
rec( 
  source := [ "computed (alternating group)", 
      "computed (char. table)", "computed (subgroup tables)", 
      "computed (subgroup tables, known repres.)", 
      "computed (table of marks)" ], value := 5 )
gap> MinimalRepresentationInfo( "A5", Characteristic, 2 );
rec( source := [ "computed (char. table)" ], value := 2 )
gap> MinimalRepresentationInfo( "A5", Size, 2 );
rec( source := [ "computed (char. table)" ], value := 4 )

##  doc/../gap/mindeg.gd (336-355)
gap> SetMinimalRepresentationInfo( "A5", "NrMovedPoints", 5,
>      "computed (alternating group)" );
true
gap> SetMinimalRepresentationInfo( "A5", [ "Characteristic", 0 ], 3,
>      "computed (char. table)" );
true
gap> SetMinimalRepresentationInfo( "A5", [ "Characteristic", 2 ], 2,
>      "computed (char. table)" );
true
gap> SetMinimalRepresentationInfo( "A5", [ "Size", 2 ], 4,
>      "computed (char. table)" );
true
gap> SetMinimalRepresentationInfo( "A5", [ "Size", 4 ], 2,
>      "computed (char. table)" );
true
gap> SetMinimalRepresentationInfo( "A5", [ "Characteristic", 3 ], 3,
>      "computed (char. table)" );
true

##  doc/../gap/json.g (128-137)
gap> l:= [ [ 1 ] ];; l[2]:= l[1];;  l;
[ [ 1 ], [ 1 ] ]
gap> new:= AGR.GapObjectOfJsonText( AGR.JsonText( l ) ).value;
[ [ 1 ], [ 1 ] ]
gap> Add( l[1], 2 );  l;
[ [ 1, 2 ], [ 1, 2 ] ]
gap> Add( new[1], 2 );  new;
[ [ 1, 2 ], [ 1 ] ]

##  doc/../gap/json.g (142-144)
gap> l:= [];;  l[1]:= l;;

##  doc/../gap/json.g (298-314)
gap> AGR.JsonText( [] );
"[]"
gap> AGR.JsonText( "" );
"\"\""
gap> AGR.JsonText( "abc\ndef\cghi" );
"\"abc\\ndef\\u0003ghi\""
gap> AGR.JsonText( rec() );
"{}"
gap> AGR.JsonText( [ , 2 ] );
fail
gap> str:= [ '\303', '\266' ];;  # umlaut o
gap> json:= AGR.JsonText( str );;  List( json, IntChar );
[ 34, 195, 182, 34 ]
gap> AGR.JsonText( str, "ASCII" );
"\"\\u00F6\""

##  doc/../gap/json.g (422-427)
gap> AGR.GapObjectOfJsonText( "{ \"a\": 1 }" );
rec( status := true, value := rec( a := 1 ) )
gap> AGR.GapObjectOfJsonText( "{ \"a\": x }" );
rec( errpos := 8, status := false )

##  doc/../gap/scanmtx.gd (332-351)
gap> mat:= [ [ 1, -1 ], [ 0, 1 ] ] * Z(3)^0;;
gap> str:= MeatAxeString( mat, 3 );
"1 3 2 2\n12\n01\n"
gap> mat = ScanMeatAxeFile( str, "string" );
true
gap> str:= MeatAxeString( mat, 9 );
"1 9 2 2\n12\n01\n"
gap> mat = ScanMeatAxeFile( str, "string" );
true
gap> perms:= [ (1,2,3)(5,6) ];;
gap> str:= MeatAxeString( perms, 6 );
"12 1 6 1\n2\n3\n1\n4\n6\n5\n"
gap> perms = ScanMeatAxeFile( str, "string" );
true
gap> str:= MeatAxeString( perms, 8 );
"12 1 8 1\n2\n3\n1\n4\n6\n5\n7\n8\n"
gap> perms = ScanMeatAxeFile( str, "string" );
true

##  doc/../gap/scanmtx.gd (357-375)
gap> perm:= (1,2,4);;
gap> str:= MeatAxeString( perm, 3, [ 5, 6 ] );
"2 3 5 6\n2\n4\n3\n1\n5\n"
gap> mat:= ScanMeatAxeFile( str, "string" );;  Print( mat, "\n" );
[ [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], 
  [ 0*Z(3), 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ] ]
gap> pref:= UserPreference( "AtlasRep", "WriteMeatAxeFilesOfMode2" );;
gap> SetUserPreference( "AtlasRep", "WriteMeatAxeFilesOfMode2", true );
gap> MeatAxeString( mat, 3 ) = str;
true
gap> SetUserPreference( "AtlasRep", "WriteMeatAxeFilesOfMode2", false );
gap> MeatAxeString( mat, 3 );
"1 3 5 6\n010000\n000100\n001000\n100000\n000010\n"
gap> SetUserPreference( "AtlasRep", "WriteMeatAxeFilesOfMode2", pref );

##  doc/../gap/scanmtx.gd (113-118)
gap> FFList( GF(4) );
[ 0*Z(2), Z(2)^0, Z(2^2), Z(2^2)^2 ]
gap> IsBound( FFLists[4] );
true

##  doc/../gap/scanmtx.gd (424-438)
gap> tmpdir:= DirectoryTemporary();;
gap> mat:= Filename( tmpdir, "mat" );;
gap> q:= 4;;
gap> mats:= GeneratorsOfGroup( GL(10,q) );;
gap> CMtxBinaryFFMatOrPerm( mats[1], q, Concatenation( mat, "1" ) );
gap> CMtxBinaryFFMatOrPerm( mats[2], q, Concatenation( mat, "2" ) );
gap> prm:= Filename( tmpdir, "prm" );;
gap> n:= 200;;
gap> perms:= GeneratorsOfGroup( SymmetricGroup( n ) );;
gap> CMtxBinaryFFMatOrPerm( perms[1], n, Concatenation( prm, "1" ) );
gap> CMtxBinaryFFMatOrPerm( perms[2], n, Concatenation( prm, "2" ) );
gap> CMtxBinaryFFMatOrPerm( perms[1], n, Concatenation( prm, "1a" ), 0 );
gap> CMtxBinaryFFMatOrPerm( perms[2], n, Concatenation( prm, "2b" ), 1 );

##  doc/../gap/scanmtx.gd (465-478)
gap> FFMatOrPermCMtxBinary( Concatenation( mat, "1" ) ) = mats[1];
true
gap> FFMatOrPermCMtxBinary( Concatenation( mat, "2" ) ) = mats[2];
true
gap> FFMatOrPermCMtxBinary( Concatenation( prm, "1" ) ) = perms[1];
true
gap> FFMatOrPermCMtxBinary( Concatenation( prm, "2" ) ) = perms[2];
true
gap> FFMatOrPermCMtxBinary( Concatenation( prm, "1a" ) ) = perms[1];
true
gap> FFMatOrPermCMtxBinary( Concatenation( prm, "2b" ) ) = perms[2];
true

##  doc/../gap/scanmtx.gd (733-782)
gap> str:= "inp 2\nmu 1 2 3\nmu 3 1 2\niv 2 1\noup 2 1 2";;
gap> prg:= ScanStraightLineProgram( str, "string" );
rec( program := <straight line program> )
gap> prg:= prg.program;;
gap> Display( prg );
# input:
r:= [ g1, g2 ];
# program:
r[3]:= r[1]*r[2];
r[2]:= r[3]*r[1];
r[1]:= r[2]^-1;
# return values:
[ r[1], r[2] ]
gap> StringOfResultOfStraightLineProgram( prg, [ "a", "b" ] );
"[ (aba)^-1, aba ]"
gap> AtlasStringOfProgram( prg );
"inp 2\nmu 1 2 3\nmu 3 1 2\niv 2 1\noup 2\n"
gap> prg:= StraightLineProgram( "(a^2b^3)^-1", [ "a", "b" ] );
<straight line program>
gap> Print( AtlasStringOfProgram( prg ) );
inp 2
pwr 2 1 4
pwr 3 2 5
mu 4 5 3
iv 3 4
oup 1 4
gap> prg:= StraightLineProgram( [ [2,3], [ [3,1,1,4], [1,2,3,1] ] ], 2 );
<straight line program>
gap> Print( AtlasStringOfProgram( prg ) );
inp 2
pwr 3 2 3
pwr 4 1 5
mu 3 5 4
pwr 2 1 6
mu 6 3 5
oup 2 4 5
gap> Print( AtlasStringOfProgram( prg, "mtx" ) );
# inputs are expected in 1 2
zsm pwr3 2 3
zsm pwr4 1 5
zmu 3 5 4
zsm pwr2 1 6
zmu 6 3 5
echo "outputs are in 4 5"
gap> str:= "inp 2\nchor 1 2\nchor 2 3\nmu 1 2 3\nchor 3 5";;
gap> prg:= ScanStraightLineDecision( str );;
gap> AtlasStringOfProgram( prg.program );
"inp 2\nchor 1 2\nchor 2 3\nmu 1 2 3\nchor 3 5\n"

##  doc/../gap/access.gd (148-159)
gap> format:= [ [ [ IsChar, "G", IsDigitChar ],
>                 [ "p", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
>                   "B", IsDigitChar, ".m", IsDigitChar ] ],
>               [ ParseBackwards, ParseForwards ] ];;
gap> AGR.ParseFilenameFormat( "A6G1-p10B0.m1", format );
[ "A6", "G", 1, "p", 10, "", "B", 0, ".m", 1 ]
gap> AGR.ParseFilenameFormat( "A6G1-p15aB0.m1", format );
[ "A6", "G", 1, "p", 15, "a", "B", 0, ".m", 1 ]
gap> AGR.ParseFilenameFormat( "A6G1-f2r16B0.m1", format );
fail

##  doc/../gap/utils.gd (391-426)
gap> id:= [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ];;
gap> AtlasRepIdentifier( id ) = id;
true
gap> id:= [ "L2(8)", "L28G1-check1", 1, 1 ];;
gap> AtlasRepIdentifier( id ) = id;
true
gap> oldid:= [ [ "priv", "C4" ], [ "C4G1-p4B0.m1" ], 1, 4 ];;
gap> newid:= AtlasRepIdentifier( oldid );
[ "C4", [ [ "priv", "C4G1-p4B0.m1" ] ], 1, 4 ]
gap> oldid = AtlasRepIdentifier( newid, "old" );
true
gap> oldid:= [ [ "priv", "C4" ], "C4G1-max1W1", 1 ];;
gap> newid:= AtlasRepIdentifier( oldid );
[ "C4", [ [ "priv", "C4G1-max1W1" ] ], 1 ]
gap> oldid = AtlasRepIdentifier( newid, "old" );
true
gap> oldid:= [ [ "priv", "C4" ], "C4G1-Ar1aB0.g", 1, 1 ];;
gap> newid:= AtlasRepIdentifier( oldid );
[ "C4", [ [ "priv", "C4G1-Ar1aB0.g" ] ], 1, 1 ]
gap> oldid = AtlasRepIdentifier( newid, "old" );
true
gap> oldid:= [ [ "priv", "C4" ], "C4G1-XtestW1", 1 ];;
gap> newid:= AtlasRepIdentifier( oldid );
[ "C4", [ [ "priv", "C4G1-XtestW1" ] ], 1 ]
gap> oldid = AtlasRepIdentifier( newid, "old" );
true
gap> oldid:= [ [ "mfer", "2.M12" ],
>  [ "2M12G1-p264aB0.m1", "2M12G1-p264aB0.m2" ], 1, 264 ];;
gap> newid:= AtlasRepIdentifier( oldid );
[ "2.M12", 
  [ [ "mfer", "2M12G1-p264aB0.m1" ], [ "mfer", "2M12G1-p264aB0.m2" ] ]
    , 1, 264 ]
gap> oldid = AtlasRepIdentifier( newid, "old" );
true

##  doc/technica.xml (284-287)
gap> SetUserPreference( "AtlasRep", "DisplayFunction", origpref );
gap> SetInfoLevel( InfoAtlasRep, globallevel );

##
gap> if IsBound( BrowseData ) then
>      data:= BrowseData.defaults.dynamic.replayDefaults;
>      data.replayInterval:= oldinterval;
>    fi;

##
gap> STOP_TEST( "docxpl.tst" );
gap> SizeScreen( save );;

#############################################################################
##
#E
