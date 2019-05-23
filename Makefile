#!/bin/bash
function output(){
		while IFS= read -r line; do
				if [[ $line == *source* ]]; then
						eval "${line//source/cat}"
				else
						echo "$line"
				fi
		done < install
}

function main(){
	if [[ "$1" == "" ]]; then
		[[ -f bootstrap.sh ]] && rm bootstrap.sh
		output > bootstrap.sh
		if [[ -f bootstrap.sh ]]; then
				echo "Built successfully"
		else
				echo failed
		fi
	elif [[ "$1" == "install" ]]; then
		bash bootstrap.sh
	fi
}

main "$@"
