resource "lovi_subnet" "team034" {
  name = "team034"
  vlan_id = 1000 + 34
  network = "10.160.34.0/24"
  start = "10.160.34.100"
  end = "10.160.34.200"
  gateway = "10.160.34.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.34.1"
}

resource "lovi_bridge" "team034" {
  name = "team034"
  vlan_id = 1000 + 34

  depends_on = [lovi_subnet.team034]
}

resource "lovi_internal_bridge" "team034" {
  name = "team034-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team034" {
  count = var.node_count

  subnet_id = lovi_subnet.team034.id
  fixed_ip = "10.160.34.${101 + count.index}"
}

resource "lovi_lease" "problem-team034" {
  count = var.node_count

  address_id = lovi_address.problem-team034[count.index].id

  depends_on = [lovi_address.problem-team034]
}
resource "lovi_cpu_pinning_group" "team034" {
  name = "team034"
  count_of_core = 4
  hypervisor_name = "isucn0002"
}

resource "lovi_virtual_machine" "problem-team034" {
  count = var.node_count

  name = "team034-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team034.name

  depends_on = [
    lovi_cpu_pinning_group.team034
  ]
}

resource "lovi_interface_attachment" "problem-team034" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team034[count.index].id
  bridge_id = lovi_bridge.team034.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t034-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team034[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team034,
    lovi_lease.problem-team034
  ]
}

resource "lovi_address" "bench-team034" {
  subnet_id = lovi_subnet.team034.id
  fixed_ip = "10.160.34.104"
}

resource "lovi_lease" "bench-team034" {
  address_id = lovi_address.bench-team034.id

  depends_on = [lovi_address.bench-team034]
}

resource "lovi_virtual_machine" "bench-team034" {
  name = "team034-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team034,
    lovi_cpu_pinning_group.team034
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team034.name
}

resource "lovi_interface_attachment" "bench-team034" {
  virtual_machine_id = lovi_virtual_machine.bench-team034.id
  bridge_id = lovi_bridge.team034.id
  average = 12500 // NOTE: 100Mbps
  name = "t034-be"
  lease_id = lovi_lease.bench-team034.id

  depends_on = [
    lovi_virtual_machine.bench-team034,
    lovi_lease.bench-team034
  ]
}

resource "lovi_address" "bastion100-team034" {
  subnet_id = lovi_subnet.team034.id
  fixed_ip = "10.160.34.100"
}

resource "lovi_lease" "bastion100-team034" {
  address_id = lovi_address.bastion100-team034.id

  depends_on = [lovi_address.bastion100-team034]
}

resource "lovi_virtual_machine" "bastion100-team034" {
  name = "team034-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team034,
  ]
}

resource "lovi_interface_attachment" "bastion100-team034" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team034.id
  bridge_id = lovi_bridge.team034.id
  average = 125000 // NOTE: 1Gbps
  name = "t034-ba100"
  lease_id = lovi_lease.bastion100-team034.id

  depends_on = [
    lovi_virtual_machine.bastion100-team034,
    lovi_lease.bastion100-team034
  ]
}
resource "lovi_address" "bastion200-team034" {
  subnet_id = lovi_subnet.team034.id
  fixed_ip = "10.160.34.200"
}

resource "lovi_lease" "bastion200-team034" {
  address_id = lovi_address.bastion200-team034.id

  depends_on = [lovi_address.bastion200-team034]
}

resource "lovi_virtual_machine" "bastion200-team034" {
  name = "team034-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team034,
  ]
}

resource "lovi_interface_attachment" "bastion200-team034" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team034.id
  bridge_id = lovi_bridge.team034.id
  average = 125000 // NOTE: 1Gbps
  name = "t034-ba200"
  lease_id = lovi_lease.bastion200-team034.id

  depends_on = [
    lovi_virtual_machine.bastion200-team034,
    lovi_lease.bastion200-team034
  ]
}