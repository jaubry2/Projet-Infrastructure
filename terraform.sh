echo "Initialisation et déploiement de Terraform..."
cd ./terraform || { echo "Dossier /terraform non trouvé"; exit 1; }
terraform init
terraform apply -auto-approve
cd ..
echo "Fin du déploiement de l'architecture"