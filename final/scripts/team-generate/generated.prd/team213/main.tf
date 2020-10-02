resource "lovi_subnet" "team213" {
  name = "team213"
  vlan_id = 1000 + 213
  network = "10.162.13.0/24"
  start = "10.162.13.100"
  end = "10.162.13.200"
  gateway = "10.162.13.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.162.13.1"
}

resource "lovi_bridge" "team213" {
  name = "team213"
  vlan_id = 1000 + 213

  depends_on = [lovi_subnet.team213]
}

resource "lovi_internal_bridge" "team213" {
  name = "team213-in"
}

resource "lovi_cpu_pinning_group" "team213" {
  name = "team213"
  count_of_core = 12
  hypervisor_name = "isucn0007"
}

resource "lovi_address" "problem-team213-1" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.${100 + 1}"

  depends_on = [lovi_subnet.team213]
}

resource "lovi_lease" "problem-team213-1" {
  address_id = lovi_address.problem-team213-1.id

  depends_on = [lovi_address.problem-team213-1]
}

resource "lovi_virtual_machine" "problem-team213-1" {
  name = "team213-${format("%03d", 1)}"
  vcpus = 2
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team213.name

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "problem-team213-1" {
  virtual_machine_id = lovi_virtual_machine.problem-team213-1.id
  bridge_id = lovi_bridge.team213.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t213-${format("%03d", 1)}"
  lease_id = lovi_lease.problem-team213-1.id

  depends_on = [
    lovi_virtual_machine.problem-team213-1,
    lovi_lease.problem-team213-1
  ]
}
resource "lovi_address" "problem-team213-2" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.${100 + 2}"

  depends_on = [lovi_subnet.team213]
}

resource "lovi_lease" "problem-team213-2" {
  address_id = lovi_address.problem-team213-2.id

  depends_on = [lovi_address.problem-team213-2]
}

resource "lovi_virtual_machine" "problem-team213-2" {
  name = "team213-${format("%03d", 2)}"
  vcpus = 2
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team213.name

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "problem-team213-2" {
  virtual_machine_id = lovi_virtual_machine.problem-team213-2.id
  bridge_id = lovi_bridge.team213.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t213-${format("%03d", 2)}"
  lease_id = lovi_lease.problem-team213-2.id

  depends_on = [
    lovi_virtual_machine.problem-team213-2,
    lovi_lease.problem-team213-2
  ]
}
resource "lovi_address" "problem-team213-3" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.${100 + 3}"

  depends_on = [lovi_subnet.team213]
}

resource "lovi_lease" "problem-team213-3" {
  address_id = lovi_address.problem-team213-3.id

  depends_on = [lovi_address.problem-team213-3]
}

resource "lovi_virtual_machine" "problem-team213-3" {
  name = "team213-${format("%03d", 3)}"
  vcpus = 4
  memory_kib = 1 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "18295a50-6ec0-4a6f-8dc7-f19d28d2057e"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team213.name

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "problem-team213-3" {
  virtual_machine_id = lovi_virtual_machine.problem-team213-3.id
  bridge_id = lovi_bridge.team213.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t213-${format("%03d", 3)}"
  lease_id = lovi_lease.problem-team213-3.id

  depends_on = [
    lovi_virtual_machine.problem-team213-3,
    lovi_lease.problem-team213-3
  ]
}

resource "lovi_address" "bench-team213" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.104"
}

resource "lovi_lease" "bench-team213" {
  address_id = lovi_address.bench-team213.id

  depends_on = [lovi_address.bench-team213]
}

resource "lovi_virtual_machine" "bench-team213" {
  name = "team213-bench"
  vcpus = 8
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "7b4d093f-7e9a-4488-9d77-93c8e3556a64"
  hypervisor_name = "isucn0007"
  europa_backend_name = "dorado002"

  read_bytes_sec = 1 * 1000 * 1000 * 1000
  write_bytes_sec = 1 * 1000 * 1000 * 1000
  read_iops_sec = 800
  write_iops_sec = 800

  cpu_pinning_group_name = lovi_cpu_pinning_group.team213.name

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "bench-team213" {
  virtual_machine_id = lovi_virtual_machine.bench-team213.id
  bridge_id = lovi_bridge.team213.id
  average = 125000 // NOTE: 1Gbps
  name = "t213-be"
  lease_id = lovi_lease.bench-team213.id

  depends_on = [
    lovi_virtual_machine.bench-team213,
    lovi_lease.bench-team213
  ]
}

resource "lovi_address" "bastion100-team213" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.100"
}

resource "lovi_lease" "bastion100-team213" {
  address_id = lovi_address.bastion100-team213.id

  depends_on = [lovi_address.bastion100-team213]
}

resource "lovi_virtual_machine" "bastion100-team213" {
  name = "team213-bastion100"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0002"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "bastion100-team213" {
  virtual_machine_id = lovi_virtual_machine.bastion100-team213.id
  bridge_id = lovi_bridge.team213.id
  average = 125000 // NOTE: 1Gbps
  name = "t213-ba100"
  lease_id = lovi_lease.bastion100-team213.id

  depends_on = [
    lovi_virtual_machine.bastion100-team213,
    lovi_lease.bastion100-team213
  ]
}
resource "lovi_address" "bastion200-team213" {
  subnet_id = lovi_subnet.team213.id
  fixed_ip = "10.162.13.200"
}

resource "lovi_lease" "bastion200-team213" {
  address_id = lovi_address.bastion200-team213.id

  depends_on = [lovi_address.bastion200-team213]
}

resource "lovi_virtual_machine" "bastion200-team213" {
  name = "team213-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "c453a2ef-9865-4b14-bff2-0a78416ebea5"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado002"

  depends_on = [
    lovi_cpu_pinning_group.team213
  ]
}

resource "lovi_interface_attachment" "bastion200-team213" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team213.id
  bridge_id = lovi_bridge.team213.id
  average = 125000 // NOTE: 1Gbps
  name = "t213-ba200"
  lease_id = lovi_lease.bastion200-team213.id

  depends_on = [
    lovi_virtual_machine.bastion200-team213,
    lovi_lease.bastion200-team213
  ]
}