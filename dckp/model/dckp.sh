case $1 in
	1)
		for file in data/knapsack-100-*.dzn
		do
			python3 -u dckp-evaluate.py chuffed dckp.mzn dckp_dom.mzn $file 4 3600000 result/dckp-100-result.txt
		done
	;;
	2)
		for file in data/knapsack-150-*.dzn
		do
			python3 -u dckp-evaluate.py chuffed dckp.mzn dckp_dom.mzn $file 4 3600000 result/dckp-150-result.txt
		done
	;;
	3)
		for file in data/knapsack-200-*.dzn
		do
			python3 -u dckp-evaluate.py chuffed dckp.mzn dckp_dom.mzn $file 4 3600000 result/dckp-200-result.txt
		done
	;;
	4)
		for file in data/knapsack-250-*.dzn
		do
			python3 -u dckp-evaluate.py chuffed dckp.mzn dckp_dom.mzn $file 4 3600000 result/dckp-250-result.txt
		done
	;;
	5)
		for file in data/knapsack-300-*.dzn
		do
			python3 -u dckp-evaluate.py chuffed dckp.mzn dckp_dom.mzn $file 4 3600000 result/dckp-300-result.txt
		done
	;;
  	*)
    	echo -n "usage: bash dckp.sh [case]"
    ;;
esac

