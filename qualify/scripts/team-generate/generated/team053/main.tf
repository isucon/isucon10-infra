resource "lovi_subnet" "team053" {
  name = "team053"
  vlan_id = 1000 + 53
  network = "10.160.53.0/24"
  start = "10.160.53.100"
  end = "10.160.53.200"
  gateway = "10.160.53.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.53.1"
}

resource "lovi_bridge" "team053" {
  name = "team053"
  vlan_id = 1000 + 53

  depends_on = [lovi_subnet.team053]
}

resource "lovi_internal_bridge" "team053" {
  name = "team053-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team053" {
  count = var.node_count

  subnet_id = lovi_subnet.team053.id
  fixed_ip = "10.160.53.${101 + count.index}"
}

resource "lovi_lease" "problem-team053" {
  count = var.node_count

  address_id = lovi_address.problem-team053[count.index].id

  depends_on = [lovi_address.problem-team053]
}
resource "lovi_cpu_pinning_group" "team053" {
  name = "team053"
  count_of_core = 4
  hypervisor_name = "isucn0003"
}

resource "lovi_virtual_machine" "problem-team053" {
  count = var.node_count

  name = "team053-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0003"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team053.name

  depends_on = [
    lovi_cpu_pinning_group.team053
  ]
}

resource "lovi_interface_attachment" "problem-team053" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team053[count.index].id
  bridge_id = lovi_bridge.team053.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t053-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team053[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team053,
    lovi_lease.problem-team053
  ]
}

resource "lovi_address" "bench-team053" {
  subnet_id = lovi_subnet.team053.id
  fixed_ip = "10.160.53.104"
}

resource "lovi_lease" "bench-team053" {
  address_id = lovi_address.bench-team053.id

  depends_on = [lovi_address.bench-team053]
}

resource "lovi_virtual_machine" "bench-team053" {
  name = "team053-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0003"

  depends_on = [
    lovi_virtual_machine.problem-team053,
    lovi_cpu_pinning_group.team053
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team053.name
}

resource "lovi_interface_attachment" "bench-team053" {
  virtual_machine_id = lovi_virtual_machine.bench-team053.id
  bridge_id = lovi_bridge.team053.id
  average = 12500 // NOTE: 100Mbps
  name = "t053-be"
  lease_id = lovi_lease.bench-team053.id

  depends_on = [
    lovi_virtual_machine.bench-team053,
    lovi_lease.bench-team053
  ]
}

resource "lovi_address" "bastion-team053" {
  subnet_id = lovi_subnet.team053.id
  fixed_ip = "10.160.53.100"
}

resource "lovi_lease" "bastion-team053" {
  address_id = lovi_address.bastion-team053.id

  depends_on = [lovi_address.bastion-team053]
}

resource "lovi_virtual_machine" "bastion-team053" {
  name = "team053-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team053,
  ]
}

resource "lovi_interface_attachment" "bastion-team053" {
  virtual_machine_id = lovi_virtual_machine.bastion-team053.id
  bridge_id = lovi_bridge.team053.id
  average = 125000 // NOTE: 1Gbps
  name = "t053-ba"
  lease_id = lovi_lease.bastion-team053.id

  depends_on = [
    lovi_virtual_machine.bastion-team053,
    lovi_lease.bastion-team053
  ]
}