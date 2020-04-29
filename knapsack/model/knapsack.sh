case $1 in
	1)
	    for file in data/knapsack-100-*.dzn
		do
			python3 -u knapsack-evaluate.py chuffed knapsack.mzn knapsack_dom.mzn $file 4 3600000 ../logs/knapsack-100-result.txt
		done
    ;;
    2)
		for file in data/knapsack-150-*.dzn
		do
			python3 -u knapsack-evaluate.py chuffed knapsack.mzn knapsack_dom.mzn $file 4 3600000 ../logs/knapsack-150-result.txt
		done
    ;;
    3)
		for file in data/knapsack-200-*.dzn
		do
			python3 -u knapsack-evaluate.py chuffed knapsack.mzn knapsack_dom.mzn $file 4 3600000 ../logs/knapsack-200-result.txt
		done
	;;
	4)
		for file in data/knapsack-250-*.dzn
		do
			python -u knapsack-evaluate.py chuffed knapsack.mzn knapsack_dom.mzn $file 4 3600000 ../logs/knapsack-250-result.txt
		done
    ;;
    5)
		for file in data/knapsack-300-*.dzn
		do
			python -u knapsack-evaluate.py chuffed knapsack.mzn knapsack_dom.mzn $file 4 3600000 ../logs/knapsack-300-result.txt
		done
	;;
	*)
    	echo -n "usage: bash knapsack.sh [case]"
    ;;
esac