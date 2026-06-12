#############################################################################
##
#W  interfac.gi          GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains the implementation part of the ''high level'' GAP
##  interface to the ATLAS of Group Representations.
##


#############################################################################
##
#F  AGR.Pager( <string> )
##
##  Simply calling 'Pager' is not good enough, because GAP introduces
##  line breaks in too long lines, and GAP does not compute the printable
##  length of the line but the length as a string.
##
##  If <string> is empty then the builtin pager runs into an error,
##  therefore we catch this case.
##
AGR.Pager:= function( string )
    if string <> "" then
      Pager( rec( lines:= string, formatted:= true ) );
    fi;
    end;


#############################################################################
##
#F  AGR.ShowOnlyASCII()
##
##  Show nicer grids and symbols such as ℤ if the terminal admits this.
##  Currently we do *not* do this if 'Print' is used to show the data,
##  because of the automatically inserted line breaks.
##
AGR.ShowOnlyASCII:= function()
    return UserPreference( "AtlasRep", "DisplayFunction" ) = "Print" or
           GAPInfo.TermEncoding <> "UTF-8";
    end;


#############################################################################
##
#F  AGR.StringAtlasInfoOverview( <gapnames>, <conditions> )
##
AGR.StringAtlasInfoOverview:= function( gapnames, conditions )
    local rep_rest_funs, only_if_rep, columns, len, type, widths, choice, i,
          j, fstring, result, mid;

    # Consider only those names for which actually information is available.
    # (The ordering shall be the same as in the input.)
    if gapnames = "all" then
      gapnames:= AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp;
    else
      gapnames:= Filtered( List( gapnames, AGR.InfoForName ),
                           x -> x <> fail );
    fi;
    if IsEmpty( gapnames ) then
      return [];
    fi;

    # If 'conditions' restricts the representations then omit rows
    # with empty representations part.
    rep_rest_funs:= [ Characteristic, Dimension, Identifier, IsMatrixGroup, 
                      IsPermGroup, IsPrimitive, IsTransitive, NrMovedPoints, 
                      RankAction, Ring, Transitivity ];
    only_if_rep:= ForAny( conditions, x -> x in rep_rest_funs );

    # Compute the data of the columns.
    columns:= [ [ "group", "l", List( gapnames, x -> [ x[1], false ] ) ] ];
    len:= 0;
    for type in AGR.DataTypes( "rep", "prg" ) do
      if type[2].DisplayOverviewInfo <> fail then
        Add( columns, [
             type[2].DisplayOverviewInfo[1],
             type[2].DisplayOverviewInfo[2],
             List( gapnames,
                   n -> type[2].DisplayOverviewInfo[3](
                            Concatenation( [ n ], conditions ) ) ) ] );
        if only_if_rep then
          if type[3] = "rep" then
            len:= Length( columns );
          fi;
        else
          len:= Length( columns );
        fi;
      fi;
    od;

    # Initialize the column widths; the header string shall fit.
    widths:= List( columns, c -> [ Length( c[1] ), c[2] ] );

    # Restrict the lists to the nonempty rows.
    choice:= [];
    for i in [ 1 .. Length( gapnames ) ] do
      if ForAny( [ 2 .. len ],
                 c -> columns[c][3][i][1] <> "" ) then
        Add( choice, i );

        # Evaluate the privacy flag.
        if ForAny( columns, x -> x[3][i][2] ) then
          columns[1][3][i][1]:= Concatenation( columns[1][3][i][1],
              UserPreference( "AtlasRep", "AtlasRepMarkNonCoreData" ) );
        fi;

        for j in [ 1 .. Length( columns ) ] do
          widths[j][1]:= Maximum( widths[j][1],
                                  Length( columns[j][3][i][1] ) );
        od;

      fi;
    od;

    if IsEmpty( choice ) then
      return [];
    fi;

    fstring:= function( string, width )
      local strwidth, n, n1, n2;

      strwidth:= WidthUTF8String( string );
      if width[1] <= strwidth then
        return string;
      elif width[2] = "l" then
        return Concatenation( string,
                              RepeatedString( ' ', width[1] - strwidth ) );
      elif width[2] = "r" then
        return Concatenation( RepeatedString( ' ', width[1] - strwidth ),
                              string );
      else
        n:= RepeatedString( ' ', width[1] - strwidth );
        n1:= n{ [ QuoInt( Length( n ), 2 ) + 1 .. Length( n ) ] };
        n2:= n{ [ 1 .. QuoInt( Length( n ), 2 ) ] };
        return Concatenation( n1, string, n2 );
      fi;
    end;

    result:= [];

    # Add the header line.
    if AGR.ShowOnlyASCII() then
      mid:= " | ";
    else
      mid:= " │ ";
    fi;
    Add( result, JoinStringsWithSeparator( List( [ 1 .. Length( columns ) ],
               j -> fstring( columns[j][1], widths[j] ) ), mid ) );
    if AGR.ShowOnlyASCII() then
      Add( result, JoinStringsWithSeparator( List( [ 1 .. Length( columns ) ],
                 j -> RepeatedString( "-", widths[j][1] ) ), "-+-" ) );
    else
      Add( result, JoinStringsWithSeparator( List( [ 1 .. Length( columns ) ],
                 j -> RepeatedUTF8String( "─", widths[j][1] ) ), "─┼─" ) );
    fi;

    # Add the information for each group.
    for i in choice do
      Add( result, JoinStringsWithSeparator( List( [ 1 .. Length( columns ) ],
               j -> fstring( columns[j][3][i][1], widths[j] ) ), mid ) );
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.StringAtlasInfoContents()
##
AGR.StringAtlasInfoContents:= function()
    local datadir, result, mid, dir, header, table, info, n, path, subdir,
          dstfile, prefix, ncols, widths, i, row, sep;

    # general information
    datadir:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
    if datadir = "" then
      datadir:= "(no local caches available)";
    fi;
    result:= [];
    Add( result, Concatenation( "- AtlasRepAccessRemoteFiles: ",
                     String( UserPreference( "AtlasRep",
                                 "AtlasRepAccessRemoteFiles" ) ), "\n" ) );
    Add( result, Concatenation( "- AtlasRepDataDirectory: ", datadir, "\n" ) );

    # information per part of the database
    if AGR.ShowOnlyASCII() then
      mid:= " | ";
    else
      mid:= " │ ";
    fi;

    dir:= Directory( datadir );
    header:= [ "ID", mid, "address, version, files" ];
    table:= [];
    for info in AtlasOfGroupRepresentationsInfo.notified do
      n:= 0;
      if info.ID = "core" then
        path:= Filename( dir, "datagens" );
        if IsDirectoryPath( path ) then
          n:= n + Length( Difference( DirectoryContents( path ),
                                      [ ".", "..", "dummy" ] ) );
        fi;
        path:= Filename( dir, "dataword" );
        if IsDirectoryPath( path ) then
          n:= n + Length( Difference( DirectoryContents( path ),
                                      [ ".", "..", "dummy" ] ) );
        fi;
      elif StartsWith( info.DataURL, "http" ) then
        # remote data extension
        path:= Filename( dir, Concatenation( "dataext/", info.ID ) );
        if IsDirectoryPath( path ) then
          n:= n + Length( Difference( DirectoryContents( path ),
                                      [ ".", "..", "toc.json" ] ) );
        fi;
      else
        # local data extension (perhaps with one intermediate directory level)
        path:= info.DataURL;
        if IsDirectoryPath( path ) then
          path:= Directory( path );
          for subdir in Difference( DirectoryContents( path ),
                                    [ ".", "..", "toc.json" ] ) do
            dstfile:= Filename( path, subdir );
            if IsDirectoryPath( dstfile ) then
              n:= n + Length( Difference( DirectoryContents( dstfile ),
                                          [ ".", ".." ] ) );
            else
              n:= n + 1;
            fi;
          od;
        fi;
      fi;
      path:= info.DataURL;
      if not StartsWith( path, "http" ) then
        prefix:= First( List( DirectoriesLibrary( "pkg" ),
                              d -> Filename( d, "" ) ),
                        str -> StartsWith( path, str ) );
        if prefix <> fail then
          path:= ReplacedString( path, prefix, "" );
        fi;
      fi;
      Add( table, [ info.ID, mid, Concatenation( path, "," ) ] );

      if IsBound( info.Version ) then
        Add( table, [ "", mid, Concatenation( "version ", info.Version,
                                   "," ) ] );
      fi;
      Add( table, [ "", mid, Concatenation( String( n ),
                                 " files locally available." ) ] );
    od;
    ncols:= Length( header );
    widths:= List( header, Length );
    for row in table do
      for i in [ 1 .. ncols ] do
        widths[i]:= Maximum( widths[i], WidthUTF8String( row[i] ) );
      od;
    od;
    for i in [ 1, 3 ] do
      widths[i]:= -widths[i];
    od;

    Add( result, Concatenation( List( [ 1 .. ncols ],
                                i -> String( header[i], widths[i] ) ) ) );
    if AGR.ShowOnlyASCII() then
      sep:= JoinStringsWithSeparator( List( [ 1, 3 .. ncols ],
              j -> RepeatedString( "-", AbsInt( widths[j] ) ) ), "-+-" );
    else
      sep:= JoinStringsWithSeparator( List( [ 1, 3 .. ncols ],
              j -> RepeatedUTF8String( "─", AbsInt( widths[j] ) ) ), "─┼─" );
    fi;
    for row in table do
      if row[1] <> "" then
        Add( result, sep );
      fi;
      Add( result,
           Concatenation( List( [ 1 .. ncols ],
                                i -> String( row[i], widths[i] ) ) ) );
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.InfoPrgs( <conditions> )
##
AGR.InfoPrgs:= function( conditions )
    local gapname, groupname, name, tocs, std, argpos, stdavail, toc, record,
          type, list, header, nams, sort, info, pi;

    gapname:= conditions[1];
    groupname:= AGR.InfoForName( gapname );
    if groupname = fail then
      return rec( list:= [] );
    fi;
    conditions:= conditions{ [ 2 .. Length( conditions ) ] };
    name:= groupname[2];
    tocs:= AGR.TablesOfContents( conditions );

    if Length( conditions ) = 0 or
       not ( IsInt( conditions[1] ) or IsList( conditions[1] ) ) then
      std:= true;
      argpos:= 1;
    else
      std:= conditions[1];
      if IsInt( std ) then
        std:= [ std ];
      fi;
      argpos:= 2;
    fi;

    # If the standardization is prescribed then do not mention it.
    # Otherwise if all information refers to the same standardization then
    # print just one line.
    # Otherwise print the standardization for each entry.
    stdavail:= [];
    if std = true or 1 < Length( std ) then
      for toc in tocs do
        if IsBound( toc.( name ) ) then
          record:= toc.( name );
          for type in AGR.DataTypes( "prg" ) do
            if IsBound( record.( type[1] ) ) then
              for list in record.( type[1] ) do
                if std = true or list[1] in std then
                  AddSet( stdavail, list[1] );
                fi;
              od;
            fi;
          od;
        fi;
      od;
    fi;

    # Create the header line.
    # (Because of 'AGR.CreateHTMLInfoForGroup',
    # the group name must occur as an entry of its own .)
    header:= [ "Programs for G = ", groupname[1], ":" ];
    if Length( stdavail ) = 1 then
      Append( header, [ "    (all refer to std. generators ",
                        String( stdavail[1] ), ")" ] );
    fi;

    # Collect the info lines for the scripts.
    list:= [];
    nams:= [];
    sort:= [];
    if ( Length( conditions ) = argpos and
         conditions[ argpos ] = IsStraightLineProgram )
       or ( Length( conditions ) = argpos + 1
            and conditions[ argpos ] = IsStraightLineProgram
            and conditions[ argpos + 1 ] = true )
       or Length( conditions ) < argpos then
      for type in AGR.DataTypes( "prg" ) do
        info:= type[2].DisplayPRG( tocs, [ gapname, groupname[2] ], std,
                                   stdavail );
        Add( list, info );
        if IsEmpty( info ) then
          Add( sort, [ 0 ] );
        elif IsString( info[2] ) then
          Add( sort, [ 0, info[1] ] );
        else
          Add( sort, [ 1, info[1] ] );
        fi;
        Add( nams, type[1] );
      od;
    fi;

    # Sort the information such that those come first for which a single
    # line is given.
    # (This is because 'BrowseAtlasInfo' turns the parts with more than
    # one line into a subcategory which is created from the first line.)
    # Inside this ordering of entries, sort the information alphabetically.
    pi:= Sortex( sort );

    return rec( header := header,
                list   := Permuted( list, pi ),
                nams   := Permuted( nams, pi ) );
    end;


#############################################################################
##
#F  AGR.EvaluateMinimalityCondition( <gapname>, <conditions> )
##
##  Evaluate conditions involving '"minimal"':
##  Replace the string '"minimal"' by the number in question if known,
##  return 'true' in this case and 'false' otherwise.
##  (In the 'false' case, an info message is printed.)
##
AGR.EvaluateMinimalityCondition:= function( gapname, conditions )
    local pos, info, pos2;

    pos:= Position( conditions, "minimal" );
    if pos <> fail and pos <> 1 then
      if   IsIdenticalObj( conditions[ pos-1 ], NrMovedPoints ) then
        # ..., NrMovedPoints, "minimal", ...
        info:= MinimalRepresentationInfo( gapname, NrMovedPoints );
        if info = fail then
          Info( InfoAtlasRep, 1,
                "minimal perm. repr. of '", gapname, "' not known" );
          return false;
        fi;
        conditions[ pos ]:= info.value;
      elif IsIdenticalObj( conditions[ pos-1 ], Dimension ) then
        pos2:= Position( conditions, Characteristic );
        if pos2 <> fail and pos2 < Length( conditions ) then
          # ..., Characteristic, <p>, ..., Dimension, "minimal", ...
          info:= MinimalRepresentationInfo( gapname,
                     Characteristic, conditions[ pos2+1 ] );
          if info = fail then
            Info( InfoAtlasRep, 1,
                  "minimal matrix repr. of '", gapname,
                  "' in characteristic ", conditions[ pos2+1 ],
                  " not known" );
            return false;
          fi;
          conditions[ pos ]:= info.value;
        else
          pos2:= Position( conditions, Ring );
          if pos2 <> fail and pos2 < Length( conditions )
                         and IsField( conditions[ pos2+1 ] )
                         and IsFinite( conditions[ pos2+1 ] ) then
            # ..., Ring, <R>, ..., Dimension, "minimal", ...
            info:= MinimalRepresentationInfo( gapname,
                       Size, Size( conditions[ pos2+1 ] ) );
            if info = fail then
              Info( InfoAtlasRep, 1,
                    "minimal matrix repr. of '", gapname,
                    "' over '", conditions[ pos2+1 ], "' not known" );
              return false;
            fi;
            conditions[ pos ]:= info.value;
          fi;
        fi;
      fi;
    fi;

    return true;
    end;


#############################################################################
##
#F  AGR.InfoReps( <conditions> )
##
##  This function is used by 'AGR.StringAtlasInfoGroup' and
##  'BrowseData.AtlasRepGroupInfoTable'.
##
AGR.InfoReps:= function( conditions )
    local info, stdavail, header, list, types, r, type, entry;

    info:= CallFuncList( AllAtlasGeneratingSetInfos, conditions );

    # If all information refers to the same standardization then
    # print just one line.
    # Otherwise print the standardization for each entry.
    stdavail:= Set( List( info, x -> x.standardization ) );

    # Construct the header line.
    # (Because of 'AGR.CreateHTMLInfoForGroup',
    # 'gapname' must occur as an entry of its own .)
    header:= [ "Representations for G = ", AGR.GAPName( conditions[1] ),
               ":" ];
    if Length( stdavail ) = 1 then
      Add( header, Concatenation(
           "    (all refer to std. generators ", String( stdavail[1] ),
           ")" ) );
    fi;

    list:= [];
    types:= AGR.DataTypes( "rep" );
    for r in info do
      type:= First( types, t -> t[1] = r.type );
      entry:= type[2].DisplayGroup( r );
      if IsString( entry ) then
        entry:= [ entry ];
      fi;
      entry:= [ [ String( r.repnr ), ":" ], [ entry[1], "" ],
                entry{ [ 2 .. Length( entry ) ] } ];
      if not ( IsString( r.identifier[2] ) or
               ForAll( r.identifier[2], IsString ) ) then
        entry[2][2]:= UserPreference( "AtlasRep", "AtlasRepMarkNonCoreData" );
      fi;
      if 1 < Length( stdavail ) then
        Add( entry, [ ", w.r.t. std. gen. ", String( r.standardization ) ] );
      fi;
      Add( list, entry );
    od;

    return rec( header := header,
                list   := list );
    end;


#############################################################################
##
#F  AGR.StringAtlasInfoGroup( <conditions> )
##
##  Deal with the detailed overview for one group.
##
AGR.StringAtlasInfoGroup:= function( conditions )
    local result, screenwidth, inforeps, list, line, len1, len2, indent,
          underline, bullet, bulletlength, i, prefix, entry, infoprgs, j,
          colsep;

    result:= [];
    screenwidth:= SizeScreen()[1] - 1;

    # 'DisplayAtlasInfo( <gapname>[, <std>][, <conditions>] )'
    inforeps:= AGR.InfoReps( conditions );
    if not IsEmpty( inforeps.list ) then

      list:= List( inforeps.list, line -> Concatenation(
               [ Concatenation( line[1] ), Concatenation( line[2] ) ],
               Concatenation( line{ [ 3 .. Length( line ) ] } ) ) );
      len1:= Maximum( List( list, x -> WidthUTF8String( x[1] ) ) );
      len2:= Maximum( List( list, x -> WidthUTF8String( x[2] ) ) );
      indent:= 0;
      line:= Concatenation( inforeps.header{ [ 1 .. 3 ] } );
      if AGR.ShowOnlyASCII() then
        underline:= RepeatedString( "-", Sum( List(
                        inforeps.header{ [ 1 .. 3 ] }, Length ) ) );
      else
        underline:= RepeatedUTF8String( "─", Sum( List(
                        inforeps.header{ [ 1 .. 3 ] }, Length ) ) );
      fi;
      for i in [ 4 .. Length( inforeps.header ) ] do
        if WidthUTF8String( line ) + WidthUTF8String( inforeps.header[i] )
           >= screenwidth
           and WidthUTF8String( line ) <> indent then
          Add( result, line );
          Add( result, underline );
          underline:= "";
          line:= "";
        fi;
        Append( line, inforeps.header[i] );
      od;
      if line <> "" then
        Add( result, line );
      fi;
      if underline <> "" then
        Add( result, underline );
      fi;

      indent:= len1 + len2 + 2;
      if indent >= screenwidth then
        indent:= 1;
      fi;
      prefix:= RepeatedString( " ", indent );
      for entry in list do
        # right-aligned number, left-aligned description
        line:= Concatenation( String( entry[1], len1 ), " ",
                              entry[2],
                              RepeatedString( " ", len2
                                  - WidthUTF8String( entry[2] ) ),
                              " " );
        for i in [ 3 .. Length( entry ) ] do
          if WidthUTF8String( line ) + WidthUTF8String( entry[i] )
             >= screenwidth
             and Length( line ) <> indent then
            Add( result, line );
            line:= ShallowCopy( prefix );
          fi;
          Append( line, entry[i] );
        od;
        Add( result, line );
      od;
    fi;

    # 'DisplayAtlasInfo( <gapname>[, <std>][, IsStraightLineProgram] )'
    infoprgs:= AGR.InfoPrgs( conditions );
    if ForAny( infoprgs.list, x -> not IsEmpty( x ) ) then
      if IsBound( inforeps ) and not IsEmpty( inforeps.list ) then
        Add( result, "" );
      fi;
      indent:= 0;

      # Format the header.
      line:= Concatenation( infoprgs.header{ [ 1 .. 3 ] } );
      if AGR.ShowOnlyASCII() then
        underline:= RepeatedString( "-", Sum( List(
                        infoprgs.header{ [ 1 .. 3 ] }, Length ) ) );
        bullet:= "- ";
      else
        underline:= RepeatedUTF8String( "─", Sum( List(
                        infoprgs.header{ [ 1 .. 3 ] }, Length ) ) );
        bullet:= "• ";
      fi;
      bulletlength:= 2;
      for i in [ 4 .. Length( infoprgs.header ) ] do
        if WidthUTF8String( line ) + WidthUTF8String( infoprgs.header[i] )
           >= screenwidth
           and WidthUTF8String( line ) <> indent then
          Add( result, line );
          Add( result, underline );
          underline:= "";
          line:= "";
        fi;
        Append( line, infoprgs.header[i] );
      od;
      if line <> "" then
        Add( result, line );
      fi;
      if underline <> "" then
        Add( result, underline );
      fi;

      # Format the info list.  Each entry is a list of the following type:
      # - empty or
      # - consists of two strings (corresponding to table columns),
      #   plus a program identifier, or
      # - has a string at position 1
      #   and non-string lists of length 3 at the other positions,
      #   each representing the columns of a table row,
      #   plus a program identifier.
      len1:= 0;
      len2:= 0;
      for i in infoprgs.list do
        if not IsEmpty( i ) then
          if IsString( i[2] ) then
            # This happens if only one program is available,
            # and if the type is not "automorphisms", "kernels", or "maxes".
            len1:= Maximum( len1, WidthUTF8String( i[1] ) );
            if Length( i ) = 2 then
              len2:= Maximum( len2, WidthUTF8String( i[2] ) );
            fi;
          else
            # This happens for "automorphisms", "kernels", and "maxes",
            # and whenever more than one program is available for a type.
            len1:= Maximum( len1, WidthUTF8String( i[1] ) + 1 );
            for j in [ 2 .. Length( i ) ] do
              len1:= Maximum( len1, WidthUTF8String( i[j][1] ) );
              len2:= Maximum( len2, WidthUTF8String( i[j][2] ) );
            od;
          fi;
        fi;
      od;

      # The two columns shall be left aligned.
      len1:= -len1;
      len2:= -len2;
      colsep:= "  ";
      indent:= RepeatedString( " ", bulletlength );

      for i in infoprgs.list do
        if not IsEmpty( i ) then
          if IsString( i[2] ) then
            Add( result, Concatenation( bullet,
                                        String( i[1], len1 ),
                                        colsep,
                                        String( i[2], len2 ) ) );
          else
            Add( result, Concatenation( bullet, i[1], ":" ) );
            for j in [ 2 .. Length( i ) ] do
              Add( result, Concatenation( indent,
                  String( i[j][1], len1 ),
                  colsep,
                  String( i[j][2], len2 ) ) );
            od;
          fi;
        fi;
      od;
    fi;

    return result;
    end;


#############################################################################
##
#F  DisplayAtlasInfo( [<listofnames>][,][<std>][,]["contents", <sources>]
#F                    [, IsPermGroup[, true]]
#F                    [, NrMovedPoints, <n>]
#F                    [, IsTransitive[, <bool>]]
#F                    [, Transitivty[, <n>]]
#F                    [, IsPrimitive[, <bool>]]
#F                    [, RankAction[, <n>]]
#F                    [, IsMatrixGroup[, true]]
#F                    [, Characteristic, <p>][, Dimension, <n>]
#F                    [, Ring, <R>]
#F                    [, Position, <n>]
#F                    [, Character, <chi>]
#F                    [, Identifier, <id>] )
#F  DisplayAtlasInfo( <gapname>[, <std>][, "contents", <sources>]
#F                    [, IsPermGroup[, true]]
#F                    [, NrMovedPoints, <n>]
#F                    [, IsTransitive[, <bool>]]
#F                    [, Transitivty[, <n>]]
#F                    [, IsPrimitive[, <bool>]] 
#F                    [, RankAction[, <n>]]
#F                    [, IsMatrixGroup[, true]]
#F                    [, Characteristic, <p>][, Dimension, <n>]
#F                    [, Ring, <R>]
#F                    [, Position, <n>]
#F                    [, Character, <chi>]
#F                    [, Identifier, <id>]
#F                    [, IsStraightLineProgram[, true]] )
#F  DisplayAtlasInfo( "contents" )
##
#T support DisplayAtlasInfo( <tbl> ) for a character table <tbl>
#T with admissible Identifier value
##
InstallGlobalFunction( DisplayAtlasInfo, function( arg )
    local result, width, fun;

    # Distinguish the summary overview for at least one group
    # from the detailed overview for exactly one group.
    if   Length( arg ) = 0 then
      result:= AGR.StringAtlasInfoOverview( "all", arg );
    elif Length( arg ) = 1 and arg[1] = "contents" then
      result:= AGR.StringAtlasInfoContents();
    elif IsList( arg[1] ) and ForAll( arg[1], IsString ) then
      result:= AGR.StringAtlasInfoOverview( arg[1],
                    arg{ [ 2 .. Length( arg ) ] } );
    elif not IsString( arg[1] ) or arg[1] = "contents" then
      result:= AGR.StringAtlasInfoOverview( "all", arg );
    else
      result:= AGR.StringAtlasInfoGroup( arg );
    fi;

    width:= SizeScreen()[1] - 2;
    if AGR.ShowOnlyASCII() then
      result:= List( result,
               l -> InitialSubstringUTF8String( l, width, "*" ) );
    else
      result:= List( result,
               l -> InitialSubstringUTF8String( l, width, "⋯" ) );
    fi;
    Add( result, "" );

    fun:= EvalString( UserPreference( "AtlasRep", "DisplayFunction" ) );
    fun( JoinStringsWithSeparator( result, "\n" ) );
    end );


#############################################################################
##
#F  AtlasGenerators( <gapname>, <repnr>[, <maxnr>] )
#F  AtlasGenerators( <identifier> )
#F  AtlasGenerators( <inforecord> )
##
##  <identifier> is a list containing at the first position the string
##  <gapname>,
##  at the second position a string or a list of strings
##  (describing filenames),
##  at the third position a positive integer denoting the standardization of
##  the representation,
##  at the fourth position a positive integer describing the common ring of
##  the generators,
##  and at the fifth position, if bound, a positive integer denoting the
##  number of the maximal subgroup to which the representation is restricted.
##
InstallGlobalFunction( AtlasGenerators, function( arg )
    local identifier, gapname, id, maxnr, rep, repnr, reps, prog, filenames,
          i, groupname, type, gens, result;

    if Length( arg ) = 1 then

      # 'AtlasGenerators( <identifier> )'
      identifier:= arg[1];
      if IsRecord( identifier ) and IsBound( identifier.identifier ) then
        identifier:= identifier.identifier;
      fi;
      gapname:= identifier[1];
      id:= identifier;
      if IsBound( identifier[5] ) then
        maxnr:= identifier[5];
        id:= identifier{ [ 1 .. 4 ] };
      fi;
      rep:= First( AGR.MergedTableOfContents( "all", gapname ),
                   r -> r.identifier = id );

    elif  ( Length( arg ) = 2 and IsString( arg[1] ) and IsPosInt( arg[2] ) )
       or ( Length( arg ) = 3 and IsString( arg[1] ) and IsPosInt( arg[2] )
                              and IsPosInt( arg[3] ) ) then

      # 'AtlasGenerators( <gapname>, <repnr>[, <maxnr>] )'
      gapname:= arg[1];
      repnr:= arg[2];
      reps:= AGR.MergedTableOfContents( "all", gapname );
      rep:= First( reps, r -> r.repnr = repnr );
      if rep = fail then
        return fail;
      fi;
      identifier:= ShallowCopy( rep.identifier );
      if IsBound( arg[3] ) then
        maxnr:= arg[3];
        identifier[5]:= maxnr;
      fi;
    else
      Error( "usage: AtlasGenerators( <gapname>,<repnr>[,<maxnr>] ) or\n",
             "       AtlasGenerators( <identifier> )" );
    fi;

    # If the restriction to a subgroup is required then
    # try to fetch the program (w.r.t. the correct standardization)
    # *before* reading the generators;
    # if we do not get the program then the generators are not needed.
    if IsBound( maxnr ) then
      prog:= AtlasProgram( gapname, identifier[3], maxnr );
      if prog = fail then
        return fail;
      fi;
    fi;

    filenames:= identifier[2];
    if IsString( filenames ) then
      filenames:= [ [ "datagens", filenames ] ];
    else
      filenames:= ShallowCopy( filenames );
      for i in [ 1 .. Length( filenames ) ] do
        if IsString( filenames[i] ) then
          filenames[i]:= [ "datagens", filenames[i] ];
        fi;
      od;
    fi;

    # Access the data file(s).
    groupname:= AGR.InfoForName( gapname );
    if groupname = fail then
      Info( InfoAtlasRep, 1,
            "AtlasGenerators: no group with GAP name '", gapname, "'" );
      return fail;
    fi;
    type:= First( AGR.DataTypes( "rep" ), l -> l[1] = rep.type );
    if IsRecord( arg[1] ) then
      PushOptions( rec( inforecord:= arg[1] ) );
    fi;
    gens:= AGR.FileContents( filenames, type );
    if IsRecord( arg[1] ) then
      PopOptions();
    fi;
    if gens = fail then
      return fail;
    fi;
    result:= ShallowCopy( rep );
    if IsRecord( arg[1] ) then
      if IsBound( arg[1].givenRing ) then
        result.givenRing:= arg[1].givenRing;
      fi;
      if IsBound( arg[1].constructingFilter ) then
        result.constructingFilter:= arg[1].constructingFilter;
      fi;
    fi;

    if IsBound( maxnr ) then

      result.identifier:= identifier;

      # Evaluate the straight line program.
      result.generators:= ResultOfStraightLineProgram( prog.program, gens );

      # Add/adjust info.
      if IsBound( groupname[3].sizesMaxes )
         and IsBound( groupname[3].sizesMaxes[ maxnr ] ) then
        result.size:= groupname[3].sizesMaxes[ maxnr ];
      fi;
      if IsBound( groupname[3].structureMaxes )
         and IsBound( groupname[3].structureMaxes[ maxnr ] ) then
        result.groupname:= groupname[3].structureMaxes[ maxnr ];
      fi;

    else
      result.generators:= gens;
    fi;

    # Return the result.
    return Immutable( result );
    end );


#############################################################################
##
#F  AGR.MergedTableOfContents( <tocid>, <gapname> )
##
##  'AGR.MergedTableOfContents' returns a list of the known representations
##  for the group with name <gapname>.
##  This list is sorted by types and for each type by its 'SortTOCEntries'
##  function.
##  The list is cached in the component <gapname> of the global record
##  'AtlasOfGroupRepresentationsInfo.TableOfContents.merged'.
##  When a new table of contents is notified with
##  'AtlasOfGroupRepresentationsNotifyPrivateDirectory' then the cache is
##  cleared.
##
AGR.MergedTableOfContents:= function( tocid, gapname )
    local merged, label, groupname, result, tocs, type, typeresult, sortkeys,
          toc, record, id, i, repname, oneresult, types, r, loc;

    merged:= AtlasOfGroupRepresentationsInfo.TableOfContents.merged;
    if IsString( tocid ) then
      tocid:= [ tocid ];
    fi;
    label:= Concatenation( JoinStringsWithSeparator( tocid, "|" ),
                           "|", gapname );
    if IsBound( merged.( label ) ) then
      return merged.( label );
    fi;

    groupname:= AGR.InfoForName( gapname );
    if groupname = fail then
      return [];
    elif tocid = [ "all" ] then
      result:= [];

      # collect all representations, sort them for each type.
      tocs:= AGR.TablesOfContents( [ "contents", "all" ] );
      for type in AGR.DataTypes( "rep" ) do
        typeresult:= [];
        sortkeys:= [];
        for toc in tocs do
          if IsBound( toc.( groupname[2] ) ) then
            record:= toc.( groupname[2] );
            if IsBound( record.( type[1] ) ) then
              for i in record.( type[1] ) do
                repname:= i[ Length(i) ];
                if not IsString( repname ) then
                  repname:= repname[1];
                fi;
                repname:= repname{ [ 1 .. Position( repname, '.' )-1 ] };
                id:= i[ Length(i) ];

                if toc.TocID <> "core" then
                  if IsString( id ) then
                    id:= [ [ toc.TocID, id ] ];
                  else
                    id:= List( id, x -> [ toc.TocID, x ] );
                  fi;
                fi;

                oneresult:= rec( groupname       := gapname,
                                 identifier      := [ gapname, id,
                                                      i[1], i[2] ],
                                 repname         := repname,
                                 standardization := i[1],
                                 type            := type[1],
                                 contents        := toc.TocID );

                type[2].AddDescribingComponents( oneresult, type );
                Add( typeresult, oneresult );
                Add( sortkeys, type[2].SortTOCEntries( i ) );
              od;
            fi;
          fi;
        od;
        SortParallel( sortkeys, typeresult );
        Append( result, typeresult );
      od;

      if IsBound( groupname[3].size ) then
        for i in result do
          i.size:= groupname[3].size;
        od;
      fi;
      for i in [ 1 .. Length( result ) ] do
        result[i].repnr:= i;
      od;
    elif tocid = [ "local" ] then
      types:= AGR.DataTypes( "rep" );
      result:= [];
      for r in AGR.MergedTableOfContents( "all", gapname ) do
        type:= First( types, x -> x[1] = r.type );
        if r.contents <> "core" then
          loc:= AtlasOfGroupRepresentationsLocalFilename(
                    r.identifier[2], type );
        elif IsString( r.identifier[2] ) then
          loc:= AtlasOfGroupRepresentationsLocalFilename(
                    [ [ "datagens", r.identifier[2] ] ], type );
        else
          loc:= AtlasOfGroupRepresentationsLocalFilename(
                    List( r.identifier[2], x -> [ "datagens", x ] ), type );
        fi;
        if not IsEmpty( loc ) and ForAll( loc[1][2], x -> x[2] ) then
          Add( result, r );
        fi;
      od;
    else
      # Now we know that we have to filter a list which we can compute.
      if "local" in tocid then
        result:= AGR.MergedTableOfContents( "local", gapname );
      else
        result:= AGR.MergedTableOfContents( "all", gapname );
      fi;
      tocid:= Difference( tocid, [ "all", "local" ] );
      result:= Filtered( result, r -> r.contents in tocid );
    fi;

    merged.( label ):= result;
    return result;
end;


#############################################################################
##
#F  AGR.EvaluateCharacterCondition( <gapname>, <conditions>, <reps> )
##
##  Evaluate conditions involving 'Character'.
##  The list <conditions> is changed in place such that the first occurrence
##  of 'Character' and the subsequent entry (the condition on the character)
##  are removed.
##  The return value is the sublist of those entries in <reps> that satisfy
##  the condition.
##
AGR.EvaluateCharacterCondition:= function( gapname, conditions, reps )
    local pos, map, pos2, p, chars, primes, consts, i, chi, tbl, ordtbl, dec,
          const, j, repnames, mapi, len;

    # If 'Character' does not occur then we need not work.
    pos:= Position( conditions, Character );
    if pos = fail then
      return reps;
    elif pos = Length( conditions ) then
      return [];
    fi;

    map:= AtlasOfGroupRepresentationsInfo.characterinfo;
    if not IsBound( map.( gapname ) ) then
      Info( InfoAtlasRep, 1,
            "no character information for ", gapname, " known" );
      return [];
    fi;
    map:= map.( gapname );

    # Check whether also 'Characteristic' is specified.
    pos2:= Position( conditions, Characteristic );
    if pos2 = fail then
      p:= "?";
    elif pos2 = Length( conditions ) then
      return [];
    else
      p:= conditions[ pos2+1 ];
      if IsInt( p ) then
        p:= [ p ];
      fi;
    fi;

    # Interpret the character(s).
    chars:= conditions[ pos+1 ];
    if IsClassFunction( chars ) then
      chars:= [ chars ];
    fi;
    if IsList( chars ) and ForAll( chars, IsClassFunction ) then
      # The characters are explicitly given.
      # Compute the positions of their irreducible constituents.
      primes:= [];
      consts:= [];
      for i in [ 1 .. Length( chars ) ] do
        chi:= chars[i];
        tbl:= UnderlyingCharacterTable( chi );
        if IsOrdinaryTable( tbl ) then
          ordtbl:= tbl;
        else
          ordtbl:= OrdinaryCharacterTable( tbl );
        fi;
        if gapname = Identifier( ordtbl ) and
           ( p = "?" or
             ( IsFunction( p ) and p( UnderlyingCharacteristic( tbl ) ) = true ) or
             ( IsList( p ) and UnderlyingCharacteristic( tbl ) in p ) ) then
          if IsOrdinaryTable( tbl ) then
            dec:= MatScalarProducts( tbl, Irr( tbl ), [ chi ] )[1];
          else
            dec:= Decomposition( Irr( tbl ), [ chi ], "nonnegative" )[1];
          fi;
          const:= [];
          if dec <> fail and ForAll( dec, x -> IsInt( x ) and 0 <= x ) then
            AddSet( primes, UnderlyingCharacteristic( tbl ) );
            for j in [ 1 .. Length( dec ) ] do
              if dec[j] = 1 then
                Add( const, j );
              elif 1 < dec[j] then
                Add( const, [ j, dec[j] ] );
              fi;
            od;
            if Length( const ) = 1 and IsInt( const[1] ) then
              const:= const[1];
            fi;
            Add( consts, const );
          fi;
        fi;
      od;
      p:= primes;
      chi:= consts;
    elif not ( IsPosInt( chars ) or IsString( chars ) ) then
#T perhaps admit a list of positions or strings?
      return [];
    else
      # The position in the list of irreducibles or the name is given.
      if p = "?" then
        # No characteristic is specified, this means *ordinary* character.
        p:= [ 0 ];
      fi;
      chi:= chars;
    fi;

    # Look for the character(s) in the info lists.
    repnames:= [];
    for i in [ 1 .. Length( map ) ] do
      if IsBound( map[i] ) and
         ( ( IsFunction( p ) and ( ( i = 1 and p( 0 ) = true ) or
                                   ( 1 < i and p( i ) = true ) ) ) or
           ( IsList( p ) and ( ( i = 1 and 0 in p ) or i in p ) ) ) then
        mapi:= map[i];
        for j in [ 1 .. Length( mapi[1] ) ] do
          if ( IsPosInt( chi ) and mapi[1][j] = chi ) or
             ( IsString( chi ) and mapi[3][j] = chi ) or
             ( IsList( chi ) and mapi[1][j] in chi ) then
            # We have found a character that matches.
            Add( repnames, mapi[2][j] );
          fi;
        od;
      fi;
    od;

    if Length( repnames ) = 0 then
      return [];
    fi;

    # We will return a nonempty list. Remove 'Character' from 'conditions'.
    for i in [ pos .. Length( conditions )-2 ] do
      conditions[i]:= conditions[ i+2 ];
    od;
    Remove( conditions );
    Remove( conditions );

    return Filtered( reps, r -> r.repname in repnames );
    end;


#############################################################################
##
#F  AGR.AtlasGeneratingSetInfo( <conditions>, "one" )
#F  AGR.AtlasGeneratingSetInfo( <conditions>, "all" )
#F  AGR.AtlasGeneratingSetInfo( <conditions>, <types> )
##
##  This function does the work for 'OneAtlasGeneratingSetInfo',
##  'AllAtlasGeneratingSetInfos', and 'AGR.InfoReps'.
##  The first entry in <conditions> can be a group name
##  or a list of group names.
##
AGR.AtlasGeneratingSetInfo:= function( conditions, mode )
    local pos, tocid, gapnames, types, std, filter, givenRing, position,
          result, gapname, reps, cond, info, type, F;

    # Ignore the condition that no straight line programs are wanted.
    pos:= Position( conditions, IsStraightLineProgram );
    if pos <> fail and
       pos < Length( conditions ) and conditions[ pos + 1 ] = false then
      conditions:= Concatenation( conditions{ [ 1 .. pos-1 ] },
                       conditions{ [ pos+2 .. Length( conditions ) ] } );
    fi;

    # Restrict the sources.
    pos:= Position( conditions, "contents" );
    if pos <> fail then
      tocid:= conditions[ pos+1 ];
      conditions:= Concatenation( conditions{ [ 1 .. pos-1 ] },
                       conditions{ [ pos+2 .. Length( conditions ) ] } );
    else
      tocid:= "all";
    fi;

    # The first argument (if there is one) is a group name,
    # or a list of group names,
    # or an integer (denoting a standardization),
    # or a function (denoting the first condition).
    if Length( conditions ) = 0 or IsInt( conditions[1] )
                                or IsFunction( conditions[1] ) then
      # The group is not restricted.
      gapnames:= List( AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp,
                       pair -> pair[1] );
    elif IsString( conditions[1] ) then
      # Only one group is considered.
      gapnames:= [ AGR.GAPName( conditions[1] ) ];
      conditions:= conditions{ [ 2 .. Length( conditions ) ] };
    elif IsList( conditions[1] ) and ForAll( conditions[1], IsString ) then
      # A list of group names is prescribed.
      gapnames:= List( conditions[1], AGR.GAPName );
      conditions:= conditions{ [ 2 .. Length( conditions ) ] };
    else
      Error( "invalid first argument ", conditions[1] );
    fi;

    types:= AGR.DataTypes( "rep" );

    # Deal with a prescribed standardization.
    if 1 <= Length( conditions ) and
       ( IsInt( conditions[1] ) or
         ( IsList( conditions[1] ) and ForAll( conditions[1], IsInt ) ) ) then
      std:= conditions[1];
      if IsInt( std ) then
        std:= [ std ];
      fi;
      conditions:= conditions{ [ 2 .. Length( conditions ) ] };
    else
      std:= true;
    fi;

    # Extract a prescribed 'ConstructingFilter'.
    filter:= fail;
    pos:= Position( conditions, ConstructingFilter );
    if pos <> fail then
      if pos = Length( conditions ) or not IsFilter( conditions[ pos+1 ] ) then
        Error( "condition 'ConstructingFilter' must be followed by a filter" );
      fi;
      filter:= conditions[ pos+1 ];
      conditions:= Concatenation( conditions{ [ 1 .. pos-1 ] },
                       conditions{ [ pos+2 .. Length( conditions ) ] } );
    fi;

    # Extract a prescribed ring (but leave it in 'conditions').
    givenRing:= fail;
    pos:= Position( conditions, Ring );
    if pos <> fail then
      if pos = Length( conditions ) or not ( IsRing( conditions[ pos+1 ] )
#T admit a list of rings!
         or IsFunction( conditions[ pos+1 ] )
         or conditions[ pos+1 ] = fail ) then
        Error( "condition 'Ring' must be followed by a ring" );
      elif IsRing( conditions[ pos+1 ] ) then
        givenRing:= conditions[ pos+1 ];
      fi;
    fi;

    # A prescribed ring prescribes also a characteristic.
    if givenRing <> fail and Position( conditions, Characteristic ) = fail then
      conditions:= Concatenation( conditions,
                       [ Characteristic, Characteristic( givenRing ) ] );
    fi;

    # Deal with a prescribed representation number.
    pos:= Position( conditions, Position );
    if pos <> fail then
      if pos = Length( conditions ) or not IsPosInt( conditions[ pos+1 ] ) then
        Error( "condition 'Position' must be followed by a pos. integer" );
      fi;
      position:= conditions[ pos+1 ];
      conditions:= Concatenation( conditions{ [ 1 .. pos-1 ] },
                       conditions{ [ pos+2 .. Length( conditions ) ] } );
    fi;

    result:= [];

    for gapname in gapnames do

      reps:= AGR.MergedTableOfContents( tocid, gapname );

      # Evaluate the 'Position' condition.
      if pos <> fail then
        reps:= Filtered( reps, r -> r.repnr = position );
      fi;

      cond:= ShallowCopy( conditions );

      # Evaluate conditions involving '"minimal"' (modify 'cond' in place).
      if AGR.EvaluateMinimalityCondition( gapname, cond ) then
        # Evaluate the 'Character' condition.
        if Character in cond then
          reps:= AGR.EvaluateCharacterCondition( gapname, cond, reps );
        fi;

        # Loop over the relevant representations.
        for info in reps do
          type:= First( types, t -> t[1] = info.type );
          if ( std = true or info.standardization in std ) and
             type[2].AccessGroupCondition( info, ShallowCopy( cond ) ) then
            # Hack:
            # Store the desired ring/field if there is one,
            # in order to create the matrices over the correct ring/field.
            if givenRing <> fail and IsBound( info.ring )
               and not IsIdenticalObj( givenRing, info.ring ) then
              info:= ShallowCopy( info );
              info.givenRing:= givenRing;
            fi;
            if filter <> fail then
              info:= ShallowCopy( info );
#T twice copy?
              info.constructingFilter:= filter;
            fi;

            if mode = "one" then
              return info;
            else
              Add( result, info );
            fi;
          fi;
        od;
      fi;
    od;

    # We have checked all available representations.
    if mode = "one" then
      return fail;
    else
      return result;
    fi;
    end;


#############################################################################
##
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], IsPermGroup[, true] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], NrMovedPoints, <n> )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], IsMatrixGroup[, true] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>][, Characteristic, <p>]
#F                                                 [, Dimension, <m>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>][, Ring, <R>]
#F                                                 [, Dimension, <m>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>,][ <std>,] Position, <n> )
##
InstallGlobalFunction( OneAtlasGeneratingSetInfo, function( arg )
    return AGR.AtlasGeneratingSetInfo( arg, "one" );
    end );


#############################################################################
##
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], IsPermGroup[, true] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], NrMovedPoints, <n> )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], IsMatrixGroup[, true] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>][, Characteristic, <p>]
#F                                                  [, Dimension, <m>] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>][, Ring, <R>]
#F                                                  [, Dimension, <m>] )
##
InstallGlobalFunction( AllAtlasGeneratingSetInfos, function( arg )
    return AGR.AtlasGeneratingSetInfo( arg, "all" );
    end );


#############################################################################
##
#M  AtlasRepInfoRecord( <gapname> )
##
InstallMethod( AtlasRepInfoRecord,
    [ "IsString" ],
    function( gapname )
    local info, result, comp, groupname, name, maxes, maxstd, toc, record, i;

    # Make sure that the file 'gap/types.g' is already loaded.
    IsRecord( AtlasOfGroupRepresentationsInfo );

    if not IsBound( AGR.GAPnamesRec.( gapname ) ) then
      return rec();
    fi;

    info:= AGR.GAPnamesRec.( gapname )[3];
    result:= rec( name:= gapname );
    for comp in [ "size", "nrMaxes", "sizesMaxes", "structureMaxes" ] do
      if IsBound( info.( comp ) ) then
        result.( comp ):= StructuralCopy( info.( comp ) );
      fi;
    od;

    groupname:= AGR.InfoForName( gapname );
    name:= groupname[2];

    maxes:= [];
    maxstd:= [];
    for toc in AGR.TablesOfContents( "all" ) do
      if IsBound( toc.( name ) ) then
        record:= toc.( name );
        if IsBound( record.maxes ) then
          for i in record.maxes do
            if i[2] in maxes then
              AddSet( maxstd[ Position( maxes, i[2] ) ], i[1] );
            else
              Add( maxes, i[2] );
              Add( maxstd, [ i[1] ] );
            fi;
          od;
        fi;
      fi;
    od;
    if IsBound( info.maxext ) then
      for i in info.maxext do
        if i[2] in maxes then
          AddSet( maxstd[ Position( maxes, i[2] ) ], i[1] );
        else
          Add( maxes, i[2] );
          Add( maxstd, [ i[1] ] );
        fi;
      od;
    fi;
    if not IsEmpty( maxes ) then
      SortParallel( maxes, maxstd );
      ConvertToRangeRep( maxes );
      result.slpMaxes:= [ maxes, maxstd ];
    fi;

    return result;
    end );


#############################################################################
##
#F  AtlasGroup( [<gapname>[, <std>]] )
#F  AtlasGroup( [<gapname>[, <std>]], IsPermGroup[, true] )
#F  AtlasGroup( [<gapname>[, <std>]], NrMovedPoints, <n> )
#F  AtlasGroup( [<gapname>[, <std>]], IsMatrixGroup[, true] )
#F  AtlasGroup( [<gapname>[, <std>]][, Characteristic, <p>]
#F                                  [, Dimension, <m>] )
#F  AtlasGroup( [<gapname>[, <std>]][, Ring, <R>][, Dimension, <m>] )
#F  AtlasGroup( [<gapname>[, <std>]], Position, <n> )
#F  AtlasGroup( <identifier> )
##
InstallGlobalFunction( AtlasGroup, function( arg )
    local info, identifier, gapname, gens, result;

    if   Length( arg ) = 1 and IsRecord( arg[1] ) then
      info:= arg[1];
    elif Length( arg ) = 1 and IsList( arg[1] ) and not IsString( arg[1] ) then
      # Find the info record with this identifier.
      identifier:= arg[1];
      gapname:= identifier[1];
      info:= First( AGR.MergedTableOfContents( "all", gapname ),
                    r -> r.identifier = identifier );
    else
      info:= CallFuncList( OneAtlasGeneratingSetInfo, arg );
    fi;
    if info <> fail then
      gens:= AtlasGenerators( info );
      if gens <> fail then
        result:= GroupWithGenerators( gens.generators );
        if IsBound( gens.isPrimitive ) then
          SetIsPrimitive( result, gens.isPrimitive );
        fi;
        # Note that it would *not* be safe to set 'NrMovedPoints'
        # or 'LargestMovedPoint' to 'gens.p'.
        if IsBound( gens.rankAction ) then
          SetRankAction( result, gens.rankAction );
        fi;
        if IsBound( gens.size ) then
          SetSize( result, gens.size );
        fi;
        if IsBound( gens.transitivity ) then
          SetTransitivity( result, gens.transitivity );
          SetIsTransitive( result, gens.transitivity > 0 );
        fi;
#T Set known info about the *group* (IsSimple etc., not stored in 'gens')!
        SetAtlasRepInfoRecord( result, info );
        return result;
      fi;
    fi;
    return fail;
    end );


#############################################################################
##
#F  AtlasSubgroup( <gapname>[, <std>], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], IsPermGroup[, true], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], NrMovedPoints, <n>, <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], IsMatrixGroup[, true], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>][, Characteristic, <p>]
#F                                  [, Dimension, <m>], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>][, Ring, <R>]
#F                                  [, Dimension, <m>], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], Position, <n>, <maxnr> )
#F  AtlasSubgroup( <G>, <maxnr> )
#F  AtlasSubgroup( <identifier>, <maxnr> )
##
#T  ... or the same with '<maxnr>' replaced by '"maxes", <maxnr>, <maxstd>'
##
InstallGlobalFunction( AtlasSubgroup, function( arg )
    local maxnr, info, groupname, std, prog, result, inforec;

    maxnr:= arg[ Length( arg ) ];
    if not IsPosInt( maxnr ) then
      Error( "<maxnr> must be a positive integer" );
    fi;

    if   Length( arg ) = 2 and IsRecord( arg[1] ) then
      info:= arg[1];
      groupname:= info.groupname;
    elif Length( arg ) = 2 and IsGroup( arg[1] ) then
      if not HasAtlasRepInfoRecord( arg[1] ) then
        Error( "the 'AtlasRepInfoRecord' value is not set for the group" );
      fi;
      info:= AtlasRepInfoRecord( arg[1] );
      groupname:= info.groupname;
    elif Length( arg ) = 2 and IsList( arg[1] ) and not IsString( arg[1] ) then
      info:= rec( identifier:= arg[1], standardization:= arg[1][3] );
      groupname:= arg[1][1];
    elif 1 < Length( arg ) then
      info:= CallFuncList( OneAtlasGeneratingSetInfo,
                           arg{ [ 1 .. Length( arg ) - 1 ] } );
      groupname:= arg[1];
    else
      info:= fail;
    fi;

    if info = fail then
      return fail;
    fi;

    std:= info.standardization;
    prog:= AtlasProgram( groupname, std, "maxes", maxnr );
    if prog = fail then
      return fail;
    fi;

    if Length( arg ) = 2 and IsGroup( arg[1] ) then
      # We need not load the generators from files.
      result:= GroupWithGenerators( ResultOfStraightLineProgram( prog.program,
                                    GeneratorsOfGroup( arg[1] ) ) );
    else
      result:= AtlasGenerators( info );
      if result = fail then
        return fail;
      fi;
      result:= GroupWithGenerators( ResultOfStraightLineProgram( prog.program,
                                    result.generators ) );
    fi;

    if IsBound( prog.size ) then
      SetSize( result, prog.size );
    fi;
    inforec:= rec( identifier:= Concatenation( info.identifier,
                                               [ maxnr ] ),
                   standardization:= std );
    if IsBound( info.repnr ) then
      inforec.repnr:= info.repnr;
    fi;
    if IsBound( prog.subgroupname ) then
      inforec.groupname:= prog.subgroupname;
    fi;
    if IsBound( prog.size ) then
      inforec.size:= prog.size;
    fi;
    SetAtlasRepInfoRecord( result, inforec );

    return result;
    end );


#############################################################################
##
#M  ConjugacyClasses( <G> )
##
##  For a group with stored 'AtlasRepInfoRecord' value,
##  there may be a straight line program that computes class representatives.
##  If yes then use it, otherwise give up.
##
##  Note that the 'ccls' straight line programs output the representatives
##  in Atlas ordering, in particular the identity element comes first.
##
#T  Is there a way to express that a group constructed with 'AtlasSubgroup'
#T  does in fact have standard generators,
#T  such that class representatives can be computed with this method?
##
InstallMethod( ConjugacyClasses,
    [ "IsGroup and IsFinite and HasAtlasRepInfoRecord" ],
    OVERRIDENICE + RankFilter( IsPermGroup ),  # adjust to other uprankings
    function( G )
    local info, prg, reps;

    info:= AtlasRepInfoRecord( G );
    if info.groupname <> info.identifier[1] then
      # The group is just a subgroup of an Atlas group.
      TryNextMethod();
    fi;
    prg:= AtlasProgram( info.groupname, info.standardization, "classes" );
    if prg = fail then
      # We do not know a straight line program for computing class reps.
      TryNextMethod();
    fi;
    reps:= ResultOfStraightLineProgram( prg.program,
               GeneratorsOfGroup( G ) );
    return List( reps, x -> ConjugacyClass( G, x ) );
    end );


#############################################################################
##
#F  AtlasProgramInfo( <gapname>[, <std>][, "maxes"], <maxnr> )
#F  AtlasProgramInfo( <gapname>[, <std>], "maxes", <maxnr>[, <std2>] )
#F  AtlasProgramInfo( <gapname>[, <std>], "maxstd", <maxnr>, <vers>, <substd> )
#F  AtlasProgramInfo( <gapname>[, <std>], "kernel", <factname> )
#F  AtlasProgramInfo( <gapname>[, <std>], "classes" )
#F  AtlasProgramInfo( <gapname>[, <std>], "cyclic" )
#F  AtlasProgramInfo( <gapname>[, <std>], "cyc2ccl"[, <vers>] )
#F  AtlasProgramInfo( <gapname>[, <std>], "automorphism", <autname> )
#F  AtlasProgramInfo( <gapname>[, <std>], "check" )
#F  AtlasProgramInfo( <gapname>[, <std>], "presentation" )
#F  AtlasProgramInfo( <gapname>[, <std>], "find" )
#F  AtlasProgramInfo( <gapname>, <std>, "restandardize", <std2> )
#F  AtlasProgramInfo( <gapname>[, <std>], "other", <descr> )
##
InstallGlobalFunction( AtlasProgramInfo, function( arg )
    local identifier, gapname, groupname, type, result, std, argpos,
          conditions, tocs, toc, id;

    if Length( arg ) = 1 then

      # 'AtlasProgramInfo( <identifier> )'
      identifier:= arg[1];
      gapname:= identifier[1];
      groupname:= AGR.InfoForName( gapname );
      if groupname = fail then
        return fail;
      fi;
      for type in AGR.DataTypes( "prg" ) do
        result:= type[2].AtlasProgramInfo( type, identifier, groupname[2] );
        if result <> fail then
          result.groupname:= gapname;
          result.version:= AGR.VersionOfSLP( identifier[2] );
          return Immutable( result );
        fi;
      od;
      return fail;

    elif Length( arg ) = 0 or not IsString( arg[1] ) then
      Error( "the first argument must be the GAP name of a group" );
    fi;

    # Now handle the cases of more than one argument.
    gapname:= arg[1];
    groupname:= AGR.InfoForName( gapname );
    if groupname = fail then
      Info( InfoAtlasRep, 1,
            "AtlasProgramInfo: no group with GAP name '", gapname, "'" );
      return fail;
    fi;

    if IsInt( arg[2] ) and 2 < Length( arg ) then
      std:= [ arg[2] ];
      argpos:= 3;
    elif IsBool( arg[2] ) and 2 < Length( arg ) then
      std:= true;
      argpos:= 3;
    else
      std:= true;
      argpos:= 2;
    fi;
    conditions:= arg{ [ argpos .. Length( arg ) ] };

    # Restrict to a prescribed selection of tables of contents.
    tocs:= AGR.TablesOfContents( conditions );

    # 'AtlasProgramInfo( <gapname>[, <std>][, "maxes"], <maxnr> )'
    if ( Length( conditions ) = 1 and IsInt( conditions[1] ) ) or
       ( Length( conditions ) = 3 and IsInt( conditions[1] )
                                  and conditions[2] = "version" ) then
      conditions:= Concatenation( [ "maxes" ], conditions );
    fi;

    for toc in tocs do
      # Note that 'toc.( groupname[2] )' need not be bound
      # if database extensions provide straight line pograms.
      for type in AGR.DataTypes( "prg" ) do
        id:= type[2].AccessPRG( toc, groupname[2], std, conditions );
        if id <> fail then
          # The table of contents provides a program as is required.
          return AtlasProgramInfo( Concatenation( [ groupname[1] ], id ) );
        fi;
      od;
    od;

    # No program was found.
    Info( InfoAtlasRep, 2,
          "no program for conditions ", conditions, "\n",
          "#I  of the group with GAP name '", groupname[1], "'" );
    return fail;
end );


#############################################################################
##
#F  AtlasProgram( <gapname>[, <std>][, "maxes"], <maxnr> )
#F  AtlasProgram( <gapname>[, <std>], "maxes", <maxnr>[, <std2>] )
#F  AtlasProgram( <gapname>[, <std>], "maxstd", <maxnr>, <vers>, <substd> )
#F  AtlasProgram( <gapname>[, <std>], "kernel", <factname> )
#F  AtlasProgram( <gapname>[, <std>], "classes" )
#F  AtlasProgram( <gapname>[, <std>], "cyclic" )
#F  AtlasProgram( <gapname>[, <std>], "cyc2ccl"[, <vers>] )
#F  AtlasProgram( <gapname>[, <std>], "automorphism", <autname> )
#F  AtlasProgram( <gapname>[, <std>], "check" )
#F  AtlasProgram( <gapname>[, <std>], "presentation" )
#F  AtlasProgram( <gapname>[, <std>], "find" )
#F  AtlasProgram( <gapname>, <std>, "restandardize", <std2> )
#F  AtlasProgram( <gapname>[, <std>], "other", <descr> )
#F  AtlasProgram( <identifier> )
##
##  <identifier> is a list containing at the first position the string
##  <gapname>,
##  at the second position a string or a list of strings
##  (describing the filenames involved),
##  and at the third position a positive integer denoting the standardization
##  of the program.
##
InstallGlobalFunction( AtlasProgram, function( arg )
    local identifier, gapname, groupname, type, result, info;

    if Length( arg ) = 1 then

      # 'AtlasProgram( <identifier> )'
      identifier:= arg[1];
      gapname:= identifier[1];
      groupname:= AGR.InfoForName( gapname );
      if groupname = fail then
        return fail;
      fi;
      for type in AGR.DataTypes( "prg" ) do
        result:= type[2].AtlasProgram( type, identifier, groupname[2] );
        if result <> fail then
          result.groupname:= groupname[1];
          result.version:= AGR.VersionOfSLP( identifier[2] );
          return Immutable( result );
        fi;
      od;
      return fail;

    elif Length( arg ) = 0 or not IsString( arg[1] ) then
      Error( "the first argument must be the GAP name of a group" );
    fi;

    # Now handle the cases of more than one argument.
    info:= CallFuncList( AtlasProgramInfo, arg );
    if info = fail then
      return fail;
    fi;
    return AtlasProgram( info.identifier );
end );


#############################################################################
##
#M  EvaluatePresentation( <G>, <gapname>[, <std>] )
#M  EvaluatePresentation( <gens>, <gapname>[, <std>] )
##
InstallMethod( EvaluatePresentation,
    [ "IsGroup", "IsString" ],
    { G, gapname } -> EvaluatePresentation( GeneratorsOfGroup( G ), gapname, 1 ) );

InstallMethod( EvaluatePresentation,
    [ "IsHomogeneousList", "IsString" ],
    { gens, gapname } -> EvaluatePresentation( gens, gapname, 1 ) );

InstallMethod( EvaluatePresentation,
    [ "IsGroup", "IsString", "IsPosInt" ],
    { G, gapname, std } -> EvaluatePresentation( GeneratorsOfGroup( G ), gapname, std ) );

InstallMethod( EvaluatePresentation,
    [ "IsHomogeneousList", "IsString", "IsPosInt" ],
    function( gens, gapname, std )
      local prg;

      prg:= AtlasProgram( gapname, std, "presentation" );
      if prg = fail then
        return fail;
      elif NrInputsOfStraightLineDecision( prg.program )
           <> Length( gens ) then
        Error( "presentation for \"", gapname, "\" has ",
               NrInputsOfStraightLineDecision( prg.program ),
               " generators but ", Length( gens ),
               " generators were given" );
      fi;

      prg:= StraightLineProgramFromStraightLineDecision( prg.program );

      return ResultOfStraightLineProgram( prg, gens );
    end );


#############################################################################
##
#M  StandardGeneratorsData( <G>, <gapname>[, <std>] )
#M  StandardGeneratorsData( <gens>, <gapname>[, <std>] )
##
InstallMethod( StandardGeneratorsData,
    [ "IsGroup", "IsString" ],
    function( G, gapname )
      return StandardGeneratorsData( GeneratorsOfGroup( G ), gapname, 1 );
    end );

InstallMethod( StandardGeneratorsData,
    [ "IsHomogeneousList", "IsString" ],
    { gens, gapname } -> StandardGeneratorsData( gens, gapname, 1 ) );

InstallMethod( StandardGeneratorsData,
    [ "IsGroup", "IsString", "IsPosInt" ],
    function( G, gapname, std )
      return StandardGeneratorsData( GeneratorsOfGroup( G ), gapname, std );
    end );

InstallMethod( StandardGeneratorsData,
    [ "IsHomogeneousList", "IsString", "IsPosInt" ],
    function( gens, gapname, std )
      local prg, options, mgens, res;

      prg:= AtlasProgram( gapname, std, "find" );
      if prg = fail then
        return fail;
      fi;
      prg:= prg.program;

      if ValueOption( "projective" ) = true then
        # This is supported only for FFE matrix groups.
        # We do not check this condition,
        # 'ProjectiveOrder' will run into an error if it is not satisfied.
        options:= rec( orderfunction:= mat -> ProjectiveOrder( mat )[1] );
      else
        options:= rec();
      fi;

      mgens:= GeneratorsWithMemory( gens );
      res:= ResultOfBBoxProgram( prg, GroupWithGenerators( mgens ),
                                 options );
      if res = "timeout" then
        return "timeout";
      elif res = fail then
        # The program has detected that 'gens' cannot belong to 'gapname'.
        return fail;
      fi;

      return rec( gapname:= gapname,
                  givengens:= gens,
                  stdgens:= StripMemory( res ),
                  givengenstostdgens:= SLPOfElms( res ),
                  std:= std );
    end );


#############################################################################
##
#E

