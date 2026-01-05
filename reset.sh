cd terraform_edge/ && terraform destroy -auto-approve \
&& cd ../terraform_bigdata_cluster && terraform destroy -auto-approve \
&& terraform apply -auto-approve \
&& cd ../terraform_edge && terraform apply -auto-approve \
&& cd .. && sleep 65 && echo "******petite pause de 65s avant d'entamer les playbook ansibles, ne pas quitter.******" && ./ansible.sh
