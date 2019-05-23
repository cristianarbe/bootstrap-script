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
		[[ -f bootstrap.sh ]] && rm bootstrap.sh
		output > bootstrap.sh
		if [[ -f bootstrap.sh ]]; then
				echo "Built successfully"
		else
				echo failed
		fi
}

main
