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
  assert_output --partial "print_tool_version_bash"
  assert_output --partial "print_tool_version_make"
}

################################################################################
