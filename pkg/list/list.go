package list

import (
	"fmt"
	"github.com/cristianarbe/gnad/pkg/common"
	"log"
)

func Main() {
	common.Log("Initiating list.Main")
	installedPackages, err := common.ListPackages()
	common.Log("Got installed packages.")

	if err != nil {
		log.Fatal(err.Error())
	}

	for _, c := range installedPackages {
		fmt.Println(c)
	}

	return
}
