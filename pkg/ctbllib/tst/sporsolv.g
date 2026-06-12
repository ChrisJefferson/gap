# This file was created from xpl/sporsolv.xpl, do not edit!
#############################################################################
##
#W  sporsolv.g          GAP 4 package `ctbllib'                 Thomas Breuer
##

MaximalSolvableSubgroupInfoFromTom:= function( name )
    local tom,          # table of marks for `name'
          n,            # maximal order of a solvable subgroup
          maxsubs,      # numbers of the classes of subgroups of order `n'
          orders,       # list of orders of the classes of subgroups
          i,            # loop over the classes of subgroups
          maxes,        # list of positions of the classes of max. subgroups
          subs,         # `SubsTom' value
          cont;         # list of list of positions of max. subgroups

    tom:= TableOfMarks( name );
    if tom = fail then
      return false;
    fi;
    n:= 1;
    maxsubs:= [];
    orders:= OrdersTom( tom );
    for i in [ 1 .. Length( orders ) ] do
      if IsSolvableTom( tom, i ) then
        if orders[i] = n then
          Add( maxsubs, i );
        elif orders[i] > n then
          n:= orders[i];
          maxsubs:= [ i ];
        fi;
      fi;
    od;
    maxes:= MaximalSubgroupsTom( tom )[1];
    subs:= SubsTom( tom );
    cont:= List( maxsubs, j -> Filtered( maxes, i -> j in subs[i] ) );

    return [ name, n, List( cont, l -> orders{ l } ) ];
end;;


SolvableSubgroupInfoFromCharacterTable:= function( tblM, minorder )
    local maxindex,  # index of subgroups of order `minorder'
          N,         # class positions describing a solvable normal subgroup
          fact,      # character table of the factor by `N'
          classes,   # class sizes in `fact'
          nsg,       # list of class positions of normal subgroups
          i;         # loop over the possible indices

    maxindex:= Int( Size( tblM ) / minorder );
    if   maxindex = 0 then
      return false;
    elif IsSolvableCharacterTable( tblM ) then
      return [ tblM, maxindex, 1 ];
    elif maxindex < 5 then
      return false;
    fi;

    N:= [ 1 ];
    fact:= tblM;
    repeat
      fact:= fact / N;
      classes:= SizesConjugacyClasses( fact );
      nsg:= Difference( ClassPositionsOfNormalSubgroups( fact ), [ [ 1 ] ] );
      N:= First( nsg, x -> IsPrimePowerInt( Sum( classes{ x } ) ) );
    until N = fail;

    for i in [ 5 .. maxindex ] do
      if Length( PermChars( fact, rec( torso:= [ i ] ) ) ) > 0 then
        return [ tblM, maxindex, i ];
      fi;
    od;

    return false;
end;;


#############################################################################
##
#E

