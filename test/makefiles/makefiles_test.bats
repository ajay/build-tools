#!/usr/bin/env bats

# @test "addition using bc" {
#   result="$(echo 2+2 | bc)"
#   [ "$result" -eq 4 ]
# }

# @test "addition using dc" {
#   result="$(echo 2 2+p | dc)"
#   [ "$result" -eq 4 ]
# }

@test "`make help` produces a help menu" {
  run make help
  assert_output --partial "  help                           this menu"
  [ "$status" -eq 0 ]
#   [ "$output" = "  help                           this menu
#   print_tool_version_bash
#   print_tool_version_make
# " ]
}

# @test "invoking foo without arguments prints usage" {
#   run foo
#   [ "$status" -eq 1 ]
#   [ "${lines[0]}" = "usage: foo <filename>" ]
# }
