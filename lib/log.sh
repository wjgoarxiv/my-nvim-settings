#!/usr/bin/env bash

set -euo pipefail

timestamp() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}

status_line() {
  local label="$1"
  local message="$2"
  printf '%s %s %s\n' "$(timestamp)" "$label" "$message"
}

log_installed() {
  status_line "INSTALLED" "$1"
}

log_skipped() {
  status_line "SKIPPED" "$1"
}

log_failed() {
  status_line "FAILED" "$1"
}

die() {
  log_failed "$1"
  exit 1
}
