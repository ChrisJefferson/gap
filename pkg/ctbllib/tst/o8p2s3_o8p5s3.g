#############################################################################
##
#V  o8p2s3_o8p5s3_data
##
##  In all representations (where applicable),
##  $\langle a1, a2          \rangle \cong O^+_8(2)$,
##  $\langle a1, a2, b       \rangle \cong O^+_8(2).2$,
##  $\langle a1, a2, t       \rangle \cong O^+_8(2).3$,
##  $\langle a1, a2, t, b    \rangle \cong O^+_8(2).S_3$,
##  $\langle a1, a2, c       \rangle \cong O^+_8(5)$,
##  $\langle a1, a2, c, b    \rangle \cong O^+_8(5).2$,
##  $\langle a1, a2, c, t    \rangle \cong O^+_8(5).3$, and
##  $\langle a1, a2, c, t, b \rangle \cong O^+_8(5).S_3$.
##
o8p2s3_o8p5s3_data:= rec(
  # auxiliary data
  o:= One( GF(5) ),
  conj:= [[1,2,0,0,0,0,0,0],[4,2,0,0,0,0,0,0],
          [0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],
          [0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],
          [0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,1]]*~.o,
  conjinv:= Inverse( ~.conj ),
  seed_orb120:= [1,1,0,0,0,0,0,0], 
  # matrix generators of $2.M$, $2.M.2$, in dimension $8$ over the Rationals
  dim8Q:= rec(
    a1:= [[-3,-1, 1, 1, 1,-1, 1, 1],[ 1,-1, 1, 1, 1,-1,-3, 1], 
          [-1, 1,-1,-1,-1, 1,-1, 3],[-1, 1,-1, 3,-1, 1,-1,-1], 
          [-1,-3,-1,-1,-1, 1,-1,-1],[-1, 1,-1,-1, 3, 1,-1,-1], 
          [ 1,-1,-3, 1, 1,-1, 1, 1],[ 1,-1, 1, 1, 1, 3, 1, 1]]/4,
    a2:= [[ 0, 1, 0, 1, 0, 1, 0,-1],[-1, 0,-1, 0, 1, 0,-1, 0], 
          [-1, 0, 1, 0, 1, 0, 1, 0],[ 0,-1, 0,-1, 0, 1, 0,-1], 
          [ 0,-1, 0, 1, 0,-1, 0,-1],[ 1, 0,-1, 0, 1, 0, 1, 0], 
          [ 1, 0, 1, 0, 1, 0,-1, 0],[ 0, 1, 0,-1, 0,-1, 0,-1]]/2,
    b:= ReflectionMat( ~.seed_orb120 ), 
    a1_t:= [[ 0, 0, 1, 1, 1, 1, 0, 0],[-1,-1, 0, 0, 0, 0,-1,-1], 
            [ 1,-1, 0, 0, 0, 0,-1, 1],[ 0, 0, 1,-1,-1, 1, 0, 0], 
            [ 0, 0, 1,-1, 1,-1, 0, 0],[ 1, 1, 0, 0, 0, 0,-1,-1], 
            [ 0, 0,-1,-1, 1, 1, 0, 0],[ 1,-1, 0, 0, 0, 0, 1,-1]]/2,
    a2_t:= [[-1, 1,-1,-1, 1, 3, 1, 1],[ 1,-1,-3, 1,-1, 1,-1,-1], 
            [ 1, 3, 1, 1,-1, 1,-1,-1],[-1, 1,-1,-1, 1,-1,-3, 1], 
            [ 1,-1, 1, 1, 3, 1,-1,-1],[ 1,-1, 1,-3,-1, 1,-1,-1], 
            [ 1,-1, 1, 1,-1, 1,-1, 3],[-3,-1, 1, 1,-1, 1,-1,-1]]/4,
    a1_tt:= [[-1,-1, 1, 1, 3,-1, 1, 1],[-1,-1,-3, 1,-1,-1, 1, 1], 
             [-1,-1, 1, 1,-1,-1,-3, 1],[-1,-1, 1, 1,-1,-1, 1,-3], 
             [ 1,-3,-1,-1, 1, 1,-1,-1],[ 3,-1, 1, 1,-1,-1, 1, 1], 
             [ 1, 1,-1, 3, 1, 1,-1,-1],[-1,-1, 1, 1,-1, 3, 1, 1]]/4,
    a2_tt:= [[-1,-1, 3, 1,-1, 1,-1,-1],[ 1, 1, 1,-1, 1,-1, 1,-3], 
             [-3, 1, 1,-1, 1,-1, 1, 1],[-1,-1,-1,-3,-1, 1,-1,-1], 
             [ 1, 1, 1,-1, 1, 3, 1, 1],[-1,-1,-1, 1,-1, 1, 3,-1], 
             [ 1,-3, 1,-1, 1,-1, 1, 1],[-1,-1,-1, 1, 3, 1,-1,-1]]/4,
    gamma:= [[ 0, 1, 0, 0, 0,-1,-1,-1],[-1, 0,-1, 1,-1, 0, 0, 0],
             [ 1, 0,-1, 1, 1, 0, 0, 0],[ 0,-1, 0, 0, 0,-1, 1,-1],
             [ 1, 0,-1,-1,-1, 0, 0, 0],[ 1, 0, 1, 1,-1, 0, 0, 0],
             [ 0, 1, 0, 0, 0, 1, 1,-1],[ 0, 1, 0, 0, 0,-1, 1, 1]]/2,
    gamma_t:= [[-3,-1,-1, 1, 1,-1,-1, 1],[-1,-3, 1,-1,-1, 1, 1,-1],
               [ 1,-1,-1, 1,-3,-1,-1, 1],[ 1,-1, 3, 1, 1,-1,-1, 1],
               [-1, 1, 1,-1,-1,-3, 1,-1],[-1, 1, 1,-1,-1, 1,-3,-1],
               [ 1,-1,-1, 1, 1,-1,-1,-3],[-1, 1, 1, 3,-1, 1, 1,-1]]/4,
    ),
  # permutation generators of $M$, $M.2$, of degree $120$
  orb120:= SortedList( Orbit( Group( ~.dim8Q.a1, ~.dim8Q.a2 ),
                              ~.seed_orb120, OnLines ) ),
  deg120:= rec(
    a1:= Permutation( ~.dim8Q.a1, ~.orb120, OnLines ),
    a2:= Permutation( ~.dim8Q.a2, ~.orb120, OnLines ),
    b:= Permutation( ~.dim8Q.b, ~.orb120, OnLines ),
    a1_t:= Permutation( ~.dim8Q.a1_t, ~.orb120, OnLines ),
    a2_t:= Permutation( ~.dim8Q.a2_t, ~.orb120, OnLines ),
    a1_tt:= Permutation( ~.dim8Q.a1_tt, ~.orb120, OnLines ),
    a2_tt:= Permutation( ~.dim8Q.a2_tt, ~.orb120, OnLines ),
    gamma:= Permutation( ~.dim8Q.gamma, ~.orb120, OnLines ),
    gamma_t:= Permutation( ~.dim8Q.gamma_t, ~.orb120, OnLines ),
    ),
  # permutation generators of $M$, $M.2$, $M.3$, $M.S3$, of degree $360$
  n:= 120,
  t_3n:= PermList( Concatenation( [[1..~.n]+2*~.n,[1..~.n],[1..~.n]+~.n] ) ),
  deg360:= rec(
    a1:= ~.deg120.a1 * ( ~.deg120.a1_t^(~.t_3n) )
                     * ( ~.deg120.a1_tt^(~.t_3n^2) ),
    a2:= ~.deg120.a2 * ( ~.deg120.a2_t^(~.t_3n) )
                     * ( ~.deg120.a2_tt^(~.t_3n^2) ),
    b:= PermList( Concatenation( ListPerm( ~.deg120.b ),
                      ListPerm( ~.deg120.b * ~.deg120.gamma ) + 2*~.n,
                      ListPerm( ~.deg120.b * ~.deg120.gamma
                                           * ~.deg120.gamma_t ) + ~.n ) ),
    t:= ~.t_3n,
    ),
  # matrix generators of $M$, $M.2$, $S$, $S.2$, in dimension $8$ over $\F_5$
  dim8f5:= rec(
    a1:= ~.conj * ~.dim8Q.a1 * ~.conjinv,
    a2:= ~.conj * ~.dim8Q.a2 * ~.conjinv,
    a1_t:= ~.conj * ~.dim8Q.a1_t * ~.conjinv,
    a2_t:= ~.conj * ~.dim8Q.a2_t * ~.conjinv,
    a1_tt:= ~.conj * ~.dim8Q.a1_tt * ~.conjinv,
    a2_tt:= ~.conj * ~.dim8Q.a2_tt * ~.conjinv,
    b:= ~.conj * ~.dim8Q.b * ~.conjinv,
    c:= [[1,4,4,3,2,2,2,2],[4,1,0,3,1,4,3,1],
         [0,3,0,4,2,1,1,3],[1,1,4,0,3,1,0,3],
         [4,0,3,2,2,2,2,1],[4,3,1,1,3,0,3,2],
         [0,0,4,0,1,3,2,1],[4,0,2,2,1,3,2,3]] * ~.o,
    c_t:= [[3,3,3,1,0,4,1,3],[4,0,1,4,3,3,4,3],
           [3,3,3,4,1,4,1,2],[3,2,4,0,0,0,3,0],
           [3,1,2,0,0,2,0,0],[0,1,3,0,3,0,3,3],
           [3,2,1,2,0,3,0,1],[4,1,0,0,1,2,4,1]] * ~.o,
    c_tt:= [[4,4,2,4,2,4,0,3],[2,2,0,1,2,0,0,4],
            [1,4,3,4,4,1,4,2],[1,3,0,3,1,4,4,4],
            [1,1,4,1,0,0,2,3],[4,1,2,3,0,0,0,3],
            [0,0,4,4,3,0,0,0],[2,4,1,3,3,2,0,0]] * ~.o,
    gamma:= ~.conj * ~.dim8Q.gamma * ~.conjinv,
    gamma_t:= ~.conj * ~.dim8Q.gamma_t * ~.conjinv,
    ),
  # permutation generators of $M$, $M.2$, $S$, $S.2$, of degree $19\,656$
  seed_orb19656:= [0,0,0,0,0,0,1,2] * ~.o,
  orb19656:= SortedList( Orbit( Group( ~.dim8f5.a1, ~.dim8f5.a2, ~.dim8f5.c ),
                                ~.seed_orb19656, OnLines ) ),
  deg19656:= rec(
    a1:= Permutation( ~.dim8f5.a1, ~.orb19656, OnLines ),
    a2:= Permutation( ~.dim8f5.a2, ~.orb19656, OnLines ),
    a1_t:= Permutation( ~.dim8f5.a1_t, ~.orb19656, OnLines ),
    a2_t:= Permutation( ~.dim8f5.a2_t, ~.orb19656, OnLines ),
    a1_tt:= Permutation( ~.dim8f5.a1_tt, ~.orb19656, OnLines ),
    a2_tt:= Permutation( ~.dim8f5.a2_tt, ~.orb19656, OnLines ),
    b:= Permutation( ~.dim8f5.b, ~.orb19656, OnLines ),
    c:= Permutation( ~.dim8f5.c, ~.orb19656, OnLines ),
    c_t:= Permutation( ~.dim8f5.c_t, ~.orb19656, OnLines ),
    c_tt:= Permutation( ~.dim8f5.c_tt, ~.orb19656, OnLines ),
    gamma:= Permutation( ~.dim8f5.gamma, ~.orb19656, OnLines ),
    gamma_t:= Permutation( ~.dim8f5.gamma_t, ~.orb19656, OnLines ),
    ),
  # permutation generators of $M$, $M.2$, $M.3$, $H$, $S$, $S.2$, $S.3$, $G$,
  # of degree $58\,968$
  N:= 19656,
  t_3N:= PermList( Concatenation( [[1..~.N]+2*~.N,[1..~.N],[1..~.N]+~.N] ) ),
  deg58968:= rec(
    a1:= ~.deg19656.a1 * ( ~.deg19656.a1_t^~.t_3N )
                       * ( ~.deg19656.a1_tt^(~.t_3N^2) ),
    a2:= ~.deg19656.a2 * ( ~.deg19656.a2_t^~.t_3N )
                       * ( ~.deg19656.a2_tt^(~.t_3N^2) ),
    b:= PermList( Concatenation( ListPerm( ~.deg19656.b ),
                      ListPerm( ~.deg19656.b * ~.deg19656.gamma ) + 2*~.N,
                      ListPerm( ~.deg19656.b * ~.deg19656.gamma
                                             * ~.deg19656.gamma_t ) + ~.N ) ),
    t:= ~.t_3N,
    c:= ~.deg19656.c * ( ~.deg19656.c_t^(~.t_3N) )
                     * ( ~.deg19656.c_tt^(~.t_3N^2) ),
    ),
  # one block in the degree $58\,968$ permutation representation for $H$,
  # which yields a degree $405$ representation of $H$
  seed405:= [1,2,3,4,5,6,7,8,9,10,15,28,37,38,39,40,45,58,87,132,157,158,
             159,160,165,178,207,252,397,662,807,4032,7257,7258,7259,7260,
             7265,7278,7307,7352,7497,7762,8507,9732,13457,13458,13459,
             13460,13461,13474,13487,13532,13577,13842,14107,15332],
  # the permutation character of $G$ on the cosets of $H$, restricted to $H$,
  # the ordering of classes corresponds to that in the GAP library table
  # with identifier "O8+(2).3.2"
  pi:= [51162109375,69375,1259375,69375,568750,1750,4000,375,135,975,135,625,
        150,650,30,72,80,72,27,27,3,7,25,30,6,12,25,484375,1750,375,375,30,
        40,15,15,15,6,6,3,3,3,157421875,121875,4875,475,75,3875,475,13000,
        1750,300,400,30,60,15,15,15,125,10,30,4,8,6,9,7,5,6,5],
  );;


#############################################################################
##
#E

