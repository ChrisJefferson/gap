#############################################################################
##
#W  testall.g            GAP 4 package AtlasRep                 Thomas Breuer
##

LoadPackage( "atlasrep", false );
dirs:= DirectoriesPackageLibrary( "atlasrep", "tst" );
optrec:= rec( compareFunction:= "uptowhitespace" );

oldvalue:= UserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles" );

# Run the standard tests with one value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles",
    "minimizing the space" );

# Test the manual examples, including the 'Browse' related ones.
Test( Filename( dirs, "docxpl.tst" ), optrec );

# Test some variants that do not appear in the manual.
Test( Filename( dirs, "atlasrep.tst" ), optrec );

# Run the standard tests with the other value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles", "fast" );

# Test the manual examples, including the 'Browse' related ones.
Test( Filename( dirs, "docxpl.tst" ), optrec );

# Test some variants that do not appear in the manual.
Test( Filename( dirs, "atlasrep.tst" ), optrec );

# Reset the value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles", oldvalue );

# Test the json interface provided by the package.
Test( Filename( dirs, "json.tst" ), optrec );

# Test the internal data files.
# This can be done just once, afterwards some outputs may look differently,
# therefore we do this in the end.
Test( Filename( dirs, "internal.tst" ), optrec );


#############################################################################
##
#E

