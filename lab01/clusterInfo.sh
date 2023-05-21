# Amount of nodes in the cluster
numNodes=$(pbsnodes -a | awk '/^s/{count++} END{print count}')
echo "Number of nodes in the cluster: $numNodes"

# Amount of nodes with the same number of cores
echo "Nodes with the same number of cores:"
pbsnodes -a | awk '/np =/{print $3}' | sort | uniq -c | awk '{printf "%d nodes with %d cores\n", $1, $2}'

# Amount of nodes with the same amount of memory
echo "Nodes with the same amount of memory:"
pbsnodes -a | awk '/physmem =/{print $10}' | sort | uniq -c | awk '{printf "%d nodes with %d GB of memory\n", $1, $2/$3}'

# Calculate the average amount of memory per core
n_p=$(pbsnodes -x | sed 's/<Node>/\n/g' | grep -o '<np>.*</np>' | cut -d'>' -f2 | cut -d'<' -f1 | tr '\n' ' ' | awk '{sum = 0; for (i=1; i<=NF; i++) {sum+=$i} print sum}')
totMemGb=$(pbsnodes -x | sed 's/<Node>/\n/g' | grep -o '<status>.*</status>' | grep -o 'totmem=.*' | cut -d',' -f1 | cut -d'=' -f2 | sed 's/kb//g' | tr '\n' ' ' | awk '{sum = 0; for (i=1; i<=NF; i++) {sum+=$i}; print sum/(1024*1024)}')
memPerProc=$(echo $totMemGb $n_p | awk '{print $1/$2}')
echo "The average amount of memory per proc is $memPerProc GB"

# Count the number of GPUs in the cluster
numGpus=$(pbsnodes -a | awk '/gpus =/{sum += $3} END {print sum}')
echo "There are $numGpus GPUs on the cluster"
