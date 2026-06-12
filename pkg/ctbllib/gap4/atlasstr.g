#############################################################################
##
#W  atlasstr.g           GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains functions and data for showing ATLAS maps
##  and ATLAS tables.
##
##  1. Notify data about different portions that belong to a simple group.
##  2. Show the map of an ATLAS group.
##  3. Show the table of contents of the ATLAS.
##


#############################################################################
##
##  1. Notify data about different portions that belong to a simple group.
##

#############################################################################
##
#F  CTblLib.AtlasGroupPermuteToDashedTablesFunction( <tbl>, <dashedname> )
##
##  Let <tbl> be a character table (ordinary or modular),
##  and <dashedname> be the name of an upward extension
##  that is not available in GAP's character table library.
##  If 'CTblLib.AtlasGroupPermuteToDashedTables[2]' contains an entry 'l'
##  with 'l[1]' equal to the 'Identifier' value of <tbl> and 'l[3]' equal to
##  <dashedname> then 'l[2]' is the name of an available table $tx$, say,
##  that differs from the table $tx'$, say, with name <dashedname> by a
##  permutation of rows and columns.
##  The automorphism of <tbl> that conjugates 
##  The two automorphisms of <tbl> that are induced by $tx$ and $tx'$ are
##  conjugates by the automorphism of <tbl> that is stored in 'l[4]'.
##  
##  This information is used to describe the character table $tx'$, say,
##  of <dashedname>, provided that $t$ and $tx$ are known.
##
##  If the underlying characteristic $p$ of <tbl> is nonzero then 'l[4]' must
##  be rewritten to a permutation on the $p$-regular classes.
##
##  (This description of ``dashed'' tables is needed by
##  'StringOfCambridgeFormat'.)
##
##  If the relevant information is available then
##  this function returns a record with the following components.
##
##  'fusion':
##    the class fusion from $t$ to $tx'$,
##
##  'table':
##    the character table $tx'$.
##
##  Otherwise 'fail' is returned.
##
CTblLib.AtlasGroupPermuteToDashedTablesFunction:= function( t, dashedname )
    local char, ordt, entry, tx, autcols, fus, fusx, moved, img, imgx,
          permcols, txdash, modfus, reg, modtx, irrt, autrows, rest,
          dec, decx, pos, posx, permrows, ind, i;

    # Always permute the classes of the *ordinary* table,
    # in order to have a consistent 'OrdinaryCharacterTable' value.
    char:= UnderlyingCharacteristic( t );
    if char = 0 then
      ordt:= t;
    else
      ordt:= OrdinaryCharacterTable( t );
    fi;

    # Find the entry in the list 'CTblLib.AtlasGroupPermuteToDashedTables'.
    entry:= First( CTblLib.AtlasGroupPermuteToDashedTables[2],
                   l -> l[1] = Identifier( ordt ) and l[3] = dashedname );
    if entry = fail then
      return fail;
    fi;

    tx:= CharacterTable( entry[2] );
    if tx = fail then
      return fail;
    fi;
    autcols:= entry[4];

    # Shortcut for the case "9.U3(8).3_3'",
    # where we have both a dashed name and a broken box.
    # (I do not know how to treat this generically.)
    if entry[3] = "9.U3(8).3_3'" then
      if char <> 0 then
        tx:= tx mod char;
      fi;
      return rec( table:= tx, fusion:= fail );
    fi;

    # Compute the permuted fusion and the class permutation in the image.
    fus:= GetFusionMap( ordt, tx );
    fusx:= Permuted( fus, autcols );
    moved:= Set( MovedPoints( autcols ) );

    # 'fus' is '[ ..., a, b, b, ... ]',
    # 'fusx' is '[ ..., b, a, b, ... ]',
    # we have to apply (a,b) to the columns of 'tx'
    # (consider only the first occurrence of each image).
    img:= DuplicateFreeList( fus{ moved } );
    imgx:= DuplicateFreeList( fusx{ moved } );
    permcols:= MappingPermListList( img, imgx )^-1;
    txdash:= CharacterTableWithSortedClasses( tx, permcols );
    ResetFilterObj( txdash, HasClassPermutation );
    fusx:= OnTuples( fusx, permcols );

    # Rewrite 'autcols', 'permcols', 'fusx' w.r.t. 'char'-regular classes
    # and replace the character tables by Brauer tables
    # if the characteristic is nonzero.
    if char <> 0 then
      modfus:= GetFusionMap( t, ordt );
      autcols:= PermList( CompositionMaps( InverseMap( modfus ),
                    CompositionMaps( ListPerm( autcols,
                        NrConjugacyClasses( ordt ) ), modfus ) ) );
      reg:= CharacterTableRegular( txdash, char );
      fusx:= CompositionMaps( InverseMap( GetFusionMap( reg, txdash ) ),
                 CompositionMaps( fusx, GetFusionMap( t, ordt ) ) );
      modtx:= tx mod char;
      if modtx = fail then
        return fail;
      fi;
      modfus:= GetFusionMap( reg, txdash );
      permcols:= PermList( CompositionMaps( InverseMap( modfus ),
                    CompositionMaps( ListPerm( permcols,
                        NrConjugacyClasses( txdash ) ), modfus ) ) );
      fus:= CompositionMaps( InverseMap( GetFusionMap( modtx, tx ) ),
                CompositionMaps( fus, GetFusionMap( t, ordt ) ) );
      tx:= modtx;
    fi;

    # Compute the row permutation.
    # For that, we have to determine
    # - the action of characters of 't' induced by 'aut' and
    # - the extension/fusion of characters between 't' and 'tx'.
    irrt:= List( Irr( t ), ValuesOfClassFunction );
    autrows:= Sortex( List( irrt, x -> Permuted( x, autcols ) ) )
              / Sortex( irrt );

    rest:= List( Irr( tx ), x -> ValuesOfClassFunction( x ){ fus } );
    dec:= TransposedMat( Decomposition( Irr( t ), rest, "nonnegative" ) );
    decx:= Permuted( dec, autrows );
    moved:= Set( MovedPoints( autrows ) );

    # the pattern in 'dec' is '[ ..., [ x, y ], [ z ], [ z ], ... ]',
    # the pattern in 'decx' is '[ ..., [ z ], [ x, y ], [ z ], ... ]',
    # we have to apply (x,y,z) to the rows of 'tx'
    # (consider only the first occurrence of each character of 'tx').
    pos:= DuplicateFreeList( Concatenation( List( moved,
                                 x -> Positions( dec[x], 1 ) ) ) );
    posx:= DuplicateFreeList( Concatenation( List( moved,
                                  x -> Positions( decx[x], 1 ) ) ) );
    permrows:= MappingPermListList( posx, pos );

    # Apply the permutation to the characters,
    # and let the dashed table look like a library table.
    if char = 0 then
      txdash:= CharacterTableWithSortedCharacters( txdash, permrows );
      ResetFilterObj( txdash, HasIdentifier );
      SetIdentifier( txdash, entry[3] );
      SetConstructionInfoCharacterTable( txdash,
          [ "ConstructPermuted", [ Identifier( tx ) ], permcols, permrows ] );
    else
      txdash:= reg;
      SetIrr( txdash,
          List( Permuted( Irr( tx ), permrows ),
                x -> Character( txdash,
                         Permuted( ValuesOfClassFunction( x ),
                                   permcols ) ) ) );

      # Set also the indicators that are stored on the undashed table.
      ind:= ComputedIndicators( tx );
      if not IsEmpty( ind ) then
        for i in [ 1 .. Length( ind ) ] do
          if IsBound( ind[i] ) then
            ComputedIndicators( txdash )[i]:= Permuted( ind[i], permrows );
          fi;
        od;
      fi;
    fi;

    return rec( fusion:= fusx,
permrows:= permrows,
permcols:= permcols,
char:= char,
                table:= txdash,
              );
    end;


#############################################################################
##
#V  CTblLib.AtlasGroupPermuteToDashedTables
##
##  This is a list of length 2.
##  The first entry is a record that stores permutations.
##  The second entry is a list whose entries have one of the forms
##  '[ G, G.a, G.adash, aut ]' or '[ G, m.G, mdash.G, aut ]'.
##
##  Each entry describes how to create the unavailable character table with
##  ``dashed'' name 'G.adash' or 'mdash.G' from the permutation equivalent
##  available table with name 'G.a' or 'm.G'.
##  The point is to permute classes and characters of $G.a$ and to adjust the
##  class fusion from $G$ such that the ATLAS conventions are satisfied.
##
##  Typical situations are
##
##  - an upward extension $G.a'$ that is equivalent to another upward
##    extension $G.a$ such that the two groups are conjugate in a bigger
##    upward extension;
##    the action of the conjugating automorphism on the classes of the table
##    of $G$ is sufficient to construct the relevant permutations.
##
##  - a downward extension $m'.G$ that is equivalent to another doenward
##    extension $m.G$ such that the two groups are conjugate in a bigger
##    bicyclic extension;
##    the action of the conjugating automorphism on the classes of the table
##    of $G$ is sufficient to construct the relevant permutations.
##
##  The data are used for example by 'StringOfCambridgeFormat'.
##
CTblLib.AtlasGroupPermuteToDashedTables:= MakeImmutable( [
  # the action of the relevant group automorphism
  rec(
    ("L3(4)"):= (4,5,6),
    ("L3(4).2_1"):= (4,5,6)(12,13,14),
    ("3.L3(4)"):= (8,11,14)(9,12,15)(10,13,16),
    ("Sz(8)"):= (6,7,8)(9,10,11),
    ("U3(5)"):= (6,7,8),
    ("3.U3(5)"):= (14,17,20)(15,18,21)(16,19,22),
    ("L3(7)"):= (7,8,9),
    ("3.L3(7)"):= (17,20,23)(18,21,24)(19,22,25),
    ("U4(3).2_2"):= (13,14)(18,19),
    ("U4(3).2_3"):= (4,5)(11,12)(13,14)(16,18)(17,19),
    ("U4(3).(2^2)_{133}"):= (4,5)(11,12)(13,14)(16,17)(24,25)(29,30)(31,32)
                            (33,34),
    ("U4(3).(2^2)_{122}"):= (13,14)(29,30)(33,34),
    ("U3(8)"):= (6,7,8),
    ("3.U3(8)"):= (14,17,20)(15,18,21)(16,19,22),
    ("U3(11)"):= (15,16,17),
    ("3.U3(11)"):= (41,44,47)(42,45,48)(43,46,49),
    ("O8+(2)"):= (3,4,5)(7,8,9)(14,15,16)(18,19,20)(21,22,23)(24,25,26)
                 (28,29,30)(31,32,33)(38,39,40)(41,42,43)(44,45,46)(48,49,50)
                 (51,52,53),
    ("U6(2)"):= (10,11,12)(26,27,28)(40,41,42),
    ("3.U6(2)"):= (26,29,32)(27,30,33)(28,31,34)(72,75,78)(73,76,79)
                  (74,77,80)(112,115,118)(113,116,119)(114,117,120),
    ("O8+(3).2_1"):= (2,3,4)(7,8,9)(10,11,12)(14,15,16)(20,21,22)(24,25,26)
                 (27,28,29)(31,32,33)(34,35,36)(37,38,39)(40,41,42)(43,44,45)
                 (47,48,49)(51,52,53)(58,59,60)(61,62,63)(65,66,67)(69,70,71)
                 (72,73,74)(75,76,77)(78,79,80)(81,82,83)(86,87,88)(89,90,91)
                 (92,93,94)(97,98,99)(100,101,102)(103,104,105)(106,107,108)
                 (109,110,111)(112,113,114),
    ("O8+(3).3"):= (3,4)(7,10)(8,9,11,12)(13,16,14,15)(21,22)(25,26)(28,29)
                   (31,34)(32,33,35, 36)(37,40)(38,39,41,42)(44,45)
                   (46,49,47,48)(50,53,51,52)(58,61)(59,60,62,63)
                   (64,67,65,66)(68,71,69,70)(73,74)(76,77)(78,81)
                   (79,80,82,83)(85,88,86,87)(89,92)(90,91,93,94)(98,99)
                   (100,103)(101,102,104,105)(106,109)(107,108,110,111)
                   (113,114),
    ("2E6(2)"):= (11,12,13)(16,17,18)(39,40,41)(43,44,45)(46,47,48)(64,65,66)
                 (67,68,69)(75,76,77)(78,79,80)(88,89,90)(91,92,93)(94,95,96)
                 (114,115,116)(117,118,119),
     ),
  [
    [ "L3(4)", "L3(4).2_2", "L3(4).2_2'", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "L3(4).2_2", "L3(4).2_2''", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "L3(4).2_3", "L3(4).2_3'", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "L3(4).2_3", "L3(4).2_3''", ~[1].( "L3(4)" )^2 ],
    [ "3.L3(4)", "3.L3(4).2_2", "3.L3(4).2_2'", ~[1].( "3.L3(4)" ) ],
    [ "3.L3(4)", "3.L3(4).2_2", "3.L3(4).2_2''", ~[1].( "3.L3(4)" )^2 ],
    [ "3.L3(4)", "3.L3(4).2_3", "3.L3(4).2_3'", ~[1].( "3.L3(4)" ) ],
    [ "3.L3(4)", "3.L3(4).2_3", "3.L3(4).2_3''", ~[1].( "3.L3(4)" )^2 ],

    [ "L3(4).2_1", "2.L3(4).2_1", "2'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "2.L3(4).2_1", "2''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],
    [ "L3(4).2_1", "4_1.L3(4).2_1", "4_1'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "4_1.L3(4).2_1", "4_1''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],
    [ "L3(4).2_1", "4_2.L3(4).2_1", "4_2'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "4_2.L3(4).2_1", "4_2''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],
    [ "L3(4).2_1", "6.L3(4).2_1", "6'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "6.L3(4).2_1", "6''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],
    [ "L3(4).2_1", "12_1.L3(4).2_1", "12_1'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "12_1.L3(4).2_1", "12_1''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],
    [ "L3(4).2_1", "12_2.L3(4).2_1", "12_2'.L3(4).2_1", ~[1].( "L3(4).2_1" ) ],
    [ "L3(4).2_1", "12_2.L3(4).2_1", "12_2''.L3(4).2_1", ~[1].( "L3(4).2_1" )^2 ],

    [ "L3(4)", "2.L3(4)", "2'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "2.L3(4)", "2''.L3(4)", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "4_1.L3(4)", "4_1'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "4_1.L3(4)", "4_1''.L3(4)", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "4_2.L3(4)", "4_2'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "4_2.L3(4)", "4_2''.L3(4)", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "6.L3(4)", "6'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "6.L3(4)", "6''.L3(4)", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "12_1.L3(4)", "12_1'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "12_1.L3(4)", "12_1''.L3(4)", ~[1].( "L3(4)" )^2 ],
    [ "L3(4)", "12_2.L3(4)", "12_2'.L3(4)", ~[1].( "L3(4)" ) ],
    [ "L3(4)", "12_2.L3(4)", "12_2''.L3(4)", ~[1].( "L3(4)" )^2 ],

    [ "Sz(8)", "2.Sz(8)", "2'.Sz(8)", ~[1].( "Sz(8)" ) ],
    [ "Sz(8)", "2.Sz(8)", "2''.Sz(8)", ~[1].( "Sz(8)" )^2 ],

    [ "U3(5)", "U3(5).2", "U3(5).2'", ~[1].( "U3(5)" ) ],
    [ "U3(5)", "U3(5).2", "U3(5).2''", ~[1].( "U3(5)" )^2 ],
    [ "3.U3(5)", "3.U3(5).2", "3.U3(5).2'", ~[1].( "3.U3(5)" ) ],
    [ "3.U3(5)", "3.U3(5).2", "3.U3(5).2''", ~[1].( "3.U3(5)" )^2 ],

    [ "L3(7)", "L3(7).2", "L3(7).2'", ~[1].( "L3(7)" ) ],
    [ "L3(7)", "L3(7).2", "L3(7).2''", ~[1].( "L3(7)" )^2 ],
    [ "3.L3(7)", "3.L3(7).2", "3.L3(7).2'", ~[1].( "3.L3(7)" ) ],
    [ "3.L3(7)", "3.L3(7).2", "3.L3(7).2''", ~[1].( "3.L3(7)" )^2 ],

    [ "U4(3)", "3_1.U4(3)", "3_1'.U4(3)", ~[1].( "U4(3).2_3" ) ],
    [ "U4(3)", "6_1.U4(3)", "6_1'.U4(3)", ~[1].( "U4(3).2_3" ) ],
    [ "U4(3)", "12_1.U4(3)", "12_1'.U4(3)", ~[1].( "U4(3).2_3" ) ],
    [ "U4(3)", "3_2.U4(3)", "3_2'.U4(3)", ~[1].( "U4(3).2_2" ) ],
    [ "U4(3)", "6_2.U4(3)", "6_2'.U4(3)", ~[1].( "U4(3).2_2" ) ],
    [ "U4(3)", "12_2.U4(3)", "12_2'.U4(3)", ~[1].( "U4(3).2_2" ) ],

    [ "U4(3).2_1", "3_1.U4(3).2_1", "3_1'.U4(3).2_1", ~[1].("U4(3).(2^2)_{133}") ],
    [ "U4(3).2_1", "6_1.U4(3).2_1", "6_1'.U4(3).2_1", ~[1].("U4(3).(2^2)_{133}") ],
    [ "U4(3).2_1", "12_1.U4(3).2_1", "12_1'.U4(3).2_1", ~[1].("U4(3).(2^2)_{133}") ],

    [ "U4(3).2_2", "3_1.U4(3).2_2'", "3_1'.U4(3).2_2", () ],
    [ "U4(3).2_2", "6_1.U4(3).2_2'", "6_1'.U4(3).2_2", () ],
    [ "U4(3).2_2", "12_1.U4(3).2_2'", "12_1'.U4(3).2_2", () ],

    [ "U4(3).2_1", "3_2.U4(3).2_1", "3_2'.U4(3).2_1", ~[1].("U4(3).(2^2)_{122}") ],
    [ "U4(3).2_1", "6_2.U4(3).2_1", "6_2'.U4(3).2_1", ~[1].("U4(3).(2^2)_{122}") ],
    [ "U4(3).2_1", "12_2.U4(3).2_1", "12_2'.U4(3).2_1", ~[1].("U4(3).(2^2)_{122}") ],

    [ "U4(3).2_3", "3_2.U4(3).2_3'", "3_2'.U4(3).2_3", () ],
    [ "U4(3).2_3", "6_2.U4(3).2_3'", "6_2'.U4(3).2_3", () ],
    [ "U4(3).2_3", "12_2.U4(3).2_3'", "12_2'.U4(3).2_3", () ],

    [ "4.U4(3)", "4.U4(3).2_2", "4.U4(3).2_2'", (2,4)(8,10)(11,15)(12,18)(13,17)(14,16)(20,22)(24,26)(29,31)(33,35)(36,38)(37,39)(40,44)(41,47)(42,46)(43,45)(48,51)(49,50)(52,60)(53,63)(54,62)(55,61)(56,64)(57,67)(58,66)(59,65)(69,71) ],
    [ "4.U4(3)", "4.U4(3).2_3", "4.U4(3).2_3'", (2,4)(8,10)(12,14)(16,18)(20,22)(24,26)(29,31)(33,35)(40,44)(41,47)(42,46)(43,45)(48,51)(49,50)(53,55)(57,59)(60,64)(61,67)(62,66)(63,65)(69,71) ],

    [ "U3(8)", "U3(8).2", "U3(8).2'", ~[1].( "U3(8)" ) ],
    [ "U3(8)", "U3(8).2", "U3(8).2''", ~[1].( "U3(8)" )^2 ],
    [ "U3(8)", "U3(8).3_3", "U3(8).3_3'", () ],
    [ "U3(8)", "U3(8).6", "U3(8).6'", (6,7,8) ], # the same 3 conjugates the 6s!
    [ "U3(8)", "U3(8).6", "U3(8).6''", (6,8,7) ],
# note: the group aut. of order 6 induces
# (3,4)(7,8)(9,10)(11,12,13)(14,15,16)(17,20,21,18,19,22)(23,26,27,24,25,28),
# determined using 2-modular table!
    [ "3.U3(8)", "3.U3(8).2", "3.U3(8).2'", ~[1].( "3.U3(8)" ) ],
    [ "3.U3(8)", "3.U3(8).2", "3.U3(8).2''", ~[1].( "3.U3(8)" )^2 ],
    [ "3.U3(8)", "9.U3(8).3_3", "9.U3(8).3_3'", () ],
    [ "3.U3(8)", "3.U3(8).6", "3.U3(8).6'", ~[1].( "3.U3(8)" ) ],
    [ "3.U3(8)", "3.U3(8).6", "3.U3(8).6''", ~[1].( "3.U3(8)" )^2 ],

    [ "U3(11)", "U3(11).2", "U3(11).2'", ~[1].( "U3(11)" ) ],
    [ "U3(11)", "U3(11).2", "U3(11).2''", ~[1].( "U3(11)" )^2 ],
    [ "3.U3(11)", "3.U3(11).2", "3.U3(11).2'", ~[1].( "3.U3(11)" ) ],
    [ "3.U3(11)", "3.U3(11).2", "3.U3(11).2''", ~[1].( "3.U3(11)" )^2 ],

    [ "O8+(2)", "O8+(2).2", "O8+(2).2'", ~[1].( "O8+(2)" ) ],
    [ "O8+(2)", "O8+(2).2", "O8+(2).2''", ~[1].( "O8+(2)" )^2 ],

    [ "O8+(2)", "2.O8+(2)", "2'.O8+(2)", ~[1].( "O8+(2)" ) ],
    [ "O8+(2)", "2.O8+(2)", "2''.O8+(2)", ~[1].( "O8+(2)" )^2 ],

    [ "U6(2)", "U6(2).2", "U6(2).2'", ~[1].( "U6(2)" ) ],
    [ "U6(2)", "U6(2).2", "U6(2).2''", ~[1].( "U6(2)" )^2 ],
    [ "3.U6(2)", "3.U6(2).2", "3.U6(2).2'", ~[1].( "3.U6(2)" ) ],
    [ "3.U6(2)", "3.U6(2).2", "3.U6(2).2''", ~[1].( "3.U6(2)" )^2 ],

    [ "U6(2)", "2.U6(2)", "2'.U6(2)", ~[1].( "U6(2)" ) ],
    [ "U6(2)", "2.U6(2)", "2''.U6(2)", ~[1].( "U6(2)" )^2 ],
    [ "U6(2)", "6.U6(2)", "6'.U6(2)", ~[1].( "U6(2)" ) ],
    [ "U6(2)", "6.U6(2)", "6''.U6(2)", ~[1].( "U6(2)" )^2 ],

    [ "O8+(3)", "O8+(3).2_1", "O8+(3).2_1'", ~[1].( "O8+(3).2_1" ) ],
    [ "O8+(3)", "O8+(3).2_1", "O8+(3).2_1''", ~[1].( "O8+(3).2_1" )^2 ],
    [ "O8+(3)", "O8+(3).3", "O8+(3).3'", ~[1].( "O8+(3).3" ) ],
    [ "O8+(3)", "O8+(3).3", "O8+(3).3''", ~[1].( "O8+(3).3" )^2 ],
    [ "O8+(3)", "O8+(3).3", "O8+(3).3'''", ~[1].( "O8+(3).3" )^3 ],

    # We need a right transversal of the 2_2 normalizer in S4.
    [ "O8+(3)", "O8+(3).2_2", "O8+(3).2_2'",
      (7,10)(9,12)(13,15)(14,16)(31,34)(33,36)(37,40)(39,42)(46,48)(47,49)
      (50,52)(51,53)(58,61)(60,63)(64,66)(65,67)(68,70)(69,71)(78,81)(80,83)
      (85,87)(86,88)(89,92)(91,94)(100,103)(102,105)(106,109)(108,111) ],
    [ "O8+(3)", "O8+(3).2_2", "O8+(3).2_2''",
      (2,3)(7,8)(10,11)(14,15)(20,21)(24,25)(27,28)(31,32)(34,35)(37,38)
      (40,41)(43,44)(47,48)(51,52)(58,59)(61,62)(65,66)(69,70)(72,73)(75,76)
      (78,79)(81,82)(86,87)(89,90)(92,93)(97,98)(100,101)(103,104)(106,107)
      (109,110)(112,113) ],
    [ "O8+(3)", "O8+(3).2_2", "O8+(3).2_2'''",
      (2,3)(7,11,10,8)(9,12)(13,14,16,15)(20,21)(24,25)(27,28)(31,35,34,32)
      (33,36)(37,41,40,38)(39,42)(43,44)(46,47,49,48)(50,51,53,52)
      (58,62,61,59)(60,63)(64,65,67,66)(68,69,71,70)(72,73)(75,76)
      (78,82,81,79)(80,83)(85,86,88,87)(89,93,92,90)(91,94)(97,98)
      (100,104,103,101)(102,105)(106,110,109,107)(108,111)(112,113) ],
    [ "O8+(3)", "O8+(3).2_2", "O8+(3).2_2''''",
      (2,4,3)(7,12,8)(9,11,10)(13,14,15)(20,22,21)(24,26,25)(27,29,28)
      (31,36,32)(33,35,34)(37,42,38)(39,41,40)(43,45,44)(46,47,48)(50,51,52)
      (58,63,59)(60,62,61)(64,65,66)(68,69,70)(72,74,73)(75,77,76)(78,83,79)
      (80,82,81)(85,86,87)(89,94,90)(91,93,92)(97,99,98)(100,105,101)
      (102,104,103)(106,111,107)(108,110,109)(112,114,113) ],
    [ "O8+(3)", "O8+(3).2_2", "O8+(3).2_2'''''",
      (2,4,3)(7,9,8)(10,12,11)(14,16,15)(20,22,21)(24,26,25)(27,29,28)
      (31,33,32)(34,36,35)(37,39,38)(40,42,41)(43,45,44)(47,49,48)(51,53,52)
      (58,60,59)(61,63,62)(65,67,66)(69,71,70)(72,74,73)(75,77,76)(78,80,79)
      (81,83,82)(86,88,87)(89,91,90)(92,94,93)(97,99,98)(100,102,101)
      (103,105,104)(106,108,107)(109,111,110)(112,114,113) ],

    [ "O8+(3)", "O8+(3).4", "O8+(3).4'", ~[1].( "O8+(3).2_1" ) ],
    [ "O8+(3)", "O8+(3).4", "O8+(3).4''", ~[1].( "O8+(3).2_1" )^2 ],

    [ "2E6(2)", "2E6(2).2", "2E6(2).2'", ~[1].( "2E6(2)" ) ],
    [ "2E6(2)", "2E6(2).2", "2E6(2).2''", ~[1].( "2E6(2)" )^2 ],

    [ "2E6(2)", "2.2E6(2)", "2'.2E6(2)", ~[1].( "2E6(2)" ) ],
    [ "2E6(2)", "2.2E6(2)", "2''.2E6(2)", ~[1].( "2E6(2)" )^2 ],
    [ "2E6(2)", "6.2E6(2)", "6'.2E6(2)", ~[1].( "2E6(2)" ) ],
    [ "2E6(2)", "6.2E6(2)", "6''.2E6(2)", ~[1].( "2E6(2)" )^2 ],
  ] ] );


#############################################################################
##
#V  CTblLib.BrokenBoxReplacements
##
##  This is used by 'StringOfCambridgeFormat'.
##  The entries have the form '[ <names>, <nameperf>, <phi>, <roots> ]',
##  where <names> is a pair consisting of the identifiers of m.G (perfect)
##  and m'.G.a (the larger bicyclic extension that exists),
##  and <nameperf> is the identifier that belongs to the larger group
##  m'.G.
##
CTblLib.BrokenBoxReplacements:= [
    [ [ "2.A6", "4.A6.2_3" ], "Isoclinic(2.A6x2)", 2,
      [ E(4), -E(4) ] ],
    [ [ "6.A6", "12.A6.2_3" ], "Isoclinic(6.A6x2)", 4,
      [ E(12), E(12)^5, E(12)^7, E(12)^11 ] ],
    [ [ "2.L2(25)", "4.L2(25).2_3" ], "Isoclinic(2.L2(25)x2)", 2,
      [ E(4), -E(4) ] ],
    [ [ "2.L2(49)", "4.L2(49).2_3" ], "Isoclinic(2.L2(49)x2)", 2,
      [ E(4), -E(4) ] ],
    [ [ "2.L2(81)", "4.L2(81).2_3" ], "Isoclinic(2.L2(81)x2)", 2,
      [ E(4), -E(4) ] ],
    [ [ "2.L2(81)", "4.L2(81).4_2" ], "Isoclinic(2.L2(81)x2)", 2,
      [ E(4), -E(4) ] ],
    [ [ "3.U3(8)", "9.U3(8).3_3" ], "Isoclinic(3.U3(8)x3)", 6,
      [ E(9), E(9)^2, E(9)^4, E(9)^5, E(9)^7, E(9)^8 ] ],
    [ [ "3.U3(8)", "9.U3(8).3_3'" ], "Isoclinic(3.U3(8)x3)", 6,
      [ E(9), E(9)^2, E(9)^4, E(9)^5, E(9)^7, E(9)^8 ] ],
  ];


#############################################################################
##
##  2. Show the map of an ATLAS group.
##


#############################################################################
##
#V  CTblLib.AtlasMapBoxesSpecial
#F  CTblLib.AtlasMapBoxesSpecialSet( <name>, <shape>[, <replname> ] )
##
##  'CTblLib.AtlasMapBoxesSpecial' is a list that contains information about
##  box shapes that (currently) cannot be computed from the available
##  character tables.
##  The first entry is a list of strings that would be identifiers of
##  character tables if the names would be just composed from the
##  relevant part of the multiplier, the name of the simple group, and the
##  relevant part of the outer automorphism group.
##  The second entry is a list of the corresponding shapes of boxes.
##  The third entry is a list of the real table identifiers.
##
##  'CTblLib.AtlasMapBoxesSpecialSet' adds information to the list.
##
CTblLib.AtlasMapBoxesSpecial:= [ [], [], [] ];

CTblLib.AtlasMapBoxesSpecialSet:= function( arg )
    local identifier, type, len;

    identifier:= arg[1];
    type:= arg[2];
    len:= Length( CTblLib.AtlasMapBoxesSpecial[1] ) + 1;
    CTblLib.AtlasMapBoxesSpecial[1][ len ]:= identifier;
    CTblLib.AtlasMapBoxesSpecial[2][ len ]:= type;
    if Length( arg ) = 3 then
      CTblLib.AtlasMapBoxesSpecial[3][ len ]:= arg[3];
    else
      CTblLib.AtlasMapBoxesSpecial[3][ len ]:= identifier;
    fi;
end;

CTblLib.AtlasMapBoxesSpecialSet( "2.A6.2_3", "broken", "4.A6.2_3" );
CTblLib.AtlasMapBoxesSpecialSet( "6.A6.2_3", "broken", "12.A6.2_3" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.2E6(2).2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.2E6(2).2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "3.2E6(2).2'", "open" );  # remove as soon as the table of 3.G.3 becomes available
CTblLib.AtlasMapBoxesSpecialSet( "3.2E6(2).2''", "open" );  # remove as soon as the table of 3.G.3 becomes available
CTblLib.AtlasMapBoxesSpecialSet( "3.2E6(2).3", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6'.2E6(2).2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6''.2E6(2).2''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "2.L2(25).2_3", "broken", "4.L2(25).2_3" );
CTblLib.AtlasMapBoxesSpecialSet( "2.L2(49).2_3", "broken", "4.L2(49).2_3" );
CTblLib.AtlasMapBoxesSpecialSet( "2.L2(81).2_3", "broken", "4.L2(81).2_3" );
CTblLib.AtlasMapBoxesSpecialSet( "2.L2(81).4_2", "broken", "4.L2(81).4_2" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.L3(4).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.L3(4).2_2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.L3(4).2_3'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.L3(4).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.L3(4).2_2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.L3(4).2_3''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1'.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1'.L3(4).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1'.L3(4).2_3'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1''.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1''.L3(4).2_2''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_1''.L3(4).2_3''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2'.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2'.L3(4).2_2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2'.L3(4).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2''.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2''.L3(4).2_2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "4_2''.L3(4).2_3''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6'.L3(4).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6'.L3(4).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6'.L3(4).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6''.L3(4).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6''.L3(4).2_2''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6''.L3(4).2_3''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.L3(4).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.L3(4).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1''.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1''.L3(4).2_2''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1''.L3(4).2_3''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.L3(4).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.L3(4).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2''.L3(4).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2''.L3(4).2_2''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2''.L3(4).2_3''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(2).2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(2).2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).2_1'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).2_1''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).2_1'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).2_1''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).2_1", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).2_1'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).2_1''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).2_2", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).2_2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).2_2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).2_2'''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).2_2''''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).2_2'''''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2.O8+(3).4", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.O8+(3).4'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.O8+(3).4''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "3.U3(8).3_3", "broken", "9.U3(8).3_3" );
CTblLib.AtlasMapBoxesSpecialSet( "3.U3(8).3_3'", "broken", "9.U3(8).3_3'" );
CTblLib.AtlasMapBoxesSpecialSet( "3.U3(8).6'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3.U3(8).6''", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4.U4(3).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "4.U4(3).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_1'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6_1'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_1'.U4(3).2_2", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6_1'.U4(3).2_2", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.U4(3).2_2", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_1'.U4(3).2_2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6_1'.U4(3).2_2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "12_1'.U4(3).2_2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_2'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6_2'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.U4(3).2_1", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_2'.U4(3).2_3", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6_2'.U4(3).2_3", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.U4(3).2_3", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "3_2'.U4(3).2_3'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6_2'.U4(3).2_3'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "12_2'.U4(3).2_3'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "2'.U6(2).2'", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "2''.U6(2).2''", "closed" );
CTblLib.AtlasMapBoxesSpecialSet( "6'.U6(2).2'", "open" );
CTblLib.AtlasMapBoxesSpecialSet( "6''.U6(2).2''", "open" );

MakeImmutable( CTblLib.AtlasMapBoxesSpecial );


#############################################################################
##
#V  CTblLib.AtlasMapMultNames
#V  CTblLib.AtlasMapOutNames
##
CTblLib.AtlasMapMultNames:= MakeImmutable( [
    [ "", [] ],
    [ "12", # The order of the divisors is unintuitive.
      [ "2", "4", "3", "6", "12" ] ],
    [ "2^2", # Currently there are no 2^2 cases where 2_1, 2_2, 2_3 occur,
             # thus deal with 2.G, 2'.G, 2''.G.
#T what about O12+(3)?
      [ "2", "2'", "2''" ] ],
    [ "(2^2x3)", # This occurs for U6(2), 2E6(2).
      [ "2", "2'", "2''", "3", "6", "6'", "6''" ] ],
    [ "(3^2x4)", # The only case in the ATLAS is U4(3),
                 # and we know that there are just 3_1 and 3_2.
      [ "2", "4", "3_1", "3_1'", "6_1", "6_1'", "12_1", "12_1'",
        "3_2", "3_2'", "6_2", "6_2'", "12_2", "12_2'" ] ],
    [ "(3x4^2)", # The only case in the ATLAS is L3(4),
                 # and we know that there are just 4_1 and 4_2.
      [ "2", "2'", "2''", "4_1", "4_1'", "4_1''",
        "4_2", "4_2'", "4_2''", "3", "6", "6'", "6''",
        "12_1", "12_1'", "12_1''", "12_2", "12_2'", "12_2''" ] ],
  ] );

CTblLib.AtlasMapOutNames:= MakeImmutable( [
    [ "2^2", # This occurs for A6, L2(p^2), L3(9), L4(3), L4(4), S4(9),
             # O12-(3), O8-(3), U4(5).
      [ "2_1", "2_2", "2_3" ] ],
    [ "3.2", # This occurs for 2E6(2), L3(7), O8+(2), U3(11), U3(5), U6(2).
             # Note that the ordering depends on the multiplier.
      [ "3", "2", "2'", "2''" ],
      function( mult )
        if mult = "2^2" or mult = "(2^2x3)" then
          return (1,4,3,2);  # Put the 3 to the end.
        else
          return ();
        fi;
      end ],
    [ "D8", # This occurs for U4(3), L4(5), O10-(3), O12+(3).
      [ "2_1", "4", "2_2", "2_2'", "2_3", "2_3'" ] ],
    [ "D12", # This occurs for L3(4).
      [ "2_1", "3", "6", "2_2", "2_2'", "2_2''", "2_3", "2_3'", "2_3''" ] ],
    [ "(2x4)", # This occurs for L2(81).
      [ "2_1", "4_1", "2_2", "2_3", "4_2" ] ],
    [ "(S3x3)", # This occurs for U3(8).
      [ "3_1", "3_2", "3_3", "3_3'", "2", "2'", "2''", "6", "6'", "6''" ] ],
    [ "S4", # This occurs for O8+(3), O8+(7).
      [ "2_1", "2_1'", "2_1''", "3", "3'", "3''", "3'''",
        "2_2", "2_2'", "2_2''", "2_2'''", "2_2''''", "2_2'''''",
        "4", "4'", "4''" ] ],
  ] );


#############################################################################
##
#V  CTblLib.AtlasTablesReduceToSubset
##
##  The ATLAS shows not all extensions, GAP may contain not all extensions.
##  The version of 'StringOfCambridgeFormat' with first argument a string
##  (the name of the simple group) will reduce the result to the submatrix
##  defined below.
##
CTblLib.AtlasTablesReduceToSubset:= MakeImmutable( [
    [ "O8+(3)", [ 1 ], [ 1 .. 17 ] ],
    [ "2E6(2)", [ 1, 2 ], [ 1, 2 ] ],
  ] );


#############################################################################
##
#F  CTblLib.DisplayAtlasMap_ComputePortions( <simplename>, <p> )
##
##  This is an auxiliary function of 'CTblLib.StringsAtlasMap_CompleteData'.
##  It returns a record with the components 'labels' and 'identifiers'.
##
##  <simplename> must be an admissible name of a character table from
##  GAP's Character Table Library such that the attribute
##  'ExtensionInfoCharacterTable' is set for this character table
##  and such that the lists 'CTblLib.AtlasMapMultNames' and
##  'CTblLib.AtlasMapOutNames' contain entries for the multiplier and the
##  outer automorphism group, respectively.
##
##  If these conditions are not satisfied then 'fail' is returned.
##
CTblLib.DisplayAtlasMap_ComputePortions:= function( simplename, p )
    local t, ext, mult, out, entry, mdivs, i, pos, odivs, labels,
          identifiers, j, id, rows, row;

    # Determine the involved portions.
    t:= CharacterTable( simplename );
    if t = fail or not HasExtensionInfoCharacterTable( t ) then
      Info( InfoCharacterTable, 1,
            "The table of ", simplename, " is not available." );
      return fail;
    fi;
    ext:= ExtensionInfoCharacterTable( t );
    mult:= ext[1];
    out:= ext[2];

    entry:= First( CTblLib.AtlasMapMultNames, x -> x[1] = mult );
    if entry <> fail then
      # Prefer entries from the explicit list.
      mdivs:= ShallowCopy( entry[2] );
    elif Int( mult ) <> fail then
      mdivs:= List( Difference( DivisorsInt( Int( mult ) ), [ 1 ] ),
                    String );
    else
      Info( InfoCharacterTable, 1,
            "mult = ", mult, " is not (yet) supported." );
      return fail;
    fi;

    if p <> 0 then
      # Omit the 'p'-singular part of the multiplier.
      for i in [ 1 .. Length( mdivs ) ] do
        pos:= Position( mdivs[i], '_' );
        if pos <> fail then
          if Int( mdivs[i]{ [ 1 .. pos - 1 ] } ) mod p = 0 then
            Unbind( mdivs[i] );
          fi;
        else
          pos:= Position( mdivs[i], '\'' );
          if pos <> fail then
            if Int( mdivs[i]{ [ 1 .. pos - 1 ] } ) mod p = 0 then
              Unbind( mdivs[i] );
            fi;
          elif Int( mdivs[i] ) mod p = 0 then
            Unbind( mdivs[i] );
          fi;
        fi;
      od;
      mdivs:= Compacted( mdivs );
    fi;

    entry:= First( CTblLib.AtlasMapOutNames, x -> x[1] = out );
    if entry <> fail then
      # Prefer entries from the explicit list.
      odivs:= ShallowCopy( entry[2] );
      if Length( entry ) = 3 then
        odivs:= Permuted( odivs, entry[3]( mult ) );
      fi;
    elif out = "" then
      odivs:= [];
    elif Int( out ) <> fail then
      odivs:= List( Difference( DivisorsInt( Int( out ) ), [ 1 ] ),
                    String );
    else
      Info( InfoCharacterTable, 1,
            "out = ", out, " is not (yet) supported." );
      return fail;
    fi;

    # Compose the matrices of labels and identifiers.
    labels:= [ [ "G" ] ];
    identifiers:= [ [ simplename ] ];
    for j in odivs do
      Add( labels[1], Concatenation( "G.", j ) );
      Add( identifiers[1], Concatenation( simplename, ".", j ) );
    od;
    for i in mdivs do
      Add( labels, [ Concatenation( i, ".G" ) ] );
      Add( identifiers, [ Concatenation( i, ".", simplename ) ] );
    od;
    for i in [ 1 .. Length( mdivs ) ] do
      for j in [ 1 .. Length( odivs ) ] do
        id:= Concatenation( mdivs[i], ".", simplename, ".", odivs[j] );
        pos:= Position( CTblLib.AtlasMapBoxesSpecial[1], id );
        if pos <> fail and
           CTblLib.AtlasMapBoxesSpecial[3][ pos ] <> fail then
          id:= CTblLib.AtlasMapBoxesSpecial[3][ pos ];
          Add( labels[ i+1 ], ReplacedString( id, simplename, "G" ) );
          Add( identifiers[ i+1 ], id );
        else
          Add( labels[ i+1 ],
               Concatenation( mdivs[i], ".G.", odivs[j] ) );
          Add( identifiers[ i+1 ],
               Concatenation( mdivs[i], ".", simplename, ".", odivs[j] ) );
        fi;
      od;
    od;

    # Remove boxes of nonexisting extensions.
    if mult = "2^2" and p <> 2 then
      # In the available cases,
      # there is no acting 3 on downward extensions by a single 2.
      for i in [ 2 .. 4 ] do
        for j in [ 1 .. Length( odivs ) ] do
          if odivs[j] in [ "3", "6" ] or
             ( 1 < Length( odivs[j] ) and
               odivs[j]{ [ 1, 2 ] } in [ "3_", "6_", "3'", "6'" ] ) then
            labels[i][ j+1 ]:= "";
            identifiers[i][ j+1 ]:= fail;
          fi;
        od;
      od;
    fi;

    return rec( labels:= labels,
                identifiers:= identifiers );
end;


#############################################################################
##
#F  CTblLib.StringsAtlasMap_CompleteData( <arec> )
##
##  This is an auxiliary function of 'StringsAtlasMap'.
##  It returns either 'true' or 'false'.
##
CTblLib.StringsAtlasMap_CompleteData:= function( arec )
    local info, i, dottedname, charTable, lab, endswithdash,
          hasdashbeforedot, otbls, mtbls, tbl, mtbl, fus, ker, j, motbl,
          nondashed, nondashedtbl, r, target, cand, name, exttbl, kercand,
          kername, pos, img, sh, lin, m, mroot, orders, c;

    if not IsBound( arec.char ) then
      # Set the default.
      arec.char:= 0;
    fi;

    if not IsBound( arec.specialshapes ) then
      arec.specialshapes:= [ [], [], [] ];
    fi;

    if not IsBound( arec.identifiers ) then
      # Compute the involved library tables.
      info:= CTblLib.DisplayAtlasMap_ComputePortions( arec.name, arec.char );
      if info = fail then
        return false;
      fi;
      arec.identifiers:= info.identifiers;
    fi;

    if not IsBound( arec.onlyasciiboxes ) then
      arec.onlyasciiboxes:= CTblLib.ShowOnlyASCII();
    fi;

    if not IsBound( arec.onlyasciilabels ) then
      arec.onlyasciilabels:= CTblLib.ShowOnlyASCII();
    fi;

    if not IsBound( arec.labels ) then
      if not IsBound( info ) then
        info:= CTblLib.DisplayAtlasMap_ComputePortions( arec.name,
                                                        arec.char );
        if info = fail then
          return false;
        fi;
      fi;
      if not arec.onlyasciilabels then
        for i in [ 1 .. Length( info.labels ) ] do
          info.labels[i]:= List( info.labels[i],
                                 x -> ReplacedString( x, "_1", "₁" ) );
          info.labels[i]:= List( info.labels[i],
                                 x -> ReplacedString( x, "_2", "₂" ) );
          info.labels[i]:= List( info.labels[i],
                                 x -> ReplacedString( x, "_3", "₃" ) );
        od;
      fi;
      arec.labels:= info.labels;
    fi;

    dottedname:= Concatenation( ".", arec.name, "." );
    Append( arec.specialshapes[1], CTblLib.AtlasMapBoxesSpecial[1] );
    Append( arec.specialshapes[2], CTblLib.AtlasMapBoxesSpecial[2] );
    Append( arec.specialshapes[3], CTblLib.AtlasMapBoxesSpecial[3] );
    pos:= PositionsProperty( arec.specialshapes[3],
              x -> PositionSublist( x, dottedname ) <> fail );
    arec.specialshapes[1]:= arec.specialshapes[1]{ pos };
    arec.specialshapes[2]:= arec.specialshapes[2]{ pos };
    arec.specialshapes[3]:= arec.specialshapes[3]{ pos };

    if not IsBound( arec.showdashedrows ) then
      arec.showdashedrows:= ( arec.char = 0 );
    fi;

    charTable:= function( idorfail, p )
      local tbl;

      if idorfail = fail then
        return fail;
      fi;
      tbl:= CharacterTable( idorfail );
      if tbl = fail then
        return fail;
      elif p <> 0 then
        tbl:= tbl mod p;
      fi;
      return tbl;
    end;

    endswithdash:= string -> string[ Length( string ) ] = '\'';

    hasdashbeforedot:= string ->
        '.' in string and string[ Position( string, '.' ) - 1 ] = '\'';

    if not IsBound( arec.shapes ) then
      # Compute the shapes of the boxes
      # (closed/open/broken/empty, dashed or not).
      arec.shapes:= [ [ ] ];

      # The first row consists of closed boxes.
      for lab in arec.labels[1] do
        Add( arec.shapes[1], "closed" );
      od;

      # The first column consists of closed boxes.
      for i in [ 2 .. Length( arec.labels ) ] do
        arec.shapes[i]:= [ "closed" ];
      od;

      # The shape of the other boxes depends on the action.
      otbls:= List( arec.identifiers[1], x -> charTable( x, 0 ) );
      mtbls:= List( arec.identifiers, l -> charTable( l[1], 0 ) );
      tbl:= mtbls[1];
      if tbl = fail then
        Info( InfoCharacterTable, 1,
              "the table of ", arec.identifiers[1][1], " is missing" );
        return false;
      fi;
      for i in [ 2 .. Length( mtbls ) ] do
        mtbl:= mtbls[i];
        if mtbl = fail then
          fus:= fail;
        else
          fus:= GetFusionMap( mtbl, tbl );
        fi;
        if fus <> fail then
          ker:= ClassPositionsOfKernel( fus );
        else
          ker:= fail;
        fi;
        for j in [ 2 .. Length( otbls ) ] do
          if arec.identifiers[i][j] in arec.specialshapes[3] then
            # This case is explicitly listed.
            arec.shapes[i][j]:= arec.specialshapes[2][
                Position( arec.specialshapes[3], arec.identifiers[i][j] ) ];
          else
            # use the character table.
            motbl:= charTable( arec.identifiers[i][j], 0 );
            if motbl = fail then
              # For non-ATLAS tables, we give up.
              if ForAll( CTblLib.AtlasPages,
                         x -> x[1][1] <> arec.identifiers[1][1] ) then
                return false;
              fi;

              # For proper ATLAS tables, we know that the box is either
              # empty (i. e., the bicyclic extension does not exist),
              # or we know a conjugate extension with the same box shape.
              arec.shapes[i][j]:= "empty";

              # If the automorphism is a 2' contained in an S_3
              # which acts on the i-th central extension
              # then the shape is the same as for the non-dashed box.
              if endswithdash( arec.identifiers[1][j] ) then
                nondashed:= ShallowCopy( arec.identifiers[i][j] );
                while nondashed <> fail
                      and nondashed[ Length( nondashed ) ] = '\'' do
                  Unbind( nondashed[ Length( nondashed ) ] );
                od;
                nondashedtbl:= charTable( nondashed, 0 );
                if nondashedtbl <> fail
                   and nondashed in arec.identifiers[i] then
                  for r in ComputedClassFusions( nondashedtbl ) do
                    target:= CharacterTable( r.name );
                    if target <> fail and
                       Size( target ) / Size( nondashedtbl ) = 3 and
                       not Set( r.map ) in ClassPositionsOfNormalSubgroups(
                                               target ) then
                      # There is some S3 factor that acts; confirm that the
                      # kernel of this action is a group of index 2
                      # that occurs in the list.
                      cand:= Intersection( NamesOfFusionSources( target ),
                                           arec.identifiers[i] );
                      for name in cand do
                        exttbl:= CharacterTable( name );
                        if 2 * Size( exttbl ) = Size( target ) and
                           ClassPositionsOfKernel( GetFusionMap( exttbl,
                               target ) ) = [ 1 ] then
                          kercand:= Intersection(
                              NamesOfFusionSources( exttbl ),
                              arec.identifiers[i],
                              NamesOfFusionSources( nondashedtbl ) );
                          for kername in kercand do
                            if Size( nondashedtbl ) /
                               Size( CharacterTable( kername ) ) = 2 then
                              pos:= Position( arec.identifiers[i],
                                              nondashed );
                              arec.shapes[i][j]:= arec.shapes[i][ pos ];
                            fi;
                          od;
                        fi;
                      od;
                    fi;
                  od;
                fi;
              fi;
            else
              # We have the table, we can compute the action.
              if ker = fail then
                arec.shapes[i][j]:= "empty";
              else
                img:= GetFusionMap( mtbl, motbl ){ ker };
                if IsDuplicateFreeList( img ) then
                  arec.shapes[i][j]:= "closed";
                else
                  arec.shapes[i][j]:= "open";
                fi;
              fi;
            fi;
          fi;
        od;
      od;
    fi;

    for i in [ 1 .. Length( arec.identifiers ) ] do
      for j in [ 1 .. Length( arec.identifiers[1] ) ] do
        if arec.shapes[i][j] = "empty" then
          arec.identifiers[i][j]:= "";
          arec.labels[i][j]:= "";
        fi;
      od;
    od;

    if not IsBound( arec.dashedhorz ) then
      arec.dashedhorz:= List( arec.labels, l -> hasdashbeforedot( l[1] ) );
    fi;
    if not IsBound( arec.dashedvert ) then
      arec.dashedvert:= List( arec.labels[1], endswithdash );
    fi;

    if not IsBound( arec.labelscol ) then
      # Compute the class numbers from the character tables.
      if not IsBound( otbls ) or arec.char <> 0 then
        otbls:= List( arec.identifiers[1], x -> charTable( x, arec.char ) );
      fi;
      tbl:= otbls[1];
      if tbl = fail then
        # The table of the simple group is not available.
        Info( InfoCharacterTable, 1,
              "the table of ", arec.identifiers[1][1], " is missing" );
        return false;
      fi;
      arec.labelscol:= [ String( NrConjugacyClasses( tbl ) ) ];
      for i in [ 2 .. Length( otbls ) ] do
        # Omit the column label for dashed extensions
        # (no matter whether the character table is available).
        lab:= arec.labels[1][i];
        if arec.dashedvert[i] then
          arec.labelscol[i]:= "";
        elif otbls[i] = fail then
          Info( InfoCharacterTable, 1,
                "the table of ", arec.identifiers[1][i], " is missing" );
          return false;
        elif arec.char <> 0
             and Size( otbls[i] ) / Size( tbl ) mod arec.char = 0 then
          # p-singular extension
          arec.labelscol[i]:= "0";
        else
          fus:= GetFusionMap( tbl, otbls[i] );
          if fus = fail then
            Info( InfoCharacterTable, 1,
                  "no fusion from ", Identifier( tbl ), " to ",
                  Identifier( otbls[i] ) );
            return false;
          fi;
          img:= Set( fus );
          lin:= Filtered( Irr( otbls[i] ),
                          chi -> chi[1] = 1 and Set( chi{ img } ) = [ 1 ] );
          m:= Length( lin );
          mroot:= E(m);
          lin:= First( lin,
                       chi -> mroot in chi and m mod Conductor( chi ) = 0 );
          if lin = fail then
            # Can this happen for Brauer tables?
            arec.labelscol[i]:= "0";
          else
            arec.labelscol[i]:= String( Number( lin, x -> x = mroot ) );
          fi;
        fi;
      od;
    fi;

    if not IsBound( arec.labelsrow ) then
      # Compute the character numbers from the character tables.
      if not IsBound( mtbls ) or arec.char <> 0 then
        mtbls:= List( arec.identifiers, x -> charTable( x[1], arec.char ) );
      fi;
      tbl:= mtbls[1];
      if tbl = fail then
        # The table of the simple group is not available.
        Info( InfoCharacterTable, 1,
              "the table of ", arec.identifiers[1][1], " is missing" );
        return false;
      fi;
      arec.labelsrow:= [ String( NrConjugacyClasses( tbl ) ) ];
      for i in [ 2 .. Length( mtbls ) ] do
        # Omit the row label for dashed extensions
        # (no matter whether the character table is available).
        lab:= arec.labels[i][1];
        if arec.dashedhorz[i] then
          arec.labelsrow[i]:= "";
        elif mtbls[i] = fail then
          Info( InfoCharacterTable, 1,
                "the table of ", arec.identifiers[i][1], " is missing" );
          return false;
        else
          # Note that we are dealing only with the 'p'-regular part
          # of the multiplier.
          fus:= GetFusionMap( mtbls[i], tbl );
          if fus = fail then
            Info( InfoCharacterTable, 1,
                  "no fusion from ", Identifier( mtbls[i] ), " to ",
                  Identifier( tbl ) );
            return false;
          fi;
          img:= Set( fus );
          orders:= OrdersClassRepresentatives( mtbls[i] );
          c:= ClassPositionsOfKernel( fus );
          m:= Length( c );
          c:= First( c, x -> orders[x] = m );
          mroot:= E(m);
          arec.labelsrow[i]:= String( Number( Irr( mtbls[i] ),
                                      chi -> chi[c] = mroot * chi[1] ) );
        fi;
      od;
    fi;

    return true;
end;


#############################################################################
##
#F  CTblLib.AtlasMapFirstLine( <labels>, <widths>, <relevant> )
##
##  The result is either 'fail' (if no dashed names occur in the first row
##  of boxes) or the string that appears above the first row of boxes
##  and shows the dashed names.
##
##  <labels> is the list of names of the boxes in the first row,
##  <widths> is the list of column widths, and
##  <relevant> is a list of 'true'/'false' values; 'true' at position $i$
##  means that the $i$-th name shall appear in the result.
##
CTblLib.AtlasMapFirstLine:= function( labels, widths, relevant )
    local pos, dashednames, i, width, firstline, j;

    pos:= 1;
    dashednames:= [];
    for i in [ 1 .. Length( labels ) ] do
      width:= widths[i];
      if relevant[i] then
        if IsBound( dashednames[ i-1 ] ) then
          # Insert the name on the right of the ulc of the box.
          dashednames[i]:= [ labels[i],
            pos,
            pos + WidthUTF8String( labels[i] ) - 1 ];
        else
          # Insert the name on the left of the urc of the box.
          dashednames[i]:= [ labels[i],
            pos + width - WidthUTF8String( labels[i] ),
            pos + width - 1 ];
        fi;
      fi;
      pos:= pos + width + 1;
    od;

    if dashednames = [] then
      return fail;
    fi;

    # Show only the first and the last ones in a block of dashed names,
    # in order to avoid overlaps.
    # (This happens for O8+(3).)
    pos:= PositionBound( dashednames );
    while pos <= Length( dashednames ) do
      i:= pos + 1;
      while IsBound( dashednames[i] ) do
        i:= i + 1;
      od;
      for j in [ pos + 1 .. i - 2 ] do
        Unbind( dashednames[j] );
      od;
      pos:= i;
      while pos <= Length( dashednames )
            and not IsBound( dashednames[ pos ] ) do
        pos:= pos + 1;
      od;
    od;
    dashednames:= Compacted( dashednames );
    firstline:= RepeatedString( " ", dashednames[1][2] - 1 );
    for i in [ 1 .. Length( dashednames ) - 1 ] do
      Append( firstline, dashednames[i][1] );
      Append( firstline,
              RepeatedString( " ",
                  dashednames[ i+1 ][2] - dashednames[i][3] - 1 ) );
    od;
    Append( firstline, dashednames[ Length( dashednames ) ][1] );

    return firstline;
  end;


#############################################################################
##
#F  DisplayAtlasMap( <name>[, <p>] )
#F  DisplayAtlasMap( <arec> )
#F  StringsAtlasMap( <name>[, <p>] )
#F  StringsAtlasMap( <arec> )
##
##  <#GAPDoc Label="DisplayAtlasMap">
##  <ManSection>
##  <Func Name="DisplayAtlasMap" Arg='name[,p]'
##   Label="for the name of a simple group"/>
##  <Func Name="DisplayAtlasMap" Arg='arec' Label="for a record"/>
##  <Func Name="StringsAtlasMap" Arg='name[,p]'
##   Label="for the name of a simple group"/>
##  <Func Name="StringsAtlasMap" Arg='arec' Label="for a record"/>
##
##  <Returns>
##  <Ref Func="DisplayAtlasMap" Label="for a record"/> returns nothing,
##  <Ref Func="StringsAtlasMap" Label="for a record"/> returns either
##  <K>fail</K> or the list of strings that form the rows of the &ATLAS; map
##  of the group in question.
##  </Returns>
##
##  <Description>
##  Let <A>name</A> be an admissible name for the character table of a
##  simple &ATLAS; group,
##  and <A>p</A> be a prime integer or <M>0</M> (which is the default).
##  <Ref Func="DisplayAtlasMap" Label="for the name of a simple group"/>
##  shows the map for the group and its extensions, similar to the map
##  shown in the &ATLAS;.
##  <Ref Func="StringsAtlasMap" Label="for a record"/> returns the list of
##  strings that form the rows of this map.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasMap( "M12" );
##  --------- ---------   
##  |       | |       |   
##  |   G   | |  G.2  | 15
##  |       | |       |   
##  --------- ---------   
##  --------- ---------   
##  |       | |       |   
##  |  2.G  | | 2.G.2 | 11
##  |       | |       |   
##  --------- ---------   
##      15        9    
##  gap> DisplayAtlasMap( "M12", 2 );
##  --------- ---------  
##  |       | |       |  
##  |   G   | |  G.2  | 6
##  |       | |       |  
##  --------- ---------  
##      6         0    
##  gap> StringsAtlasMap( "M11" );
##  [ "---------   ", "|       |   ", "|   G   | 10", "|       |   ", 
##    "---------   ", "    10   " ]
##  ]]></Example>
##  <P/>
##  More generally, <A>name</A> can be an admissible name for a character
##  with known <Ref Attr="ExtensionInfoCharacterTable"/> value and such that
##  the strings describing multiplier and outer automorphism group in this
##  value occur in the lists <C>CTblLib.AtlasMapMultNames</C> and
##  <C>CTblLib.AtlasMapOutNames</C>, respectively.
##  If not all character tables of bicyclic extensions of the simple group
##  in question are available then
##  <Ref Func="StringsAtlasMap" Label="for a record"/> returns <K>fail</K>,
##  and <Ref Func="DisplayAtlasMap" Label="for the name of a simple group"/>
##  shows nothing.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasMap( "S10(2)" );
##  ---------    
##  |       |    
##  |   G   | 198
##  |       |    
##  ---------    
##     198   
##  gap> DisplayAtlasMap( "L12(27)" );
##  gap> StringsAtlasMap( "L12(27)" );
##  fail
##  ]]></Example>
##  <P/>
##  If the abovementioned requirements are not satisfied for the
##  character tables in question then one can provide the necessary
##  information via a record <A>arec</A>.
##  <P/>
##  The following example shows the <Q>&ATLAS; map</Q> for the alternating
##  group on four points, viewed as an extension of the trivial group
##  by a Klein four group and a group of order three.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasMap( rec(
##  > labels:= [ [ "G", "G.3" ],
##  >            [ "2.G", "" ],
##  >            [ "2'.G", "" ],
##  >            [ "2''.G", "" ] ],
##  > shapes:= [ [ "closed", "closed" ],
##  >            [ "closed", "empty" ],
##  >            [ "closed", "empty" ],
##  >            [ "closed", "empty" ] ],
##  > labelscol:= [ "1", "1" ],
##  > labelsrow:= [ "1", "1", "1", "1" ],
##  > dashedhorz:= [ false, false, true, true ],
##  > dashedvert:= [ false, false ],
##  > showdashedrows:= true ) );
##        --------- ---------  
##        |       | |       |  
##        |   G   | |  G.3  | 1
##        |       | |       |  
##        --------- ---------  
##        ---------            
##        |       |            
##        |  2.G  |           1
##        |       |            
##        ---------            
##   2'.G ---------          
##        ---------          
##  2''.G ---------          
##        ---------          
##            1         1    
##  ]]></Example>
##  <P/>
##  The next example shows the <Q>&ATLAS; map</Q> for the symmetric group
##  on three points, viewed as a bicyclic extension of the trivial group
##  by groups of the orders three and two, respectively.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasMap( rec(
##  > labels:= [ [ "G", "G.2" ],
##  >            [ "3.G", "3.G.2" ] ],
##  > shapes:= [ [ "closed", "closed" ],
##  >            [ "closed", "open" ] ],
##  > labelscol:= [ "1", "1" ],
##  > labelsrow:= [ "1", "1" ],
##  > dashedhorz:= [ false, false ],
##  > dashedvert:= [ false, false ],
##  > showdashedrows:= true ) );
##  --------- ---------  
##  |       | |       |  
##  |   G   | |  G.2  | 1
##  |       | |       |  
##  --------- ---------  
##  --------- --------   
##  |       | |          
##  |  3.G  | | 3.G.2   1
##  |       | |          
##  ---------            
##      1         1    
##  ]]></Example>
##  <P/>
##  (Depending on the terminal capabilities, the results may look nicer than
##  the <Q>ASCII only</Q> graphics shown above.)
##  <P/>
##  The following components of <A>arec</A> are supported.
##  <P/>
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    a string, the name of the (simple) group;
##  </Item>
##  <Mark><C>char</C></Mark>
##  <Item>
##    the characteristic, the default is <M>0</M>;
##  </Item>
##  <Mark><C>identifiers</C></Mark>
##  <Item>
##    an <M>m</M> by <M>n</M> matrix whose entries are <K>fail</K>
##    or the <Ref Attr="Identifier" BookName="ref"/> values
##    of the character tables of the extensions in question;
##  </Item>
##  <Mark><C>labels</C></Mark>
##  <Item>
##    an <M>m</M> by <M>n</M> matrix whose entries are <K>fail</K>
##    or the strings that shall be used as the labels of the boxes;
##  </Item>
##  <Mark><C>shapes</C></Mark>
##  <Item>
##    an <M>m</M> by <M>n</M> matrix whose entries are the strings
##    <C>"closed"</C>, <C>"open"</C>, <C>"broken"</C>, and <C>"empty"</C>,
##    describing the boxes that occur;
##  </Item>
##  <Mark><C>labelscol</C></Mark>
##  <Item>
##    a list of length <M>n</M> that contains the labels to be shown
##    below the last row of boxes,
##    intended to show the numbers of classes in this column of boxes;
##  </Item>
##  <Mark><C>labelsrow</C></Mark>
##  <Item>
##    a list of length <M>m</M> that contains the labels to be shown
##    on the right of the last column of boxes,
##    intended to show the numbers of characters in this row of boxes;
##  </Item>
##  <Mark><C>dashedhorz</C></Mark>
##  <Item>
##    a list of length <M>m</M> with entries <K>true</K> (the boxes in this
##    row shall have small height) or <K>false</K> (the boxes in this row
##    shall have normal height);
##  </Item>
##  <Mark><C>dashedvert</C></Mark>
##  <Item>
##    a list of length <M>n</M> with entries <K>true</K> (the boxes in this
##    column shall have small width) or <K>false</K> (the boxes in this
##    column shall have normal width);
##  </Item>
##  <Mark><C>showdashedrows</C></Mark>
##  <Item>
##    <K>true</K> or <K>false</K>,
##    the default is to show rows of <Q>dashed</Q> boxes in the case of
##    ordinary tables, and to omit them in the case of Brauer tables,
##    as happens in the printed Atlases;
##  </Item>
##  <Mark><C>onlyasciiboxes</C></Mark>
##  <Item>
##    <K>true</K> (show only ASCII characters when drawing the boxes)
##    or <K>false</K> (use line drawing characters),
##    the default is the value returned by <C>CTblLib.ShowOnlyASCII</C>;
##  </Item>
##  <Mark><C>onlyasciilabels</C></Mark>
##  <Item>
##    <K>true</K> (show only ASCII characters in the labels inside the boxes)
##    or <K>false</K> (default, use subscripts if applicable);
##    the default is the value returned by <C>CTblLib.ShowOnlyASCII</C>;
##  </Item>
##  <Mark><C>specialshapes</C></Mark>
##  <Item>
##    a list of length three that describes exceptional cases (intended for
##    the treatment of <Q>dashed names</Q> and <Q>broken boxes</Q>,
##    look at the values in <C>CTblLib.AtlasMapBoxesSpecial</C> where this
##    component is actually used).
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "StringsAtlasMap", function( arg )
    local arec, good, comp, centeredString, boxstrings,
          boxes, labellen, maxlen, emp, i, result, firstline, pos,
          dashednames, width, prefix, entry, footer;

    if Length( arg ) = 1 and IsRecord( arg[1] ) then
      arec:= ShallowCopy( arg[1] );
    else
      if Length( arg ) = 1 and IsString( arg[1] ) then
        arec:= rec( name:= arg[1] );
      elif Length( arg ) = 2 and IsString( arg[1] )
                             and ( arg[2] = 0 or IsPrimeInt( arg[2] ) ) then
        arec:= rec( name:= arg[1], char:= arg[2] );
      else
        Error( "usage: StringsAtlasMap( <name>[, <p>] ) ",
               "or StringsAtlasMap( <arec> )" );
      fi;

      if not CTblLib.StringsAtlasMap_CompleteData( arec ) then
        # Some information (tables, fusions, ...) is missing.
        return fail;
      fi;
    fi;

    if not IsBound( arec.onlyasciiboxes ) then
      arec.onlyasciiboxes:= CTblLib.ShowOnlyASCII();
    fi;

    if not IsBound( arec.onlyasciilabels ) then
      arec.onlyasciilabels:= CTblLib.ShowOnlyASCII();
    fi;

    # Omit rows corresponding to dashed names if wanted.
    if ( not IsBound( arec.showdashedrows ) )
       or arec.showdashedrows <> true then
      good:= Positions( arec.dashedhorz, false );
      for comp in [ "identifiers", "labels", "labelsrow", "shapes",
                    "dashedhorz" ] do
        if IsBound( arec.( comp ) ) then
          arec.( comp ):= arec.( comp ){ good };
        fi;
      od;
    fi;

    # If 'nextchar' is a string then either append it to the result,
    # or allow for extending the result by one character if 'nextchar'
    # equals " ".
    centeredString:= function( str, width, nextchar )
      local widthstr, contents, pos, n, n1, n2;

      widthstr:= WidthUTF8String( str );
      if width + 1 = widthstr and nextchar = " " then
        # One line is just enough.
        contents:= [ str ];
      elif width < widthstr then
        # Two lines are needed.
        pos:= Positions( str, '.' );
        if pos = [] then
          # There is no good place to split the name.
          contents:= Concatenation( str{ [ 1 .. width-3 ] },
                                    "...", nextchar );
        else
          if WidthUTF8String( str{ [ 1 .. pos[ Length( pos ) ] ] } ) <= width
             then
            pos:= pos[ Length( pos ) ];
          else
            pos:= pos[1];
          fi;
          contents:= Concatenation(
              centeredString( str{ [ 1 .. pos ] }, width, nextchar ),
              centeredString( str{ [ pos + 1 .. Length( str ) ] }, width,
                              nextchar ) );
        fi;
      else
        # One line is enough, and we have to format the string.
        n:= width - widthstr;
        n2:= Int( n / 2 );
        n1:= n - n2;
        contents:= [ Concatenation( RepeatedString( " ", n1 ),
                                    str,
                                    RepeatedString( " ", n2 ),
                                    nextchar ) ];
      fi;

      return contents;
    end;

    # Define the function that creates one box.
    # 'shape' is one of "closed", "open", "broken", "empty";
    # 'dashedhorz' and 'dashedvert' are 'true' or 'false'.

    # The format strings used in the code have length 12;
    # the first 4 entries are the corner characters (ulc, urc, llc, lrc),
    # the next 4 entries are the side characters (vls, vrs, hus, hls),
    # and the last 4 entries are the vls, vrs, hus, hls characters to be used
    # in the middle, depending on whether the box is broken or not.

    # Note that we cannot express broken horizontally dashed boxes,
    # but such cases do not appear in the ATLAS

    boxstrings:= function( name, onlyascii, shape, dashedhorz, dashedvert )
      local format, contents, result;

      if shape = "closed" or shape = "broken" then
        if onlyascii then
          format:= [ "-", "-", "-", "-", "|", "|", "-", "-" ];
        else
          format:= [ "┌", "┐", "└", "┘", "│", "│", "─", "─" ];
        fi;
      elif shape = "open" then
        if onlyascii then
          format:= [ "-", " ", " ", " ", "|", " ", "-", " " ];
        else
          format:= [ "┌", " ", " ", " ", "│", " ", "─", " " ];
        fi;
      elif shape = "empty" then
        format:= List( [ 1 .. 8 ], x -> " " );
      fi;

      if shape = "broken" then
        format{ [ 9 .. 12 ] }:= [ " ", " ", " ", " " ];
      else
        format{ [ 9 .. 12 ] }:= format{ [ 5 .. 8 ] };
      fi;

      if shape = "empty" then
        contents:= [ "        " ];
      else
        contents:= centeredString( name, 7, format[10] );
      fi;

      if dashedvert then
        result:= [ Concatenation( format{ [ 1, 11, 2 ] } ) ];
      else
        result:= [ Concatenation( format{ [ 1,7,7,11,11,11,7,7,2 ] } ) ];
      fi;
      if not dashedhorz then
        if dashedvert then
          result[2]:= Concatenation( format[5], " ", format[6] );
          result[3]:= Concatenation( format[9], " ", format[10] );
          result[4]:= result[2];
        else
          result[2]:= Concatenation( format[5], "       ", format[6] );
          result[3]:= Concatenation( format[9], contents[1] );
          if Length( contents ) = 1 then
            result[4]:= result[2];
          else
            result[4]:= contents[2];
          fi;
        fi;
      fi;
      if dashedvert then
        Add( result, Concatenation( format{ [ 3, 12, 4 ] } ) );
      else
        Add( result, Concatenation( format{ [ 3,8,8,12,12,12,8,8,4 ] } ) );
      fi;

      return result;
    end;

    # Compose the map.
    boxes:= List( [ 1 .. Length( arec.labels ) ],
              i -> List( [ 1 .. Length( arec.labels[1] ) ],
                     j -> boxstrings( arec.labels[i][j],
                                      arec.onlyasciiboxes,
                                      arec.shapes[i][j],
                                      arec.dashedhorz[i],
                                      arec.dashedvert[j] ) ) );

    # Add a column on the right that shows the row labels.
    labellen:= List( arec.labelsrow, Length );
    maxlen:= Maximum( labellen );
    emp:= RepeatedString( " ", maxlen );
    for i in [ 1 .. Length( arec.labelsrow ) ] do
      if arec.dashedhorz[i] <> true then
        Add( boxes[i],
             [ emp, emp, String( arec.labelsrow[i], maxlen ), emp, emp ] );
      fi;
    od;

    # Create the main part.
    result:= [];
    for i in [ 1 .. Length( boxes ) ] do
      Append( result, List( TransposedMat( boxes[i] ),
                            l -> JoinStringsWithSeparator( l, " " ) ) );
    od;

    # Prepend a line with names of dashed tables.
    firstline:= CTblLib.AtlasMapFirstLine( arec.labels[1],
                    List( boxes[1], x -> WidthUTF8String( x[1] ) ),
                    arec.dashedvert );

    # Prepend a column with names of dashed tables.
    pos:= 1;
    if firstline <> fail then
      pos:= 2;
      result:= Concatenation( [ firstline ], result );
    fi;
    dashednames:= [];
    if IsBound( arec.showdashedrows ) and arec.showdashedrows = true then
      for i in [ 1 .. Length( arec.labels ) ] do
        if arec.dashedhorz[i] then
          Add( dashednames, [ arec.labels[i][1], pos ] );
        fi;
        pos:= pos + Length( boxes[i][1] );
      od;
    fi;
    if dashednames <> [] then
      width:= Maximum( List( dashednames, l -> WidthUTF8String( l[1] ) ) );
      prefix:= RepeatedString( " ", width + 1 );
      for i in Difference( [ 1 .. Length( result ) ],
                           List( dashednames, x -> x[2] ) ) do
        result[i]:= Concatenation( prefix, result[i] );
      od;
      for entry in dashednames do
        result[ entry[2] ]:= Concatenation(
          RepeatedString( " ", width - WidthUTF8String( entry[1] ) ),
          entry[1], " ", result[ entry[2] ] );
      od;
    else
      prefix:= "";
    fi;

    # Add the footer line with column labels.
    footer:= [];
    for i in [ 1 .. Length( arec.labelscol ) ] do
      width:= WidthUTF8String( boxes[1][i][1] );
      if arec.labelscol[i] = "" then
        Add( footer, RepeatedString( " ", width ) );
      else
        Append( footer, centeredString( arec.labelscol[i], width, "" ) );
      fi;
    od;
    Add( result,
         Concatenation( prefix, JoinStringsWithSeparator( footer, " " ) ) );

    return result;
end );


#############################################################################
##
#F  DisplayAtlasMap( <name>[, <p>] )
##
BindGlobal( "DisplayAtlasMap", function( arg )
    local str, width, fun;

    str:= CallFuncList( StringsAtlasMap, arg );
    if str = fail or str = "" then
      return;
    fi;

    width:= SizeScreen()[1] - 2;
    if CTblLib.ShowOnlyASCII() then
      str:= List( str,
               l -> InitialSubstringUTF8String( l, width, "*" ) );
    else
      str:= List( str,
               l -> InitialSubstringUTF8String( l, width, "⋯" ) );
    fi;
    str:= JoinStringsWithSeparator( str, "\n" );
    Add( str, '\n' );
    fun:= EvalString( UserPreference( "AtlasRep", "DisplayFunction" ) );
    fun( str );
end );


#############################################################################
##
##  3. Show the table of contents of the ATLAS.
##


#############################################################################
##
#V  CTblLib.AtlasPages
##
##  This list is used by 'DisplayAtlasContents', 'StringAtlasContents',
##  and 'BrowseAtlasContents'.
##
##  Each entry has the form '[ <names>, <ordpages>, <modpages> ]', where
##  <names> is the list of names of the group in question,
##  <ordpages> (a list of length at most two) describes the page number(s)
##  in the ATLAS of Finite Groups, and
##  <modpages> describes the page numbers in the ATLAS of Brauer Characters,
##  in the format '[ <prime_1>, <page_1>, <prime_2>, <page_2>, ... ]'.
##
CTblLib.AtlasPages:= [
  [ [ "A5", "L2(4)", "L2(5)" ], [ 2 ], [ 2, 2, 3, 2, 5, 2 ] ],
  [ [ "L3(2)", "L2(7)" ], [ 3 ], [ 2, 3, 3, 3, 7, 3 ] ],
  [ [ "A6", "L2(9)", "S4(2)'" ], [ 4 ], [ 2, 4, 3, 4, 5, 5 ] ],
  [ [ "L2(8)", "R(3)'" ], [ 6 ], [ 2, 6, 3, 6, 7, 6 ] ],
  [ [ "L2(11)" ], [ 7 ], [ 2, 7, 3, 7, 5, 8, 11, 8 ] ],
  [ [ "L2(13)" ], [ 8 ], [ 2, 9, 3, 9, 7, 10, 13, 10 ] ],
  [ [ "L2(17)" ], [ 9 ], [ 2, 11, 3, 11, 17, 12 ] ],
  [ [ "A7" ], [ 10 ], [ 2, 13, 3, 13, 5, 14, 7, 15 ] ],
  [ [ "L2(19)" ], [ 11 ], [ 2, 16, 3, 16, 5, 17, 19, 18 ] ],
  [ [ "L2(16)" ], [ 12 ], [ 2, 19, 3, 20, 5, 20, 17, 21 ] ],
  [ [ "L3(3)" ], [ 13 ], [ 2, 22, 3, 22, 13, 22 ] ],
  [ [ "U3(3)", "G2(2)'" ], [ 14 ], [ 2, 23, 3, 23, 7, 24 ] ],
  [ [ "L2(23)" ], [ 15 ], [ 2, 25, 3, 26, 11, 27, 23, 28 ] ],
  [ [ "L2(25)" ], [ 16 ], [ 2, 29, 3, 30, 5, 31, 13, 32 ] ],
  [ [ "M11" ], [ 18 ], [ 2, 33, 3, 33, 5, 34, 11, 34 ] ],
  [ [ "L2(27)" ], [ 18 ], [ 2, 35, 3, 36, 7, 37, 13, 38 ] ],
  [ [ "L2(29)" ], [ 20 ], [ 2, 39, 3, 40, 5, 41, 7, 42, 29, 43 ] ],
  [ [ "L2(31)" ], [ 21 ], [ 2, 44, 3, 45, 5, 46, 31, 47 ] ],
  [ [ "A8", "L4(2)" ], [ 22 ], [ 2, 48, 3, 49, 5, 50, 7, 51 ] ],
  [ [ "L3(4)" ], [ 23 ], [ 2, 54, 3, 55, 5, 56, 7, 58 ] ],
  [ [ "U4(2)", "S4(3)" ], [ 26 ], [ 2, 60, 3, 61, 5, 62 ] ],
  [ [ "Sz(8)" ], [ 28 ], [ 2, 63, 5, 64, 7, 65, 13, 65 ] ],
  [ [ "L2(32)" ], [ 29 ], [ 2, 66, 3, 67, 11, 68, 31, 69 ] ],
  [ [ "L2(49)" ], [], [] ],
  [ [ "U3(4)" ], [ 30 ], [ 2, 70, 3, 71, 5, 72, 13, 73 ] ],
  [ [ "M12" ], [ 31 ], [ 2, 74, 3, 75, 5, 76, 11, 77 ] ],
  [ [ "U3(5)" ], [ 34 ], [ 2, 78, 3, 79, 5, 80, 7, 81 ] ],
  [ [ "J1" ], [ 36 ], [ 2, 82, 3, 82, 5, 83, 7, 83, 11, 84, 19, 84 ] ],
  [ [ "A9" ], [ 37 ], [ 2, 85, 3, 86, 5, 87, 7, 88 ] ],
  [ [ "L2(81)" ], [], [] ],
  [ [ "L3(5)" ], [ 38 ], [ 2, 89, 3, 90, 5, 91, 31, 92 ] ],
  [ [ "M22" ], [ 39 ], [ 2, 93, 3, 94, 5, 96, 7, 98, 11, 100 ] ],
  [ [ "J2", "HJ", "F5-" ], [ 42 ], [ 2, 102, 3, 103, 5, 104, 7, 105 ] ],
  [ [ "S4(4)" ], [ 44 ], [ 2, 106, 3, 107, 5, 108, 17, 109 ] ],
  [ [ "S6(2)" ], [ 46 ], [ 2, 110, 3, 111, 5, 112, 7, 113 ] ],
  [ [ "A10" ], [ 48 ], [ 2, 114, 3, 115, 5, 116, 7, 117 ] ],
  [ [ "L3(7)" ], [ 50 ], [ 2, 118, 3, 119, 7, 120, 19, 122 ] ],
  [ [ "U4(3)" ], [ 52 ], [ 2, 125, 3, 126, 5, 128, 7, 134 ] ],
  [ [ "G2(3)" ], [ 60 ], [ 2, 140, 3, 141, 7, 142, 13, 143 ] ],
  [ [ "S4(5)" ], [ 61 ], [ 2, 144, 3, 145, 5, 146, 13, 147 ] ],
  [ [ "U3(8)" ], [ 64, 66 ], [ 2, 148, 3, 151, 7, 152, 19, 155 ] ],
  [ [ "U3(7)" ], [ 66 ], [ 2, 158, 3, 159, 7, 160, 43, 162 ] ],
  [ [ "L4(3)" ], [ 68 ], [ 2, 165, 3, 166, 5, 168, 13, 170 ] ],
  [ [ "L5(2)" ], [ 70 ], [ 2, 172, 3, 173, 5, 174, 7, 175, 31, 176 ] ],
  [ [ "M23" ], [ 71 ], [ 2, 177, 3, 177, 5, 178, 7, 178, 11, 179, 23, 179 ] ],
  [ [ "U5(2)" ], [ 72 ], [ 2, 180, 3, 181, 5, 182, 11, 184 ] ],
  [ [ "L3(8)" ], [ 74 ], [ 2, 186, 3, 187, 7, 187, 73, 186 ] ],
  [ [ "2F4(2)'" ], [ 74 ], [ 2, 188, 3, 189, 5, 190, 13, 191 ] ],
  [ [ "A11" ], [ 75 ], [ 2, 192, 3, 193, 5, 194, 7, 195, 11, 196 ] ],
  [ [ "Sz(32)" ], [ 77 ], [ 2, 197, 5, 198, 31, 199, 41, 200 ] ],
  [ [ "L3(9)" ], [ 78 ], [ 2, 201, 3, 202, 5, 204, 7, 204, 13, 205 ] ],
  [ [ "U3(9)" ], [ 79 ], [ 2, 206, 3, 208, 5, 207, 73, 207 ] ],
  [ [ "HS" ], [ 80 ], [ 2, 210, 3, 211, 5, 212, 7, 213, 11, 214 ] ],
  [ [ "J3" ], [ 82 ], [ 2, 215, 3, 216, 5, 217, 17, 218, 19, 219 ] ],
  [ [ "U3(11)" ], [ 84 ], [ 2, 220, 3, 221, 5, 222, 11, 224, 37, 230 ] ],
  [ [ "O8+(2)" ], [ 85 ], [ 2, 232, 3, 233, 5, 234, 7, 238 ] ],
  [ [ "O8-(2)" ], [ 88, 89 ], [ 2, 243, 3, 244, 5, 245, 7, 246, 17, 248 ] ],
  [ [ "3D4(2)" ], [ 89 ], [ 2, 250, 3, 251, 7, 252, 13, 253 ] ],
  [ [ "L3(11)" ], [ 91 ], [ ] ],
  [ [ "A12" ], [ 91 ], [ 2, 254, 3, 255, 5, 256, 7, 258, 11, 262 ] ],
  [ [ "M24" ], [ 94 ], [ 2, 267, 3, 267, 5, 268, 7, 269, 11, 270, 23, 271 ] ],
  [ [ "G2(4)" ], [ 97 ], [ 2, 273, 3, 274, 5, 275, 7, 276, 13, 277 ] ],
  [ [ "McL" ], [ 100 ], [ 2, 278, 3, 279, 5, 280, 7, 281, 11, 282 ] ],
  [ [ "A13" ], [ 102, 104 ], [ ] ],
  [ [ "He" ], [ 104 ], [ ] ],
  [ [ "O7(3)" ], [ 106, 108 ], [ ] ],
  [ [ "S6(3)" ], [ 110, 112 ], [ ] ],
  [ [ "G2(5)" ], [ 114 ], [ ] ],
  [ [ "U6(2)" ], [ 115 ], [ ] ],
  [ [ "R(27)" ], [ 122, 123 ], [ ] ],
  [ [ "L6(2)" ], [], [] ],
  [ [ "S8(2)" ], [ 123 ], [ ] ],
  [ [ "Ru" ], [ 126 ], [ ] ],
  [ [ "Suz" ], [ 128, 131 ], [ ] ],
  [ [ "ON" ], [ 132 ], [ ] ],
  [ [ "Co3" ], [ 134 ], [ ] ],
  [ [ "O8+(3)" ], [ 136, 140 ], [ ] ],
  [ [ "O8-(3)" ], [ 141 ], [ ] ],
  [ [ "O10+(2)" ], [ 142, 146 ], [ ] ],
  [ [ "O10-(2)" ], [ 147 ], [ ] ],
  [ [ "Co2" ], [ 154 ], [ ] ],
  [ [ "Fi22" ], [ 156, 162 ], [ ] ],
  [ [ "HN", "F5+" ], [ 164, 166 ], [ ] ],
  [ [ "F4(2)" ], [ 167, 170 ], [ ] ],
  [ [ "S10(2)" ], [], [] ],
  [ [ "Ly" ], [ 174 ], [ ] ],
  [ [ "Th", "F3|3" ], [ 176, 177 ], [ ] ],
  [ [ "Fi23" ], [ 177 ], [ ] ],
  [ [ "Co1", "F2-" ], [ 180 ], [ ] ],
  [ [ "J4" ], [ 188, 190 ], [ ] ],
  [ [ "2E6(2)" ], [ 191 ], [ ] ],
  [ [ "E6(2)" ], [ 191 ], [ ] ],
  [ [ "Fi24'", "F3+" ], [ 200, 206 ], [ ] ],
  [ [ "B", "F2+" ], [ 208, 216 ], [ ] ],
  [ [ "E7(2)" ], [ 219 ], [ ] ],
  [ [ "M", "F1" ], [ 220, 228 ], [ ] ],
  [ [ "E8(2)" ], [ 235 ], [ ] ],
];


#############################################################################
##
#F  DisplayAtlasContents()
#F  StringAtlasContents()
##
##  <#GAPDoc Label="DisplayAtlasContents">
##  <ManSection>
##  <Func Name="DisplayAtlasContents" Arg=''/>
##  <Func Name="StringAtlasContents" Arg=''/>
##
##  <Description>
##  <Ref Func="DisplayAtlasContents"/> calls the function that is given by
##  the user preference <Ref Subsect="subsect:displayfunction"/>,
##  in order to show the list of names of simple groups and the corresponding
##  page numbers in the &ATLAS; of Finite Groups <Cite Key="CCN85"/>,
##  as given on page v of this book,
##  plus a few groups for which <Cite Key="JLPW95" Where="Appendix 2"/>
##  states that their character tables in &ATLAS; format have been obtained;
##  if applicable then also the corresponding page numbers in the
##  &ATLAS; of Brauer Characters <Cite Key="JLPW95"/> are shown.
##  <P/>
##  An interactive variant of
##  <Ref Func="DisplayAtlasContents"/> is <Ref Func="BrowseAtlasContents"/>.
##  <P/>
##  The string that is shown by
##  <Ref Func="DisplayAtlasContents"/> can be computed using
##  <Ref Func="StringAtlasContents"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> str:= StringAtlasContents();;
##  gap> pos:= PositionNthOccurrence( str, '\n', 10 );;
##  gap> Print( str{ [ 1 .. pos ] } );
##  A5 = L2(4) = L2(5)    2       2:2, 3:2, 5:2
##  L3(2) = L2(7)         3       2:3, 3:3, 7:3
##  A6 = L2(9) = S4(2)'   4       2:4, 3:4, 5:5
##  L2(8) = R(3)'         6       2:6, 3:6, 7:6
##  L2(11)                7       2:7, 3:7, 5:8, 11:8
##  L2(13)                8       2:9, 3:9, 7:10, 13:10
##  L2(17)                9       2:11, 3:11, 17:12
##  A7                   10       2:13, 3:13, 5:14, 7:15
##  L2(19)               11       2:16, 3:16, 5:17, 19:18
##  L2(16)               12       2:19, 3:20, 5:20, 17:21
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "StringAtlasContents", function()
    local isom, lines, widths, entry, name, ordpages, ordpages2, modpages, i,
          str;

    if CTblLib.ShowOnlyASCII() then
      isom:= " = ";
    else
      isom:= " ≅ ";
    fi;

    lines:= [];
    widths:= [ 0, 0, 0 ];
    for entry in CTblLib.AtlasPages do
      name:= JoinStringsWithSeparator( entry[1], isom );
      widths[1]:= Maximum( widths[1], WidthUTF8String( name ) );
      ordpages:= "";
      if 0 < Length( entry[2] ) then
        ordpages:= String( entry[2][1] );
      fi;
      widths[2]:= Maximum( widths[2], Length( ordpages ) );
      if Length( entry[2] ) > 1 then
        ordpages2:= Concatenation( "(", String( entry[2][2] ), ")" );
        widths[3]:= Maximum( widths[3], Length( ordpages2 ) );
      else
        ordpages2:= "";
      fi;
      modpages:= [];
      for i in [ 2, 4 .. Length( entry[3] ) ] do
        Add( modpages, Concatenation( String( entry[3][ i-1 ] ), ":",
                                      String( entry[3][i] ) ) );
      od;
      Add( lines, [ name, ordpages, ordpages2,
                    JoinStringsWithSeparator( modpages, ", " ) ] );
    od;

    str:= "";
    widths[1]:= widths[1] + 1;
    for i in [ 1 .. Length( lines ) ] do
      name:= lines[i][1];
      Append( str, name );
      Append( str,
              RepeatedString( " ", widths[1] - WidthUTF8String( name ) ) );
      Append( str, String( lines[i][2],  widths[2] ) );
      Append( str, " " );
      Append( str, String( lines[i][3], -widths[3] ) );
      Append( str, " " );
      Append( str, lines[i][4] );
      Append( str, "\n" );
    od;

    return str;
end );


BindGlobal( "DisplayAtlasContents", function()
    local str, width, fun;

    str:= StringAtlasContents();
    if str <> "" then
      width:= SizeScreen()[1] - 2;
      if CTblLib.ShowOnlyASCII() then
        str:= List( SplitString( str, "\n" ),
                l -> InitialSubstringUTF8String( l, width, "*" ) );
      else
        str:= List( SplitString( str, "\n" ),
                l -> InitialSubstringUTF8String( l, width, "⋯" ) );
      fi;
      fun:= EvalString( UserPreference( "AtlasRep", "DisplayFunction" ) );
      fun( JoinStringsWithSeparator( str, "\n" ) );
    fi;
end );


#############################################################################
##
#E

