#############################################################################
##
#W  internal.tst         GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains some tests for the internal data files.
##  Note that the output of some package functions may differ after this file
##  has been processed, so be careful not to run other package tests
##  afterwards.
##
##  In order to run the tests, one starts GAP from the `tst' subdirectory
##  of the 'pkg/atlasrep' directory, and calls 'Test( "internal.tst" );'.
##
gap> START_TEST( "internal.tst" );

# Load the necessary packages.
gap> LoadPackage( "atlasrep", false );
true
gap> LoadPackage( "ctbllib", false );
true

# Test the collection of local internal data files.
# For that, first we forget the files and then notify the extension
# as a local-only one.
gap> AtlasOfGroupRepresentationsForgetData( "internal" );
gap> AtlasOfGroupRepresentationsNotifyData(
>        DirectoriesPackageLibrary( "atlasrep", "datapkg" )[1],
>        "internal", true );
true

# Reinstall the extension 'internal' as a local or remote one,
# in order to get the old behaviour back.
# (The ordering of extensions may have changed now,
# so from now on, some output of interface functions may differ
# from the output shown in testfiles.)
gap> AtlasOfGroupRepresentationsForgetData( "internal" );
gap> AtlasOfGroupRepresentationsNotifyData(
>        Filename( DirectoriesPackageLibrary( "atlasrep", "" ),
>                  "datapkg/toc.json" ), "internal" );
true

# Done.
gap> STOP_TEST( "internal.tst" );


#############################################################################
##
#E

