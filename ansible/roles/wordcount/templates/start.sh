
rm -rf /tmp/hadoop*
ssh -i /home/terraform-user/.ssh/gcp_vm_key_nopass terraform-user@{{datanodes_ips.split(",")[0]}} rm -rf /tmp/hadoop*
ssh -i /home/terraform-user/.ssh/gcp_vm_key_nopass terraform-user@{{datanodes_ips.split(",")[1]}} rm -rf /tmp/hadoop*

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh

