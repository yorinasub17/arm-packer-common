#!/bin/bash
# This script disables the swapfile. This is useful for prolonging the life of the SD card.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: disable-swap.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script disables the swapfile. This is useful for prolonging the life of the SD card.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  disable-swap.sh'
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

  dphys-swapfile swapoff
  dphys-swapfile uninstall
  update-rc.d dphys-swapfile remove
  DEBIAN_FRONTEND=noninteractive apt purge -y dphys-swapfile
  DEBIAN_FRONTEND=noninteractive apt autoremove -yy
}

run "$@"
