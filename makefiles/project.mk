ifndef _PROJECT_MK_
_PROJECT_MK_ := 1

################################################################################

MAKEFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILES_DIR)base.mk
include $(MAKEFILES_DIR)git.mk

################################################################################

PROJECT_NAME ?= $(notdir $(CURDIR))

$(info )
$(info PROJECT = $(PROJECT_NAME))
$(info COMMIT  = $(GIT_COMMIT) ($(GIT_BRANCH))$(if $(GIT_DIRTY), $(GIT_DIRTY)))
$(info )

################################################################################

endif # _PROJECT_MK_
