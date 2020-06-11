include "globals.mzn";

int: num_offers;
int: num_halls;

set of int: Offer = 1..num_offers;
set of int: Hall = 1..num_halls;
set of int: Hall0 = 0..num_halls;

array [Offer] of int: start;
array [Offer] of int: end;
array [Offer] of int: price;

set of int: Time = min(start)..max(end);

function bool: overlaps(Offer: o, Time: t) = start[o] <= t /\ t < end[o];
array [Offer] of set of Offer: cliques = [ { p | p in Offer where overlaps(p, start[o]) } | o in Offer ];
function bool: clique_is_maximal(Offer: o) = forall(o1 in Offer where o < o1 /\ card(cliques[o]) <= card(cliques[o1]) ) ( not (cliques[o]  subset cliques[o1]) ); 
function bool: clique_is_maximal(set of Offer: c) = forall (d in cliques where card(d) > card(c)) (not (c subset d));

array [Hall] of int: capacity;
array [Offer] of int: requirement;

int: var_no; 
array [1..var_no] of var Offer: fixed_index;
array [1..var_no] of var Hall0: x1; 
array [1..var_no] of var Hall0: x2;

array [Offer] of var 0..var_no: fixed; 

% channeling constraint 
constraint forall(i in 1..var_no)( fixed[fixed_index[i]] = i);
constraint forall(i in Offer)( fixed[i] = 0 <-> forall(l in 1..var_no)( fixed_index[l] != i));
constraint alldifferent(fixed_index);
constraint increasing(fixed_index);

% dominance condition for alldifferent_except_0
constraint forall(clique in cliques where clique_is_maximal(clique), i in 1..var_no) ( (fixed_index[i] in clique /\ x1[i] != 0)-> exists(j in 1..var_no)( fixed_index[j] in clique /\ x1[i] = x2[j] )  ); 
constraint forall(clique in cliques where clique_is_maximal(clique), i, j in 1..var_no where i < j)( (fixed_index[i] in clique /\ fixed_index[j] in clique) ->  (x1[i] = 0 \/ x1[j] = 0 \/ x1[i] != x1[j]) );
constraint forall(clique in cliques where clique_is_maximal(clique), i, j in 1..var_no where i < j)( (fixed_index[i] in clique /\ fixed_index[j] in clique) -> (x2[i] = 0 \/ x2[j] = 0 \/ x2[i] != x2[j]) ); 

%% Overlapping events cannot share a hall.
function set of Hall: feasible_halls(Offer: o) = { h | h in Hall where capacity[h] >= requirement[o] };
array[Offer] of set of Hall: fh = [ feasible_halls(o) | o in Offer ];

constraint forall(i in 1..var_no, o in Offer)( fixed_index[i] = o -> x1[i] in {0} union fh[o] );
constraint forall(i in 1..var_no, o in Offer)( fixed_index[i] = o -> x2[i] in {0} union fh[o] );

solve satisfy; 

constraint lex_less([-sum(i in 1..var_no)( price[fixed_index[i]] * (x1[i] > 0) )] ++ x1, [-sum(i in 1..var_no)( price[fixed_index[i]] * (x2[i] > 0) )] ++ x2); 

output ["constraint "] ++ [ "assign[\(fixed_index[i])] = \(x2[i]) " ++ if i != var_no then " /\\ " else "" endif | i in 1..var_no] ++ ["-> false;\n"];
output ["constraint "] ++ [ "fixed[\(fixed_index[i])] = 0" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [" \\/ "] ++ ["x2[fixed[\(fixed_index[i])]] != \(x2[i] )" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [";\n"];