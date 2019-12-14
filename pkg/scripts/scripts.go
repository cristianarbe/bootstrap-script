package scripts

import (
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"github.com/cristianarbe/gnad/pkg/common"
	"log"
	"os"
	"os/exec"
	"strings"
)

func Rm(script string){
	fmt.Println(script)
}

func Get(url string) {
	common.Log("user chose get")

	common.InitGnadHome()

	urlNoHttp := common.RemoveHttp(url)
	common.Log("the url is " + url)
	splitUrl := common.SplitUrl(urlNoHttp)
	absolutePath := common.CreateRecursiveDir(splitUrl)

	cmd := exec.Command("git", "clone", url, absolutePath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		log.Fatal(err.Error())
	}

	return
}

func List() {
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

func Set(pkg string) {
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