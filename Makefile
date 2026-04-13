################################################################################

# Copied from build-tools repo.mk reference implementation.
# https://github.com/ajay/build-tools/blob/main/makefiles/repo.mk
# Keep in sync with the reference when updating.

REPO_ROOT := $(shell git rev-parse --show-toplevel)

# Path to repo.mk — used as existence check for whether submodules
# are initialized. Update this path to match your submodule layout.
REPO_INIT_CHECK := $(REPO_ROOT)/test/helpers/bats-assert/load.bash

repo-init:
	@## initialize git submodules
	git submodule sync --recursive
	git submodule update --init --recursive

ifneq ($(MAKECMDGOALS),repo-init)
ifeq (,$(wildcard $(REPO_INIT_CHECK)))
$(error ERROR: git submodules not initialized; run `make repo-init`)
endif
endif

################################################################################

include makefiles/help.mk
include makefiles/repo.mk

################################################################################

SHELL := bash

MAKEFLAGS += -rR                        # do not use make's built-in rules and variables
MAKEFLAGS += -k                         # keep going on errors
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

ifeq ($(shell uname -s),Darwin)
	OS := mac
else
	OS := $(shell lsb_release -is | tr A-Z a-z)
endif

################################################################################

.DEFAULT_GOAL := help

install-deps:
	@## install dependencies
	tools/deps/os/$(OS).sh

ci: repo-check
	@## run CI checks
	(cd test/makefiles/ && ./makefiles_test.bats)

################################################################################
