#!/bin/bash
# This script disables the ability to login to the node, there by removing the standard means to gain a shell on the
# node.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"
source "$BASH_COMMONS_DIR/assert.sh"

# Source the OS information
source /etc/os-release

function print_usage {
  echo_stderr
  echo_stderr "Usage: disable-access.sh [OPTIONS]"
  echo_stderr
  echo_stderr "This script disables the ability to login to the node, there by removing the standard means to gain a shell on the node."
  echo_stderr
  echo_stderr "Options:"
  echo_stderr
  echo_stderr "  --user\tUsers that should be removed from the server. Pass in multiple times to indicate multiple users to remove."
  echo_stderr
  echo_stderr "Example:"
  echo_stderr
  echo_stderr "  disable-access.sh --user pi --user default"
}

function is_armbian {
  [[ "$PRETTY_NAME" =~ ^Armbian ]]
}

function remove_ssh {
  apt purge -y openssh-server
}

function disable_root {
  rm /root/.not_logged_in_yet
  rm -f /etc/systemd/system/getty@.service.d/override.conf
  rm -f /etc/systemd/system/serial-getty@.service.d/override.conf

  # Need to mark procps as installed to avoid losing it
  apt-mark manual procps libprocps7
}

function remove_user {
  local -r user="$1"

  # Lock account
  passwd -d "$user"
  passwd -l "$user"
  # Delete account and home directory
  deluser --remove-home "$user"
}

function run {
  local -a users=()

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --user)
        assert_not_empty "$key" "$2"
        users+=("$2")
        shift
        ;;
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

  for user in "${users[@]}"; do
    remove_user "$user"
  done
  remove_ssh

  if is_armbian; then
    disable_root
  fi
}

run "$@"
