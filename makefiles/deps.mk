ifndef _DEPS_MK_
_DEPS_MK_ := 1

################################################################################

# Dependency check and install targets.
#
# deps-check: verify required tools are installed (fast, cross-platform)
# deps-install: install dependencies via OS-specific scripts
#
# Both use :: so consuming makefiles can extend with additional checks/installs.

################################################################################

MAKEFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILES_DIR)base.mk
include $(MAKEFILES_DIR)os.mk
include $(MAKEFILES_DIR)verbose.mk

################################################################################

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
	$(MAKEFILES_DIR)../tools/deps/os/$(OS).sh

################################################################################

endif # _DEPS_MK_
