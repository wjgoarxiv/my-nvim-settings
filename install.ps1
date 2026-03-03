param(
    [switch]$Yes,
    [switch]$CI
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = $ScriptDir

. (Join-Path $RepoRoot "lib-win/log.ps1")
. (Join-Path $RepoRoot "lib-win/deps.ps1")
. (Join-Path $RepoRoot "lib-win/backup.ps1")
. (Join-Path $RepoRoot "lib-win/config.ps1")

function Invoke-PostInstallHeadlessValidation {
    $commandDisplay = 'nvim --headless "+Lazy! sync" "+checkhealth" +qa'

    & nvim --headless "+Lazy! sync" "+checkhealth" +qa
    if ($LASTEXITCODE -ne 0) {
        Fail-And-Exit "Post-install headless validation failed: $commandDisplay"
    }

    Write-Installed "Post-install headless validation succeeded: $commandDisplay"
}

if ($Yes) {
    Write-Installed "Auto-confirm enabled via -Yes"
} else {
    Write-Skipped "Auto-confirm not requested"
}

if ($CI) {
    Write-Installed "CI mode enabled via -CI"
} else {
    Write-Skipped "CI mode not enabled"
}

Test-Dependencies

$localAppData = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { Join-Path $HOME ".local/share" }
$targetPath = Join-Path $localAppData "nvim"

Apply-ConfigLink -SourceRoot $RepoRoot -TargetPath $targetPath
Invoke-PostInstallHeadlessValidation
. (Join-Path $RepoRoot "lib-win/patch-image-nvim.ps1")
Write-Installed "Windows installer completed"
