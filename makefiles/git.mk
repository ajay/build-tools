################################################################################
## Copy-paste block — uncomment all lines after pasting into your Makefile
################################################################################

# # Copied from build-tools git.mk reference implementation.
# # https://github.com/ajay/build-tools/blob/main/makefiles/git.mk
# # Keep in sync with the reference when updating.

# REPO_ROOT := $(shell git rev-parse --show-toplevel)

# git-submodule-update:
# 	@## initialize and update git submodules
# 	git submodule sync --recursive
# 	git submodule update --init --recursive

# ifneq ($(MAKECMDGOALS),git-submodule-update)
# ifneq (,$(shell git submodule status --recursive 2>/dev/null | grep '^[-+]'))
# $(error ERROR: git submodules not initialized or out of date; run `make git-submodule-update`)
# endif
# endif

################################################################################

ifndef _GIT_MK_
_GIT_MK_ := 1

DEPS += awk basename cut fold git paste sed sort tr

################################################################################

MAKEFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILES_DIR)base.mk

################################################################################

GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null)
GIT_DIRTY ?= $(shell git status --porcelain 2>/dev/null | awk '{print substr($$0,1,2)}' | tr -d ' ' | fold -w1 | sort -u | paste -sd '' -)

################################################################################

# Space-separated list of submodule names to exclude from staleness checks.
# Override in your repo's Makefile before including this file.
# Example: GIT_SUBMODULE_STALE_CHECK_EXCLUDE := bats-assert bats-support
GIT_SUBMODULE_STALE_CHECK_EXCLUDE ?=

.PHONY: git-check git-submodule-stale-check

git-check: git-submodule-stale-check
	@## run all git health checks

git-submodule-stale-check:
	@## check all submodules are up to date with their remotes
	@ echo "$@:";                                                                                               \
	FAIL=0;                                                                                                     \
	EXCLUDES=" $(GIT_SUBMODULE_STALE_CHECK_EXCLUDE) ";                                                          \
	check_submodules() {                                                                                        \
		local root="$$1";                                                                                       \
		local prefix="$$2";                                                                                     \
		local paths=$$(git -C "$$root" config --file .gitmodules --get-regexp 'submodule\..*\.path' 2>/dev/null \
			| awk '{print $$2}');                                                                               \
		for path in $$paths; do                                                                                 \
			local full="$$root/$$path";                                                                         \
			local display="$${prefix}$${path}";                                                                 \
			local name=$$(basename "$$path");                                                                   \
			if echo "$$EXCLUDES" | grep -q " $${name} "; then                                                   \
				echo "SKIP: $$display (excluded)";                                                              \
				continue;                                                                                       \
			fi;                                                                                                 \
			local url=$$(git -C "$$root" config --file .gitmodules "submodule.$$path.url");                     \
			url=$$(echo "$$url" | sed 's|git@github.com:|https://github.com/|');                                \
			local pinned=$$(git -C "$$full" rev-parse HEAD 2>/dev/null);                                        \
			local latest=$$(git ls-remote "$$url" refs/heads/main 2>/dev/null | cut -f1);                       \
			if [ -z "$$latest" ]; then                                                                          \
				latest=$$(git ls-remote "$$url" refs/heads/master 2>/dev/null | cut -f1);                       \
			fi;                                                                                                 \
			if [ -z "$$pinned" ]; then                                                                          \
				echo "ERROR: $$display — submodule not initialized";                                            \
				FAIL=1;                                                                                         \
			elif [ -z "$$latest" ]; then                                                                        \
				echo "WARNING: $$display — could not query remote";                                             \
			elif [ "$$pinned" != "$$latest" ]; then                                                             \
				echo "ERROR: $$display is stale (pinned: $${pinned:0:7}, latest: $${latest:0:7})";              \
				FAIL=1;                                                                                         \
			else                                                                                                \
				echo "OK: $$display ($${pinned:0:7})";                                                          \
			fi;                                                                                                 \
			if [ -f "$$full/.gitmodules" ]; then                                                                \
				check_submodules "$$full" "$${display}/";                                                       \
			fi;                                                                                                 \
		done;                                                                                                   \
	};                                                                                                          \
	check_submodules "$(REPO_ROOT)" "";                                                                         \
	if [ "$$FAIL" -ne 0 ]; then                                                                                 \
		echo "";                                                                                                \
		echo "ERROR: one or more submodules are out of date; please update";                                    \
		exit 1;                                                                                                 \
	fi

################################################################################

endif # _GIT_MK_
