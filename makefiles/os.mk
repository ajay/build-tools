ifndef _OS_MK_
_OS_MK_ := 1

DEPS += tr uname

################################################################################

ifeq ($(shell uname -s),Darwin)
	OS := mac
else
	OS := $(shell lsb_release -is | tr A-Z a-z)
endif

################################################################################

endif # _OS_MK_
