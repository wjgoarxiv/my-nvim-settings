Set-StrictMode -Version Latest

function Get-Timestamp {
    return (Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz")
}

function Write-StatusLine {
    param(
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][string]$Message
    )

    Write-Output ("{0} {1} {2}" -f (Get-Timestamp), $Label, $Message)
}

function Write-Installed {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-StatusLine -Label "INSTALLED" -Message $Message
}

function Write-Skipped {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-StatusLine -Label "SKIPPED" -Message $Message
}

function Write-Failed {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-StatusLine -Label "FAILED" -Message $Message
}

function Fail-And-Exit {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Failed -Message $Message
    exit 1
}
