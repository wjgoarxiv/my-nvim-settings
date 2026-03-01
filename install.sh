#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

source "$REPO_ROOT/lib/log.sh"
source "$REPO_ROOT/lib/deps.sh"
source "$REPO_ROOT/lib/backup.sh"
source "$REPO_ROOT/lib/config.sh"

ASSUME_YES=false
CI_MODE=false

run_post_install_headless_validation() {
  local command_display='nvim --headless "+Lazy! sync" "+checkhealth" +qa'

  if nvim --headless "+Lazy! sync" "+checkhealth" +qa; then
    log_installed "Post-install headless validation succeeded: $command_display"
  else
    die "Post-install headless validation failed: $command_display"
  fi
}

parse_args() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --yes)
        ASSUME_YES=true
        ;;
      --ci)
        CI_MODE=true
        ;;
      *)
        die "Unknown argument: $arg"
        ;;
    esac
  done
}

main() {
  parse_args "$@"

  if [ "$ASSUME_YES" = true ]; then
    log_installed "Auto-confirm enabled via --yes"
  else
    log_skipped "Auto-confirm not requested"
  fi

  if [ "$CI_MODE" = true ]; then
    log_installed "CI mode enabled via --ci"
  else
    log_skipped "CI mode not enabled"
  fi

  check_dependencies

  local target_path
  target_path="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

  apply_config_link "$REPO_ROOT" "$target_path"
  run_post_install_headless_validation
  log_installed "Unix installer completed"
}

main "$@"
