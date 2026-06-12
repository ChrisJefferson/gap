## experimental version for creating the two manuals together

##  this creates the documentation (both books of the CTblLib package),
##  needs: GAPDoc package, latex, pdflatex, mkindex, dvips

##  parameters and functions for both books
SetInfoLevel( InfoGAPDoc, 2 );
main:= "main.xml";;
pkgname:= "CTblLib";;
pathtoroot:= "../../..";;
pathtotst:= "tst";
authors:= [ "Thomas Breuer" ];

bibfile:= Filename( DirectoriesLibrary( "doc" ), "manualbib.xml" );
if bibfile = fail then
  Error( "cannot access GAP's current 'manualbib.xml'" );
fi;

# Add BibTeX and HTML handlers for package names in references.
AddHandlerBuildRecBibXMLEntry( "Wrap:Package", "BibTeX",
  function( entry, r, restype, strings, options )
    return Concatenation( "\\textsf{", ContentBuildRecBibXMLEntry(
               entry, r, restype, strings, options ), "}" );
  end );

AddHandlerBuildRecBibXMLEntry( "Wrap:Package", "HTML",
  function( entry, r, restype, strings, options )
    return Concatenation( "<strong class='pkg'>", ContentBuildRecBibXMLEntry(
               entry, r, restype, strings, options ), "</strong>" );
  end );

# Adjust cross-references to packages:
# The name of the subdirectory of 'pkg' in the main GAP root path shall be
# the lowercase package name.
# (In particular, the names shall not involve version numbers.)
# Note that the python script
# 'https://github.com/gap-system/PackageDistro/tools/assemble_distro.py'
# normalizes the names of package directories in this way
# when it creates an archive of all distributed GAP packages.
# If the link points to a different book in the same package then
# create a relative link inside the package, not only relative to the
# GAP root path.

GAPInfo.CurrentPackageName:= LowercaseString( pkgname );

GAPDoc2HTMLProcs.AdjustExtURL_Orig:= GAPDoc2HTMLProcs.AdjustExtURL;

GAPDoc2HTMLProcs.AdjustExtURL := function( r, url )
  local res, pkgpath, self, pos, pos2, prefix, prefixdir, pkgname, suffix;

  res:= GAPDoc2HTMLProcs.AdjustExtURL_Orig( r, url );
  if IsBound( GAPDoc2HTMLProcs.RelPath ) then
    # We want to replace absolute paths in links to other package manuals
    # by relative links.
    pkgpath:= Concatenation( GAPInfo.MainRootPath, "pkg/" );
    self:= GAPInfo.PackagesLoaded.( GAPInfo.CurrentPackageName );
    if StartsWith( res, self[1] ) then
      # The link points to a file inside the same package
      # but in a different book.
      # In this case, we want to create a link relative to the package
      # not only relative to the GAP root directory.
      res:= Concatenation( "../",
                res{ [ Length( self[1] ) + 1 .. Length( res ) ] } );
    elif not StartsWith( res, pkgpath ) then
      # Perhaps the link points to a package outside the main root path.
      # Probably this indicates an error.
      if ForAny( RecNames( GAPInfo.PackagesLoaded ),
                 x -> x <> GAPInfo.CurrentPackageName and
                      StartsWith( res, GAPInfo.PackagesLoaded.( x )[1] ) ) then
        Error( "<url> points to a package outside the main GAP root path:\n",
               "res = '", res, "',\n",
               "pkgpath = '", pkgpath, "'\n",
               "(You should start GAP with the '-r' option.)" );
      fi;
      # Otherwise the link is just kept.
      # Typical examples are links to the GAP Manuals,
      # they will get replaced via the GAPDoc function.
    else
      # The link points to a file in the main GAP root path
      # that belongs to another package.
      # Use 'GAPInfo.PackagesLoaded' for deriving the normalized name of
      # this package from the directory name that occurs in the link.
      pos:= Length( pkgpath );
      pos2:= Position( res, '/', pos );
      prefix:= res{ [ 1 .. pos2-1 ] };
      prefixdir:= Directory( prefix );  # needed since #5178 got merged
      pkgname:= First( RecNames( GAPInfo.PackagesLoaded ),
                       x -> Directory( GAPInfo.PackagesLoaded.( x )[1] )
                            = prefixdir );
      suffix:= res{ [ pos2 .. Length( res ) ] };
      res:= Concatenation( prefix{ [ 1 .. pos ] }, pkgname, suffix );
    fi;
  fi;

  return res;
end;

ExampleFileHeader:= function( filename, pkgname, authors, text, linelen,
                              withbrowse )
    local free1, free2, str, i;

    free1:= Int( ( linelen - Length( pkgname ) - 14 ) / 2 );
    free2:= linelen - free1 - 14 - Length( pkgname ) - Length( authors[1] );

    text:= ReplacedString( text, "PKGNAME", LowercaseString( pkgname ) );
    text:= ReplacedString( text, "FILENAME", filename );
    text:= ReplacedString( text, "\n", "\n##  " );

    str:= RepeatedString( "#", linelen );
    Append( str, "\n##\n#W  " );
    Append( str, filename );
    Append( str, RepeatedString( " ", free1 - Length( filename ) - 4 ) );
    Append( str, "GAP 4 package " );
    Append( str, pkgname );
    Append( str, RepeatedString( " ", free2 ) );
    Append( str, authors[1] );
    for i in [ 2 .. Length( authors ) ] do
      Append( str, "\n#W" );
      Append( str, RepeatedString( " ", linelen - Length( authors[i] ) - 4 ) );
      Append( str, authors[i] );
    od;
    Append( str, "\n##\n##  " );
    Append( str, text );

    Append( str, "\ngap> LoadPackage( \"" );
    Append( str, pkgname );
    Append( str, "\", false );\ntrue" );
    Append( str, "\ngap> save:= SizeScreen();;" );
    Append( str, "\ngap> SizeScreen( [ 72 ] );;" );
    Append( str, "\ngap> START_TEST( \"" );
    Append( str, filename );
    Append( str, "\" );\n" );

    if withbrowse then
      Append( str, "\n##\ngap> if IsBound( BrowseData ) then\n" );
      Append( str, ">      data:= BrowseData.defaults.dynamic.replayDefaults;\n" );
      Append( str, ">      oldinterval:= data.replayInterval;\n" );
      Append( str, ">      data.replayInterval:= 1;\n" );
      Append( str, ">    fi;\n" );
    fi;

    return str;
end;

ExampleFileFooter:= function( filename, linelen, withbrowse )
    local str;

    if withbrowse then
      str:= "\n##\ngap> if IsBound( BrowseData ) then\n";
      Append( str, ">      data:= BrowseData.defaults.dynamic.replayDefaults;\n" );
      Append( str, ">      data.replayInterval:= oldinterval;\n" );
      Append( str, ">    fi;\n" );
    else
      str:= "";
    fi;

    Append( str, "\n##\ngap> STOP_TEST( \"" );
    Append( str, filename );
    Append( str, "\" );\n" );
    Append( str, "gap> SizeScreen( save );;\n\n" );
    Append( str, RepeatedString( "#", linelen ) );
    Append( str, "\n##\n#E\n" );

    return str;
end;


##  Create the test file(s) with examples.
##  If 'tstfilename' equals "chapter-wise" then one file is created for each
##  chapter, with filename <srcname>'.tst' if the contents of the chapter is
##  in <srcname>'.xml'.
##  Otherwise, all examples are collected in the file with name 'tstfilename'.
##
CreateManualExamplesFiles:= function( pkgname, authors, text, path, main,
                                      files, pathtodoc, tstpath, tstfilename,
                                      withbrowse )
    local linelen, xpls, str, pos, pos2, tstfilenames, i, r, l,
          tstfilenameold;

    linelen:= 77;

    xpls:= ExtractExamples( path, main, files, "Chapter" );

    # Distinguish chapter-wise or book-wise test files.
    if tstfilename = "chapter-wise" then
      str:= StringFile( Concatenation( pathtodoc, "/", main ) );
      pos:= PositionSublist( str, "<Body>" );
      pos2:= PositionSublist( str, "</Body>", pos );
      str:= str{ [ pos .. pos2 ] };
      tstfilenames:= [];
      pos:= PositionSublist( str, "<#Include SYSTEM \"" );
      while pos <> fail do
        pos:= pos + 18;
        pos2:= PositionSublist( str, "\"", pos );
        Add( tstfilenames,
             ReplacedString( str{ [ pos .. pos2-1 ] }, ".xml", ".tst" ) );
        pos:= PositionSublist( str, "<#Include SYSTEM \"", pos2 );
      od;
      if Length( xpls ) <> Length( tstfilenames ) then
        Error( "wrong number of chapters?" );
      fi;
    else
      tstfilenames:= [ tstfilename ];
      xpls:= [ Concatenation( xpls ) ];
    fi;

    if not withbrowse then
      xpls:= List( xpls,
                 l -> Filtered( l,
                          x -> PositionSublist( x[1], "Browse" ) = fail and
                               PositionSublist( x[1], "res:= GenProjNotProj" ) = fail ) );
    fi;

    for i in [ 1 .. Length( xpls ) ] do
      str:= "# This file was created automatically, do not edit!\n";
      Append( str, ExampleFileHeader( tstfilenames[i], pkgname, authors,
                                      text, linelen, withbrowse ) );
      for l in xpls[i] do
        Append( str, Concatenation( "\n##  ", l[2][1],
                " (", String( l[2][2] ), "-", String( l[2][3] ), ")" ) );
        Append( str, l[1] );
      od;
      Append( str, ExampleFileFooter( tstfilenames[i], linelen, withbrowse ) );
      tstfilename:= Concatenation( tstpath, "/", tstfilenames[i] );
      tstfilenameold:= Concatenation( tstfilename, "~" );
      if IsExistingFile( tstfilename ) then
        Exec( Concatenation( "rm -f ", tstfilenameold ) );
        Exec( Concatenation( "mv ", tstfilename, " ", tstfilenameold ) );
      fi;
      FileString( tstfilename, str );
      if IsExistingFile( tstfilenameold ) then
        Print( "#I  differences in `", tstfilename, "':\n" );
        Exec( Concatenation( "diff ", tstfilenameold, " ", tstfilename ) );
      fi;
      Exec( Concatenation( "chmod 444 ", tstfilename ) );
    od;
end;

# - Check the consistency of version numbers in 'PackageInfo.g' and the manual.
# - Make sure that the *current* version of the package is loaded
#   when the documentation gets processed.
#   Otherwise the links between the books are wrong.
#   (Cross-references are created w.r.t. matches via the 'HELP' function.)
CheckVersionNumber:= function( pkgname, pathtodoc, main )
    local str, pos, pos2, version1, version2;

    # definition in the manual
    str:= StringFile( Concatenation( pathtodoc, "/", main ) );
    pos:= PositionSublist( str, "<!ENTITY VERSIONNUMBER \"" );
    pos:= Position( str, '\"', pos );
    pos2:= Position( str, '\"', pos );
    version1:= str{ [ pos + 1 .. pos2 - 1 ] };

    # definition in 'PackageInfo.g'
    Read( Concatenation( pathtodoc, "/../PackageInfo.g" ) );
    version2:= GAPInfo.PackageInfoCurrent.Version;

    if version1 <> version2 then
      Error( "version numbers '", version1, "' (from ", main,
             ") and '", version2, "' (from PackageInfo.g) differ" );
    fi;

    # loaded version of the package
    version2:= GAPInfo.PackagesLoaded.ctbllib[2];
    if version1 <> version2 then
      Error( "version numbers '", version1, "' (from ", main,
             ") and '", version2, "' (the loaded version) differ" );
    fi;
end;


#############################################################################
##  Create the book 'CTblLib'

pathtodoc:= "doc";;

CheckVersionNumber( pkgname, pathtodoc, main );

SetGapDocLaTeXOptions( "nocolor", "utf8",
      rec( Maintitlesize := "\\fontsize{36}{38}\\selectfont" ) );

# Extract the book name from the 'main' file.
str:= StringFile( Concatenation( pathtodoc, "/", main ) );;
pos:= PositionSublist( str, "<Book" );;
pos:= PositionSublist( str, "Name=\"", pos );;
pos:= Position( str, '\"', pos );;
pos2:= Position( str, '\"', pos );;
bookname:= str{ [ pos + 1 .. pos2 - 1 ] };;

files:= [
    "../gap4/atlasbro.g",
    "../gap4/atlasimp.g",
    "../gap4/atlasirr.g",
    "../gap4/atlasstr.g",
    "../gap4/brirrat.g",
    "../gap4/brctdiff.g",
    "../gap4/construc.gd",
    "../gap4/ctadmin.gd",
    "../gap4/ctadmin.gi",
    "../gap4/ctblothe.gd",
    "../gap4/ctbltocb.g",
    "../gap4/ctbltoct.g",
    "../gap4/ctdbattr.g",
    "../gap4/test.g",
    "../gap4/tomlib_only.g",
    "../tst/testinst.g",
    "../dlnames/dlnames.gd",
  ];;

# Fetch GAP's current 'manualbib.xml'.
# This way, we avoid creating 'xml.bib' files in other paths.
Exec( Concatenation( "cp ", bibfile, " ", pathtodoc, "/gapmanualbib.xml" ) );

outputstring:= "";;
outputstream:= OutputTextString(outputstring, true);;
SetPrintFormattingStatus(outputstream, false);
SetInfoOutput(InfoGAPDoc, outputstream);
SetInfoOutput(InfoWarning, outputstream);
MakeGAPDocDoc( pathtodoc, main, files, bookname, pathtoroot, "MathJax" );;
CloseStream(outputstream);
UnbindInfoOutput(InfoGAPDoc);
UnbindInfoOutput(InfoWarning);

# Remove GAP's current 'manualbib.xml', and the automatically generated
# 'manualbib.xml.bib'.
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml" ) );
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml.bib" ) );

CopyHTMLStyleFiles( pathtodoc );

GAPDocManualLabFromSixFile( bookname,
    Concatenation( pathtodoc, "/manual.six" ) );

tstfilename:= "docxpl.tst";

tstheadertext_with:= "\
This file contains the GAP code of examples in the package\n\
documentation files.\n\n\
In order to run the tests, one starts GAP from the 'tst' subdirectory\n\
of the 'pkg/PKGNAME' directory, and calls 'Test( \"FILENAME\" );'.\n\
";

tstheadertext_without:= "\
This file contains the GAP code of those examples in the package\n\
documentation files that do not involve the visual mode used by the\n\
Browse package and that run not too long.\n\n\
In order to run the tests, one starts GAP from the 'tst' subdirectory\n\
of the 'pkg/PKGNAME' directory, and calls 'Test( \"FILENAME\" );'.\n\
";

# include examples involving 'Browse'
CreateManualExamplesFiles( pkgname, authors, tstheadertext_with, pathtodoc,
                           main, files, pathtodoc, pathtotst,
                           tstfilename, true );

# omit examples involving 'Browse'
CreateManualExamplesFiles( pkgname, authors, tstheadertext_without, pathtodoc,
                           main, files, pathtodoc, pathtotst,
                           ReplacedString( tstfilename, ".", "2." ), false );


#############################################################################
##  Create the book 'CTblLibXpls'

pathtodoc:= "doc2";;

CheckVersionNumber( pkgname, pathtodoc, main );

SetGapDocLaTeXOptions( "nocolor", "utf8",
      rec(
           TocDepth := "\\setcounter{tocdepth}{2}",  # include subsections
           Maintitlesize := "\\fontsize{36}{38}\\selectfont",
           EarlyExtraPreamble := "\\usepackage{epic}",
         ) );

# Extract the book name from the 'main' file.
str:= StringFile( Concatenation( pathtodoc, "/", main ) );;
pos:= PositionSublist( str, "<Book" );;
pos:= PositionSublist( str, "Name=\"", pos );;
pos:= Position( str, '\"', pos );;
pos2:= Position( str, '\"', pos );;
bookname:= str{ [ pos + 1 .. pos2 - 1 ] };;

files:= [
  ];;

# Fetch GAP's current 'manualbib.xml'.
# This way, we avoid creating 'xml.bib' files in other paths.
Exec( Concatenation( "cp ", bibfile, " ", pathtodoc, "/gapmanualbib.xml" ) );

outputstream:= OutputTextString(outputstring, true);;
SetPrintFormattingStatus(outputstream, false);
SetInfoOutput(InfoGAPDoc, outputstream);
SetInfoOutput(InfoWarning, outputstream);
MakeGAPDocDoc( pathtodoc, main, files, bookname, pathtoroot, "MathJax" );;
CloseStream(outputstream);
UnbindInfoOutput(InfoGAPDoc);
UnbindInfoOutput(InfoWarning);

# Remove GAP's current 'manualbib.xml', and the automatically generated.
# 'manualbib.xml.bib'.
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml" ) );
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml.bib" ) );

CopyHTMLStyleFiles( pathtodoc );

GAPDocManualLabFromSixFile( bookname,
    Concatenation( pathtodoc, "/manual.six" ) );

# Create the necessary `png' files.
CreatePictures:= function( pathtodoc, main )
  local str, filenames, pos, pos2, filename, sub, nam;

  # Extract the source file names from the 'main' file.
  str:= StringFile( Concatenation( pathtodoc, "/", main ) );;
  filenames:= [];
  pos:= PositionSublist( str, "<#Include SYSTEM " );;
  while pos <> fail do
    pos:= Position( str, '\"', pos );;
    pos2:= Position( str, '\"', pos );;
    Add( filenames, Concatenation( pathtodoc, "/",
                                   str{ [ pos+1 .. pos2-1 ] } ) );
    pos:= PositionSublist( str, "<#Include SYSTEM ", pos );;
  od;

  for filename in filenames do
    str:= StringFile( filename );
    pos:= PositionSublist( str, "<!-- BP " );
    while pos <> fail do
      pos2:= PositionSublist( str, "]]>\n<!-- EP", pos );
      sub:= str{ [ pos + 8 .. pos2-1 ] };
      nam:= sub{ [ 1 .. Position( sub, ' ' ) - 1 ] };
      pos:= Position( sub, '\n' );
      pos:= Position( sub, '\n', pos );
      sub:= sub{ [ pos .. Length( sub ) ] };
      PrintTo( nam, "\\batchmode\\documentclass{article}\n",
                    "\\usepackage{graphicx}\\usepackage{epsfig}\n",
                    "\\pagestyle{empty}\\begin{document}\n",
                    sub,
                    "\n\\end{document}\n" );
      Exec( Concatenation( "latex ", nam ) );
      Exec( Concatenation( "dvips -o ", nam, ".ps ", nam ) );
      Exec( Concatenation( "gs -sDEVICE=ppmraw -sOutputFile=- -sNOPAUSE -q ",
                nam, ".ps -c showpage -c quit | pnmcrop| pnmmargin ",
                "-white 10 | pnmtopng > ", nam, ".png" ) );
      Exec( Concatenation( "rm -rf ", nam, " ", nam, ".aux ", nam, ".dvi ",
                nam, ".log ", nam, ".ps" ) );
      if pathtodoc <> "." then
        Exec( Concatenation( "mv ", nam, ".png ", pathtodoc ) );
      fi;

      pos:= PositionSublist( str, "<!-- BP", pos2 );
    od;
  od;
end;

CreatePictures( pathtodoc, main );

# Create the necessary '.g' files.
CreateGapInputFiles:= function( pathtodoc, main, pathtotst, linelen )
  local str, filenames, pos, pos2, filename, res, sub, pos3, pos4, line,
        filenameold;

  # Extract the source file names from the 'main' file.
  str:= StringFile( Concatenation( pathtodoc, "/", main ) );;
  filenames:= [];
  pos:= PositionSublist( str, "<#Include SYSTEM " );;
  while pos <> fail do
    pos:= Position( str, '\"', pos );;
    pos2:= Position( str, '\"', pos );;
    Add( filenames, str{ [ pos+1 .. pos2-1 ] } );

    pos:= PositionSublist( str, "<#Include SYSTEM ", pos );;
  od;

  for filename in filenames do
    str:= StringFile( Concatenation( pathtodoc, "/", filename ) );
    res:= Concatenation( "# This file was created from ", filename,
                         ", do not edit!\n" );
    pos:= PositionSublist( str,
              "<Ignore Remark=\"gapfilecomments\"><![CDATA[" );
    if pos <> fail then
      while pos <> fail do
        pos2:= PositionSublist( str, "]]></Ignore>", pos );
        sub:= str{ [ Position( str, '\n', pos ) + 1 .. pos2-1 ] };
        Append( res, sub );
        pos3:= PositionSublist( str, "<Example><![CDATA[\n", pos2 );
        pos4:= PositionSublist( str, "]]></Example>", pos3 );
        sub:= str{ [ Position( str, '\n', pos3) + 1 .. pos4-1 ] };
        sub:= SplitString( sub, "\n" );
        for line in sub do
          if Length( line ) > 5 and line{ [ 1 .. 5 ] } = "gap> " then
            Append( res, line{ [ 6 .. Length( line ) ] } );
            Append( res, "\n" );
          elif Length( line ) > 2 and line{ [ 1 .. 2 ] } = "> " then
            Append( res, line{ [ 3 .. Length( line ) ] } );
            Append( res, "\n" );
          fi;
        od;
        Append( res, "\n\n" );

        pos:= PositionSublist( str,
                  "<Ignore Remark=\"gapfilecomments\"><![CDATA[", pos2 );
      od;
      Append( res, RepeatedString( "#", linelen ) );
      Append( res, "\n##\n#E\n\n" );

      pos:= Position( filename, '.' );
      filenameold:= Concatenation( pathtotst, "/",
                                   filename{ [ 1 .. pos ] }, "g" );
      if IsExistingFile( filenameold ) then
        Exec( Concatenation( "rm -f ", filenameold, "~" ) );
        Exec( Concatenation( "mv ", filenameold, " ", filenameold, "~" ) );
      fi;
      FileString( filenameold, res );
    fi;
  od;
end;

CreateGapInputFiles( pathtodoc, main, pathtotst, 77 );

tstfilename:= "chapter-wise";

tstheadertext:= "\
This file contains the GAP code of examples in the package\n\
documentation files.\n\n\
In order to run the tests, one starts GAP from the 'tst' subdirectory\n\
of the 'pkg/PKGNAME' directory, and calls 'Test( \"FILENAME\" );'.\n\
";

CreateManualExamplesFiles( pkgname, authors, tstheadertext, pathtodoc,
                           main, files, pathtodoc, pathtotst,
                           tstfilename, true );

Print(outputstring);
outputstring:= ReplacedString(outputstring, "\c", "");;
errors:= Filtered(SplitString(outputstring, "\n"),
           x -> StartsWith(x, "#W ") and x <> "#W There are overfull boxes:");;
if Length(errors) = 0 then
  QuitGap(true);
else
  Print(errors, "\n");
  QuitGap(false);
fi;

