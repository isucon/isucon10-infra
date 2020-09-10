resource "lovi_subnet" "team019" {
  name = "team019"
  vlan_id = 1000 + 19
  network = "10.160.19.0/24"
  start = "10.160.19.100"
  end = "10.160.19.200"
  gateway = "10.160.19.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.19.1"
}

resource "lovi_bridge" "team019" {
  name = "team019"
  vlan_id = 1000 + 19

  depends_on = [lovi_subnet.team019]
}

resource "lovi_internal_bridge" "team019" {
  name = "team019-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team019" {
  count = var.node_count

  subnet_id = lovi_subnet.team019.id
  fixed_ip = "10.160.19.${101 + count.index}"
}

resource "lovi_lease" "problem-team019" {
  count = var.node_count

  address_id = lovi_address.problem-team019[count.index].id

  depends_on = [lovi_address.problem-team019]
}
resource "lovi_cpu_pinning_group" "team019" {
  name = "team019"
  count_of_core = 4
  hypervisor_name = "isucn0001"
}

resource "lovi_virtual_machine" "problem-team019" {
  count = var.node_count

  name = "team019-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team019.name

  depends_on = [
    lovi_cpu_pinning_group.team019
  ]
}

resource "lovi_interface_attachment" "problem-team019" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team019[count.index].id
  bridge_id = lovi_bridge.team019.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t019-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team019[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team019,
    lovi_lease.problem-team019
  ]
}

resource "lovi_address" "bench-team019" {
  subnet_id = lovi_subnet.team019.id
  fixed_ip = "10.160.19.104"
}

resource "lovi_lease" "bench-team019" {
  address_id = lovi_address.bench-team019.id

  depends_on = [lovi_address.bench-team019]
}

resource "lovi_virtual_machine" "bench-team019" {
  name = "team019-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team019,
    lovi_cpu_pinning_group.team019
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team019.name
}

resource "lovi_interface_attachment" "bench-team019" {
  virtual_machine_id = lovi_virtual_machine.bench-team019.id
  bridge_id = lovi_bridge.team019.id
  average = 12500 // NOTE: 100Mbps
  name = "t019-be"
  lease_id = lovi_lease.bench-team019.id

  depends_on = [
    lovi_virtual_machine.bench-team019,
    lovi_lease.bench-team019
  ]
}

resource "lovi_address" "bastion-team019" {
  subnet_id = lovi_subnet.team019.id
  fixed_ip = "10.160.19.100"
}

resource "lovi_lease" "bastion-team019" {
  address_id = lovi_address.bastion-team019.id

  depends_on = [lovi_address.bastion-team019]
}

resource "lovi_virtual_machine" "bastion-team019" {
  name = "team019-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team019,
  ]
}

resource "lovi_interface_attachment" "bastion-team019" {
  virtual_machine_id = lovi_virtual_machine.bastion-team019.id
  bridge_id = lovi_bridge.team019.id
  average = 125000 // NOTE: 1Gbps
  name = "t019-ba"
  lease_id = lovi_lease.bastion-team019.id

  depends_on = [
    lovi_virtual_machine.bastion-team019,
    lovi_lease.bastion-team019
  ]
}