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
  assert_output --partial "help"
  assert_output --partial "this menu"
}

@test "`make help` shows correct descriptions" {
  run make help
  assert_success
  assert_output --partial "last alphabetically"
  assert_output --partial "first alphabetically"
  assert_output --partial "should appear before non-underscore targets"
}

@test "`make help` sorts _ targets before others" {
  run make help
  assert_success
  # _underscore_target should appear before apple in the output
  local underscore_line=$(echo "$output" | grep -n "_underscore_target" | head -1 | cut -d: -f1)
  local apple_line=$(echo "$output" | grep -n "apple" | head -1 | cut -d: -f1)
  [ "$underscore_line" -lt "$apple_line" ]
}

@test "`make help` shows both :: definitions with unique descriptions" {
  run make help
  assert_success
  assert_output --partial "first definition"
  assert_output --partial "second definition"
}

################################################################################
