resource "lovi_subnet" "team032" {
  name = "team032"
  vlan_id = 1000 + 32
  network = "10.160.32.0/24"
  start = "10.160.32.100"
  end = "10.160.32.200"
  gateway = "10.160.32.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.32.1"
}

resource "lovi_bridge" "team032" {
  name = "team032"
  vlan_id = 1000 + 32

  depends_on = [lovi_subnet.team032]
}

resource "lovi_internal_bridge" "team032" {
  name = "team032-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team032" {
  count = var.node_count

  subnet_id = lovi_subnet.team032.id
  fixed_ip = "10.160.32.${101 + count.index}"
}

resource "lovi_lease" "problem-team032" {
  count = var.node_count

  address_id = lovi_address.problem-team032[count.index].id

  depends_on = [lovi_address.problem-team032]
}
resource "lovi_virtual_machine" "problem-team032" {
  count = var.node_count

  name = "team032-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "f099f816-424f-489a-93bd-738505cd3539"
  hypervisor_name = "isucn0001"
}

resource "lovi_interface_attachment" "problem-team032" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team032[count.index].id
  bridge_id = lovi_bridge.team032.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t032-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team032[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team032,
    lovi_lease.problem-team032
  ]
}

resource "lovi_address" "bench-team032" {
  subnet_id = lovi_subnet.team032.id
  fixed_ip = "10.160.32.104"
}

resource "lovi_lease" "bench-team032" {
  address_id = lovi_address.bench-team032.id

  depends_on = [lovi_address.bench-team032]
}

resource "lovi_virtual_machine" "bench-team032" {
  name = "team032-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2247a5d9-0ecb-4788-b148-dfb3279c2156"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team032,
  ]

  //read_bytes_sec = 1 * 1000 * 1000 * 1000
  //write_bytes_sec = 1000000000
  //read_iops_sec = 2000
  //write_iops_sec = 2000
}

resource "lovi_interface_attachment" "bench-team032" {
  virtual_machine_id = lovi_virtual_machine.bench-team032.id
  bridge_id = lovi_bridge.team032.id
  average = 12500 // NOTE: 100Mbps
  name = "t032-be"
  lease_id = lovi_lease.bench-team032.id

  depends_on = [
    lovi_virtual_machine.bench-team032,
    lovi_lease.bench-team032
  ]
}

resource "lovi_address" "bastion-team032" {
  subnet_id = lovi_subnet.team032.id
  fixed_ip = "10.160.32.100"
}

resource "lovi_lease" "bastion-team032" {
  address_id = lovi_address.bastion-team032.id

  depends_on = [lovi_address.bastion-team032]
}

resource "lovi_virtual_machine" "bastion-team032" {
  name = "team032-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team032,
  ]
}

resource "lovi_interface_attachment" "bastion-team032" {
  virtual_machine_id = lovi_virtual_machine.bastion-team032.id
  bridge_id = lovi_bridge.team032.id
  average = 125000 // NOTE: 1Gbps
  name = "t032-ba"
  lease_id = lovi_lease.bastion-team032.id

  depends_on = [
    lovi_virtual_machine.bastion-team032,
    lovi_lease.bastion-team032
  ]
}