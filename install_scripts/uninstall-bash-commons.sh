#!/bin/bash
# This script uninstalls bash-commons. This is useful if you want to keep your final image clean of bash-commons and you
# only need it for the purposes of running the scripts in this repo.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: uninstall-bash-commons.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script uninstalls bash-commons.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  uninstall-bash-commons.sh'
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

  log_info 'Uninstalling gruntwork-install and fetch'
  rm /usr/local/bin/gruntwork-install
  rm /usr/local/bin/fetch
  log_info 'Uninstalling bash-commons (removing /opt/gruntwork folder)'
  rm -r /opt/gruntwork
}

run "$@"
