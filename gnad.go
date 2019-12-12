package main

import (
	"github.com/cristianarbe/gnad/common"
	"github.com/cristianarbe/gnad/get"
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
	argsObject := ""

	if numberOfArguments == 1 {
		log("The verb is " + argsVerb + " and there is no object")
	} else {
		argsObject = os.Args[2]
		log("The verb is " + argsVerb + " and the object is " + argsObject)
	}

	switch argsVerb {
	case "get":
		if numberOfArguments == 2 {
			get.Main(argsObject)
		} else {
			log("Incorrect number of arguments.")
		}
	default:
		log(argsVerb + " not recognized")
	}

}
