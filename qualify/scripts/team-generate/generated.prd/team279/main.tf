resource "lovi_subnet" "team279" {
  name = "team279"
  vlan_id = 1000 + 279
  network = "10.162.79.0/24"
  start = "10.162.79.100"
  end = "10.162.79.200"
  gateway = "10.162.79.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.79.1"
}

resource "lovi_bridge" "team279" {
  name = "team279"
  vlan_id = 1000 + 279

  depends_on = [lovi_subnet.team279]
}

resource "lovi_internal_bridge" "team279" {
  name = "team279-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team279" {
  count = var.node_count

  subnet_id = lovi_subnet.team279.id
  fixed_ip = "10.162.79.${101 + count.index}"
}

resource "lovi_lease" "problem-team279" {
  count = var.node_count

  address_id = lovi_address.problem-team279[count.index].id

  depends_on = [lovi_address.problem-team279]
}
resource "lovi_cpu_pinning_group" "team279" {
  name = "team279"
  count_of_core = 4
  hypervisor_name = "isucn0013"
}

resource "lovi_virtual_machine" "problem-team279" {
  count = var.node_count

  name = "team279-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "23e33fcd-1951-4185-ba47-0a6fb1dcf50e"
  hypervisor_name = "isucn0013"
  europa_backend_name = "dorado002"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team279.name

  depends_on = [
    lovi_cpu_pinning_group.team279
  ]
}

resource "lovi_interface_attachment" "problem-team279" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team279[count.index].id
  bridge_id = lovi_bridge.team279.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t279-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team279[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team279,
    lovi_lease.problem-team279
  ]
}

resource "lovi_address" "bench-team279" {
  subnet_id = lovi_subnet.team279.id
  fixed_ip = "10.162.79.104"
}

resource "lovi_lease" "bench-team279" {
  address_id = lovi_address.bench-team279.id

  depends_on = [lovi_address.bench-team279]
}

resource "lovi_virtual_machine" "bench-team279" {
  name = "team279-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0013"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team279,
    lovi_cpu_pinning_group.team279
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team279.name
}

resource "lovi_interface_attachment" "bench-team279" {
  virtual_machine_id = lovi_virtual_machine.bench-team279.id
  bridge_id = lovi_bridge.team279.id
  average = 12500 // NOTE: 100Mbps
  name = "t279-be"
  lease_id = lovi_lease.bench-team279.id

  depends_on = [
    lovi_virtual_machine.bench-team279,
    lovi_lease.bench-team279
  ]
}

resource "lovi_address" "bastion100-team279" {
  subnet_id = lovi_subnet.team279.id
  fixed_ip = "10.162.79.100"
}

resource "lovi_lease" "bastion100-team279" {
  address_id = lovi_address.bastion100-team279.id

  depends_on = [lovi_address.bastion100-team279]
}

resource "lovi_virtual_machine" "bastion100-team279" {
  name = "team279-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team279,
  ]
}

resource "lovi_interface_attachment" "bastion100-team279" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team279.id
  bridge_id = lovi_bridge.team279.id
  average = 125000 // NOTE: 1Gbps
  name = "t279-ba100"
  lease_id = lovi_lease.bastion100-team279.id

  depends_on = [
    lovi_virtual_machine.bastion100-team279,
    lovi_lease.bastion100-team279
  ]
}
resource "lovi_address" "bastion200-team279" {
  subnet_id = lovi_subnet.team279.id
  fixed_ip = "10.162.79.200"
}

resource "lovi_lease" "bastion200-team279" {
  address_id = lovi_address.bastion200-team279.id

  depends_on = [lovi_address.bastion200-team279]
}

resource "lovi_virtual_machine" "bastion200-team279" {
  name = "team279-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team279,
  ]
}

resource "lovi_interface_attachment" "bastion200-team279" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team279.id
  bridge_id = lovi_bridge.team279.id
  average = 125000 // NOTE: 1Gbps
  name = "t279-ba200"
  lease_id = lovi_lease.bastion200-team279.id

  depends_on = [
    lovi_virtual_machine.bastion200-team279,
    lovi_lease.bastion200-team279
  ]
}