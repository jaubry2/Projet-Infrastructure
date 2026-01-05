data "local_file" "inventory_bigdata" {
  filename = "${path.module}/../ansible_bigdata_cluster/inventory.ini"
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible_edge/inventory.ini"
  content  = <<-EOT
${data.local_file.inventory_bigdata.content}

[edge]
${google_compute_instance.edge.name} ansible_host=${google_compute_instance.edge.network_interface[0].access_config[0].nat_ip}  


[edge:vars]
edge_ip=${google_compute_instance.edge.network_interface[0].network_ip}


EOT
}
