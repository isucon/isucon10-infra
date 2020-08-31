resource "lovi_subnet" "team010" {
  name = "team010"
  vlan_id = 1000 + 10
  network = "10.160.10.0/24"
  start = "10.160.10.100"
  end = "10.160.10.200"
  gateway = "10.160.10.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.10.1"
}

resource "lovi_bridge" "team010" {
  name = "team010"
  vlan_id = 1000 + 10

  depends_on = [lovi_subnet.team010]
}

resource "lovi_internal_bridge" "team010" {
  name = "team010-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team010" {
  count = var.node_count

  subnet_id = lovi_subnet.team010.id
  fixed_ip = "10.160.10.${101 + count.index}"
}

resource "lovi_lease" "problem-team010" {
  count = var.node_count

  address_id = lovi_address.problem-team010[count.index].id

  depends_on = [lovi_address.problem-team010]
}
resource "lovi_virtual_machine" "problem-team010" {
  count = var.node_count

  name = "team010-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0002"
}

resource "lovi_interface_attachment" "problem-team010" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team010[count.index].id
  bridge_id = lovi_bridge.team010.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t010-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team010[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team010,
    lovi_lease.problem-team010
  ]
}

resource "lovi_address" "bench-team010" {
  subnet_id = lovi_subnet.team010.id
  fixed_ip = "10.160.10.104"
}

resource "lovi_lease" "bench-team010" {
  address_id = lovi_address.bench-team010.id

  depends_on = [lovi_address.bench-team010]
}

resource "lovi_virtual_machine" "bench-team010" {
  name = "team010-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0002"

  depends_on = [
    lovi_virtual_machine.problem-team010,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team010" {
  virtual_machine_id = lovi_virtual_machine.bench-team010.id
  bridge_id = lovi_bridge.team010.id
  average = 12500 // NOTE: 100Mbps
  name = "t010-be"
  lease_id = lovi_lease.bench-team010.id

  depends_on = [
    lovi_virtual_machine.bench-team010,
    lovi_lease.bench-team010
  ]
}

resource "lovi_address" "bastion-team010" {
  subnet_id = lovi_subnet.team010.id
  fixed_ip = "10.160.10.100"
}

resource "lovi_lease" "bastion-team010" {
  address_id = lovi_address.bastion-team010.id

  depends_on = [lovi_address.bastion-team010]
}

resource "lovi_virtual_machine" "bastion-team010" {
  name = "team010-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team010,
  ]
}

resource "lovi_interface_attachment" "bastion-team010" {
  virtual_machine_id = lovi_virtual_machine.bastion-team010.id
  bridge_id = lovi_bridge.team010.id
  average = 125000 // NOTE: 1Gbps
  name = "t010-ba"
  lease_id = lovi_lease.bastion-team010.id

  depends_on = [
    lovi_virtual_machine.bastion-team010,
    lovi_lease.bastion-team010
  ]
}