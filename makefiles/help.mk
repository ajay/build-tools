################################################################################

# Generates a help menu for a makefile in a "make help" target.
#
# Inspired by:
#   https://gist.github.com/prwhite/8168133
#   https://dwmkerr.com/makefile-help-command
#
# This is done by querying make's internal target database (using "make -qpr")
# and extracting target names paired with their @## docstrings. Supports
# :: targets with per-block descriptions.
#
# my_target:
#     @## This is the help string for "my_target"
#     ...

GNUMAKEFLAGS ?=

HELP_PRINT_GREEN := "\033[1;32m"
HELP_PRINT_RESET := "\033[00m"

HELP_TARGETS_TO_IGNORE := "^\.PHONY$$"

help::
	@## this menu
	@$(MAKE) -qpr 2>/dev/null |                                                                                  \
	awk '/^[a-zA-Z0-9_.-]+::?/ { target = $$1; gsub(/:+$$/, "", target); next }                                  \
		/\t@##/ && target != "" { desc = $$0; sub(/.*@## */, "", desc); print target "\t" desc; target = "" }' | \
	grep -Ev $(HELP_TARGETS_TO_IGNORE) |                                                                         \
	sort -t$$'\t' -k1,1V |                                                                                       \
	uniq |                                                                                                       \
	awk -F'\t' '/^_/{a[++i]=$$0;next}{b[++j]=$$0}END{for(k=1;k<=i;k++)print a[k];for(k=1;k<=j;k++)print b[k]}' | \
	while IFS=$$'\t' read -r target desc; do                                                                     \
		printf $(HELP_PRINT_GREEN);                                                                              \
		printf "  %-30s" "$$target";                                                                             \
		printf $(HELP_PRINT_RESET);                                                                              \
		printf "%s\n" "$$desc";                                                                                  \
	done

################################################################################
