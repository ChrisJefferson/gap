#############################################################################
##
#W  hardtest.tst         GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains, among others, those checks for the AtlasRep package
##  that examine the transfer from a server and the matrices that are
##  contained in the local `atlasgens' directory.
##  These tests cannot be performed without access to remote files.
##
##  In order to run the tests, one starts GAP from the `tst' subdirectory
##  of the `pkg/atlasrep' directory, and calls `Test( "hardtest.tst" );'.
##
##  If one of the functions `AGR.Test.Words', `AGR.Test.FileHeaders' reports
##  an error then detailed information can be obtained by increasing the
##  info level of `InfoAtlasRep' to at least 1 and then running the tests
##  again.
##

gap> START_TEST( "hardtest.tst" );

# Load the package if necessary.
gap> LoadPackage( "atlasrep" );
true
gap> LoadPackage( "ctbllib" );
true

# Test transferring group generators in MeatAxe format.
gap> dir:= DirectoriesPackageLibrary( "atlasrep", "datagens" );;
gap> id:= OneAtlasGeneratingSet( "A5", Characteristic, 2 ).identifier;;
gap> for file in List( id[2], name -> Filename( dir, name ) ) do
>      RemoveFile( file );
> od;
gap> gens:= AtlasGenerators( id );;
gap> IsRecord( gens ) and id = gens.identifier;
true

# Test transferring group generators in GAP format.
gap> id:= OneAtlasGeneratingSetInfo( "A5", Characteristic, 0 ).identifier;;
gap> RemoveFile( Filename( dir, id[2] ) );;
gap> gens:= AtlasGenerators( id );;
gap> IsRecord( gens ) and id = gens.identifier;
true

# Test whether the locally stored straight line programs
# can be read and processed.
gap> if not AGR.Test.Words() then
>      Print( "#I  Error in `AGR.Test.Words'\n" );
> fi;

# Test whether the locally stored generators are consistent
# with their filenames.
gap> if not AGR.Test.FileHeaders() then
>      Print( "#I  Error in `AGR.Test.FileHeaders'\n" );
> fi;

# Read all MeatAxe format files in the local installation.
gap> if not AGR.Test.Files() then
>      Print( "#I  Error in `AGR.Test.Files'\n" );
> fi;

# Test whether the group names are consistent (with verification test).
gap> if not AGR.Test.GroupOrders() then
>      Print( "#I  Error in `AGR.Test.GroupOrders'\n" );
> fi;
gap> if not AGR.Test.StdCompatibility() then
>      Print( "#I  Error in `AGR.Test.StdCompatibility'\n" );
> fi;
gap> if not AGR.Test.KernelGenerators() then
>      Print( "#I  Error in `AGR.Test.KernelGenerators'\n" );
> fi;

# Check the conversion between binary and text format.
gap> if not AGR.Test.BinaryFormat() then
>      Print( "#I  Error in `AGR.Test.BinaryFormat'\n" );
> fi;

# Download and check some straight line programs.
gap> checkprg:= function( id )
> return IsRecord( id ) and LinesOfStraightLineProgram( id.program ) =
>  LinesOfStraightLineProgram(
>      AtlasProgram( id.identifier ).program );
> end;;
gap> checkprg( AtlasProgram( "M11", 2 ) );
true
gap> checkprg( AtlasProgram( "M11", 1, 2 ) );
true
gap> checkprg( AtlasProgram( "M11", "maxes", 2 ) );
true
gap> checkprg( AtlasProgram( "M11", 1, "maxes", 2 ) );
true
gap> checkprg( AtlasProgram( "M11", "classes" ) );
true
gap> checkprg( AtlasProgram( "M11", 1, "classes" ) );
true
gap> checkprg( AtlasProgram( "M11", "cyclic" ) );
true
gap> checkprg( AtlasProgram( "M11", 1, "cyclic" ) );
true
gap> checkprg( AtlasProgram( "L2(13)", "automorphism", "2" ) );
true
gap> checkprg( AtlasProgram( "L2(13)", 1, "automorphism", "2" ) );
true
gap> checkprg( AtlasProgram( "J4", 1, "restandardize", 2 ) );
true

# Test the ``minimal degrees feature''.
# gap> info:= ComputedMinimalRepresentationInfo();;
# gap> infostr:= StringOfMinimalRepresentationInfoData( info );;
gap> AGR.Test.MinimalDegrees();
true

# Test whether there are new `cyc' scripts for which the `cyc2ccls' script
# can be computed by GAP.
gap> if not AGR.Test.CycToCcls() then
>      Print( "#I  Error in `AGR.Test.CycToCcls'\n" );
> fi;

# Test whether the scripts that return class representatives
# are sufficiently consistent.
# (This test should be the last one,
# because newly added scripts may be too hard for it.)
gap> if not AGR.Test.ClassScripts() then
>      Print( "#I  Error in `AGR.Test.ClassScripts'\n" );
> fi;

##
gap> STOP_TEST( "hardtest.tst" );


#############################################################################
##
#E

