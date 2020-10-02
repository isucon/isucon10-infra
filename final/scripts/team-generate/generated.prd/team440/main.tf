resource "lovi_subnet" "team440" {
  name = "team440"
  vlan_id = 1000 + 440
  network = "10.164.40.0/24"
  start = "10.164.40.100"
  end = "10.164.40.200"
  gateway = "10.164.40.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.164.40.1"
}

resource "lovi_bridge" "team440" {
  name = "team440"
  vlan_id = 1000 + 440

  depends_on = [lovi_subnet.team440]
}

resource "lovi_internal_bridge" "team440" {
  name = "team440-in"
}

resource "lovi_cpu_pinning_group" "team440" {
  name = "team440"
  count_of_core = 12
  hypervisor_name = "isucn0016"
}

resource "lovi_address" "problem-team440-1" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.${100 + 1}"

  depends_on = [lovi_subnet.team440]
}

resource "lovi_lease" "problem-team440-1" {
  address_id = lovi_address.problem-team440-1.id

  depends_on = [lovi_address.problem-team440-1]
}

resource "lovi_virtual_machine" "problem-team440-1" {
  name = "team440-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0016"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team440.name

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "problem-team440-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team440-1.id
  bridge_id = lovi_bridge.team440.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t440-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team440-1.id

  depends_on = [
    lovi_virtual_machine.problem-team440-1,
    lovi_lease.problem-team440-1
  ]
}
resource "lovi_address" "problem-team440-2" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.${100 + 2}"

  depends_on = [lovi_subnet.team440]
}

resource "lovi_lease" "problem-team440-2" {
  address_id = lovi_address.problem-team440-2.id

  depends_on = [lovi_address.problem-team440-2]
}

resource "lovi_virtual_machine" "problem-team440-2" {
  name = "team440-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0016"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team440.name

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "problem-team440-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team440-2.id
  bridge_id = lovi_bridge.team440.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t440-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team440-2.id

  depends_on = [
    lovi_virtual_machine.problem-team440-2,
    lovi_lease.problem-team440-2
  ]
}
resource "lovi_address" "problem-team440-3" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.${100 + 3}"

  depends_on = [lovi_subnet.team440]
}

resource "lovi_lease" "problem-team440-3" {
  address_id = lovi_address.problem-team440-3.id

  depends_on = [lovi_address.problem-team440-3]
}

resource "lovi_virtual_machine" "problem-team440-3" {
  name = "team440-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0016"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team440.name

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "problem-team440-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team440-3.id
  bridge_id = lovi_bridge.team440.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t440-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team440-3.id

  depends_on = [
    lovi_virtual_machine.problem-team440-3,
    lovi_lease.problem-team440-3
  ]
}

resource "lovi_address" "bench-team440" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.104"
}

resource "lovi_lease" "bench-team440" {
  address_id = lovi_address.bench-team440.id

  depends_on = [lovi_address.bench-team440]
}

resource "lovi_virtual_machine" "bench-team440" {
  name = "team440-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "a87104a2-0c24-4058-bc6f-13a9e632b5c1"
  hypervisor_name = "isucn0016"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team440.name

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "bench-team440" {
  virtual_machine_id = lovi_virtual_machine.bench-team440.id
  bridge_id = lovi_bridge.team440.id
  average = 125000 // NOTE: 1Gbps
  name = "t440-be"
  lease_id = lovi_lease.bench-team440.id

  depends_on = [
    lovi_virtual_machine.bench-team440,
    lovi_lease.bench-team440
  ]
}

resource "lovi_address" "bastion100-team440" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.100"
}

resource "lovi_lease" "bastion100-team440" {
  address_id = lovi_address.bastion100-team440.id

  depends_on = [lovi_address.bastion100-team440]
}

resource "lovi_virtual_machine" "bastion100-team440" {
  name = "team440-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "bastion100-team440" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team440.id
  bridge_id = lovi_bridge.team440.id
  average = 125000 // NOTE: 1Gbps
  name = "t440-ba100"
  lease_id = lovi_lease.bastion100-team440.id

  depends_on = [
    lovi_virtual_machine.bastion100-team440,
    lovi_lease.bastion100-team440
  ]
}
resource "lovi_address" "bastion200-team440" {
  subnet_id = lovi_subnet.team440.id
  fixed_ip = "10.164.40.200"
}

resource "lovi_lease" "bastion200-team440" {
  address_id = lovi_address.bastion200-team440.id

  depends_on = [lovi_address.bastion200-team440]
}

resource "lovi_virtual_machine" "bastion200-team440" {
  name = "team440-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team440
  ]
}

resource "lovi_interface_attachment" "bastion200-team440" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team440.id
  bridge_id = lovi_bridge.team440.id
  average = 125000 // NOTE: 1Gbps
  name = "t440-ba200"
  lease_id = lovi_lease.bastion200-team440.id

  depends_on = [
    lovi_virtual_machine.bastion200-team440,
    lovi_lease.bastion200-team440
  ]
}