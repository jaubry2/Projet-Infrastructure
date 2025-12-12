resource "local_file" "ansible_inventory" {
  filename = "../inventory.ini"
  content  = <<-EOT
[master]
${google_compute_instance.nodes["master"].name} ansible_host=${google_compute_instance.nodes["master"].network_interface[0].access_config[0].nat_ip}

[workers]
${google_compute_instance.nodes["worker"].name} ansible_host=${google_compute_instance.nodes["worker"].network_interface[0].access_config[0].nat_ip}

[edge]
${google_compute_instance.nodes["edge"].name} ansible_host=${google_compute_instance.nodes["edge"].network_interface[0].access_config[0].nat_ip}

[all:vars]
ansible_user=${var.ssh_user}
ansible_ssh_private_key_file=${replace(var.ssh_pub_key, ".pub", "")}
EOT
}