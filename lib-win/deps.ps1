Set-StrictMode -Version Latest

function Test-Dependencies {
    $required = @("git", "nvim")

    foreach ($dep in $required) {
        if (Get-Command $dep -ErrorAction SilentlyContinue) {
            Write-Installed "Dependency available: $dep"
        } else {
            Fail-And-Exit "Missing required dependency: $dep"
        }
    }
}
