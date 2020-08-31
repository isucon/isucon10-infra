resource "lovi_subnet" "team011" {
  name = "team011"
  vlan_id = 1000 + 11
  network = "10.160.11.0/24"
  start = "10.160.11.100"
  end = "10.160.11.200"
  gateway = "10.160.11.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.11.1"
}

resource "lovi_bridge" "team011" {
  name = "team011"
  vlan_id = 1000 + 11

  depends_on = [lovi_subnet.team011]
}

resource "lovi_internal_bridge" "team011" {
  name = "team011-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team011" {
  count = var.node_count

  subnet_id = lovi_subnet.team011.id
  fixed_ip = "10.160.11.${101 + count.index}"
}

resource "lovi_lease" "problem-team011" {
  count = var.node_count

  address_id = lovi_address.problem-team011[count.index].id

  depends_on = [lovi_address.problem-team011]
}
resource "lovi_virtual_machine" "problem-team011" {
  count = var.node_count

  name = "team011-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0001"
}

resource "lovi_interface_attachment" "problem-team011" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team011[count.index].id
  bridge_id = lovi_bridge.team011.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t011-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team011[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team011,
    lovi_lease.problem-team011
  ]
}

resource "lovi_address" "bench-team011" {
  subnet_id = lovi_subnet.team011.id
  fixed_ip = "10.160.11.104"
}

resource "lovi_lease" "bench-team011" {
  address_id = lovi_address.bench-team011.id

  depends_on = [lovi_address.bench-team011]
}

resource "lovi_virtual_machine" "bench-team011" {
  name = "team011-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team011,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team011" {
  virtual_machine_id = lovi_virtual_machine.bench-team011.id
  bridge_id = lovi_bridge.team011.id
  average = 12500 // NOTE: 100Mbps
  name = "t011-be"
  lease_id = lovi_lease.bench-team011.id

  depends_on = [
    lovi_virtual_machine.bench-team011,
    lovi_lease.bench-team011
  ]
}

resource "lovi_address" "bastion-team011" {
  subnet_id = lovi_subnet.team011.id
  fixed_ip = "10.160.11.100"
}

resource "lovi_lease" "bastion-team011" {
  address_id = lovi_address.bastion-team011.id

  depends_on = [lovi_address.bastion-team011]
}

resource "lovi_virtual_machine" "bastion-team011" {
  name = "team011-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team011,
  ]
}

resource "lovi_interface_attachment" "bastion-team011" {
  virtual_machine_id = lovi_virtual_machine.bastion-team011.id
  bridge_id = lovi_bridge.team011.id
  average = 125000 // NOTE: 1Gbps
  name = "t011-ba"
  lease_id = lovi_lease.bastion-team011.id

  depends_on = [
    lovi_virtual_machine.bastion-team011,
    lovi_lease.bastion-team011
  ]
}