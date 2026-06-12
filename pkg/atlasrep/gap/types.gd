#############################################################################
##
#W  types.gd             GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains declarations of the functions for administrating
##  the data types used in the &ATLAS; of Group Representations.
##


#############################################################################
##
#F  AGR.DeclareDataType( <kind>, <name>, <record> )
##
##  <#GAPDoc Label="AGRDeclareDataType">
##  <ManSection>
##  <Func Name="AGR.DeclareDataType" Arg='kind, name, record'/>
##
##  <Description>
##  Let <A>kind</A> be one of the strings <C>"rep"</C> or <C>"prg"</C>,
##  and <A>record</A> be a record.
##  If <A>kind</A> is <C>"rep"</C> then <Ref Func="AGR.DeclareDataType"/>
##  declares a new data type of representations,
##  if <A>kind</A> is <C>"prg"</C> then it declares a new data type of
##  programs.
##  The string <A>name</A> is the name of the type,
##  for example <C>"perm"</C>, <C>"matff"</C>, or <C>"classes"</C>.
##  &AtlasRep; stores the data for each group internally in a record
##  whose component <A>name</A> holds the list of the data about the type
##  with this name.
##  <P/>
##  <E>Mandatory components</E> of <A>record</A> are
##  <P/>
##  <List>
##  <Mark><C>FilenameFormat</C></Mark>
##  <Item>
##    This defines the format of the filenames containing data of the type
##    in question.
##    The value must be a list that can be used as the second argument of
##    <Ref Func="AGR.ParseFilenameFormat"/>,
##    such that only filenames of the type in question match.
##    (It is not checked whether this <Q>detection function</Q> matches
##    exactly one type, so declaring a new type needs care.)
##  </Item>
##  <Mark><C>AddFileInfo</C></Mark>
##  <Item>
##    This defines the information stored in the table of contents for the
##    data of the type.
##    The value must be a function that takes three arguments (the current
##    list of data for the type and the given group, a list returned
##    by <Ref Func="AGR.ParseFilenameFormat"/> for the given type,
##    and a filename).
##    This function adds the necessary parts of the data entry to the list,
##    and returns <K>true</K> if the data belongs to the type,
##    otherwise <K>false</K> is returned;
##    note that the latter case occurs if the filename matches the format
##    description but additional conditions on the parts of the name are
##    not satisfied (for example integer parts may be required to be
##    positive or prime powers).
##  </Item>
##  <Mark><C>ReadAndInterpretDefault</C></Mark>
##  <Item>
##    This is the function that does the work for the default
##    <C>contents</C> value of the <C>accessFunctions</C> component of
##    <Ref Var="AtlasOfGroupRepresentationsInfo"/>, see
##    Section&nbsp;<Ref Sect="sect:How to Customize the Access to Data files"/>.
##    This function must take a path and return the &GAP; object given by
##    this file.
##  </Item>
##  <Mark><C>AddDescribingComponents</C> (for <C>rep</C> only)</Mark>
##  <Item>
##    This function takes two arguments, a record (that will be returned by
##    <Ref Func="AtlasGenerators"/>, <Ref Func="OneAtlasGeneratingSetInfo"/>,
##    or <Ref Func="AllAtlasGeneratingSetInfos"/>) and the type record
##    <A>record</A>.
##    It sets the components <C>p</C>, <C>dim</C>, <C>id</C>, and <C>ring</C>
##    that are promised for return values of the abovementioned three
##    functions.
##  </Item>
##  <Mark><C>DisplayGroup</C> (for <C>rep</C> only)</Mark>
##  <Item>
##    This defines the format of the lines printed by
##    <Ref Func="DisplayAtlasInfo"/> for a given group.
##    The value must be a function that takes a list as returned by the
##    function given in the component <C>AddFileInfo</C>, and returns the
##    string to be printed for the representation in question.
##  </Item>
##  </List>
##  <P/>
##  <E>Optional components</E> of <A>record</A> are
##  <P/>
##  <List>
##  <Mark><C>DisplayOverviewInfo</C></Mark>
##  <Item>
##    This is used to introduce a new column in the output of
##    <Ref Func="DisplayAtlasInfo"/> when this is called
##    without arguments or with a list of group names as its only argument.
##    The value must be a list of length three, containing at its first
##    position a string used as the header of the column, at its second
##    position one of the strings <C>"r"</C> or <C>"l"</C>,
##    denoting right or left aligned column entries,
##    and at its third position a function that takes two arguments
##    (a list of tables of contents of the &AtlasRep;
##    package and a group name), and returns a list of length two,
##    containing the string to be printed as the column value and
##    <K>true</K> or <K>false</K>,
##    depending on whether private data is involved or not.
##    (The default is <K>fail</K>,
##    indicating that no new column shall be printed.)
##  </Item>
##  <Mark><C>DisplayPRG</C> (for <C>prg</C> only)</Mark>
##  <Item>
##    This is used in <Ref Func="DisplayAtlasInfo"/> for &ATLAS; programs.
##    The value must be a function that takes four arguments
##    (a list of tables of contents to examine,
##    a list containing the &GAP; name and the &ATLAS; name of the given
##    group,
##    a list of integers or <K>true</K> for the required standardization,
##    and a list of all available standardizations),
##    and returns the list of lines (strings) to be printed as the
##    information about the available programs of the current type and for
##    the given group.
##    (The default is to return an empty list.)
##  </Item>
##  <Mark><C>AccessGroupCondition</C> (for <C>rep</C> only)</Mark>
##  <Item>
##    This is used in <Ref Func="DisplayAtlasInfo"/> and
##    <Ref Func="OneAtlasGeneratingSetInfo"/>.
##    The value must be a function that takes two arguments
##    (a list as returned by <Ref Func="OneAtlasGeneratingSetInfo"/>,
##    and a list of conditions),
##    and returns <K>true</K> or <K>false</K>, depending on whether the
##    first argument satisfies the conditions.
##    (The default value is <Ref Func="ReturnFalse" BookName="ref"/>.)
##    <P/>
##    The function must support conditions such as
##    <C>[ IsPermGroup, true ]</C> and <C>[ NrMovedPoints, [ 5, 6 ] ]</C>,
##    in general a list of functions followed by a prescribed value,
##    a list of prescribed values, another (unary) function,
##    or the string <C>"minimal"</C>.
##    For an overview of the interesting functions,
##    see&nbsp;<Ref Func="DisplayAtlasInfo"/>.
##  </Item>
##  <Mark><C>AccessPRG</C> (for <C>prg</C> only)</Mark>
##  <Item>
##    This is used in <Ref Func="AtlasProgram"/>.
##    The value must be a function that takes four arguments (the current
##    table of contents, the group name, an integer or a list of integers
##    or <K>true</K> for the required standardization, and a list of
##    conditions given by the optional arguments of
##    <Ref Func="AtlasProgram"/>),
##    and returns either <K>fail</K> or a list that together with the group
##    name forms the identifier of a program that matches the
##    conditions.
##    (The default value is <Ref Func="ReturnFail" BookName="ref"/>.)
##  </Item>
##  <Mark><C>AtlasProgram</C> (for <C>prg</C> only)</Mark>
##  <Item>
##    This is used in <Ref Func="AtlasProgram"/> to create the
##    result value from the identifier.
##    (The default value is <C>AtlasProgramDefault</C>, which
##    works whenever the second entry of the identifier is the filename;
##    this is not the case for example if the program is the composition of
##    several programs.)
##  </Item>
##  <Mark><C>AtlasProgramInfo</C> (for <C>prg</C> only)</Mark>
##  <Item>
##    This is used in <Ref Func="AtlasProgramInfo"/> to create the
##    result value from the identifier.
##    (The default value is <C>AtlasProgramDefault</C>.)
##  </Item>
##  <Mark><C>TOCEntryString</C></Mark>
##  <Item>
##    This is used in <Ref Func="StringOfAtlasTableOfContents"/>.
##    The value must be a function that takes two or three arguments
##    (the name <A>name</A> of the type, a list as returned by
##    <Ref Func="AGR.ParseFilenameFormat"/>,
##    and optionally a string that indicates the <Q>remote</Q> format)
##    and returns a string that describes the appropriate data format.
##    (The default value is <C>TOCEntryStringDefault</C>.)
##  </Item>
##  <Mark><C>PostprocessFileInfo</C></Mark>
##  <Item>
##    This is used in the construction of a table of contents
##    for testing or rearranging the data of the current table of contents.
##    The value must be a function that takes two arguments,
##    the table of contents record and the record in it that belongs to
##    one fixed group.
##    (The default function does nothing.)
##  </Item>
##  <Mark><C>SortTOCEntries</C></Mark>
##  <Item>
##    This is used in the construction of a table of contents
##    for sorting the entries after they have been added and after the
##    value of the component <C>PostprocessFileInfo</C> has been called.
##    The value must be a function that takes a list as returned by
##    <Ref Func="AGR.ParseFilenameFormat"/>,
##    and returns the sorting key.
##    (There is no default value, which means that no sorting is needed.)
##  </Item>
##  <Mark><C>TestFileHeaders</C> (for <C>rep</C> only)</Mark>
##  <Item>
##    This is used in the function <C>AGR.Test.FileHeaders</C>.
##    The value must be a function that takes the same four arguments as
##    <Ref Func="AGR.FileContents"/>,
##    except that the third argument is a list as returned by
##    <Ref Func="AGR.ParseFilenameFormat"/>.
##    (The default value is <Ref Func="ReturnTrue" BookName="ref"/>.)
##  </Item>
##  <Mark><C>TestFiles</C> (for <C>rep</C> only)</Mark>
##  <Item>
##    This is used in the function <C>AGR.Test.Files</C>.
##    The format of the value and the default are the same as for
##    the component <C>TestFileHeaders</C>.
##  </Item>
##  <Mark><C>TestWords</C> (for <C>prg</C> only)</Mark>
##  <Item>
##    This is used in the function <C>AGR.Test.Words</C>.
##    The value must be a function that takes five arguments where the first
##    four are the same arguments as for <Ref Func="AGR.FileContents"/>,
##    except that the fifth argument is <K>true</K> or <K>false</K>,
##    indicating verbose mode or not.
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##


#############################################################################
##
#V  AtlasOfGroupRepresentationsInfo
##
##  <#GAPDoc Label="AtlasOfGroupRepresentationsInfo">
##  <ManSection>
##  <Var Name="AtlasOfGroupRepresentationsInfo"/>
##
##  <Description>
##  This is a record that is defined in the file <F>gap/types.g</F> of the
##  package, with the following components.
##  <P/>
##  <List>
##  <Mark><C>GAPnames</C></Mark>
##  <Item>
##    a list of pairs, each containing the &GAP; name and the
##    &ATLAS;-file name of a group, see
##    Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>,
##  </Item>
##  <Mark><C>notified</C></Mark>
##  <Item>
##    a list used for administrating extensions of the database
##    (see Chapter&nbsp;<Ref Chap="chap:Private Extensions"/>);
##    the value is changed by
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>
##    and <Ref Func="AtlasOfGroupRepresentationsForgetData"/>,
##  </Item>
##  <Mark><C>characterinfo</C>, <C>permrepinfo</C>, <C>ringinfo</C></Mark>
##  <Item>
##    additional information about representations,
##    concerning the afforded characters,
##    the point stabilizers of permutation representations, and
##    the rings of definition of matrix representations;
##    this information is used by <Ref Func="DisplayAtlasInfo"/>,
##  </Item>
##  <Mark><C>TableOfContents</C></Mark>
##  <Item>
##    a record with at most the components <C>core</C>, <C>internal</C>,
##    <C>local</C>, <C>merged</C>, <C>types</C>,
##    and the identifiers of database extensions.
##    The value of the component <C>types</C> is set in
##    <Ref Func="AGR.DeclareDataType"/>,
##    and the values of the other components are created by
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>.
##  </Item>
##  <Mark><C>accessFunctions</C></Mark>
##  <Item>
##    a list of records, each describing how to access the data files, see
##    Sections <Ref Subsect="subsect:FileAccessFunctions"/>
##    and <Ref Sect="sect:How to Customize the Access to Data files"/>,
##    and
##  </Item>
##  </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  We want to delay reading the table of contents until the data are really
##  accessed.
##
DeclareAutoreadableVariables( "atlasrep", "gap/types.g",
    [ "AtlasOfGroupRepresentationsInfo" ] );


#############################################################################
##
#A  Maxes( <tbl> )
##
##  <ManSection>
##  <Attr Name="Maxes" Arg='tbl'/>
##
##  <Description>
##  In some consistency checks, the &GAP; Character Table Library is used.
##  Since the AtlasRep package does not require the table library,
##  we declare the missing variables in order to avoid error messages.
##  </Description>
##  </ManSection>
##
if not IsBound( Maxes ) then
  DeclareAttribute( "Maxes", IsUnknown );
  InstallMethod( Maxes, [ IsUnknown ], Error );
fi;


#############################################################################
##
#E

