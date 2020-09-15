package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"

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
	//now := time.Now()
	//if err := os.Rename("generated", fmt.Sprintf("generated.%d", now.Unix())); err != nil {
	//	if !os.IsNotExist(err) {
	//		log.Fatal(err)
	//	}
	//}

	doSchedule()

	for k, v := range scheduled {
		fmt.Printf("team%03d: %s\n", k, v)
	}

	//for teamID := 1; teamID <= maxTeamID; teamID++ {
	//	if !isAvailableTeamID(teamID) {
	//		continue
	//	}
	//
	//	if err := generateTeam(teamID); err != nil {
	//		log.Fatal(err)
	//	}
	//}
}

func getBackend(hypervisor string) string {
	s := strings.TrimPrefix(hypervisor, "isucn00")

	id, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}

	// id is 1 to 24
	if id <= 12 {
		return "dorado001"
	} else {
		return "dorado002"
	}
}

func getImageIDs(backend string) (problemImageID, benchImageID, bastionID string) {
	switch backend {
	case "dorado001":
		return "1ab68dff-7d0d-40b5-abff-3ef0db2618b1", "10eee589-725b-4686-a424-1df5e161b031", "5138fee8-59a1-407a-bb84-2937d9705143"
	case "dorado002":
		return "23e33fcd-1951-4185-ba47-0a6fb1dcf50e", "8dea495b-373e-49ca-9b79-caa63e842c7f", "c453a2ef-9865-4b14-bff2-0a78416ebea5"
	default:
		panic("shiran")
	}
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
	m := map[string]interface{}{
		"TeamID":     teamID,
		"TeamSubnet": teamSubnet,
		"TeamIDNum":  strconv.Itoa(id),
	}

	return Tprintf(templateTeamNetwork, m)
}

func generateProblem(id int, teamID, teamSubnet string) string {
	problemID, _, _ := getImageIDs(getBackend(scheduled[id]))

	m := map[string]interface{}{
		"TeamID":           teamID,
		"TeamSubnet":       teamSubnet,
		"TeamIDNum":        strconv.Itoa(id),
		"HypervisorName":   scheduled[id],
		"EuropaBackend":    getBackend(scheduled[id]),
		"ProblemVMImageID": problemID,
	}

	network := Tprintf(templateProblemNetwork, m)
	vm := Tprintf(templateProblemVM, m)

	return strings.Join([]string{network, vm}, "")
}

func generateBench(id int, teamID, teamSubnet string) string {
	_, benchID, _ := getImageIDs(getBackend(scheduled[id]))

	m := map[string]interface{}{
		"TeamID":         teamID,
		"TeamSubnet":     teamSubnet,
		"HypervisorName": scheduled[id],
		"EuropaBackend":  getBackend(scheduled[id]),
		"BenchImageID":   benchID,
	}

	return Tprintf(templateBench, m)

}

func generateBastion(id int, teamID, teamSubnet string) string {
	_, _, bastionID := getImageIDs(getBackend(scheduled[id]))

	m := map[string]interface{}{
		"TeamID":         teamID,
		"TeamSubnet":     teamSubnet,
		"BastionID":      "100",
		"HypervisorName": "isuadm0002",
		"EuropaBackend":  getBackend(scheduled[id]),
		"BastionImageID": bastionID,
	}

	bastion100 := Tprintf(templateBastion, m)

	m = map[string]interface{}{
		"TeamID":         teamID,
		"TeamSubnet":     teamSubnet,
		"BastionID":      "200",
		"HypervisorName": "isuadm0006",
		"EuropaBackend":  getBackend(scheduled[id]),
		"BastionImageID": bastionID,
	}
	bastion200 := Tprintf(templateBastion, m)

	return strings.Join([]string{bastion100, bastion200}, "")
}

func Tprintf(format string, params map[string]interface{}) string {
	for key, val := range params {
		format = strings.Replace(format, "%{"+key+"}s", fmt.Sprintf("%s", val), -1)
	}
	return format
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
const templateTeamNetwork = `resource "lovi_subnet" "team%{TeamID}s" {
  name = "team%{TeamID}s"
  vlan_id = 1000 + %{TeamIDNum}s
  network = "%{TeamSubnet}s.0/24"
  start = "%{TeamSubnet}s.100"
  end = "%{TeamSubnet}s.200"
  gateway = "%{TeamSubnet}s.254"
  dns_server = "8.8.8.8"
  metadata_server = "%{TeamSubnet}s.1"
}

resource "lovi_bridge" "team%{TeamID}s" {
  name = "team%{TeamID}s"
  vlan_id = 1000 + %{TeamIDNum}s

  depends_on = [lovi_subnet.team%{TeamID}s]
}

resource "lovi_internal_bridge" "team%{TeamID}s" {
  name = "team%{TeamID}s-in"
}`

// templateProblemNetwork is template of network resource for problem
// %s catch teamID (%03d)
const templateProblemNetwork = `
variable "node_count" {
  default = 3
}

resource "lovi_address" "problem-team%{TeamID}s" {
  count = var.node_count

  subnet_id = lovi_subnet.team%{TeamID}s.id
  fixed_ip = "%{TeamSubnet}s.${101 + count.index}"
}

resource "lovi_lease" "problem-team%{TeamID}s" {
  count = var.node_count

  address_id = lovi_address.problem-team%{TeamID}s[count.index].id

  depends_on = [lovi_address.problem-team%{TeamID}s]
}`

// templateProblemVM is template of virtual machine resource for problem
// %s catch teamID (%03d)
const templateProblemVM = `
resource "lovi_cpu_pinning_group" "team%{TeamID}s" {
  name = "team%{TeamID}s"
  count_of_core = 4
  hypervisor_name = "%{HypervisorName}s"
}

resource "lovi_virtual_machine" "problem-team%{TeamID}s" {
  count = var.node_count

  name = "team%{TeamID}s-${format("%03d", count.index + 1)}"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "%{ProblemVMImageID}s"
  hypervisor_name = "%{HypervisorName}s"
  europa_backend_name = "%{EuropaBackend}s"

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team%{TeamID}s.name

  depends_on = [
    lovi_cpu_pinning_group.team%{TeamID}s
  ]
}

resource "lovi_interface_attachment" "problem-team%{TeamID}s" {
  count = var.node_count

  virtual_machine_id = lovi_virtual_machine.problem-team%{TeamID}s[count.index].id
  bridge_id = lovi_bridge.team%{TeamID}s.id
  //average = 12500 // NOTE: 100Mbps
  //average = 37500 // NOTE: 300Mbps
  average = 125000 // NOTE: 1Gbps
  name = "t%{TeamID}s-${format("%03d", count.index + 1)}"
  lease_id = lovi_lease.problem-team%{TeamID}s[count.index].id

  depends_on = [
    lovi_virtual_machine.problem-team%{TeamID}s,
    lovi_lease.problem-team%{TeamID}s
  ]
}`

// templateBench is template of resource for benchmarker
const templateBench = `
resource "lovi_address" "bench-team%{TeamID}s" {
  subnet_id = lovi_subnet.team%{TeamID}s.id
  fixed_ip = "%{TeamSubnet}s.104"
}

resource "lovi_lease" "bench-team%{TeamID}s" {
  address_id = lovi_address.bench-team%{TeamID}s.id

  depends_on = [lovi_address.bench-team%{TeamID}s]
}

resource "lovi_virtual_machine" "bench-team%{TeamID}s" {
  name = "team%{TeamID}s-bench"
  vcpus = 1
  memory_kib = 16 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "%{BenchImageID}s"
  hypervisor_name = "%{HypervisorName}s"
  europa_backend_name = "%{EuropaBackend}s"

  depends_on = [
    lovi_virtual_machine.problem-team%{TeamID}s,
    lovi_cpu_pinning_group.team%{TeamID}s
  ]

  read_bytes_sec = 100 * 1000 * 1000
  write_bytes_sec = 100 * 1000 * 1000
  read_iops_sec = 200
  write_iops_sec = 200

  cpu_pinning_group_name = lovi_cpu_pinning_group.team%{TeamID}s.name
}

resource "lovi_interface_attachment" "bench-team%{TeamID}s" {
  virtual_machine_id = lovi_virtual_machine.bench-team%{TeamID}s.id
  bridge_id = lovi_bridge.team%{TeamID}s.id
  average = 12500 // NOTE: 100Mbps
  name = "t%{TeamID}s-be"
  lease_id = lovi_lease.bench-team%{TeamID}s.id

  depends_on = [
    lovi_virtual_machine.bench-team%{TeamID}s,
    lovi_lease.bench-team%{TeamID}s
  ]
}`

// templateBastion is template of resource for bastion
const templateBastion = `
resource "lovi_address" "bastion%{BastionID}s-team%{TeamID}s" {
  subnet_id = lovi_subnet.team%{TeamID}s.id
  fixed_ip = "%{TeamSubnet}s.%{BastionID}s"
}

resource "lovi_lease" "bastion%{BastionID}s-team%{TeamID}s" {
  address_id = lovi_address.bastion%{BastionID}s-team%{TeamID}s.id

  depends_on = [lovi_address.bastion%{BastionID}s-team%{TeamID}s]
}

resource "lovi_virtual_machine" "bastion%{BastionID}s-team%{TeamID}s" {
  name = "team%{TeamID}s-bastion%{BastionID}s"
  vcpus = 1
  memory_kib = 2 * 1024 * 1024
  root_volume_gb = 10
  source_image_id = "%{BastionImageID}s"
  hypervisor_name = "%{HypervisorName}s"
  europa_backend_name = "%{EuropaBackend}s"

  depends_on = [
    lovi_virtual_machine.problem-team%{TeamID}s,
  ]
}

resource "lovi_interface_attachment" "bastion%{BastionID}s-team%{TeamID}s" {
  virtual_machine_id = lovi_virtual_machine.bastion%{BastionID}s-team%{TeamID}s.id
  bridge_id = lovi_bridge.team%{TeamID}s.id
  average = 125000 // NOTE: 1Gbps
  name = "t%{TeamID}s-ba%{BastionID}s"
  lease_id = lovi_lease.bastion%{BastionID}s-team%{TeamID}s.id

  depends_on = [
    lovi_virtual_machine.bastion%{BastionID}s-team%{TeamID}s,
    lovi_lease.bastion%{BastionID}s-team%{TeamID}s
  ]
}`
