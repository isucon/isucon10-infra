resource "lovi_subnet" "team292" {
  name = "team292"
  vlan_id = 1000 + 292
  network = "10.162.92.0/24"
  start = "10.162.92.100"
  end = "10.162.92.200"
  gateway = "10.162.92.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.92.1"
}

resource "lovi_bridge" "team292" {
  name = "team292"
  vlan_id = 1000 + 292

  depends_on = [lovi_subnet.team292]
}

resource "lovi_internal_bridge" "team292" {
  name = "team292-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team292" {
  count = var.node_count

  subnet_id = lovi_subnet.team292.id
  fixed_ip = "10.162.92.${101 + count.index}"
}

resource "lovi_lease" "problem-team292" {
  count = var.node_count

  address_id = lovi_address.problem-team292[count.index].id

  depends_on = [lovi_address.problem-team292]
}
resource "lovi_cpu_pinning_group" "team292" {
  name = "team292"
  count_of_core = 4
  hypervisor_name = "isucn0013"
}

resource "lovi_virtual_machine" "problem-team292" {
  count = var.node_count

  name = "team292-${format("%03d", count.index + 1)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team292.name

  depends_on = [
    lovi_cpu_pinning_group.team292
  ]
}

resource "lovi_interface_attachment" "problem-team292" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team292[count.index].id
  bridge_id = lovi_bridge.team292.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t292-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team292[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team292,
    lovi_lease.problem-team292
  ]
}

resource "lovi_address" "bench-team292" {
  subnet_id = lovi_subnet.team292.id
  fixed_ip = "10.162.92.104"
}

resource "lovi_lease" "bench-team292" {
  address_id = lovi_address.bench-team292.id

  depends_on = [lovi_address.bench-team292]
}

resource "lovi_virtual_machine" "bench-team292" {
  name = "team292-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0013"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team292,
    lovi_cpu_pinning_group.team292
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team292.name
}

resource "lovi_interface_attachment" "bench-team292" {
  virtual_machine_id = lovi_virtual_machine.bench-team292.id
  bridge_id = lovi_bridge.team292.id
  average = 12500 // NOTE: 100Mbps
  name = "t292-be"
  lease_id = lovi_lease.bench-team292.id

  depends_on = [
    lovi_virtual_machine.bench-team292,
    lovi_lease.bench-team292
  ]
}

resource "lovi_address" "bastion100-team292" {
  subnet_id = lovi_subnet.team292.id
  fixed_ip = "10.162.92.100"
}

resource "lovi_lease" "bastion100-team292" {
  address_id = lovi_address.bastion100-team292.id

  depends_on = [lovi_address.bastion100-team292]
}

resource "lovi_virtual_machine" "bastion100-team292" {
  name = "team292-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team292,
  ]
}

resource "lovi_interface_attachment" "bastion100-team292" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team292.id
  bridge_id = lovi_bridge.team292.id
  average = 125000 // NOTE: 1Gbps
  name = "t292-ba100"
  lease_id = lovi_lease.bastion100-team292.id

  depends_on = [
    lovi_virtual_machine.bastion100-team292,
    lovi_lease.bastion100-team292
  ]
}
resource "lovi_address" "bastion200-team292" {
  subnet_id = lovi_subnet.team292.id
  fixed_ip = "10.162.92.200"
}

resource "lovi_lease" "bastion200-team292" {
  address_id = lovi_address.bastion200-team292.id

  depends_on = [lovi_address.bastion200-team292]
}

resource "lovi_virtual_machine" "bastion200-team292" {
  name = "team292-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team292,
  ]
}

resource "lovi_interface_attachment" "bastion200-team292" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team292.id
  bridge_id = lovi_bridge.team292.id
  average = 125000 // NOTE: 1Gbps
  name = "t292-ba200"
  lease_id = lovi_lease.bastion200-team292.id

  depends_on = [
    lovi_virtual_machine.bastion200-team292,
    lovi_lease.bastion200-team292
  ]
}