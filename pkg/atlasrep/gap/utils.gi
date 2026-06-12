#############################################################################
##
#W  utils.gi             GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains the implementations of utility functions for the
##  ATLAS of Group Representations.
##


#############################################################################
##
#V  AtlasClassNamesOffsetInfo
##
##  The component `ordinary' is used for cases where the outer automorphism
##  group is not of prime order, and so the ordering of cosets is important
##  for constructing the names.
##
##  The component `special' is used for cases where one table of a subgroup
##  is used more than once.
##  Each entry is a list of length three, with first entry the `Identifier'
##  of the table in question, second entry the list of `Identifier' values of
##  the tables that cover the classes of the table in question, and third
##  entry the list of corresponding class fusions (those stored on the tables
##  can be omitted here).
##
InstallValue( AtlasClassNamesOffsetInfo, rec(
    ordinary:= [
    [ "A6", "A6.2_1", "A6.2_2", "A6.2_3" ],
    [ "L2(16)", "L2(16).2", "L2(16).4" ],
    [ "L2(25)", "L2(25).2_1", "L2(25).2_2", "L2(25).2_3" ],
    [ "L2(27)", "L2(27).2", "L2(27).3", "L2(27).6" ],
    [ "L2(49)", "L2(49).2_1", "L2(49).2_2", "L2(49).2_3" ],
    [ "L2(81)", "L2(81).2_1", "L2(81).4_1", "L2(81).4_2", "L2(81).2_2",
      "L2(81).2_3" ],
    [ "L3(4)", "L3(4).2_1", "L3(4).3", "L3(4).6", "L3(4).2_2", "L3(4).2_3" ],
    [ "L3(7)", "L3(7).3", "L3(7).2" ],
    [ "L3(8)", "L3(8).2", "L3(8).3", "L3(8).6" ],
    [ "L3(9)", "L3(9).2_1", "L3(9).2_2", "L3(9).2_3" ],
    [ "L4(3)", "L4(3).2_1", "L4(3).2_2", "L4(3).2_3" ],
    [ "L4(4)", "L4(4).2_1", "L4(4).2_2", "L4(4).2_3" ],
    [ "O8-(3)", "O8-(3).2_1", "O8-(3).2_2", "O8-(3).2_3" ],
    [ "O8+(2)", "O8+(2).3", "O8+(2).2" ],
    [ "O8+(3)", "O8+(3).2_1", "O8+(3).3", "O8+(3).2_2", "O8+(3).4" ],
    [ "S4(4)", "S4(4).2", "S4(4).4" ],
    [ "S4(9)", "S4(9).2_1", "S4(9).2_2", "S4(9).2_3" ],
    [ "2E6(2)", "2E6(2).2", "2E6(2).3" ],
    [ "U3(4)", "U3(4).2", "U3(4).4" ],
    [ "U3(5)", "U3(5).3", "U3(5).2" ],
    [ "U3(8)", "U3(8).3_1", "U3(8).3_2", "U3(8).3_3", "U3(8).2", "U3(8).6" ],
    [ "U3(9)", "U3(9).2", "U3(9).4" ],
    [ "U3(11)", "U3(11).3", "U3(11).2" ],
    [ "U4(3)", "U4(3).2_1", "U4(3).4", "U4(3).2_2", "U4(3).2_3" ],
    [ "U4(5)", "U4(5).2_1", "U4(5).2_2", "U4(5).2_3" ],
    [ "U6(2)", "U6(2).3", "U6(2).2" ],
    ],
    special:= [
    [ "O8+(3).(2^2)_{111}",
      [ "O8+(3)", "O8+(3).2_1", "O8+(3).2_1", "O8+(3).2_1" ],
      [,,[1,3,4,2,5,6,8,9,7,8,10,10,11,12,13,15,16,14,17,19,20,18,22,23,21,
      24,26,27,25,26,29,30,28,29,32,33,31,34,34,35,35,36,37,38,39,41,42,40,
      41,43,43,44,44,46,47,45,49,50,48,52,53,51,52,54,55,55,57,58,56,57,59,
      60,62,63,61,65,66,64,65,68,69,67,68,71,72,70,122,123,124,125,126,127,
      128,129,129,130,130,131,131,132,133,134,136,135,137,139,138,140,142,
      141,143,144,145,145,146,147,148,149,149,150,151,152,152,153,155,154,
      157,156,158,158,159,160,161,162,164,163,165,165,166,166,169,170,167,
      168],[1,4,2,3,5,6,9,7,8,9,10,10,11,12,13,16,14,15,17,20,18,19,23,21,22,
      24,27,25,26,27,30,28,29,30,33,31,32,34,34,35,35,36,37,38,39,42,40,41,
      42,43,43,44,44,47,45,46,50,48,49,53,51,52,53,54,55,55,58,56,57,58,59,
      60,63,61,62,66,64,65,66,69,67,68,69,72,70,71,171,172,173,174,175,176,
      177,178,178,179,179,180,180,181,182,183,184,185,186,187,188,189,190,
      191,192,193,194,194,195,196,197,198,198,199,200,201,201,202,203,204,
      205,206,207,207,208,209,210,211,212,213,214,214,215,215,216,217,218,
      219]] ],
    [ "O8+(3).(2^2)_{122}",
      [ "O8+(3)", "O8+(3).2_1", "O8+(3).2_2", "O8+(3).2_2" ],
      [,,,[1,2,3,4,5,8,7,6,7,10,10,9,11,12,13,14,15,16,17,18,19,20,21,24,23,
      22,23,27,26,25,26,28,29,31,31,30,33,33,32,34,35,36,37,40,39,38,39,42,
      42,41,44,44,43,45,46,47,48,51,50,49,50,52,54,54,53,57,56,55,56,58,59,
      60,61,64,63,62,63,67,66,65,66,68,69,167,168,169,170,171,172,173,174,
      175,176,177,177,178,179,180,181,181,182,183,184,185,186,187,188,189,
      190,191,192,193,194,195,196,197,198,199,199,200,201,202,203,204,204,
      205,205,206,207,208,209,210,211,212,213]] ],
    [ "O8+(3).D8",
      [ "O8+(3)", "O8+(3).2_1", "O8+(3).2_1", "O8+(3).2_2", "O8+(3).4" ],
      [,,[1,3,2,3,4,5,7,6,7,7,8,8,9,10,11,13,12,13,14,16,15,16,18,17,18,19,
      21,20,21,21,23,22,23,23,25,24,25,26,26,27,27,28,29,30,31,33,32,33,33,
      34,34,35,35,37,36,37,39,38,39,41,40,41,41,42,43,43,45,44,45,45,46,47,
      49,48,49,51,50,51,51,53,52,53,53,55,54,55,97,98,99,100,101,102,103,104,
      104,105,105,106,106,107,108,109,110,111,112,113,114,115,116,117,118,
      119,120,120,121,122,123,124,124,125,126,127,127,128,129,130,131,132,
      133,133,134,135,136,137,138,139,140,140,141,141,142,143,144,145]] ],
    [ "U4(3).(2^2)_{122}",
      [ "U4(3)", "U4(3).2_1", "U4(3).2_2", "U4(3).2_2" ],
      [,,,[1,2,3,5,4,6,7,8,9,10,12,11,13,14,16,16,15,17,46,47,48,49,50,50,51,
      52,53,54,55,56,57,58,59,59]] ],
    [ "U4(3).(2^2)_{133}",
      [ "U4(3)", "U4(3).2_1", "U4(3).2_3", "U4(3).2_3" ],
      [,,,[1,2,3,4,5,6,7,8,9,10,11,12,13,13,14,36,37,38,39,40,41,42,43,44,44]
      ] ],
    ] ) );


#############################################################################
##
#F  AtlasClassNames( <tbl> )
##
InstallGlobalFunction( AtlasClassNames, function( tbl )
    local ordtbl, names, n, fact, factnames, map, i, j, name, pos,
          solvres, simplename, F, Finv, info, tbls, classes, tblname,
          subtbl, derclasses, subF, size,
          gens,
          fus,
          filt,
          special,
          subtblfustbl,
          Fproxies,
          inv,
          proxies,
          orb,
          imgs,
          img,
          count,
          k,
          alpha,    # alphabet
          lalpha,   # length of the alphabet
          orders,   # list of representative orders
          innernames,
          number,   # at position <i> the current number of
                    # classes of order <i>
          suborders,
          depname,
          dashes,
          subnames,
          relevant,
          intermed,       # loop over intermediate tables
          tblfusF;

    if not IsCharacterTable( tbl ) then

      Error( "<tbl> must be a character table" );

    elif IsBrauerTable( tbl ) then

      # Derive the class names from the names of the ordinary table.
      ordtbl:= OrdinaryCharacterTable( tbl );
      names:= AtlasClassNames( ordtbl );
      if names = fail then
        return fail;
      fi;
      return names{ GetFusionMap( tbl, ordtbl ) };

    elif IsSimpleCharacterTable( tbl ) then

      # For tables of simple groups, `ClassNames' is good enough.
      return ClassNames( tbl, "Atlas" );

    fi;

    # For not almost simple tables,
    # derive the class names from the names for the almost simple factor.
    n:= ClassPositionsOfFittingSubgroup( tbl );

    if Length( n ) <> 1 then
      fus:= First( ComputedClassFusions( tbl ),
                   r -> ClassPositionsOfKernel( r.map ) = n );
      if fus = fail then
        return fail;
      fi;
      fact:= CharacterTable( fus.name );
      factnames:= AtlasClassNames( fact );
      if factnames = fail then
        Info( InfoAtlasRep, 2,
              Identifier( tbl ),
              " is not a downward extension of an almost simple table" );
        return fail;
      fi;

      map:= InverseMap( GetFusionMap( tbl, fact ) );
      names:= [];
      for i in [ 1 .. Length( map ) ] do
        if IsInt( map[i] ) then
          names[ map[i] ]:= Concatenation( factnames[i], "_0" );
        # Add( names, Concatenation( factnames[i], "_0" ) );
        else
          for j in [ 0 .. Length( map[i] )-1 ] do
            names[ map[i][ j+1 ] ]:= Concatenation( factnames[i], "_",
                                         String( j ) );
          od;
        # Append( names, List( [ 0 .. Length( map[i] )-1 ],
        #     j -> Concatenation( factnames[i], "_", String( j ) ) ) );
        fi;
      od;
      return names;
    elif not IsAlmostSimpleCharacterTable( tbl ) then
      Info( InfoAtlasRep, 2,
            Identifier( tbl ), " is not an almost simple table" );
      return fail;
    fi;

    # Now `tbl' is almost simple and not simple.
    # Find out which nonabelian simple group is involved,
    # and which upward extension is given.
    # (We use the `Identifier' value of `tbl';
    # note that this function makes sense only for library tables.)
    name:= Identifier( tbl );
    pos:= Position( name, '.' );
    if pos = fail then
      Info( InfoAtlasRep, 2,
            "strange name `", name, "'" );
      return fail;
    fi;

    # Get the table of the solvable residuum.
    solvres:= CharacterTable( name{ [ 1 .. pos-1 ] } );
    if solvres = fail then
      Info( InfoAtlasRep, 2,
            "the identifier `", name,
            "' does not fit to an almost simple group" );
      return fail;
    fi;

    simplename:= Identifier( solvres );
    F:= tbl / ClassPositionsOfSolvableResiduum( tbl );
    Finv:= InverseMap( GetFusionMap( tbl, F ) );

    # We use the global variable `AtlasClassNamesOffsetInfo'.
    info:= First( AtlasClassNamesOffsetInfo.ordinary,
                  x -> x[1] = simplename );

    # Compute the tables of all cyclic upward extensions of `solvres'
    # that are contained in `tbl',
    # and store the positions of the corresponding relevant classes in `tbl'.
    # Tables that are *not* involved in `tbl' but whose class names force
    # offsets for the class names of `tbl' are also stored,
    tbls:= [ solvres ];
    classes:= [ [ Finv[1], true ] ];

    if IsPrimeInt( Size( tbl ) / Size( solvres ) ) then

      # Here `AtlasClassNamesOffsetInfo' may be missing.
      if info = fail then
        Info( InfoCharacterTable, 2,
              "AtlasClassNames: ",
              "no info by `AtlasClassNamesOffsetInfo' available" );
      else

        tblname:= ShallowCopy( Identifier( tbl ) );
        while tblname[ Length( tblname ) ] = '\'' do
          Unbind( tblname[ Length( tblname ) ] );
        od;
        pos:= Position( info, tblname );
        for i in [ 2 .. pos-1 ] do

          subtbl:= CharacterTable( info[i] );
          derclasses:= ClassPositionsOfDerivedSubgroup( subtbl );
          subF:= subtbl / derclasses;

          # The classes are *not* involved in `tbl',
          # store the positions of the classes in generator cosets!
          size:= Size( subF );
          gens:= Filtered( [ 1 .. size ],
                     i -> OrdersClassRepresentatives( subF )[i] = size );
          fus:= GetFusionMap( subtbl, subF );
          filt:= Filtered( [ 1 .. NrConjugacyClasses( subtbl ) ],
                           i -> fus[i] in gens );

          Add( tbls, subtbl );
          Add( classes, [ filt, false ] );

        od;

      fi;
      special:= fail;

      # Add `tbl' itself.
      Add( tbls, tbl );
      Add( classes,
           [ Difference( [ 1 .. NrConjugacyClasses( tbl ) ], Finv[1] ),
             true ] );

    elif Size( solvres ) <> Size( tbl ) then

      # Here we definitely need `AtlasClassNamesOffsetInfo'.
      if info = fail then
        Error( "not enough information about <tbl>" );
      fi;

      # More information is needed if a table occurs more than once.
      special:= First( AtlasClassNamesOffsetInfo.special,
                       list -> list[1] = Identifier( tbl ) );
      if special <> fail then
        special:= ShallowCopy( special );
        special[4]:= [];
        info:= special[2];
      fi;

      # Test which intermediate tables are needed.
      # These are exactly the ones having a fusion into `tbl'.
      # The others are taken with `false' in `classes'.
      for i in [ 2 .. Length( info ) ] do

        subtbl:= CharacterTable( info[i] );
        derclasses:= ClassPositionsOfDerivedSubgroup( subtbl );
        subF:= subtbl / derclasses;

        if special = fail or not IsBound( special[3][i] ) then
          subtblfustbl:= GetFusionMap( subtbl, tbl );
        else
          subtblfustbl:= special[3][i];
        fi;

        if subtblfustbl = fail then

          # The classes are *not* involved in `tbl',
          # or `subtbl' is equal to `tbl'.
          # Store the positions of the classes in generator cosets!
          size:= Size( subF );
          gens:= Filtered( [ 1 .. size ],
                     i -> OrdersClassRepresentatives( subF )[i] = size );
          fus:= GetFusionMap( subtbl, subF );
          filt:= Filtered( [ 1 .. NrConjugacyClasses( subtbl ) ],
                           i -> fus[i] in gens );

          if Identifier( tbl ) = info[i] then
            Add( tbls, tbl );
            Add( classes, [ filt, true ] );
          else
            Add( tbls, subtbl );
            Add( classes, [ filt, false ] );
          fi;

        elif Set( subtblfustbl{ derclasses } ) <> Finv[1] then
          Error( "strange fusion ", Identifier( subtbl ),
                 " -> ", Identifier( tbl ) );
        else

          # The table is needed.
          # Store the positions in `tbl' of the classes in generator cosets!
          size:= Size( subF );
          gens:= Filtered( [ 1 .. size ],
                     i -> OrdersClassRepresentatives( subF )[i] = size );
          fus:= GetFusionMap( subtbl, subF );
          filt:= Filtered( [ 1 .. NrConjugacyClasses( subtbl ) ],
                           i -> fus[i] in gens );

          Add( tbls, subtbl );
          Add( classes, [ Set( subtblfustbl{ filt } ), true ] );

        fi;

      od;

      # Check whether all necessary tables are available.
      if Union( List( Filtered( classes, x -> x[2] = true ), y -> y[1] ) )
             <> [ 1 .. NrConjugacyClasses( tbl ) ] then
        Info( InfoAtlasRep, 2,
              "AtlasClassNames: ",
              "not all necessary tables are available for ",
              Identifier( tbl ) );
        return fail;
      fi;

    fi;

    # Define a function that creates class names in ATLAS style.
    alpha:= List( "ABCDEFGHIJKLMNOPQRSTUVWXYZ", x -> [ x ] );
    for i in alpha do
      ConvertToStringRep( i );
    od;
    lalpha:= Length( alpha );
    name:= function( n )
      local m;
      if n <= lalpha then
        return alpha[n];
      else
        m:= (n-1) mod lalpha + 1;
        n:= ( n - m ) / lalpha;
        return Concatenation( alpha[m], String( n ) );
      fi;
    end;

    # Initialize the list of class names
    # and the counter for the names already constructed.
    names:= [];
    number:= [];

    # Loop over the tables.
    for pos in [ 1 .. Length( tbls ) ] do

      subtbl:= tbls[ pos ];
      relevant:= classes[ pos ][1];

      if special <> fail and IsBound( special[3][ pos ] ) then
        fus:= special[3][ pos ];
        subnames:= special[4][ Position( special[2], special[2][ pos ] ) ];
        for i in [ 1 .. Length( subnames ) ] do
          if not IsBound( subnames[i] ) then
            subnames[i]:= "?";
          fi;
        od;
        subnames:= Concatenation( [ 1 .. Maximum( Filtered(
            [ 1 .. Length( fus ) ], x -> fus[x] in relevant ) )
            - Length( subnames ) ], subnames );
        dashes:= Number( [ 1 .. pos-1 ],
                         x -> special[2][x] = special[2][ pos ] );
        dashes:= ListWithIdenticalEntries( dashes, '\'' );
        subnames:= List( subnames, ShallowCopy );
        for i in [ 1 .. Length( subnames ) ] do
          Append( subnames[i], dashes );
        od;

      else

        if classes[ pos ][2] then
          if Size( subtbl ) = Size( tbl ) then
            fus:= [ 1 .. NrConjugacyClasses( tbl ) ];
          elif special <> fail and IsBound( special[3][ pos ] ) then
            fus:= special[3][ pos ];
          else
            fus:= GetFusionMap( subtbl, tbl );
            if fus = fail then
              for intermed in tbls do
                if     GetFusionMap( subtbl, intermed ) <> fail
                   and GetFusionMap( intermed, tbl ) <> fail then
                  fus:= CompositionMaps( GetFusionMap( intermed, tbl ),
                                         GetFusionMap( subtbl, intermed ) );
                  break;
                fi;
              od;
            fi;
          fi;
        else
          fus:= fail;
        fi;

        # Choose proxy classes in the factor group,
        # that is, one generator class for each cyclic subgroup.
        F:= subtbl / ClassPositionsOfDerivedSubgroup( subtbl );
        Fproxies:= [];
        for i in [ 1 .. NrConjugacyClasses( F ) ] do
          if not IsBound( Fproxies[i] ) then
            for j in ClassOrbit( F, i ) do
              Fproxies[j]:= i;
            od;
          fi;
        od;

        # Transfer the proxy classes to `subtbl'.
        tblfusF:= GetFusionMap( subtbl, F );
        proxies:= [];
        for i in [ 1 .. Length( tblfusF ) ] do
          if not IsBound( proxies[i] ) then
            orb:= ClassOrbit( subtbl, i );
            imgs:= tblfusF{ orb };
            for j in [ 1 .. Length( orb ) ] do

              # Classes mapping to a proxy class in `F' are proxies also
              # in `subtbl'.
              # For the other classes,
              # we make use of the convention that in GAP tables
              # (of upward extensions of simple groups),
              # the follower classes come immediately after their proxies.
              k:= j;
              while Fproxies[ imgs[k] ] <> imgs[k] do
                k:= k-1;
              od;
              proxies[ orb[j] ]:= orb[k];

            od;
          fi;
        od;

        # Compute the non-order parts of the names w.r.t. the subgroup.
        subnames:= [];
        suborders:= OrdersClassRepresentatives( subtbl );
        for i in [ 1 .. NrConjugacyClasses( subtbl ) ] do
          if ( fus <> fail and fus[i] in relevant ) then
            if proxies[i] = i then
              if not IsBound( number[ suborders[i] ] ) then
                number[ suborders[i] ]:= 1;
              fi;
              subnames[i]:= name( number[ suborders[i] ] );
              number[ suborders[i] ]:= number[ suborders[i] ] + 1;
            else
              depname:= ShallowCopy( subnames[ proxies[i] ] );
              while ForAny( [ 1 .. i-1 ], x -> IsBound( subnames[x] )
                         and subnames[x] = depname
                         and suborders[x] = suborders[i] ) do
                Add( depname, '\'' );
              od;
              subnames[i]:= depname;
            fi;
          fi;
        od;

        if special <> fail then
          special[4][ pos ]:= subnames;
        fi;

      fi;

      # For tables that are not needed,
      # just compute the class names for all outer generator classes
      if fus = fail then
        for i in classes[ pos ][1] do
          if Fproxies[ tblfusF[i] ] = tblfusF[i] then
            if not IsBound( number[ suborders[i] ] ) then
              number[ suborders[i] ]:= 1;
            fi;
            name( number[ suborders[i] ] );
            number[ suborders[i] ]:= number[ suborders[i] ] + 1;
          fi;
        od;
      fi;

      # Compute the dashes that are forced by the table name.
      dashes:= "";
      if pos <> 1 then
        i:= Length( Identifier( subtbl ) );
        while Identifier( subtbl )[i] = '\'' do
          Add( dashes, '\'' );
          i:= i-1;
        od;
      fi;

      # If the table is needed then form orbit concatenations of these names.
      if fus <> fail then
        orders:= OrdersClassRepresentatives( tbl );
        inv:= InverseMap( fus );
        for i in relevant do
          if IsInt( inv[i] ) then
            orb:= [ subnames[ inv[i] ] ];
          else
            orb:= List( inv[i], x -> subnames[x] );
            if     ForAny( orb, x -> '\'' in x )
               and not ForAll( orb, x -> '\'' in x ) then
              orb:= Filtered( orb, x -> not '\'' in x );
            fi;
          fi;
          orb:= List( orb, x -> Concatenation( x, dashes ) );
          names[i]:= Concatenation( String( orders[i] ),
                         Concatenation( orb ) );
        od;
      fi;

    od;

    # Return the list of classnames.
    return names;
end );


#############################################################################
##
#F  AtlasCharacterNames( <tbl> )
##
InstallGlobalFunction( AtlasCharacterNames, function( tbl )
    local alpha, i, lalpha, name, ordtbl, names, degrees, chi, pos;

    if not IsCharacterTable( tbl ) then
      Error( "<tbl> must be a character table" );
    fi;

    # Define a function that creates character names in ATLAS style.
    alpha:= List( "abcdefghijlkmnopqrstuvwxyz", x -> [ x ] );
    for i in alpha do
      ConvertToStringRep( i );
    od;
    lalpha:= Length( alpha );
    name:= function( n )
      local m;
      if n <= lalpha then
        return alpha[n];
      else
        m:= (n-1) mod lalpha + 1;
        n:= ( n - m ) / lalpha;
        return Concatenation( alpha[m], String( n ) );
      fi;
    end;

    if UnderlyingCharacteristic( tbl ) = 0 then
      ordtbl:= tbl;
    else
      ordtbl:= OrdinaryCharacterTable( tbl );
    fi;

    if IsSimpleCharacterTable( ordtbl ) then

      # For tables of simple groups, use the degrees.
      names:= [];
      degrees:= [ [], [] ];
      for chi in Irr( tbl ) do
        pos:= Position( degrees[1], chi[1] );
        if pos = fail then
          Add( degrees[1], chi[1] );
          Add( degrees[2], 1 );
          Add( names, Concatenation( String( chi[1] ), name( 1 ) ) );
        else
          degrees[2][ pos ]:= degrees[2][ pos ] + 1;
          Add( names,
               Concatenation( String( chi[1] ), name( degrees[2][ pos ] ) ) );
        fi;
      od;
      return names;

    else

      Info( InfoAtlasRep, 2,
            "AtlasCharacterNames: ",
            "not available for ", Identifier( tbl ) );
      return fail;

    fi;
end );


#############################################################################
##
#F  StringOfAtlasProgramCycToCcls( <prgstring>, <tbl>, <mode> )
##
InstallGlobalFunction( StringOfAtlasProgramCycToCcls,
    function( prgstring, tbl, mode )
    local classnames, labels, numbers, prgline, line, string, pos, nrlabels,
          inputline, inline, nccl, result, i, dashedclassnames, orders,
          primes, known, unchanged, p, map, img, pp, orb, k, j, e, namline,
          resline;

    # Check the input.
    if not ( IsString( prgstring ) and IsOrdinaryTable( tbl ) ) then
      Error("usage: StringOfAtlasProgramCycToCcls(<prgstring>,<tbl>,<mode>)");
    fi;

    # Fetch the `echo' lines starting with `Classes'.
    # They serve as inputs for the result program.

    # Compute the classnames.
    classnames:= AtlasClassNames( tbl );

    # Determine the labels that occur.
    # `labels' is a list of labels that occur in `echo' lines of the
    # given script (class names, without dashes).
    # `numbers' is a list of labels that occur in `oup' lines of the
    # given script (numbers or classnames, with dashes).
    labels:= [];
    numbers:= [];
    for prgline in SplitString( prgstring, "\n" ) do

      # Ignore lines that are neither `echo' nor `oup' statements.
      if   5 < Length( prgline ) and prgline{ [ 1 .. 4 ] } = "echo" then
        line:= SplitString( prgline, "", "\" " );
        if   "classes" in line then
          Append( labels,
              line{ [ Position( line, "classes" )+1 .. Length( line ) ] } );
        elif "Classes" in line then
          Append( labels,
              line{ [ Position( line, "Classes" )+1 .. Length( line ) ] } );
        elif not "Here" in line then
          Append( labels,
              line{ [ Position( line, "echo" )+1 .. Length( line ) ] } );
        fi;
      elif  4 < Length( prgline ) and prgline{ [ 1 .. 3 ] } = "oup" then
        line:= SplitString( prgline, "", "\" \n" );
        Append( numbers, line{ [ 3 .. Length( line ) ] } );
      fi;

    od;

    # Construct the list of class representatives from the labels.
    if   IsEmpty( labels ) then
      Info( InfoCMeatAxe, 1,
            "no class names specified as outputs" );
      return fail;
    elif not ForAll( labels, str -> str in classnames ) then
      Info( InfoCMeatAxe, 1,
            "labels `",
            Filtered( labels, str -> not str in classnames ),
            "' aren't class names" );
      return fail;
    fi;
    string:= "";

    # Write down the line(s) specifying the input list.
    pos:= 1;
    nrlabels:= Length( labels );
    while pos <= nrlabels do
      inputline:= "";
      inline:= 0;
      while pos <= nrlabels and
            Length( inputline ) + Length( numbers[ pos ] ) <= 71 do
        Add( inputline, ' ' );
        Append( inputline, numbers[ pos ] );
        pos:= pos + 1;
        inline:= inline + 1;
      od;
      Append( string, "inp " );
      Append( string, String( inline ) );
      Append( string, inputline );
      Add( string, '\n' );
    od;

    # The program shall return conjugacy class representatives.
    nccl:= Length( classnames );
    result:= [];
    for i in [ 1 .. nccl ] do
      if classnames[i] in labels then
        result[i]:= true;
      fi;
    od;

    # The inputs are numbers or class names,
    # and depending on `mode', the outputs are numbers or class names.
    if   mode = "names" then
      # Dashes in the labels must be escaped with backslashes.
      # (Note that names in `echo' lines must *not* be escaped.)
      numbers:= Concatenation( numbers,
                    List( Filtered( classnames, x -> not x in labels ),
                          str -> ReplacedString( str, "'", "\\'" ) ) );
    elif ForAll( numbers, x -> Int( x ) <> fail ) then
      # The inputs are numbers, and the outputs shall be numbers.
      numbers:= Concatenation( numbers,
                    Difference( List( [ 1 .. nccl ], String ), numbers ) );
    elif IsSubset( classnames, numbers ) and numbers = labels then
      # The inputs are class names (with dashes escaped),
      # and the outputs shall be numbers,
      dashedclassnames:= List( classnames,
                               str -> ReplacedString( str, "'", "\\'" ) );
      numbers:= Concatenation( numbers,
                    List( Difference( [ 1 .. nccl ],
                              List( numbers,
                                    x -> Position( dashedclassnames, x ) ) ),
                          String ) );
    else
      Error( "all in <numbers> must be numbers or in <classnames>" );
    fi;
    labels:= Concatenation( labels,
                 Filtered( classnames, x -> not x in labels ) );

    # Use power maps to fill missing entries of smaller element order.
    orders:= OrdersClassRepresentatives( tbl );
    primes:= PrimeDivisors( Size( tbl ) );
    known:= Filtered( [ 1 .. nccl ], x -> IsBound( result[x] ) );
    SortParallel( - orders{ known }, known );
    repeat
      unchanged:= true;
      for p in primes do
        map:= PowerMap( tbl, p );
        for i in known do
          img:= map[i];
          pp:= p mod orders[i];
          if pp = 0 then
            pp:= p;
          fi;
          if not img in known then
            Append( string, "pwr " );
            Append( string, String( pp ) );
            Append( string, " " );
            Append( string, numbers[ Position( labels, classnames[i] ) ] );
            Append( string, " " );
            Append( string, numbers[ Position( labels,
                                               classnames[ img ] ) ] );
            Append( string, "\n" );
            result[ img ]:= true;
            Add( known, img );
            unchanged:= false;
          fi;
        od;
      od;
    until unchanged;

    # Use Galois conjugacy to fill missing entries.
    for i in Difference( [ 1 .. nccl ], known ) do
      if not IsBound( result[i] ) then
        orb:= ClassOrbit( tbl, i );
        k:= First( orb, x -> x in known );
        if k = fail then
          Info( InfoCMeatAxe, 1,
                "at least Galois orbit representatives of classes in\n",
                "#I  `", classnames{ orb }, "' are missing" );
          return fail;
        fi;
        for j in orb do

          e:= 1;
          while not IsBound( result[j] ) do

            # Find a *small* power that maps k to j.
            e:= e+1;
            if orders[k] mod e <> 0 then
              if PowerMap( tbl, e, k ) = j then
                Append( string, "pwr " );
                Append( string, String( e ) );
                Append( string, " " );
                Append( string, numbers[ Position( labels,
                                         classnames[k] ) ] );
                Append( string, " " );
                Append( string, numbers[ Position( labels,
                                                   classnames[j] ) ] );
                Append( string, "\n" );
                result[j]:= true;
              fi;
            fi;

          od;

        od;
      fi;
    od;

    # Write the `echo' and `oup' statements.
    # (Split the output specifications into lines if necessary.)
    i:= 1;
    namline:= "";
    resline:= "";
    inline:= 0;
    while i <= nccl do
      if    60 < Length( namline ) + Length( classnames[i] )
         or 60 < Length( resline ) + Length( numbers[ Position( labels,
                                         classnames[i] ) ] ) then
        Append( string,
            Concatenation( "echo \"Classes", namline, "\"\n" ) );
        Append( string,
            Concatenation( "oup ", String( inline ), resline, "\n" ) );
        namline:= "";
        resline:= "";
        inline:= 0;
      fi;
      Add( namline, ' ' );
      Append( namline, classnames[i] );
      Add( resline, ' ' );
      Append( resline, numbers[ Position( labels, classnames[i] ) ] );
      inline:= inline + 1;
      i:= i + 1;
    od;
    if inline <> 0 then
      Append( string,
          Concatenation( "echo \"Classes", namline, "\"\n" ) );
      Append( string,
          Concatenation( "oup ", String( inline ), resline, "\n" ) );
    fi;

    # Return the string.
    return string;
end );


#############################################################################
##
#F  AGR.ComputeKernelGeneratorsInner( <gens>, <fgens>, <size>, <fsize>,
#F                                    <goodorders>, <bound> )
##
##  This function does the work for 'AtlasRepComputedKernelGenerators'.
##
##  <gens> and <fgens> must be lists of generators as occur in the records
##  that are returned by 'AtlasGenerators',
##  and <size> and <fsize> must be the orders of the groups that are
##  generated by these lists.
##  The lists of generators are assumed to be compatible in the sense that
##  mapping <gens> to <fgens> defines an epimorphism.
##  Let <M>G</M> be the group generated by <gens>.
##
##  <goodorders> can be 'true' or the list of all those element orders in the
##  factor group for which a preimage in the group has larger order.
##
##  The return value of the function and the meaning of <bound> are the same
##  as described for 'AtlasRepComputedKernelGenerators'.
##
AGR.ComputeKernelGeneratorsInner:= function( gens, fgens, size, fsize,
                                             goodorders, bound )
    local kersize, ker, kerwords, f, mgens, iter, gensorders, i, word,
          extrep, gm, fm, gord, ford, kergen;

    if Length( gens ) <> Length( fgens ) then
      Info( InfoAtlasRep, 3,
            "AtlasRepComputeKernelGenerators:\n",
            "#I  incompatible generators (lengths ", Length( gens ),
            " and ", Length( fgens ), "\n" );
      return fail;
    fi;

    if size = fail or fsize = fail then
      kersize:= fail;
    else
      kersize:= size / fsize;
      if not IsPosInt( kersize ) or kersize = 1 then
        Info( InfoAtlasRep, 3,
              "AtlasRepComputeKernelGenerators:\n",
              "#I  strange kernel size ", kersize, "\n" );
        return fail;
      fi;
    fi;

    ker:= TrivialSubgroup( Group( gens[1] ) );
    SetAsSSortedList( ker, [ gens[1]^0 ] );
    kerwords:= [];
    f:= FreeMonoid( Length( gens ) );
    mgens:= GeneratorsOfMonoid( f );
    iter:= Iterator( f );
    gensorders:= List( gens, Order );

    # Check at most 'bound' words.
    i:= 1;
    while i <= bound do
      word:= NextIterator( iter );
      extrep:= ExtRepOfObj( word );
      if ForAll( [ 2, 4 .. Length( extrep ) ],
                 j -> extrep[j] < gensorders[ extrep[ j-1 ] ] ) then
        # No exponent in a syllable exceeds the generator order in question.
        i:= i + 1;
        fm:= MappedWord( word, mgens, fgens );
        ford:= Order( fm );
        if goodorders = true or ford in goodorders then
          gm:= MappedWord( word, mgens, gens );
          gord:= Order( gm );
          if gord <> ford then
            if gord mod ford <> 0 or kersize mod ( gord / ford ) <> 0 then
              # The generators are not compatible.
              Info( InfoAtlasRep, 3,
                    "AtlasRepComputeKernelGenerators:\n",
                    "#I  incompatible generators (elements orders ", gord,
                    " and ", ford, " for word ", word, "\n" );
              return fail;
            elif kersize <> fail and gord / ford = kersize then
              # One generator suffices.
              return [ [ [ word, ford ] ], true ];
            else
              kergen:= gm^ford;
              # The membership test does not involve the computation
              # of a ``nice monomorphism'' because we have forced the
              # elements list of 'ker'.
              if not kergen in ker then
                ker:= ClosureGroup( ker, kergen );
                Add( kerwords, [ word, ford ] );
                if kersize = fail then
                  # We do not know how much we need,
                  # return at least this word.
                  return [ kerwords, false ];
                elif Size( ker ) = kersize then
                  return [ kerwords, true ];
                fi;
              fi;
            fi;
          fi;
        fi;
      fi;
    od;

    # We did not find enough elements among the first 'bound' words.
    return [ kerwords, false ];
end;


#############################################################################
##
#F  AtlasRepComputedKernelGenerators( <gapname>, <std>,
#F                                    <factgapname>, <factstd>,
#F                                    <bound> )
##
InstallGlobalFunction( AtlasRepComputedKernelGenerators,
    function( gapname, std, factgapname, factstd, bound )
    local gens, fgens, tbl, facttbl, goodorders, fus, orders, factorders, i,
          size, fsize;

    gens:= AtlasGroup( gapname, std, "contents", "local" );
    if gens = fail then
      return fail;
    fi;
    fgens:= AtlasGroup( factgapname, factstd, "contents", "local" );
    if fgens = fail then
      return fail;
    fi;

    # Representations of both G and F are available.
    # Assume that they are compatible.
    # Try to compute a list of interesting element orders in the factor.
    tbl:= CharacterTable( gapname );
    facttbl:= CharacterTable( factgapname );
    if tbl = fail or facttbl = fail then
      goodorders:= true;
    else
      fus:= GetFusionMap( tbl, facttbl );
      if fus = fail then
        goodorders:= true;
      else
        goodorders:= [];
        orders:= OrdersClassRepresentatives( tbl );
        factorders:= OrdersClassRepresentatives( facttbl );
        for i in [ 1 .. Length( fus ) ] do
          if orders[i] <> factorders[ fus[i] ] then
            AddSet( goodorders, factorders[ fus[i] ] );
          fi;
        od;
      fi;
    fi;

    if HasSize( gens ) then
      size:= Size( gens );
    elif tbl <> fail then
      size:= Size( tbl );
    else
      size:= fail;
    fi;
    if HasSize( fgens ) then
      fsize:= Size( fgens );
    elif facttbl <> fail then
      fsize:= Size( facttbl );
    else
      fsize:= fail;
    fi;

    # Run the loop.
    return AGR.ComputeKernelGeneratorsInner( GeneratorsOfGroup( gens ),
               GeneratorsOfGroup( fgens ), size, fsize, goodorders, bound );
end );


#############################################################################
##
#F  CurrentDateTimeString( [<options>] )
##
InstallGlobalFunction( CurrentDateTimeString, function( arg )
    local options, name, str, out;

    if Length( arg ) = 0 then
      options:= [ "-u", "+%s" ];
    elif Length( arg ) = 1 then
      options:= arg[1];
    fi;

    name:= Filename( DirectoriesSystemPrograms(), "date" );
    if name = fail then
      return "unknown";
    fi;

    str:= "";
    out:= OutputTextString( str, true );
    Process( DirectoryCurrent(), name, InputTextNone(), out, options );
    CloseStream( out );

    # Strip the trailing newline character.
    Unbind( str[ Length( str ) ] );

    # In the default case, transform to a format that is compatible with
    # `StringDate' and `StringTime'.
    if Length( arg ) = 0 then
      str:= Int( str );
      str:= Concatenation( StringDate( Int( str / 86400 ) ),
                           ", ",
                           StringTime( 1000 * ( str mod 86400 ) ),
                           " UTC" );
    fi;

    return str;
end );


#############################################################################
##
#F  SendMail( <sendto>, <copyto>, <subject>, <text> )
##
InstallGlobalFunction( SendMail, function( sendto, copyto, subject, text )
    local sendmail, inp;

    sendto:= JoinStringsWithSeparator( sendto, "," );
    copyto:= JoinStringsWithSeparator( copyto, "," );
    sendmail:= Filename( DirectoriesSystemPrograms(), "mail" );
    inp:= InputTextString( text );

    return Process( DirectoryCurrent(), sendmail, inp, OutputTextNone(),
                    [ "-s", subject, "-c", copyto, sendto ] );
end  );


#############################################################################
##
#F  ParseBackwards( <string>, <format> )
##
InstallGlobalFunction( "ParseBackwards", function( string, format )
    local result, pos, j, pos2;

    # Scan the string backwards.
    result:= [];
    pos:= Length( string );
    for j in Reversed( format ) do
      if IsString( j ) then
        pos2:= pos - Length( j );
        if pos2 < 0 or string{ [ pos2+1 .. pos ] } <> j then
          return fail;
        fi;
      else
        pos2:= pos;
        while 0 < pos2 and j( string[ pos2 ] ) do
          pos2:= pos2-1;
        od;
      fi;
      if j = IsDigitChar then
        Add( result, Int( string{ [ pos2+1 .. pos ] } ) );
      else
        Add( result, string{ [ pos2+1 .. pos ] } );
      fi;
      pos:= pos2;
    od;
    if 0 < pos then
      return fail;
    fi;

    return Reversed( result );
    end );


#############################################################################
##
#F  ParseBackwardsWithPrefix( <string>, <format> )
##
InstallGlobalFunction( "ParseBackwardsWithPrefix", function( string, format )
    local prefixes, len, flen, fstr, fstrlen, result;

    # Remove string prefixes.
    prefixes:= [];
    len:= Length( string );
    flen:= Length( format );
    while 0 < flen and IsString( format[1] ) do
      fstr:= format[1];
      fstrlen:= Length( fstr );
      if len < fstrlen or string{ [ 1 .. fstrlen ] } <> fstr then
        return fail;
      fi;
      Add( prefixes, fstr );
      string:= string{ [ fstrlen + 1 .. len ] };
      format:= format{ [ 2 .. flen ] };
      len:= len - fstrlen;
      flen:= flen-1;
    od;

    # Parse the remaining string backwards.
    result:= ParseBackwards( string, format );
    if result = fail then
      return fail;
    fi;

    Append( prefixes, result );
    return prefixes;
end );


#############################################################################
##
#F  ParseForwards( <string>, <format> )
##
InstallGlobalFunction( "ParseForwards", function( string, format )
    local result, pos, j, pos2, len;

    result:= [];
    pos:= 0;
    for j in format do
      len:= Length( string );
      if IsString( j ) then
        pos2:= pos + Length( j );
        if len < pos2 or string{ [ pos+1 .. pos2 ] } <> j then
          return fail;
        fi;
      else
        pos2:= pos + 1;
        while pos2 <= len and j( string[ pos2 ] ) do
          pos2:= pos2 + 1;
        od;
        pos2:= pos2 - 1;
      fi;
      if j = IsDigitChar then
        Add( result, Int( string{ [ pos+1 .. pos2 ] } ) );
      else
        Add( result, string{ [ pos+1 .. pos2 ] } );
      fi;
      pos:= pos2;
    od;
    if pos <> len then
      return fail;
    fi;

    return result;
end );


#############################################################################
##
#F  ParseForwardsWithSuffix( <string>, <format> )
##
InstallGlobalFunction( "ParseForwardsWithSuffix", function( string, format )
    local suffixes, len, flen, fstr, fstrlen, result;

    # Remove string suffixes.
    suffixes:= [];
    len:= Length( string );
    flen:= Length( format );
    while 0 < flen and IsString( format[ flen ] ) do
      fstr:= format[ flen ];
      fstrlen:= Length( fstr );
      if len < fstrlen or string{ [ len-fstrlen+1 .. len ] } <> fstr then
        return fail;
      fi;
      suffixes:= Concatenation( [ fstr ], suffixes );
      len:= len - fstrlen;
      flen:= flen-1;
      string:= string{ [ 1 .. len ] };
      format:= format{ [ 1 .. flen ] };
    od;

    # Parse the remaining string forwards.
    result:= ParseForwards( string, format );
    if result = fail then
      return fail;
    fi;

    Append( result, suffixes );
    return result;
end );


#############################################################################
##
#F  AtlasRepIdentifier( <oldid> )
#F  AtlasRepIdentifier( <id>, "old" )
##
InstallGlobalFunction( AtlasRepIdentifier, function( arg )
    local id, tocid, groupname, files, res, type;

    if Length( arg ) = 1 and IsList( arg[1] ) then
      # Convert an old type identifier to a new type identifier.
      id:= arg[1];
      if not IsDenseList( id ) or Length( id ) < 3 then
        return fail;
      elif IsString( id[1] ) then
        # The identifier belongs to non-private data.
        return StructuralCopy( id );
      elif IsDenseList( id[1] ) and Length( id[1] ) = 2 then
        # The identifier belongs to private data.
        tocid:= id[1][1];
        groupname:= id[1][2];
        files:= id[2];
        if IsString( files ) then
          files:= [ files ];
        fi;
        res:= StructuralCopy( id );
        res[1]:= groupname;
        res[2]:= List( files, x -> [ tocid, x ] );
        return res;
      else
        return fail;
      fi;
    elif Length( arg ) = 2 and IsList( arg[1] ) and arg[2] = "old" then
      # Convert a new type identifier to an old type identifier if possible.
      id:= arg[1];
      if not IsDenseList( id ) or Length( id ) < 3 then
        return fail;
      elif IsString( id[2] ) or
           ( IsList( id[2] ) and ForAll( id[2], IsString ) ) then
        # The identifier belongs to non-private data.
        return StructuralCopy( id );
      elif IsDenseList( id[2] ) and not ForAny( id[2], IsString ) then
        # The identifier belongs to private data.
        files:= id[2];
        tocid:= Set( List( files, x -> x[1] ) );
        if Length( tocid ) = 1 then
          # The private data belong to the same extension.
          tocid:= tocid[1];
        else
          return fail;
        fi;
        groupname:= id[1];
        res:= StructuralCopy( id );
        res[1]:= [ tocid, groupname ];
        res[2]:= List( files, x -> x[2] );
        if Length( res[2] ) = 1 then
          # If the list describes MeatAxe matrices or permutations
          # then keep the list, otherwise strip it.
          res[2]:= res[2][1];
          for type in AGR.DataTypes( "rep" ) do
            if type[1] in [ "perm", "matff" ] and
               AGR.ParseFilenameFormat( res[2], type[2].FilenameFormat )
               <> fail then
              res[2]:= [ res[2] ];
              break;
            fi;
          od;
        fi;
        return res;
      else
        return fail;
      fi;
    else
      Error( "usage: AtlasRepIdentifier( <id>[, \"old\"] )" );
    fi;
    end );


#############################################################################
##
#F  CompositionOfSLDAndSLP( <sld>, <slp> )
##
##  Return a straight line decision that first applies the straight line
##  program <slp> to its inputs and then returns the result of the
##  straight line decision <sld> on the outputs.
##
##  A typical situation is that <slp> is a restandardization script
##  and <sld> is a presentation.
##
InstallGlobalFunction( CompositionOfSLDAndSLP,
    function( sld, slp )
    local lines, len, lastline, inp2, max, i, pos, line;

    lines:= ShallowCopy( LinesOfStraightLineProgram( slp ) );
    len:= Length( lines );
    lastline:= lines[ len ];
    inp2:= NrInputsOfStraightLineDecision( sld );

    if ForAll( lastline, IsList ) then

      # Check that the programs fit together.
      if inp2 <> Length( lastline ) then
        Error( "outputs of <slp> incompatible with inputs of <sld>" );
      fi;

      # The last line is a list of external representations of assoc. words.
      # Copy them first to safe positions, then to the first positions.
      max:= NrInputsOfStraightLineProgram( slp );
      for i in [ 1 .. len-1 ] do
        if IsList( lines[i][1] ) then
          max:= Maximum( max, lines[i][2] );
        else
          max:= max + 1;
        fi;
      od;
      Unbind( lines[ len ] );
      pos:= max;
      for i in lastline do
        max:= max + 1;
        Add( lines, [ i, max ] );
      od;
      for i in [ 1 .. Length( lastline ) ] do
        Add( lines, [ [ pos + i, 1 ], i ] );
      od;

    else
      # Check that the programs fit together.
      if inp2 <> 1 then
        Error( "outputs of <slp> incompatible with inputs of <sld>" );
      fi;

      if Length( lastline ) = 2 and IsList( lastline[1] ) then

        # The last line is a pair of the external representation of an assoc.
        # word and a positive integer.
        # Copy the word to position 1 if necessary.
        if lastline[2] <> 1 then
          Add( lines, [ [ lastline[2], 1 ], 1 ] );
        fi;

      else

        # The last line is the external representation of an assoc. word.
        # Store it at position 1.
        lines[ Length( lines ) ]:= [ lastline, 1 ];

      fi;

    fi;

    # Append the lines of `sld'.
    # (Rewrite lines of type 1.)
    max:= inp2;
    for line in LinesOfStraightLineDecision( sld ) do
      if line[1] = "Order" then
        Add( lines, line );
      elif ForAll( line, IsInt ) then
        max:= max + 1;
        Add( lines, [ line, max ] );
      else
        max:= Maximum( max, line[2] );
        Add( lines, line );
      fi;
    od;

    # Construct and return the new decision.
    return StraightLineDecisionNC( lines,
                                   NrInputsOfStraightLineProgram( slp ) );
    end );


#############################################################################
##
#F  AGR.CompareAsNumbersAndNonnumbers( <nam1>, <nam2> )
##
##  This function is available as `BrowseData.CompareAsNumbersAndNonnumbers'
##  if the Browse package is available.
##  But we must deal also with the case that this package is not available.
##
AGR.CompareAsNumbersAndNonnumbers:= function( nam1, nam2 )
    local len1, len2, len, digit, comparenumber, i;

    # Essentially the code does the following, just more efficiently.
    # return BrowseData.SplitStringIntoNumbersAndNonnumbers( nam1 ) <
    #        BrowseData.SplitStringIntoNumbersAndNonnumbers( nam2 );

    len1:= Length( nam1 );
    len2:= Length( nam2 );
    len:= len1;
    if len2 < len then
      len:= len2;
    fi;
    digit:= false;
    comparenumber:= 0;
    for i in [ 1 .. len ] do
      if nam1[i] in DIGITS then
        if nam2[i] in DIGITS then
          digit:= true;
          if comparenumber = 0 then
            # first digit of a number, or previous digits were equal
            if nam1[i] < nam2[i] then
              comparenumber:= 1;
            elif nam1[i] <> nam2[i] then
              comparenumber:= -1;
            fi;
          fi;
        else
          # if digit then the current number in `nam2' is shorter,
          # so `nam2' is smaller;
          # if not digit then a number starts in `nam1' but not in `nam2',
          # so `nam1' is smaller
          return not digit;
        fi;
      elif nam2[i] in DIGITS then
        # if digit then the current number in `nam1' is shorter,
        # so `nam1' is smaller;
        # if not digit then a number starts in `nam2' but not in `nam1',
        # so `nam2' is smaller
        return digit;
      else
        # both characters are non-digits
        if digit then
          # first evaluate the current numbers (which have the same length)
          if comparenumber = 1 then
            # nam1 is smaller
            return true;
          elif comparenumber = -1 then
            # nam2 is smaller
            return false;
          fi;
          digit:= false;
        fi;
        # now compare the non-digits
        if nam1[i] <> nam2[i] then
          return nam1[i] < nam2[i];
        fi;
      fi;
    od;

    if digit then
      # The suffix of the shorter string is a number.
      # If the longer string continues with a digit then it is larger,
      # otherwise the first digits of the number decide.
      if len < len1 and nam1[ len+1 ] in DIGITS then
        # nam2 is smaller
        return false;
      elif len < len2 and nam2[ len+1 ] in DIGITS then
        # nam1 is smaller
        return true;
      elif comparenumber = 1 then
        # nam1 is smaller
        return true;
      elif comparenumber = -1 then
        # nam2 is smaller
        return false;
      fi;
    fi;

    # Now the longer string is larger.
    return len1 < len2;
    end;


#############################################################################
##
#F  AGR.IsEquivalentSLP( <lines1>, <lines2>, <gens> )
##
##  returns 'true' if the straight line programs defined by the lists
##  <lines1> and <lines2>, respectively, evaluate to the same results
##  when applied to the list <gens>;
##  returns 'false' otherwise.
##
AGR.IsEquivalentSLP:= function( lines1, lines2, gens )
    local n, slp1, slp2;

    if lines1 = lines2 then
      return true;
    fi;

    n:= Length( gens );
    slp1:= StraightLineProgram( lines1, n );
    slp2:= StraightLineProgram( lines2, n );
    return ResultOfStraightLineProgram( slp1, gens )
           = ResultOfStraightLineProgram( slp2, gens );
    end;


#############################################################################
##
#F  AGR.CleanedGroupName( <name> )
##
##  The function is used for the creation of HTML files.
##  Replace backslash and colon, as 'Filename' does not accept them.
##
AGR.CleanedGroupName:= name -> JoinStringsWithSeparator(
                                   SplitString( name, ":\\" ), "." );


#############################################################################
##
#F  AGR.CurrentAtlasPage( <atlasname> )
##
##  The usual URLs refer to the location of the data,
##  but we need the web page with the overview (currently in the v3 variant).
##
##  The return value is 'fail' if the ''official'' AGR contains at least one
##  file for the group <atlasname>.
##
##  (cf. MFERCurrentAtlasPage)
##
AGR.CurrentAtlasPage:= function( atlasname )
    local prefix, list, pos, test, j, entry, info;

    prefix:= Concatenation( atlasname, "G" );
    list:= AtlasOfGroupRepresentationsInfo.filenames;
    pos:= PositionSorted( list, [ prefix ] );
    if Length( list ) < pos then
      return fail;
    fi;

    # Assume that only the standardizations 0, 1, 2 occur.
    test:= List( [ "0", "1", "2" ],
                 i -> Concatenation( "/", prefix, i, "-" ) );

    for j in [ pos .. Length( list ) ] do
      entry:= list[j][2];
      if list[j][3] = "core" and
         ForAny( test, x -> ReplacedString( entry, x, "" ) <> entry ) then
        entry:= SplitString( entry, "/" );
        info:= AtlasOfGroupRepresentationsInfo.servers[1];
        return Concatenation( "http://", info[1], "/", info[2], "v3/",
                              entry[1], "/", entry[2] );
      fi;
    od;

    return fail;
    end;


#############################################################################
##
#F  AGR.HTMLInfoForGroup( <tocids>, <gapname> )
##
##  the common part of the HTML file for a single group or of the combined
##  file for all groups
##
AGR.HTMLInfoForGroup:= function( tocids, gapname )
    local pref, str, inforeps, list, entry, infoprgs, i, pos;

    # Make sure that 'AGR.ShowOnlyASCII' returns 'true',
    # otherwise we cannot safely replace the "<=" substring.
    pref:= UserPreference( "AtlasRep", "DisplayFunction" );
    SetUserPreference( "AtlasRep", "DisplayFunction", "Print" );

    str:= "";

    # Append the information about representations.
    Append( str, "<dl>\n" );
    inforeps:= AGR.InfoReps( [ gapname, "contents", tocids ] );
#T add links to data which are available in the internet
    if not IsEmpty( inforeps.list ) then
      Append( str, "<dt>\n" );
      Append( str, Concatenation( inforeps.header[1],
                       NormalizedNameOfGroup( inforeps.header[2], "HTML" ) ) );
      Append( str, Concatenation(
                       inforeps.header{ [ 3 .. Length( inforeps.header ) ] } ) );
      Append( str, "\n" );
      Append( str, "</dt>\n" );
      Append( str, "<dd>\n" );

      list:= [];
      for entry in inforeps.list do
        entry[2][1]:= ReplacedString( entry[2][1], "<=",
                          MarkupGlobals.HTML.leq );
        entry[2][1]:= ReplacedString( entry[2][1], ",Z)",
                          Concatenation( ",", MarkupGlobals.HTML.Z, ")" ) );
        if 3 <= Length( entry[3] ) then
          entry[3][3]:= NormalizedNameOfGroup( entry[3][3], "HTML" );
        fi;
        Add( list, [ entry[1][1], entry[2][1], Concatenation( entry[3] ) ] );
      od;
      Append( str, HTMLStandardTable( fail, list,
                                      "datatable",
                                      [ "pright", "pleft", "pleft" ] ) );
      Append( str, "</dd>\n" );
    fi;
    Append( str, "</dl>\n" );

    # Append the information about programs.
    infoprgs:= AGR.InfoPrgs( [ gapname, "contents", tocids ] );
    if ForAny( infoprgs.list, x -> not IsEmpty( x ) ) then
      Append( str, "<dl>\n" );
      Append( str, "<dt>\n" );
      Append( str, infoprgs.header[1] );
      Append( str, NormalizedNameOfGroup( infoprgs.header[2], "HTML" ) );
      Append( str, Concatenation(
                       infoprgs.header{ [ 3 .. Length( infoprgs.header ) ] } ) );
      Append( str, "\n" );
      Append( str, "</dt>\n" );
      Append( str, "<dd>\n" );
      Append( str, "<ul>\n" );
      for entry in infoprgs.list do
        if not IsEmpty( entry ) then
          Append( str, "<li>\n" );
          Append( str, entry[1] );
          if 1 < Length( entry ) then
            Append( str, ":" );
          fi;
          Append( str, "\n" );
          if 1 < Length( entry ) then
            list:= entry{ [ 2 .. Length( entry ) ] };
            if IsString( list[1] ) then
              Append( str, list[1] );
            else
              for i in [ 1 .. Length( list ) ] do
                if list[i] = "" then
                  pos:= fail;
                else
                  pos:= Position( list[i][1], ':' );
                fi;
                if pos = fail or
                   Int( NormalizedWhitespace( list[i][1]{ [ 1 .. pos-1 ] } ) )
                     = fail then
                  list[i]:= [ list[i][1], "" ];
                else
                  # This happens currently only for 'maxes'.
                  list[i]:= [ list[i][1]{ [ 1 .. pos-1 ] },
                              NormalizedNameOfGroup( NormalizedWhitespace(
                                  list[i][1]{ [ pos+1 .. Length( list[i][1] ) ] } ),
                                  "HTML" ) ];
                fi;
              od;
              if ForAll( list, x -> x[2] = "" ) then
                Append( str, HTMLStandardTable( fail, List( list, x -> [x[1]] ),
                                          "datatable",
                                          [ "pleft" ] ) );
              else
                Append( str, HTMLStandardTable( fail, list,
                                          "datatable",
                                          [ "pright", "pleft" ] ) );
              fi;
            fi;
          fi;
          Append( str, "</li>\n" );
        fi;
      od;
      Append( str, "</ul>\n" );
      Append( str, "</dd>\n" );
      Append( str, "</dl>\n" );
      Append( str, "\n" );
    fi;

    SetUserPreference( "AtlasRep", "DisplayFunction", pref );

    return str;
    end;


#############################################################################
##
#F  AGR.CreateHTMLInfoForGroup( <tocids>, <gapname>, <dirname> )
##
##  <tocid> is a string or a list of strings,
##  <gapname> and <atlasname> are the names of the group in question,
##  <dirname> is the directory where the file will be created if necessary.
##

#T what about MathJax? -> introduce as a new option besides "HTML"?

AGR.CreateHTMLInfoForGroup:= function( tocids, gapname, dirname )
    local str, atlasname, link, inforeps, list, entry, infoprgs, i, pos;

    # Create the file header.
    str:= HTMLHeader( "GAP Package AtlasRep",
                      "../../atlasrep.css",
                      Concatenation( "<a href=\"../../index.html\">",
                          "GAP Package AtlasRep</a>" ),
#T -> indiv. title, link to AtlasRep, link to AGR, ...
                      Concatenation( "AtlasRep Info for ",
                          NormalizedNameOfGroup( gapname, "HTML" ) ) );
#T change parameters:
#T - automatically provide minimal css file in the dir. if not available,
#T - turn title with link into an argument
    Append( str, "<dl>\n" );

    # Append the links to the overview
    # and to the page for this group in the ATLAS database.
    Append( str, "<dt>\n" );
    atlasname:= AGR.GAPnamesRec.( gapname )[2];
    link:= AGR.CurrentAtlasPage( atlasname );
#T not for groups not in the AGR?
    if link <> fail then
      # There is a web page of the AGR to which we can point.
      Append( str, Concatenation( "<a href=\"", link, "\">",
                       MarkupGlobals.HTML.rightarrow,
                       " ATLAS page for ",
                       NormalizedNameOfGroup( gapname, "HTML" ),
                       "</a>\n" ) );
    fi;
    Append( str, "</dt>\n" );
    Append( str, "<dt>\n" );
    Append( str, Concatenation( "<a href=\"overview.htm\">",
                     MarkupGlobals.HTML.rightarrow,
                     " Overview of Groups</a>\n" ) );
    Append( str, "</dt>\n" );
    Append( str, "</dl>\n" );

    Append( str, AGR.HTMLInfoForGroup( tocids, gapname ) );

    # Append the footer string.
    Append( str, HTMLFooter() );

    # Create the file.
    return PrintToIfChanged( Concatenation( dirname, "/",
               AGR.CleanedGroupName( gapname ), ".htm" ), str );
    end;


#############################################################################
##
#F  AGR.CreateHTMLOverview( <tocid>[, <info>] )
##
##  <tocid> must be the string "core" or an ID of a data extension.
##  <info> must be a record with the components
##  - title
##  - cssfile
##  - cornerlink
##  - headerline
##  - overviewtext
##  - dir
##
##  The code was copied from 'DisplayAtlasInfoOverview'.
##
AGR.CreateHTMLOverview:= function( tocid, info... )
    local conditions, tocs, title, cssfile, cornerlink, headerline, str, 
          gapnames, groupnames, columns, type, matrix, alignments, col, i,
          row, dir, name;

    if Length( info ) = 0 then
      info:= rec();
    elif IsRecord( info[1] ) then
      info:= info[1];
    else
      Error( "<info> must be a record" );
    fi;
 
    
    conditions:= [ "contents", tocid ];
    tocs:= AGR.TablesOfContents( tocid );
    if Length( tocs ) = 0 then
      Error( "no id <tocid> known" );
    fi;

    # Create the file header.
    if IsBound( info.title ) then
      title:= info.title;
    elif tocid = "core" then
      title:= "GAP Package AtlasRep";
    else
      title:= Concatenation( "AtlasRep extension '", tocid, "'" );
    fi;

    if IsBound( info.cssfile ) then
      cssfile:= info.cssfile;
    elif tocid = "core" then
      cssfile:= "../../atlasrep.css";
    else
      cssfile:= fail;
    fi;

    if IsBound( info.cornerlink ) then
      cornerlink:= info.cornerlink;
    elif tocid = "core" then
      cornerlink:= Concatenation( "<a href=\"../../index.html\">",
                                  "GAP Package AtlasRep</a>" );
    else
      cornerlink:= fail;
    fi;

    if IsBound( info.headerline ) then
      headerline:= info.headerline;
    elif tocid = "core" then
      headerline:= "Available via the GAP Interface";
    else
      headerline:= fail;
    fi;

    str:= HTMLHeader( title, cssfile, cornerlink, headerline );
#T -> mention the name of the extension, the URL, ...

    # Insert the explanatory text.
    if IsBound( info.overviewtext ) then
      Append( str, info.overviewtext );
    elif tocid = "core" then
      Append( str, AGR.StringFile( Filename(
                       DirectoriesPackageLibrary( "atlasrep", "dev" ),
                       "overviewtxt.htm" ) ) );
    else
      Append( str, "" );
    fi;

    # Consider only those names for which actually information is available.
    gapnames:= Filtered( AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp,
                   x -> ForAny( tocs, toc -> IsBound( toc.( x[2] ) ) ) );

    # Construct the links for the names.
    groupnames:= List( gapnames,
                       x -> Concatenation( "<a href=\"",
                                AGR.CleanedGroupName( x[1] ), ".htm\">",
                                NormalizedNameOfGroup( x[1], "HTML" ),
                                "</a>" ) );

    # Compute the data of the columns.
    columns:= [ [ "group", "l", groupnames ] ];
    for type in AGR.DataTypes( "rep", "prg" ) do
      if type[2].DisplayOverviewInfo <> fail then
        Add( columns, [
             type[2].DisplayOverviewInfo[1],
             type[2].DisplayOverviewInfo[2],
             List( gapnames,
                   name -> type[2].DisplayOverviewInfo[3](
                               Concatenation( [ name ], conditions ) ) ) ] );
      fi;
    od;
#T now omit empty columns

    matrix:= [ [] ];
    alignments:= [];

    # Add the table header line.
    for col in columns do
      Add( matrix[1], col[1] );
      if col[2] = "l" then
        Add( alignments, "tdleft" );
      elif col[2] = "r" then
        Add( alignments, "tdright" );
      else
        Add( alignments, "tdcenter" );
      fi;
    od;

    if IsBound( info.dir ) then
      dir:= info.dir;
    elif tocid = "core" then
      dir:= Filename( DirectoriesPackageLibrary( "atlasrep", "htm/data" ), "" );
    else
      Error( "info.dir must be bound" );
    fi;

    # Collect the information for each group.
    for i in [ 1 .. Length( gapnames ) ] do
      row:= [ columns[1][3][i] ];
      for col in columns{ [ 2 .. Length( columns ) ] } do
        Add( row, col[3][i][1] );
      od;
      Add( matrix, row );

      # Create the file for this group.
      info:= AGR.CreateHTMLInfoForGroup( tocid, gapnames[i][1], dir );
      if not StartsWith( info, "unchanged" ) then
        Print( "#I  ", info, "\n" );
      fi;
    od;

    Append( str, HTMLStandardTable( fail, matrix, "datatable", alignments ) );

    # Append the footer string.
    Append( str, HTMLFooter() );

    # Create the overview file.
    info:= PrintToIfChanged( Concatenation( dir, "/overview.htm" ), str );
    if not StartsWith( info, "unchanged" ) then
      Print( "#I  ", info, "\n" );
    fi;

    # Finally, report about HTML files that should be removed.
    # List the files in `toc'.
    str:= Difference( DirectoryContents( dir ), List( gapnames,
          x -> Concatenation( AGR.CleanedGroupName( x[1] ), ".htm" ) ) );
    SubtractSet( str, [ "changes.htm", "changes.htm.old",
                        "overview.htm", ".", ".." ] );
    if not IsEmpty( str ) then
      Print( "#I  Remove the following files from '", dir, "':\n" );
      for name in str do
        Print( "#I  ", name, "\n" );
      od;
    fi;
    end;


#############################################################################
##
#E

