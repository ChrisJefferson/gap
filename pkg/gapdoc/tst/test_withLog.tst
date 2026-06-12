# This file was created automatically, do not edit!
#############################################################################
##
#W  test_withLog.tst        GAP 4 package GAPDoc                Frank Lübeck
##
#Y  Copyright (C) 2022,  Lehrstuhl f. Alg. u. Zahlenth., RWTH Aachen, Germany
##
##  This file contains the GAP code of the examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the `tst' subdirectory
##  of the `pkg/GAPDoc' directory, and calls `Test( "test.tst" );'.
##  
gap> LoadPackage( "GAPDoc", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "Input file: test_withLog.tst" );

##
gap> oldinterval:= BrowseData.defaults.dynamic.replayDefaults.replayInterval;;
gap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= 1;;

##  doc/../lib/ComposeXML.gi (294-301)
gap> FilenameGAP("hsdkfhs.g");
fail
gap> FilenameGAP("lib/system.g");
"/usr/local/gap4/lib/system.g"
gap> FilenameGAP("gap://lib/system.g");
"/usr/local/gap4/lib/system.g"

##  doc/../lib/XMLParser.gi (1147-1156)
gap> fn := Filename(DirectoriesPackageLibrary("gapdoc", ""), 
>                                             "3k+1/3k+1.xml");;
gap> doc := ComposedDocument("GAPDoc", "", fn, [], true);;
gap> doc[1][220] := 't';;
gap> check := ValidateGAPDoc(doc);;
ValidateGAPDoc found problems:
Line 11:  parser error : Opening and ending tag mismatch
   source position: /opt/gap/pkg/GAPDoc-1.6.4/3k+1/3k+1.xml, line 11

##  doc/../lib/GAPDoc2Text.gi (118-123)
gap> # use no colors for GAP examples and 
gap> # change display of headings to bold green
gap> SetGAPDocTextTheme("noColorPrompt", 
>            rec(Heading:=Concatenation(TextAttr.bold, TextAttr.2)));

##  doc/../lib/HelpBookHandler.g (123-127)
gap> # show/hide subsections in tables on contents only after click,
gap> # and don't use colors in GAP examples
gap> SetGAPDocHTMLStyle("toggless", "nocolorprompt");

##  doc/../lib/Text.gi (608-616)
gap> str := Concatenation("XXX",TextAttr.2, "BLUB", TextAttr.reset,"YYY");
"XXX\033[32mBLUB\033[0mYYY"
gap> str2 := WrapTextAttribute(str, TextAttr.1);
"\033[31mXXX\033[32mBLUB\033[0m\033[31m\027YYY\033[0m"
gap> str3 := WrapTextAttribute(str, TextAttr.underscore);
"\033[4mXXX\033[32mBLUB\033[0m\033[4m\027YYY\033[0m"
gap> # use Print(str); and so on to see how it looks like.

##  doc/../lib/Text.gi (679-685)
gap> str := "One two three four five six seven eight nine ten eleven.";;
gap> Print(FormatParagraph(str, 25, "left", ["/* ", " */"]));           
/* One two three four five */
/* six seven eight nine ten */
/* eleven. */

##  doc/../lib/Text.gi (355-358)
gap> SubstitutionSublist("xababx", "ab", "a");
"xaax"

##  doc/../lib/Text.gi (546-549)
gap> StripBeginEnd(" ,a, b,c,   ", ", ");
"a, b,c"

##  doc/../lib/Text.gi (193-205)
gap> RepeatedString('=',51);
"==================================================="
gap> RepeatedString("*=",51);
"*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*"
gap> s := "bäh";;
gap> enc := GAPInfo.TermEncoding;;
gap> if enc <> "UTF-8" then s := Encode(Unicode(s, enc), "UTF-8"); fi;
gap> l := RepeatedUTF8String(s, 8);;
gap> u := Unicode(l, "UTF-8");;
gap> Print(Encode(u, enc), "\n");
bähbähbä

##  doc/../lib/Text.gi (414-419)
gap> NumberDigits("1A3F",16);
6719
gap> DigitsNumber(6719, 16);
"1A3F"

##  doc/../lib/Text.gi (475-488)
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"Decimal","","."));
[ "1.", "2.", "3.", "4.", "5.", "691." ]
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"alpha","(",")"));
[ "(a)", "(b)", "(c)", "(d)", "(e)", "(zo)" ]
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"alpha","(",")"));
[ "(a)", "(b)", "(c)", "(d)", "(e)", "(zo)" ]
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"Alpha","",".)"));
[ "A.)", "B.)", "C.)", "D.)", "E.)", "ZO.)" ]
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"roman","","."));
[ "i.", "ii.", "iii.", "iv.", "v.", "dcxci." ]
gap> List([1,2,3,4,5,691], i-> LabelInt(i,"Roman","",""));
[ "I", "II", "III", "IV", "V", "DCXCI" ]

##  doc/../lib/Text.gi (301-308)
gap> PositionMatchingDelimiter("{}x{ab{c}d}", "{}", 0);
fail
gap> PositionMatchingDelimiter("{}x{ab{c}d}", "{}", 1);
2
gap> PositionMatchingDelimiter("{}x{ab{c}d}", "{}", 6);
11

##  doc/../lib/Text.gi (1127-1130)
gap> WordsString("one_two \n    three!?");
[ "one", "two", "three" ]

##  doc/../lib/Text.gi (1175-1180)
gap> b := Base64String("This is a secret!");
"VGhpcyBpcyBhIHNlY3JldCEA="
gap> StringBase64(b);                       
"This is a secret!"

##  doc/../lib/UnicodeTools.gi (529-538)
gap> ustr := Unicode("a and \366", "latin1");
Unicode("a and ö")
gap> ustr = Unicode("a and &#246;", "XML");  
true
gap> IntListUnicodeString(ustr);
[ 97, 32, 97, 110, 100, 32, 246 ]
gap> ustr[7];
'ö'

##  doc/../lib/UnicodeTools.gi (759-769)
gap> ustr := Unicode("a and &#246;", "XML");
Unicode("a and ö")
gap> SimplifiedUnicodeString(ustr, "ASCII");
Unicode("a and oe")
gap> SimplifiedUnicodeString(ustr, "ASCII", "single");
Unicode("a and o")
gap> ustr2 := UppercaseUnicodeString(ustr);;
gap> Print(Encode(ustr2, GAPInfo.TermEncoding), "\n");
A AND Ö

##  doc/../lib/UnicodeTools.gi (1102-1115)
gap> # A, German umlaut u, B, zero width space, C, newline
gap> str := Encode( Unicode( "A&#xFC;B&#x200B;C\n", "XML" ) );;
gap> Print(str);
AüB​C
gap> # umlaut u needs two bytes and the zero width space three
gap> Length(str);
9
gap> NrCharsUTF8String(str);
6
gap> # zero width space and newline don't contribute to width
gap> WidthUTF8String(str);
4

##  doc/../lib/UnicodeTools.gi (1171-1183)
gap> # A, German umlaut u, B, zero width space, C, newline
gap> str := Encode( Unicode( "A&#xFC;B&#x200B;C\n", "XML" ) );;
gap> ini := InitialSubstringUTF8String(str, 3);;
gap> WidthUTF8String(ini);
3
gap> IntListUnicodeString(Unicode(ini));
[ 65, 252, 66, 8203 ]
gap> l := Unicode([ 23380, 22827, 23376 ] );; # three chars of width 2
gap> s := InitialSubstringUTF8String(l, 4, "*");;
gap> WidthUTF8String(s);
3

##  doc/../lib/PrintUtil.gi (37-41)
gap> f := function() local i; 
>   for i in [1..100000] do Print(i, "\n"); od; end;; 
gap> PrintTo1("nonsense", f); # now check the local file `nonsense'

##  doc/../lib/PrintUtil.gi (150-153)
gap> Page([1..1421]+0);
gap> PageDisplay(CharacterTable("Symmetric", 14));

##  doc/../lib/BibTeX.gi (252-260)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "test.bib");;
gap> bib := ParseBibFiles(f);
[ [ rec( From := rec( BibTeX := true ), Label := "AB2000", 
          Type := "article", author := "Fritz A. First and Sec, X. Y."
            , journal := "Important Journal", title := "Short", 
          year := "2000" ) ], [ "j" ], [ "Important Journal" ] ]

##  doc/../lib/BibTeX.gi (427-441)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "test.bib");;
gap> bib := ParseBibFiles(f);;
gap> NormalizedNameAndKey(bib[1][1].author);
[ "First, F. A. and Sec, X. Y.", "FS", "firstsec", 
  [ [ "First", "F. A.", "Fritz A." ], [ "Sec", "X. Y.", "X. Y." ] ] ]
gap> NormalizeNameAndKey(bib[1][1]);
gap> bib[1][1];
rec( From := rec( BibTeX := true ), Label := "AB2000", 
  Type := "article", author := "First, F. A. and Sec, X. Y.", 
  authororig := "Fritz A. First and Sec, X. Y.", 
  journal := "Important Journal", keylong := "firstsec2000", 
  printedkey := "FS00", title := "Short", year := "2000" )

##  doc/../lib/BibTeX.gi (611-613)
gap> WriteBibFile("nicer.bib", bib);

##  doc/../lib/BibTeX.gi (1574-1578)
gap> f := Filename(DirectoriesPackageLibrary("gapdoc","doc"), "test.bib");;
gap> LabelsFromBibTeX(".", ["AB2000"], [f], "alpha");
[ [ "AB2000", "FS00" ] ]

##  doc/../lib/BibXMLextTools.gi (326-332)
gap> s := "\\\"u\\'{e}\\`e{\\ss}";;
gap> Print(s, "\n");               
\"u\'{e}\`e{\ss}
gap> Print(HeuristicTranslationsLaTeX2XML.Apply(s),"\n");
üéèß

##  doc/../lib/BibXMLextTools.gi (372-387)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "test.bib");;
gap> bib := ParseBibFiles(f);;
gap> str := StringBibAsXMLext(bib[1][1], bib[2], bib[3]);;
gap> Print(str, "\n");
<entry id="AB2000"><article>
  <author>
    <name><first>Fritz A.</first><last>First</last></name>
    <name><first>X. Y.</first><last>Sec</last></name>
  </author>  
  <title>Short</title>
  <journal><value key="j"/></journal>
  <year>2000</year>
</article></entry>

##  doc/../lib/BibXMLextTools.gi (210-222)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "testbib.xml");;
gap> bib := ParseBibXMLextFiles(f);;
gap> Set(RecNames(bib));
[ "entities", "entries", "strings" ]
gap> bib.entries;
[ <BibXMLext entry: AB2000> ]
gap> bib.strings;
[ [ "j", "Important Journal" ] ]
gap> bib.entities[1]; 
[ "amp", "&#38;#38;" ]

##  doc/../lib/BibXMLextTools.gi (975-980)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "testbib.xml");;
gap> bib := ParseBibXMLextFiles(f);;
gap> WriteBibXMLextFile("test.xml", bib);

##  doc/../lib/BibXMLextTools.gi (1097-1130)
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "testbib.xml");;
gap> bib := ParseBibXMLextFiles(f);;
gap> e := bib.entries[1];; strs := bib.strings;;
gap> Print(RecBibXMLEntry(e, "BibTeX", strs), "\n");
rec(
  From := rec(
      BibXML := true,
      options := rec(
           ),
      type := "BibTeX" ),
  Label := "AB2000",
  Type := "article",
  author := "First, F. A. and Sec{\\H o}nd, X. Y.",
  authorAsList := 
   [ [ "First", "F. A.", "Fritz A." ], 
      [ "Sec\305\221nd", "X. Y.", "X. Y." ] ],
  journal := "Important Journal",
  mycomment := "very useful",
  note := 
   "Online data at \\href {http://www.publish.com/~ImpJ/123#data} {Bla\
 Bla Publisher}",
  number := "13",
  pages := "13{\\textendash}25",
  printedkey := "FS00",
  title := 
   "The  {F}ritz package for the \n         formula $x^y - l_{{i+1}} \
\\rightarrow \\mathbb{R}$",
  year := "2000" )
gap> Print(RecBibXMLEntry(e, "HTML", strs).note, "\n");
Online data at <a href="http://www.publish.com/~ImpJ/123#data">Bla Bla\
 Publisher</a>

##  doc/../lib/BibXMLextTools.gi (1184-1198)
gap> AddHandlerBuildRecBibXMLEntry("Wrap:Package", "BibTeX",
> function(entry,  r, restype,  strings, options)
>   return Concatenation("\\textsf{", ContentBuildRecBibXMLEntry(
>             entry, r, restype,  strings, options), "}");
> end);
gap> 
gap> Print(RecBibXMLEntry(e, "BibTeX", strs).title, "\n");
The \textsf{ {F}ritz} package for the 
         formula $x^y - l_{{i+1}} \rightarrow \mathbb{R}$
gap> Print(RecBibXMLEntry(e, "Text", strs).title, "\n");  
The  Fritz package for the 
         formula x^y - l_{i+1} → R
gap> AddHandlerBuildRecBibXMLEntry("Wrap:Package", "BibTeX", "Ignore");

##  doc/../lib/BibXMLextTools.gi (1795-1842)   edited for readability 
gap> gddirs := DirectoriesPackageLibrary("gapdoc","doc");;
gap> f := Filename(gddirs, "testbib.xml");;
gap> bib := ParseBibXMLextFiles(f);;
gap> e := bib.entries[1];; strs := bib.strings;;
gap> ebib := StringBibXMLEntry(e, "BibTeX", strs);;
gap> PrintFormattedString(ebib);
@article{ AB2000,
  author =           {First, F. A. and Sec{\H o}nd, X. Y.},
  title =            {The  {F}ritz  package  for  the formula $x^y -
                      l_{{i+1}} \rightarrow \mathbb{R}$},
  journal =          {Important Journal},
  number =           {13},
  year =             {2000},
  pages =            {13{\textendash}25},
  note =             {Online          data          at         \href
                      {http://www.publish.com/~ImpJ/123#data}   {Bla
                      Bla Publisher}},
  mycomment =        {very useful},
  printedkey =       {FS00}
}
gap> etxt := StringBibXMLEntry(e, "Text", strs);;      
gap> etxt := SimplifiedUnicodeString(Unicode(etxt), "latin1", "single");;
gap> etxt := Encode(etxt, GAPInfo.TermEncoding);;                        
gap> PrintFormattedString(etxt);
[FS00]  First,  F.  A.  and Second, X. Y., The Fritz package for the
formula  x^y  -  l_{i+1}  ?  R, Important Journal, 13 (2000), 13-25,
(Online        data        at        Bla        Bla        Publisher
(http://www.publish.com/~ImpJ/123#data)).

gap> ehtml := StringBibXMLEntry(e, "HTML", strs, rec(MathJax := true));;
gap> ehtml := Encode(Unicode(ehtml), GAPInfo.TermEncoding);;
gap> PrintFormattedString(ehtml);
<p class='BibEntry'>
[<span class='BibKey'>FS00</span>]   
 <b class='BibAuthor'>First, F. A. and Secőnd, X. Y.</b>,
 <i class='BibTitle'>The  Fritz package for the 
         formula \(x^y - l_{{i+1}} \rightarrow \mathbb{R}\)</i>,
 <span class='BibJournal'>Important Journal</span> 
(<span class='BibNumber'>13</span>)
 (<span class='BibYear'>2000</span>),
 <span class='BibPages'>13–25</span><br />
(<span class='BibNote'>Online data at 
<a href="http://www.publish.com/~ImpJ/123#data">Bla Bla 
Publisher</a></span>).
</p>


##  doc/../lib/BibXMLextTools.gi (61-109)
gap> TemplateBibXML();
[ "article", "book", "booklet", "conference", "inbook", 
  "incollection", "inproceedings", "manual", "mastersthesis", "misc", 
  "phdthesis", "proceedings", "techreport", "unpublished" ]
gap> Print(TemplateBibXML("inbook"));
<entry id="X"><inbook>
  <author>
    <name><first>X</first><last>X</last></name>+
  </author>OR
  <editor>
    <name><first>X</first><last>X</last></name>+
  </editor>
  <title>X</title>
  <chapter>X</chapter>AND/OR
  <pages>X</pages>
  <publisher>X</publisher>
  <year>X</year>
  <volume>X</volume>*OR
  <number>X</number>*
  <series>X</series>*
  <type>X</type>*
  <address>X</address>*
  <edition>X</edition>*
  <month>X</month>*
  <note>X</note>*
  <key>X</key>*
  <annotate>X</annotate>*
  <crossref>X</crossref>*
  <abstract>X</abstract>*
  <affiliation>X</affiliation>*
  <contents>X</contents>*
  <copyright>X</copyright>*
  <isbn>X</isbn>*OR
  <issn>X</issn>*
  <keywords>X</keywords>*
  <language>X</language>*
  <lccn>X</lccn>*
  <location>X</location>*
  <mrnumber>X</mrnumber>*
  <mrclass>X</mrclass>*
  <mrreviewer>X</mrreviewer>*
  <price>X</price>*
  <size>X</size>*
  <url>X</url>*
  <category>X</category>*
  <other type="X">X</other>*+
</inbook></entry>

##  doc/../lib/BibTeX.gi (1379-1403)
gap> ll := SearchMR(rec(Author:="Gauss", Title:="Disquisitiones"));;
gap> ll2 := List(ll, HeuristicTranslationsLaTeX2XML.Apply);;
gap> bib := ParseBibStrings(Concatenation(ll2));;
gap> bibxml := List(bib[1], StringBibAsXMLext);;
gap> bib2 := ParseBibXMLextString(Concatenation(bibxml));;
gap> for b in bib2.entries do 
>          PrintFormattedString(StringBibXMLEntry(b, "Text")); od;     
[Gau95]   Gauss,   C.   F.,  Disquisitiones  arithmeticae,  Academia
Colombiana   de  Ciencias  Exactas,  Físicas  y  Naturales,  Bogotá,
Colección   Enrique   Pérez   Arbeláez   [Enrique   Pérez   Arbeláez
Collection],  10  (1995), xliv+495 pages, (Translated from the Latin
by  Hugo  Barrantes  Campos,  Michael Josephy and Ángel Ruiz Zúñiga,
With a preface by Ruiz Zúñiga).

[Gau86]  Gauss, C. F., Disquisitiones arithmeticae, Springer-Verlag,
New  York  (1986),  xx+472  pages, (Translated and with a preface by
Arthur  A.  Clarke,  Revised  by  William  C.  Waterhouse, Cornelius
Greither and A. W. Grootendorst and with a preface by Waterhouse).

[Gau66]  Gauss,  C. F., Disquisitiones arithmeticae, Yale University
Press, New Haven, Conn.-London, Translated into English by Arthur A.
Clarke, S. J (1966), xx+472 pages.


##
gap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= oldinterval;;
gap> Exec( "rm -f nonsense nicer.bib test.xml");;

##
gap> STOP_TEST( "test_withLog.tst", 10000000 );
gap> SizeScreen( save );;

#############################################################################
##
#E
