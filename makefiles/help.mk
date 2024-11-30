################################################################################

# Generates a help menu for a makefile in a "make help" target.
#
# Inspired by:
#   https://gist.github.com/prwhite/8168133
#   https://dwmkerr.com/makefile-help-command
#
# This is done by querying make's internal target database (using "make -qpr")
# to determine which targets exist (ignoring built in rules). Furthermore for
# each target, an associated help string can be added to that target using the
# format:
#
# my_target:
#     @## This is the help string for "my_target"
#     ...
#
# All of the given targets are taken and formatted into a help menu which can
# be displayed invoking the "help" target, i.e. "make help".

GNUMAKEFLAGS ?=

HELP_PRINT_GREEN := "\033[1;32m"
HELP_PRINT_RESET := "\033[00m"

HELP_TARGETS_TO_IGNORE := ".PHONY"  # Extended grep syntax (NOT PCRE due to mac grep)

help::
	@## this menu
	@MAKE_QPR=$$($(MAKE) -qpr);                                   \
	HELP_TARGETS=$$(echo "$${MAKE_QPR}" |                         \
		perl -0nle 'print for /(?<!Not a target:)\n[\.\w-]+:/g' | \
		tr -d '\0:' |                                             \
		sort -V |                                                 \
		grep -Ev $(HELP_TARGETS_TO_IGNORE)) &&                    \
                                                                  \
	for target in $${HELP_TARGETS};                               \
	do                                                            \
		TARGET_DOCSTRING=$$(echo "$${MAKE_QPR}" |                 \
			perl -0777nle 'print for /'$${target}'\:.*?\n\n/gs' | \
			perl -0nle 'print for /(?<=@##).*\n/g' |              \
			tr -d '\0' |                                          \
			head -1) &&		                                      \
		printf $(HELP_PRINT_GREEN) &&                             \
		printf "  %-30s" $${target} &&                            \
		printf $(HELP_PRINT_RESET) &&                             \
		printf "%s\n" "$${TARGET_DOCSTRING}";                     \
	done

################################################################################
