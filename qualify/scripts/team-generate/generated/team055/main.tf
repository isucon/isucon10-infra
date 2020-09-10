resource "lovi_subnet" "team055" {
  name = "team055"
  vlan_id = 1000 + 55
  network = "10.160.55.0/24"
  start = "10.160.55.100"
  end = "10.160.55.200"
  gateway = "10.160.55.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.55.1"
}

resource "lovi_bridge" "team055" {
  name = "team055"
  vlan_id = 1000 + 55

  depends_on = [lovi_subnet.team055]
}

resource "lovi_internal_bridge" "team055" {
  name = "team055-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team055" {
  count = var.node_count

  subnet_id = lovi_subnet.team055.id
  fixed_ip = "10.160.55.${101 + count.index}"
}

resource "lovi_lease" "problem-team055" {
  count = var.node_count

  address_id = lovi_address.problem-team055[count.index].id

  depends_on = [lovi_address.problem-team055]
}
resource "lovi_cpu_pinning_group" "team055" {
  name = "team055"
  count_of_core = 4
  hypervisor_name = "isucn0003"
}

resource "lovi_virtual_machine" "problem-team055" {
  count = var.node_count

  name = "team055-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "isucn0003"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team055.name

  depends_on = [
    lovi_cpu_pinning_group.team055
  ]
}

resource "lovi_interface_attachment" "problem-team055" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team055[count.index].id
  bridge_id = lovi_bridge.team055.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t055-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team055[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team055,
    lovi_lease.problem-team055
  ]
}

resource "lovi_address" "bench-team055" {
  subnet_id = lovi_subnet.team055.id
  fixed_ip = "10.160.55.104"
}

resource "lovi_lease" "bench-team055" {
  address_id = lovi_address.bench-team055.id

  depends_on = [lovi_address.bench-team055]
}

resource "lovi_virtual_machine" "bench-team055" {
  name = "team055-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "isucn0003"

  depends_on = [
    lovi_virtual_machine.problem-team055,
    lovi_cpu_pinning_group.team055
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team055.name
}

resource "lovi_interface_attachment" "bench-team055" {
  virtual_machine_id = lovi_virtual_machine.bench-team055.id
  bridge_id = lovi_bridge.team055.id
  average = 12500 // NOTE: 100Mbps
  name = "t055-be"
  lease_id = lovi_lease.bench-team055.id

  depends_on = [
    lovi_virtual_machine.bench-team055,
    lovi_lease.bench-team055
  ]
}

resource "lovi_address" "bastion-team055" {
  subnet_id = lovi_subnet.team055.id
  fixed_ip = "10.160.55.100"
}

resource "lovi_lease" "bastion-team055" {
  address_id = lovi_address.bastion-team055.id

  depends_on = [lovi_address.bastion-team055]
}

resource "lovi_virtual_machine" "bastion-team055" {
  name = "team055-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team055,
  ]
}

resource "lovi_interface_attachment" "bastion-team055" {
  virtual_machine_id = lovi_virtual_machine.bastion-team055.id
  bridge_id = lovi_bridge.team055.id
  average = 125000 // NOTE: 1Gbps
  name = "t055-ba"
  lease_id = lovi_lease.bastion-team055.id

  depends_on = [
    lovi_virtual_machine.bastion-team055,
    lovi_lease.bastion-team055
  ]
}