package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

const (
	numTeam       = 50
	generatedDir  = "generated"
	tfFilePathTpl = generatedDir + "/team%s/main.tf"
)

var (
	binaryTerraform = "terraform"
	scheduled       = map[int]string{}
)

// templateTeamNetwork is template of resource that one of team
// %s catch teamID (%03d)
const templateTeamNetwork = `resource "lovi_subnet" "team%s" {
  name = "team%s"
  vlan_id = 1000 + %d
  network = "10.160.%d.0/24"
  start = "10.160.%d.100"
  end = "10.160.%d.200"
  gateway = "10.160.%d.254"
  dns_server = "8.8.8.8"
  metadata_server = "10.160.%d.1"
}

resource "lovi_bridge" "team%s" {
  name = "team%s"
  vlan_id = 1000 + %d

  depends_on = [lovi_subnet.team%s]
}

resource "lovi_internal_bridge" "team%s" {
  name = "team%s-in"
}`

// templateProblemNetwork is template of network resource for problem
// %s catch teamID (%03d)
const templateProblemNetwork = `
variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team%s" {
  count = var.node_count

  subnet_id = lovi_subnet.team%s.id
  fixed_ip = "10.160.%d.${101 + count.index}"
}

resource "lovi_lease" "problem-team%s" {
  count = var.node_count

  address_id = lovi_address.problem-team%s[count.index].id

  depends_on = [lovi_address.problem-team%s]
}`

// templateProblemVM is template of virtual machine resource for problem
// %s catch teamID (%03d)
const templateProblemVM = `
resource "lovi_virtual_machine" "problem-team%s" {
  count = var.node_count

  name = "team%s-${format("%%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "30afbf08-a9d2-4245-ab7f-a4c1a83bf062"
  hypervisor_name = "%s"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200
}

resource "lovi_interface_attachment" "problem-team%s" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team%s[count.index].id
  bridge_id = lovi_bridge.team%s.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t%s-${format("%%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team%s[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team%s,
    lovi_lease.problem-team%s
  ]
}`

// templateBench is template of resource for benchmarker
const templateBench = `
resource "lovi_address" "bench-team%s" {
  subnet_id = lovi_subnet.team%s.id
  fixed_ip = "10.160.%d.104"
}

resource "lovi_lease" "bench-team%s" {
  address_id = lovi_address.bench-team%s.id

  depends_on = [lovi_address.bench-team%s]
}

resource "lovi_virtual_machine" "bench-team%s" {
  name = "team%s-bench"
  vcpus = 2
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "2c56bd7b-f594-43f7-baa0-6863d9eb4348"
  hypervisor_name = "%s"

  depends_on = [
    lovi_virtual_machine.problem-team%s,
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200
}

resource "lovi_interface_attachment" "bench-team%s" {
  virtual_machine_id = lovi_virtual_machine.bench-team%s.id
  bridge_id = lovi_bridge.team%s.id
  average = 12500 // NOTE: 100Mbps
  name = "t%s-be"
  lease_id = lovi_lease.bench-team%s.id

  depends_on = [
    lovi_virtual_machine.bench-team%s,
    lovi_lease.bench-team%s
  ]
}`

// templateBastion is template of resource for bastion
const templateBastion = `
resource "lovi_address" "bastion-team%s" {
  subnet_id = lovi_subnet.team%s.id
  fixed_ip = "10.160.%d.100"
}

resource "lovi_lease" "bastion-team%s" {
  address_id = lovi_address.bastion-team%s.id

  depends_on = [lovi_address.bastion-team%s]
}

resource "lovi_virtual_machine" "bastion-team%s" {
  name = "team%s-bastion"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "bab847e2-b14f-4463-80ee-8cfb36392ea9"
  hypervisor_name = "isuadm0002"

  depends_on = [
    lovi_virtual_machine.problem-team%s,
  ]
}

resource "lovi_interface_attachment" "bastion-team%s" {
  virtual_machine_id = lovi_virtual_machine.bastion-team%s.id
  bridge_id = lovi_bridge.team%s.id
  average = 125000 // NOTE: 1Gbps
  name = "t%s-ba"
  lease_id = lovi_lease.bastion-team%s.id

  depends_on = [
    lovi_virtual_machine.bastion-team%s,
    lovi_lease.bastion-team%s
  ]
}`

func main() {
	// truncate
	now := time.Now()
	if err := os.Rename("generated", fmt.Sprintf("generated.%d", now.Unix())); err != nil {
		if !os.IsNotExist(err) {
			log.Fatal(err)
		}
	}

	doSchedule()

	if err := generateTeam(3); err != nil {
		log.Fatal(err)
	}
	//
	//for i := 100; i < 201; i++ {
	//	if err := generateTeam(i); err != nil {
	//		log.Fatal(err)
	//	}
	//}

	log.Println("generated")
}

func generateTeam(teamid int) error {
	teamID := fmt.Sprintf("%03d", teamid)
	if err := writeFile(teamid, teamID); err != nil {
		return fmt.Errorf("failed to write file: %w", err)
	}

	if err := terraformInit(teamID); err != nil {
		return fmt.Errorf("failed to terraform init: %w", err)
	}

	return nil
}

func terraformInit(teamID string) error {
	pwd, err := filepath.Abs(".")
	if err != nil {
		return err
	}
	defer os.Chdir(pwd)

	if err := os.Chdir(generatedDir + "/team" + teamID); err != nil {
		return err
	}

	if err := os.Symlink("../../terraform-provider-lovi", "terraform-provider-lovi"); err != nil {
		return err
	}

	out, err := exec.Command(binaryTerraform, "init").CombinedOutput()
	if err != nil {
		return fmt.Errorf("out: %s, err: %w", string(out), err)
	}

	return nil
}

func writeFile(id int, teamID string) error {
	tfFilePath := fmt.Sprintf(tfFilePathTpl, teamID)

	if err := os.MkdirAll(filepath.Dir(tfFilePath), 0777); err != nil {
		return err
	}

	f, err := os.OpenFile(tfFilePath, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0666)
	if err != nil {
		return err
	}

	content := strings.Join([]string{generateNetwork(id, teamID), generateProblem(id, teamID), generateBench(id, teamID), generateBastion(id, teamID)}, "\n")

	if _, err := f.WriteString(content); err != nil {
		return err
	}
	if err := f.Close(); err != nil {
		return err
	}

	return nil
}

func generateNetwork(id int, teamID string) string {
	return fmt.Sprintf(templateTeamNetwork, teamID, teamID, id, id, id, id, id, id, teamID, teamID, id, teamID, teamID, teamID)
}

func generateProblem(id int, teamID string) string {
	network := fmt.Sprintf(templateProblemNetwork, teamID, teamID, id, teamID, teamID, teamID)
	vm := fmt.Sprintf(templateProblemVM, teamID, teamID, scheduled[id], teamID, teamID, teamID, teamID, teamID, teamID, teamID)

	return strings.Join([]string{network, vm}, "")
}

func generateBench(id int, teamID string) string {
	return fmt.Sprintf(templateBench, teamID, teamID, id, teamID, teamID, teamID, teamID, teamID, scheduled[id], teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID)
}

func generateBastion(id int, teamID string) string {
	return fmt.Sprintf(templateBastion, teamID, teamID, id, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID)
}

const (
	CountHostCore = 94
	TeamCore      = 4
	CountTeam     = 500
)

func doSchedule() {
	NumberCN := 1
	core := CountHostCore // のこり

	for i := 1; i <= CountTeam; i++ {
		if core-TeamCore < 0 {
			// 在庫切れなので新しいCNを出す
			NumberCN++
			core = CountHostCore
		}

		core = core - TeamCore
		scheduled[i] = fmt.Sprintf("isucn%04d", NumberCN)
	}
}
