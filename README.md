<p align="center"><img src="https://raw.githubusercontent.com/wjgoarxiv/my-nvim-settings/main/docs/assets/cover.png" width="100%" /></p>

<h1 align="center">my-nvim-settings</h1>
<p align="center">
  <em>Set up a full Neovim config with one prompt for your LLM agent.</em>
</p>
<p align="center">
  <a href="#quick-start">Quick Start</a> · <a href="#features">Features</a> · <a href="#manual-install">Manual Install</a> · <a href="#image-preview">Image Preview</a> · <a href="#troubleshooting">Troubleshooting</a>
</p>
<p align="center">
  <img src="https://img.shields.io/github/stars/wjgoarxiv/my-nvim-settings?style=social" />
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue" />
  <img src="https://img.shields.io/badge/neovim-0.11+-green" />
  <img src="https://img.shields.io/badge/plugin%20manager-lazy.nvim-blueviolet" />
</p>

---

> [!NOTE]
> A cross-platform Neovim config with a one-prompt onboarding flow for LLM agents. Clone, inject the prompt, install, and verify -- safe to rerun, deterministic health checks, backup-on-replace logic built in.

## Features

- **One-Prompt Onboarding** -- Copy-paste a single block into your LLM agent to install end-to-end
- **Cross-Platform** -- macOS, Linux, and Windows installers with platform-specific handling
- **Lazy.nvim Plugin Setup** -- Deterministic, locked plugin versions via `lazy-lock.json`
- **Inline Image Preview** -- View images directly in Neovim via [snacks.nvim](https://github.com/folke/snacks.nvim) (Kitty Graphics Protocol)
- **Safe Rerun** -- Existing configs are backed up before relinking; idempotent installers
- **Post-Install Validation** -- Headless health check catches issues before you open Neovim

## Quick Start

> [!TIP]
> Works with any LLM CLI agent (Claude Code, Codex, Gemini CLI). Just paste the block below into your chat.

```text
Clone (or update) this repository and install it end-to-end.
IMPORTANT: Never delete or overwrite existing files without backing them up first.

1) Clone or update:
   - macOS/Linux:
     If ~/my-nvim-settings does not exist:
       git clone https://github.com/wjgoarxiv/my-nvim-settings.git ~/my-nvim-settings
     If ~/my-nvim-settings already exists:
       cd ~/my-nvim-settings && git pull
   - Windows PowerShell:
     If "$env:USERPROFILE\my-nvim-settings" does not exist:
       git clone https://github.com/wjgoarxiv/my-nvim-settings.git "$env:USERPROFILE\my-nvim-settings"
     If "$env:USERPROFILE\my-nvim-settings" already exists:
       Set-Location "$env:USERPROFILE\my-nvim-settings"; git pull

2) Install ImageMagick (skip if already installed):
   - macOS: brew install imagemagick
   - Ubuntu/Debian: sudo apt install imagemagick
   - Windows: choco install imagemagick

3) Run installer by OS:
   - macOS/Linux:
     cd ~/my-nvim-settings
     bash ./install.sh --yes --ci
   - Windows PowerShell:
     Set-Location "$env:USERPROFILE\my-nvim-settings"
     pwsh -File .\install.ps1 -Yes -CI
   Note: the installer backs up any existing nvim config before relinking.
   It is safe to rerun.

4) Verify:
   nvim --headless "+Lazy! sync" "+checkhealth" +qa

5) Return:
   - whether install passed
   - the last 30 log lines
   - any FAILED markers
```

## Manual Install

### macOS / Linux

```bash
git clone https://github.com/wjgoarxiv/my-nvim-settings.git ~/my-nvim-settings
cd ~/my-nvim-settings
bash ./install.sh --yes --ci
```

### Windows (PowerShell)

```powershell
git clone https://github.com/wjgoarxiv/my-nvim-settings.git "$env:USERPROFILE\my-nvim-settings"
Set-Location "$env:USERPROFILE\my-nvim-settings"
pwsh -File .\install.ps1 -Yes -CI
```

> [!WARNING]
> **Windows notes:**
> - **Image preview** requires Windows Terminal v1.22+ (Kitty Graphics Protocol). Verify with `wt --version`.
> - `telescope-fzf-native` needs build tools: `choco install -y cmake mingw`
> - If telescope reports fzf load failure, build manually:
>   ```
>   cd "$env:LOCALAPPDATA\nvim-data\lazy\telescope-fzf-native.nvim"
>   cmake -S . -B build -G "MinGW Makefiles"
>   cmake --build build --config Release
>   ```

## How It Works

```
                  my-nvim-settings pipeline
                  ~~~~~~~~~~~~~~~~~~~~~~~~

 [LLM Agent / User]
       |
       v
 +-------------------+
 | 1. CLONE          |     git clone / git pull
 |   - fetch repo    |     safe idempotent update
 +-------------------+
       |
       v
 +-------------------+
 | 2. INSTALL        |     install.sh / install.ps1
 |   - backup old    |     backup-on-replace logic
 |   - symlink new   |     platform detection
 |   - sync plugins  |     lazy.nvim + lazy-lock.json
 +-------------------+
       |
       v
 +-------------------+
 | 3. VERIFY         |     nvim --headless
 |   - health check  |     checkhealth + Lazy sync
 |   - report status |     PASSED / FAILED markers
 +-------------------+
```

## Image Preview

This config includes [snacks.nvim](https://github.com/folke/snacks.nvim) image module for inline image previews (PNG, JPG, GIF, WebP, PDF, etc.) directly inside Neovim.

| OS | Terminal | Install ImageMagick |
|----|----------|---------------------|
| macOS | Ghostty | `brew install imagemagick` |
| macOS | Kitty | `brew install imagemagick` |
| Windows | Windows Terminal v1.22+ | `choco install imagemagick` |
| Linux | Ghostty / Kitty | `sudo apt install imagemagick` |

The terminal is auto-detected. For tmux users, add to `~/.tmux.conf`:

```tmux
set -gq allow-passthrough on
set -g visual-activity off
set -g focus-events on
```

## Requirements

| Dependency | Required | Purpose |
|-----------|----------|---------|
| `git` | Yes | Clone repository |
| `nvim` 0.11+ | Yes | Runtime |
| `imagemagick` | No (recommended) | Inline image preview |

## Font (Korean + Icons)

Recommended: **D2CodingLigature Nerd Font Mono** (fallback: `D2CodingLigature Nerd Font`)

```powershell
# Windows (Chocolatey)
choco install -y nerd-fonts-D2Coding
```

## Installer Options

| Flag | Unix | Windows | Effect |
|------|------|---------|--------|
| Auto-confirm | `--yes` | `-Yes` | Skip confirmation prompts |
| CI mode | `--ci` | `-CI` | Machine-readable log output |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Missing dependency | Install `git` or `nvim`, then rerun |
| Installer failed | Check the last `FAILED` line in output |
| Wrong path linked | Restore from `nvim-backups` and rerun |
| Plugin issues | `nvim --headless "+Lazy! sync" "+checkhealth" +qa` |
| Image not showing (macOS/Linux) | Install `imagemagick`, use Ghostty or Kitty, run `:checkhealth snacks` |
| Image not showing (Windows) | `choco install imagemagick` + Windows Terminal v1.22+ |
| `nvim-tree obj is nil` | Open Neovim inside a git repo; usually non-fatal |

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Open a Pull Request

For bug reports or feature requests, please [open an issue](https://github.com/wjgoarxiv/my-nvim-settings/issues).

## License

This project is licensed under the [MIT License](./LICENSE).
