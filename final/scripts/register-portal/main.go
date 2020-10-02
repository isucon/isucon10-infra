package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/whywaita/satelit-isucon/team"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"

	"github.com/isucon/isucon10-portal/proto.go/isuxportal/resources"
	portalpb "github.com/isucon/isucon10-portal/proto.go/isuxportal/services/dcim"
	satelitpb "github.com/whywaita/satelit/api/satelit"
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
	args := os.Args
	satelitAddress := args[1]
	if satelitAddress == "" {
		return errors.New("need to set satelit address")
	}
	fmt.Printf("satelit adddress: %s\n", satelitAddress)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	connSatelit, err := grpc.DialContext(ctx, satelitAddress+":9262", grpc.WithBlock(), grpc.WithInsecure())
	if err != nil {
		return err
	}

	satelitClient := satelitpb.NewSatelitClient(connSatelit)

	connPortal, err := grpc.DialContext(ctx, portalAPIEndpoint, grpc.WithBlock(), grpc.WithTransportCredentials(credentials.NewClientTLSFromCert(nil, "")))
	if err != nil {
		return err
	}
	portalClient := portalpb.NewInstanceManagementClient(connPortal)
	fmt.Println(portalClient)

	resp, err := satelitClient.ListVirtualMachine(ctx, &satelitpb.ListVirtualMachineRequest{})
	if err != nil {
		return err
	}

	for _, vm := range resp.VirtualMachines {
		ci, err := parseVMName(vm.Name, vm.Uuid)
		if err != nil {
			continue
		}

		req := &portalpb.InformInstanceStateUpdateRequest{
			Token:    "himitsudayo",
			Instance: ci,
		}
		//if _, err := portalClient.InformInstanceStateUpdate(ctx, req); err != nil {
		//	return err
		//}

		fmt.Println(req)
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

	if !team.IsAvailable(teamID) {
		return nil, errors.New("unavailable")
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
