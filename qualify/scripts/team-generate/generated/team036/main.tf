resource "lovi_subnet" "team036" {
  name = "team036"
  vlan_id = 1000 + 36
  network = "10.160.36.0/24"
  start = "10.160.36.100"
  end = "10.160.36.200"
  gateway = "10.160.36.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.36.1"
}

resource "lovi_bridge" "team036" {
  name = "team036"
  vlan_id = 1000 + 36

  depends_on = [lovi_subnet.team036]
}

resource "lovi_internal_bridge" "team036" {
  name = "team036-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team036" {
  count = var.node_count

  subnet_id = lovi_subnet.team036.id
  fixed_ip = "10.160.36.${101 + count.index}"
}

resource "lovi_lease" "problem-team036" {
  count = var.node_count

  address_id = lovi_address.problem-team036[count.index].id

  depends_on = [lovi_address.problem-team036]
}
resource "lovi_virtual_machine" "problem-team036" {
  count = var.node_count

  name = "team036-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0001"
}

resource "lovi_interface_attachment" "problem-team036" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team036[count.index].id
  bridge_id = lovi_bridge.team036.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t036-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team036[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team036,
    lovi_lease.problem-team036
  ]
}

resource "lovi_address" "bench-team036" {
  subnet_id = lovi_subnet.team036.id
  fixed_ip = "10.160.36.104"
}

resource "lovi_lease" "bench-team036" {
  address_id = lovi_address.bench-team036.id

  depends_on = [lovi_address.bench-team036]
}

resource "lovi_virtual_machine" "bench-team036" {
  name = "team036-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team036,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team036" {
  virtual_machine_id = lovi_virtual_machine.bench-team036.id
  bridge_id = lovi_bridge.team036.id
  average = 12500 // NOTE: 100Mbps
  name = "t036-be"
  lease_id = lovi_lease.bench-team036.id

  depends_on = [
    lovi_virtual_machine.bench-team036,
    lovi_lease.bench-team036
  ]
}

resource "lovi_address" "bastion-team036" {
  subnet_id = lovi_subnet.team036.id
  fixed_ip = "10.160.36.100"
}

resource "lovi_lease" "bastion-team036" {
  address_id = lovi_address.bastion-team036.id

  depends_on = [lovi_address.bastion-team036]
}

resource "lovi_virtual_machine" "bastion-team036" {
  name = "team036-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team036,
  ]
}

resource "lovi_interface_attachment" "bastion-team036" {
  virtual_machine_id = lovi_virtual_machine.bastion-team036.id
  bridge_id = lovi_bridge.team036.id
  average = 125000 // NOTE: 1Gbps
  name = "t036-ba"
  lease_id = lovi_lease.bastion-team036.id

  depends_on = [
    lovi_virtual_machine.bastion-team036,
    lovi_lease.bastion-team036
  ]
}