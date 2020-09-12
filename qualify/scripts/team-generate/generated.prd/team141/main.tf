resource "lovi_subnet" "team141" {
  name = "team141"
  vlan_id = 1000 + 141
  network = "10.161.41.0/24"
  start = "10.161.41.100"
  end = "10.161.41.200"
  gateway = "10.161.41.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.161.41.1"
}

resource "lovi_bridge" "team141" {
  name = "team141"
  vlan_id = 1000 + 141

  depends_on = [lovi_subnet.team141]
}

resource "lovi_internal_bridge" "team141" {
  name = "team141-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team141" {
  count = var.node_count

  subnet_id = lovi_subnet.team141.id
  fixed_ip = "10.161.41.${101 + count.index}"
}

resource "lovi_lease" "problem-team141" {
  count = var.node_count

  address_id = lovi_address.problem-team141[count.index].id

  depends_on = [lovi_address.problem-team141]
}
resource "lovi_cpu_pinning_group" "team141" {
  name = "team141"
  count_of_core = 4
  hypervisor_name = "isucn0007"
}

resource "lovi_virtual_machine" "problem-team141" {
  count = var.node_count

  name = "team141-${format("%03d", count.index + 1)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team141.name

  depends_on = [
    lovi_cpu_pinning_group.team141
  ]
}

resource "lovi_interface_attachment" "problem-team141" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team141[count.index].id
  bridge_id = lovi_bridge.team141.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t141-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team141[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team141,
    lovi_lease.problem-team141
  ]
}

resource "lovi_address" "bench-team141" {
  subnet_id = lovi_subnet.team141.id
  fixed_ip = "10.161.41.104"
}

resource "lovi_lease" "bench-team141" {
  address_id = lovi_address.bench-team141.id

  depends_on = [lovi_address.bench-team141]
}

resource "lovi_virtual_machine" "bench-team141" {
  name = "team141-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team141,
    lovi_cpu_pinning_group.team141
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team141.name
}

resource "lovi_interface_attachment" "bench-team141" {
  virtual_machine_id = lovi_virtual_machine.bench-team141.id
  bridge_id = lovi_bridge.team141.id
  average = 12500 // NOTE: 100Mbps
  name = "t141-be"
  lease_id = lovi_lease.bench-team141.id

  depends_on = [
    lovi_virtual_machine.bench-team141,
    lovi_lease.bench-team141
  ]
}

resource "lovi_address" "bastion100-team141" {
  subnet_id = lovi_subnet.team141.id
  fixed_ip = "10.161.41.100"
}

resource "lovi_lease" "bastion100-team141" {
  address_id = lovi_address.bastion100-team141.id

  depends_on = [lovi_address.bastion100-team141]
}

resource "lovi_virtual_machine" "bastion100-team141" {
  name = "team141-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team141,
  ]
}

resource "lovi_interface_attachment" "bastion100-team141" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team141.id
  bridge_id = lovi_bridge.team141.id
  average = 125000 // NOTE: 1Gbps
  name = "t141-ba100"
  lease_id = lovi_lease.bastion100-team141.id

  depends_on = [
    lovi_virtual_machine.bastion100-team141,
    lovi_lease.bastion100-team141
  ]
}
resource "lovi_address" "bastion200-team141" {
  subnet_id = lovi_subnet.team141.id
  fixed_ip = "10.161.41.200"
}

resource "lovi_lease" "bastion200-team141" {
  address_id = lovi_address.bastion200-team141.id

  depends_on = [lovi_address.bastion200-team141]
}

resource "lovi_virtual_machine" "bastion200-team141" {
  name = "team141-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team141,
  ]
}

resource "lovi_interface_attachment" "bastion200-team141" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team141.id
  bridge_id = lovi_bridge.team141.id
  average = 125000 // NOTE: 1Gbps
  name = "t141-ba200"
  lease_id = lovi_lease.bastion200-team141.id

  depends_on = [
    lovi_virtual_machine.bastion200-team141,
    lovi_lease.bastion200-team141
  ]
}