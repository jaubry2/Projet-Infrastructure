# Spark Cluster Deployment
---
### Deployment Architecture
---
Provision the network resources and virtual machines.
```
# bash
./terraform.sh 
```

### Deploy Dependencies and Libraries
---
Execute the Ansible playbooks to configure the environment.
```
# bash
./ansible.sh
```

### Start Daemons on Instances
---
Launch the background services (daemons) on the remote instances.
```
# bash
./daemon.sh
```

### Run All Scripts
---
Execute all deployment scripts simultaneously (or sequentially).
```
# bash
./all.sh
```