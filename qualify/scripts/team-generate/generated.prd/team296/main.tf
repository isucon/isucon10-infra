resource "lovi_subnet" "team296" {
  name = "team296"
  vlan_id = 1000 + 296
  network = "10.162.96.0/24"
  start = "10.162.96.100"
  end = "10.162.96.200"
  gateway = "10.162.96.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.96.1"
}

resource "lovi_bridge" "team296" {
  name = "team296"
  vlan_id = 1000 + 296

  depends_on = [lovi_subnet.team296]
}

resource "lovi_internal_bridge" "team296" {
  name = "team296-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team296" {
  count = var.node_count

  subnet_id = lovi_subnet.team296.id
  fixed_ip = "10.162.96.${101 + count.index}"
}

resource "lovi_lease" "problem-team296" {
  count = var.node_count

  address_id = lovi_address.problem-team296[count.index].id

  depends_on = [lovi_address.problem-team296]
}
resource "lovi_cpu_pinning_group" "team296" {
  name = "team296"
  count_of_core = 4
  hypervisor_name = "isucn0014"
}

resource "lovi_virtual_machine" "problem-team296" {
  count = var.node_count

  name = "team296-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "23e33fcd-1951-4185-ba47-0a6fb1dcf50e"
  hypervisor_name = "isucn0014"
  europa_backend_name = "dorado002"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team296.name

  depends_on = [
    lovi_cpu_pinning_group.team296
  ]
}

resource "lovi_interface_attachment" "problem-team296" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team296[count.index].id
  bridge_id = lovi_bridge.team296.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t296-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team296[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team296,
    lovi_lease.problem-team296
  ]
}

resource "lovi_address" "bench-team296" {
  subnet_id = lovi_subnet.team296.id
  fixed_ip = "10.162.96.104"
}

resource "lovi_lease" "bench-team296" {
  address_id = lovi_address.bench-team296.id

  depends_on = [lovi_address.bench-team296]
}

resource "lovi_virtual_machine" "bench-team296" {
  name = "team296-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0014"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team296,
    lovi_cpu_pinning_group.team296
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team296.name
}

resource "lovi_interface_attachment" "bench-team296" {
  virtual_machine_id = lovi_virtual_machine.bench-team296.id
  bridge_id = lovi_bridge.team296.id
  average = 12500 // NOTE: 100Mbps
  name = "t296-be"
  lease_id = lovi_lease.bench-team296.id

  depends_on = [
    lovi_virtual_machine.bench-team296,
    lovi_lease.bench-team296
  ]
}

resource "lovi_address" "bastion100-team296" {
  subnet_id = lovi_subnet.team296.id
  fixed_ip = "10.162.96.100"
}

resource "lovi_lease" "bastion100-team296" {
  address_id = lovi_address.bastion100-team296.id

  depends_on = [lovi_address.bastion100-team296]
}

resource "lovi_virtual_machine" "bastion100-team296" {
  name = "team296-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team296,
  ]
}

resource "lovi_interface_attachment" "bastion100-team296" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team296.id
  bridge_id = lovi_bridge.team296.id
  average = 125000 // NOTE: 1Gbps
  name = "t296-ba100"
  lease_id = lovi_lease.bastion100-team296.id

  depends_on = [
    lovi_virtual_machine.bastion100-team296,
    lovi_lease.bastion100-team296
  ]
}
resource "lovi_address" "bastion200-team296" {
  subnet_id = lovi_subnet.team296.id
  fixed_ip = "10.162.96.200"
}

resource "lovi_lease" "bastion200-team296" {
  address_id = lovi_address.bastion200-team296.id

  depends_on = [lovi_address.bastion200-team296]
}

resource "lovi_virtual_machine" "bastion200-team296" {
  name = "team296-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team296,
  ]
}

resource "lovi_interface_attachment" "bastion200-team296" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team296.id
  bridge_id = lovi_bridge.team296.id
  average = 125000 // NOTE: 1Gbps
  name = "t296-ba200"
  lease_id = lovi_lease.bastion200-team296.id

  depends_on = [
    lovi_virtual_machine.bastion200-team296,
    lovi_lease.bastion200-team296
  ]
}