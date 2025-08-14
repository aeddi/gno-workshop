MAKEFILE_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GNO_LAND_DIR = $(MAKEFILE_DIR)/gno.land
DEV_CONT_DIR = $(MAKEFILE_DIR)/.devcontainer

.PHONY: all test lint fmt install_tools help

help:
	@echo "Available commands:"
	@echo "  make dev             ->  Run the development node"
	@echo "  make test            ->  Run all gno tests"
	@echo "  make lint            ->  Lint all gno files"
	@echo "  make fmt             ->  Format all gno files"
	@echo "  make all             ->  Run fmt, test & lint commands"
	@echo "  make install_tools   ->  Install gno tools locally"
	@echo "  make [help]          ->  Show this help message"

all: fmt test lint

# Run the development node
dev:
	(cd $(MAKEFILE_DIR) && gnodev local -web-home /r/workshop/home)

# Run all tests
test:
	gno test -v $(MAKEFILE_DIR)/...

# Run linter
lint:
	gno lint -v $(MAKEFILE_DIR)

# Format the code
fmt:
	gno fmt -w $(MAKEFILE_DIR)/...

# Install gno tools locally
install_tools:
	GNO_COMMIT="$$($(DEV_CONT_DIR)/get_gno_commit.sh)"; \
 	curl -sSL "https://raw.githubusercontent.com/gnolang/gno/$$GNO_COMMIT/misc/install.sh" | bash
