package config

import (
	"log"
	"os/user"
)

const Debug = false

const Version = "v0.1"

func GnadHome() string {
	user, err := user.Current()
	homeDir := user.HomeDir + "/"

	if err != nil {
		log.Fatal(err)
	}

	return homeDir + ".cache/gnad/"
}
