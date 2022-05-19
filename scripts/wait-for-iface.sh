#!/bin/bash
# Waits until the given interface is connected and up.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

readonly MAX_RETRIES=30
readonly SLEEP_BETWEEN_RETRIES_SEC=10
readonly SCRIPT_NAME="$(basename "$0")"

function wait_for_iface {
  local -r iface="$1"

  log_info "Waiting for $iface interface to be up..."
  for (( i=1; i<="$MAX_RETRIES"; i++ )); do
    if ip route | grep -oP "default via .+ dev $iface"; then
      log_info "$iface interface is up"
      log_info "Sleeping additional $SLEEP_BETWEEN_RETRIES_SEC seconds for dhcp."
      sleep "$SLEEP_BETWEEN_RETRIES_SEC"
      return
    else
      log_warn "$iface is not up yet."
      log_warn "Will sleep for $SLEEP_BETWEEN_RETRIES_SEC seconds."
      sleep "$SLEEP_BETWEEN_RETRIES_SEC"
    fi
  done

  log_error "Timed out waiting for eth0"
  exit 1
}

wait_for_iface "$@"
