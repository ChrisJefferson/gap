#############################################################################
##
#W  htmltbl.g                                                   Thomas Breuer
##
#Y  Copyright (C)  2000,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the functions used to create the HTML info database
##  about the GAP Character Table Library.
##


#############################################################################
##
#F  IsNameOfAtlasCharacterTable( <name> )
##
IsNameOfAtlasCharacterTable := function( name )
    local attr, val;

    attr:= CTblLib.Data.IdEnumerator.attributes.InfoText;
    val:= attr.attributeValue( attr, name );
    return PositionSublist( val, "origin: ATLAS of finite groups" ) <> fail;
end;


#############################################################################
##
#V  HTMLGroupInfoFilesGlobals
##
##  parameters that will be used in the web pages of the character tables
##
HTMLGroupInfoFileGlobals := rec(
    versionstring := InstalledPackageVersion( "ctbllib" ),
    titlestring := "Character Table Info for a Group",
    commonheading := Concatenation( "<a href=\"../index.html\">",
                         "Overview of the GAP Character Table Library ",
                         "(version ", ~.versionstring, ")",
                         "</a>" ),
    stylesheetpath := "../ctbltoc.css",
    );


#############################################################################
##
#V  HTMLViewsGlobals
##
##  parameters that will be used in the creation of the overviews
##
HTMLViewsGlobals := rec(
    commonheading := "GAP Character Table Library",
#   maxsimplesize := 2^120*3^13*5^5*7^4*11^2*13^2*17^2*19*31^2*41*43*73*127*151*241*331
    maxsimplesizestring := "10^9",
    maxsimplesize := EvalString( ~.maxsimplesizestring ),
    documents := AllCharacterTableNames(),
#   documents := Union( Filtered(
#                           AllCharacterTableNames( IsDuplicateTable, false ),
#                           IsNameOfAtlasCharacterTable ),
#                       AllCharacterTableNames( IsDuplicateTable, false,
#                                               IsSimple, true ) ),
    );


ExistsDocumentForName := name -> name in HTMLViewsGlobals.documents;

FilenameGroupname:= function( filename )
    filename:= ReplacedString( filename, ":", "colon" );
    filename:= ReplacedString( filename, "\\", "backslash" );
    filename:= ReplacedString( filename, "/", "slash" );
    return filename;
end;

NameWithLink:= function( obj )
    local text, url, simpname;

    if obj.target[1] = "details page" then
      # link to another group info page, if such a page exists
      if obj.display = "L2(7)" then
        text:= "L3(2)";
      elif obj.display = "S4(3)" then
        text:= "U4(2)";
      else
        text:= obj.display;
      fi;
      if not obj.target[2][1] in HTMLViewsGlobals.documents then
        # We cannot create a link.
        return NormalizedNameOfGroup( text, "HTML" );
      fi;
      if ( not IsBound( obj.keep_display ) ) or obj.keep_display <> true then
        text:= NormalizedNameOfGroup( text, "HTML" );
      fi;
      url:= Concatenation( "../data/", FilenameGroupname( obj.target[2][1] ),
                           ".html" );
    elif obj.target[1] = "AtlasRep overview" then
      # link to the AtlasRep overview pages
      text:= obj.display;
      url:= Concatenation( "../../../atlasrep/htm/data/", obj.target[2][1],
                           ".htm" );
    elif obj.target[1] = "dec. matrix" then
      # link to the dec. matrices database
      text:= "dec. matrix (PDF)";
      url:= First( DecMatMap, x -> x[1] = obj.target[2][1] );
      if url = fail then
        return text;
      fi;
      if '.' in url[2] then
        simpname:= url[2]{ [ 1 .. Position( url[2], '.' )-1 ] };
      else
        simpname:= url[2];
      fi;
      url:= Concatenation( "http://www.math.rwth-aachen.de/~MOC/",
                "decomposition/tex/", simpname, "/", url[2], "mod",
                String( obj.target[2][2] ), ".pdf" );
    else
      Error( "unknown target in NameWithLink" );
    fi;

    return Concatenation( "<a href=\"", url, "\">", text, "</a>" );
end;

GroupNameWithLink:= name -> NameWithLink(
                                rec( target:= [ "details page", [ name ] ],
                                     display:= name ) );


#############################################################################
##
#F  CTblLib.HTMLRender( <obj>, <type> )
##
CTblLib.HTMLRender:= function( obj, type )
    local str, entry, header, mat, row, matrow, i;

    if IsString( obj ) then
      return NormalizedNameOfGroup( obj, type );
    elif not ( IsRecord( obj ) and IsBound( obj.type ) ) then
      Error( "<obj> must be a string or a record with the component `type'" );
    fi;

    if   obj.type = "string" then
      return obj.value;
    elif obj.type = "factored order" then
      return Concatenation( String( obj.value ), " = ",
                 MarkupFactoredNumber( obj.value, type ) );
    elif obj.type = "linkedtext" then
      return NameWithLink( obj );
    elif obj.type = "datalist" then
      str:= "<span class=\"indentedlist\">\n";
      for entry in obj.list do
        if obj.title = "Group constructions in GAP" then
          Append( str, Concatenation( "<code>", entry, "</code>" ) );
        elif obj.title = "Duplicates" then
          # special treatment: do not replace their names but create links
          entry.keep_display:= true;
          Append( str, CTblLib.HTMLRender( entry, type ) );
        else
          Append( str, CTblLib.HTMLRender( entry, type ) );
        fi;
        Append( str, ",\n" );
      od;
      Remove( str );
      Remove( str );
      Append( str, "</span>" );
      return str;
    elif obj.type = "datatable" then
      # render entries in the 'Name' column,
      # turn entries in the 'Structure' column to code
      header:= obj.header;
      mat:= [];
      for row in obj.matrix do
        matrow:= [];
        Add( mat, matrow );
        for i in [ 1 .. Length( header ) ] do
          if 1 < i and header[i] = "" then
            # dec. mat. table only
            matrow[i]:= CTblLib.HTMLRender( row[i], type );
            if not StartsWith( matrow[i], "<a href" ) then
              # Omit this row.
              Unbind( mat[ Length( mat ) ] );
              break;
            fi;
          elif header[i] = "Structure" then
            matrow[i]:= CTblLib.HTMLRender( row[i], type );
          elif header[i] = "Name" then
            matrow[i]:= Concatenation( "<code>", row[i].display, "</code>" );
          elif IsRecord( row[i] ) then
            matrow[i]:= row[i].display;
          else
            matrow[i]:= row[i];
          fi;
        od;
      od;

      if Length( mat ) = 0 then
        return fail;
      fi;
      return HTMLStandardTable( obj.header, mat, "pleft",
                 List( obj.colalign, x -> Concatenation( "p", x ) ) );
    else
      Error( "unknown type `", obj.type, "'" );
    fi;
end;


#############################################################################
##
#F  HTMLStringCTblLibInfo( <groupname>, <type>[, <p>] )
##
##  Create the string that is the contents of the HTML file describing the
##  ordinary or <p>-modular character table of the group <groupname>.
##
##  <type> must be '"HTML"' or '"MathJax"'.
##
HTMLStringCTblLibInfo := function( groupname, type, p... )
    local name, title, attr, str, info, fun, val, str2, url, simpname, i,
          row, targeturl;

    if Length( p ) = 0 and IsCharacterTable( groupname ) then
      p:= UnderlyingCharacteristic( groupname );
      groupname:= Identifier( groupname );
      if p <> 0 then
        name:= PartsBrauerTableName( groupname );
        if name <> fail then
          groupname:= name.ordname;
        fi;
      fi;
    elif Length( p ) = 0 and IsString( groupname ) then
      p:= 0;
    elif Length( p ) = 1 and IsString( groupname ) and IsPosInt( p[1] ) then
      p:= p[1];
    else
      Error( "usage: HTMLStringCTblLibInfo( <tbl>, <type> ) or\n",
             "  HTMLStringCTblLibInfo( <name>, <type>[, <p>] )" );
    fi;

    name:= LibInfoCharacterTable( groupname );
    if name = fail then
      return "";
    fi;
    groupname:= name.firstName;

    # Construct the information about `groupname'.
    title:= "Character Table info for ";
    if CTblLib.TableValue( groupname, "IdentifierOfMainTable" ) = fail then
      Append( title, NormalizedNameOfGroup( groupname, type ) );
    else
      # We deal with a duplicate table.
      Append( title, groupname );
    fi;
    if p = 0 then
      info:= CTblLib.OrdinaryTableInfo;
    else
      info:= CTblLib.BrauerTableInfo;
      Append( title, Concatenation( " mod ", String( p ) ) );
    fi;

    # For the HTML pages, first show the identifier.
    # (This is not needed for the overviews shown inside the GAP session.)
    info:= Concatenation( [
        function( groupname, p )
          local str;

          str:= Concatenation( "<code>", groupname );
          if p <> 0 then
            Append( str, "mod" );
            Append( str, String( p ) );
          fi;
          Append( str, "</code>" );

          return rec( type:= "string", title:= "Name", value:= str );
        end ],
        info );

    # header
    str:= HTMLHeader( HTMLGroupInfoFileGlobals.titlestring,
                      HTMLGroupInfoFileGlobals.stylesheetpath,
                      HTMLGroupInfoFileGlobals.commonheading,
                      title );

    # contents
    Append( str, "<dl>\n" );
    for fun in info do
      val:= fun( groupname, p );
      if val <> fail then
        if val.title = "Available Brauer tables" then
          # adjust the Brauer section: omit the columns for 'details' and
          # 'show table'
          val.header:= [ "p", "" ];
          val.matrix:= List( val.matrix, row -> row{ [ 1, 4 ] } );
        
          # omit rows for which the Brauer tables are not in the dec. mat.
          # database (GAP can compute some Brauer tables)
          url:= First( DecMatMap, x -> x[1] = groupname );
          if url = fail then
            continue;
          fi;
          if '.' in url[2] then
            simpname:= url[2]{ [ 1 .. Position( url[2], '.' )-1 ] };
          else
            simpname:= url[2];
          fi;
          for i in [ 1 .. Length( val.matrix ) ] do
            row:= val.matrix[i];
            targeturl:= First( DecMatMap, x -> x[1] = row[2].target[2][1] );
            if targeturl = fail or
               not IsExistingFile( Concatenation(
                             Filename( DirectoriesPackageLibrary(
                                       "ctbllib", "dec/tex" ), "" ),
                             simpname, "/", targeturl[2],
                             "mod", row[1], ".pdf" ) ) then
              Unbind( val.matrix[i] );
            fi;
          od;
        fi;
        str2:= CTblLib.HTMLRender( val, type );
        if str2 = fail then
          continue;
        elif not IsString( str2 ) then
          str2:= JoinStringsWithSeparator( str2, "\n  " );
        fi;

        # label
        Append( str, "<dt class=\"strong\">\n" );
        Append( str, val.title );
        Append( str, ":\n</dt>\n" );
        # data
        Append( str, "<dd class=\"spacebelow\">\n" );
        Append( str, str2 );
        Append( str, "\n</dd>\n\n" );
      fi;
    od;
    Append( str, "</dl>\n" );

    # footer
    Append( str, HTMLFooter() );

    return str;
end;


#############################################################################
##
#F  HTMLCreateGroupInfoFile( <groupname> )
##
##  'HTMLCreateGroupInfoFile' creates the HTML file with name
##  '<groupname>.html' that displays the info for the GAP character table
##  with 'Identifier' value <groupname>.
##  The information returned by 'TableDatabaseInfo' is used,
##  each entry being translated into an entry of a HTML definition list.
##
HTMLCreateGroupInfoFile := function( groupname )
    local str, dir;

    str:= HTMLStringCTblLibInfo( groupname, "HTML" );

    # Create the file.
    dir:= DirectoriesPackageLibrary( "ctbllib", "ctbltoc/data"  )[1];
    PrintToIfChanged( Filename( dir,
                          Concatenation( FilenameGroupname( groupname ),
                                         ".html" ) ),
                      str );
end;


#############################################################################
##
#V  HTMLCreateView
##
HTMLCreateView := rec();


#############################################################################
##
#F  HTMLCreateView.allbyorder()
##
##  This view lists the names of all character tables in the GAP table library
##  according to their group orders.
##
##  If a web page for the character table is available in GAP then the
##  table name appears as a link to the page for this table.
##
HTMLCreateView.allbyorder := function()
    local str, tables, attr, sizes, matrix, dir;

    # Create the header string.
    str:= HTMLHeader( "All GAP Table Names by Group Order",
                      HTMLGroupInfoFileGlobals.stylesheetpath,
                      HTMLGroupInfoFileGlobals.commonheading,
                      "All GAP Table Names by Group Order" );

    # Add explanatory text.
    Append( str, JoinStringsWithSeparator( [
      "\n<p>",
      "This table lists the ordinary character tables",
      "contained in the GAP Character Table Library",
      Concatenation(
          "(version ", HTMLGroupInfoFileGlobals.versionstring, ")," ),
      "by increasing group order.",
      "</p><p>",
      "The column <strong>Structure</strong> shows a group name",
      "in a format involving subscripts and superscripts,",
      "similar to the notation used in the ATLAS of Finite Groups.",
      "Clicking on this name opens the details page",
      " about the GAP character table.",
      "</p><p>",
      "The column <strong>Name</strong> shows the <code>Identifier</code>",
      "value of the GAP character table.",
      "Note that some <code>Identifier</code> values give less information",
      "about the group structure than the corresponding values in the",
      "<strong>Structure</strong> column.",
      "</p><p>",
      "The columns <strong>Order</strong> and",
      "<strong>Order (factored)</strong>",
      "show the group order as decimal numbers and in factored form,",
      "respectively.",
      "</p>\n",
      ], "\n" ) );

    # Compute the list of character table names in the {\GAP} table library,
    # and get the group orders.
    tables:= AllCharacterTableNames( IsDuplicateTable, false
                                     : OrderedBy := Size );
    attr:= CTblLib.Data.IdEnumerator.attributes.Size;
    sizes:= List( tables, name -> attr.attributeValue( attr, name ) );

    # Loop over the tables, and enter the names into a table.
    matrix:= List( [ 1 .. Length( sizes ) ],
                   i -> [ GroupNameWithLink( tables[i] ),
                          Concatenation( "<code>", tables[i], "</code>" ),
                          String( sizes[i] ),
                          MarkupFactoredNumber( sizes[i], "HTML" ) ] );

    # Sort the groups of the same order alphabetically.
    SortBy( matrix, x -> [ Int( x[3] ), x[1] ] );

    Append( str, HTMLStandardTable(
        [ "Structure", "Name", "Order", "Order (factored)" ],
        matrix, "pleft",
        [ "pleft", "pleft", "pright", "pleft" ] ) );

    # Append the footer string.
    Append( str, HTMLFooter() );

    # Create the file.
    dir:= DirectoriesPackageLibrary( "ctbllib", "ctbltoc/views"  )[1];
    PrintToIfChanged( Filename( dir, "allbyorder.html" ), str );
end;


#############################################################################
##
#F  ExtensionInfoFiniteSimpleGroup( <series>, <parameter> )
##
##  preliminary code for computing descriptions of the Schur multiplier and
##  the outer automorphism group of a simple group,
##  sufficient for groups of order up to 10^9
##
##  admissible values of series are "L", "A", "Spor", "B", "C", "D", "E",
##  "F", "2A", "2B", "2D", "3D", "2E", "2F", "2G"
##
ExtensionInfoFiniteSimpleGroup:= function( series, parameter )
    local n, q, mult, f, out, entry;

    if not series in [ "A", "B", "C", "D", "E", "F", "G", "L",
                       "2A", "2B", "2D", "3D", "2E", "2F", "2G", "Spor" ] then
      Error( "unknown <series>" );
    elif series = "A" then
      # Alt( n )
      n:= parameter;
      if n = 6 then
        mult:= "6";
        out:= "2^2";
      elif n = 7 then
        mult:= "6";
        out:= "2";
      else
        mult:= "2";
        out:= "2";
      fi;
    elif series = "L" then
      # PSL( n, q )
      n:= parameter[1];
      q:= parameter[2];
      if not IsPrimePowerInt( q ) then
        Error( "<q> must be a prime power" );
      fi;
      if n = 2 then
        # multiplier, exceptional for 'q' in { 4, 9 }
        if q = 4 then
          mult:= "2";
        elif q = 9 then
          mult:= "6";
        elif IsEvenInt( q ) then
          mult:= "1";
        else
          mult:= "2";
        fi;
        # outer automorphisms
        f:= Length( Factors( Integers, q ) );
        if IsEvenInt( q ) then
          # d = g = 1, get cyclic f
          out:= String( f );
        elif f = 2 then
          out:= "2^2";
        elif IsEvenInt( f ) then
          # d = 2, g = 1, get 2xf
          out:= Concatenation( "2x", String( f ) );
        else
          # d = 2, g = 1, get cyclic 2f
          out:= String( 2*f );
        fi;
      else
        return fail;
      fi;
    elif series = "2B" then
      q:= parameter;
      f:= Length( Factors( Integers, q ) );
      if q = 8 then
        # multiplier, exceptional for 'q' = 8
        mult:= "2^2";
      else
        mult:= "1";
      fi;
      out:= String( f );
    elif series in [ "2F", "2G", "3D" ] then
      # no exceptional multipliers
      q:= parameter;
      f:= Length( Factors( Integers, q ) );
      mult:= "1";
      out:= String( f );
    elif series = "G" then
      # exceptional multipliers for q = 3 and q = 4;
      # the outer automorphism group is cyclic (see e.g. Kleidman 1988)
      q:= parameter;
      f:= Length( Factors( Integers, q ) );
      if q = 3 then
        mult:= "3";
      elif q = 4 then
        mult:= "2";
      else
        mult:= "1";
      fi;
      if Factors( q )[1] = 3 then
        # g = 2
        out:= String( 2*f );
      else
        # g = 1
        out:= String( f );
      fi;
    elif series = "Spor" then
      entry:= First( LIBLIST.simpleInfo, x -> x[2] = parameter );
      mult:= entry[1];
      if mult = "" then
        mult:= "1";
      fi;
      out:= entry[3];
      if out = "" then
        out:= "1";
      fi;
    else
#T TODO: "B", "C", "D", "E", "F", "2A", "2D", "2E"
      return fail;
    fi;

    return rec( mult:= mult, out:= out );
end;


MultInfoFiniteSimpleGroup:= function( pair )
    local info, iso;

    # If CTblLib stores the info then take it.
    info:= First( LIBLIST.simpleInfo, x -> x[2] = pair[2] );
    if info <> fail then
      if info[1] = "" then
        return "1";
      elif info[1][1] = '(' and info[1][ Length( info[1] ) ] = ')' then
        return info[1]{ [ 2 .. Length( info[1] ) - 1 ] };
      else
        return info[1];
      fi;
    fi;

    # Compute the value.
    iso:= IsomorphismTypeInfoFiniteSimpleGroup( pair[1] );
    info:= ExtensionInfoFiniteSimpleGroup( iso.series, iso.parameter );
    if info <> fail then
      return info.mult;
    fi;

    # some exceptions until order 10^9
    if pair[2] = "L3(13)" then
      return "3";
    elif pair[2] = "U3(13)" then
      return "1";
    fi;

    Error( "no information about multiplier of ", pair );
end;


OutInfoFiniteSimpleGroup:= function( pair )
    local info, iso;

    # If CTblLib stores the info then take it.
    info:= First( LIBLIST.simpleInfo, x -> x[2] = pair[2] );
    if info <> fail then
      if info[3] = "" then
        return "1";
      elif info[3] = "3.2" then
        return "S3";
      elif info[3][1] = '(' and info[3][ Length( info[3] ) ] = ')' then
        return info[3]{ [ 2 .. Length( info[3] ) - 1 ] };
      else
        return info[3];
      fi;
    fi;

    # Compute the value.
    iso:= IsomorphismTypeInfoFiniteSimpleGroup( pair[1] );
    info:= ExtensionInfoFiniteSimpleGroup( iso.series, iso.parameter );
    if info <> fail then
      return info.out;
    fi;

    # some exceptions until order 10^9
    if pair[2] = "L3(13)" then
      return "S3";
    elif pair[2] = "U3(13)" then
      return "2";
    fi;

    Error( "no information about outer automorphism group of ", pair );
end;


#############################################################################
##
#F  HTMLCreateView.simplebyorder()
##
##  This view lists *all* nonabelian simple groups
##  (not only those whose tables are available in the GAP character table
##  library)
##  up to the order 'HTMLViewsGlobals.maxsimplesize',
##  together with their group orders
##  (as a decimal number and in factored form).
##  This is similar to the list shown in the ATLAS of Finite Groups on
##  pages~239--242.
##
##  Note that this list in the ATLAS only claims to show the simple groups
##  up to order 10^25, with specified omissions for L2(q) etc.;
##  *additionally*, the groups B, E7(2), M, E8(2) are listed,
##  whose orders are larger than 10^25.
##  (The character table library contains the tables of O12+(3) and O12-(3),
##  whose order is also larger than 10^25.
##  One should not wonder that these groups are missing from the list in the
##  Atlas.)
##
##  If a web page for the character table is available then
##  the table name appears as a link to the page for this table.
##
HTMLCreateView.simplebyorder := function()
    local str, sizes, matrix, i, pair, dir;

    # Create the header string.
    str:= HTMLHeader( "Simple Groups by Group Order",
                      HTMLGroupInfoFileGlobals.stylesheetpath,
                      HTMLGroupInfoFileGlobals.commonheading,
                      "Simple Groups by Group Order" );

    # Add explanatory text.
    Append( str, JoinStringsWithSeparator( [
      "\n<p>",
      "This table lists the names of nonabelian simple groups",
      Concatenation( "of order up to ",
          NormalizedNameOfGroup( HTMLViewsGlobals.maxsimplesizestring,
                                 "HTML" ), "," ),
      "by increasing group order.",
      "</p><p>",
      "The column <strong>Structure</strong> shows a group name",
      "in a format involving subscripts and superscripts,",
      "similar to the notation used in the ATLAS of Finite Groups.",
      "If the character table of the group in question is contained",
      "in the GAP Character Table Library",
      Concatenation(
          "(version ", HTMLGroupInfoFileGlobals.versionstring, ")" ),
      "then clicking on this name opens the details page",
      " about the GAP character table.",
      "</p><p>",
      "The column <strong>Name</strong> shows the <code>Identifier</code>",
      "value of the GAP character table (if applicable).",
      "</p><p>",
      "The columns <strong>Order</strong> and",
      "<strong>Order (factored)</strong>",
      "show the group order as decimal numbers and in factored form,",
      "respectively.",
      "</p><p>",
      "The columns <strong>Mult</strong> and <strong>Out</strong>",
      "show the structures of the Schur multiplier",
      "and of the outer automorphism group, respectively.",
      "</p>\n",
      ], "\n" ) );

    # Compute the list of all simple groups up to the prescribed order.
    sizes:= SizesSimpleGroupsInfo( HTMLViewsGlobals.maxsimplesize );

    # Loop over the orders, and enter the groups into a table.
    matrix:= [];
    for i in [ 1 .. Length( sizes ) ] do
      pair:= sizes[i];

      # Replace 'S4(3)' by 'U4(2)', and 'L2(7)' by 'L3(2)'.
      if pair[2] = "S4(3)" then
        pair:= [ pair[1], "U4(2)" ];
      elif pair[2] = "L2(7)" then
        pair:= [ pair[1], "L3(2)" ];
      fi;
      matrix[i]:= [ GroupNameWithLink( pair[2] ),
                    Concatenation( "<code>", pair[2], "</code>" ),
                    String( pair[1] ),
                    MarkupFactoredNumber( pair[1], "HTML" ),
                    NormalizedNameOfGroup( MultInfoFiniteSimpleGroup( pair ),
                                           "HTML" ),
                    NormalizedNameOfGroup( OutInfoFiniteSimpleGroup( pair ),
                                           "HTML" ) ];
      if PositionSublist( matrix[i][1], "href" ) = fail then
        matrix[i][2]:= "";
      fi;
    od;

    Append( str, HTMLStandardTable(
        [ "Structure", "Name", "Order", "Order (factored)", "Mult", "Out" ],
        matrix, "pleft",
        [ "pleft", "pleft", "pright", "pleft", "pleft", "pleft" ] ) );

    # Append the footer string.
    Append( str, HTMLFooter() );

    # Create the file.
    dir:= DirectoriesPackageLibrary( "ctbllib", "ctbltoc/views"  )[1];
    PrintToIfChanged( Filename( dir, "simplebyorder.html" ), str );
end;


#############################################################################
##
#E

