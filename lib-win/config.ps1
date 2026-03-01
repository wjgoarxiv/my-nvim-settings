Set-StrictMode -Version Latest

function Resolve-NormalizedPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    try {
        $resolved = Resolve-Path -LiteralPath $Path -ErrorAction Stop
        return $resolved.ProviderPath
    } catch {
    return $Path
    }
}

function Get-ConfigState {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRoot,
        [Parameter(Mandatory = $true)][string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        return 'ABSENT'
    }

    $existingLinkTarget = Get-LinkTargetPath -Path $TargetPath
    if ($existingLinkTarget) {
        $resolvedExisting = Resolve-NormalizedPath -Path $existingLinkTarget
        $resolvedSource = Resolve-NormalizedPath -Path $SourceRoot
        if ($resolvedExisting -eq $resolvedSource) {
            return 'ALREADY_LINKED'
        }
    }

    return 'REPLACED_WITH_BACKUP'
}

function Ensure-ParentDir {
    param([Parameter(Mandatory = $true)][string]$TargetPath)

    $parentDir = Split-Path -Parent $TargetPath
    if (Test-Path -LiteralPath $parentDir) {
        Write-Skipped "Parent directory already exists: $parentDir"
    } else {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        Write-Installed "Created parent directory: $parentDir"
    }
}

function Get-LinkTargetPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    try {
        $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            if ($item.Target -is [Array]) {
                return [string]$item.Target[0]
            }
            return [string]$item.Target
        }
    } catch {
        return $null
    }

    return $null
}

function Apply-ConfigLink {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRoot,
        [Parameter(Mandatory = $true)][string]$TargetPath
    )

    Ensure-ParentDir -TargetPath $TargetPath

    $state = Get-ConfigState -SourceRoot $SourceRoot -TargetPath $TargetPath

    switch ($state) {
        'ALREADY_LINKED' {
            Write-Skipped "Config already linked: $TargetPath -> $SourceRoot"
            return
        }
        'REPLACED_WITH_BACKUP' {
            Backup-IfNeeded -TargetPath $TargetPath
        }
        'ABSENT' {
            Write-Skipped "No previous config found at $TargetPath"
        }
        default {
            Fail-And-Exit "Unhandled config state: $state"
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourceRoot -Force | Out-Null
    } catch {
        $null = & cmd /c "mklink /J `"$TargetPath`" `"$SourceRoot`"" 2>$null
        if (-not (Test-Path -LiteralPath $TargetPath)) {
            Fail-And-Exit "Failed to create config link at $TargetPath"
        }
    }

    Write-Installed "Linked config: $TargetPath -> $SourceRoot"
}
