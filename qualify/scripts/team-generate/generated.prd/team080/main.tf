resource "lovi_subnet" "team080" {
  name = "team080"
  vlan_id = 1000 + 80
  network = "10.160.80.0/24"
  start = "10.160.80.100"
  end = "10.160.80.200"
  gateway = "10.160.80.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.80.1"
}

resource "lovi_bridge" "team080" {
  name = "team080"
  vlan_id = 1000 + 80

  depends_on = [lovi_subnet.team080]
}

resource "lovi_internal_bridge" "team080" {
  name = "team080-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team080" {
  count = var.node_count

  subnet_id = lovi_subnet.team080.id
  fixed_ip = "10.160.80.${101 + count.index}"
}

resource "lovi_lease" "problem-team080" {
  count = var.node_count

  address_id = lovi_address.problem-team080[count.index].id

  depends_on = [lovi_address.problem-team080]
}
resource "lovi_cpu_pinning_group" "team080" {
  name = "team080"
  count_of_core = 4
  hypervisor_name = "isucn0004"
}

resource "lovi_virtual_machine" "problem-team080" {
  count = var.node_count

  name = "team080-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0004"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team080.name

  depends_on = [
    lovi_cpu_pinning_group.team080
  ]
}

resource "lovi_interface_attachment" "problem-team080" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team080[count.index].id
  bridge_id = lovi_bridge.team080.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t080-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team080[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team080,
    lovi_lease.problem-team080
  ]
}

resource "lovi_address" "bench-team080" {
  subnet_id = lovi_subnet.team080.id
  fixed_ip = "10.160.80.104"
}

resource "lovi_lease" "bench-team080" {
  address_id = lovi_address.bench-team080.id

  depends_on = [lovi_address.bench-team080]
}

resource "lovi_virtual_machine" "bench-team080" {
  name = "team080-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0004"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team080,
    lovi_cpu_pinning_group.team080
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team080.name
}

resource "lovi_interface_attachment" "bench-team080" {
  virtual_machine_id = lovi_virtual_machine.bench-team080.id
  bridge_id = lovi_bridge.team080.id
  average = 12500 // NOTE: 100Mbps
  name = "t080-be"
  lease_id = lovi_lease.bench-team080.id

  depends_on = [
    lovi_virtual_machine.bench-team080,
    lovi_lease.bench-team080
  ]
}

resource "lovi_address" "bastion100-team080" {
  subnet_id = lovi_subnet.team080.id
  fixed_ip = "10.160.80.100"
}

resource "lovi_lease" "bastion100-team080" {
  address_id = lovi_address.bastion100-team080.id

  depends_on = [lovi_address.bastion100-team080]
}

resource "lovi_virtual_machine" "bastion100-team080" {
  name = "team080-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team080,
  ]
}

resource "lovi_interface_attachment" "bastion100-team080" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team080.id
  bridge_id = lovi_bridge.team080.id
  average = 125000 // NOTE: 1Gbps
  name = "t080-ba100"
  lease_id = lovi_lease.bastion100-team080.id

  depends_on = [
    lovi_virtual_machine.bastion100-team080,
    lovi_lease.bastion100-team080
  ]
}
resource "lovi_address" "bastion200-team080" {
  subnet_id = lovi_subnet.team080.id
  fixed_ip = "10.160.80.200"
}

resource "lovi_lease" "bastion200-team080" {
  address_id = lovi_address.bastion200-team080.id

  depends_on = [lovi_address.bastion200-team080]
}

resource "lovi_virtual_machine" "bastion200-team080" {
  name = "team080-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team080,
  ]
}

resource "lovi_interface_attachment" "bastion200-team080" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team080.id
  bridge_id = lovi_bridge.team080.id
  average = 125000 // NOTE: 1Gbps
  name = "t080-ba200"
  lease_id = lovi_lease.bastion200-team080.id

  depends_on = [
    lovi_virtual_machine.bastion200-team080,
    lovi_lease.bastion200-team080
  ]
}