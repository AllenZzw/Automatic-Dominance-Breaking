int: W; % capacity weight 
int: n; % number of items 
int: t; % number of conflicts 
bool: dominance; 

array[1..n] of int: w; % weights of items 
array[1..n] of int: v; % values of items 
array[1..t, 1..2] of int: conflict; 
array[1..n] of int: sortedidx; 

array[1..n] of var 0..1: x; 
var int: objective; 

constraint sum (i in 1..n) (w[i]*x[i]) <= W;
constraint sum (i in 1..n) (v[i]*x[i]) >= objective;

% disjunctive constraints 
constraint forall(i in 1..t)( x[ conflict[i, 1] ] + x[ conflict[i, 2] ] <= 1 );

% Dominance breaking constraints
array [1..n] of var bool: allowed;  
constraint dominance -> forall (i in 1..n) (
  allowed[i] = not( exists(k in 1..t where conflict[k, 1] = i)( x[conflict[k, 2]] = 1 ) \/ exists(k in 1..t where conflict[k, 2] = i)( x[conflict[k, 1]] = 1 ) )
);
constraint dominance -> forall (i, j in 1..n where i < j) (
	if (v[j] <= v[i] /\ w[j] >= w[i]) then
		allowed[i] -> x[i] >= x[j]
	else 
		if (v[i] <= v[j] /\ w[i] >= w[j]) then
			allowed[j] -> x[j] >= x[i]
		else 
			true 
		endif
	endif
);

solve 
  :: int_search([ x[sortedidx[i]]| i in 1..n ], input_order, indomain_max)
maximize objective;

