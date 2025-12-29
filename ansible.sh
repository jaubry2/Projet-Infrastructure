#!/bin/bash
echo "Lancement des playbooks en parallèle..."

# Lancer la configuration du Master
ansible-playbook -i inventory.ini ./ansible/master.yml &
PID1=$!

# Lancer la configuration de l'Edge Node
ansible-playbook -i inventory.ini ./ansible/edge.yml &
PID2=$!

# Lancer la configuration des Workers
ansible-playbook -i inventory.ini ./ansible/workers.yml &
PID3=$!

# Attendre la fin des trois processus
wait $PID1 $PID2 $PID3

gcloud compute ssh master-node \
    --zone=europe-west1-b \
    --quiet \
    --command="source /home/newsletters_box149_gmail_com/.bashrc && bash -l /home/newsletters_box149_gmail_com/wordcount/scale-subject/start.sh"

echo "Déploiement terminé."