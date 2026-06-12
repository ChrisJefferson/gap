#############################################################################
##
#W  interfac.gd          GAP 4 package AtlasRep                 Thomas Breuer
##
##  This file contains the declaration part of the ``high level'' GAP
##  interface to the ATLAS of Group Representations.
##


#############################################################################
##
#F  DisplayAtlasInfo( [<listofnames>][,][<std>][,]["contents", <sources>]
#F                    [, IsPermGroup[, <bool>]]
#F                    [, NrMovedPoints, <n>]
#F                    [, IsTransitive[, <bool>]]
#F                    [, Transitivity, <n>]
#F                    [, IsPrimitive[, <bool>]]
#F                    [, RankAction, <n>]
#F                    [, IsMatrixGroup[, <bool>]]
#F                    [, Characteristic, <p>][, Dimension, <n>]
#F                    [, Ring, <R>]
#F                    [, Position, <n>]
#F                    [, Character, <chi>]
#F                    [, Identifier, <id>] )
#F  DisplayAtlasInfo( <gapname>[, <std>][, "contents", <sources>]
#F                    [, IsPermGroup[, <bool>]]
#F                    [, NrMovedPoints, <n>]
#F                    [, IsTransitive[, <bool>]]
#F                    [, Transitivity, <n>]
#F                    [, IsPrimitive[, <bool>]]
#F                    [, RankAction, <n>]
#F                    [, IsMatrixGroup[, <bool>]]
#F                    [, Characteristic, <p>][, Dimension, <n>]
#F                    [, Ring, <R>]
#F                    [, Position, <n>]
#F                    [, Character, <chi>]
#F                    [, Identifier, <id>]
#F                    [, IsStraightLineProgram[, <bool>]] )
##
##  <#GAPDoc Label="DisplayAtlasInfo">
##  <ManSection>
##  <Func Name="DisplayAtlasInfo"
##  Arg='[listofnames][,][std][,]["contents", sources][, ...]'/>
##  <Func Name="DisplayAtlasInfo" Arg='gapname[, std][, ...]'
##  Label="for a group name, and optionally further restrictions"/>
##
##  <Description>
##  This function lists the information available via the &AtlasRep; package,
##  for the given input.
##  <P/>
##  There are essentially three ways of calling this function.
##  <List>
##  <Item>
##    If there is no argument or if the first argument is a list
##    <A>listofnames</A> of strings that are &GAP; names of groups,
##    <Ref Func="DisplayAtlasInfo"/> shows an overview of
##    the known information.
##  </Item>
##  <Item>
##    If the first argument is a string <A>gapname</A> that is a
##    &GAP; name of a group,
##    <Ref Func="DisplayAtlasInfo"/> shows an overview of the information
##    that is available for this group.
##  </Item>
##  <Item>
##    If the string <C>"contents"</C> is the only argument
##    then the function shows which parts of the database are available;
##    these are at least the <C>"core"</C> part, which means the data from
##    the &ATLAS; of Group Representations, and the <C>"internal"</C> part,
##    which means the data that are distributed with the &AtlasRep; package.
##    Other parts can become available by calls to 
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/>.
##    Note that the shown numbers of locally available files depend on
##    what has already been downloaded.
##  </Item>
##  </List>
##  <P/>
##  In each case,
##  the information will be printed to the screen
##  or will be fed into a pager,
##  see Section <Ref Subsect="subsect:DisplayFunction"/>.
##  An interactive alternative to <Ref Func="DisplayAtlasInfo"/> is the
##  function <Ref Func="BrowseAtlasInfo" BookName="Browse"/>,
##  see <Cite Key="Browse"/>.
##  <P/>
##  The following paragraphs describe the structure of the output in the
##  two cases.
##  Examples can be found in
##  Section&nbsp;<Ref Subsect="sect:Examples for DisplayAtlasInfo"/>.
##  <P/>
##  Called without arguments, <Ref Func="DisplayAtlasInfo"/> shows a general
##  overview for all groups.
##  If some information is available for the group <M>G</M>, say,
##  then one line is shown for <M>G</M>, with the following columns.
##  <P/>
##  <List>
##  <Mark><C>group</C></Mark>
##  <Item>
##    the &GAP; name of <M>G</M> (see
##    Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>),
##    if applicable followed by a string (by default a star <C>*</C>)
##    indicating that at least one column refers to data not belonging to
##    the core part of the database
##    (see Section <Ref Subsect="subsect:AtlasRepMarkNonCoreData"/>).
##  </Item>
##  <Mark><C>#</C></Mark>
##  <Item>
##    the number of faithful representations stored for <M>G</M>
##    that satisfy the additional conditions given (see below),
##  </Item>
##  <Mark><C>maxes</C></Mark>
##  <Item>
##    the number of available straight line programs
##    <Index>straight line program</Index>
##    for computing generators of maximal subgroups of <M>G</M>,
##  </Item>
##  <Mark><C>cl</C></Mark>
##  <Item>
##    a <C>+</C> sign if at least one program for computing representatives
##    of conjugacy classes of elements of <M>G</M> is stored,
##  </Item>
##  <Mark><C>cyc</C></Mark>
##  <Item>
##    a <C>+</C> sign if at least one program for computing representatives
##    of classes of maximally cyclic subgroups of <M>G</M> is stored,
##  </Item>
##  <Mark><C>out</C></Mark>
##  <Item>
##    descriptions of outer automorphisms of <M>G</M> for which at least
##    one program is stored,
##  </Item>
##  <Mark><C>fnd</C></Mark>
##  <Item>
##    a <C>+</C> sign if at least one program is available for finding
##    standard generators,
##  </Item>
##  <Mark><C>chk</C></Mark>
##  <Item>
##    a <C>+</C> sign if at least one program is available for checking
##    whether a set of generators is a set of standard generators,
##    and
##  </Item>
##  <Mark><C>prs</C></Mark>
##  <Item>
##    a <C>+</C> sign if at least one program is available that encodes a
##    presentation.
##  </Item>
##  </List>
##  <P/>
##  Called with a list <A>listofnames</A> of strings that are &GAP; names of
##  some groups,
##  <Ref Func="DisplayAtlasInfo"/> prints the overview described above
##  but restricted to the groups in this list.
##  <P/>
##  In addition to or instead of <A>listofnames</A>,
##  the string <C>"contents"</C> and a description <M>sources</M> of the
##  data may be given about which the overview is formed.
##  See below for admissible values of <M>sources</M>.
##  <P/>
##  Called with a string <A>gapname</A> that is a &GAP; name of a group,
##  <Ref Func="DisplayAtlasInfo"/> prints an overview of the information
##  that is available for this group.
##  One line is printed for each faithful representation,
##  showing the number of this representation
##  (which can be used in calls of <Ref Func="AtlasGenerators"/>),
##  and a string of one of the following forms;
##  in both cases, <M>id</M> is a (possibly empty) string.
##  <P/>
##  <List>
##  <Mark><C>G &lt;= Sym(</C><M>n</M><M>id</M><C>)</C></Mark>
##  <Item>
##      denotes a permutation representation of degree <M>n</M>,
##      for example <C>G &lt;= Sym(40a)</C> and <C>G &lt;= Sym(40b)</C>
##      denote two (nonequivalent) representations of degree <M>40</M>.
##  </Item>
##  <Mark><C>G &lt;= GL(</C><M>n</M><M>id</M>,<M>descr</M><C>)</C></Mark>
##  <Item>
##      denotes a matrix representation of dimension <M>n</M> over a
##      coefficient ring described by <M>descr</M>,
##      which can be a prime power,
##      <C>ℤ</C> (denoting the ring of integers),
##      a description of an algebraic extension field,
##      <C>ℂ</C> (denoting an unspecified algebraic extension field), or
##      <C>ℤ/</C><M>m</M><C>ℤ</C> for an integer <M>m</M>
##      (denoting the ring of residues mod <M>m</M>);
##      for example, <C>G &lt;= GL(2a,4)</C> and <C>G &lt;= GL(2b,4)</C>
##      denote two (nonequivalent) representations of dimension <M>2</M> over
##      the field with four elements.
##  </Item>
##  </List>
##  <P/>
##  Below the representations,
##  the programs available for <A>gapname</A> are listed.
##  In each row of the overview, the entry in the first column is followed
##  by a string (by default a star <C>*</C>) if the row refers to data
##  not belonging to the core part of the database
##  (see Section <Ref Subsect="subsect:AtlasRepMarkNonCoreData"/>).
##  <P/>
##  The following optional arguments can be used to restrict the overviews.
##  <P/>
##  <List>
##  <Mark><A>std</A></Mark>
##  <Item>
##    must be a positive integer or a list of positive integers;
##    if it is given then only those representations are considered
##    that refer to the <A>std</A>-th set of standard generators or the
##    <M>i</M>-th set of standard generators, for <M>i</M> in <A>std</A>
##    (see
##    Section&nbsp;<Ref Sect="sect:Standard Generators Used in AtlasRep"/>),
##  </Item>
##  <Mark><C>"contents"</C> and <M>sources</M></Mark>
##  <Item>
##    for a string or a list of strings <M>sources</M>,
##    restrict the data about which the overview is formed;
##    if <M>sources</M> is the string <C>"core"</C> then only data from the
##    &ATLAS; of Group Representations are considered,
##    if <M>sources</M> is a string that denotes a data extension in the
##    sense of a <C>dirid</C> argument of
##    <Ref Func="AtlasOfGroupRepresentationsNotifyData"
##    Label="for a local file describing private data"/> then
##    only the data that belong to this data extension are considered;
##    also a list of such strings may be given, then the union of these
##    data is considered,
##  </Item>
##  <Mark><C>Identifier</C> and <M>id</M></Mark>
##  <Item>
##    restrict to representations with <C>id</C> component in the
##    list <M>id</M> (note that this component is itself a list, entering
##    this list is not admissible),
##    or satisfying the function <M>id</M>,
##  </Item>
##  <Mark><C>IsPermGroup</C> and <K>true</K> (or <K>false</K>)</Mark>
##  <Item>
##    restrict to permutation representations (or to representations that are
##    not permutation representations),
##  </Item>
##  <Mark><C>NrMovedPoints</C> and <M>n</M></Mark>
##  <Item>
##    for a positive integer, a list of positive integers,
##    or a property <M>n</M>,
##    restrict to permutation representations of degree equal to <M>n</M>,
##    or in the list <M>n</M>, or satisfying the function <M>n</M>,
##  </Item>
##  <Mark><C>NrMovedPoints</C> and the string <C>"minimal"</C></Mark>
##  <Item>
##    restrict to faithful permutation representations of minimal degree
##    (if this information is available),
##  </Item>
##  <Mark><C>IsTransitive</C> and a boolean value</Mark>
##  <Item>
##    restrict to transitive or intransitive permutation representations
##    where this information is available (if the value <K>true</K> or
##    <K>false</K> is given),
##    or to representations for which this information is not available
##    (if the value <K>fail</K> is given),
##  </Item>
##  <Mark><C>IsPrimitive</C> and a boolean value</Mark>
##  <Item>
##    restrict to primitive or imprimitive permutation representations
##    where this information is available (if the value <K>true</K> or
##    <K>false</K> is given),
##    or to representations for which this information is not available
##    (if the value <K>fail</K> is given),
##  </Item>
##  <Mark><C>Transitivity</C> and <M>n</M></Mark>
##  <Item>
##    for a nonnegative integer, a list of nonnegative integers,
##    or a property <M>n</M>,
##    restrict to permutation representations for which the information is
##    available that the transitivity is equal to <M>n</M>,
##    or is in the list <M>n</M>, or satisfies the function <M>n</M>;
##    if <M>n</M> is <K>fail</K> then restrict to all permutation
##    representations for which this information is not available,
##  </Item>
##  <Mark><C>RankAction</C> and <M>n</M></Mark>
##  <Item>
##    for a nonnegative integer, a list of nonnegative integers,
##    or a property <M>n</M>,
##    restrict to permutation representations for which the information is
##    available that the rank is equal to <M>n</M>,
##    or is in the list <M>n</M>, or satisfies the function <M>n</M>;
##    if <M>n</M> is <K>fail</K> then restrict to all permutation
##    representations for which this information is not available,
##  </Item>
##  <Mark><C>IsMatrixGroup</C> and <K>true</K> (or <K>false</K>)</Mark>
##  <Item>
##    restrict to matrix representations (or to representations that are
##    not matrix representations),
##  </Item>
##  <Mark><C>Characteristic</C> and <M>p</M></Mark>
##  <Item>
##    for a prime integer, a list of prime integers, or a property <M>p</M>,
##    restrict to matrix representations over fields of characteristic equal
##    to <M>p</M>, or in the list <M>p</M>,
##    or satisfying the function <M>p</M>
##    (representations over residue class rings that are not fields can be
##    addressed by entering <K>fail</K> as the value of <M>p</M>),
##  </Item>
##  <Mark><C>Dimension</C> and <M>n</M></Mark>
##  <Item>
##    for a positive integer, a list of positive integers,
##    or a property <M>n</M>,
##    restrict to matrix representations of dimension equal to <M>n</M>,
##    or in the list <M>n</M>, or satisfying the function <M>n</M>,
##  </Item>
##  <Mark><C>Characteristic</C>, <M>p</M>, <C>Dimension</C>,
##        and the string <C>"minimal"</C></Mark>
##  <Item>
##    for a prime integer <M>p</M>,
##    restrict to faithful matrix representations over fields
##    of characteristic <M>p</M> that have minimal dimension
##    (if this information is available),
##  </Item>
##  <Mark><C>Ring</C> and <M>R</M></Mark>
##  <Item>
##    for a ring or a property <M>R</M>,
##    restrict to matrix representations for which the information is
##    available that the ring spanned by the matrix entries is contained
##    in this ring or satisfies this property
##    (note that the representation might be defined over a proper subring);
##    if <M>R</M> is <K>fail</K> then restrict to all matrix representations
##    for which this information is not available,
##  </Item>
##  <Mark><C>Ring</C>, <M>R</M>, <C>Dimension</C>,
##        and the string <C>"minimal"</C></Mark>
##  <Item>
##    for a ring <M>R</M>, restrict to faithful matrix representations
##    over this ring that have minimal dimension
##    (if this information is available),
##  </Item>
##  <Mark><C>Character</C> and <M>chi</M></Mark>
##  <Item>
##    for a class function or a list of class functions <M>chi</M>,
##    restrict to representations with these characters
##    (note that the underlying characteristic of the class function,
##    see Section&nbsp;<Ref Sect="UnderlyingCharacteristic" BookName="ref"/>,
##    determines the characteristic of the representation),
##  </Item>
##  <Mark><C>Character</C> and <M>name</M></Mark>
##  <Item>
##    for a string <M>name</M>,
##    restrict to representations for which the character is known to have
##    this name,
##    according to the information shown by <Ref Func="DisplayAtlasInfo"/>;
##    if the characteristic is not specified then it defaults to zero,
##  </Item>
##  <Mark><C>Character</C> and <M>n</M></Mark>
##  <Item>
##    for a positive integer <M>n</M>,
##    restrict to representations for which the character is known to be the
##    <M>n</M>-th irreducible character in &GAP;'s library character table
##    of the group in question;
##    if the characteristic is not specified then it defaults to zero,
##  </Item>
##  <Mark><C>IsStraightLineProgram</C> and <K>true</K></Mark>
##  <Item>
##    restrict to straight line programs,
##    straight line decisions
##    (see Section&nbsp;<Ref Sect="sect:Straight Line Decisions"/>),
##    and black box programs
##    (see Section&nbsp;<Ref Sect="sect:Black Box Programs"/>),
##    and
##  </Item>
##  <Mark><C>IsStraightLineProgram</C> and <K>false</K></Mark>
##  <Item>
##    restrict to representations.
##  </Item>
##  </List>
##  <P/>
##  Note that the above conditions refer only to the information that is
##  available without accessing the representations.
##  For example, if it is not stored in the table of contents whether a
##  permutation representation is primitive then this representation does not
##  match an <C>IsPrimitive</C> condition in <Ref Func="DisplayAtlasInfo"/>.
##  <P/>
##  If <Q>minimality</Q> information is requested and no available
##  representation matches this condition then either no minimal
##  representation is available or the information about the minimality
##  is missing.
##  See <Ref Func="MinimalRepresentationInfo"/> for checking whether the
##  minimality information is available for the group in question.
##  Note that in the cases where the string <C>"minimal"</C> occurs as an
##  argument, <Ref Func="MinimalRepresentationInfo"/> is called with third
##  argument <C>"lookup"</C>;
##  this is because the stored information was precomputed just for
##  the groups in the &ATLAS; of Group Representations,
##  so trying to compute non-stored minimality information (using other
##  available databases) will hardly be successful.
##  <P/>
##  The representations are ordered as follows.
##  Permutation representations come first (ordered according to their
##  degrees),
##  followed by matrix representations over finite fields
##  (ordered first according to the field size and second according to
##  the dimension), matrix representations over the integers,
##  and then matrix representations over algebraic extension fields
##  (both kinds ordered according to the dimension),
##  the last representations are matrix representations over residue class
##  rings (ordered first according to the modulus and second according to the
##  dimension).
##  <P/>
##  The maximal subgroups are ordered according to decreasing group order.
##  For an extension <M>G.p</M> of a simple group <M>G</M> by an outer
##  automorphism of prime order <M>p</M>,
##  this means that <M>G</M> is the first maximal subgroup
##  and then come the extensions of the maximal subgroups of <M>G</M> and the
##  novelties;
##  so the <M>n</M>-th maximal subgroup of <M>G</M> and the <M>n</M>-th
##  maximal subgroup of <M>G.p</M> are in general not related.
##  (This coincides with the numbering used for the
##  <Ref Func="Maxes" BookName="ctbllib"/> attribute for character tables.)
##  </Description>
##  </ManSection>
##
##  <Subsection Label="sect:Examples for DisplayAtlasInfo">
##  <Heading>Examples for DisplayAtlasInfo</Heading>
##
##  Here are some examples how <Ref Func="DisplayAtlasInfo"/> can be called,
##  and how its output can be interpreted.
##  <P/>
##  <Log><![CDATA[
##  gap> DisplayAtlasInfo( "contents" );
##  - AtlasRepAccessRemoteFiles: false
##  
##  - AtlasRepDataDirectory: /home/you/gap/pkg/atlasrep/
##  
##  ID       | address, version, files                        
##  ---------+------------------------------------------------
##  core     | http://atlas.math.rwth-aachen.de/Atlas/,
##           | version 2019-04-08,                            
##           | 10586 files locally available.                 
##  ---------+------------------------------------------------
##  internal | atlasrep/datapkg,                              
##           | version 2019-05-06,                            
##           | 276 files locally available.                   
##  ---------+------------------------------------------------
##  mfer     | http://www.math.rwth-aachen.de/~mfer/datagens/,
##           | version 2015-10-06,                            
##           | 34 files locally available.                    
##  ---------+------------------------------------------------
##  ctblocks | ctblocks/atlas/,   
##           | version 2019-04-08,                            
##           | 121 files locally available.                   
##  ]]></Log>
##  <P/>
##  Note: The above output does not fit to the rest of the manual examples,
##  since data extensions except <C>internal</C> have been removed at the
##  beginning of Chapter <Ref Chap="chap:tutorial" Style="Number"/>.
##  <P/>
##  The output tells us that two data extensions have been notified
##  in addition to the core data from the &ATLAS; of Group Representations
##  and the (local) internal data distributed with the &AtlasRep; package.
##  The files of the extension <C>mfer</C> must be downloaded before they
##  can be read (but note that the access to remote files is disabled),
##  and the files of the extension <C>ctblocks</C> are locally available
##  in the <F>ctblocks/atlas</F> subdirectory of the &GAP; package directory.
##  This table (in particular the numbers of locally available files)
##  depends on your installation of the package and how many files you have
##  already downloaded.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( [ "M11", "A5" ] );
##  group |  # | maxes | cl | cyc | out | fnd | chk | prs
##  ------+----+-------+----+-----+-----+-----+-----+----
##  M11   | 42 |     5 |  + |  +  |     |  +  |  +  |  + 
##  A5*   | 18 |     3 |  + |     |     |     |  +  |  + 
##  ]]></Example>
##  <P/>
##  The above output means that the database provides
##  <M>42</M> representations of the Mathieu group <M>M_{11}</M>,
##  straight line programs for computing generators of representatives
##  of all five classes of maximal subgroups,
##  for computing representatives of the conjugacy classes of elements
##  and of generators of maximally cyclic subgroups,
##  contains no straight line program for applying outer automorphisms
##  (well, in fact <M>M_{11}</M> admits no nontrivial outer automorphism),
##  and contains straight line decisions that check a set of generators
##  or a set of group elements for being a set of standard generators.
##  Analogously,
##  <M>18</M> representations of the alternating group <M>A_5</M> are
##  available, straight line programs for computing generators of
##  representatives of all three classes of maximal subgroups,
##  and no straight line programs for computing representatives
##  of the conjugacy classes of elements,
##  of generators of maximally cyclic subgroups,
##  and no for computing images under outer automorphisms;
##  straight line decisions for checking the standardization of generators
##  or group elements are available.
##  The star <C>*</C> in the first column of the row for <M>A_5</M> means
##  that some of the available data do not belong to the core part of the
##  database (see Section <Ref Subsect="subsect:AtlasRepMarkNonCoreData"/>).
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( [ "M11", "A5" ], NrMovedPoints, 11 );
##  group | # | maxes | cl | cyc | out | fnd | chk | prs
##  ------+---+-------+----+-----+-----+-----+-----+----
##  M11   | 1 |     5 |  + |  +  |     |  +  |  +  |  + 
##  ]]></Example>
##  <P/>
##  The given conditions restrict the overview to permutation representations
##  on <M>11</M> points.
##  The rows for all those groups are omitted for which no such
##  representation is available, and the numbers of those representations are
##  shown that satisfy the given conditions.
##  In the above example, we see that no representation on <M>11</M> points
##  is available for <M>A_5</M>, and exactly one such representation is
##  available for <M>M_{11}</M>.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( "A5", IsPermGroup, true );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##  1: G <= Sym(5)  3-trans., on cosets of A4 (1st max.)
##  2: G <= Sym(6)  2-trans., on cosets of D10 (2nd max.)
##  3: G <= Sym(10) rank 3, on cosets of S3 (3rd max.)
##  gap> DisplayAtlasInfo( "A5", NrMovedPoints, [ 4 .. 9 ] );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##  1: G <= Sym(5) 3-trans., on cosets of A4 (1st max.)
##  2: G <= Sym(6) 2-trans., on cosets of D10 (2nd max.)
##  ]]></Example>
##  <P/>
##  The first three representations stored for <M>A_5</M> are
##  (in fact primitive) permutation representations.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( "A5", Dimension, [ 1 .. 3 ] );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##   8: G <= GL(2a,4)                character 2a
##   9: G <= GL(2b,4)                character 2b
##  10: G <= GL(3,5)                 character 3a
##  12: G <= GL(3a,9)                character 3a
##  13: G <= GL(3b,9)                character 3b
##  17: G <= GL(3a,Field([Sqrt(5)])) character 3a
##  18: G <= GL(3b,Field([Sqrt(5)])) character 3b
##  gap> DisplayAtlasInfo( "A5", Characteristic, 0 );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##  14: G <= GL(4,Z)                 character 4a
##  15: G <= GL(5,Z)                 character 5a
##  16: G <= GL(6,Z)                 character 3ab
##  17: G <= GL(3a,Field([Sqrt(5)])) character 3a
##  18: G <= GL(3b,Field([Sqrt(5)])) character 3b
##  ]]></Example>
##  <P/>
##  The representations with number between <M>4</M> and <M>13</M> are
##  (in fact irreducible) matrix representations over various finite fields,
##  those with numbers <M>14</M> to <M>16</M> are integral matrix
##  representations,
##  and the last two are matrix representations over the field generated by
##  <M>\sqrt{{5}}</M> over the rational number field.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( "A5", Identifier, "a" );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##   4: G <= GL(4a,2)                character 4a
##   8: G <= GL(2a,4)                character 2a
##  12: G <= GL(3a,9)                character 3a
##  17: G <= GL(3a,Field([Sqrt(5)])) character 3a
##  ]]></Example>
##  <P/>
##  Each of the representations with the numbers <M>4, 8, 12</M>,
##  and <M>17</M> is labeled with the distinguishing letter <C>a</C>.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( "A5", NrMovedPoints, IsPrimeInt );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##  1: G <= Sym(5) 3-trans., on cosets of A4 (1st max.)
##  gap> DisplayAtlasInfo( "A5", Characteristic, IsOddInt );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##   6: G <= GL(4,3)  character 4a
##   7: G <= GL(6,3)  character 3ab
##  10: G <= GL(3,5)  character 3a
##  11: G <= GL(5,5)  character 5a
##  12: G <= GL(3a,9) character 3a
##  13: G <= GL(3b,9) character 3b
##  gap> DisplayAtlasInfo( "A5", Dimension, IsPrimeInt );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##   8: G <= GL(2a,4)                character 2a
##   9: G <= GL(2b,4)                character 2b
##  10: G <= GL(3,5)                 character 3a
##  11: G <= GL(5,5)                 character 5a
##  12: G <= GL(3a,9)                character 3a
##  13: G <= GL(3b,9)                character 3b
##  15: G <= GL(5,Z)                 character 5a
##  17: G <= GL(3a,Field([Sqrt(5)])) character 3a
##  18: G <= GL(3b,Field([Sqrt(5)])) character 3b
##  gap> DisplayAtlasInfo( "A5", Ring, IsFinite and IsPrimeField );
##  Representations for G = A5:    (all refer to std. generators 1)
##  ---------------------------
##   4: G <= GL(4a,2) character 4a
##   5: G <= GL(4b,2) character 2ab
##   6: G <= GL(4,3)  character 4a
##   7: G <= GL(6,3)  character 3ab
##  10: G <= GL(3,5)  character 3a
##  11: G <= GL(5,5)  character 5a
##  ]]></Example>
##  <P/>
##  The above examples show how the output can be restricted using a property
##  (a unary function that returns either <K>true</K> or <K>false</K>)
##  that follows <Ref Func="NrMovedPoints" BookName="ref"/>,
##  <Ref Func="Characteristic" BookName="ref"/>,
##  <Ref Func="Dimension" BookName="ref"/>,
##  or <Ref Func="Ring" BookName="ref"/>
##  in the argument list of <Ref Func="DisplayAtlasInfo"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> DisplayAtlasInfo( "A5", IsStraightLineProgram, true );
##  Programs for G = A5:    (all refer to std. generators 1)
##  --------------------
##  - class repres.*      
##  - presentation        
##  - maxes (all 3):
##    1:  A4              
##    2:  D10             
##    3:  S3              
##  - std. gen. checker:
##    (check)             
##    (pres)              
##  ]]></Example>
##  <P/>
##  Straight line programs are available for computing generators of
##  representatives of the three classes of maximal subgroups of <M>A_5</M>,
##  and a straight line decision for checking whether given generators are
##  in fact standard generators is available as well as a presentation
##  in terms of standard generators,
##  see&nbsp;<Ref Func="AtlasProgram"/>.
##  A straight line program for computing conjugacy class representatives
##  is available, and the star <C>*</C> says that this program does not
##  belong to the core part of the database
##  (see Section <Ref Subsect="subsect:AtlasRepMarkNonCoreData"/>).
##  </Subsection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "DisplayAtlasInfo" );


#############################################################################
##
#F  AtlasGenerators( <gapname>, <repnr>[, <maxnr>] )
#F  AtlasGenerators( <identifier> )
##
##  <#GAPDoc Label="AtlasGenerators">
##  <ManSection>
##  <Func Name="AtlasGenerators" Arg='gapname, repnr[, maxnr]'/>
##  <Func Name="AtlasGenerators" Arg='identifier' Label="for an identifier"/>
##
##  <Returns>
##  a record containing generators for a representation, or <K>fail</K>.
##  </Returns>
##  <Description>
##  In the first form, <A>gapname</A> must be a string denoting a &GAP; name
##  (see
##  Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>)
##  of a group, and <A>repnr</A> a positive integer.
##  If at least <A>repnr</A> representations for the group with &GAP; name
##  <A>gapname</A> are available then <Ref Func="AtlasGenerators"/>,
##  when called with <A>gapname</A> and <A>repnr</A>,
##  returns an immutable record describing the <A>repnr</A>-th
##  representation;
##  otherwise <K>fail</K> is returned.
##  If a third argument <A>maxnr</A>, a positive integer,
##  is given then an immutable record describing the restriction of the
##  <A>repnr</A>-th representation to the <A>maxnr</A>-th maximal subgroup is
##  returned.
##  <P/>
##  The result record has at least the following components.
##  <P/>
##  <List>
##  <Mark><C>contents</C></Mark>
##  <Item>
##    the identifier of the part of the database to which the generators
##    belong, for example <C>"core"</C> or <C>"internal"</C>,
##  </Item>
##  <Mark><C>generators</C></Mark>
##  <Item>
##    a list of generators for the group,
##  </Item>
##  <Mark><C>groupname</C></Mark>
##  <Item>
##    the &GAP; name of the group (see
##    Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>),
##  </Item>
##  <Mark><C>identifier</C></Mark>
##  <Item>
##    a &GAP; object (a list of filenames plus additional information)
##    that uniquely determines the representation,
##    see Section <Ref Sect="sect:identifier component"/>;
##    the value can be used as <C>identifier</C> argument of
##    <Ref Func="AtlasGenerators"/>.
##  </Item>
##  <Mark><C>repname</C></Mark>
##  <Item>
##    a string that is an initial part of the filenames of the generators.
##  </Item>
##  <Mark><C>repnr</C></Mark>
##  <Item>
##    the number of the representation in the current session,
##    equal to the argument <A>repnr</A> if this is given.
##  </Item>
##  <Mark><C>standardization</C></Mark>
##  <Item>
##    the positive integer denoting the underlying standard generators,
##  </Item>
##  <Mark><C>type</C></Mark>
##  <Item>
##    a string that describes the type of the representation
##    (<C>"perm"</C> for a permutation representation,
##    <C>"matff"</C> for a matrix representation over a finite field,
##    <C>"matint"</C> for a matrix representation over the ring of integers,
##    <C>"matalg"</C> for a matrix representation over an algebraic number
##    field).
##  </Item>
##  </List>
##  <P/>
##  Additionally, the following <E>describing components</E> may be available
##  if they are known, and depending on the data type of the representation.
##  <P/>
##  <List>
##  <Mark><C>size</C></Mark>
##  <Item>
##    the group order,
##  </Item>
##  <Mark><C>id</C></Mark>
##  <Item>
##    the distinguishing string as described for
##    <Ref Func="DisplayAtlasInfo"/>,
##  </Item>
##  <Mark><C>charactername</C></Mark>
##  <Item>
##    a string that describes the character of the representation,
##  </Item>
##  <Mark><C>constituents</C></Mark>
##  <Item>
##    a list of positive integers denoting the positions of the irreducible
##    constituents of the character of the representation,
##  </Item>
##  <Mark><C>p</C> (for permutation representations)</Mark>
##  <Item>
##    for the number of moved points,
##  </Item>
##  <Mark><C>dim</C> (for matrix representations)</Mark>
##  <Item>
##    the dimension of the matrices,
##  </Item>
##  <Mark><C>ring</C> (for matrix representations)</Mark>
##  <Item>
##    the ring generated by the matrix entries,
##  </Item>
##  <Mark><C>transitivity</C> (for permutation representations)</Mark>
##  <Item>
##    a nonnegative integer, see <Ref Oper="Transitivity" BookName="ref"/>,
##  </Item>
##  <Mark><C>orbits</C> (for intransitive permutation representations)</Mark>
##  <Item>
##    the sorted list of orbit lengths on the set of moved points,
##  </Item>
##  <Mark><C>rankAction</C> (for transitive permutation representations)</Mark>
##  <Item>
##    the number of orbits of the point stabilizer on the set of moved points,
##    see <Ref Oper="RankAction" BookName="ref"/>,
##  </Item>
##  <Mark><C>stabilizer</C> (for transitive permutation representations)</Mark>
##  <Item>
##    a string that describes the structure of the point stabilizers,
##  </Item>
##  <Mark><C>isPrimitive</C> (for transitive permutation representations)</Mark>
##  <Item>
##    <K>true</K> if the point stabilizers are maximal subgroups,
##    and <K>false</K> otherwise,
##  </Item>
##  <Mark><C>maxnr</C> (for primitive permutation representations)</Mark>
##  <Item>
##    the number of the class of maximal subgroups that contains the point
##    stabilizers, w.&nbsp;r.&nbsp;t.&nbsp;the
##    <Ref Attr="Maxes" BookName="ctbllib"/> list.
##  </Item>
##  </List>
##  <P/>
##  It should be noted that the number <A>repnr</A> refers to the number
##  shown by <Ref Func="DisplayAtlasInfo"/> <E>in the current session</E>;
##  it may be that after the addition of new representations
##  (for example after loading a package that provides some),
##  <A>repnr</A> refers to another representation.
##  <P/>
##  The alternative form of <Ref Func="AtlasGenerators"/>,
##  with only argument <A>identifier</A>,
##  can be used to fetch the result record with <C>identifier</C> value equal
##  to <A>identifier</A>.
##  The purpose of this variant is to access the <E>same</E> representation
##  also in <E>different</E> &GAP; sessions.
##  <P/>
##  <Example><![CDATA[
##  gap> gens1:= AtlasGenerators( "A5", 1 );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
##    groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> gens8:= AtlasGenerators( "A5", 8 );
##  rec( charactername := "2a", constituents := [ 2 ], contents := "core",
##    dim := 2, 
##    generators := [ [ [ Z(2)^0, 0*Z(2) ], [ Z(2^2), Z(2)^0 ] ], 
##        [ [ 0*Z(2), Z(2)^0 ], [ Z(2)^0, Z(2)^0 ] ] ], groupname := "A5",
##    id := "a", 
##    identifier := [ "A5", [ "A5G1-f4r2aB0.m1", "A5G1-f4r2aB0.m2" ], 1, 
##        4 ], repname := "A5G1-f4r2aB0", repnr := 8, ring := GF(2^2), 
##    size := 60, standardization := 1, type := "matff" )
##  gap> gens17:= AtlasGenerators( "A5", 17 );
##  rec( charactername := "3a", constituents := [ 2 ], contents := "core",
##    dim := 3, 
##    generators := 
##      [ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ -E(5)-E(5)^4, -E(5)-E(5)^4, 1 ] 
##           ], [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ] ], 
##    groupname := "A5", id := "a", 
##    identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
##    polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
##    ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
##    type := "matalg" )
##  ]]></Example>
##  <P/>
##  Each of the above pairs of elements generates a group isomorphic to
##  <M>A_5</M>.
##  <P/>
##  <Example><![CDATA[
##  gap> gens1max2:= AtlasGenerators( "A5", 1, 2 );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", generators := [ (1,2)(3,4), (2,3)(4,5) ], 
##    groupname := "D10", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5, 2 ],
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 10, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> id:= gens1max2.identifier;;
##  gap> gens1max2 = AtlasGenerators( id );
##  true
##  gap> max2:= Group( gens1max2.generators );;
##  gap> Size( max2 );
##  10
##  gap> IdGroup( max2 ) = IdGroup( DihedralGroup( 10 ) );
##  true
##  ]]></Example>
##  <P/>
##  The elements stored in <C>gens1max2.generators</C> describe the
##  restriction of the first representation of <M>A_5</M> to a group in the
##  second class of maximal subgroups of <M>A_5</M> according to the list in
##  the &ATLAS; of Finite Groups&nbsp;<Cite Key="CCN85"/>;
##  this subgroup is isomorphic to the dihedral group <M>D_{10}</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasGenerators" );


#############################################################################
##
#F  AtlasProgramInfo( <gapname>[, <std>][, "maxes"], <maxnr> )
#F  AtlasProgramInfo( <gapname>[, <std>], "maxes", <maxnr>[, <std2>] )
#F  AtlasProgramInfo( <gapname>[, <std>], "maxstd", <maxnr>, <vers>, <substd> )
#F  AtlasProgramInfo( <gapname>[, <std>], "kernel", <factname> )
#F  AtlasProgramInfo( <gapname>[, <std>], "classes" )
#F  AtlasProgramInfo( <gapname>[, <std>], "cyclic" )
#F  AtlasProgramInfo( <gapname>[, <std>], "cyc2ccl"[, <vers>] )
#F  AtlasProgramInfo( <gapname>[, <std>], "automorphism", <autname> )
#F  AtlasProgramInfo( <gapname>[, <std>], "check" )
#F  AtlasProgramInfo( <gapname>[, <std>], "presentation" )
#F  AtlasProgramInfo( <gapname>[, <std>], "find" )
#F  AtlasProgramInfo( <gapname>, <std>, "restandardize", <std2> )
#F  AtlasProgramInfo( <gapname>[, <std>], "other", <descr> )
##
##  (same arguments as 'AtlasProgram')
##
##  <#GAPDoc Label="AtlasProgramInfo">
##  <ManSection>
##  <Func Name="AtlasProgramInfo"
##  Arg='gapname[, std][, "contents", sources][, "version", vers ], ...'/>
##
##  <Returns>
##  a record describing a program, or <K>fail</K>.
##  </Returns>
##  <Description>
##  <Ref Func="AtlasProgramInfo"/> takes the same arguments as
##  <Ref Func="AtlasProgram"/>, and returns a similar result.
##  The only difference is that the records returned by
##  <Ref Func="AtlasProgramInfo"/> have no components <C>program</C> and
##  <C>outputs</C>.
##  The idea is that one can use <Ref Func="AtlasProgramInfo"/> for
##  testing whether the program in question is available at all,
##  but without downloading files.
##  The <C>identifier</C> component of the result of
##  <Ref Func="AtlasProgramInfo"/> can then be used to fetch the program
##  with <Ref Func="AtlasProgram"/>.
##
##  <Example><![CDATA[
##  gap> AtlasProgramInfo( "J1", "cyclic" );
##  rec( groupname := "J1", identifier := [ "J1", "J1G1-cycW1", 1 ], 
##    standardization := 1, version := "1" )
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasProgramInfo" );


#############################################################################
##
#F  AtlasProgram( <gapname>[, <std>][, "maxes"], <maxnr> )
#F  AtlasProgram( <gapname>[, <std>], "maxes", <maxnr>[, <std2>] )
#F  AtlasProgram( <gapname>[, <std>], "maxstd", <maxnr>, <vers>, <substd> )
#F  AtlasProgram( <gapname>[, <std>], "kernel", <factname> )
#F  AtlasProgram( <gapname>[, <std>], "classes" )
#F  AtlasProgram( <gapname>[, <std>], "cyclic" )
#F  AtlasProgram( <gapname>[, <std>], "cyc2ccl"[, <vers>] )
#F  AtlasProgram( <gapname>[, <std>], "automorphism", <autname> )
#F  AtlasProgram( <gapname>[, <std>], "check" )
#F  AtlasProgram( <gapname>[, <std>], "presentation" )
#F  AtlasProgram( <gapname>[, <std>], "find" )
#F  AtlasProgram( <gapname>, <std>, "restandardize", <std2> )
#F  AtlasProgram( <gapname>[, <std>], "other", <descr> )
#F  AtlasProgram( <identifier> )
##
##  (Also the argument pairs '[ "contents", <sources> ]' and
##  '[ "version", <v> ]' are supported.)
##
##  <#GAPDoc Label="AtlasProgram">
##  <ManSection>
##  <Func Name="AtlasProgram"
##  Arg='gapname[, std][, "contents", sources][, "version", vers ], ...'/>
##  <Func Name="AtlasProgram" Arg='identifier' Label="for an identifier"/>
##
##  <Returns>
##  a record containing a program, or <K>fail</K>.
##  </Returns>
##  <Description>
##  In the first form, <A>gapname</A> must be a string denoting a &GAP; name
##  (see
##  Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>)
##  of a group <M>G</M>, say.
##  If the database contains a straight line program
##  (see Section&nbsp;<Ref Sect="Straight Line Programs" BookName="ref"/>)
##  or straight line decision
##  (see Section&nbsp;<Ref Sect="sect:Straight Line Decisions"/>)
##  or black box program
##  (see Section&nbsp;<Ref Sect="sect:Black Box Programs"/>)
##  as described by the arguments indicated by <A>...</A> (see below) then
##  <Ref Func="AtlasProgram"/> returns an immutable record
##  containing this program.
##  Otherwise <K>fail</K> is returned.
##  <P/>
##  If the optional argument <A>std</A> is given, only those straight line
##  programs/decisions are considered
##  that take generators from the <A>std</A>-th set
##  of standard generators of <M>G</M> as input,
##  see Section&nbsp;<Ref Sect="sect:Standard Generators Used in AtlasRep"/>.
##  <P/>
##  If the optional arguments <C>"contents"</C> and <A>sources</A> are
##  given then the latter must be either a string or a list of strings,
##  with the same meaning as described for <Ref Func="DisplayAtlasInfo"/>.
##  <P/>
##  If the optional arguments <C>"version"</C> and <A>vers</A> are
##  given then the latter must be either a number or a list of numbers,
##  and only those straight line programs/decisions are considered
##  whose version number fits to <A>vers</A>.
##  <P/>
##  The result record has at least the following components.
##  <P/>
##  <List>
##  <Mark><C>groupname</C></Mark>
##  <Item>
##      the string <A>gapname</A>,
##  </Item>
##  <Mark><C>identifier</C></Mark>
##  <Item>
##      a &GAP; object (a list of filenames plus additional information)
##      that uniquely determines the program;
##      the value can be used as <A>identifier</A> argument of
##      <Ref Func="AtlasProgram"/> (see below),
##  </Item>
##  <Mark><C>program</C></Mark>
##  <Item>
##      the required straight line program/decision, or black box program,
##  </Item>
##  <Mark><C>standardization</C></Mark>
##  <Item>
##      the positive integer denoting the underlying standard generators of
##      <M>G</M>,
##  </Item>
##  <Mark><C>version</C></Mark>
##  <Item>
##      the substring of the filename of the program that denotes the
##      version of the program.
##  </Item>
##  </List>
##  <P/>
##  If the program computes generators of the restriction to a maximal
##  subgroup then also the following components are present.
##  <P/>
##  <List>
##  <Mark><C>size</C></Mark>
##  <Item>
##      the order of the maximal subgroup,
##  </Item>
##  <Mark><C>subgroupname</C></Mark>
##  <Item>
##      a string denoting a name of the maximal subgroup.
##  </Item>
##  </List>
##  <P/>
##  In the first form,
##  the arguments indicated by <A>...</A> must be as follows.
##  <P/>
##  <List>
##  <Mark>(the string <C>"maxes"</C> and) a positive integer <M>maxnr</M>
##  </Mark>
##  <Item>
##    the required program computes generators of the <M>maxnr</M>-th
##    maximal subgroup of the group with &GAP; name <M>gapname</M>.
##    <Index Subkey="for maximal subgroups">straight line program</Index>
##    <Index>maximal subgroups</Index>
##    <P/>
##    In this case, the result record of <Ref Func="AtlasProgram"/> also
##    may contain a component <C>size</C>,
##    whose value is the order of the maximal subgroup in question.
##  </Item>
##  <Mark>the string <C>"maxes"</C>
##        and two positive integers <M>maxnr</M> and <M>std2</M></Mark>
##  <Item>
##    the required program computes standard generators of the
##    <M>maxnr</M>-th maximal subgroup of the group with &GAP; name
##    <M>gapname</M>, w.&nbsp;r.&nbsp;t.&nbsp;the standardization <M>std2</M>.
##    <P/>
##    A prescribed <C>"version"</C> parameter refers to the straight line
##    program for computing the restriction, not to the program for
##    standardizing the result of the restriction.
##    <P/>
##    The meaning of the component <C>size</C> in the result, if present,
##    is the same as in the previous case.
##  </Item>
##  <Mark>the string <C>"maxstd"</C> and three positive integers
##  <M>maxnr</M>, <M>vers</M>, <M>substd</M></Mark>
##  <Item>
##    the required program computes standard generators of the
##    <M>maxnr</M>-th maximal subgroup of the group with &GAP; name
##    <M>gapname</M> w.&nbsp;r.&nbsp;t.&nbsp;standardization <M>substd</M>;
##    in this case, the inputs of the program are <E>not</E> standard
##    generators of the group with &GAP; name <M>gapname</M>
##    but the outputs of the straight line program with version <M>vers</M>
##    for computing generators of its <M>maxnr</M>-th maximal subgroup.
##  </Item>
##  <Mark>the string <C>"kernel"</C> and a string <M>factname</M></Mark>
##  <Item>
##    the required program computes generators of the kernel of an
##    epimorphism from <M>G</M> to a group with &GAP; name <M>factname</M>.
##    <Index Subkey="for normal subgroups">straight line program</Index>
##    <Index Subkey="for kernels of epimorphisms">straight line program</Index>
##  </Item>
##  <Mark>one of the strings <C>"classes"</C> or <C>"cyclic"</C></Mark>
##  <Item>
##    the required program computes representatives of conjugacy classes
##    of elements or representatives of generators of maximally cyclic
##    subgroups of <M>G</M>, respectively.
##    <Index Subkey="for class representatives">straight line program</Index>
##    <Index>class representatives</Index>
##    <Index Subkey="for representatives of cyclic subgroups">
##    straight line program</Index>
##    <Index>cyclic subgroups</Index>
##    <Index>maximally cyclic subgroups</Index>
##    <P/>
##    See&nbsp;<Cite Key="BSW01"/> and&nbsp;<Cite Key="SWW00"/>
##    for the background concerning these straight line programs.
##    In these cases, the result record of <Ref Func="AtlasProgram"/>
##    also contains a component <C>outputs</C>,
##    whose value is a list of class names of the outputs,
##    as described in
##    Section&nbsp;<Ref Sect="sect:Class Names Used in the AtlasRep Package"/>.
##  </Item>
##  <Mark>the string <C>"cyc2ccl"</C> (and the string <M>vers</M>)</Mark>
##  <Item>
##    the required program computes representatives of conjugacy classes
##    of elements from representatives of generators of maximally cyclic
##    subgroups of <M>G</M>.
##    Thus the inputs are the outputs of the program of type <C>"cyclic"</C>
##    whose version is <M>vers</M>.
##  </Item>
##  <Mark>the strings <C>"cyc2ccl"</C>, <M>vers1</M>, <C>"version"</C>, <M>vers2</M></Mark>
##  <Item>
##    the required program computes representatives of conjugacy classes
##    of elements from representatives of generators of maximally cyclic
##    subgroups of <M>G</M>,
##    where the inputs are the outputs of the program of type <C>"cyclic"</C>
##    whose version is <M>vers1</M> and the required program itself has
##    version <M>vers2</M>.
##  </Item>
##  <Mark>the strings <C>"automorphism"</C> and <M>autname</M></Mark>
##  <Item>
##    <Index Subkey="for outer automorphisms">straight line program</Index>
##    <Index>automorphisms</Index>
##    the required program computes images of standard generators under
##    the outer automorphism of <M>G</M> that is given by this string.
##    <P/>
##    Note that a value <C>"2"</C> of <M>autname</M> means that the square of
##    the automorphism is an inner automorphism of <M>G</M> (not necessarily
##    the identity mapping) but the automorphism itself is not.
##  </Item>
##  <Mark>the string <C>"check"</C></Mark>
##  <Item>
##    <Index Subkey="for checking standard generators">straight line decision
##    </Index>
##    the required result is a straight line decision that
##    takes a list of generators for <M>G</M>
##    and returns <K>true</K> if these generators are standard generators of
##    <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the standardization <A>std</A>,
##    and <K>false</K> otherwise.
##  </Item>
##  <Mark>the string <C>"presentation"</C></Mark>
##  <Item>
##    <Index Subkey="encoding a presentation">straight line decision
##    </Index>
##    the required result is a straight line decision that
##    takes a list of group elements
##    and returns <K>true</K> if these elements are standard generators of
##    <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the standardization <A>std</A>,
##    and <K>false</K> otherwise.
##    <P/>
##    See <Ref Func="StraightLineProgramFromStraightLineDecision"/> for an
##    example how to derive defining relators for <M>G</M> in terms of the
##    standard generators from such a straight line decision.
##  </Item>
##  <Mark>the string <C>"find"</C></Mark>
##  <Item>
##    <Index Subkey="for finding standard generators">black box program
##    </Index>
##    the required result is a black box program that takes <M>G</M>
##    and returns a list of standard generators of <M>G</M>,
##    w.&nbsp;r.&nbsp;t.&nbsp;the standardization <A>std</A>.
##  </Item>
##  <Mark>the string <C>"restandardize"</C> and an integer <M>std2</M></Mark>
##  <Item>
##    <Index Subkey="for restandardizing">straight line program</Index>
##    the required result is a straight line program that computes
##    standard generators of <M>G</M> w.&nbsp;r.&nbsp;t.&nbsp;the
##    <M>std2</M>-th set of standard generators of <M>G</M>;
##    in this case, the argument <A>std</A> must be given.
##  </Item>
##  <Mark>the strings <C>"other"</C> and <M>descr</M></Mark>
##  <Item>
##    <Index Subkey="free format">straight line program</Index>
##    the required program is described by <M>descr</M>.
##  </Item>
##  </List>
##  <P/>
##  The second form of <Ref Func="AtlasProgram"/>,
##  with only argument the list <A>identifier</A>,
##  can be used to fetch the result record with <C>identifier</C> value equal
##  to <A>identifier</A>.
##  <Example><![CDATA[
##  gap> prog:= AtlasProgram( "A5", 2 );
##  rec( groupname := "A5", identifier := [ "A5", "A5G1-max2W1", 1 ], 
##    program := <straight line program>, size := 10, 
##    standardization := 1, subgroupname := "D10", version := "1" )
##  gap> StringOfResultOfStraightLineProgram( prog.program, [ "a", "b" ] );
##  "[ a, bbab ]"
##  gap> gens1:= AtlasGenerators( "A5", 1 );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
##    groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> maxgens:= ResultOfStraightLineProgram( prog.program,
##  >                  gens1.generators );
##  [ (1,2)(3,4), (2,3)(4,5) ]
##  gap> maxgens = gens1max2.generators;
##  true
##  ]]></Example>
##  <P/>
##  The above example shows that for restricting representations given by
##  standard generators to a maximal subgroup of <M>A_5</M>,
##  we can also fetch and apply the appropriate straight line program.
##  Such a program
##  (see&nbsp;<Ref Sect="Straight Line Programs" BookName="ref"/>)
##  takes standard generators of a group
##  &ndash;in this example <M>A_5</M>&ndash;
##  as its input, and returns a list of elements in this group
##  &ndash;in this example generators of the <M>D_{10}</M> subgroup we had
##  met above&ndash;
##  which are computed essentially by evaluating structured words in terms of
##  the standard generators.
##  <P/>
##  <Example><![CDATA[
##  gap> prog:= AtlasProgram( "J1", "cyclic" );
##  rec( groupname := "J1", identifier := [ "J1", "J1G1-cycW1", 1 ], 
##    outputs := [ "6A", "7A", "10B", "11A", "15B", "19A" ], 
##    program := <straight line program>, standardization := 1, 
##    version := "1" )
##  gap> gens:= GeneratorsOfGroup( FreeGroup( "x", "y" ) );;
##  gap> ResultOfStraightLineProgram( prog.program, gens );
##  [ (x*y)^2*((y*x)^2*y^2*x)^2*y^2, x*y, (x*(y*x*y)^2)^2*y, 
##    (x*y*x*(y*x*y)^3*x*y^2)^2*x*y*x*(y*x*y)^2*y, x*y*x*(y*x*y)^2*y, 
##    (x*y)^2*y ]
##  ]]></Example>
##  <P/>
##  The above example shows how to fetch and use straight line programs for
##  computing generators of representatives of maximally cyclic subgroups
##  of a given group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasProgram" );


#############################################################################
##
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], IsPermGroup[, true] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], NrMovedPoints, <n> )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>], IsMatrixGroup[, true] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>][, Characteristic, <p>]
#F                                                 [, Dimension, <m>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>][, <std>][, Ring, <R>]
#F                                                 [, Dimension, <m>] )
#F  OneAtlasGeneratingSetInfo( [<gapname>,][ <std>,] Position, <n> )
##
##  <#GAPDoc Label="OneAtlasGeneratingSetInfo">
##  <ManSection>
##  <Func Name="OneAtlasGeneratingSetInfo" Arg='[gapname][, std][, ...]'/>
##
##  <Returns>
##  a record describing a representation that satisfies the conditions,
##  or <K>fail</K>.
##  </Returns>
##  <Description>
##  Let <A>gapname</A> be a string denoting a &GAP; name (see
##  Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>)
##  of a group <M>G</M>, say.
##  If the database contains at least one representation for <M>G</M> with
##  the required properties
##  then <Ref Func="OneAtlasGeneratingSetInfo"/> returns a record <M>r</M>
##  whose components are the same as those of the records returned by
##  <Ref Func="AtlasGenerators"/>,
##  except that the component <C>generators</C> is not contained,
##  and an additional component <C>givenRing</C> is present if <C>Ring</C>
##  is one of the arguments in the function call.
##  <P/>
##  The information in <C>givenRing</C> can be used later to construct
##  the matrices over the prescribed ring.
##  Note that this ring may be for example a domain constructed with
##  <Ref Func="AlgebraicExtension" BookName="ref"/> instead of a field of
##  cyclotomics or of a finite field constructed with
##  <Ref Func="GF" BookName="ref"/>.
##  <P/>
##  The component <C>identifier</C> of <M>r</M> can be used as input for
##  <Ref Func="AtlasGenerators"/> in order to fetch the generators.
##  If no representation satisfying the given conditions is available
##  then <K>fail</K> is returned.
##  <P/>
##  If the argument <A>std</A> is given then it must be a positive integer
##  or a list of positive integers, denoting the sets of standard generators
##  w.&nbsp;r.&nbsp;t.&nbsp;which the representation shall be given (see
##  Section&nbsp;<Ref Sect="sect:Standard Generators Used in AtlasRep"/>).
##  <P/>
##  The argument <A>gapname</A> can be missing (then all available groups are
##  considered), or a list of group names can be given instead.
##  <P/>
##  Further restrictions can be entered as arguments, with the same meaning
##  as described for <Ref Func="DisplayAtlasInfo"/>.
##  The result of <Ref Func="OneAtlasGeneratingSetInfo"/> describes the first
##  generating set for <M>G</M> that matches the restrictions,
##  in the ordering shown by <Ref Func="DisplayAtlasInfo"/>.
##  <P/>
##  Note that even in the case that the user preference
##  <C>AtlasRepAccessRemoteFiles</C> has the value <K>true</K>
##  (see Section&nbsp;<Ref Subsect="subsect:AtlasRepAccessRemoteFiles"/>),
##  <Ref Func="OneAtlasGeneratingSetInfo"/> does <E>not</E> attempt
##  to <E>transfer</E> remote data files,
##  just the table of contents is evaluated.
##  So this function (as well as <Ref Func="AllAtlasGeneratingSetInfos"/>)
##  can be used to check for the availability of certain representations,
##  and afterwards one can call <Ref Func="AtlasGenerators"/> for those
##  representations one wants to work with.
##  <P/>
##  In the following example, we try to access information about
##  permutation representations for the alternating group <M>A_5</M>.
##  <P/>
##  <Example><![CDATA[
##  gap> info:= OneAtlasGeneratingSetInfo( "A5" );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> gens:= AtlasGenerators( info.identifier );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", generators := [ (1,2)(3,4), (1,3,5) ], 
##    groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> info = OneAtlasGeneratingSetInfo( "A5", IsPermGroup, true );
##  true
##  gap> info = OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, "minimal" );
##  true
##  gap> info = OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, [ 1 .. 10 ] );
##  true
##  gap> OneAtlasGeneratingSetInfo( "A5", NrMovedPoints, 20 );
##  fail
##  ]]></Example>
##  <P/>
##  Note that a permutation representation of degree <M>20</M> could be
##  obtained by taking twice the primitive representation on <M>10</M> points;
##  however, the database does not store this imprimitive representation (cf.
##  Section&nbsp;<Ref Sect="sect:Accessing vs. Constructing Representations"/>).
##  <P/>
##  We continue this example.
##  Next we access matrix representations of <M>A_5</M>.
##  <P/>
##  <Example><![CDATA[
##  gap> info:= OneAtlasGeneratingSetInfo( "A5", IsMatrixGroup, true );
##  rec( charactername := "4a", constituents := [ 4 ], contents := "core",
##    dim := 4, groupname := "A5", id := "a", 
##    identifier := [ "A5", [ "A5G1-f2r4aB0.m1", "A5G1-f2r4aB0.m2" ], 1, 
##        2 ], repname := "A5G1-f2r4aB0", repnr := 4, ring := GF(2), 
##    size := 60, standardization := 1, type := "matff" )
##  gap> gens:= AtlasGenerators( info.identifier );
##  rec( charactername := "4a", constituents := [ 4 ], contents := "core",
##    dim := 4, 
##    generators := [ <an immutable 4x4 matrix over GF2>, 
##        <an immutable 4x4 matrix over GF2> ], groupname := "A5", 
##    id := "a", 
##    identifier := [ "A5", [ "A5G1-f2r4aB0.m1", "A5G1-f2r4aB0.m2" ], 1, 
##        2 ], repname := "A5G1-f2r4aB0", repnr := 4, ring := GF(2), 
##    size := 60, standardization := 1, type := "matff" )
##  gap> info = OneAtlasGeneratingSetInfo( "A5", Dimension, 4 );
##  true
##  gap> info = OneAtlasGeneratingSetInfo( "A5", Characteristic, 2 );
##  true
##  gap> info2:= OneAtlasGeneratingSetInfo( "A5", Ring, GF(2) );;
##  gap> info.identifier = info2.identifier; 
##  true
##  gap> OneAtlasGeneratingSetInfo( "A5", Characteristic, [2,5], Dimension, 2 );
##  rec( charactername := "2a", constituents := [ 2 ], contents := "core",
##    dim := 2, groupname := "A5", id := "a", 
##    identifier := [ "A5", [ "A5G1-f4r2aB0.m1", "A5G1-f4r2aB0.m2" ], 1, 
##        4 ], repname := "A5G1-f4r2aB0", repnr := 8, ring := GF(2^2), 
##    size := 60, standardization := 1, type := "matff" )
##  gap> OneAtlasGeneratingSetInfo( "A5", Characteristic, [2,5], Dimension, 1 );
##  fail
##  gap> info:= OneAtlasGeneratingSetInfo( "A5", Characteristic, 0,
##  >                                            Dimension, 4 );
##  rec( charactername := "4a", constituents := [ 4 ], contents := "core",
##    dim := 4, groupname := "A5", id := "", 
##    identifier := [ "A5", "A5G1-Zr4B0.g", 1, 4 ], 
##    repname := "A5G1-Zr4B0", repnr := 14, ring := Integers, size := 60, 
##    standardization := 1, type := "matint" )
##  gap> gens:= AtlasGenerators( info.identifier );
##  rec( charactername := "4a", constituents := [ 4 ], contents := "core",
##    dim := 4, 
##    generators := 
##      [ 
##        [ [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 0 ], 
##            [ -1, -1, -1, -1 ] ], 
##        [ [ 0, 1, 0, 0 ], [ 0, 0, 0, 1 ], [ 0, 0, 1, 0 ], 
##            [ 1, 0, 0, 0 ] ] ], groupname := "A5", id := "", 
##    identifier := [ "A5", "A5G1-Zr4B0.g", 1, 4 ], 
##    repname := "A5G1-Zr4B0", repnr := 14, ring := Integers, size := 60, 
##    standardization := 1, type := "matint" )
##  gap> info = OneAtlasGeneratingSetInfo( "A5", Ring, Integers );
##  true
##  gap> info2:= OneAtlasGeneratingSetInfo( "A5", Ring, CF(37) );;
##  gap> info = info2;
##  false
##  gap> Difference( RecNames( info2 ), RecNames( info ) );
##  [ "givenRing" ]
##  gap> info2.givenRing;
##  CF(37)
##  gap> OneAtlasGeneratingSetInfo( "A5", Ring, Integers mod 77 );
##  fail
##  gap> info:= OneAtlasGeneratingSetInfo( "A5", Ring, CF(5), Dimension, 3 );
##  rec( charactername := "3a", constituents := [ 2 ], contents := "core",
##    dim := 3, givenRing := CF(5), groupname := "A5", id := "a", 
##    identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
##    polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
##    ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
##    type := "matalg" )
##  gap> gens:= AtlasGenerators( info );
##  rec( charactername := "3a", constituents := [ 2 ], contents := "core",
##    dim := 3, 
##    generators := 
##      [ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ -E(5)-E(5)^4, -E(5)-E(5)^4, 1 ] 
##           ], [ [ 0, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 0 ] ] ], 
##    givenRing := CF(5), groupname := "A5", id := "a", 
##    identifier := [ "A5", "A5G1-Ar3aB0.g", 1, 3 ], 
##    polynomial := [ -1, 1, 1 ], repname := "A5G1-Ar3aB0", repnr := 17, 
##    ring := NF(5,[ 1, 4 ]), size := 60, standardization := 1, 
##    type := "matalg" )
##  gap> gens2:= AtlasGenerators( info.identifier );;
##  gap> Difference( RecNames( gens ), RecNames( gens2 ) );
##  [ "givenRing" ]
##  gap> OneAtlasGeneratingSetInfo( "A5", Ring, GF(17) );
##  fail
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "OneAtlasGeneratingSetInfo" );


#############################################################################
##
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], IsPermGroup[, true] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], NrMovedPoints, <n> )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>], IsMatrixGroup[, true] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>][, Characteristic, <p>]
#F                                                  [, Dimension, <m>] )
#F  AllAtlasGeneratingSetInfos( [<gapname>][, <std>][, Ring, <R>]
#F                                                  [, Dimension, <m>] )
##
##  <#GAPDoc Label="AllAtlasGeneratingSetInfos">
##  <ManSection>
##  <Func Name="AllAtlasGeneratingSetInfos" Arg='[gapname][, std][, ...]'/>
##
##  <Returns>
##  the list of all records describing representations that satisfy
##  the conditions.
##  </Returns>
##  <Description>
##  <Ref Func="AllAtlasGeneratingSetInfos"/> is similar to
##  <Ref Func="OneAtlasGeneratingSetInfo"/>.
##  The difference is that the list of <E>all</E> records describing
##  the available representations with the given properties is returned
##  instead of just one such component.
##  In particular an empty list is returned if no such representation is
##  available.
##  <P/>
##  <Example><![CDATA[
##  gap> AllAtlasGeneratingSetInfos( "A5", IsPermGroup, true );
##  [ rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##        contents := "core", groupname := "A5", id := "", 
##        identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ]
##          , isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##        repname := "A5G1-p5B0", repnr := 1, size := 60, 
##        stabilizer := "A4", standardization := 1, transitivity := 3, 
##        type := "perm" ), 
##    rec( charactername := "1a+5a", constituents := [ 1, 5 ], 
##        contents := "core", groupname := "A5", id := "", 
##        identifier := [ "A5", [ "A5G1-p6B0.m1", "A5G1-p6B0.m2" ], 1, 6 ]
##          , isPrimitive := true, maxnr := 2, p := 6, rankAction := 2, 
##        repname := "A5G1-p6B0", repnr := 2, size := 60, 
##        stabilizer := "D10", standardization := 1, transitivity := 2, 
##        type := "perm" ), 
##    rec( charactername := "1a+4a+5a", constituents := [ 1, 4, 5 ], 
##        contents := "core", groupname := "A5", id := "", 
##        identifier := [ "A5", [ "A5G1-p10B0.m1", "A5G1-p10B0.m2" ], 1, 
##            10 ], isPrimitive := true, maxnr := 3, p := 10, 
##        rankAction := 3, repname := "A5G1-p10B0", repnr := 3, 
##        size := 60, stabilizer := "S3", standardization := 1, 
##        transitivity := 1, type := "perm" ) ]
##  ]]></Example>
##  <P/>
##  Note that a matrix representation in any characteristic can be obtained by
##  reducing a permutation representation or an integral matrix representation;
##  however, the database does not <E>store</E> such a representation
##  (cf.&nbsp;Section&nbsp;
##  <Ref Sect="sect:Accessing vs. Constructing Representations"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AllAtlasGeneratingSetInfos" );


#############################################################################
##
#A  AtlasRepInfoRecord( <G> )
#A  AtlasRepInfoRecord( <name> )
##
##  <#GAPDoc Label="AtlasRepInfoRecord">
##  <ManSection>
##  <Attr Name="AtlasRepInfoRecord" Arg='G' Label="for a group"/>
##  <Attr Name="AtlasRepInfoRecord" Arg='name' Label="for a string"/>
##  <Returns>
##  the record stored in the group <A>G</A> when this was constructed
##  with <Ref Func="AtlasGroup" Label="for various arguments"/>,
##  or a record with information about the group with name <A>name</A>.
##  </Returns>
##  <Description>
##  For a group <A>G</A> that has been constructed with
##  <Ref Func="AtlasGroup" Label="for various arguments"/>,
##  the value of this attribute is the info record that describes <A>G</A>,
##  in the sense that this record was the first argument of the call to
##  <Ref Func="AtlasGroup" Label="for various arguments"/>, or it is the
##  result of the call to <Ref Func="OneAtlasGeneratingSetInfo"/> with the
##  conditions that were listed in the call to
##  <Ref Func="AtlasGroup" Label="for various arguments"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> AtlasRepInfoRecord( AtlasGroup( "A5" ) );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  ]]></Example>
##  <P/>
##  For a string <A>name</A> that is a &GAP; name of a group <M>G</M>, say,
##  <Ref Attr="AtlasRepInfoRecord" Label="for a string"/> returns a record
##  that contains information about <M>G</M> which is used by
##  <Ref Func="DisplayAtlasInfo"/>.
##  The following components may be bound in the record.
##  <P/>
##  <List>
##  <Mark><C>name</C></Mark>
##  <Item>
##    the string <A>name</A>,
##  </Item>
##  <Mark><C>nrMaxes</C></Mark>
##  <Item>
##    the number of conjugacy classes of maximal subgroups of <M>G</M>,
##  </Item>
##  <Mark><C>size</C></Mark>
##  <Item>
##    the order of <M>G</M>,
##  </Item>
##  <Mark><C>sizesMaxes</C></Mark>
##  <Item>
##    a list which contains at position <M>i</M>, if bound,
##    the order of a subgroup in the <M>i</M>-th class of maximal subgroups
##    of <M>G</M>,
##  </Item>
##  <Mark><C>slpMaxes</C></Mark>
##  <Item>
##    a list of length two;
##    the first entry is a list of positions <M>i</M> such that
##    a straight line program for computing the restriction of
##    representations of <M>G</M> to a subgroup in the <M>i</M>-th class of
##    maximal subgroups is available via &AtlasRep;;
##    the second entry is the corresponding list of standardizations of
##    the generators of <M>G</M> for which these straight line programs
##    are available,
##  </Item>
##  <Mark><C>structureMaxes</C></Mark>
##  <Item>
##    a list which contains at position <M>i</M>, if bound,
##    a string that describes the structure of the subgroups in the
##    <M>i</M>-th class of maximal subgroups of <M>G</M>.
##  </Item>
##  </List>
##  <P/>
##  <Example><![CDATA[
##  gap> AtlasRepInfoRecord( "A5" );
##  rec( name := "A5", nrMaxes := 3, size := 60, 
##    sizesMaxes := [ 12, 10, 6 ], 
##    slpMaxes := [ [ 1 .. 3 ], [ [ 1 ], [ 1 ], [ 1 ] ] ], 
##    structureMaxes := [ "A4", "D10", "S3" ] )
##  gap> AtlasRepInfoRecord( "J5" );
##  rec(  )
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "AtlasRepInfoRecord", IsGroup );

DeclareAttribute( "AtlasRepInfoRecord", IsString );


#############################################################################
##
#F  AtlasGroup( [<gapname>[, <std>]] )
#F  AtlasGroup( [<gapname>[, <std>]], IsPermGroup[, true] )
#F  AtlasGroup( [<gapname>[, <std>]], NrMovedPoints, <n> )
#F  AtlasGroup( [<gapname>[, <std>]], IsMatrixGroup[, true] )
#F  AtlasGroup( [<gapname>[, <std>]][, Characteristic, <p>]
#F                                  [, Dimension, <m>] )
#F  AtlasGroup( [<gapname>[, <std>]][, Ring, <R>][, Dimension, <m>] )
#F  AtlasGroup( <identifier> )
##
##  <#GAPDoc Label="AtlasGroup">
##  <ManSection>
##  <Heading>AtlasGroup</Heading>
##  <Func Name="AtlasGroup" Arg='[gapname][, std][, ...]'
##   Label="for various arguments"/>
##  <Func Name="AtlasGroup" Arg='identifier'
##   Label="for an identifier record"/>
##
##  <Returns>
##  a group that satisfies the conditions, or <K>fail</K>.
##  </Returns>
##  <Description>
##  <Ref Func="AtlasGroup" Label="for various arguments"/> takes the same
##  arguments as <Ref Func="OneAtlasGeneratingSetInfo"/>,
##  and returns the group generated by the <C>generators</C> component
##  of the record that is returned by <Ref Func="OneAtlasGeneratingSetInfo"/>
##  with these arguments;
##  if <Ref Func="OneAtlasGeneratingSetInfo"/> returns <K>fail</K> then also
##  <Ref Func="AtlasGroup" Label="for various arguments"/> returns
##  <K>fail</K>.
##  <P/>
##  <Example><![CDATA[
##  gap> g:= AtlasGroup( "A5" );
##  Group([ (1,2)(3,4), (1,3,5) ])
##  ]]></Example>
##  <P/>
##  Alternatively, it is possible to enter exactly one argument,
##  a record <A>identifier</A> as returned by
##  <Ref Func="OneAtlasGeneratingSetInfo"/> or
##  <Ref Func="AllAtlasGeneratingSetInfos"/>,
##  or the <C>identifier</C> component of such a record.
##  <P/>
##  <Example><![CDATA[
##  gap> info:= OneAtlasGeneratingSetInfo( "A5" );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> AtlasGroup( info );
##  Group([ (1,2)(3,4), (1,3,5) ])
##  gap> AtlasGroup( info.identifier );
##  Group([ (1,2)(3,4), (1,3,5) ])
##  ]]></Example>
##  <P/>
##  In the groups returned by
##  <Ref Func="AtlasGroup" Label="for various arguments"/>,
##  the value of the attribute
##  <Ref Attr="AtlasRepInfoRecord" Label="for a group"/> is set.
##  This information is used for example by
##  <Ref Func="AtlasSubgroup" Label="for a group and a number"/>
##  when this function is called with second argument a group created by
##  <Ref Func="AtlasGroup" Label="for various arguments"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasGroup" );


#############################################################################
##
#F  AtlasSubgroup( <gapname>[, <std>], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], IsPermGroup[, true], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], NrMovedPoints, <n>, <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>], IsMatrixGroup[, true], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>][, Characteristic, <p>]
#F                                  [, Dimension, <m>], <maxnr> )
#F  AtlasSubgroup( <gapname>[, <std>][, Ring, <R>]
#F                                  [, Dimension, <m>], <maxnr> )
#F  AtlasSubgroup( <identifier>, <maxnr> )
#F  AtlasSubgroup( <G>, <maxnr> )
##
##  <#GAPDoc Label="AtlasSubgroup">
##  <ManSection>
##  <Heading>AtlasSubgroup</Heading>
##  <Func Name="AtlasSubgroup" Arg='gapname[, std][, ...], maxnr'
##   Label="for a group name (and various arguments) and a number"/>
##  <Func Name="AtlasSubgroup" Arg='identifier, maxnr'
##   Label="for an identifier record and a number"/>
##  <Func Name="AtlasSubgroup" Arg='G, maxnr'
##   Label="for a group and a number"/>
##
##  <Returns>
##  a group that satisfies the conditions, or <K>fail</K>.
##  </Returns>
##  <Description>
##  The arguments of
##  <Ref Func="AtlasSubgroup"
##   Label="for a group name (and various arguments) and a number"/>,
##  except the last argument <A>maxnr</A>, are the same as for
##  <Ref Func="AtlasGroup" Label="for various arguments"/>.
##  If the database provides a straight line program
##  for restricting representations of the group with name <A>gapname</A>
##  (given w.&nbsp;r.&nbsp;t.&nbsp;the <A>std</A>-th standard generators)
##  to the <A>maxnr</A>-th maximal subgroup
##  and if a representation with the required properties is available,
##  in the sense that calling
##  <Ref Func="AtlasGroup" Label="for various arguments"/> with the same
##  arguments except <A>maxnr</A> yields a group, then
##  <Ref Func="AtlasSubgroup"
##   Label="for a group name (and various arguments) and a number"/>
##  returns the restriction of this representation to the <A>maxnr</A>-th
##  maximal subgroup.
##  <P/>
##  In all other cases, <K>fail</K> is returned.
##  <P/>
##  Note that the conditions refer to the group and not to the subgroup.
##  It may happen that in the restriction of a permutation representation
##  to a subgroup, fewer points are moved,
##  or that the restriction of a matrix representation turns out to be
##  defined over a smaller ring.
##  Here is an example.
##  <P/>
##  <Example><![CDATA[
##  gap> g:= AtlasSubgroup( "A5", NrMovedPoints, 5, 1 );
##  Group([ (1,5)(2,3), (1,3,5) ])
##  gap> NrMovedPoints( g );
##  4
##  ]]></Example>
##  <P/>
##  Alternatively, it is possible to enter exactly two arguments,
##  the first being a record <A>identifier</A> as returned by
##  <Ref Func="OneAtlasGeneratingSetInfo"/> or
##  <Ref Func="AllAtlasGeneratingSetInfos"/>,
##  or the <C>identifier</C> component of such a record,
##  or a group <A>G</A> constructed with
##  <Ref Func="AtlasGroup" Label="for an identifier record"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> info:= OneAtlasGeneratingSetInfo( "A5" );
##  rec( charactername := "1a+4a", constituents := [ 1, 4 ], 
##    contents := "core", groupname := "A5", id := "", 
##    identifier := [ "A5", [ "A5G1-p5B0.m1", "A5G1-p5B0.m2" ], 1, 5 ], 
##    isPrimitive := true, maxnr := 1, p := 5, rankAction := 2, 
##    repname := "A5G1-p5B0", repnr := 1, size := 60, stabilizer := "A4", 
##    standardization := 1, transitivity := 3, type := "perm" )
##  gap> AtlasSubgroup( info, 1 );
##  Group([ (1,5)(2,3), (1,3,5) ])
##  gap> AtlasSubgroup( info.identifier, 1 );
##  Group([ (1,5)(2,3), (1,3,5) ])
##  gap> AtlasSubgroup( AtlasGroup( "A5" ), 1 );
##  Group([ (1,5)(2,3), (1,3,5) ])
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AtlasSubgroup" );


#############################################################################
##
#O  EvaluatePresentation( <G>, <gapname>[, <std>] )
#O  EvaluatePresentation( <gens>, <gapname>[, <std>] )
##
##  <#GAPDoc Label="EvaluatePresentation">
##  <ManSection>
##  <Heading>EvaluatePresentation</Heading>
##  <Oper Name="EvaluatePresentation" Arg='G, gapname[, std]'
##   Label="for a group, a group name (and a number)"/>
##  <Oper Name="EvaluatePresentation" Arg='gens, gapname[, std]'
##   Label="for a list of generators, a group name (and a number)"/>
##
##  <Returns>
##  a list of group elements or <K>fail</K>.
##  </Returns>
##  <Description>
##  The first argument must be either a group <A>G</A> or a list <A>gens</A>
##  of group generators,
##  and <A>gapname</A> must be a string that is a &GAP; name
##  (see
##  Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>)
##  of a group <M>H</M>, say.
##  The optional argument <A>std</A>, if given, must be a positive integer
##  that denotes a standardization of generators of <M>H</M>,
##  the default is <M>1</M>.
##  <P/>
##  <Ref Oper="EvaluatePresentation"
##  Label="for a group, a group name (and a number)"/> returns <K>fail</K>
##  if no presentation for <M>H</M>
##  w.&nbsp;r.&nbsp;t.&nbsp;the standardization <A>std</A>
##  is stored in the database,
##  and otherwise returns the list of results of evaluating the relators
##  of a presentation for <M>H</M> at <A>gens</A> or the
##  <Ref BookName="ref" Attr="GeneratorsOfGroup"/> value of <A>G</A>,
##  respectively.
##  (An error is signalled if the number of generators is not equal to the
##  number of inputs of the presentation.)
##  <P/>
##  The result can be used as follows.
##  Let <M>N</M> be the normal closure of the the result in <A>G</A>.
##  The factor group <A>G</A><M>/N</M> is an epimorphic image of <M>H</M>.
##  In particular, if all entries of the result have order <M>1</M> then
##  <A>G</A> itself is an epimorphic image of <M>H</M>.
##  Moreover, an epimorphism is given by mapping the <A>std</A>-th
##  standard generators of <M>H</M> to the <M>N</M>-cosets
##  of the given generators of <A>G</A>.
##  <P/>
##  <Example><![CDATA[
##  gap> g:= MathieuGroup( 12 );;
##  gap> gens:= GeneratorsOfGroup( g );;  # switch to 2 generators
##  gap> g:= Group( gens[1] * gens[3], gens[2] * gens[3] );;
##  gap> EvaluatePresentation( g, "J0" );  # no pres. for group "J0"
##  fail
##  gap> relimgs:= EvaluatePresentation( g, "M11" );;
##  gap> List( relimgs, Order );  # wrong group
##  [ 3, 1, 5, 4, 10 ]
##  gap> relimgs:= EvaluatePresentation( g, "M12" );;
##  gap> List( relimgs, Order );  # generators are not standard
##  [ 3, 4, 5, 4, 4 ]
##  gap> g:= AtlasGroup( "M12" );;
##  gap> relimgs:= EvaluatePresentation( g, "M12", 1 );;
##  gap> List( relimgs, Order );  # right group, std. generators
##  [ 1, 1, 1, 1, 1 ]
##  gap> g:= AtlasGroup( "2.M12" );;
##  gap> relimgs:= EvaluatePresentation( g, "M12", 1 );;
##  gap> List( relimgs, Order );  # std. generators for extension
##  [ 1, 2, 1, 1, 2 ]
##  gap> Size( NormalClosure( g, SubgroupNC( g, relimgs ) ) );
##  2
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "EvaluatePresentation", [ IsGroup, IsString ] );
DeclareOperation( "EvaluatePresentation",
    [ IsGroup, IsString, IsPosInt ] );
DeclareOperation( "EvaluatePresentation",
    [ IsHomogeneousList, IsString ] );
DeclareOperation( "EvaluatePresentation",
    [ IsHomogeneousList, IsString, IsPosInt ] );


#############################################################################
##
#O  StandardGeneratorsData( <G>, <gapname>[, <std>][: projective] )
#O  StandardGeneratorsData( <gens>, <gapname>[, <std>][: projective] )
##
##  <#GAPDoc Label="StandardGeneratorsData">
##  <ManSection>
##  <Heading>StandardGeneratorsData</Heading>
##  <Oper Name="StandardGeneratorsData" Arg='G, gapname[, std]'
##   Label="for a group, a group name (and a number)"/>
##  <Oper Name="StandardGeneratorsData" Arg='gens, gapname[, std]'
##   Label="for a list of generators, a group name (and a number)"/>
##
##  <Returns>
##  a record that describes standard generators of the group in question,
##  or <K>fail</K>, or the string <C>"timeout"</C>.
##  </Returns>
##  <Description>
##  The first argument must be either a group <A>G</A> or a list <A>gens</A>
##  of group generators,
##  and <A>gapname</A> must be a string that is a &GAP; name
##  (see
##  Section&nbsp;<Ref Sect="sect:Group Names Used in the AtlasRep Package"/>)
##  of a group <M>H</M>, say.
##  The optional argument <A>std</A>, if given, must be a positive integer
##  that denotes a standardization of generators of <M>H</M>,
##  the default is <M>1</M>.
##  <P/>
##  If the global option <C>projective</C> is given then the group elements
##  must be matrices over a finite field,
##  and the group must be a central extension of the group <M>H</M>
##  by a normal subgroup that consists of scalar matrices.
##  In this case, all computations will be carried out modulo scalar
##  matrices (in particular, element orders will be computed using
##  <Ref BookName="ref" Attr="ProjectiveOrder"/>),
##  and the returned standard generators will belong to <M>H</M>.
##  <P/>
##  <Ref Oper="StandardGeneratorsData"
##  Label="for a group, a group name (and a number)"/> returns
##  <P/>
##  <List>
##  <Mark><K>fail</K></Mark>
##  <Item>
##    if no black box program for computing standard generators of <M>H</M>
##    w.&nbsp;r.&nbsp;t.&nbsp;the standardization <A>std</A>
##    is stored in the database,
##    or if the black box program returns <K>fail</K>
##    because a runtime error occurred or the program has proved
##    that the given group or generators cannot generate a group
##    isomorphic to <M>H</M>,
##  </Item>
##  <Mark><C>"timeout"</C></Mark>
##  <Item>
##    if the black box program returns <C>"timeout"</C>,
##    typically because some elements of a given order were not found
##    among a reasonable number of random elements, or
##  </Item>
##  <Mark>a record containing standard generators</Mark>
##  <Item>
##    otherwise.
##  </Item>
##  </List>
##  <P/>
##  When the result is not a record then either the group is not isomorphic
##  to <M>H</M> (modulo scalars if applicable),
##  or we were unlucky with choosing random elements.
##  <P/>
##  When a record is returned <E>and</E> <A>G</A> or the group generated by
##  <A>gens</A>, respectively, is isomorphic to <M>H</M>
##  (or to a central extension of <M>H</M> by a group of scalar matrices
##  if the global option <C>projective</C> is given)
##  then the result describes the desired standard generators.
##  <P/>
##  If <A>G</A> or the group generated by <A>gens</A>, respectively,
##  is <E>not</E> isomorphic to <M>H</M> then it may still happen that
##  <Ref Oper="StandardGeneratorsData"
##  Label="for a group, a group name (and a number)"/> returns a record.
##  For a proof that the returned record describes the desired standard
##  generators, one can use a presentation of <M>H</M> whose generators
##  correspond to the <A>std</A>-th standard generators,
##  see <Ref Oper="EvaluatePresentation"
##  Label="for a group, a group name (and a number)"/>.
##  <P/>
##  A returned record has the following components.
##  <P/>
##  <List>
##  <Mark><C>gapname</C></Mark>
##  <Item>
##    the string <A>gapname</A>,
##  </Item>
##  <Mark><C>givengens</C></Mark>
##  <Item>
##    the list of group generators from which standard generators were
##    computed,
##    either <A>gens</A> or the <Ref BookName="ref" Attr="GeneratorsOfGroup"/>
##    value of <A>G</A>,
##  </Item>
##  <Mark><C>stdgens</C></Mark>
##  <Item>
##    a list of standard generators of the group,
##  </Item>
##  <Mark><C>givengenstostdgens</C></Mark>
##  <Item>
##    a straight line program that takes <C>givengens</C> as inputs,
##    and returns <C>stdgens</C>,
##  </Item>
##  <Mark><C>std</C></Mark>
##  <Item>
##    the underlying standardization <A>std</A>.
##  </Item>
##  </List>
##  <P/>
##  The first examples show three cases of failure,
##  due to the unavailability of a suitable black box program
##  or to a wrong choice of <A>gapname</A>.
##  (In the search for standard generators of <M>M_{11}</M> in the group
##  <M>M_{12}</M>, one may or may not find an element whose order does not
##  appear in <M>M_{11}</M>; in the first case, the result is <K>fail</K>,
##  whereas a record is returned in the second case.
##  Both cases occur.)
##  <P/>
##  <Example><![CDATA[
##  gap> StandardGeneratorsData( MathieuGroup( 11 ), "J0" );
##  fail
##  gap> StandardGeneratorsData( MathieuGroup( 11 ), "M12" );
##  "timeout"
##  gap> repeat
##  >      res:= StandardGeneratorsData( MathieuGroup( 12 ), "M11" );
##  >    until res = fail;
##  ]]></Example>
##  <P/>
##  The next example shows a computation of standard generators for the
##  Mathieu group <M>M_{12}</M>.
##  Using a presentation of <M>M_{12}</M> w.&nbsp;r.&nbsp;t.&nbsp;these
##  standard generators, we prove that the given group is
##  isomorphic to <M>M_{12}</M>.
##  <P/>
##  <Example><![CDATA[
##  gap> gens:= GeneratorsOfGroup( MathieuGroup( 12 ) );;
##  gap> std:= 1;;
##  gap> res:= StandardGeneratorsData( gens, "M12", std );;
##  gap> Set( RecNames( res ) );
##  [ "gapname", "givengens", "givengenstostdgens", "std", "stdgens" ]
##  gap> gens = res.givengens;
##  true
##  gap> ResultOfStraightLineProgram( res.givengenstostdgens, gens )
##  >    = res.stdgens;
##  true
##  gap> evl:= EvaluatePresentation( res.stdgens, "M12", std );;
##  gap> ForAll( evl, IsOne );
##  true
##  ]]></Example>
##  <P/>
##  The next example shows the use of the global option <C>projective</C>.
##  We take an irreducible matrix representation of the double cover of
##  the Mathieu group <M>M_{12}</M> (thus the center is represented by
##  scalar matrices) and compute standard generators of the factor group
##  <M>M_{12}</M>.
##  Using a presentation of <M>M_{12}</M> w.&nbsp;r.&nbsp;t.&nbsp;these
##  standard generators, we prove that the given group is modulo scalars
##  isomorphic to <M>M_{12}</M>, and we get generators for the kernel.
##  <P/>
##  <Example><![CDATA[
##  gap> g:= AtlasGroup( "2.M12", IsMatrixGroup, Characteristic, IsPosInt );;
##  gap> gens:= Permuted( GeneratorsOfGroup( g ), (1,2) );;
##  gap> res:= StandardGeneratorsData( gens, "M12", std : projective );;
##  gap> gens = res.givengens;
##  true
##  gap> ResultOfStraightLineProgram( res.givengenstostdgens, gens )
##  >    = res.stdgens;
##  true
##  gap> evl:= EvaluatePresentation( res.stdgens, "M12", std );;
##  gap> ForAll( evl, IsOne );
##  false
##  gap> ForAll( evl, x -> IsCentral( g, x ) );
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "StandardGeneratorsData", [ IsGroup, IsString ] );
DeclareOperation( "StandardGeneratorsData",
    [ IsGroup, IsString, IsPosInt ] );
DeclareOperation( "StandardGeneratorsData",
    [ IsHomogeneousList, IsString ] );
DeclareOperation( "StandardGeneratorsData",
    [ IsHomogeneousList, IsString, IsPosInt ] );


#############################################################################
##
#E

