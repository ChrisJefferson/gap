#############################################################################
##
#W  test.g               GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains functions to test the data available in the
##  ATLAS of Group Representations or in private extensions.
##


#############################################################################
##
##  <#GAPDoc Label="tests">
##  The file <F>tst/testall.g</F> of the package
##  contains <Ref Func="Test" BookName="ref"/> statements
##  for checking whether the &AtlasRep; functions behave as documented.
##  One can run these tests by calling
##  <C>ReadPackage( "AtlasRep", "tst/testall.g" )</C>.
##  The examples in the package manual form a part of the tests,
##  they are collected in the file <F>tst/docxpl.tst</F> of the package.
##  <P/>
##  The remainder of this section deals with consistency checks of the data.
##  The tests described in Section
##  <Ref Subsect="subsect:AGR sanity checks by toc"/> can be used
##  for data from any extension of the database
##  (see Chapter&nbsp;<Ref Chap="chap:Private Extensions"/>),
##  Section <Ref Subsect="subsect:AGR other sanity checks"/> lists tests
##  which apply only to the core part of the database.
##  <P/>
##  All these tests apply only to <E>locally</E> available files
##  (see Section&nbsp;<Ref Sect="sect:The Tables of Contents of the AGR"/>),
##  no files are downloaded during the tests.
##  Thus the required space and time for running these tests
##  depend on the amount of locally available data.
##  <P/>
##  Some of the tests compute and verify additional data,
##  such as information about point stabilizers of permutation
##  representations.
##  In these cases, output lines starting with <C>#E</C> are error messages
##  that point to inconsistencies,
##  whereas output lines starting with <C>#I</C> inform about data that have
##  been computed and were not yet stored,
##  or about stored data that were not verified.
##  These tests are experimental in the sense that they involve several
##  heuristics.  Depending on the data to which they are applied,
##  it may happen that the tests run out of space or do not finish in
##  acceptable time.  Please inform the package maintainer if you run into
##  such problems.
##
##  <Subsection Label="subsect:AGR sanity checks by toc">
##  <Heading>Sanity Checks for a Table of Contents</Heading>
##
##  The following tests can be used to check the data that belong to a given
##  part of the database (core data or extension).
##  Each of these tests is given by a function with optional argument
##  <M>tocid</M>, the identifying string that had been entered as the second
##  argument of
##  <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/>.
##  The contents of the core part can be checked by entering <C>"core"</C>,
##  which is also the default for <M>tocid</M>.
##  The function returns <K>false</K> if an error occurs,
##  otherwise <K>true</K>.
##  Currently the following tests of this kind are available.
##  (For some of them, the global option <C>TryToExtendData</C> can be
##  entered in order to try the computation of not yet stored data.)
##  <P/>
##  <List>
##  <#Include Label="test:AGR.Test.GroupOrders">
##  <!-- <Include Label="test:AGR.Test.GroupFlags"> -->
##  <#Include Label="test:AGR.Test.Words">
##  <#Include Label="test:AGR.Test.ClassScripts">
##  <#Include Label="test:AGR.Test.CycToCcls">
##  <#Include Label="test:AGR.Test.FileHeaders">
##  <#Include Label="test:AGR.Test.Files">
##  <#Include Label="test:AGR.Test.BinaryFormat">
##  <#Include Label="test:AGR.Test.Primitivity">
##  <#Include Label="test:AGR.Test.Characters">
##  <#Include Label="test:AGR.Test.StdCompatibility">
##  <#Include Label="test:AGR.Test.KernelGenerators">
##  <#Include Label="test:AGR.Test.MaxesOrders">
##  <#Include Label="test:AGR.Test.MaxesStructure">
##  <#Include Label="test:AGR.Test.MaxesStandardization">
##  <#Include Label="test:AGR.Test.CompatibleMaxes">
##  </List>
##
##  </Subsection>
##
##  <Subsection Label="subsect:AGR other sanity checks">
##  <Heading>Other Sanity Checks</Heading>
##
##  The tests described in this section are intended for checking data
##  that do not belong to a particular part of the &AtlasRep; database.
##  Therefore <E>all</E> locally available data are used in these tests.
##  Each of the tests is given by a function without arguments that
##  returns <K>false</K> if a contradiction was found during the test,
##  and <K>true</K> otherwise.
##  Additionally, certain messages are printed
##  when contradictions between stored and computed data are found,
##  when stored data cannot be verified computationally,
##  or when the computations yield improvements of the stored data.
##  Currently the following tests of this kind are available.
##  <P/>
##  <List>
##  <#Include Label="test:AGR.Test.Standardization">
##  <#Include Label="test:AGR.Test.StdTomLib">
##  <#Include Label="test:AGR.Test.MinimalDegrees">
##  </List>
##
##  </Subsection>
##  <#/GAPDoc>
##

if not IsPackageMarkedForLoading( "TomLib", "" ) then
  IsStandardGeneratorsOfGroup:= "dummy";
  LIBTOMKNOWN:= "dummy";
fi;

if not IsPackageMarkedForLoading( "CTblLib", "" ) then
  ConstructionInfoCharacterTable:= "dummy";
  HasConstructionInfoCharacterTable:= "dummy";
  LibInfoCharacterTable:= "dummy";
  StructureDescriptionCharacterTableName:= "dummy";
fi;

if not IsPackageMarkedForLoading( "Recog", "" ) then
  InfoRecog:= "dummy";
  RecogniseGroup:= "dummy";
  SLPforElement:= "dummy";
  NiceGens:= "dummy";
fi;


#############################################################################
##
AGR.FillHoles:= function( list, default )
    local i;

    for i in [ 1 .. Length( list ) ] do
      if not IsBound( list[i] ) then
        list[i]:= default;
      fi;
    od;
    return list;
end;
    
AGR.TOCLine:= function( tag, name, values, default )
    return Filtered( String( [ tag,
                         [ name, AGR.FillHoles( values, default ) ] ] ),
                     x -> x <> ' ' );
end;


#############################################################################
##
#V  AGR.Test
#V  AGR.Test.HardCases
#V  AGR.Test.HardCases.MaxNumberMaxes
#V  AGR.Test.HardCases.MaxNumberStd
#V  AGR.Test.HardCases.MaxNumberVersions
#V  AGR.Test.MaxTestDegree
##
##  'AGR.Test' is a record whose components belong to the various tests,
##  and list data which shall be omitted from the tests
##  because they would be too space or time consuming.
##
##  In the test loops, we assume upper bounds on the numbers of available
##  maximal subgroups and standardizations,
##  and we perform some tests only if a sufficiently small permutation
##  representation is available.
##
AGR.Test:= rec();
AGR.Test.HardCases:= rec();
AGR.Test.HardCases.MaxNumberMaxes:= 50;
AGR.Test.HardCases.MaxNumberStd:= 2;
AGR.Test.HardCases.MaxNumberVersions:= 3;
AGR.Test.MaxTestDegree:= 10^5;

#T 6.Suz.2 needs 200000 ...
#T 6.Fi22.2 needs ...


#############################################################################
##
#F  AGR.Test.Words( [<tocid>[, <gapname>]][,][<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.Words">
##  <Mark><C>AGR.Test.Words( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    processes the straight line programs that belong to <M>tocid</M>,
##    using the function stored in the <C>TestWords</C> component of the
##    data type in question.
##    <P/>
##    The straight line programs for the cases listed in
##    <C>AGR.Test.HardCases.TestWords</C> are omitted.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.HardCases.TestWords:= [
    [ "find", [ "B", "HN", "S417", "F24d2" ] ],
    [ "check", [ "B" ] ],
    [ "maxes", [ "Co1" ] ],
#T doable with recog?
  ];

AGR.Test.Words:= function( arg )
    local result, maxdeg, tocid, verbose, types, toc, name, r, type, omit,
          entry, prg, gens, grp, size;

    # Initialize the result.
    result:= true;

    maxdeg:= AGR.Test.MaxTestDegree;

    if Length( arg ) = 0 then
      return AGR.Test.Words( "core", false );
    elif Length( arg ) = 1 and IsBool( arg[1] ) then
      return AGR.Test.Words( "core", arg[1] );
    elif Length( arg ) = 1 and IsString( arg[1] ) then
      return AGR.Test.Words( arg[1], false );
    elif Length( arg ) = 2 and IsString( arg[1] ) and IsString( arg[2] ) then
      return AGR.Test.Words( arg[1], arg[2], false );
    elif Length( arg ) = 2 and IsString( arg[1] ) and IsBool( arg[2] ) then
      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.Words( arg[1],
                     name[1], arg[2] ) and result;
      od;
      return result;
    elif not ( Length( arg ) = 3 and IsString( arg[1] )
                                 and IsString( arg[2] )
                                 and IsBool( arg[3] ) ) then
      Error( "usage: AGR.Test.Words( [<tocid>[, ",
             "<gapname>]][,][<verbose>] )" );
    fi;

    tocid:= arg[1];
    verbose:= arg[3];

    # Check only straight line programs.
    types:= AGR.DataTypes( "prg" );
    name:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                  x -> x[1] = arg[2] );

    for toc in AGR.TablesOfContents( [ tocid, "local" ] ) do
      if IsBound( toc.( name[2] ) ) then
        r:= toc.( name[2] );

        # Note that the ordering in the 'and' statement must not be
        # changed, in order to execute all tests!
        for type in types do
          omit:= First( AGR.Test.HardCases.TestWords,
                        pair -> pair[1] = type[1] );
          if IsBound( r.( type[1] ) ) then
            if IsList( omit ) and name[2] in omit[2] then
              if verbose then
                Print( "#I  AGR.Test.Words:\n",
                       "#I  omit TestWords for ", type[1], " and ", name[2],
                       "\n" );
              fi;
            else
              for entry in r.( type[1] ) do
                result:= type[2].TestWords( tocid, name[2],
                             entry[ Length( entry ) ], type, verbose )
                         and result;
              od;
            fi;
          fi;
        od;

        # Check also those 'maxext' scripts (which do not form a data type)
        # that belong to the given t.o.c.
        r:= name[3];
        if IsBound( r.maxext ) then
          for entry in Filtered( r.maxext, l -> l[4] = tocid ) do
            prg:= AtlasProgram( name[1], entry[1], "maxes", entry[2] );
            if prg = fail then
              if verbose then
                Print( "#E  AGR.Test.Words:\n",
                       "#E  cannot verify 'maxext' entry '", entry[3], "'\n" );
                result:= false;
              fi;
            elif not IsInternallyConsistent( prg.program )  then
              Print( "#E  AGR.Test.Words:\n",
                     "#E  program '", entry[3],
                     "' not internally consistent\n" );
              result:= false;
            else
              # Get a representation if available, and map the generators.
              gens:= OneAtlasGeneratingSetInfo( prg.groupname,
                         prg.standardization,
                         NrMovedPoints, [ 2 .. maxdeg ],
                         "contents", [ tocid, "local" ] );
              if gens = fail then
                if verbose then
                  Print( "#I  AGR.Test.Words:\n",
                         "#I  no perm. repres. for '", prg.groupname,
                         "', no check for '", entry[3], "'\n" );
                fi;
              else
                gens:= AtlasGenerators( gens );
                grp:= Group( gens.generators );
                if IsBound( gens.size ) then
                  SetSize( grp, gens.size );
                fi;
                gens:= ResultOfStraightLineProgram( prg.program,
                           gens.generators );
                size:= Size( SubgroupNC( grp, gens ) );
#T use the recog package for larger cases!
                if IsBound( prg.size ) then
                  if size <> prg.size then
                    Print( "#E  AGR.Test.Words:\n",
                           "#E  program '", entry[3], "' for group of order ",
                           size, " not ", prg.size, "\n" );
                    result:= false;
                  fi;
                else
                  Print( "#I  AGR.Test.Words:\n",
                         "#I  add size ", size, " for program '", entry[3],
                         "'\n" );
                fi;
              fi;
            fi;
          od;
        fi;
      fi;
    od;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.FileHeaders( [<tocid>[,<gapname>]] )
##
##  <#GAPDoc Label="test:AGR.Test.FileHeaders">
##  <Mark><C>AGR.Test.FileHeaders( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether the &MeatAxe; text files that belong to <M>tocid</M>
##    have a header line that is consistent with the filename,
##    and whether the contents of all &GAP; format data files that belong to
##    <M>tocid</M> is consistent with the filename.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.FileHeaders:= function( arg )
    local result, name, toc, record, type, entry, test;

    # Initialize the result.
    result:= true;

    if Length( arg ) = 2 then
      name:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                    x -> x[1] = arg[2] );
      for toc in AGR.TablesOfContents( [ arg[1], "local" ] ) do
        if IsBound( toc.( name[2] ) ) then
          record:= toc.( name[2] );
          for type in AGR.DataTypes( "rep" ) do
            if IsBound( record.( type[1] ) ) then
              for entry in record.( type[1] ) do
                test:= type[2].TestFileHeaders( arg[1], arg[2], entry, type );
                if not IsBool( test ) then
                  Print( "#E  AGR.Test.FileHeaders:\n",
                         "#E  ", test, " for ", entry[ Length( entry ) ],
                         "\n" );
                  test:= false;
                fi;
                result:= test and result;
              od;
            fi;
          od;
        fi;
      od;
    elif Length( arg ) = 1 then
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.FileHeaders( arg[1], entry[1] ) and result;
      od;
    elif Length( arg ) = 0 then
      result:= AGR.Test.FileHeaders( "core" );
    fi;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.BinaryFormat( [<tocid>] )
##
##  <#GAPDoc Label="test:AGR.Test.BinaryFormat">
##  <Mark><C>AGR.Test.BinaryFormat( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether all &MeatAxe; text files that belong to <M>tocid</M>
##    satisfy that applying first <Ref Func="CMtxBinaryFFMatOrPerm"/> and
##    then <Ref Func="FFMatOrPermCMtxBinary"/> yields the same object.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.BinaryFormat:= function( arg )
    local tmpfile, tocid, result, r, gens, gen, test, cnv;

    # Create one temporary file.
    tmpfile:= Filename( DirectoryTemporary(), "testfile" );

    # Get the data directory.
    if IsEmpty( arg ) then
      tocid:= [ "core", "local" ];
    else
      tocid:= arg[1];
    fi;

    result:= true;

    for r in Concatenation( AllAtlasGeneratingSetInfos( "contents", tocid,
                                IsPermGroup, true ),
                            AllAtlasGeneratingSetInfos( "contents", tocid,
                                Characteristic, IsPosInt ) ) do
      gens:= AtlasGenerators( r );
      if gens <> fail then
        gens:= gens.generators;
        for gen in gens do
          test:= false;
          if IsPerm( gen ) then
            CMtxBinaryFFMatOrPerm( gen, LargestMovedPoint( gen ), tmpfile );
            test:= true;
          elif IsMatrix( gen ) then
            cnv:= ConvertToMatrixRep( gen );
            if IsInt( cnv ) then
              CMtxBinaryFFMatOrPerm( gen, cnv, tmpfile );
              test:= true;
            fi;
          else
            Print( "#E  AGR.Test.BinaryFormat:\n",
                   "#E  not permutation or matrix for '", r, "'\n" );
            result:= false;
          fi;
          if test and gen <> FFMatOrPermCMtxBinary( tmpfile ) then
            Print( "#E  AGR.Test.BinaryFormat:\n",
                   "#E  differences for '", r, "'\n" );
            result:= false;
          fi;
        od;
      fi;
    od;

    # Remove the temporary file.
    RemoveFile( tmpfile );

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.Standardization( [<gapname>] )
##
##  <#GAPDoc Label="test:AGR.Test.Standardization">
##  <Mark><C>AGR.Test.Standardization()</C></Mark>
##  <Item>
##    checks whether all generating sets corresponding to the same set of
##    standard generators have the same element orders; for the case that
##    straight line programs for computing certain class representatives are
##    available, also the orders of these representatives are checked
##    w.&nbsp;r.&nbsp;t.&nbsp;all generating sets.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.Standardization:= function( arg )
    local result, name, gapname, gensorders, cclorders, cycorders, tbl, info,
          gens, std, ords, pair, prg, names, choice;

    # Initialize the result.
    result:= true;

    if Length( arg ) = 0 then

      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.Standardization( name[1] ) and result;
      od;

    elif Length( arg ) = 1 and IsString( arg[1] ) then

      gapname:= arg[1];
      if AGR.InfoForName( gapname ) = fail then
        Print( "#E  AGR.Test.Standardization:\n",
               "#E  no group with GAP name '", gapname, "'\n" );
        return false;
      fi;

      gensorders:= [];
      cclorders:= [];
      cycorders:= [];

      tbl:= CharacterTable( gapname );

      # Loop over the relevant representations.
      for info in AllAtlasGeneratingSetInfos( gapname, "contents", "local" ) do
        gens:= AtlasGenerators( info.identifier );
        std:= gens.standardization;

        # Check that the generators are invertible,
        # and that the orders are equal in all representations.
        if ForAll( gens.generators, x -> Inverse( x ) <> fail ) then
          ords:= List( gens.generators, Order );
        else
          ords:= [ fail ];
        fi;
        if not ForAll( ords, IsInt ) then
          Print( "#E  AGR.Test.Standardization:\n",
                 "#E  representation '", gens.identifier[2],
                 "': non-finite order\n" );
          result:= false;
        elif IsBound( gensorders[ std+1 ] ) then
          if gensorders[ std+1 ] <> ords then
            Print( "#E  AGR.Test.Standardization:\n",
                   "#E  '", gapname, "': representation '",
                   gens.identifier[2], "':\n",
                   "#E  incompatible generator orders ",
                   ords, " and ", gensorders[ std+1 ], "\n" );
            result:= false;
          fi;
        else
          gensorders[ std+1 ]:= ords;
        fi;

        # If scripts for computing representatives of cyclic subgroups
        # or representatives of conjugacy classes are available
        # then check that their orders are equal in all representations.
        for pair in [ [ cclorders, "classes" ], [ cycorders, "cyclic" ] ] do
          if not IsBound( pair[1][ std+1 ] ) then
            prg:= AtlasProgram( gapname, std, pair[2] );
            if prg = fail then
              pair[1][ std+1 ]:= fail;
            else
              pair[1][ std+1 ]:= [ prg.program,
                                   List( ResultOfStraightLineProgram(
                                     prg.program, gens.generators ), Order ) ];
              if tbl <> fail then
                names:= AtlasClassNames( tbl );
                if IsBound( prg.outputs ) then
                  choice:= List( prg.outputs, x -> Position( names, x ) );
                  if ( not fail in choice ) and pair[1][ std+1 ][2]
                         <> OrdersClassRepresentatives( tbl ){ choice } then
                    Print( "#E  AGR.Test.Standardization:\n",
                           "#E  '", gapname, "': representation '",
                           gens.identifier[2], "':\n",
                           "#E  ", pair[2],
                           " orders differ from character table\n" );
                    result:= false;
                  fi;
                else
                  Print( "#E  no component 'outputs' in '", pair[2],
                         "' for '", gapname, "'\n" );
                fi;
              fi;
            fi;
          elif pair[1][ std+1 ] <> fail then
            if pair[1][ std+1 ][2] <> List( ResultOfStraightLineProgram(
                   pair[1][ std+1 ][1], gens.generators ), Order ) then
              Print( "#E  AGR.Test.Standardization:\n",
                     "#E  '", gapname, "': representation '",
                     gens.identifier[2], "':\n",
                     "#E  incompatible ", pair[2], " orders\n" );
              result:= false;
            fi;
          fi;
        od;
      od;

    fi;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.StdTomLib( [<gapname>] )
##
##  <#GAPDoc Label="test:AGR.Test.StdTomLib">
##  <Mark><C>AGR.Test.StdTomLib()</C></Mark>
##  <Item>
##    checks whether the standard generators are compatible with those that
##    occur in the <Package>TomLib</Package> package.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.StdTomLib:= function( arg )
    local result, name, tomnames, tbl, tom, gapname, info, allgens, stdavail,
          verified, falsified, G, i, iinfo, type, prg, res, gens, G2,
          fitstotom, fitstohom;

    if not IsPackageMarkedForLoading( "TomLib", "1.0" ) then
      Print( "#E  AGR.Test.StdTomLib:\n",
             "#E  TomLib not loaded, cannot verify ATLAS standardizations\n" );
      return false;
    fi;

    # Initialize the result.
    result:= true;

    if Length( arg ) = 0 then

      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.StdTomLib( name[1] ) and result;
      od;

      # Check also that all tables of marks which provide standardization
      # information really belong to ATLAS groups.
      tomnames:= Set( List( Filtered( LIBTOMKNOWN.STDGEN, x -> x[2] <> "N" ),
                            x -> x[1] ) );
      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        tbl:= CharacterTable( name[1] );
        if tbl <> fail then
          tom:= TableOfMarks( tbl );
          if tom <> fail then
            RemoveSet( tomnames, Identifier( tom ) );
          fi;
        fi;
      od;

      if not IsEmpty( tomnames ) then
        Print( "#E  AGR.Test.StdTomLib:\n",
               "#E  cannot verify ATLAS standardizations for tables of ",
               "marks in\n",
               "#E  ", tomnames, "\n" );
        result:= false;
      fi;

    elif Length( arg ) = 1 and IsString( arg[1] ) then

      gapname:= arg[1];
      if AGR.InfoForName( gapname ) = fail then
        Print( "#E  AGR.Test.StdTomLib:\n",
               "#E  no group with GAP name '", gapname, "'\n" );
        return false;
      fi;

      tbl:= CharacterTable( gapname );

      # Check the ATLAS standardization against the TomLib standardization.
      # (We consider only ATLAS permutation representations.)
      if tbl = fail then
        tom:= fail;
      else
        tom:= TableOfMarks( tbl );
      fi;
      if tom <> fail then

        # The table of marks is available,
        # which implies that the TomLib package is loaded.
        # Thus '(Has)StandardGeneratorsInfo' is bound.
        # (But avoid a syntax error message when reading the file
        # in the case that TomLib is not available.)
        if ValueGlobal( "HasStandardGeneratorsInfo" )( tom ) then
          info:= ValueGlobal( "StandardGeneratorsInfo" )( tom );
        else
          info:= [];
        fi;

        allgens:= AllAtlasGeneratingSetInfos( gapname, IsPermGroup, true,
                                              "contents", "local" );
        stdavail:= Set( List( allgens, x -> x.standardization ) );

        if not IsSubset( stdavail,
                         Set( List( info, r -> r.standardization ) ) ) then
          Print( "#E  AGR.Test.StdTomLib:\n",
                 "#E  strange standardization info ",
                 " for table of marks of ", gapname, "\n" );
          result:= false;
        fi;

        if not IsSubset( Set( List( info, r -> r.standardization ) ),
                         stdavail ) then
          Print( "#I  AGR.Test.StdTomLib:\n",
                 "#I  extend STDGEN info for ", gapname, "\n" );
        fi;

        allgens:= List( stdavail,
                        i -> First( allgens, x -> x.standardization = i ) );
        verified:= [];
        falsified:= [];
        G:= UnderlyingGroup( tom );

        for i in Union( stdavail, List( info, r -> r.standardization ) ) do

          # 1. Apply AtlasRep checks (using 'pres' and 'check' scripts)
          #    to the TomLib generators.
          iinfo:= First( info, r -> IsBound( r.standardization ) and
                                    r.standardization = i );
          if i in stdavail then
            for type in [ "pres", "check" ] do
              prg:= AtlasProgram( gapname, i, type );
              if prg <> fail then
                res:= ResultOfStraightLineDecision( prg.program,
                          GeneratorsOfGroup( G ) );
                if res = true then
                  AddSet( verified, i );
                  if iinfo = fail then
                    Print( "#I  AGR.Test.StdTomLib:\n",
                           "#I  ", gapname,
                           ": extend TomLib standardization info, ",
                           "we have standardization = ", i, "\n" );
                  elif ForAny( info, r -> IsBound( r.standardization ) and
                                          r.standardization <> i ) then
                    Print( "#E  AGR.Test.StdTomLib:\n",
                           "#E  ", gapname,
                           ": different TomLib standardizations (", i,
                           " verified)?\n" );
                    result:= false;
                  fi;
                else
                  AddSet( falsified, i );
                  if iinfo <> fail then
                    Print( "#E  AGR.Test.StdTomLib:\n",
                           "#E  ", gapname,
                           ": TomLib standardization info is not ", i, "\n" );
                    result:= false;
                  fi;
                fi;
              fi;
            od;
          fi;

          # 2. Apply TomLib checks to the Atlas generators
          #    (permutations only).
          if iinfo.script = fail then
            Print( "#E  AGR.Test.StdTomLib:\n",
                   "#E  ", gapname,
                   ": script component 'fail' in TomLib standardization\n" );
          else
            # Compare the available ATLAS generators
            # with this TomLib standardization.
            for gens in allgens do
              gens:= AtlasGenerators( gens.identifier );
              G2:= Group( gens.generators );
              fitstotom:= IsStandardGeneratorsOfGroup( info, G2,
                              gens.generators );
              fitstohom:= GroupHomomorphismByImages( G, G2,
                              GeneratorsOfGroup( G ), gens.generators )
                          <> fail;
              if fitstotom <> fitstohom then
                Print( "#E  AGR.Test.StdTomLib:\n",
                       "#E  ", gapname,
                       ": IsStandardGeneratorsOfGroup and ",
                       "homom. construction for standardization ",
                       gens.standardization, " inconsistent\n" );
              fi;

              if fitstotom then
                AddSet( verified, gens.standardization );
                if IsBound( info.standardization ) then
                  if info.standardization <> gens.standardization then
                    Print( "#I  AGR.Test.StdTomLib:\n",
                           "#I  ", gapname,
                           ": TomLib standardization is ",
                           gens.standardization, " not ",
                           info.standardization, "\n" );
                    result:= false;
                  fi;
                else
                  Print( "#I  AGR.Test.StdTomLib:\n",
                         "#I  ", gapname,
                         ": TomLib standardization is ",
                         gens.standardization, "\n" );
                fi;
              else
                AddSet( falsified, gens.standardization );
                if IsBound( info.standardization ) and
                   info.standardization = gens.standardization then
                  Print( "#E  AGR.Test.StdTomLib:\n",
                         "#E  ", gapname,
                         ": TomLib standardization is not ",
                         info.standardization, "\n" );
                fi;
              fi;
            od;
          fi;
        od;

        # Now 'verified' and 'falsified' are the lists of standardizations
        # that hold or do not hold, respectively, for the generators of 'G'.
        if IsEmpty( info ) then
            Print( "#I  AGR.Test.StdTomLib:\n",
                   "#I  ", gapname, ": add TomLib info!\n" );
        fi;

        if IsSubset( falsified, stdavail ) and
           ForAny( info, r -> r.ATLAS <> false ) then
          Print( "#E  AGR.Test.StdTomLib:\n",
                 "#E  ", gapname,
                 ": TomLib standardization info must be ATLAS = \"N\"\n" );
        fi;

        if ( not IsSubset( falsified, stdavail ) ) and
           ForAny( info, r -> r.ATLAS = false ) then
          Print( "#E  AGR.Test.StdTomLib:\n",
                 "#E  ", gapname,
                 ": cannot verify TomLib info ATLAS = \"N\"\n" );
        fi;

      fi;

    fi;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.Files( [<tocid>[, <gapname>]] )
##
##  <#GAPDoc Label="test:AGR.Test.Files">
##  <Mark><C>AGR.Test.Files( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether the &MeatAxe; text files that belong to <M>tocid</M>
##    can be read with <Ref Func="ScanMeatAxeFile"/> such that the result
##    is not <K>fail</K>.
##    The function does not check whether the first line of a &MeatAxe; text
##    file is consistent with the filename, since this can be tested with
##    <C>AGR.Test.FileHeaders</C>.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.Files:= function( arg )
    local result, entry, name, toc, record, type;

    # Initialize the result.
    result:= true;

    if IsEmpty( arg ) then
      result:= AGR.Test.Files( "core" );
    elif Length( arg ) = 1 then
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.Files( arg[1], entry[1] ) and result;
      od;
    elif Length( arg ) = 2 then
      name:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                    x -> x[1] = arg[2] );
      if name = fail then
        return result;
      fi;
      name:= name[2];
      for toc in AGR.TablesOfContents( [ arg[1], "local" ] ) do
        if IsBound( toc.( name ) ) then
          record:= toc.( name );
          for type in AGR.DataTypes( "rep" ) do
            if IsBound( record.( type[1] ) ) then
              for entry in record.( type[1] ) do
                result:= type[2].TestFiles( arg[1], name, entry, type )
                         and result;
              od;
            fi;
          od;
        fi;
      od;
    fi;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.ClassScripts( [<tocid>[, <gapname>]] )
##
##  <#GAPDoc Label="test:AGR.Test.ClassScripts">
##  <Mark><C>AGR.Test.ClassScripts( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether the straight line programs that belong to <M>tocid</M>
##    and that compute representatives of certain conjugacy classes
##    are consistent with information stored on the &GAP; character table
##    of the group in question, in the sense that
##    the given class names really occur in the character table and that
##    the element orders and centralizer orders for the classes are correct.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.ClassScripts:= function( arg )
    local result, maxdeg, entry, tocid, gapname, groupname, toc, record,
          std, name, prg, tbl, outputs, ident, classnames, map, gens, roots,
          grp, reps, orders1, orders2, cents1, cents2, cycscript;

    # Initialize the result.
    result:= true;
    maxdeg:= AGR.Test.MaxTestDegree;

    if IsEmpty( arg ) then
      return AGR.Test.ClassScripts( "core" );
    elif Length( arg ) = 1 and IsString( arg[1] ) then
      # The argument is an identifier of an extension.
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.ClassScripts( arg[1], entry[1] ) and result;
      od;
      return result;
    elif Length( arg ) = 2 and IsString( arg[1] ) and IsString( arg[2] ) then
      # The arguments are an identifier and a group name.
      tocid:= arg[1];
      gapname:= arg[2];
    else
      Error( "usage: AGR.Test.ClassScripts( [<tocid>[, <groupname>]] )" );
    fi;

    groupname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> pair[1] = gapname );
    if groupname = fail then
      Print( "#E  AGR.Test.ClassScripts:\n",
             "#E  no group with name '", gapname, "'\n" );
      return false;
    fi;
    groupname:= groupname[2];
    for toc in AGR.TablesOfContents( [ tocid, "local" ] ) do
      if IsBound( toc.( groupname ) ) then
        record:= toc.( groupname );
        for name in [ "cyclic", "classes", "cyc2ccl" ] do
          if IsBound( record.( name ) ) then
            for std in Set( List( record.( name ), x -> x[1] ) ) do

              prg:= AtlasProgram( gapname, std, name );
              if prg = fail then
                Print( "#E  AGR.Test.ClassScripts:\n",
                       "#E  inconsistent program '", name, "' for '",
                       gapname, "'\n" );
                result:= false;
              else

                # Fetch the character table of the group.
                # (No further tests are possible if it is not available.)
                tbl:= CharacterTable( gapname );
                if tbl <> fail then

                  ident:= prg.identifier[2];
                  classnames:= AtlasClassNames( tbl );
                  if classnames <> fail then
                    if IsBound( prg.outputs ) then
                      outputs:= prg.outputs;
                      map:= List( outputs, x -> Position( classnames, x ) );
                    else
                      Print( "#E  AGR.Test.ClassScripts:\n",
                             "#E  no component 'outputs' in '", name,
                             "' for '", gapname, "'\n" );
                      result:= false;
                      outputs:= [ "-" ];
                      map:= [ fail ];
                    fi;
                    prg:= prg.program;

                    # (If '-' signs occur then we cannot test the names,
                    # but the number of outputs can be checked.)
                    roots:= ClassRoots( tbl );
                    roots:= Filtered( [ 1 .. Length( roots ) ],
                                      i -> IsEmpty( roots[i] ) );
                    roots:= Set( List( roots, x -> ClassOrbit( tbl, x ) ) );

                    if ForAll( outputs, x -> not '-' in x ) then

                      # Check the class names.
                      if fail in map then
                        Print( "#E  AGR.Test.ClassScripts:\n",
                               "#E  strange class names ",
                               Difference( outputs, classnames ),
                               " for program ", ident, "\n" );
                        result:= false;
                      fi;
                      if     name in [ "classes", "cyc2ccl" ]
                         and Set( classnames ) <> Set( outputs ) then
                        Print( "#E  AGR.Test.ClassScripts:\n",
                               "#E  class names ",
                               Difference( classnames, outputs ),
                               " not hit for program ", ident, "\n" );
                        result:= false;
                      fi;
                      if name = "cyclic" then
                        # Check whether all maximally cyclic subgroups
                        # are covered.
                        roots:= Filtered( roots,
                                   list -> IsEmpty( Intersection( outputs,
                                               classnames{ list } ) ) );
                        if not IsEmpty( roots ) then
                          Print( "#E  AGR.Test.ClassScripts:\n",
                                 "#E  maximally cyclic subgroups ",
                                 List( roots, x -> classnames{ x } ),
                                 " not hit for program ", ident, "\n" );
                          result:= false;
                        fi;
                      fi;

                    elif name = "cyclic" and
                         Length( outputs ) <> Length( roots ) and
                         not ForAny( outputs, x -> '-' in x ) then
                      # The programs 'F23G1-cycW1' and 'F24G1-cycW1'
                      # specify some elements only up to Galois conjugacy.
                      Print( "#E  AGR.Test.ClassScripts:\n",
                             "#E  no. of outputs and cyclic subgroups differ",
                             " for program '", ident, "'\n" );
                      result:= false;
                    fi;

                    if not fail in map then

                      # Compute the representatives in a representation.
                      # (No further tests are possible if none is available.)
                      gens:= OneAtlasGeneratingSetInfo( gapname, std,
                                 NrMovedPoints, [ 2 .. maxdeg ],
                                 "contents", [ tocid, "local" ] );
                      if gens <> fail then

                        gens:= AtlasGenerators( gens.identifier );
                        if gens <> fail then
                          gens:= gens.generators;
                        fi;
                        if fail in gens then
                          gens:= fail;
                        fi;

                        if not name in [ "cyclic", "classes" ] then

                          # The input consists of the images of the standard
                          # generators under the 'cyc' script (which may belong
                          # to a different t.o.c.).
                          cycscript:= AtlasProgram( gapname, std, "cyclic",
                              "version", AGR.VersionOfSLP( ident )[1],
                              "contents", [ tocid, "local" ] );
                          if cycscript = fail then
                            gens:= fail;
                            Print( "#E  AGR.Test.ClassScripts:\n",
                                   "#E  no script for computing the 'cyc' ",
                                   "part of '", ident, "' available\n" );
                            result:= false;
                          elif gens <> fail then
                            gens:= ResultOfStraightLineProgram(
                                       cycscript.program, gens );
                          fi;
                        fi;

                      fi;

                      if gens <> fail then

                        grp:= Group( gens );
                        reps:= ResultOfStraightLineProgram( prg, gens );

                        if Length( reps ) <> Length( outputs ) then
                          Print( "#E  AGR.Test.ClassScripts:\n",
                                 "#E  inconsistent output numbers for ",
                                 "program ", ident, "\n" );
                          result:= false;
                        else

                          # Check element orders and centralizer orders.
                          orders1:= OrdersClassRepresentatives( tbl ){ map };
                          orders2:= List( reps, Order );
                          if orders1 <> orders2 then
                            Print( "#E  AGR.Test.ClassScripts:\n",
                                   "#E  element orders of ",
                                   outputs{ Filtered( [ 1 .. Length( outputs ) ],
                                              i -> orders1[i] <> orders2[i] ) },
                                   " differ for program ", ident, "\n" );
                            result:= false;
                          fi;
                          cents1:= SizesCentralizers( tbl ){ map };
                          cents2:= List( reps, x -> Size( Centralizer(grp,x) ) );
                          if    cents1 <> cents2 then
                            Print( "#E  AGR.Test.ClassScripts:\n",
                                   "#E  centralizer orders of ",
                                   outputs{ Filtered( [ 1 .. Length( outputs ) ],
                                              i -> cents1[i] <> cents2[i] ) },
                                   " differ for program ", ident, "\n" );
                            result:= false;
                          fi;

                        fi;

                      fi;

                    fi;
                  fi;

                fi;
              fi;

            od;
          fi;
        od;
      fi;
    od;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.CycToCcls( [<tocid>[, <gapname>]] )
##
##  <#GAPDoc Label="test:AGR.Test.CycToCcls">
##  <Mark><C>AGR.Test.CycToCcls( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks whether all straight line programs that belong to <M>tocid</M>
##    and that compute class representatives from representatives of cyclic
##    subgroups possess a corresponding straight line program
##    (<E>anywhere</E> in the database)
##    for computing representatives of cyclic subgroups.
##  </Item>
##  <#/GAPDoc>
##
##    if the extend option is set then:
##    checks whether some straight line program that computes representatives
##    of conjugacy classes of a group can be computed from the ordinary
##    &GAP; character table of that group and a straight line program in
##    <M>tocid</M> that computes representatives of cyclic subgroups.
##    In this case the missing scripts are printed.
##
AGR.Test.CycToCcls:= function( arg )
    local result, triple, tocid, groupname, gapname, toc, record, entry,
          versions, prg, tbl, version, str;

    # Initialize the result.
    result:= true;

    if IsEmpty( arg ) then
      return AGR.Test.CycToCcls( "core" );
    elif Length( arg ) = 1 and IsString( arg[1] ) then
      # The argument is an identifier of an extension.
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.CycToCcls( arg[1], entry[1] ) and result;
      od;
      return result;
    elif Length( arg ) = 2 and IsString( arg[1] ) and IsString( arg[2] ) then
      # The arguments are an identifier and a group name.
      tocid:= arg[1];
      gapname:= arg[2];
    else
      Error( "usage: AGR.Test.CycToCcls( [<tocid>[, <gapname>]] )" );
    fi;

    groupname:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                       pair -> pair[1] = gapname );
    if groupname = fail then
      Print( "#E  AGR.Test.CycToCcls:\n",
             "#E  no group with name '", gapname, "'\n" );
      return false;
    fi;
    groupname:= groupname[2];
    for toc in AGR.TablesOfContents( tocid ) do
      if not IsBound( toc.( groupname ) ) then
        return true;
      fi;
      record:= toc.( groupname );

      # Run over the 'cyc2ccl' scripts that are available in this t.o.c,
      # and check whether *some t.o.c.* provides the corresponding 'cyc' script.
      if IsBound( record.cyc2ccl ) then
        for entry in record.cyc2ccl do
          versions:= AGR.VersionOfSLP( entry[2] );
          prg:= AtlasProgramInfo( gapname, "cyclic", "version", versions[1] );
          if prg = fail then
            Print( "#E  AGR.Test.CycToCcls:\n",
                   "#E  no program '\"",
                   ReplacedString( entry[2]{
                                       [ 1 .. Position( entry[2], '-' )-1 ] },
                                   "cyc", "-cyc" ), "\"' available\n" );
            result:= false;
          fi;
        od;
      fi;

      if ValueOption( "TryToExtendData" ) <> true then
        return result;
      fi;

      # Check whether the current t.o.c. contains a 'cyc' script for which
      # no 'cyc2ccl' script is available in *any t.o.c.* but for which such a
      # script can be computed.
      # (This is possible only if we have the character table of the group.)
      tbl:= CharacterTable( gapname );
      if tbl <> fail and IsBound( record.cyclic ) then
        for entry in record.cyclic do
          version:= AGR.VersionOfSLP( entry[2] );
          prg:= AtlasProgram( gapname, "cyc2ccl", version,
                              "contents", "local" );
          if prg = fail then
            # There is no 'cyc2ccl' script but perhaps we can create it.
            prg:= AtlasProgram( gapname, "cyclic", version,
                                "contents", "local" );
            if prg = fail then
              Print( "#E  AGR.Test.CycToCcls:\n",
                     "#E  cannot access program '\"", entry[2], "\"\n" );
              result:= false;
            else
              str:= StringOfAtlasProgramCycToCcls(
                        AtlasStringOfProgram( prg.program, prg.outputs ),
                        tbl, "names" );
              if str <> fail then
                prg:= ScanStraightLineProgram( str, "string" );
                if prg = fail then
                  Print( "#E  AGR.Test.CycToCcls:\n",
                         "#E  automatically created cyc2ccl script for '",
                         entry[2], "' would be incorrect" );
                  result:= false;
                else
                  prg:= prg.program;
                  Print( "#I  AGR.Test.CycToCcls:\n",
                         "#I  add the following script, in the new file '",
                         ReplacedString( entry[2], "-", "" ), "-cclsW1':\n",
                         str, "\n" );
                fi;
              fi;
            fi;
          fi;
        od;
      fi;
    od;

    # Return the result.
    return result;
    end;


#############################################################################
##
#F  AGR.Test.GroupOrders( [true] )
##
##  <#GAPDoc Label="test:AGR.Test.GroupOrders">
##  <Mark><C>AGR.Test.GroupOrders()</C></Mark>
##  <Item>
##    checks whether the group orders stored in the <C>GAPnames</C> component
##    of <Ref Var="AtlasOfGroupRepresentationsInfo"/> coincide with the
##    group orders computed from an &ATLAS; permutation representation of
##    degree up to <C>AGR.Test.MaxTestDegree</C>,
##    from the available character table or table of marks with the given name,
##    or from the structure of the name,
##    in the sense that splitting the name at the first dot (<C>.</C>) or
##    colon (<C>:</C>) and applying the same criteria to derive the group
##    order from the two parts may yield enough information.
##  </Item>
##  <#/GAPDoc>
##
AGR.SizeExceptional2E6:= q -> q^36*(q^12-1)*(q^9+1)*(q^8-1)*(q^6-1)*
                              (q^5+1)*(q^2-1) / Gcd( 3, q+1 );

AGR.SizeExceptionalE:= function( n, q )
    local data;

    if   n = 6 then
      data:= [ 36, [ 12, 9, 8, 6, 5, 2 ], Gcd( 3, q-1 ) ];
    elif n = 7 then
      data:= [ 63, [ 18, 14, 12, 10, 8, 6, 2 ], Gcd( 2, q-1 ) ];
    elif n = 8 then
      data:= [ 120, [ 30, 24, 20, 18, 14, 12, 8, 2 ], 1 ];
    else
      Error( "<n> must be one of 6, 7, 8" );
    fi;

    return q^data[1] * Product( List( data[2], i -> q^i - 1 ) ) / data[3];
end;

AGR.Test.GroupOrders:= function( arg )
    local verbose, formats, maxdeg, HasRemovableOuterBrackets, SizesFromName,
          result, entry, size;

    verbose:= ( Length( arg ) <> 0 and arg[1] = true );

    formats:= [
      [ [ "L", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> Size( PSL( l[2], l[4] ) ) ],
      [ [ "2.L", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> 2 * Size( PSL( l[2], l[4] ) ) ],
      [ [ "S", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> Size( PSp( l[2], l[4] ) ) ],
      [ [ "2.S", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> 2 * Size( PSp( l[2], l[4] ) ) ],
      [ [ "U", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> Size( PSU( l[2], l[4] ) ) ],
      [ [ "E", IsDigitChar, "(", IsDigitChar, ")" ],
        l -> AGR.SizeExceptionalE( l[2], l[4] ) ],
      [ [ "2E6(", IsDigitChar, ")" ],
        l -> AGR.SizeExceptional2E6( l[2] ) ],
    ];

    maxdeg:= AGR.Test.MaxTestDegree;

    HasRemovableOuterBrackets:= function( name )
      local len, open, i;

      len:= Length( name );
      if Length( name ) < 2 or name[1] <> '(' or name[ len ] <> ')' then
        return false;
      fi;
      open:= 0;
      for i in [ 1 .. len-1 ] do
        if name[i] = '(' then
          open:= open + 1;
        elif name[i] = ')' then
          open:= open - 1;
        fi;
        if open = 0 then
          return false;
        fi;
      od;
      return true;
    end;

    SizesFromName:= function( name )
      local result, pair, parse, tbl, tom, data, splitchar, pos,
            name1, name2, size1, size2;

      result:= [];

      # Strip outer brackets.
      while HasRemovableOuterBrackets( name ) do
        name:= name{ [ 2 .. Length( name ) - 1 ] };
      od;

      # Deal with the case of integers.
      if ForAll( name, x -> IsDigitChar( x ) or x in "^()" ) then
        # No other criterion matches with this format, so we return.
        return [ EvalString( name ) ];
      fi;

#T perhaps improve: admit also '+' and '-'
#T if ForAll( name, x -> IsDigitChar( x ) or x in "^()+-" ) then
#T   Print( "name not yet handled: ", name, "\n" );
#T fi;
      for pair in formats do
        parse:= ParseBackwards( name, pair[1] );
        if parse <> fail then
          AddSet( result, pair[2]( parse ) );
        fi;
      od;

      # Try to use the character table information.
      tbl:= CharacterTable( name );
      if tbl <> fail then
        AddSet( result, Size( tbl ) );
      fi;

      # Try to use the table of marks information.
      tom:= TableOfMarks( name );
      if tom <> fail then
        AddSet( result, Size( UnderlyingGroup( tom ) ) );
      fi;

      # Try to use the (locally available) database,
      # but only permutation representations up to degree 'maxdeg'.
      data:= OneAtlasGeneratingSetInfo( name,
                 NrMovedPoints, [ 1 .. maxdeg ],
                 "contents", "local" );
      if data <> fail then
        data:= AtlasGenerators( data );
        if data <> fail then
          AddSet( result, Size( Group( data.generators ) ) );
        fi;
      fi;

      # Try to evaluate the name structure.
      for splitchar in ".:" do
        pos:= Position( name, splitchar );
        while pos <> fail do
          name1:= name{ [ 1 .. pos-1 ] };
          name2:= name{ [ pos+1 .. Length( name ) ] };
          if Length( Positions( name1, '(' ) )
             = Length( Positions( name1, ')' ) ) then
            size1:= SizesFromName( name1 );
            size2:= SizesFromName( name2 );
            if Length( size1 ) = 1 and Length( size2 ) = 1 then
              AddSet( result, size1[1] * size2[1] );
            elif Length( size1 ) > 1 or Length( size2 ) > 1 then
              Print( "#E  AGR.Test.GroupOrders:\n",
                     "#E  group orders: problem with '", name, "'\n" );
              UniteSet( result,
                        Concatenation( List( size1, x -> x * size2 ) ) );
            fi;
          fi;
          pos:= Position( name, splitchar, pos );
        od;
      od;

      return result;
    end;

    result:= true;

    for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
      size:= SizesFromName( entry[1] );
      if 1 < Length( size ) then
        Print( "#E  AGR.Test.GroupOrders:\n",
               "#E  several group orders for '",
               entry[1], "':\n#E  ", size, "\n" );
        result:= false;
      elif not IsBound( entry[3].size ) then
        if Length( size ) = 0 then
          if verbose then
            Print( "#I  AGR.Test.GroupOrders:\n",
                   "#I  group order for '", entry[1], "' unknown\n" );
          fi;
        else
          entry[3].size:= size[1];
          Print( "#I  AGR.Test.GroupOrders:\n",
                 "#I  set group order for '", entry[1], "'\n",
                 "[\"GRS\",[\"", entry[1], "\",", size[1], "]],\n" );
        fi;
      elif Length( size ) = 0 then
        if verbose then
          Print( "#I  AGR.Test.GroupOrders:\n",
                 "#I  cannot verify group order for '", entry[1], "'\n" );
        fi;
      elif size[1] <> entry[3].size then
        Print( "#E  AGR.Test.GroupOrders:\n",
               "#E  wrong group order for '", entry[1], "'\n" );
        result:= false;
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.IsFactorFusionWhoseImageHasSameMaxes( <tbl>, <factfus> )
##
##  Let <A>tbl</A> be the character table of a group <M>G</M>, say,
##  and <A>factfus</A> be a factor fusion record from <A>tbl</A>.
##  Let <M>F</M> denote the factor group of <M>G</M> whose character table
##  is given by <A>factfus</A><C>.name</C>.
##  If we can show that the maximal subgroups of <M>F</M> are exactly the
##  images of the maximal subgroups of <M>G</M> under the epimorphism from
##  <M>G</M> to <M>F</M> then this function returns <K>true</K>,
##  otherwise <K>fail</K>.
##  <P/>
##  The function is used to deduce the orders of maximal subgroups from those
##  of suitable factor groups.
##  <P/>
##  The following idea is applied:
##  If <M>K</M> is a normal subgroup in <M>G</M> such that <M>K</M>
##  is contained in the Frattini subgroup <M>\Phi(G)</M> of <M>G</M>
##  (i. e., contained in <E>any</E> maximal subgroup of <M>G</M>)
##  then the maximal subgroups of <M>G</M> are exactly the preimages of the
##  maximal subgroups of <M>G/K</M> under the natural epimorphism.
##  <P/>
##  This situation occurs in the following cases.
##  <List>
##  <Item>
##    If <M>G</M> is perfect then <M>Z(G)</M> is contained in <M>\Phi(G)</M>
##    because <M>G' \cap Z(G) \leq \Phi(G)</M> holds,
##    by <Cite Key="Hup67" SubKey="Kap. III, §3, Satz 3.12)"/>.
##    For example, the orders of the maximal subgroups of <M>3.A_6</M> are
##    the orders of the maximal subgroups of <M>A_6</M>,
##    multiplied by the factor three.
##  </Item>
##  <Item>
##    If <M>G</M> is an upward extension of a perfect group <M>N</M>
##    then <M>Z(N)</M> is contained in <M>\Phi(N)</M>,
##    and since <M>\Phi(N) \leq \Phi(G)</M> holds for any normal subgroup
##    <M>N</M> of <M>G</M>
##    (see <Cite Key="Hup67" SubKey="Kap. III, §3, Hilfssatz 3.3 b)"/>),
##    we get that <M>Z(N)</M> is contained in <M>\Phi(G)</M>.
##    For example the orders of the maximal subgroups of <M>3.A_6.2_1</M> are
##    the orders of the maximal subgroups of <M>A_6.2_1</M>,
##    multiplied by the factor three.
##  </Item>
##  </List>
##
AGR.IsFactorFusionWhoseImageHasSameMaxes:= function( tbl, factfus )
    local ker, nam, subtbl, subfus, subker;

    # Compute the kernel <M>K</M> of the epimorphism.
    ker:= ClassPositionsOfKernel( factfus.map );
    if Length( ker ) = 1 then
      # This is not a factor fusion.
      return fail;
    elif not IsSubset( ClassPositionsOfDerivedSubgroup( tbl ), ker ) then
      # We have no criterion for this case.
      return fail;
    elif IsSubset( ClassPositionsOfCentre( tbl ), ker ) then
      # We have <M>K \leq G' \cap Z(G)</M>,
      # so the maximal subgroups are exactly the preimages of the
      # maximal subgroups in the factor group.
      return true;
    fi;

    # Look for a suitable normal subgroup <M>N</M> of <M>G</M>.
    for nam in NamesOfFusionSources( tbl ) do
      subtbl:= CharacterTable( nam );
      if subtbl <> fail then
        subfus:= GetFusionMap( subtbl, tbl );
        if Size( subtbl ) = Sum( SizesConjugacyClasses( tbl ){
                                   Set( subfus ) } ) and
           IsSubset( subfus, ker ) then
          # <M>N</M> is normal in <M>G</M>, with <M>K \leq N</M>
          subker:= Filtered( [ 1 .. Length( subfus ) ],
                             i -> subfus[i] in ker );
          if IsSubset( ClassPositionsOfDerivedSubgroup( subtbl ),
                     subker ) and
             IsSubset( ClassPositionsOfCentre( subtbl ), subker ) then
            # We have <M>K \leq N' \cap Z(N)</M>.
            return true;
          fi;
        fi;
      fi;
    od;

    return fail;
    end;


#############################################################################
##
#F  AGR.Test.MaxesOrders( [<tocid>,[ <entry>][,][<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.MaxesOrders">
##  <Mark><C>AGR.Test.MaxesOrders( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether the orders of maximal subgroups stored in the component
##    <C>GAPnames</C> of <Ref Var="AtlasOfGroupRepresentationsInfo"/>
##    coincide with the orders computed from the restriction of an &ATLAS;
##    permutation representation of degree up to
##    <C>AGR.Test.MaxTestDegree</C>
##    (using a straight line program that belongs to <M>tocid</M>),
##    from the character table, or the table of marks with the given name,
##    or from the information about maximal subgroups of the factor group
##    modulo a normal subgroup that is contained in the Frattini subgroup.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.MaxesOrders:= function( arg )
    local verbose, tocid, result, toc, extend, maxdeg, maxmax,
          MaxesInfoForName, entry, info, size, filt;

    verbose:= ( Length( arg ) <> 0 and arg[ Length( arg ) ] = true );
    tocid:= First( arg, IsString );
    if tocid = fail then
      tocid:= "core";
    fi;
    result:= true;
    toc:= AGR.TablesOfContents( [ tocid, "local" ] );
    if toc = fail then
      return result;
    fi;
    toc:= toc[1];

    extend:= ( ValueOption( "TryToExtendData" ) = true );

    maxdeg:= AGR.Test.MaxTestDegree;
    maxmax:= AGR.Test.HardCases.MaxNumberMaxes;

    MaxesInfoForName:= function( name )
      local result, nrmaxes, tbl, oneresult, i,
            subtbl, tom, std, g, prg, gens, factfus, recurs, good;

      result:= [];
      nrmaxes:= [];

      # Try to use the character table information.
      tbl:= CharacterTable( name );
      if tbl <> fail then
        if HasMaxes( tbl ) then
          AddSet( nrmaxes, Length( Maxes( tbl ) ) );
          AddSet( result, List( Maxes( tbl ),
                                 nam -> Size( CharacterTable( nam ) ) ) );
        else
          # Try whether individual maxes are supported.
          oneresult:= [];
          if tbl <> fail then
            for i in [ 1 .. maxmax ] do
              subtbl:= CharacterTable( Concatenation( Identifier( tbl ), "M",
                                                      String( i ) ) );
              if subtbl <> fail then
                oneresult[i]:= Size( subtbl );
              fi;
            od;
          fi;
          if not IsEmpty( oneresult ) then
            AddSet( result, oneresult );
          fi;
        fi;
      fi;

      # Try to use the table of marks information.
# more tests: how to identify FusionsToLibTom( tom )?
      tom:= TableOfMarks( name );
      if tom <> fail then
        AddSet( nrmaxes, Length( MaximalSubgroupsTom( tom )[1] ) );
        AddSet( result, Reversed( SortedList( OrdersTom( tom ){
                             MaximalSubgroupsTom( tom )[1] } ) ) );
      fi;

      # Try to use the AtlasRep database.
      for std in [ 1 .. AGR.Test.HardCases.MaxNumberStd ] do
        g:= AtlasGroup( name, std, "contents", "local" );
        if ( g <> fail ) and
           ( ( HasSize( g ) and Size( g ) < 10^7 ) or
             ( IsPermGroup( g ) and NrMovedPoints( g ) <= maxdeg ) ) then
          oneresult:= [];
          for i in [ 1 .. maxmax ] do
            if extend then
              prg:= AtlasProgram( name, std, "maxes", i, "contents", "local" );
            else
              prg:= AtlasProgram( name, std, "maxes", i,
                                  "contents", [ tocid, "local" ] );
            fi;
            if prg <> fail then
              gens:= ResultOfStraightLineProgram( prg.program,
                                                  GeneratorsOfGroup( g ) );
              if verbose then
                Print( "#I  AGR.Test.MaxesOrders:\n",
                       "#I  computing max. ", i, " for ", name, "\n" );
              fi;
              oneresult[i]:= Size( SubgroupNC( g, gens ) );
            fi;
          od;
          if not IsEmpty( oneresult ) then
            AddSet( result, oneresult );
          fi;
        fi;
      od;

      # Try to deduce the orders of maximal subgroups from those of factors.
      if tbl <> fail then
        for factfus in ComputedClassFusions( tbl ) do
          if AGR.IsFactorFusionWhoseImageHasSameMaxes( tbl, factfus ) = true
             then
            recurs:= MaxesInfoForName( factfus.name );
            UniteSet( nrmaxes, recurs.nrmaxes );
            UniteSet( result,
              recurs.maxesorders * Sum( SizesConjugacyClasses( tbl ){
                  ClassPositionsOfKernel( factfus.map ) } ) );
          fi;
        od;
      fi;

      # Compact the partial results.
      good:= true;
      for oneresult in result{ [ 2 .. Length( result ) ] } do
        for i in [ 1 .. Length( oneresult ) ] do
          if   IsBound( result[1][i] ) then
            if IsBound( oneresult[i] ) then
              if result[1][i] <> oneresult[i] then
                good:= false;
              fi;
            fi;
          elif IsBound( oneresult[i] ) then
            result[1][i]:= oneresult[i];
          fi;
        od;
      od;
      if good and not IsEmpty( result ) then
        result:= [ result[1] ];
      fi;

      return rec( maxesorders:= result,
                  nrmaxes:= Set( nrmaxes ) );
    end;

    if Length( arg ) = 0 or
       ForAll( arg, x -> IsString( x ) or IsBool( x ) ) then
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.MaxesOrders( tocid, entry, verbose ) and result;
      od;
    else
      entry:= First( arg, x -> not IsBool( x ) and not IsString( x ) );
      info:= MaxesInfoForName( entry[1] );

      if not IsBound( entry[3].nrMaxes ) then
        if Length( info.nrmaxes ) = 1 then
          Print( "#I  AGR.Test.MaxesOrders:\n",
                 "#I  set maxes number for '", entry[1], "':\n",
                 "[\"MXN\",[\"", entry[1], "\",", info.nrmaxes[1], "]],\n" );
        fi;
      elif Length( info.nrmaxes ) <> 1 then
        if verbose then
          Print( "#I  AGR.Test.MaxesOrders:\n",
                 "#I  cannot verify stored maxes number for '", entry[1],
                 "'\n" );
        fi;
      fi;

      size:= info.maxesorders;
      if 1 < Length( size ) then
        Print( "#E  AGR.Test.MaxesOrders:\n",
               "#E  several maxes orders for '", entry[1], "':\n",
               "#E  ", size, "\n" );
        result:= false;
      elif not IsBound( entry[3].sizesMaxes )
           or IsEmpty( entry[3].sizesMaxes ) then
        # No maxes orders are stored yet.
        if Length( size ) = 0 then
          if IsBound( toc.( entry[2] ) ) and
             IsBound( toc.( entry[2] ).maxes ) and
             not IsEmpty( toc.( entry[2] ).maxes ) then
            # We have at least one straight line program but no repres.
            Print( "#I  AGR.Test.MaxesOrders:\n",
                   "#I  maxes orders for '", entry[1],
                   "' unknown (but slps available)\n" );
          elif verbose then
            # We have no information about maximal subgroups.
            Print( "#I  AGR.Test.MaxesOrders:\n",
                   "#I  maxes orders for '", entry[1], "' unknown\n" );
          fi;
        else
          if IsBound( entry[3].size ) then
            if entry[3].size in size[1] then
              Print( "#E  AGR.Test.MaxesOrders:\n",
                     "#E  group order in maxes orders list for '", entry[1],
                     "'\n" );
              result:= false;
            fi;
            if ForAny( size[1], x -> entry[3].size mod x <> 0 ) then
              Print( "#E  AGR.Test.MaxesOrders:\n",
                     "#E  strange subgp. order for '", entry[1], "'\n" );
              result:= false;
            fi;
          fi;
          if IsSortedList( - Compacted( size[1] ) ) then
            entry[3].sizesMaxes:= size[1];
            Print( "#I  AGR.Test.MaxesOrders:\n",
                   "#I  set maxes orders for '", entry[1], "':\n",
                   AGR.TOCLine( "MXO", entry[1], size[1], 0 ), ",\n" );
          else
            Print( "#E  AGR.Test.MaxesOrders:\n",
                   "#E  computed maxes orders for '", entry[1],
                   "' are not sorted:\n", size[1], "\n" );
          fi;
        fi;
      elif Length( size ) = 0 then
        if extend and verbose then
          Print( "#I  AGR.Test.MaxesOrders:\n",
                 "#I  cannot verify stored maxes orders for '", entry[1],
                 "'\n" );
        fi;
      elif not IsSortedList( - Compacted( size[1] ) ) then
        Print( "#E  AGR.Test.MaxesOrders:\n",
               "#E  computed maxes orders for '",
               entry[1], "' are not sorted:\n", size[1], "\n" );
      elif size[1] <> entry[3].sizesMaxes then
        filt:= Filtered( [ 1 .. Length( entry[3].sizesMaxes ) ],
                         i -> IsBound( entry[3].sizesMaxes[i] ) and
                              IsBound( size[1][i] ) and
                              entry[3].sizesMaxes[i] <> size[1][i] );
        if filt <> [] then
          # We have contradicting values.
          Print( "#E  AGR.Test.MaxesOrders:\n",
                 "#E  computed and stored maxes orders for '", entry[1],
                 "' differ at positions ", filt, ":\n",
                 "#E  ", size[1], " vs. ", entry[3].sizesMaxes, "\n" );
          result:= false;
        elif ForAny( [ 1 .. Length( size[1] ) ],
                     i -> IsBound( size[1][i] ) and
                          not IsBound( entry[3].sizesMaxes[i] ) ) then
          # We have just extended the stored list.
          entry[3].sizesMaxes:= size[1];
          Print( "#I  AGR.Test.MaxesOrders:\n",
                 "#I  replace maxes orders for '", entry[1], "':\n",
                 AGR.TOCLine( "MXO", entry[1], size[1], 0 ), ",\n" );
        fi;
      fi;
    fi;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.MaxesStructure( [<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.MaxesStructure">
##  <Mark><C>AGR.Test.MaxesStructure()</C></Mark>
##  <Item>
##    checks whether the names of maximal subgroups stored in the component
##    <C>GAPnames</C> of <Ref Var="AtlasOfGroupRepresentationsInfo"/>
##    coincide with the names computed from the &GAP; character table with
##    the given name.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.MaxesStructure:= function( arg )
    local verbose, maxdeg, maxmax, MaxesInfoForName, result, toc, entry,
          info, size, struct;

    verbose:= ( Length( arg ) <> 0 and arg[1] = true );
    maxdeg:= AGR.Test.MaxTestDegree;
    maxmax:= AGR.Test.HardCases.MaxNumberMaxes;

    MaxesInfoForName:= function( name )
      local result, tbl, oneresult, i, relname, subtbl, prefix, good;

      result:= [];

      # Try to use the character table information.
      tbl:= CharacterTable( name );
      if tbl <> fail then
        if HasMaxes( tbl ) then
          AddSet( result,
              List( Maxes( tbl ), StructureDescriptionCharacterTableName ) );
        else
          # Check whether individual maxes are supported.
          oneresult:= [];
          if tbl <> fail then
            for i in [ 1 .. maxmax ] do
              relname:= Concatenation( Identifier( tbl ), "M", String( i ) );
              subtbl:= CharacterTable( relname );
              if subtbl <> fail then
                oneresult[i]:= StructureDescriptionCharacterTableName(
                                   Identifier( subtbl ) );
              fi;
            od;
          fi;
          if not IsEmpty( oneresult ) then
            AddSet( result, oneresult );
          fi;
        fi;
      fi;

      # Make sure that no relative names appear in the output.
      for oneresult in result do
        for relname in oneresult do
          i:= ParseBackwards( relname, [ IsChar, "M", IsDigitChar ] );
          if i <> fail then
            # Exclude all cases where Mathieu groups are on the top.
            # (Currently there are a few tables with weird names.)
            prefix:= i[1];
            if prefix <> [] and not prefix[ Length( prefix ) ] in ".:x"
               and not relname in
                  [ "2^10:3M22", "2^11.3M22", "2x3^6:2M12", "3^6:2M12" ] then
#T Is there a chance to get rid of these table identifiers?
#T -> insert a dot before the M!
#T -> would be better for the well-definedness of relative names
#T    (assuming that a dot cannot be the last character in a name!)
              Print( "#E  AGR.Test.MaxesStructure:\n",
                     "#E  provide structure descr. for rel. name '", relname,
                     "'\n" );
            fi;
          fi;
        od;
      od;

      # Compact the partial results.
      good:= true;
      for oneresult in result{ [ 2 .. Length( result ) ] } do
        for i in [ 1 .. Length( oneresult ) ] do
          if   IsBound( result[1][i] ) then
            if IsBound( oneresult[i] ) then
              if result[1][i] <> oneresult[i] then
                good:= false;
              fi;
            fi;
          elif IsBound( oneresult[i] ) then
            result[1][i]:= oneresult[i];
          fi;
        od;
      od;
      if good and not IsEmpty( result ) then
        result:= [ result[1] ];
      fi;

      return rec( maxesstructure:= result );
    end;

    result:= true;
    toc:= AtlasOfGroupRepresentationsInfo.TableOfContents.core;

    for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
      info:= MaxesInfoForName( entry[1] );
      struct:= info.maxesstructure;
      if 1 < Length( struct ) then
        Print( "#E  AGR.Test.MaxesStructure:\n",
               "#E  several maxes structures for '", entry[1], "':\n",
               "#E  ", struct, "\n" );
        result:= false;
      elif not IsBound( entry[3].structureMaxes ) then
        # No maxes structures are stored yet.
        if Length( struct ) = 0 then
          if verbose or ( IsBound( toc.( entry[2] ) ) and
                          IsBound( toc.( entry[2] ).maxes ) and
                          not IsEmpty( toc.( entry[2] ).maxes ) ) then
            Print( "#I  AGR.Test.MaxesStructure:\n",
                   "#I  maxes structures for '", entry[1], "' unknown\n" );
          fi;
        elif Length( struct ) = 1 then
          Print( "#I  AGR.Test.MaxesStructure:\n",
                 "#I  set maxes structures for '", entry[1], "':\n",
                 AGR.TOCLine( "MXS", entry[1], struct[1], "" ), ",\n" );
        fi;
      elif Length( struct ) = 0 then
        if verbose then
          Print( "#I  AGR.Test.MaxesStructure:\n",
                 "#I  cannot verify stored maxes structures for '", entry[1],
                 "'\n" );
        fi;
      elif struct[1] <> entry[3].structureMaxes then
        if ForAll( [ 1 .. Length( entry[3].structureMaxes ) ],
                   i -> ( not IsBound( entry[3].structureMaxes[i] ) ) or
                        ( IsBound( struct[1][i] ) and
                          entry[3].structureMaxes[i] = struct[1][i] ) ) then
          # New maximal subgroups were identified.
          Print( "#I  AGR.Test.MaxesStructure:\n",
                 "#I  replace maxes structures for '", entry[1], "':\n",
                 AGR.TOCLine( "MXS", entry[1], struct[1], "" ), ",\n" );
        else
          # There is really a contradiction.
          Print( "#E  AGR.Test.MaxesStructure:\n",
                 "#E  computed and stored maxes structures for '", entry[1],
                 "' differ:\n",
                 "#E  ", struct[1], " vs. ", entry[3].structureMaxes, "\n" );
          result:= false;
        fi;
      fi;

    od;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.StdCompatibility( [<tocid>[, <entry>]][,][ <verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.StdCompatibility">
##  <Mark><C>AGR.Test.StdCompatibility( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks whether the information about the compatibility of
##    standard generators of a group and its factor groups that is stored in
##    the <C>GAPnames</C> component of
##    <Ref Var="AtlasOfGroupRepresentationsInfo"/>
##    and belongs to <M>tocid</M> coincides with computed values.
##    <P/>
##    The following criterion is used for computing the value for a group
##    <M>G</M>.
##    Use the &GAP; Character Table Library to determine factor groups
##    <M>F</M> of <M>G</M> for which standard generators are defined and
##    moreover a presentation in terms of these standard generators is known.
##    Evaluate the relators of the presentation in the standard generators of
##    <M>G</M>, and let <M>N</M> be the normal closure of these elements in
##    <M>G</M>.
##    Then mapping the standard generators of <M>F</M> to the <M>N</M>-cosets
##    of the standard generators of <M>G</M> is an epimorphism.
##    If <M>|G/N| = |F|</M> holds then <M>G/N</M> and <M>F</M> are
##    isomorphic, and the standard generators of <M>G</M> and <M>F</M> are
##    compatible in the sense that mapping the standard generators of
##    <M>G</M> to their <M>N</M>-cosets yields standard generators of
##    <M>F</M>.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.StdCompatibility:= function( arg )
    local verbose, tocid, extend, maxstd, result, CompInfoForEntry, entry,
          info, filt, diff, l;

    if Length( arg ) <> 0 and arg[ Length( arg ) ] = true then
      verbose:= true;
      Remove( arg );
    else
      verbose:= false;
    fi;

    if Length( arg ) = 0 then
      # Note that the 'factorCompatibility' entries for core data
      # have the fifth entry "core".
      tocid:= "core";
    elif IsString( arg[1] ) then
      tocid:= arg[1];
      arg:= arg{ [ 2 .. Length( arg ) ] };
    else
      tocid:= "core";
    fi;

    extend:= ( ValueOption( "TryToExtendData" ) = true );

    maxstd:= AGR.Test.HardCases.MaxNumberStd;
    result:= true;

    CompInfoForEntry:= function( entry )
      local result, tbl, fus, factstd, pres, std, gens, prg, res, ker,
            facttbl, G, F, hom;

      result:= [];
      tbl:= CharacterTable( entry[1] );
      if tbl <> fail then
        for fus in ComputedClassFusions( tbl ) do
          if 1 < Length( ClassPositionsOfKernel( fus.map ) ) then
            if AGR.InfoForName( fus.name ) <> fail and
               ( extend or ForAny( entry[3].factorCompatibility,
                                   x -> x[2] = fus.name and x[5] = tocid ) ) then
              for factstd in [ 1 .. maxstd ] do
                pres:= AtlasProgram( fus.name, factstd, "presentation",
                                     "contents", "local" );
                if pres <> fail then
                  if verbose then
                    Print( "#I  AGR.Test.StdCompatibility:\n",
                           "#I  have pres. for factor group '",
                           fus.name, "' (std. ", factstd, ")\n" );
                  fi;

                  # The two sets of generators are compatible iff the
                  # relators in terms of the generators of the big group
                  # generate the kernel of the epimorphism.
                  for std in [ 0 .. maxstd ] do
                    gens:= AtlasGroup( entry[1], std,
                                       "contents", "local" );
                    if gens <> fail then
                      prg:= StraightLineProgramFromStraightLineDecision(
                                pres.program );
                      res:= ResultOfStraightLineProgram( prg,
                                GeneratorsOfGroup( gens ) );
                      ker:= Group( res );
                      # 'ker' is assumed to be a very small group.
                      if Size( tbl ) / Size( CharacterTable( fus.name ) )
                         = Size( ker ) then
                        Add( result,
                             [ std, fus.name, factstd, true, tocid ] );
                      else
                        Add( result,
                             [ std, fus.name, factstd, false, tocid ] );
                      fi;
                    fi;
                  od;
                else
                  if verbose then
                    Print( "#I  AGR.Test.StdCompatibility:\n",
                           "#I  no pres. for factor group '",
                           fus.name, "' (std. ", factstd, ")\n" );
                  fi;
                  # Try to form the homomorphism object in GAP,
                  # by mapping generators of the big group to generators
                  # of the factor group.
                  # If this defines a homomorphism and if this is surjective
                  # then the generators are compatible.
                  facttbl:= CharacterTable( fus.name );
                  if ClassPositionsOfFittingSubgroup( facttbl ) = [1] then
                    for std in [ 0 .. maxstd ] do
                      # Currently classes scripts are available only
                      # for these tables, so other cases
                      # are not really interesting at the moment.
                      G:= AtlasGroup( entry[1], std, IsPermGroup, true,
                                      "contents", "local" );
                      F:= AtlasGroup( fus.name, factstd, IsPermGroup, true,
                                      "contents", "local" );
                      if G <> fail and F <> fail then
                        if NrMovedPoints( G ) <= AGR.Test.MaxTestDegree and
                           NrMovedPoints( F ) <= AGR.Test.MaxTestDegree then
                          if verbose then
                            Print( "#I  AGR.Test.StdCompatibility:\n",
                                   "#I  trying hom. ", entry[1], " ->> ",
                                   fus.name, "\n" );
                          fi;
                          hom:= GroupHomomorphismByImages( G, F,
                                    GeneratorsOfGroup( G ),
                                    GeneratorsOfGroup( F ) );
                          if hom <> fail then
                            Add( result,
                                 [ std, fus.name, factstd, true, tocid ] );
                          else
                            Add( result,
                                 [ std, fus.name, factstd, false, tocid ] );
                          fi;
                        elif verbose then
                          Print( "#I  AGR.Test.StdCompatibility:\n",
                                 "#I  omit hom. ", entry[1], " ->> ",
                                 fus.name, ", too many points ...\n" );
                        fi;
                      elif std = 1 and factstd = 1 and verbose then
                        # Typically, G has only repres. of std. 0.
                        Print( "#I  AGR.Test.StdCompatibility:\n",
                               "#I  no hom. ", entry[1], " ->> ",
                               fus.name, " to try?\n" );
                      fi;
                    od;
                  fi;
                fi;
              od;
            fi;
          fi;
        od;
      fi;
      return result;
    end;

    if Length( arg ) = 0 then
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.StdCompatibility( tocid, entry, verbose )
                 and result;
      od;
    else
      entry:= arg[1];
      if verbose then
        Print( "#I  AGR.Test.StdCompatibility:\n",
               "#I  called for ", entry[1], "\n" );
      fi;
      if not IsBound( entry[3].factorCompatibility ) then
        entry[3].factorCompatibility:= [];
      fi;
      info:= CompInfoForEntry( entry );
      filt:= entry[3].factorCompatibility;
      if not extend then
        filt:= Filtered( filt, x -> x[5] = tocid );
      fi;
      diff:= Difference( info, filt );
      if diff <> [] then
        Print( "#I  AGR.Test.StdCompatibility:\n",
               "#I  add compatibility info:\n" );
        for l in diff do
          Print( "[\"STDCOMP\",[\"", entry[1], "\",",
                 Filtered( String( l{ [ 1 .. 4 ] } ), x -> x <> ' ' ),
                 "]],\n" );
        od;
      fi;
      for l in Difference( filt, info ) do
        Print( "#I  AGR.Test.StdCompatibility:\n",
               "#I  cannot verify compatibility info \n",
               "#I  '", l, "' for '", entry[1], "'\n" );
      od;

      if ForAny( entry[3].factorCompatibility, l1 -> ForAny( info,
           l2 -> l1{[1..3]} = l2{[1..3]} and ( l1[4] <> l2[4] ) ) ) then
        Print( "#E  AGR.Test.StdCompatibility:\n",
               "#E  contradiction of compatibility info for '",
               entry[1], "'\n" );
        result:= false;
      fi;
    fi;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.CompatibleMaxes( [<tocid>[, <entry>]][,][ <verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.CompatibleMaxes">
##  <Mark><C>AGR.Test.CompatibleMaxes( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks whether the information about deriving straight line programs
##    for restricting to subgroups from straight line programs that belong
##    to a factor group coincide with computed values.
##    <P/>
##    The following criterion is used for computing the value for a group
##    <M>G</M>.
##    If <M>F</M> is a factor group of <M>G</M> such that the standard
##    generators of <M>G</M> and <M>F</M> are compatible
##    (see the test function <C>AGR.Test.StdCompatibility</C>)
##    and if there are a presentation for <M>F</M> and a permutation
##    representation of <M>G</M> then it is checked whether the
##    <C>"maxes"</C> type straight line programs for <M>F</M> can be used to
##    compute generators for the maximal subgroups of <M>G</M>;
##    if not then generators of the kernel of the natural epimorphism from
##    <M>G</M> to <M>F</M>, must be added.
##  </Item>
##  <#/GAPDoc>
##
##  If the global option 'TryToExtendData' has the value 'true' then
##  the function also tries to compute compatibility information
##  (independent of <M>tocid</M>)
##  which is not yet stored.
##
AGR.Test.CompatibleMaxes:= function( arg )
    local verbose, extend, maxdeg, maxmax, maxversion, CompMaxForEntry,
          tocid, result, entry, info, stored, entry2, filename, factname,
          filt;

    if Length( arg ) <> 0 and arg[ Length( arg ) ] = true then
      verbose:= true;
      Remove( arg );
    else
      verbose:= false;
    fi;

    extend:= ( ValueOption( "TryToExtendData" ) = true );

    maxdeg:= AGR.Test.MaxTestDegree;
    maxmax:= AGR.Test.HardCases.MaxNumberMaxes;
    maxversion:= AGR.Test.HardCases.MaxNumberVersions;

    CompMaxForEntry:= function( entry, tocid )
      local result, tbl, l, factname, factstd, gens, i, v, prg, max, kerprg;

      result:= [];
      tbl:= CharacterTable( entry[1] );
      if tbl <> fail and IsBound( entry[3].sizesMaxes )
                     and IsBound( entry[3].factorCompatibility ) then
        # Maxes orders info and compatibility info are known.
        for l in Filtered( entry[3].factorCompatibility,
                           x -> x[4] = true ) do
          # Check whether the maxes of the two groups are in bijection.
          factname:= l[2];
          factstd:= l[3];
          if ForAny( ComputedClassFusions( tbl ),
                     fus -> fus.name = factname and
                            AGR.IsFactorFusionWhoseImageHasSameMaxes( tbl,
                                fus ) = true ) then
            gens:= AtlasGroup( entry[1], l[1],
                               NrMovedPoints, [ 1 .. maxdeg ],
                               "contents", "local" );
            if gens <> fail then
              for i in [ 1 .. maxmax ] do
                for v in [ 1 .. maxversion ] do
                  if extend then
                    prg:= AtlasProgram( factname, factstd, "maxes", i,
                                        "version", v,
                                        "contents", "local" );
                  else
                    prg:= AtlasProgram( factname, factstd, "maxes", i,
                                        "version", v,
                                        "contents", [ tocid, "local" ] );
                  fi;
                  if prg <> fail and IsBound( entry[3].sizesMaxes[i] ) and
                     ( extend or AtlasProgram( entry[1], l[1], "maxes", i,
                                               "contents", "local" )
                                 <> fail ) then
                    # try the program for the ext. gp.
                    max:= ResultOfStraightLineProgram( prg.program,
                              GeneratorsOfGroup( gens ) );
                    max:= Group( max );
                    if Size( max ) = entry[3].sizesMaxes[i] then
                      # The program for the factor group is sufficient.
                      Add( result,
                           [ entry[2], factstd, i, [ prg.identifier[2] ] ] );
                    else
                      kerprg:= AtlasProgram( entry[1], l[1],
                                             "kernel", factname,
                                             "contents", "local" );
                      if kerprg = fail then
                        # No program for computing kernel generators
                        # is available (in all table of contents).
                        Print( "#I  AGR.Test.CompatibleMaxes:\n",
                               "#I  SLP for kernel generators of ",
                               entry[1], " ->> ", factname, " missing ",
                               "\n#I  (needed for max. ", i, ")\n" );
                      else
                        max:= Group( Concatenation( GeneratorsOfGroup( max ),
                                  ResultOfStraightLineProgram( kerprg.program,
                                      GeneratorsOfGroup( gens ) ) ) );
                        if Size( max ) = entry[3].sizesMaxes[i] then
                          Add( result,
                               [ entry[2], factstd, i,
                                 [ prg.identifier[2], factname ] ] );
                        else
                          Print( "#E  AGR.Test.CompatibleMaxes:\n",
                                 "#E  max. ", i, " together with kernel of ",
                                 entry[1], " ->> ", factname,
                                 " does not fit,\n",
                                 "#E  size is ", Size( max ), " not ",
                                 entry[3].sizesMaxes[i], "\n" );
                        fi;
                      fi;
                    fi;
                  fi;
                od;
              od;
            fi;
          fi;
        od;
      fi;
      return result;
    end;

    if Length( arg ) = 0 then
      tocid:= "core";
    elif IsString( arg[1] ) then
      tocid:= arg[1];
      arg:= arg{ [ 2 .. Length( arg ) ] };
    fi;

    result:= true;

    if Length( arg ) = 0 then
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.CompatibleMaxes( tocid, entry, verbose )
                 and result;
      od;
    else
      entry:= arg[1];
      info:= CompMaxForEntry( entry, tocid );
      stored:= [];
      if IsBound( entry[3].maxext ) then
        stored:= List( entry[3].maxext,
                       x -> Concatenation( [ entry[2] ], x ) );
      fi;
      for entry2 in info do
        filename:= entry2[4][1];
        if not IsString( filename ) then
          filename:= filename[1][2];
          entry2[4][1]:= filename;
        fi;
        if Length( entry2[4] ) = 2 then
          factname:= entry2[4][2];
        else
          factname:= fail;
        fi;
        filt:= Filtered( stored,
                         x ->     x{ [ 1 .. 3 ] } = entry2{ [ 1 .. 3 ] }
                              and x[4][1] = filename );
        if IsEmpty( filt ) then
          # The entry is new.
          if factname = fail then
            # The script for restricting the repres. of the factor group
            # is good enough for the group.
            Print( "#I  AGR.Test.CompatibleMaxes:\n",
                   "#I  set entry\n[\"TOCEXT\",[\"", entry2[1],
                   "\",", entry2[2], ",", entry2[3], ",[\"",
                   filename, "\"]]],\n" );
          else
            # For restricting a repres. of the group, one needs the script
            # for the factor group plus some kernel elements.
            Print( "#I  AGR.Test.CompatibleMaxes:\n",
                   "#I  set entry\n[\"TOCEXT\",[\"", entry2[1],
                   "\",", entry2[2], ",", entry2[3], ",[\"",
                   filename, "\",\"", factname, "\"]]],\n" );
          fi;
        elif Length( entry2[4] ) <> Length( filt[1][4] ) then
          # We have already such an entry but it is different.
          Print( "#E  AGR.Test.CompatibleMaxes:\n",
                 "#E  difference ", entry2, " (new) vs. ",
                 filt[1], " (stored)\n" );
          result:= false;
        fi;
      od;
      for entry2 in stored do
        filt:= Filtered( info,
                         x ->     x{ [ 1 .. 3 ] } = entry2{ [ 1 .. 3 ] }
                              and x[4][1] = entry2[4][1] );
        if IsEmpty( filt ) and ( extend or entry2[5] = tocid ) then
          Print( "#I  AGR.Test.CompatibleMaxes:\n",
                 "#I  cannot verify stored value ", entry2, "\n" );
        fi;
      od;
    fi;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.KernelGeneratorsExtend( <entry> )
##
AGR.Test.KernelGeneratorsExtend:= function( entry )
    local tbl, factcand, bound, std, factgapname, comp,  try;

    # Compute the list of names of relevant factor tables
    # from the character table information.
    tbl:= CharacterTable( entry[1] );
    if tbl = fail then
      return true;
    fi;

    factcand:= List( Filtered( ComputedClassFusions( tbl ),
                         r -> 1 < Length( ClassPositionsOfKernel( r.map ) ) ),
                     x -> x.name );
    factcand:= Intersection( factcand, AGR.Test.FirstNames );
    if Length( factcand ) = 0 then
      return true;
    fi;

    bound:= 10^6;

    for std in [ 0 .. AGR.Test.HardCases.MaxNumberStd ] do
      if OneAtlasGeneratingSetInfo( entry[1], std ) <> fail then
        # The 'std'-th standard generators are defined.
        if not IsBound( entry[3].factorCompatibility ) then
          Print( "#I  AGR.Test.KernelGenerators for ", entry[1],
                 ":\n",
                 "#I  no 'factorCompatibility' info stored\n" );
        else
          for factgapname in factcand do
            comp:= First( entry[3].factorCompatibility,
                          x -> x[1] = std and x[2] = factgapname );
            if comp = fail then
              Print( "#I  AGR.Test.KernelGenerators for ", entry[1],
                     " (std. ", std, "):\n",
                     "#I  no 'factorCompatibility' info stored for\n",
                     "#I  ", factgapname, "\n" );
            fi;
            comp:= First( entry[3].factorCompatibility,
                          x -> x[1] = std and x[2] = factgapname and
                               x[4] = true );
            if comp <> fail and AtlasProgram( entry[1], std,
                                    "kernel", factgapname,
                                    "contents", "local" ) = fail then
              Print( "#I  AGR.Test.KernelGenerators for ", entry[1],
                     " (std. ", std, "):\n",
                     "#I  missing kernel of epim. to ", factgapname,
                     "\n" );
              try:= AtlasRepComputedKernelGenerators( entry[1], std,
                        factgapname, comp[3], bound );
              if try = fail then
                Print( "#I  AGR.Test.KernelGenerators:\n",
                       "#I  'fail' result for ", entry[1], " and ",
                       factgapname, "\n",
                       "#I  (std is ", std, "\n" );
              elif try[1] = [] then
                Print( "#I  AGR.Test.KernelGenerators:\n",
                       "#I  no kernel generators found for ", entry[1],
                       " and ", factgapname,
                       "\n#I  (std is ", std, "\n" );
              elif try[2] = true then
                Print( "#I  AGR.Test.KernelGenerators:\n",
                       "#I  kernel for ", entry[1], " and ", factgapname,
                       " (std is ", std, ",\n",
                       "#I  name is ",
                       First( AtlasOfGroupRepresentationsInfo.GAPnames,
                              l -> l[1] = entry[1] )[2],
                       "G", std, "-ker",
                       First( AtlasOfGroupRepresentationsInfo.GAPnames,
                              l -> l[1] = factgapname )[2], "W1),\n",
                       "#I  generated by ", try[1], "\n" );
              else
                Print( "#I  AGR.Test.KernelGenerators:\n",
                       "#I  kernel for ", entry[1], " and ", factgapname,
                       " (std is ", std, "),\n",
                       "#I  did not find all kernel elements ",
                       "among the first relevant ", bound, " words,\n",
                       "#I  SOME kernel generators are ", try[1], "\n" );
              fi;
            fi;
          od;
        fi;
      fi;
    od;

    return true;
    end;


#############################################################################
##
#F  AGR.Test.KernelGenerators( [<tocid>][,][<entry>][,][<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.KernelGenerators">
##  <Mark><C>AGR.Test.KernelGenerators( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks whether the straight line programs (that belong to <M>tocid</M>)
##    for computing generators of kernels of natural epimorphisms between
##    &ATLAS; groups compute generators of normal subgroups of the right
##    group orders.
##    If it is known that the given standard generators of the given group
##    are compatible with some standard generators of the factor group in
##    question (see the section about <C>AGR.Test.StdCompatibility</C>)
##    then it is also checked whether evaluating the straight line program
##    at these standard generators of the factor group yields only the
##    identity.
##    <P/>
##    Note that the verification of normal subgroups of matrix groups may
##    be <E>very</E> time and space consuming if the package
##    <Package>recog</Package> <Cite Key="recog"/> is not available.
##    <P/>
##    The function also tries to <E>find</E> words for
##    computing kernel generators of those epimorphisms for which no
##    straight line programs are stored;
##    the candidates are given by stored factor fusions between the
##    character tables from the &GAP; Character Table Library.
##  </Item>
##  <#/GAPDoc>
##
##  If the global option 'TryToExtendData' has the value 'true' then
##  the function also tries to compute kernel information
##  (*independent* of <M>tocid</M>)
##  which is not yet stored.
##
AGR.Test.KernelGenerators:= function( arg )
    local verbose, tocid, entry, result, record, list, gsize, l, factname,
          kersize, fentry,  G, prg, res, N, level, recog, comp;

    verbose:= ForAny( arg, x -> x = true );
    tocid:= First( arg, IsString );
    if tocid = fail then
      tocid:= "core";
    fi;
    entry:= First( arg, x -> IsList( x ) and not IsString( x ) );

    result:= true;

    # Compute a global list of names only once.
    if not IsBound( AGR.Test.FirstNames ) then
      AGR.Test.FirstNames:= List( Filtered( List( RecNames( AGR.GAPnamesRec ),
                                                  LibInfoCharacterTable ),
                                            IsRecord ),
                                  x -> x.firstName );
    fi;

    if entry = fail then
      # Run over the groups.
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.KernelGenerators( tocid, entry, verbose )
                 and result;
      od;
      return result;
    fi;

    # Treat one group.
    # Check that the available kernel scripts compute normal subgroups
    # of the right size.
    for record in AGR.TablesOfContents( [ tocid, "local" ] ) do
      list:= [];
      if IsBound( record.( entry[2] ) ) then
        record:= record.( entry[2] );
        if IsBound( record.kernel ) then
          list:= record.kernel;
        fi;
      fi;

      gsize:= fail;
      if IsBound( entry[3].size ) then
        gsize:= entry[3].size;
      fi;

      for l in list do
        factname:= l[2];
        kersize:= fail;
        if gsize <> fail then
          fentry:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                          x -> x[2] = factname );
          if fentry <> fail and IsBound( fentry[3].size ) then
            kersize:= gsize / fentry[3].size;
          fi;
        fi;

        G:= AtlasGroup( entry[1], l[1] );
        prg:= fail;
        if G = fail then
          Print( "#I  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                 "#I  cannot verify script ", l[3], " (no repres.)\n" );
        elif kersize = fail then
          Print( "#I  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                 "#I  do not know the order of the kernel",
                 " of the epim. to ", factname, "\n" );
        else
          prg:= AtlasProgram( entry[1], l[1], "kernel", fentry[1] );
          if prg = fail then
            Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                   "#E  cannot access script ", l[3], "\n" );
            result:= false;
          elif prg.identifier[2][1] <> [ tocid, l[3] ] then
            Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                   "#E  get script ", prg.identifier[2][1],
                   " not ", [ tocid, l[3] ], "\n" );
            result:= false;
          else
            res:= ResultOfStraightLineProgram( prg.program,
                      GeneratorsOfGroup( G ) );
            N:= Group( res );
            if not IsAbelian( N ) and
# Note that recog (up to 1.2.3) does not perform well on small (cyclic) groups.
               IsPackageMarkedForLoading( "recog", "" ) then
              # Without this approach,
              # the case "3^(1+12):2.Suz.2" seems to be hopeless.
              level:= InfoLevel( InfoRecog );
              SetInfoLevel( InfoRecog, 0 );
              recog:= RecogniseGroup( N );
              SetInfoLevel( InfoRecog, level );
              if recog = fail then
                Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                       "#E  recognition failed\n" );
                result:= false;
              elif not ForAll( GeneratorsOfGroup( G ),
                         g -> ForAll( List( res, n -> n^g ),
                                conj -> conj = ResultOfStraightLineProgram(
                                                 SLPforElement( recog, conj ),
                                                 NiceGens( recog ) ) ) ) then
                Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                       "#E  subgroup gen. by ", l[3], " is not normal\n" );
                result:= false;
              elif Size( recog ) <> kersize then
                Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                       "#E  subgroup gen. by ", l[3], " has size ",
                       Size( recog ), " not ", kersize, "\n" );
                result:= false;
              fi;
            else
              # At least the small cases can be verified.
              # Calling 'IsNormal( G, N )' for two matrix groups would result
              # in a delegation to their nice objects (why?),
              # even if the list of elements of 'N' is stored.
              # We avoid this.
              # Note that we must not create the normal subgroup with
              # 'Subgroup', otherwise the nice object of the supergroup wants
              # to be used.
              if IsAbelian( N ) then
                if not ForAll( GeneratorsOfGroup( G ),
                           g -> ForAll( res,
                                    n -> n^g in Elements( N ) ) ) then
                  Print( "#E  AGR.Test.KernelGenerators for ", entry[1],
                         ":\n",
                         "#E  subgroup gen. by ", l[3], " is not normal\n" );
                  result:= false;
                fi;
              elif not ForAll( GeneratorsOfGroup( G ),
                               g -> ForAll( res, n -> n^g in N ) ) then
                Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                       "#E  subgroup gen. by ", l[3], " is not normal\n" );
                result:= false;
              fi;
              if Size( N ) <> kersize then
                Print( "#E  AGR.Test.KernelGenerators for ", entry[1], ":\n",
                       "#E  subgroup gen. by ", l[3], " has size ",
                       Size( N ), " not ", kersize, "\n" );
                result:= false;
              fi;
            fi;
          fi;
        fi;

        # If the generators of group and factor group are compatible then
        # check that evaluating the generators of the factor group with the
        # kernel script yields only the identity.
        if IsBound( entry[3].factorCompatibility ) then
          comp:= First( entry[3].factorCompatibility,
                     x -> x[1] = l[1] and x[2] = factname and x[4] = true );
          if comp <> fail then
            G:= AtlasGroup( factname, comp[3] );
            if G <> fail then
              if prg = fail then
                prg:= AtlasProgram( entry[1], l[1], "kernel", l[2] );
              fi;
              if prg <> fail then
                res:= ResultOfStraightLineProgram( prg.program,
                          GeneratorsOfGroup( G ) );
                if not ForAll( res, IsOne ) then
                  Print( "#E  AGR.Test.KernelGenerators for ", entry[1],
                         ":\n",
                         "#E  evaluating the program at generators of the ",
                         "factor ", factname, "\n",
                         "#E  yields nonidentity elements\n" );
                  result:= false;
                fi;
              fi;
            fi;
          fi;
        fi;
      od;

      if ValueOption( "TryToExtendData" ) = true then
        AGR.Test.KernelGeneratorsExtend( entry );
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.CharacterNameFromMultiplicities( <tbl>, <mults> )
##
AGR.CharacterNameFromMultiplicities:= function( tbl, mults )
    local degrees, degreeset, positions, irrnames, i, alp, ATL, j, n, pair;

    degrees:= List( Irr( tbl ), x -> x[1] );
    degreeset:= Set( degrees );
    positions:= List( degreeset, x -> [] );
    irrnames:= [];
    for i in [ 1 .. Length( degrees ) ] do
      Add( positions[ PositionSorted( degreeset, degrees[i] ) ], i );
    od;

    alp:= List( "abcdefghijklmnopqrstuvwxyz", x -> [ x ] );
    while Length( alp ) < Maximum( List( positions, Length ) ) do
      Append( alp, List( alp{ [ 1 .. 26 ] },
                         x -> Concatenation( "(", x, "')" ) ) );
    od;

    if IsInt( mults ) then
      mults:= [ mults ];
    fi;

    ATL:= [];
    for i in [ 1 .. Length( degreeset ) ] do
      ATL[i]:= "";
      for j in [ 1 .. Length( positions[i] ) ] do
        n:= positions[i][j];
        if n in mults then
          # appears once
          Append( ATL[i], alp[j] );
        else
          pair:= First( mults, x -> IsList( x ) and x[1] = n );
          if pair <> fail then
            # appears with larger mult.
            Append( ATL[i], alp[j] );
            Append( ATL[i], "^" );
            Append( ATL[i], String( pair[2] ) );
          fi;
        fi;
      od;
      if ATL[i] <> "" then
        ATL[i]:= Concatenation( String( degreeset[i] ), ATL[i] );
      fi;
    od;

    return JoinStringsWithSeparator( Filtered( ATL, x -> x <> "" ), "+" );
    end;


#############################################################################
##
##  Let $H$ be the point stabilizer of a transitive and faithful
##  permutation action of $G$ of degree $d$, say.
##  For any proper normal subgroup $N$ of prime order in $G$,
##  we have $|N \cap H| = 1$ because $N$ cannot be contained in $H$,
##  and the constituent $1_{HN}^G$ of $1_H^G$ can be identified with
##  $1_{HN/N}^{G/N}$.
##  The degree of the latter character is $d / |N|$.
##  (In particular, $d$ must be divisible by $|N|$, otherwise there is no
##  faithful transitive permutation representation of degree $d$.)
##
AGR.Test.PermCharsFaithful:= function( tbl, degree )
    local cand, maxname, subtbl, subdegree, fus, onlyfaithful, n, img,
          subcand, classes, nsg, nsize, facttbl, factcand, pi;

    if degree = 1 then
      cand:= [ TrivialCharacter( tbl ) ];
    elif HasMaxes( tbl ) then
      cand:= [];
      for maxname in Maxes( tbl ) do
        subtbl:= CharacterTable( maxname );
        subdegree:= degree / ( Size( tbl ) / Size( subtbl ) );
        if IsInt( subdegree ) then
          # Note that the characters of the subgroup
          # need in general not be faithful.
          # However, if *any* normal subgroup of the subgroup
          # is also normal in the big group then we are interested
          # only in *faithful* characters of the subgroup.
          fus:= GetFusionMap( subtbl, tbl );
          onlyfaithful:= false;
          if fus <> fail then
            onlyfaithful:= true;
            for n in ClassPositionsOfNormalSubgroups( subtbl ) do
              img:= Set( fus{ n } );
              if not( img in ClassPositionsOfNormalSubgroups( tbl ) and
                      Sum( SizesConjugacyClasses( subtbl ){ n } ) =
                      Sum( SizesConjugacyClasses( tbl ){ img } ) ) then
                onlyfaithful:= false;
                break;
              fi;
            od;
          fi;
          if onlyfaithful then
            subcand:= AGR.Test.PermCharsFaithful( subtbl, subdegree );
          else
            subcand:= PermChars( subtbl, rec( torso:= [ subdegree ] ) );
          fi;
          UniteSet( cand, Induced( subtbl, tbl, subcand ) );
        fi;
      od;
    else
      # Find a normal subgroup to factor out in the first step.
      classes:= SizesConjugacyClasses( tbl );
      nsg:= First( ClassPositionsOfNormalSubgroups( tbl ),
                      x -> IsPrimeInt( Sum( classes{ x } ) ) );
      if nsg <> fail then
        nsize:= Sum( classes{ nsg } );
        if degree mod nsize <> 0 then
           Info( InfoAtlasRep, 2,
                 "AGR.Test.PermCharsFaithful:\n",
                 "#I  permcand. comput. done for ", Identifier( tbl ), "\n",
                 "#I  (no candidates of degree ", degree, ")" );
          return [];
        fi;
        fus:= First( ComputedClassFusions( tbl ),
                     x -> ClassPositionsOfKernel( x.map ) = nsg );
        if fus = fail or CharacterTable( fus.name ) = fail then
          facttbl:= tbl / nsg;
          fus:= GetFusionMap( tbl, facttbl );
          factcand:= AGR.Test.PermCharsFaithful( facttbl, degree / nsize );
        else
          factcand:= AGR.Test.PermCharsFaithful( CharacterTable( fus.name ),
                                                 degree / nsize );
          fus:= fus.map;
        fi;
        cand:= [];
        for pi in factcand do
          UniteSet( cand, PermChars( tbl, rec( torso:= [ degree ],
                                               normalsubgroup:= nsg,
                                               nonfaithful:= pi{ fus } ) ) );
        od;
      else
        # no reduction ...
        cand:= PermChars( tbl, rec( torso:= [ degree ] ) );
      fi;
    fi;

    Info( InfoAtlasRep, 2,
          "AGR.Test.PermCharsFaithful:\n",
          "#I  permcand. comput. done for ", Identifier( tbl ), "\n",
          "#I  (found ", Length( cand ), " cand. of degree ", degree, ")" );
    return cand;
    end;


#############################################################################
##
#F  AGR.Test.Character( <inforec>, <quick> )
##
##  This function is called by 'AGR.Test.Characters'.
##  It tries to compute class representatives or representatives of cyclic
##  subgroups, and to compute the (Brauer) character values at these
##  representatives.
##  The return value must be a record with the following components.
##
##  'result':
##      'true' or 'false',
##
##  'p':
##      the characteristic ('0' or a prime integer or 'fail', where 'fail'
##      occurs in the case of matrix repres. over residue class rings),
##
##  'candidates' (if 'p' is not 'fail'):
##      either 'fail' (if not enough information is available for computing
##      a list of candidates) or the list of possible characters that may be
##      afforded by the given representation;
##      an empty list means that we have found some contradiction.
##
##  'tbl' (if 'p' is not 'fail'):
##      the character table (ordinary or modular) that was used for the
##      identification,
##
##  'constituents' (if 'p' is not 'fail'):
##      either 'fail' (if the character is not uniquely determined) or an
##      integer (the position of the character in the list of irreducibles if
##      it is irreducible) or the list of positions of the constituents of
##      the character.
##
##  If <quick> is 'true' then no verification of a character is tried if
##  character theoretic criteria determine the character uniquely.
##  (In this case, no  inconsistencies because of generality problems can be
##  detected.)
##
AGR.Test.Character:= function( inforec, quick )
    local result, name, tbl, classnames, ccl, cyc, outputs1, prg1, poss, nam,
          ord, parts, outputs, prgs2, id, p, modtbl, fus, cand, pp,
          galoisfams, choice, phi, gens, pos, prgs, prg2, repprg, rep, val,
          orders, divisors, patterns, g, bound, good, x, inv, dec, i;

    result:= true;

    # Do nothing in the case of a matrix repres. over a residue class ring.
    if IsBound( inforec.ring ) and ( Characteristic( inforec.ring ) <> 0
       and not IsPrimeInt( Characteristic( inforec.ring ) ) ) then
      return rec( result:= true, p:= fail );
    fi;

    name:= inforec.groupname;
    tbl:= CharacterTable( name );

    # If there are scripts for computing class representatives then
    # use them.
    classnames:= AtlasClassNames( tbl );
    ccl:= AtlasProgram( name, inforec.standardization, "classes",
                        "contents", "local" );
    cyc:= AtlasProgram( name, inforec.standardization, "cyclic",
                        "contents", "local" );

    if ccl <> fail then
      if not IsBound( ccl.outputs ) then
        Print( "#E  AGR.Test.Character:\n",
               "#E  no component 'outputs' in ccl script for ", name, "\n" );
        ccl:= fail;
      else
        outputs1:= ccl.outputs;
        prg1:= ccl.program;
        cyc:= fail;
      fi;
    elif cyc <> fail and classnames <> fail then
      if not IsBound( cyc.outputs ) then
        Print( "#E  AGR.Test.Character:\n",
               "#E  no component 'outputs' in cyc script for ", name, "\n" );
        cyc:= fail;
      else
        outputs1:= cyc.outputs;
        prg1:= cyc.program;

        # Form all possibilities for proper class names.
        poss:= [];
        for nam in outputs1 do
          if nam in classnames then
            Add( poss, [ nam ] );
          else
            # Assume that only single letters appear.
#T problem with primes attached to class names!
# L216d4G1-cycW1:echo "Classes 15ABCD 17EFGH 10AB 8A 12A'"
# Sz32d5G1-cycW1:echo "Classes 25A-E 31A-O 41A-J 20A-B'''' 25F-F''''"
# TD42d3G1-cycW1:echo "Classes  6B 12A 13ABC 18ABC 21ABC 28ABC  6D 12C' 12E 18D' 21D 24A 24B"
            ord:= nam{ [ 1 .. PositionProperty( nam, IsAlphaChar ) - 1 ] };
            if '-' in nam then
              parts:= SplitString( nam{ [ Length( ord ) + 1 .. Length( nam ) ] },
                                   "-" );
              Add( poss, List( Filtered( List( CHARS_UALPHA, x -> [ x ] ),
                                         x -> parts[1] <= x and x <= parts[2] ),
                               y -> Concatenation( ord, y ) ) );
            else
              Add( poss, List( nam{ [ Length( ord ) + 1 .. Length( nam ) ] },
                               y -> Concatenation( ord, [ y ] ) ) );
            fi;
          fi;
        od;
        if ForAny( poss, IsEmpty ) then
          Print( "#E  AGR.Test.Character:\n",
                 "#E  not all classes identified in cyc script for ", name,
                 "\n" );
          cyc:= fail;
        else
          outputs:= List( Cartesian( poss ), names -> Concatenation( [
              "oup ", String( Length( names ) ), " ",
                      JoinStringsWithSeparator( names, " " ), "\n",
              "echo \"Classes ",
                      JoinStringsWithSeparator( names, " " ), "\"" ] ) );
          outputs:= List( outputs, str ->
                      StringOfAtlasProgramCycToCcls( str, tbl, "names" ) );
          if fail in outputs then
            # The "cyclic" script does not cover all maximally cyclic subgroups.
            # This happens for 'F24G1-cycW1' (classes "24C-D").
            cyc:= fail;
          else
            outputs:= List( outputs,
                            x -> ScanStraightLineProgram( x, "string" ) );
            prgs2:= List( outputs,
                       x -> rec( program:= CompositionOfStraightLinePrograms(
                                               x.program, prg1 ),
                                 outputs:= x.outputs ) );
          fi;
        fi;
      fi;

    fi;

    id:= inforec.repname;
    if IsBound( inforec.p ) then
      # a permutation representation
      p:= 0;
      modtbl:= tbl;
      fus:= [ 1 .. NrConjugacyClasses( tbl ) ];
    else
      if not IsBound( inforec.ring ) then
        gens:= AtlasGenerators( inforec );
        if gens <> fail then
          gens:= gens.generators;
          p:= Characteristic( Flat( gens ) );
          Info( InfoAtlasRep, 2,
                "AGR.Test.Character:\n",
                "#I  store RNG info for ", id, ":\n",
                "#I  ", Field( Flat( gens ) ), "\n" );
        else
          p:= fail;
        fi;
      else
        p:= Characteristic( inforec.ring );
      fi;
      if p = 0 then
        # a matrix representation in characteristic zero
        modtbl:= tbl;
        fus:= [ 1 .. NrConjugacyClasses( tbl ) ];
      elif p <> fail and IsPrimeInt( p ) then
        # a matrix representation in finite characteristic
        modtbl:= tbl mod p;
        if modtbl = fail then
          fus:= fail;
        else
          fus:= GetFusionMap( modtbl, tbl );
        fi;
      else
        # a matrix representation for which no info is stored,
        # and such that the generators are not accessible.
      fi;
    fi;

    # If possible then find a list of candidates.
    if IsBound( inforec.p ) then
      if IsBound( inforec.transitivity ) and inforec.transitivity > 0  then
        # In the case of transitive permutation representations,
        # compute the candidates from the character table,
        # and compare the character with them.
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  try perm. cand. comput. for ", Identifier( tbl ),
              ",\n#I  degree ", inforec.p );
        cand:= AGR.Test.PermCharsFaithful( tbl, inforec.p );
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  found ", Length( cand ), " candidates" );
      elif IsBound( inforec.orbits ) then
        # In the case of intransitive permutation representations,
        # compute candidates of not nec. faithful transitive permutation
        # characters for the orbit lengths, combine these constituents.
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  try perm. cand. comput. for ", Identifier( tbl ),
              ",\n#I  degrees ", inforec.orbits );
        cand:= List( inforec.orbits,
                     p -> PermChars( tbl, rec( torso:= [ p ] ) ) );
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  found ", List( cand, Length ), " candidates" );
        cand:= CallFuncList( ListX, Concatenation( cand,
                   [ function( arg ) return Sum( arg ); end ] ) );
        cand:= Filtered( cand, x -> ClassPositionsOfKernel( x ) = [ 1 ] );
      fi;
    elif IsBound( inforec.ring ) and IsField( inforec.ring )
                                 and IsFinite( inforec.ring )
                                 and modtbl <> fail then
      # In the case of an irreducible matrix representation over a finite
      # field, compute the candidates from the character table,
      # and compare the character with them.
      if IsBound( inforec.generators ) then
        gens:= inforec.generators;
      else
        gens:= AtlasGenerators( inforec );
        if gens <> fail then
          gens:= gens.generators;
        fi;
      fi;
      if gens <> fail then
        # Check the irreducibility.
        if MTX.IsIrreducible( GModuleByMats( gens, inforec.ring ) ) then
          cand:= Filtered( RealizableBrauerCharacters( Irr( modtbl ), 
                               Size( inforec.ring ) ),
                           x -> x[1] = inforec.dim );
        fi;
      fi;
    elif IsBound( inforec.ring ) and IsIntegers( inforec.ring ) then
      # In the case of an irreducible integral matrix representation,
      # compute the candidates from the character table,
      # and compare the character with them.
      if IsBound( inforec.generators ) then
        gens:= inforec.generators;
      else
        gens:= AtlasGenerators( inforec );
        if gens <> fail then
          gens:= gens.generators;
        fi;
      fi;
      if gens <> fail then
        # Check the irreducibility of a coprime reduction.
        pp:= 3;
        while Size( tbl ) mod pp = 0 do
          pp:= NextPrimeInt( pp );
        od;
        if MTX.IsAbsolutelyIrreducible(
                   GModuleByMats( gens * Z(pp)^0, GF(pp) ) ) then
          cand:= Filtered( Irr( tbl ),
                           x -> x[1] = inforec.dim and ForAll( x, IsInt ) );
        fi;
      fi;
    fi;

    # Determine representatives of Galois orbits.
    # We need values only for these classes.
    if modtbl <> fail then
      galoisfams:= GaloisMat( TransposedMat( Irr( modtbl ) ) ).galoisfams;
      choice:= Filtered( [ 1 .. Length( galoisfams ) ],
                         i -> galoisfams[i] <> 0 );
    fi;

    phi:= fail;

    if quick = true and IsBound( cand ) and Length( cand ) = 1 then
      phi:= cand[1]{ choice };
    elif ccl <> fail or cyc <> fail then
      # Try to compute the character directly from the representation.
      if fus = fail then
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  no Brauer table available for identifying ", id );
      elif classnames = fail then
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  no AtlasClassNames available for ", id );
      else
        # Fetch generators if we haven't done this already.
        if not IsBound( gens ) then
          if IsBound( inforec.generators ) then
            gens:= inforec.generators;
          else
            gens:= AtlasGenerators( inforec );
            if gens <> fail then
              gens:= gens.generators;
            fi;
          fi;
        fi;
        if gens <> fail and IsBound( choice ) then

          phi:= [];
          Info( InfoAtlasRep, 2,
                "AGR.Test.Character:\n",
                "#I  need ", Length( choice ), " char. values for ", id );
          for i in [ 1 .. Length( choice ) ] do
            pos:= fus[ choice[i] ];
            if classnames[ pos ] in outputs1 then
              # The character value is uniquely determined.
              prgs:= [ rec( program:= prg1, outputs:= outputs1 ) ];
            else
              # We have to check several possibilities.
              prgs:= prgs2;
            fi;
            for prg2 in prgs do
              repprg:= RestrictOutputsOfSLP( prg2.program,
                           Position( prg2.outputs, classnames[ pos ] ) );
              rep:= ResultOfStraightLineProgram( repprg, gens );
              if IsBound( inforec.p ) then
                # permutation repres.
                val:= inforec.p - NrMovedPoints( rep );
              elif Characteristic( rep ) = 0 then
                # ordinary matrix repres.
                val:= TraceMat( rep );
              else
                # modular matrix repres.
                val:= BrauerCharacterValue( rep );
              fi;
              if not IsBound( phi[i] ) then
                phi[i]:= val;
              elif phi[i] <> val then
                Print( "#I  AGR.Test.Character:\n",
                       "#I  representation ", id,
                       " yields information about class ",
                       classnames[ pos ], "\n",
                       "#I  (values ", phi[i], " vs. ", val, ")\n" );
                phi:= fail;
                result:= false;
                break;
              fi;
            od;
            if phi = fail then
              break;
            fi;
            Info( InfoAtlasRep, 2,
                  "AGR.Test.Character:\n",
                  "#I  have the ", Ordinal( i ), " char. value for ", id );
          od;
          Info( InfoAtlasRep, 2,
                "AGR.Test.Character:\n",
                "#I  have the char. values for ", id );
        fi;
      fi;
    else
      # ...
#T If we know a script for a proper factor then use it.
#T Otherwise try random elements and use possible patterns.
    fi;

    if phi = fail then
      Info( InfoAtlasRep, 2,
            "AGR.Test.Character:\n",
            "#I  cannot identify explicitly character for ", id );
    fi;

    # Now we have computed 'phi' from an explicit identification,
    # and we may have computed 'cand' from the character table.
    # Merge this information in order to get a new list 'cand'.
    if IsBound( cand ) then
      if phi <> fail then
        # We have both candidates and an explicit character.
        if ForAny( cand, x -> x{ choice } = phi ) then
          cand:= [ phi ];
        else
          cand:= [];
          Print( "#E  AGR.Test.Character:\n",
                 "#E  identified character info for ", id, "\n",
                 "#E  does not fit to candidates from char. table\n" );
          result:= false;
        fi;
      fi;
    else
      # The representation did not admit a list of candidates.
      if phi = fail then
        cand:= fail;
      else
        cand:= [ phi ];
      fi;
    fi;

    # If there are several candidates then try to exclude some of them,
    # using random elements.
    if cand <> fail and 1 < Length( cand ) then
      orders:= OrdersClassRepresentatives( modtbl );
      divisors:= List( orders, DivisorsInt );
      patterns:= List( cand,
        x -> Set( List( [ 1 .. Length( x ) ],
                        i -> [ orders[i], List( divisors[i],
                               d -> x[ PowerMap( modtbl, d, i ) ] ) ] ) ) );
      cand:= List( cand, x -> x{ choice } );
      orders:= OrdersClassRepresentatives( modtbl ){ choice };
      if Length( Set( patterns ) ) = 1 then
        Info( InfoAtlasRep, 2,
              "AGR.Test.Character:\n",
              "#I  values do not distinguish candidates for ",
              inforec.repname );
      else
        # We have a chance to rule out some candidates.
        if IsBound( inforec.generators ) then
          gens:= inforec.generators;
        else
          gens:= AtlasGenerators( inforec );
          if gens <> fail then
            gens:= gens.generators;
          fi;
        fi;
        if gens <> fail then
          g:= Group( gens );
          while 1 < Length( Set( patterns ) ) do
            if ForAll( patterns,
                 pt1 -> Number( patterns,
                          pt2 -> IsEmpty( Difference( pt1, pt2 ) ) ) = 1 and
                        Number( patterns,
                          pt2 -> IsEmpty( Difference( pt2, pt1 ) ) ) = 1 ) then
              # For each pattern, there are elements that allow us
              # to either exclude this pattern or all others.
              bound:= infinity;
            else
              # Some pattern cannot be excluded,
              # but perhaps we are lucky.
              # (This would happen for M22d2G1-p1232cB0
              # if no ccls script would be available.)
              bound:= 100;
            fi;
            i:= 1;
            while i <= bound do
              good:= [ 1 .. Length( patterns ) ];
              repeat
                x:= PseudoRandom( g );
                ord:= Order( x );
              until IsPerm( x ) or
                    Characteristic( x ) = 0 or
                    ( ord mod Characteristic( x ) ) <> 0;
              if IsBound( inforec.p ) then
                # permutation repres.
                inv:= [ ord, List( DivisorsInt( ord ),
                                   d -> inforec.p - NrMovedPoints( x^d ) ) ];
              elif Characteristic( x ) = 0 then
                # ordinary matrix repres.
                inv:= [ ord, List( DivisorsInt( ord ),
                                   d -> TraceMat( x^d ) ) ];
              else
                # modular matrix repres.
                inv:= [ ord, List( DivisorsInt( ord ),
                                   d -> BrauerCharacterValue( x^d ) ) ];
              fi;
              good:= Filtered( good, i -> inv in patterns[i] );
              if Length( good ) < Length( patterns ) then
                patterns:= patterns{ good };
                cand:= cand{ good };
                Info( InfoAtlasRep, 2,
                      "AGR.Test.Character:\n",
                      "#I  group comput. reduces to ", Length( good ),
                      " candidates" );
                break;
              fi;
              i:= i + 1;
            od;
            if not ( i <= bound ) then
              break;
            fi;
          od;
        fi;
      fi;

    elif cand <> fail and phi = fail then
      cand:= List( cand, x -> x{ choice } );
    fi;

    # If the character is identified then compute
    # the coefficients of the constituents.
    pos:= fail;
    if cand <> fail and Length( cand ) = 1 then
      Info( InfoAtlasRep, 2,
            "AGR.Test.Character:\n",
            "#I  found unique character for ", id );
      dec:= Decomposition( List( Irr( modtbl ), x -> x{ choice } ),
                           cand, "nonnegative" )[1];
      if dec = fail then
        Print( "#E  AGR.Test.Character:\n",
               "#E  not decomposable character for ", id, ":\n",
               cand[1], "\n" );
        result:= false;
        cand:= [];
      else
        pos:= [];
        for i in [ 1 .. Length( dec ) ] do
          if dec[i] = 1 then
            Add( pos, i );
          elif 1 < dec[i] then
            Add( pos, [ i, dec[i] ] );
          fi;
        od;
        if Length( pos ) = 1 and IsInt( pos[1] ) then
          pos:= pos[1];
        fi;
      fi;
    else
      Info( InfoAtlasRep, 2,
            "AGR.Test.Character:\n",
            "#I  not identified character for ", id );
      pos:= fail;
    fi;

    return rec( result:= result,
                p:= p,
                tbl:= modtbl,
                candidates:= cand,
                constituents:= pos );
    end;


#############################################################################
##
#F  AGR.Test.Characters( [<tocid>[, <name>[, <cond>]]][,][ <quick>] )
##
##  <#GAPDoc Label="test:AGR.Test.Characters">
##  <Mark><C>AGR.Test.Characters( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks the character information (that belongs to <M>tocid</M>)
##    for the matrix and permutation representations.
##  </Item>
##  <#/GAPDoc>
##
##  If <quick> is 'true' then no further tests are applied if the character
##  is uniquely determined by character-theoretic criteria.
##  (In this case, no  inconsistencies because of generality problems can be
##  detected.)
##
##  If the global option 'TryToExtendData' has the value 'true' then
##  the function also tries to compute character information
##  which is not yet stored.
##
AGR.Test.Characters:= function( arg )
    local quick, extend, result, name, cond, grpname, info, totest,
          test, map, charpos, nam, pos;

    if Length( arg ) <> 0 and IsBool( arg[ Length( arg ) ] ) then
      quick:= true;
      Remove( arg );
    else
      quick:= false;
    fi;

    extend:= ( ValueOption( "TryToExtendData" ) = true );

    # Initialize the result.
    result:= true;

    if IsEmpty( arg ) then
      return AGR.Test.Characters( "core" );
    elif Length( arg ) = 1 then
      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.Characters( arg[1], name[1] ) and result;
      od;
      return result;
    elif Length( arg ) = 2 then
      name:= arg[2];
      cond:= [];
    elif Length( arg ) = 3 then
      name:= arg[2];
      cond:= ShallowCopy( arg[3] );
    else
      Error( "usage: AGR.Test.Characters( [<tocid>[, <name>[, <cond>]]] )" );
    fi;

    Append( cond, [ "contents", [ arg[1], "local" ] ] );

    grpname:= AGR.InfoForName( name );
    if grpname = fail then
      Print( "#E  AGR.Test.Characters:\n",
             "#E  no AtlasRep info stored for ", name, "\n" );
      return false;
    elif CharacterTable( name ) = fail then
      # There is nothing to identify.
      return true;
    fi;

    totest:= CallFuncList( AllAtlasGeneratingSetInfos,
                           Concatenation( [ name ], cond ) );
    if not extend then
      totest:= Filtered( totest, r -> IsBound( r.constituents ) );
    fi;

    for info in totest do
      test:= AGR.Test.Character( info, quick );
      result:= test.result and result;

      # Check the character data stored for this representation.
      map:= AtlasOfGroupRepresentationsInfo.characterinfo;
      if not IsBound( map.( name ) ) then
        map.( name ):= [];
      fi;
      map:= map.( name );
      if test.p = 0 then
        charpos:= 1;
      else
        charpos:= test.p;
      fi;
      if charpos <> fail then
        if not IsBound( map[ charpos ] ) then
          map[ charpos ]:= [ [], [], [], [] ];
        fi;
        map:= map[ charpos ];
        if test.candidates = [] then
          # We have found a contradiction.
          Print( "#E  AGR.Test.Character:\n",
                 "#E  contradiction in character info for ",
                 info.repname, "\n" );
          result:= false;
        elif test.candidates = fail then
          # Test that NO character info is stored.
          if info.repname in map[2] then
            Print( "#E  AGR.Test.Character:\n",
                   "#E  cannot verify stored character info for ",
                   info.repname, "\n" );
            result:= false;
          fi;
        elif info.repname in map[2] then
          # Test that NO OTHER character info is stored.
          if map[1][ Position( map[2], info.repname ) ]
             <> test.constituents then
            Print( "#E  AGR.Test.Character:\n",
                   "#E  stored and computed character info for '",
                   info.repname, "' differ\n",
                   "#E  ('", map[1][ Position( map[2], info.repname ) ],
                   "' vs. '", test.constituents, "')\n" );
            result:= false;
          fi;
        elif test.constituents <> fail then
          # Add the new information.
          nam:= AGR.CharacterNameFromMultiplicities( test.tbl,
                    test.constituents );
          pos:= ReplacedString( String( test.constituents ), " ", "" );
          Print( "#I  AGR.Test.Character:\n",
                 "#I  add new info\n",
                 "[\"CHAR\",[\"", name, "\",\"", info.repname, "\",", test.p,
                 ",", pos );
          if nam <> fail then
            Print( ",\"", nam, "\"" );
          fi;
          Print( "]],\n" );
        fi;

        if test.candidates <> fail and test.candidates <> [] then
          # If the character is absolutely irreducible,
          # test whether the character name is compatible with 'info.repname'.
          if IsInt( test.constituents ) then
            nam:= AGR.CharacterNameFromMultiplicities( test.tbl,
                      test.constituents );
            if ( info.id = "" and
                 nam <> Concatenation( String( info.dim ), "a" ) ) or
               ( info.id <> "" and
                 nam <> Concatenation( String( info.dim ), info.id ) ) then
              Print( "#E  AGR.Test.Character:\n",
                     "#E  character name '", nam, "' contradicts '",
                     info.repname, "'\n" );
              result:= false;
            fi;
          fi;
        fi;
      fi;

    od;

    return result;
    end;


#############################################################################
##
#F  AGR.PrimitivityInfo( <inforec> )
##
##  <inforec> is a record as returned by 'OneAtlasGeneratingSetInfo',
##  for a permutation representation.
##
##  - If a perm. repres. is intransitive then just compute the orbit lengths.
##  - For a transitive perm. repres. of degree n, say, check primitivity:
##    * If the restriction to a maximal subgroup fixes a point then
##      this maximal subgroup is identified as the point stabilizer.
##    * If the the degree is not an index of a maximal subgroup then we know
##      that the repres. is not primitive.
##    * If the restriction from G to a maximal subgroup M of G has an orbit
##      of length n / [G:M] then M contains the point stabilizer.
##      So if the restriction to M does not fix a point then the repres. is
##      not primitive,
##      and we know a maximal overgroup of the point stabilizer.
##
AGR.PrimitivityInfo:= function( inforec )
    local gens, gapname, orbs, G, tr, rk, atlasinfo, size, indices, cand,
          result, i, prg, rest, filt, tbl, max, stab, maxmax, maxcand;

    gens:= AtlasGenerators( inforec );
    if gens <> fail then
      gens:= gens.generators;
      gapname:= inforec.groupname;

      # Check whether the group is transitive.
      orbs:= OrbitsPerms( gens, [ 1 .. inforec.p ] );
      if 1 < Length( orbs ) then
        return rec( isPrimitive:= false,
                    transitivity:= 0,
                    orbitLengths:= SortedList( List( orbs, Length ) ),
                    comment:= "explicit computation of orbits" );
      fi;

      atlasinfo:= First( AtlasOfGroupRepresentationsInfo.GAPnames,
                         x -> x[1] = gapname );

      # Compute transitivity and primitivity.
      G:= Group( gens );
      if IsBound( atlasinfo[3].size ) then
        SetSize( G, atlasinfo[3].size );
      fi;
      tr:= Transitivity( G );
      rk:= RankAction( G );

      if IsBound( atlasinfo[3].nrMaxes ) and
         IsBound( atlasinfo[3].sizesMaxes ) and
         Number( atlasinfo[3].sizesMaxes ) = atlasinfo[3].nrMaxes then
        size:= Size( G );
        indices:= List( atlasinfo[3].sizesMaxes, x -> size / x );
        cand:= Filtered( [ 1 .. Length( indices ) ],
                         i -> inforec.p mod indices[i] = 0 );
        if inforec.p in indices and Length( cand ) = 1 then
          # The point stabilizer is contained in a unique class of maxes,
          # and since the degree occurs as index of a maximal subgroup,
          # this representation is necessarily primitive.
          # Moreover, we know the class of maximal subgroups that are
          # the point stabilizers.
          result:= rec( isPrimitive:= true,
                        transitivity:= tr,
                        rankAction:= rk,
                        class:= cand[1],
                        comment:= "unique class of maxes for given degree" );
          if IsBound( atlasinfo[3].structureMaxes ) and
             IsBound( atlasinfo[3].structureMaxes[ cand[1] ] ) then
            result.structure:= atlasinfo[3].structureMaxes[ cand[1] ];
          fi;
          return result;
        fi;
      else
        cand:= [ 1 .. AGR.Test.HardCases.MaxNumberMaxes ];
      fi;

      # Check explicit restrictions to maximal subgroups M.
      # (If we know their orders then we check only those that can contain
      # the point stabilizer U.)
      # We prefer the smallest possible maximal subgroup that contains
      # the point stabilizer, so we run over the reversed list.
      for i in Reversed( cand ) do
        prg:= AtlasProgram( gapname, "maxes", i );
        if prg <> fail then
          rest:= ResultOfStraightLineProgram( prg.program, gens );

          if NrMovedPoints( rest ) < inforec.p then
            # If the restriction to M fixes a point then M is equal to U.
            result:= rec( isPrimitive:= true,
                          transitivity:= tr,
                          rankAction:= rk,
                          class:= i,
                          comment:= "restriction fixes a point" );
            if IsBound( atlasinfo[3].structureMaxes ) and
               IsBound( atlasinfo[3].structureMaxes[i] ) then
              result.structure:= atlasinfo[3].structureMaxes[i];
            fi;
            return result;
          elif IsBound( atlasinfo[3].sizesMaxes ) and
               IsBound( atlasinfo[3].sizesMaxes[i] ) then
            if inforec.p * atlasinfo[3].sizesMaxes[i] / Size( G ) in
               OrbitLengths( Group( rest ) ) then
              # The length of the M-orbit of a point is equal to the quotient
              # |M|/|U|, thus U is a proper subgroup of M.
              result:= rec( isPrimitive:= false,
                            transitivity:= tr,
                            rankAction:= rk,
                            class:= i,
                            comment:= "restriction contains point stab." );
              if IsBound( atlasinfo[3].structureMaxes ) and
                 IsBound( atlasinfo[3].structureMaxes[i] ) then
                # We know a maximal overgroup M of the stabilizer U.
                # Try to identify also U itself:
                # - If U is trivial then nothing is to do.
                # - If [M:U] is the index of the largest maximal subgroup of M
                #   then take the description of it.
                # - If [M:U] = 2 and [M:M']_2 = 2 then U is the unique index
                #   two subgroup of M.
                result.overgroup:= atlasinfo[3].structureMaxes[i];
                if inforec.p = Size( G ) then
                  result.subgroup:= "1";
                else
                  tbl:= CharacterTable( inforec.groupname );
                  if tbl <> fail then
                    max:= CharacterTable( result.overgroup );
                    if max <> fail then
                      if inforec.p * atlasinfo[3].sizesMaxes[i] / Size( G )
                         = 2 and
                         Length( LinearCharacters( max ) ) mod 4 = 2 then
                        stab:= Filtered( NamesOfFusionSources( max ),
                                   u -> Size( CharacterTable( u ) )
                                        = Size( max ) / 2 );
                        if Length( stab ) = 1 then
                          result.subgroup:= stab[1];
                        elif HasConstructionInfoCharacterTable( max ) and
                             [ "Cyclic", 2 ] in
                             ConstructionInfoCharacterTable( max )[2] then
                          stab:= Difference( ConstructionInfoCharacterTable(
                                     max )[2], [ [ "Cyclic", 2 ] ] );
                          if Length( stab ) = 1 and Length( stab[1] ) = 1 and
                             IsString( stab[1][1] ) then
                            result.subgroup:= stab[1][1];
                          fi;
                        fi;
                      else
                        maxmax:= CharacterTable( Concatenation( Identifier(
                                                     max ), "M1" ) );
                        if maxmax <> fail and
                           inforec.p * atlasinfo[3].sizesMaxes[i] / Size( G )
                           = Size( max ) / Size( maxmax ) then
                          result.subgroup:= Identifier( maxmax );
                        fi;
                      fi;
                    fi;
                  fi;
                fi;
              fi;
              if IsBound( result.subgroup ) then
                result.subgroup:= StructureDescriptionCharacterTableName(
                                      result.subgroup );
              fi;
              return result;
            fi;
          fi;
        fi;
      od;

      if IsBound( atlasinfo[3].nrMaxes ) and
         IsBound( atlasinfo[3].sizesMaxes ) and
         Number( atlasinfo[3].sizesMaxes ) = atlasinfo[3].nrMaxes and
         not inforec.p in indices then
        # This representation is not primitive
        # but we do not know overgroups.
        return rec( isPrimitive:= false,
                    transitivity:= tr,
                    rankAction:= rk,
                    comment:= "degree is not an index of a max. subgroup" );
      fi;

      # Check explictly whether the action is primitive.
      if not IsPrimitive( G, MovedPoints( G ) ) then
        return rec( isPrimitive:= false,
                    transitivity:= tr,
                    rankAction:= rk,
                    comment:= "explicit check of primitivity" );
      fi;

      # Now we know that the action is primitive.
      if IsBound( atlasinfo[3].nrMaxes ) and
         IsBound( atlasinfo[3].sizesMaxes ) and
         Number( atlasinfo[3].sizesMaxes ) = atlasinfo[3].nrMaxes then
        maxcand:= Filtered( [ 1 .. Length( indices ) ],
                            i -> inforec.p = indices[i] );
        if Length( maxcand ) = 1 then
          # We know the class.
          result:= rec( isPrimitive:= true,
                        transitivity:= tr,
                        rankAction:= rk,
                        class:= maxcand[1],
                        comment:=
           "unique class of maxes for the given degree and prim. action" );
          if IsBound( atlasinfo[3].structureMaxes ) and
             IsBound( atlasinfo[3].structureMaxes[ maxcand[1] ] ) then
            result.structure:= atlasinfo[3].structureMaxes[ maxcand[1] ];
          fi;
          return result;
        fi;
      else
        return rec( isPrimitive:= true,
                    transitivity:= tr,
                    rankAction:= rk,
                    comment:= "explicit check of primitivity, no more info" );
      fi;
    fi;

    # We do not know how to deal with this case.
    return rec( isPrimitive:= fail );
    end;


#############################################################################
##
#F  AGR.Test.Primitivity( [<tocid>[, <name>]] )
##
##  <#GAPDoc Label="test:AGR.Test.Primitivity">
##  <Mark><C>AGR.Test.Primitivity( [</C><M>tocid</M><C>][:TryToExtendData] )</C></Mark>
##  <Item>
##    checks the stored primitivity information for the permutation
##    representations that belong to <M>tocid</M>.
##    That is, the number of orbits, in case of a transitive action the
##    transitivity, the rank, the information about the point stabilizers
##    are computed if possible, and compared with the stored information.
##  </Item>
##  <#/GAPDoc>
##
##  If the global option 'TryToExtendData' has the value 'true' then
##  the function also tries to compute primitivity information
##  which is not yet stored.
##
AGR.Test.Primitivity:= function( arg )
    local result, name, tocid, extend, tblid, totest, arec, repname, info,
          maxid, tbl, maxname, res, permrepinfo, stored, str, entry;

    # Initialize the result.
    result:= true;

    if IsEmpty( arg ) then
      return AGR.Test.Primitivity( "core" );
    elif Length( arg ) = 1 then
      for name in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.Primitivity( arg[1], name[1] ) and result;
      od;
      return result;
    elif Length( arg ) = 2 then
      tocid:= arg[1];
      name:= arg[2];
    else
      Error( "usage: AGR.Test.Primitivity( [<tocid>[, <name>]] )" );
    fi;

    extend:= ( ValueOption( "TryToExtendData" ) = true );

    tblid:= fail;
    if IsPackageMarkedForLoading( "CTblLib", "1.0" ) then
      tblid:= LibInfoCharacterTable( name );
      if tblid <> fail then
        tblid:= tblid.firstName;
      fi;
    fi;

    totest:= AllAtlasGeneratingSetInfos( name, IsPermGroup, true,
                 "contents", [ tocid, "local" ] );
    if not extend then
      totest:= Filtered( totest, r -> IsBound( r.isPrimitive ) );
    fi;

    for arec in totest do
      repname:= arec.repname;
      info:= AGR.PrimitivityInfo( arec );

      # Translate 'info' to 'res'.
      if IsBound( info.transitivity ) and info.transitivity = 0 then
        res:= [ repname, [ 0, info.orbitLengths ] ];
      elif info.isPrimitive = true then
        if IsBound( info.structure ) then
          res:= [ repname, [ info.transitivity, info.rankAction, "prim",
                             info.structure, info.class ] ];
        elif IsBound( info.class ) then
          if tblid <> fail then
            maxid:= Concatenation( tblid, "M", String( info.class ) );
            tbl:= CharacterTable( maxid );
          else
            tbl:= fail;
          fi;
          if tbl <> fail then
            maxname:= StructureDescriptionCharacterTableName(
                          Identifier( tbl ) );
          else
            maxname:= "???";
          fi;
          res:= [ repname, [ info.transitivity, info.rankAction, "prim",
                             maxname, info.class ] ];
        elif IsBound( info.possclass ) then
          res:= [ repname, [ info.transitivity, info.rankAction, "prim",
                             "???", info.possclass ] ];
        else
          res:= [ repname, [ info.transitivity, info.rankAction, "prim",
                             "???", "???" ] ];
        fi;
      elif info.isPrimitive = false then
        if IsBound( info.overgroup ) then
          if IsBound( info.subgroup ) then
            res:= [ repname, [ info.transitivity, info.rankAction, "imprim",
                               Concatenation( info.subgroup, " < ",
                                              info.overgroup ) ] ];
          else
            res:= [ repname, [ info.transitivity, info.rankAction, "imprim",
                               Concatenation( "??? < ", info.overgroup ) ] ];
          fi;
        else
          res:= [ repname, [ info.transitivity, info.rankAction, "imprim",
                             "???" ] ];
        fi;
      else
        res:= fail;
      fi;

      # Compare the computed info with the stored one.
#T extend the check:
#T Compute the size of the stabilizer,
#T and if the table with given name is available then compare!
      permrepinfo:= AtlasOfGroupRepresentationsInfo.permrepinfo;
      if IsBound( permrepinfo.( repname ) ) then
        stored:= permrepinfo.( repname );
        if stored.transitivity = 0 then
          str:= [ stored.transitivity, stored.orbits ];
        else
          str:= [ stored.transitivity, stored.rankAction,, stored.stabilizer ];
          if stored.isPrimitive then
            str[3]:= "prim";
            str[5]:= stored.maxnr;
            if '<' in stored.stabilizer then
              Print( "#E  AGR.Test.Primitivity:\n",
                     "#E  prim. repres. with '<' in stabilizer string ",
                     "for ", repname, "?\n" );
              result:= false;
            fi;
          else
            str[3]:= "imprim";
            if stored.stabilizer <> "???" and not '<' in stored.stabilizer then
              Print( "#E  AGR.Test.Primitivity:\n",
                     "#E  imprim. repres. without '<' in stabilizer string ",
                     "for ", repname, "?\n" );
              result:= false;
            fi;
          fi;
        fi;
      else
        stored:= fail;
      fi;

      if stored = fail then
        if res <> fail then
          Print( "#I  AGR.Test.Primitivity:\n",
                 "#I  add new AGR.API value:\n" );
          str:= [];
          for entry in res[2] do
            if IsString( entry ) then
              Add( str, Concatenation( "\"", entry, "\"" ) );
            elif IsList( entry ) and ForAll( entry, IsInt ) then
              Add( str, ReplacedString( String( entry ), " ", "" ) );
            else
              Add( str, String( entry ) );
            fi;
          od;
          if ForAny( res[2], x -> IsString( x ) and '?' in x ) then
            Print( "# " );
          fi;
          Print( "[\"API\",[\"", res[1], "\",[",
                 JoinStringsWithSeparator( str, "," ), "]]],\n" );
        fi;
      elif res = fail then
        Print( "#I  AGR.Test.Primitivity:\n",
               "#I  cannot verify stored value '", str, "' for ", repname,
               "\n" );
      else
        # We have a computed and a stored value.
        if res[2] <> str then
          # Report an error if the two values are not compatible,
          # report a difference if some part was not identified.
          if Length( str ) <> Length( res[2] ) or Length( str ) = 2 or
             str{ [ 1 .. 3 ] } <> res[2]{ [ 1 .. 3 ] } then
            Print( "#E  AGR.Test.Primitivity:\n",
                   "#E  difference stored <-> computed for ", repname,
                   ":\n#E  ", str, " <-> ", res[2], "\n" );
            result:= false;
          elif 4 <= Length( str ) and res[2][4] = "???" then
            Print( "#I  AGR.Test.Primitivity:\n",
                   "#I  cannot identify stabilizer '", str[4], "' for ",
                   repname, "\n" );
          elif 4 <= Length( str ) and 6 < Length( res[2][4] ) and
               res[2][4]{ [ 1 .. 6 ] } = "??? < " then
            if '<' in str[4] and
                str[4]{ [ Position( str[4], '<' ) .. Length( str[4] ) ] }
                = res[2][4]{ [ Position( res[2][4], '<' )
                               .. Length( res[2][4] ) ] } then
              Print( "#I  AGR.Test.Primitivity:\n",
                     "#I  cannot identify subgroup in stabilizer '", str[4],
                     "' for ", repname, "\n" );
            else
              Print( "#E  AGR.Test.Primitivity:\n",
                     "#E  difference stored <-> computed for ", repname,
                     ":\n#E  ", str, " <-> ", res[2], "\n" );
              result:= false;
            fi;
          else
            Print( "#E  AGR.Test.Primitivity:\n",
                   "#E  difference stored <-> computed for ", repname,
                   ":\n#E  ", str, " <-> ", res[2], "\n" );
            result:= false;
          fi;
        fi;
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.MaxesStandardization( [<tocid>][,][<entry>][,][<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.MaxesStandardization">
##  <Mark><C>AGR.Test.MaxesStandardization( [</C><M>tocid</M><C>] )</C></Mark>
##  <Item>
##    checks whether the straight line programs (that belong to <M>tocid</M>)
##    for standardizing the generators of maximal subgroups are correct:
##    If a semi-presentation is available for the maximal subgroup and the
##    standardization in question then it is used, otherwise an explicit
##    isomorphism is tried.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.MaxesStandardization:= function( arg )
    local verbose, tocid, entry, result, toc, record, l, G, maxprg,
          maxstdprg, res, subname, check, H, cand, sml, hom;

    verbose:= ForAny( arg, x -> x = true );
    tocid:= First( arg, IsString );
    if tocid = fail then
      tocid:= "core";
    fi;
    entry:= First( arg, x -> IsList( x ) and not IsString( x ) );

    result:= true;

    if entry = fail then
      # Run over the groups.
      for entry in AtlasOfGroupRepresentationsInfo.GAPnames do
        result:= AGR.Test.MaxesStandardization( tocid, entry, verbose )
                 and result;
      od;
      return result;
    fi;

    # Treat one group.
    for toc in Filtered( AGR.TablesOfContents( [ tocid, "local" ] ),
                         x -> IsBound( x.( entry[2] ) ) ) do

      record:= toc.( entry[2] );
      if IsBound( record.maxstd ) then
        for l in record.maxstd do
          if verbose then
            Print( "#I  AGR.Test.MaxesStandardization:\n",
                   "#I  entered for ", l[6], "\n" );
          fi;
          G:= AtlasGroup( entry[1], l[1], "contents", "local" );
          maxprg:= AtlasProgram( entry[1], l[1], "maxes", l[2],
                                 "version", l[3],
                                 "contents", "local" );
          if G <> fail then
            if maxprg = fail then
              Print( "#E  AGR.Test.MaxesStandardization for ", entry[1], ":\n",
                     "#E  no maxes script for ", l[6], "\n" );
              result:= false;
            else
              maxstdprg:= AtlasProgram( entry[1], l[1],
                                        "maxstd", l[2], l[3], l[5],
                                        "contents", "local" );
              if maxstdprg = fail then
                Print( "#E  AGR.Test.MaxesStandardization for ", entry[1],
                       ":\n",
                       "#E  no maxstd script for ", l[6], "\n" );
                result:= false;
              else
                res:= ResultOfStraightLineProgram( maxprg.program,
                          GeneratorsOfGroup( G ) );
                res:= ResultOfStraightLineProgram( maxstdprg.program, res );
                subname:= AGR.GAPNameAtlasName( l[4] );
                check:= AtlasProgram( subname, l[5], "check",
                                      "contents", "local" );
                if check = fail then
                  # Verify an isomorphism.
                  if verbose then
                    Print( "#I  AGR.Test.MaxesStandardization:\n",
                           "#I  no check program available,\n",
                           "#I  hard test for ", subname, " < ", entry[1],
                           "\n" );
                  fi;
                  H:= AtlasGroup( subname, l[5], "contents", "local" );
                  if H = fail then
                    Print( "#E  AGR.Test.MaxesStandardization for ", entry[1],
                           ":\n",
                           "#E  no repres. for subgroup ", subname, "\n",
                           "#E  cannot verify the standardization script.\n" );
                    result:= false;
                  else
                    cand:= GroupWithGenerators( res );
                    if IsPermGroup( cand ) then
                      # The 'cheap' option is crucial!
                      sml:= SmallerDegreePermutationRepresentation(
                                cand : cheap:= true );
                      if verbose then
                        Print( "#I  AGR.Test.MaxesStandardization:\n",
                                 "#I  switched from perm. repres. on ",
                               NrMovedPoints( cand ), "\n",
                               "#I  to ", NrMovedPoints( Images( sml ) ),
                               " points\n" );
                      fi;
                      res:= List( res, x -> x^sml );
                      cand:= GroupWithGenerators( res );
                    fi;
                    hom:= GroupHomomorphismByImages( H, cand,
                              GeneratorsOfGroup( H ), res );
                    if verbose then
                      Print( "#I  AGR.Test.MaxesStandardization for ", entry[1],
                             ":\n",
                             "#I  have the homomorphism result\n" );
                    fi;
                    if hom = fail or not IsBijective( hom ) then
                      Print( "#E  AGR.Test.MaxesStandardization for ", entry[1],
                             ":\n",
                             "#E  restriction to ", subname,
                             " is not standard!\n" );
                      result:= false;
                    fi;
                    if verbose then
                      Print( "#I  AGR.Test.MaxesStandardization for ", entry[1],
                             ":\n",
                             "#I  have the isomorphism result\n" );
                    fi;
                  fi;
                elif ResultOfStraightLineDecision( check.program, res )
                     <> true then
                  Print( "#E  AGR.Test.MaxesStandardization for ", entry[1],
                         ":\n",
                         "#E  restriction to ", subname,
                         " is not standard!\n" );
                  result:= false;
                fi;
              fi;
            fi;
          fi;
        od;
      fi;
    od;

    return result;
    end;


#############################################################################
##
#F  AGR.Test.MinimalDegrees( [<verbose>] )
##
##  <#GAPDoc Label="test:AGR.Test.MinimalDegrees">
##  <Mark><C>AGR.Test.MinimalDegrees()</C></Mark>
##  <Item>
##    checks that the (permutation and matrix) representations available in
##    the database do not have smaller degree than the minimum claimed in
##    Section&nbsp;<Ref Sect="sect:Representations of Minimal Degree"/>.
##  </Item>
##  <#/GAPDoc>
##
AGR.Test.MinimalDegrees:= function( arg )
    local result, verbose, info, grpname, known, knownzero, deg, mindeg,
          knownfinite, chars_and_sizes, size, p, knowncharp, q, knownsizeq;

    result:= true;
    verbose:= ( Length( arg ) <> 0 );
    for info in AtlasOfGroupRepresentationsInfo.GAPnames do

      grpname:= info[1];

      # Check permutation representations.
      known:= AllAtlasGeneratingSetInfos( grpname, IsPermGroup, true,
                                          "contents", "local" );
      if not IsEmpty( known ) then
        deg:= Minimum( List( known, r -> r.p ) );
        mindeg:= MinimalRepresentationInfo( grpname, NrMovedPoints,
                     "lookup" );
        if   mindeg = fail then
          if verbose then
            Print( "#I  AGR.Test.MinimalDegrees:\n",
                   "#I  '", grpname, "': degree ", deg,
                   " perm. repr. known but no minimality info stored\n" );
          fi;
        elif deg < mindeg.value then
          Print( "#E  AGR.Test.MinimalDegrees:\n",
                 "#E  '", grpname, "': smaller perm. repr. (", deg,
                 ") than minimal degree (", mindeg.value, ")\n" );
          result:= false;
        fi;
      fi;

      # Check matrix representations over fields in characteristic zero.
      known:= AllAtlasGeneratingSetInfos( grpname, Ring, IsField,
                                          "contents", "local" );
      knownzero:= Filtered( known,
                      r -> IsBound( r.ring ) and not IsFinite( r.ring ) );
      if not IsEmpty( knownzero ) then
        deg:= Minimum( List( knownzero, r -> r.dim ) );
        mindeg:= MinimalRepresentationInfo( grpname, Characteristic, 0,
                     "lookup" );
        if   mindeg = fail then
          if verbose then
            Print( "#I  AGR.Test.MinimalDegrees:\n",
                   "#I  '", grpname, "': degree ", deg, " char. 0 ",
                   "matrix repr. known but no minimality info stored\n" );
          fi;
        elif deg < mindeg.value then
          Print( "#E  AGR.Test.MinimalDegrees:\n",
                 "#E  '", grpname, "': smaller char. 0 matrix repr. (", deg,
                 ") than minimal degree (", mindeg.value, ")\n" );
          result:= false;
        fi;
      fi;

      # Check matrix representations over finite fields.
      knownfinite:= Filtered( known,
                        r -> IsBound( r.ring ) and IsFinite( r.ring ) );
      chars_and_sizes:= [];
      for size in Set( List( knownfinite, r -> Size( r.ring ) ) ) do
        p:= SmallestRootInt( size );
        info:= First( chars_and_sizes, pair -> pair[1] = p );
        if info = fail then
          Add( chars_and_sizes, [ p, [ size ] ] );
        else
          Add( info[2], size );
        fi;
      od;
      for info in chars_and_sizes do
        p:= info[1];
        knowncharp:= Filtered( knownfinite,
                               r -> Characteristic( r.ring ) = p );
        deg:= Minimum( List( knowncharp, r -> r.dim ) );
        mindeg:= MinimalRepresentationInfo( grpname, Characteristic, p,
                     "lookup" );
        if   mindeg = fail then
          if verbose then
            Print( "#I  AGR.Test.MinimalDegrees:\n",
                   "#I  '", grpname, "': degree ", deg, " char. ", p,
                   " matrix repr. known but no minimality info stored\n" );
          fi;
        elif deg < mindeg.value then
          Print( "#E  AGR.Test.MinimalDegrees:\n",
                 "#E  '", grpname, "': smaller char. ", p, " matrix repr. (",
                 deg, ") than minimal degree (", mindeg.value, ")\n" );
          result:= false;
        fi;
        for q in info[2] do
          knownsizeq:= Filtered( knownfinite,
                                 r -> Size( r.ring ) = q );
          deg:= Minimum( List( knownsizeq, r -> r.dim ) );
          mindeg:= MinimalRepresentationInfo( grpname, Size, q,
                       "lookup" );
          if   mindeg = fail then
            if verbose then
              Print( "#I  AGR.Test.MinimalDegrees:\n",
                     "#I  '", grpname, "': degree ", deg, " size ", q,
                     " matrix repr. known but no minimality info stored\n" );
            fi;
          elif deg < mindeg.value then
            Print( "#E  AGR.Test.MinimalDegrees:\n",
                   "#E  '", grpname, "': smaller size ", q,
                   " matrix repr. (", deg, ") than minimal degree (",
                   mindeg.value, ")\n" );
            result:= false;
          fi;
        od;
      od;

    od;
    return result;
    end;


#############################################################################
##
##  Note that the dummy variables are actually used only if the packages
##  in question are available.
##
if not IsPackageMarkedForLoading( "TomLib", "" ) then
  Unbind( IsStandardGeneratorsOfGroup );
  Unbind( LIBTOMKNOWN );
fi;

if not IsPackageMarkedForLoading( "CTblLib", "" ) then
  Unbind( ConstructionInfoCharacterTable );
  Unbind( HasConstructionInfoCharacterTable );
  Unbind( LibInfoCharacterTable );
  Unbind( StructureDescriptionCharacterTableName );
fi;

if not IsPackageMarkedForLoading( "Recog", "" ) then
  Unbind( InfoRecog );
  Unbind( RecogniseGroup );
  Unbind( SLPforElement );
  Unbind( NiceGens );
fi;


#############################################################################
##
#E

