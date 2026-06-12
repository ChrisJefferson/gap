#############################################################################
##
#W  scanmtx.gi     GAP 4 packages AtlasRep and MeatAxe          Thomas Breuer
#W                                                               Frank Lübeck
##
##  Whenever this file is changed in one of the packages
##  'atlasrep' or 'meataxe',
##  do not forget to update the corresponding file in the other package!
##
##  This file contains the implementation part of the interface routines for
##  reading and writing C-MeatAxe text and binary format,
##  and straight line programs used in the ATLAS of Group Representations.
##
##  The functions 'CMtxBinaryFFMatOrPerm' and 'FFMatOrPermCMtxBinary'
##  were contributed by Frank Lübeck.
##


############################################################################
##
#V  CMeatAxe
##
InstallValue( CMeatAxe,
    rec(
                gennames := [],
                alpha    := "abcdefghijklmnopqrstuvwxyz",
                maxnr    := 0
               ) );


#############################################################################
##
#V  FFLists
#V  FFLogLists
#V  NONNEG_INTEGERS_STRINGS
##
##  The bijection between elements in the finite field with $q$ elements and
##  the integers in the set $\{ 0, 1, \ldots, q-1 \}$ is implemented
##  via lookup tables `l1 = FFList( GF(<q>) )'
##  and `l2 = FFLogList( GF(<q>) )'.
##
##  If the field element <x> corresponds to the integer <i> then
##  the relations $<i> = `Position( FFList( GF(<q>) ), <x> )' - 1$ and
##  $<x> = `FFList( GF(<q>) )'[ <i>+1 ]$ hold.
##
##  If $q = p$ then $<i> = `IntFFE'( <x> )$ holds,
##  which is cheaper to compute than via `Position';
##  Also $<x> = <i> * `Z(p)^0'$ holds, so the lookup table need not be
##  created for large prime fields.
##
##  In order to avoid the calls to `Position' also in the case of non-prime
##  fields, the lookup list `FFLogList( GF(<q>) )' is used.
##  For $<x> = <z>^k$,
##  we have `String( <i> ) = FFLogList( GF(<q>) )[ LogFFE( <x>, <z> ) + 1 ]'.
##
InstallFlushableValue( FFLists, [] );
InstallFlushableValue( FFLogLists, [] );
InstallFlushableValue( NONNEG_INTEGERS_STRINGS, [] );


#############################################################################
##
#F  FFList( <F> )
##
##  (This program was originally written by Meinolf Geck.)
##
InstallGlobalFunction( FFList, function( F )
    local one, sizeF, iso, dim, root, pow, powers, i, elms;

    one:= One( F );
    sizeF:= Size( F );

    if IsBoundGlobal( "IsStandardFiniteField" ) and
       ValueGlobal( "IsStandardFiniteField" )( F ) then
      # Currently we do not cache the list.
      iso:= ValueGlobal( "StandardIsomorphismGF" )( F );
      return List( FFList( GF( sizeF ) ), x -> ImageElm( iso, x ) );
    elif not IsFFE( one ) then
      Error( "no support for the finite field <F> yet" );
#T or support AlgebraicExtension with primitive defining polynomial?
    fi;

    # Now we are in the case of fields constructed via Conway polynomials.
    if not IsBound( FFLists[ sizeF ] ) then
      dim:= DegreeOverPrimeField( F );
      root:= PrimitiveRoot( F );
      pow:= One( root );
      powers:= [ pow ];
      for i in [ 2 .. dim ] do
        pow:= pow * root;
        powers[i]:= pow;
      od;
      elms:= Tuples( [ 0 .. Characteristic( F )-1 ], dim )
             * Reversed( powers );
      ConvertToVectorRep( elms, sizeF );
      FFLists[ sizeF ]:= elms;
    fi;
      
    return FFLists[ sizeF ];
end );


#############################################################################
##
#F  FFLogList( <F> )
##
InstallGlobalFunction( FFLogList, function( F )
    local sizeF, fflist, z, result, i;

    sizeF:= Size( F );

    if not IsBound( FFLogLists[ sizeF ] ) then
      fflist:= FFList( F );
      z:= Z( sizeF );
      result:= [ 0 ];
      result[ Length( fflist ) ]:= 0;
      for i in [ 2 .. Length( fflist ) ] do
        result[ LogFFE( fflist[i], z ) + 1 ]:= String( i-1 );
      od;
      FFLogLists[ sizeF ]:= result;
    fi;

    return FFLogLists[ sizeF ];
#T  ???
end );


#############################################################################
##
#F  IntegerStrings( <q> )
##
InstallGlobalFunction( IntegerStrings, function( q )
    local i;
    for i in [ Length( NONNEG_INTEGERS_STRINGS ) + 1 .. q ] do
      NONNEG_INTEGERS_STRINGS[i]:= String( i-1 );
    od;
    return NONNEG_INTEGERS_STRINGS;
end );


#############################################################################
##
#F  CMeatAxeFileHeaderInfo( <string> )
##
InstallGlobalFunction( "CMeatAxeFileHeaderInfo", function( string )
    local lline, header, pos, line, degree;

    # Remove a comment part if necessary.
    pos:= Position( string, '#' );
    if pos <> fail then
      string:= string{ [ 1 .. pos ] };
    fi;

    # Split the header string, and convert the entries to integers.
    header:= SplitString( string, "", " \n" );
    lline:= List( header, Int );
    if fail in lline then

      # If the header is valid then it is of new type.
      if Length( header ) = 2 and header[1] = "permutation" then

        line:= [ 12, 1,, 1 ];
        if StartsWith( header[2], "degree=" ) then
          degree:= Int( header[2]{ [ 8 .. Length( header[2] ) ] } );
          line[3]:= degree;
        fi;

      elif Length( header ) = 4 and header[1] = "matrix" then

        line:= [ 6 ];
        if StartsWith( header[2], "field=" ) then
          line[2]:= Int( header[2]{ [ 7 .. Length( header[2] ) ] } );
          if IsInt( line[2] ) and line[2] < 10 then
            line[1]:= 1;
          fi;
        fi;
        if StartsWith( header[3], "rows=" ) then
          line[3]:= Int( header[3]{ [ 6 .. Length( header[3] ) ] } );
        fi;
        if StartsWith( header[4], "cols=" ) then
          line[4]:= Int( header[4]{ [ 6 .. Length( header[4] ) ] } );
        fi;

      elif Length( header ) = 4 and header[1] = "integer"
                                and header[2] = "matrix" then

        line:= [ 8, 0 ];
        if StartsWith( header[3], "rows=" ) then
          line[3]:= Int( header[3]{ [ 6 .. Length( header[3] ) ] } );
        fi;
        if StartsWith( header[4], "cols=" ) then
          line[4]:= Int( header[4]{ [ 6 .. Length( header[4] ) ] } );
        fi;

      fi;

      if fail in line or Number( line ) <> 4 then
        Info( InfoCMeatAxe, 1,
              "corrupted (new) MeatAxe file header" );
        return fail;
      fi;

    else

      # The header is of old type, consisting of four integers.
      if Length( lline ) = 3 and lline[1] = 12 then

        # We may be dealing with permutations of a degree requiring
        # (at least) six digits, for example the header for a permutation
        # on $100000$ points can be `12     1100000     1'.
        line:= String( lline[2] );
        if line[1] = '1' then
          lline[4]:= lline[3];
          lline[3]:= Int( line{ [ 2 .. Length( line ) ] } );
          lline[2]:= 1;
        fi;

      fi;

      if Length( lline ) <> 4 then
        Info( InfoCMeatAxe, 1,
              "corrupted (old) MeatAxe file header" );
        return fail;
      fi;
      line:= lline;

    fi;

    return line;
end );


#############################################################################
##
#F  ScanMeatAxeFile( <filename>[, <q>] )
#F  ScanMeatAxeFile( <string>[, <q>], "string" )
##
InstallGlobalFunction( ScanMeatAxeFile, function( arg )
    local PermListWithTest,
          filename,
          string,
          file,
          line,
          q,
          headlen,
          mode,
          pos,
          pos2,
          degree,
          result,
          offset,
          j,
          nrows,
          givenF,
          F,
          one,
          i,
          ncols,
          Fsize,
          fflist,
          len,
          newline;

    PermListWithTest:= function( list )
      local perm;

      perm:= PermList( list );
      if perm = fail then
        if ForAny( list, x -> not IsInt( x ) ) then
          Info( InfoCMeatAxe, 1,
                "non-permutation in file, contains ",
                Filtered( list, x -> not IsInt( x ) ) );
        fi;
        Info( InfoCMeatAxe, 1,
              "non-permutation in file,\n#I  ",
              Difference( [ 1 .. degree ], list ), " missing, ",
              List( Filtered( Collected( list ),
                    x -> x[2] <> 1 ), x -> x[1] ), " duplicate" );
      fi;
      return perm;
    end;

    if    Length( arg ) = 1
       or ( Length( arg ) = 2 and IsPosInt( arg[2] ) ) then

      filename:= arg[1];

      # Do we want to read the file *fast* (but using more space)?
      AGR.InfoRead( "#I  reading `", filename, "' started\n" );
      if UserPreference( "AtlasRep", "HowToReadMeatAxeTextFiles" ) = "fast"
         then
        string:= AGR.StringFile( filename );
        if Length( arg ) = 1 then
          return ScanMeatAxeFile( string, "string" );
        else
          return ScanMeatAxeFile( string, arg[2], "string" );
        fi;
      fi;

      file:= InputTextFile( filename );
      if file = fail then
        Error( "cannot create input stream for file <filename>" );
      fi;
      line:= ReadLine( file );
      if line = fail then
        Info( InfoCMeatAxe, 1, "no first line exists" );
        CloseStream( file );
        return fail;
      fi;
      while not '\n' in line do
        Append( line, ReadLine( file ) );
      od;
      if Length( arg ) = 2 then
        q:= arg[2];
      fi;

    elif    ( Length( arg ) = 2 and IsString( arg[1] ) and arg[2] = "string" )
         or ( Length( arg ) = 3 and IsString( arg[1] ) and IsPosInt( arg[2] )
                                and arg[3] = "string" ) then

      # Cut out the header line.
      string:= arg[1];
      headlen:= Position( string, '\n' );
      if headlen = fail then
        return fail;
      fi;
      line:= string{ [ 1 .. headlen-1 ] };
      string:= ShallowCopy( string );
      string{ [ 1 .. headlen ] }:= ListWithIdenticalEntries( headlen, ' ' );
      if Length( arg ) = 3 then
        q:= arg[2];
      fi;

    else
      Error( "usage: ScanMeatAxeFile( <filename>[, <q>] )" );
    fi;

    # Interpret the first line as file header.
    # From the first line, determine whether a matrix or a permutation
    # is to be read.
    line:= CMeatAxeFileHeaderInfo( line );
    if line = fail then
      Info( InfoCMeatAxe, 1, "corrupted file header" );
      if not IsBound( string ) then
        CloseStream( file );
      fi;
      return fail;
    fi;

    mode:= line[1];

    if mode in [ 2, 12, 8 ] then

      # a permutation, to be converted to a matrix,
      # or a list of permutations,
      # or an integer matrix
      if not IsBound( string ) then
        string:= AGR.StringFile( filename );

        # Omit the header line.
        headlen:= Position( string, '\n' );
        string{ [ 1 .. headlen ] }:= ListWithIdenticalEntries( headlen, ' ' );

        CloseStream( file );
        AGR.InfoRead( "#I  reading `", filename, "' done\n" );
      fi;

      # Remove comment parts
      # (not really clever, but we actually do not expect comments).
      pos:= Position( string, '#' );
      while pos <> fail do
        pos2:= Position( string, '\n', pos );
        if pos2 = fail then
          pos2:= Length( string ) + 1;
        fi;
        string:= Concatenation( string{ [ 1 .. pos-1 ] },
                                string{ [ pos2 .. Length( string ) ] } );
        pos:= Position( string, '#' );
      od;

      # Split the line into substrings representing integers.
      # (Admittedly, the code looks ugly, but simply calling `SplitString'
      # and `Int' is slower, and calling `SplitString' and `EvalString'
      # would be even slower than that.)
      if 12 < headlen then
        string{ [ 1 .. 13 ] }:= "SMFSTRING:=[ ";
      else
        string:= Concatenation( "SMFSTRING:=[ ", string );
      fi;
      NormalizeWhitespace( string );
      pos:= Position( string, ' ' );
      pos:= Position( string, ' ', pos );
      while pos <> fail do
        string[ pos ]:= ',';
        pos:= Position( string, ' ', pos );
      od;
      Append( string, "];" );
      file:= InputTextString( string );
      Read( file );
      string:= SMFSTRING;
      SMFSTRING:= "";

      if mode = 12 then

        # mode = 12:
        # a list of permutations (in free format)
        degree:= line[3];
        result:= [];
        if Length( string ) <> degree * line[4] then
          Info( InfoCMeatAxe, 1, "corrupted file, wrong number of entries" );
          return fail;
        fi;
        if line[4] = 1 then
          # This is the usual case (avoid duplicating the list).
          result[1]:= PermListWithTest( string );
        else
          offset:= 0;
          for j in [ 1 .. line[4] ] do
            result[j]:=
                PermListWithTest( string{ [ offset+1 .. offset+degree ] } );
            offset:= offset + degree;
          od;
        fi;
        if fail in result then
          return fail;
        fi;

      elif mode = 2 then

        # mode = 2:
        # a permutation, to be converted to a matrix
        # (Note that we cannot leave the task to `PermutationMat'
        # because we admit also non-square results.)
        if not IsBound( q ) then
          q:= line[2];
        fi;
        nrows:= line[3];
        if Length( string ) <> nrows then
          Info( InfoCMeatAxe, 1, "corrupted file" );
          return fail;
        fi;
        givenF:= ValueOption( "inforecord" );
        if givenF <> fail and IsBound( givenF.givenRing ) then
          F:= givenF.givenRing;
        else
          F:= GF(q);
        fi;

        result:= NullMat( nrows, line[4], F );
        one:= One( F );
        for i in [ 1 .. nrows ] do
          result[ i, string[i] ]:= one;
        od;

        # Convert the matrix to the compressed representation.
        ImmutableMatrix( F, result, true );

      else

        # mode = 8:
        # an integer matrix
        nrows:= line[3];
        ncols:= line[4];
        if Length( string ) <> nrows * ncols then
          Info( InfoCMeatAxe, 1, "corrupted file" );
          return fail;
        fi;
        result:= NullMat( nrows, ncols );
        pos:= 1;
        for i in [ 1 .. nrows ] do
          for j in [ 1 .. ncols ] do
            result[i,j]:= string[ pos ];
            pos:= pos + 1;
          od;
        od;

      fi;

    elif mode = 1 then

      # a matrix, in fixed format
      Fsize:= line[2];
      if Fsize > 10 then
        Info( InfoCMeatAxe, 1, "too large field for mode 1 matrix" );
        return fail;
#T Extend the scope of mode 1, as proposed by Richard:
#T Allow A .. Z for 10 .. 35 and a .. z for -26 .. -1.
      fi;

      givenF:= ValueOption( "inforecord" );
      if givenF <> fail and IsBound( givenF.givenRing ) then
        F:= givenF.givenRing;
      else
        F:= GF( Fsize );
      fi;

      fflist:= FFList( F );
      fflist:= fflist{ Concatenation( ListWithIdenticalEntries( 47, 1 ),
                                      [ 1 .. Length( fflist ) ] ) };
      nrows:= line[3];
      ncols:= line[4];
      result:= [];

      if IsBound( string ) then

        # Remove comment parts
        # (not really clever, but we actually do not expect comments).
        pos:= Position( string, '#' );
        while pos <> fail do
          pos2:= Position( string, '\n', pos );
          if pos2 = fail then
            pos2:= Length( string ) + 1;
          fi;
          string:= Concatenation( string{ [ 1 .. pos-1 ] },
                                  string{ [ pos2 .. Length( string ) ] } );
          pos:= Position( string, '#' );
        od;

        # The string is available in GAP.
        RemoveCharacters( string, " \n" );
        if Length( string ) <> nrows * ncols then
          Info( InfoCMeatAxe, 1, "string length does not fit" );
          return fail;
        fi;
        pos:= 0;
        for i in [ 1 .. nrows ] do
          result[i]:= fflist{ INTLIST_STRING(
                                 string{ [ pos+1 .. pos+ncols ] }, -1 ) };
          pos:= pos + ncols;
        od;

      else

        # The file is read line by line (for space reasons).
        line:= "";
        len:= 0;
        for i in [ 1 .. nrows ] do

          # Read enough lines from the file to fill the `i'-th row.
          while len < ncols do
            newline:= ReadLine( file );
            if newline = fail then
              Info( InfoCMeatAxe, 1, "corrupted file" );
              CloseStream( file );
              return fail;
            fi;
while not '\n' in newline do
  Append( newline, ReadLine( file ) );
od;

            # Remove comment parts.
            pos:= Position( newline, '#' );
            if pos <> fail then
              newline:= newline{ [ 1 .. pos-1 ] };
            fi;

            RemoveCharacters( newline, " \n" );
            Append( line, newline );
            len:= len + Length( newline );
          od;
          result[i] := fflist{ INTLIST_STRING( line{ [ 1 .. ncols ] }, -1 ) };
          line:= line{ [ ncols + 1 .. len ] };
          len:= len - ncols;

        od;

        # Close the stream.
        CloseStream( file );
        AGR.InfoRead( "#I  reading `", filename, "' done\n" );

      fi;

      # Convert further.
      ImmutableMatrix( F, result, true );

    elif mode in [ 3, 4, 5, 6 ] then

      # a matrix, in various free formats:
      # 3 means matrix over GF(q), 10 < q < 100;
      # 4 means matrix over GF(q), 100 < q < 10^6;
      # 5 means matrix of integers, to be reduced modulo the prime q;
      # 6 means matrix over GF(q), 10 < q.
      # (Prime fields could be treated in a special way,
      # without calling `FFList'; but this seems to yield no speedup,
      # except in exotic cases where `FFList' itself is the most expensive
      # part of the computation.)
      Fsize:= line[2];
      F:= GF( Fsize );

      givenF:= ValueOption( "inforecord" );
      if givenF <> fail and IsBound( givenF.givenRing ) then
        F:= givenF.givenRing;
      else
        F:= GF( Fsize );
      fi;
      nrows:= line[3];
      ncols:= line[4];
      result:= [];
      if not IsBound( q ) then
        q:= Fsize;
      fi;

      if mode = 5 then
        one:= One( F );
      else
        fflist:= FFList( F );
      fi;

      # The case of a string that is available in GAP is dealt with
      # in parallel with the case of a file that is read line by line
      # (for space reasons).
      if IsBound( string ) then

        # Remove comment parts if applicable.
        # (not really clever, but we actually do not expect comments).
        while '#' in string do
          pos:= Position( string, '#' );
          pos2:= Position( string, '\n', pos );
          if pos2 = fail then
            pos2:= Length( string ) + 1;
          fi;
          string:= Concatenation( string{ [ 1 .. pos-1 ] },
                                  string{ [ pos2 .. Length( string ) ] } );
        od;

        # Split the string into substrings representing numbers.
        # (Admittedly, the code looks ugly, but simply calling `SplitString'
        # and `Int' is slower, and calling `SplitString' and `EvalString'
        # would be even slower than that.)
        if 12 < headlen then
          string{ [ 1 .. 13 ] }:= "SMFSTRING:=[ ";
        else
          string:= Concatenation( "SMFSTRING:=[ ", string );
        fi;
        NormalizeWhitespace( string );
        pos:= Position( string, ' ' );
        pos:= Position( string, ' ', pos );
        while pos <> fail do
          string[ pos ]:= ',';
          pos:= Position( string, ' ', pos );
        od;
        Append( string, "];" );
        file:= InputTextString( string );
        Read( file );
        string:= SMFSTRING;
        SMFSTRING:= "";
        line:= string;

        if Length( line ) <> nrows * ncols then
          Info( InfoCMeatAxe, 1, "corrupted file" );
          return fail;
        fi;

        pos:= 0;
        for i in [ 1 .. nrows ] do
          if mode = 5 then
            # an integer matrix (in free format), to be reduced mod a prime
            result[i]:= ( line{ [ pos+1 .. pos+ncols ] } + 1 ) * one;
          else
            result[i]:= fflist{ line{ [ pos+1 .. pos+ncols ] } + 1 };
          fi;
          pos:= pos + ncols;
        od;

      else

        # The file is read line by line (for space reasons).
        line:= "";
        len:= 0;

        for i in [ 1 .. nrows ] do

          # Read enough lines from the file to fill the `i'-th row.
          while len < ncols do
            newline:= ReadLine( file );
            if newline = fail then
              Info( InfoCMeatAxe, 1, "corrupted file" );
              CloseStream( file );
              return fail;
            fi;
while not '\n' in newline do
  Append( newline, ReadLine( file ) );
od;

            # Remove comment parts.
            pos:= Position( newline, '#' );
            if pos <> fail then
              newline:= newline{ [ 1 .. pos-1 ] };
            fi;

            newline:= List( SplitString( newline, "", " \n" ), Int );
            Append( line, newline );
            len:= len + Length( newline );
          od;

          if mode = 5 then
            # an integer matrix (in free format), to be reduced mod a prime
            result[i]:= ( line{ [ 1 .. ncols ] } + 1 ) * one;
          else
            result[i]:= fflist{ line{ [ 1 .. ncols ] } + 1 };
          fi;
          line:= line{ [ ncols + 1 .. len ] };
          len:= len - ncols;

        od;

        # Close the stream.
        CloseStream( file );
        AGR.InfoRead( "#I  reading `", filename, "' done\n" );

      fi;

      # Convert further.
      MakeImmutable( result );
      ConvertToMatrixRep( result, q );

    else
      Info( InfoCMeatAxe, 1, "unknown mode" );
      return fail;
    fi;

    return result;
end );


#############################################################################
##
#M  MeatAxeString( <mat>, <q> )
##
InstallMethod( MeatAxeString,
    [ "IsMatrixOrMatrixObj", "IsPosInt" ],
    function( mat, q )
    local nrows,     # number of rows of `mat'
          ncols,     # number of columns of `mat'
          one,       # identity element of the field of matrix entries
          zero,      # zero element of the field of matrix entries
          perm,      # list of perm. images if `mat' is a perm. matrix
          i,         # loop over the rows of `mat'
          noone,     # no `one' found yet in the current row
          j,         # loop over the columns of `mat'
          mode,      # mode of the MeatAxe string (first header entry)
          header,    # mode of the header
          values,
          linelen,
          nol,
          tail,      #
          fflist,    #
          len,
          str,       # MeatAxe string, result
          k,
          l,
          N,
          d,
          ffloglist, #
          z;         #

    nrows:= NumberRows( mat );
    ncols:= NumberColumns( mat );

    # Check that `q' and `mat' are compatible.
    if not IsPrimePowerInt( q ) or ( q mod Characteristic( mat ) <> 0 ) then
      Error( "<q> and the characteristic of <mat> are incompatible" );
    fi;

    one:= One( mat[1,1] );
    zero:= Zero( one );
    perm:= fail;
    if UserPreference( "AtlasRep", "WriteMeatAxeFilesOfMode2" ) = true then
      # If the matrix is a ``generalized permutation matrix''
      # then construct a string of MeatAxe mode 2.
      perm:= [];
      for i in [ 1 .. nrows ] do
        noone:= true;
        for j in [ 1 .. ncols ] do
          if mat[i,j] = one then
            if noone and not j in perm then
              perm[i]:= j;
              noone:= false;
            else
              perm:= fail;
              break;
            fi;
          elif mat[i,j] <> zero then
            perm:= fail;
            break;
          fi;
        od;
        if perm = fail then
          break;
        fi;
      od;
    fi;

    # Start with the header line.
    # We try to keep the files as small as possible by using the (old)
    # mode `1' whenever possible.
    if perm <> fail then
      mode:= "2";
    elif q < 10 then
      mode:= "1";
    else
      mode:= "6";
    fi;

    header:= UserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles" );
    if   header= "numeric" then
      header:= Concatenation( mode, " ", String( q ), " ",
                   String( nrows ), " ", String( ncols ), "\n" );
    elif header= "numeric (fixed)" then
      header:= Concatenation( String( mode, 6 ), " ", String( q, 5 ), " ",
                   String( nrows, 5 ), " ", String( ncols, 5 ), "\n" );
    elif header= "textual" then
      header:= Concatenation( "matrix field=", String( q ), " rows=",
                   String( nrows ), " cols=", String( ncols ), "\n" );
    else
      Error( "the user preference 'WriteHeaderFormatOfMeatAxeFiles' must ",
             "be one of \"numeric\", \"numeric (fixed)\", \"textual\"" );
    fi;

    # Add the matrix entries.
    if mode = "1" then

      # Set the parameters for filling lines in the fixed format
      values:= "0123456789";
      linelen:= 80;
      nol:= Int( ncols / linelen );
      tail:= [ nol * linelen + 1 .. ncols ];
      fflist:= FFList( GF(q) );

      # Compute the length of the string.
      len:= Length( header )
            + nrows * ( ncols + 1 + Int( ( ncols - 1 ) / linelen ) );
      str:= EmptyString( len );
      Append( str, header );

      for i in [ 1 .. nrows ] do
        j:= 1;
        for k in [ 0 .. nol-1 ] do
          for l in [ 1 .. linelen ] do
            Add( str, values[ Position( fflist, mat[i,j] ) ] );
            j:= j + 1;
          od;
          Add( str, '\n' );
        od;
        if not IsEmpty( tail ) then
          for j in tail do
            Add( str, values[ Position( fflist, mat[i,j] ) ] );
          od;
          Add( str, '\n' );
        fi;
      od;

    elif mode = "2" then

      # Compute the length of the string.
      N:= Length( perm );
      k:= LogInt( N, 10 );
      d:= 0;
      for i in [ 1 .. k ] do
        d:= d * 10;
        d:= d + i;
      od;
      len:= Length( header )
            + ( k + 2 ) * N - 9 * d;
      str:= EmptyString( len );
      Append( str, header );

      for i in perm do
        Append( str, String( i ) );
        Add( str, '\n' );
      od;

    else

      # free format
      # The length of the result depends on the matrix entries,
      # thus we start with an estimate of the length.
      len:= Length( header )
            + nrows * ncols * Int( ( LogInt( q, 10 ) + 4 ) / 2 );
      str:= EmptyString( len );
      Append( str, header );

      if IsPrimeInt( q ) then
        # Avoid the call to `FFList', and expensive `Position' calls.
        # Also store the strings once;
        # this cache avoids garbage collections and thus saves time
        # if the matrix is not too small, compared to the field.
        values:= IntegerStrings( q );
        for i in [ 1 .. nrows ] do
          for j in [ 1 .. ncols ] do
            Append( str, values[ IntFFE( mat[i,j] ) + 1 ] );
            Add( str, '\n' );
          od;
        od;
      else
        # Avoid expensive `Position' calls for the result of `FFList'.
        ffloglist:= FFLogList( GF(q) );
        z:= Z(q);
        for i in [ 1 .. nrows ] do
          for j in [ 1 .. ncols ] do
            if mat[i,j] = zero then
              Append( str, "0\n" );
            else
              Append( str, ffloglist[ LogFFE( mat[i,j], z ) + 1 ] );
              Add( str, '\n' );
            fi;
          od;
        od;
      fi;

      ShrinkAllocationString( str );

    fi;

    # Return the result.
    return str;
    end );


#############################################################################
##
#M  MeatAxeString( <perms>, <degree> )
##
InstallMethod( MeatAxeString,
    [ "IsPermCollection and IsList", "IsPosInt" ],
    function( perms, degree )
    local header, k, d, len, str, perm, i;

    # Start with the header line.
    header:= UserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles" );
    if   header= "numeric" then
      header:= Concatenation( "12 1 ", String( degree ), " ",
                   String( Length( perms ) ), "\n" );
    elif header= "numeric (fixed)" then
      header:= Concatenation( "    12     1 ", String( degree, 5 ), " ",
                   String( Length( perms ), 5 ), "\n" );
    elif header= "textual" then
      if Length( perms ) <> 1 then
        Error( "<perms> must have length 1 if the user preference ",
               "\"WriteHeaderFormatOfMeatAxeFiles\" has the value ",
               "\"textual\"" );
      fi;
      header:= Concatenation( "permutation degree=", String( degree ), "\n" );
    else
      Error( "the user preference 'WriteHeaderFormatOfMeatAxeFiles' must ",
             "be one of \"numeric\", \"numeric (fixed)\", \"textual\"" );
    fi;

    # Compute the length of the string.
    k:= LogInt( degree, 10 );
    d:= 0;
    for i in [ 1 .. k ] do
      d:= d * 10;
      d:= d + i;
    od;
    len:= Length( header )
          + ( k + 2 ) * degree - 9 * d;
    str:= EmptyString( len );
    Append( str, header );

    # Add the images.
    for perm in perms do
      for i in [ 1 .. degree ] do
        Append( str, String( i ^ perm ) );
        Add( str, '\n' );
      od;
    od;

    # Return the result.
    return str;
    end );


#############################################################################
##
#M  MeatAxeString( <perm>, <q>, <dims> )
##
InstallMethod( MeatAxeString,
    [ "IsPerm", "IsPosInt", "IsList" ],
    function( perm, q, dims )
    local header, str, i;

    # Start with the header line.
    # (The mode is `2': a permutation, to be converted to a matrix.)
    header:= UserPreference( "AtlasRep", "WriteHeaderFormatOfMeatAxeFiles" );
    if   header = "numeric" then
      str:= "2 ";                         # mode,
      Append( str, String( q ) );         # field size,
      Append( str, " " );
      Append( str, String( dims[1] ) );   # number of rows,
      Append( str, " " );
      Append( str, String( dims[2] ) );   # number of columns
      Append( str, "\n" );
    elif header = "numeric (fixed)" then
      str:= "     2 ";
      Append( str, String( q, 5 ) );
      Append( str, " " );
      Append( str, String( dims[1], 5 ) );
      Append( str, " " );
      Append( str, String( dims[2], 5 ) );
      Append( str, "\n" );
    elif header = "textual" then
#T does zcv support this at all?
      str:= "permutation degree=";
      Append( str, String( q ) );         # field size,
      Append( str, "\n" );
    else
      Error( "the user preference 'WriteHeaderFormatOfMeatAxeFiles' must ",
             "be one of \"numeric\", \"numeric (fixed)\", \"textual\"" );
    fi;

    # Add the images.
    for i in [ 1 .. dims[1] ] do
      Append( str, String( i ^ perm ) );
      Add( str, '\n' );
    od;

    # Return the result.
    return str;
    end );


#############################################################################
##
#M  MeatAxeString( <intmat> )
##
##  This is supported only for integer matrices
##  and only with the new header format.
##
InstallMethod( MeatAxeString,
    [ "IsMatrixOrMatrixObj" ],
    function( intmat )
    local str, ncols, i, j, entry;

    # Start with the header line.
    str:= "integer matrix rows=";
    Append( str, String( Length( intmat ) ) );
    Append( str, " cols=" );
    Append( str, String( Length( intmat[1] ) ) );
    Append( str, "\n" );

    ncols:= NumberColumns( intmat );
    for i in [ 1 .. NumberRows( intmat ) ] do
      for j in [ 1 .. ncols ] do
        entry:= intmat[i,j];
        if not IsInt( entry ) then
          Error( "in characteristic zero, ",
                 "only integer matrices are supported by MeatAxeString" );
        fi;
        Append( str, String( entry ) );
        Append( str, " " );
      od;
      Add( str, '\n' );
    od;

    # Return the result.
    return str;
    end );


#############################################################################
##
#F  CMtxBinaryFFMatOrPerm( <mat>, <q>, <outfile> )
#F  CMtxBinaryFFMatOrPerm( <perm>, <deg>, <outfile>[, <base>] )
##
InstallGlobalFunction( CMtxBinaryFFMatOrPerm, function( arg )
  local mat, q, outfile, res, qr, i, imgs, f, nrows, ncols, a, epb, qpwrs,
        ffloglist, z, len, ind, j, x;

  if Length( arg ) < 3 or 4 < Length( arg ) then
    Error( "usage: ",
           "CMtxBinaryFFMatOrPerm( <perm>, <deg>, <outfile>[, <base>] )" );
  fi;
  mat:= arg[1];
  q:= arg[2];
  outfile:= arg[3];

  if IsPerm( mat ) then
    res:= [ 255, 255, 255, 255 ];
    qr:= q;
    for i in [ 1 .. 4 ] do
      Add( res, RemInt( qr, 256 ) );
      qr:= QuoInt( qr, 256 );
    od;
    Append( res, [ 1, 0, 0, 0 ] );
    imgs:= OnTuples( [ 1 .. q ], mat );
    if Length( arg ) = 4 and arg[4] = 0 then
      imgs:= imgs - 1;
    fi;
    for qr in imgs do
      for i in [ 1 .. 4 ] do
        Add( res, RemInt( qr, 256 ) );
        qr:= QuoInt( qr, 256 );
      od;
    od;
    f:= OutputTextFile( outfile, false );
    WriteAll( f, STRING_SINTLIST( res ) );
  elif q <= 256 then
    nrows:= NumberRows( mat );
    ncols:= NumberColumns( mat );
    # ff elts per byte
    a := q;
    epb := 0;
    while a<=256 do
      a := a*q;
      epb := epb+1;
    od;
    # q-powers
    qpwrs := List([epb-1,epb-2..0], i-> q^i);
    # open outfile
    f := OutputTextFile(outfile, false);
    # header is 12 = 3x4 bytes, (field size, nrrows, nrcols),
    # each  number in 256-adic decomposition, least significant first
    res := [];
    for a in [q,Length(mat),Length(mat[1])] do
      qr := [a,0];
      for i in [1..4] do
        qr := QuotientRemainder(qr[1],256);
        Add(res,qr[2]);
      od;
    od;
    WriteAll(f, STRING_SINTLIST(res));
    # now the data, pack each epb entries in one byte, weighted with qpwrs
    ffloglist:= List(FFLogList( GF(q) ), Int);
    z:= Z(q);
    len := QuoInt(ncols, epb);
    if len * epb < ncols then
      len := len+1;
    fi;
    for i in [ 1 .. nrows ] do
      res := 0*[1..len];
      ind := [1,1];
      for j in [ 1 .. ncols ] do
        x:= mat[i,j];
        if not IsZero(x) then
          a := ffloglist[LogFFE(x, z) + 1];
          res[ind[1]] := res[ind[1]] + a*qpwrs[ind[2]];
        fi;
        if ind[2] = epb then
          ind := [ind[1]+1, 1];
        else
          ind[2] := ind[2]+1;
        fi;
      od;
      WriteAll(f, STRING_SINTLIST(res));
    od;
  else
    Error( "<q> must be at most 256" );
  fi;
  CloseStream(f);
end );


#############################################################################
##
#F  FFMatOrPermCMtxBinary( <fname> )
##
InstallGlobalFunction( FFMatOrPermCMtxBinary, function( fname )
  local f, head, v, q, deg, bytes, list, j, zero, i, res, nrows, ncols, a,
        epb, lenrow, fflist, poslist, eltsbyte, row;
  # open file and read first 12 bytes as header
  # header is 12 = 3x4 bytes,
  # (in the matrix case field size, nrrows, nrcols;
  # in the permutation case -1, degree, 1),
  # each  number in 256-adic decomposition, least significant first
  f := InputTextFile(fname);
  if f = fail then
    Info( InfoCMeatAxe, 1,
          "cannot open ", fname );
    return fail;
  fi;
  head := ReadAll(f, 12);
  if head = fail or Length( head ) < 12 then
    Info( InfoCMeatAxe, 1,
          "file too short: ", fname );
    CloseStream( f );
    return fail;
  fi;
  head := INTLIST_STRING(head, 1);
  v := [1, 256, 256^2, 256^3];
  q := v * head{[1..4]};
  if q = 4294967295 then
    # permutation
    deg:= v * head{ [ 5 .. 8 ] };
    bytes:= INTLIST_STRING( ReadAll( f ), 1 );
    CloseStream( f );
    list:= [];
    j:= 1;
    zero:= false;
    for i in [ 1 .. deg ] do
      list[i]:= v * bytes{ [ j .. j+3 ] };
      if list[i] = 0 then
        zero:= true;
      fi;
      j:= j + 4;
    od;
    if zero then
      # format used in C-MeatAxe 2.4 (zero-based): add 1 to all entries
      for i in [ 1 .. deg ] do
        list[i]:= list[i] + 1;
      od;
    fi;
    res:= PermList( list );
    # ugly hack:
    # several of the data files on the server are stored in a wrong format.
    if res = fail then
      v:= [ 256^3, 256^2, 256, 1 ];
      j:= 1;
      zero:= false;
      for i in [ 1 .. deg ] do
        list[i]:= v * bytes{ [ j .. j+3 ] };
        if list[i] = 0 then
          zero:= true;
        fi;
        j:= j + 4;
      od;
      if zero then
        # format used in C-MeatAxe 2.4 (zero-based): add 1 to all entries
        for i in [ 1 .. deg ] do
          list[i]:= list[i] + 1;
        od;
      fi;
      res:= PermList( list );
      if res = fail then
        Info( InfoCMeatAxe, 1,
              "not a permutation: ", fname );
      fi;
    fi;
  else
    # matrix
    nrows := v * head{[5..8]};
    ncols := v * head{[9..12]};
    # ff elts per byte
    a := q;
    epb := 0;
    while a<=256 do
      a := a*q;
      epb := epb+1;
    od;
    # length of row in bytes
    lenrow := QuoInt(ncols, epb);
    if lenrow*epb < ncols then
      lenrow := lenrow+1;
    fi;
    # map from bytes to element lists
    fflist := FFList(GF(q));
    poslist := Cartesian(List([1..epb], i-> [0..q-1]));
    eltsbyte := List(poslist, a-> fflist{a+1});
    # now read line by line
    res := [];
    for i in [1..nrows] do
      bytes := ReadAll(f, lenrow);
      bytes := INTLIST_STRING(bytes, 1);
      row := Concatenation(eltsbyte{bytes+1});
      while Length(row) > ncols do
        Unbind(row[Length(row)]);
      od;
      ConvertToVectorRep(row, q);
      Add(res, row);
    od;
    CloseStream(f);
    ConvertToMatrixRep(res);
  fi;
  return res;
end );


#############################################################################
##
#F  ScanStraightLineProgramOrDecision( <strdata>, <mode> )
##
BindGlobal( "ScanStraightLineProgramOrDecision", function( strdata, mode )
    local data, echo, line, pos, labels, nrinputs, i, lines, output, a, b, c,
          outputs, result, search;

    data:= [];
    echo:= [];
    for line in SplitString( strdata, "", "\n" ) do

      # Omit empty lines and comment parts.
      if   4 < Length( line ) and line{ [ 1 .. 4 ] } = "echo" then
        Add( echo, line );
      elif not IsEmpty( line ) then
        pos:= Position( line, '#' );
        if pos <> fail then
          line:= line{ [ 1 .. pos-1 ] };
        fi;
        line:= SplitString( line, "", " \n" );
        if not IsEmpty( line ) then
          Add( data, line );
        fi;
      fi;

    od;

    # Determine the labels that occur.
    labels:= [];
    nrinputs:= 0;
    if IsEmpty( data ) or data[1][1] <> "inp" then

      # There is no `inp' line.
      # The default input is given by the labels `1' and `2'.
      labels:=[ "1", "2" ];
      nrinputs:= 2;

    fi;
    for line in data do
      if line[1] = "inp" then
        if Length( line ) = 2 and Int( line[2] ) <> fail then
          Append( labels, List( [ 1 .. Int( line[2] ) ], String ) );
          nrinputs:= nrinputs + Int( line[2] );
        elif Int( line[2] ) = Length( line ) - 2 then
          Append( labels, line{ [ 3 .. Length( line ) ] } );
          nrinputs:= nrinputs + Length( line ) - 2;
        else
          Info( InfoCMeatAxe, 1, "corrupted line `", line, "'" );
          return fail;
        fi;
      elif not ( line[1] in [ "cjr", "chor" ] ) then
        i:= Length( line );
        if not line[i] in labels then
          Add( labels, line[i] );
        fi;
      fi;
    od;

    # Translate the lines.
    lines:= [];
    output:= [];
    c:= 0;
    for line in data do
      if line[1] = "oup" or line[1] = "op" then

        Add( output, line );

      elif line[1] <> "inp" then

        if   line[1] = "mu" and Length( line ) = 4 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          c:= Position( labels, line[4] );
          Add( lines, [ [ a, 1, b, 1 ], c ] );
        elif line[1] = "iv" and Length( line ) = 3 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          Add( lines, [ [ a, -1 ], b ] );
        elif line[1] = "pwr" and Length( line ) = 4 then
          a:= Int( line[2] );
          b:= Position( labels, line[3] );
          c:= Position( labels, line[4] );
          Add( lines, [ [ b, a ], c ] );
        elif line[1] = "cjr" and Length( line ) = 3 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          Add( lines, [ [ b, -1, a, 1, b, 1 ], a ] );
        elif line[1] = "cp" and Length( line ) = 3 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          Add( lines, [ [ a, 1 ], b ] );
        elif line[1] = "cj" and Length( line ) = 4 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          c:= Position( labels, line[4] );
          Add( lines, [ [ b, -1, a, 1, b, 1 ], c ] );
        elif line[1] = "com" and Length( line ) = 4 then
          a:= Position( labels, line[2] );
          b:= Position( labels, line[3] );
          c:= Position( labels, line[4] );
          Add( lines, [ [ a, -1, b, -1, a, 1, b, 1 ], c ] );
# improve: three multiplications and one inversion suffice!
        elif line[1] = "chor" and Length( line ) = 3 then
          if mode = "program" then
            Info( InfoCMeatAxe, 1,
                  "no \"chor\" lines allowed in straight line programs" );
            return fail;
          fi;
          a:= Position( labels, line[2] );
          b:= Int( line[3] );
          Add( lines, [ "Order", a, b ] );
        else
          Info( InfoCMeatAxe, 1, "strange line `", line, "'" );
          return fail;
        fi;
        if a = fail or b = fail or c = fail then
          Info( InfoCMeatAxe, 1, "line `", line, "' uses undefined label" );
          return fail;
        fi;

      fi;
    od;

    # Specify the output.
    result:= rec();
    if IsEmpty( output ) and mode = "program" then

      # The default output is given by the labels `1' and `2'.
      # Note that this is allowed only if these labels really occur.
      if IsSubset( labels, [ "1", "2" ] ) then
        Add( lines, [ [ Position( labels, "1" ), 1 ],
                      [ Position( labels, "2" ), 1 ] ] );
      else
        Info( InfoCMeatAxe, 1, "missing `oup' statement" );
        return fail;
      fi;

    elif mode = "program" then

      # The `oup' lines list the output labels.
      outputs:= [];
      for line in output do
        if Length( line ) = 2 and Int( line[2] ) <> fail then
          Append( outputs, List( [ 1 .. Int( line[2] ) ],
                          x -> [ Position( labels, String( x ) ), 1 ] ) );
        elif Length( line ) = Int( line[2] ) + 2 then
          Append( outputs, List( line{ [ 3 .. Length( line ) ] },
                          x -> [ Position( labels, x ), 1 ] ) );
        else
          Info( InfoCMeatAxe, 1, "corrupted line `", line, "'" );
          return fail;
        fi;
      od;
      if ForAny( outputs, pair -> pair[1] = fail ) then
        Info( InfoCMeatAxe, 1, "undefined label used in output line(s)" );
        return fail;
      fi;
      Add( lines, outputs );

      # The straight line program is thought for computing
      # class representatives,
      # and the bijection between the output labels and the class names
      # is given by the `echo' lines.
      # For the line `oup <l> <b1> <b2> ... <bl>',
      # there must be the `echo' line `Classes <n1> <n2> ... <nl>'.
      echo:= List( echo, line -> SplitString( line, "", "\" \n" ) );
      while     not IsEmpty( echo )
            and LowercaseString( echo[1][2] ) <> "classes" do
        echo:= echo{ [ 2 .. Length( echo ) ] };
      od;

      if not IsEmpty( echo ) then

        # Check that the `echo' lines fit to the `oup' lines.
        echo:= List( echo, x -> Filtered( x,
                 y -> y <> "echo" and LowercaseString( y ) <> "classes" ) );
        outputs:= Concatenation( echo );
        output:= Sum( List( output, x -> Int( x[2] ) ), 0 );
        if Length( outputs ) < output then
          Info( InfoCMeatAxe, 1,
                "`oup' and `echo' lines not compatible" );
          return fail;
        fi;
        outputs:= outputs{ [ 1 .. output ] };
        result.outputs:= outputs;

      fi;

    fi;

    # Construct and return the result.
    if mode = "program" then
      result.program:= StraightLineProgramNC( lines, nrinputs );
    else
      result.program:= StraightLineDecisionNC( lines, nrinputs );
    fi;
    return result;
end );


#############################################################################
##
#F  ScanStraightLineDecision( <string> )
##
InstallGlobalFunction( ScanStraightLineDecision,
    string -> ScanStraightLineProgramOrDecision( string, "decision" ) );


#############################################################################
##
#F  ScanStraightLineProgram( <filename> )
#F  ScanStraightLineProgram( <string>, "string" )
##
InstallGlobalFunction( ScanStraightLineProgram, function( arg )
    local filename, strdata;

    if   Length( arg ) = 1 and arg[1] = fail then
      # This is used to simplify other programs.
      return fail;
    elif Length( arg ) = 1 and IsString( arg[1] ) then
      # Read the data.
      filename:= arg[1];
      strdata:= AGR.StringFile( filename );
      if strdata = fail then
        Error( "cannot read file <filename>" );
      fi;
    elif  Length( arg ) = 2 and IsString( arg[1] ) and arg[2] = "string" then
      strdata:= arg[1];
    else
      Error( "usage: ScanStraightLineProgram( <filename>[, \"string\"] )" );
    fi;

    return ScanStraightLineProgramOrDecision( strdata, "program" );
end );


#############################################################################
##
#F  AtlasStringOfProgram( <prog>[, <outputnames>[, <avoidslots>]] )
#F  AtlasStringOfProgram( <prog>[, <format>[, <avoidslots>]] )
##
##  <avoidslots> refers only to the result list.
##
InstallGlobalFunction( AtlasStringOfProgram, function( arg )
    local format,         # "ATLAS" or "mtx"
          avoidslots,     # optional third argument
          prog,           # straight line program, first argument
          outputnames,    # list of strings, optional second argument
          resused,        # maximal label currently used in the program
          lines,
          str,            # string, result
          formats,        # record
          i,
          translateword,  # local function
          line,
          lastresult,
          namline,
          resline,
          inline;

    # Get and check the arguments.
    format:= "ATLAS";
    avoidslots:= [];
    if   Length( arg ) = 1 then
      prog:= arg[1];
    elif 2 <= Length( arg ) and IsString( arg[2] ) then
      prog:= arg[1];
      if LowercaseString( arg[2] ) = "mtx" then
        format:= "mtx";
      fi;
    elif 2 <= Length( arg ) and IsList( arg[2] ) then
      prog:= arg[1];
      outputnames:= arg[2];
    fi;
    if Length( arg ) = 3 and IsList( arg[3] ) then
      avoidslots:= arg[3];
    fi;
    if   IsBound( prog ) and IsStraightLineProgram( prog ) then
      resused:= NrInputsOfStraightLineProgram( prog );
      lines:= LinesOfStraightLineProgram( prog );
    elif IsBound( prog ) and IsStraightLineDecision( prog ) then
      resused:= NrInputsOfStraightLineDecision( prog );
      lines:= LinesOfStraightLineDecision( prog );
    else
      Error( "usage: ",
             "AtlasStringOfProgram( <prog>[, <outputnames>] )",
             "or AtlasStringOfProgram( <prog>[, \"mtx\"] )" );
    fi;

    str:= "";
    if format = "ATLAS" then
      # Write the line of inputs.
      Append( str, "inp " );
      Append( str, String( resused ) );
      Add( str, '\n' );

      # Define the line formats.
      formats:= rec( iv:= l -> Concatenation( "iv ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                     cp:= l -> Concatenation( "cp ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                     pw:= l -> Concatenation( "pwr ", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     mu:= l -> Concatenation( "mu ", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     cj:= l -> Concatenation( "cj ", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     ch:= l -> Concatenation( "chor ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                   );
    else
      # Write the line that describes the inputs.
      Append( str, "# inputs are expected in " );
      Append( str, JoinStringsWithSeparator( List( [ 1 .. resused ],
                                                   String ), " " ) );
      Add( str, '\n' );

      # Define the line formats.
      formats:= rec( iv:= l -> Concatenation( "ziv ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                     cp:= l -> Concatenation( "cp ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                     pw:= l -> Concatenation( "zsm pwr", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     mu:= l -> Concatenation( "zmu ", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     cj:= l -> Concatenation( "cj ", String( l[1] ),
                                 " ", String( l[2] ),
                                 " ", String( l[3] ), "\n" ),
                     ch:= l -> Concatenation( "chor ", String( l[1] ),
                                 " ", String( l[2] ), "\n" ),
                   );
    fi;

    # function to translate a word into a series of simple operations
    translateword:= function( word, respos )
      local used,  # maximal label, including intermediate results
            new,
            i;

      if resused < respos then
        resused:= respos;
      fi;
      used:= resused;

      if Length( word ) = 2 then

        # The word describes a simple powering.
        if word[2] = -1 then
          Append( str, formats.iv( [ word[1], respos ] ) );
        elif word[2] = 1 then
          Append( str, formats.cp( [ word[1], respos ] ) );
        elif 0 <= word[2] then
          Append( str, formats.pw( [ word[2], word[1], respos ] ) );
        else
          used:= used + 1;
          Append( str, formats.iv( [ word[1], used ] ) );
          Append( str, formats.pw( [ -word[2], used, respos ] ) );
        fi;

      elif Length( word ) = 3 and word[1] = "Order" then

        Append( str, formats.ch( [ word[2], word[3] ] ) );

      elif Length( word ) = 6 and word[2] = -1 and word[4] = 1
                              and word[6] =  1 and word[1] = word[5] then

        # The word describes a conjugation.
        Append( str, formats.cj( [ word[3], word[1], respos ] ) );

      else

        # Get rid of the powerings.
        new:= [];
        for i in [ 2, 4 .. Length( word ) ] do
          if word[i] = 1 then
            Add( new, word[ i-1 ] );
          elif 0 < word[i] then
            used:= used + 1;
            Append( str, formats.pw( [ word[i], word[ i-1 ], used ] ) );
            Add( new, used );
          else
            used:= used + 1;
            Append( str, formats.iv( [ word[ i-1 ], used ] ) );
            if word[i] < -1 then
              used:= used + 1;
              Append( str, formats.pw( [ -word[i], used-1, used ] ) );
            fi;
            Add( new, used );
          fi;
        od;

        # Now form the product of the elements in `new'.
        if Length( new ) = 1 then
          if new[1] <> respos then
            Append( str, formats.cp( [ new[1], respos ] ) );
          fi;
        elif Length( new ) = 2 then
          Append( str, formats.mu( [ new[1], new[2], respos ] ) );
        else
          used:= used + 1;
          Append( str, formats.mu( [ new[1], new[2], used ] ) );
          for i in [ 3 .. Length( new )-1 ] do
            used:= used + 1;
            Append( str, formats.mu( [ used-1, new[i], used ] ) );
          od;
          used:= used + 1;
          Append( str, formats.mu( [ used-1, new[ Length( new ) ],
                                     respos ] ) );
        fi;

      fi;
    end;

    # Loop over the lines.
    for line in lines do

      if ForAll( line, IsList ) then

        # The list describes the return values.
        lastresult:= [];
        for i in [ 1 .. Length( line ) ] do
          if Length( line[i] ) = 2 and line[i][2] = 1 then
            Add( lastresult, String( line[i][1] ) );
          else
            repeat
              resused:= resused + 1;
            until not resused in avoidslots;
            translateword( line[i], resused );
            Add( lastresult, String( resused ) );
          fi;
        od;

        if IsBound( outputnames ) then

          if Length( line ) <> Length( outputnames ) then
            Error( "<outputnames> has the wrong length" );
          fi;

          # Write the `echo' statements.
          # (Split the output specifications into lines if necessary.)
          i:= 1;
          namline:= "";
          resline:= "";
          inline:= 0;
          while i <= Length( outputnames ) do
            if    60 < Length( namline ) + Length( outputnames[i] )
               or 60 < Length( resline ) + Length( lastresult[i] ) then
              Append( str,
                  Concatenation( "echo \"Classes", namline, "\"\n" ) );
              Append( str,
                  Concatenation( "oup ", String( inline ), resline, "\n" ) );
              namline:= "";
              resline:= "";
              inline:= 0;
            fi;
            Add( namline, ' ' );
            Add( resline, ' ' );
            Append( namline, outputnames[i] );
            Append( resline, lastresult[i] );
            inline:= inline + 1;
            i:= i + 1;
          od;
          if inline <> 0 then
            Append( str,
                Concatenation( "echo \"Classes", namline, "\"\n" ) );
            Append( str,
                Concatenation( "oup ", String( inline ), resline, "\n" ) );
          fi;

        elif ForAll( [ 1 .. Length( line ) ], i -> line[i] = [ i, 1 ] ) then

          # Write a short output statement.
          if format = "ATLAS" then
            Append( str, "oup " );
            Append( str, String( Length( line ) ) );
            Add( str, '\n' );
          else
            Append( str, "echo \"outputs are in " );
            Append( str, JoinStringsWithSeparator(
                           List( [ 1 .. Length( line ) ], String ), " " ) );
            Append( str, "\"\n" );
          fi;

        elif format = "ATLAS" then

          # Write the full output statements.
          i:= 1;
          resline:= "";
          inline:= 0;
          while i <= Length( lastresult ) do
            if 60 < Length( resline ) + Length( lastresult[i] ) then
              Append( str,
                  Concatenation( "oup ", String( inline ), resline, "\n" ) );
              resline:= "";
              inline:= 0;
            fi;
            Add( resline, ' ' );
            Append( resline, lastresult[i] );
            inline:= inline + 1;
            i:= i + 1;
          od;
          if inline <> 0 then
            Append( str,
                Concatenation( "oup ", String( inline ), resline, "\n" ) );
          fi;

        else

          Append( str, "echo \"outputs are in " );
          Append( str, JoinStringsWithSeparator( lastresult, " " ) );
          Append( str, "\"\n" );

        fi;

        # Return the result.
        return str;

      else

        # Separate word and position where to put the result,
        # and translate the line into a sequence of simple steps.
        if ForAll( line, IsInt ) then
          resused:= resused + 1;
          lastresult:= resused;
          translateword( line, resused );
        elif line[1] = "Order" then
          translateword( line, "dummy" );
        else
          lastresult:= line[2];
          translateword( line[1], lastresult );
        fi;

      fi;
    od;

    # (If we arrive here then there is exactly one output value.)

    # Write the `echo' statements if applicable.
    # (This isn't really probable, is it?)
    if IsBound( outputnames ) then
      if Length( outputnames ) <> 1 then
        Error( "<outputnames> has the wrong length" );
      fi;
      Append( str,
          Concatenation( "echo \"Classes ", outputnames[1], "\"\n" ) );
    fi;

    # Write the output statement in the case of straight line programs.
    if IsStraightLineProgram( prog ) then
      if format = "ATLAS" then
        Append( str, "oup 1 " );
        Append( str, String( lastresult ) );
        Add( str, '\n' );
      else
        Append( str, "echo \"outputs are in " );
        Append( str, String( lastresult ) );
        Append( str, "\"\n" );
      fi;
    fi;

    # Return the result;
    return str;
end );


#############################################################################
##
#E

