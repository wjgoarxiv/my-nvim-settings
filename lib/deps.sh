#!/usr/bin/env bash

set -euo pipefail

# True on an Apple Silicon Mac, even when the current shell runs under Rosetta.
is_apple_silicon_host() {
  [ "$(uname -s)" = "Darwin" ] && [ "$(/usr/sbin/sysctl -n hw.optional.arm64 2>/dev/null || true)" = "1" ]
}

# True when the file is a Mach-O binary without an arm64 slice.
is_x86_only_binary() {
  local info
  info="$(file -L -b "$1" 2>/dev/null || true)"
  case "$info" in
    *arm64*) return 1 ;;
    *x86_64*) return 0 ;;
    *) return 1 ;;
  esac
}

# Re-run the installer natively when an Apple Silicon Mac started it under Rosetta,
# so plugin builds and downloaded tools are arm64 instead of x86_64.
ensure_native_arch() {
  local script_path="$1"
  shift

  is_apple_silicon_host || return 0
  [ "$(uname -m)" != "arm64" ] || return 0

  if [ -n "${NVIM_SETTINGS_NATIVE_REEXEC:-}" ]; then
    die "Still running as $(uname -m) after re-exec; open a native arm64 terminal and retry"
  fi

  log_skipped "Rosetta (x86_64) shell detected on Apple Silicon; re-running as arm64"
  NVIM_SETTINGS_NATIVE_REEXEC=1 exec arch -arm64 /bin/bash "$script_path" "$@"
}

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

  if is_apple_silicon_host && is_x86_only_binary "$(command -v nvim)"; then
    die "nvim ($(command -v nvim)) is x86_64-only; install a native arm64 build and put /opt/homebrew/bin before /usr/local/bin in PATH"
  fi
}

# Plugin builds left over from an x86_64 install (e.g. telescope-fzf-native's libfzf.so)
# cannot be loaded by a native nvim and lazy.nvim never rebuilds an unchanged plugin.
rebuild_foreign_arch_plugin_builds() {
  is_apple_silicon_host || return 0

  local lazy_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy"
  [ -d "$lazy_dir" ] || return 0

  local lib plugin_dir
  while IFS= read -r lib; do
    is_x86_only_binary "$lib" || continue

    plugin_dir="${lib%/build/*}"
    if [ -f "$plugin_dir/Makefile" ] && make -C "$plugin_dir" clean all >/dev/null; then
      log_installed "Rebuilt x86_64 plugin build as arm64: $plugin_dir"
    else
      die "x86_64 build artifact cannot be rebuilt automatically: $lib"
    fi
  done < <(find "$lazy_dir" -mindepth 3 -maxdepth 3 -path '*/build/*' \( -name '*.so' -o -name '*.dylib' \))
}
