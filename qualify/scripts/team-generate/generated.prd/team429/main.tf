resource "lovi_subnet" "team429" {
  name = "team429"
  vlan_id = 1000 + 429
  network = "10.164.29.0/24"
  start = "10.164.29.100"
  end = "10.164.29.200"
  gateway = "10.164.29.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.164.29.1"
}

resource "lovi_bridge" "team429" {
  name = "team429"
  vlan_id = 1000 + 429

  depends_on = [lovi_subnet.team429]
}

resource "lovi_internal_bridge" "team429" {
  name = "team429-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team429" {
  count = var.node_count

  subnet_id = lovi_subnet.team429.id
  fixed_ip = "10.164.29.${101 + count.index}"
}

resource "lovi_lease" "problem-team429" {
  count = var.node_count

  address_id = lovi_address.problem-team429[count.index].id

  depends_on = [lovi_address.problem-team429]
}
resource "lovi_cpu_pinning_group" "team429" {
  name = "team429"
  count_of_core = 4
  hypervisor_name = "isucn0020"
}

resource "lovi_virtual_machine" "problem-team429" {
  count = var.node_count

  name = "team429-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "23e33fcd-1951-4185-ba47-0a6fb1dcf50e"
  hypervisor_name = "isucn0020"
  europa_backend_name = "dorado002"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team429.name

  depends_on = [
    lovi_cpu_pinning_group.team429
  ]
}

resource "lovi_interface_attachment" "problem-team429" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team429[count.index].id
  bridge_id = lovi_bridge.team429.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t429-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team429[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team429,
    lovi_lease.problem-team429
  ]
}

resource "lovi_address" "bench-team429" {
  subnet_id = lovi_subnet.team429.id
  fixed_ip = "10.164.29.104"
}

resource "lovi_lease" "bench-team429" {
  address_id = lovi_address.bench-team429.id

  depends_on = [lovi_address.bench-team429]
}

resource "lovi_virtual_machine" "bench-team429" {
  name = "team429-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0020"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team429,
    lovi_cpu_pinning_group.team429
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team429.name
}

resource "lovi_interface_attachment" "bench-team429" {
  virtual_machine_id = lovi_virtual_machine.bench-team429.id
  bridge_id = lovi_bridge.team429.id
  average = 12500 // NOTE: 100Mbps
  name = "t429-be"
  lease_id = lovi_lease.bench-team429.id

  depends_on = [
    lovi_virtual_machine.bench-team429,
    lovi_lease.bench-team429
  ]
}

resource "lovi_address" "bastion100-team429" {
  subnet_id = lovi_subnet.team429.id
  fixed_ip = "10.164.29.100"
}

resource "lovi_lease" "bastion100-team429" {
  address_id = lovi_address.bastion100-team429.id

  depends_on = [lovi_address.bastion100-team429]
}

resource "lovi_virtual_machine" "bastion100-team429" {
  name = "team429-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team429,
  ]
}

resource "lovi_interface_attachment" "bastion100-team429" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team429.id
  bridge_id = lovi_bridge.team429.id
  average = 125000 // NOTE: 1Gbps
  name = "t429-ba100"
  lease_id = lovi_lease.bastion100-team429.id

  depends_on = [
    lovi_virtual_machine.bastion100-team429,
    lovi_lease.bastion100-team429
  ]
}
resource "lovi_address" "bastion200-team429" {
  subnet_id = lovi_subnet.team429.id
  fixed_ip = "10.164.29.200"
}

resource "lovi_lease" "bastion200-team429" {
  address_id = lovi_address.bastion200-team429.id

  depends_on = [lovi_address.bastion200-team429]
}

resource "lovi_virtual_machine" "bastion200-team429" {
  name = "team429-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team429,
  ]
}

resource "lovi_interface_attachment" "bastion200-team429" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team429.id
  bridge_id = lovi_bridge.team429.id
  average = 125000 // NOTE: 1Gbps
  name = "t429-ba200"
  lease_id = lovi_lease.bastion200-team429.id

  depends_on = [
    lovi_virtual_machine.bastion200-team429,
    lovi_lease.bastion200-team429
  ]
}