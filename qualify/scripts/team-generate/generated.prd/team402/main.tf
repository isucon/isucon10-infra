resource "lovi_subnet" "team402" {
  name = "team402"
  vlan_id = 1000 + 402
  network = "10.164.2.0/24"
  start = "10.164.2.100"
  end = "10.164.2.200"
  gateway = "10.164.2.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.164.2.1"
}

resource "lovi_bridge" "team402" {
  name = "team402"
  vlan_id = 1000 + 402

  depends_on = [lovi_subnet.team402]
}

resource "lovi_internal_bridge" "team402" {
  name = "team402-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team402" {
  count = var.node_count

  subnet_id = lovi_subnet.team402.id
  fixed_ip = "10.164.2.${101 + count.index}"
}

resource "lovi_lease" "problem-team402" {
  count = var.node_count

  address_id = lovi_address.problem-team402[count.index].id

  depends_on = [lovi_address.problem-team402]
}
resource "lovi_cpu_pinning_group" "team402" {
  name = "team402"
  count_of_core = 4
  hypervisor_name = "isucn0018"
}

resource "lovi_virtual_machine" "problem-team402" {
  count = var.node_count

  name = "team402-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "23e33fcd-1951-4185-ba47-0a6fb1dcf50e"
  hypervisor_name = "isucn0018"
  europa_backend_name = "dorado002"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team402.name

  depends_on = [
    lovi_cpu_pinning_group.team402
  ]
}

resource "lovi_interface_attachment" "problem-team402" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team402[count.index].id
  bridge_id = lovi_bridge.team402.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t402-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team402[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team402,
    lovi_lease.problem-team402
  ]
}

resource "lovi_address" "bench-team402" {
  subnet_id = lovi_subnet.team402.id
  fixed_ip = "10.164.2.104"
}

resource "lovi_lease" "bench-team402" {
  address_id = lovi_address.bench-team402.id

  depends_on = [lovi_address.bench-team402]
}

resource "lovi_virtual_machine" "bench-team402" {
  name = "team402-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0018"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team402,
    lovi_cpu_pinning_group.team402
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team402.name
}

resource "lovi_interface_attachment" "bench-team402" {
  virtual_machine_id = lovi_virtual_machine.bench-team402.id
  bridge_id = lovi_bridge.team402.id
  average = 12500 // NOTE: 100Mbps
  name = "t402-be"
  lease_id = lovi_lease.bench-team402.id

  depends_on = [
    lovi_virtual_machine.bench-team402,
    lovi_lease.bench-team402
  ]
}

resource "lovi_address" "bastion100-team402" {
  subnet_id = lovi_subnet.team402.id
  fixed_ip = "10.164.2.100"
}

resource "lovi_lease" "bastion100-team402" {
  address_id = lovi_address.bastion100-team402.id

  depends_on = [lovi_address.bastion100-team402]
}

resource "lovi_virtual_machine" "bastion100-team402" {
  name = "team402-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team402,
  ]
}

resource "lovi_interface_attachment" "bastion100-team402" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team402.id
  bridge_id = lovi_bridge.team402.id
  average = 125000 // NOTE: 1Gbps
  name = "t402-ba100"
  lease_id = lovi_lease.bastion100-team402.id

  depends_on = [
    lovi_virtual_machine.bastion100-team402,
    lovi_lease.bastion100-team402
  ]
}
resource "lovi_address" "bastion200-team402" {
  subnet_id = lovi_subnet.team402.id
  fixed_ip = "10.164.2.200"
}

resource "lovi_lease" "bastion200-team402" {
  address_id = lovi_address.bastion200-team402.id

  depends_on = [lovi_address.bastion200-team402]
}

resource "lovi_virtual_machine" "bastion200-team402" {
  name = "team402-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team402,
  ]
}

resource "lovi_interface_attachment" "bastion200-team402" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team402.id
  bridge_id = lovi_bridge.team402.id
  average = 125000 // NOTE: 1Gbps
  name = "t402-ba200"
  lease_id = lovi_lease.bastion200-team402.id

  depends_on = [
    lovi_virtual_machine.bastion200-team402,
    lovi_lease.bastion200-team402
  ]
}