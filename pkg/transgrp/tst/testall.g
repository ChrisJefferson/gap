#
# TransGrp: The GAP Transitive Groups Library
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "transgrp" );

TestDirectory(DirectoriesPackageLibrary( "transgrp", "tst" ),
  rec(exitGAP := true,testOptions := rec(compareFunction:="uptowhitespace")));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
