################################################################################

include makefiles/help.mk

################################################################################

SHELL = bash

MAKEFLAGS += -rR                        # do not use make's built-in rules and variables
MAKEFLAGS += -k                         # keep going on errors
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

ifeq ($(shell uname -s),Darwin)
OS := mac
else
OS := $(shell lsb_release --id | awk '{print $$3}' | tr A-Z a-z)
endif

################################################################################

.DEFAULT_GOAL := help

install-deps:
	@## install-deps
	@tools/deps/os/$(OS).sh

ci:
	@## ci
	@(cd test/makefiles/ && ./makefiles_test.bats)
