#!/usr/bin/env bats

################################################################################

load '../../third-party/bats-assert/load'
load '../../third-party/bats-support/load'

################################################################################
# base.mk

@test "base.mk: PYTHON and SHELL are set" {
  run make -p 2>/dev/null
  assert_output --regexp "PYTHON.*python3"
  assert_output --regexp "SHELL.*bash"
}

################################################################################
# deps.mk

@test "deps.mk: deps-check succeeds and lists tools alphabetically" {
  run make deps-check
  assert_success
  assert_output --partial "OK:"
  local first_tool=$(echo "$output" | grep "^OK:" | head -1 | sed 's/OK: //')
  local last_tool=$(echo "$output" | grep "^OK:" | tail -1 | sed 's/OK: //')
  [[ "$first_tool" < "$last_tool" ]]
}

@test "deps.mk: deps-versions prints version info" {
  run make deps-versions
  assert_success
  assert_output --partial "python3"
}

################################################################################
# functions.mk

@test "functions.mk: print_tool_version prints name, path, and version" {
  run make print_tool_version_bash
  assert_success
  assert_output --partial "bash=bash"
  assert_output --partial "GNU bash, version"
}

################################################################################
# git.mk

@test "git.mk: GIT_BRANCH is set" {
  run make -p 2>/dev/null
  assert_output --regexp "GIT_BRANCH"
}

################################################################################
# help.mk

@test "help.mk: help menu with correct targets, sorting, and :: descriptions" {
  run make help
  assert_success
  assert_output --regexp "help.*this menu"
  assert_output --regexp "zebra.*last alphabetically"
  assert_output --regexp "apple.*first alphabetically"
  assert_output --regexp "_underscore_target.*should appear before non-underscore targets"
  assert_output --regexp "multi_def.*first definition"
  assert_output --regexp "multi_def.*second definition"
  assert_output --regexp "git-check.*run all git health checks"
  assert_output --regexp "git-submodule-stale-check.*check all submodules"
  assert_output --regexp "lint.*check formatting"
  assert_output --regexp "format.*auto-format"
  # _ targets before alphabetic targets
  local underscore_line=$(echo "$output" | grep -n "_underscore_target" | head -1 | cut -d: -f1)
  local apple_line=$(echo "$output" | grep -n "apple" | head -1 | cut -d: -f1)
  [ "$underscore_line" -lt "$apple_line" ]
}

################################################################################
# os.mk

@test "os.mk: OS is detected" {
  run make -p 2>/dev/null
  assert_output --regexp "OS :?= "
}

################################################################################
# project.mk

@test "project.mk: PROJECT and COMMIT are printed" {
  run make help
  assert_success
  assert_output --regexp "PROJECT = "
  assert_output --regexp "COMMIT  = [0-9a-f]+ \("
}

################################################################################
# verbose.mk

@test "verbose.mk: verbose defaults to true" {
  run make -p 2>/dev/null
  assert_output --regexp "verbose.*true"
}

################################################################################
