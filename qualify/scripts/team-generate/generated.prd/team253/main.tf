resource "lovi_subnet" "team253" {
  name = "team253"
  vlan_id = 1000 + 253
  network = "10.162.53.0/24"
  start = "10.162.53.100"
  end = "10.162.53.200"
  gateway = "10.162.53.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.53.1"
}

resource "lovi_bridge" "team253" {
  name = "team253"
  vlan_id = 1000 + 253

  depends_on = [lovi_subnet.team253]
}

resource "lovi_internal_bridge" "team253" {
  name = "team253-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team253" {
  count = var.node_count

  subnet_id = lovi_subnet.team253.id
  fixed_ip = "10.162.53.${101 + count.index}"
}

resource "lovi_lease" "problem-team253" {
  count = var.node_count

  address_id = lovi_address.problem-team253[count.index].id

  depends_on = [lovi_address.problem-team253]
}
resource "lovi_cpu_pinning_group" "team253" {
  name = "team253"
  count_of_core = 4
  hypervisor_name = "isucn0012"
}

resource "lovi_virtual_machine" "problem-team253" {
  count = var.node_count

  name = "team253-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "1ab68dff-7d0d-40b5-abff-3ef0db2618b1"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team253.name

  depends_on = [
    lovi_cpu_pinning_group.team253
  ]
}

resource "lovi_interface_attachment" "problem-team253" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team253[count.index].id
  bridge_id = lovi_bridge.team253.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t253-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team253[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team253,
    lovi_lease.problem-team253
  ]
}

resource "lovi_address" "bench-team253" {
  subnet_id = lovi_subnet.team253.id
  fixed_ip = "10.162.53.104"
}

resource "lovi_lease" "bench-team253" {
  address_id = lovi_address.bench-team253.id

  depends_on = [lovi_address.bench-team253]
}

resource "lovi_virtual_machine" "bench-team253" {
  name = "team253-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "10eee589-725b-4686-a424-1df5e161b031"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team253,
    lovi_cpu_pinning_group.team253
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team253.name
}

resource "lovi_interface_attachment" "bench-team253" {
  virtual_machine_id = lovi_virtual_machine.bench-team253.id
  bridge_id = lovi_bridge.team253.id
  average = 12500 // NOTE: 100Mbps
  name = "t253-be"
  lease_id = lovi_lease.bench-team253.id

  depends_on = [
    lovi_virtual_machine.bench-team253,
    lovi_lease.bench-team253
  ]
}

resource "lovi_address" "bastion100-team253" {
  subnet_id = lovi_subnet.team253.id
  fixed_ip = "10.162.53.100"
}

resource "lovi_lease" "bastion100-team253" {
  address_id = lovi_address.bastion100-team253.id

  depends_on = [lovi_address.bastion100-team253]
}

resource "lovi_virtual_machine" "bastion100-team253" {
  name = "team253-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team253,
  ]
}

resource "lovi_interface_attachment" "bastion100-team253" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team253.id
  bridge_id = lovi_bridge.team253.id
  average = 125000 // NOTE: 1Gbps
  name = "t253-ba100"
  lease_id = lovi_lease.bastion100-team253.id

  depends_on = [
    lovi_virtual_machine.bastion100-team253,
    lovi_lease.bastion100-team253
  ]
}
resource "lovi_address" "bastion200-team253" {
  subnet_id = lovi_subnet.team253.id
  fixed_ip = "10.162.53.200"
}

resource "lovi_lease" "bastion200-team253" {
  address_id = lovi_address.bastion200-team253.id

  depends_on = [lovi_address.bastion200-team253]
}

resource "lovi_virtual_machine" "bastion200-team253" {
  name = "team253-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team253,
  ]
}

resource "lovi_interface_attachment" "bastion200-team253" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team253.id
  bridge_id = lovi_bridge.team253.id
  average = 125000 // NOTE: 1Gbps
  name = "t253-ba200"
  lease_id = lovi_lease.bastion200-team253.id

  depends_on = [
    lovi_virtual_machine.bastion200-team253,
    lovi_lease.bastion200-team253
  ]
}