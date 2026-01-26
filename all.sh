#!/bin/bash

echo "Début du script : $(date +'%H:%M:%S')"
echo "----------------------------------------"
./terraform.sh
echo "----------------------------------------"
sleep 45
./ansible.sh
echo "----------------------------------------"
sleep 10
./daemon.sh
echo "----------------------------------------"
echo "Script terminé : $(date +'%H:%M:%S')"