resource "lovi_subnet" "team512" {
  name = "team512"
  vlan_id = 1000 + 512
  network = "10.165.12.0/24"
  start = "10.165.12.100"
  end = "10.165.12.200"
  gateway = "10.165.12.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.12.1"
}

resource "lovi_bridge" "team512" {
  name = "team512"
  vlan_id = 1000 + 512

  depends_on = [lovi_subnet.team512]
}

resource "lovi_internal_bridge" "team512" {
  name = "team512-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team512" {
  count = var.node_count

  subnet_id = lovi_subnet.team512.id
  fixed_ip = "10.165.12.${101 + count.index}"
}

resource "lovi_lease" "problem-team512" {
  count = var.node_count

  address_id = lovi_address.problem-team512[count.index].id

  depends_on = [lovi_address.problem-team512]
}
resource "lovi_cpu_pinning_group" "team512" {
  name = "team512"
  count_of_core = 4
  hypervisor_name = "isucn0023"
}

resource "lovi_virtual_machine" "problem-team512" {
  count = var.node_count

  name = "team512-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "23e33fcd-1951-4185-ba47-0a6fb1dcf50e"
  hypervisor_name = "isucn0023"
  europa_backend_name = "dorado002"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team512.name

  depends_on = [
    lovi_cpu_pinning_group.team512
  ]
}

resource "lovi_interface_attachment" "problem-team512" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team512[count.index].id
  bridge_id = lovi_bridge.team512.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t512-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team512[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team512,
    lovi_lease.problem-team512
  ]
}

resource "lovi_address" "bench-team512" {
  subnet_id = lovi_subnet.team512.id
  fixed_ip = "10.165.12.104"
}

resource "lovi_lease" "bench-team512" {
  address_id = lovi_address.bench-team512.id

  depends_on = [lovi_address.bench-team512]
}

resource "lovi_virtual_machine" "bench-team512" {
  name = "team512-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0023"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team512,
    lovi_cpu_pinning_group.team512
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team512.name
}

resource "lovi_interface_attachment" "bench-team512" {
  virtual_machine_id = lovi_virtual_machine.bench-team512.id
  bridge_id = lovi_bridge.team512.id
  average = 12500 // NOTE: 100Mbps
  name = "t512-be"
  lease_id = lovi_lease.bench-team512.id

  depends_on = [
    lovi_virtual_machine.bench-team512,
    lovi_lease.bench-team512
  ]
}

resource "lovi_address" "bastion100-team512" {
  subnet_id = lovi_subnet.team512.id
  fixed_ip = "10.165.12.100"
}

resource "lovi_lease" "bastion100-team512" {
  address_id = lovi_address.bastion100-team512.id

  depends_on = [lovi_address.bastion100-team512]
}

resource "lovi_virtual_machine" "bastion100-team512" {
  name = "team512-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team512,
  ]
}

resource "lovi_interface_attachment" "bastion100-team512" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team512.id
  bridge_id = lovi_bridge.team512.id
  average = 125000 // NOTE: 1Gbps
  name = "t512-ba100"
  lease_id = lovi_lease.bastion100-team512.id

  depends_on = [
    lovi_virtual_machine.bastion100-team512,
    lovi_lease.bastion100-team512
  ]
}
resource "lovi_address" "bastion200-team512" {
  subnet_id = lovi_subnet.team512.id
  fixed_ip = "10.165.12.200"
}

resource "lovi_lease" "bastion200-team512" {
  address_id = lovi_address.bastion200-team512.id

  depends_on = [lovi_address.bastion200-team512]
}

resource "lovi_virtual_machine" "bastion200-team512" {
  name = "team512-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team512,
  ]
}

resource "lovi_interface_attachment" "bastion200-team512" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team512.id
  bridge_id = lovi_bridge.team512.id
  average = 125000 // NOTE: 1Gbps
  name = "t512-ba200"
  lease_id = lovi_lease.bastion200-team512.id

  depends_on = [
    lovi_virtual_machine.bastion200-team512,
    lovi_lease.bastion200-team512
  ]
}