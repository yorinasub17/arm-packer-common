#!/bin/bash
# This script removes the automatic SD card resize routine for various ARM SoC operating systems. This is useful for
# packer based ARM SoC setup as we are relying on the packer builder to right size the image. We want to keep the
# partition size smaller than the SD card image to prolong the lifetime of the card.

set -e

readonly BASH_COMMONS_DIR="/opt/gruntwork/bash-commons"
if [[ ! -d "$BASH_COMMONS_DIR" ]]; then
  echo "ERROR: this script requires that bash-commons is installed in $BASH_COMMONS_DIR. See https://github.com/gruntwork-io/bash-commons for more info."
  exit 1
fi
source "$BASH_COMMONS_DIR/log.sh"

# Source the OS information
source /etc/os-release

function print_usage {
  echo_stderr
  echo_stderr 'Usage: remove-resize.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script removes the automatic SD card resize routine for various ARM SoC operating systems. This is useful for packer based ARM SoC setup as we are relying on the packer builder to right size the image. We want to keep the partition size smaller than the SD card image to prolong the lifetime of the card.'
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  remove-resize.sh'
}

function is_raspbian {
  source /etc/os_release
  [[ "$ID" == 'raspbian' ]]
}

function is_armbian {
  source /etc/os_release
  [[ "$PRETTY_NAME" =~ ^Armbian ]]
}

function remove_resize_raspbian {
  sed -i -e 's| init=/usr/lib/raspi-config/init_resize.sh||g' /boot/cmdline.txt
  rm /usr/lib/raspi-config/init_resize.sh
  rm /etc/init.d/resize2fs_once
  rm /etc/rc3.d/S01resize2fs_once
}

function remove_resize_armbian {
  touch /root/.no_rootfs_resize
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

  if is_raspbian; then
    remove_resize_raspbian
  elif is_armbian; then
    remove_resize_armbian
  else
    log_error 'Unsupported OS. This script only supports Raspbian or Armbian.'
    exit 1
  fi
}

run "$@"
