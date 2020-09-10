resource "lovi_subnet" "team021" {
  name = "team021"
  vlan_id = 1000 + 21
  network = "10.160.21.0/24"
  start = "10.160.21.100"
  end = "10.160.21.200"
  gateway = "10.160.21.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.21.1"
}

resource "lovi_bridge" "team021" {
  name = "team021"
  vlan_id = 1000 + 21

  depends_on = [lovi_subnet.team021]
}

resource "lovi_internal_bridge" "team021" {
  name = "team021-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team021" {
  count = var.node_count

  subnet_id = lovi_subnet.team021.id
  fixed_ip = "10.160.21.${101 + count.index}"
}

resource "lovi_lease" "problem-team021" {
  count = var.node_count

  address_id = lovi_address.problem-team021[count.index].id

  depends_on = [lovi_address.problem-team021]
}
resource "lovi_cpu_pinning_group" "team021" {
  name = "team021"
  count_of_core = 4
  hypervisor_name = "isucn0001"
}

resource "lovi_virtual_machine" "problem-team021" {
  count = var.node_count

  name = "team021-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team021.name

  depends_on = [
    lovi_cpu_pinning_group.team021
  ]
}

resource "lovi_interface_attachment" "problem-team021" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team021[count.index].id
  bridge_id = lovi_bridge.team021.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t021-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team021[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team021,
    lovi_lease.problem-team021
  ]
}

resource "lovi_address" "bench-team021" {
  subnet_id = lovi_subnet.team021.id
  fixed_ip = "10.160.21.104"
}

resource "lovi_lease" "bench-team021" {
  address_id = lovi_address.bench-team021.id

  depends_on = [lovi_address.bench-team021]
}

resource "lovi_virtual_machine" "bench-team021" {
  name = "team021-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team021,
    lovi_cpu_pinning_group.team021
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team021.name
}

resource "lovi_interface_attachment" "bench-team021" {
  virtual_machine_id = lovi_virtual_machine.bench-team021.id
  bridge_id = lovi_bridge.team021.id
  average = 12500 // NOTE: 100Mbps
  name = "t021-be"
  lease_id = lovi_lease.bench-team021.id

  depends_on = [
    lovi_virtual_machine.bench-team021,
    lovi_lease.bench-team021
  ]
}

resource "lovi_address" "bastion-team021" {
  subnet_id = lovi_subnet.team021.id
  fixed_ip = "10.160.21.100"
}

resource "lovi_lease" "bastion-team021" {
  address_id = lovi_address.bastion-team021.id

  depends_on = [lovi_address.bastion-team021]
}

resource "lovi_virtual_machine" "bastion-team021" {
  name = "team021-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team021,
  ]
}

resource "lovi_interface_attachment" "bastion-team021" {
  virtual_machine_id = lovi_virtual_machine.bastion-team021.id
  bridge_id = lovi_bridge.team021.id
  average = 125000 // NOTE: 1Gbps
  name = "t021-ba"
  lease_id = lovi_lease.bastion-team021.id

  depends_on = [
    lovi_virtual_machine.bastion-team021,
    lovi_lease.bastion-team021
  ]
}