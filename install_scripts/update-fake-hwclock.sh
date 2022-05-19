#!/bin/bash
# This script updates the fake hwclock. This is useful to ensure the clock is updated to the latest time to ensure log
# continuity.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: update-fake-hwclock.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script updates the fake hwclock. This is useful to ensure the clock is updated to the latest time to ensure echo_stderr continuity.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  update-fake-hwclock.sh'
}

function run {
  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --help)
        print_usage
        exit
        ;;
      *)
        log_error "Unrecognized argument: $key"
        print_usage
        exit 1
        ;;
    esac

    shift
  done

  echo "Current time is $(date)"
  echo "Current fake time is $(cat /etc/fake-hwclock.data)"
  echo 'Updating fake time to current time'
  fake-hwclock
  echo "Updated fake time is $(cat /etc/fake-hwclock.data)"
}

run "$@"
