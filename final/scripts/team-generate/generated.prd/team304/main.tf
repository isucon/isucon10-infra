resource "lovi_subnet" "team304" {
  name = "team304"
  vlan_id = 1000 + 304
  network = "10.163.4.0/24"
  start = "10.163.4.100"
  end = "10.163.4.200"
  gateway = "10.163.4.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.163.4.1"
}

resource "lovi_bridge" "team304" {
  name = "team304"
  vlan_id = 1000 + 304

  depends_on = [lovi_subnet.team304]
}

resource "lovi_internal_bridge" "team304" {
  name = "team304-in"
}

resource "lovi_cpu_pinning_group" "team304" {
  name = "team304"
  count_of_core = 12
  hypervisor_name = "isucn0010"
}

resource "lovi_address" "problem-team304-1" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.${100 + 1}"

  depends_on = [lovi_subnet.team304]
}

resource "lovi_lease" "problem-team304-1" {
  address_id = lovi_address.problem-team304-1.id

  depends_on = [lovi_address.problem-team304-1]
}

resource "lovi_virtual_machine" "problem-team304-1" {
  name = "team304-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0010"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team304.name

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "problem-team304-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team304-1.id
  bridge_id = lovi_bridge.team304.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t304-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team304-1.id

  depends_on = [
    lovi_virtual_machine.problem-team304-1,
    lovi_lease.problem-team304-1
  ]
}
resource "lovi_address" "problem-team304-2" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.${100 + 2}"

  depends_on = [lovi_subnet.team304]
}

resource "lovi_lease" "problem-team304-2" {
  address_id = lovi_address.problem-team304-2.id

  depends_on = [lovi_address.problem-team304-2]
}

resource "lovi_virtual_machine" "problem-team304-2" {
  name = "team304-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0010"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team304.name

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "problem-team304-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team304-2.id
  bridge_id = lovi_bridge.team304.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t304-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team304-2.id

  depends_on = [
    lovi_virtual_machine.problem-team304-2,
    lovi_lease.problem-team304-2
  ]
}
resource "lovi_address" "problem-team304-3" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.${100 + 3}"

  depends_on = [lovi_subnet.team304]
}

resource "lovi_lease" "problem-team304-3" {
  address_id = lovi_address.problem-team304-3.id

  depends_on = [lovi_address.problem-team304-3]
}

resource "lovi_virtual_machine" "problem-team304-3" {
  name = "team304-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0010"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team304.name

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "problem-team304-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team304-3.id
  bridge_id = lovi_bridge.team304.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t304-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team304-3.id

  depends_on = [
    lovi_virtual_machine.problem-team304-3,
    lovi_lease.problem-team304-3
  ]
}

resource "lovi_address" "bench-team304" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.104"
}

resource "lovi_lease" "bench-team304" {
  address_id = lovi_address.bench-team304.id

  depends_on = [lovi_address.bench-team304]
}

resource "lovi_virtual_machine" "bench-team304" {
  name = "team304-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "a87104a2-0c24-4058-bc6f-13a9e632b5c1"
  hypervisor_name = "isucn0010"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team304.name

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "bench-team304" {
  virtual_machine_id = lovi_virtual_machine.bench-team304.id
  bridge_id = lovi_bridge.team304.id
  average = 125000 // NOTE: 1Gbps
  name = "t304-be"
  lease_id = lovi_lease.bench-team304.id

  depends_on = [
    lovi_virtual_machine.bench-team304,
    lovi_lease.bench-team304
  ]
}

resource "lovi_address" "bastion100-team304" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.100"
}

resource "lovi_lease" "bastion100-team304" {
  address_id = lovi_address.bastion100-team304.id

  depends_on = [lovi_address.bastion100-team304]
}

resource "lovi_virtual_machine" "bastion100-team304" {
  name = "team304-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "bastion100-team304" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team304.id
  bridge_id = lovi_bridge.team304.id
  average = 125000 // NOTE: 1Gbps
  name = "t304-ba100"
  lease_id = lovi_lease.bastion100-team304.id

  depends_on = [
    lovi_virtual_machine.bastion100-team304,
    lovi_lease.bastion100-team304
  ]
}
resource "lovi_address" "bastion200-team304" {
  subnet_id = lovi_subnet.team304.id
  fixed_ip = "10.163.4.200"
}

resource "lovi_lease" "bastion200-team304" {
  address_id = lovi_address.bastion200-team304.id

  depends_on = [lovi_address.bastion200-team304]
}

resource "lovi_virtual_machine" "bastion200-team304" {
  name = "team304-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team304
  ]
}

resource "lovi_interface_attachment" "bastion200-team304" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team304.id
  bridge_id = lovi_bridge.team304.id
  average = 125000 // NOTE: 1Gbps
  name = "t304-ba200"
  lease_id = lovi_lease.bastion200-team304.id

  depends_on = [
    lovi_virtual_machine.bastion200-team304,
    lovi_lease.bastion200-team304
  ]
}