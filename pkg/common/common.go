package common

import (
	"errors"
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"os"
	"strings"
	"time"
	"path/filepath"
)

var log = Log

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

func RemoveHttp(url string) string {
	url = strings.Replace(url, "https://", "", -1)
	url = strings.Replace(url, "http://", "", -1)
	return url
}

func SplitUrl(url string) []string {
	out := strings.SplitN(url, "/", -1)
	return out
}

func InitGnadHome() error {
	if !FileFolderExists(config.GnadHome) {
		log(config.GnadHome + " does not exist")
		log("creating " + config.GnadHome)
		err := os.MkdirAll(config.GnadHome, 0700)
		if err != nil {
			return errors.New("Could not create directory")
		}
		log("Directory created")
	} else {
		log(config.GnadHome + " found")
	}

	return nil

}

func CreateRecursiveDir(url_path []string) (string, error) {
	absolute_path := config.GnadHome
	for _, c := range url_path {
		absolute_path = absolute_path + "/" + c
		err := os.MkdirAll(absolute_path, 0700)
		if err != nil {
			return "", errors.New("Failed to create directory")
		} else {
			log("Created " + absolute_path)
		}
	}

	return absolute_path, nil
}

func ListRecursive(inputPath string) ([]string, error){
	var files []string
	filepath.Walk(inputPath, func(file string, info os.FileInfo, err error) error {
		files = append(files,file)
		return nil
	})
	return files, nil
}

func FindInDir(inputPath string, searchTerm string) ([]string, error){
	allFiles,_ := ListRecursive(inputPath)
	var filesMatching []string
	for _,c := range allFiles {
		splitFile := SplitUrl(c)
		fileName := splitFile[len(splitFile)-1]
		if fileName == searchTerm {
			filesMatching=append(filesMatching, c)
		}
	}

	return filesMatching, nil
}
