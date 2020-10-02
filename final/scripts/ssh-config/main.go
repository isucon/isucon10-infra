package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/whywaita/satelit-isucon/team"
)

var privateKeyPath = "~/.ssh/id_rsa"

const templateSSHConfig = `
Host %s.*
  User isucon-admin
  ProxyJump %s
  IdentityFile %s
  StrictHostKeyChecking no

`

const templateBastionConfig = `
Host team%d-bastion200
  User isucon-admin
  HostName %s
  Port 20340
  IdentityFile %s
  StrictHostKeyChecking no

`

const templateCNConfig = `
Host isucn00%s.hv.x.isucon.dev
  User whywaita
  IdentityFile %s
  StrictHostKeyChecking no

`

func main() {
	if len(os.Args) != 1 && len(os.Args) != 2 {
		panic("args error")
	}

	doSchedule()

	// switch mode "cn" or "global"
	switch os.Args[1] {
	case "cn":
		generateFromCN()
	case "global":
		generateFromGlobal()
	}

}

func generateFromCN() {
	for i := 1; i <= 24; i++ {
		fmt.Printf(templateCNConfig, fmt.Sprintf("%02d", i), privateKeyPath)
	}

	ids := team.GetTeamIDs()

	for _, id := range ids {
		ipNet, err := team.GetTeamSubnet(id)
		if err != nil {
			panic("aa")
		}
		words := strings.Split(ipNet.String(), ".")
		teamSubnet := strings.Join(words[:3], ".")

		fmt.Printf(templateSSHConfig, teamSubnet, scheduled[id]+".hv.x.isucon.dev", privateKeyPath)
	}
}

func generateFromGlobal() {
	ids := team.GetTeamIDs()

	for _, id := range ids {
		bastion := getBastionIP(id)
		fmt.Printf(templateBastionConfig, id, bastion, privateKeyPath)

		ipNet, err := team.GetTeamSubnet(id)
		if err != nil {
			panic("aa")
		}
		words := strings.Split(ipNet.String(), ".")
		teamSubnet := strings.Join(words[:3], ".")

		bastionHostName := fmt.Sprintf("team%d-bastion200", id)

		fmt.Printf(templateSSHConfig, teamSubnet, bastionHostName, privateKeyPath)
	}
}

func getBastionIP(teamID int) string {
	var three, four int // octet

	switch {
	case teamID <= 254:
		three = 64
		four = teamID
	case 255 <= teamID && teamID <= 508:
		three = 65
		four = teamID - 254
	case teamID <= 576:
		three = 66
		four = teamID - 508
	}

	return fmt.Sprintf("157.112.%d.%d", three, four)
}

var (
	scheduled = map[int]string{}
)

const (
	// CountTeamPerHost is number of team in a same host
	CountTeamPerHost = 2
)

func doSchedule() {
	NumberCN := 1
	finalTeamIDs := team.GetTeamIDs()

	perHost := CountTeamPerHost

	for _, teamID := range finalTeamIDs {
		scheduled[teamID] = fmt.Sprintf("isucn%04d", NumberCN)
		perHost--

		if perHost == 0 {
			// 新しいCNへ
			NumberCN++
			perHost = CountTeamPerHost
		}
		if teamID == 515 {
			// ガチチーム終了、並行チームは別のCNに行きましょうね
			NumberCN++
			perHost = CountTeamPerHost
		}
	}
}
