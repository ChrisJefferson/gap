#############################################################################
##
#W  ctadmin.tst          GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains basic tests for functions from 'ctadmin.gi'.
##
gap> START_TEST( "Input file: ctadmin.tst" );

# Load the package.
gap> LoadPackage( "ctbllib", false );
true

# GroupForGroupInfo
gap> GroupForGroupInfo( [ "Nothing", [] ] );
fail
gap> GroupForGroupInfo( [ "DirectProductByNames",
>                         [ [ "Nothing", 2 ], [ "A5" ] ] ] );;
gap> GroupForGroupInfo( [ "DirectProductByNames",
>                         [ [ "Cyclic", 2 ], [ "A5" ] ] ] );;

# Done.
gap> STOP_TEST( "ctadmin.tst" );


#############################################################################
##
#E

