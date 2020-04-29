import sys
import os, re
import time, random
import subprocess, ast, string 
from functools import reduce
import numpy as np

MiniZinc_path = "~/MiniZinc/bin/minizinc"

def solve_model(command, dom=False, dom_model=None, tmp_model=None):
	filter_constraints = []
	dom_nogoods = []
	solving_stat = {}
	result_str = subprocess.check_output(command, shell=True).decode()
	for line in filter(None, result_str.splitlines()): 
		line = str(line)
		m = re.match(r'\%\%\%mzn-stat: (.*)=(.*)', line) 
		if m:
			solving_stat[m.group(1)] = m.group(2)
		elif dom and 'constraint' in line: 
			if 'fixed' in line: 
				filter_constraints.append(line+'\n')
			else:
				dom_nogoods.append(line+'\n') 
	if tmp_model: 
		with open(tmp_model, 'a') as fh:
			fh.writelines(dom_nogoods) 
	if dom_model: 
		with open(dom_model, 'a') as fh:
			fh.writelines(filter_constraints) 

	return solving_stat

if __name__ == '__main__': 
	solving_timeout = 600000
	datafile = ''
	fix_var_no = 0
	solving_stats = {}
	if len(sys.argv) > 7: 
		solver = sys.argv[1]
		modelfile = sys.argv[2]
		dommodelfile = sys.argv[3]
		datafile = sys.argv[4]
		fix_var_no = int(sys.argv[5])
		solving_timeout = int(sys.argv[6])
		result_file = sys.argv[7]
	else:
		exit("Usage: python knapsack-evaluate.py [solver] [solving model] [dominance model file] [data file] [fix variable number] [solving timeout] [nogood timeout] [result file]")

	tmp_data = ''.join(random.choice(string.ascii_lowercase) for i in range(10)) + '.dzn'
	with open(tmp_data, 'w') as fh: 
		v, w = [], [] 
		for line in open(datafile).readlines(): 
			if line != '\n': 
				fh.write(line)
				n = [int(s) for s in re.findall(r'\d+', line)][0] 
			if "v = " in line: 
				v = np.array(ast.literal_eval( line[line.find('['):line.find(']')+1] ), dtype=float)
			if "w = " in line: 
				w = np.array(ast.literal_eval( line[line.find('['):line.find(']')+1] ), dtype=float)
		fh.write("sortedidx = " + str((np.argsort(v/w)+1).tolist()) + ';\n')

	solving_stats["Model with manual Dominance"] = solve_model("%s --solver %s -s --time-limit %d %s %s -D 'dominance=true;' 2>&1" %(MiniZinc_path, solver, solving_timeout, modelfile, tmp_data))
	solving_stats["Model without without Dominance"] = solve_model("%s --solver %s -s --time-limit %d %s %s -D 'dominance=false;' 2>&1" %(MiniZinc_path, solver, solving_timeout, modelfile, tmp_data))

	tmp_model = 'tmp-' + ''.join(random.choice(string.ascii_lowercase) for i in range(10)) + '.mzn'
	dom_model = 'dom-' + ''.join(random.choice(string.ascii_lowercase) for i in range(10)) + '.mzn'
	with open(tmp_model, 'w') as fh: 
		for line in open(modelfile).readlines(): 
			if line != '\n': 
				fh.write(line)
	with open(dom_model, 'w') as fh: 
		for line in open(dommodelfile).readlines(): 
			if line != '\n': 
				fh.write(line)

	nogood_generation_time = []
	remain_time = solving_timeout
	for i in range(2, fix_var_no+1):
		command = "%s -a --solver %s -s --time-limit %d --soln-sep '' --unsat-msg '' --search-complete-msg '' %s %s -D 'var_no=%d;' 2>&1" %(MiniZinc_path, solver, remain_time, dom_model, tmp_data, i)
		solving_stats["Length-%d NoGood detection" %(i) ] = solve_model(command, True, dom_model, tmp_model)
		try:
			remain_time = remain_time - float(solving_stats["Length-%d NoGood detection" %(i) ]['time']) * 1000
		except:
			remain_time = 1000 
		command = "%s --solver %s -s --time-limit %d %s %s -D 'dominance=false;' 2>&1" %(MiniZinc_path, solver, remain_time, tmp_model, tmp_data)
		solving_stats["Model with length-%d NoGoods" %(i) ] = solve_model(command)
		
	os.remove(tmp_model)
	os.remove(dom_model)
	os.remove(tmp_data)

	keys = ["flatBoolConstraints","flatTime","evaluatedReifiedConstraints","flatIntVars","solveTime","propagators","variables","boolVariables","baseMem","backjumps","trailMem","flatIntConstraints","time","flatBoolVars","nogoods","optTime","initTime","method","failures","paths","objective","restarts","eliminatedImplications","randomSeed","intVars","nSolutions","evaluatedHalfReifiedConstraints","peakMem","propagations","peakDepth","nodes"]
	if not os.path.exists(result_file):
		with open(result_file, 'a') as fh:
			fh.write(','.join( ['Instance', 'Model'] + keys) + '\n') 
			
	with open(result_file, 'a') as fh:
		for key in solving_stats:
			fh.write(','.join([datafile ,key] + [solving_stats[key][k] if k in solving_stats[key] else ' ' for k in keys]) + '\n')
	
	