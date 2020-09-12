resource "lovi_subnet" "team189" {
  name = "team189"
  vlan_id = 1000 + 189
  network = "10.161.89.0/24"
  start = "10.161.89.100"
  end = "10.161.89.200"
  gateway = "10.161.89.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.89.1"
}

resource "lovi_bridge" "team189" {
  name = "team189"
  vlan_id = 1000 + 189

  depends_on = [lovi_subnet.team189]
}

resource "lovi_internal_bridge" "team189" {
  name = "team189-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team189" {
  count = var.node_count

  subnet_id = lovi_subnet.team189.id
  fixed_ip = "10.161.89.${101 + count.index}"
}

resource "lovi_lease" "problem-team189" {
  count = var.node_count

  address_id = lovi_address.problem-team189[count.index].id

  depends_on = [lovi_address.problem-team189]
}
resource "lovi_cpu_pinning_group" "team189" {
  name = "team189"
  count_of_core = 4
  hypervisor_name = "isucn0009"
}

resource "lovi_virtual_machine" "problem-team189" {
  count = var.node_count

  name = "team189-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0009"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team189.name

  depends_on = [
    lovi_cpu_pinning_group.team189
  ]
}

resource "lovi_interface_attachment" "problem-team189" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team189[count.index].id
  bridge_id = lovi_bridge.team189.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t189-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team189[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team189,
    lovi_lease.problem-team189
  ]
}

resource "lovi_address" "bench-team189" {
  subnet_id = lovi_subnet.team189.id
  fixed_ip = "10.161.89.104"
}

resource "lovi_lease" "bench-team189" {
  address_id = lovi_address.bench-team189.id

  depends_on = [lovi_address.bench-team189]
}

resource "lovi_virtual_machine" "bench-team189" {
  name = "team189-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0009"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team189,
    lovi_cpu_pinning_group.team189
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team189.name
}

resource "lovi_interface_attachment" "bench-team189" {
  virtual_machine_id = lovi_virtual_machine.bench-team189.id
  bridge_id = lovi_bridge.team189.id
  average = 12500 // NOTE: 100Mbps
  name = "t189-be"
  lease_id = lovi_lease.bench-team189.id

  depends_on = [
    lovi_virtual_machine.bench-team189,
    lovi_lease.bench-team189
  ]
}

resource "lovi_address" "bastion100-team189" {
  subnet_id = lovi_subnet.team189.id
  fixed_ip = "10.161.89.100"
}

resource "lovi_lease" "bastion100-team189" {
  address_id = lovi_address.bastion100-team189.id

  depends_on = [lovi_address.bastion100-team189]
}

resource "lovi_virtual_machine" "bastion100-team189" {
  name = "team189-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team189,
  ]
}

resource "lovi_interface_attachment" "bastion100-team189" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team189.id
  bridge_id = lovi_bridge.team189.id
  average = 125000 // NOTE: 1Gbps
  name = "t189-ba100"
  lease_id = lovi_lease.bastion100-team189.id

  depends_on = [
    lovi_virtual_machine.bastion100-team189,
    lovi_lease.bastion100-team189
  ]
}
resource "lovi_address" "bastion200-team189" {
  subnet_id = lovi_subnet.team189.id
  fixed_ip = "10.161.89.200"
}

resource "lovi_lease" "bastion200-team189" {
  address_id = lovi_address.bastion200-team189.id

  depends_on = [lovi_address.bastion200-team189]
}

resource "lovi_virtual_machine" "bastion200-team189" {
  name = "team189-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team189,
  ]
}

resource "lovi_interface_attachment" "bastion200-team189" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team189.id
  bridge_id = lovi_bridge.team189.id
  average = 125000 // NOTE: 1Gbps
  name = "t189-ba200"
  lease_id = lovi_lease.bastion200-team189.id

  depends_on = [
    lovi_virtual_machine.bastion200-team189,
    lovi_lease.bastion200-team189
  ]
}