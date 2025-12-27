resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.ini"
  content  = <<-EOT
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file=${var.my_public_key}
ansible_user=${var.ssh_user}
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
ansible_ssh_common_args='-J ${var.ssh_user}@${google_compute_instance.master.network_interface[0].access_config[0].nat_ip}'


EOT
}
