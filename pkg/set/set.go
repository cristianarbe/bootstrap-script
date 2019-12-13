package set

import (
	"github.com/cristianarbe/gnad/pkg/common"
	"os"
	"strings"
)

func Main(pkg string) {
	installedPackages,err := common.ListPackages()

	if err != nil {
		common.Log(err.Error())
		os.Exit(1)
	}

	var runTarget []string

	for _,c := range installedPackages {
		if strings.Contains(c, pkg){
			runTarget = append(runTarget, c)
		}
	}

	if len(runTarget) == 0 {
		common.Log("I have found no matches.")
		return
	} else if len(runTarget) != 1 {
		common.Log("I have found more than one match. Don't know what to do.")
		os.Exit(1)
	}

	common.Log("Running " + runTarget[0])

	return
}