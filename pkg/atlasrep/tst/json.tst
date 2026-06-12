#############################################################################
##
#W  json.tst             GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains a few basic tests for the JSON interface.
##
##  In order to run the tests, one starts GAP from the 'tst' subdirectory
##  of the 'pkg/atlasrep' directory, and calls 'Test( "json.tst" );'.
##

gap> START_TEST( "json.tst" );

# Load the package.
gap> LoadPackage( "atlasrep" );
true

# The following GAP objects have no JSON equivalent.
gap> notconvertible:= [ (1,2), Z(2), E(7), Group( () ), [ , 1 ] ];;
gap> ForAll( notconvertible, x -> AGR.JsonText( x ) = fail );
true
gap> ForAll( notconvertible, x -> AGR.JsonText( x, "ASCII" ) = fail );
true
gap> AGR.JsonText( "\"\200\"", "ASCII" );
fail

# The following strings are not valid JSON.
gap> invalid:= [ "-", "- 1", "-.", "-.2", "1.", "01",
>      "e", "1e", "1e+", "1e-",
>      "\"\n\"", "\"\\uXXXX\"", "\"\\uD800\"", "\"\\uDC00\"",
>      "\"\\uDC00\\uD800\"",
>      "]", "[,1]", "[1,]", "[1",
>      "}", "{[]}", "{,\"a\":0}", "{\"a\":0,}", "{\"a\":0},", "{\"a\":0" ];;
gap> ForAll( invalid, x -> AGR.GapObjectOfJsonText( x ).status = false );
true

# Convert constants.
gap> gapconstants:= [ true, false, fail ];;
gap> jsonconstants:= List( gapconstants, AGR.JsonText );
[ "true", "false", "null" ]
gap> jsonconstants = List( gapconstants, x -> AGR.JsonText( x, "ASCII" ) );
true
gap> gapconstants = List( jsonconstants,
>                         x -> AGR.GapObjectOfJsonText( x ).value );
true

# Convert strings.
gap> gapstrings:= List( [ 0 .. 1000 ],
>                       i -> Encode( Unicode( [ i ] ), "UTF-8" ) );;
gap> jsonstrings:= List( gapstrings, AGR.JsonText );;
gap> jsonstringsascii:= List( gapstrings, x -> AGR.JsonText( x, "ASCII" ) );;
gap> Filtered( [ 1 .. Length( gapstrings ) ],
>              i ->  jsonstrings[i] = jsonstringsascii[i] ) = [ 1 .. 128 ];
true
gap> gapstrings = List( jsonstrings,
>                       x -> AGR.GapObjectOfJsonText( x ).value );
true
gap> gapstrings = List( jsonstringsascii,
>                       x -> AGR.GapObjectOfJsonText( x ).value );
true
gap> List( [ "\"\"" ],
>          x -> AGR.GapObjectOfJsonText( x ).value );
[ "" ]
gap> AGR.JsonText( "" );
"\"\""
gap> gapstrings:= List( [ "ABCD", "FFFF", "10000", "10ABCD", "10FFFF" ],
>                       x -> Encode( Unicode( Concatenation( "&#x", x, ";" ),
>                                             "XML" ), "UTF-8" ) );;
gap> jsonstrings:= List( gapstrings, x -> AGR.JsonText( x, "ASCII" ) );
[ "\"\\uABCD\"", "\"\\uFFFF\"", "\"\\uD800\\uDC00\"", "\"\\uDBEA\\uDFCD\"", 
  "\"\\uDBFF\\uDFFF\"" ]
gap> gapstrings = List( jsonstrings,
>                       x -> AGR.GapObjectOfJsonText( x ).value );
true

# Convert numbers.  (Leading zeros in exponents are allowed.)
gap> gapnumbers:= [ 0, 1, -1, 1.7, -1.35 ];;
gap> jsonnumbers:= List( gapnumbers, AGR.JsonText );
[ "0", "1", "-1", "1.7", "-1.3500000000000001" ]
gap> jsonnumbers = List( gapnumbers, x -> AGR.JsonText( x, "ASCII" ) );
true
gap> gapnumbers = List( jsonnumbers,
>                       x -> AGR.GapObjectOfJsonText( x ).value );
true
gap> List( [ "0", "-0", "10e1", "10E1", "10e+1", "10E+1", "10e-1", "10E-1",
>            "10.4e1", "10.4e-1", "10e01", "10e0" ],
>          x -> AGR.GapObjectOfJsonText( x ).value );
[ 0, 0, 100, 100, 100, 100, 1., 1., 104., 1.04, 100, 10 ]
gap> AGR.GapObjectOfJsonText( AGR.JsonText( 1/2 ) ).value;
0.5
gap> AGR.GapObjectOfJsonText( AGR.JsonText( 1/2, "ASCII" ) ).value;
0.5

# Convert arrays/lists.
gap> AGR.JsonText( [] );
"[]"
gap> AGR.JsonText( [], "ASCII" );
"[]"
gap> AGR.JsonText( gapnumbers );
"[0,1,-1,1.7,-1.3500000000000001]"
gap> AGR.JsonText( gapnumbers, "ASCII" );
"[0,1,-1,1.7,-1.3500000000000001]"

# Convert objects/records.
gap> AGR.JsonText( rec() );
"{}"
gap> AGR.JsonText( rec(), "ASCII" );
"{}"
gap> AGR.JsonText( rec( a:= [] ) );
"{\"a\":[]}"
gap> AGR.JsonText( rec( a:= [] ), "ASCII" );
"{\"a\":[]}"
gap> r:= AGR.GapObjectOfJsonText( "{\"\":0}" );
rec( status := true, value := rec( ("") := 0 ) )
gap> r.value.( "" );
0
gap> nam:= Encode( Unicode( "&#246;", "XML"), "UTF-8" );;
gap> r:= rec();;  r.( nam ):= 0;;  r.( "\005" ):= 1;;
gap> json:= AGR.JsonText( r );;
gap> jsonascii:= AGR.JsonText( r, "ASCII" );
"{\"\\u00F6\":0,\"\\u0005\":1}"
gap> AGR.GapObjectOfJsonText( json ).value = r;
true
gap> AGR.GapObjectOfJsonText( jsonascii ).value = r;
true

# Convert nested structures.
gap> l:= [];;  ll:= l;;
gap> for i in [ 1 .. 100 ] do
>      ll[1]:= [];
>      ll:= ll[1];
>    od;
gap> json:= AGR.JsonText( l );;
gap> json = AGR.JsonText( l, "ASCII" );
true
gap> AGR.GapObjectOfJsonText( json ).value = l;
true
gap> r:= rec();;  rr:= r;;
gap> for i in [ 1 .. 100 ] do
>      nam:= Concatenation( "a", String( i ) );
>      rr.( nam ):= rec();
>      rr:= rr.( nam );
>    od;
gap> json:= AGR.JsonText( r );;
gap> json = AGR.JsonText( r, "ASCII" );
true
gap> AGR.GapObjectOfJsonText( json ).value = r;
true

# Done.
gap> STOP_TEST( "json.tst" );


#############################################################################
##
#E

