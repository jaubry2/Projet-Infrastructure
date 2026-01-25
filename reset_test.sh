#!/bin/bash
set -euo pipefail

start=$(date +%s)

(
  cd terraform_edge
  terraform destroy -auto-approve
)

(
  cd terraform_bigdata_cluster
  terraform destroy -auto-approve
  terraform apply -auto-approve
)

end=$(date +%s)
runtime=$((end - start))
echo "Durée totale : ${runtime}s"
start=$(date +%s)

(
  cd terraform_edge
  terraform apply -auto-approve
)


end=$(date +%s)
runtime=$((end - start))
echo "Durée totale : ${runtime}s"

echo "****** petite pause de 60s avant d'entamer les playbooks Ansible, ne pas quitter ******"
sleep 60

./ansible.sh

sleep 60

(
gcloud compute ssh edge \
    --zone=us-central1-a \
    --project=front-edge-482211 \
    --quiet \
    --command="source /home/front/.bashrc && cd /home/front/scale-subject && source generates.sh filesample.txt 23 && source copy.sh && source comp.sh && source run.sh && hdfs dfs -cat /output/*"
)
