package common

import (
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func FileFolderExists(path string) (bool, error) {
	_, osStatError := os.Stat(path)

	errorIsDoesntExist := os.IsNotExist(osStatError)

	if errorIsDoesntExist {
		return false, nil
	} else {
		return true, nil
	}
}

func Log(message string) {
	if config.Debug {
		currentTime := time.Now().Format("2006-01-02 15:04:05.000000")
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

func InitGnadHome(){
	exists, err := FileFolderExists(config.GnadHome)
	
	if err != nil {
		Log(err.Error())
		os.Exit(1)
	}

	if !exists {

		Log(config.GnadHome + " does not exist, creating it")

		err := os.MkdirAll(config.GnadHome, 0700)

		if err != nil {
			Log(err.Error())
			os.Exit(1)
		}

		Log("Directory created")
	} else {
		Log(config.GnadHome + " found")
	}

	return
}

func CreateRecursiveDir(urlPath []string) (string) {
	absolutePath := config.GnadHome
	for _, c := range urlPath {
		absolutePath = absolutePath + "/" + c
		err := os.MkdirAll(absolutePath, 0700)
		if err != nil {
			Log(err.Error())
			os.Exit(1)
		} else {
			Log("Created " + absolutePath)
		}
	}

	return absolutePath
}

func ListRecursive(inputPath string) ([]string, error) {
	var files []string
	filepath.Walk(inputPath, func(file string, info os.FileInfo, err error) error {
		files = append(files, file)
		return nil
	})
	return files, nil
}

func FindInDir(inputPath string, searchTerm string) ([]string) {
	allFiles, err := ListRecursive(inputPath)

	if err != nil {
		Log(err.Error())
		os.Exit(1)
	}

	var filesMatching []string
	for _, c := range allFiles {
		splitFile := SplitUrl(c)
		fileName := splitFile[len(splitFile)-1]
		if fileName == searchTerm {
			filesMatching = append(filesMatching, c)
		}
	}

	return filesMatching
}

func ListPackages() ([]string, error) {
	packages := FindInDir(config.GnadHome, "main")

	var installedPackages []string

	for _, packageName := range packages {
		packageName = strings.Replace(packageName, config.GnadHome+"/", "", -1)
		packageName = strings.Replace(packageName, "/main", "", -1)
		installedPackages = append(installedPackages, packageName)
	}

	return installedPackages, nil
}
