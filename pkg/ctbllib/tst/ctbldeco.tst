# This file was created from xpl/ctbldeco.xpl, do not edit!
#############################################################################
##
#W  ctbldeco.tst              GAP applications              Thomas Breuer
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `Test( "ctbldeco.tst" );`.
##
gap> START_TEST( "ctbldeco.tst" );

##
gap> LoadPackage( "ctbllib", false );
true

##
gap> ordtbl:= CharacterTable( "M11" );
CharacterTable( "M11" )
gap> p:= 2;
2
gap> modtbl:= ordtbl mod p;
BrauerTable( "M11", 2 )

##
gap> Display( ordtbl );
M11

      2  4  4  1  3  .  1  3  3   .   .
      3  2  1  2  .  .  1  .  .   .   .
      5  1  .  .  .  1  .  .  .   .   .
     11  1  .  .  .  .  .  .  .   1   1

        1a 2a 3a 4a 5a 6a 8a 8b 11a 11b
     2P 1a 1a 3a 2a 5a 3a 4a 4a 11b 11a
     3P 1a 2a 1a 4a 5a 2a 8a 8b 11a 11b
     5P 1a 2a 3a 4a 1a 6a 8b 8a 11a 11b
    11P 1a 2a 3a 4a 5a 6a 8a 8b  1a  1a

X.1      1  1  1  1  1  1  1  1   1   1
X.2     10  2  1  2  . -1  .  .  -1  -1
X.3     10 -2  1  .  .  1  A -A  -1  -1
X.4     10 -2  1  .  .  1 -A  A  -1  -1
X.5     11  3  2 -1  1  . -1 -1   .   .
X.6     16  . -2  .  1  .  .  .   B  /B
X.7     16  . -2  .  1  .  .  .  /B   B
X.8     44  4 -1  . -1  1  .  .   .   .
X.9     45 -3  .  1  .  . -1 -1   1   1
X.10    55 -1  1 -1  . -1  1  1   .   .

A = E(8)+E(8)^3
  = Sqrt(-2) = i2
B = E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9
  = (-1+Sqrt(-11))/2 = b11
gap> Display( modtbl );
M11mod2

     2  4  1  .   .   .
     3  2  2  .   .   .
     5  1  .  1   .   .
    11  1  .  .   1   1

       1a 3a 5a 11a 11b
    2P 1a 3a 5a 11b 11a
    3P 1a 1a 5a 11a 11b
    5P 1a 3a 1a 11a 11b
   11P 1a 3a 5a  1a  1a

X.1     1  1  1   1   1
X.2    10  1  .  -1  -1
X.3    16 -2  1   A  /A
X.4    16 -2  1  /A   A
X.5    44 -1 -1   .   .

A = E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9
  = (-1+Sqrt(-11))/2 = b11

##
gap> mat:= DecompositionMatrix( modtbl );
[ [ 1, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], 
  [ 1, 1, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ], 
  [ 1, 0, 0, 0, 1 ], [ 1, 1, 0, 0, 1 ] ]
gap> Display( mat );
[ [  1,  0,  0,  0,  0 ],
  [  0,  1,  0,  0,  0 ],
  [  0,  1,  0,  0,  0 ],
  [  0,  1,  0,  0,  0 ],
  [  1,  1,  0,  0,  0 ],
  [  0,  0,  1,  0,  0 ],
  [  0,  0,  0,  1,  0 ],
  [  0,  0,  0,  0,  1 ],
  [  1,  0,  0,  0,  1 ],
  [  1,  1,  0,  0,  1 ] ]

##
gap> blocks:= PrimeBlocks( ordtbl, p );;
gap> blocks.block;
[ 1, 1, 1, 1, 1, 2, 3, 1, 1, 1 ]
gap> blocks.defect;
[ 4, 0, 0 ]

##
gap> blocksinfo:= BlocksInfo( modtbl );
[ rec( basicset := [ 1, 2, 8 ], 
      decinv := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ], defect := 4, 
      modchars := [ 1, 2, 5 ], ordchars := [ 1, 2, 3, 4, 5, 8, 9, 10 ] ), 
  rec( basicset := [ 6 ], decinv := [ [ 1 ] ], defect := 0, modchars := [ 3 ],
      ordchars := [ 6 ] ), 
  rec( basicset := [ 7 ], decinv := [ [ 1 ] ], defect := 0, modchars := [ 4 ],
      ordchars := [ 7 ] ) ]

##
gap> Display( DecompositionMatrix( modtbl, 1 ) );
[ [  1,  0,  0 ],
  [  0,  1,  0 ],
  [  0,  1,  0 ],
  [  0,  1,  0 ],
  [  1,  1,  0 ],
  [  0,  0,  1 ],
  [  1,  0,  1 ],
  [  1,  1,  1 ] ]

##
gap> principalinfo:= blocksinfo[1];
rec( basicset := [ 1, 2, 8 ], 
  decinv := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ], 
  decmat := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 1, 0 ], [ 0, 1, 0 ], 
      [ 1, 1, 0 ], [ 0, 0, 1 ], [ 1, 0, 1 ], [ 1, 1, 1 ] ], defect := 4, 
  modchars := [ 1, 2, 5 ], ordchars := [ 1, 2, 3, 4, 5, 8, 9, 10 ] )

##
gap> ordpos:= principalinfo.ordchars;
[ 1, 2, 3, 4, 5, 8, 9, 10 ]

##
gap> ordchars:= Irr( ordtbl ){ ordpos };
[ Character( CharacterTable( "M11" ), [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ), 
  Character( CharacterTable( "M11" ), [ 10, 2, 1, 2, 0, -1, 0, 0, -1, -1 ] ), 
  Character( CharacterTable( "M11" ),
  [ 10, -2, 1, 0, 0, 1, E(8)+E(8)^3, -E(8)-E(8)^3, -1, -1 ] ), 
  Character( CharacterTable( "M11" ),
  [ 10, -2, 1, 0, 0, 1, -E(8)-E(8)^3, E(8)+E(8)^3, -1, -1 ] ), 
  Character( CharacterTable( "M11" ), [ 11, 3, 2, -1, 1, 0, -1, -1, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 44, 4, -1, 0, -1, 1, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "M11" ), [ 45, -3, 0, 1, 0, 0, -1, -1, 1, 1 ] ), 
  Character( CharacterTable( "M11" ), [ 55, -1, 1, -1, 0, -1, 1, 1, 0, 0 ] ) ]

##
gap> rest:= RestrictedClassFunctions( ordchars, modtbl );
[ Character( BrauerTable( "M11", 2 ), [ 1, 1, 1, 1, 1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 10, 1, 0, -1, -1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 10, 1, 0, -1, -1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 10, 1, 0, -1, -1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 11, 2, 1, 0, 0 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 44, -1, -1, 0, 0 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 45, 0, 0, 1, 1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 55, 1, 0, 0, 0 ] ) ]
gap> modchars:= Irr( modtbl ){ principalinfo.modchars };    
[ Character( BrauerTable( "M11", 2 ), [ 1, 1, 1, 1, 1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 10, 1, 0, -1, -1 ] ), 
  Character( BrauerTable( "M11", 2 ), [ 44, -1, -1, 0, 0 ] ) ]
gap> dec:= Decomposition( modchars, rest, "nonnegative" );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 1, 0 ], [ 0, 1, 0 ], [ 1, 1, 0 ], 
  [ 0, 0, 1 ], [ 1, 0, 1 ], [ 1, 1, 1 ] ]

##
gap> Print( LaTeXStringDecompositionMatrix( modtbl, 1 ) );
\[
\begin{array}{r|rrr} \hline
 & {\tt Y}_{1}
 & {\tt Y}_{2}
 & {\tt Y}_{5}
 \rule[-7pt]{0pt}{20pt} \\ \hline
{\tt X}_{1} & 1 & . & . \rule[0pt]{0pt}{13pt} \\
{\tt X}_{2} & . & 1 & . \\
{\tt X}_{3} & . & 1 & . \\
{\tt X}_{4} & . & 1 & . \\
{\tt X}_{5} & 1 & 1 & . \\
{\tt X}_{8} & . & . & 1 \\
{\tt X}_{9} & 1 & . & 1 \\
{\tt X}_{10} & 1 & 1 & 1 \rule[-7pt]{0pt}{5pt} \\
\hline
\end{array}
\]

##
gap> StringOfPartition:= function( part )
>    local pair;
> 
>    part:= List( Reversed( Collected( part ) ),
>                 pair -> List( pair, String ) );
>    for pair in part do
>      if pair[2] = "1" then
>        Unbind( pair[2] );
>      else
>        pair[2]:= Concatenation( "{", pair[2], "}" );
>      fi;
>    od;
>    return JoinStringsWithSeparator( List( part,
>               p -> JoinStringsWithSeparator( p, "^" ) ), " \\ " );
>  end;;
gap> StringOfPartition( [ 2, 1, 1, 1, 1 ] );
"2 \\ 1^{4}"

##
gap> MyLaTeXMatrix:= function( symt, blocknr )
>    local alllabels, rowlabels;
> 
>    alllabels:= List( CharacterParameters( OrdinaryCharacterTable( symt ) ),
>                      x -> StringOfPartition( x[2] ) );
>    rowlabels:= alllabels{ BlocksInfo( symt )[ blocknr ].ordchars };
> 
>    return LaTeXStringDecompositionMatrix( symt, blocknr,
>               rec(  phi:= "\\varphi", rowlabels:= rowlabels ) );
> end;;

##
gap> t:= CharacterTable( "S6" ) mod 5;
BrauerTable( "A6.2_1", 5 )
gap> b:= 1;
1
gap> Print( MyLaTeXMatrix( t, b ) );
\[
\begin{array}{r|rrrr} \hline
 & \varphi_{1}
 & \varphi_{2}
 & \varphi_{7}
 & \varphi_{8}
 \rule[-7pt]{0pt}{20pt} \\ \hline
6 & 1 & . & . & . \rule[0pt]{0pt}{13pt} \\
1^{6} & . & 1 & . & . \\
3 \ 2 \ 1 & . & . & 1 & 1 \\
4 \ 2 & 1 & . & 1 & . \\
2^{2} \ 1^{2} & . & 1 & . & 1 \rule[-7pt]{0pt}{5pt} \\
\hline
\end{array}
\]

##
gap> ordtbl:= CharacterTable( "A6" );
CharacterTable( "A6" )
gap> ordlabels:= AtlasLabelsOfIrreducibles( ordtbl );
[ "\\chi_{1}", "\\chi_{2}", "\\chi_{3}", "\\chi_{4}", "\\chi_{5}", 
  "\\chi_{6}", "\\chi_{7}" ]
gap> modtbl:= ordtbl mod 5;
BrauerTable( "A6", 5 )
gap> modlabels:= AtlasLabelsOfIrreducibles( modtbl );
[ "\\varphi_{1}", "\\varphi_{2}", "\\varphi_{3}", "\\varphi_{4}", 
  "\\varphi_{5}" ]

##
gap> rowlabels:= ordlabels{ BlocksInfo( modtbl )[1].ordchars };
[ "\\chi_{1}", "\\chi_{4}", "\\chi_{5}", "\\chi_{6}" ]
gap> collabels:= modlabels{ BlocksInfo( modtbl )[1].modchars };
[ "\\varphi_{1}", "\\varphi_{4}" ]
gap> options:= rec( rowlabels:= rowlabels, collabels:= collabels );;
gap> Print( LaTeXStringDecompositionMatrix( modtbl, 1, options ) );
\[
\begin{array}{r|rr} \hline
 & \varphi_{1}
 & \varphi_{4}
 \rule[-7pt]{0pt}{20pt} \\ \hline
\chi_{1} & 1 & . \rule[0pt]{0pt}{13pt} \\
\chi_{4} & . & 1 \\
\chi_{5} & . & 1 \\
\chi_{6} & 1 & 1 \rule[-7pt]{0pt}{5pt} \\
\hline
\end{array}
\]

##
gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A6" ) );
[ "\\chi_{1}", "\\chi_{2}", "\\chi_{3}", "\\chi_{4}", "\\chi_{5}", 
  "\\chi_{6}", "\\chi_{7}", "\\chi_{14}", "\\chi_{14}^{\\ast 11}", 
  "\\chi_{15}", "\\chi_{15}^{\\ast 11}", "\\chi_{16}", "\\chi_{16}^{\\ast 2}",
  "\\chi_{17}", "\\chi_{17}^{\\ast 2}", "\\chi_{18}", "\\chi_{18}^{\\ast 2}" ]
gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A6" ) mod 5 );
[ "\\varphi_{1}", "\\varphi_{2}", "\\varphi_{3}", "\\varphi_{4}", 
  "\\varphi_{5}", "\\varphi_{10}", "\\varphi_{10}^{\\ast 2}", "\\varphi_{11}",
  "\\varphi_{11}^{\\ast 2}", "\\varphi_{12}", "\\varphi_{12}^{\\ast 2}" ]

##
gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A6.2_1" ) );
[ "\\chi_{1,0}", "\\chi_{1,1}", "\\chi_{2,0}", "\\chi_{2,1}", "\\chi_{3,0}", 
  "\\chi_{3,1}", "\\chi_{4+5}", "\\chi_{6,0}", "\\chi_{6,1}", "\\chi_{7,0}", 
  "\\chi_{7,1}", "\\chi_{14+15\\ast 11}", "\\chi_{14\\ast 11+15}", 
  "\\chi_{16+16\\ast 2}", "\\chi_{17+17\\ast 2}", "\\chi_{18+18\\ast 2}" ]
gap> AtlasLabelsOfIrreducibles( CharacterTable( "3.A6.2_1" ), "short" );
[ "\\chi_{1,0}", "\\chi_{1,1}", "\\chi_{2,0}", "\\chi_{2,1}", "\\chi_{3,0}", 
  "\\chi_{3,1}", "\\chi_{4+}", "\\chi_{6,0}", "\\chi_{6,1}", "\\chi_{7,0}", 
  "\\chi_{7,1}", "\\chi_{14+}", "\\chi_{15+}", "\\chi_{16+}", "\\chi_{17+}", 
  "\\chi_{18+}" ]

##
gap> ordtbl:= CharacterTable( "3.A6.2_1" );;
gap> ordlabels:= AtlasLabelsOfIrreducibles( ordtbl, "short" );;
gap> modtbl:= ordtbl mod 3;;
gap> modlabels:= AtlasLabelsOfIrreducibles( modtbl, "short" );;
gap> rowlabels:= ordlabels{ BlocksInfo( modtbl )[1].ordchars };;
gap> collabels:= modlabels{ BlocksInfo( modtbl )[1].modchars };;
gap> options:= rec( rowlabels:= rowlabels, collabels:= collabels );;
gap> Print( LaTeXStringDecompositionMatrix( modtbl, 1, options ) );
\[
\begin{array}{r|rrrrr} \hline
 & \varphi_{1,0}
 & \varphi_{1,1}
 & \varphi_{2+}
 & \varphi_{4,0}
 & \varphi_{4,1}
 \rule[-7pt]{0pt}{20pt} \\ \hline
\chi_{1,0} & 1 & . & . & . & . \rule[0pt]{0pt}{13pt} \\
\chi_{1,1} & . & 1 & . & . & . \\
\chi_{2,0} & 1 & . & . & 1 & . \\
\chi_{2,1} & . & 1 & . & . & 1 \\
\chi_{3,0} & 1 & . & . & . & 1 \\
\chi_{3,1} & . & 1 & . & 1 & . \\
\chi_{4+} & 1 & 1 & 1 & 1 & 1 \\
\chi_{7,0} & . & . & 1 & 1 & . \\
\chi_{7,1} & . & . & 1 & . & 1 \\
\chi_{14+} & . & . & 1 & . & . \\
\chi_{15+} & . & . & 1 & . & . \\
\chi_{16+} & 2 & 2 & . & 1 & 1 \\
\chi_{18+} & 1 & 1 & 2 & 2 & 2 \rule[-7pt]{0pt}{5pt} \\
\hline
\end{array}
\]

##
gap> STOP_TEST( "ctbldeco.tst" );

#############################################################################
##
#E

