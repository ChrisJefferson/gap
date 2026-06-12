#############################################################################
##
#W  mindeg.gi            GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains implementations for dealing with information about
##  permutation and matrix representations of minimal degree
##  for selected groups.
##


#############################################################################
##
#F  MinimalRepresentationInfo( <grpname>, NrMovedPoints[, <mode>] )
#F  MinimalRepresentationInfo( <grpname>, Characteristic, <p>[, <mode>] )
#F  MinimalRepresentationInfo( <grpname>, Size, <q>[, <mode>] )
##
InstallGlobalFunction( MinimalRepresentationInfo, function( arg )
    local grpname, info, conditions, known, result, mode, p, ordtbl, minpos,
          faith, Norder, modtbl, min, q, pos, cont;

    if   Length( arg ) = 0 then
      Error( "usage: ",
             "MinimalRepresentationInfo( <grpname>[, <conditions>] )" );
    fi;
    grpname:= arg[1];
    if not IsString( grpname ) then
      return fail;
    fi;
    if IsBound( MinimalRepresentationInfoData.( grpname ) ) then
      info:= MinimalRepresentationInfoData.( grpname );
    else
      info:= fail;
    fi;
    conditions:= arg{ [ 2 .. Length( arg ) ] };

    known:= fail;
    result:= fail;
    mode:= "cache";
    if not IsEmpty( conditions ) and
       IsString( conditions[ Length( conditions ) ] ) then
      mode:= conditions[ Length( conditions ) ];
      Unbind( conditions[ Length( conditions ) ] );
    fi;

    if conditions = [ NrMovedPoints ] then

      # MinimalRepresentationInfo( <grpname>, NrMovedPoints )
      if info <> fail and IsBound( info.NrMovedPoints ) then
        known:= info.NrMovedPoints;
      fi;
      if mode = "lookup" or ( mode = "cache" and known <> fail ) then
        return known;
      fi;
      if IsBound( GAPInfo.PackagesLoaded.ctbllib ) then
        # This works only if the package `CTblLib' is available.
        if   mode = "recompute" then
          result:= MinimalPermutationRepresentationInfo( grpname, "all" );
#T currently gets stuck at "B", because of missing fusion from "(2^2xF4(2)):2"
        elif known = fail then
          result:= MinimalPermutationRepresentationInfo( grpname, "one" );
        fi;
      fi;
      if result = fail or IsEmpty( result.source ) then
        # We cannot compute the value, take the stored value.
        result:= known;
      else
        # Store the computed value, and compare it with the known one.
        SetMinimalRepresentationInfo( grpname, "NrMovedPoints",
                                      result.value, result.source );
      fi;

    elif Length( conditions ) = 2 and conditions[1] = Characteristic then

      # MinimalRepresentationInfo( <grpname>, Characteristic, <p> )
      p:= conditions[2];
      if info <> fail and IsBound( info.Characteristic )
                      and IsBound( info.Characteristic.( p ) ) then
        known:= info.Characteristic.( p );
      fi;
      if mode = "lookup" or ( mode = "cache" and known <> fail ) then
        return known;
      fi;
      if known = fail or mode = "recompute" then
        # For groups with a unique minimal normal subgroup
        # whose order is not a power of the characteristic,
        # a faithful matrix representation of minimal degree is irreducible.
        # (Consider a faithful reducible representation $\rho$ in block
        # diagonal form.
        # If the restriction to the minimal normal subgroup $N$ is trivial
        # on the two factors then the restriction of $\rho$ to $N$ is a group
        # of triangular matrices, i.e., a $p$-group.)
        ordtbl:= CharacterTable( grpname );
        if ordtbl <> fail then
          minpos:= ClassPositionsOfMinimalNormalSubgroups( ordtbl );
          if Length( minpos ) = 1 then
            if p = 0 or Size( ordtbl ) mod p <> 0 then
              # Consider the ordinary character table.
              # Take the smallest degree of a faithful irreducible character.
              faith:= Filtered( Irr( ordtbl ),
                          x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
              result:= rec( value:= Minimum( List( faith, x -> x[1] ) ),
                            source:= [ "computed (char. table)" ] );
            elif IsPrimeInt( p ) then
              Norder:= Sum( SizesConjugacyClasses( ordtbl ){ minpos[1] } );
              if not ( IsPrimePowerInt( Norder ) and Norder mod p = 0 ) then
                # Consider the Brauer table.
                modtbl:= ordtbl mod p;
                if modtbl <> fail then
                  faith:= Filtered( Irr( modtbl ),
                            x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
                  result:= rec( value:= Minimum( List( faith, x -> x[1] ) ),
                                source:= [ "computed (char. table)" ] );
                fi;
              fi;
            fi;
          else
            # If the minimal nontrivial irreducible representation is
            # faithful then this irreducible is minimal.
            if p = 0 or Size( ordtbl ) mod p <> 0 then
              faith:= Filtered( Irr( ordtbl ),
                          x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
              if not IsEmpty( faith ) then
                min:= Minimum( List( faith, x -> x[1] ) );
                if ForAll( Irr( ordtbl ),
                           x -> x[1] >= min or Set( x ) = [ 1 ] ) then
                  result:= rec( value:= min,
                                source:= [ "computed (char. table)" ] );
                fi;
              fi;
            elif IsPrimeInt( p ) then
              minpos:= List( ClassPositionsOfNormalSubgroups( ordtbl ),
                             x -> Sum( SizesConjugacyClasses( ordtbl ){ x } ) );
              if not ForAny( minpos,
                             x -> IsPrimePowerInt( x ) and x mod p = 0 ) then
                # Consider the Brauer table.
                modtbl:= ordtbl mod p;
                if modtbl <> fail then
                  faith:= Filtered( Irr( modtbl ),
                            x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
                  if not IsEmpty( faith ) then
                    min:= Minimum( List( faith, x -> x[1] ) );
                    if ForAll( Irr( modtbl ),
                               x -> x[1] >= min or Set( x ) = [ 1 ] ) then
                      result:= rec( value:= min,
                                    source:= [ "computed (char. table)" ] );
                    fi;
                  fi;
                fi;
              fi;
            fi;
          fi;
        fi;
      fi;
      if result = fail then
        # We cannot compute the value, take the stored value.
        result:= known;
      else
        SetMinimalRepresentationInfo( grpname, [ "Characteristic", p ],
                                      result.value, result.source );
      fi;

    elif Length( conditions ) = 2 and conditions[1] = Size then

      # MinimalRepresentationInfo( <grpname>, Size, <q> )
      q:= conditions[2];
      p:= SmallestRootInt( q );
      if info <> fail and IsBound( info.CharacteristicAndSize )
                      and IsBound( info.CharacteristicAndSize.( p ) ) then
        info:= info.CharacteristicAndSize.( p );
        pos:= Position( info.sizes, q );
        if pos <> fail then
          known:= rec( value:= info.dimensions[ pos ],
                       source:= info.sources[ pos ] );
        elif info.complete.value then
          cont:= Filtered( [ 1 .. Length( info.sizes ) ],
                   i -> LogInt( q, p ) mod LogInt( info.sizes[i], p ) = 0 );
          known:= rec( value:= Minimum( info.dimensions{ cont } ),
                       source:= [ "computed (stored data)" ] );
        fi;
      fi;
      if mode = "lookup" or ( mode = "cache" and known <> fail ) then
        return known;
      fi;
      if known = fail or mode = "recompute" then
        # For groups with a unique minimal normal subgroup
        # whose order is not a power of the characteristic,
        # a faithful matrix representation of minimal degree is irreducible
        # (over a given field).
        ordtbl:= CharacterTable( grpname );
        if IsPosInt( q ) and IsPrimePowerInt( q ) and ordtbl <> fail then
          minpos:= ClassPositionsOfMinimalNormalSubgroups( ordtbl );
          if Length( minpos ) = 1 then
            if Size( ordtbl ) mod p <> 0 then
              # Consider the ordinary character table.
              # Take the smallest degree of a faithful irreducible character,
              # over the given field.
              faith:= Filtered( Irr( ordtbl ),
                          x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
              faith:= RealizableBrauerCharacters( faith, q );
              result:= rec( value:= Minimum( List( faith, x -> x[1] ) ),
                            source:= [ "computed (char. table)" ] );
            else
              Norder:= Sum( SizesConjugacyClasses( ordtbl ){ minpos[1] } );
              if not ( IsPrimePowerInt( Norder ) and Norder mod p = 0 ) then
                # Consider the Brauer table.
                modtbl:= ordtbl mod p;
                if modtbl <> fail then
                  faith:= Filtered( Irr( modtbl ),
                            x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
                  faith:= RealizableBrauerCharacters( faith, q );
                  if faith <> fail then
                    result:= rec( value:= Minimum( List( faith, x -> x[1] ) ),
                                  source:= [ "computed (char. table)" ] );
                  fi;
                fi;
              fi;
            fi;
          fi;
        fi;
      fi;
      if result = fail then
        # We cannot compute the value, take the stored value.
        result:= known;
      else
        SetMinimalRepresentationInfo( grpname, [ "Size", q ],
                                      result.value, result.source );
      fi;

    fi;

    return result;
    end );


#############################################################################
##
#F  SetMinimalRepresentationInfo( <grpname>, <op>, <value>, <source> )
##
InstallGlobalFunction( SetMinimalRepresentationInfo,
    function( grpname, op, value, source )
    local compare, info, p, q, pos;

    compare:= function( value, source, valuestored, sourcestored, type )
      if value <> valuestored then
        Print( "#E  ", type, ": incompatible minimum for `",
               grpname, "'\n" );
        return false;
      fi;
      UniteSet( sourcestored, source );
      return true;
    end;

    if IsString( source ) then
      source:= [ source ];
    fi;
    if not IsBound( MinimalRepresentationInfoData.( grpname ) ) then
      MinimalRepresentationInfoData.( grpname ):= rec();
    fi;
    info:= MinimalRepresentationInfoData.( grpname );
    if op = "NrMovedPoints" then
      if IsBound( info.NrMovedPoints ) then
        info:= info.NrMovedPoints;
        return compare( value, source,
                        info.value, info.source, "NrMovedPoints" );
      else
        info.NrMovedPoints:= rec( value:= value, source:= source );
        return true;
      fi;
    elif IsList( op ) and Length( op ) = 2
                      and op[1] = "Characteristic"
                      and ( op[2] = 0 or IsPrimeInt( op[2] ) ) then
      if not IsBound( info.Characteristic ) then
        info.Characteristic:= rec();
      fi;
      info:= info.Characteristic;
      p:= String( op[2] );
      if IsBound( info.( p ) ) then
        info:= info.( p );
        return compare( value, source,
                        info.value, info.source, "Characteristic" );
      else
        info.( p ):= rec( value:= value, source:= source );
        return true;
      fi;
    elif IsList( op ) and Length( op ) = 3
                      and op[1] = "Characteristic"
                      and IsPrimeInt( op[2] )
                      and op[3] = "complete" then
      if not IsBound( info.CharacteristicAndSize ) then
        info.CharacteristicAndSize:= rec();
      fi;
      info:= info.CharacteristicAndSize;
      p:= String( op[2] );
      if not IsBound( info.( p ) ) then
        info.( p ):= rec( sizes:= [], dimensions:= [], sources:= [] );
      fi;
      info.( p ).complete:= rec( value:= value, source:= source );
      return true;
    elif IsList( op ) and Length( op ) = 2
                      and op[1] = "Size"
                      and IsInt( op[2] ) and IsPrimePowerInt( op[2] ) then
      if not IsBound( info.CharacteristicAndSize ) then
        info.CharacteristicAndSize:= rec();
      fi;
      info:= info.CharacteristicAndSize;
      q:= op[2];
      p:= String( SmallestRootInt( q ) );
      if not IsBound( info.( p ) ) then
        info.( p ):= rec( sizes:= [], dimensions:= [], sources:= [],
                          complete:= rec( value:= false, source:= "" ) );
      fi;
      info:= info.( p );
      pos:= Position( info.sizes, q );
      if pos <> fail then
        # Compare the stored and the computed value.
        return compare( value, source,
                   info.dimensions[ pos ], info.sources[ pos ], "Size" );
      elif ForAll( [ 1 .. Length( info.sizes ) ],
                   i -> not ( q = info.sizes[i] ^ LogInt( q, info.sizes[i] )
                              and info.dimensions[i] = value ) ) then
        Add( info.sizes, q );
        Add( info.dimensions, value );
        Add( info.sources, source );
        return true;
      fi;
    else
      Error( "do not known how to store this info: <value>, <source>" );
    fi;
    end );


#############################################################################
##
#F  ComputedMinimalRepresentationInfo()
##
InstallGlobalFunction( ComputedMinimalRepresentationInfo, function()
    local oldvalue, info, grpname, ordtbl, size, p, modtbl, sizes, q, r,
          entry, newvalue, diff, comp, char;

    # Save the stored list.
    oldvalue:= MinimalRepresentationInfoData;
    MakeReadWriteGlobal( "MinimalRepresentationInfoData" );
    MinimalRepresentationInfoData:= rec();

    # Add non-computed data.
    for entry in Filtered( oldvalue.datalist,
                           e -> e[4]{ [ 1 .. 4 ] } <> "comp" ) do
      SetMinimalRepresentationInfo( entry[1], entry[2], entry[3],
                                    [ entry[4] ] );
    od;

    # Recompute the data.
    for info in AtlasOfGroupRepresentationsInfo.GAPnames do
      grpname:= info[1];
      MinimalRepresentationInfo( grpname, NrMovedPoints, "recompute" );
      ordtbl:= CharacterTable( grpname );
      MinimalRepresentationInfo( grpname, Characteristic, 0, "recompute" );
      if IsBound( info[3].size ) then
        size:= info[3].size;
        for p in PrimeDivisors( size ) do
          MinimalRepresentationInfo( grpname, Characteristic, p,
                                     "recompute" );
          # If O_p is nontrivial then the Brauer table belongs to a factor.
          if ordtbl <> fail and ClassPositionsOfPCore( ordtbl, p ) = [ 1 ] then
            modtbl:= ordtbl mod p;
            if modtbl <> fail then
              sizes:= Set( List( Irr( modtbl ),
                             phi -> SizeOfFieldOfDefinition( phi, p ) ) );
              for q in Filtered( sizes, IsInt ) do
                MinimalRepresentationInfo( grpname, Size, q, "recompute" );
              od;
              if IsBound( MinimalRepresentationInfoData.( grpname ) ) then
                r:= MinimalRepresentationInfoData.( grpname );
                if IsBound( r.CharacteristicAndSize ) then
                  r:= r.CharacteristicAndSize;
                  if not fail in sizes then
                    SetMinimalRepresentationInfo( grpname,
                      [ "Characteristic", p, "complete" ], true,
                      [ "computed (char. table)" ] );
                  fi;
                fi;
              fi;
            fi;
          fi;
        od;
      fi;
    od;

    # Print information about differences.
    newvalue:= MinimalRepresentationInfoData;
    newvalue.datalist:= oldvalue.datalist;
    diff:= Difference( RecNames( oldvalue ), RecNames( newvalue ) );
    if not IsEmpty( diff ) then
      Print( "#E  missing min. repr. components:\n", diff, "\n" );
    fi;
    diff:= Intersection( Difference( RecNames( newvalue ),
                                     RecNames( oldvalue ) ),
                         List( AtlasOfGroupRepresentationsInfo.GAPnames,
                               x -> x[1] ) );
    if not IsEmpty( diff ) then
      Print( "#I  new min. repr. components:\n", diff, "\n" );
    fi;
    for comp in Intersection( RecNames( newvalue ), RecNames( oldvalue ) ) do
      if oldvalue.( comp ) <> newvalue.( comp ) then
        Print( "#I  min. repr. differences for ", comp, "\n" );
        if IsBound( oldvalue.( comp ).NrMovedPoints ) and
           IsBound( newvalue.( comp ).NrMovedPoints ) and
           oldvalue.( comp ).NrMovedPoints.source
             <> newvalue.( comp ).NrMovedPoints.source then
          Print( "#I  (different `source' components for NrMovedPoints:\n",
                 "#I  ", oldvalue.( comp ).NrMovedPoints.source, "\n",
                 "#I   -> ", newvalue.( comp ).NrMovedPoints.source, ")\n" );
        fi;
        if IsBound( oldvalue.( comp ).Characteristic ) and
           IsBound( newvalue.( comp ).Characteristic ) then
          for char in Intersection(
                          RecNames( oldvalue.( comp ).Characteristic ),
                          RecNames( newvalue.( comp ).Characteristic ) ) do
            if oldvalue.( comp ).Characteristic.( char ).source
                 <> newvalue.( comp ).Characteristic.( char ).source then
              Print( "#I  (different `source' components for characteristic ",
                     char, ":\n",
                     "#I  ", oldvalue.( comp ).Characteristic.( char ).source,
                     "\n#I   -> ",
                     newvalue.( comp ).Characteristic.( char ).source,
                     ")\n" );
            fi;
          od;
        fi;
      fi;
    od;

    # Reinstall the old value.
    MinimalRepresentationInfoData:= oldvalue;
    MakeReadOnlyGlobal( "MinimalRepresentationInfoData" );

    # Return the new value.
    return newvalue;
    end );


#############################################################################
##
#F  StringOfMinimalRepresentationInfoData( <record> )
##
InstallGlobalFunction( StringOfMinimalRepresentationInfoData,
    function( record )
    local lines, grpname, info, src, infoc, p, i, result, line;

    lines:= [];
    for grpname in Intersection( RecNames( record ),
                       List( AtlasOfGroupRepresentationsInfo.GAPnames,
                             x -> x[1] ) ) do
      info:= record.( grpname );
      if IsBound( info.NrMovedPoints ) then
        for src in info.NrMovedPoints.source do
          Add( lines, [ src{ [ 1 .. 4 ] } = "comp",
                        Concatenation(
                            "[\"", grpname,
                            "\",\"NrMovedPoints\",",
                            String( info.NrMovedPoints.value ),
                            ",\"", src, "\"],\n" ) ] );
        od;
      fi;
      if IsBound( info.Characteristic ) then
        infoc:= info.Characteristic;
        for p in List( Set( List( RecNames( infoc ), Int ) ), String ) do
          for src in infoc.( p ).source do
            Add( lines, [ src{ [ 1 .. 4 ] } = "comp",
                          Concatenation(
                              "[\"", grpname,
                              "\",[\"Characteristic\",", String( p ), "],",
                              String( infoc.( p ).value ),
                              ",\"", src, "\"],\n" ) ] );
          od;
        od;
      fi;
      if IsBound( info.CharacteristicAndSize ) then
        infoc:= info.CharacteristicAndSize;
        for p in List( Set( List( RecNames( infoc ), Int ) ), String ) do
          for i in [ 1 .. Length( infoc.( p ).sizes ) ] do
            for src in infoc.( p ).sources[i] do
              Add( lines, [ src{ [ 1 .. 4 ] } = "comp",
                            Concatenation(
                                "[\"", grpname,
                                "\",[\"Size\",", String( infoc.( p ).sizes[i] ),
                                "],", String( infoc.( p ).dimensions[i] ),
                                ",\"", src, "\"],\n" ) ] );
            od;
          od;
          if infoc.( p ).complete.value then
            for src in infoc.( p ).complete.source do
              Add( lines, [ src{ [ 1 .. 4 ] } = "comp",
                            Concatenation(
                                "[\"", grpname,
                                "\",[\"Characteristic\",", String( p ),
                                ",\"complete\"],true,\"",
                                src, "\"],\n" ) ] );
            od;
          fi;
        od;
      fi;
    od;

    result:= "\nMinimalRepresentationInfoData.datalist:= [\n";
    Append( result, "# non-computed values\n" );
    for line in List( Filtered( lines, l -> not l[1] ), l -> l[2] ) do
      Append( result, line );
    od;
    Append( result, "\n" );
    Append( result, "# computed values\n" );
    for line in List( Filtered( lines, l -> l[1] ), l -> l[2] ) do
      Append( result, line );
    od;
    Append( result, "];;\n\n" );
    Append( result,
            "for entry in MinimalRepresentationInfoData.datalist do\n" );
    Append( result,
            "  CallFuncList( SetMinimalRepresentationInfo, entry );\n" );
    Append( result, "od;\n" );

    return result;
    end );


#############################################################################
##
#E

