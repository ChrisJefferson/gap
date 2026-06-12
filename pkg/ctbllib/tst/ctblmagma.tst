#############################################################################
##
#W  ctblmagma.tst        GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains a few basic tests for 'CharacterTableComputedByMagma'.
##
##  Note that these tests make sense only if the MAGMA system is available
##  and if the path to the MAGMA executable is stored as the value of the
##  user preference 'MagmaPath'.
##
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/ctbllib' directory, and calls 'Test( "ctblmagma.tst" );'.
##

gap> START_TEST( "Input file: ctblmagma.tst" );

# Load the package.
gap> LoadPackage( "ctbllib" );
true

# 1. option "setclasses" with value 'false'
gap> g:= MathieuGroup( 24 );;
gap> HasConjugacyClasses( g );
false
gap> t:= CharacterTableComputedByMagma( g, "test" : setclasses:= false );;
gap> HasUnderlyingGroup( t );
false
gap> HasConjugacyClasses( t );
false
gap> HasConjugacyClasses( g );
false
gap> IsRecord( TransformingPermutationsCharacterTables( t, 
>        CharacterTable( "M24" ) ) );
true

# 2. no option "setclasses",
#    the group has no conjugacy classes set before the computation
gap> g:= MathieuGroup( 24 );;
gap> HasConjugacyClasses( g );
false
gap> t:= CharacterTableComputedByMagma( g, "test" );;
gap> HasUnderlyingGroup( t );
true
gap> HasConjugacyClasses( t );
true
gap> HasConjugacyClasses( g );
true
gap> ConjugacyClasses( g ) = ConjugacyClasses( t );
true
gap> List( ConjugacyClasses( t ), Size ) = SizesConjugacyClasses( t );
true
gap> List( ConjugacyClasses( t ), x -> Order( Representative( x ) ) )
>        = OrdersClassRepresentatives( t );
true
gap> IsRecord( TransformingPermutationsCharacterTables( t, 
>        CharacterTable( "M24" ) ) );
true

# 3. no option "setclasses",
#    the group has conjugacy classes set before the computation
gap> g:= MathieuGroup( 24 );;
gap> ConjugacyClasses( g );;
gap> HasConjugacyClasses( g );
true
gap> t:= CharacterTableComputedByMagma( g, "test" );;
gap> HasUnderlyingGroup( t );
true
gap> HasConjugacyClasses( t );
true
gap> HasConjugacyClasses( g );
true
gap> ConjugacyClasses( g ) = ConjugacyClasses( t );
true
gap> List( ConjugacyClasses( t ), Size ) = SizesConjugacyClasses( t );
true
gap> List( ConjugacyClasses( t ), x -> Order( Representative( x ) ) )
>        = OrdersClassRepresentatives( t );
true
gap> IsRecord( TransformingPermutationsCharacterTables( t, 
>        CharacterTable( "M24" ) ) );
true

# Done.
gap> STOP_TEST( "ctblmagma.tst" );


#############################################################################
##
#E

