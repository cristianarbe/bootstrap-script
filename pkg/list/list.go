package list

import (
	"fmt"
	"github.com/cristianarbe/gnad/pkg/common"
	"os"
)

func Main() {
	common.Log("Initiating list.Main")
	installedPackages,err := common.ListPackages()
	common.Log("Got installed packages.")

	if err != nil {
		common.Log(err.Error())
		os.Exit(1)
	}

	for _,c := range installedPackages {
		fmt.Println(c)
	}

	return
}
