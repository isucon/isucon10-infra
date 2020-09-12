resource "lovi_subnet" "team153" {
  name = "team153"
  vlan_id = 1000 + 153
  network = "10.161.53.0/24"
  start = "10.161.53.100"
  end = "10.161.53.200"
  gateway = "10.161.53.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.53.1"
}

resource "lovi_bridge" "team153" {
  name = "team153"
  vlan_id = 1000 + 153

  depends_on = [lovi_subnet.team153]
}

resource "lovi_internal_bridge" "team153" {
  name = "team153-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team153" {
  count = var.node_count

  subnet_id = lovi_subnet.team153.id
  fixed_ip = "10.161.53.${101 + count.index}"
}

resource "lovi_lease" "problem-team153" {
  count = var.node_count

  address_id = lovi_address.problem-team153[count.index].id

  depends_on = [lovi_address.problem-team153]
}
resource "lovi_cpu_pinning_group" "team153" {
  name = "team153"
  count_of_core = 4
  hypervisor_name = "isucn0007"
}

resource "lovi_virtual_machine" "problem-team153" {
  count = var.node_count

  name = "team153-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team153.name

  depends_on = [
    lovi_cpu_pinning_group.team153
  ]
}

resource "lovi_interface_attachment" "problem-team153" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team153[count.index].id
  bridge_id = lovi_bridge.team153.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t153-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team153[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team153,
    lovi_lease.problem-team153
  ]
}

resource "lovi_address" "bench-team153" {
  subnet_id = lovi_subnet.team153.id
  fixed_ip = "10.161.53.104"
}

resource "lovi_lease" "bench-team153" {
  address_id = lovi_address.bench-team153.id

  depends_on = [lovi_address.bench-team153]
}

resource "lovi_virtual_machine" "bench-team153" {
  name = "team153-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team153,
    lovi_cpu_pinning_group.team153
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team153.name
}

resource "lovi_interface_attachment" "bench-team153" {
  virtual_machine_id = lovi_virtual_machine.bench-team153.id
  bridge_id = lovi_bridge.team153.id
  average = 12500 // NOTE: 100Mbps
  name = "t153-be"
  lease_id = lovi_lease.bench-team153.id

  depends_on = [
    lovi_virtual_machine.bench-team153,
    lovi_lease.bench-team153
  ]
}

resource "lovi_address" "bastion100-team153" {
  subnet_id = lovi_subnet.team153.id
  fixed_ip = "10.161.53.100"
}

resource "lovi_lease" "bastion100-team153" {
  address_id = lovi_address.bastion100-team153.id

  depends_on = [lovi_address.bastion100-team153]
}

resource "lovi_virtual_machine" "bastion100-team153" {
  name = "team153-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team153,
  ]
}

resource "lovi_interface_attachment" "bastion100-team153" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team153.id
  bridge_id = lovi_bridge.team153.id
  average = 125000 // NOTE: 1Gbps
  name = "t153-ba100"
  lease_id = lovi_lease.bastion100-team153.id

  depends_on = [
    lovi_virtual_machine.bastion100-team153,
    lovi_lease.bastion100-team153
  ]
}
resource "lovi_address" "bastion200-team153" {
  subnet_id = lovi_subnet.team153.id
  fixed_ip = "10.161.53.200"
}

resource "lovi_lease" "bastion200-team153" {
  address_id = lovi_address.bastion200-team153.id

  depends_on = [lovi_address.bastion200-team153]
}

resource "lovi_virtual_machine" "bastion200-team153" {
  name = "team153-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team153,
  ]
}

resource "lovi_interface_attachment" "bastion200-team153" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team153.id
  bridge_id = lovi_bridge.team153.id
  average = 125000 // NOTE: 1Gbps
  name = "t153-ba200"
  lease_id = lovi_lease.bastion200-team153.id

  depends_on = [
    lovi_virtual_machine.bastion200-team153,
    lovi_lease.bastion200-team153
  ]
}