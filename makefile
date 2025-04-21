# Root Makefile to manage ESP-IDF projects

# Default USB-Serial port (can override at runtime)
PORT ?= /dev/tty.usbserial-XXXXX

# Script paths
NEW_PROJECT_SCRIPT = ./new.sh
FLASH_AND_BUILD_SCRIPT = ./run.sh

# Capture project name passed as second argument
PROJECT := $(word 2, $(MAKECMDGOALS))

# Create a new project
new:
	@if [ -z "$(PROJECT)" ]; then \
		echo "❌ Please specify a project name. Example: make new my_project"; \
		exit 1; \
	fi
	@echo "🚀 Creating project: $(PROJECT)"
	@chmod +x $(NEW_PROJECT_SCRIPT)
	@$(NEW_PROJECT_SCRIPT) $(PROJECT)

# Build, flash, and monitor a project
run:
	@if [ -z "$(PROJECT)" ]; then \
		echo "❌ Please specify a project name. Example: make run my_project"; \
		exit 1; \
	fi
	@echo "🚀 Running project: $(PROJECT)"
	cd $(PROJECT) && chmod +x $(abspath $(FLASH_AND_BUILD_SCRIPT)) && $(abspath $(FLASH_AND_BUILD_SCRIPT))

# Clean project
clean:
	@if [ -z "$(PROJECT)" ]; then \
		echo "❌ Please specify a project name. Example: make clean my_project"; \
		exit 1; \
	fi
	@echo "🧹 Cleaning project: $(PROJECT)"
	cd $(PROJECT) && idf.py fullclean

# Allow passing project name as second argument
%:
	@:
