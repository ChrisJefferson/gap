#############################################################################
##
#W  atlasrep.tst         GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains among others the function calls needed to perform some
##  of the sanity checks mentioned in the corresponding manual section.
##
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/atlasrep' directory, and calls 'Test( "atlasrep.tst" );'.
##
##  If one of the functions 'AGR.Test.Words', 'AGR.Test.FileHeaders' reports
##  an error then detailed information can be obtained by increasing the
##  info level of 'InfoAtlasRep' to at least 1 and then running the tests
##  again.
##
gap> START_TEST( "atlasrep.tst" );

# Load the necessary packages.
gap> LoadPackage( "atlasrep", false );
true
gap> LoadPackage( "ctbllib", false );
true

# Test the internally available class scripts.
gap> AGR.Test.ClassScripts( "internal" );
true
gap> AGR.Test.CycToCcls( "internal" );
true

# Test the availability of peripheral information.
gap> AllAtlasGeneratingSetInfos( Ring, fail );
[  ]
gap> AllAtlasGeneratingSetInfos( IsTransitive, fail );
[  ]
gap> AllAtlasGeneratingSetInfos( IsPrimitive, fail );
[  ]

# Test reading and writing straight line programs.
gap> str:= "\
> mu 1 2 3\n\
> mu 3 2 4\n\
> mu 3 4 5\n\
> mu 3 5 6\n\
> mu 6 6 5\n\
> mu 6 5 1\n\
> iv 4 5\n\
> mu 5 2 6\n\
> mu 6 4 2\n\
> iv 3 4\n\
> mu 4 1 5\n\
> mu 5 3 1";;
gap> prog:= ScanStraightLineProgram( str, "string" );
rec( program := <straight line program> )
gap> Print( AtlasStringOfProgram( prog.program ) );
inp 2
mu 1 2 3
mu 3 2 4
mu 3 4 5
mu 3 5 6
mu 6 6 5
mu 6 5 1
iv 4 5
mu 5 2 6
mu 6 4 2
iv 3 4
mu 4 1 5
mu 5 3 1
oup 2
gap> Print( AtlasStringOfProgram( prog.program, "mtx" ) );
# inputs are expected in 1 2
zmu 1 2 3
zmu 3 2 4
zmu 3 4 5
zmu 3 5 6
zmu 6 6 5
zmu 6 5 1
ziv 4 5
zmu 5 2 6
zmu 6 4 2
ziv 3 4
zmu 4 1 5
zmu 5 3 1
echo "outputs are in 1 2"
gap> str:= "\
> mu 1 2 3\n\
> mu 3 2 4\n\
> mu 3 4 5\n\
> mu 5 4 6\n\
> mu 6 2 7\n\
> oup 4 7 4 6 3";;
gap> prog:= ScanStraightLineProgram( str, "string" );
rec( program := <straight line program> )
gap> Print( AtlasStringOfProgram( prog.program,
>     ["5A","6A","8A","11A"] ) );
inp 2
mu 1 2 3
mu 3 2 4
mu 3 4 5
mu 5 4 6
mu 6 2 7
echo "Classes 5A 6A 8A 11A"
oup 4 7 4 6 3
gap> prg:= ScanStraightLineProgram( "inp 4 1 2 3 4\noup 3 1 2 4", "string" );;
gap> Display( prg.program );
# input:
r:= [ g1, g2, g3, g4 ];
# program:
# return values:
[ r[1], r[2], r[4] ]
gap> prg:= ScanStraightLineProgram( "inp 3 1 2 3\noup 3 1 2 3", "string" );;
gap> Display( prg.program );
# input:
r:= [ g1, g2, g3 ];
# program:
# return values:
[ r[1], r[2], r[3] ]
gap> str:= "\
> inp 2\n\
> mu 1 2 3\n\
> mu 1 1 4\n\
> mu 3 3 5\n\
> echo \"Classes 1A 2A 3A 5A 5B\"\n\
> oup 5 4 1 2 3 5";;
gap> prg:= ScanStraightLineProgram( str, "string" );
rec( outputs := [ "1A", "2A", "3A", "5A", "5B" ], 
  program := <straight line program> )
gap> Display( prg.program );
# input:
r:= [ g1, g2 ];
# program:
r[3]:= r[1]*r[2];
r[4]:= r[1]*r[1];
r[5]:= r[3]*r[3];
# return values:
[ r[4], r[1], r[2], r[3], r[5] ]
gap> str:= "cj 1 2 3\noup 1 3";;
gap> prg:= ScanStraightLineProgram( str, "string" );;
gap> AtlasStringOfProgram( prg.program );
"inp 2\ncj 1 2 3\noup 1 3\n"

# Test reading group generators in MeatAxe format.
gap> dir:= DirectoriesPackageLibrary( "atlasrep", "tst" );;

# mode 12
gap> str:= "\
> 12     1    9     1\n\
>      1\n\
>      4\n\
>      5\n\
>      2\n\
>      3\n\
>      8\n\
>      6\n\
>      9\n\
>      7";;
gap> perms:= ScanMeatAxeFile( str, "string" );
[ (2,4)(3,5)(6,8,9,7) ]
gap> str:= "\
> permutation degree=9\n\
> 1 4 5 2 3 8 6 9 7";;
gap> perms = ScanMeatAxeFile( str, "string" );
true
gap> ScanMeatAxeFile( Filename( dir, "perm7.txt" ) );
[ (1,2,3)(4,6) ]

# mode 1
gap> str:= "\
>  1     9     3     3\n\
> 200\n\
> 020\n\
> 331";
" 1     9     3     3\n200\n020\n331"
gap> scan:= ScanMeatAxeFile( str, "string" );
[ [ Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3), 0*Z(3) ], 
  [ Z(3^2), Z(3^2), Z(3)^0 ] ]
gap> str:= "\
> matrix field=9 rows=3 cols=3\n\
> 200\n\
> 020\n\
> 331";;
gap> scan = ScanMeatAxeFile( str, "string" );
true
gap> scan = ScanMeatAxeFile( Filename( dir, "matf9r3.txt" ) );
true
gap> scan = ScanMeatAxeFile( Filename( dir, "matf81r3.txt" ) );
true

# mode 3
gap> str:= "\
>  3    11    10    10\n\
>   0  1  0  0  0  0  0  0  0  0\n\
>   1  0  0  0  0  0  0  0  0  0\n\
>   0  0  0  1  0  0  0  0  0  0\n\
>   0  0  1  0  0  0  0  0  0  0\n\
>   0  0  0  0  0  0  1  0  0  0\n\
>   0  0  0  0  0  0  0  1  0  0\n\
>   0  0  0  0  1  0  0  0  0  0\n\
>   0  0  0  0  0  1  0  0  0  0\n\
>   6  6 10 10  9 10  9 10 10  0\n\
>  10 10  9  9  1  6  1  6  0 10";;
gap> scan:= ScanMeatAxeFile( str, "string" );;
gap> Print( scan, "\n" );
[ [ 0*Z(11), Z(11)^0, 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ Z(11)^0, 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), 0*Z(11), Z(11)^0, 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), Z(11)^0, 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), Z(11)^0, 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), Z(11)^0,
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), Z(11)^0, 0*Z(11), 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), 0*Z(11), Z(11)^0, 0*Z(11), 0*Z(11),
       0*Z(11), 0*Z(11) ], 
  [ Z(11)^9, Z(11)^9, Z(11)^5, Z(11)^5, Z(11)^6, Z(11)^5, Z(11)^6, Z(11)^5,
       Z(11)^5, 0*Z(11) ], 
  [ Z(11)^5, Z(11)^5, Z(11)^6, Z(11)^6, Z(11)^0, Z(11)^9, Z(11)^0, Z(11)^9,
       0*Z(11), Z(11)^5 ] ]
gap> str:= "\
> matrix field=11 rows=10 cols=10\n\
>   0  1  0  0  0  0  0  0  0  0\n\
>   1  0  0  0  0  0  0  0  0  0\n\
>   0  0  0  1  0  0  0  0  0  0\n\
>   0  0  1  0  0  0  0  0  0  0\n\
>   0  0  0  0  0  0  1  0  0  0\n\
>   0  0  0  0  0  0  0  1  0  0\n\
>   0  0  0  0  1  0  0  0  0  0\n\
>   0  0  0  0  0  1  0  0  0  0\n\
>   6  6 10 10  9 10  9 10 10  0\n\
>  10 10  9  9  1  6  1  6  0 10";;
gap> scan = ScanMeatAxeFile( str, "string" );
true
gap> scan = ScanMeatAxeFile( Filename( dir, "matf11r10.txt" ) );
true

# mode 4

# mode 5
gap> file:= Filename( dir, "matf7r3.txt" );;
gap> scan:= ScanMeatAxeFile( file );
[ [ Z(7)^5, 0*Z(7), Z(7)^0 ], [ 0*Z(7), Z(7), 0*Z(7) ], 
  [ Z(7)^2, Z(7)^2, Z(7) ] ]
gap> str:= StringFile( file );;
gap> scan = ScanMeatAxeFile( str, "string" );
true

# mode 6

# mode 2
gap> str:= "\
> 2 5 3 6\n\
> 4\n\
> 6\n\
> 1";;
gap> scan:= ScanMeatAxeFile( str, "string" );
[ [ 0*Z(5), 0*Z(5), 0*Z(5), Z(5)^0, 0*Z(5), 0*Z(5) ], 
  [ 0*Z(5), 0*Z(5), 0*Z(5), 0*Z(5), 0*Z(5), Z(5)^0 ], 
  [ Z(5)^0, 0*Z(5), 0*Z(5), 0*Z(5), 0*Z(5), 0*Z(5) ] ]
gap> str:= "\
> matrix field=5 rows=3 cols=6\n\
> 000100\n\
> 000001\n\
> 100000";;
gap> scan = ScanMeatAxeFile( str, "string" );
true
gap> scan:= ScanMeatAxeFile( Filename( dir, "permmat7.txt" ) );;
gap> scan = PermutationMat( (1,2,3)(4,6), 7, GF(3) );
true

# Test writing group generators in MeatAxe format.
# (Cover the cases of matrices over small fields, over large prime fields,
# and over large nonprime fields.)
# 1. Write numeric file headers.
gap> pref:= UserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles" );;
gap> SetUserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles",
>        "numeric" );;
gap> mat:= [ [ 1, 0 ], [ 0, 0 ] ] * Z(3)^0;; # (not a permutation matrix)
gap> MeatAxeString( mat, 3 );
"1 3 2 2\n10\n00\n"
gap> mat:= [ [ 1, 0 ], [ 1, 0 ] ] * Z(3)^0;  # (not a permutation matrix)
[ [ Z(3)^0, 0*Z(3) ], [ Z(3)^0, 0*Z(3) ] ]
gap> MeatAxeString( mat, 3 );
"1 3 2 2\n10\n10\n"
gap> q:= 101;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true
gap> q:= 3^7;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true

# 2. Write numeric (fixed) file headers.
gap> SetUserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles",
>        "numeric (fixed)" );;
gap> mat:= [ [ 1, 0 ], [ 0, 0 ] ] * Z(3)^0;; # (not a permutation matrix)
gap> MeatAxeString( mat, 3 );
"     1     3     2     2\n10\n00\n"
gap> mat:= [ [ 1, 0 ], [ 1, 0 ] ] * Z(3)^0;  # (not a permutation matrix)
[ [ Z(3)^0, 0*Z(3) ], [ Z(3)^0, 0*Z(3) ] ]
gap> MeatAxeString( mat, 3 );
"     1     3     2     2\n10\n10\n"
gap> q:= 101;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true
gap> q:= 3^7;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true

# 3. Write textual file headers.
gap> SetUserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles",
>        "textual" );;
gap> mat:= [ [ 1, 0 ], [ 0, 0 ] ] * Z(3)^0;; # (not a permutation matrix)
gap> MeatAxeString( mat, 3 );
"matrix field=3 rows=2 cols=2\n10\n00\n"
gap> mat:= [ [ 1, 0 ], [ 1, 0 ] ] * Z(3)^0;  # (not a permutation matrix)
[ [ Z(3)^0, 0*Z(3) ], [ Z(3)^0, 0*Z(3) ] ]
gap> MeatAxeString( mat, 3 );
"matrix field=3 rows=2 cols=2\n10\n10\n"
gap> q:= 101;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true
gap> q:= 3^7;;
gap> mat:= RandomMat( 20, 20, GF(q) );;
gap> str:= MeatAxeString( mat, q );;
gap> ScanMeatAxeFile( str, "string" ) = mat;
true
gap> SetUserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles",
>        pref );;
gap> Print( MeatAxeString( [ [ 1, 2 ], [ 3, 4 ] ] ) );
integer matrix rows=2 cols=2
1 2 
3 4 

# Check the interface functions.
gap> g:= "A5";;
gap> IsRecord( OneAtlasGeneratingSetInfo( g ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsPermGroup ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsPermGroup, true ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsPermGroup, NrMovedPoints, 5 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsPermGroup, true,
>                                         NrMovedPoints, 5 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, IsPermGroup ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, NrMovedPoints, 5 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, NrMovedPoints, 5 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsMatrixGroup ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsMatrixGroup, true ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsMatrixGroup, Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, IsMatrixGroup, true,
>                                         Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, IsMatrixGroup ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, Characteristic, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, Characteristic, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, Characteristic, 2,
>                                         Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, Characteristic, 2,
>                                         Dimension, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, Ring, GF(2) ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, Ring, GF(2) ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, Ring, GF(2), Dimension, 4 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( g, 1, Ring, GF(2), Dimension, 4 ) );
true

# Check access to representations with unusual parameters.
gap> OneAtlasGeneratingSetInfo( IsPermGroup, true );;
gap> OneAtlasGeneratingSetInfo( [ "A5", "A6" ], IsPermGroup, true );;
gap> AllAtlasGeneratingSetInfos( IsPermGroup, true );;
gap> AllAtlasGeneratingSetInfos( [ "A5", "A6" ], IsPermGroup, true );;
gap> OneAtlasGeneratingSetInfo( Identifier, "a" );;
gap> OneAtlasGeneratingSetInfo( Position, 1 );;
gap> OneAtlasGeneratingSetInfo( Position, 10^6 );
fail
gap> OneAtlasGeneratingSetInfo( Ring, Integers );;
gap> AllAtlasGeneratingSetInfos( Ring, Integers );;
gap> tbl:= CharacterTable( "M11" );;
gap> chi:= PermChars( tbl, [ 11 ] )[1];;
gap> IsRecord( OneAtlasGeneratingSetInfo( Character, chi ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( "M11", Character, chi ) );
true
gap> phi:= Irr( tbl mod 2 )[2];;
gap> IsRecord( OneAtlasGeneratingSetInfo( Character, phi ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( Character, phi,
>                                         Characteristic, IsEvenInt ) );
true
gap> OneAtlasGeneratingSetInfo( Character, phi, Characteristic, IsOddInt );
fail
gap> IsRecord( OneAtlasGeneratingSetInfo( "L2(11)", Character, "10a" ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( Character, "10a" ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( "M11", Character, 2 ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( "M11", Character, "5a" ) );
false
gap> IsRecord( OneAtlasGeneratingSetInfo( "M11", Ring, GF(3),
>                                         Character, "5a" ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( "M11", Characteristic, 3,
>                                         Character, "5a" ) );
true
gap> IsRecord( OneAtlasGeneratingSetInfo( Character, 2 ) );
true
gap> x:= Indeterminate( Rationals, "x" );;
gap> f:= x^2-5;;
gap> F:= AlgebraicExtension( Rationals, f );;
gap> info:= OneAtlasGeneratingSetInfo( "A5", Dimension, 3, Ring, F );;
gap> info.givenRing = F;
true
gap> AtlasGroup( "A5", Characteristic, 0, Dimension, 3 );;
gap> ForAll( AllAtlasGeneratingSetInfos( "A5", Ring, GF(5) ),
>            r -> Characteristic( r.ring ) = 5 );
true

# Check access to straight line programs with unusual parameters.
gap> IsRecord( AtlasProgramInfo( "M11", "maxes", 1, "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "maxes", 1, "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", 1, "maxes", 1, "contents", "core" ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", 1, "maxes", 1, "contents", "other" ) );
false
gap> IsRecord( AtlasProgramInfo( "J1", 1, "maxstd", 1, 1, 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "J1", 1, "maxstd", 1, 1, 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "2.M12", "kernel", "M12", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "2.M12", "kernel", "M12", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "cyclic", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "cyclic", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "classes", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "classes", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "cyc2ccl", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "cyc2ccl", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "cyc2ccl", 1, "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "cyc2ccl", 1, "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "Suz", "automorphism", "2", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "Suz", "automorphism", "2",
>                                "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "check", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "check", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "presentation", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "presentation", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "M11", "find", "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "M11", "find", "version", 10^6 ) );
false
gap> IsRecord( AtlasProgramInfo( "L3(5)", 1, "restandardize", 2,
>                                "version", 1 ) );
true
gap> IsRecord( AtlasProgramInfo( "L3(5)", 1, "restandardize", 2,
>                                "version", 10^6 ) );
false

# Check the variants of 'StandardGeneratorsData'.
gap> StandardGeneratorsData( Group( () ), "M11" );
"timeout"
gap> repeat
>      res:= StandardGeneratorsData( MathieuGroup( 12 ), "M11" );
>    until res = fail;
gap> StandardGeneratorsData( MathieuGroup( 11 ), "M11", 9 );
fail
gap> gens:= List( GeneratorsOfGroup( MathieuGroup( 11 ) ),
>                 x -> PermutationMat( x, 11, GF(2) ) );;
gap> g:= Group( gens );;
gap> IsRecord( StandardGeneratorsData( gens, "M11" ) );
true
gap> IsRecord( StandardGeneratorsData( gens, "M11", 1 ) );
true
gap> IsRecord( StandardGeneratorsData( gens, "M11" : projective ) );
true
gap> IsRecord( StandardGeneratorsData( gens, "M11", 1 : projective ) );
true
gap> IsRecord( StandardGeneratorsData( g, "M11" ) );
true
gap> IsRecord( StandardGeneratorsData( g, "M11", 1 ) );
true
gap> IsRecord( StandardGeneratorsData( g, "M11" : projective ) );
true
gap> IsRecord( StandardGeneratorsData( g, "M11", 1 : projective ) );
true
gap> StandardGeneratorsData( g, "M11", 9 );
fail
gap> StandardGeneratorsData( g, "M11", 9 : projective );
fail

# Check the variants of 'EvaluatePresentation'.
gap> EvaluatePresentation( Group( () ), "M11" );
Error, presentation for "M11" has 2 generators but 1 generators were given
gap> EvaluatePresentation( Group( () ), "M11", 1 );
Error, presentation for "M11" has 2 generators but 1 generators were given
gap> EvaluatePresentation( [], "M11" );
Error, presentation for "M11" has 2 generators but 0 generators were given
gap> EvaluatePresentation( [], "M11", 1 );
Error, presentation for "M11" has 2 generators but 0 generators were given
gap> EvaluatePresentation( [ (), (), () ], "M11" );
Error, presentation for "M11" has 2 generators but 3 generators were given
gap> EvaluatePresentation( gens, "M11", 9 );
fail
gap> g:= AtlasGroup( "M11" );;
gap> gens:= GeneratorsOfGroup( g );;
gap> ForAll( EvaluatePresentation( gens, "M11" ), IsOne );
true
gap> ForAll( EvaluatePresentation( gens, "M11", 1 ), IsOne );
true
gap> ForAll( EvaluatePresentation( g, "M11" ), IsOne );
true
gap> ForAll( EvaluatePresentation( g, "M11", 1 ), IsOne );
true

# Call 'AtlasClassNames' for all tables of almost simple and quasisimple
# groups that are not simple.
# (We do not have direct access to the list of quasisimple groups,
# here we use a heuristic argument based on the structure of names.)
# We check whether the function runs without error messages,
# and that the class names returned are different and are compatible with
# the element orders.
gap> digitprefix:= function( str )
>        local bad;
>        bad:= First( str, x -> not IsDigitChar( x ) );
>        if bad = fail then
>          return str;
>        else
>          return str{ [ 1 .. Position( str, bad ) - 1 ] };
>        fi;
> end;;
gap> simpl:= AllCharacterTableNames( IsSimple, true,
>                                    IsDuplicateTable, false );;
gap> bad:= [ "A6.D8", "L2(64).6", "L3(4).D12",
>            "O12-(2).2", "O12+(2).2",
>            "U3(8).3^2", "U4(4).4",
>            "U4(5).2^2",
>            "2.Alt(3)", "2.Sym(2)",
>            "4.L4(5)" ];;
gap> pos:= "dummy";;
gap> for name in AllCharacterTableNames() do
>      pos:= Position( name, '.' );
>      if pos <> fail then
>        for simp in simpl do
>          if     Length( simp ) = pos-1
>             and name{ [ 1 .. pos-1 ] } = simp
>             and ForAll( "xMN", x -> Position( name, x, pos ) = fail )
>             and not name in bad then
>            # upward extension of a simple group
>            tbl:= CharacterTable( name );
>            classnames:= AtlasClassNames( tbl );
>            if    classnames = fail
>               or Length( classnames ) <> Length( Set( classnames ) )
>               or List( classnames, digitprefix )
>                   <> List( OrdersClassRepresentatives( tbl ), String ) then
>              Print( "#I  AtlasClassNames: problem for '", name, "'\n" );
>            fi;
>          elif   Length( simp ) = Length( name ) - pos
>             and name{ [ pos+1 .. Length( name ) ] } = simp
>             and ForAll( name{ [ 1 .. pos-1 ] },
>                         c -> IsDigitChar( c ) or c = '_' )
>             and not name in bad then
>            tbl:= CharacterTable( name );
>            classnames:= AtlasClassNames( tbl );
>            if    classnames = fail
>               or Length( classnames ) <> Length( Set( classnames ) ) then
>              Print( "#I  AtlasClassNames: problem for '", name, "'\n" );
>            fi;
>          fi;
>        od;
>      fi;
>    od;

# Check that the function 'StringOfAtlasTableOfContents' works.
# We do *not* want to recompute checksums,
# since this would require all data files to be locally available.
# Thus we test only the checksum format that is actually used in
# 'AtlasOfGroupRepresentationsInfo.filenames'.
# For the 'core' t.o.c. ...
gap> dir:= DirectoriesPackageLibrary( "atlasrep", "" );;
gap> if IsString( AtlasOfGroupRepresentationsInfo.filenames[1][4] ) then
>      filename:= Filename( dir, "atlasprm_SHA.json" );;
>      f:= AGR.GapObjectOfJsonText( AGR.StringFile( filename ) );;
>      str:= StringOfAtlasTableOfContents( f.value : SHA:= true );;
>    else
>      filename:= Filename( dir, "atlasprm.json" );;
>      f:= AGR.GapObjectOfJsonText( AGR.StringFile( filename ) );;
>      str:= StringOfAtlasTableOfContents( f.value );;
>    fi;
gap> str = AGR.StringFile( filename );
true

# ... and for the 'internal' t.o.c.
gap> dir:= DirectoriesPackageLibrary( "atlasrep", "datapkg" );;
gap> if IsString( AtlasOfGroupRepresentationsInfo.filenames[1][4] ) then
>      filename:= Filename( dir, "toc_SHA.json" );;
>      f:= AGR.GapObjectOfJsonText( AGR.StringFile( filename ) );;
>      str:= StringOfAtlasTableOfContents( f.value : SHA:= true );;
>    else
>      filename:= Filename( dir, "toc.json" );;
>      f:= AGR.GapObjectOfJsonText( AGR.StringFile( filename ) );;
>      str:= StringOfAtlasTableOfContents( f.value );;
>    fi;
gap> str = AGR.StringFile( filename );
true

# Done.
gap> STOP_TEST( "atlasrep.tst" );


#############################################################################
##
#E

