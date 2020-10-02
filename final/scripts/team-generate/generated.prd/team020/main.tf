resource "lovi_subnet" "team020" {
  name = "team020"
  vlan_id = 1000 + 20
  network = "10.160.20.0/24"
  start = "10.160.20.100"
  end = "10.160.20.200"
  gateway = "10.160.20.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.20.1"
}

resource "lovi_bridge" "team020" {
  name = "team020"
  vlan_id = 1000 + 20

  depends_on = [lovi_subnet.team020]
}

resource "lovi_internal_bridge" "team020" {
  name = "team020-in"
}

resource "lovi_cpu_pinning_group" "team020" {
  name = "team020"
  count_of_core = 12
  hypervisor_name = "isucn0002"
}

resource "lovi_address" "problem-team020-1" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.${100 + 1}"

  depends_on = [lovi_subnet.team020]
}

resource "lovi_lease" "problem-team020-1" {
  address_id = lovi_address.problem-team020-1.id

  depends_on = [lovi_address.problem-team020-1]
}

resource "lovi_virtual_machine" "problem-team020-1" {
  name = "team020-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team020.name

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "problem-team020-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team020-1.id
  bridge_id = lovi_bridge.team020.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t020-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team020-1.id

  depends_on = [
    lovi_virtual_machine.problem-team020-1,
    lovi_lease.problem-team020-1
  ]
}
resource "lovi_address" "problem-team020-2" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.${100 + 2}"

  depends_on = [lovi_subnet.team020]
}

resource "lovi_lease" "problem-team020-2" {
  address_id = lovi_address.problem-team020-2.id

  depends_on = [lovi_address.problem-team020-2]
}

resource "lovi_virtual_machine" "problem-team020-2" {
  name = "team020-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team020.name

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "problem-team020-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team020-2.id
  bridge_id = lovi_bridge.team020.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t020-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team020-2.id

  depends_on = [
    lovi_virtual_machine.problem-team020-2,
    lovi_lease.problem-team020-2
  ]
}
resource "lovi_address" "problem-team020-3" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.${100 + 3}"

  depends_on = [lovi_subnet.team020]
}

resource "lovi_lease" "problem-team020-3" {
  address_id = lovi_address.problem-team020-3.id

  depends_on = [lovi_address.problem-team020-3]
}

resource "lovi_virtual_machine" "problem-team020-3" {
  name = "team020-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "ee12d10d-471e-4939-8650-9302c2ea71c0"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team020.name

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "problem-team020-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team020-3.id
  bridge_id = lovi_bridge.team020.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t020-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team020-3.id

  depends_on = [
    lovi_virtual_machine.problem-team020-3,
    lovi_lease.problem-team020-3
  ]
}

resource "lovi_address" "bench-team020" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.104"
}

resource "lovi_lease" "bench-team020" {
  address_id = lovi_address.bench-team020.id

  depends_on = [lovi_address.bench-team020]
}

resource "lovi_virtual_machine" "bench-team020" {
  name = "team020-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "a87104a2-0c24-4058-bc6f-13a9e632b5c1"
  hypervisor_name = "isucn0002"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team020.name

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "bench-team020" {
  virtual_machine_id = lovi_virtual_machine.bench-team020.id
  bridge_id = lovi_bridge.team020.id
  average = 125000 // NOTE: 1Gbps
  name = "t020-be"
  lease_id = lovi_lease.bench-team020.id

  depends_on = [
    lovi_virtual_machine.bench-team020,
    lovi_lease.bench-team020
  ]
}

resource "lovi_address" "bastion100-team020" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.100"
}

resource "lovi_lease" "bastion100-team020" {
  address_id = lovi_address.bastion100-team020.id

  depends_on = [lovi_address.bastion100-team020]
}

resource "lovi_virtual_machine" "bastion100-team020" {
  name = "team020-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "bastion100-team020" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team020.id
  bridge_id = lovi_bridge.team020.id
  average = 125000 // NOTE: 1Gbps
  name = "t020-ba100"
  lease_id = lovi_lease.bastion100-team020.id

  depends_on = [
    lovi_virtual_machine.bastion100-team020,
    lovi_lease.bastion100-team020
  ]
}
resource "lovi_address" "bastion200-team020" {
  subnet_id = lovi_subnet.team020.id
  fixed_ip = "10.160.20.200"
}

resource "lovi_lease" "bastion200-team020" {
  address_id = lovi_address.bastion200-team020.id

  depends_on = [lovi_address.bastion200-team020]
}

resource "lovi_virtual_machine" "bastion200-team020" {
  name = "team020-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team020
  ]
}

resource "lovi_interface_attachment" "bastion200-team020" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team020.id
  bridge_id = lovi_bridge.team020.id
  average = 125000 // NOTE: 1Gbps
  name = "t020-ba200"
  lease_id = lovi_lease.bastion200-team020.id

  depends_on = [
    lovi_virtual_machine.bastion200-team020,
    lovi_lease.bastion200-team020
  ]
}