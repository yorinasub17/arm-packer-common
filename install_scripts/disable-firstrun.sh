#!/bin/bash
# This script disables firstrun services. Typically, most of the services are setup during build time by packer.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: disable-firstrun.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script disables firstrun services.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  disable-firstrun.sh'
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

  rm /usr/lib/systemd/system/armbian-firstrun.service
  rm /etc/systemd/system/multi-user.target.wants/armbian-firstrun.service
  rm /usr/lib/systemd/system/armbian-firstrun-config.service
  rm /etc/systemd/system/multi-user.target.wants/armbian-firstrun-config.service
}

run "$@"
