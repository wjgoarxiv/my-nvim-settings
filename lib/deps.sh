#!/usr/bin/env bash

set -euo pipefail

check_dependencies() {
  local required=(git nvim)
  local dep

  for dep in "${required[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
      log_installed "Dependency available: $dep"
    else
      die "Missing required dependency: $dep"
    fi
  done
}
