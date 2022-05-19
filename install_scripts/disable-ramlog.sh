#!/bin/bash
# This script disables ramlog on armbian. This is useful if you are mounting a secondary drive to store logs, freeing up
# more space in RAM.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

function print_usage {
  echo_stderr
  echo_stderr 'Usage: disable-ramlog.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script disables ramlog. This is useful if you are mounting a secondary drive to store logs, freeing up more space in RAM.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  disable-ramlog.sh'
}

function is_armbian {
  source /etc/os-release
  [[ "$PRETTY_NAME" =~ ^Armbian ]]
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

  if ! is_armbian; then
    log_error "This script only supports Armbian."
    exit 1
  fi

  echo 'ENABLED=false' > /etc/default/armbian-ramlog

  rm /etc/cron.d/armbian-truncate-logs
  rm /etc/cron.daily/armbian-ram-logging
  rm /usr/lib/systemd/system/armbian-ramlog.service
  rm /etc/systemd/system/sysinit.target.wants/armbian-ramlog.service
  rm /usr/lib/systemd/system/armbian-zram-config.service
  rm /etc/systemd/system/sysinit.target.wants/armbian-zram-config.service
}

run "$@"
