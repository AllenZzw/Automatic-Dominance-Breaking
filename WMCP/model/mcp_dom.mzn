int: n; % number of varialbe 
int: m; % number of clauses 
array [1..m] of int: w; % weights of all clauses 
array [1..m, 1..2] of 1..n: edges; 

int: var_no; 

array [1..var_no] of var 1..n: fixed_index;
array [1..var_no] of var 0..1: value_1;
array [1..var_no] of var 0..1: value_2; 

array [1..n] of var 0..var_no: fixed; 

% channeling constraint 
constraint forall(i in 1..var_no)( fixed[fixed_index[i]] = i);
constraint forall(i in 1..n)( fixed[i] = 0 <-> forall(l in 1..var_no)( fixed_index[l] != i)); 

include "globals.mzn";
constraint alldifferent(fixed_index); 
constraint increasing(fixed_index);

constraint forall(i in 1..var_no)( value_1[i] = 1 -> value_2[i] = 1 ); 

function var int: partial_objective(array [1..var_no] of var 1..n: fixed_index, array [1..var_no] of var 0..1: value ) = 
  let { array[1..n] of var 0..1: represented_set = [ exists(j in 1..var_no)(fixed_index[j] = i /\ value[j] = 1)  | i in 1..n ];  } 
  in sum(i in 1..m)( bool2int( represented_set[edges[i, 1]] != represented_set[edges[i, 2]] ) * w[i]); 

constraint lex_greater([partial_objective(fixed_index, value_1)] ++ value_1, [partial_objective(fixed_index, value_2)]++value_2);

output ["constraint "] ++ [ "x[\(fixed_index[i])] = \(value_2[i])" ++ if i != var_no then " /\\ " else "" endif | i in 1..var_no] ++ [" -> false;\n"]; 

output ["constraint "] ++ [ "fixed[\(fixed_index[i])] = 0" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [" \\/ "] ++ ["value_2[fixed[\(fixed_index[i])]] != \(value_2[i] )" ++ if i != var_no then " \\/ " else "" endif | i in 1..var_no ] ++ [";\n"];

solve :: int_search(fixed_index ++ value_2 ++ value_1, input_order, indomain_min ) satisfy; 