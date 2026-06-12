#############################################################################
##
#F  MinimalPermutationRepresentationInfo( <grpname>, <mode> )
##
InstallGlobalFunction( MinimalPermutationRepresentationInfo,
    function( grpname, mode )
    local result, addvalue, parse, ordtbl, identifier, value, s, cand, maxes,
          indices, perms, m, corefreepos, cand1, other, minpos, cand2min,
          tom, faith, mincand, minsubmindeg, subname, subtbl, pi, submindeg,
          fus, n, N, l;

    # Initialize the result values.
    result:= rec( value:= "unknown",
                  source:= [] );
    addvalue:= function( val, src )
      if result.value = "unknown" then
        result.value:= val;
      elif result.value <> val then
        Error( "inconsistent minimal degrees" );
      fi;
      AddSet( result.source, src );
    end;

    # `"A<n>"' and `"A<n>.2"' yield <n>.
    parse:= ParseForwards( grpname, [ "A", IsDigitChar ] );
    if parse <> fail then
      parse:= Int( parse[2] );
      if parse < 3 then
        addvalue( 1, "computed (alternating group)" );
      else
        addvalue( Int( parse ), "computed (alternating group)" );
      fi;
      if mode = "one" then
        return result;
      fi;
    fi;
    parse:= ParseForwards( grpname, [ "A", IsDigitChar, ".2" ] );
    if parse <> fail then
      parse:= Int( parse[2] );
      if parse < 2 then
        Error( grpname, " makes no sense" );
      else
        addvalue( Int( parse ), "computed (symmetric group)" );
      fi;
      if mode = "one" then
        return result;
      fi;
    fi;

    # `"L2(<q>)"' yields $<q>+1$ if $<q> \not\in \{ 2, 3, 5, 7, 9, 11 \}$.
    parse:= ParseForwards( grpname, [ "L2(", IsDigitChar, ")" ] );
    if parse <> fail then
      parse:= Int( parse[2] );
      if   parse in [ 2, 3, 5, 7, 11 ] then
        addvalue( parse, "computed (PSL(2,q))" );
      elif parse = 9 then
        addvalue( 6, "computed (PSL(2,q))" );
      else
        addvalue( parse + 1, "computed (PSL(2,q))" );
      fi;
      if mode = "one" then
        return result;
      fi;
    fi;

    # Use information from the character table from the library.
    ordtbl:= CharacterTable( grpname );
    if IsCharacterTable( ordtbl ) then
      if     HasConstructionInfoCharacterTable( ordtbl )
         and IsList( ConstructionInfoCharacterTable( ordtbl ) )
         and ConstructionInfoCharacterTable( ordtbl )[1]
                 = "ConstructPermuted"
         and Length( ConstructionInfoCharacterTable( ordtbl )[2] ) = 1 then
        # Delegate to another table for which more information is available.
        identifier:= ConstructionInfoCharacterTable( ordtbl )[2][1];
        value:= MinimalRepresentationInfo( identifier, NrMovedPoints );
        if value <> fail then
          addvalue( value.value, Concatenation( "computed (char. table of ",
                                   identifier, ")" ) );
          if mode = "one" then
            return result;
          fi;
        fi;
      else

        # If the first maximal subgroup is known and core-free
        # then take its index. (This happens for simple tables.)
        # (Here we need not assume that the permutation representation of
        # minimal degree is transitive.)
        s:= CharacterTable( Concatenation( Identifier( ordtbl ), "M1" ) );
        if s <> fail and
           Length( ClassPositionsOfKernel( TrivialCharacter( s )^ordtbl ) )
               = 1 then
          addvalue( Size( ordtbl ) / Size( s ), "computed (char. table)" );
          if mode = "one" then
            return result;
          fi;
        fi;

        # If all tables of maximal subgroups are available then inspect them.
        # (We try to avoid assuming that the fusions are stored.)
        if HasMaxes( ordtbl ) then
          maxes:= List( Maxes( ordtbl ), CharacterTable );
          indices:= List( maxes, s -> Size( ordtbl ) / Size( s ) );
          if IsSimpleCharacterTable( ordtbl ) then
            # just a shortcut ...
            addvalue( Minimum( indices ), "computed (char. table)" );
            if mode = "one" then
              return result;
            fi;
          fi;
          perms:= [];
          for m in maxes do
            if GetFusionMap( m, ordtbl ) <> fail then
              Add( perms, TrivialCharacter( m ) ^ ordtbl );
            else
              Add( perms, fail );
            fi;
          od;
          if IsSimpleCharacterTable( ordtbl ) then
            corefreepos:= [ 1 .. Length( perms ) ];
          elif not fail in perms then
            corefreepos:= Filtered( [ 1 .. Length( perms ) ],
                i -> Length( ClassPositionsOfKernel( perms[i] ) ) = 1 );
          else
            corefreepos:= fail;
          fi;

          # If the maximal subgroups of largest order are core-free
          # then we are done.
          if corefreepos <> fail and not IsEmpty( corefreepos ) then
            cand1:= Minimum( indices{ corefreepos } );
            if Minimum( indices ) = cand1 then
              addvalue( cand1, "computed (char. table)" );
              if mode = "one" then
                return result;
              fi;
            fi;
          fi;

          if corefreepos <> fail then
            # If the group has a unique minimal normal subgroup
            # (so the minimal permutation representation is transitive)
            # that is simple and maximal
            # then all candidate subgroups in this normal subgroup
            # are admissible also inside this subgroup;
            # so the candidate indices for point stabilizers inside this
            # normal subgroup are minimal degree times index.
            other:= Difference( [ 1 .. Length( maxes ) ], corefreepos );
            if     Length( other ) = 1
               and IsSimpleCharacterTable( maxes[ other[1] ] ) then
              minpos:= ClassPositionsOfMinimalNormalSubgroups( ordtbl );
              if Length( minpos ) = 1 and
                 ClassPositionsOfKernel( TrivialCharacter( maxes[ other[1] ]
                                         )^ordtbl ) = minpos[1] then
                cand2min:= MinimalRepresentationInfo(
                               Identifier( maxes[ other[1] ] ), NrMovedPoints );
                if IsRecord( cand2min ) then
                  addvalue( Minimum( cand1,
                                     indices[ other[1] ] * cand2min.value ),
                            "computed (char. table)" );
                  if mode = "one" then
                    return result;
                  fi;
                fi;
              fi;
            fi;
          fi;
        fi;
      fi;

      # If the table of marks is known and the minimal permutation
      # representation is transitive then we can compute directly.
      if HasFusionToTom( ordtbl ) and
         Length( ClassPositionsOfMinimalNormalSubgroups( ordtbl ) ) = 1 then
        tom:= TableOfMarks( ordtbl );
        if tom <> fail then
          if IsSimpleCharacterTable( ordtbl ) then
            maxes:= MaximalSubgroupsTom( tom );
            addvalue( Minimum( maxes[2] ), "computed (table of marks)" );
            if mode = "one" then
              return result;
            fi;
          else
            faith:= Filtered( PermCharsTom( ordtbl, tom ),
                        x -> Length( ClassPositionsOfKernel( x ) ) = 1 );
            addvalue( Minimum( List( faith, x -> x[1] ) ),
                      "computed (table of marks)" );
            if mode = "one" then
              return result;
            fi;
          fi;
        fi;
      fi;

      # If we have a subgroup with known minimal degree $n$
      # and a core-free subgroup of index $n$,
      # then $n$ is the minimal degree of $G$.
      mincand:= infinity;
      minsubmindeg:= Maximum( PrimeDivisors( Size( ordtbl ) ) );
      for subname in NamesOfFusionSources( ordtbl ) do
        subtbl:= CharacterTable( subname );
        if subtbl <> fail and IsOrdinaryTable( subtbl ) and
           Length( ClassPositionsOfKernel( GetFusionMap( subtbl, ordtbl ) ) )
               = 1 then
          pi:= TrivialCharacter( subtbl ) ^ ordtbl;
          if Length( ClassPositionsOfKernel( pi ) ) = 1 then
            if pi[1] < mincand then
              mincand:= pi[1];
            fi;
          fi;
          submindeg:= MinimalRepresentationInfo( subname, NrMovedPoints );
          if submindeg <> fail and minsubmindeg < submindeg.value then
            minsubmindeg:= submindeg.value;
          fi;
          if mincand = minsubmindeg then
            addvalue( minsubmindeg, "computed (subgroup tables)" );
            if mode = "one" then
              return result;
            fi;
          fi;
        fi;
      od;

      # If we have a subgroup with known minimal degree $n$
      # and a faithful permutation representation of degree $n$ for $G$
      # then $n$ is the minimal degree of $G$.
      if OneAtlasGeneratingSetInfo( grpname, NrMovedPoints, minsubmindeg )
             <> fail then
        addvalue( minsubmindeg,
                  "computed (subgroup tables, known repres.)" );
        if mode = "one" then
          return result;
        fi;
      fi;

      # If the factor group of $G$ modulo its unique minimal normal subgroup
      # $N$ is simple and has minimal degree $n$,
      # and if we know a subgroup $U$ of index $n |N|$ that intersects $N$
      # trivially then the minimal degree is $n |N|$.
      minpos:= ClassPositionsOfMinimalNormalSubgroups( ordtbl );
      if Length( minpos ) = 1 then
        fus:= First( ComputedClassFusions( ordtbl ),
                     r -> ClassPositionsOfKernel( r.map ) = minpos[1] );
        if fus <> fail then
          n:= MinimalRepresentationInfo( fus.name, NrMovedPoints );
          if n <> fail then
            N:= Sum( SizesConjugacyClasses( ordtbl ){ minpos[1] } );
            for subname in NamesOfFusionSources( ordtbl ) do
              subtbl:= CharacterTable( subname );
              if subtbl <> fail and IsOrdinaryTable( subtbl ) and
                 Size( ordtbl ) = Size( subtbl ) * n.value then
                fus:= GetFusionMap( subtbl, ordtbl );
                if Length( ClassPositionsOfKernel( fus ) ) = 1 then
                  for l in ClassPositionsOfDirectProductDecompositions(
                               subtbl ) do
                    if ForAny( l,
                         x -> Sum( SizesConjugacyClasses( subtbl ){ x } )
                                = Size( subtbl ) / N 
                              and Intersection( fus{ x }, minpos[1] )
                                    = [ 1 ] ) then
                      addvalue( N * n.value, "computed (factor table)" );
                      if mode = "one" then
                        return result;
                      fi;
                    fi;
                  od;
                fi;
              fi;
            od;
          fi;
        fi;
      fi;
    fi;

    return result;
    end );

