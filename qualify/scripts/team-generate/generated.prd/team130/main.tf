resource "lovi_subnet" "team130" {
  name = "team130"
  vlan_id = 1000 + 130
  network = "10.161.30.0/24"
  start = "10.161.30.100"
  end = "10.161.30.200"
  gateway = "10.161.30.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.30.1"
}

resource "lovi_bridge" "team130" {
  name = "team130"
  vlan_id = 1000 + 130

  depends_on = [lovi_subnet.team130]
}

resource "lovi_internal_bridge" "team130" {
  name = "team130-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team130" {
  count = var.node_count

  subnet_id = lovi_subnet.team130.id
  fixed_ip = "10.161.30.${101 + count.index}"
}

resource "lovi_lease" "problem-team130" {
  count = var.node_count

  address_id = lovi_address.problem-team130[count.index].id

  depends_on = [lovi_address.problem-team130]
}
resource "lovi_cpu_pinning_group" "team130" {
  name = "team130"
  count_of_core = 4
  hypervisor_name = "isucn0006"
}

resource "lovi_virtual_machine" "problem-team130" {
  count = var.node_count

  name = "team130-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0006"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team130.name

  depends_on = [
    lovi_cpu_pinning_group.team130
  ]
}

resource "lovi_interface_attachment" "problem-team130" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team130[count.index].id
  bridge_id = lovi_bridge.team130.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t130-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team130[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team130,
    lovi_lease.problem-team130
  ]
}

resource "lovi_address" "bench-team130" {
  subnet_id = lovi_subnet.team130.id
  fixed_ip = "10.161.30.104"
}

resource "lovi_lease" "bench-team130" {
  address_id = lovi_address.bench-team130.id

  depends_on = [lovi_address.bench-team130]
}

resource "lovi_virtual_machine" "bench-team130" {
  name = "team130-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team130,
    lovi_cpu_pinning_group.team130
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team130.name
}

resource "lovi_interface_attachment" "bench-team130" {
  virtual_machine_id = lovi_virtual_machine.bench-team130.id
  bridge_id = lovi_bridge.team130.id
  average = 12500 // NOTE: 100Mbps
  name = "t130-be"
  lease_id = lovi_lease.bench-team130.id

  depends_on = [
    lovi_virtual_machine.bench-team130,
    lovi_lease.bench-team130
  ]
}

resource "lovi_address" "bastion100-team130" {
  subnet_id = lovi_subnet.team130.id
  fixed_ip = "10.161.30.100"
}

resource "lovi_lease" "bastion100-team130" {
  address_id = lovi_address.bastion100-team130.id

  depends_on = [lovi_address.bastion100-team130]
}

resource "lovi_virtual_machine" "bastion100-team130" {
  name = "team130-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team130,
  ]
}

resource "lovi_interface_attachment" "bastion100-team130" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team130.id
  bridge_id = lovi_bridge.team130.id
  average = 125000 // NOTE: 1Gbps
  name = "t130-ba100"
  lease_id = lovi_lease.bastion100-team130.id

  depends_on = [
    lovi_virtual_machine.bastion100-team130,
    lovi_lease.bastion100-team130
  ]
}
resource "lovi_address" "bastion200-team130" {
  subnet_id = lovi_subnet.team130.id
  fixed_ip = "10.161.30.200"
}

resource "lovi_lease" "bastion200-team130" {
  address_id = lovi_address.bastion200-team130.id

  depends_on = [lovi_address.bastion200-team130]
}

resource "lovi_virtual_machine" "bastion200-team130" {
  name = "team130-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team130,
  ]
}

resource "lovi_interface_attachment" "bastion200-team130" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team130.id
  bridge_id = lovi_bridge.team130.id
  average = 125000 // NOTE: 1Gbps
  name = "t130-ba200"
  lease_id = lovi_lease.bastion200-team130.id

  depends_on = [
    lovi_virtual_machine.bastion200-team130,
    lovi_lease.bastion200-team130
  ]
}