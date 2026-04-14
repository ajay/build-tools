################################################################################

PYTHON ?= python3
REPO_ROOT ?= $(shell git rev-parse --show-toplevel)
RM ?= rm -rf
SHELL := bash

MAKEFLAGS += -rR                        # do not use make's built-in rules and variables
MAKEFLAGS += -k                         # keep going on errors
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################
