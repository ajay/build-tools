################################################################################

# Copied from build-tools repo.mk reference implementation.
# https://github.com/ajay/build-tools/blob/main/makefiles/repo.mk
# Keep in sync with the reference when updating.

REPO_ROOT := $(shell git rev-parse --show-toplevel)

repo-init:
	@## initialize git submodules
	git submodule sync --recursive
	git submodule update --init --recursive

ifneq ($(MAKECMDGOALS),repo-init)
ifneq (,$(shell git submodule status --recursive 2>/dev/null | grep '^-'))
$(error ERROR: git submodules not initialized; run `make repo-init`)
endif
endif

################################################################################

include makefiles/help.mk
include makefiles/os.mk
include makefiles/repo.mk

################################################################################

SHELL := bash

MAKEFLAGS += -rR                        # do not use make's built-in rules and variables
MAKEFLAGS += -k                         # keep going on errors
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

.DEFAULT_GOAL := help

install-deps:
	@## install dependencies
	tools/deps/os/$(OS).sh

ci: repo-check
	@## run CI checks
	(cd test/makefiles/ && ./makefiles_test.bats)

################################################################################
