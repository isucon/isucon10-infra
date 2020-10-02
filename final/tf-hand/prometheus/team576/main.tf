resource "lovi_subnet" "team576" {
  name = "team576"
  vlan_id = 1000 + 576
  network = "10.165.76.0/24"
  start = "10.165.76.100"
  end = "10.165.76.200"
  gateway = "10.165.76.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.76.1"
}

resource "lovi_bridge" "team576" {
  name = "team576"
  vlan_id = 1000 + 576

  depends_on = [lovi_subnet.team576]
}

resource "lovi_internal_bridge" "team576" {
  name = "team576-in"
}

resource "lovi_cpu_pinning_group" "team576" {
  name = "team576"
  count_of_core = 12
  hypervisor_name = "isucn0022"
}

resource "lovi_address" "problem-team576-1" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.${100 + 1}"

  depends_on = [lovi_subnet.team576]
}

resource "lovi_lease" "problem-team576-1" {
  address_id = lovi_address.problem-team576-1.id

  depends_on = [lovi_address.problem-team576-1]
}

resource "lovi_virtual_machine" "problem-team576-1" {
  name = "team576-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18021d55-a78b-490e-b8b3-801fdf753136"
  hypervisor_name = "isucn0022"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team576.name

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "problem-team576-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team576-1.id
  bridge_id = lovi_bridge.team576.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t576-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team576-1.id

  depends_on = [
    lovi_virtual_machine.problem-team576-1,
    lovi_lease.problem-team576-1
  ]
}
resource "lovi_address" "problem-team576-2" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.${100 + 2}"

  depends_on = [lovi_subnet.team576]
}

resource "lovi_lease" "problem-team576-2" {
  address_id = lovi_address.problem-team576-2.id

  depends_on = [lovi_address.problem-team576-2]
}

resource "lovi_virtual_machine" "problem-team576-2" {
  name = "team576-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18021d55-a78b-490e-b8b3-801fdf753136"
  hypervisor_name = "isucn0022"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team576.name

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "problem-team576-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team576-2.id
  bridge_id = lovi_bridge.team576.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t576-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team576-2.id

  depends_on = [
    lovi_virtual_machine.problem-team576-2,
    lovi_lease.problem-team576-2
  ]
}
resource "lovi_address" "problem-team576-3" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.${100 + 3}"

  depends_on = [lovi_subnet.team576]
}

resource "lovi_lease" "problem-team576-3" {
  address_id = lovi_address.problem-team576-3.id

  depends_on = [lovi_address.problem-team576-3]
}

resource "lovi_virtual_machine" "problem-team576-3" {
  name = "team576-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18021d55-a78b-490e-b8b3-801fdf753136"
  hypervisor_name = "isucn0022"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team576.name

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "problem-team576-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team576-3.id
  bridge_id = lovi_bridge.team576.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t576-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team576-3.id

  depends_on = [
    lovi_virtual_machine.problem-team576-3,
    lovi_lease.problem-team576-3
  ]
}

resource "lovi_address" "bench-team576" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.104"
}

resource "lovi_lease" "bench-team576" {
  address_id = lovi_address.bench-team576.id

  depends_on = [lovi_address.bench-team576]
}

resource "lovi_virtual_machine" "bench-team576" {
  name = "team576-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "783ab7dd-7cae-46c7-9121-53440466fc36"
  hypervisor_name = "isucn0022"
  europa_backend_name = "dorado001"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team576.name

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "bench-team576" {
  virtual_machine_id = lovi_virtual_machine.bench-team576.id
  bridge_id = lovi_bridge.team576.id
  average = 125000 // NOTE: 1Gbps
  name = "t576-be"
  lease_id = lovi_lease.bench-team576.id

  depends_on = [
    lovi_virtual_machine.bench-team576,
    lovi_lease.bench-team576
  ]
}

resource "lovi_address" "bastion100-team576" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.100"
}

resource "lovi_lease" "bastion100-team576" {
  address_id = lovi_address.bastion100-team576.id

  depends_on = [lovi_address.bastion100-team576]
}

resource "lovi_virtual_machine" "bastion100-team576" {
  name = "team576-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "bastion100-team576" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team576.id
  bridge_id = lovi_bridge.team576.id
  average = 125000 // NOTE: 1Gbps
  name = "t576-ba100"
  lease_id = lovi_lease.bastion100-team576.id

  depends_on = [
    lovi_virtual_machine.bastion100-team576,
    lovi_lease.bastion100-team576
  ]
}
resource "lovi_address" "bastion200-team576" {
  subnet_id = lovi_subnet.team576.id
  fixed_ip = "10.165.76.200"
}

resource "lovi_lease" "bastion200-team576" {
  address_id = lovi_address.bastion200-team576.id

  depends_on = [lovi_address.bastion200-team576]
}

resource "lovi_virtual_machine" "bastion200-team576" {
  name = "team576-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team576
  ]
}

resource "lovi_interface_attachment" "bastion200-team576" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team576.id
  bridge_id = lovi_bridge.team576.id
  average = 125000 // NOTE: 1Gbps
  name = "t576-ba200"
  lease_id = lovi_lease.bastion200-team576.id

  depends_on = [
    lovi_virtual_machine.bastion200-team576,
    lovi_lease.bastion200-team576
  ]
}