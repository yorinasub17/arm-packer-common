#!/bin/bash
# This script installs bash-commons. Bash commons includes many reusable helper functions that can streamline bash
# scripts.

set -e

readonly GRUNTWORK_INSTALLER_VERSION='v0.0.38'

function print_usage {
  echo_stderr
  echo_stderr 'Usage: install-bash-commons.sh [OPTIONS]'
  echo_stderr
  echo_stderr 'This script installs bash-commons.'
  echo_stderr
  echo_stderr 'Options:'
  echo_stderr
  echo_stderr "  --version\tThe version of bash-commons to install."
  echo_stderr
  echo_stderr 'Example:'
  echo_stderr
  echo_stderr '  install-bash-commons.sh --version v0.1.9'
}

function run {
  local version=''

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --version)
        version="$2"
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

  # Install gruntwork-installer, which can then be used to install bash-commons
  curl -LsS https://raw.githubusercontent.com/gruntwork-io/gruntwork-installer/"${GRUNTWORK_INSTALLER_VERSION}"/bootstrap-gruntwork-installer.sh \
    | bash /dev/stdin --version "${GRUNTWORK_INSTALLER_VERSION}"
  gruntwork-install \
    --repo https://github.com/gruntwork-io/bash-commons \
    --module-name bash-commons \
    --tag "$version"
}

echo "DEBUG!!!!"

#run "$@"
