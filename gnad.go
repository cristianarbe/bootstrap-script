package main

import (
	"github.com/cristianarbe/gnad/common"
	"github.com/cristianarbe/gnad/config"
	"os"
	"strconv"
)

var log = common.Log

func main() {
	numberOfArguments := len(os.Args[1:])

	log("Number of arguments is " + strconv.Itoa(numberOfArguments))

	if numberOfArguments == 0 {
		log("Error, no arguments given.")
		os.Exit(1)
	} else if numberOfArguments > 2 {
		log("Too many arguments given.")
		os.Exit(1)
	}

	argsVerb := os.Args[1]

	if numberOfArguments == 1 {
		log("The verb is " + argsVerb + " and there is no object")
	} else {
		argsObject := os.Args[2]
		log("The verb is " + argsVerb + " and the object is " + argsObject)
	}

	switch argsVerb {
	case "get":
		log("user chose get")
		if !common.FileFolderExists(config.GnadHome) {
			log(config.GnadHome + " does not exist")
			log("creating " + config.GnadHome)
		} else {
			log(config.GnadHome + " found")
		}
	default:
		log(argsVerb + " not recognized")
	}

}
