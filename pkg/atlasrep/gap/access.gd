#############################################################################
##
#W  access.gd            GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains functions for low level access to data from the
##  ATLAS of Group Representations.
##


#############################################################################
##
#V  AGR
##
##  <#GAPDoc Label="AGR">
##  <ManSection>
##  <Var Name="AGR"/>
##
##  <Description>
##  is a record whose components are functions and data that are used by the
##  high level interface functions.
##  Some of the components are documented, see for example the index of the
##  package manual.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BindGlobal( "AGR", rec( GAPnamesRec:= rec() ) );


#############################################################################
##
#V  InfoAtlasRep
##
##  <#GAPDoc Label="InfoAtlasRep">
##  <ManSection>
##  <InfoClass Name="InfoAtlasRep"/>
##
##  <Description>
##  If the info level of <Ref InfoClass="InfoAtlasRep"/> is at least <M>1</M>
##  then information about <K>fail</K> results of &AtlasRep; functions
##  is printed.
##  If the info level is at least <M>2</M> then also information about calls
##  to external programs is printed.
##  The default level is <M>0</M>, no information is printed on this level.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareInfoClass( "InfoAtlasRep" );


#############################################################################
##
##  Filenames Used in the Atlas of Group Representations
##
##  <#GAPDoc Label="[1]{access}">
##  &AtlasRep; expects that the filename of each data file describes
##  the contents of the file.
##  This section lists the definitions of the supported structures of
##  filenames.
##  <P/>
##  Each filename consists of two parts, separated by a minus sign <C>-</C>.
##  The first part is always of the form <M>groupname</M><C>G</C><M>i</M>,
##  where the integer <M>i</M> denotes the <M>i</M>-th set of standard
##  generators for the group <M>G</M>, say,
##  with <Package>ATLAS</Package>-file name <M>groupname</M>
##  (see&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>).
##  The translations of the name <M>groupname</M> to the name(s) used within
##  &GAP; is given by the component <C>GAPnames</C> of
##  <Ref Var="AtlasOfGroupRepresentationsInfo"/>.
##  <P/>
##  The names of files that contain straight line programs or straight line
##  decisions have one of the following forms.
##  In each of these cases, the suffix <C>W</C><M>n</M> means that <M>n</M>
##  is the version number of the program.
##  <List>
##  <#Include Label="type:cyclic:format">
##  <#Include Label="type:classes:format">
##  <#Include Label="type:cyc2ccls:format">
##  <#Include Label="type:maxes:format">
##  <#Include Label="type:maxstd:format">
##  <#Include Label="type:out:format">
##  <#Include Label="type:kernel:format">
##  <#Include Label="type:switch:format">
##  <#Include Label="type:check:format">
##  <#Include Label="type:pres:format">
##  <#Include Label="type:find:format">
##  <#Include Label="type:otherscripts:format">
##  </List>
##  <P/>
##  The names of files that contain group generators have one of the
##  following forms.
##  In each of these cases,
##  <M>id</M> is a (possibly empty) string that starts with a lowercase
##  alphabet letter (see&nbsp;<Ref Func="IsLowerAlphaChar" BookName="ref"/>),
##  and <M>m</M> is a nonnegative integer, meaning that the generators are
##  written w.&nbsp;r.&nbsp;t.&nbsp;the <M>m</M>-th basis
##  (the meaning is defined by the <Package>ATLAS</Package> developers).
##  <P/>
##  <List>
##  <#Include Label="type:matff:format">
##  <#Include Label="type:perm:format">
##  <#Include Label="type:matalg:format">
##  <#Include Label="type:matint:format">
##  <#Include Label="type:quat:format">
##  <#Include Label="type:matmodn:format">
##  </List>
##  <#/GAPDoc>
##


#############################################################################
##
#F  AGR.ParseFilenameFormat( <string>, <format> )
##
##  <#GAPDoc Label="AGRParseFilenameFormat">
##  <ManSection>
##  <Func Name="AGR.ParseFilenameFormat" Arg='string, format'/>
##
##  <Returns>
##  a list of strings and integers if <A>string</A> matches <A>format</A>,
##  and <K>fail</K> otherwise.
##  </Returns>
##  <Description>
##  Let <A>string</A> be a filename, and <A>format</A> be a list
##  <M>[ [ c_1, c_2, \ldots, c_n ], [ f_1, f_2, \ldots, f_n ] ]</M>
##  such that each entry <M>c_i</M> is a list of strings and of functions
##  that take a character as their argument and return <F>true</F> or
##  <F>false</F>,
##  and such that each entry <M>f_i</M> is a function for parsing a filename,
##  such as the currently undocumented functions <C>ParseForwards</C> and
##  <C>ParseBackwards</C>.
##  <!-- %T add a cross-reference to gpisotyp!-->
##  <P/>
##  <Ref Func="AGR.ParseFilenameFormat"/> returns a list of strings and
##  integers such that the concatenation of their
##  <Ref Attr="String" BookName="ref"/> values yields <A>string</A> if
##  <A>string</A> matches <A>format</A>,
##  and <K>fail</K> otherwise.
##  Matching is defined as follows.
##  Splitting <A>string</A> at each minus character (<C>-</C>)
##  yields <M>m</M> parts <M>s_1, s_2, \ldots, s_m</M>.
##  The string <A>string</A> matches <A>format</A> if <M>s_i</M> matches
##  the conditions in <M>c_i</M>, for <M>1 \leq i \leq n</M>,
##  in the sense that applying <M>f_i</M> to <M>s_i</M>
##  and <M>c_i</M> yields a non-<K>fail</K> result.
##  <P/>
##  <Example><![CDATA[
##  gap> format:= [ [ [ IsChar, "G", IsDigitChar ],
##  >                 [ "p", IsDigitChar, AGR.IsLowerAlphaOrDigitChar,
##  >                   "B", IsDigitChar, ".m", IsDigitChar ] ],
##  >               [ ParseBackwards, ParseForwards ] ];;
##  gap> AGR.ParseFilenameFormat( "A6G1-p10B0.m1", format );
##  [ "A6", "G", 1, "p", 10, "", "B", 0, ".m", 1 ]
##  gap> AGR.ParseFilenameFormat( "A6G1-p15aB0.m1", format );
##  [ "A6", "G", 1, "p", 15, "a", "B", 0, ".m", 1 ]
##  gap> AGR.ParseFilenameFormat( "A6G1-f2r16B0.m1", format );
##  fail
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##


#############################################################################
##
#F  AtlasOfGroupRepresentationsLocalFilename( <groupname>, <files>, <type> )
##
##  This implements the <E>location</E> step of the access to data files.
##  The return value is a pair, the first entry being <K>true</K> if the
##  file is already locally available, and <K>false</K> otherwise,
##  and the second entry being a list of pairs
##  <M>[ path, r ]</M>,
##  where <M>path</M> is the local path where the file can be found,
##  or a list of such paths
##  (after the file has been transferred if the first entry is <K>false</K>),
##  and <M>r</M> is the record of functions to be used for transferring the
##  file.
##
DeclareGlobalFunction( "AtlasOfGroupRepresentationsLocalFilename" );


#############################################################################
##
#F  AtlasOfGroupRepresentationsLocalFilenameTransfer( <groupname>, <files>,
#F                                                    <type> )
##
##  This implements the <E>location</E> and <E>fetch</E> steps
##  of the access to data files.
##  The return value is either <K>fail</K>
##  or a pair <M>[ paths, r ]</M>
##  where <M>paths</M> is the list of the local paths (which really exist)
##  and <C>r</C> is the record containing the function to be used for reading
##  and interpreting the file contents
##  or a triple <M>[ contents, r, "contents" ]</M>
##  where <M>contents</M> is the list of strings that describe the contents
##  of the files and <M>r</M> is again the relevant record.
##
DeclareGlobalFunction( "AtlasOfGroupRepresentationsLocalFilenameTransfer" );


#############################################################################
##
#F  AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates()
##
##  <ManSection>
##  <Func Name="AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates"
##  Arg=''/>
##
##  <Returns>
##  the list of names of all locally available data files from the
##  &ATLAS; of Group Representations that should be removed.
##  </Returns>
##  <Description>
##  This function fetches the file <F>changes.html</F> from the package's
##  home page, extracts the times of changes for the data files in question,
##  and compares them with the times of the last changes of the local data
##  files.
##  For that, the &GAP; package <Package>IO</Package>
##  <Cite Key="IO"/><Index>IO package</Index>
##  is needed;
##  if it is not available then an error message is printed,
##  and <K>fail</K> is returned.
##  <P/>
##  If the time of the last modification of a server file is later than
##  that of the local copy then the local file must be updated.
##  <Index Key="touch"><C>touch</C></Index>
##  (This means that <C>touch</C>ing files in the local directories
##  will cheat this function.)
##  <P/>
##  It is useful that a system administrator (i.&nbsp;e., someone who has
##  the permission to remove files from the data directories)
##  runs this function from time to time,
##  and afterwards removes the files in the list that is returned.
##  This way, new versions of these files will be fetched automatically
##  from the servers when a user asks for their data.
##  </Description>
##  </ManSection>
##
##  The function was documented up to version 1.5.1.
##  It does not fit to the user interface since version 2.0,
##  but providing something inthis spirit might be useful in the future.
##
DeclareGlobalFunction(
    "AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates" );


#############################################################################
##
#F  AGR.FileContents( <files>, <type> )
##
##  <#GAPDoc Label="AGRFileContents">
##  <ManSection>
##  <Func Name="AGR.FileContents" Arg='files, type'/>
##
##  <Returns>
##  the &GAP; object obtained from reading and interpreting the file(s) given
##  by <A>files</A>.
##  </Returns>
##  <Description>
##  Let <A>files</A> be a list of pairs of the form
##  <C>[ dirname, filename ]</C>,
##  where <C>dirname</C> and <C>filename</C> are strings,
##  and let <A>type</A> be a data type
##  (see <Ref Func="AGR.DeclareDataType"/>).
##  Each <C>dirname</C> must be one of <C>"datagens"</C>, <C>"dataword"</C>,
##  or the <C>dirid</C> value of a data extension
##  (see <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/>).
##  If the contents of each of the files in question is accessible
##  and their data belong to the data type <C>type</C> then
##  <Ref Func="AGR.FileContents"/> returns the contents of the files;
##  otherwise <K>fail</K> is returned.
##  <P/>
##  Note that if some file is already stored in the
##  <A>dirname</A> directory then <Ref Func="AGR.FileContents"/>
##  does <E>not</E> check whether the relevant table of contents
##  actually contains <A>filename</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##


#############################################################################
##
#V  AtlasOfGroupRepresentationsAccessFunctionsDefault
##
##  <#GAPDoc Label="AccessFunctionsDefault">
##  By default, locally available data files are stored in prescribed
##  directories,
##  and the files are exactly the text files that have been downloaded from
##  appropriate places in the internet.
##  However, a more flexible approach may be useful.
##  <P/>
##  First, one may want to use <E>different file formats</E>,
##  for example &MeatAxe; binary files may be provided
##  parallel to &MeatAxe; text files.
##  Second, one may want to use <E>a different directory structure</E>,
##  for example the same structure as used on some server
##  &ndash;this makes sense for example if a local mirror of a server
##  is available, because then one can read the server files directly,
##  without transferring/copying them to another directory.
##  <P/>
##  In order to achieve this (and perhaps more),
##  we admit to customize the meaning of the following three access steps.
##  <P/>
##  <List>
##  <Mark>Are the required data locally available?</Mark>
##  <Item>
##    There may be different file formats available,
##    such as text or binary files, and it may happen that the data are
##    available in one file or are distributed to several files.
##  </Item>
##  <Mark>How can a file be made locally available?</Mark>
##  <Item>
##    A different remote file may be fetched,
##    or some postprocessing may be required.
##  </Item>
##  <Mark>How is the data of a file accessed by &GAP;?</Mark>
##  <Item>
##    A different function may be needed to evaluate the file contents.
##  </Item>
##  </List>
##  <P/>
##  For creating an overview of the locally available data,
##  the first of these steps must be available independent of
##  actually accessing the file in question.
##  For updating the local copy of the server data,
##  the second of the above steps must be available independent of
##  the third one.
##  Therefore, the package provides the possibility to extend the default
##  behaviour by adding new records to the <C>accessFunctions</C>
##  component of <Ref Var="AtlasOfGroupRepresentationsInfo"/>.
##  The relevant record components are as follows.
##  <P/>
##  <List>
##  <Mark><C>description</C></Mark>
##  <Item>
##    This must be a short string that describes for which kinds of files
##    the functions in the current record are intended,
##    which file formats are supported etc.
##    The value is used as key in the user preference
##    <C>FileAccessFunctions</C>,
##    see Section <Ref Subsect="subsect:FileAccessFunctions"/>.
##  </Item>
##  <Mark>
##  <C>location( </C><M>files, type</M><C> )</C>
##  </Mark>
##  <Item>
##    Let <M>files</M> be a list of pairs <C>[ dirname, filename ]</C>,
##    and <M>type</M> be the data type
##    (see <Ref Func="AGR.DeclareDataType"/>) to which the files belong.
##    This function must return either the absolute paths where the
##    mechanism implemented by the current record expects the local version
##    of the given files,
##    or <K>fail</K> if this function does not feel responsible for these
##    files.
##    <P/>
##    The files are regarded as not locally available
##    if all installed <C>location</C> functions return either <K>fail</K>
##    or paths of nonexisting files,
##    in the sense of <Ref Func="IsExistingFile" BookName="ref"/>.
##  </Item>
##  <Mark>
##  <C>fetch( </C><M>filepath, filename, dirname, type</M><C> )</C>
##  </Mark>
##  <Item>
##    This function is called if a file is not locally available
##    and if the <C>location</C> function in the current record has returned
##    a list of paths.
##    The argument <M>type</M>
##    must be the same as for the <C>location</C> function,
##    and <M>filepath</M> and <M>filename</M> must be strings
##    (<E>not</E> lists of strings).
##    <P/>
##    The return value must be <K>true</K> if the function succeeded with
##    making the file locally available (including postprocessing if
##    applicable), a string with the contents of the data file if the remote
##    data were directly loaded into the &GAP; session (if no local caching
##    is possible), and <K>false</K> otherwise.
##  </Item>
##  <Mark><C>contents( </C><M>files, type, filepaths</M><C> )</C></Mark>
##  <Item>
##    This function is called when the <C>location</C> function in the
##    current record has returned the path(s) <M>filepath</M>,
##    and if either these are paths of existing files
##    or the <C>fetch</C> function in the current record has been called
##    for these paths, and the return value was <K>true</K>.
##    The first three arguments must be the same as for the <C>location</C>
##    function.
##    <P/>
##    The return value must be the contents of the file(s),
##    in the sense that the &GAP; matrix, matrix list, permutation,
##    permutation list, or program described by the file(s) is returned.
##    This means that besides reading the file(s) via the appropriate
##    function, interpreting the contents may be necessary.
##  </Item>
##  </List>
##  <P/>
##  In <Ref Func="AGR.FileContents"/>, those records in the
##  <C>accessFunctions</C> component of
##  <Ref Var="AtlasOfGroupRepresentationsInfo"/> are considered
##  &ndash;in reversed order&ndash;
##  whose <C>description</C> component occurs in the user preference
##  <C>FileAccessFunctions</C>,
##  see Section <Ref Subsect="subsect:FileAccessFunctions"/>.
##  <#/GAPDoc>
##
DeclareGlobalVariable( "AtlasOfGroupRepresentationsAccessFunctionsDefault" );


#############################################################################
##
##  The Tables of Contents of the Atlas of Group Representations
##
##  <#GAPDoc Label="toc">
##  The list of &AtlasRep; data is stored in several
##  <E>tables of contents</E>,
##  which are given essentially by JSON documents,
##  one for the core data and one for each data extension in the sense of
##  Chapter <Ref Chap="chap:Private Extensions"/>.
##  The only exception are data extensions by locally available files in a
##  given directory, where the contents of this directory itself describes
##  the data in question.
##  One can create such a JSON document for the contents of a given local
##  data directory with the function
##  <Ref Func="StringOfAtlasTableOfContents"/>.
##  <P/>
##  Here are the administrational functions that are called
##  when a data extension gets notified with
##  <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/>.
##  In each case, <M>gapname</M> and <M>atlasname</M> denote the &GAP; and
##  &ATLAS; name of the group in question
##  (see Section <Ref Sect="sect:Group Names Used in the AtlasRep Package"/>),
##  and <M>dirid</M> denotes the identifier of the data extension.
##  <P/>
##  The following functions define group names, available representations,
##  and straight line programs.
##  <P/>
##  <List>
##  <#Include Label="AGR.GNAN">
##  <#Include Label="AGR.TOC">
##  </List>
##  <P/>
##  The following functions add data about the groups and their
##  standard generators.
##  The function calls must be executed after the corresponding
##  <C>AGR.GNAN</C> calls.
##  <P/>
##  <List>
##  <#Include Label="AGR.GRS">
##  <#Include Label="AGR.MXN">
##  <#Include Label="AGR.MXO">
##  <#Include Label="AGR.MXS">
##  <#Include Label="AGR.STDCOMP">
##  </List>
##  <P/>
##  The following functions add data about representations or
##  straight line programs that are already known.
##  The function calls must be executed after the corresponding
##  <C>AGR.TOC</C> calls.
##  <P/>
##  <List>
##  <#Include Label="AGR.RNG">
##  <#Include Label="AGR.TOCEXT">
##  <#Include Label="AGR.API">
##  <#Include Label="AGR.CHAR">
##  </List>
##  <#/GAPDoc>
##


#############################################################################
##
#F  AtlasStringOfFieldOfMatrixEntries( <mats> )
#F  AtlasStringOfFieldOfMatrixEntries( <filename> )
##
##  <ManSection>
##  <Func Name="AtlasStringOfFieldOfMatrixEntries" Arg='mats'/>
##  <Func Name="AtlasStringOfFieldOfMatrixEntries" Arg='filename'/>
##
##  <Description>
##  For a nonempty list <A>mats</A> of matrices of cyclotomics,
##  let <M>F</M> be the field generated by all matrix entries.
##  <Ref Func="AtlasStringOfFieldOfMatrixEntries"/> returns a pair
##  <M>[ F, descr ]</M>
##  where <M>descr</M> is a string describing <M>F</M>, as follows.
##  If <M>F</M> is a quadratic field then <M>descr</M> is of the form
##  <C>"Field([Sqrt(</C><M>n</M><C>)])"</C> where <M>n</M> is an integer;
##  if <M>F</M> is the <M>n</M>-th cyclotomic field,
##  for a positive integer <M>n</M>
##  then <M>descr</M> is of the form <C>"Field([E(</C><M>n</M><C>)])"</C>;
##  otherwise <M>descr</M> is the <Ref Func="String" BookName="ref"/> value
##  of the field object.
##  <P/>
##  If the argument is a string <A>filename</A> then <A>mats</A> is obtained
##  by reading the file with name <A>filename</A> via
##  <Ref Func="ReadAsFunction" BookName="ref"/>.
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "AtlasStringOfFieldOfMatrixEntries" );


#############################################################################
##
#F  AtlasTableOfContents( <tocid>, <allorlocal> )
##
##  <ManSection>
##  <Func Name="AtlasTableOfContents" Arg='tocid, allorlocal'/>
##
##  <Description>
##  The function returns a record whose
##  components are <C>lastupdated</C> (date and time of the last update of
##  this table of contents) and the names that occur at the second position
##  in the entries of <C>AtlasOfGroupRepresentationsInfo.GAPnames</C>;
##  the value of each such component is a record whose components are the
##  names of the available data types, see
##  <Ref Sect="sect:Data Types Used in the ATLAS of Group Representations"/>,
##  for example <C>perm</C>, <C>matff</C>, <C>classes</C>, and <C>maxes</C>,
##  all lists.
##  <A>tocid</A> must be <C>"core"</C> or the identifier of an extension.
##  <A>allorlocal</A> must be one of <C>"all"</C> or <C>"local"</C>,
##  where <C>"local"</C> means that only the locally available data are
##  considered.
##  <P/>
##  Once a (local or remote) table of contents has been computed using
##  <Ref Func="AtlasTableOfContents"/>,
##  it is stored in the <C>TableOfContents</C> component of
##  <Ref Var="AtlasOfGroupRepresentationsInfo"/>,
##  and is just fetched when <Ref Func="AtlasTableOfContents"/> is called
##  again.
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "AtlasTableOfContents" );


#############################################################################
##
#F  StringOfAtlasTableOfContents( <inforec> )
##
##  <#GAPDoc Label="StringOfAtlasTableOfContents">
##  <ManSection>
##  <Func Name="StringOfAtlasTableOfContents" Arg='inforec'/>
##
##  <Description>
##  For a record <A>inforec</A> with at least the component <C>ID</C>,
##  with value <C>"core"</C> or the identifier of a data extension
##  (see <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/>),
##  this function returns a string that describes the part of &AtlasRep; data
##  belonging to <A>inforec</A><C>.ID</C>.
##  <P/>
##  Printed to a file, the returned string can be used
##  as the table of contents of this part of the data.
##  For that purpose, also the following components of <A>inforec</A> must be
##  bound (all strings).
##  <C>Version</C>,
##  <C>SelfURL</C>
##    (the internet address of the table of contents file itself).
##  At least one of the following two components must be bound.
##  <C>DataURL</C> is the internet address of the directory from where the
##  data in question can be downloaded.
##  <C>LocalDirectory</C> is a path relative to &GAP;'s <F>pkg</F> directory
##  where the data may be stored locally (depending on whether some &GAP;
##  package is installed).
##  If the component <C>DataURL</C> is bound then the returned string
##  contains the information about the data files;
##  this is not necessary if the data are <E>only</E> locally available.
##  If both <C>DataURL</C> and <C>LocalDirectory</C> are bound then locally
##  available data will be prefered at runtime.
##  <P/>
##  Alternatively, <A>inforec</A> can also be the <C>ID</C> string;
##  in this case, the values of those of the supported components
##  mentioned above that are defined in an available JSON file for this
##  <C>ID</C> are automatically inserted.
##  (If there is no such file yet then entering the <C>ID</C> string as
##  <A>inforec</A> does not make sense.)
##  <P/>
##  For an example how to use the function,
##  see Section <Ref Sect="sect:An Example of Extending AtlasRep"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "StringOfAtlasTableOfContents" );


#############################################################################
##
##  <#GAPDoc Label="addprivate">
##  After the &AtlasRep; package has been loaded into the &GAP; session,
##  one can extend the data which the interface can access by own
##  representations and programs.
##  The following two variants are supported.
##  <P/>
##  <List>
##  <Item>
##    The additional data files are locally available in some directory.
##    Information about the declaration of new groups or about
##    additional information such as the character names of representations
##    can be provided in an optional JSON format file named
##    <F>toc.json</F> in this directory.
##  </Item>
##  <Item>
##    The data files can be downloaded from the internet.
##    Both the list of available data and additional information as in
##    the above case are given by either a local JSON format file or
##    the URL of a JSON format file.
##    This variant requires the user preference
##    <C>AtlasRepAccessRemoteFiles</C>
##    (see Section <Ref Subsect="subsect:AtlasRepAccessRemoteFiles"/>)
##    to have the value <K>true</K>.
##  </Item>
##  </List>
##  <P/>
##  In both cases,
##  <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/> can be
##  used to make the private data available to the interface.
##  <#/GAPDoc>
##
##  It should be noted that a data file is fetched from a server only if
##  the local data directories do not contain a file with this name,
##  independent of the contents of the files.
##  (As a consequence, corrupted files in the local data directories are
##  <E>not</E> automatically replaced by correct server files.)
##


#############################################################################
##
#F  AtlasOfGroupRepresentationsNotifyData( <dir>, <id>[, <test>] )
#F  AtlasOfGroupRepresentationsNotifyData( <filename>[, <id>][, <test>] )
#F  AtlasOfGroupRepresentationsNotifyData( <url>[, <id>][, <test>] )
##
##  <#GAPDoc Label="AtlasOfGroupRepresentationsNotifyData">
##  <ManSection>
##  <Heading>AtlasOfGroupRepresentationsNotifyData</Heading>
##  <Func Name="AtlasOfGroupRepresentationsNotifyData" Arg='dir, id[, test]'
##   Label="for a local directory of private data"/>
##  <Func Name="AtlasOfGroupRepresentationsNotifyData"
##   Arg='filename[, id][, test]'
##   Label="for a local file describing private data"/>
##  <Func Name="AtlasOfGroupRepresentationsNotifyData"
##   Arg='url[, id][, test]'
##   Label="for a remote file describing private data"/>
##
##  <Returns>
##  <K>true</K> if the overview of the additional data can be evaluated and
##  if the names of the data files in the extension are compatible
##  with the data files that had been available before the call,
##  otherwise <K>false</K>.
##  </Returns>
##
##  <Description>
##  The following variants are supported for notifying additional data.
##  <P/>
##  <List>
##  <Mark>Contents of a local directory</Mark>
##  <Item>
##    The first argument <A>dir</A> must be either a local directory
##    (see <Ref Sect="Directories" BookName="ref"/>)
##    or a string denoting the path of a local directory,
##    such that the &GAP; object describing this directory can be obtained
##    by calling <Ref Func="Directory" BookName="ref"/> with the argument
##    <A>dir</A>;
##    in the latter case, <A>dir</A> can be an absolute path or a path
##    relative to the user's home directory (starting with a tilde character
##    <C>~</C>) or a path relative to the directory where &GAP; was started.
##    The files contained in this directory or in its subdirectories
##    (only one level deep) are considered.
##    If the directory contains a JSON document in a file with the name
##    <F>toc.json</F> then this file gets evaluated;
##    its purpose is to provide additional information about the data files.
##    <P/>
##    Calling <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local directory of private data"/>
##    means to evaluate the contents of the directory
##    and (if available) of the file <F>toc.json</F>.
##    <P/>
##    Accessing data means to read the locally available data files.
##    <P/>
##    The argument <A>id</A> must be a string.
##    It will be used in the <C>identifier</C> components of the records
##    that are returned by interface functions (see
##    Section&nbsp;<Ref Sect="sect:Accessing Data of the AtlasRep Package"/>)
##    for data contained in the directory <A>dir</A>.
##    (Note that the directory name may be different in different &GAP;
##    sessions or for different users who want to access the same data,
##    whereas the <C>identifier</C> components shall be independent of such
##    differences.)
##    <P/>
##    An example of a local extension is the contents of the
##    <F>datapkg</F> directory of the &AtlasRep; package.
##    This extension gets notified automatically when &AtlasRep; gets loaded.
##    For restricting data collections to this extension,
##    one can use the identifier <C>"internal"</C>.
##  </Item>
##  <Mark>Local file describing the contents of a local or remote directory</Mark>
##  <Item>
##    The first argument <A>filename</A> must be the name of a local file
##    whose content is a JSON document that lists the available data,
##    additional information about these data,
##    and an URL from where the data can be downloaded.
##    The data format of this file is defined by the JSON schema file
##    <F>doc/atlasreptoc_schema.json</F> of the &AtlasRep; package.
##    <P/>
##    Calling <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>
##    means to evaluate the contents of the file <A>filename</A>,
##    without trying to access the remote data.
##    The <A>id</A> is then either given implicitly by the <C>ID</C> component
##    of the JSON document or can be given as the second argument.
##    <P/>
##    Downloaded data files are stored in the subdirectory
##    <F>dataext/</F><A>id</A> of the directory that is given by the
##    user preference <C>AtlasRepDataDirectory</C>,
##    see Section <Ref Subsect="subsect:AtlasRepDataDirectory"/>.
##    <P/>
##    Accessing data means to download remote files if necessary but to
##    prefer files that are already locally available.
##    <P/>
##    An example of such an extension is the set of permutation
##    representations provided by the <Package>MFER</Package> package
##    <Cite Key="MFER"/>;
##    due to the file sizes, these representations are <E>not</E> distributed
##    together with the <Package>MFER</Package> package.
##    For restricting data collections to this extension,
##    one can use the identifier <C>"mfer"</C>.
##    <P/>
##    Another example is given by some of the data that belong to the
##    <Package>CTBlocks</Package> package <Cite Key="CTBlocks"/>.
##    These data are also distributed with that package,
##    and notifying the extension in the situation that the
##    <Package>CTBlocks</Package> package is available will make its
##    local data available,
##    via the component <C>LocalDirectory</C> of the JSON document
##    <F>ctblocks.json</F>;
##    notifying the extension in the situation that the
##    <Package>CTBlocks</Package> package is <E>not</E> available
##    will make the remote files available,
##    via the component <C>DataURL</C> of this JSON document.
##    For restricting data collections to this extension,
##    one can use the identifier <C>"ctblocks"</C>.
##  </Item>
##  <Mark>URL of a file</Mark>
##  <Item>
##    (This variant works only if the <Package>IO</Package> package
##    <Cite Key="IO"/> is available.)
##    <P/>
##    The first argument <A>url</A> must be the URL of a JSON document
##    as in the previous case.
##    <P/>
##    Calling <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a remote file describing private data"/>
##    in <E>online mode</E> (that is, the user preference
##    <C>AtlasRepAccessRemoteFiles</C> has the value <K>true</K>)
##    means to download this file and to evaluate it;
##    the <A>id</A> is then given implicitly by the <C>ID</C> component
##    of the JSON document,
##    and the contents of the document gets stored in a file with name
##    <F>dataext/</F><A>id</A><F>/toc.json</F>,
##    relative to the directory given by the value of the user preference
##    <C>AtlasRepDataDirectory</C>.
##    Also downloaded files for this extension will be stored in the
##    directory <F>dataext/</F><A>id</A>.
##    <P/>
##    Calling <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a remote file describing private data"/>
##    in <E>offline mode</E> requires that the argument <A>id</A> is
##    explicitly given.
##    In this case, it is checked whether the <F>dataext</F> subdirectory
##    contains a subdirectory with name <A>id</A>;
##    if not then <K>false</K> is returned,
##    if yes then the contents of this local directory gets notified via the
##    first form described above.
##    <P/>
##    Accessing data in online mode means the same as in the case of a
##    remote directory.
##    Accessing data in offline mode means the same as in the case of a
##    local directory.
##    <P/>
##    Examples of such extension are again the data from the packages
##    <Package>CTBlocks</Package> and <Package>MFER</Package> described
##    above, but in the situation that these packages are <E>not</E> loaded,
##    and that just the web URLs of their JSON documents are entered which
##    describe the contents.
##  </Item>
##  </List>
##  <P/>
##  In all three cases,
##  if the optional argument <A>test</A> is given then it must be either
##  <K>true</K> or <K>false</K>.
##  In the <K>true</K> case, consistency checks are switched on during the
##  notification.
##  The default for <A>test</A> is <K>false</K>.
##  <P/>
##  The notification of an extension may happen as a side-effect
##  when a &GAP; package gets loaded that provides the data in question.
##  Besides that, one may collect the notifications of data extensions
##  in one's <F>gaprc</F> file (see
##  Section&nbsp;<Ref Sect="The gap.ini and gaprc files" BookName="ref"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasOfGroupRepresentationsNotifyData" );


#############################################################################
##
#F  AtlasOfGroupRepresentationsForgetData( <dirid> )
##
##  <#GAPDoc Label="AtlasOfGroupRepresentationsForgetData">
##  <ManSection>
##  <Func Name="AtlasOfGroupRepresentationsForgetData"
##   Arg='dirid'/>
##
##  <Description>
##  If <A>dirid</A> is the identifier of a database extension that has been
##  notified with
##  <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##  Label="for a local file describing private data"/>
##  then <Ref Func="AtlasOfGroupRepresentationsForgetData"/>
##  undoes the notification;
##  this means that from then on, the data of this extension cannot be
##  accessed anymore in the current session.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasOfGroupRepresentationsForgetData" );


#############################################################################
##
#E

