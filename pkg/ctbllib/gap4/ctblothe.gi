#############################################################################
##
#W  ctblothe.gi          GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains the declarations of functions for interfaces to
##  other data formats of character tables.
##
##  1. interface to CAS
##  2. interface to MOC
##  3. interface to GAP 3
##  4. interface to the Cambridge format
##  5. Interface to the MAGMA display format
##


#############################################################################
##
##  1. interface to CAS
##


#############################################################################
##
#F  CASString( <tbl> )
##
InstallGlobalFunction( CASString, function( tbl )
    local ll,                 # line length
          CAS,                # the string, result
          i, j,               # loop variables
          convertcyclotom,    # local function, string of cyclotomic
          convertrow,         # local function, convert a whole list
          column,
          param,              # list of class parameters
          fus,                # loop over fusions
          tbl_irredinfo;

    ll:= SizeScreen()[1];

    if HasIdentifier( tbl ) then                        # name
      CAS:= Concatenation( "'", Identifier( tbl ), "'\n" );
    else
      CAS:= "'NN'\n";
    fi;
    Append( CAS, "00/00/00. 00.00.00.\n" );             # date
    if HasSizesCentralizers( tbl ) then                 # nccl, cvw, ctw
      Append( CAS, "(" );
      Append( CAS, String( Length( SizesCentralizers( tbl ) ) ) );
      Append( CAS, "," );
      Append( CAS, String( Length( SizesCentralizers( tbl ) ) ) );
      Append( CAS, ",0," );
    else
      Append( CAS, "(0,0,0," );
    fi;

    if HasIrr( tbl ) then
      Append( CAS, String( Length( Irr( tbl ) ) ) );    # max
      Append( CAS, "," );
      if Length( Irr( tbl ) ) = Length( Set( Irr( tbl ) ) ) then
        Append( CAS, "-1," );                           # link
      else
        Append( CAS, "0," );                            # link
      fi;
    fi;
    Append( CAS, "0)\n" );                              # tilt
    if HasInfoText( tbl ) then                          # text
      Append( CAS, "text:\n(#" );
      Append( CAS, InfoText( tbl ) );
      Append( CAS, "#),\n" );
    fi;

    convertcyclotom:= function( cyc )
    local i, str, coeffs;
    coeffs:= COEFFS_CYC( cyc );
    str:= Concatenation( "\n<w", String( Length( coeffs ) ), "," );
    if coeffs[1] <> 0 then
      Append( str, String( coeffs[1] ) );
    fi;
    i:= 2;
    while i <= Length( coeffs ) do
      if Length( str ) + Length( String( coeffs[i] ) )
                       + Length( String( i-1 ) ) + 4 >= ll then
        Append( CAS, str );
        Append( CAS, "\n" );
        str:= "";
      fi;
      if coeffs[i] < 0 then
        Append( str, "-" );
        if coeffs[i] <> -1 then
          Append( str, String( -coeffs[i] ) );
        fi;
        Append( str, "w" );
        Append( str, String( i-1 ) );
      elif coeffs[i] > 0 then
        Append( str, "+" );
        if coeffs[i] <> 1 then
          Append( str, String( coeffs[i] ) );
        fi;
        Append( str, "w" );
        Append( str, String( i-1 ) );
      fi;
      i:= i+1;
    od;
    Append( CAS, str );
    Append( CAS, "\n>\n" );
    end;

    convertrow:= function( list )
    local i, str;
    if IsCycInt( list[1] ) and not IsInt( list[1] ) then
      convertcyclotom( list[1] );
      str:= "";
    elif IsUnknown( list[1] ) or IsList( list[1] ) then
      str:= "?";
    else
      str:= ShallowCopy( String( list[1] ) );
    fi;
    i:= 2;
    while i <= Length( list ) do
      if IsCycInt( list[i] ) and not IsInt( list[i] ) then
        Append( CAS, str );
        Append( CAS, "," );
        convertcyclotom( list[i] );
        str:= "";
      elif IsUnknown( list[i] ) or IsList( list[i] ) then
        if Length( str ) + 4 < ll then
          Append( str, ",?" );
        else
          Append( CAS, str );
          Append( CAS, ",?\n" );
          str:= "";
        fi;
      else
        if Length(str) + Length( String(list[i]) ) + 5 < ll then
          Append( str, "," );
          Append( str, String( list[i] ) );
        else
          Append( CAS, str );
          Append( CAS, ",\n" );
          str:= ShallowCopy( String( list[i] ) );
        fi;
      fi;
      i:= i+1;
    od;
    Append( CAS, str );
    Append( CAS, "\n" );
    end;

    Append( CAS, "order=" );                            # order
    Append( CAS, String( Size( tbl ) ) );
    if HasSizesCentralizers( tbl ) then                 # centralizers
      Append( CAS, ",\ncentralizers:(\n" );
      convertrow( SizesCentralizers( tbl ) );
      Append( CAS, ")" );
    fi;
    if HasOrdersClassRepresentatives( tbl ) then        # orders
      Append( CAS, ",\nreps:(\n" );
      convertrow( OrdersClassRepresentatives( tbl ) );
      Append( CAS, ")" );
    fi;
    if HasComputedPowerMaps( tbl ) then                 # power maps
      for i in [ 1 .. Length( ComputedPowerMaps( tbl ) ) ] do
        if IsBound( ComputedPowerMaps( tbl )[i] ) then
          Append( CAS, ",\npowermap:" );
          Append( CAS, String(i) );
          Append( CAS, "(\n" );
          convertrow( ComputedPowerMaps( tbl )[i] );
          Append( CAS, ")" );
        fi;
      od;
    fi;
    if HasClassParameters( tbl )                        # classtext
       and ForAll( ClassParameters( tbl ),              # (partitions only)
                   x ->     IsList( x ) and Length( x ) = 2
                        and x[1] = 1 and IsList( x[2] )
                        and ForAll( x[2], IsPosInt ) ) then
      Append( CAS, ",\nclasstext:'part'\n($[" );
      param:= ClassParameters( tbl );
      convertrow( param[1][2] );
      Append( CAS, "]$" );
      for i in [ 2 .. Length( param ) ] do
        Append( CAS, "\n,$[" );
        convertrow( param[i][2] );
        Append( CAS, "]$" );
      od;
      Append( CAS, ")" );
    fi;
    if HasComputedClassFusions( tbl ) then              # fusions
      for fus in ComputedClassFusions( tbl ) do
        if IsBound( fus.type ) then
          if fus.type = "normal" then
            Append( CAS, ",\nnormal subgroup " );
          elif fus.type = "factor" then
            Append( CAS, ",\nfactor " );
          else
            Append( CAS, ",\n" );
          fi;
        else
          Append( CAS, ",\n" );
        fi;
        Append( CAS, "fusion:'" );
        Append( CAS, fus.name );
        Append( CAS, "'(\n" );
        convertrow( fus.map );
        Append( CAS, ")" );
      od;
    fi;
    if HasIrr( tbl ) then                              # irreducibles
      Append( CAS, ",\ncharacters:" );
      for i in Irr( tbl ) do
        Append( CAS, "\n(" );
        convertrow( i );
        Append( CAS, ",0:0)" );
      od;
    fi;
    if HasComputedPrimeBlockss( tbl ) then             # blocks
      for i in [ 2 .. Length( ComputedPrimeBlockss( tbl ) ) ] do
        if IsBound( ComputedPrimeBlockss( tbl )[i] ) then
          Append( CAS, ",\nblocks:" );
          Append( CAS, String( i ) );
          Append( CAS, "(\n" );
          convertrow( ComputedPrimeBlockss( tbl )[i] );
          Append( CAS, ")" );
        fi;
      od;
    fi;
    if HasComputedIndicators( tbl ) then               # indicators
      for i in [ 2 .. Length( ComputedIndicators( tbl ) ) ] do
        if IsBound( ComputedIndicators( tbl )[i] ) then
          Append( CAS, ",\nindicator:" );
          Append( CAS, String( i ) );
          Append( CAS, "(\n" );
          convertrow( ComputedIndicators( tbl )[i] );
          Append( CAS, ")" );
        fi;
      od;
    fi;
    if 27 < ll then
      Append( CAS, ";\n/// converted from GAP" );
    else
      Append( CAS, ";\n///" );
    fi;
    return CAS;
end );


#############################################################################
##
##  2. interface to MOC
##


#############################################################################
##
#F  MOCFieldInfo( <F> )
##
##  For a number field <F>,
##  'MOCFieldInfo' returns a record with the following components.
##
##  'nofcyc':
##      the conductor of <F>,
##
##  'repres':
##      a list of orbit representatives forming the Parker base of <F>,
##
##  'stabil':
##      a smallest generating system of the stabilizer, and
##
##  'ParkerBasis':
##      the Parker basis of <F>.
##
BindGlobal( "MOCFieldInfo", function( F )
    local i, j, n, orbits, stab, cycs, coeffs, base, repres, rank, max, pos,
          sub, sub2, stabil, elm, numbers, orb, orders, gens;

    if F = Rationals then
      return rec(
                  nofcyc      := 1,
                  repres      := [ 0 ],
                  stabil      := [],
                  ParkerBasis := Basis( Rationals )
                 );
    fi;

    n:= Conductor( F );

    # representatives of orbits under the action of 'GaloisStabilizer( F )'
    # on '[ 0 .. n-1 ]'
    numbers:= [ 0 .. n-1 ];
    orbits:= [];
    stab:= GaloisStabilizer( F );
    while not IsEmpty( numbers ) do
      orb:= Set( List( numbers[1] * stab, x -> x mod n ) );
      Add( orbits, orb );
      SubtractSet( numbers, orb );
    od;

    # orbit sums under the corresponding action on 'n'--th roots of unity
    cycs:= List( orbits, x -> Sum( x, y -> E(n)^y, 0 ) );
    coeffs:= List( cycs, x -> CoeffsCyc( x, n ) );

    # Compute the Parker basis.
    gens:= [ 1 ];
    base:= [ coeffs[1] ];
    repres:= [ 0 ];
    rank:= 1;

    for i in [ 1 .. Length( coeffs ) ] do
      if rank < RankMat( Union( base, [ coeffs[i] ] ) ) then
        rank:= rank + 1;
        Add( gens, cycs[i] );
        Add( base, coeffs[i] );
        Add( repres, orbits[i][1] );
      fi;
    od;

    # Compute a small generating system for the stabilizer:
    # Start with the empty generating system.
    # Add the smallest number of maximal multiplicative order to
    # the generating system, remove all points in the new group.
    # Proceed until one has a generating system for the stabilizer.
    orders:= List( stab, x -> OrderMod( x, n ) );
    orders[1]:= 0;
    max:= Maximum( orders );
    stabil:= [];
    sub:= [ 1 ];
    while max <> 0 do
      pos:= Position( orders, max );
      elm:= stab[ pos ];
      AddSet( stabil, elm );
      sub2:= sub;
      for i in [ 1 .. max-1 ] do
        sub2:= Union( sub2, List( sub, x -> ( x * elm^i ) mod n ) );
      od;
      sub:= sub2;
      for j in sub do
        orders[ Position( stab, j ) ]:= 0;
      od;
      max:= Maximum( orders );
    od;

    return rec(
                nofcyc      := n,
                repres      := repres,
                stabil      := stabil,
                ParkerBasis := Basis( F, gens )
               );
    end );


#############################################################################
##
#F  MAKElb11( <listofns> )
##
InstallGlobalFunction( MAKElb11, function( listofns )
    local n, f, k, j, fields, info, num, stabs;

    # 12 entries per row
    num:= 12;

    for n in listofns do

      if n > 2 and n mod 4 <> 2 then

        fields:= Filtered( Subfields( CF(n) ), x -> Conductor( x ) = n );
        fields:= List( fields, MOCFieldInfo );
        stabs:=  List( fields,
                       x -> Concatenation( [ x.nofcyc, Length( x.repres ),
                                           Length(x.stabil) ], x.stabil ) );
        fields:= List( fields,
                       x -> Concatenation( [ x.nofcyc, Length( x.repres ) ],
                                           x.repres, [ Length( x.stabil ) ],
                                           x.stabil ) );

        # sort fields according to degree and stabilizer generators
        fields:= Permuted( fields, Sortex( stabs ) );
        for f in fields do
          for k in [ 0 .. QuoInt( Length( f ), num ) - 1 ] do
            for j in [ 1 .. num ] do
              Print( String( f[ k*num + j ], 4 ) );
            od;
            Print( "\n " );
          od;
          for j in [ num * QuoInt( Length(f), num ) + 1 .. Length(f) ] do
            Print( String( f[j], 4 ) );
          od;
          Print( "\n" );
        od;

      fi;

    od;
end );


#############################################################################
##
#F  MOCPowerInfo( <listofbases>, <galoisfams>, <powermap>, <prime> )
##
##  For a list <listofbases> of number field bases as produced in
##  'MOCTable' (see~"MOCTable"),
##  the information of labels '30220' and '30230' is computed.
##  This is a sequence
##  $$
##  x_{1,1} x_{1,2} \ldots x_{1,m_1} 0 x_{2,1} x_{2,2} \ldots x_{2,m_2}
##  0 \ldots 0 x_{n,1} x_{n,2} \ldots x_{n,m_n} 0
##  $$
##  with the followong meaning.
##  Let $[ a_1, a_2, \ldots, a_n ]$ be a character in MOC format.
##  The value of the character obtained on indirection by the <prime>-th
##  power map at position $i$ is
##  $$
##  x_{i,1} a_{x_{i,2}} + x_{i,3} a_{x_{i,4}} + \ldots
##  + x_{i,m_i-1} a_{x_{i,m_i}} \ .
##  $$
##
##  The information is computed as follows.
##
##  If $g$ and $g^{<prime>}$ generate the same cyclic group then write the
##  <prime>-th conjugates of the base vectors $v_1, \ldots, v_k$ as
##  $\tilde{v_i} = \sum_{j=1}^{k} c_{ij} v_j$.
##  The $j$-th coefficient of the <prime>-th conjugate of
##  $\sum_{i=1}^{k} a_i v_i$ is then $\sum_{i=1}^{k} a_i c_{ij}$.
##
##  If $g$ and $g^{<prime>}$ generate different cyclic groups then write the
##  base vectors $w_1, \ldots, w_{k^{\prime}}$ in terms of the $v_i$ as
##  $w_i = \sum_{j=1}^{k} c_{ij} v_j$.
##  The $v_j$-coefficient of the indirection of
##  $\sum_{i=1}^{k^{\prime}} a_i w_i$ is then
##  $\sum_{i=1}^{k^{\prime}} a_i c_{ij}$.
##
##  For $<prime> = -1$ (complex conjugation) we have of course
##  $k = k^{\prime}$ and $w_i = \overline{v_i}$.
##  In this case the parameter <powermap> may have any value.
##  Otherwise <powermap> must be the 'ComputedPowerMaps' value of the
##  underlying character table;
##  for any Galois automorphism of a cyclic subgroup,
##  it must contain a map covering this automorphism.
##
##  <galoisfams> is a list that describes the Galois conjugacy;
##  its format is equal to that of the 'galoisfams' component in
##  records returned by 'GaloisMat'.
##
##  'MOCPowerInfo' returns a list containing the information for <prime>,
##  the part of class 'i' is stored in a list at position 'i'.
##
##  *Note* that 'listofbases' refers to all classes, not only
##  representatives of cyclic subgroups;
##  non-leader classes of Galois families must have value 0.
##
BindGlobal( "MOCPowerInfo",
    function( listofbases, galoisfams, powermap, prime )
    local power, i, f, c, im, oldim, imf, pp, entry, j, n, k;

    power:= [];
    i:= 1;
    while i <= Length( listofbases ) do

      if (     IsBasis( listofbases[i] )
           and UnderlyingLeftModule( listofbases[i] ) = Rationals )
         or listofbases[i] = 1 then

        # rational class
        if prime = -1 then
          Add( power, [ 1, i, 0 ] );
        else

          # 'prime'-th power of class 'i' (of course rational)
          Add( power, [ 1, powermap[ prime ][i], 0 ] );

        fi;

      elif listofbases[i] <> 0 then

        # the field basis
        f:= listofbases[i];

        if prime = -1 then

          # the coefficient matrix
          c:= List( BasisVectors( f ),
                    x -> Coefficients( f, GaloisCyc( x, -1 ) ) );
          im:= i;

        else

          # the image class and field
          oldim:= powermap[ prime ][i];
          if galoisfams[ oldim ] = 1 then
            im:= oldim;
          else
            im:= 1;
            while not IsList( galoisfams[ im ] ) or
                  not oldim in galoisfams[ im ][1] do
              im:= im+1;
            od;
          fi;

          if listofbases[ im ] = 1 then

            # maps to rational class 'im'
            c:= [ Coefficients( f, 1 ) ];

          elif im = i then

            # just Galois conjugacy
            c:= List( BasisVectors( f ),
                      x -> Coefficients( f, GaloisCyc(x,prime) ) );

          else

            # compute embedding of the image field
            imf:= listofbases[ im ];
            pp:= false;
            for j in [ 2 .. Length( powermap ) ] do
              if IsBound( powermap[j] ) and powermap[j][ im ] = oldim then
                pp:= j;
              fi;
            od;
            if pp = false then
              Error( "MOCPowerInfo cannot compute Galois autom. for ", im,
                     " -> ", oldim, " from power map" );
            fi;

            c:= List( BasisVectors( imf ),
                      x -> Coefficients( f, GaloisCyc(x,pp) ) );

          fi;

        fi;

        # the power info for column 'i' of the MOC table,
        # and all other columns in the same cyclic subgroup
        entry:= [];
        n:= Length( c );
        for j in [ 1 .. Length( c[1] ) ] do
          for k in [ 1 .. n ] do
            if c[k][j] <> 0 then
              Append( entry, [ c[k][j], im + k - 1 ] );
#T this assumes that Galois families are subsequent!
            fi;
          od;
          Add( entry, 0 );
        od;
        Add( power, entry );

      fi;
      i:= i+1;
    od;
    return power;
end );


#############################################################################
##
#F  ScanMOC( <list> )
##
InstallGlobalFunction( ScanMOC, function( list )
    local digits, positive, negative, specials,
          admissible,
          number,
          pos, result,
          scannumber2,     # scan a number in MOC 2 format
          scannumber3,     # scan a number in MOC 3 format
          label, component;

    # Check the argument.
    if not IsList( list ) then
      Error( "argument must be a list" );
    fi;

    # Define some constants used for MOC 3 format.
    digits:= "0123456789";
    positive:= "abcdefghij";
    negative:= "klmnopqrs";
    specials:= "tuvwyz";

    # Remove characters that are nonadmissible, for example line breaks.
    admissible:= Union( digits, positive, negative, specials );
    list:= Filtered( list, char -> char in admissible );

    # local functions: scan a number of MOC 2 or MOC 3 format
    scannumber2:= function()
    number:= 0;
    while list[ pos ] < 10000 do

      # number is not complete
      number:= 10000 * number + list[ pos ];
      pos:= pos + 1;
    od;
    if list[ pos ] < 20000 then
      number:= 10000 * number + list[ pos ] - 10000;
    else
      number:= - ( 10000 * number + list[ pos ] - 20000 );
    fi;
    pos:= pos + 1;
    return number;
    end;

    scannumber3:= function()
    number:= 0;
    while list[ pos ] in digits do

      # number is not complete
      number:=  10000 * number
               + 1000 * Position( digits, list[ pos   ] )
               +  100 * Position( digits, list[ pos+1 ] )
               +   10 * Position( digits, list[ pos+2 ] )
               +        Position( digits, list[ pos+3 ] )
               - 1111;
      pos:= pos + 4;
    od;

    # end of number or small number
    if list[ pos ] in positive then

      # small positive number
      if number <> 0 then
        Error( "corrupted input" );
      fi;
      number:=   10000 * number
               + Position( positive, list[ pos ] )
               - 1;

    elif list[ pos ] in negative then

      # small negative number
      if number <> 0 then
        Error( "corrupted input" );
      fi;
      number:=   10000 * number
               - Position( negative, list[ pos ] );

    elif   list[ pos ] = 't' then
      number:=   10000 * number
               + 10 * Position( digits, list[ pos+1 ] )
               +      Position( digits, list[ pos+2 ] )
               - 11;
      pos:= pos + 2;
    elif list[ pos ] = 'u' then
      number:=   10000 * number
               - 10 * Position( digits, list[ pos+1 ] )
               -      Position( digits, list[ pos+2 ] )
               + 11;
      pos:= pos + 2;
    elif list[ pos ] = 'v' then
      number:=   10000 * number
               + 1000 * Position( digits, list[ pos+1 ] )
               +  100 * Position( digits, list[ pos+2 ] )
               +   10 * Position( digits, list[ pos+3 ] )
               +        Position( digits, list[ pos+4 ] )
               - 1111;
      pos:= pos + 4;
    elif list[ pos ] = 'w' then
      number:= - 10000 * number
               - 1000 * Position( digits, list[ pos+1 ] )
               -  100 * Position( digits, list[ pos+2 ] )
               -   10 * Position( digits, list[ pos+3 ] )
               -        Position( digits, list[ pos+4 ] )
               + 1111;
      pos:= pos + 4;
    fi;
    pos:= pos + 1;
    return number;
    end;

    # convert <list>
    result:= rec();
    pos:= 1;

    if IsInt( list[1] ) then

      # MOC 2 format
      if list[1] = 30100 then pos:= 2; fi;
      while pos <= Length( list ) and list[ pos ] <> 31000 do
        label:= list[ pos ];
        pos:= pos + 1;
        component:= [];
        while pos <= Length( list ) and list[ pos ] < 30000 do
          Add( component, scannumber2() );
        od;
        result.( label ):= component;
      od;

    else

      # MOC 3 format
      if list{ [ 1 .. 4 ] } = "y100" then
        pos:= 5;
      fi;

      while pos <= Length( list ) and list[ pos ] <> 'z' do

        # label of form 'yABC'
        label:= list{ [ pos .. pos+3 ] };
        pos:= pos + 4;
        component:= [];
        while pos <= Length( list ) and not list[ pos ] in "yz" do
          Add( component, scannumber3() );
        od;
        result.( label ):= component;
      od;
    fi;

    return result;
end );


#############################################################################
##
#F  MOCChars( <tbl>, <gapchars> )
##
InstallGlobalFunction( MOCChars, function( tbl, gapchars )
    local i, result, chi, MOCchi;

    # take the MOC format (if necessary, construct the MOC format table first)
    if IsCharacterTable( tbl ) then
      tbl:= MOCTable( tbl );
    fi;

    # translate the characters
    result:= [];
    for chi in gapchars do
      MOCchi:= [];
      for i in [ 1 .. Length( tbl.fieldbases ) ] do
        if UnderlyingLeftModule( tbl.fieldbases[i] ) = Rationals then
          Add( MOCchi, chi[ tbl.repcycsub[i] ] );
        else
          Append( MOCchi, Coefficients( tbl.fieldbases[i],
                                        chi[ tbl.repcycsub[i] ] ) );
        fi;
      od;
      Add( result, MOCchi );
    od;
    return result;
end );


#############################################################################
##
#F  GAPChars( <tbl>, <mocchars> )
##
InstallGlobalFunction( GAPChars, function( tbl, mocchars )
    local i, j, val, result, chi, GAPchi, map, pos, numb, nccl;

    # take the MOC format table (if necessary, construct it first)
    if IsCharacterTable( tbl ) then
      tbl:= MOCTable( tbl );
    fi;

    # 'map[i]' is the list of columns of the MOC table that belong to
    # the 'i'-th cyclic subgroup of the MOC table
    map:= [];
    pos:= 0;
    for i in [ 1 .. Length( tbl.fieldbases ) ] do
      Add( map, pos + [ 1 .. Length( BasisVectors( tbl.fieldbases[i] ) ) ] );
      pos:= pos + Length( BasisVectors( tbl.fieldbases[i] ) );
    od;

    result:= [];

    # if 'mocchars' is not a list of lists, divide it into pieces of length
    # 'nccl'
    if not IsList( mocchars[1] ) then
      nccl:= NrConjugacyClasses( tbl.GAPtbl );
      mocchars:= List( [ 1 .. Length( mocchars ) / nccl ],
                       i -> mocchars{ [ (i-1)*nccl+1 .. i*nccl ] } );
    fi;

    for chi in mocchars do
      GAPchi:= [];
      # loop over classes of the GAP table
      for i in [ 1 .. Length( tbl.galconjinfo ) / 2 ] do

        # the number of the cyclic subgroup in the MOC table
        numb:= tbl.galconjinfo[ 2*i - 1 ];
        if UnderlyingLeftModule( tbl.fieldbases[ numb ] ) = Rationals then

          # rational class
          GAPchi[i]:= chi[ map[ tbl.galconjinfo[ 2*i-1 ] ][1] ];

        elif tbl.galconjinfo[ 2*i ] = 1 then

          # representative of cyclic subgroup, not rational
          GAPchi[i]:= chi{ map[ numb ] }
                      * BasisVectors( tbl.fieldbases[ numb ] );

        else

          # irrational class, no representative:
          # conjugate the value on the representative class
          GAPchi[i]:=
             GaloisCyc( GAPchi[ ( Position( tbl.galconjinfo, numb ) + 1 ) / 2 ],
                        tbl.galconjinfo[ 2*i ] );

        fi;
      od;
      Add( result, GAPchi );
    od;
    return result;
end );


#############################################################################
##
#F  MOCTable0( <gaptbl> )
##
##  MOC 3 format table of ordinary GAP table <gaptbl>
##
BindGlobal( "MOCTable0", function( gaptbl )
    local i, j, k, d, n, p, result, trans, gal, extendedfields, entry,
          gaptbl_orders, vectors, prod, pow, im, cl, basis, struct, rep,
          aut, primes;

    # initialize the record
    result:= rec( identifier := Concatenation( "MOCTable(",
                                               Identifier( gaptbl ), ")" ),
                  prime  := 0,
                  fields := [],
                  GAPtbl := gaptbl );

    # 1. Compute necessary information to encode the irrational columns.
    #
    #    Each family of $n$ Galois conjugate classes is replaced by $n$
    #    integral columns, the Parker basis of each number field
    #    is stored in the component 'fieldbases' of the result.
    #
    trans:= TransposedMat( Irr( gaptbl ) );
    gal:= GaloisMat( trans ).galoisfams;

    result.cycsubgps:= [];
    result.repcycsub:= [];
    result.galconjinfo:= [];
    for i in [ 1 .. Length( gal ) ] do
      if gal[i] = 1 then
        Add( result.repcycsub, i );
        result.cycsubgps[i]:= Length( result.repcycsub );
        Append( result.galconjinfo, [ Length( result.repcycsub ), 1 ] );
      elif gal[i] <> 0 then
        Add( result.repcycsub, i );
        n:= Length( result.repcycsub );
        for k in gal[i][1] do
          result.cycsubgps[k]:= n;
        od;
        Append( result.galconjinfo, [ Length( result.repcycsub ), 1 ] );
      else
        rep:= result.repcycsub[ result.cycsubgps[i] ];
        aut:= gal[ rep ][2][ Position( gal[ rep ][1], i ) ]
                 mod Conductor( trans[i] );
        Append( result.galconjinfo, [ result.cycsubgps[i], aut ] );
      fi;
    od;

    gaptbl_orders:= OrdersClassRepresentatives( gaptbl );

    # centralizer orders and element orders
    # (for representatives of cyclic subgroups only)
    result.centralizers:= SizesCentralizers( gaptbl ){ result.repcycsub };
    result.orders:= OrdersClassRepresentatives( gaptbl ){ result.repcycsub };

    # the fields (for cyclic subgroups only)
    result.fieldbases:= List( result.repcycsub,
                        i -> MOCFieldInfo( Field( trans[i] ) ).ParkerBasis );

    # fields for all classes (used by 'MOCPowerInfo')
    extendedfields:= List( [ 1 .. Length( gal ) ], x -> 0 );
    for i in [ 1 .. Length( result.repcycsub ) ] do
      extendedfields[ result.repcycsub[i] ]:= result.fieldbases[i];
    od;

    # '30170' power maps:
    # for each cyclic subgroup (except the trivial one) and each prime
    # divisor of the representative order store four values, the number
    # of the subgroup, the power, the number of the cyclic subgroup
    # containing the image, and the power to which the representative
    # must be raised to give the image class.
    # (This is used only to construct the '30230' power map/embedding
    # information.)
    # In 'result.30170' only a list of lists (one for each cyclic subgroup)
    # of all these values is stored, it will not be used by GAP.
    #
    result.30170:= [ [] ];
    for i in [ 2 .. Length( result.repcycsub ) ] do

      entry:= [];
      for d in PrimeDivisors( gaptbl_orders[ result.repcycsub[i] ] ) do

        # cyclic subgroup 'i' to power 'd'
        Add( entry, i );
        Add( entry, d );
        pow:= PowerMap( gaptbl, d )[ result.repcycsub[i] ];

        if gal[ pow ] = 1 then

          # rational class
          Add( entry, Position( result.repcycsub, pow ) );
          Add( entry, 1 );

        else

          # get the representative 'im'
          im:= result.repcycsub[ result.cycsubgps[ pow ] ];
          cl:= Position( gal[ im ][1], pow );

          # the image is class 'im' to power 'gal[ im ][2][cl]'
          Add( entry, Position( result.repcycsub, im ) );
          Add( entry, gal[ im ][2][cl]
                              mod gaptbl_orders[ result.repcycsub[i] ] );

        fi;

      od;

      Add( result.30170, entry );

    od;

    # tensor product information, used to compute the coefficients of
    # the Parker base for tensor products of characters.
    result.tensinfo:= [];
    for basis in result.fieldbases do
      if UnderlyingLeftModule( basis ) = Rationals then
        Add( result.tensinfo, [ 1 ] );
      else
        vectors:= BasisVectors( basis );
        n:= Length( vectors );

        # Compute structure constants.
        struct:= List( vectors, x -> [] );
        for i in [ 1 .. n ] do
          for k in [ 1 .. n ] do
            struct[k][i]:= [];
          od;
          for j in [ 1 .. n ] do
            prod:= Coefficients( basis, vectors[i] * vectors[j] );
            for k in [ 1 .. n ] do
              struct[k][i][j]:= prod[k];
            od;
          od;
        od;

        entry:= [ n ];
        for i in [ 1 .. n ] do
          for j in [ 1 .. n ] do
            for k in [ 1 .. n ] do
              if struct[i][j][k] <> 0 then
                Append( entry, [ struct[i][j][k], j, k ] );
              fi;
            od;
          od;
          Add( entry, 0 );
        od;
        Add( result.tensinfo, entry );
      fi;
    od;

    # '30220' inverse map (to compute complex conjugate characters)
    result.invmap:= MOCPowerInfo( extendedfields, gal, 0, -1 );

    # '30230' power map (field embeddings for $p$-th symmetrizations,
    # where $p$ is a prime not larger than the maximal element order);
    # note that the necessary power maps must be stored on 'gaptbl'
    result.powerinfo:= [];
    primes:= Filtered( [ 2 .. Maximum( gaptbl_orders ) ], IsPrimeInt );
    for p in primes do
      PowerMap( gaptbl, p );
    od;
    for p in primes do
      result.powerinfo[p]:= MOCPowerInfo( extendedfields, gal,
                                          ComputedPowerMaps( gaptbl ), p );
    od;

    # '30900': here all irreducible characters
    result.30900:= MOCChars( result, Irr( gaptbl ) );

    return result;
end );


#############################################################################
##
#F  MOCTableP( <gaptbl>, <basicset> )
##
##  MOC 3 format table of GAP Brauer table <gaptbl>,
##  with basic set of ordinary irreducibles at positions in
##  'Irr( OrdinaryCharacterTable( <gaptbl> ) )' given in the list <basicset>
##
BindGlobal( "MOCTableP", function( gaptbl, basicset )
    local i, j, p, result, fusion, mocfusion, images, ordinary, fld, pblock,
          invpblock, ppart, ord, degrees, defect, deg, charfusion, pos,
          repcycsub, ncharsperblock, restricted, invcharfusion, inf, mapp,
          gaptbl_classes;

    # check the arguments
    if not ( IsBrauerTable( gaptbl ) and IsList( basicset ) ) then
      Error( "<gaptbl> must be a Brauer character table,",
             " <basicset> must be a list" );
    fi;

    # transfer information from ordinary MOC table to 'result'
    ordinary:= MOCTable0( OrdinaryCharacterTable( gaptbl ) );
    fusion:= GetFusionMap( gaptbl, OrdinaryCharacterTable( gaptbl ) );
    images:= Set( ordinary.cycsubgps{ fusion } );

    # initialize the record
    result:= rec( identifier := Concatenation( "MOCTable(",
                                               Identifier( gaptbl ), ")" ),
                  prime  := UnderlyingCharacteristic( gaptbl ),
                  fields := [],
                  ordinary:= ordinary,
                  GAPtbl := gaptbl );

    result.cycsubgps:= List( fusion,
                   x -> Position( images, ordinary.cycsubgps[x] ) );
    repcycsub:= ProjectionMap( result.cycsubgps );
    result.repcycsub:= repcycsub;

    mocfusion:= CompositionMaps( ordinary.cycsubgps, fusion );

    # fusion map to restrict characters from 'ordinary' to 'result'
    charfusion:= [];
    pos:= 1;
    for i in [ 1 .. Length( result.cycsubgps ) ] do
      Add( charfusion, pos );
      pos:= pos + 1;
      while pos <= NrConjugacyClasses( result.ordinary.GAPtbl ) and
            OrdersClassRepresentatives( result.ordinary.GAPtbl )[ pos ]
                mod result.prime = 0 do
        pos:= pos + 1;
      od;
    od;

    result.fusions:= [ rec( name:= ordinary.identifier, map:= charfusion ) ];
    invcharfusion:= InverseMap( charfusion );

    result.galconjinfo:= [];
    for i in fusion do
      Append( result.galconjinfo,
              [ Position( images, ordinary.galconjinfo[ 2*i-1 ] ),
                ordinary.galconjinfo[ 2*i ] ] );
    od;

    for fld in [ "centralizers", "orders", "fieldbases", "30170",
                 "tensinfo", "invmap" ] do
      result.( fld ):= List( result.repcycsub,
                             i -> ordinary.( fld )[ mocfusion[i] ] );
    od;

    mapp:= InverseMap( CompositionMaps( ordinary.cycsubgps,
               CompositionMaps( charfusion,
                   InverseMap( result.cycsubgps ) ) ) );
    for i in [ 2 .. Length( result.30170 ) ] do
      for j in 2 * [ 1 .. Length( result.30170[i] ) / 2 ] - 1 do
        result.30170[i][j]:= mapp[ result.30170[i][j] ];
      od;
    od;


    result.powerinfo:= [];
    for p in Filtered( [ 2 .. Maximum( ordinary.orders ) ], IsPrimeInt ) do

      inf:= List( result.repcycsub,
                  i -> ordinary.powerinfo[p][ mocfusion[i] ] );
      for i in [ 1 .. Length( inf ) ] do
        pos:= 2;
        while pos < Length( inf[i] ) do
          while inf[i][ pos + 1 ] <> 0 do
            inf[i][ pos ]:= invcharfusion[ inf[i][ pos ] ];
            pos:= pos + 2;
          od;
          inf[i][ pos ]:= invcharfusion[ inf[i][ pos ] ];
          pos:= pos + 3;
        od;
      od;
      result.powerinfo[p]:= inf;

    od;

    # '30310' number of $p$-blocks
    pblock:= PrimeBlocks( OrdinaryCharacterTable( gaptbl ),
                          result.prime ).block;
    invpblock:= InverseMap( pblock );
    for i in [ 1 .. Length( invpblock ) ] do
      if IsInt( invpblock[i] ) then
        invpblock[i]:= [ invpblock[i] ];
      fi;
    od;
    result.30310:= Maximum( pblock );

    # '30320' defect, numbers of ordinary and modular characters per block
    result.30320:= [ ];
    ppart:= 0;
    ord:= Size( gaptbl );
    while ord mod result.prime = 0 do
      ppart:= ppart + 1;
      ord:= ord / result.prime;
    od;

    for i in [ 1 .. Length( invpblock ) ] do
      defect:= result.prime ^ ppart;
      for j in invpblock[i] do
        deg:= Irr( OrdinaryCharacterTable( gaptbl ) )[j][1];
        while deg mod defect <> 0 do
          defect:= defect / result.prime;
        od;
      od;
      restricted:= List( Irr( OrdinaryCharacterTable( gaptbl )
                         ){ invpblock[i] },
                         x -> x{ fusion } );

      # Form the scalar product on $p$-regular classes.
      gaptbl_classes:= SizesConjugacyClasses( gaptbl );
      ncharsperblock:= Sum( restricted,
          y -> Sum( [ 1 .. Length( gaptbl_classes ) ],
                    i -> gaptbl_classes[i] * y[i]
                             * GaloisCyc( y[i], -1 ) ) ) / Size( gaptbl );

      Add( result.30320,
           [ ppart - Length( FactorsInt( defect ) ),
             Length( invpblock[i] ),
             ncharsperblock ] );
    od;

    # '30350' distribution of ordinary irreducibles to blocks
    #         (irreducible character number 'i' has number 'i')
    result.30350:= List( invpblock, ShallowCopy);

    # '30360' distribution of basic set characters to blocks:
    result.30360:= List( invpblock,
                         x -> List( Intersection( x, basicset ),
                                    y -> Position( basicset, y ) ) );

    # '30370' positions of basic set characters in irreducibles (per block)
    result.30370:= List( invpblock, x -> Intersection( x, basicset ) );

    # '30550' decomposition of ordinary irreducibles in basic set
    basicset:= Irr( ordinary.GAPtbl ){ basicset };
    basicset:= MOCChars( result, List( basicset, x -> x{ fusion } ) );
    result.30550:= DecompositionInt( basicset,
                          List( ordinary.30900, x -> x{ charfusion } ), 30 );

    # '30900' basic set of restricted ordinary irreducibles,
    result.30900:= basicset;

    return result;
end );


#############################################################################
##
#F  MOCTable( <ordtbl> )
#F  MOCTable( <modtbl>, <basicset> )
##
InstallGlobalFunction( MOCTable, function( arg )
    if Length( arg ) = 1 and IsOrdinaryTable( arg[1] ) then
      return MOCTable0( arg[1] );
    elif Length( arg ) = 2 and IsBrauerTable( arg[1] )
                           and IsList( arg[2] ) then
      return MOCTableP( arg[1], arg[2] );
    else
      Error( "usage: MOCTable( <ordtbl> ) resp.",
                   " MOCTable( <modtbl>, <basicset> )" );
    fi;
end );


#############################################################################
##
#F  MOCString( <moctbl>[, <chars>] )
##
InstallGlobalFunction( MOCString, function( arg )
    local str,                     # result string
          i, j, d, p,              # loop variables
          tbl,                     # first argument
          ncol, free,              # number of columns for printing
          lettP, lettN, digit,     # lists of letters for encoding
          Pr, PrintNumber,         # local functions for printing
          trans, gal,
          repcycsub,
          ord,                     # corresponding ordinary table
          fus, invfus,             # transfer between ord. and modular table
          restr,                   # restricted ordinary irreducibles
          basicset, BS,            # numbers in basic set, basic set itself
          aut, gallist, fields,
          F,
          pow, im, cl,
          info, chi,
          dec;

    # 1. Preliminaries:
    #    initialisations, local functions needed for encoding and printing
    str:= "";

    # number of columns for printing
    ncol:= 80;
    free:= ncol;

    # encode numbers in '[ -9 .. 9 ]' as letters
    lettP:= "abcdefghij";
    lettN:= "klmnopqrs";
    digit:= "0123456789";

    # local function 'Pr':
    # Append 'string' in lines of length 'ncol'
    Pr:= function( string )
    local len;
    len:= Length( string );
    if len <= free then
      Append( str, string );
      free:= free - len;
    else
      if 0 < free then
        Append( str, string{ [ 1 .. free ] } );
        string:= string{ [ free+1 .. len ] };
      fi;
      Append( str, "\n" );
      for i in [ 1 .. Int( ( len - free ) / ncol ) ] do
        Append( str, string{ [ 1 .. ncol ] }, "\n" );
        string:= string{ [ ncol+1 .. Length( string ) ] };
      od;
      free:= ncol - Length( string );
      if free <> ncol then
        Append( str, string );
      fi;
    fi;
    end;

    # local function 'PrintNumber': print MOC3 code of number 'number'
    PrintNumber:= function( number )
    local i, sumber, sumber1, sumber2, len, rest;
    sumber:= String( AbsInt( number ) );
    len:= Length( sumber );
    if len > 4 then

      # long number, fill with leading zeros
      rest:= len mod 4;
      if rest = 0 then
        rest:= 4;
      fi;
      for i in [ 1 .. 4-rest ] do
        sumber:= Concatenation( "0", sumber );
        len:= len+1;
      od;

      sumber1:= sumber{ [ 1 .. len - 4 ] };
      sumber2:= sumber{ [ len - 3 .. len ] };

      # code of last digits is always 'vABCD' or 'wABCD'
      if number >= 0 then
        sumber:= Concatenation( sumber1, "v", sumber2 );
      else
        sumber:= Concatenation( sumber1, "w", sumber2 );
      fi;

    else

      # short numbers (up to 9999), encode the last digits
      if len = 1 then
        if number >= 0 then
          sumber:= [ lettP[ Position( digit, sumber[1] )     ] ];
        else
          sumber:= [ lettN[ Position( digit, sumber[1] ) - 1 ] ];
        fi;
      elif len = 2 then
        if number >= 0 then
          sumber:= Concatenation( "t", sumber );
        else
          sumber:= Concatenation( "u", sumber );
        fi;
      elif len = 3 then
        if number >= 0 then
          sumber:= Concatenation( "v0", sumber );
        else
          sumber:= Concatenation( "w0", sumber );
        fi;
      else
        if number >= 0 then
          sumber:= Concatenation( "v", sumber );
        else
          sumber:= Concatenation( "w", sumber );
        fi;
      fi;
    fi;

    # print the code in lines of length 'ncol'
    Pr( sumber );
    end;

    if Length( arg ) = 1 and IsMatrix( arg[1] ) then

      # number of columns
      Pr( "y110" );
      PrintNumber( Length( arg[1] ) );
      PrintNumber( Length( arg[1] ) );

      # matrix entries under label '30900'
      Pr( "y900" );
      for i in arg[1] do
        for j in i do
          PrintNumber( j );
        od;
      od;

      Pr( "z" );

    elif not ( Length( arg ) in [ 1, 2 ] and IsRecord( arg[1] ) and
             ( Length( arg ) = 1 or IsList( arg[2] ) ) ) then
      Error( "usage: MOCString( <moctbl>[, <chars>] )" );
    else

      tbl:= arg[1];

      # '30100' start of the table
      Pr( "y100" );

      # '30105' characteristic of the field
      Pr( "y105" );
      PrintNumber( tbl.prime );

      # '30110' number of p-regular classes and of cyclic subgroups
      Pr( "y110" );
      PrintNumber( Length( SizesCentralizers( tbl.GAPtbl ) ) );
      PrintNumber( Length( tbl.centralizers ) );

      # '30130' centralizer orders
      Pr( "y130" );
      for i in tbl.centralizers do PrintNumber( i ); od;

      # '30140' representative orders of cyclic subgroups
      Pr( "y140" );
      for i in tbl.orders do PrintNumber( i ); od;

      # '30150' field information
      Pr( "y150" );

      # loop over cyclic subgroups
      for i in tbl.fieldbases do
        if UnderlyingLeftModule( i ) = Rationals then
          PrintNumber( 1 );
        else
          F:= MOCFieldInfo( UnderlyingLeftModule( i ) );
          PrintNumber( F.nofcyc );           # $\Q(e_N)$ is the conductor
          PrintNumber( Length( F.repres ) ); # degree of the field
          for j in F.repres do
            PrintNumber( j );                # representatives of the orbits
          od;
          PrintNumber( Length( F.stabil ) ); # no. generators for stabilizer
          for j in F.stabil do
            PrintNumber( j );                # generators for stabilizer
          od;
        fi;
      od;

      # '30160' galconjinfo of classes:
      Pr( "y160" );
      for i in tbl.galconjinfo do PrintNumber( i ); od;

      # '30170' power maps
      Pr( "y170" );
      for i in Flat( tbl.30170 ) do PrintNumber( i ); od;

      # '30210' tensor product information
      Pr( "y210" );
      for i in Flat( tbl.tensinfo ) do PrintNumber( i ); od;

      # '30220' inverse map (to compute complex conjugate characters)
      Pr( "y220" );
      for i in Flat( tbl.invmap ) do PrintNumber( i ); od;

      # '30230' power map (field embeddings for $p$-th symmetrizations,
      # where $p$ is a prime not larger than the maximal element order);
      # note that the necessary power maps must be stored on 'tbl'
      Pr( "y230" );
      for p in [ 1 .. Length( tbl.powerinfo ) - 1 ] do
        if IsBound( tbl.powerinfo[p] ) then
          PrintNumber( p );
          for j in Flat( tbl.powerinfo[p] ) do PrintNumber( j ); od;
          Pr( "y050" );
        fi;
      od;
      # no '30050' at the end!
      p:= Length( tbl.powerinfo );
      PrintNumber( p );
      for j in Flat( tbl.powerinfo[p] ) do PrintNumber( j ); od;

      # '30310' number of p-blocks
      if IsBound( tbl.30310 ) then
        Pr( "y310" );
        PrintNumber( tbl.30310 );
      fi;

      # '30320' defect, number of ordinary and modular characters per block
      if IsBound( tbl.30320 ) then
        Pr( "y320" );
        for i in tbl.30320 do
          PrintNumber( i[1] );
          PrintNumber( i[2] );
          PrintNumber( i[3] );
          Pr( "y050" );
        od;
      fi;

      # '30350' relative numbers of ordinary characters per block
      if IsBound( tbl.30350 ) then
        Pr( "y350" );
        for i in tbl.30350 do
          for j in i do PrintNumber( j ); od;
          Pr( "y050" );
        od;
      fi;

      # '30360' distribution of basic set characters to blocks:
      #         relative numbers in the basic set
      if IsBound( tbl.30360 ) then
        Pr( "y360" );
        for i in tbl.30360 do
          for j in i do PrintNumber( j ); od;
          Pr( "y050" );
        od;
      fi;

      # '30370' relative numbers of basic set characters (blockwise)
      if IsBound( tbl.30370 ) then
        Pr( "y370" );
        for i in tbl.30370 do
          for j in i do PrintNumber( j ); od;
          Pr( "y050" );
        od;
      fi;

      # '30500' matrices of scalar products of Brauer characters with PS
      #         (per block)
      if IsBound( tbl.30500 ) then
        Pr( "y700" );
        for i in tbl.30700 do
          for j in Concatenation( i ) do PrintNumber( j ); od;
          Pr( "y050" );
        od;
      fi;

      # '30510' absolute numbers of '30500' characters
      if IsBound( tbl.30510 ) then
        Pr( "y510" );
        for i in tbl.30510 do PrintNumber( i ); od;
      fi;

      # '30550' decomposition of ordinary characters into basic set
      if IsBound( tbl.30550 ) then
        Pr( "y550" );
        for i in Concatenation( tbl.30550 ) do
          PrintNumber( i );
        od;
      fi;

      # '30590' ??
      # '30690' ??

      # '30700' matrices of scalar products of PS with BS (per block)
      if IsBound( tbl.30700 ) then
        Pr( "y700" );
        for i in tbl.30700 do
          for j in Concatenation( i ) do PrintNumber( j ); od;
          Pr( "y050" );
        od;
      fi;

      # '30710'
      if IsBound( tbl.30710 ) then
        Pr( "y710" );
        for i in tbl.30710 do PrintNumber( i ); od;
      fi;

      # '30900' basic set of restricted ordinary irreducibles,
      #         or characters in <chars>
      Pr( "y900" );
      if Length( arg ) = 2 then

        # case 'MOCString( <tbl>, <chars> )'
        for chi in arg[2] do
          for i in chi do PrintNumber( i ); od;
        od;

      elif IsBound( tbl.30900 ) then

        # case 'MOCString( <tbl> )'
        for i in Concatenation( tbl.30900 ) do PrintNumber( i ); od;

      fi;

      # '31000' end of table
      Pr( "z\n" );

    fi;

    # Return the result.
    return str;
end );


#############################################################################
##
##  3. interface to GAP 3
##


#############################################################################
##
#V  GAP3CharacterTableData
##
##  The pair '[ "group", "UnderlyingGroup" ]' is not contained in the list
##  because GAP 4 expects that together with the group, conjugacy classes
##  are stored compatibly with the ordering of columns in the table;
##  in GAP 3, conjugacy classes were not supported as a part of character
##  tables.
##
InstallValue( GAP3CharacterTableData, [
    [ "automorphisms", "AutomorphismsOfTable" ],
    [ "centralizers", "SizesCentralizers" ],
    [ "classes", "SizesConjugacyClasses" ],
    [ "fusions", "ComputedClassFusions" ],
    [ "fusionsources", "NamesOfFusionSources" ],
    [ "identifier", "Identifier" ],
    [ "irreducibles", "Irr" ],
    [ "name", "Name" ],
    [ "orders", "OrdersClassRepresentatives" ],
    [ "permutation", "ClassPermutation" ],
    [ "powermap", "ComputedPowerMaps" ],
    [ "size", "Size" ],
    [ "text", "InfoText" ],
    ] );


#############################################################################
##
#F  GAP3CharacterTableScan( <string> )
##
InstallGlobalFunction( GAP3CharacterTableScan, function( string )
    local gap3table, gap4table, pair;

    # Remove the substring '\\\n', which may split component names.
    string:= ReplacedString( string, "\\\n", "" );

    # Remove the variable name 'CharTableOps', which GAP 4 does not know.
    string:= ReplacedString( string, "CharTableOps", "0" );

    # Get the GAP 3 record encoded by the string.
    gap3table:= EvalString( string );

    # Fill the GAP 4 record.
    gap4table:= rec( UnderlyingCharacteristic:= 0 );
    for pair in GAP3CharacterTableData do
      if IsBound( gap3table.( pair[1] ) ) then
        gap4table.( pair[2] ):= gap3table.( pair[1] );
      fi;
    od;

    return ConvertToCharacterTable( gap4table );
    end );


#############################################################################
##
#F  GAP3CharacterTableString( <tbl> )
##
InstallGlobalFunction( GAP3CharacterTableString, function( tbl )
    local str, pair, val;

    str:= "rec(\n";
    for pair in GAP3CharacterTableData do
      if Tester( ValueGlobal( pair[2] ) )( tbl ) then
        val:= ValueGlobal( pair[2] )( tbl );
        Append( str, pair[1] );
        Append( str, " := " );
        if pair[1] in [ "name", "text", "identifier" ] then
          Append( str, "\"" );
          Append( str, String( val ) );
          Append( str, "\"" );
        elif pair[1] = "irreducibles" then
          Append( str, "[\n" );
          Append( str, JoinStringsWithSeparator(
              List( val, chi -> String( ValuesOfClassFunction( chi ) ) ),
              ",\n" ) );
          Append( str, "\n]" );
        elif pair[1] = "automorphisms" then
          # There is no 'String' method for groups.
          Append( str, "Group( " );
          Append( str, String( GeneratorsOfGroup( val ) ) );
          Append( str, ", () )" );
        else
#T what about "cliffordTable"?
#T (special function 'PrintCliffordTable' in GAP 3)
          Append( str, String( val ) );
        fi;
        Append( str, ",\n" );
      fi;
    od;
    Append( str, "operations := CharTableOps )\n" );

    return str;
    end );


#############################################################################
##
##  4. interface to the Cambridge format
##


#############################################################################
##
#F  CTblLib.GalConj( <n>, <N>, <k> )
##
##  returns the value <M>k'</M> defined in
##  Chapter 7, Section 19 of the &ATLAS; of Finite Groups
##  (but be careful what exactly is said there).
##  This value is used to construct follower characters and classes.
##  <P/>
##  <A>N</A>, <A>n</A> and <A>k</A> are as in the &ATLAS;,
##  and <M>k'</M> is congruent <M>1</M> mod <M>N / ( 2part \* 3part )</M>,
##  congruent <M>\pm 1</M> mod '2part' and congruent <M>\pm 1</M>
##  mod '3part'.
##  This yields three nontrivial solutions mod <A>N</A>,
##  we consider only those with <M>k'</M> congruent <A>k</A> mod <A>n</A>,
##  and if there is an ambiguity left,
##  we prefer the solution congruent <M>+1</M>.
##  (R. Parker says: <Q>+1 is better than -1.</Q>)
##  <P/>
##  Note that <A>n</A> must lie in <M>[ 3, 4, 5, 6, 12 ]</M>.
##  Also note that the &ATLAS; of Brauer Characters defines
##  another convention for follower cohorts of characters.
##
CTblLib.GalConj:= function( n, N, k )
    local i, j, facts, pos, 2part, 3part, 5part, a, b, c, d, kprime,
          g, gcd, gcd2;

    if N = 1 or k = 1 then
      return 1;
    elif n = 5 then
      5part:= 1;
      for i in FactorsInt( N ) do
        if i = 5 then
          5part:= 5 * 5part;
        fi;
      od;

      for kprime in List( [ 0 .. Int( N-1-k / 5 ) ], x -> k + x * 5 ) do
        if Gcd( kprime, N ) = 1 and ( kprime - 1 ) mod ( N / 5part ) = 0
           and ( kprime^4 - 1 ) mod 5part = 0 then
          return kprime mod N;
        fi;
      od;
    elif 12 mod n = 0 then
      facts:= FactorsInt( N );
      2part:= 1;
      3part:= 1;
      for i in facts do
        if i = 2 then
          2part:= 2 * 2part;
        elif i = 3 then
          3part:= 3 * 3part;
        fi;
      od;

      # x congr. u (mod M) and x congr. v (mod N)
      # with 1 = Gcd( M, N ) = a * M + b * N
      # yields the solution x = u * b * N + v * a * M (mod M * N)
      gcd:= Gcdex( N / 3part, 3part );
      c:= gcd.coeff1; d:= gcd.coeff2;
      kprime:= ( d * 3part - c * N / 3part );   #  1 ( mod N / 3part )
                                                # -1 ( mod 3part )
      if ( kprime - k ) mod n = 0 then
        return kprime mod N;
      else
        gcd2:= Gcdex( N / ( 2part * 3part ), 2part );
        a:= gcd2.coeff1;
        b:= gcd2.coeff2;
        g:= b * 2part - a * N / ( 2part * 3part );    #  g ( mod N / 3part )
                                                      # -1 ( mod 2part )
        kprime:= ( g * d * 3part + c * N / 3part );   #  1 ( mod 3part )
        if ( kprime - k ) mod n = 0 then
          return kprime mod N;
        else
          kprime:= ( g * d * 3part - c * N / 3part );  # -1 ( mod 3part )
                                                       # -1 ( mod 2part )
          if ( kprime - k ) mod n = 0 then
            return kprime mod N;
          else
            Error( "GalConj(n,N,k) with n=", n, " N=", N, " k=", k );
          fi;
        fi;
      fi;
    else
      Error( "CTblLib.GalConj is implemented only for ",
             "n in [ 2, 3, 4, 5, 6, 12 ]" );
    fi;
    end;


#############################################################################
##
#F  CTblLib.CommonCambridgeMaps( <tbls> )
##
##  We assume that
##  - <tbls> is a dense list that describes the tables of
##    cyclic upward extensions of a simple group,
##  - the first entry is the table of this simple group,
##  - the tables occur in the same order as in the &ATLAS;, and
##  - inner classes precede outer ones, as in the &ATLAS;.
##
CTblLib.CommonCambridgeMaps:= function( tbls )
    local alpha, lalpha, name, tbl, char, names, power, prime, choice,
          number, letters, i, orders, galois, n, lin, root, outerclasses,
          fus, follower, j, k, ord, nam, dashes, pos, tr, galoismat, inverse,
          stabilizers, entry, family, residues, n0, resorders, aut, p, div,
          gcd, po, img, found, subtbl, subfus;

    alpha:= [ "A","B","C","D","E","F","G","H","I","J","K","L","M",
              "N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ];
    lalpha:= Length( alpha );

    name:= function( n )
      local m;
      if n <= lalpha then
        return alpha[n];
      else
        m:= (n-1) mod lalpha + 1;
        return Concatenation( alpha[m], String( ( n - m ) / lalpha ) );
      fi;
    end;

    tbl:= tbls[1];
    char:= UnderlyingCharacteristic( tbl );

    names:= [];
    power:= [];
    prime:= [];
    choice:= [];
    number:= [];
    letters:= [];

    for i in [ 1 .. Length( tbls ) ] do

      names[i]:= [];
      power[i]:= [];
      prime[i]:= [];
      choice[i]:= [];

      if tbls[i] <> fail and
         ( char = 0 or ( Size( tbls[i] ) / Size( tbl ) ) mod char <> 0 ) then

        # Compute absolute names for the outer classes.
        orders:= OrdersClassRepresentatives( tbls[i] );
        galois:= GaloisMat( TransposedMat( Irr( tbls[i] ) ) ).galoisfams;

        if i = 1 then
          n:= NrConjugacyClasses( tbl );
          lin:= [ ListWithIdenticalEntries( n, 1 ) ];
          root:= 1;
          choice[i]:= [ 1 .. n ];
          outerclasses:= [ 1 .. n ];
        else
          fus:= GetFusionMap( tbl, tbls[i] );
          if fus = fail then
            Error( "fusion tbls[1] -> tbls[", i, "] is not stored" );
          fi;
          lin:= Filtered( Irr( tbls[i] ),
                          x -> x[1] = 1 and Set( x{ fus } ) = [ 1 ] );
          n:= Length( lin );
          if not n in [ 2 .. 6 ] then
            Error( "only cyclic upwards extensions by [ 2, 3, 4, 5, 6 ] ",
                   "are supported" );
          fi;
          lin:= First( lin, x -> E(n) in x );
          outerclasses:= PositionsProperty( lin, x -> Order( x ) = n );
          root:= lin[ outerclasses[1] ];
          choice[i]:= Positions( lin, root );
          if n <> 2 then
            follower:= [];
            for j in choice[i] do
              follower[j]:= [];
              for k in PrimeResidues( n ) do
                if k <> 1 then
                  follower[j][k]:= CTblLib.GalConj( n, orders[j], k );
                fi;
              od;
            od;
          fi;
        fi;

        for j in choice[i] do
          ord:= orders[j];
          if not IsBound( number[ ord ] ) then
            number[ ord ]:= 1;
          fi;
          nam:= Concatenation( String( ord ), name( number[ ord ] ) );
          number[ ord ]:= number[ ord ] + 1;
          names[i][j]:= nam;
          if not IsInt( root ) then
            dashes:= "'";
            for k in follower[j] do
              pos:= PowerMap( tbls[i], k )[j];
              if IsBound( names[i][ pos ] ) then
                Error( "names[i][ pos ] is bound, this should not happen!" );
              fi;
              names[i][ pos ]:= Concatenation( nam, dashes );
              Add( dashes, '\'' );
            od;
          fi;
        od;

        # Compute relative class names.
        # Note that the relative names for non-leading classes in a family
        # of algebraically conjugate classes are chosen only if the classes
        # of the family are consecutive.
        tr:= TransposedMat( Irr( tbls[i] ) );
        galoismat:= GaloisMat( tr );
        galois:= galoismat.galoisfams;
        inverse:= InverseClasses( tbls[i] );
        letters[i]:= List( names[i],
          x -> x{ [ PositionProperty( x, IsAlphaChar ) .. Length( x ) ] } );

        stabilizers:= [];
        for j in [ 1 .. Length( galois ) ] do
          if IsList( galois[j] ) then
            entry:= galois[j][1][1];
            stabilizers[j]:= Filtered( PrimeResidues( orders[ entry ] ),
                x -> GaloisCyc( tr[ entry ], x ) = tr[ entry ] );
          fi;
        od;

        for j in outerclasses do
          # Adjust class names for consecutive families of alg. conjugates.
          if IsList( galois[j] ) then
            family:= SortedList( galois[j][1] );
            n:= orders[ galois[j][1][1] ];
            residues:= PrimeResidues( n );
            n0:= Conductor( tr[ galois[j][1][1] ] );
            if not ( n0 = 9 and Length( family ) = 3  ) then
              # (For 'y9' type irrationalities, use '*2' and '*4'.)
              resorders:= List( residues, x -> OrderMod( x, n ) );
              SortParallel( resorders, residues );
            fi;

            if family = [ family[1] .. family[ Length( family ) ] ] then
              for k in [ 2 .. Length( galois[j][1] ) ] do
                if not '\'' in names[i][ galois[j][1][k] ] then
                  if galois[j][1][k] = inverse[j] then
                    # Use '**' whenever this is possible.
                    aut:= "**";
                  elif Length( galois[j][1] ) = 2 * Phi( Order( root ) ) then
                    # Use '*' in real quadratic cases, or if at least the
                    # restriction to proxy classes/characters is quadratic.
                    aut:= "*";
                  else
                    # The powering computed by 'GaloisMat' refers to the
                    # conductor of the character values on the class,
                    # it need not be coprime to the element order;
                    # rewrite this.
                    aut:= galois[j][2][k] mod n;
                    if Gcd( aut, n ) <> 1 then
                      aut:= aut mod n0;
                      aut:= First( residues, x -> x mod n0 = aut );
                      if aut = fail then
                        Error( "problem with prime residues!" );
                      fi;
                    fi;

                    # Choose '*k' with 'k' of smallest possible mult. order.
                    # (Note that 'residues' is ordered accordingly.)
                    aut:= First( residues,
                                 x -> ( x / aut ) mod n in stabilizers[j] );

                  fi;

                  if IsString( aut ) then
                    names[i][ galois[j][1][k] ]:=
                        Concatenation( letters[i][ galois[j][1][k] ], aut );
                  else
                    # We have no negative 'aut' yet.
                    names[i][ galois[j][1][k] ]:= aut;
                  fi;
                fi;
              od;

              # Adjust the names such that '**k' occur if applicable.
              # If ** occurs, then together with *k also **k occurs,
              # except if this string is longer than *(n-k)
              if inverse[ family[1] ] <> family[1] then
                # Run over the pairs of complex conjugate classes,
                # except the leading pair.
                for k in family do
                  if k < inverse[k] and IsInt( names[i][k] ) then
                    if names[i][k] < names[i][ inverse[k] ] and
                       Length( String( names[i][k] ) ) + 1
                       <= Length( String( names[i][ inverse[k] ] ) ) then
                      names[i][ inverse[k] ]:= - names[i][k];
                    elif names[i][k] > names[i][ inverse[k] ] and
                       Length( String( names[i][ inverse[k] ] ) ) + 1
                       <= Length( String( names[i][k] ) ) then
                      names[i][k]:= - names[i][ inverse[k] ];
                    fi;
                  fi;
                od;
              fi;

              # Finally set the relative class names.
              for k in [ 2 .. Length( galois[j][1] ) ] do
                entry:= galois[j][1][k];
                if IsInt( names[i][ entry ] ) then
                  aut:= names[i][ entry ];
                  if 0 < aut then
                    names[i][ entry ]:= Concatenation( letters[i][ entry ],
                                            "*", String( aut ) );
                  else
                    names[i][ entry ]:= Concatenation( letters[i][ entry ],
                                            "**", String( -aut ) );
                  fi;
                fi;
              od;

            fi;
          fi;
        od;

        # Deal with the lines for power maps and p' part.
        for j in choice[i] do
          power[i][j]:= "";
          prime[i][j]:= "";
          if orders[j] <> 1 then
            for p in PrimeDivisors( orders[j] ) do
              div:= orders[j];
              while div mod p = 0 do
                div:= div / p;
              od;
              gcd:= Gcdex( div, orders[j] / div );
              po:= orders[j] / div * gcd.coeff2;
              if po <= 0 then
                po:= po + orders[j];
              fi;

              img:= PowerMap( tbls[i], p, j );
              if IsBound( letters[i][ img ] ) then
                Append( power[i][j], letters[i][ img ] );
              else
                found:= false;
                for k in [ 1 .. i-1 ] do
                  subtbl:= tbls[k];
                  if subtbl <> fail then
                    subfus:= GetFusionMap( subtbl, tbls[i] );
                    if subfus <> fail and img in subfus then
                      found:= true;
                      Append( power[i][j],
                              letters[k][ Position( subfus, img ) ] );
                      break;
                    fi;
                  fi;
                od;
                if not found then
                  Append( power[i][j], "?" );
                fi;
              fi;
              img:= PowerMap( tbls[i], po, j );
              if IsBound( letters[i][ img ] ) then
                Append( prime[i][j], letters[i][ img ] );
              else
                found:= false;
                for k in [ 1 .. i-1 ] do
                  subtbl:= tbls[k];
                  if subtbl <> fail then
                    subfus:= GetFusionMap( subtbl, tbls[i] );
                    if subfus <> fail and img in subfus then
                      found:= true;
                      Append( prime[i][j],
                              letters[k][ Position( subfus, img ) ] );
                      break;
                    fi;
                  fi;
                od;
                if not found then
                  Append( prime[i][j], "?" );
                fi;
              fi;
            od;
          fi;
        od;
      fi;
    od;

    # Return the result.
    return rec( power  := List( power, l -> List( l,
                                    x -> Filtered( x, y -> y <> '\'' ) ) ),
                prime  := List( prime, l -> List( l,
                                    x -> Filtered( x, y -> y <> '\'' ) ) ),
                names  := names,
                choice := choice );
end;


#############################################################################
##
#F  CambridgeMaps( <tbl> )
##
InstallGlobalFunction( CambridgeMaps, function( tbl )
    local orders,      # representative orders of 'tbl'
          classnames,  # (relative) class names in ATLAS format
          letters,     # non-order parts of 'classnames'
          galois,      # info about algebraic conjugacy
          inverse,     # positions of inverse classes
          power,       # ATLAS line for the power map
          prime,       # ATLAS line for the p' parts
          i,           # loop variable
          family,      # one family of algebraic conjugates
          j,           # loop variable
          aut,         # one relative class name
          div,         # help variable for p' parts
          gcd,         # help variable for p' parts
          po;          # help variable for p' parts

    # Compute the list of class names in ATLAS format.
    # Note that the relative names for non-leading classes in a family of
    # algebraically conjugate classes are chosen only if the classes of the
    # family are consecutive.
    orders:= OrdersClassRepresentatives( tbl );
    classnames:= ShallowCopy( ClassNames( tbl, "ATLAS" ) );
    letters:= List( classnames,
        x -> x{ [ PositionProperty( x, IsAlphaChar ) .. Length( x ) ] } );
    galois:= GaloisMat( TransposedMat( Irr( tbl ) ) ).galoisfams;
    inverse:= InverseClasses( tbl );
    power:= [""];
    prime:= [""];
    for i in [ 2 .. Length( galois ) ] do

      # 1. Adjust class names for consecutive families of alg. conjugates.
      if IsList( galois[i] ) then
        family:= SortedList( galois[i][1] );
        if family = [ family[1] .. family[ Length( family ) ] ] then
          for j in [ 2 .. Length( galois[i][1] ) ] do
            aut:= galois[i][2][j] mod orders[i];
            if galois[i][1][j] = inverse[i] then
              aut:= "*";                            # '**'
            elif Length( galois[i][1] ) = 2 then
              aut:= "";                             # '*'
            elif 2 * aut > orders[i] then
              aut:= String( orders[i] - aut );      # '**k' or '*k'(if real)
              if inverse[i] <> i then
                aut:= Concatenation( "*", aut );  # not real
              fi;
            else
              aut:= String( aut );                  # '*k'
            fi;
            classnames[ galois[i][1][j] ]:=
               Concatenation( letters[ galois[i][1][j] ], "*", aut );
          od;
        fi;
      fi;

      # 2. Deal with the lines for power maps and p' part.
      power[i]:= "";
      prime[i]:= "";
      for j in PrimeDivisors( orders[i] ) do

        div:= orders[i];
        while div mod j = 0 do
          div:= div / j;
        od;
        gcd:= Gcdex( div, orders[i] / div );
        po:= orders[i] / div * gcd.coeff2;
        if po <= 0 then
          po:= po + orders[i];
        fi;

        Append( power[i], letters[ PowerMap( tbl, j, i ) ] );
        Append( prime[i], letters[ PowerMap( tbl, po, i ) ] );

      od;

    od;

    # Return the result.
    return rec( power := power,
                prime := prime,
                names := classnames );
end );


#############################################################################
##
#F  CTblLib.ScanCambridgeFormatFile( <filename> )
#F  CTblLib.ScanCambridgeFormatFile( <tblname>, <string> )
##
CTblLib.ScanCambridgeFormatFile:= function( arg )
    local name, str, result, line, prevprefix, pos, prefix, currline;

    if Length( arg ) = 1 then
      name:= arg[1];
      str:= InputTextFile( name );
      result:= rec( filename:= name );
      if str = fail then
        Print( "file '", name, "' does not exist\n" );
        return result;
      fi;
    elif Length( arg ) = 2 then
      name:= arg[1];
      str:= InputTextString( arg[2] );
      result:= rec();
    fi;

    # Run once over the lines.
    line:= Chomp( ReadLine( str ) );
    prevprefix:= "";
    while line <> fail do
      NormalizeWhitespace( line );
      if line = "" then
        # This should in fact not happen.
      elif line[1] = '#' then
        pos:= Position( line, ' ' );
        if pos = fail then
          pos:= Length( line ) + 1;
        fi;
        prefix:= line{ [ 1 .. pos-1 ] };
        currline:= line{ [ pos+1 .. Length( line ) ] };
        if not IsBound( result.( prefix ) ) then
          result.( prefix ):= [ [ currline ] ];
        elif prefix <> prevprefix then
          Add( result.( prefix ), [ currline ] );
        else
          Add( result.( prefix )[ Length( result.( prefix ) ) ], currline );
        fi;
        prevprefix:= prefix;
      else
        Append( currline, " " );
        Append( currline, line );
      fi;
      line:= Chomp( ReadLine( str ) );
    od;

    return result;
end;


#############################################################################
##
#F  StringOfCambridgeFormat( <tblnames>[, <p>][: OmitDashedRows] )
#F  StringOfCambridgeFormat( <simpname>[, <p>][: OmitDashedRows] )
#F  StringOfCambridgeFormat( <tbls> ) . . . . . . . . backwards compatibility
##
InstallGlobalFunction( StringOfCambridgeFormat, function( arg )
    local msg, p, r, tblnames, tbls, i, j, tbl, nccl, linelength, ttbls, id,
          centralizers, maps, maps_power, maps_prime, maps_names, hash9,
          convertindicators, convertcharacters, out, chars, lifts,
          dashedlifts, galorbs, extendDashedLifts, omitdashedrows, multdash,
          tblperf, irr, phi, mult, proj, cohorts, factfus, inv, k, roots,
          projperf, orders, entry, ind2, ext, outerdash, pos,
          symbol, undashed, centre, line, subfus, brokenbox, nams,
          not_consecutive_fusions, outerirr, rest, scpr, outerchi, outerind,
          indmult, emptybox, ker, len, fuspos, l, pos2, c, chi,
          partner, colwidth, width, nam, allowed, str, result, row,
fusionPartner, fusp, jj;

    # Check that the arguments are valid.
    msg:= "<tblnames> must be a list of (lists of) char. table identifiers";
    if Length( arg ) = 1 and IsString( arg[1] ) then
      # not documented but useful
      p:= 0;
      r:= rec( name:= arg[1], char:= p );
      if not CTblLib.StringsAtlasMap_CompleteData( r ) then
        # Even the information about extensions is not available.
        return fail;
      fi;
      tblnames:= r.identifiers;
    elif Length( arg ) = 1 and IsList( arg[1] ) then
      tblnames:= arg[1];
      p:= 0;
      if ForAll( tblnames, IsCharacterTable ) then
        # This was supported in the past (central extensions of a group).
        tbls:= List( tblnames, t -> [ t ] );
        p:= UnderlyingCharacteristic( tblnames[1] );
        tblnames:= List( tblnames, t -> [ Identifier( t ) ] );
      elif not ForAll( tblnames,
                       l -> IsList( l ) and ForAll( l, IsString ) ) then
        Error( msg );
      fi;
    elif Length( arg ) = 2 and IsString( arg[1] )
                           and ( arg[2] = 0 or IsPrimeInt( arg[2] ) ) then
      p:= arg[2];
      r:= rec( name:= arg[1], char:= p );
      if not CTblLib.StringsAtlasMap_CompleteData( r ) then
        # Even the information about extensions is not available.
        return fail;
      fi;
      tblnames:= r.identifiers;
    elif Length( arg ) = 2 and IsList( arg[1] ) and
         ( arg[2] = 0 or IsPrimeInt( arg[2] ) ) then
      tblnames:= arg[1];
      p:= arg[2];
      if not ForAll( tblnames,
                     l -> IsList( l ) and ForAll( l, IsString ) ) then
        Error( msg );
      fi;
    else
      Error( msg );
    fi;

    if not IsBound( tbls ) then

      # Perhaps we have to omit some (not available) tables.
      for nams in CTblLib.AtlasTablesReduceToSubset do
        if nams[1] = tblnames[1][1] then
          tblnames:= tblnames{ nams[2] }{ nams[3] };
          break;
        fi;
      od;

      # Fetch the character tables.
      # We have a list of lists of character table identifiers,
      # except that no table need exist in the case of dashed names
      # (if we have additional information).
      tbls:= [];
      for i in [ 1 .. Length( tblnames ) ] do
        tbls[i]:= [];
        for j in [ 1 .. Length( tblnames[i] ) ] do
          if tblnames[i][j] = "" then
            tbls[i][j]:= fail;
          else
            tbls[i][j]:= CharacterTable( tblnames[i][j] );
            if tbls[i][j] = fail and not '\'' in tblnames[i][j] then
              # The arguments are syntactically correct
              # but some information is missing.
              return fail;
            fi;
          fi;
        od;
      od;

      if p <> 0 and ForAny( tbls[1], x -> Size( x ) mod p = 0 ) then
        # Replace the ordinary tables by Brauer tables.
        for i in [ 1 .. Length( tbls ) ] do
          for j in [ 1 .. Length( tbls[i] ) ] do
            if tbls[i][j] <> fail then
              tbls[i][j]:= tbls[i][j] mod p;
              if tbls[i][j] = fail then
                # The arguments are syntactically correct
                # but some information is missing.
                return fail;
              fi;
            fi;
          od;
        od;
      fi;
    fi;

    tbl:= tbls[1][1];
    nccl:= NrConjugacyClasses( tbl );

    # The line length of the file (including the trailing whitespace)
    # is in general 79.
    # A few Cambridge files contain lines of length 80, but not consistently.
    linelength:= 79;

    # Compute the power map information and the choices of outer classes.
    # We have to omit outer classes of dashed tables.
    ttbls:= ShallowCopy( tbls[1] );
    for i in [ 2 .. Length( ttbls ) ] do
      if ttbls[i] <> fail then
        if p = 0 then
          id:= Identifier( ttbls[i] );
        else
          id:= Identifier( OrdinaryCharacterTable( ttbls[i] ) );
        fi;
        if id[ Length( id ) ] = '\'' then
          ttbls[i]:= fail;
        fi;
      fi;
    od;
    centralizers:= [];
    maps:= CTblLib.CommonCambridgeMaps( ttbls );
    maps_power:= [];
    maps_prime:= [];
    maps_names:= [];
    hash9:= [];
    for j in [ 1 .. Length( maps.choice ) ] do
      if j <> 1 then
        Append( centralizers, [ "|", "|" ] );
        Append( maps_power, [ "|", "|" ] );
        Append( maps_prime, [ "|", "|" ] );
        Append( maps_names, [ "fus", "ind" ] );
        Append( hash9, [ ";", ";" ] );
      fi;
      if maps.choice[j] <> [] then
        Append( centralizers,
                SizesCentralizers( tbls[1][j] ){ maps.choice[j] }
                    / ( Size( tbls[1][j] ) / Size( tbl ) ) );
        Append( maps_power, maps.power[j]{ maps.choice[j] } );
        Append( maps_prime, maps.prime[j]{ maps.choice[j] } );
        Append( maps_names, maps.names[j]{ maps.choice[j] } );
        Append( hash9,
                ListWithIdenticalEntries( Length( maps.choice[j] ), "@" ) );
      fi;
    od;

    # Convert indicators of a portion to strings.
    convertindicators:= function( result, ind2, indmult )
      local i, ind, res, val;

      for i in [ 1 .. Length( ind2 ) ] do
        ind:= ind2[i];
        if ind = [ "|" ] then
          res:= ind[1];
        else
          res:= "";
          for val in ind do
            if   val = -1 then
              Add( res, '-' );
            elif val = 0 then
              Add( res, 'o' );
            elif val = 1 then
              Add( res, '+' );
            elif val = '|' then
              Add( res, '|' );
            else
              Add( res, '?' );
            fi;
          od;
          if indmult[i] <> 1 then
            Append( res, String( indmult[i] ) );
          fi;
        fi;
        Add( result[i], res );
      od;
    end;

    # Convert character values of a portion to strings.
    convertcharacters:= function( result, chars, galoisorbs, name )
      local info, i, newresult, j, entry, galorb, vals;

      # Initialize the cache for each portion,
      # since the ATLAS may use different descriptions for the same value
      # in different portions.
      # In order to be able to handle ordinary and Brauer tables
      # differently, we enter the characteristic in 'info'.
      info:= rec( name:= name,
                  characteristic:= p,
                  cache:= rec( lists:= [], strings:= [] ) );
      for i in [ 1 .. Length( chars ) ] do
        newresult:= [];
        for j in [ 1 .. Length( chars[i] ) ] do
          entry:= chars[i][j];
          if entry = "|" then
            newresult[j]:= entry;
          else
            galorb:= galoisorbs[j];
            if galorb = 1 then
              newresult[j]:= String( entry );
            elif IsList( galorb ) then
              if IsInt( entry ) then
                vals:= ListWithIdenticalEntries( Length( galorb ),
                                                 String( entry ) );
              else
                vals:= chars[i]{ galorb };
                vals:= CTblLib.RelativeIrrationalities( vals, info );
              fi;
              newresult{ galorb }:= vals;
            fi;
          fi;
        od;
        Assert( 1, IsDenseList( newresult ) );
        Append( result[i], newresult );
      od;
    end;

    # Compute the lists of relevant character values of the tables.
    # In particular, compute Galois conjugacy information.
    # (We will compute relative names for the irrationalities that occur,
    # thus we have to know which conjugates are shown at all,
    # which of them is shown via a name, and how the others are named.)
    out:= [];
    for i in [ 1 .. Length( tbls[1] ) ] do
      if tbls[1][i] <> fail then
        out[i]:= Size( tbls[1][i] ) / Size( tbl );
      else
        out[i]:= out[ i-1 ];
      fi;
    od;
    chars:= [];
    lifts:= [];
    dashedlifts:= [];

    galorbs:= function( i, j )
      local galoisorbs, proj, gal, ii, galval, k, pos, proxy;

      galoisorbs:= [];
      if i = 1 then
        proj:= [ 1 .. NrConjugacyClasses( tbls[1][j] ) ];
      else
        proj:= ProjectionMap( GetFusionMap( tbls[i][j], tbls[1][j] ) );
      fi;
      proj:= proj{ maps.choice[j] };
      gal:= GaloisMat( TransposedMat( Irr( tbls[i][j] ) ) ).galoisfams;
      for ii in [ 1 .. Length( proj ) ] do
        galval:= gal[ proj[ii] ];
        if galval = 1 then
          galoisorbs[ii]:= 1;
        elif IsList( galval ) then
          galoisorbs[ii]:= [];
          for k in [ 1 .. Length( galval[1] ) ] do
            pos:= Position( proj, galval[1][k] );
            if pos <> fail then
              Add( galoisorbs[ii], pos );
            fi;
          od;
          Sort( galoisorbs[ii] );
        else
          proxy:= First( gal, x -> IsList( x ) and proj[ii] in x[1] );
          if Intersection( proxy[1], proj ) = [ proj[ii] ] then
            # Take care of unfortunate choices of preimages.
            # (This happens exactly for U4(3)).
            galoisorbs[ii]:= [ ii ];
          else
            galoisorbs[ii]:= 0;
          fi;
        fi;
      od;

      return galoisorbs;
    end;

    extendDashedLifts:= function( i, j )
      local entry, undashed, fus, inv, ordtbl, orders, k;

      if tbls[i][j] = fail then
        # Create the dashed table from the data in the list
        # 'CTblLib.AtlasGroupPermuteToDashedTables'.
        entry:= First( CTblLib.AtlasGroupPermuteToDashedTables[2],
                    x -> x[1] = tblnames[1][j] and x[3] = tblnames[i][j] );
        if entry = fail then
          Error( "'CTblLib.AtlasGroupPermuteToDashedTables' does not ",
                 "contain an entry about '", tblnames[i][j], "'" );
        fi;
        undashed:= CharacterTable( entry[2] );
        if p = 0 then
          fus:= GetFusionMap( undashed, tbls[1][j] );
          if fus = fail then
            # 'undashed' is not really undashed
            fus:= First( ComputedClassFusions( undashed ),
                         x -> ReplacedString( x.name, "'", "" )
                              = Identifier( tbls[1][j] ) ).map;
          fi;
          inv:= Permuted( InverseMap( fus ), entry[4] );
        else
          # This code is reached only if one explicitly wants to show
          # dashed rows in modular tables.
          ordtbl:= OrdinaryCharacterTable( tbls[1][j] );
          fus:= GetFusionMap( undashed, ordtbl );
          if fus = fail then
            # 'undashed' is not really undashed
            fus:= First( ComputedClassFusions( undashed ),
                         x -> ReplacedString( x.name, "'", "" )
                              = Identifier( ordtbl ) ).map;
          fi;
          inv:= Permuted( InverseMap( fus ), entry[4] )
                    { GetFusionMap( tbls[1][j], ordtbl ) };
        fi;
        orders:= OrdersClassRepresentatives( undashed );
      else
        inv:= InverseMap( GetFusionMap( tbls[i][j], tbls[1][j] ) );
        orders:= OrdersClassRepresentatives( tbls[i][j] );
      fi;

      if j <> 1 then
        Append( dashedlifts[i][1], [ "|", "and" ] );
        Append( dashedlifts[i][2], [ "|", "no:" ] );
      fi;

      for k in maps.choice[j] do
        if IsInt( inv[k] ) then
          Add( dashedlifts[i][1], String( orders[ inv[k] ] ) );
          Add( dashedlifts[i][2], "|" );
        else
          Add( dashedlifts[i][1], String( orders[ inv[k][1] ] ) );
          Add( dashedlifts[i][2],
               Concatenation( ":", String( Length( inv[k] ) ) ) );
        fi;
      od;
    end;

    fusionPartner:= function( chi1, chi2, mult, p, projperf, brokenbox, symbol )
      local n, kprime, c;

      n:= Conductor( chi1 );
      if mult = 12 then
        # Always write '**' or '*k' or '**k',
        # in order to specify the cohort.
        # In positive characteristic 'p', write '*p' or '**p' or '**',
        # where '*k' means the same as in the ordinary ATLAS (take the result
        # of 'CTblLib.GalConj') if all Galois conjugate characters exist,
        # and '*k' means applying '*k' itself otherwise.
        kprime:= CTblLib.GalConj( 12, n, -1 );
        if GaloisCyc( chi1, kprime ) = chi2 then
          return Concatenation( "**", symbol );
        fi;
        for c in PrimeResidues( 12 ) do
          kprime:= CTblLib.GalConj( 12, n, c );
          if GaloisCyc( chi1, kprime ) = chi2 then
            if p = 0 or p = c then
              return Concatenation( "*", String( c ), symbol );
            elif p = 12 - c then
              return Concatenation( "**", String( p ), symbol );
            fi;
          fi;
        od;
        if p = 0 then
          Error( "something is wrong with the *k conventions" );
        elif GaloisCyc( chi1, p ) = chi2 then
          return Concatenation( "*", String( p ), symbol );
        elif GaloisCyc( chi1, -p ) = chi2 then
          return Concatenation( "**", String( p ), symbol );
        elif GaloisCyc( chi1, -1 ) = chi2 then
          return Concatenation( "**", symbol );
        else
          Error( "which conjugate?" );
        fi;
      else
        # Write '*' or '**' or '*k'.
        # Note that mult is one of 2, 3, 4, 6;
        # thus '*' is in principle correct, but may be
        # counterintuitive if there is at least one
        # irrationality with conductor neither
        # dividing 'mult' nor being coprime to 'mult'.
        # (The ATLAS does *not* write ** in 4.M22.)
        kprime:= CTblLib.GalConj( mult, n, -1 );
        if GaloisCyc( chi1, kprime ) <> chi2 and not brokenbox then
          # Not all Galois conjugates are characters.
          if p = 0 then
            Error( "something must be wrong with *" );
          fi;

          # In the modular case, write '*'.
          return Concatenation( "*", symbol );
#T What happens for 3.McL.2 mod 5, 12.M22.2 mod 5, ... ???
        elif Gcd( n, mult ) <= 2 or
             mult = 4 or  # case 4.M22
             ForAll( Set( List( chi1{ projperf }, Conductor ) ),
                     x -> Gcd( x, mult ) <= 2 or mult mod x = 0 ) then
          # Simply write '*'.
          return Concatenation( "*", symbol );
        elif GaloisCyc( chi1, kprime ) = chi2 then
          # Show '**'.
          return Concatenation( "**", symbol );
        else
          # Show explicit '*k'.
          c:= First( PrimeResidues( n ),
                     x -> GaloisCyc( chi, x ) = partner );
          if c = 2 and Identifier( tblperf ) in
                         [ "3.Suz", "6.Suz", "3.F3+" ] then
            c:= 8;
          fi;
          return Concatenation( "*", String( c ), symbol );
        fi;
      fi;
    end;

    # If the global option 'OmitDashedRows' is present then obey it,
    # otherwise omit dashed rows exactly in the modular case.
    omitdashedrows:= ValueOption( "OmitDashedRows" );
    if omitdashedrows = fail or not IsBool( omitdashedrows ) then
      omitdashedrows:= ( p <> 0 );
    fi;

    for i in [ 1 .. Length( tbls ) ] do

      # Set the parameters that are independent of the column 'j' in the map.
      # (Note that some parameters may be reassigned for some 'j' in order to
      # treat ``broken box'' cases.)
      multdash:= false;
      if i <> 1 then
        pos:= Position( tblnames[i][1], '.' );
        if '\'' in tblnames[i][1] and pos <> fail and
           Position( tblnames[i][1], '\'' ) < pos then
          multdash:= true;
        fi;
      fi;

      if not multdash then
        tblperf:= tbls[i][1];
        if 1 < i then
          factfus:= GetFusionMap( tblperf, tbl );
          inv:= InverseMap( factfus );
          for k in [ 1 .. Length( inv ) ] do
            if IsInt( inv[k] ) then
              inv[k]:= [ inv[k] ];
            fi;
          od;

          mult:= Size( tblperf ) / Size( tbl );
          lifts[i]:= List( [ 1 .. mult ],
                           j -> ListWithIdenticalEntries( nccl, "|" ) );
          orders:= OrdersClassRepresentatives( tblperf );
          for jj in [ 1 .. Length( inv ) ] do
            entry:= inv[jj];
            for k in [ 1 .. Length( entry ) ] do
              lifts[i][k][jj]:= String( orders[ entry[k] ] );
            od;
          od;
        fi;
      fi;

      for j in [ 1 .. Length( tbls[i] ) ] do

        # This may have been replaced in broken box cases.
        if not multdash then
          tblperf:= tbls[i][1];
          irr:= Irr( tblperf );

          phi:= 1;
          if i = 1 then
            mult:= 1;
            proj:= [ 1 .. Length( irr ) ];
            cohorts:= [ [ 1 .. Length( irr ) ] ];
          else
            mult:= Size( tblperf ) / Size( tbl );
            if 2 < mult then
              phi:= Phi( mult );
            fi;

            if   mult in [ 2, 3, 4 ] then
              roots:= List( PrimeResidues( mult ), x -> E( mult )^x );
            elif mult = 6 then
              roots:= [ -E(3), E(6) ];
            elif mult = 12 then
              roots:= [ E(12)^7, E(12)^11, -E(12)^7, -E(12)^11 ];
            else
              Error( "sorry, 'mult' cannot be ", mult );
            fi;

            factfus:= GetFusionMap( tblperf, tbl );
            proj:= ProjectionMap( factfus );
            projperf:= proj;

            cohorts:= List( roots,
                root -> PositionsProperty( irr, x -> x[2] = x[1] * root ) );
          fi;
        fi;

        if j = 1 then
          # Deal with the first column (perfect central extensions).
          if multdash then
            # Show dashed rows only for ordinary tables, as in ATLAS maps.
            if not omitdashedrows then
              # Store just two rows (``relative'' order/lifting information.)
              dashedlifts[i]:= [ [], [] ];
              extendDashedLifts( i, j );
            fi;
          else
            # We need a full portion of irreducibles info.
            chars[i]:= List( cohorts[1], x -> [] );

            if UnderlyingCharacteristic( tblperf ) <> 2 or
               IsBound( ComputedIndicators( tblperf )[2] ) then
              ind2:= List( Indicator( tblperf, 2 ){ cohorts[1] }, x -> [ x ] );
            else
              # We set the value "o" if the character is not real.
              ind2:= List( cohorts[1], i -> [ "?" ] );
              for k in [ 1 .. Length( cohorts[1] ) ] do
                if irr[ cohorts[1][k] ]
                   <> ComplexConjugate( irr[ cohorts[1][k] ] ) then
                  ind2[k]:= [ 0 ];
                fi;
              od;
            fi;
            convertindicators( chars[i], ind2,
                ListWithIdenticalEntries( Length( cohorts[1] ), phi ) );
            convertcharacters( chars[i],
                List( irr{ cohorts[1] }, x -> x{ proj } ),
                galorbs( i, 1 ), Identifier( tbls[i][1] ) );
          fi;
        else
          # Deal with upwards extensions of the perfect groups.
          if tblnames[i][j] = "" then
            # The portion is empty.
            ext:= ListWithIdenticalEntries( Length( maps.choice[j] ) + 2,
                                            "|" );
            if IsBound( chars[i] ) then
              for line in chars[i] do
                Append( line, ext );
              od;
            fi;
            if IsBound( lifts[i] ) then
              for line in lifts[i] do
                Append( line, ext );
              od;
            fi;
            if IsBound( dashedlifts[i] ) then
              for line in dashedlifts[i] do
                Append( line, ext );
              od;
            fi;
          else
            # Perhaps the table name is dashed.
            outerdash:= false;
            pos:= Position( tblnames[i][j], '.' );
            if '\'' in tblnames[i][j] and pos <> fail then
              if i = 1 then
                if Position( tblnames[i][j], '\'', pos ) <> fail then
                  outerdash:= true;
                fi;
              else
                pos:= Position( tblnames[i][j], '.', pos );
                if Position( tblnames[i][j], '\'', pos ) <> fail then
                  outerdash:= true;
                fi;
              fi;
            fi;

            if outerdash and multdash then
              # Show a 2 by 2 square of ':' if the box is closed,
              # otherwise '*' or (if 'mult' is 12) '**' or '*k'.
              pos:= Position( CTblLib.AtlasMapBoxesSpecial[1],
                              tblnames[i][j] );
              if pos = fail then
                Error( tblnames[i][j], " should occur in ",
                       "'CTblLib.AtlasMapBoxesSpecial[1]'" );
              elif CTblLib.AtlasMapBoxesSpecial[2][ pos ] = "closed" then
                symbol:= ":";
              elif mult < 12 then
                symbol:= "*";
              else
                # Read 'k' off from the action on the centre
                # in the case of *undashed* table names.
                undashed:= List( tblnames[i]{ [ 1, j ] },
                    x -> CharacterTable( ReplacedString( x, "\'", "" ) ) );
                subfus:= GetFusionMap( undashed[1], undashed[2] );
                if subfus = fail then
                  Error( "no class fusion from '", Identifier( undashed[1] ),
                         "' to '", Identifier( undashed[2] ), "' stored" );
                fi;
                centre:= ClassPositionsOfCentre( undashed[1] );
                subfus:= First( InverseMap( subfus{ centre } ), IsList );
                centre:= centre{ subfus };
                k:= First( [ 5, 7, 11 ],
                      x -> PowerMap( undashed[1], x, centre[1] ) = centre[2] );
                if k = 11 then
                  symbol:= "**";
                else
                  symbol:= Concatenation( "*", String( k ) );
                fi;
              fi;

              if not omitdashedrows then
                for line in dashedlifts[i] do
                  Append( line, [ symbol, symbol ] );
                od;
              fi;
            elif outerdash then
              # Show two columns, corresp. to the ext./fusion
              # in the non-dashed table.
              if tbls[i][j] = fail then
                # Create the table from the data in the list
                # 'CTblLib.AtlasGroupPermuteToDashedTables'.
                entry:= CTblLib.AtlasGroupPermuteToDashedTablesFunction(
                            tbls[i][1], tblnames[i][j] );
                if entry = fail then
                  Error( "'CTblLib.AtlasGroupPermuteToDashedTables' does not ",
                         "contain an entry about '", tblnames[i][j], "'" );
                fi;
                tbls[i][j]:= entry.table;
                subfus:= entry.fusion;
              else
                subfus:= GetFusionMap( tblperf, tbls[i][j] );
              fi;
            elif multdash then
              if not omitdashedrows then
                # Show two rows, corresp. to the class splitting
                # in the non-dashed table.
                extendDashedLifts( i, j );
              fi;
            else
              # Show also character values.
              subfus:= GetFusionMap( tblperf, tbls[i][j] );
            fi;

            if not multdash then
              # Deal with the ''broken box'' case,
              # by enlarging the ''perfect'' subgroup.
              brokenbox:= false;
              if subfus = fail then
                nams:= tblnames[i]{ [ 1, j ] };
                for entry in CTblLib.BrokenBoxReplacements do
                  if entry[1] = nams then
                    tblperf:= CharacterTable( entry[2] );
                    if UnderlyingCharacteristic( tbls[1][1] ) <> 0 then
                      tblperf:= tblperf mod p;
                    fi;
                    phi:= entry[3];
                    roots:= entry[4];
                    brokenbox:= true;
                    break;
                  fi;
                od;
                subfus:= GetFusionMap( tblperf, tbls[i][j] );
                irr:= Irr( tblperf );
                cohorts:= List( roots,
                    r -> PositionsProperty( irr, x -> x[ phi ] = x[1] * r ) );
              fi;

              # Append the extension/fusion information for the 'j'-th column.
              not_consecutive_fusions:= [];
              if i = 1 then
                proj:= [ 1 .. NrConjugacyClasses( tbls[i][j] ) ];
              else
                factfus:= GetFusionMap( tbls[i][j], tbls[1][j] );
                if factfus = fail then
                  ker:= Set( subfus{ ClassPositionsOfKernel(
                                         GetFusionMap( tbls[i][1], tbl ) ) } );
                  factfus:= GetFusionMap( tbls[i][j], tbls[i][j] / ker );
                fi;
                proj:= ProjectionMap( factfus );
              fi;
              outerirr:= Irr( tbls[i][j] );
              rest:= List( outerirr, x -> x{ subfus } );
              if UnderlyingCharacteristic( tbls[i][j] ) = 0 then
                scpr:= List( cohorts,
                         l -> MatScalarProducts( tblperf, irr{ l }, rest ) );
              else
                scpr:= TransposedMat(
                           Decomposition( irr, rest, "nonnegative" ) );
                scpr:= List( cohorts, l -> TransposedMat( scpr{ l } ) );
              fi;
              Assert( 1, ForAll( Set( Flat( scpr ) ), IsInt ) );

              # ugly hack for the special case '9.U3(8).3_3'
              if brokenbox and Length( cohorts ) = 6 then
                scpr:= [ Sum( scpr{ [ 1, 3, 5 ] } ),
                         Sum( scpr{ [ 2, 4, 6 ] } ) ];
              fi;

              if UnderlyingCharacteristic( tbls[i][j] ) <> 2 or
                 IsBound( ComputedIndicators( tbls[i][j] )[2] ) then
                ind2:= Indicator( tbls[i][j], 2 );
              else
                # We set the value "o" if the character is not real.
                ind2:= List( Irr( tbls[i][j] ), x -> "?" );
                for k in [ 1 .. Length( ind2 ) ] do
                  if Irr( tbls[i][j] )[k]
                     <> ComplexConjugate( Irr( tbls[i][j] )[k] ) then
                    ind2[k]:= 0;
                  fi;
                od;
              fi;

              outerchi:= [];
              outerind:= [];
              indmult:= [];

              # For ordinary tables, the (i,j)-box is open
              # if no faithful character restricts irreducibly.
              # In the case of p-modular tables,
              # it may happen that all splitting classes are p-singular
              # (3.U3(8).3_1 mod 2 is such an example) but the box is not
              # regarded as open;
              # we require that a divides m-1 in this case.
#T is this good enough?
              if i = 1 then
                emptybox:= false;
              else
                ker:= ClassPositionsOfKernel( factfus );
                emptybox:= ForAll( outerirr, x -> ( not x{ subfus } in irr ) or
                    ( Length( ClassPositionsOfKernel( x{ ker } ) ) > 1 ) );
                if p <> 0 and ( ( mult - 1 ) mod out ) <> 0 then
                  emptybox:= false;
                fi;
              fi;

              for k in [ 1 .. Length( cohorts[1] ) ] do
                if not IsBound( outerchi[k] ) then
                  chi:= irr[ cohorts[1][k] ];
                  pos:= Positions( rest, chi );
                  symbol:= RepeatedString( "?",
                             Number( not_consecutive_fusions, x -> k in x ) );
                  if Length( pos ) <> 0 then
                    # This character extends; take the first extension.
                    Add( chars[i][k], Concatenation( ":", symbol ) );
                    outerchi[k]:= outerirr[ pos[1] ]{ proj{ maps.choice[j] } };
                    outerind[k]:= ind2{ pos };
                    indmult[k]:= phi;
                  else
                    # This char. is the first from a set of fusing characters,
                    # either with one or more characters from the same cohort
                    # or with one character from another cohort
                    # or with characters from both the same and another cohort
                    # (where the last case occurs only for "3.U3(8).6").
                    len:= Length( maps.choice[j] );
                    if emptybox then
                      # The whole box is empty.
                      outerchi[k]:= ListWithIdenticalEntries( len, "|" );
                    else
                      # Some other rows in the box may be nonempty.
                      outerchi[k]:= ListWithIdenticalEntries( len, 0 );
                    fi;
                    pos:= PositionsProperty( scpr[1], x -> x[k] <> 0 );

                    # ugly hack for the special case '9.U3(8).3_3'
                    if brokenbox and Length( cohorts ) = 6 then
                      # This happens for 9.U3(8).3_3, 9.U3(8).3_3' only.
                      pos:= pos{ [ 1 ] };
                    fi;

                    fuspos:= pos[1];
                    outerind[k]:= ind2{ pos };
                    pos:= PositionsProperty( scpr[1][ fuspos ], x -> x <> 0 );
                    if Length( pos ) <> 1 then
                      # fusion with characters from the same cohort
                      if pos <> [ pos[1] .. pos[ Length( pos ) ] ] then
                        Add( not_consecutive_fusions,
                             [ pos[1] .. pos[ Length( pos ) ] ] );
                      fi;
                      if 1 < Length( cohorts ) and
                         scpr[2][ fuspos ][k] <> 0 then
                        # The character fuses also with its partner.
                        Add( chars[i][k], Concatenation( "*", symbol ) );
                        indmult[k]:= phi / 2;
                      elif Sum( List( scpr,
                             mat -> Length( PositionsProperty(
                                      mat[ fuspos ], x -> x <> 0 ) ) ) )
                           = out[j] then
                        # No fusing character extends to a subgroup.
                        Add( chars[i][k], Concatenation( ".", symbol ) );
                        indmult[k]:= phi;
                      else
                        # Some extensions fuse.
                        Add( chars[i][k], Concatenation( ":", symbol ) );
                        indmult[k]:= phi;
                      fi;

                      # Mark the other fusing characters.
                      for l in pos do
                        if l <> k then
                          if 1 < Length( cohorts ) and
                             scpr[2][ fuspos ][l] <> 0 then
                            # Also the partner from another cohort fuses.
                            Add( chars[i][l], Concatenation( "*", symbol ) );
                          elif Sum( List( scpr,
                                 mat -> Length( PositionsProperty(
                                          mat[ fuspos ], x -> x <> 0 ) ) ) )
                               = out[j] then
                            # All fusing characters lie in the same cohort.
                            Add( chars[i][l], Concatenation( ".", symbol ) );
                          else
                            # All fusing characters lie in the same cohort.
                            Add( chars[i][l], Concatenation( ":", symbol ) );
                          fi;
                          outerchi[l]:= ListWithIdenticalEntries( len, "|" );
                          outerind[l]:= [ "|" ];
                        fi;
                      od;

                      # Deal also with fusing characters from other cohorts.
                      if 1 < Length( cohorts ) then
                        pos:= PositionsProperty( scpr[2][ fuspos ],
                                                 x -> x <> 0 );
                        for l in pos do
                          if l <> k and not IsBound( outerchi[l] ) then
#T changed 12.07.17: added condition l <> k
                            Add( chars[i][l], Concatenation( "*", symbol ) );
                            outerchi[l]:=
                                ListWithIdenticalEntries( len, "|" );
                            outerind[l]:= [ "|" ];
                          fi;
                        od;
                      fi;
                    else
                      # fusion with a character from another cohort:
                      # Find the position of this character.
                      for l in [ 2 .. Length( cohorts ) ] do
                        pos2:= PositionsProperty( scpr[l][ fuspos ],
                                                  x -> x <> 0 );
                        if Length( pos2 ) = 1 then
                          # We found the right cohort.
                          if pos2[1] <> pos[1] + 1 then
                            Add( not_consecutive_fusions,
                                 [ pos[1] .. pos2[1] ] );
                          fi;
                          if pos2[1] = k then
                            # The 'k'-th character fuses with the 'k'-th
                            # character in another cohort.
                            indmult[k]:= phi / 2;
                            if out[j] in [ 4, 6 ] then
                              # There must be intermediate extension.
                              Add( chars[i][k],
                                   Concatenation( ":*", symbol ) );
                            else
                              Add( chars[i][k],
                                   fusionPartner( chi,
                                       irr[ cohorts[l][k] ], mult, p,
                                       projperf, brokenbox, symbol ) );
                            fi;
                          else
                            # The 'k'-th character fuses with a character at
                            # another position in another cohort.
                            # Mark the other fusing character.
                            # If all irrationalities have conductor coprime
                            # to 'mult' and if 'CTblLib.GalConj' describes
                            # the necessary Galois conjugation
                            # (see Chapter 7, Section 19 of the ATLAS)
#T but only for ordinary tables!
                            # then write '*', otherwise write '**' or '*k'.
                            # Always write '**' or '*k' if 'mult' is 12,
                            # in order to specify the cohort.
                            indmult[k]:= phi;
                            partner:= irr[ cohorts[l][ pos2[1] ] ];
                            fusp:= fusionPartner(
                                       irr[ cohorts[1][ pos2[1] ] ],
                                       partner, mult, p, projperf,
                                       brokenbox, symbol );
                            Add( chars[i][k],
                                 Concatenation( ".",
                                     RepeatedString( "?", Length( fusp )
                                         - Length( symbol ) - 1 ),
                                     symbol ) );
                            Add( chars[i][ pos2[1] ], fusp );

                            outerchi[ pos2[1] ]:=
                                ListWithIdenticalEntries( len, "|" );
                            outerind[ pos2[1] ]:= [ "|" ];
                          fi;
                          break;
                        fi;
                      od;
                    fi;
                  fi;
                fi;
              od;

              convertindicators( chars[i], outerind, indmult );
              if outerdash then
                convertcharacters( chars[i], outerchi, fail,
                    Identifier( tbls[i][j] ) );
              else
                convertcharacters( chars[i], outerchi, galorbs( i, j ),
                    Identifier( tbls[i][j] ) );
              fi;

              if i > 1 then
                # Extend the lifting order rows.
                Append( lifts[i][1], [ "fus", "ind" ] );
                for k in [ 2 .. mult ] do
                  Append( lifts[i][k], [ "|", "|" ] );
                od;

                if maps.choice[j] <> [] then
                  inv:= InverseMap( factfus ){ maps.choice[j] };
                  for k in [ 1 .. Length( inv ) ] do
                    if IsInt( inv[k] ) then
                      inv[k]:= [ inv[k] ];
                    fi;
                  od;
                  if brokenbox then
                    if mult = 6 then
                      # 12.A6.2_3
                      inv:= List( inv, x -> x{ [ 1, 2, 3 ] } );
                    else
                      # mult = 2 or 3
                      inv:= List( inv, x -> x{ [ 1 ] } );
                    fi;
                  fi;

                  ext:= ListWithIdenticalEntries( Length( maps.choice[j] ),
                                                  "|" );
                  ext:= List( [ 1 .. mult ], x -> ShallowCopy( ext ) );
                  orders:= OrdersClassRepresentatives( tbls[i][j] );
                  for l in [ 1 .. Length( inv ) ] do
                    entry:= inv[l];
                    for k in [ 1 .. Length( entry ) ] do
                      ext[k][l]:= String( orders[ entry[k] ] );
                    od;
                  od;

                  for k in [ 1 .. mult ] do
                    Append( lifts[i][k], ext[k] );
                  od;
                fi;
              fi;
            fi;
          fi;
        fi;
      od;
    od;

    # Compute the column widths (first disregarding centralizer orders).
    colwidth:= [];
    for i in [ 1 .. Length( maps_power ) ] do
      # Consider power maps.
      # (Adjacent class names are allowed.)
      width:= Maximum( 4,
                       Length( maps_power[i] ) + 1,
                       Length( maps_prime[i] ) + 1,
                       Length( maps_names[i] ) );

      # Consider all character values.
      # Note that a '-' prefix does not require a wider column,
      # and that 'ind' columns need not be separated from 'fus' columns.
      for j in [ 1 .. Length( chars ) ] do
        if IsBound( chars[j] ) then
          for chi in chars[j] do
            if Length( chi[ i+1 ] ) >= width then
              if chi[ i+1 ][1] = '-' or
                 maps_names[i] = "ind" then
                width:= Length( chi[ i+1 ] );
              else
                width:= Length( chi[ i+1 ] ) + 1;
              fi;
            fi;
          od;
        fi;
      od;

      # All column widths must be even.
      if width mod 2 <> 0 then
        width:= width + 1;
      fi;
      colwidth[i]:= width;
    od;

    # Absolute class names (i. e., names not involving '*')
    # ending with digits may not be adjacent to neighbouring ones.
    for i in [ 2 .. Length( maps_names ) ] do
      nam:= maps_names[i];
      if IsDigitChar( nam[ Length( nam ) ] ) and
         not '*' in nam and
         colwidth[i] = Length( nam ) then
        colwidth[i]:= colwidth[i] + 2;
        if i < Length( maps_names ) and
           colwidth[ i+1 ] = Length( maps_names[ i+1 ] ) then
          colwidth[ i+1 ]:= colwidth[ i+1 ] + 2;
        fi;
      fi;
    od;

    # The centralizer order must fit; it may be distributed to two rows.
    # (In the table of A13, the 3A centralizer order has 7 digits,
    # and the rest of the column needs only width 4;
    # thus the centralizer order forces us to take width 6.)
    # (We allow adjacent values in *one* of the two rows,
    # in columns following "fus" "ind" columns.)
    centralizers:= List( centralizers, String );
    for j in [ 2 .. Length( centralizers ) ] do
      if hash9[ j-1 ] = ";" then
        allowed:= 2 * colwidth[j] - 1;
      else
        allowed:= 2 * colwidth[j] - 2;
      fi;
      while allowed < Length( centralizers[j] ) do
        colwidth[j]:= colwidth[j] + 2;
        allowed:= allowed + 4;
      od;
    od;

    # Break the data into lines.
    str:= function( prefix, list )
      local result, len, i, val, len2;

      result:= prefix;
      len:= Length( prefix );
      for i in list do
        val:= String( i );
        len2:= 1 + Length( val );
        len:= len + len2;
        if len > linelength then
          Add( result, '\n' );
          len:= len2;
        fi;
        Append( result, val );
        Add( result, ' ' );
      od;
      Add( result, '\n' );

      return result;
    end;

    # Compose the result.
    if UnderlyingCharacteristic( tbl ) = 0 then
      result:= Concatenation( "#23 ? ", Identifier( tbl ), "\n" );
    else
      result:= Concatenation( "#23 ",
                   Identifier( OrdinaryCharacterTable( tbl ) ), " (Mod ",
                   String( UnderlyingCharacteristic( tbl ) ), ")\n" );
    fi;
    Append( result, str( "#7 4 ", colwidth ) );
    Append( result, str( "#9 ; ", hash9 ) );
    Append( result, str( "#1 | ", centralizers ) );
    Append( result, str( "#2 p power", maps_power ) );
    Append( result, str( "#3 p' part", maps_prime ) );
    Append( result, str( "#4 ind ", maps_names ) );
    for row in chars[1] do
      Append( result, str( "#5 ", row ) );
    od;
    for i in [ 2 .. Length( tbls ) ] do
      if IsBound( lifts[i] ) and not IsEmpty( lifts[i] ) then
        Append( result, str( "#6 ind ", lifts[i][1] ) );
        for j in [ 2 .. Length( lifts[i] ) ] do
          Append( result, str( "#6 | ", lifts[i][j] ) );
        od;
      fi;
      if IsBound( dashedlifts[i] ) and not IsEmpty( dashedlifts[i] ) then
        Append( result, str( "#6 and ", dashedlifts[i][1] ) );
        Append( result, str( "#6 no: ", dashedlifts[i][2] ) );
      fi;
      if IsBound( chars[i] ) then
        for row in chars[i] do
          Append( result, str( "#5 ", row ) );
        od;
      fi;
    od;
    Append( result, "#8\n" );

    return result;
end );


#############################################################################
##
##  5. Interface to the MAGMA display format
##


#############################################################################
##
#V  CTblLib.ComputedBosmaBases
##
CTblLib.ComputedBosmaBases:= [ [ 0 ] ];


#############################################################################
##
#F  BosmaBase( <n> )
##
InstallGlobalFunction( BosmaBase, function( n )
    local first, pair, p, pk, phi, q, basis, newbasis, i;

    if ( not IsPosInt( n ) ) or n mod 4 = 2 then
      return fail;
    elif not IsBound( CTblLib.ComputedBosmaBases[n] ) then
      if n = 1 then
        CTblLib.ComputedBosmaBases[n]:= [ 0 ];
      else
        first:= true;
        for pair in Collected( Factors( n ) ) do
          p:= pair[1];
          pk:= p^pair[2];
          phi:= ( pk / p ) * (p-1);
          q:= n / pk;
          if first then
            basis:= [ 0, q .. (phi-1)*q ];
          else
            newbasis:= ShallowCopy( basis );
            for i in [ q, 2*q .. (phi-1)*q ] do
              Append( newbasis, basis + i );
            od;
            basis:= newbasis;
          fi;
          first:= false;
        od;

        CTblLib.ComputedBosmaBases[n]:= List( basis, x -> x mod n );
      fi;
    fi;

    # When the function was introduced, the result was a *mutable* list.
    # Perhaps this was a bad idea.
    return ShallowCopy( CTblLib.ComputedBosmaBases[n] );
end );


#############################################################################
##
#F  GAPTableOfMagmaFile( <file>, <identifier>[, "string"] )
##
##  MAGMA's display format for character tables is assumed to start with a
##  series of parts showing for a bunch of columns the class lengths,
##  element orders, power maps, and character values;
##  afterwards follows the definition of the symbols used to denote
##  irrational character values.
##
##  Unfortunately, it cannot be assumed that character values in adjacent
##  columns are separated by at least one blank --this feature would have
##  simplified the function below considerably.
##  We assume that
##  - the class numbers are in fact separated by at least one blank,
##  - all values are right-aligned,
##  - class numbers occur in lines starting with 'Class',
##    and are consecutive positive integers starting at '1',
##  - class lengths occur in lines starting with 'Size',
##  - element orders occur in lines starting with 'Order',
##  - power maps occur in lines starting with 'p', followed by at least one
##    blank, followed by '=', followed by at least one blank and then the
##    prime in question,
##  - the irrational values have names of the form 'Z<i>' or 'Z<i>#<k>' or
##    'I' or 'J' or their negatives or an integer followed by such a symbol.
##
InstallGlobalFunction( GAPTableOfMagmaFile, function( arg )
    local file, identifier, split, orders, classlengths, powermaps, irr,
          irrats, str, line, i, istr, columns, pos, pos2, p, spl, val, N,
          coeffs, basis, chi, int, pair, k, tbl;

    if not( Length( arg ) = 2 or Length( arg ) = 3 and arg[3] = "string" ) then
      Error( "usage: ",
             "GAPTableOfMagmaFile( <file>, <identifier>[, \"string\"] )" );
    fi;

    file:= arg[1];
    identifier:= arg[2];

    split:= function( line, columns )
      local result, range;

      result:= [];
      for range in columns do
        Add( result, NormalizedWhitespace( line{ range } ) );
      od;
      return result;
    end;

    orders:= [];
    classlengths:= [];
    powermaps:= [];
    irr:= [];
    irrats:= [];

    # Run once over the lines of the file/string.
    if Length( arg ) = 3 then
      str:= InputTextString( file );
    else
      str:= InputTextFile( file );
    fi;
    line:= ReadLine( str );
    i:= 1;
    istr:= String( i );
    while line <> fail do
      if 5 < Length( line ) then
        if   line{ [ 1 .. 5 ] } = "Class" then
          # some class numbers; use them to define the columns
          columns:= [];
          pos:= Position( line, '|' );
          pos2:= PositionSublist( line, istr, pos );
          while pos2 <> fail do
            pos2:= pos2 + Length( istr ) - 1;
            Add( columns, [ pos+1 .. pos2 ] );
            pos:= pos2;
            i:= i+1;
            istr:= String( i );
            pos2:= PositionSublist( line, istr, pos );
          od;
        elif line{ [ 1 .. 4 ] } = "Size" then
          # some class lengths
          Append( classlengths, List( split( line, columns ), Int ) );
        elif line{ [ 1 .. 5 ] } = "Order" then
          # some element orders
          Append( orders, List( split( line, columns ), Int ) );
        elif line{ [ 1 .. 2 ] } = "p " then
          # some power map values
          p:= Int( NormalizedWhitespace( line{
                       [ Position( line, '=' ) + 1 .. columns[1][1] ] } ) );
          if not IsBound( powermaps[p] ) then
            powermaps[p]:= [];
          fi;
          Append( powermaps[p], List( split( line, columns ), Int ) );
        elif line{ [ 1 .. 2 ] } = "X." then
          # some character values
          pos:= Int( line{ [ 3 .. Position( line, ' ' ) - 1 ] } );
          if not IsBound( irr[ pos ] ) then
            irr[ pos ]:= [];
          fi;
          Append( irr[ pos ], split( line, columns ) );
        elif line[1] = 'Z' then
          # definition of an irrational value that is not a root of unity;
          # the line has the form
          # 'Z<m> = (CyclotomicField(<n>: Sparse := true)) ! [
          # RationalField() | <coeffs> ]'
          # where <m> and <n> are positive integers and <coeffs> is a
          # sequence of comma separated integers;
          # this information may be extended over several lines
          NormalizeWhitespace( line );
          spl:= SplitString( line, " " );
          val:= "Unknown()";
          pos:= PositionSublist( line, "CyclotomicField(" );
          if pos <> fail then
            pos2:= Position( line, ':', pos );
            if pos2 <> fail then
              N:= Int( line{ [ pos+16 .. pos2-1 ] } );
              while line[ Length( line ) ] <> ']' do
                Append( line, NormalizedWhitespace( ReadLine( str ) ) );
              od;
              pos2:= PositionSublist( line, "RationalField() |" );
              if pos2 <> fail then
                pos2:= Position( line, '|', pos ) + 1;
                coeffs:= EvalString( Concatenation( "[",
                             line{ [ pos2 .. Length( line ) ] } ) );
                basis:= List( BosmaBase( N ), i -> E(N)^i );
                val:= Concatenation( "(", String( coeffs * basis ), ")" );
              fi;
            fi;
          fi;
          if val = "Unknown()" then
            Print( "#E cannot identify irrationality ", spl[1], "\n" );
          fi;
          Add( irrats, [ spl[1], val ] );
        elif PositionSublist( line, "RootOfUnity(" ) <> fail then
          # definition of an irrational value that is a root of unity;
          # the line has the form '<nam> = RootOfUnity(<n>)',
          # for a string <nam> and a positive integer <n>
          NormalizeWhitespace( line );
          spl:= SplitString( line, " " );
          N:= EvalString( ReplacedString( spl[3], "RootOfUnity", "" ) );
          Add( irrats, [ spl[1], Concatenation( "(E(", String(N), "))" ) ] );
        fi;
      fi;

      line:= ReadLine( str );
    od;
    CloseStream( str );

    # Run over the character values, replace irrationalities by their values.
    irrats:= Reversed( irrats );
    for chi in irr do
      for i in [ 1 .. Length( chi ) ] do
        val:= chi[i];
        int:= Int( val );
        if int <> fail then
          chi[i]:= int;
        else
          # Identify the irrationality.
          pos:= Position( val, '#' );
          if pos = fail then
            for pair in irrats do
              val:= ReplacedString( val, pair[1], pair[2] );
            od;
          else
            k:= "";
            pos2:= pos + 1;
            while pos2 <= Length( val ) and IsDigitChar( val[ pos2 ] ) do
              Add( k, val[ pos2 ] );
              pos2:= pos2 + 1;
            od;
            pos2:= pos - 1;
            while IsDigitChar( val[ pos2 ] ) do
              pos2:= pos2 - 1;
            od;
            val:= val{ [ pos2 .. pos - 1 ] };
            pair:= First( irrats, pair -> pair[1] = val );
            if pair[2] = "Unknown()" then
              val:= ReplacedString( chi[i], Concatenation( pair[1], "#", k ),
                           pair[2] );
            else
              val:= ReplacedString( chi[i], Concatenation( pair[1], "#", k ),
                      Concatenation( "GaloisCyc(", pair[2], ",", k, ")" ) );
            fi;
          fi;
          chi[i]:= EvalString( val );
        fi;
      od;
    od;

    # Create the GAP character table object.
    tbl:= rec(
      UnderlyingCharacteristic:= 0,
      Identifier:= identifier,
      ComputedPowerMaps:= powermaps,
      Irr:= irr,
      NrConjugacyClasses:= Length( orders ),
      SizesConjugacyClasses:= classlengths,
      OrdersClassRepresentatives:= orders,
    );

    # Check whether the table is not obvious garbage.
    if Length( irr ) = 0 then
      return fail;
    fi;

    return ConvertToLibraryCharacterTableNC( tbl );
end );


#############################################################################
##
#F  CTblLib.MagmaStringOfPerm( <perm>, <n> )
##
##  returns a string that describes the permutation <perm>,
##  as a permutation on the points from 1 to <n>, in MAGMA format.
##
CTblLib.MagmaStringOfPerm:= function( perm, n )
    local linelen, result, imgs, line, pos, nextpos;

    linelen:= 78;

    result:= "";
    imgs:= String( ListPerm( perm, n ) );
    line:= "";
    pos:= 0;
    nextpos:= Position( imgs, ',' );
    while nextpos <> fail do
      if linelen < Length( line ) + nextpos - pos then
        Add( line, '\n' );
        Append( result, line );
        line:= "  ";
      fi;
      Append( line, imgs{ [ pos+1 .. nextpos ] } );
      pos:= nextpos;
      nextpos:= Position( imgs, ',', nextpos );
    od;
    nextpos:= Length( imgs );
    if linelen < Length( line ) + nextpos - pos then
      Add( line, '\n' );
      Append( result, line );
      line:= "  ";
    fi;
    Append( line, imgs{ [ pos+1 .. nextpos ] } );
    Append( result, line );

    return result;
end;


#############################################################################
##
#F  CTblLib.MagmaStringOfPermGroup( <permgrp>, <varname> )
##
##  returns a string that describes the assignment of the permutation group
##  <permgrp> to the variable <varname>, in MAGMA.
##
CTblLib.MagmaStringOfPermGroup:= function( permgrp, varname )
    local linelen, degree, result, gen;

    linelen:= 78;
    degree:= LargestMovedPoint( permgrp );

    result:= Concatenation( varname, ":= " );
    Append( result, "PermutationGroup<" );
    Append( result, String( degree ) );
    Append( result, " |\n" );
    for gen in GeneratorsOfGroup( permgrp ) do
      Append( result, CTblLib.MagmaStringOfPerm( gen, degree ) );
      Append( result, ",\n" );
    od;

    result[ Length( result )-1 ]:= '>';
    result[ Length( result ) ]:= ';';
    Add( result, '\n' );

    return result;
end;


#############################################################################
##
#F  CTblLib.MagmaStringOfFFEMatrixGroupData( <gens> )
##
CTblLib.MagmaStringOfFFEMatrixGroupData:= function( mats )
    local F, p, e, q, w, one, pow, wp, tab, i, cpn;

    F:= Field( Flat( mats ) );
    p:= Characteristic( F );
    e:= DegreeOverPrimeField( F );
    q:= Size( F );
    w:= PrimitiveRoot( F );
    one:= One( F );
    pow:= (q-1)/(p-1);
    wp:= w^pow;
    tab:= [];
    for i in [ 1 .. p-1 ] do
      tab[ LogFFE( i*one, wp )+1 ]:= i;
    od;

    if p < 10 then
      cpn:= 3;
    elif p < 100 then
      cpn:= 4;
    elif p < 1000 then
      cpn:= 5;
    elif p < 10000 then
      cpn:= 6;
    else
      cpn:= 7;
    fi;
    if e > 1 then
      cpn:= cpn + 2;
    fi;

    return rec( parentname:= "P",
                primname:= "w",
                dim:= Length( mats[1] ),
                zero:= Zero( F ),
                pow:= pow,
                w:= w,
                wp:= wp,
                tab:= tab,
                q:= q,
                e:= e,
                npl:= Int( 76/(cpn) ) ); # should be 78, but it overflowed.
end;


#############################################################################
##
#F  CTblLib.MagmaStringOfFFEMatrix( <matrix>, <data> )
##
CTblLib.MagmaStringOfFFEMatrix:= function( matrix, data )
    local zero, pow, wp, tab, q, e, npl, w, primname, nc, result, i, cno, j,
          val, isint;

    zero:= data.zero;
    pow:= data.pow;
    wp:= data.wp;
    tab:= data.tab;
    q:= data.q;
    e:= data.e;
    npl:= data.npl;
    w:= data.w;
    primname:= data.primname;

    nc:= NumberColumns( matrix );
    result:= "";
    Append( result, data.parentname );
    Append( result, "![" );
    for i in [ 1 .. NumberRows( matrix ) ] do
      cno:= 0;
      for j in [ 1 .. nc ] do
        if matrix[i,j] = zero then
          val:= 0;
          isint:= true;
        else
          val:= LogFFE( matrix[i,j], w );
          if val mod pow = 0 then
            val:= tab[ LogFFE( matrix[i,j], wp )+1 ];
            isint:= true;
          else
            isint:= false;
          fi;
        fi;
        if q < 10 or ( q < 100 and val >= 10 ) or ( q < 1000 and val >= 100)
               or ( q < 10000 and val >= 1000 ) or val >= 10000 then
          if not (i = 1 and j = 1) then
            Append( result, ",");
          fi;
        elif q < 100 or ( q < 1000 and val >= 10 ) or ( q < 10000 and val >= 100 )
                                      or val >= 1000 then
          if not ( i = 1 and j = 1 ) then
            Append( result, " , " );
          fi;
        elif q < 1000 or ( q < 10000 and val >= 10 ) or  val >= 100 then
          if not ( i = 1 and j = 1 ) then
            Append( result, " , " );
          fi;
        elif q < 10000 or val >= 10 then
          if not ( i = 1 and j = 1 ) then
            Append( result, "  , " );
          fi;
        else
          if not ( i = 1 and j = 1 ) then
            Append( result, "   , " );
          fi;
        fi;
        if  e > 1 then
          if isint then
            Append( result, " " );
          else
            Append( result, primname );
            Append( result, "^" );
          fi;
        fi;
        Append( result, String( val ) );
        cno:= cno+1;
        if cno >= npl and j < nc then
          Append( result, "\n " );
          cno:= 0;
        fi;
      od;
    od;
    Append( result, "]");

    return result;
end;


#############################################################################
##
#F  CTblLib.MagmaStringOfFFEMatrixGroup( <matgrp>, <varname> )
##
##  returns a string that describes the assignment of the matrix group
##  <matgrp> to the variable <varname>, in MAGMA.
##
##  This function is based on code written by Eamonn O'Brien.
##
CTblLib.MagmaStringOfFFEMatrixGroup:= function( matgrp, varname )
    local mats, data, result, NmrIter, FinalIter, matrix;

    mats:= GeneratorsOfGroup( matgrp );
    data:= CTblLib.MagmaStringOfFFEMatrixGroupData( mats );
    result:= Concatenation( "F:= GF(", String( data.q ), ");\n" );
    Append( result, "P:= GL(" );
    Append( result, String( data.dim ) );
    Append( result, ",F);\n" );
    if data.e > 1 then
      Append( result, "w:= PrimitiveElement( F );\n");
    fi;
    Append( result, "gens:= [" );

    NmrIter:= 0;
    FinalIter:= Length( mats );

    for matrix in mats do
      NmrIter:= NmrIter + 1;
      Append( result, "\n" );
      Append( result, CTblLib.MagmaStringOfFFEMatrix( matrix, data ) );
      if NmrIter <> FinalIter then
        Append( result, ",\n");
      else
        Append( result, "\n");
      fi;
    od;
    Append( result, "];\n" );
    Append( result, varname );
    Append( result, ":= sub <P | gens>;\n" );

    return result;
end;


#############################################################################
##
#F  CTblLib.IsMagmaAvailable()
##
CTblLib.IsMagmaAvailable:= function()
    local path, str, out, result;

    path:= UserPreference( "CTblLib", "MagmaPath" );

    if path = "" or path = fail or not IsExecutableFile( path ) then
      # We do not know how to call MAGMA.
      return false;
    fi;

    # Try to call MAGMA.
    str:= "";
    out:= OutputTextString( str, true );
    result:= Process( DirectoryCurrent(), path,
                 InputTextString( "" ),
                 out, [] );
    CloseStream( out );

    return result = 0;
end;


#############################################################################
##
#F  CharacterTableComputedByMagma( <G>, <identifier> )
##
##  Call MAGMA for computing the character table of the group <G>.
##
##  If the conjugacy classes of <G> are known before the function call
##  then the columns of the character table correspond to the given classes.
##  For that, we have to transfer the class information to MAGMA.
##
##  If we want to set the classes list in the MAGMA group object directly
##  then we have to set also the class sizes,
##  and computing the class sizes in GAP for that purpose would be in general
##  very time consuming.
##
##  If the sizes would be known in advance on the GAP side then it would not
##  help much to tell them to MAGMA, so we omit the class sizes.
##  Instead, we let MAGMA compute the class map for the known representatives
##  w. r. t. the table computed by MAGMA, and use this map for permuting the
##  columns such that they fit to GAP's conjugacy classes.
##
##  (We could set the list of triples consisting of element order,
##  class length, and representative, by inserting
##  "AssertAttribute( G, \"Classes\", c );" into the MAGMA input string.)
##
InstallGlobalFunction( CharacterTableComputedByMagma,
    function( G, identifier )
    local inputs, setclasses, data, c, r, rstr, len, path, str, out, result,
          pos, pos2, str1, tbl, str2, pi, reps, dim, F, z, pair, mat, i, j,
          idpos, cl, info;

    if not CTblLib.IsMagmaAvailable() then
      return fail;
    elif IsPermGroup( G ) then
      inputs:= [ "SetMemoryLimit(0);", 
                 CTblLib.MagmaStringOfPermGroup( G, "G" ) ];
    elif IsFFEMatrixGroup( G ) then
      inputs:= [ "SetMemoryLimit(0);", 
                 CTblLib.MagmaStringOfFFEMatrixGroup( G, "G" ) ];
    else
      # We do not know how to represent the group in Magma.
      return fail;
    fi;

    setclasses:= ( ValueOption( "setclasses" ) <> false );

    if setclasses then
      if HasConjugacyClasses( G ) then
        # Transfer the known class representatives into the Magma session,
        # and let Magma evaluate the class mapping.
        Add( inputs, "c:= [" );
        if IsPermGroup( G ) then
          data:= LargestMovedPoint( G );
        else
          # Prepare the data for translating the matrices.
          data:= CTblLib.MagmaStringOfFFEMatrixGroupData(
                     GeneratorsOfGroup( G ) );
        fi;
        for c in ConjugacyClasses( G ) do
          r:= Representative( c );
          if IsOne( r ) then
            rstr:= "Id(G)";
          elif IsPerm( r ) then
            rstr:= CTblLib.MagmaStringOfPerm( r, data );
          else
            rstr:= CTblLib.MagmaStringOfFFEMatrix( r, data );
          fi;
          Add( inputs, Concatenation( "< ",
                           String( Order( r ) ), ", ",
                           "G!", rstr, " >," ) );
        od;
        len:= Length( inputs );
        inputs[ len ]:= ReplacedString( inputs[ len ], ">,", "> ];" );
        Append( inputs, [
                          "tbl:= CharacterTable( G );",
                          "if assigned tbl then",
                          "  tbl;",
                          "  mp:= ClassMap( G );",
                          "  if assigned mp then",
                          "\"Class Mapping:\";",
                          "\"[\";",
                          "for i in [ 1 .. #c ] do",
                          "  mp( c[i][2] ), \",\";",
                          "end for;",
                          "\"]\";",
                          "  end if;",
                          "end if;" ] );
      else
        # Let Magma compute and print the classes.
        if IsPermGroup( G ) then
          Append( inputs, [ "tbl:= CharacterTable( G );",
                            "if assigned tbl then",
                            "  tbl;",
                            "  c:= Classes( G );",
                            "  if assigned c then",
                            "\"Class Representatives:\";",
                            "\"[\";",
                            "for i in [ 1 .. #c ] do",
                            "  r:= c[i];",
                            "  if r[1] eq 1 then",
                            "    \"[ 1, () ],\";",
                            "  else",
                            "    \"[ \", r[2], \", \", r[3], \" ],\";",
                            "  end if;",
                            "end for;",
                            "\"]\";",
                            "  end if;",
                            "end if;" ] );
        else
          # Represent nonidentity matrices by lists of strings.
          # Elements in the prime fields can be evaluated as integers,
          # other elements have to be scanned.
          dim:= String( DimensionOfMatrixGroup( G ) );
          Append( inputs, [ "tbl:= CharacterTable( G );",
                            "if assigned tbl then",
                            "  tbl;",
                            "  c:= Classes( G );",
                            "  if assigned c then",
                            "\"Class Representatives:\";",
                            "\"[\";",
                            "for i in [ 1 .. #c ] do",
                            "  r:= c[i];",
                            "  if r[1] eq 1 then",
                            "    \"[ 1, \\\"\\\" ],\";",
                            "  else",
                            "    \"[ \", r[2], \", [\";",
                            "    mat:= r[3];",
                            "    for i in [ 1 .. ", dim, " ] do",
                            "      for j in [ 1 .. ", dim, " ] do",
                            "        \"\\\"\", mat[i][j], \"\\\",\";",
                            "      end for;",
                            "    end for;",
                            "    \"] ],\";",
                            "  end if;",
                            "end for;",
                            "\"]\";",
                            "  end if;",
                            "end if;" ] );
        fi;
      fi;
    else
      Add( inputs, "CharacterTable( G );" );
    fi;

    # Call Magma.
    path:= UserPreference( "CTblLib", "MagmaPath" );
    str:= "";
    out:= OutputTextString( str, true );
    result:= Process( DirectoryCurrent(), path,
                 InputTextString( JoinStringsWithSeparator( inputs, "\n" ) ),
                 out, [] );
    CloseStream( out );

    # Check the output.
    if result <> 0 then
      Info( InfoCharacterTable, 1,
            "CharacterTableComputedByMagma: Process returns ", result );
      return fail;
    fi;

    # Split the output if necessary,
    # and convert the Magma table to a GAP table.
    if setclasses then
      if HasConjugacyClasses( G ) then
        # No class representatives have been returned,
        # but the class mapping tells us how the columns of the table
        # are related to the classes from the group in GAP.
        pos:= PositionSublist( str, "Class Mapping:\n" );
        if pos = fail then
          Error( "CharacterTableComputedByMagma: ",
                 "no class mapping returned" );
        fi;
        pos2:= PositionSublist( str, "Total time", pos );
        str1:= str{ [ 1 .. pos-1 ] };
        tbl:= GAPTableOfMagmaFile( str1, identifier, "string" );

        # Store the group and apply the class mapping.
        str2:= str{ [ pos + 15 .. pos2 - 1 ] };
        SetUnderlyingGroup( tbl, G );
        pi:= EvalString( str2 );
        pi:= PermList( pi );
        if not IsOne( pi ) then
          tbl:= CharacterTableWithSortedClasses( tbl, pi^-1 );
          ResetFilterObj( tbl, HasClassPermutation );
        fi;
        SetConjugacyClasses( tbl, ConjugacyClasses( G ) );
      else
        # The class representatives have been returned.
        pos:= PositionSublist( str, "Class Representatives:\n" );
        if pos = fail then
          Error( "CharacterTableComputedByMagma: ",
                 "no class repres. returned" );
        fi;
        pos2:= PositionSublist( str, "Total time", pos );
        str1:= str{ [ 1 .. pos-1 ] };
        tbl:= GAPTableOfMagmaFile( str1, identifier, "string" );

        # Store group and class representatives.
        str2:= str{ [ pos + 23 .. pos2 - 1 ] };
        SetUnderlyingGroup( tbl, G );
        reps:= EvalString( str2 );
        if IsMatrixGroup( G ) then
          # Rewrite the matrices.
          dim:= DimensionOfMatrixGroup( G );
          F:= FieldOfMatrixGroup( G );
          z:= Concatenation( "Z(", String( Size( F ) ), ")" );
          for pair in reps do
            if pair[2] = "" then
              pair[2]:= One( G );
            else
              mat:= [];
              pos:= 0;
              for i in [ 1 .. dim ] do
                mat[i]:= [];
                for j in [ 1 .. dim ] do
                  pos:= pos + 1;
                  mat[i,j]:= EvalString( ReplacedString( pair[2][ pos ],
                                             "F.1", z ) );
                od;
              od;
              pair[2]:= mat * One( F );
            fi;
          od;
        fi;
        idpos:= fail;
        for i in [ 1 .. Length( reps ) ] do
          if reps[i][1] = 1 then
            reps[i]:= [ 1, One( G ) ];
            idpos:= i;
            break;
          fi;
        od;
        if idpos = fail then
          Error( "no class with the identity element found" );
          Add( reps, [ 1, One( G ) ] );
        fi;
        cl:= List( reps, x -> ConjugacyClass( G, x[2] ) );
        for i in [ 1 .. Length( reps ) ] do
          SetSize( cl[i], reps[i][1] );
        od;
        SetConjugacyClasses( tbl, cl );
        SetConjugacyClasses( G, cl );
      fi;
    else
      # We want only the table,
      # without underlying group and without class representatives.
      tbl:= GAPTableOfMagmaFile( str, identifier, "string" );
      if tbl = fail then
        Error( "CharacterTableComputedByMagma: ",
               "no valid table returned" );
      fi;
      pos2:= PositionSublist( str, "Total time" );
    fi;

    # Store the data about the computation (version, data, runtime).
    pos:= PositionSublist( str, "Magma V" );
    while pos <> 1 and str[ pos-1 ] <> '\n' do
      pos:= PositionSublist( str, "Magma V", pos );
    od;
    info:= str{ [ pos .. Position( str, '\n', pos ) ] };
    Append( info, str{ [ pos2 .. Length( str ) ] } );
    SetInfoText( tbl, Concatenation( "computed using ", Chomp( info ) ) );

    # Return the result.
    return tbl;
end );


#############################################################################
##
#F  CTblLib.IsConjugateViaMagma( <permgroup>, <pi>, <known> )
##
##  Let <permgroup> be a permutation group, <pi> be an element of this group,
##  and <known> be a list of elements of this group.
##  The function returns 'true' if <pi> is conjugate in <permgroup>
##  to at least one element in <known>.
##  Otherwise, the order of the centralizer of <pi> in <permgroup> is
##  returned.
##
CTblLib.IsConjugateViaMagma:= function( permgroup, pi, known )
  local n, path, inputs, str, out, result, pos;

  if not CTblLib.IsMagmaAvailable() then
    return fail;
  fi;

  n:= LargestMovedPoint( permgroup );
  path:= UserPreference( "CTblLib", "MagmaPath" );
  inputs:= [ "SetMemoryLimit(0);",
             CTblLib.MagmaStringOfPermGroup( permgroup, "G" ),
             Concatenation( "p:= G!", CTblLib.MagmaStringOfPerm( pi, n ), ";" ),
             "l:= [" ];
  if Length( known ) > 0 then
    Append( inputs,
          List( known, p -> Concatenation( "G!", CTblLib.MagmaStringOfPerm( p, n ), "," ) ) );
    Remove( inputs[ Length( inputs ) ] );
  fi;
  Append( inputs,
          [ "];",
            "conj:= false;",
            "for q in l do",
            "  conj:= IsConjugate( G, p, q );",
            "  if conj then break; end if;",
            "end for;",
            "if conj then",
            "  print true;",
            "else",       # Do not call '# Class( G, p );'.
            "  print \"#\", # Centralizer( G, p );",
            "end if;" ] );
  str:= "";
  out:= OutputTextString( str, true );
  result:= Process( DirectoryCurrent(), path,
      InputTextString( JoinStringsWithSeparator( inputs, "\n" ) ),
      out, [] );
  CloseStream( out );
  if result <> 0 then
    Error( "Process returned ", result );
  fi;
  pos:= PositionSublist( str, "\n# " );
  if pos <> fail then
    return Int( str{ [ pos + 3 .. Position( str, '\n', pos+1 )-1 ] } );
  elif PositionSublist( str, "true" ) <> fail then
    # 'pi' is conjugate to a perm. in 'known'.
    return true;
  else
    # One possible reason is that 'pi' is not contained in 'permgroup'.
    Error( "Magma failed" );
  fi;
end;


#############################################################################
##
#F  CTblLib.CentralizerOrderViaMagma( <permgroup>, <pi> )
##
##  Let <permgroup> be a permutation group, <pi> be an element of this group.
##  The function returns the order of the centralizer of <pi> in <permgroup>.
##
CTblLib.CentralizerOrderViaMagma:= function( permgroup, pi )
  local n, path, inputs, str, out, result, pos;

  if not CTblLib.IsMagmaAvailable() then
    return fail;
  fi;

  n:= LargestMovedPoint( permgroup );
  path:= UserPreference( "CTblLib", "MagmaPath" );
  inputs:= [ "SetMemoryLimit(0);",
             CTblLib.MagmaStringOfPermGroup( permgroup, "G" ),
             Concatenation( "p:= G!", CTblLib.MagmaStringOfPerm( pi, n ),
                            ";" ) ];
  Append( inputs,
          [ "print \"#\", # Centralizer( G, p );" ] );
  str:= "";
  out:= OutputTextString( str, true );
  result:= Process( DirectoryCurrent(), path,
      InputTextString( JoinStringsWithSeparator( inputs, "\n" ) ),
      out, [] );
  CloseStream( out );
  if result <> 0 then
    Error( "Process returned ", result );
  fi;
  pos:= PositionSublist( str, "\n# " );
  if pos <> fail then
    return Int( str{ [ pos + 3 .. Position( str, '\n', pos+1 )-1 ] } );
  else
    # One possible reason is that 'pi' is not contained in 'permgroup'.
    Error( "Magma failed" );
  fi;
end;


#############################################################################
##
#E

