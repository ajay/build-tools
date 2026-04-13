################################################################################

# Lint targets for various file types.
#
# Optional overrides: LINT_HTML_EXCLUDE, LINT_JSON_EXCLUDE

################################################################################

-include $(dir $(lastword $(MAKEFILE_LIST)))base.mk

LINT_HTML_EXCLUDE ?= .git build node_modules
LINT_JSON_EXCLUDE ?= .git build .claude node_modules

.PHONY: lint lint-html lint-json

lint: lint-html lint-json
	@## run all linters

lint-html:
	@## lint HTML files
	@ find $(REPO_ROOT) -name '*.html' $(foreach d,$(LINT_HTML_EXCLUDE),-not -path '*/$d/*') | xargs htmlhint

lint-json:
	@## lint JSON files
	@ find $(REPO_ROOT) -name '*.json' $(foreach d,$(LINT_JSON_EXCLUDE),-not -path '*/$d/*') | while read f; do $(PYTHON) -m json.tool "$$f" > /dev/null || exit 1; done

################################################################################
