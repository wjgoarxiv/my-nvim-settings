#!/usr/bin/env bash

set -euo pipefail

create_backup_if_needed() {
  local target_path="$1"

  if [ ! -e "$target_path" ] && [ ! -L "$target_path" ]; then
    log_skipped "No existing config to back up at $target_path"
    return 0
  fi

  local backup_dir
  backup_dir="$(dirname "$target_path")/nvim-backups"
  mkdir -p "$backup_dir"

  local backup_path
  backup_path="$backup_dir/nvim.$(date +"%Y%m%d%H%M%S")"

  mv "$target_path" "$backup_path"
  log_installed "Backup created: $backup_path"
}
