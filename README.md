# my-nvim-settings

Set up this Neovim config with one prompt for your LLM agent.
It is designed to be safe to rerun and easy to verify.

## Media

<img src="docs/assets/cover.png" alt="my-nvim-settings cover" width="100%" />

## What this repo gives you

- One-prompt onboarding flow for LLM agents
- Cross-platform installer for macOS, Linux, and Windows
- Lazy.nvim-based plugin setup
- Deterministic post-install health check
- Safe rerun behavior with backup-on-replace logic

## Quick Start (LLM-first)

✅ Copy and paste this block directly into your agent:

```text
Clone this repository and install it end-to-end.

1) Clone:
   - macOS/Linux: git clone https://github.com/wjgoarxiv/my-nvim-settings.git ~/my-nvim-settings
   - Windows PowerShell: git clone https://github.com/wjgoarxiv/my-nvim-settings.git "$env:USERPROFILE\my-nvim-settings"

2) Install ImageMagick (required for image preview):
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

4) Verify:
   nvim --headless "+Lazy! sync" "+checkhealth" +qa

5) Return:
   - whether install passed
   - the last 30 log lines
   - any FAILED markers
```

## Manual fallback

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

Windows notes:

- **Image preview** requires Windows Terminal v1.22+ (Sixel support). Check your version with `wt --version`. ImageMagick must be on PATH — verify with `magick --version`.

- `telescope-fzf-native` needs local build tools. Install and reopen PowerShell:

```powershell
choco install -y cmake mingw
```

- If `telescope` reports fzf extension load failure, build manually:

```powershell
Set-Location "$env:LOCALAPPDATA\nvim-data\lazy\telescope-fzf-native.nvim"
cmake -S . -B build -G "MinGW Makefiles"
cmake --build build --config Release
```

## How to know it worked

The installer should finish without `FAILED` lines and include:

- `Post-install headless validation succeeded: nvim --headless "+Lazy! sync" "+checkhealth" +qa`
- `Unix installer completed` (or Windows completion equivalent)

You can run the validation command manually:

```bash
nvim --headless "+Lazy! sync" "+checkhealth" +qa
```

## Rerun Safety

You can run the installer again.

- If your config already points to this repo, the installer reports `SKIPPED`.
- If your old config is different, it is backed up before relinking.

## Image Preview

This config includes [image.nvim](https://github.com/3rd/image.nvim) for inline image previews (PNG, JPG, GIF, WebP, etc.) directly inside Neovim.

**Requirements:**

- [ImageMagick](https://imagemagick.org/) must be installed
- A terminal that supports a graphics protocol (see table below)

| OS | Terminal | Backend | Install ImageMagick |
|----|----------|---------|---------------------|
| macOS | Ghostty | Kitty protocol (auto-detected) | `brew install imagemagick` |
| macOS | Kitty | Kitty protocol (auto-detected) | `brew install imagemagick` |
| Windows | Windows Terminal v1.22+ | Sixel (auto-detected) | `choco install imagemagick` |
| Linux | Ghostty / Kitty | Kitty protocol (auto-detected) | `sudo apt install imagemagick` |

The backend is auto-detected based on your terminal. No manual configuration needed.

**Unsupported terminals:** macOS Terminal.app, older Windows Terminal (< v1.22).

## Requirements

- `git`
- `nvim` (Neovim 0.11+ recommended)
- `imagemagick` (for image preview)

## Font (Korean + icons)

Recommended GUI font:

- `D2CodingLigature Nerd Font Mono`
- fallback: `D2CodingLigature Nerd Font`

If glyphs/icons look wrong, set one of the fonts above in your terminal or Neovim GUI.

Windows quick install (Chocolatey):

```powershell
choco install -y nerd-fonts-D2Coding
```

## Useful Options

- Unix: `bash ./install.sh --yes --ci`
  - `--yes`: auto-confirm
  - `--ci`: CI-style logs
- Windows: `pwsh -File .\install.ps1 -Yes -CI`
  - `-Yes`: auto-confirm
  - `-CI`: CI-style logs

## Troubleshooting

- Missing dependency: install `git` or `nvim`, then rerun.
- Installer failed: check the last `FAILED` line in output.
- Wrong path linked: restore from `nvim-backups` and rerun.
- Plugin/setup check: run `nvim --headless "+Lazy! sync" "+checkhealth" +qa`.
- `nvim-tree git/utils.lua:15 obj is nil` can appear outside git repos on some Windows setups. It is usually non-fatal; open Neovim inside a git repo for stable git status behavior.
- Image preview not showing: ensure `imagemagick` is installed and on PATH (`magick --version`). On Windows, requires Windows Terminal v1.22+ for Sixel support. On macOS/Linux, use Ghostty or Kitty.

## Extra

- For one-shot LLM onboarding flow, see `PROMPT.md`.
- For exact installer behavior, see `install.sh` and `install.ps1`.
