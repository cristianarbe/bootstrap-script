package get

import (
	"errors"
	"fmt"
	"github.com/cristianarbe/gnad/pkg/common"
	"os"
	"os/exec"
)

var log = common.Log

func Main(url string) error {
	log("user chose get")

	common.InitGnadHome()

	urlNoHttp := common.RemoveHttp(url)
	log("the url is " + url)
	splitUrl := common.SplitUrl(urlNoHttp)
	fmt.Println(splitUrl)
	absolute_path, err := common.CreateRecursiveDir(splitUrl)
	if err != nil {
		return errors.New("Can't create directories")
	}

	cmd := exec.Command("git", "clone", url, absolute_path)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		return errors.New("Git clone failed.")
	}

	return nil
}
