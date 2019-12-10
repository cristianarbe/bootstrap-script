package common

import (
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"os"
	"time"
)

func FileFolderExists(path string) bool {
	_, os_stat_error := os.Stat(path)
	//fmt.Println(os_stat_error)
	error_is_doesnt_exist := os.IsNotExist(os_stat_error)
	//fmt.Println(error_is_doesnt_exist)

	if error_is_doesnt_exist {
		return false
	} else {
		return true
	}
}

func Log(message string) {
	if config.Debug {
		currentTime := time.Now().Format("2006-01-02 15:04:05")
		fmt.Printf("[%v] %s\n", currentTime, message)
	}
}