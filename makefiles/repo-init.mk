################################################################################

# Reference implementation of repo-init for repos using git submodules.
#
# The repo-init target below is commented out because it must live in each
# repo's root Makefile (it needs to run before submodules are available).
#
# This file is included via include. Its existence is used to check whether
# submodules have been initialized.
#
# To use: copy the block between the dividers below into your repo's root
# Makefile and uncomment all lines (remove the leading "# ").

################################################################################
## Copy-paste block — uncomment all lines after pasting into your Makefile
################################################################################

# # Copied from build-tools repo-init.mk reference implementation.
# # https://github.com/ajay/build-tools/blob/main/makefiles/repo-init.mk
# # Keep in sync with the reference when updating.

# REPO_ROOT := $(shell git rev-parse --show-toplevel)

# # Path to repo-init.mk — used as existence check for whether submodules
# # are initialized. Update this path to match your submodule layout.
# REPO_INIT_CHECK := $(REPO_ROOT)/path/to/repo-init.mk

# repo-init:
# 	@## initialize git submodules
# 	git submodule sync --recursive
# 	git submodule update --init --recursive

# ifneq ($(MAKECMDGOALS),repo-init)
# ifeq (,$(wildcard $(REPO_INIT_CHECK)))
# $(error ERROR: git submodules not initialized; run `make repo-init`)
# endif

################################################################################
