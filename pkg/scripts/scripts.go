package scripts

import (
	"errors"
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"github.com/cristianarbe/gnad/pkg/common"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
)

func Rm(scriptToRemove string) {
	selected, err := GetPath(scriptToRemove)

	if err != nil {
		common.Bye(err.Error())
	}

	toDelete := config.GnadHome() + selected + "/"
	fmt.Printf("Are you sure you want to delete %s? [y/N] ", toDelete)
	response := common.ReadInput("")

	if response != "y" && response != "Y" {
		common.Bye("Exiting.")
	}

	common.Log("I am deleting then.")
	err = os.RemoveAll(toDelete)

	if err != nil {
		log.Fatal("Failed to remove directory.")
	}

	common.Bye("All done!")

}

func Get(url string) {
	common.Log("user chose get")
	common.Log("the url is " + url)

	common.InitGnadHome()

	urlNoHttp := common.RemoveHttp(url)

	common.Log("I am checking if it already exists.")
	path, err := GetPath(urlNoHttp)
	path = config.GnadHome() + path

	if err == nil {
		fmt.Printf("Script %s already exists. Do you want to override it? [y/N] ", path)
		response := common.ReadInput("")
		if response != "y" && response != "Y" {
			common.Bye("Exiting.")
		}

		os.RemoveAll(path)
	}

	splitUrl := common.SplitUrl(urlNoHttp)
	absolutePath := common.CreateRecursiveDir(splitUrl)

	cmd := exec.Command("git", "clone", url, absolutePath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
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

	currentScriptFile := config.GnadHome() + "current"

	var checkForCurrent bool
	var currentScript string

	common.Log("Checking for " + currentScriptFile)

	exists := common.FileFolderExists(currentScriptFile)

	if exists {
		common.Log("Script file exists.")
		checkForCurrent = true
		currentScriptByte, err := ioutil.ReadFile(currentScriptFile)

		if err != nil {
			log.Fatal(err)
		}

		currentScript = string(currentScriptByte)
	} else {
		common.Log("Script file does not exist.")
		common.WriteFile(currentScriptFile, "")
		checkForCurrent = false
	}

	for _, c := range installedPackages {

		if checkForCurrent && c == currentScript {
			fmt.Print("* ")
		} else {
			fmt.Print("  ")
		}

		fmt.Printf("%s\n", c)
	}

	return
}

func Set(pkg string) {
	target, err := GetPath(pkg)

	if err != nil {
		common.Bye(err.Error())
	}

	common.Log("Running " + target)
	cmd := exec.Command("/bin/bash", config.GnadHome()+target+"/main")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Fatal(err.Error())
	}

	currentScriptFile := config.GnadHome() + "current"
	common.Log("writing " + target + " to " + currentScriptFile)
	common.WriteFile(currentScriptFile, target)
	common.Bye("Done!")

	return
}

func GetPath(query string) (string, error) {
	installedPackages, err := common.ListPackages()

	if err != nil {
		log.Fatal(err.Error())
	}

	var found []string

	for _, c := range installedPackages {
		if strings.Contains(c, query) {
			found = append(found, c)
		}
	}

	if len(found) == 0 {
		return "", errors.New("No matches found.")
	} else if len(found) > 1 {
		return "", errors.New("Found more than one match")
	}

	return found[0], nil

}
