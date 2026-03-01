#!/usr/bin/env bash

set -euo pipefail

ensure_parent_dir() {
  local target_path="$1"
  local parent_dir

  parent_dir="$(dirname "$target_path")"
  if [ -d "$parent_dir" ]; then
    log_skipped "Parent directory already exists: $parent_dir"
  else
    mkdir -p "$parent_dir"
    log_installed "Created parent directory: $parent_dir"
  fi
}

config_state() {
  local source_root="$1"
  local target_path="$2"

  if [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path")" = "$source_root" ]; then
      echo "ALREADY_LINKED"
      return 0
    fi
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    echo "REPLACED_WITH_BACKUP"
    return 0
  fi

  echo "ABSENT"
}

apply_config_link() {
  local source_root="$1"
  local target_path="$2"
  local state

  ensure_parent_dir "$target_path"

  state="$(config_state "$source_root" "$target_path")"

  case "$state" in
    ALREADY_LINKED)
    log_skipped "Config already linked: $target_path -> $source_root"
    return 0

    ;;
    REPLACED_WITH_BACKUP)
    create_backup_if_needed "$target_path"

    ;;
    ABSENT)
    log_skipped "No previous config found at $target_path"
    ;;
  esac

  ln -s "$source_root" "$target_path"
  log_installed "Linked config: $target_path -> $source_root"
}
