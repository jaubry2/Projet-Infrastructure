resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible_bigdata_cluster/inventory.ini"
  content  = <<-EOT
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file=${replace(var.my_public_key, ".pub", "")}
ansible_user="josua_jerrynithiyendra02_gmail_c"
namenode_ip=${google_compute_instance.master.network_interface[0].network_ip}
datanodes_ips=${
    join(",", [
        for worker in google_compute_instance.workers : 
        worker.network_interface[0].network_ip
    ])
}


[master]
${google_compute_instance.master.name} ansible_host=${google_compute_instance.master.network_interface[0].access_config[0].nat_ip}  

[workers]
%{ for worker in google_compute_instance.workers ~}
${worker.name} ansible_host=${worker.network_interface[0].network_ip}
%{ endfor ~}


[workers:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -i ${replace(var.my_public_key, ".pub", "")} josua_jerrynithiyendra02_gmail_c@${google_compute_instance.master.network_interface[0].access_config[0].nat_ip}"'

EOT
}
