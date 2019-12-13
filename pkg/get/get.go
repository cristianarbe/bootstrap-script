package get

import (
	"fmt"
	"github.com/cristianarbe/gnad/pkg/common"
	"os"
	"os/exec"
)

var log = common.Log

func Main(url string){
	log("user chose get")

	common.InitGnadHome()

	urlNoHttp := common.RemoveHttp(url)
	log("the url is " + url)
	splitUrl := common.SplitUrl(urlNoHttp)
	fmt.Println(splitUrl)
	absolutePath := common.CreateRecursiveDir(splitUrl)

	cmd := exec.Command("git", "clone", url, absolutePath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		common.Log(err.Error())
		os.Exit(1)
	}

	return
}
