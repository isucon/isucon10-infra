resource "lovi_subnet" "team530" {
  name = "team530"
  vlan_id = 1000 + 530
  network = "10.165.30.0/24"
  start = "10.165.30.100"
  end = "10.165.30.200"
  gateway = "10.165.30.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.30.1"
}

resource "lovi_bridge" "team530" {
  name = "team530"
  vlan_id = 1000 + 530

  depends_on = [lovi_subnet.team530]
}

resource "lovi_internal_bridge" "team530" {
  name = "team530-in"
}

resource "lovi_cpu_pinning_group" "team530" {
  name = "team530"
  count_of_core = 16
  hypervisor_name = "isuadm0008"
}

resource "lovi_address" "problem-team530-1" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.${100 + 1}"

  depends_on = [lovi_subnet.team530]
}

resource "lovi_lease" "problem-team530-1" {
  address_id = lovi_address.problem-team530-1.id

  depends_on = [lovi_address.problem-team530-1]
}

resource "lovi_virtual_machine" "problem-team530-1" {
  name = "team530-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "b54ed619-b3ec-438a-9fb4-131846c9fc67"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team530.name

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "problem-team530-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team530-1.id
  bridge_id = lovi_bridge.team530.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t530-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team530-1.id

  depends_on = [
    lovi_virtual_machine.problem-team530-1,
    lovi_lease.problem-team530-1
  ]
}
resource "lovi_address" "problem-team530-2" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.${100 + 2}"

  depends_on = [lovi_subnet.team530]
}

resource "lovi_lease" "problem-team530-2" {
  address_id = lovi_address.problem-team530-2.id

  depends_on = [lovi_address.problem-team530-2]
}

resource "lovi_virtual_machine" "problem-team530-2" {
  name = "team530-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "b54ed619-b3ec-438a-9fb4-131846c9fc67"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team530.name

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "problem-team530-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team530-2.id
  bridge_id = lovi_bridge.team530.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t530-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team530-2.id

  depends_on = [
    lovi_virtual_machine.problem-team530-2,
    lovi_lease.problem-team530-2
  ]
}
resource "lovi_address" "problem-team530-3" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.${100 + 3}"

  depends_on = [lovi_subnet.team530]
}

resource "lovi_lease" "problem-team530-3" {
  address_id = lovi_address.problem-team530-3.id

  depends_on = [lovi_address.problem-team530-3]
}

resource "lovi_virtual_machine" "problem-team530-3" {
  name = "team530-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "b54ed619-b3ec-438a-9fb4-131846c9fc67"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team530.name

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "problem-team530-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team530-3.id
  bridge_id = lovi_bridge.team530.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t530-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team530-3.id

  depends_on = [
    lovi_virtual_machine.problem-team530-3,
    lovi_lease.problem-team530-3
  ]
}

resource "lovi_address" "bench-team530" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.104"
}

resource "lovi_lease" "bench-team530" {
  address_id = lovi_address.bench-team530.id

  depends_on = [lovi_address.bench-team530]
}

resource "lovi_virtual_machine" "bench-team530" {
  name = "team530-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "210ab27e-a727-4ccb-aba4-234a7ae0aeb6"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team530.name

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "bench-team530" {
  virtual_machine_id = lovi_virtual_machine.bench-team530.id
  bridge_id = lovi_bridge.team530.id
  average = 12500 // NOTE: 100Mbps
  name = "t530-be"
  lease_id = lovi_lease.bench-team530.id

  depends_on = [
    lovi_virtual_machine.bench-team530,
    lovi_lease.bench-team530
  ]
}

resource "lovi_address" "bastion100-team530" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.100"
}

resource "lovi_lease" "bastion100-team530" {
  address_id = lovi_address.bastion100-team530.id

  depends_on = [lovi_address.bastion100-team530]
}

resource "lovi_virtual_machine" "bastion100-team530" {
  name = "team530-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "bastion100-team530" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team530.id
  bridge_id = lovi_bridge.team530.id
  average = 125000 // NOTE: 1Gbps
  name = "t530-ba100"
  lease_id = lovi_lease.bastion100-team530.id

  depends_on = [
    lovi_virtual_machine.bastion100-team530,
    lovi_lease.bastion100-team530
  ]
}
resource "lovi_address" "bastion200-team530" {
  subnet_id = lovi_subnet.team530.id
  fixed_ip = "10.165.30.200"
}

resource "lovi_lease" "bastion200-team530" {
  address_id = lovi_address.bastion200-team530.id

  depends_on = [lovi_address.bastion200-team530]
}

resource "lovi_virtual_machine" "bastion200-team530" {
  name = "team530-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team530
  ]
}

resource "lovi_interface_attachment" "bastion200-team530" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team530.id
  bridge_id = lovi_bridge.team530.id
  average = 125000 // NOTE: 1Gbps
  name = "t530-ba200"
  lease_id = lovi_lease.bastion200-team530.id

  depends_on = [
    lovi_virtual_machine.bastion200-team530,
    lovi_lease.bastion200-team530
  ]
}