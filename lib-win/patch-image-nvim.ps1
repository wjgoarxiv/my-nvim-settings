param()
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "log.ps1")

$pluginRoot = Join-Path $env:LOCALAPPDATA "nvim-data\lazy\image.nvim"
if (-not (Test-Path $pluginRoot)) {
    Write-Skipped "image.nvim not installed yet — skipping patches"
    return
}

# --- Patch 1: term.lua — Windows terminal size fallback ---
$termLua = Join-Path $pluginRoot "lua\image\utils\term.lua"
if (Test-Path $termLua) {
    $content = Get-Content $termLua -Raw
    if ($content -notmatch 'vim\.fn\.has\("win32"\)') {
        Copy-Item $termLua "$termLua.bak"
        $patch = @'
    -- Windows fallback: use vim built-in dimensions with estimated pixel sizes
    if vim.fn.has("win32") == 1 then
      local cols = vim.o.columns
      local rows = vim.o.lines
      local cell_w = 8
      local cell_h = 16
      cached_size = {
        screen_x = cols * cell_w,
        screen_y = rows * cell_h,
        screen_cols = cols,
        screen_rows = rows,
        cell_width = cell_w,
        cell_height = cell_h,
      }
      return
    end
'@
        $content = $content -replace '(?m)(  if not TIOCGWINSZ then\r?\n)', "`$1$patch`n"
        Set-Content $termLua -Value $content -NoNewline
        Write-Installed "Patched term.lua with Windows terminal size fallback"
    } else {
        Write-Skipped "term.lua already patched"
    }
} else {
    Write-Skipped "term.lua not found"
}

# --- Patch 2: sixel.lua — list-form system call for Windows ---
$sixelLua = Join-Path $pluginRoot "lua\image\backends\sixel.lua"
if (Test-Path $sixelLua) {
    $content = Get-Content $sixelLua -Raw
    if ($content -notmatch 'cmd_args') {
        Copy-Item $sixelLua "$sixelLua.bak"
        # Replace string-form command building with list-form
        $content = $content -replace [regex]::Escape("  local escaped_path = escape_shell_arg(image_path)`n  local cmd = nil`n  if width and height then`n    cmd = string.format(""%s '%s' -resize %dx%d sixel:-"", magick_cmd, escaped_path, width, height)`n  else`n    cmd = string.format(""%s '%s' sixel:-"", magick_cmd, escaped_path)`n  end"), @"
  local cmd_args = nil
  if width and height then
    cmd_args = {magick_cmd, image_path, "-resize", string.format("%dx%d", width, height), "sixel:-"}
  else
    cmd_args = {magick_cmd, image_path, "sixel:-"}
  end
"@
        $content = $content -replace 'local sixel_data = vim\.fn\.system\(cmd\)', 'local sixel_data = vim.fn.system(cmd_args)'
        $content = $content -replace '("Encoding with ImageMagick: " \.\. )cmd', '$1table.concat(cmd_args, " ")'
        Set-Content $sixelLua -Value $content -NoNewline
        Write-Installed "Patched sixel.lua with list-form system call"
    } else {
        Write-Skipped "sixel.lua already patched"
    }
} else {
    Write-Skipped "sixel.lua not found"
}

# --- Patch 3: Enable Sixel graphics in Windows Terminal ---
$wtSettingsDir = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$wtSettings = Join-Path $wtSettingsDir "settings.json"
if (Test-Path $wtSettings) {
    $content = Get-Content $wtSettings -Raw
    if ($content -notmatch 'enableSixelGraphics') {
        Copy-Item $wtSettings "$wtSettings.bak"
        $content = $content -replace '("\$schema":\s*"[^"]*",)', "`$1`n    `"experimental.enableSixelGraphics`": true,"
        Set-Content $wtSettings -Value $content -NoNewline
        Write-Installed "Enabled experimental.enableSixelGraphics in Windows Terminal"
    } else {
        Write-Skipped "Sixel graphics already enabled in Windows Terminal"
    }
} else {
    Write-Skipped "Windows Terminal settings not found"
}
