package get

import (
	"fmt"
	"github.com/cristianarbe/gnad/pkg/common"
	"log"
	"os"
	"os/exec"
)

func Main(url string) {
	common.Log("user chose get")

	common.InitGnadHome()

	urlNoHttp := common.RemoveHttp(url)
	common.Log("the url is " + url)
	splitUrl := common.SplitUrl(urlNoHttp)
	fmt.Println(splitUrl)
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
