
rm -rf /tmp/hadoop*
ssh {{datanodes_ips.split(",")[0]}} rm -rf /tmp/hadoop*
ssh {{datanodes_ips.split(",")[1]}} rm -rf /tmp/hadoop*

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh

