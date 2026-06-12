#############################################################################
##
#W  testauto.g           GAP 4 package AtlasRep                 Thomas Breuer
##

LoadPackage( "atlasrep", false );
dirs:= DirectoriesPackageLibrary( "atlasrep", "tst" );
optrec:= rec( compareFunction:= "uptowhitespace" );

success:= true;
AtlasRepTest:= function( filename )
    success:= Test( Filename( dirs, filename ), optrec ) and success;
end;

oldvalue:= UserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles" );

# Run the standard tests with one value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles",
    "minimizing the space" );

# Test the manual examples but omit the 'Browse' related ones.
AtlasRepTest( "docxpl2.tst" );

# Test some variants that do not appear in the manual.
AtlasRepTest( "atlasrep.tst" );

# Run the standard tests with the other value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles", "fast" );

# Test the manual examples but omit the 'Browse' related ones.
AtlasRepTest( "docxpl2.tst" );

# Test some variants that do not appear in the manual.
AtlasRepTest( "atlasrep.tst" );

# Reset the value.
SetUserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles", oldvalue );

# Test the json interface provided by the package.
AtlasRepTest( "json.tst" );

# Test the internal data files.
# This can be done just once, afterwards some outputs may look differently,
# therefore we do this in the end.
AtlasRepTest( "internal.tst" );

# Report overall test results.
if success then
  Print( "#I  No errors detected while testing\n\n" );
  QUIT_GAP( 0 );
else
  Print( "#I  Errors detected while testing\n\n" );
  QUIT_GAP( 1 );
fi;


#############################################################################
##
#E

