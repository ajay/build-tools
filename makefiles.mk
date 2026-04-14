################################################################################

# Include all build-tools makefiles.
#
# Include this single file to get all build-tools functionality.
# Individual mk files can also be included separately if needed.

################################################################################

BUILDTOOLS_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))makefiles

-include $(BUILDTOOLS_ROOT)/base.mk
-include $(BUILDTOOLS_ROOT)/deps.mk
-include $(BUILDTOOLS_ROOT)/functions.mk
-include $(BUILDTOOLS_ROOT)/git.mk
-include $(BUILDTOOLS_ROOT)/help.mk
-include $(BUILDTOOLS_ROOT)/lint.mk
-include $(BUILDTOOLS_ROOT)/os.mk
-include $(BUILDTOOLS_ROOT)/project.mk
-include $(BUILDTOOLS_ROOT)/verbose.mk

################################################################################
