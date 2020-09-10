resource "lovi_subnet" "team043" {
  name = "team043"
  vlan_id = 1000 + 43
  network = "10.160.43.0/24"
  start = "10.160.43.100"
  end = "10.160.43.200"
  gateway = "10.160.43.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.43.1"
}

resource "lovi_bridge" "team043" {
  name = "team043"
  vlan_id = 1000 + 43

  depends_on = [lovi_subnet.team043]
}

resource "lovi_internal_bridge" "team043" {
  name = "team043-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team043" {
  count = var.node_count

  subnet_id = lovi_subnet.team043.id
  fixed_ip = "10.160.43.${101 + count.index}"
}

resource "lovi_lease" "problem-team043" {
  count = var.node_count

  address_id = lovi_address.problem-team043[count.index].id

  depends_on = [lovi_address.problem-team043]
}
resource "lovi_cpu_pinning_group" "team043" {
  name = "team043"
  count_of_core = 4
  hypervisor_name = "isucn0003"
}

resource "lovi_virtual_machine" "problem-team043" {
  count = var.node_count

  name = "team043-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0003"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team043.name

  depends_on = [
    lovi_cpu_pinning_group.team043
  ]
}

resource "lovi_interface_attachment" "problem-team043" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team043[count.index].id
  bridge_id = lovi_bridge.team043.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t043-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team043[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team043,
    lovi_lease.problem-team043
  ]
}

resource "lovi_address" "bench-team043" {
  subnet_id = lovi_subnet.team043.id
  fixed_ip = "10.160.43.104"
}

resource "lovi_lease" "bench-team043" {
  address_id = lovi_address.bench-team043.id

  depends_on = [lovi_address.bench-team043]
}

resource "lovi_virtual_machine" "bench-team043" {
  name = "team043-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0003"

  depends_on = [
    lovi_virtual_machine.problem-team043,
    lovi_cpu_pinning_group.team043
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team043.name
}

resource "lovi_interface_attachment" "bench-team043" {
  virtual_machine_id = lovi_virtual_machine.bench-team043.id
  bridge_id = lovi_bridge.team043.id
  average = 12500 // NOTE: 100Mbps
  name = "t043-be"
  lease_id = lovi_lease.bench-team043.id

  depends_on = [
    lovi_virtual_machine.bench-team043,
    lovi_lease.bench-team043
  ]
}

resource "lovi_address" "bastion-team043" {
  subnet_id = lovi_subnet.team043.id
  fixed_ip = "10.160.43.100"
}

resource "lovi_lease" "bastion-team043" {
  address_id = lovi_address.bastion-team043.id

  depends_on = [lovi_address.bastion-team043]
}

resource "lovi_virtual_machine" "bastion-team043" {
  name = "team043-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team043,
  ]
}

resource "lovi_interface_attachment" "bastion-team043" {
  virtual_machine_id = lovi_virtual_machine.bastion-team043.id
  bridge_id = lovi_bridge.team043.id
  average = 125000 // NOTE: 1Gbps
  name = "t043-ba"
  lease_id = lovi_lease.bastion-team043.id

  depends_on = [
    lovi_virtual_machine.bastion-team043,
    lovi_lease.bastion-team043
  ]
}