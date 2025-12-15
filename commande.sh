ansible-playbook -i inventory.ini ./ansible/master.yml
ssh -i ~/.ssh/gcp_vm_key_nopass terraform-user@34.76.173.135
ssh -i ~/.ssh/gcp_vm_key_nopass -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/gcp_vm_key_nopass terraform-user@34.76.173.135" terraform-user@10.10.0.5