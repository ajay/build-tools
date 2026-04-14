################################################################################

GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null)
GIT_DIRTY ?= $(shell git status --porcelain 2>/dev/null | awk '{print substr($$0,1,2)}' | tr -d ' ' | fold -w1 | sort -u | paste -sd '' -)

################################################################################
