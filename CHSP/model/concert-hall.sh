case $1 in
	1)
		for file in data/concert-20-100-1000-*.dzn; do
			python3 -u concert-hall-evalutate.py concert-hall-no-sym.mzn concert-hall-dom.mzn "$file" 4 3600000 result/20-no-sym-result.txt	
		done 
	;;
	2) 
		for file in data/concert-25-100-1000-*.dzn; do
			python3 -u concert-hall-evalutate.py concert-hall-no-sym.mzn concert-hall-dom.mzn "$file" 4 3600000 result/25-no-sym-result.txt	
		done
	;;
	3) 
		for file in data/concert-30-100-1000-*.dzn; do
			python3 -u concert-hall-evalutate.py concert-hall-no-sym.mzn concert-hall-dom.mzn "$file" 4 3600000 result/30-no-sym-result.txt	
		done
	;;
	4) 
		for file in data/concert-35-100-1000-*.dzn; do
			python3 -u concert-hall-evalutate.py concert-hall-no-sym.mzn concert-hall-dom.mzn "$file" 4 3600000 result/35-no-sym-result.txt	
		done
	;;
	5) 
		for file in data/concert-40-100-1000-*.dzn; do
			python3 -u concert-hall-evalutate.py concert-hall-no-sym.mzn concert-hall-dom.mzn "$file" 4 3600000 result/40-no-sym-result.txt	
		done
	;;
    *)
    	echo -n "usage: bash concert-hall.sh [case]"
    ;;
esac
