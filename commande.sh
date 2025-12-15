ansible-playbook -i inventory.ini ./ansible/master.yml
ssh -i ~/.ssh/gcp_vm_key_nopass terraform-user@34.78.131.236
ssh -i ~/.ssh/gcp_vm_key_nopass -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/gcp_vm_key_nopass terraform-user@34.78.131.236" terraform-user@10.10.0.5
ssh-keygen -R 10.10.0.5

ssh -i /home/terraform-user/.ssh/gcp_vm_key_nopass terraform-user@34.77.148.49

