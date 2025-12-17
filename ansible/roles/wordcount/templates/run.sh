
hdfs dfs -rm /output/*
hdfs dfs -rmdir /output
spark-submit --class WordCount --master spark://{{namenode_ip}}:7077 wc.jar hdfs://{{namenode_ip}}:9000/input hdfs://{{namenode_ip}}:9000/output
