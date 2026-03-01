Set-StrictMode -Version Latest

function Backup-IfNeeded {
    param([Parameter(Mandatory = $true)][string]$TargetPath)

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        Write-Skipped "No existing config to back up at $TargetPath"
        return
    }

    $parentDir = Split-Path -Parent $TargetPath
    $backupDir = Join-Path $parentDir "nvim-backups"
    if (-not (Test-Path -LiteralPath $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }

    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupPath = Join-Path $backupDir ("nvim.{0}" -f $timestamp)
    Move-Item -LiteralPath $TargetPath -Destination $backupPath
    Write-Installed "Backup created: $backupPath"
}
