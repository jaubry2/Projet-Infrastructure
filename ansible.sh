#!/bin/bash

echo "Début du script : $(date +'%H:%M:%S')"
echo "----------------------------------------"

echo "Initialisation et application de Terraform..."
cd ./terraform || { echo "Dossier /terraform non trouvé"; exit 1; }
terraform init
terraform apply -auto-approve
cd ..
sleep 45
echo "Fin de l'archi : $(date +'%H:%M:%S')"
echo "----------------------------------------"
echo "Suppression des hosts connus..."
rm -rf ~/.ssh/known_hosts
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

echo "Fin des playbook : $(date +'%H:%M:%S')"
echo "----------------------------------------"

echo "Attente de 10 secondes pour la stabilisation des services..."
sleep 10

gcloud compute ssh master-node \
    --zone=europe-west1-b \
    --quiet \
    --command="source /home/newsletters_box149_gmail_com/.bashrc && bash -l /home/newsletters_box149_gmail_com/wordcount/scale-subject/start.sh"

echo "----------------------------------------"
echo "Déploiement terminé."
echo "Heure de fin : $(date +'%H:%M:%S')"