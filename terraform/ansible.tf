resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../inventory.ini"
  content  = <<-EOT
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
namenode_ip=${google_compute_instance.nodes["master"].network_interface[0].network_ip}
datanodes_ips=${
    join(",", [
        for key, node in google_compute_instance.nodes : 
        node.network_interface[0].network_ip 
        if startswith(key, "worker")
    ])
}

[master]
${google_compute_instance.nodes["master"].name} ansible_host=${google_compute_instance.nodes["master"].network_interface[0].access_config[0].nat_ip} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${replace(var.ssh_pub_key, ".pub", "")}

[edge]
${google_compute_instance.nodes["edge"].name} ansible_host=${google_compute_instance.nodes["edge"].network_interface[0].access_config[0].nat_ip} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${replace(var.ssh_pub_key, ".pub", "")}

[workers]
%{ for key, node in google_compute_instance.nodes ~}
%{ if startswith(key, "worker") }
${node.name} ansible_host=${
    # LOGIQUE DE SÉLECTION DE L'IP :
    # Si la longueur de access_config est > 0 (il y a une IP publique), on utilise nat_ip.
    # Sinon (IP publique absente), on utilise network_ip (IP Privée).
    length(node.network_interface[0].access_config) > 0 ? "${node.network_interface[0].access_config[0].nat_ip} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${replace(var.ssh_pub_key, ".pub", "")}" : "${node.network_interface[0].network_ip} ansible_ssh_common_args='-o ProxyCommand=\"ssh -W %h:%p -i ${replace(var.ssh_pub_key, ".pub", "")} ${var.ssh_user}@${google_compute_instance.nodes["master"].network_interface[0].access_config[0].nat_ip}\"' ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${replace(var.ssh_pub_key, ".pub", "")}"
}
%{ endif ~}
%{ endfor ~}

EOT
}