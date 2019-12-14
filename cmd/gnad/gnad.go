package main

import (
	"fmt"
	"github.com/cristianarbe/gnad/config"
	"github.com/cristianarbe/gnad/pkg/common"
	"github.com/cristianarbe/gnad/pkg/get"
	"github.com/cristianarbe/gnad/pkg/list"
	"github.com/cristianarbe/gnad/pkg/set"
	"log"
	"os"
	"strconv"
)

func main() {
	numberOfArguments := len(os.Args[1:])

	common.Log("Number of arguments is " + strconv.Itoa(numberOfArguments))
	common.Log("Your gnad home is " + config.GnadHome())

	if numberOfArguments == 0 {
		log.Fatal("Error, no arguments given.")
	} else if numberOfArguments > 2 {
		log.Fatal("Too many arguments given.")
	}

	argsVerb := os.Args[1]
	argsObject := ""

	if numberOfArguments == 1 {
		common.Log("The verb is " + argsVerb + " and there is no object")
	} else {
		argsObject = os.Args[2]
		common.Log("The verb is " + argsVerb + " and the object is " + argsObject)
	}

	switch argsVerb {
	case "get":
		if numberOfArguments != 2 {
			log.Fatal("Incorrect number of arguments.")
		}

		get.Main(argsObject)
	case "ls":
		if numberOfArguments != 1 {
			common.Log("Incorrect number of arguments.")
		}

		list.Main()
	case "set":
		if numberOfArguments != 2 {
			log.Fatal("Incorrect number of arguments.")
		}

		set.Main(argsObject)
	case "version":
		fmt.Println(config.Version)
	default:
		common.Bye("Invalid operation \"" + argsVerb + "\"")
	}

}
