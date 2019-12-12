package list

import (
	"github.com/cristianarbe/gnad/config"
	"github.com/cristianarbe/gnad/pkg/common"
	"fmt"
	"strings"
)

func Main() {
	packages,_ := common.FindInDir(config.GnadHome, "main")

	for  _, packageName := range packages {
		packageName = strings.Replace(packageName, config.GnadHome + "/","",-1)
		packageName = strings.Replace(packageName, "/main","",-1)
		fmt.Println(packageName)
	}
}
