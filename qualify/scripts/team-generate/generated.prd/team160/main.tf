resource "lovi_subnet" "team160" {
  name = "team160"
  vlan_id = 1000 + 160
  network = "10.161.60.0/24"
  start = "10.161.60.100"
  end = "10.161.60.200"
  gateway = "10.161.60.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.60.1"
}

resource "lovi_bridge" "team160" {
  name = "team160"
  vlan_id = 1000 + 160

  depends_on = [lovi_subnet.team160]
}

resource "lovi_internal_bridge" "team160" {
  name = "team160-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team160" {
  count = var.node_count

  subnet_id = lovi_subnet.team160.id
  fixed_ip = "10.161.60.${101 + count.index}"
}

resource "lovi_lease" "problem-team160" {
  count = var.node_count

  address_id = lovi_address.problem-team160[count.index].id

  depends_on = [lovi_address.problem-team160]
}
resource "lovi_cpu_pinning_group" "team160" {
  name = "team160"
  count_of_core = 4
  hypervisor_name = "isucn0008"
}

resource "lovi_virtual_machine" "problem-team160" {
  count = var.node_count

  name = "team160-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0008"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team160.name

  depends_on = [
    lovi_cpu_pinning_group.team160
  ]
}

resource "lovi_interface_attachment" "problem-team160" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team160[count.index].id
  bridge_id = lovi_bridge.team160.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t160-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team160[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team160,
    lovi_lease.problem-team160
  ]
}

resource "lovi_address" "bench-team160" {
  subnet_id = lovi_subnet.team160.id
  fixed_ip = "10.161.60.104"
}

resource "lovi_lease" "bench-team160" {
  address_id = lovi_address.bench-team160.id

  depends_on = [lovi_address.bench-team160]
}

resource "lovi_virtual_machine" "bench-team160" {
  name = "team160-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0008"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team160,
    lovi_cpu_pinning_group.team160
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team160.name
}

resource "lovi_interface_attachment" "bench-team160" {
  virtual_machine_id = lovi_virtual_machine.bench-team160.id
  bridge_id = lovi_bridge.team160.id
  average = 12500 // NOTE: 100Mbps
  name = "t160-be"
  lease_id = lovi_lease.bench-team160.id

  depends_on = [
    lovi_virtual_machine.bench-team160,
    lovi_lease.bench-team160
  ]
}

resource "lovi_address" "bastion100-team160" {
  subnet_id = lovi_subnet.team160.id
  fixed_ip = "10.161.60.100"
}

resource "lovi_lease" "bastion100-team160" {
  address_id = lovi_address.bastion100-team160.id

  depends_on = [lovi_address.bastion100-team160]
}

resource "lovi_virtual_machine" "bastion100-team160" {
  name = "team160-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team160,
  ]
}

resource "lovi_interface_attachment" "bastion100-team160" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team160.id
  bridge_id = lovi_bridge.team160.id
  average = 125000 // NOTE: 1Gbps
  name = "t160-ba100"
  lease_id = lovi_lease.bastion100-team160.id

  depends_on = [
    lovi_virtual_machine.bastion100-team160,
    lovi_lease.bastion100-team160
  ]
}
resource "lovi_address" "bastion200-team160" {
  subnet_id = lovi_subnet.team160.id
  fixed_ip = "10.161.60.200"
}

resource "lovi_lease" "bastion200-team160" {
  address_id = lovi_address.bastion200-team160.id

  depends_on = [lovi_address.bastion200-team160]
}

resource "lovi_virtual_machine" "bastion200-team160" {
  name = "team160-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team160,
  ]
}

resource "lovi_interface_attachment" "bastion200-team160" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team160.id
  bridge_id = lovi_bridge.team160.id
  average = 125000 // NOTE: 1Gbps
  name = "t160-ba200"
  lease_id = lovi_lease.bastion200-team160.id

  depends_on = [
    lovi_virtual_machine.bastion200-team160,
    lovi_lease.bastion200-team160
  ]
}