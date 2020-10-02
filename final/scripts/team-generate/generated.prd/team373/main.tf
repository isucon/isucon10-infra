resource "lovi_subnet" "team373" {
  name = "team373"
  vlan_id = 1000 + 373
  network = "10.163.73.0/24"
  start = "10.163.73.100"
  end = "10.163.73.200"
  gateway = "10.163.73.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.163.73.1"
}

resource "lovi_bridge" "team373" {
  name = "team373"
  vlan_id = 1000 + 373

  depends_on = [lovi_subnet.team373]
}

resource "lovi_internal_bridge" "team373" {
  name = "team373-in"
}

resource "lovi_cpu_pinning_group" "team373" {
  name = "team373"
  count_of_core = 12
  hypervisor_name = "isucn0012"
}

resource "lovi_address" "problem-team373-1" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.${100 + 1}"

  depends_on = [lovi_subnet.team373]
}

resource "lovi_lease" "problem-team373-1" {
  address_id = lovi_address.problem-team373-1.id

  depends_on = [lovi_address.problem-team373-1]
}

resource "lovi_virtual_machine" "problem-team373-1" {
  name = "team373-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team373.name

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "problem-team373-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team373-1.id
  bridge_id = lovi_bridge.team373.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t373-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team373-1.id

  depends_on = [
    lovi_virtual_machine.problem-team373-1,
    lovi_lease.problem-team373-1
  ]
}
resource "lovi_address" "problem-team373-2" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.${100 + 2}"

  depends_on = [lovi_subnet.team373]
}

resource "lovi_lease" "problem-team373-2" {
  address_id = lovi_address.problem-team373-2.id

  depends_on = [lovi_address.problem-team373-2]
}

resource "lovi_virtual_machine" "problem-team373-2" {
  name = "team373-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team373.name

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "problem-team373-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team373-2.id
  bridge_id = lovi_bridge.team373.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t373-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team373-2.id

  depends_on = [
    lovi_virtual_machine.problem-team373-2,
    lovi_lease.problem-team373-2
  ]
}
resource "lovi_address" "problem-team373-3" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.${100 + 3}"

  depends_on = [lovi_subnet.team373]
}

resource "lovi_lease" "problem-team373-3" {
  address_id = lovi_address.problem-team373-3.id

  depends_on = [lovi_address.problem-team373-3]
}

resource "lovi_virtual_machine" "problem-team373-3" {
  name = "team373-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team373.name

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "problem-team373-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team373-3.id
  bridge_id = lovi_bridge.team373.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t373-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team373-3.id

  depends_on = [
    lovi_virtual_machine.problem-team373-3,
    lovi_lease.problem-team373-3
  ]
}

resource "lovi_address" "bench-team373" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.104"
}

resource "lovi_lease" "bench-team373" {
  address_id = lovi_address.bench-team373.id

  depends_on = [lovi_address.bench-team373]
}

resource "lovi_virtual_machine" "bench-team373" {
  name = "team373-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "a87104a2-0c24-4058-bc6f-13a9e632b5c1"
  hypervisor_name = "isucn0012"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team373.name

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "bench-team373" {
  virtual_machine_id = lovi_virtual_machine.bench-team373.id
  bridge_id = lovi_bridge.team373.id
  average = 125000 // NOTE: 1Gbps
  name = "t373-be"
  lease_id = lovi_lease.bench-team373.id

  depends_on = [
    lovi_virtual_machine.bench-team373,
    lovi_lease.bench-team373
  ]
}

resource "lovi_address" "bastion100-team373" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.100"
}

resource "lovi_lease" "bastion100-team373" {
  address_id = lovi_address.bastion100-team373.id

  depends_on = [lovi_address.bastion100-team373]
}

resource "lovi_virtual_machine" "bastion100-team373" {
  name = "team373-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "bastion100-team373" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team373.id
  bridge_id = lovi_bridge.team373.id
  average = 125000 // NOTE: 1Gbps
  name = "t373-ba100"
  lease_id = lovi_lease.bastion100-team373.id

  depends_on = [
    lovi_virtual_machine.bastion100-team373,
    lovi_lease.bastion100-team373
  ]
}
resource "lovi_address" "bastion200-team373" {
  subnet_id = lovi_subnet.team373.id
  fixed_ip = "10.163.73.200"
}

resource "lovi_lease" "bastion200-team373" {
  address_id = lovi_address.bastion200-team373.id

  depends_on = [lovi_address.bastion200-team373]
}

resource "lovi_virtual_machine" "bastion200-team373" {
  name = "team373-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team373
  ]
}

resource "lovi_interface_attachment" "bastion200-team373" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team373.id
  bridge_id = lovi_bridge.team373.id
  average = 125000 // NOTE: 1Gbps
  name = "t373-ba200"
  lease_id = lovi_lease.bastion200-team373.id

  depends_on = [
    lovi_virtual_machine.bastion200-team373,
    lovi_lease.bastion200-team373
  ]
}