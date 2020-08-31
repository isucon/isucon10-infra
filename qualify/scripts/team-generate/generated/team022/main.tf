resource "lovi_subnet" "team022" {
  name = "team022"
  vlan_id = 1000 + 22
  network = "10.160.22.0/24"
  start = "10.160.22.100"
  end = "10.160.22.200"
  gateway = "10.160.22.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.22.1"
}

resource "lovi_bridge" "team022" {
  name = "team022"
  vlan_id = 1000 + 22

  depends_on = [lovi_subnet.team022]
}

resource "lovi_internal_bridge" "team022" {
  name = "team022-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team022" {
  count = var.node_count

  subnet_id = lovi_subnet.team022.id
  fixed_ip = "10.160.22.${101 + count.index}"
}

resource "lovi_lease" "problem-team022" {
  count = var.node_count

  address_id = lovi_address.problem-team022[count.index].id

  depends_on = [lovi_address.problem-team022]
}
resource "lovi_virtual_machine" "problem-team022" {
  count = var.node_count

  name = "team022-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0001"
}

resource "lovi_interface_attachment" "problem-team022" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team022[count.index].id
  bridge_id = lovi_bridge.team022.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t022-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team022[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team022,
    lovi_lease.problem-team022
  ]
}

resource "lovi_address" "bench-team022" {
  subnet_id = lovi_subnet.team022.id
  fixed_ip = "10.160.22.104"
}

resource "lovi_lease" "bench-team022" {
  address_id = lovi_address.bench-team022.id

  depends_on = [lovi_address.bench-team022]
}

resource "lovi_virtual_machine" "bench-team022" {
  name = "team022-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team022,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team022" {
  virtual_machine_id = lovi_virtual_machine.bench-team022.id
  bridge_id = lovi_bridge.team022.id
  average = 12500 // NOTE: 100Mbps
  name = "t022-be"
  lease_id = lovi_lease.bench-team022.id

  depends_on = [
    lovi_virtual_machine.bench-team022,
    lovi_lease.bench-team022
  ]
}

resource "lovi_address" "bastion-team022" {
  subnet_id = lovi_subnet.team022.id
  fixed_ip = "10.160.22.100"
}

resource "lovi_lease" "bastion-team022" {
  address_id = lovi_address.bastion-team022.id

  depends_on = [lovi_address.bastion-team022]
}

resource "lovi_virtual_machine" "bastion-team022" {
  name = "team022-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team022,
  ]
}

resource "lovi_interface_attachment" "bastion-team022" {
  virtual_machine_id = lovi_virtual_machine.bastion-team022.id
  bridge_id = lovi_bridge.team022.id
  average = 125000 // NOTE: 1Gbps
  name = "t022-ba"
  lease_id = lovi_lease.bastion-team022.id

  depends_on = [
    lovi_virtual_machine.bastion-team022,
    lovi_lease.bastion-team022
  ]
}