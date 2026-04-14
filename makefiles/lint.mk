################################################################################

# Lint and format targets.
#
# lint: check formatting + run linters (CI-safe, no modifications)
# format: auto-format files in place
#
# Tools:
#   htmlhint — HTML semantic linting
#   prettier — formatting for HTML, CSS, JS, JSON

################################################################################

-include $(dir $(lastword $(MAKEFILE_LIST)))base.mk

LINT_EXCLUDE ?= .git build .claude node_modules

PRETTIER_FLAGS ?=
ifneq ($(findstring lint,$(MAKECMDGOALS)),)
PRETTIER_FLAGS += --check
endif
ifneq ($(findstring format,$(MAKECMDGOALS)),)
PRETTIER_FLAGS += --write
endif

LINT_FIND = find $(REPO_ROOT) $(foreach d,$(LINT_EXCLUDE),-not -path '*/$d/*')

.PHONY: format lint _format_prettier _lint_html _lint_prettier

format: _format_prettier
	@## auto-format files in place

lint: _lint_html _lint_prettier
	@## check formatting + run linters

_lint_html:
	@## lint HTML (htmlhint)
	@ $(LINT_FIND) -name '*.html' | xargs htmlhint

# prettier: HTML, CSS, JS, JSON (excludes symlinks)
_lint_prettier _format_prettier:
	@## check/format with prettier
	@ $(LINT_FIND) -type f \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.json' \) | xargs prettier $(PRETTIER_FLAGS)

versions::
	@## print lint tool versions
	@ echo "htmlhint:" && htmlhint --version
	@ echo "prettier:" && prettier --version

################################################################################
