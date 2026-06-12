#############################################################################
##
#W  testauto.g           GAP 4 package CTblLib                  Thomas Breuer
##
##  Running these tests requires only a few minutes of CPU time,
##  contrary to 'tst/testall.g'.
##  Therefore, this testfile is listed in 'PackageInfo.g',
##  and 'tst/testall.g' is not.
##

LoadPackage( "ctbllib", false );
dirs:= DirectoriesPackageLibrary( "ctbllib", "tst" );
optrec:= rec( compareFunction:= "uptowhitespace" );

# Test the manual examples but omit the 'Browse' related ones.
success:= Test( Filename( dirs, "docxpl2.tst" ), optrec );

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

