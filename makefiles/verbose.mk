ifndef _VERBOSE_MK_
_VERBOSE_MK_ := 1

################################################################################

# Verbose mode control.
#
# Set verbose=false to suppress command echoing.

################################################################################

verbose ?= true

ifeq ($(verbose), true)
	Q :=
else
	Q := @
endif

################################################################################

endif # _VERBOSE_MK_
