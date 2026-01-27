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

echo "Fin du lancement des playbooks : $(date +'%H:%M:%S')"