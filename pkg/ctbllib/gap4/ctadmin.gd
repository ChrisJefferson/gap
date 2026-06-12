#############################################################################
##
#W  ctadmin.gd           GAP 4 package CTblLib                  Thomas Breuer
#W                                                               Ute Schiffer
##
##  This file contains the declaration part of the data of the GAP
##  character table library that is not automatically produced from the
##  library files.
##
##  0. Global variables to handle the table library.
##  1. Representations of library tables
##  2. Functions used in the library files
##  3. Functions to construct library tables
##  4. Functions used as `construction' component of library tables
##  5. Selection functions for the table library
##  6. Functions to produce tables in library format
##


#############################################################################
##
##  <#GAPDoc Label="organization">
##  <Subsection Label="subsec:CTblLib data files">
##  <Heading>Data Files of the &GAP; Character Table Library</Heading>
##
##  The data files of the &GAP; Character Table Library
##  reside in the <F>data</F> directory of the package &CTblLib;.
##  <P/>
##  The filenames start with <C>ct</C> (for <Q>character table</Q>),
##  followed by either <C>o</C> (for <Q>ordinary</Q>),
##  <C>b</C> (for <Q>Brauer</Q>),
##  or <C>g</C> (for <Q>generic</Q>),
##  then a description of the contents (up to <M>5</M> characters,
##  e.&nbsp;g.,
##  <C>alter</C> for the tables of alternating and related groups),
##  and the suffix <C>.tbl</C>.
##  <P/>
##  The file <C>ctb</C><M>descr</M><C>.tbl</C> contains the known Brauer
##  tables corresponding to the ordinary tables in the file
##  <C>cto</C><M>descr</M><C>.tbl</C>.
##  <P/>
##  Each data file of the table library is supposed to consist of
##  <Enum>
##  <Item>
##    comment lines, starting with a hash character <C>#</C>
##    in the first column,
##  </Item>
##  <Item>
##    an assignment to a component of <C>LIBTABLE.LOADSTATUS</C>,
##    at the end of the file, and
##  </Item>
##  <Item>
##    function calls of the form
##    <List>
##    <Item>
##      <C>MBT( </C><M>name, data</M><C> )</C>
##      (<Q>make Brauer table</Q>),
##    </Item>
##    <Item>
##      <C>MOT( </C><M>name, data</M><C> )</C>
##      (<Q>make ordinary table</Q>),
##    </Item>
##    <Item>
##      <C>ALF( </C><M>from, to, map</M><C> )</C>,
##      <C>ALF( </C><M>from, to, map, textlines</M><C> )</C>
##      (<Q>add library fusion</Q>),
##    </Item>
##    <Item>
##      <C>ALN( </C><M>name, listofnames</M><C> )</C>
##      (<Q>add library name</Q>), and
##    </Item>
##    <Item>
##      <C>ARC( </C><M>name, component, compdata</M><C> )</C>
##      (<Q>add record component</Q>).
##    </Item>
##    </List>
##    <P/>
##    Here <M>name</M> must be the identifier value of the ordinary character
##    table corresponding to the table to which the command refers;
##    <M>data</M> must be a comma separated sequence of &GAP; objects;
##    <M>from</M> and <M>to</M> must be identifier values of ordinary
##    character tables,
##    <M>map</M> a list of positive integers,
##    <M>textlines</M> and <M>listofnames</M> lists list of strings,
##    <M>component</M> a string, and
##    <M>compdata</M> any &GAP; object.
##    <P/>
##    <C>MOT</C>, <C>ALF</C>, <C>ALN</C>, and <C>ARC</C>
##    occur only in files containing ordinary character tables,
##    and <C>MBT</C> occurs only in files containing Brauer tables.
##  </Item>
##  </Enum>
##  <P/>
##  Besides the above calls, the data in files containing ordinary and Brauer
##  tables may contain only the following &GAP; functions.
##  (Files containing generic character tables may contain calls to
##  arbitrary &GAP; library functions.)
##  <P/>
##  <C>ACM</C>,
##  <Ref Func="Concatenation" BookName="ref"/>,
##  <Ref Func="E" BookName="ref"/>,
##  <C>EvalChars</C>,
##  <C>GALOIS</C>,
##  <Ref Func="Length" BookName="ref"/>,
##  <Ref Func="ShallowCopy" BookName="ref"/>,
##  <C>TENSOR</C>, and
##  <Ref Func="TransposedMat" BookName="ref"/>.
##  <P/>
##  The function <C>CTblLib.RecomputeTOC</C> in the file <F>gap4/maketbl.g</F>
##  of the &CTblLib; package expects the file format described above,
##  and to some extent it checks this format.
##  <P/>
##  The function calls may be continued over several lines of a file.
##  A semicolon is assumed to be the last character in its line
##  if and only if it terminates a function call.
##  <P/>
##  Names of character tables are strings
##  (see Chapter&nbsp;<Ref Chap="Strings and Characters" BookName="ref"/>),
##  i.&nbsp;e., they are enclosed in double quotes;
##  <E>strings in table library files must not be split over several
##  lines</E>, because otherwise the function <C>CTblLib.RecomputeTOC</C> may
##  get confused.
##  Additionally, no character table name is allowed to contain double
##  quotes.
##  <P/>
##  There are three different ways how the table data can be stored in the
##  file.
##  <P/>
##  <List>
##  <Mark>Full ordinary tables</Mark>
##  <Item>
##    are encoded by a call to the function <C>MOT</C>,
##    where the arguments correspond to the relevant attribute values;
##    each fusion into another library table is added by a call to
##    <C>ALF</C>, values to be stored in components of the table object
##    are added with <C>ARC</C>, and admissible names are notified with
##    <C>ALN</C>.
##    The argument of <C>MOT</C> that encodes the irreducible characters is
##    abbreviated as follows.
##    For each subset of characters that differ just by multiplication with a
##    linear character or by Galois conjugacy, only the first one is given by
##    its values, the others are replaced by
##    <C>[TENSOR,[i,j]]</C> (which means that the character is the tensor
##    product of the <C>i</C>-th and the <C>j</C>-th character in the list)
##    or <C>[GALOIS,[i,j]]</C> (which means that the character is obtained from
##    the <C>i</C>-th character by applying <C>GaloisCyc( ., j )</C> to it).
##  </Item>
##  <Mark>Brauer tables</Mark>
##  <Item>
##    are stored relative to the corresponding ordinary
##    tables; attribute values that can be computed by restricting from the
##    ordinary table to <M>p</M>-regular classes are not stored,
##    and instead of the irreducible characters the files contain
##    (inverses of) decomposition matrices or Brauer trees for the blocks of
##    nonzero defect.
##  </Item>
##  <Mark>Ordinary construction tables</Mark>
##  <Item>
##    have the attribute
##    <Ref Func="ConstructionInfoCharacterTable"/> set,
##    with value a list that contains the name of the construction
##    function used and the arguments for a call to this function;
##    the function call is performed by
##    <Ref Func="CharacterTable" BookName="ref"/> when the table is constructed
##    (<E>not</E> when the file containing the table is read).
##    One aim of this mechanism is to store structured character tables such as
##    tables of direct products and tables of central extensions of other
##    tables in a compact way,
##    see Chapter <Ref Chap="chap:constructions"/>.
##  </Item>
##  </List>
##
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
##  0. Global variables to handle the table library.
##

BindGlobal( "CTblLib", rec(
    SupportedAttributes:= [ "Identifier" ],
    Test:= rec(),
    Data:= rec(),
  ) );


#############################################################################
##
#V  LIBTABLE
##
##  is a record with the components
##  <P/>
##  <List>
##  <Mark><C>LOADSTATUS</C></Mark>
##  <Item>
##     a record whose components are names of files in the table library,
##     with value one of <C>"loaded"</C>, <C>"unloaded"</C>,
##     <C>"userloaded"</C>,
##  </Item>
##  <Mark><C>TABLEFILENAME</C></Mark>
##  <Item>
##     the name of the file that is currently read
##     (is set by <C>ReadTbl</C>),
##  </Item>
##  <Mark><C>unload</C></Mark>
##  <Item>
##     a Boolean, only one file with ordinary character tables plus perhaps
##     the corresponding file with Brauer tables is kept in memory if the
##     value is <K>true</K> (which is the default),
##  </Item>
##  <Mark><C>clmelab</C></Mark>
##  <Item>
##     the list for Clifford matrices of extensions by elementary abelian
##     normal subgroups
##  </Item>
##  <Mark><C>clmexsp</C></Mark>
##  <Item>
##     the list for Clifford matrices of extensions by extraspecial normal
##     subgroups
##  </Item>
##  </List>
##  <P/>
##  Additionally the filenames of loaded and userloaded files occur as
##  components, with values the lists of data stored in the files.
##
DeclareGlobalVariable( "LIBTABLE" );


#############################################################################
##
##  OrderCyc( <cyc> )
##
##  This is needed for backward compatibility.
##  A call of `OrderCyc' (with one argument) occurs in `ctgeneri.tbl',
##  it cannot be replaced by `Order' because GAP 3 does not accept it.
##
DeclareSynonym( "OrderCyc", Order );


#############################################################################
##
##  1. Representations of library tables
##
##  All these are in the library now, because the library accesses these.
##


#############################################################################
##
##  2. Functions used in the library files
##


#############################################################################
##
#F  GALOIS( <chars>, <list> )
#F  TENSOR( <chars>, <list> )
##
##  are global variables used to store the library tables in compressed form.
##
##  The entry `[GALOIS,[<i>,<j>]]' in the `irreducibles' or `projectives'
##  component of a library table means the <j>-th Galois conjugate of
##  the <i>-th character.
##
##  The entry `[TENSOR,[<i>,<j>]]' in the `irreducibles' or `projectives'
##  component of a library table means the tensor product of the <i>-th
##  and the <j>-th character.
##
#F  EvalChars( <chars> )
##
##  replaces all entries of the form `[<func>,<list>]' in the list <chars>
##  by the result `<func>( <chars>, <list> )'.
##
DeclareGlobalFunction( "GALOIS" );
DeclareGlobalFunction( "TENSOR" );
DeclareGlobalFunction( "EvalChars" );


#############################################################################
##
#F  ALF( <from>, <to>, <map>[, <text>, <spec>] ) .  add library table fusions
##
##  <ManSection>
##  <Func Name="ALF" Arg="from, to, map[, text, spec]"/>
##
##  <Description>
##  <C>ALF</C> stores the fusion map <A>map</A> between the ordinary
##  character tables with identifier strings <A>from</A> and <A>to</A>
##  in the record encoding the table with identifier <A>from</A>.
##  If the string <A>text</A> is given then it is added
##  as <C>text</C> component of the fusion.
##  If the argument <A>spec</A> is given then it is added
##  as <C>specification</C> component of the fusion.
##  <P/>
##  <C>ALF</C> changes the global list <C>LIBLIST.fusionsource</C>.
##  <P/>
##  Note that the <C>ALF<C> statement should be placed in the file
##  containing the data for the table with identifier <A>from</A>.
##  </Description>
##  </ManSection>
##


#############################################################################
##
#F  ACM( <spec>, <dim>, <val> )
##     adds a Clifford matrix to the library.
##     <spec> is one of the strings "elab", "exsp".
##     <dim> is the dimension of the Clifford matrix,
##     <val> is the Clifford matrix itself.
##
#F  ARC( <name>, <comp>, <val> )
##     adds the record component <comp> with value <val> to the table record
##     with name <name>.
##
##  These functions are used in the library table files,
##  so they assume that it is not necessary to read such a file before the
##  data can be stored.
##


#############################################################################
##
#F  NotifyNameOfCharacterTable( <firstname>, <newnames> )
##
##  <#GAPDoc Label="NotifyNameOfCharacterTable">
##  <ManSection>
##  <Func Name="NotifyNameOfCharacterTable" Arg="firstname, newnames"/>
##
##  <Description>
##  notifies the strings in the list <A>newnames</A> as new admissible names
##  for the library table with
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value <A>firstname</A>.
##  If there is already another library table for which some of these names
##  are admissible then an error is signaled.
##  <P/>
##  <Ref Func="NotifyNameOfCharacterTable"/> modifies the global variable
##  <Ref Var="LIBLIST"/>.
##  <P/>
##  <Example>
##  gap> CharacterTable( "private" );
##  fail
##  gap> NotifyNameOfCharacterTable( "A5", [ "private" ] );
##  gap> a5:= CharacterTable( "private" );
##  CharacterTable( "A5" )
##  </Example>
##  <P/>
##  One can notify alternative names for character tables inside data files,
##  using the function <C>ALN</C> instead of
##  <Ref Func="NotifyNameOfCharacterTable"/>.
##  The idea is that the additional names of tables from those files can be
##  ignored which are controlled by <C>CTblLib.RecomputeTOC</C>.
##  Therefore, <C>ALN</C> is set to <C>Ignore</C> before the file is read
##  with <C>CTblLib.ReadTbl</C>,
##  otherwise <C>ALN</C> is set to <Ref Func="NotifyNameOfCharacterTable"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "NotifyNameOfCharacterTable" );


#############################################################################
##
#F  NotifyCharacterTable( <firstname>, <filename>, <othernames> )
##
##  <#GAPDoc Label="NotifyCharacterTable">
##  <ManSection>
##  <Func Name="NotifyCharacterTable" Arg="firstname, filename, othernames"/>
##
##  <Description>
##  notifies a new ordinary table to the library.
##  This table has
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value <A>firstname</A>,
##  it is contained (in library format, see&nbsp;<Ref Func="PrintToLib"/>)
##  in the file with name <A>filename</A> (without suffix <C>.tbl</C>),
##  and the names contained in the list <A>othernames</A> are admissible
##  for it.
##  <P/>
##  If the initial part of <A>filename</A> is one of <C>~/</C>, <C>/</C>
##  or <C>./</C> then it is interpreted as an <E>absolute</E> path.
##  Otherwise it is interpreted <E>relative</E> to the <F>data</F> directory
##  of the &CTblLib; package.
##  <P/>
##  <Ref Func="NotifyCharacterTable"/> modifies the global variable
##  <Ref Var="LIBLIST"/> for the current &GAP; session,
##  after having checked that there is no other library table yet with an
##  admissible name equal to <A>firstname</A>
##  or contained in <A>othernames</A>.
##  <P/>
##  For example, let us change the name <C>A5</C> to <C>icos</C> wherever it
##  occurs in the file <F>private.tbl</F> that was produced above,
##  and then notify the <Q>new</Q> table in this file as follows.
##  (The name change is needed because &GAP; knows already a table with name
##  <C>A5</C> and would not accept to add another table with this name.)
##  <P/>
##  <Log>
##  gap> NotifyCharacterTable( "icos", "private", [] );
##  gap> icos:= CharacterTable( "icos" );
##  CharacterTable( "icos" )
##  gap> Display( icos );
##  icos
##  
##       2  2  2  .  .  .
##       3  1  .  1  .  .
##       5  1  .  .  1  1
##  
##         1a 2a 3a 5a 5b
##      2P 1a 1a 3a 5b 5a
##      3P 1a 2a 1a 5b 5a
##      5P 1a 2a 3a 1a 1a
##  
##  X.1     1  1  1  1  1
##  X.2     3 -1  .  A *A
##  X.3     3 -1  . *A  A
##  X.4     4  .  1 -1 -1
##  X.5     5  1 -1  .  .
##  
##  A = -E(5)-E(5)^4
##    = (1-ER(5))/2 = -b5
##  </Log>
##  <P/>
##  So the private table is treated as a library table.
##  Note that the table can be accessed only if it has been notified in the
##  current &GAP; session.
##  For frequently used private tables, it may be reasonable to put the
##  <Ref Func="NotifyCharacterTable"/> statements into your <F>gaprc</F> file
##  (see&nbsp;<Ref Sect="The gap.ini and gaprc files" BookName="ref"/>),
##  or into a file that is read via the <F>gaprc</F> file.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "NotifyCharacterTable" );


#############################################################################
##
#F  NotifyCharacterTables( <list> )
##
##  <#GAPDoc Label="NotifyCharacterTables">
##  <ManSection>
##  <Func Name="NotifyCharacterTables" Arg="list"/>
##
##  <Description>
##  notifies several new ordinary tables to the library.
##  The argument <A>list</A> must be a dense list in which each entry is a
##  lists of the form <C>[ firstname, filename, othernames ]</C>, with the
##  same meaning as the arguments of <Ref Func="NotifyCharacterTable"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "NotifyCharacterTables" );


#############################################################################
##
#F  MBT( <arg> )
##
##  The library format of Brauer tables is a call to the function
##  `MBT', with the following arguments.
##
##   1. identifier of the table
##   2. field characteristic
##   3. text (list of lines)
##   4. block
##   5. defect
##   6. basic set
##   7. Brauer tree information
##   8. inverses of decomposition matrices restricted to basic sets
##   9. blocks of proper factor groups
##  10. list of generators for the group of table automorphisms
##  11. 2nd indicator (in characteristic 2 only)
##  12. (optional) record with additional components
##
##  `MBT' constructs a record and stores it in the record
##  `LIBTABLE.TABLEFILENAME'.
##


#############################################################################
##
#F  MOT( <arg> )
##
##  The library format of ordinary character tables is a call to the function
##  `MOT', with the following arguments.
##
##   1. identifier of the table
##   2. text (list of lines)
##   3. list of centralizer orders
##   4. list of power maps
##   5. list of irreducibles
##   6. list of generators for the group of table automorphisms
##   7. (optional) construction of the table
##
##  Each fusion is added by `ALF', any other component of the table must be
##  added individually via `ARC( <identifier>, <compname>, <compval> )'.
##
##  `MOT' constructs a preliminary table record,
##  and puts it into the record `LIBTABLE.TABLEFILENAME'.
##  The `NamesOfFusionSources' and `ProjectivesInfo' values are dealt with
##  when the table is constructed by `CharacterTableFromLibrary'.
##  Admissible names are notified by `ALN( <name>, <othernames> )'.
##


#############################################################################
##
#V  GEN_Q_P
##
##  for prime powers <q>, at position <q> the unique prime divisor of <q>
##
#F  PrimeBase( <q> )  . . . . . . . . . . . . . . unique prime divisor of <q>
##
##  If <q> is a prime power, `PrimeBase' computes the prime of which it is
##  a power.  For the sake of speed, the results are stored
##  in the global list `GEN_Q_P'.
##
DeclareGlobalVariable( "GEN_Q_P",
    "list where the prime <p> is stored at position <p>^<n>, if bound" );

DeclareGlobalFunction( "PrimeBase" );


#############################################################################
##
##  3. Functions to construct library tables
##

#############################################################################
##
#F  LibInfoCharacterTable( <tblname> )
##
##  <#GAPDoc Label="LibInfoCharacterTable">
##  <ManSection>
##  <Func Name="LibInfoCharacterTable" Arg="tblname"/>
##
##  <Description>
##  is a record with the components
##  <P/>
##  <List>
##  <Mark><C>firstName</C></Mark>
##  <Item>
##    the <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##    value of the library table for which <A>tblname</A> is an admissible
##    name, and
##  </Item>
##  <Mark><C>fileName</C></Mark>
##  <Item>
##    the name of the file in which the table data is stored.
##  </Item>
##  </List>
##  <P/>
##  If no such table exists in the &GAP; library then <K>fail</K>
##  is returned.
##  <P/>
##  If <A>tblname</A> contains the substring <C>"mod"</C> then it is regarded
##  as the name of a Brauer table.
##  In this case the result is computed from that for the corresponding
##  ordinary table and the characteristic.
##  So if the ordinary table exists then the result is a record although
##  the Brauer table in question need not be contained in the &GAP; library.
##  <P/>
##  <Example>
##  gap> LibInfoCharacterTable( "S5" );
##  rec( fileName := "ctoalter", firstName := "A5.2" )
##  gap> LibInfoCharacterTable( "S5mod2" );
##  rec( fileName := "ctbalter", firstName := "A5.2mod2" )
##  gap> LibInfoCharacterTable( "J5" );
##  fail
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "LibInfoCharacterTable" );


#############################################################################
##
#F  LibraryTables( <filename> )
##
##  is the list of data obtained on reading the file `<filename>.tbl'.
##  If the initial part of <filename> is one of `~/', `/' or `./' then the
##  file with this name is read; otherwise the name is interpreted relative
##  to the `data' directory of the `ctbllib' package.
##
DeclareGlobalFunction( "LibraryTables" );


#############################################################################
##
##  We replace the library function `CharacterTableFromLibrary' that just
##  issues a warning about nonavailability of the Character Table Library.
##
if IsBoundGlobal( "CharacterTableFromLibrary" ) then
  MakeReadWriteGlobal( "CharacterTableFromLibrary" );
  UNBIND_GLOBAL( "CharacterTableFromLibrary" );
fi;


#############################################################################
##
#F  CharacterTableFromLibrary( <tblname> )
#F  CharacterTableFromLibrary( <series>, <param1>[, <param2>] )
##
##  <#GAPDoc Label="CharacterTable_for_a_string">
##  <ManSection>
##  <Meth Name="CharacterTable" Arg="tblname[, para1[, para2]]"
##   Label="for a string"/>
##
##  <Description>
##  If the only argument is a string <A>tblname</A> and if this is
##  an admissible name (see <Ref Subsect="subsect:admissiblenames"/>)
##  of a library character table then
##  <Ref Meth="CharacterTable" Label="for a string"/> returns this
##  library table, otherwise <K>fail</K>.
##  <P/>
##  If <Ref Meth="CharacterTable" Label="for a string"/> is called
##  with more than one argument then the first must be a string
##  <A>tblname</A> specifying a series of groups which is implemented via
##  a generic character table,
##  for example <C>"Symmetric"</C> for symmetric groups;
##  the remaining arguments specialize the desired member of the series
##  (see Section&nbsp;<Ref Sect="sec:generictables"/> for a list of
##  available generic tables).
##  If no generic table with name <A>tblname</A> is available or if the
##  parameters are not admissible
##  then <Ref Meth="CharacterTable" Label="for a string"/>
##  returns <K>fail</K>.
##  <P/>
##  A call of <Ref Meth="CharacterTable" Label="for a string"/> may cause
##  that some library files are read and that some table objects are
##  constructed from the data stored in these files,
##  so fetching a library table may take more time than one expects.
##  <P/>
##  Case is not significant for <A>tblname</A>.
##  For example, both <C>"suzm3"</C> and <C>"SuzM3"</C> can be entered
##  in order to access the character table of the third class of maximal
##  subgroups of the sporadic simple Suzuki group.
##  <P/>
##  <Example>
##  gap> s5:= CharacterTable( "A5.2" );
##  CharacterTable( "A5.2" )
##  gap> sym5:= CharacterTable( "Symmetric", 5 );
##  CharacterTable( "Sym(5)" )
##  gap> TransformingPermutationsCharacterTables( s5, sym5 );
##  rec( columns := (2,3,4,7,5), group := Group(()), 
##    rows := (1,7,3,4,6,5,2) )
##  </Example>
##  <P/>
##  The above two tables are tables of the symmetric group on five letters;
##  the first is in &ATLAS; format
##  (see Section&nbsp;<Ref Sect="sec:ATLAS Tables"/>),
##  the second is constructed from the generic table for symmetric groups
##  (see&nbsp;<Ref Sect="sec:generictables"/>).
##  <P/>
##  <Example>
##  gap> CharacterTable( "J5" );
##  fail
##  gap> CharacterTable( "A5" ) mod 2;
##  BrauerTable( "A5", 2 )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "CharacterTableFromLibrary" );


#############################################################################
##
#O  BrauerTable( <tblname>, <p> )
##
##  <#GAPDoc Label="BrauerTable_for_a_string">
##  <ManSection>
##  <Oper Name="BrauerTable" Arg="tblname, p"
##   Label="for a string, and a prime integer"/>
##
##  <Description>
##  Called with a string <A>tblname</A> and a prime integer <A>p</A>,
##  <Ref Oper="BrauerTable" Label="for a string, and a prime integer"/>
##  returns the <A>p</A>-modular character table of
##  the ordinary character table with admissible name <A>tblname</A>,
##  if such an ordinary character table exists and if &GAP; can compute its
##  <A>p</A>-modular table.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  The default method delegates to <Ref Oper="BrauerTable" BookName="ref"
##  Label="for a character table, and a prime integer"/>
##  with arguments the <Ref Attr="CharacterTable" Label="for a string"/>
##  value of <A>tblname</A> and <A>p</A>.
##  <P/>
##  <Example>
##  gap> BrauerTable( "A5", 2 );
##  BrauerTable( "A5", 2 )
##  gap> BrauerTable( "J5", 2 );  # no ordinary table with name J5
##  fail
##  gap> BrauerTable( "M", 2 );   # Brauer table not known
##  fail
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "BrauerTable", [ IsString, IsInt ] );


#############################################################################
##
#F  PartsBrauerTableName( <modname> )
##
##  is a record with components
##  `ordname'
##      substring up to the occurrence of `mod' in <modname>,
##  `prime'
##      the integer of the string after `mod'.
##
DeclareGlobalFunction( "PartsBrauerTableName" );


#############################################################################
##
#F  BasicSetBrauerTree( <brauertree> )
##
##  returns a basic set of the Brauer tree <brauertree>.
##  *Note* that this is a list of positions relative to the block, so it is
##  not compatible with the `basicset' components of blocks in Brauer tables.
##
DeclareGlobalFunction( "BasicSetBrauerTree" );


#############################################################################
##
#F  DecMatBrauerTree( <brauertree> )
##
##  In the GAP table library, a Brauer tree <brauertree> is a list where
##  `<brauertree>[i]' contains the positions of `1' in the `i'-th column
##  of the decomposition matrix of the corresponding block.
##  So `<brauertree>[i]' has length 2 or 3 (in the case of exceptional
##  characters).
##
##  `DecMatBrauerTree' returns the decomposition matrix of the block with
##  given Brauer tree.
##
DeclareGlobalFunction( "DecMatBrauerTree" );


#############################################################################
##
#F  BrauerTree( <decmat> )
##
##  returns the Brauer tree of the decomposition matrix <decmat>, if exists,
##  and `fail' otherwise.
##
DeclareGlobalFunction( "BrauerTree" );


#############################################################################
##
#F  BrauerTableFromLibrary( <ordtbl>, <p> )
##
##  is the <p>-modular Brauer table of the ordinary library table <ordtbl>.
##
DeclareGlobalFunction( "BrauerTableFromLibrary" );


#############################################################################
##
#F  CharacterTableSpecialized( <generic_table>, <q> )  . . . . specialise <q>
##
##  <#GAPDoc Label="CharacterTableSpecialized">
##  <ManSection>
##  <Func Name="CharacterTableSpecialized" Arg="gentbl, q"/>
##
##  <Description>
##  For a record <A>gentbl</A> representing a generic character table,
##  and a parameter value <A>q</A>,
##  <Ref Func="CharacterTableSpecialized"/> returns a character table object
##  computed by evaluating <A>gentbl</A> at <A>q</A>.
##  <P/>
##  <Example>
##  gap> c5:= CharacterTableSpecialized( CharacterTable( "Cyclic" ), 5 );
##  CharacterTable( "C5" )
##  gap> Display( c5 );
##  C5
##  
##       5  1  1  1  1  1
##  
##         1a 5a 5b 5c 5d
##      5P 1a 1a 1a 1a 1a
##  
##  X.1     1  1  1  1  1
##  X.2     1  A  B /B /A
##  X.3     1  B /A  A /B
##  X.4     1 /B  A /A  B
##  X.5     1 /A /B  B  A
##  
##  A = E(5)
##  B = E(5)^2
##  </Example>
##  <P/>
##  (Also <C>CharacterTable( "Cyclic", 5 )</C> could have been used
##  to construct the above table.)
##  <P/>
##  <Example>
##  gap> HasClassParameters( c5 );  HasCharacterParameters( c5 );
##  true
##  true
##  gap> ClassParameters( c5 );  CharacterParameters( c5 );
##  [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ]
##  [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 1, 4 ] ]
##  gap> ClassParameters( CharacterTable( "Symmetric", 3 ) );
##  [ [ 1, [ 1, 1, 1 ] ], [ 1, [ 2, 1 ] ], [ 1, [ 3 ] ] ]
##  </Example>
##  <P/>
##  Here are examples for the <Q>local evaluation</Q> of
##  generic character tables,
##  first a character value of the cyclic group shown above,
##  then a character value and a representative order of a symmetric group.
##  <P/>
##  <Example>
##  gap> CharacterTable( "Cyclic" ).irreducibles[1][1]( 5, 2, 3 );
##  E(5)
##  gap> tbl:= CharacterTable( "Symmetric" );;
##  gap> tbl.irreducibles[1][1]( 5, [ 3, 2 ], [ 2, 2, 1 ] );
##  1
##  gap> tbl.orders[1]( 5, [ 2, 1, 1, 1 ] );
##  2
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "CharacterTableSpecialized" );


#############################################################################
##
##  4. Functions used as `construction' component of library tables
##
##  Note that in all construction functions, the table under construction is
##  a plain record, *not* a table object.
##

#############################################################################
##
#F  TransferComponentsToLibraryTableRecord( <t>, <tbl> )
##
##  <t> must be a library character table, and <tbl> a record that will be
##  converted to a library character table later.
##  `TransferComponentsToLibraryTableRecord' transfers all those values
##  from <t> to <tbl> that are described by `SupportedOrdinaryTableInfo'
##  and `SupportedLibraryTableComponents'.
##
DeclareGlobalFunction( "TransferComponentsToLibraryTableRecord" );


#############################################################################
##
#F  InducedLibraryCharacters( <subtbl>, <tblrec>, <chars>, <fusionmap> )
##
##  is the list of class function values lists
##
DeclareGlobalFunction( "InducedLibraryCharacters" );


#############################################################################
##
#F  UnpackedCll( <cll> )
##
##  is a record with the components `mat', `inertiagrps', `fusionclasses',
##  and perhaps `libname'.
##  These are the only components used in the construction of library
##  character tables encoded by Clifford matrices.
##
##  The meaning of <cll> is the same as in `CllToClf'.
##
DeclareGlobalFunction( "UnpackedCll" );


#############################################################################
##
#F  CllToClf( <tbl>, <cll> )
##
##  is a Clifford matrix for the table <tbl>.
##  It is constructed from the list <cll> that contains
##  the following entries.
##  1. list of indices of inertia factors
##  2. list of classes fusing in the factor group
##  3. identification of the matrix,
##     either unbound (then the matrix has dimension <= 2)
##     or a list containing
##       a. string `"elab"' or `"exsp"'
##       b. size of the Clifford matrix
##       c. index in the library file
##       d. (optional) necessary permutation of columns
##     or a list containing
##       a. the Clifford matrix itself and
##       b. the column weights.
##  4. (case `"exsp"') a list with items of record `splitinfos':
##       a. classindex
##       b. p
##       c. numclasses
##       d. root
##
DeclareGlobalFunction( "CllToClf" );


#############################################################################
##
##  5. Selection functions for the table library
##

#############################################################################
##
#F  CompleteGroup()
##
##  dummy function for selection function
##
DeclareGlobalFunction( "CompleteGroup" );


#############################################################################
##
#F  OfThose()
##
##  dummy function for selection function
##
DeclareGlobalFunction( "OfThose" );


#############################################################################
##
#P  IsAtlasCharacterTable( <tbl> )
##
##  <#GAPDoc Label="IsAtlasCharacterTable">
##  <ManSection>
##  <Prop Name="IsAtlasCharacterTable" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A>, this function returns
##  <K>true</K> if and only if the <Ref Meth="InfoText"/> value of <A>tbl</A>
##  contains the string <C>"origin: ATLAS of finite groups"</C>.
##  <P/>
##  For a Brauer character table <A>tbl</A>, this function returns
##  <K>true</K> if and only if <Ref Prop="IsAtlasCharacterTable"/>
##  returns <K>true</K> for the underlying ordinary table of <A>tbl</A>.
##  <P/>
##  One application of this function is to restrict the search with
##  <Ref Func="AllCharacterTableNames"/> to character tables from the
##  &ATLAS; of Finite Groups.
##  <P/>
##  <Example>
##  gap> Maxes( CharacterTable( "A6" ) );
##  [ "A5", "A6M2", "3^2:4", "s4", "A6M5" ]
##  gap> IsAtlasCharacterTable( CharacterTable( "A5" ) );
##  true
##  gap> IsAtlasCharacterTable( CharacterTable( "A5" ) mod 2 );
##  true
##  gap> IsAtlasCharacterTable( CharacterTable( "A6M2" ) );
##  false
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  Note that we do not call `DeclareAttributeSuppCT' because a `true' value
##  shall not be inherited via `ConstructPermuted':
##  If an Atlas table has been loaded and has been asked for its value then
##  `true' is stored in it, and `ConstructPermuted' would set `true' also in
##  duplicate tables.
##
DeclareProperty( "IsAtlasCharacterTable", IsCharacterTable );


#############################################################################
##
#F  AllCharacterTableNames( [<func>, <val>, ...[, OfThose, <func>]]
#F                          [: OrderedBy:= <func>] )
##
##  <#GAPDoc Label="AllCharacterTableNames">
##  <ManSection>
##  <Func Name="AllCharacterTableNames"
##  Arg="[func, val, ...[, OfThose, func]]: OrderedBy:= func"/>
##
##  <Description>
##  Similar to group libraries
##  (see Chapter&nbsp;<Ref Chap="Group Libraries" BookName="ref"/>),
##  the &GAP; Character Table Library can be used to search for ordinary
##  character tables with prescribed properties.
##  <P/>
##  A specific library table can be selected by an admissible name,
##  see <Ref Subsect="subsect:admissiblenames"/>.
##  <P/>
##  <Index>selection function!for character tables</Index>
##  The <E>selection function</E>
##  (see <Ref Sect="Selection Functions" BookName="ref"/>)
##  for character tables from the &GAP; Character Table Library that have
##  certain abstract properties is <Ref Func="AllCharacterTableNames"/>.
##  Contrary to the situation in the case of group libraries,
##  the selection function returns a list not of library character tables
##  but of their names;
##  using <Ref Meth="CharacterTable" Label="for a string"/>
##  one can then access the tables themselves.
##  <P/>
##  <Ref Func="AllCharacterTableNames"/> takes an arbitrary even number
##  of arguments.
##  The argument at each odd position must be a function, and
##  the argument at the subsequent even position must be either a value
##  that this function must return when called for the character table
##  in question, in order to have the name of the table included in the
##  selection, or a list of such values,
##  or a function that returns <K>true</K> for such a value,
##  and <K>false</K> otherwise.
##  For example,
##  <P/>
##  <Example>
##  gap> names:= AllCharacterTableNames();;
##  </Example>
##  <P/>
##  returns a list containing one admissible name of each ordinary character
##  table in the &GAP; library,
##  <P/>
##  <Example>
##  gap> simpnames:= AllCharacterTableNames( IsSimple, true,
##  >                                        IsAbelian, false );;
##  </Example>
##  <P/>
##  returns a list containing an admissible name of each ordinary character
##  table in the &GAP; library whose groups are nonabelian and simple, and
##  <P/>
##  <Example>
##  gap> AllCharacterTableNames( IsSimple, true, IsAbelian, false,
##  >                            Size, [ 1 .. 100 ] );
##  [ "A5", "A6M2", "Alt(5)" ]
##  </Example>
##  <P/>
##  returns a list containing an admissible name of each ordinary character
##  table in the &GAP; library whose groups are nonabelian and simple and
##  have order at most <M>100</M>,
##  respectively.
##  (Note that <C>"A5"</C>, <C>"A6M2"</C>, and <C>"Alt(5)"</C>
##  are identifiers of permutation equivalent character tables.
##  It would be possible to exclude duplicates,
##  see Section&nbsp;<Ref Sect="sec:duplicates"/>).
##  <P/>
##  Similarly,
##  <P/>
##  <Example>
##  gap> AllCharacterTableNames( Size, IsPrimeInt );
##  [ "2.Alt(2)", "Alt(3)", "C2", "C3", "Sym(2)" ]
##  </Example>
##  <P/>
##  returns the list of all identifiers of library tables whose
##  <Ref Attr="Size" BookName="ref"/> value is a prime integer, and
##  <P/>
##  <Example><![CDATA[
##  gap> AllCharacterTableNames( Identifier,
##  >        x -> PositionSublist( x, "L8" ) <> fail );
##  [ "L8(2)", "P1L82", "P2L82" ]
##  ]]></Example>
##  <P/>
##  returns the identifiers that contain the string <C>"L8"</C> as a
##  substring.
##  <P/>
##  For the sake of efficiency, the attributes whose names are listed in
##  <C>CTblLib.SupportedAttributes</C> are handled in a special way,
##  &GAP; need not read all files of the table library in these cases
##  in order to find the desired names.
##  <P/>
##  <Example>
##  gap> CTblLib.SupportedAttributes;
##  [ "AbelianInvariants", "HasFusionToTom", "Identifier", 
##    "IdentifiersOfDuplicateTables", "InfoText", "IsAbelian", 
##    "IsAlmostSimple", "IsAtlasCharacterTable", "IsDuplicateTable", 
##    "IsNontrivialDirectProduct", "IsPerfect", "IsQuasisimple", 
##    "IsSimple", "IsSporadicSimple", "KnowsDeligneLusztigNames", 
##    "KnowsSomeGroupInfo", "Maxes", "NamesOfFusionSources", 
##    "NrConjugacyClasses", "Size" ]
##  </Example>
##  <P/>
##  If the <Package>Browse</Package> package (see&nbsp;<Cite Key="Browse"/>)
##  is not loaded then <C>CTblLib.SupportedAttributes</C> contains only
##  <C>"Identifier"</C>, and
##  <Ref Func="AllCharacterTableNames"/> will be very slow when one selects
##  character tables according to other attributes from the list shown above.
##  <P/>
##  The global option <C>OrderedBy</C> can be used to prescribe the ordering
##  of the result.
##  The value of this option, if given, must be a function that takes a
##  character table as its unique argument; the result list is then
##  sorted according to the results of this function (w.&nbsp;r.&nbsp;t. the
##  comparison by &GAP;'s <C>\&lt;</C> operation).
##  <P/>
##  For example, we may be interested in the tables of small sporadic simple
##  groups, ordered alphabetically or by size
##  (<Ref Attr="Size" BookName="ref" Label="for a character table"/>)
##  or by the number of conjugacy classes
##  (<Ref Attr="NrConjugacyClasses" BookName="ref"
##  Label="for a character table"/>).
##  <P/>
##  <Example>
##  gap> AllCharacterTableNames( IsSporadicSimple, true,
##  >        Size, [ 1 .. 10^6 ],
##  >        IsDuplicateTable, false );
##  [ "J1", "J2", "M11", "M12", "M22" ]
##  gap> AllCharacterTableNames( IsSporadicSimple, true,
##  >        Size, [ 1 .. 10^6 ],
##  >        IsDuplicateTable, false : OrderedBy:= Size );
##  [ "M11", "M12", "J1", "M22", "J2" ]
##  gap> AllCharacterTableNames( IsSporadicSimple, true,
##  >        Size, [ 1 .. 10^6 ],
##  >        IsDuplicateTable, false : OrderedBy:= NrConjugacyClasses );
##  [ "M11", "M22", "J1", "M12", "J2" ]
##  </Example>
##  <P/>
##  (Note that the alphabtical ordering could also be achieved by entering
##  <C>OrderedBy:= Identifier</C>.)
##  <P/>
##  If the dummy function <C>OfThose</C> is an argument at an odd position
##  then the following argument <A>func</A> must be a function that takes a
##  character table and returns a name of a character table or a list of
##  names;
##  this is interpreted as replacement of the names computed up to this
##  position by the union of names returned by <A>func</A>.
##  For example, <A>func</A> may be <Ref Attr="Maxes"/> or
##  <Ref Attr="NamesOfFusionSources" BookName="ref"/>).
##  <P/>
##  <Example>
##  gap> maxesnames:= AllCharacterTableNames( IsSporadicSimple, true,
##  >                                         HasMaxes, true,
##  >                                         OfThose, Maxes );;
##  </Example>
##  <P/>
##  returns the union of names of ordinary tables of those maximal subgroups
##  of sporadic simple groups that are contained in the table library in the
##  sense that the attribute <Ref Attr="Maxes"/> is set.
##  <P/>
##  For the sake of efficiency, <C>OfThose</C> followed by one of the
##  arguments <Ref Attr="AutomorphismGroup" BookName="ref"/>,
##  <Ref Func="SchurCover" BookName="ref"/>,
##  <C>CompleteGroup</C> is handled in a special way.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AllCharacterTableNames" );


#############################################################################
##
#F  OneCharacterTableName( [<func>, <val>, ...{, OfThose, <func>}]
#F                         [: OrderedBy:= <func>] )
##
##  <#GAPDoc Label="OneCharacterTableName">
##  <ManSection>
##  <Func Name="OneCharacterTableName"
##  Arg="[func, val, ...[, OfThose, func]]: OrderedBy:= func"/>
##
##  <Description>
##  The example function for character tables from the &GAP; Character
##  Table Library that have certain abstract properties is
##  <Ref Func="OneCharacterTableName"/>.
##  It is analogous to the selection function
##  <Ref Func="AllCharacterTableNames"/>,
##  the difference is that it returns one
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of a character table with the properties in question
##  instead of the list of all such values.
##  If no table with the required properties is contained in the &GAP;
##  Character Table Library then <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> OneCharacterTableName( IsSimple, true, Size, 60 );
##  "A5"
##  gap> OneCharacterTableName( IsSimple, true, Size, 20 );
##  fail
##  </Example>
##  <P/>
##  The global option <C>OrderedBy</C> can be used to search for a
##  <Q>smallest</Q> example, according to the value of the option.
##  If this function is one of the attributes
##  whose names are listed in <C>CTblLib.SupportedAttributes</C> then the
##  tables are processed according to increasing values of the option,
##  which may speed up the search.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "OneCharacterTableName" );


#############################################################################
##
#F  NameOfEquivalentLibraryCharacterTable( <ordtbl> )
#F  NamesOfEquivalentLibraryCharacterTables( <ordtbl> )
##
##  <#GAPDoc Label="NameOfEquivalentLibraryCharacterTable">
##  <ManSection>
##  <Func Name="NameOfEquivalentLibraryCharacterTable" Arg='ordtbl'/>
##  <Func Name="NamesOfEquivalentLibraryCharacterTables" Arg='ordtbl'/>
##
##  <Description>
##  Let <A>ordtbl</A> be an ordinary character table.
##  <Ref Func="NameOfEquivalentLibraryCharacterTable"/> returns
##  the <Ref Func="Identifier" Label="for character tables" BookName="ref"/>
##  value of a character table in the &GAP; Character Table Library that is
##  permutation equivalent to <A>ordtbl</A>
##  (see <Ref Func="TransformingPermutationsCharacterTables"
##  BookName="ref"/>) if such a character table exists,
##  and <K>fail</K> otherwise.
##  <Ref Func="NamesOfEquivalentLibraryCharacterTables"/> returns the list of
##  all <Ref Func="Identifier" Label="for character tables" BookName="ref"/>
##  values of character tables in the &GAP; Character Table Library that are
##  permutation equivalent to <A>ordtbl</A>; thus an empty list is returned
##  in this case if no equivalent library table exists.
##  <P/>
##  <Example>
##  gap> tbl:= CharacterTable( "Alternating", 5 );;
##  gap> NameOfEquivalentLibraryCharacterTable( tbl );
##  "A5"
##  gap> NamesOfEquivalentLibraryCharacterTables( tbl );
##  [ "A5", "A6M2", "Alt(5)" ]
##  gap> tbl:= CharacterTable( "Cyclic", 17 );;
##  gap> NameOfEquivalentLibraryCharacterTable( tbl );
##  fail
##  gap> NamesOfEquivalentLibraryCharacterTables( tbl );
##  [  ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "NameOfEquivalentLibraryCharacterTable" );

DeclareGlobalFunction( "NamesOfEquivalentLibraryCharacterTables" );


#############################################################################
##
#F  UserPreference( "CTblLib", "UnloadCTblLibFiles" )
##
##  <#GAPDoc Label="UnloadCTblLibFiles">
##  <Subsection Label="subsect:unloadfiles">
##  <Heading>Unloading Character Table Data</Heading>
##
##  <Index Subkey="UnloadCTblLibFiles">user preferences</Index>
##  Data files from the &GAP; Character Table Library may be read only once
##  during a &GAP; session
##  &ndash;this is efficient but requires memory&ndash;
##  or the cached data may be erased as soon as a second data file is to be
##  read &ndash;this requires less memory but is usually less efficient.
##  <P/>
##  One can choose between these two possibilities via the user preference
##  <C>"UnloadCTblLibFiles"</C> of the <Package>CTblLib</Package> package,
##  see <Ref Func="UserPreference" BookName="ref"/>.
##  The default value of this preference is <K>true</K>,
##  that is, the contents of only one data file is kept in memory.
##  Call <C>SetUserPreference( "CTblLib", "UnloadCTblLibFiles", false );</C>
##  if you want to change this behaviour.
##  </Subsection>
##  <#/GAPDoc>
##
DeclareUserPreference( rec( name:= "UnloadCTblLibFiles",
    description:= [ "This preference controls the data files from the \
GAP Character Table Library. \
Only one such file is kept in memory if the value is 'true' (the default), \
whereas all such files are kept if the value is 'false'." ],
    default:= true,
    values:= [ true, false ],
    multi:= false ) );


#############################################################################
##
#F  UserPreference( "AtlasRep", "DisplayFunction" )
##
##  <#GAPDoc Label="DisplayFunction">
##  <Subsection Label="subsect:displayfunction">
##  <Heading>Changing the display format of several functions</Heading>
##
##  <Index Subkey="DisplayFunction">user preferences</Index>
##  The way how the functions
##  <Ref Func="DisplayAtlasContents"/>,
##  <Ref Func="DisplayAtlasInfo" BookName="atlasrep"/>,
##  <Ref Func="DisplayAtlasMap" Label="for the name of a simple group"/>,
##  <!-- <Ref Func="DisplayBlockInvariants" BookName="ctblocks"/>, -->
##  and <Ref Func="DisplayCTblLibInfo" Label="for a character table"/>
##  show tabular information can be customized via the user preference
##  <C>"DisplayFunction"</C> of the <Package>AtlasRep</Package> package,
##  see Section
##  <Ref Subsect="User preference DisplayFunction" BookName="AtlasRep"/>.
##  </Subsection>
##  <#/GAPDoc>
##


#############################################################################
##
#T  UserPreference( "CTblLib", "DataDirectory" )
##
##  This will become interesting as soon as remote files will be supported.
##


#############################################################################
##
#F  CTblLib.ShowOnlyASCII()
##
##  Show nicer grids and symbols such as ℤ if the terminal admits this.
##  Currently we do not do this if `Print' is used to show the data,
##  because of the automatically inserted line breaks.
##
CTblLib.ShowOnlyASCII:= function()
    return UserPreference( "AtlasRep", "DisplayFunction" ) = "Print" or
           GAPInfo.TermEncoding <> "UTF-8";
    end;


#############################################################################
##
#F  UnloadCharacterTableData()
##
##  `UnloadCharacterTableData' clears the cache of character tables.
##  This can be used to free up to more than hundred megabytes of space
##  in the current GAP session.
##
DeclareGlobalFunction( "UnloadCharacterTableData" );


#############################################################################
##
##  6. Functions to produce tables in library format
##

#############################################################################
##
#F  ShrinkClifford( <tbl> )
##
##  shrinks the `cliffordTable' component.
##  The Clifford records are changed to library format using `ClfToCll'.
##  In the library format, only the component `ident' of the inertia factor
##  groups are stored.
##
DeclareGlobalFunction( "ShrinkClifford" );


#############################################################################
##
#F  TextString( <text> )
##
##  returns a string that is printed as
##
##  [
##  "<line_1>\n",
##  "<line_1>\n",
##  ...
##  "<line_n>"
##  ]
##
##  where <line_i> is the <i>-th line of the output of `Print( <text> )',
##  except that the doublequotes are escaped.
##
##  *Note* that the `]' is the last output character.
##
DeclareGlobalFunction( "TextString" );


#############################################################################
##
#F  BlanklessPrintTo( <stream>, <obj> )
##
##  appends <obj> to the output stream <stream>,
##  thereby trying to avoid unnecessary blanks.
##  For the subobjects of <obj>, the function `PrintTo' is used.
##  (So the subobjects are appended only if <stream> is of the appropriate
##  type, see~"PrintTo".)
##
##  If <obj> is a record then the component `text' and strings in an `irr'
##  list are *not* treated in a special way!
##
##  This function is used by the libraries of character tables and of tables
##  of marks.
##
DeclareGlobalFunction( "BlanklessPrintTo" );
#T better use WriteAll?


#############################################################################
##
#F  ShrinkChars( <chars> )
##
##  returns the list corresponding to the list <chars> where
##
##  each `<chars>[<k>]' that is the tensor product of `<chars>[<i>]'
##  and a linear character `<chars>[j]' with $i, j \leq k$ is replaced by
##  the string `\"[TENSOR,[<i>,<j>]]\"', and
##
##  each `<chars>[<k>]' that is the <j>-th Galois conjugate of `<chars>[<i>]'
##  with $i \leq k$ is replaced by the string `\"[GALOIS,[<i>,<j>]]\"'.
##
##  This function is used by `PrintToLib'.
##
DeclareGlobalFunction( "ShrinkChars" );


#############################################################################
##
#F  ClfToCll( <clf> )
##
##  is a list encoding the information in the Clifford matrix record <clf>.
##  <clf> must contain the components `mat', `inertiagrps', `fusionclasses'.
##
##  See `CllToClf' for the meaning of the entries.
##
DeclareGlobalFunction( "ClfToCll" );
#T up to now no function is installed


#############################################################################
##
#F  LibraryFusion( <name>, <fus> )
##
##  <#GAPDoc Label="LibraryFusion">
##  <ManSection>
##  <Func Name="LibraryFusion" Arg="name, fus"/>
##
##  <Description>
##  For a string <A>name</A> that is an
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of an ordinary character table in the &GAP; library,
##  and a record <A>fus</A> with the components
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the identifier of the destination table, or this table itself,
##  </Item>
##  <Mark><C>map</C></Mark>
##  <Item>
##    the fusion map, a list of image positions,
##  </Item>
##  <Mark><C>text</C> (optional)</Mark>
##  <Item>
##    a string describing properties of the fusion, and
##  </Item>
##  <Mark><C>specification</C> (optional)</Mark>
##  <Item>
##    a string or an integer,
##  </Item>
##  </List>
##  <Ref Func="LibraryFusion"/> returns a string whose printed value can be
##  used to add the fusion in question to the library file containing
##  the data for the table with identifier <A>name</A>.
##  <P/>
##  If <A>name</A> is a character table then its
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value is used as the corresponding string.
##  <Example>
##  gap> s5:= CharacterTable( "S5" );
##  CharacterTable( "A5.2" )
##  gap> fus:= PossibleClassFusions( a5, s5 );
##  [ [ 1, 2, 3, 4, 4 ] ]
##  gap> fusion:= rec( name:= s5, map:= fus[1], text:= "unique" );;
##  gap> Print( LibraryFusion( "A5", fusion ) );
##  ALF("A5","A5.2",[1,2,3,4,4],[
##  "unique"
##  ]);
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "LibraryFusion" );


#############################################################################
##
#F  LibraryFusionTblToTom( <name>, <fus> )
##
##  <#GAPDoc Label="LibraryFusionTblToTom">
##  <ManSection>
##  <Func Name="LibraryFusionTblToTom" Arg="name, fus"/>
##
##  <Description>
##  For a string <A>name</A> that is an
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of an ordinary character table in the &GAP; library,
##  and a record <A>fus</A> with the components
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the identifier of the destination table of marks, or this table itself,
##  </Item>
##  <Mark><C>map</C></Mark>
##  <Item>
##    the fusion map, a list of image positions,
##  </Item>
##  <Mark><C>text</C> (optional)</Mark>
##  <Item>
##    a string describing properties of the fusion, and
##  </Item>
##  <Mark><C>perm</C> (optional)</Mark>
##  <Item>
##    a permutation,
##  </Item>
##  </List>
##  <Ref Func="LibraryFusionTblToTom"/> returns a string whose printed value
##  can be used to add the fusion in question to the library file containing
##  the data for the table with identifier <A>name</A>.
##  <P/>
##  The meaning of the component <C>perm</C> is as follows.
##  Let <A>prim</A> be the primitive permutation characters obtained by
##  computing the <Ref Func="PermCharsTom" BookName="ref"/> value of the
##  tables of marks,
##  taking the sublist at the positions in the first component of the
##  <Ref Func="MaximalSubgroupsTom" BookName="ref"/> value of the tables of
##  marks, and restricting these lists via the <C>map</C> component.
##  Permuting <A>prim</A> with the <C>perm</C> component via
##  <Ref Func="Permuted" BookName="ref"/> yields the list of
##  permutation characters obtained by inducing the trivial characters of the
##  subgroups given by the <Ref Attr="Maxes"/> value of the character table.
##  If the component <C>perm</C> is not present and if the character table
##  has the attribute <Ref Attr="Maxes"/> set then the two ways of computing
##  the primitive permutation characters yield the same list.
##  <P/>
##  If <A>name</A> is a character table then its
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value is used as the corresponding string.
##  <Example>
##  gap> tbl:= CharacterTable( "A5" );     
##  CharacterTable( "A5" )
##  gap> tom:= TableOfMarks( "A5" );
##  TableOfMarks( "A5" )
##  gap> fus:= PossibleFusionsCharTableTom( tbl, tom );
##  [ [ 1, 2, 3, 5, 5 ] ]
##  gap> fusion:= rec( name:= tom, map:= fus[1], text:= "unique" );;
##  gap> Print( LibraryFusionTblToTom( "A5", fusion ) );
##  ARC("A5","tomfusion",rec(name:="A5",map:=[1,2,3,5,5],text:=[
##  "unique"
##  ]));
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "LibraryFusionTblToTom" );


#############################################################################
##
#F  PrintToLib( <file>, <tbl> )
##
##  <#GAPDoc Label="PrintToLib">
##  <ManSection>
##  <Func Name="PrintToLib" Arg="file, tbl"/>
##
##  <Description>
##  prints the (ordinary or Brauer) character table <A>tbl</A>
##  in library format to the file <A>file</A><C>.tbl</C>
##  (or to <A>file</A> if this has already the suffix <C>.tbl</C>).
##  <P/>
##  If <A>tbl</A> is an ordinary table then the value of the attribute
##  <Ref Attr="NamesOfFusionSources" BookName="ref"/> is ignored by
##  <Ref Func="PrintToLib"/>,
##  since for library tables this information is extracted from the source
##  files (see Section <Ref Subsect="subsec:CTblLib data files"/>).
##  <P/>
##  The names of data files in the &GAP; Character Table Library begin with
##  <C>cto</C> (for ordinary tables) or
##  <C>ctb</C> (for corresponding Brauer tables),
##  see Section&nbsp;<Ref Sect="sec:technicalities"/>.
##  This is supported also for private extensions of the library,
##  that is, if the filenames are chosen this way and the ordinary tables
##  in the <C>cto</C> files are notified via
##  <Ref Func="NotifyCharacterTable"/> then the Brauer tables will be found
##  in the <C>ctb</C> files.
##  Alternatively, if the filenames of the files with the ordinary tables do
##  not start with <C>cto</C> then &GAP; expects the corresponding Brauer
##  tables in the same file as the ordinary tables.
##  <P/>
##  <Log>
##  gap> PrintToLib( "private", a5 );
##  </Log>
##  <P/>
##  The above command appends the data of the table <C>a5</C> to the file
##  <F>private.tbl</F>;
##  the first lines printed to this file are
##  <P/>
##  <Listing>
##  MOT("A5",
##  [
##  "origin: ATLAS of finite groups, tests: 1.o.r., pow[2,3,5]"
##  ],
##  [60,4,3,5,5],
##  [,[1,1,3,5,4],[1,2,1,5,4],,[1,2,3,1,1]],
##  [[1,1,1,1,1],[3,-1,0,-E(5)-E(5)^4,-E(5)^2-E(5)^3],
##  [GALOIS,[2,2]],[4,0,1,-1,-1],[5,1,-1,0,0]],
##  [(4,5)]);
##  ARC("A5","projectives",["2.A5",[[2,0,-1,E(5)+E(5)^4,E(5)^2+E(5)^3],
##  [GALOIS,[1,2]],[4,0,1,-1,-1],[6,0,0,1,1]],]);
##  ARC("A5","extInfo",["2","2"]);
##  </Listing>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "PrintToLib" );


#############################################################################
##
#F  PrintClmsToLib( <file>, <clms> )
##
##  prints the Clifford matrices in library format in a list on the file
##  <file> which are not yet in the Clifford matrix library or in this list.
##
##  <clms> must be a Clifford table or a list of Clifford records.
##  In case of splitting, each Clifford record must contain `splitinfos'.
##
DeclareGlobalFunction( "PrintClmsToLib" );
#T up to now no function is installed


#############################################################################
##
#F  OrbitsResidueClass( <pq>, <set> )
##
##  is used in the generic character table of the groups $p \colon q$.
##  <pq> must be a list of length $2$ or $3$, the first entry being $p$,
##  the second being $q$, and the third (if bound) being the residue $k$
##  (modulo $p$) that forms orbits of length $q$ each on the nonzero
##  residues modulo $p$.
##  <set> is the set of points to act on.
##
DeclareGlobalFunction( "OrbitsResidueClass" );


#############################################################################
##
#A  CASInfo( <tbl> )
##
##  <#GAPDoc Label="CASInfo">
##  <ManSection>
##  <Attr Name="CASInfo" Arg="tbl"/>
##
##  <Description>
##  Let <A>tbl</A> be an ordinary character table in the &GAP; library
##  that was (up to permutations of classes and characters) contained already
##  in the &CAS; table library.
##  When one fetches <A>tbl</A> from the library,
##  one does in general not get the original &CAS; table.
##  Namely, in many cases (mostly &ATLAS; tables,
##  see Section&nbsp;<Ref Sect="sec:ATLAS Tables"/>),
##  the identifier of the table (see&nbsp;<Ref Attr="Identifier"
##  Label="for character tables" BookName="ref"/>)
##  as well as the ordering of classes and
##  characters are different for the &CAS; table and its &GAP; version.
##  <P/>
##  Note that in several cases, the &CAS; library contains
##  different tables of the same group,
##  in particular these tables may have different names and orderings of
##  classes and characters.
##  <P/>
##  The <Ref Attr="CASInfo"/> value of <A>tbl</A>, if stored,
##  is a list of records, each describing the relation between <A>tbl</A>
##  and a character table in the &CAS; library.
##  The records have the components
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the name of the &CAS; table,
##  </Item>
##  <Mark><C>permchars</C> and <C>permclasses</C></Mark>
##  <Item>
##    permutations of the <Ref Attr="Irr" BookName="ref"/> values and the
##    classes of <A>tbl</A>, respectively, that must be applied in order
##    to get the orderings in the original &CAS; table, and
##  </Item>
##  <Mark><C>text</C></Mark>
##  <Item>
##    the text that was stored on the &CAS; table
##    (which may contain incorrect statements).
##  </Item>
##  </List>
##  <Example>
##  gap> tbl:= CharacterTable( "m10" );
##  CharacterTable( "A6.2_3" )
##  gap> HasCASInfo( tbl );
##  true
##  gap> CASInfo( tbl );
##  [ rec( name := "m10", permchars := (3,5)(4,8,7,6), permclasses := (), 
##        text := "names:     m10\norder:     2^4.3^2.5 = 720\nnumber of c\
##  lasses: 8\nsource:    cambridge atlas\ncomments:  point stabilizer of \
##  mathieu-group m11\ntest:      orth, min, sym[3]\n" ) ]
##  </Example>
##  <P/>
##  The class fusions stored on tables from the &CAS; library
##  have been computed anew with &GAP;;
##  the <C>text</C> component of such a fusion record tells if the fusion map
##  is equal to that in the &CAS; library,
##  up to the permutation of classes between the table in
##  &CAS; and its &GAP; version.
##  <P/>
##  <Example>
##  gap> First( ComputedClassFusions( tbl ), x -> x.name = "M11" );
##  rec( map := [ 1, 2, 3, 4, 5, 4, 7, 8 ], name := "M11", 
##    text := "fusion is unique up to table automorphisms,\nthe representa\
##  tive is equal to the fusion map on the CAS table" )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "CASInfo", IsNearlyCharacterTable,
    [ "character", "class" ] );


#############################################################################
##
#A  Maxes( <tbl> )
##
##  <#GAPDoc Label="Maxes">
##  <ManSection>
##  <Attr Name="Maxes" Arg="tbl"/>
##
##  <Description>
##  If this attribute is set for an ordinary character table <A>tbl</A>
##  then the value is a list of identifiers of the ordinary character tables
##  of all maximal subgroups of <A>tbl</A>.
##  There is no default method to <E>compute</E> this value from <A>tbl</A>.
##  <P/>
##  If the <Ref Attr="Maxes"/> value of <A>tbl</A> is stored then it lists
##  exactly one representative for each conjugacy class of maximal subgroups
##  of the group of <A>tbl</A>,
##  and the character tables of these maximal subgroups are available in the
##  &GAP; Character Table Library,
##  and compatible class fusions to <A>tbl</A> are stored on these tables
##  (see the example in Section <Ref Subsect="subsect:primpermchars2A6"/>).
##  <P/>
##  <Example>
##  gap> tbl:= CharacterTable( "M11" );;
##  gap> HasMaxes( tbl );
##  true
##  gap> maxes:= Maxes( tbl );
##  [ "A6.2_3", "L2(11)", "3^2:Q8.2", "A5.2", "2.S4" ]
##  gap> CharacterTable( maxes[1] );
##  CharacterTable( "A6.2_3" )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "Maxes", IsNearlyCharacterTable, [] );


#############################################################################
##
#A  ConstructionInfoCharacterTable( <tbl> )
##
##  <#GAPDoc Label="ConstructionInfoCharacterTable">
##  <ManSection>
##  <Attr Name="ConstructionInfoCharacterTable" Arg="tbl"/>
##
##  <Description>
##  If this attribute is set for an ordinary character table <A>tbl</A>
##  then the value is a list that describes how this table was constructed.
##  The first entry is a string that is the identifier of the function that
##  was applied to the pre-table record;
##  the remaining entries are the arguments for that function,
##  except that the pre-table record must be prepended to these arguments.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#T should this be available also for other tables than library tables?
#T (direct products of tables with groups and library tables etc.)
#T and if it is a `SuppCT' attribute then should row/column permutations
#T be always optional arguments to be applied after the constuction?
##
DeclareAttributeSuppCT( "ConstructionInfoCharacterTable",
    IsNearlyCharacterTable, [ "character", "class" ] );


#############################################################################
##
#A  FusionToTom( <tbl> )
##
##  <#GAPDoc Label="FusionToTom">
##  <ManSection>
##  <Attr Name="FusionToTom" Arg="tbl"/>
##
##  <Description>
##  If this attribute is set for an ordinary character table <A>tbl</A> then
##  the &GAP; Library of Tables of Marks contains the table of marks of the
##  group of <A>tbl</A>,
##  and the attribute value is a record with the following components.
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the
##    <Ref Attr="Identifier" Label="for tables of marks" BookName="ref"/>
##    component of the table of marks of <A>tbl</A>,
##  </Item>
##  <Mark><C>map</C></Mark>
##  <Item>
##    the fusion map,
##  </Item>
##  <Mark><C>text</C> (optional)</Mark>
##  <Item>
##    a string describing the status of the fusion, and
##  </Item>
##  <Mark><C>perm</C> (optional)</Mark>
##  <Item>
##    a permutation that establishes the bijection between the classes of
##    maximal subgroups in the table of marks
##    (see <Ref Func="MaximalSubgroupsTom" BookName="ref"/>) and the
##    <Ref Func="Maxes"/> list of <A>tbl</A>.
##    Applying the permutation to the sublist of permutation characters
##    (see <Ref Func="PermCharsTom" BookName="ref"/>) at the positions of the
##    maximal subgroups of the table of marks yields the list of primitive
##    permutation characters computed from the character tables described by
##    the <Ref Func="Maxes"/> list.
##    Usually, there is no <C>perm</C> component, which means that the two
##    lists of primitive permutation characters are equal.
##    See Section <Ref Subsect="subsect:primpermchars2A6"/> for an example.
##  </Item>
##  </List>
##  <P/>
##  <Example>
##  gap> FusionToTom( CharacterTable( "2.A6" ) );
##  rec( map := [ 1, 2, 5, 4, 8, 3, 7, 11, 11, 6, 13, 6, 13 ], 
##    name := "2.A6", perm := (4,5), 
##    text := "fusion map is unique up to table autom." )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "FusionToTom", IsNearlyCharacterTable, [ "class" ] );


#############################################################################
##
#A  ProjectivesInfo( <tbl> )
##
##  <#GAPDoc Label="ProjectivesInfo">
##  <ManSection>
##  <Attr Name="ProjectivesInfo" Arg="tbl"/>
##
##  <Description>
##  If this attribute is set for an ordinary character table <A>tbl</A> then
##  the value is a list of records, each with the following components.
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the
##    <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##    value of the character table of the covering
##    whose faithful irreducible characters are described by the record,
##  </Item>
##  <Mark><C>chars</C></Mark>
##  <Item>
##    a list of values lists of faithful projective irreducibles;
##    only one representative of each family of Galois conjugates is
##    contained in this list.
##    and
##  </Item>
##  </List>
##  <P/>
##  <Example>
##  gap> ProjectivesInfo( CharacterTable( "A5" ) );
##  [ rec( 
##        chars := [ [ 2, 0, -1, E(5)+E(5)^4, E(5)^2+E(5)^3 ], 
##            [ 2, 0, -1, E(5)^2+E(5)^3, E(5)+E(5)^4 ], 
##            [ 4, 0, 1, -1, -1 ], [ 6, 0, 0, 1, 1 ] ], name := "2.A5" ) ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "ProjectivesInfo", IsNearlyCharacterTable,
    [ "class" ] );


#############################################################################
##
#A  ExtensionInfoCharacterTable( <tbl> )
##
##  <#GAPDoc Label="ExtensionInfoCharacterTable">
##  <ManSection>
##  <Attr Name="ExtensionInfoCharacterTable" Arg="tbl"/>
##
##  <Description>
##  Let <A>tbl</A> be the ordinary character table of a group <M>G</M>, say.
##  If this attribute is set for <A>tbl</A> then the value is a list of
##  length two,
##  the first entry being a string <C>M</C> that describes the Schur
##  multiplier of <M>G</M>
##  and the second entry being a string <C>A</C> that describes the outer
##  automorphism group of <M>G</M>.
##  Trivial multiplier or outer automorphism group are denoted by an empty
##  string.
##  <P/>
##  If <A>tbl</A> is a table from the &GAP; Character Table Library
##  and <M>G</M> is (nonabelian and) simple then the value is set.
##  In this case, an admissible name for the character table of a
##  universal covering group of <M>G</M>
##  (if this table is available and different from <A>tbl</A>)
##  is given by the concatenation of <C>M</C>, <C>"."</C>, and the
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of <A>tbl</A>.
##  Analogously, an admissible name for the character table of the
##  automorphism group of <M>G</M> (if this table is available and different
##  from <A>tbl</A>) is given by the concatenation of the
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of <A>tbl</A>, <C>"."</C>, and <C>A</C>.
##  <P/>
##  <Example>
##  gap> ExtensionInfoCharacterTable( CharacterTable( "A5" ) );
##  [ "2", "2" ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "ExtensionInfoCharacterTable",
    IsNearlyCharacterTable, [] );


#############################################################################
##
#A  GroupInfoForCharacterTable( <tbl> )
##
##  <#GAPDoc Label="GroupInfoForCharacterTable">
##  <ManSection>
##  <Attr Name="GroupInfoForCharacterTable" Arg="tbl"/>
##
##  <Description>
##  Let <A>tbl</A> be an ordinary character table
##  from the &GAP; Character Table Library.
##  <Ref Attr="GroupInfoForCharacterTable"/> returns a sorted list of pairs
##  such that calling <Ref Attr="GroupForGroupInfo"/> with any of these pairs
##  yields a group whose ordinary character table is <A>tbl</A>,
##  up to permutations of rows and columns.
##  <P/>
##  Note that this group is in general <E>not</E> determined up to
##  isomorphism, since nonisomorphic groups may have the same character table
##  (including power maps).
##  <P/>
##  Contrary to the attribute <Ref Attr="UnderlyingGroup" BookName="ref"/>,
##  the entries of the <Ref Attr="GroupInfoForCharacterTable"/> list for
##  <A>tbl</A> are not related to the ordering of the conjugacy classes in
##  <A>tbl</A>.
##  <P/>
##  Sources for this attribute are the &GAP; databases of groups
##  described in Chapter <Ref Chap="Group Libraries" BookName="ref"/>,
##  and the packages <Package>AtlasRep</Package> and
##  <Package>TomLib</Package>,
##  see also <Ref Func="GroupForTom"/> and <Ref Func="AtlasStabilizer"/>.
##  If these packages are not loaded then part of the information may be
##  missing.
##  If the <Package>Browse</Package> package (see&nbsp;<Cite Key="Browse"/>)
##  is not loaded then <Ref Attr="GroupInfoForCharacterTable"/> returns
##  always an empty list.
##  <P/>
##  <Example>
##  gap> GroupInfoForCharacterTable( CharacterTable( "A5" ) );
##  [ [ "AlternatingGroup", [ 5 ] ], [ "AtlasGroup", [ "A5" ] ], 
##    [ "AtlasStabilizer", [ "A6", "A6G1-p6aB0" ] ], 
##    [ "AtlasStabilizer", [ "A6", "A6G1-p6bB0" ] ], 
##    [ "AtlasStabilizer", [ "L2(11)", "L211G1-p11aB0" ] ], 
##    [ "AtlasStabilizer", [ "L2(11)", "L211G1-p11bB0" ] ], 
##    [ "AtlasStabilizer", [ "L2(19)", "L219G1-p57aB0" ] ], 
##    [ "AtlasStabilizer", [ "L2(19)", "L219G1-p57bB0" ] ], 
##    [ "AtlasSubgroup", [ "A5.2", 1 ] ], [ "AtlasSubgroup", [ "A6", 1 ] ]
##      , [ "AtlasSubgroup", [ "A6", 2 ] ], 
##    [ "AtlasSubgroup", [ "J2", 9 ] ], 
##    [ "AtlasSubgroup", [ "L2(109)", 4 ] ], 
##    [ "AtlasSubgroup", [ "L2(109)", 5 ] ], 
##    [ "AtlasSubgroup", [ "L2(11)", 1 ] ], 
##    [ "AtlasSubgroup", [ "L2(11)", 2 ] ], 
##    [ "AtlasSubgroup", [ "S6(3)", 11 ] ], 
##    [ "GroupForTom", [ "2^4:A5", 68 ] ], 
##    [ "GroupForTom", [ "2^4:A5`", 56 ] ], [ "GroupForTom", [ "A5" ] ], 
##    [ "GroupForTom", [ "A5xA5", 85 ] ], [ "GroupForTom", [ "A6", 21 ] ],
##    [ "GroupForTom", [ "J2", 99 ] ], 
##    [ "GroupForTom", [ "L2(109)", 25 ] ], 
##    [ "GroupForTom", [ "L2(11)", 15 ] ], 
##    [ "GroupForTom", [ "L2(125)", 18 ] ], 
##    [ "GroupForTom", [ "L2(16)", 18 ] ], 
##    [ "GroupForTom", [ "L2(19)", 17 ] ], 
##    [ "GroupForTom", [ "L2(29)", 19 ] ], 
##    [ "GroupForTom", [ "L2(31)", 25 ] ], 
##    [ "GroupForTom", [ "S5", 18 ] ], [ "PSL", [ 2, 4 ] ], 
##    [ "PSL", [ 2, 5 ] ], [ "PerfectGroup", [ 60, 1 ] ], 
##    [ "PrimitiveGroup", [ 5, 4 ] ], [ "PrimitiveGroup", [ 6, 1 ] ], 
##    [ "PrimitiveGroup", [ 10, 1 ] ], [ "SmallGroup", [ 60, 5 ] ], 
##    [ "TransitiveGroup", [ 5, 4 ] ], [ "TransitiveGroup", [ 6, 12 ] ], 
##    [ "TransitiveGroup", [ 10, 7 ] ], [ "TransitiveGroup", [ 12, 33 ] ],
##    [ "TransitiveGroup", [ 15, 5 ] ], [ "TransitiveGroup", [ 20, 15 ] ],
##    [ "TransitiveGroup", [ 30, 9 ] ] ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttributeSuppCT( "GroupInfoForCharacterTable",
    IsNearlyCharacterTable, [] );


#############################################################################
##
#P  KnowsSomeGroupInfo( <tbl> )
##
##  <#GAPDoc Label="KnowsSomeGroupInfo">
##  <ManSection>
##  <Prop Name="KnowsSomeGroupInfo" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A>,
##  this function returns <K>true</K> if the list returned by
##  <Ref Attr="GroupInfoForCharacterTable"/> is nonempty,
##  and <K>false</K> otherwise.
##  <P/>
##  <Example>
##  gap> KnowsSomeGroupInfo( CharacterTable( "A5" ) );
##  true
##  gap> KnowsSomeGroupInfo( CharacterTable( "M" ) );
##  false
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclarePropertySuppCT( "KnowsSomeGroupInfo", IsNearlyCharacterTable );


##############################################################################
##
#F  CharacterTableForGroupInfo( <info> )
##
##  <#GAPDoc Label="CharacterTableForGroupInfo">
##  <ManSection>
##  <Attr Name="CharacterTableForGroupInfo" Arg="info"/>
##
##  <Description>
##  This function is a partial inverse of
##  <Ref Attr="GroupInfoForCharacterTable"/>.
##  If <A>info</A> has the form
##  <C>[ </C><M>funcname</M><C>, </C><M>args</M><C> ]</C>
##  and occurs in the list returned by
##  <Ref Attr="GroupInfoForCharacterTable"/> when called with
##  a character table <M>t</M>, say,
##  then <Ref Func="CharacterTableForGroupInfo"/> returns
##  a character table from the &GAP; Character Table that is equivalent
##  to <M>t</M>.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> CharacterTableForGroupInfo( [ "AlternatingGroup", [ 5 ] ] );
##  CharacterTable( "A5" )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "CharacterTableForGroupInfo" );


##############################################################################
##
#F  GroupForGroupInfo( <info> )
##
##  <#GAPDoc Label="GroupForGroupInfo">
##  <ManSection>
##  <Attr Name="GroupForGroupInfo" Arg="info"/>
##
##  <Description>
##  If <A>info</A> has the form
##  <C>[ </C><M>funcname</M><C>, </C><M>args</M><C> ]</C>
##  and occurs in the list returned by
##  <Ref Attr="GroupInfoForCharacterTable"/> when called with
##  a character table <M>tbl</M>, say,
##  then <Ref Func="GroupForGroupInfo"/> returns a group that is described by
##  <A>info</A> and whose character table is equal to <M>tbl</M>,
##  up to permutations of rows and columns.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  Typically, <M>funcname</M> is a string that is the name of a
##  global &GAP; function <M>fun</M>, say,
##  and <M>args</M> is a list of arguments for this function
##  such that <C>CallFuncList( </C><M>fun</M><C>, </C><M>args</M><C> )</C>
##  yields the desired group.
##  <P/>
##  <Example>
##  gap> GroupForGroupInfo( [ "AlternatingGroup", [ 5 ] ] );
##  Alt( [ 1 .. 5 ] )
##  gap> GroupForGroupInfo( [ "PrimitiveGroup", [ 5, 4 ] ] );
##  A(5)
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "GroupForGroupInfo" );


#############################################################################
##
#F  GroupForTom( <tomidentifier>[, <repnr>] )
##
##  <#GAPDoc Label="GroupForTom">
##  <ManSection>
##  <Attr Name="GroupForTom" Arg="tomidentifier[, repnr]"/>
##
##  <Description>
##  Let <A>tomidentifier</A> be a string that is an admissible name for a
##  table of marks from the &GAP; Library of Tables of Marks
##  (the <Package>TomLib</Package> package <Cite Key="TomLib"/>).
##  Called with one argument, <Ref Func="GroupForTom"/> returns the
##  <Ref Func="UnderlyingGroup" BookName="ref"/> value of this table of
##  marks.
##  If a positive integer <A>repnr</A> is given as the second argument then
##  a representative of the <A>repnr</A>-th class of subgroups of this
##  group is returned, see <Ref Func="RepresentativeTom" BookName="ref"/>.
##  <P/>
##  The string<C>"GroupForTom"</C> may occur in the entries of the list
##  returned by <Ref Attr="GroupInfoForCharacterTable"/>,
##  and therefore may be called by <Ref Func="GroupForGroupInfo"/>.
##  <P/>
##  If the <Package>TomLib</Package> package is not loaded or if it does not
##  contain a table of marks with identifier <A>tomidentifier</A> then
##  <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> g:= GroupForTom( "A5" );  u:= GroupForTom( "A5", 2 );
##  Group([ (2,4)(3,5), (1,2,5) ])
##  Group([ (2,3)(4,5) ])
##  gap> IsSubset( g, u );
##  true
##  gap> GroupForTom( "J4" );
##  fail
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "GroupForTom" );


#############################################################################
##
#F  AtlasStabilizer( <gapname>, <repname> )
##
##  <#GAPDoc Label="AtlasStabilizer">
##  <ManSection>
##  <Func Name="AtlasStabilizer" Arg="gapname, repname"/>
##
##  <Description>
##  Let <A>gapname</A> be an admissible name of a group <M>G</M>, say,
##  in the sense of the <Package>AtlasRep</Package> package
##  (see Section&nbsp;<Ref Subsect="Group Names Used in the AtlasRep Package"
##  BookName="AtlasRep"/>), and <A>repname</A> be a string that occurs as the
##  <C>repname</C> component of a record returned by
##  <Ref Func="AllAtlasGeneratingSetInfos" BookName="AtlasRep"/> when this
##  function is called with first argument <A>gapname</A> and further
##  arguments <Ref Func="IsTransitive" BookName="ref"/> and <K>true</K>.
##  In this case,
##  <A>repname</A> describes a transitive permutation representation of
##  <M>G</M>.
##  <P/>
##  If the <Package>AtlasRep</Package> package is available and if the
##  permutation group in question can be fetched then
##  <Ref Func="AtlasStabilizer"/> returns a point stabilizer.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  The string<C>"AtlasStabilizer"</C> may occur in the entries of the list
##  returned by <Ref Attr="GroupInfoForCharacterTable"/>,
##  and therefore may be called by <Ref Func="GroupForGroupInfo"/>.
##  <P/>
##  <Example>
##  gap> AtlasStabilizer( "A5","A5G1-p5B0");
##  Group([ (1,2)(3,4), (2,3,4) ])
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasStabilizer" );


#############################################################################
##
#P  IsNontrivialDirectProduct( <tbl> )
##
##  <#GAPDoc Label="IsNontrivialDirectProduct">
##  <ManSection>
##  <Prop Name="IsNontrivialDirectProduct" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A> of the group <M>G</M>, say,
##  this function returns <K>true</K> if <M>G</M> is the direct product of
##  smaller groups, and <K>false</K> otherwise.
##  <P/>
##  <Example>
##  gap> mx:= Maxes( CharacterTable( "J1" ) );
##  [ "L2(11)", "2^3.7.3", "2xA5", "19:6", "11:10", "D6xD10", "7:6" ]
##  gap> List( mx, name -> IsNontrivialDirectProduct(
##  >                          CharacterTable( name ) ) );
##  [ false, false, true, false, false, true, false ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclarePropertySuppCT( "IsNontrivialDirectProduct", IsNearlyCharacterTable );


#############################################################################
##
#A  ClassInfo( <tbl> )
##
##  This is currently just a placeholder.
##  Frank might use it for some character tables.
##
DeclareAttributeSuppCT( "ClassInfo", IsNearlyCharacterTable, [ "class" ] );


#############################################################################
##
#A  RootDatumInfo( <tbl> )
##
##  This is currently just a placeholder.
##  Frank might use it for some character tables.
##
DeclareAttributeSuppCT( "RootDatumInfo", IsNearlyCharacterTable, [] );


#############################################################################
##
#P  KnowsDeligneLusztigNames( <tbl> )
##
##  <#GAPDoc Label="KnowsDeligneLusztigNames">
##  <ManSection>
##  <Prop Name="KnowsDeligneLusztigNames" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A>,
##  this function returns <K>true</K> if
##  <Ref Attr="DeligneLusztigNames"/> returns the list of
##  Deligne-Lusztig names of the unipotent characters of <A>tbl</A>,
##  and <K>false</K> otherwise.
##  <P/>
##  <Example>
##  gap> KnowsDeligneLusztigNames( CharacterTable( "A5" ) );
##  true
##  gap> KnowsDeligneLusztigNames( CharacterTable( "M" ) );
##  false
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  The return value depends on the identifier of the character table,
##  we cannot call `DeclarePropertySuppCT'.
##
DeclareProperty( "KnowsDeligneLusztigNames", IsNearlyCharacterTable );


#############################################################################
##
##  <#GAPDoc Label="intro:duplicates">
##  It can be useful to deal with different instances of <Q>the same</Q>
##  character table.
##  An example is the situation that a group <M>G</M>, say,
##  contains several classes of isomorphic maximal subgroups that have
##  different class fusions;
##  the attribute <Ref Attr="Maxes"/> of the character table of <M>G</M>
##  then contains several entries that belong to the same group,
##  but the identifiers of the character tables are different.
##  <P/>
##  On the other hand, it can be useful to consider only one of the different
##  instances when one searches for character tables with certain properties,
##  for example using <Ref Func="OneCharacterTableName"/>.
##  <P/>
##  <Index>duplicate character table</Index>
##  For that, we introduce the following concept.
##  A character table <M>t_1</M> is said to be a <E>duplicate</E>
##  of another character table <M>t_2</M> if the attribute
##  <Ref Attr="IdentifierOfMainTable"/> returns the
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of <M>t_2</M> when it is called with <M>t_1</M>,
##  and we call <M>t_2</M> the <E>main table</E> of <M>t_1</M>.
##  In this case, <Ref Prop="IsDuplicateTable"/> returns <K>true</K> for
##  <M>t_1</M>.
##  <P/>
##  If the character table <M>t_1</M> is not a duplicate of any other
##  library table then <Ref Attr="IdentifierOfMainTable"/> returns
##  <K>fail</K> for <M>t_1</M> and <Ref Prop="IsDuplicateTable"/> returns
##  <K>false</K>.
##  <P/>
##  See <Ref Func="AllCharacterTableNames"/> for examples how to apply
##  <Ref Prop="IsDuplicateTable"/> in practice.
##  <P/>
##  We do <E>not</E> promise that two library tables for which
##  <Ref Prop="IsDuplicateTable"/> returns <K>false</K> are necessarily
##  different.
##  (And since nonisomorphic groups may have the same character table,
##  it would not make sense to think about restricting a search to a
##  subset of library tables that belong to pairwise nonisomorphic groups.)
##  <P/>
##  Currently <Ref Attr="IdentifierOfMainTable"/> does not return <K>fail</K>
##  for <M>t_1</M> if
##  <Ref Attr="ConstructionInfoCharacterTable"/> is set in <M>t_1</M>,
##  the first entry of the attribute value is <C>"ConstructPermuted"</C>,
##  and one of the following holds.
##  <P/>
##  <List>
##  <Item>
##    The second entry of the <Ref Attr="ConstructionInfoCharacterTable"/>
##    value is a list of length <M>1</M> that contains the
##    <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##    value of <M>t_2</M>.
##  </Item>
##  <Item>
##    The <Package>SpinSym</Package> package is loaded and <M>t_1</M> is one
##    of the character tables provided by this package.
##    These tables are not declared as permuted tables of library tables,
##    but we <E>want</E> to regard them as duplicates.
##  </Item>
##  </List>
##  <#/GAPDoc>
##


#############################################################################
##
#P  IsDuplicateTable( <tbl> )
##
##  <#GAPDoc Label="IsDuplicateTable">
##  <ManSection>
##  <Prop Name="IsDuplicateTable" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A> from the &GAP; Character Table
##  Library, this function returns <K>true</K> if <A>tbl</A> was constructed
##  from another library character table by permuting rows and columns,
##  via the attribute <Ref Attr="ConstructionInfoCharacterTable"/>.
##  Otherwise <K>false</K> is returned, in particular if <A>tbl</A> is not a
##  character table from the &GAP; Character Table Library.
##  <P/>
##  One application of this function is to restrict the search with
##  <Ref Func="AllCharacterTableNames"/> to only one library character
##  table for each class of permutation equivalent tables.
##  Note that this property of the search result cannot be guaranteed
##  if private character tables have been added to the library,
##  see <Ref Func="NotifyCharacterTable"/>.
##  <P/>
##  <Example>
##  gap> Maxes( CharacterTable( "A6" ) );
##  [ "A5", "A6M2", "3^2:4", "s4", "A6M5" ]
##  gap> IsDuplicateTable( CharacterTable( "A5" ) );
##  false
##  gap> IsDuplicateTable( CharacterTable( "A6M2" ) );
##  true
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  Note that we do not call `DeclareAttributeSuppCT' because a `false' value
##  shall not be inherited via `ConstructPermuted':
##  If the main table has been loaded and has been asked for its value then
##  `false' is stored in it, and `ConstructPermuted' would set `false' also in
##  the duplicate table.
##
DeclareProperty( "IsDuplicateTable", IsNearlyCharacterTable );


#############################################################################
##
#A  IdentifierOfMainTable( <tbl> )
##
##  <#GAPDoc Label="IdentifierOfMainTable">
##  <ManSection>
##  <Attr Name="IdentifierOfMainTable" Arg="tbl"/>
##
##  <Description>
##  If <A>tbl</A> is an ordinary character table that is a duplicate in the
##  sense of the introduction to Section&nbsp;<Ref Sect="sec:duplicates"/>
##  then this function returns the
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of the main table of <A>tbl</A>.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> Maxes( CharacterTable( "A6" ) );
##  [ "A5", "A6M2", "3^2:4", "s4", "A6M5" ]
##  gap> IdentifierOfMainTable( CharacterTable( "A5" ) );
##  fail
##  gap> IdentifierOfMainTable( CharacterTable( "A6M2" ) );
##  "A5"
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  Note that we do not call `DeclareAttributeSuppCT' because a `fail' value
##  shall not be inherited via `ConstructPermuted':
##  If the main table has been loaded and has been asked for its value then
##  `fail' is stored in it, and `ConstructPermuted' would set `fail' also in
##  the duplicate table.
##
DeclareAttribute( "IdentifierOfMainTable", IsNearlyCharacterTable );


#############################################################################
##
#A  IdentifiersOfDuplicateTables( <tbl> )
##
##  <#GAPDoc Label="IdentifiersOfDuplicateTables">
##  <ManSection>
##  <Attr Name="IdentifiersOfDuplicateTables" Arg="tbl"/>
##
##  <Description>
##  For an ordinary character table <A>tbl</A>,
##  this function returns the list of
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  values of those character tables from the &GAP; Character Table Library
##  that are duplicates of <A>tbl</A>, in the sense of the introduction to
##  Section&nbsp;<Ref Sect="sec:duplicates"/>.
##  <P/>
##  <Example>
##  gap> Maxes( CharacterTable( "A6" ) );
##  [ "A5", "A6M2", "3^2:4", "s4", "A6M5" ]
##  gap> IdentifiersOfDuplicateTables( CharacterTable( "A5" ) );
##  [ "A6M2", "Alt(5)" ]
##  gap> IdentifiersOfDuplicateTables( CharacterTable( "A6M2" ) );
##  [  ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  Note that we do not call `DeclareAttributeSuppCT' because the value shall
##  not be inherited via `ConstructPermuted'.
##
DeclareAttribute( "IdentifiersOfDuplicateTables", IsNearlyCharacterTable );


#############################################################################
##
#F  StructureDescriptionCharacterTableName( <name> )
##
##  <#GAPDoc Label="StructureDescriptionCharacterTableName">
##  <ManSection>
##  <Func Name="StructureDescriptionCharacterTableName" Arg="name"/>
##
##  <Description>
##  For a string <A>name</A> that is an admissible name of a character table,
##  <Ref Func="StructureDescriptionCharacterTableName"/> returns a string
##  that is intended as a description of the structure of the underlying
##  group.
##  <P/>
##  Note that many identifiers of character tables
##  (see <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>)
##  do not describe the group structure in an appropriate way.
##  One reason for choosing such identifiers on purpose is that several
##  character tables for isomorphic groups can be contained in the library,
##  because the groups have different class fusions into another group.
##  For example, the Mathieu group <M>M_{12}</M> contains two classes of
##  subgroups isomorphic with <M>M_{11}</M>, and the identifiers of the
##  character tables corresponding to these subgroups are <C>"M11"</C> and
##  <C>"M12M2"</C>, respectively.
##  <P/>
##  <Example>
##  gap> StructureDescriptionCharacterTableName( "M12M2" );
##  "M11"
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "StructureDescriptionCharacterTableName" );


#############################################################################
##
#F  GaloisPartnersOfIrreducibles( <tbl>, <characters>, <n> )
##
DeclareGlobalFunction( "GaloisPartnersOfIrreducibles" );


#############################################################################
##
#F  AtlasLabelsOfIrreducibles( <tbl>[, "short"] )
##
##  <#GAPDoc Label="AtlasLabelsOfIrreducibles">
##  <ManSection>
##  <Func Name="AtlasLabelsOfIrreducibles" Arg="tbl[, short]"/>
##
##  <Description>
##  Let <A>tbl</A> be the (ordinary or Brauer) character table of a bicyclic
##  extension of a simple group that occurs in the
##  &ATLAS; of Finite Groups&nbsp;<Cite Key="CCN85"/> or the
##  &ATLAS; of Brauer Characters&nbsp;<Cite Key="JLPW95"/>.
##  <Ref Func="AtlasLabelsOfIrreducibles"/> returns a list of strings,
##  the <M>i</M>-th entry being a label for the <M>i</M>-th irreducible
##  character of <A>tbl</A>.
##  <P/>
##  The labels have the following form.
##  We state the rules only for ordinary characters,
##  the rules for Brauer characters are obtained by replacing <M>\chi</M>
##  by <M>\varphi</M>.
##  <P/>
##  First consider only downward extensions <M>m.G</M> of a simple group
##  <M>G</M>.
##  If <M>m \leq 2</M> then only labels of the form <M>\chi_i</M> occur,
##  which denotes the <M>i</M>-th ordinary character shown in the &ATLAS;.
##  <P/>
##  The labels of faithful ordinary characters of groups <M>m.G</M> with
##  <M>m \geq 3</M> are of the form <M>\chi_i</M>, <M>\chi_i^*</M>,
##  or <M>\chi_i^{{*k}}</M>,
##  which means the <M>i</M>-th character printed in the &ATLAS;,
##  the unique character that is not printed and for which <M>\chi_i</M>
##  acts as proxy (see
##  <Cite Key="CCN85" Where="Chapter&nbsp;7, Sections&nbsp;8 and&nbsp;19"/>),
##  and the image of the printed character <M>\chi_i</M> under the algebraic
##  conjugacy operator <M>*k</M>, respectively.
##  <P/>
##  For groups <M>m.G.a</M> with <M>a &gt; 1</M>, the labels of the
##  irreducible characters are derived from the labels of the irreducible
##  constituents of their restrictions to <M>m.G</M>, as follows.
##  <P/>
##  <Enum>
##  <Item>
##    If the ordinary irreducible character <M>\chi_i</M> of <M>m.G</M>
##    extends to <M>m.G.a</M> then the <M>a^\prime</M> extensions are
##    denoted by
##    <M>\chi_{{i,0}}, \chi_{{i,1}}, \ldots, \chi_{{i,a^\prime}}</M>,
##    where <M>\chi_{{i,0}}</M> is the character whose values are printed
##    in the &ATLAS;.
##  </Item>
##  <Item>
##    The label <M>\chi_{{i_1 + i_2 + \cdots + i_a}}</M> means that <M>a</M>
##    different characters
##    <M>\chi_{{i_1}}, \chi_{{i_2}}, \ldots, \chi_{{i_a}}</M>
##    of <M>m.G</M> induce to an irreducible character of <M>m.G.a</M> with
##    this label.
##    <P/>
##    If either <K>true</K> or the string <C>"short"</C> is entered
##    as the second argument then the label has the short form
##    <M>\chi_{{i_1+}}</M>.
##    Note that <M>i_2, i_3, \ldots, i_a</M> can be read off from the
##    fusion signs in the &ATLAS;.
##  </Item>
##  <Item>
##    Finally, the label
##    <M>\chi_{{i_1,j_1 + i_2,j_2 + \cdots + i_{{a^\prime}},j_{{a^\prime}}}}</M>
##    means that the characters
##    <M>\chi_{{i_1}}, \chi_{{i_2}}, \ldots, \chi_{{i_{{a^\prime}}}}</M> of
##    <M>m.G</M> extend to a group that lies properly between <M>m.G</M> and
##    <M>m.G.a</M>,
##    and the extensions <M>\chi_{{i_1, j_1}}, \chi_{{i_2, j_2}}, \ldots
##    \chi_{{i_{{a^\prime}},j_{{a^\prime}}}}</M>
##    induce to an irreducible character of <M>m.G.a</M> with this label.
##    <P/>
##    If <K>true</K> or the string <C>"short"</C> was entered as the
##    second argument then the label has the short form <M>\chi_{{i,j+}}</M>.
##  </Item>
##  </Enum>
##  <P/>
##  <Example>
##  gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A7.2" ) );
##  [ "\\chi_{1,0}", "\\chi_{1,1}", "\\chi_{2,0}", "\\chi_{2,1}", 
##    "\\chi_{3+4}", "\\chi_{5,0}", "\\chi_{5,1}", "\\chi_{6,0}", 
##    "\\chi_{6,1}", "\\chi_{7,0}", "\\chi_{7,1}", "\\chi_{8,0}", 
##    "\\chi_{8,1}", "\\chi_{9,0}", "\\chi_{9,1}", "\\chi_{17+17\\ast 2}",
##    "\\chi_{18+18\\ast 2}", "\\chi_{19+19\\ast 2}", 
##    "\\chi_{20+20\\ast 2}", "\\chi_{21+21\\ast 2}", 
##    "\\chi_{22+23\\ast 8}", "\\chi_{22\\ast 8+23}" ]
##  gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A7.2" ), "short" );
##  [ "\\chi_{1,0}", "\\chi_{1,1}", "\\chi_{2,0}", "\\chi_{2,1}", 
##    "\\chi_{3+}", "\\chi_{5,0}", "\\chi_{5,1}", "\\chi_{6,0}", 
##    "\\chi_{6,1}", "\\chi_{7,0}", "\\chi_{7,1}", "\\chi_{8,0}", 
##    "\\chi_{8,1}", "\\chi_{9,0}", "\\chi_{9,1}", "\\chi_{17+}", 
##    "\\chi_{18+}", "\\chi_{19+}", "\\chi_{20+}", "\\chi_{21+}", 
##    "\\chi_{22+}", "\\chi_{23+}" ]
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasLabelsOfIrreducibles" );


#############################################################################
##
#F  NameOfLibraryCharacterTable( <tomname> )
##
##  <#GAPDoc Label="NameOfLibraryCharacterTable">
##  <ManSection>
##  <Func Name="NameOfLibraryCharacterTable" Arg="tomname"/>
##
##  <Description>
##  This function returns the
##  <Ref Attr="Identifier" Label="for character tables" BookName="ref"/>
##  value of the character table corresponding to the table of marks with
##  <Ref Attr="Identifier" Label="for tables of marks" BookName="ref"/>
##  value <A>tomname</A>.
##  If no such character table exists in the &GAP; Character Table Library
##  or if the <Package>TomLib</Package> package is not loaded
##  then <K>fail</K> is returned.
##  <P/>
##  <Example>
##  gap> NameOfLibraryCharacterTable( "A5" );
##  "A5"
##  gap> NameOfLibraryCharacterTable( "S5" );
##  "A5.2"
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "NameOfLibraryCharacterTable" );


#############################################################################
##
#E

