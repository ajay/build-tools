ifndef _OS_MK_
_OS_MK_ := 1

DEPS += uname

################################################################################

ifeq ($(shell uname -s),Darwin)
	OS := mac
else ifeq (,$(wildcard /etc/os-release))
	$(error /etc/os-release not found; cannot detect Linux distribution)
else
	OS := $(shell . /etc/os-release && echo "$$ID")
endif

################################################################################

endif # _OS_MK_
