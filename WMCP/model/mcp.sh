case $1 in
	1)
	    for file in data/wmcp-35-0.10-10-*.dzn
		do
			python3 -u mcp-evaluate.py mcp.mzn mcp_dom.mzn $file 5 3600000 result/35-result.txt
		done
    ;;
    2)
		for file in data/wmcp-40-0.10-10-*.dzn
		do
			python3 -u mcp-evaluate.py mcp.mzn mcp_dom.mzn $file 5 3600000 result/40-result.txt
		done
	;;
	3)
		for file in data/wmcp-45-0.10-10-*.dzn
		do
			python3 -u mcp-evaluate.py mcp.mzn mcp_dom.mzn $file 5 3600000 result/45-result.txt
		done
	;;
	4)
		for file in data/wmcp-50-0.10-10-*.dzn
		do
			python3 -u mcp-evaluate.py mcp.mzn mcp_dom.mzn $file 5 3600000 result/50-result.txt
		done
	;;
  	*)
    	echo -n "usage: bash mcp.sh [case]"
    ;;
esac



		


		

		
