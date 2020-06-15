int: n; % number of varialbe 
int: m; % number of edges  
array [1..m] of int: w; % weights of all edges 
array [1..m, 1..2] of 1..n: edges; 

array [1..n] of var 0..1: x; % assignment of node for source part or sink part 
bool: dominance; 

var int: objective; 

constraint objective = sum(i in 1..m)( bool2int(x[edges[i, 1]] != x[edges[i, 2]]) * w[i] );

% dominance breaking 
array [1..m+1] of int: w0 = w ++ [0]; 
function int: weight(int: v1, int: v2) = w0[min([m+1] ++ [ i | i in 1..m where (edges[i, 1] = v1 /\ edges[i, 2] = v2) \/ (edges[i, 1] = v2 /\ edges[i, 2] = v1) ])];
array[1..n, 1..n] of int: deg_matrix = array2d(1..n, 1..n, [ weight(i, j) | i, j in 1..n]);
array[1..n] of int: degree = [ sum(j in 1..n)( deg_matrix[i, j]) | i in 1..n ];
constraint dominance -> ( 
  forall(i, j in 1..n where i < j)(
    if (degree[i] > degree[i] + degree[j] - 2* weight(i, j) \/ degree[j] > degree[j] + degree[i] - 2* weight(i, j)) then 
      x[i] != 1 \/ x[j] != 1
    endif
  )
); 

solve 
:: int_search(x, input_order, indomain_min)
maximize objective;