.PHONY: build clean install
SHELL := /bin/bash # Use bash syntax
bootstrap: main.sh
	@echo "Building..."
	@shellcheck main.sh -x
	@while IFS= read -r line; do \
	if [[ $$line == *source* ]]; then \
	eval "$${line//source/cat}" >> bootstrap; \
	else \
	echo "$$line" >> bootstrap; \
	fi; \
	done < main.sh
	@echo "Built succesfully"
clean:
	@echo "Cleaning up..."
	@rm bootstrap
	@echo "Cleaned succesfully"
install:
	@bash bootstrap
