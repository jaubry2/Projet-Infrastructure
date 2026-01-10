export HADOOP_HOME=/opt/hadoop/hadoop-2.7.1
export SPARK_HOME=/opt/spark/spark-2.4.3-bin-hadoop2.7
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin

rm -rf /tmp/hadoop*
{% for ip in datanodes_ips.split(',') %}
ssh {{ ip }} rm -rf /tmp/hadoop*
{% endfor %}

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh

