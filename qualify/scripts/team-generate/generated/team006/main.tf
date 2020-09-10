resource "lovi_subnet" "team006" {
  name = "team006"
  vlan_id = 1000 + 6
  network = "10.160.6.0/24"
  start = "10.160.6.100"
  end = "10.160.6.200"
  gateway = "10.160.6.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.6.1"
}

resource "lovi_bridge" "team006" {
  name = "team006"
  vlan_id = 1000 + 6

  depends_on = [lovi_subnet.team006]
}

resource "lovi_internal_bridge" "team006" {
  name = "team006-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team006" {
  count = var.node_count

  subnet_id = lovi_subnet.team006.id
  fixed_ip = "10.160.6.${101 + count.index}"
}

resource "lovi_lease" "problem-team006" {
  count = var.node_count

  address_id = lovi_address.problem-team006[count.index].id

  depends_on = [lovi_address.problem-team006]
}
resource "lovi_cpu_pinning_group" "team006" {
  name = "team006"
  count_of_core = 4
  hypervisor_name = "isucn0001"
}

resource "lovi_virtual_machine" "problem-team006" {
  count = var.node_count

  name = "team006-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team006.name

  depends_on = [
    lovi_cpu_pinning_group.team006
  ]
}

resource "lovi_interface_attachment" "problem-team006" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team006[count.index].id
  bridge_id = lovi_bridge.team006.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t006-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team006[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team006,
    lovi_lease.problem-team006
  ]
}

resource "lovi_address" "bench-team006" {
  subnet_id = lovi_subnet.team006.id
  fixed_ip = "10.160.6.104"
}

resource "lovi_lease" "bench-team006" {
  address_id = lovi_address.bench-team006.id

  depends_on = [lovi_address.bench-team006]
}

resource "lovi_virtual_machine" "bench-team006" {
  name = "team006-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0001"

  depends_on = [
    lovi_virtual_machine.problem-team006,
    lovi_cpu_pinning_group.team006
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team006.name
}

resource "lovi_interface_attachment" "bench-team006" {
  virtual_machine_id = lovi_virtual_machine.bench-team006.id
  bridge_id = lovi_bridge.team006.id
  average = 12500 // NOTE: 100Mbps
  name = "t006-be"
  lease_id = lovi_lease.bench-team006.id

  depends_on = [
    lovi_virtual_machine.bench-team006,
    lovi_lease.bench-team006
  ]
}

resource "lovi_address" "bastion-team006" {
  subnet_id = lovi_subnet.team006.id
  fixed_ip = "10.160.6.100"
}

resource "lovi_lease" "bastion-team006" {
  address_id = lovi_address.bastion-team006.id

  depends_on = [lovi_address.bastion-team006]
}

resource "lovi_virtual_machine" "bastion-team006" {
  name = "team006-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team006,
  ]
}

resource "lovi_interface_attachment" "bastion-team006" {
  virtual_machine_id = lovi_virtual_machine.bastion-team006.id
  bridge_id = lovi_bridge.team006.id
  average = 125000 // NOTE: 1Gbps
  name = "t006-ba"
  lease_id = lovi_lease.bastion-team006.id

  depends_on = [
    lovi_virtual_machine.bastion-team006,
    lovi_lease.bastion-team006
  ]
}