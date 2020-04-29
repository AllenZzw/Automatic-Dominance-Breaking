int: n;         % number of items
int: W;         % weight limit
bool: dominance; 

array [1..n] of int: w;          % weight of each item
array [1..n] of int: v;          % value of each item
% array[1..n] of int: sortedidx; 

array [1..n] of var 0..1: x;  
int: totalValue = sum(v);
var 0..totalValue: objective;

constraint sum (i in 1..n) (w[i]*x[i]) <= W;
constraint sum (i in 1..n) (v[i]*x[i]) >= objective;

% Dominance breaking constraints
constraint dominance -> forall (i, j in 1..n where i < j) (
	if (v[j] <= v[i] /\ w[j] >= w[i]) then
	  x[i] >= x[j]
	else 
		if (v[i] <= v[j] /\ w[i] >= w[j]) then
			x[j] >= x[i]
		else true endif
	endif
);

solve 
%   :: int_search([ x[sortedidx[i]]| i in 1..n ], input_order, indomain_max)
maximize objective;
