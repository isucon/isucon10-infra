resource "lovi_subnet" "team155" {
  name = "team155"
  vlan_id = 1000 + 155
  network = "10.161.55.0/24"
  start = "10.161.55.100"
  end = "10.161.55.200"
  gateway = "10.161.55.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.55.1"
}

resource "lovi_bridge" "team155" {
  name = "team155"
  vlan_id = 1000 + 155

  depends_on = [lovi_subnet.team155]
}

resource "lovi_internal_bridge" "team155" {
  name = "team155-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team155" {
  count = var.node_count

  subnet_id = lovi_subnet.team155.id
  fixed_ip = "10.161.55.${101 + count.index}"
}

resource "lovi_lease" "problem-team155" {
  count = var.node_count

  address_id = lovi_address.problem-team155[count.index].id

  depends_on = [lovi_address.problem-team155]
}
resource "lovi_cpu_pinning_group" "team155" {
  name = "team155"
  count_of_core = 4
  hypervisor_name = "isucn0007"
}

resource "lovi_virtual_machine" "problem-team155" {
  count = var.node_count

  name = "team155-${format("%03d", count.index + 1)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team155.name

  depends_on = [
    lovi_cpu_pinning_group.team155
  ]
}

resource "lovi_interface_attachment" "problem-team155" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team155[count.index].id
  bridge_id = lovi_bridge.team155.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t155-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team155[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team155,
    lovi_lease.problem-team155
  ]
}

resource "lovi_address" "bench-team155" {
  subnet_id = lovi_subnet.team155.id
  fixed_ip = "10.161.55.104"
}

resource "lovi_lease" "bench-team155" {
  address_id = lovi_address.bench-team155.id

  depends_on = [lovi_address.bench-team155]
}

resource "lovi_virtual_machine" "bench-team155" {
  name = "team155-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team155,
    lovi_cpu_pinning_group.team155
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team155.name
}

resource "lovi_interface_attachment" "bench-team155" {
  virtual_machine_id = lovi_virtual_machine.bench-team155.id
  bridge_id = lovi_bridge.team155.id
  average = 12500 // NOTE: 100Mbps
  name = "t155-be"
  lease_id = lovi_lease.bench-team155.id

  depends_on = [
    lovi_virtual_machine.bench-team155,
    lovi_lease.bench-team155
  ]
}

resource "lovi_address" "bastion100-team155" {
  subnet_id = lovi_subnet.team155.id
  fixed_ip = "10.161.55.100"
}

resource "lovi_lease" "bastion100-team155" {
  address_id = lovi_address.bastion100-team155.id

  depends_on = [lovi_address.bastion100-team155]
}

resource "lovi_virtual_machine" "bastion100-team155" {
  name = "team155-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team155,
  ]
}

resource "lovi_interface_attachment" "bastion100-team155" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team155.id
  bridge_id = lovi_bridge.team155.id
  average = 125000 // NOTE: 1Gbps
  name = "t155-ba100"
  lease_id = lovi_lease.bastion100-team155.id

  depends_on = [
    lovi_virtual_machine.bastion100-team155,
    lovi_lease.bastion100-team155
  ]
}
resource "lovi_address" "bastion200-team155" {
  subnet_id = lovi_subnet.team155.id
  fixed_ip = "10.161.55.200"
}

resource "lovi_lease" "bastion200-team155" {
  address_id = lovi_address.bastion200-team155.id

  depends_on = [lovi_address.bastion200-team155]
}

resource "lovi_virtual_machine" "bastion200-team155" {
  name = "team155-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team155,
  ]
}

resource "lovi_interface_attachment" "bastion200-team155" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team155.id
  bridge_id = lovi_bridge.team155.id
  average = 125000 // NOTE: 1Gbps
  name = "t155-ba200"
  lease_id = lovi_lease.bastion200-team155.id

  depends_on = [
    lovi_virtual_machine.bastion200-team155,
    lovi_lease.bastion200-team155
  ]
}