ansible-playbook -i inventory.ini ./ansible/master.yml
ssh -i ~/.ssh/gcp_vm_key_nopass terraform-user@130.211.99.33
ssh -i ~/.ssh/gcp_vm_key_nopass -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/gcp_vm_key_nopass terraform-user@35.195.241.125" terraform-user@10.10.0.5
ssh-keygen -R 10.10.0.5
gcloud compute ssh master-node

ssh -i /home/terraform-user/.ssh/gcp_vm_key_nopass terraform-user@34.77.148.49

# Pour lire TOUS les fichiers du répertoire à la suite
hdfs dfs -cat /output/part*

# Ou fusionne tous les fichiers de sortie en un seul fichier local
hdfs dfs -getmerge /output resultat_final.txt

sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config