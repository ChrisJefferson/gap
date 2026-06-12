#############################################################################
##
#W  json.g               GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file defines and implements a conversion between certain low level
##  GAP objects and JSON (JavaScript Object Notation).
##


#############################################################################
##
##  <#GAPDoc Label="JsonIntro">
##  We define a mapping between certain &GAP; objects and
##  JSON (JavaScript Object Notation) texts (see <Cite Key="JSON"/>),
##  as follows.
##  <P/>
##  <List>
##  <Item>
##    The three &GAP; values <K>true</K>, <K>false</K>, and <K>fail</K>
##    correspond to the JSON texts <C>true</C>, <C>false</C>,
##    and <C>null</C>, respectively.
##  </Item>
##  <Item>
##    &GAP; strings correspond to JSON strings;
##    special characters in a &GAP; string (control characters ASCII <M>0</M>
##    to <M>31</M>, backslash and double quote) are mapped as defined in
##    JSON's specification, and other ASCII characters are kept as they are;
##    if a &GAP; string contains non-ASCII characters, it is assumed that
##    it is UTF-8 encoded, and one may choose either to keep non-ASCII
##    characters as they are, or to create an ASCII only JSON string, using
##    JSON's syntax for Unicode code points (<Q><C>\uXXXX</C></Q>);
##    in the other direction, JSON strings are assumed to be UTF-8 encoded,
##    and are mapped to UTF-8 encoded &GAP; strings, by keeping the non-ASCII
##    characters and converting substrings of the form <C>\uXXXX</C>
##    accordingly.
##  </Item>
##  <Item>
##    &GAP; integers (in the sense of <Ref Func="IsInt" BookName="ref"/>)
##    are mapped to JSON numbers that consist of digits and optionally
##    a leading sign character <C>-</C>;
##    in the other direction, JSON numbers of this form and also JSON numbers
##    that involve no decimal dots and have no negative exponent
##    (for example <C>"2e3"</C>) are mapped to &GAP; integers.
##  </Item>
##  <Item>
##    &GAP; rationals (in the sense of <Ref Func="IsRat" BookName="ref"/>)
##    which are not integers are represented by
##    JSON floating point numbers;
##    the JSON representation (and hence the precision) is given by
##    first applying <Ref Attr="Float" BookName="ref"/> and then
##    <Ref Attr="String" BookName="ref"/>.
##  </Item>
##  <Item>
##    &GAP; floats (in the sense of Chapter
##    <Ref Chap="Floats" BookName="ref"/> in the &GAP; Reference Manual)
##    are mapped to JSON floating point numbers;
##    the JSON representation (and hence the precision) is given by
##    applying <Ref Attr="String" BookName="ref"/>;
##    in the other direction, JSON numbers that involve a decimal dot or
##    a negative exponent are mapped to &GAP; floats.
##  </Item>
##  <Item>
##    (Nested and not self-referential) dense &GAP; lists of objects
##    correspond to JSON arrays such that the list entries correspond
##    to each other.
##    (Note that JSON does not support non-dense arrays.)
##  </Item>
##  <Item>
##    (Nested and not self-referential) &GAP; records correspond to JSON
##    objects such that both labels (which are strings in &GAP; and JSON)
##    and values correspond to each other.
##  </Item>
##  </List>
##  <P/>
##  The &GAP; functions <Ref Func="AGR.JsonText"/> and
##  <Ref Func="AGR.GapObjectOfJsonText"/> can be used to create a JSON
##  text from a suitable &GAP; object and the &GAP; object that
##  corresponds to a given JSON text, respectively.
##  <P/>
##  Note that the composition of the two functions is in general <E>not</E>
##  the identity mapping,
##  because <Ref Func="AGR.JsonText"/> accepts non-integer rationals,
##  whereas <Ref Func="AGR.GapObjectOfJsonText"/> does not create such
##  objects.
##  <P/>
##  Note also that the results of <Ref Func="AGR.JsonText"/> do not contain
##  information about dependencies between common subobjects.
##  This is another reason why applying first <Ref Func="AGR.JsonText"/> and
##  then <Ref Func="AGR.GapObjectOfJsonText"/> may yield a &GAP; object with
##  different behaviour.
##  <P/>
##  Applying <Ref Func="AGR.JsonText"/> to a self-referential object
##  such as <C>[ ~ ]</C> will raise a <Q>recursion depth trap</Q> error.
##
##  <Subsection Label="subsect:WhyJSON">
##  <Heading>Why JSON?</Heading>
##
##  The aim of this JSON interface is to read and write certain data files
##  with &GAP; such that these files become easily accessible independent
##  of &GAP;.
##  The function <Ref Func="AGR.JsonText"/> is intended just as a prototype,
##  variants of this function are very likely to appear in other contexts,
##  for example in order to force certain line formatting or ordering of
##  record components.
##  <P/>
##  It is <E>not</E> the aim of the JSON interface to provide self-contained
##  descriptions of arbitrary &GAP; objects, in order to read them into a
##  &GAP; session.
##  Note that those &GAP; objects for which a JSON equivalent exists (and
##  many more) can be easily written to files as they are,
##  and &GAP; can read them efficiently.
##  On the other hand, more complicated &GAP; objects can be written and read
##  via the so-called <E>pickling</E>, for which a framework is provided by
##  the &GAP; package <Package>IO</Package> <Cite Key="IO"/>.
##  <P/>
##  Here are a few situations which are handled well by pickling but which
##  cannot be addressed with a JSON interface.
##  <P/>
##  <List>
##  <Item>
##  Pickling and unpickling take care of common subobjects of the given
##  &GAP; object.
##  The following example shows that the applying first
##  <Ref Func="AGR.JsonText"/> and then
##  <Ref Func="AGR.GapObjectOfJsonText"/>
##  may yield an object which behaves differently.
##  <P/>
##  <Example><![CDATA[
##  gap> l:= [ [ 1 ] ];; l[2]:= l[1];;  l;
##  [ [ 1 ], [ 1 ] ]
##  gap> new:= AGR.GapObjectOfJsonText( AGR.JsonText( l ) ).value;
##  [ [ 1 ], [ 1 ] ]
##  gap> Add( l[1], 2 );  l;
##  [ [ 1, 2 ], [ 1, 2 ] ]
##  gap> Add( new[1], 2 );  new;
##  [ [ 1, 2 ], [ 1 ] ]
##  ]]></Example>
##  </Item>
##  <Item>
##  &GAP; admits self-referential objects, for example as follows.
##  <P/>
##  <Example><![CDATA[
##  gap> l:= [];;  l[1]:= l;;
##  ]]></Example>
##  <P/>
##  Pickling and unpickling take care of self-referential objects,
##  but <Ref Func="AGR.JsonText"/> does not support the conversion of such
##  objects.
##  </Item>
##  </List>
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
##  Every GAP function that produces a string for the outside world
##  must say something about the encoding of this string.
##  We provide a function that produces an ASCII string
##  and a function that assumes UTF-8 encoding of GAP strings,
##  and keeps this encoding except if the JSON specification prescribes
##  something different.
##


#############################################################################
##
#F  AGR.JsonStringEncodeKeep( <string> )
##
##  creates a string that describes the GAP string <string>
##  as a JSON string that has the same encoding as <string>.
##  We replace backslashes by double backslashes,
##  escape double quotes,
##  and replace the control characters 0, 1, ..., 31
##  by the corresponding values in JSON's '\uXXXX' format.
##
##  Note that we do not check whether <string> is a valid
##  UTF-8 encoded string.
##
AGR.JsonStringEncodeKeep:= function( string )
    local replace, pair;

    replace:= [
      [ "\\", "\\\\" ], [ "\"", "\\\"" ],
      [ "\000", "\\u0000" ], [ "\>", "\\u0001" ], [ "\<", "\\u0002" ],
      [ "\c", "\\u0003" ], [ "\004", "\\u0004" ], [ "\005", "\\u0005" ],
      [ "\006", "\\u0006" ], [ "\007", "\\u0007" ], [ "\b", "\\b" ],
      [ "\t", "\\t" ], [ "\n", "\\n" ], [ "\013", "\\u000B" ],
      [ "\014", "\\f" ], [ "\r", "\\r" ], [ "\016", "\\u000E" ],
      [ "\017", "\\u000F" ], [ "\020", "\\u0010" ], [ "\021", "\\u0011" ],
      [ "\022", "\\u0012" ], [ "\023", "\\u0013" ], [ "\024", "\\u0014" ],
      [ "\025", "\\u0015" ], [ "\026", "\\u0016" ], [ "\027", "\\u0017" ],
      [ "\030", "\\u0018" ], [ "\031", "\\u0019" ], [ "\032", "\\u001A" ],
      [ "\033", "\\u001B" ], [ "\034", "\\u001C" ], [ "\035", "\\u001D" ],
      [ "\036", "\\u001E" ], [ "\037", "\\u001F" ],
    ];

    for pair in replace do
      string:= ReplacedString( string, pair[1], pair[2] );
    od;

    return string;
end;


#############################################################################
##
#F  AGR.JsonStringEncodeASCII( <string> )
##
##  creates an ASCII string that describes the GAP string <string>
##  as a JSON string.
##  We replace backslashes by double backslashes,
##  escape double quotes,
##  and replace the control characters 0, 1, ..., 31
##  by the corresponding values in JSON's '\uXXXX' format.
##  Moreover, we rewrite all Unicode code points
##  except lower half ASCII to JSON's '\uXXXX' format.
##  Note that code points above U+FFFF are encoded via
##  UTF-16 surrogate pairs, using the reserved codepoints U+D800 to U+DBFF
##  for the first part and U+DC00 to U+DFFF for the second part.
##
##  If <string> is not a valid UTF-8 encoded string then 'fail' is returned.
##
AGR.JsonStringEncodeASCII:= function( string )
    local encodesmall, ustr, res, n, n2;

    encodesmall:= [ "\\u0000", "\\u0001", "\\u0002", "\\u0003", "\\u0004",
    "\\u0005", "\\u0006", "\\u0007", "\\b", "\\t", "\\n", "\\u000B", "\\f",
    "\\r", "\\u000E", "\\u000F", "\\u0010", "\\u0011", "\\u0012", "\\u0013",
    "\\u0014", "\\u0015", "\\u0016", "\\u0017", "\\u0018", "\\u0019",
    "\\u001A", "\\u001B", "\\u001C", "\\u001D", "\\u001E", "\\u001F", " ",
    "!", "\\\"" ];


    ustr:= Unicode( string );
    if ustr = fail then
      return fail;
    fi;

    res:= "";
    for n in IntListUnicodeString( ustr ) do
      if n < 35 then
        Append( res, encodesmall[ n+1 ] );
      elif n = 92 then
        Append( res, "\\\\" );
      elif n < 128 then
        Add( res, CHAR_INT( n ) );
      elif n < 256 then
        Append( res, "\\u00" );
        Append( res, HexStringInt( n ) );
      elif n < 4096 then
        Append( res, "\\u0" );
        Append( res, HexStringInt( n ) );
      elif n < 65536 then
        Append( res, "\\u" );
        Append( res, HexStringInt( n ) );
      elif n < 1114112 then
        n:= n - 65536;
        n2:= n mod 1024;
        Append( res, "\\u" );
        Append( res, HexStringInt( ( n - n2 ) / 1024 + 55296 ) );
        Append( res, "\\u" );
        Append( res, HexStringInt( n2 + 56320 ) );
      else
        return fail;
      fi;
    od;

    return res;
end;


#############################################################################
##
#F  AGR.JsonText( <obj>[, <mode>] )
##
##  <#GAPDoc Label="AGR.JsonText">
##  <ManSection>
##  <Func Name="AGR.JsonText" Arg='obj[, mode]'/>
##
##  <Returns>
##  a new mutable string that describes <A>obj</A> as a JSON text,
##  or <K>fail</K>.
##  </Returns>
##
##  <Description>
##  If <A>obj</A> is a &GAP; object for which a corresponding JSON text
##  exists, according to the mapping described above,
##  then such a JSON text is returned.
##  Otherwise, <K>fail</K> is returned.
##  <P/>
##  If the optional argument <A>mode</A> is given and has the value
##  <C>"ASCII"</C> then the result in an ASCII string,
##  otherwise the encoding of strings that are involved in <A>obj</A>
##  is kept.
##  <P/>
##  <Example><![CDATA[
##  gap> AGR.JsonText( [] );
##  "[]"
##  gap> AGR.JsonText( "" );
##  "\"\""
##  gap> AGR.JsonText( "abc\ndef\cghi" );
##  "\"abc\\ndef\\u0003ghi\""
##  gap> AGR.JsonText( rec() );
##  "{}"
##  gap> AGR.JsonText( [ , 2 ] );
##  fail
##  gap> str:= [ '\303', '\266' ];;  # umlaut o
##  gap> json:= AGR.JsonText( str );;  List( json, IntChar );
##  [ 34, 195, 182, 34 ]
##  gap> AGR.JsonText( str, "ASCII" );
##  "\"\\u00F6\""
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
AGR.JsonText:= function( arg )
    local mode, stringencode, obj, res, subobj, next, names, nam;

    stringencode:= AGR.JsonStringEncodeKeep;
    if Length( arg ) = 1 then
      obj:= arg[1];
      mode:= "";
    elif Length( arg ) = 2 and IsBound( GAPInfo ) then
      obj:= arg[1];
      mode:= arg[2];
      if mode = "ASCII" then
        stringencode:= AGR.JsonStringEncodeASCII;
      fi;
    else
      Error( "usage: AGR.JsonText( <obj>[, \"ASCII\"] )" );
    fi;

    if IsString( obj ) and ( IsStringRep( obj ) or not IsEmpty(  obj ) ) then
      obj:= stringencode( obj );
      if obj = fail then
        return fail;
      else
        return Concatenation( "\"", obj, "\"" );
      fi;
    elif IsInt( obj ) then
      return String( obj );
    elif IsRat( obj ) then
      return String( Float( obj ) );
    elif IsFloat( obj ) then
      return String( obj );
    elif obj = true then
      return "true";
    elif obj = false then
      return "false";
    elif obj = fail then
      return "null";
    elif IsDenseList( obj ) then
      res:= "[";
      if Length( obj ) = 0 then
        Add( res, ']' );
      else
        for subobj in obj do
          next:= AGR.JsonText( subobj, mode );
          if next = fail then
            return fail;
          fi;
          Append( res, next );
          Add( res, ',' );
        od;
        res[ Length( res ) ]:= ']';
      fi;
    elif IsRecord( obj ) then
      res:= "{";
      names:= RecNames( obj );
      if Length( names ) = 0 then
        Add( res, '}' );
      else
        for nam in names do
          next:= AGR.JsonText( nam, mode );
          if next = fail then
            return fail;
          fi;
          Append( res, next );
          Append( res, ":" );
          next:= AGR.JsonText( obj.( nam ), mode );
          if next = fail then
            return fail;
          fi;
          Append( res, next );
          Add( res, ',' );
        od;
        res[ Length( res ) ]:= '}';
      fi;
    else
      return fail;
    fi;

    return res;
end;


#############################################################################
##
#F  AGR.GapObjectOfJsonText( <string> )
##
##  <#GAPDoc Label="AGR.GapObjectOfJsonText">
##  <ManSection>
##  <Func Name="AGR.GapObjectOfJsonText" Arg='string'/>
##
##  <Returns>
##  a new mutable record whose <C>value</C> component, if bound,
##  contains a mutable &GAP; object that represents the JSON text
##  <A>string</A>.
##  </Returns>
##  <Description>
##  If <A>string</A> is a string that represents a JSON text
##  then the result is a record with the components <C>value</C>
##  (the corresponding &GAP; object in the sense of the above interface) and
##  <C>status</C> (value <K>true</K>).
##  Otherwise, the result is a record with the components
##  <C>status</C> (value <K>false</K>) and <C>errpos</C> (the position in
##  <A>string</A> where the string turns out to be not valid JSON).
##  <P/>
##  <Example><![CDATA[
##  gap> AGR.GapObjectOfJsonText( "{ \"a\": 1 }" );
##  rec( status := true, value := rec( a := 1 ) )
##  gap> AGR.GapObjectOfJsonText( "{ \"a\": x }" );
##  rec( errpos := 8, status := false )
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  rules for UTF-8 encoding of unicode code points:
##  0000, ..., 007F in 1 byte,  as 0xxxxxxx (7 bits)
##  0080, ..., 07FF in 2 bytes, as 110xxxxx 10xxxxxx (5+6 bits)
##  0800, ..., FFFF in 3 bytes, as 1110xxxx 10xxxxxx 10xxxxxx (4+6+6 bits)
##  10000, ..., 10FFFF in 4 bytes, as 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
##  (3+6+6+6 bits)
##
##  For example, U+0070 is encoded by 70, and U+0080 by C2 80.
##  Not all such sequences of bytes represent code points,
##  for example 0800 is binary 00001000 00000000,
##  which is encoded as 11100000 10100000 10000000.
##
AGR.GapObjectOfJsonText:= function( string )
    local len, whitespace, res, pos, expectstringor\}, expectstring,
          SIGNEDCHARSDIGITS, HEXCHARS, c, val, i, pos2, hex, high, low,
          number, dpos, pos3, pos4, pos5, expsign, exp, new, pair;

    if not IsString( string ) then
      Error( "<string> must be a nonempty string" );
    fi;
    len:= Length( string );
    if len = 0 then
      Error( "<string> must be a nonempty string" );
    fi;

    # Whitespace is defined as sequence of the HEX characters 09, 0A, 0D, 20.
    whitespace:= "\t\n\r ";

    res:= rec( type:= "unknown" );
    pos:= 1;
    expectstringor\}:= false;
    expectstring:= false;
    SIGNEDCHARSDIGITS:= "-0123456789";
    IsSSortedList( SIGNEDCHARSDIGITS );  # store that this is strictly sorted
    HEXCHARS:= "0123456789ABCDEFabcdef";
    IsSSortedList( HEXCHARS );  # store that this is strictly sorted

    while pos <= len do
      c:= string[ pos ];
      if c in whitespace then
        # Ignore whitespace.
        pos:= pos + 1;
      elif c = '\"' then
        # A string follows.
        # Rewrite the substrings \b, \f, \n, \r, \t, \\, \/,
        # and interpret \uXXXX.
        val:= "";
        i:= pos + 1;
        while i <= len do
          c:= string[i];
          if c = '\"' then
            # The string is complete.
            pos2:= i;
            break;
          elif c = '\\' then
            # Deal with a special character.
            if i = len then
              return rec( status:= false, errpos:= pos );
            fi;
            i:= i+1;
            c:= string[i];
            if   c in "\\\"/" then
              Add( val, c );
            elif c = 't' then
              Add( val, '\t' );
            elif c = 'r' then
              Add( val, '\r' );
            elif c = 'n' then
              Add( val, '\n' );
            elif c = 'b' then
              Add( val, '\b' );
            elif c = 'f' then
              Add( val, '\014' );
            elif c = 'u' then
              # Add the encoding of a unicode code point.
              if len < i + 4 then
                return rec( status:= false, errpos:= pos );
              fi;
              hex:= string{ [ i+1 .. i+4 ] };
              if not IsSubset( HEXCHARS, hex ) then
                return rec( status:= false, errpos:= pos );
              elif hex[1] in "Dd" then
                if hex[2] in "CDEFcdef" then
                  # \uDC00 to \uDFFF must occur only as the second half
                  # of a UTF-16 surrogate pair.
                  return rec( status:= false, errpos:= pos );
                elif hex[2] in "89ABab" then
                  # This is the first half of a UTF-16 surrogate pair.
                  high:= IntHexString( hex ) - 55296;
                  if len < i + 10 or string{ [ i+5, i+6 ] } <> "\\u" then
                    return rec( status:= false, errpos:= pos );
                  fi;
                  hex:= string{ [ i+7 .. i+10 ] };
                  if not ( IsSubset( HEXCHARS, hex )
                           and hex[1] in "Dd" and hex[2] in "CDEFcdef" ) then
                    return rec( status:= false, errpos:= pos );
                  fi;
                  low:= IntHexString( hex ) - 56320;
                  # Use an undocumented GAPDoc function.
                  Append( val, UNICODE_RECODE.UTF8UnicodeChar(
                                 1024 * high + low + 65536 ) );
                  i:= i + 10;
                else
                  # Use an undocumented GAPDoc function.
                  Append( val, UNICODE_RECODE.UTF8UnicodeChar(
                                 IntHexString( hex ) ) );
                  i:= i + 4;
                fi;
              else
                # Use an undocumented GAPDoc function.
                Append( val, UNICODE_RECODE.UTF8UnicodeChar(
                               IntHexString( hex ) ) );
                i:= i + 4;
              fi;
            else
              return rec( status:= false, errpos:= pos );
            fi;
          elif IntChar( c ) <= 31 then
            return rec( status:= false, errpos:= pos );
          else
            Add( val, c );
          fi;
          i:= i + 1;
        od;
        if len < i then
          return rec( status:= false, errpos:= pos );
        fi;
        res.type:= "string";
        res.value:= val;
        expectstringor\}:= false;
        expectstring:= false;
        pos:= pos2 + 1;
      elif expectstring or ( expectstringor\} and c <> '}' ) then
        # We had just opened an object, or had just read a ',' in an object.
        return rec( status:= false, errpos:= pos );
      elif c in SIGNEDCHARSDIGITS then
        # A number follows.
        res.type:= "number";
        pos2:= pos + 1;
        if c = '-' then
          number:= 0;
        else
          number:= POS_LIST_DEFAULT( CHARS_DIGITS, c, 0 ) - 1;
        fi;
        while pos2 <= len do
          dpos:= POS_LIST_DEFAULT( CHARS_DIGITS, string[ pos2 ], 0 );
          if dpos = fail then
            break;
          fi;
          number:= 10 * number + dpos - 1;
          pos2:= pos2 + 1;
        od;
        if ( c = '-' and ( pos2 = pos + 1 or ( pos + 2 < pos2 and
             string[ pos + 1 ] = '0' ) ) ) or
           ( c = '0' and pos + 1 < pos2 ) then
          return rec( status:= false, errpos:= pos );
        elif len < pos2 then
          # end of the string
          if c = '-' then
            number:= - number;
          fi;
          res.value:= number;
          pos:= pos2;
        elif string[ pos2 ] = '.' then
          # A fractional part follows, we will create a float.
          pos3:= pos2 + 1;
          while pos3 <= len and string[ pos3 ] in CHARS_DIGITS do
            pos3:= pos3 + 1;
          od;
          if pos3 = pos2 + 1 then
            return rec( status:= false, errpos:= pos2 );
          elif len < pos3 then
            res.value:= Float( string{ [ pos .. pos3 - 1 ] } );
            pos:= pos3;
          elif string[ pos3 ] in "eE" then
            # An exponent follows after the fractional part:
            # [ pos .. pos2 - 1 ] is the integer part,
            # [ pos2 + 1 .. pos3 - 1 ] is the fractional part,
            # [ pos4 .. pos5 - 1 ] is the exponent, including the sign.
            pos4:= pos3;
            if len = pos4 then
              return rec( status:= false, errpos:= pos3 );
            elif string[ pos4 + 1 ] = '+' then
              pos4:= pos4 + 1;
            elif string[ pos4 + 1 ] = '-' then
              pos4:= pos4 + 1;
            fi;
            pos5:= pos4 + 1;
            while pos5 <= len and string[ pos5 ] in CHARS_DIGITS do
              pos5:= pos5 + 1;
            od;
            if pos4 + 1 = pos5 then
              return rec( status:= false, errpos:= pos3 );
            fi;
            res.value:= Float( string{ [ pos .. pos5 - 1 ] } );
            pos:= pos5;
          else
            # There is no exponent.
            res.value:= Float( string{ [ pos .. pos3 - 1 ] } );
            pos:= pos3;
          fi;
        elif string[ pos2 ] in "eE" then
          # An integer followed by an exponent (perhaps create an integer).
          # [ pos .. pos2-1 ] is the integer part,
          # [ pos3+1 .. pos4 - 1 ] is the abs. value of the exponent,
          # expsign det. the sign
          pos3:= pos2;
          expsign:= false;
          if len = pos3 then
            return rec( status:= false, errpos:= pos2 );
          elif string[ pos3 + 1 ] = '+' then
            pos3:= pos3 + 1;
          elif string[ pos3 + 1 ] = '-' then
            pos3:= pos3 + 1;
            expsign:= true;
          fi;
          pos4:= pos3 + 1;
          while pos4 <= len and string[ pos4 ] in CHARS_DIGITS do
            pos4:= pos4 + 1;
          od;
          if pos3 + 1 = pos4 then
            return rec( status:= false, errpos:= pos3 );
          elif expsign then
            # We create a float.
            res.value:= Float( string{ [ pos .. pos4 - 1 ] } );
          else
            # We create an integer.
            exp:= 0;
            for i in [ pos3 + 1 .. pos4 - 1 ] do
              dpos:= POSITION_SORTED_LIST( CHARS_DIGITS, string[i] );
              exp:= 10 * exp + dpos - 1;
            od;
            if c = '-' then
              number:= - number;
            fi;
            res.value:= number * 10 ^ exp;
          fi;
          pos:= pos4;
        else
          # The number is an integer.
          if c = '-' then
            number:= - number;
          fi;
          res.value:= number;
          pos:= pos2;
        fi;
      elif c = '[' then
        # An array follows.
        res.type:= "list";
        new:= rec( type:= "unknown", parent:= res );
        res.entries:= [ new ];
        res.nrentries:= 1;
        res:= new;
        pos:= pos + 1;
      elif c = '{' then
        # An object follows.
        res.type:= "record";
        expectstringor\}:= true;
        new:= rec( type:= "string", parent:= res );
        res.pairs:= [ [ new ] ];
        res.nrpairs:= 1;
        res.lenlastpair:= 1;
        res:= new;
        pos:= pos + 1;
      elif c = '}' then
        # If we are processing an object then it is closed now.
        if not IsBound( res.parent ) then
          return rec( status:= false, errpos:= pos );
        fi;
        expectstringor\}:= false;
        res:= res.parent;
        if res.type <> "record" then
          return rec( status:= false, errpos:= pos );
        elif res.nrpairs = 1 and res.lenlastpair = 1
                             and not IsBound( res.pairs[1][1].value ) then
          # The record is empty.
          res.value:= rec();
        elif res.lenlastpair = 1 then
          return rec( status:= false, errpos:= pos );
        else
          res.value:= rec();
          for pair in res.pairs do
            res.value.( pair[1].value ):= pair[2].value;
          od;
        fi;
        pos:= pos + 1;
      elif c = ']' then
        # If we are processing a list then it is closed now.
        if not IsBound( res.parent ) then
          return rec( status:= false, errpos:= pos );
        fi;
        res:= res.parent;
        if res.type <> "list" then
          return rec( status:= false, errpos:= pos );
        elif res.nrentries = 1 and res.entries[1].type= "unknown" then
          # The list is empty.
          res.value:= [];
        elif res.entries[ res.nrentries ].type= "unknown" then
          return rec( status:= false, errpos:= pos );
        else
          res.value:= List( res.entries, x -> x.value );
        fi;
        pos:= pos + 1;
      elif c = ',' then
        # If we process an object or array then the next entry follows.
        if not IsBound( res.parent ) or not IsBound( res.value ) then
          return rec( status:= false, errpos:= pos );
        fi;
        res:= res.parent;
        if res.type = "list" then
          # We have processed a value.
          res.nrentries:= res.nrentries + 1;
          new:= rec( type:= "unknown", parent:= res );
          res.entries[ res.nrentries ]:= new;
          res:= new;
        elif res.type = "record" and res.lenlastpair = 2 then
          # We have processed both a label and a value.
          expectstring:= true;
          res.nrpairs:= res.nrpairs + 1;
          new:= rec( type:= "string", parent:= res );
          res.pairs[ res.nrpairs ]:= [ new ];
          res.lenlastpair:= 1;
          res:= new;
        else
          return rec( status:= false, errpos:= pos );
        fi;
        pos:= pos + 1;
      elif c = ':' then
        # In an object, this character separates labels and values.
        if res.type <> "string" then
          return rec( status:= false, errpos:= pos );
        fi;
        res:= res.parent;
        if res.type <> "record" or res.lenlastpair <> 1 then
          return rec( status:= false, errpos:= pos );
        fi;
        # We have just processed a label.
        new:= rec( type:= "unknown", parent:= res );
        res.pairs[ res.nrpairs ][2]:= new;
        res.lenlastpair:= 2;
        res:= new;
        pos:= pos + 1;
      elif c = 't' then
        # true follows.
        if len < pos + 3 or string{ [ pos .. pos + 3 ] } <> "true" then
          return rec( status:= false, errpos:= pos );
        fi;
        res.type:= "constant";
        res.value:= true;
        pos:= pos + 4;
      elif c = 'f' then
        # false follows.
        if len < pos + 4 or string{ [ pos .. pos + 4 ] } <> "false" then
          return rec( status:= false, errpos:= pos );
        fi;
        res.type:= "constant";
        res.value:= false;
        pos:= pos + 5;
      elif c = 'n' then
        # null follows.
        if len < pos + 3 or string{ [ pos .. pos + 3 ] } <> "null" then
          return rec( status:= false, errpos:= pos );
        fi;
        res.type:= "constant";
        res.value:= fail;
        pos:= pos + 4;
      else
        return rec( status:= false, errpos:= pos );
      fi;
    od;

    if not IsBound( res.value ) or IsBound( res.parent) then
      return rec( status:= false, errpos:= pos );
    fi;

    return rec( value:= res.value, status:= true );
end;


#############################################################################
##
#E

