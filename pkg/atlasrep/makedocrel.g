##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##
SetInfoLevel( InfoGAPDoc, 2 );

SetGapDocLaTeXOptions( "nocolor", "utf8" );

pathtodoc:= "doc";;
main:= "main.xml";;
pkgname:= "AtlasRep";;

SetPackagePath( pkgname, "." );
LoadPackage( pkgname );

# Extract the book name from the 'main' file.
str:= StringFile( Concatenation( pathtodoc, "/", main ) );;
pos:= PositionSublist( str, "<Book" );;
pos:= PositionSublist( str, "Name=\"", pos );;
pos:= Position( str, '\"', pos );;
pos2:= Position( str, '\"', pos );;
bookname:= str{ [ pos + 1 .. pos2 - 1 ] };;

pathtoroot:= "../../..";;

pathtotst:= "tst";;
authors:= [ "Thomas Breuer" ];;

files:= [
    "../gap/access.gd",
    "../gap/access.gi",
    "../gap/bbox.gd",
    "../gap/brmindeg.g",
    "../gap/brspor.g",
    "../gap/interfac.gd",
    "../gap/json.g",
    "../gap/mindeg.gd",
    "../gap/scanmtx.gd",
    "../gap/test.g",
    "../tst/testinst.g",
    "../gap/types.g",
    "../gap/types.gd",
    "../gap/userpref.g",
    "../gap/utils.gd",
  ];;

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
      res:= Concatenation( "..",
                res{ [ Length( self[1] ) + 1 .. Length( res ) ] } );
    elif not StartsWith( res, pkgpath ) then
      # Perhaps the link points to a package outside the main root path.
      # Probably this indicates an error.
      if ForAny( RecNames( GAPInfo.PackagesLoaded ),
                 x -> x <> GAPInfo.CurrentPackageName and
                      StartsWith( res, GAPInfo.PackagesLoaded.( x )[1] ) ) then
        Error( "<url> points to a package outside the main GAP root path:\n",
               "res = '", res, "',\npkgpath = '", pkgpath, "'" );
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
      prefixdir:= Directory( prefix );
      pkgname:= First( RecNames( GAPInfo.PackagesLoaded ),
                       x -> Directory( GAPInfo.PackagesLoaded.( x )[1] )
                            = prefixdir );
      suffix:= res{ [ pos2 .. Length( res ) ] };
      res:= Concatenation( prefix{ [ 1 .. pos ] }, pkgname, suffix );
    fi;
  fi;

  return res;
end;

# Fetch GAP's current 'manualbib.xml'.
# This way, we avoid creating 'xml.bib' files in other paths.
bibfile:= Filename( DirectoriesLibrary( "doc" ), "manualbib.xml" );
if bibfile = fail then
  Error( "cannot access GAP's current 'manualbib.xml'" );
fi;
Exec( Concatenation( "cp ", bibfile, " ", pathtodoc, "/gapmanualbib.xml" ) );

MakeGAPDocDoc( pathtodoc, main, files, bookname, pathtoroot, "MathJax" );;

# Remove GAP's current 'manualbib.xml', and the automatically generated.
# 'manualbib.xml.bib'. 
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml" ) );
Exec( Concatenation( "rm ", pathtodoc, "/", "gapmanualbib.xml.bib" ) );

CopyHTMLStyleFiles( pathtodoc );

GAPDocManualLabFromSixFile( bookname,
    Concatenation( pathtodoc, "/manual.six" ) );


#############################################################################

# Check the consistency of version numbers in 'PackageInfo.g' and the manual.
CheckVersionNumber:= function( pkgname, pathtodoc, main )
    local str, pos, pos2, version1, version2;

    # definition in the manual
    str:= StringFile( Concatenation( pathtodoc, "/", main ) );
    pos:= PositionSublist( str, "<!ENTITY VERSIONNUMBER \"" );
    pos:= Position( str, '\"', pos );
    pos2:= Position( str, '\"', pos );
    version1:= str{ [ pos + 1 .. pos2 - 1 ] };

    # definition in 'PackageInfo.g'
    version2:= PackageInfo( pkgname )[1].Version;

    if version1 <> version2 then
      Error( "version numbers <version1> (from ", main,
             ") and <version2> (from PackageInfo.g) differ" );
    fi;
end;

CheckVersionNumber( pkgname, pathtodoc, main );


#############################################################################

tstfilename:= "docxpl.tst";

tstheadertext_with:= "\
This file contains the GAP code of examples in the package\n\
documentation files.\n\
\n\
In order to run the tests, one starts GAP from the 'tst' subdirectory\n\
of the 'pkg/PKGNAME' directory, and calls 'Test( \"FILENAME\" );'.\n\
";

tstheadertext_without:= "\
This file contains the GAP code of those examples in the package\n\
documentation files that do not involve the visual mode used by the\n\
Browse package.\n\n\
In order to run the tests, one starts GAP from the 'tst' subdirectory\n\
of the 'pkg/PKGNAME' directory, and calls 'Test( \"FILENAME\" );'.\n\
";

ExampleFileHeader:= function( filename, pkgname, authors, text, linelen,
                              pathtodoc, main, withbrowse )
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

    Append( str, "\n\ngap> LoadPackage( \"" );
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
                          x -> PositionSublist( x[1], "Browse" ) = fail ) );
    fi;

    for i in [ 1 .. Length( xpls ) ] do
      str:= "# This file was created automatically, do not edit!\n";
      Append( str, ExampleFileHeader( tstfilenames[i], pkgname, authors,
                                      text, linelen, path, main, withbrowse ) );
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

# include examples involving 'Browse'
CreateManualExamplesFiles( pkgname, authors, tstheadertext_with, pathtodoc,
                           main, files, pathtodoc, pathtotst,
                           tstfilename, true );

# omit examples involving 'Browse'
CreateManualExamplesFiles( pkgname, authors, tstheadertext_without, pathtodoc,
                           main, files, pathtodoc, pathtotst,
                           ReplacedString( tstfilename, ".", "2." ), false );

