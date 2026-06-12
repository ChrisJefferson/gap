#############################################################################
##
#W  testall.g            GAP 4 package CTblLib                  Thomas Breuer
##
##  Running these tests requires several days of CPU time (on my notebook).
##  Therefore, this test file should not be listed in 'PackageInfo.g'.
##

dirs:= DirectoriesPackageLibrary( "ctbllib", "tst" );

# The following tests require access to MAGMA.
if CTblLib.IsMagmaAvailable() then
  Test( Filename( dirs, "ctblmagma.tst" ) );
fi;

# We assume that the following packages are available.
pkglist:= [ "AtlasRep", "Browse", "cohomolo", "GrpConst", "SpinSym", "TomLib" ];
for pkg in pkglist do
  if LoadPackage( pkg, false ) <> true then
    Print( "#E  The package '", pkg, "' is missing,\n",
           "#E  some test outputs will not match.\n" );
  fi;
od;

# The following tests were created from GAPDoc format files in 'doc',
# or have been created as test files.
Test( Filename( dirs, "docxpl.tst" ) );        # manual examples
Test( Filename( dirs, "ctbllib.tst" ) );       # run over all tables etc.
Test( Filename( dirs, "ctadmin.tst" ) );

# The following tests were created from GAPDoc format files in 'doc2'.
Test( Filename( dirs, "ctblcons.tst" ) );
Test( Filename( dirs, "ctocenex.tst" ) );
Test( Filename( dirs, "hamilcyc.tst" ) );
Test( Filename( dirs, "o8p2s3_o8p5s3.tst" ) );
Test( Filename( dirs, "sporsolv.tst" ) );
Test( Filename( dirs, "spornilp.tst" ) );
Test( Filename( dirs, "ctblpope.tst" ) );
Test( Filename( dirs, "ambigfus.tst" ) );
Test( Filename( dirs, "dntgap.tst" ) );
Test( Filename( dirs, "maintain.tst" ) );

# The following test files were created from 'xpl' files.
Test( Filename( dirs, "ctbldeco.tst" ) );
Test( Filename( dirs, "multfree.tst" ) );
Test( Filename( dirs, "multfre2.tst" ) );
Test( Filename( dirs, "probgen.tst" ) );
Test( Filename( dirs, "ctblatlas.tst" ) );
Test( Filename( dirs, "ctblbm.tst" ) );
if CTblLib.IsMagmaAvailable() then
  Test( Filename( dirs, "ctblm.tst" ) );
fi;

#############################################################################
##
#E

