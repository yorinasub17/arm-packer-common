#!/bin/bash
# This script updates all apt packages to latest and cleans the cache.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: update-apt-packages.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script updates all apt packages to latest and cleans the cache.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  update-apt-packages.sh'
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

  DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get -yy upgrade
  apt-get -yy autoremove
  apt-get -yy clean
  apt-get -yy autoclean
}

run "$@"
