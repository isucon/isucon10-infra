resource "lovi_subnet" "team550" {
  name = "team550"
  vlan_id = 1000 + 550
  network = "10.165.50.0/24"
  start = "10.165.50.100"
  end = "10.165.50.200"
  gateway = "10.165.50.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.165.50.1"
}

resource "lovi_bridge" "team550" {
  name = "team550"
  vlan_id = 1000 + 550

  depends_on = [lovi_subnet.team550]
}

resource "lovi_internal_bridge" "team550" {
  name = "team550-in"
}

variable "node_count" {
  default = 6
}

resource "lovi_address" "problem-team550" {
  count = var.node_count

  subnet_id = lovi_subnet.team550.id
  fixed_ip = "10.165.50.${101 + count.index}"
}

resource "lovi_lease" "problem-team550" {
  count = var.node_count

  address_id = lovi_address.problem-team550[count.index].id

  depends_on = [lovi_address.problem-team550]
}
resource "lovi_cpu_pinning_group" "team550" {
  count = var.node_count

  name = "team550-${format("%03d", count.index + 1)}"
  count_of_core = 8
  hypervisor_name = "isuadm0004"
}

resource "lovi_virtual_machine" "problem-team550" {
  count = var.node_count

  name = "team550-${format("%03d", count.index + 1)}"
  vcpus = 8
  memory_kib = 8 * 1024 * 1024
  root_volume_gb = 30
  source_image_id = "482bc437-71bd-4501-8488-dd93a8b82f54"
  hypervisor_name = "isuadm0004"

//  read_bytes_sec = 100 * 1000 * 1000
//  write_bytes_sec = 100 * 1000 * 1000
//  read_iops_sec = 200
//  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team550[count.index].name
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_cpu_pinning_group.team550
  ]
}

resource "lovi_interface_attachment" "problem-team550" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team550[count.index].id
  bridge_id = lovi_bridge.team550.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000
  // NOTE: 1Gbps
  name = "t550-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team550[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team550,
    lovi_lease.problem-team550
  ]
}

resource "lovi_address" "bastion200-team550" {
  subnet_id = lovi_subnet.team550.id
  fixed_ip = "10.165.50.200"
}

resource "lovi_lease" "bastion200-team550" {
  address_id = lovi_address.bastion200-team550.id

  depends_on = [lovi_address.bastion200-team550]
}

resource "lovi_virtual_machine" "bastion200-team550" {
  name = "team550-bastion200"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "5138fee8-59a1-407a-bb84-2937d9705143"
  hypervisor_name = "isuadm0006"
  europa_backend_name = "dorado001"

  depends_on = [
    lovi_virtual_machine.problem-team550,
  ]
}

resource "lovi_interface_attachment" "bastion200-team550" {
  virtual_machine_id = lovi_virtual_machine.bastion200-team550.id
  bridge_id = lovi_bridge.team550.id
  average = 125000 // NOTE: 1Gbps
  name = "t550-ba200"
  lease_id = lovi_lease.bastion200-team550.id

  depends_on = [
    lovi_virtual_machine.bastion200-team550,
    lovi_lease.bastion200-team550
  ]
}