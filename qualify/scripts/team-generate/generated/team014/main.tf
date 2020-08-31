resource "lovi_subnet" "team014" {
  name = "team014"
  vlan_id = 1000 + 14
  network = "10.160.14.0/24"
  start = "10.160.14.100"
  end = "10.160.14.200"
  gateway = "10.160.14.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.14.1"
}

resource "lovi_bridge" "team014" {
  name = "team014"
  vlan_id = 1000 + 14

  depends_on = [lovi_subnet.team014]
}

resource "lovi_internal_bridge" "team014" {
  name = "team014-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team014" {
  count = var.node_count

  subnet_id = lovi_subnet.team014.id
  fixed_ip = "10.160.14.${101 + count.index}"
}

resource "lovi_lease" "problem-team014" {
  count = var.node_count

  address_id = lovi_address.problem-team014[count.index].id

  depends_on = [lovi_address.problem-team014]
}
resource "lovi_virtual_machine" "problem-team014" {
  count = var.node_count

  name = "team014-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0001"
}

resource "lovi_interface_attachment" "problem-team014" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team014[count.index].id
  bridge_id = lovi_bridge.team014.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t014-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team014[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team014,
    lovi_lease.problem-team014
  ]
}

resource "lovi_address" "bench-team014" {
  subnet_id = lovi_subnet.team014.id
  fixed_ip = "10.160.14.104"
}

resource "lovi_lease" "bench-team014" {
  address_id = lovi_address.bench-team014.id

  depends_on = [lovi_address.bench-team014]
}

resource "lovi_virtual_machine" "bench-team014" {
  name = "team014-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team014,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team014" {
  virtual_machine_id = lovi_virtual_machine.bench-team014.id
  bridge_id = lovi_bridge.team014.id
  average = 12500 // NOTE: 100Mbps
  name = "t014-be"
  lease_id = lovi_lease.bench-team014.id

  depends_on = [
    lovi_virtual_machine.bench-team014,
    lovi_lease.bench-team014
  ]
}

resource "lovi_address" "bastion-team014" {
  subnet_id = lovi_subnet.team014.id
  fixed_ip = "10.160.14.100"
}

resource "lovi_lease" "bastion-team014" {
  address_id = lovi_address.bastion-team014.id

  depends_on = [lovi_address.bastion-team014]
}

resource "lovi_virtual_machine" "bastion-team014" {
  name = "team014-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team014,
  ]
}

resource "lovi_interface_attachment" "bastion-team014" {
  virtual_machine_id = lovi_virtual_machine.bastion-team014.id
  bridge_id = lovi_bridge.team014.id
  average = 125000 // NOTE: 1Gbps
  name = "t014-ba"
  lease_id = lovi_lease.bastion-team014.id

  depends_on = [
    lovi_virtual_machine.bastion-team014,
    lovi_lease.bastion-team014
  ]
}