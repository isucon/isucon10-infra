resource "lovi_subnet" "team428" {
  name = "team428"
  vlan_id = 1000 + 428
  network = "10.164.28.0/24"
  start = "10.164.28.100"
  end = "10.164.28.200"
  gateway = "10.164.28.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.164.28.1"
}

resource "lovi_bridge" "team428" {
  name = "team428"
  vlan_id = 1000 + 428

  depends_on = [lovi_subnet.team428]
}

resource "lovi_internal_bridge" "team428" {
  name = "team428-in"
}

resource "lovi_cpu_pinning_group" "team428" {
  name = "team428"
  count_of_core = 12
  hypervisor_name = "isucn0015"
}

resource "lovi_address" "problem-team428-1" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.${100 + 1}"

  depends_on = [lovi_subnet.team428]
}

resource "lovi_lease" "problem-team428-1" {
  address_id = lovi_address.problem-team428-1.id

  depends_on = [lovi_address.problem-team428-1]
}

resource "lovi_virtual_machine" "problem-team428-1" {
  name = "team428-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0015"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team428.name

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "problem-team428-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team428-1.id
  bridge_id = lovi_bridge.team428.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t428-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team428-1.id

  depends_on = [
    lovi_virtual_machine.problem-team428-1,
    lovi_lease.problem-team428-1
  ]
}
resource "lovi_address" "problem-team428-2" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.${100 + 2}"

  depends_on = [lovi_subnet.team428]
}

resource "lovi_lease" "problem-team428-2" {
  address_id = lovi_address.problem-team428-2.id

  depends_on = [lovi_address.problem-team428-2]
}

resource "lovi_virtual_machine" "problem-team428-2" {
  name = "team428-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0015"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team428.name

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "problem-team428-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team428-2.id
  bridge_id = lovi_bridge.team428.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t428-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team428-2.id

  depends_on = [
    lovi_virtual_machine.problem-team428-2,
    lovi_lease.problem-team428-2
  ]
}
resource "lovi_address" "problem-team428-3" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.${100 + 3}"

  depends_on = [lovi_subnet.team428]
}

resource "lovi_lease" "problem-team428-3" {
  address_id = lovi_address.problem-team428-3.id

  depends_on = [lovi_address.problem-team428-3]
}

resource "lovi_virtual_machine" "problem-team428-3" {
  name = "team428-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0015"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team428.name

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "problem-team428-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team428-3.id
  bridge_id = lovi_bridge.team428.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t428-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team428-3.id

  depends_on = [
    lovi_virtual_machine.problem-team428-3,
    lovi_lease.problem-team428-3
  ]
}

resource "lovi_address" "bench-team428" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.104"
}

resource "lovi_lease" "bench-team428" {
  address_id = lovi_address.bench-team428.id

  depends_on = [lovi_address.bench-team428]
}

resource "lovi_virtual_machine" "bench-team428" {
  name = "team428-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "7b4d093f-7e9a-4488-9d77-93c8e3556a64"
  hypervisor_name = "isucn0015"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team428.name

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "bench-team428" {
  virtual_machine_id = lovi_virtual_machine.bench-team428.id
  bridge_id = lovi_bridge.team428.id
  average = 125000 // NOTE: 1Gbps
  name = "t428-be"
  lease_id = lovi_lease.bench-team428.id

  depends_on = [
    lovi_virtual_machine.bench-team428,
    lovi_lease.bench-team428
  ]
}

resource "lovi_address" "bastion100-team428" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.100"
}

resource "lovi_lease" "bastion100-team428" {
  address_id = lovi_address.bastion100-team428.id

  depends_on = [lovi_address.bastion100-team428]
}

resource "lovi_virtual_machine" "bastion100-team428" {
  name = "team428-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "bastion100-team428" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team428.id
  bridge_id = lovi_bridge.team428.id
  average = 125000 // NOTE: 1Gbps
  name = "t428-ba100"
  lease_id = lovi_lease.bastion100-team428.id

  depends_on = [
    lovi_virtual_machine.bastion100-team428,
    lovi_lease.bastion100-team428
  ]
}
resource "lovi_address" "bastion200-team428" {
  subnet_id = lovi_subnet.team428.id
  fixed_ip = "10.164.28.200"
}

resource "lovi_lease" "bastion200-team428" {
  address_id = lovi_address.bastion200-team428.id

  depends_on = [lovi_address.bastion200-team428]
}

resource "lovi_virtual_machine" "bastion200-team428" {
  name = "team428-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team428
  ]
}

resource "lovi_interface_attachment" "bastion200-team428" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team428.id
  bridge_id = lovi_bridge.team428.id
  average = 125000 // NOTE: 1Gbps
  name = "t428-ba200"
  lease_id = lovi_lease.bastion200-team428.id

  depends_on = [
    lovi_virtual_machine.bastion200-team428,
    lovi_lease.bastion200-team428
  ]
}