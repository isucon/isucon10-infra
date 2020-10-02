resource "lovi_subnet" "team533" {
  name = "team533"
  vlan_id = 1000 + 533
  network = "10.165.33.0/24"
  start = "10.165.33.100"
  end = "10.165.33.200"
  gateway = "10.165.33.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.33.1"
}

resource "lovi_bridge" "team533" {
  name = "team533"
  vlan_id = 1000 + 533

  depends_on = [lovi_subnet.team533]
}

resource "lovi_internal_bridge" "team533" {
  name = "team533-in"
}

resource "lovi_cpu_pinning_group" "team533" {
  name = "team533"
  count_of_core = 12
  hypervisor_name = "isuadm0008"
}

resource "lovi_address" "problem-team533-1" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.${100 + 1}"

  depends_on = [lovi_subnet.team533]
}

resource "lovi_lease" "problem-team533-1" {
  address_id = lovi_address.problem-team533-1.id

  depends_on = [lovi_address.problem-team533-1]
}

resource "lovi_virtual_machine" "problem-team533-1" {
  name = "team533-${format("%03d", 1)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team533.name

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "problem-team533-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team533-1.id
  bridge_id = lovi_bridge.team533.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t533-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team533-1.id

  depends_on = [
    lovi_virtual_machine.problem-team533-1,
    lovi_lease.problem-team533-1
  ]
}
resource "lovi_address" "problem-team533-2" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.${100 + 2}"

  depends_on = [lovi_subnet.team533]
}

resource "lovi_lease" "problem-team533-2" {
  address_id = lovi_address.problem-team533-2.id

  depends_on = [lovi_address.problem-team533-2]
}

resource "lovi_virtual_machine" "problem-team533-2" {
  name = "team533-${format("%03d", 2)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team533.name

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "problem-team533-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team533-2.id
  bridge_id = lovi_bridge.team533.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t533-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team533-2.id

  depends_on = [
    lovi_virtual_machine.problem-team533-2,
    lovi_lease.problem-team533-2
  ]
}
resource "lovi_address" "problem-team533-3" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.${100 + 3}"

  depends_on = [lovi_subnet.team533]
}

resource "lovi_lease" "problem-team533-3" {
  address_id = lovi_address.problem-team533-3.id

  depends_on = [lovi_address.problem-team533-3]
}

resource "lovi_virtual_machine" "problem-team533-3" {
  name = "team533-${format("%03d", 3)}"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team533.name

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "problem-team533-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team533-3.id
  bridge_id = lovi_bridge.team533.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t533-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team533-3.id

  depends_on = [
    lovi_virtual_machine.problem-team533-3,
    lovi_lease.problem-team533-3
  ]
}

resource "lovi_address" "bench-team533" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.104"
}

resource "lovi_lease" "bench-team533" {
  address_id = lovi_address.bench-team533.id

  depends_on = [lovi_address.bench-team533]
}

resource "lovi_virtual_machine" "bench-team533" {
  name = "team533-bench"
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

  cpu_pinning_group_name = lovi_cpu_pinning_group.team533.name

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "bench-team533" {
  virtual_machine_id = lovi_virtual_machine.bench-team533.id
  bridge_id = lovi_bridge.team533.id
  average = 12500 // NOTE: 100Mbps
  name = "t533-be"
  lease_id = lovi_lease.bench-team533.id

  depends_on = [
    lovi_virtual_machine.bench-team533,
    lovi_lease.bench-team533
  ]
}

resource "lovi_address" "bastion100-team533" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.100"
}

resource "lovi_lease" "bastion100-team533" {
  address_id = lovi_address.bastion100-team533.id

  depends_on = [lovi_address.bastion100-team533]
}

resource "lovi_virtual_machine" "bastion100-team533" {
  name = "team533-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "bastion100-team533" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team533.id
  bridge_id = lovi_bridge.team533.id
  average = 125000 // NOTE: 1Gbps
  name = "t533-ba100"
  lease_id = lovi_lease.bastion100-team533.id

  depends_on = [
    lovi_virtual_machine.bastion100-team533,
    lovi_lease.bastion100-team533
  ]
}
resource "lovi_address" "bastion200-team533" {
  subnet_id = lovi_subnet.team533.id
  fixed_ip = "10.165.33.200"
}

resource "lovi_lease" "bastion200-team533" {
  address_id = lovi_address.bastion200-team533.id

  depends_on = [lovi_address.bastion200-team533]
}

resource "lovi_virtual_machine" "bastion200-team533" {
  name = "team533-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team533
  ]
}

resource "lovi_interface_attachment" "bastion200-team533" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team533.id
  bridge_id = lovi_bridge.team533.id
  average = 125000 // NOTE: 1Gbps
  name = "t533-ba200"
  lease_id = lovi_lease.bastion200-team533.id

  depends_on = [
    lovi_virtual_machine.bastion200-team533,
    lovi_lease.bastion200-team533
  ]
}