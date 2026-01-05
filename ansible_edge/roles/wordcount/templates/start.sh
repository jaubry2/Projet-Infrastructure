IFS=',' read -ra NODES <<< "{{ datanodes_ips }}"

for node in "${NODES[@]}"; do
    ssh "$node" "rm -rf /tmp/hadoop*"
done

rm -rf /tmp/hadoop*

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh

