# Optional standalone Yazi helper for bash/zsh.
# Source this file from your shell rc, then run `y` to browse with Yazi and cd
# to Yazi's last directory when it exits.

function y() {
  local tmp cwd exit_status config_home

  tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" || return

  config_home="${YAZI_CONFIG_HOME:-$HOME/.config/nvim/yazi}"
  if [ -n "${YAZI_CD_DEBUG:-}" ]; then
    printf 'yazi-cd: tmp=%s\n' "$tmp" >&2
    printf 'yazi-cd: config_home=%s\n' "$config_home" >&2
  fi

  if [ -d "$config_home" ]; then
    YAZI_CONFIG_HOME="$config_home" yazi "$@" --cwd-file="$tmp"
  else
    yazi "$@" --cwd-file="$tmp"
  fi
  exit_status=$?

  if [ -n "${YAZI_CD_DEBUG:-}" ]; then
    printf 'yazi-cd: yazi_status=%s\n' "$exit_status" >&2
    printf 'yazi-cd: cwd_file=%s\n' "$(command cat -- "$tmp" 2>/dev/null)" >&2
  fi

  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || exit_status=$?
  fi

  command rm -f -- "$tmp"
  return "$exit_status"
}
