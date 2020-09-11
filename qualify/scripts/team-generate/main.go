package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/isucon/isucon10-infra/qualify/scripts/team-generate/team"
)

const (
	maxTeamID     = 576
	generatedDir  = "generated"
	tfFilePathTpl = generatedDir + "/team%s/main.tf"
)

var (
	binaryTerraform = "terraform"
	scheduled       = map[int]string{}
)

func main() {
	// truncate
	now := time.Now()
	if err := os.Rename("generated", fmt.Sprintf("generated.%d", now.Unix())); err != nil {
		if !os.IsNotExist(err) {
			log.Fatal(err)
		}
	}

	doSchedule()

	for i := 1; i < 501; i++ {
		if scheduled[i] == "isucn0004" {
			if err := generateTeam(i); err != nil {
				log.Fatal(err)
			}
		}
	}

	//
	//for i := 100; i < 201; i++ {
	//	if err := generateTeam(i); err != nil {
	//		log.Fatal(err)
	//	}
	//}

	for teamID := 1; teamID <= maxTeamID; teamID++ {
		if !isAvailableTeamID(teamID) {
			continue
		}
		if err := generateTeam(teamID); err != nil {
			log.Fatal(err)
		}
	}

	log.Println("generated")
}

func generateTeam(teamID int) error {
	ipNet, err := team.GetTeamSubnet(teamID)
	if err != nil {
		return err
	}
	words := strings.Split(ipNet.String(), ".")

	teamSubnet := strings.Join(words[:3], ".")

	teamIDStr := fmt.Sprintf("%03d", teamID)
	if err := writeFile(teamID, teamIDStr, teamSubnet); err != nil {
		return fmt.Errorf("failed to write file: %w", err)
	}

	if err := terraformInit(teamIDStr); err != nil {
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

func writeFile(id int, teamID, teamSubnet string) error {
	tfFilePath := fmt.Sprintf(tfFilePathTpl, teamID)

	if err := os.MkdirAll(filepath.Dir(tfFilePath), 0777); err != nil {
		return err
	}

	f, err := os.OpenFile(tfFilePath, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0666)
	if err != nil {
		return err
	}

	content := strings.Join([]string{generateNetwork(id, teamID, teamSubnet), generateProblem(id, teamID, teamSubnet), generateBench(id, teamID, teamSubnet), generateBastion(id, teamID, teamSubnet)}, "\n")

	if _, err := f.WriteString(content); err != nil {
		return err
	}
	if err := f.Close(); err != nil {
		return err
	}

	return nil
}

func generateNetwork(id int, teamID, teamSubnet string) string {
	return fmt.Sprintf(templateTeamNetwork, teamID, teamID, id, teamSubnet, teamSubnet, teamSubnet, teamSubnet, teamSubnet, teamID, teamID, id, teamID, teamID, teamID)
}

func generateProblem(id int, teamID, teamSubnet string) string {
	network := fmt.Sprintf(templateProblemNetwork, teamID, teamID, teamSubnet, teamID, teamID, teamID)
	vm := fmt.Sprintf(templateProblemVM, teamID, teamID, scheduled[id], teamID, teamID, scheduled[id], teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID)

	return strings.Join([]string{network, vm}, "")
}

func generateBench(id int, teamID, teamSubnet string) string {
	return fmt.Sprintf(templateBench, teamID, teamID, teamSubnet, teamID, teamID, teamID, teamID, teamID, scheduled[id], teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID)
}

func generateBastion(id int, teamID, teamSubnet string) string {
	return fmt.Sprintf(templateBastion, teamID, teamID, teamSubnet, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID, teamID)
}

const (
	// CountHostCore is number of cores per host
	CountHostCore = 84
	// TeamCore is number of cores per team
	TeamCore = 4
	// CountTeam is number of teams
	CountTeam = maxTeamID
)

// 24 Node x 21 Team = 504 Teamなので、
// 21 Team / Node
// 21 Team * 4 Core / Team = 84Core がVM割当分

func doSchedule() {
	NumberCN := 1
	core := CountHostCore // のこり

	for teamID := 1; teamID <= CountTeam; teamID++ {
		if !isAvailableTeamID(teamID) {
			continue
		}

		if core-TeamCore < 0 {
			// 在庫切れなので新しいCNを出す
			NumberCN++
			core = CountHostCore
		}

		core = core - TeamCore
		scheduled[teamID] = fmt.Sprintf("isucn%04d", NumberCN)
	}
}

// templateTeamNetwork is template of resource that one of team
// %s catch teamID (%03d)
const templateTeamNetwork = `resource "lovi_subnet" "team%s" {
  name = "team%s"
  vlan_id = 1000 + %d
  network = "%s.0/24"
  start = "%s.100"
  end = "%s.200"
  gateway = "%s.254"
  dns_server = "8.8.8.8"
  metadata_server = "%s.1"
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
  fixed_ip = "%s.${101 + count.index}"
}

resource "lovi_lease" "problem-team%s" {
  count = var.node_count

  address_id = lovi_address.problem-team%s[count.index].id

  depends_on = [lovi_address.problem-team%s]
}`

// templateProblemVM is template of virtual machine resource for problem
// %s catch teamID (%03d)
const templateProblemVM = `
resource "lovi_cpu_pinning_group" "team%s" {
  name = "team%s"
  count_of_core = 4
  hypervisor_name = "%s"
}

resource "lovi_virtual_machine" "problem-team%s" {
  count = var.node_count

  name = "team%s-${format("%%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "be1069ee-b147-49fd-b7dd-65639f79012d"
  hypervisor_name = "%s"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team%s.name

  depends_on = [
    lovi_cpu_pinning_group.team%s
  ]
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
  fixed_ip = "%s.104"
}

resource "lovi_lease" "bench-team%s" {
  address_id = lovi_address.bench-team%s.id

  depends_on = [lovi_address.bench-team%s]
}

resource "lovi_virtual_machine" "bench-team%s" {
  name = "team%s-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "be1069ee-b147-49fd-b7dd-65639f79012d"
  hypervisor_name = "%s"

  depends_on = [
    lovi_virtual_machine.problem-team%s,
    lovi_cpu_pinning_group.team%s
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team%s.name
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
  fixed_ip = "%s.100"
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
