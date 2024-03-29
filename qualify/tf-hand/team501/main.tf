resource "lovi_subnet" "team501" {
  name = "team501"
  vlan_id = 1000 + 501
  network = "10.165.1.0/24"
  start = "10.165.1.100"
  end = "10.165.1.200"
  gateway = "10.165.1.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.1.1"
}

resource "lovi_bridge" "team501" {
  name = "team501"
  vlan_id = 1000 + 501

  depends_on = [lovi_subnet.team501]
}

resource "lovi_internal_bridge" "team501" {
  name = "team501-in"
}

variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team501" {
  count = var.node_count

  subnet_id = lovi_subnet.team501.id
  fixed_ip = "10.165.1.${101 + count.index}"
}

resource "lovi_lease" "problem-team501" {
  count = var.node_count

  address_id = lovi_address.problem-team501[count.index].id

  depends_on = [lovi_address.problem-team501]
}
resource "lovi_cpu_pinning_group" "team501" {
  name = "team501"
  count_of_core = 4
  hypervisor_name = "isuadm0008"
}

resource "lovi_virtual_machine" "problem-team501" {
  count = var.node_count

  name = "team501-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0008"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team501.name
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team501
  ]
}

resource "lovi_interface_attachment" "problem-team501" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team501[count.index].id
  bridge_id = lovi_bridge.team501.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t501-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team501[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team501,
    lovi_lease.problem-team501
  ]
}

resource "lovi_address" "bench-team501" {
  subnet_id = lovi_subnet.team501.id
  fixed_ip = "10.165.1.104"
}

resource "lovi_lease" "bench-team501" {
  address_id = lovi_address.bench-team501.id

  depends_on = [lovi_address.bench-team501]
}

resource "lovi_virtual_machine" "bench-team501" {
  name = "team501-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0008"

  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team501,
    lovi_cpu_pinning_group.team501
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team501.name
}

resource "lovi_interface_attachment" "bench-team501" {
  virtual_machine_id = lovi_virtual_machine.bench-team501.id
  bridge_id = lovi_bridge.team501.id
  average = 12500 // NOTE: 100Mbps
  name = "t501-be"
  lease_id = lovi_lease.bench-team501.id

  depends_on = [
    lovi_virtual_machine.bench-team501,
    lovi_lease.bench-team501
  ]
}

resource "lovi_address" "bastion-team501" {
  subnet_id = lovi_subnet.team501.id
  fixed_ip = "10.165.1.100"
}

resource "lovi_lease" "bastion-team501" {
  address_id = lovi_address.bastion-team501.id

  depends_on = [lovi_address.bastion-team501]
}

resource "lovi_virtual_machine" "bastion-team501" {
  name = "team501-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0008"

  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team501,
  ]
}

resource "lovi_interface_attachment" "bastion-team501" {
  virtual_machine_id = lovi_virtual_machine.bastion-team501.id
  bridge_id = lovi_bridge.team501.id
  average = 125000 // NOTE: 1Gbps
  name = "t501-ba"
  lease_id = lovi_lease.bastion-team501.id

  depends_on = [
    lovi_virtual_machine.bastion-team501,
    lovi_lease.bastion-team501
  ]
}