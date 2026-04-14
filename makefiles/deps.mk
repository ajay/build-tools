ifndef _DEPS_MK_
_DEPS_MK_ := 1

################################################################################

MAKEFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILES_DIR)base.mk
include $(MAKEFILES_DIR)functions.mk
include $(MAKEFILES_DIR)os.mk
include $(MAKEFILES_DIR)verbose.mk

################################################################################

# $(1) = tool name
define dep_check
	$(Q) command -v $(1) >/dev/null 2>&1 && echo "OK: $(1)" || { echo "MISSING: $(1)"; exit 1; }
endef

DEPS ?=
DEPS += python3

.PHONY: deps-check deps-install deps-versions

DEPS_SORTED = $(sort $(DEPS))

deps-check::
	@## check dependencies
	$(Q) for tool in $(DEPS_SORTED); do \
		command -v $$tool >/dev/null 2>&1 && echo "OK: $$tool" || { echo "MISSING: $$tool"; exit 1; }; \
	done

deps-install::
	@## install dependencies
	$(MAKEFILES_DIR)../tools/deps/os/$(OS).sh

deps-versions::
	@## print dependency versions
	$(Q) for tool in $(DEPS_SORTED); do \
		echo "$$tool:" && command -v $$tool && $$tool --version && echo; \
	done

################################################################################

endif # _DEPS_MK_
