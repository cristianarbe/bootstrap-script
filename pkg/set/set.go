package set

import (
	"github.com/cristianarbe/gnad/config"
	"github.com/cristianarbe/gnad/pkg/common"
	"log"
	"os"
	"os/exec"
	"strings"
)

func Main(pkg string) {
	installedPackages, err := common.ListPackages()

	if err != nil {
		log.Fatal(err.Error())
	}

	var runTarget []string

	for _, c := range installedPackages {
		if strings.Contains(c, pkg) {
			runTarget = append(runTarget, c)
		}
	}

	if len(runTarget) == 0 {
		common.Log("No matches found.")
		return
	} else if len(runTarget) != 1 {
		common.Bye("Found more than one match. Try being more specific.")
	}

	common.Log("Running " + runTarget[0])
	cmd := exec.Command("/bin/bash", config.GnadHome()+runTarget[0]+"/main")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Fatal(err.Error())
	}

	common.Bye("Done!")

	return
}
