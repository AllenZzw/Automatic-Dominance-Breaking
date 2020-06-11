int: n; % number of varialbe 
int: m; % number of clauses 
array [1..m] of int: w; % weights of all clauses 
array [1..m, 1..2] of 1..n: edges; 

array [1..n] of var 0..1: x; % assignment of node for source part or sink part 
bool: dominance; 

var int: objective; 

constraint objective = sum(i in 1..m)( bool2int(x[edges[i, 1]] != x[edges[i, 2]]) * w[i] );

solve 
:: int_search(x, input_order, indomain_min)
maximize objective;