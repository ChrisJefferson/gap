# This file was created from xpl/ctblcons.xpl, do not edit!
#############################################################################
##
#W  ctblcons.g      examples of character table constructions   Thomas Breuer
##

RepresentativesCharacterTables:= function( list )
   local reps, i, found, r;

   reps:= [];
   for i in [ 1 .. Length( list ) ] do
     if ForAll( reps, r -> ( IsCharacterTable( r ) and
            TransformingPermutationsCharacterTables( list[i], r ) = fail )
          or ( IsRecord( r ) and TransformingPermutationsCharacterTables(
                                   list[i].table, r.table ) = fail ) ) then
       Add( reps, list[i] );
     fi;
   od;
   return reps;
   end;;


ConstructOrdinaryMGATable:= function( tblMG, tblG, tblGA, name, lib )
     local acts, poss, trans;

     acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
     poss:= Concatenation( List( acts, pi ->
                PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, pi,
                    name ) ) );
     poss:= RepresentativesCharacterTables( poss );
     if Length( poss ) = 1 then
       # Compare the computed table with the library table.
       if not IsCharacterTable( lib ) then
         List( poss, x -> AutomorphismsOfTable( x.table ) );
         Print( "#I  no library table for ", name, "\n" );
       else
         trans:= TransformingPermutationsCharacterTables( poss[1].table,
                     lib );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " differ\n" );
         fi;
         # Compare the computed fusion with the stored one.
         if OnTuples( poss[1].MGfusMGA, trans.columns )
                <> GetFusionMap( tblMG, lib ) then
           Print( "#E  computed and stored fusion for ", name,
                  " differ\n" );
         fi;
       fi;
     elif Length( poss ) = 0 then
       Print( "#E  no solution for ", name, "\n" );
     else
       Print( "#E  ", Length( poss ), " possibilities for ", name, "\n" );
     fi;
     return poss;
   end;;


ConstructModularMGATables:= function( tblMG, tblGA, ordtblMGA )
   local name, poss, p, modtblMG, modtblGA, modtblMGA, modlib, trans;

   name:= Identifier( ordtblMGA );
   poss:= [];
   for p in Set( Factors( Size( ordtblMGA ) ) ) do
     modtblMG := tblMG mod p;
     modtblGA := tblGA mod p;
     if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
       modtblMGA:= BrauerTableOfTypeMGA( modtblMG, modtblGA, ordtblMGA );
       Add( poss, modtblMGA );
       modlib:= ordtblMGA mod p;
       if IsCharacterTable( modlib ) then
         trans:= TransformingPermutationsCharacterTables( modtblMGA.table,
                     modlib );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " mod ", p, " differ\n" );
         fi;
       else
         AutomorphismsOfTable( modtblMGA.table );
         Print( "#I  no library table for ", name, " mod ", p, "\n" );
       fi;
     else
       Print( "#I  not all input tables for ", name, " mod ", p,
              " available\n" );
     fi;
   od;

   return poss;
   end;;


FindExtraordinaryCase:= function( tblMGA )
   local result, der, nsg, tblMGAclasses, orders, tblMG,
         tblMGfustblMGA, tblMGclasses, pos, M, Mimg, tblMGAfustblGA, tblGA,
         outer, inv, filt, other, primes, p;
   result:= [];
   der:= ClassPositionsOfDerivedSubgroup( tblMGA );
   nsg:= ClassPositionsOfNormalSubgroups( tblMGA );
   tblMGAclasses:= SizesConjugacyClasses( tblMGA );
   orders:= OrdersClassRepresentatives( tblMGA );
   if Length( der ) < NrConjugacyClasses( tblMGA ) then
     # Look for tables of normal subgroups of the form $M.G$.
     for tblMG in Filtered( List( NamesOfFusionSources( tblMGA ),
                                  CharacterTable ), x -> x <> fail ) do
       tblMGfustblMGA:= GetFusionMap( tblMG, tblMGA );
       tblMGclasses:= SizesConjugacyClasses( tblMG );
       pos:= Position( nsg, Set( tblMGfustblMGA ) );
       if pos <> fail and
          Size( tblMG ) = Sum( tblMGAclasses{ nsg[ pos ] } ) then
         # Look for normal subgroups of the form $M$.
         for M in Difference( ClassPositionsOfNormalSubgroups( tblMG ),
                      [ [ 1 ], [ 1 .. NrConjugacyClasses( tblMG ) ] ] ) do
           Mimg:= Set( tblMGfustblMGA{ M } );
           if Sum( tblMGAclasses{ Mimg } ) = Sum( tblMGclasses{ M } ) then
             tblMGAfustblGA:= First( ComputedClassFusions( tblMGA ),
                 r -> ClassPositionsOfKernel( r.map ) = Mimg );
             if tblMGAfustblGA <> fail then
               tblGA:= CharacterTable( tblMGAfustblGA.name );
               tblMGAfustblGA:= tblMGAfustblGA.map;
               outer:= Difference( [ 1 .. NrConjugacyClasses( tblGA ) ],
                   CompositionMaps( tblMGAfustblGA, tblMGfustblMGA ) );
               inv:= InverseMap( tblMGAfustblGA ){ outer };
               filt:= Flat( Filtered( inv, IsList ) );
               if not IsEmpty( filt ) then
                 other:= Filtered( inv, IsInt );
                 primes:= Filtered( Set( Factors( Size( tblMGA ) ) ),
                    p -> ForAll( orders{ filt }, x -> x mod p = 0 )
                         and ForAny( orders{ other }, x -> x mod p <> 0 ) );
                 for p in primes do
                   Add( result, [ Identifier( tblMG ),
                                  Identifier( tblMGA ),
                                  Identifier( tblGA ), p ] );
                 od;
               fi;
             fi;
           fi;
         od;
       fi;
     od;
   fi;
   return result;
end;;


ProcessGS3Example:= function( t, tC, tK, identifier, pi )
   local tF, lib, trans, p, tmodp, tCmodp, tKmodp, modtF;

   tF:= CharacterTableOfTypeGS3( t, tC, tK, pi,
            Concatenation( identifier, "new" ) );
   lib:= CharacterTable( identifier );
   if lib <> fail then
     trans:= TransformingPermutationsCharacterTables( tF.table, lib );
     if not IsRecord( trans ) then
       Print( "#E  computed table and library table for `", identifier,
              "' differ\n" );
     fi;
   else
     Print( "#I  no library table for `", identifier, "'\n" );
   fi;
   StoreFusion( tC, tF.tblCfustblKC, tF.table );
   StoreFusion( tK, tF.tblKfustblKC, tF.table );
   for p in Set( Factors( Size( t ) ) ) do
     tmodp := t  mod p;
     tCmodp:= tC mod p;
     tKmodp:= tK mod p;
     if IsCharacterTable( tmodp ) and
        IsCharacterTable( tCmodp ) and
        IsCharacterTable( tKmodp ) then
       modtF:= CharacterTableOfTypeGS3( tmodp, tCmodp, tKmodp,
                   tF.table,
                   Concatenation(  identifier, "mod", String( p ) ) );
       if   Length( Irr( modtF.table ) ) <>
            Length( Irr( modtF.table )[1] ) then
         Print( "#E  nonsquare result table for `",
                identifier, " mod ", p, "'\n" );
       elif lib <> fail and IsCharacterTable( lib mod p ) then
         trans:= TransformingPermutationsCharacterTables( modtF.table,
                                                          lib mod p );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for `",
                  identifier, " mod ", p, "' differ\n" );
         fi;
       else
         Print( "#I  no library table for `", identifier, " mod ",
                p, "'\n" );
       fi;
     else
       Print( "#I  not all inputs available for `", identifier,
              " mod ", p, "'\n" );
     fi;
   od;
end;;


ConstructOrdinaryGV4Table:= function( tblG, tblsG2, name, lib )
     local acts, nam, poss, reps, i, trans;

     # Compute the possible actions for the ordinary tables.
     acts:= PossibleActionsForTypeGV4( tblG, tblsG2 );
     # Compute the possible ordinary tables for the given actions.
     nam:= Concatenation( "new", name );
     poss:= Concatenation( List( acts, triple -> 
         PossibleCharacterTablesOfTypeGV4( tblG, tblsG2, triple, nam ) ) );
     # Test the possibilities for permutation equivalence.
     reps:= RepresentativesCharacterTables( poss );
     if 1 < Length( reps ) then
       Print( "#I  ", name, ": ", Length( reps ),
              " equivalence classes\n" );
     elif Length( reps ) = 0 then
       Print( "#E  ", name, ": no solution\n" );
     else
       # Compare the computed table with the library table.
       if not IsCharacterTable( lib ) then
         Print( "#I  no library table for ", name, "\n" );
         PrintToLib( name, poss[1].table );
         for i in [ 1 .. 3 ] do
           Print( LibraryFusion( tblsG2[i],
                      rec( name:= name, map:= poss[1].G2fusGV4[i] ) ) );
         od;
       else
         trans:= TransformingPermutationsCharacterTables( poss[1].table,
                     lib );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " differ\n" );
         fi;
         # Compare the computed fusions with the stored ones.
         if List( poss[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
                <> List( tblsG2, x -> GetFusionMap( x, lib ) ) then
           Print( "#E  computed and stored fusions for ", name,
                  " differ\n" );
         fi;
       fi;
     fi;
     return poss;
   end;;


ConstructModularGV4Tables:= function( tblG, tblsG2, ordposs,
                                         ordlibtblGV4 )
     local name, modposs, primes, checkordinary, i, record, p, tmodp,
           t2modp, poss, modlib, trans, reps;

     if not IsCharacterTable( ordlibtblGV4 ) then
       Print( "#I  no ordinary library table ...\n" );
       return [];
     fi;
     name:= Identifier( ordlibtblGV4 );
     modposs:= [];
     primes:= Set( Factors( Size( tblG ) ) );
     ordposs:= ShallowCopy( ordposs );
     checkordinary:= false;
     for i in [ 1 .. Length( ordposs ) ] do
       modposs[i]:= [];
       record:= ordposs[i];
       for p in primes do
         tmodp := tblG  mod p;
         t2modp:= List( tblsG2, t2 -> t2 mod p );
         if IsCharacterTable( tmodp ) and
            ForAll( t2modp, IsCharacterTable ) then
           poss:= PossibleCharacterTablesOfTypeGV4( tmodp, t2modp,
                      record.table, record.G2fusGV4 );
           poss:= RepresentativesCharacterTables( poss );
           if   Length( poss ) = 0 then
             Print( "#I  excluded cand. ", i, " (out of ",
                    Length( ordposs ), ") for ", name, " by ", p,
                    "-mod. table\n" );
             Unbind( ordposs[i] );
             Unbind( modposs[i] );
             checkordinary:= true;
             break;
           elif Length( poss ) = 1 then
             # Compare the computed table with the library table.
             modlib:= ordlibtblGV4 mod p;
             if IsCharacterTable( modlib ) then
               trans:= TransformingPermutationsCharacterTables(
                           poss[1].table, modlib );
               if not IsRecord( trans ) then
                 Print( "#E  computed table and library table for ",
                        name, " mod ", p, " differ\n" );
               fi;
             else
               Print( "#I  no library table for ",
                      name, " mod ", p, "\n" );
               PrintToLib( name, poss[1].table );
             fi;
           else
             Print( "#I  ", name, " mod ", p, ": ", Length( poss ),
                    " equivalence classes\n" );
           fi;
           Add( modposs[i], poss );
         else
           Print( "#I  not all input tables for ", name, " mod ", p,
                  " available\n" );
           primes:= Difference( primes, [ p ] );
         fi;
       od;
     od;
     if checkordinary then
       # Test whether the ordinary table is admissible.
       ordposs:= Compacted( ordposs );
       modposs:= Compacted( modposs );
       reps:= RepresentativesCharacterTables( ordposs );
       if 1 < Length( reps ) then
         Print( "#I  ", name, ": ", Length( reps ),
                " equivalence classes (ord. table)\n" );
       elif Length( reps ) = 0 then
         Print( "#E  ", name, ": no solution (ord. table)\n" );
       else
         # Compare the computed table with the library table.
         trans:= TransformingPermutationsCharacterTables(
                     ordposs[1].table, ordlibtblGV4 );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " differ\n" );
         fi;
         # Compare the computed fusions with the stored ones.
         if List( ordposs[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
              <> List( tblsG2, x -> GetFusionMap( x, ordlibtblGV4 ) ) then
           Print( "#E  computed and stored fusions for ", name,
                  " differ\n" );
         fi;
       fi;
     fi;
     return rec( ordinary:= ordposs, modular:= modposs );
   end;;


ConstructOrdinaryV4GTable:= function( tblG, tbl2G, name, lib )
     local ord3, nam, poss, reps, trans;

     # Compute the possible actions for the ordinary tables.
     ord3:= Set( List( Filtered( AutomorphismsOfTable( tblG ),
                                 x -> Order( x ) = 3 ),
                       SmallestGeneratorPerm ) );
     if 1 < Length( ord3 ) then
       Print( "#I  ", name,
              ": the action of the automorphism is not unique" );
     fi;
     # Compute the possible ordinary tables for the given actions.
     nam:= Concatenation( "new", name );
     poss:= Concatenation( List( ord3, pi ->
            PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, nam ) ) );
     # Test the possibilities for permutation equivalence.
     reps:= RepresentativesCharacterTables( poss );
     if 1 < Length( reps ) then
       Print( "#I  ", name, ": ", Length( reps ),
              " equivalence classes\n" );
     elif Length( reps ) = 0 then
       Print( "#E  ", name, ": no solution\n" );
     else
       # Compare the computed table with the library table.
       if not IsCharacterTable( lib ) then
         Print( "#I  no library table for ", name, "\n" );
         PrintToLib( name, poss[1].table );
       else
         trans:= TransformingPermutationsCharacterTables( reps[1], lib );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " differ\n" );
         fi;
       fi;
     fi;
     return poss;
   end;;


ConstructModularV4GTables:= function( tblG, tbl2G, ordposs,
                                         ordlibtblV4G )
     local name, modposs, primes, checkordinary, i, p, tmodp, 2tmodp, aut,
           poss, modlib, trans, reps;

     if not IsCharacterTable( ordlibtblV4G ) then
       Print( "#I  no ordinary library table ...\n" );
       return [];
     fi;
     name:= Identifier( ordlibtblV4G );
     modposs:= [];
     primes:= Set( Factors( Size( tblG ) ) );
     ordposs:= ShallowCopy( ordposs );
     checkordinary:= false;
     for i in [ 1 .. Length( ordposs ) ] do
       modposs[i]:= [];
       for p in primes do
         tmodp := tblG  mod p;
         2tmodp:= tbl2G mod p;
         if IsCharacterTable( tmodp ) and IsCharacterTable( 2tmodp ) then
           aut:= ConstructionInfoCharacterTable( ordposs[i] )[3];
           poss:= BrauerTableOfTypeV4G( ordposs[i], 2tmodp, aut );
           if CTblLib.Test.TensorDecomposition( poss, false ) = false then
             Print( "#I  excluded cand. ", i, " (out of ",
                    Length( ordposs ), ") for ", name, " by ", p,
                    "-mod. table\n" );
             Unbind( ordposs[i] );
             Unbind( modposs[i] );
             checkordinary:= true;
             break;
           fi;
           Add( modposs[i], poss );
         else
           Print( "#I  not all input tables for ", name, " mod ", p,
                  " available\n" );
           primes:= Difference( primes, [ p ] );
         fi;
       od;
       if IsBound( modposs[i] ) then
         # Compare the computed Brauer tables with the library tables.
         for poss in modposs[i] do
           p:= UnderlyingCharacteristic( poss );
           modlib:= ordlibtblV4G mod p;
           if IsCharacterTable( modlib ) then
             trans:= TransformingPermutationsCharacterTables(
                         poss, modlib );
             if not IsRecord( trans ) then
               Print( "#E  computed table and library table for ",
                      name, " mod ", p, " differ\n" );
             fi;
           else
             Print( "#I  no library table for ",
                    name, " mod ", p, "\n" );
             PrintToLib( name, poss );
           fi;
         od;
       fi;
     od;
     if checkordinary then
       # Test whether the ordinary table is admissible.
       ordposs:= Compacted( ordposs );
       modposs:= Compacted( modposs );
       reps:= RepresentativesCharacterTables( ordposs );
       if 1 < Length( reps ) then
         Print( "#I  ", name, ": ", Length( reps ),
                " equivalence classes (ord. table)\n" );
       elif Length( reps ) = 0 then
         Print( "#E  ", name, ": no solution (ord. table)\n" );
       else
         # Compare the computed table with the library table.
         trans:= TransformingPermutationsCharacterTables( reps[1],
                     ordlibtblV4G );
         if not IsRecord( trans ) then
           Print( "#E  computed table and library table for ", name,
                  " differ\n" );
         fi;
       fi;
     fi;
     # Test the uniqueness of the Brauer tables.
     for poss in TransposedMat( modposs ) do
       reps:= RepresentativesCharacterTables( poss );
       if Length( reps ) <> 1 then
         Print( "#I  ", name, ": ", Length( reps ), " candidates for the ",
                UnderlyingCharacteristic( reps[1] ), "-modular table\n" );
       fi;
     od;
     return rec( ordinary:= ordposs, modular:= modposs );
   end;;


#############################################################################
##
#E

