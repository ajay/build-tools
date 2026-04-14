################################################################################

# Dependency check and install targets.
#
# deps-check: verify required tools are installed (fast, cross-platform)
# deps-install: install dependencies via OS-specific scripts
#
# Both use :: so consuming makefiles can extend with additional checks/installs.

################################################################################

-include $(dir $(lastword $(MAKEFILE_LIST)))base.mk
-include $(dir $(lastword $(MAKEFILE_LIST)))os.mk
-include $(dir $(lastword $(MAKEFILE_LIST)))verbose.mk

# $(1) = tool name
define dep_check
	$(Q) command -v $(1) >/dev/null 2>&1 && echo "OK: $(1)" || { echo "MISSING: $(1)"; exit 1; }
endef

.PHONY: deps-check deps-install

deps-check::
	@## check deps.mk dependencies
	$(call dep_check,python3)

deps-install::
	@## install dependencies
	$(dir $(lastword $(MAKEFILE_LIST)))../tools/deps/os/$(OS).sh

################################################################################
