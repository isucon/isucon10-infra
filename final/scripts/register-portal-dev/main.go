package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"strconv"
	"strings"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"

	"github.com/isucon/isucon10-portal/proto.go/isuxportal/resources"
	portalpb "github.com/isucon/isucon10-portal/proto.go/isuxportal/services/dcim"
)

const (
	portalAPIEndpoint = "portal-grpc-dev.x.isucon.dev:443"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func run() error {
	//args := os.Args
	//satelitAddress := args[1]
	//if satelitAddress == "" {
	//	return errors.New("need to set satelit address")
	//}
	//fmt.Printf("satelit adddress: %s\n", satelitAddress)
	//
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	//connSatelit, err := grpc.DialContext(ctx, satelitAddress, grpc.WithBlock(), grpc.WithInsecure())
	//if err != nil {
	//	return err
	//}
	//
	//satelitClient := satelitpb.NewSatelitClient(connSatelit)

	connPortal, err := grpc.DialContext(ctx, portalAPIEndpoint, grpc.WithBlock(), grpc.WithTransportCredentials(credentials.NewClientTLSFromCert(nil, "")))
	if err != nil {
		return err
	}
	portalClient := portalpb.NewInstanceManagementClient(connPortal)

	//resp, err := satelitClient.ListVirtualMachine(ctx, &satelitpb.ListVirtualMachineRequest{})
	//if err != nil {
	//	return err
	//}

	//for _, vm := range resp.VirtualMachines {
	//	ci, err := parseVMName(vm.Name, vm.Uuid)
	//	if err != nil {
	//		continue
	//	}
	//
	//	req := &portalpb.InformInstanceStateUpdateRequest{
	//		Token:    "himitsudayo",
	//		Instance: ci,
	//	}
	//	//if _, err := portalClient.InformInstanceStateUpdate(ctx, req); err != nil {
	//	//	return err
	//	//}
	//
	//	fmt.Println(req)
	//}

	//ci5291 := &resources.ContestantInstance{
	//	CloudId:            uuid.NewV4().String(),
	//	TeamId:             1,
	//	Number:             1,
	//	PublicIpv4Address:  "isu1.t.isucon.dev",
	//	PrivateIpv4Address: "10.165.29.101",
	//	Status:             resources.ContestantInstance_RUNNING,
	//}
	//ci5292 := &resources.ContestantInstance{
	//	CloudId:            uuid.NewV4().String(),
	//	TeamId:             1,
	//	Number:             2,
	//	PublicIpv4Address:  "isu2.t.isucon.dev",
	//	PrivateIpv4Address: "10.165.29.102",
	//	Status:             resources.ContestantInstance_RUNNING,
	//}
	//ci5293 := &resources.ContestantInstance{
	//	CloudId:            uuid.NewV4().String(),
	//	TeamId:             1,
	//	Number:             3,
	//	PublicIpv4Address:  "isu3.t.isucon.dev",
	//	PrivateIpv4Address: "10.165.29.103",
	//	Status:             resources.ContestantInstance_RUNNING,
	//}

	ci5301 := &resources.ContestantInstance{
		CloudId:            "team530-001",
		TeamId:             10,
		Number:             1,
		PublicIpv4Address:  "isu1.t.isucon.dev",
		PrivateIpv4Address: "10.165.30.101",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5302 := &resources.ContestantInstance{
		CloudId:            "team530-002",
		TeamId:             10,
		Number:             2,
		PublicIpv4Address:  "isu2.t.isucon.dev",
		PrivateIpv4Address: "10.165.30.102",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5303 := &resources.ContestantInstance{
		CloudId:            "team530-003",
		TeamId:             10,
		Number:             3,
		PublicIpv4Address:  "isu3.t.isucon.dev",
		PrivateIpv4Address: "10.165.30.103",
		Status:             resources.ContestantInstance_RUNNING,
	}

	ci5311 := &resources.ContestantInstance{
		CloudId:            "team531-001",
		TeamId:             8,
		Number:             1,
		PublicIpv4Address:  "isu1.t.isucon.dev",
		PrivateIpv4Address: "10.165.31.101",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5312 := &resources.ContestantInstance{
		CloudId:            "team531-002",
		TeamId:             8,
		Number:             2,
		PublicIpv4Address:  "isu2.t.isucon.dev",
		PrivateIpv4Address: "10.165.31.102",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5313 := &resources.ContestantInstance{
		CloudId:            "team531-003",
		TeamId:             8,
		Number:             3,
		PublicIpv4Address:  "isu3.t.isucon.dev",
		PrivateIpv4Address: "10.165.31.103",
		Status:             resources.ContestantInstance_RUNNING,
	}

	ci5321 := &resources.ContestantInstance{
		CloudId:            "team532-001",
		TeamId:             9,
		Number:             1,
		PublicIpv4Address:  "isu1.t.isucon.dev",
		PrivateIpv4Address: "10.165.32.101",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5322 := &resources.ContestantInstance{
		CloudId:            "team532-002",
		TeamId:             9,
		Number:             2,
		PublicIpv4Address:  "isu2.t.isucon.dev",
		PrivateIpv4Address: "10.165.32.102",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5323 := &resources.ContestantInstance{
		CloudId:            "team532-003",
		TeamId:             9,
		Number:             3,
		PublicIpv4Address:  "isu3.t.isucon.dev",
		PrivateIpv4Address: "10.165.32.103",
		Status:             resources.ContestantInstance_RUNNING,
	}

	ci5331 := &resources.ContestantInstance{
		CloudId:            "team533-001",
		TeamId:             11,
		Number:             1,
		PublicIpv4Address:  "isu1.t.isucon.dev",
		PrivateIpv4Address: "10.165.33.101",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5332 := &resources.ContestantInstance{
		CloudId:            "team533-002",
		TeamId:             11,
		Number:             2,
		PublicIpv4Address:  "isu2.t.isucon.dev",
		PrivateIpv4Address: "10.165.33.102",
		Status:             resources.ContestantInstance_RUNNING,
	}
	ci5333 := &resources.ContestantInstance{
		CloudId:            "team532-003",
		TeamId:             11,
		Number:             3,
		PublicIpv4Address:  "isu3.t.isucon.dev",
		PrivateIpv4Address: "10.165.33.103",
		Status:             resources.ContestantInstance_RUNNING,
	}

	cis := []*resources.ContestantInstance{
		ci5301, ci5302, ci5303,
		ci5311, ci5312, ci5313,
		ci5321, ci5322, ci5323,
		ci5331, ci5332, ci5333}

	for _, ci := range cis {
		req := &portalpb.InformInstanceStateUpdateRequest{
			Token:    "himitsudayo",
			Instance: ci,
		}
		fmt.Println(req)
		if _, err := portalClient.InformInstanceStateUpdate(ctx, req); err != nil {
			return err
		}
	}

	return nil
}

//// ex:) team0XX-00X
func parseVMName(vmName, vmUUID string) (*resources.ContestantInstance, error) {
	s := strings.Split(vmName, "-")

	teamID, err := strconv.Atoi(strings.TrimPrefix(s[0], "team"))
	if err != nil {
		return nil, err
	}
	if s[1] == "bench" {
		return nil, errors.New("invalid number")
	}

	number, err := strconv.Atoi(s[1])
	if err != nil {
		return nil, err
	}

	if number < 1 || number > 4 {
		return nil, errors.New("invalid number")
	}

	base := 160
	under := teamID % 100         // 下2桁
	top := (teamID - under) / 100 // 百の位の数字

	ip := fmt.Sprintf("10.%d.%d.%d", base+top, under, number+100)

	ci := &resources.ContestantInstance{
		CloudId:            vmUUID,
		TeamId:             int64(teamID),
		Number:             int64(number),
		PublicIpv4Address:  fmt.Sprintf("isu%d.t.isucon.dev", number),
		PrivateIpv4Address: ip,
		Status:             resources.ContestantInstance_RUNNING,
	}

	return ci, nil
}
