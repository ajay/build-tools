#!/usr/bin/env bats

################################################################################

load '../helpers/bats-assert/load'
load '../helpers/bats-support/load'

################################################################################
# functions.mk

@test "`make print_tool_version_bash` produces a valid version" {
  run make print_tool_version_bash
  assert_success
  assert_output --partial "bash=bash"
  assert_output --partial "GNU bash, version"
}

@test "`make print_tool_version_make` produces a valid version" {
  run make print_tool_version_make
  assert_success
  assert_output --partial "make=make"
  assert_output --partial "GNU Make"
}

################################################################################
# help.mk

@test "`make help` produces a help menu" {
  run make help
  assert_success
  assert_output --regexp "help.*this menu"
}

@test "`make help` shows correct target + description pairs" {
  run make help
  assert_success
  assert_output --regexp "zebra.*last alphabetically"
  assert_output --regexp "apple.*first alphabetically"
  assert_output --regexp "_underscore_target.*should appear before non-underscore targets"
}

@test "`make help` sorts _ targets before others" {
  run make help
  assert_success
  local underscore_line=$(echo "$output" | grep -n "_underscore_target" | head -1 | cut -d: -f1)
  local apple_line=$(echo "$output" | grep -n "apple" | head -1 | cut -d: -f1)
  [ "$underscore_line" -lt "$apple_line" ]
}

@test "`make help` shows both :: definitions with unique descriptions" {
  run make help
  assert_success
  assert_output --regexp "multi_def.*first definition"
  assert_output --regexp "multi_def.*second definition"
}

################################################################################
