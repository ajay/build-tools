################################################################################

include ../../makefiles/functions.mk
include ../../makefiles/help.mk
include ../../makefiles/project.mk

################################################################################

print_tool_version_bash:
	$(call print_tool_version,bash,bash)

print_tool_version_make:
	$(call print_tool_version,make,make)

################################################################################

# Test targets for help.mk sorting and :: descriptions

zebra:
	@## last alphabetically

apple:
	@## first alphabetically

_underscore_target:
	@## should appear before non-underscore targets

multi_def::
	@## first definition

multi_def::
	@## second definition

################################################################################
