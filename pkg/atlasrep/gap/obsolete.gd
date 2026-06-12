#############################################################################
##
#W  obsolete.gd          GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains declarations of global variables
##  that had been documented in earlier versions of the AtlasRep package.
##


#############################################################################
##
#F  AGRGNAN( <gapname>, <atlasname>[, <size>[, <maxessizes>[, "all"
#F           [, <compatinfo>]]]] )
##
##  This function is deprecated since version 1.5 of the package.
##
##  Let <gapname> be a string denoting a GAP group name,
##  and <atlasname> be a string denoting the corresponding ATLAS-file name
##  used in filenames of the ATLAS of Group Representations.
##  The following optional arguments are supported.
##
##  'size':
##    the order of the corresponding group,
##
##  'maxessizes':
##    a (not necessarily dense) list of orders of the maximal subgroups of
##    this group,
##
##  'complete':
##    the string '"all"' if the <maxessizes> list is known to be
##    complete, or the string '"unknown"' if not,
##
##  'compatinfo':
##    a list of entries of the form '[ <std>, <factname>, <factstd>, <flag> ]'
##    meaning that mapping standard generators of standardization <std>
##    to the factor group with GAP group name <factname>, via the
##    natural epimorphism, yields standard generators of standardization
##    <factstd> if <flag> is 'true'.
##
##  'AGRGNAN' adds the list of its arguments to the list stored
##  in the 'GAPnames' component of 'AtlasOfGroupRepresentationsInfo',
##  making the ATLAS data involving <atlasname>
##  accessible for the group with name <gapname>.
##
##  An example of a valid call is 'AGRGNAN("A6.2_2","PGL29",360)',
##  see also Section <Ref Sect="sect:An Example of Extending AtlasRep"/>.
##
BindGlobal( "AGRGNAN", function( arg )
    local l;

    AGR.GNAN( arg[1], arg[2] );
    if IsBound( arg[3] ) then AGR.GRS( arg[1], arg[3] ); fi;
    if IsBound( arg[4] ) then AGR.MXO( arg[1], arg[4] ); fi;
    if IsBound( arg[5] ) and arg[5] = "all" then
      AGR.MXN( arg[1], Length( AGR.GAPnamesRec.( arg[1] )[3].sizesMaxes ) );
    fi;
    if IsBound( arg[6] ) then
      for l in arg[6] do
        AGR.STDCOMP( arg[1], l );
      od;
    fi;
    end );


#############################################################################
##
#F  AGRGRP( <dirname>, <simpname>, <groupname> )
#F  AGRRNG( ... )
#F  AGRTOC( <typename>, <filename>[, <nrgens>] )
#F  AGRTOCEXT( <atlasname>, <std>, <maxnr>, <files> )
##
##  These functions are deprecated since version 1.5 of the package.
##
##  These functions were used to create the initial table of contents for the
##  server data of the AtlasRep package when the file
##  'atlasprm.g' in the 'gap' directory of the package was read.
##  Conversely, encoding the table of contents in terms of calls to 'AGRGRP',
##  'AGRTOC' and 'AGRTOCEXT' was done by 'StringOfAtlasTableOfContents'.
##
##  'AGRGRP' does not make sense anymore since the data format of the
##  table of contents was changed in version 1.6 of AtlasRep,
##  in order to admit private extensions.
##  (Each call of 'AGRGRP' notified the group with name <groupname>,
##  which was related to the simple group with name <simpname>
##  and for which the data on the servers were found in the directory
##  with name <dirname>.)
##
##  The other functions can in principle still be used also with
##  newer AtlasRep versions, provided that the current file has been read
##  in the GAP session.
##
##  Each call of 'AGRTOC' notifies an entry to the 'TableOfContents.remote'
##  component of the global variable 'AtlasOfGroupRepresentationsInfo'.
##  The arguments must be the name <typename> of the data type to which
##  the entry belongs, the prefix <filename> of the data file(s),
##  and if given the number <nrgens> of generators, which are then
##  located in separate files.
##
##  Each call of 'AGRTOCEXT' notifies an entry to the 'maxext' component in
##  the record for the group with ATLAS name <atlasname> in the 'GAPnames'
##  component of 'AtlasOfGroupRepresentationsInfo'.
##  These entries concern straight line programs for computing generators of
##  maximal subgroups from information about straight line programs for
##  proper factor groups.
##
BindGlobal( "AGRRNG", function( arg ) CallFuncList( AGR.RNG, arg ); end );
BindGlobal( "AGRTOC", function( arg ) CallFuncList( AGR.TOC, arg ); end );
BindGlobal( "AGRTOCEXT",
    function( arg ) CallFuncList( AGR.TOCEXT, arg ); end );


#############################################################################
##
#F  AGRParseFilenameFormat( <string>, <format> )
##
BindGlobal( "AGRParseFilenameFormat",
    function( arg ) CallFuncList( AGR.ParseFilenameFormat, arg ); end );


#############################################################################
##
#F  AtlasStraightLineProgram( ... )
##
##  This was the documented name before version 1.3 of the package,
##  when no straight line decisions and black box programs were available.
##  We keep it for backwards compatibility reasons,
##  but leave it undocumented.
##
DeclareSynonym( "AtlasStraightLineProgram", AtlasProgram );


#############################################################################
##
#F  OneAtlasGeneratingSet( ... )
##
##  This function is deprecated since version 1.3 of the package.
##  It was used in earlier versions,
##  when 'OneAtlasGeneratingSetInfo' was not yet available.
##
BindGlobal( "OneAtlasGeneratingSet", function( arg )
    local res;

    res:= CallFuncList( OneAtlasGeneratingSetInfo, arg );
    if res <> fail then
      res:= AtlasGenerators( res.identifier );
    fi;
    return res;
    end );


#############################################################################
##
#F  AtlasStringOfStraightLineProgram( ... )
##
##  This was the documented name before version 1.3 of the package,
##  when no straight line decisions and black box programs were available.
##  We keep it for backwards compatibility reasons,
##  but leave it undocumented.
##
DeclareSynonym( "AtlasStringOfStraightLineProgram", AtlasStringOfProgram );


#############################################################################
##
#F  AtlasOfGroupRepresentationsShowUserParameters()
#F  AtlasOfGroupRepresentationsUserParameters()
##
##  'AtlasOfGroupRepresentationsShowUserParameters' is deprecated since
##  version 1.5 of the package,
##  when 'AtlasOfGroupRepresentationsUserParameters' was introduced.
##  The latter is deprecated since version 1.6 of the package,
##  which assumes GAP's user preferences mechanism.
##  Thus one should use the general GAP library function
##  'ShowUserPreferences' instead.
##
BindGlobal( "AtlasOfGroupRepresentationsShowUserParameters", function()
    ShowUserPreferences( "AtlasRep" );
    end );

BindGlobal( "AtlasOfGroupRepresentationsUserParameters", function()
    local str;

    str:= "Please call 'ShowUserPreferences( \"AtlasRep\" );' ";
    if IsBoundGlobal( "BrowseUserPreferences" ) then
      Append( str, "or 'BrowseUserPreferences( \"AtlasRep\" );' " );
    fi;
    Append( str, "for showing the user preferences that belong to " );
    Append( str, "the AtlasRep package." );

    return str;
    end );


#############################################################################
##
#F  AtlasOfGroupRepresentationsTestClassScripts( ... )
#F  AtlasOfGroupRepresentationsTestCompatibleMaxes( ... )
#F  AtlasOfGroupRepresentationsTestFileHeaders( ... )
#F  AtlasOfGroupRepresentationsTestFiles( ... )
#F  AtlasOfGroupRepresentationsTestGroupOrders( ... )
#F  AtlasOfGroupRepresentationsTestStdCompatibility( ... )
#F  AtlasOfGroupRepresentationsTestSubgroupOrders( ... )
#F  AtlasOfGroupRepresentationsTestWords( ... )
##
##  These functions are deprecated since version 1.5 of the package.
##
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestClassScripts" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestCompatibleMaxes" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestFileHeaders" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestFiles" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestGroupOrders" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestStdCompatibility" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestSubgroupOrders" );
DeclareGlobalFunction( "AtlasOfGroupRepresentationsTestWords" );


#############################################################################
##
#F  AtlasOfGroupRepresentationsNotifyPrivateDirectory( ... )
#F  AtlasOfGroupRepresentationsForgetPrivateDirectory( ... )
##
##  These function names are deprecated since version 2.0 of the package.
##
DeclareSynonym( "AtlasOfGroupRepresentationsNotifyPrivateDirectory",
    AtlasOfGroupRepresentationsNotifyData );

DeclareSynonym( "AtlasOfGroupRepresentationsForgetPrivateDirectory",
    AtlasOfGroupRepresentationsForgetData );


#############################################################################
##
#F  ReloadAtlasTableOfContents( <dirname> )
#F  ReplaceAtlasTableOfContents( <filename> )
#F  StoreAtlasTableOfContents( <filename> )
##
##  These functions are no longer available since version 2.0 of the package.
##
BindGlobal( "ReloadAtlasTableOfContents",
    function( arg )
      Error( "the functions ReloadAtlasTableOfContents, ",
             "ReplaceAtlasTableOfContents, and ",
             "StoreAtlasTableOfContents are no longer supported" );
    end );

DeclareSynonym( "ReplaceAtlasTableOfContents", ReloadAtlasTableOfContents );
DeclareSynonym( "StoreAtlasTableOfContents", ReloadAtlasTableOfContents );


#############################################################################
##
#E

