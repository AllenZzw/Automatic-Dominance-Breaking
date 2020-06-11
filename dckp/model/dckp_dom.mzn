int: n;         % number of items
int: W;         % weight limit
int: t;         % number of conflicts 

array [1..n] of int: w;          % weight of each item
array [1..n] of int: v;          % value of each item
array[1..t, 1..2] of int: conflict; % conflict 
array[1..n] of int: sortedidx; 

int: var_no; % number of fixed variables 

array [1..var_no] of var 1..n: fixed_index;
array [1..var_no] of var 0..1: assign_value_1;
array [1..var_no] of var 0..1: assign_value_2; 

array [1..n] of var 0..var_no: fixed; 

% channeling constraint 
constraint forall(i in 1..var_no)( fixed[fixed_index[i]] = i);
constraint forall(i in 1..n)( fixed[i] = 0 <-> forall(l in 1..var_no)( fixed_index[l] != i)); 

include "globals.mzn";
constraint alldifferent(fixed_index); 
constraint increasing(fixed_index); 

constraint sum(t in 1..var_no)( w[fixed_index[t]] * assign_value_1[t] ) <=  sum(t in 1..var_no)( w[fixed_index[t]] * assign_value_2[t] ); 

array [1..t] of var 0..1: remain1;  
array [1..t] of var 0..1: remain2; 
constraint forall(i in 1..t)(remain1[i] <= remain2[i]); 
constraint forall(i in 1..t)(
  ( (fixed[conflict[i, 1]] != 0 /\ fixed[conflict[i, 2]] != 0) \/ (fixed[conflict[i, 1]] = 0 /\ fixed[conflict[i, 2]] = 0) ) -> (remain1[i] = 0 /\ remain2[i] = 0)
);
constraint forall(i in 1..t)(
  (fixed[conflict[i, 1]] != 0 /\ fixed[conflict[i, 2]] != 0) -> (assign_value_1[fixed[conflict[i, 1]]] + assign_value_1[fixed[conflict[i, 2]] ] <= 1 /\ assign_value_2[ fixed[conflict[i, 1]] ] + assign_value_2[ fixed[conflict[i, 2]] ] <= 1)
);
constraint forall(i in 1..t)(
  (fixed[conflict[i, 1]] != 0 /\ fixed[conflict[i, 2]] = 0) -> ( remain1[i] = assign_value_1[fixed[conflict[i, 1]]] /\ remain2[i] = assign_value_2[fixed[conflict[i, 1]]] )
);
constraint forall(i in 1..t)(
  (fixed[conflict[i, 1]] = 0 /\ fixed[conflict[i, 2]] != 0) -> ( remain1[i] = assign_value_1[fixed[conflict[i, 2]]] /\ remain2[i] = assign_value_2[fixed[conflict[i, 2]]] )
);

constraint lex_less( [-sum(t in 1..var_no)( v[fixed_index[t]] * assign_value_1[t] ), sum(t in 1..var_no)( w[fixed_index[t]] * assign_value_1[t] )] ++ assign_value_1, [-sum(t in 1..var_no)( v[fixed_index[t]] * assign_value_2[t] ), sum(t in 1..var_no)( w[fixed_index[t]] * assign_value_2[t] )] ++ assign_value_2 );

output ["constraint "] ++ [ "x[\(fixed_index[i])] = \(assign_value_2[i])" ++ if i != var_no then " /\\ " else "" endif | i in 1..var_no] ++ [" -> false;\n"]; 
output ["constraint "] ++ [ "fixed[\(fixed_index[i])] = 0" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [" \\/ "] ++ ["assign_value_2[fixed[\(fixed_index[i])]] != \(assign_value_2[i] )" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [";\n"];

solve satisfy;
