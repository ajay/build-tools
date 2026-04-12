################################################################################

# Repo helpers for projects using git submodules.
#
# repo-check: runs all repo health checks.
# repo-check-for-stale-submodules: verifies all submodules are pinned to the latest
# commit on their remote default branch. Checks recursively through nested
# submodules. Set REPO_CHECK_FOR_STALE_SUBMODULES_EXCLUDE to a space-separated list of
# submodule names to skip (e.g. third-party deps pinned intentionally).
#
# The repo-init copy-paste block below must live in each repo's root Makefile
# because it needs to run before submodules are available. This file's existence
# is used to check whether submodules have been initialized.

################################################################################

# Space-separated list of submodule names to exclude from staleness checks.
# Override in your repo's Makefile before including this file.
# Example: REPO_CHECK_FOR_STALE_SUBMODULES_EXCLUDE := bats-assert bats-support
REPO_CHECK_FOR_STALE_SUBMODULES_EXCLUDE ?=

.PHONY: repo-check repo-check-for-stale-submodules

repo-check: repo-check-for-stale-submodules
	@## run all repo health checks

repo-check-for-stale-submodules:
	@## check all submodules are up to date with their remotes
	$(Q) FAIL=0; \
	EXCLUDES=" $(REPO_CHECK_FOR_STALE_SUBMODULES_EXCLUDE) "; \
	check_submodules() { \
		local root="$$1"; \
		local prefix="$$2"; \
		local paths=$$(git -C "$$root" config --file .gitmodules --get-regexp 'submodule\..*\.path' 2>/dev/null | awk '{print $$2}'); \
		for path in $$paths; do \
			local full="$$root/$$path"; \
			local display="$${prefix}$${path}"; \
			local name=$$(basename "$$path"); \
			if echo "$$EXCLUDES" | grep -q " $${name} "; then \
				echo "SKIP: $$display (excluded)"; \
				continue; \
			fi; \
			local url=$$(git -C "$$root" config --file .gitmodules "submodule.$$path.url"); \
			local pinned=$$(git -C "$$full" rev-parse HEAD 2>/dev/null); \
			local latest=$$(git ls-remote "$$url" refs/heads/main 2>/dev/null | cut -f1); \
			if [ -z "$$latest" ]; then \
				latest=$$(git ls-remote "$$url" refs/heads/master 2>/dev/null | cut -f1); \
			fi; \
			if [ -z "$$pinned" ]; then \
				echo "ERROR: $$display — submodule not initialized"; \
				FAIL=1; \
			elif [ -z "$$latest" ]; then \
				echo "WARNING: $$display — could not query remote"; \
			elif [ "$$pinned" != "$$latest" ]; then \
				echo "ERROR: $$display is stale (pinned: $${pinned:0:7}, latest: $${latest:0:7})"; \
				FAIL=1; \
			else \
				echo "OK: $$display ($${pinned:0:7})"; \
			fi; \
			if [ -f "$$full/.gitmodules" ]; then \
				check_submodules "$$full" "$${display}/"; \
			fi; \
		done; \
	}; \
	check_submodules "$(REPO_ROOT)" ""; \
	if [ "$$FAIL" -ne 0 ]; then \
		echo ""; \
		echo "Update with: git submodule update --remote --recursive && git add -u && git commit && git push"; \
		exit 1; \
	fi

################################################################################
## Copy-paste block — uncomment all lines after pasting into your Makefile
################################################################################

# # Copied from build-tools repo.mk reference implementation.
# # https://github.com/ajay/build-tools/blob/main/makefiles/repo.mk
# # Keep in sync with the reference when updating.

# REPO_ROOT := $(shell git rev-parse --show-toplevel)

# # Path to repo.mk — used as existence check for whether submodules
# # are initialized. Update this path to match your submodule layout.
# REPO_INIT_CHECK := $(REPO_ROOT)/path/to/repo.mk

# repo-init:
# 	@## initialize git submodules
# 	git submodule sync --recursive
# 	git submodule update --init --recursive

# ifneq ($(MAKECMDGOALS),repo-init)
# ifeq (,$(wildcard $(REPO_INIT_CHECK)))
# $(error ERROR: git submodules not initialized; run `make repo-init`)
# endif
# endif

################################################################################
