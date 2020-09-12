resource "lovi_subnet" "team276" {
  name = "team276"
  vlan_id = 1000 + 276
  network = "10.162.76.0/24"
  start = "10.162.76.100"
  end = "10.162.76.200"
  gateway = "10.162.76.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.76.1"
}

resource "lovi_bridge" "team276" {
  name = "team276"
  vlan_id = 1000 + 276

  depends_on = [lovi_subnet.team276]
}

resource "lovi_internal_bridge" "team276" {
  name = "team276-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team276" {
  count = var.node_count

  subnet_id = lovi_subnet.team276.id
  fixed_ip = "10.162.76.${101 + count.index}"
}

resource "lovi_lease" "problem-team276" {
  count = var.node_count

  address_id = lovi_address.problem-team276[count.index].id

  depends_on = [lovi_address.problem-team276]
}
resource "lovi_cpu_pinning_group" "team276" {
  name = "team276"
  count_of_core = 4
  hypervisor_name = "isucn0013"
}

resource "lovi_virtual_machine" "problem-team276" {
  count = var.node_count

  name = "team276-${format("%03d", count.index + 1)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team276.name

  depends_on = [
    lovi_cpu_pinning_group.team276
  ]
}

resource "lovi_interface_attachment" "problem-team276" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team276[count.index].id
  bridge_id = lovi_bridge.team276.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t276-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team276[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team276,
    lovi_lease.problem-team276
  ]
}

resource "lovi_address" "bench-team276" {
  subnet_id = lovi_subnet.team276.id
  fixed_ip = "10.162.76.104"
}

resource "lovi_lease" "bench-team276" {
  address_id = lovi_address.bench-team276.id

  depends_on = [lovi_address.bench-team276]
}

resource "lovi_virtual_machine" "bench-team276" {
  name = "team276-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "8dea495b-373e-49ca-9b79-caa63e842c7f"
  hypervisor_name = "isucn0013"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team276,
    lovi_cpu_pinning_group.team276
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team276.name
}

resource "lovi_interface_attachment" "bench-team276" {
  virtual_machine_id = lovi_virtual_machine.bench-team276.id
  bridge_id = lovi_bridge.team276.id
  average = 12500 // NOTE: 100Mbps
  name = "t276-be"
  lease_id = lovi_lease.bench-team276.id

  depends_on = [
    lovi_virtual_machine.bench-team276,
    lovi_lease.bench-team276
  ]
}

resource "lovi_address" "bastion100-team276" {
  subnet_id = lovi_subnet.team276.id
  fixed_ip = "10.162.76.100"
}

resource "lovi_lease" "bastion100-team276" {
  address_id = lovi_address.bastion100-team276.id

  depends_on = [lovi_address.bastion100-team276]
}

resource "lovi_virtual_machine" "bastion100-team276" {
  name = "team276-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team276,
  ]
}

resource "lovi_interface_attachment" "bastion100-team276" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team276.id
  bridge_id = lovi_bridge.team276.id
  average = 125000 // NOTE: 1Gbps
  name = "t276-ba100"
  lease_id = lovi_lease.bastion100-team276.id

  depends_on = [
    lovi_virtual_machine.bastion100-team276,
    lovi_lease.bastion100-team276
  ]
}
resource "lovi_address" "bastion200-team276" {
  subnet_id = lovi_subnet.team276.id
  fixed_ip = "10.162.76.200"
}

resource "lovi_lease" "bastion200-team276" {
  address_id = lovi_address.bastion200-team276.id

  depends_on = [lovi_address.bastion200-team276]
}

resource "lovi_virtual_machine" "bastion200-team276" {
  name = "team276-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_virtual_machine.problem-team276,
  ]
}

resource "lovi_interface_attachment" "bastion200-team276" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team276.id
  bridge_id = lovi_bridge.team276.id
  average = 125000 // NOTE: 1Gbps
  name = "t276-ba200"
  lease_id = lovi_lease.bastion200-team276.id

  depends_on = [
    lovi_virtual_machine.bastion200-team276,
    lovi_lease.bastion200-team276
  ]
}