#!/bin/bash
echo "Lancement des playbooks en parallèle..."

rm /home/joshuajn02/.ssh/known_hosts

# Lancer la configuration du Master
cd ansible_bigdata_cluster
ansible-playbook ./master.yml &
PID1=$!

# Lancer la configuration de l'Edge Node
cd ../ansible_edge
ansible-playbook ./edge.yml &
PID2=$!

# Lancer la configuration des Workers
cd ../ansible_bigdata_cluster
ansible-playbook ./workers.yml &
PID3=$!

# Attendre la fin des trois processus
wait $PID1 $PID2 $PID3

cd ..

gcloud compute ssh master-hdfs-spark \
    --zone=us-central1-a \
    --project=cluster-spark-482013 \
    --quiet \
    --command="source /home/bigdata/.bashrc && /home/bigdata/scale-subject/start.sh && jps && hdfs dfsadmin -report"

echo "Déploiement terminé."
