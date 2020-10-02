resource "lovi_subnet" "team532" {
  name = "team532"
  vlan_id = 1000 + 532
  network = "10.165.32.0/24"
  start = "10.165.32.100"
  end = "10.165.32.200"
  gateway = "10.165.32.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.32.1"
}

resource "lovi_bridge" "team532" {
  name = "team532"
  vlan_id = 1000 + 532

  depends_on = [lovi_subnet.team532]
}

resource "lovi_internal_bridge" "team532" {
  name = "team532-in"
}

resource "lovi_cpu_pinning_group" "team532" {
  name = "team532"
  count_of_core = 12
  hypervisor_name = "isuadm0008"
}

resource "lovi_address" "problem-team532-1" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.${100 + 1}"

  depends_on = [lovi_subnet.team532]
}

resource "lovi_lease" "problem-team532-1" {
  address_id = lovi_address.problem-team532-1.id

  depends_on = [lovi_address.problem-team532-1]
}

resource "lovi_virtual_machine" "problem-team532-1" {
  name = "team532-${format("%03d", 1)}"
  vcpus = 1
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "f0b9cadb-8282-45b0-9742-29413125cc28"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team532.name

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "problem-team532-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team532-1.id
  bridge_id = lovi_bridge.team532.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t532-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team532-1.id

  depends_on = [
    lovi_virtual_machine.problem-team532-1,
    lovi_lease.problem-team532-1
  ]
}
resource "lovi_address" "problem-team532-2" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.${100 + 2}"

  depends_on = [lovi_subnet.team532]
}

resource "lovi_lease" "problem-team532-2" {
  address_id = lovi_address.problem-team532-2.id

  depends_on = [lovi_address.problem-team532-2]
}

resource "lovi_virtual_machine" "problem-team532-2" {
  name = "team532-${format("%03d", 2)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "f0b9cadb-8282-45b0-9742-29413125cc28"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team532.name

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "problem-team532-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team532-2.id
  bridge_id = lovi_bridge.team532.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t532-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team532-2.id

  depends_on = [
    lovi_virtual_machine.problem-team532-2,
    lovi_lease.problem-team532-2
  ]
}
resource "lovi_address" "problem-team532-3" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.${100 + 3}"

  depends_on = [lovi_subnet.team532]
}

resource "lovi_lease" "problem-team532-3" {
  address_id = lovi_address.problem-team532-3.id

  depends_on = [lovi_address.problem-team532-3]
}

resource "lovi_virtual_machine" "problem-team532-3" {
  name = "team532-${format("%03d", 3)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "f0b9cadb-8282-45b0-9742-29413125cc28"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team532.name

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "problem-team532-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team532-3.id
  bridge_id = lovi_bridge.team532.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t532-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team532-3.id

  depends_on = [
    lovi_virtual_machine.problem-team532-3,
    lovi_lease.problem-team532-3
  ]
}

resource "lovi_address" "bench-team532" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.104"
}

resource "lovi_lease" "bench-team532" {
  address_id = lovi_address.bench-team532.id

  depends_on = [lovi_address.bench-team532]
}

resource "lovi_virtual_machine" "bench-team532" {
  name = "team532-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "9a7c9182-badc-4fcb-8746-c0e6416d1d2f"
  hypervisor_name = "isuadm0008"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team532.name

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "bench-team532" {
  virtual_machine_id = lovi_virtual_machine.bench-team532.id
  bridge_id = lovi_bridge.team532.id
  average = 125000 // NOTE: 1Gbps
  name = "t532-be"
  lease_id = lovi_lease.bench-team532.id

  depends_on = [
    lovi_virtual_machine.bench-team532,
    lovi_lease.bench-team532
  ]
}

resource "lovi_address" "bastion100-team532" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.100"
}

resource "lovi_lease" "bastion100-team532" {
  address_id = lovi_address.bastion100-team532.id

  depends_on = [lovi_address.bastion100-team532]
}

resource "lovi_virtual_machine" "bastion100-team532" {
  name = "team532-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "bastion100-team532" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team532.id
  bridge_id = lovi_bridge.team532.id
  average = 125000 // NOTE: 1Gbps
  name = "t532-ba100"
  lease_id = lovi_lease.bastion100-team532.id

  depends_on = [
    lovi_virtual_machine.bastion100-team532,
    lovi_lease.bastion100-team532
  ]
}
resource "lovi_address" "bastion200-team532" {
  subnet_id = lovi_subnet.team532.id
  fixed_ip = "10.165.32.200"
}

resource "lovi_lease" "bastion200-team532" {
  address_id = lovi_address.bastion200-team532.id

  depends_on = [lovi_address.bastion200-team532]
}

resource "lovi_virtual_machine" "bastion200-team532" {
  name = "team532-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team532
  ]
}

resource "lovi_interface_attachment" "bastion200-team532" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team532.id
  bridge_id = lovi_bridge.team532.id
  average = 125000 // NOTE: 1Gbps
  name = "t532-ba200"
  lease_id = lovi_lease.bastion200-team532.id

  depends_on = [
    lovi_virtual_machine.bastion200-team532,
    lovi_lease.bastion200-team532
  ]
}