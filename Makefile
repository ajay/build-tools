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

REPO_ROOT := $(shell git rev-parse --show-toplevel)

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
