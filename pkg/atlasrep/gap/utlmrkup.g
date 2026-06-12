#############################################################################
##
#W  utlmrkup.g           GAP 4 package CTblLib                  Thomas Breuer
##
##  This file contains utility functions for creating HTML files.
##  They are used for the web pages on
##  - decomposition matrices,
##  - the contents of the GAP Character Table Library,
##  - the contents of the MFER database,
##  - the contents of parts of the AtlasRep database.
##


#############################################################################
##
#V  MarkupGlobals
##
##  The constant 'MarkupGlobals.CompareMark' is used in 'HTMLFooter' and
##  'PrintToIfChanged'.
##
MarkupGlobals := rec(
    HTML:= rec(
        \+ := "+",
        \- := "&#8722;",
        lt := "&lt;",
        leq := "&#8804;",
        ast := "&#8727;",
        cdot := " &#8901; ",
        rightarrow:= "&#8594;",
        sub := [ "<sub>", "</sub>" ],
        super := [ "<sup>", "</sup>" ],
        center:= [ "<center>", "</center>" ],
        bold := [ "<strong>", "</strong>" ],
        dot := ".",
        splitdot := ":",
        times := " &times; ",
        wreath := " &#8768; ",
        xi := "&#958;",
        Z := "ℤ",
        outerbrackets:= [ "", "" ],
      ),
    LaTeX:= rec(
        \+ := "+",
        \- := "-",
        lt := "<",
        leq := "\\leq",
        ast := "\\ast",
        cdot := " \\cdot ",
        rightarrow:= "\\rightarrow",
        sub := [ "_{", "}" ],
        super := [ "^{", "}" ],
        center:= [ "\n\\begin{center}\n", "\n\\end{center}\n" ],
        bold := [ "\\textbf{", "}" ],
        dot := ".",
        splitdot := ":",
        times := " \\times ",
        wreath := " \\wr ",
        xi := "\\xi",
        Z := "\\texttt{{\\ensuremath{\\mathbb Z}}}",
        outerbrackets:= [ "", "" ],
      ),
    MathJax:= rec(
        \+ := "+",
        \- := "-",
        lt := "&lt;",
        leq := "\\leq",
        ast := "\\ast",
        cdot := " \\cdot ",
        rightarrow:= "\\rightarrow",
        sub := [ "_{", "}" ],
        super := [ "^{", "}" ],
        center:= [ "\n\\begin{center}\n", "\n\\end{center}\n" ],
        bold := [ "\\textbf{", "}" ],
        dot := ".",
        splitdot := ":",
        times := " \\times ",
        wreath := " \\wr ",
        xi := "\\xi",
        Z := "\\texttt{{\\ensuremath{\\mathbb Z}}}",
        outerbrackets:= [ "\\(", "\\)" ],
      ),
    CompareMark:= "File created automatically by GAP on ",
  );


#############################################################################
##
#F  MarkupFactoredNumber( <n>, <global> )
##
##  This is used in 'ctbltoc/gap/htmltbl.g'.
##
MarkupFactoredNumber:= function( n, global )
    if   global = "LaTeX" then
      global:= MarkupGlobals.LaTeX;
    elif global = "HTML" then
      global:= MarkupGlobals.HTML;
    fi;

    if not IsPosInt( n ) then
      Error( "<n> must be a positive integer" );
    elif n = 1 then
      return "1";
    fi;

    # Loop over the prime factors and the corresponding exponents.
    return ReplacedString(
               JoinStringsWithSeparator(
                   List( Collected( Factors( n ) ),
                         pair -> Concatenation( 
                                     String( pair[1] ), global.super[1],
                                     String( pair[2] ), global.super[2] ) ),
                   global.cdot ),
               Concatenation( global.super[1], "1", global.super[2] ), "" );
end;


#############################################################################
##
#F  NormalizedNameOfGroup( <name>, <global> )
##
##  Let <name> be a string describing a group structure,
##  and <global> be one of "HTML", "LaTex", "MathJax", or a component of
##  'MarkupGlobals'.
##  This function proceeds as follows.
##  - If <name> consists of two group names that are combined with '" < "'
##    or '" -> "' then treat the parts separately;
##    this occurs in names used in the MFER package.
##  - If <name> contains the character '/' that is not surrounded by
##    digit characters then just return <name>;
##    this occurs for table identifiers such as 'P1/G1/L1/V1/ext2'.
##  - If name ends with 'M<n>' or 'N<n>' or 'N<n><char>' then keep this
##    suffix and normalize the part until this suffix,
##    *except* if 'M<n>' stands for a Mathieu group.
##  - In all other cases, it turns <name> into a tree describing the
##    hierarchy given by the substrings " < " and " -> "
##    (only on the outermost level) and brackets,
##    then splits the strings that occur in this tree at
##    the following characters.
##    ',' (appears in some MFER strings),
##    'x' (for direct product),
##    '.' and ':' (for product and semidirect product, respectively),
##    '_' (for a subscript),
##    '^' (for an exponent),
##    where the weakest binding is treated first.
##  - Then the strings that occur in the resulting tree are converted:
##    numbers following a capital letter are turned into subscripts,
##    and the characters '+', '-' are turned into superscripts.
##  - Finally, this tree is imploded into a string, where the characters at
##    which the input was split are replaced by the relevant entries of
##    <global>.
##
NormalizedNameOfGroup:= function( name, global )
    local extractbrackets, split, convertstring, convertatoms, concatenate,
          pos, result, i;

    if IsString( global ) and IsBound( MarkupGlobals.( global ) ) then
      global:= MarkupGlobals.( global );
    fi;

    extractbrackets:= function( str )
      local tree, brackets, pos, minpos, b, closeb, closepos, open;

      tree:= [];
      brackets:= [ "([{", ")]}" ];
      while str <> "" do
        pos:= List( brackets[1], b -> Position( str, b ) );
        minpos:= Minimum( pos );
        if minpos <> fail then
          b:= str[ minpos ];
          closeb:= brackets[2][ Position( brackets[1], b ) ];
          closepos:= minpos+1;
          open:= 0;
          while closepos <= Length( str )
                and ( str[ closepos ] <> closeb or open <> 0 ) do
            if   str[ closepos ] = b then
              open:= open+1;
            elif str[ closepos ] = closeb then
              open:= open-1;
            fi;
            closepos:= closepos + 1;
          od;
          if closepos > Length( str ) then
            return fail;
          fi;
          Append( tree,
               [ str{ [ 1 .. minpos-1 ] },
                 rec( op:= b,
                      contents:= extractbrackets( str{ [ minpos+1
                                     .. closepos-1 ] } ) ) ] );
          str:= str{ [ closepos+1 .. Length( str ) ] };
        else
          Add( tree, str );
          str:= "";
        fi;
      od;
      return tree;
    end;

    split:= function( tree )
      local i, splitchar, found, entry, pos;

      tree:= ShallowCopy( tree );
      for i in [ 1 .. Length( tree ) ] do
        entry:= tree[i];
        if IsRecord( tree[i] ) then
          if IsBound( entry.contents ) then
            tree[i]:= rec( op:= entry.op, contents:= split( entry.contents ) );
          else
            tree[i]:= rec( op:= entry.op, left:= split( entry.left ),
                               right:= split( entry.right ) );
          fi;
        fi;
      od;

      for splitchar in ",x.:_^" do  # weakest binding first!
        for i in [ 1 .. Length( tree ) ] do
          entry:= tree[i];
          if IsString( entry ) then
            pos:= Position( entry, splitchar );
            if pos <> fail then
              return [ rec( op:= splitchar,
                          left:= split( Concatenation( tree{ [ 1 .. i-1 ] },
                                 [ entry{ [ 1 .. pos-1 ] } ] ) ),
                          right:= split( Concatenation( [ entry{ [ pos+1
                                     .. Length( entry ) ] } ],
                                     tree{ [ i+1 .. Length( tree ) ] } ) ) ) ];
            fi;
          fi;
        od;
      od;

      for i in [ 1 .. Length( tree ) ] do
        entry:= tree[i];
        if IsString( entry ) then
          pos:= PositionSublist( entry, "wr" );
          if pos <> fail then
            return [ rec( op:= "wreath",
                        left:= split( Concatenation( tree{ [ 1 .. i-1 ] },
                               [ entry{ [ 1 .. pos-1 ] } ] ) ),
                        right:= split( Concatenation( [ entry{ [ pos+2
                                   .. Length( entry ) ] } ],
                                   tree{ [ i+1 .. Length( tree ) ] } ) ) ) ];
          fi;
        fi;
      od;

      return tree;
    end;

#T If we want to replace '"L2(4)"' and not '"L2"' then
#T first we have to implode locally, in order to get "(4)";
#T this is done by the following function.
#T Afterwards, we have to implode locally the two parts in question.
    # concatenatenumberbrackets:= function( tree )
    #     local i;
    #
    #     for i in [ 1 .. Length( tree ) ] do
    #       if IsRecord( tree[i] ) then
    #         if   tree[i].op = '^' and Length( tree[i].left ) = 1
    #                               and Length( tree[i].right ) = 1
    #                               and IsString( tree[i].left[1] )
    #                               and Int( tree[i].left[1] ) <> fail
    #                               and IsString( tree[i].right[1] )
    #                               and Int( tree[i].right[1] ) <> fail then
    #           tree[i]:= Concatenation( tree[i].left[1], global.super[1],
    #                                    tree[i].right[1], global.super[2] );
    #         elif tree[i].op = '_' and Length( tree[i].left ) = 1
    #                               and Length( tree[i].right ) = 1
    #                               and IsString( tree[i].left[1] )
    #                               and Int( tree[i].left[1] ) <> fail
    #                               and IsString( tree[i].right[1] )
    #                               and Int( tree[i].right[1] ) <> fail then
    #           tree[i]:= Concatenation( tree[i].left[1], global.sub[1],
    #                                    tree[i].right[1], global.sub[2] );
    #         elif tree[i].op = '(' and Length( tree[i].contents ) = 1
    #                               and IsString( tree[i].contents[1] )
    #                               and Int( tree[i].contents[1] ) <> fail then
    #           tree[i]:= Concatenation( "(", tree[i].contents[1], ")" );
    #         elif IsBound( tree[i].contents ) then
    #           concatenatenumberbrackets( tree[i].contents );
    #         else
    #           concatenatenumberbrackets( tree[i].left );
    #           concatenatenumberbrackets( tree[i].right );
    #         fi;
    #       fi;
    #     od;
    #
    #     return tree;
    # end;

    convertstring:= function( str )
      local digits, letters, lower, special, pos, len, string, dig;

      NormalizeWhitespace( str );

      digits  := "0123456789";
      letters := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      lower   := "abcdefghijklmnopqrstuvwxyz";

      # translate special cases
      special:= TransposedMat( [
         [ "McL", Concatenation( "M", global.super[1], "c",
                                 global.super[2], "L" ) ],
         [ "F3+", Concatenation( "F", global.sub[1], "3+", global.sub[2] ) ],
         [ "Fi24'", Concatenation( "Fi", global.sub[1], "24", global.sub[2],
                                 global.super[1], "'", global.super[2] ) ],
         [ "2E6", Concatenation( global.super[1], "2", global.super[2],
                                 "E", global.sub[1], "6", global.sub[2] ) ],
         [ "2F4", Concatenation( global.super[1], "2", global.super[2],
                                 "F", global.sub[1], "4", global.sub[2] ) ],
         [ "3D4", Concatenation( global.super[1], "3", global.super[2],
                                 "D", global.sub[1], "4", global.sub[2] ) ],
         ] );
      pos:= Position( special[1], str );
      if pos <> fail then
        string:= special[2][ pos ];
        if StartsWith( string, "^" ) then
          # This happens only in the LaTeX situation.
          string:= Concatenation( "{}", string );
        fi;
        return string;
      fi;

      # general heuristics
      pos:= 1;
      len:= Length( str );
      string:= "";

      # initial digits (happens if 'str' consists oly of digits)
      while pos <= len and str[ pos ] in digits do
        Add( string, str[ pos ] );
        pos:= pos + 1;
      od;

      while pos <= len do
        # copy letter part
        if str[ pos ] in letters then
          while pos <= len and str[ pos ] in letters do
            Add( string, str[ pos ] );
            pos:= pos + 1;
          od;
        fi;

        # following digits become subscripts
        if pos <= len and str[ pos ] in digits then
          Append( string, global.sub[1] );
          while pos <= len and str[ pos ] in digits do
            Add( string, str[ pos ] );
            pos:= pos + 1;
          od;
          Append( string, global.sub[2] );
        fi;

        # A following '+' or '-' becomes a superscript if it is the last letter
        # except if it is the only letter
        # (and except for '"F3+"' but this has been handled above ...).
        if pos = len and str[ pos ] in "+-" then
          if pos = 1 then
            Append( string, global.( [ str[ pos ] ] ) );
            pos:= pos + 1;
          else
            Append( string, global.super[1] );
            Append( string, global.( [ str[ pos ] ] ) );
            pos:= pos + 1;
            Append( string, global.super[2] );
          fi;
        fi;

        if pos <= len and not IsAlphaChar( str[ pos ] ) then
          while pos <= len do
            if str[ pos ] <> '_' then
              Add( string, str[ pos ] );
              pos:= pos + 1;
            else
              pos:= pos + 1;
              Append( string, global.sub[1] );
              while pos <= len and str[ pos ] in digits do
                Add( string, str[ pos ] );
                pos:= pos + 1;
              od;
              Append( string, global.sub[2] );
            fi;
          od;
        fi;
      od;

      return string;
    end;

    convertatoms:= function( tree )
      local i, entry;

      for i in [ 1 .. Length( tree ) ] do
        entry:= tree[i];
        if IsString( entry ) then
          tree[i]:= convertstring( tree[i] );
        elif IsBound( entry.contents ) then
          convertatoms( entry.contents );
        else
          convertatoms( entry.left );
          convertatoms( entry.right );
        fi;
      od;
      return tree;
    end;

    # Concatenate the translated parts.
    concatenate:= function( tree )
      local result, entry, right;

      result:= [];
      for entry in tree do
        if IsString( entry ) then
          Add( result, entry );
        elif IsBound( entry.contents ) then
          if   entry.op = '(' then
            Add( result,
                 Concatenation( "(", concatenate( entry.contents ), ")" ) );
          elif entry.op = '[' then
            Add( result,
                 Concatenation( "[", concatenate( entry.contents ), "]" ) );
          elif entry.op = '{' then
            Add( result,
                 Concatenation( "{", concatenate( entry.contents ), "}" ) );
          fi;
        else
          if   entry.op = '^' then
            # Deal with superscripts
            # (remove brackets around the superscripts if they are unique).
            right:= concatenate( entry.right );
            if Length( right ) > 0 and right[1] = '('
                                   and right[ Length( right ) ] = ')'
                                   and Number( right, x -> x = '(' ) = 1 then
              right:= right{ [ 2 .. Length( right ) - 1 ] };
            fi;
            Add( result, Concatenation( concatenate( entry.left ),
                             global.super[1], right, global.super[2] ) );
          elif entry.op = '_' then
            # Deal with subscripts
            # (remove brackets around the subscripts if they are unique).
            right:= concatenate( entry.right );
            if Length( right ) > 0 and
                  ( ( right[1] = '{' and right[ Length( right ) ] = '}'
                                     and Number( right, x -> x = '{' ) = 1 )
                  or ( right[1] = '(' and right[ Length( right ) ] = ')'
                                and Number( right, x -> x = '(' ) = 1 ) ) then
              right:= right{ [ 2 .. Length( right ) - 1 ] };
            fi;
            Add( result, Concatenation( concatenate( entry.left ),
                             global.sub[1], right, global.sub[2] ) );
          elif entry.op = 'x' then
            right:= concatenate( entry.right );
            if Length( right ) = 0 then
              Add( result, Concatenation( concatenate( entry.left ), "x" ) );
            else
              Add( result, Concatenation( concatenate( entry.left ),
                               global.times, concatenate( entry.right ) ) );
            fi;
          elif entry.op = "wreath" then
            Add( result, Concatenation( concatenate( entry.left ),
                             global.wreath, concatenate( entry.right ) ) );
          elif entry.op = '.' then
            Add( result, Concatenation( concatenate( entry.left ),
                             global.dot, concatenate( entry.right ) ) );
          elif entry.op = ':' then
            Add( result, Concatenation( concatenate( entry.left ),
                             global.splitdot, concatenate( entry.right ) ) );
          elif entry.op = ',' then
            Add( result, Concatenation( concatenate( entry.left ),
                             ", ", concatenate( entry.right ) ) );
          else
            Error( "unexpected entry.op" );
          fi;
        fi;
      od;
      return Concatenation( result );
    end;

    # If <name> consists of two group names that are combined with '" < "'
    # or '" -> "' then treat the parts separately.
    pos:= PositionSublist( name, " < " );
    if pos <> fail then
      return Concatenation(
                 global.outerbrackets[1],
                 NormalizedNameOfGroup( name{ [ 1 .. pos-1 ] }, global ),
                 " ", global.lt, " ",
                 NormalizedNameOfGroup( name{ [ pos+3 .. Length( name ) ] },
                                        global ),
                 global.outerbrackets[2] );
    fi;
    pos:= PositionSublist( name, " -> " );
    if pos <> fail then
      return Concatenation(
                 global.outerbrackets[1],
                 NormalizedNameOfGroup( name{ [ 1 .. pos-1 ] }, global ),
                 " ", global.rightarrow, " ",
                 NormalizedNameOfGroup( name{ [ pos+4 .. Length( name ) ] },
                                        global ),
                 global.outerbrackets[2] );
    fi;

    # Replace <name> by structure information known to CTblLib.
    if IsBound( StructureDescriptionCharacterTableName ) then
      name:= ValueGlobal( "StructureDescriptionCharacterTableName" )( name );
    fi;

    # If <name> contains the character '/' that is not surrounded by
    # digit characters then just return <name>.
    pos:= Position( name, '/' );
    if pos <> fail and pos <> 1 and pos <> Length( name ) and not
       ( IsDigitChar( name[ pos-1 ] ) and IsDigitChar( name[ pos+1 ] ) ) then
      return ShallowCopy( name );
    fi;

    # If name ends with 'M<n>' or 'N<n>' or 'N<n><char>' or 'C<n><char>'
    # then keep this suffix and normalize the part until this suffix,
    # *except* if 'M<n>' stands for a Mathieu group.
    pos:= Length( name );
    while pos > 0 and IsDigitChar( name[ pos ] ) do
      pos:= pos - 1;
    od;
    if pos < Length( name ) and pos > 0 and name <> "3^6:2M12" and
       ( name[ pos ] = 'N' or
         name = "M12C4" or
         ( name[ pos ] = 'M' and pos > 1 and not name[ pos-1 ] in ".:x" ) ) then
      return Concatenation( NormalizedNameOfGroup( name{ [ 1 .. pos-1 ] },
                                                   global ),
                            name{ [ pos .. Length( name ) ] } );
    fi;
    pos:= Length( name ) - 1;
    while pos > 0 and IsDigitChar( name[ pos ] ) do
      pos:= pos - 1;
    od;
    if pos < Length( name ) - 1 and pos > 1 and name[ pos ] in "CN" then
      return Concatenation( NormalizedNameOfGroup( name{ [ 1 .. pos-1 ] },
                                                   global ),
                            name{ [ pos .. Length( name ) ] } );
    fi;

    # Hack for a few names which contain proper subnames '<name>N<p>':
    # If there is an outer round bracket then recurse with its contents.
    result:= extractbrackets( NormalizedWhitespace( name ) );
    if Length( result ) = 3 and result[1] = "" and result[3] = ".2" and
       IsRecord( result[2] ) and result[2].op = '(' then
      return Concatenation( "(",
                 NormalizedNameOfGroup( name{ [ 2 .. Length( name ) - 3 ] },
                                        global ), ").2" );
    fi;

    # Now apply the translation rules.
    result:= concatenate( convertatoms( split( extractbrackets(
                 NormalizedWhitespace( name ) ) ) ) );
    for i in [ 1 .. 3 ] do
      result:= ReplacedString( result,
                   Concatenation( ".2<sub>", String( i ), "'</sub>" ),
                   Concatenation( ".2<sub>", String( i ), "</sub>'" ) );
    od;

    return Concatenation(
               global.outerbrackets[1], result, global.outerbrackets[2] );
end;


#############################################################################
##
#F  HTMLStandardTable( <header>, <matrix>, <tblclass>, <colclasses> )
##
##  <header>
##      must be 'fail' (if no table header is wanted) or a list of strings,
##      its entries are turned into <th> elements
##      (with the appropriate alignments),
##  <matrix>
##      must be a nonempty list of lists of strings,
##      the rows are turned into <tr> elements,
##      the entries are turned into <td> elements
##      where unbound and empty entries are represented by "&nbsp;"
##      (with the appropriate alignments),
##  <tblclass>
##      must be a style class for the table itself,
##  <colclasses>
##      must be a list of style classes for the <th> and <td> elements
##      (typically defining the alignments of the columns).
##
HTMLStandardTable:= function( header, matrix, tblclass, colclasses )
    local str, i, ncols, row;

    str:= Concatenation( "<table class=\"", tblclass, "\">\n" );
    ncols:= Maximum( List( matrix, Length ) );
    if IsList( header ) and not IsEmpty( header ) then
      ncols:= Maximum( ncols, Length( header ) );
      Append( str, "<tr class=\"firstrow\">\n" );
      for i in [ 1 .. ncols ] do
        if IsBound( colclasses[i] ) then
          Append( str, "<th class=\"" );
          Append( str, colclasses[i] );
          Append( str, "\">" );
        else
          Append( str, "<th>" );
        fi;
        if not IsBound( header[i] ) or IsEmpty( header[i] ) then
          Append( str, "&nbsp;" );
        else
          Append( str, header[i] );
        fi;
        Append( str, "</th>\n" );
      od;
      Append( str, "</tr>\n" );
    fi;
    for row in matrix do
      Append( str, "<tr>\n" );
      for i in [ 1 .. ncols ] do
        if IsBound( colclasses[i] ) then
          Append( str, "<td class=\"" );
          Append( str, colclasses[i] );
          Append( str, "\">" );
        else
          Append( str, "<td>" );
        fi;
        if not IsBound( row[i] ) or row[i] = "" then
          Append( str, "&nbsp;" );
        else
          Append( str, row[i] );
        fi;
        Append( str, "</td>\n" );
      od;
      Append( str, "</tr>\n" );
    od;
    Append( str, "</table>\n" );

    return str;
end;


#############################################################################
##
#F  HTMLHeader( <titlestring>, <stylesheetpath>, <commonheading>, <heading> )
##
##  For the given four strings,
##  'HTMLHeader' returns the string that prints as follows.
##
##  <?xml version="1.0" encoding="UTF-8"?>
##
##  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
##           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
##
##  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
##  <head>
##  <title>
##  <titlestring>
##  </title>
##  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
##  <link rel="stylesheet" type="text/css" href="<stylesheetpath>" />
##  </head>
##  <body>
##  <h5 class="pleft"><span class="Heading">
##  <commonheading>
##  </span></h5>
##  <h3 class="pcenter"><span class="Heading">
##  <heading>
##  </span></h3>
##
HTMLHeader:= function( titlestring, stylesheetpath, commonheading, heading )
    local str;

    str:= "";

    # Append the document type stuff.
    Append( str, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n" );
    Append( str, "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n" );
    Append( str, "         \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n\n" );
    Append( str, "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">\n" );

    # Append the head part, which contains the title.
    Append( str, "<head>\n" );
    Append( str, "<title>\n" );
    Append( str, titlestring );
    Append( str, "\n</title>\n" );
    Append( str, "<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\"/>\n" );  # needed to display symbols properly
    if IsString( stylesheetpath ) then
      # Support a list of style sheet paths.
      stylesheetpath:= [ stylesheetpath ];
    fi;
    if IsList( stylesheetpath ) and ForAll( stylesheetpath, IsString ) then
      Append( str, Concatenation( List( stylesheetpath,
          path -> Concatenation(
                      "<link rel=\"stylesheet\" type=\"text/css\" href=\"",
                      path, "\" />\n" ) ) ) );
    fi;
    Append( str, "</head>\n" );

    # Append the body begin, with font specifications.
    Append( str, "<body>\n" );
    if commonheading <> fail then
      Append( str, "<h5 class=\"pleft\"><span class=\"Heading\">" );
      Append( str, commonheading );
      Append( str, "\n</span></h5>\n" );
    fi;
    if heading <> fail then
      Append( str, "<h3 class=\"pcenter\"><span class=\"Heading\">" );
      Append( str, heading );
      Append( str, "\n</span></h3>\n" );
    fi;

    # Return the result.
    return str;
end;


#############################################################################
##
#F  HTMLFooter()
##
##  Let <datestr> be a string describing the current date,
##  as is returned by 'CurrentDateTimeString' (which belongs to 'AtlasRep'
##  and therefore cannot be used here in general).
##  'HTMLFooter' returns the string that prints as follows.
##
##  <hr/>
##  <p class="foot">File created by GAP on <datestr>.</p>
##
##  </body>
##  </html>
##
HTMLFooter:= function( )
    local date, name, out, pos, str;

    # Create a string that shows the current date.
    # (This is done as in AtlasRep's function 'CurrentDateTimeString'.)
    date:= "unknown";
    name:= Filename( DirectoriesSystemPrograms(), "date" );
    if name <> fail then
      date:= "";
      out:= OutputTextString( date, true );
      Process( DirectoryCurrent(), name, InputTextNone(), out,
               [ "-u", "+%s" ] );
      CloseStream( out );

      # Strip the trailing newline character.
      Unbind( date[ Length( date ) ] );

      # Transform to a format that is compatible with
      # 'StringDate' and 'StringTime'.
      date:= Int( date );
      date:= Concatenation( StringDate( Int( date / 86400 ) ),
                            ", ",
                            StringTime( 1000 * ( date mod 86400 ) ),
                            " UTC" );
      pos:= Position( date, ',' );
      if pos <> fail then
        date:= date{ [ 1 .. pos-1 ] };
      fi;
    fi;

    str:= "";

    # Append a horizontal line.
    Append( str, "\n<hr/>\n" );

    # Append the line about the file creation.
    Append( str, "<p class=\"foot\">" );
    Append( str, MarkupGlobals.CompareMark );
    Append( str, date );
    Append( str, ".</p>\n\n" );

    # Append the closing brackets.
    Append( str, "</body>\n" );
    Append( str, "</html>\n" );

    # Return the result.
    return str;
end;


#############################################################################
##
#F  PrintToIfChanged( <filename>, <str> );
##
##  Let <filename> be a filename, and <str> be a string.
##  If no file with name <filename> exists or if the contents of the file
##  with name <filename> is different from <str>, up to the ''last changed''
##  line, <str> is printed to the file.
##  Otherwise nothing is done.
##
PrintToIfChanged := function( filename, str )
    local mark, oldfile, contents, pos, diffstr,
          diff, out, tmpfile;

    mark:= MarkupGlobals.CompareMark;

    # Check whether the file exists in the web directory.
    if IsExistingFile( filename ) then

      # Check whether the contents of the file differs from 'str'.
      oldfile:= filename;
      contents:= AGR.StringFile( filename );
      pos:= PositionSublist( contents, mark );
      if    pos <> fail
         and pos = PositionSublist( str, mark )
         and contents{ [ 1 .. pos-1 ] } = str{ [ 1 .. pos-1 ] } then
        return Concatenation( "unchanged: ", filename );
      fi;

    fi;

    # The file does not yet exist or the info has changed,
    # so print a new file, and produce a 'diff' string if applicable.
    diffstr:= "";
    if IsBound( oldfile ) then
      diffstr:= "\n";
      diff:= Filename( DirectoriesSystemPrograms(), "diff" );
      if diff <> fail and IsExecutableFile( diff ) then
        out:= OutputTextString( diffstr, true );
        SetPrintFormattingStatus( out, false );
        tmpfile:= TmpName();
        FileString( tmpfile, str );
        Process( DirectoryCurrent(), diff, InputTextNone(), out,
                 [ oldfile, tmpfile ] );
        CloseStream( out );
        RemoveFile( tmpfile );
      fi;
    fi;

    if FileString( filename, str ) = fail then
      Error( "cannot write file '", filename, "'" );
    fi;

    return Concatenation( "replaced: ", filename, diffstr );
end;


#############################################################################
##
#E

