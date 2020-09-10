resource "lovi_subnet" "team502" {
  name = "team502"
  vlan_id = 1000 + 502
  network = "10.165.2.0/24"
  start = "10.165.2.100"
  end = "10.165.2.200"
  gateway = "10.165.2.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.2.1"
}

resource "lovi_bridge" "team502" {
  name = "team502"
  vlan_id = 1000 + 502

  depends_on = [lovi_subnet.team502]
}

resource "lovi_internal_bridge" "team502" {
  name = "team502-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team502" {
  count = var.node_count

  subnet_id = lovi_subnet.team502.id
  fixed_ip = "10.165.2.${101 + count.index}"
}

resource "lovi_lease" "problem-team502" {
  count = var.node_count

  address_id = lovi_address.problem-team502[count.index].id

  depends_on = [lovi_address.problem-team502]
}
resource "lovi_cpu_pinning_group" "team502" {
  name = "team502"
  count_of_core = 4
  hypervisor_name = "isuadm0008"
}

resource "lovi_virtual_machine" "problem-team502" {
  count = var.node_count

  name = "team502-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "be1069ee-b147-49fd-b7dd-65639f79012d"
  hypervisor_name = "isuadm0008"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team502.name

  depends_on = [
    lovi_cpu_pinning_group.team502
  ]
}

resource "lovi_interface_attachment" "problem-team502" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team502[count.index].id
  bridge_id = lovi_bridge.team502.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t502-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team502[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team502,
    lovi_lease.problem-team502
  ]
}

resource "lovi_address" "bench-team502" {
  subnet_id = lovi_subnet.team502.id
  fixed_ip = "10.165.2.104"
}

resource "lovi_lease" "bench-team502" {
  address_id = lovi_address.bench-team502.id

  depends_on = [lovi_address.bench-team502]
}

resource "lovi_virtual_machine" "bench-team502" {
  name = "team502-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "be1069ee-b147-49fd-b7dd-65639f79012d"
  hypervisor_name = "isuadm0008"

  depends_on = [
    lovi_virtual_machine.problem-team502,
    lovi_cpu_pinning_group.team502
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team502.name
}

resource "lovi_interface_attachment" "bench-team502" {
  virtual_machine_id = lovi_virtual_machine.bench-team502.id
  bridge_id = lovi_bridge.team502.id
  average = 12500 // NOTE: 100Mbps
  name = "t502-be"
  lease_id = lovi_lease.bench-team502.id

  depends_on = [
    lovi_virtual_machine.bench-team502,
    lovi_lease.bench-team502
  ]
}

resource "lovi_address" "bastion-team502" {
  subnet_id = lovi_subnet.team502.id
  fixed_ip = "10.165.2.100"
}

resource "lovi_lease" "bastion-team502" {
  address_id = lovi_address.bastion-team502.id

  depends_on = [lovi_address.bastion-team502]
}

resource "lovi_virtual_machine" "bastion-team502" {
  name = "team502-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team502,
  ]
}

resource "lovi_interface_attachment" "bastion-team502" {
  virtual_machine_id = lovi_virtual_machine.bastion-team502.id
  bridge_id = lovi_bridge.team502.id
  average = 125000 // NOTE: 1Gbps
  name = "t502-ba"
  lease_id = lovi_lease.bastion-team502.id

  depends_on = [
    lovi_virtual_machine.bastion-team502,
    lovi_lease.bastion-team502
  ]
}