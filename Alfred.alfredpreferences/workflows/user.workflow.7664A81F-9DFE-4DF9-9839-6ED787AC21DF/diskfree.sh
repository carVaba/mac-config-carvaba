HARDDRIVES=$(df -H | grep G | awk '{printf ($1)}' )
CAPACITIES=$(df -H | grep G | awk '{printf ($2)}' )
AVAILABLE=$(df -H | grep G | awk '{printf ($4)}' )

IFS='G' read -ra ARR_AVAILABLE <<< "$AVAILABLE"
IFS='G' read -ra ARR_CAPACITIES <<< "$CAPACITIES"

echo "<?xml version='1.0'?>"
echo "<items>"
	for ((i=0; i < ${#ARR_AVAILABLE[@]}; i++)); do
		echo "<item>"
    		echo "<title>${ARR_AVAILABLE[$i]}GB Free space</title>"
			echo "<subtitle>${ARR_CAPACITIES[$i]}GB Total space</subtitle>"
			echo "<icon>hdd.png</icon>"
  		echo "</item>"
	done	
echo "</items>"