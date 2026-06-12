#############################################################################
##
#A  ctbllib.tst                GAP 3 tests                      Thomas Breuer
##
##  In order to run the tests, start GAP 3 and call 'Read( "ctbllib.tst" );'.
##

RequirePackage( "ctbllib" );

# Check that all ordinary tables can be loaded without problems,
# are internally consistent, and have power maps and automorphisms stored.
easytest:= function( ordtbl )
      if not TestCharTable( ordtbl ) then
        Print( "#E  not internally consistent: ", ordtbl, "\n" );
      fi;
      if ForAny( Set( Factors( Size( ordtbl ) ) ),
                   p -> not IsBound( ordtbl.powermap[p] ) ) then
        Print( "#E  some power maps are missing: ", ordtbl, "\n" );
      fi;
      if not IsBound( ordtbl.automorphisms ) then
        Print( "#E  table automorphisms missing: ", ordtbl, ",\n" );
      fi;
      return true;
end;;
AllCharTableNames( easytest, false );;

# Check that all Brauer tables can be loaded without problems.
brauernames:= function( ordtbl )
      local primes;
      primes:= Set( Factors( Size( CharTable( ordtbl ) ) ) );
      return List( primes, p -> Concatenation( ordtbl,
                                    "mod", String( p ) ) );
end;;
AllCharTableNames( OfThose, brauernames, IsCharTable, true );;


#############################################################################
##
#E

