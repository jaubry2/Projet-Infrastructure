# Spark Cluster Deployment

## Deployment Architecture

Provision the network resources and virtual machines.
```
# bash
./terraform.sh 
```

## Deploy Dependencies and Libraries

Execute the Ansible playbooks to configure the environment.
```
# bash
./ansible.sh
```

## Start Daemons on Instances

Launch the background services (daemons) on the remote instances.
```
# bash
./daemon.sh
```

## Run All Scripts

Execute all deployment scripts simultaneously (or sequentially).
```
# bash
./all.sh
```

## Script on Edge 

You need to connect to the edge node, compile the program, copy the file to HDFS, and start the execution.
```
# bash
gcloud compute ssh edge-node
cd wordcount/scale-subject
./comp.sh
./copy.sh
./run.sh
```

