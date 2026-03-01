# One Prompt Setup for my-nvim-settings

Run this exact flow for your platform and post the installer log as proof of completion.

## macOS / Linux

```bash
set -euo pipefail

REPO_URL="https://github.com/wjgoarxiv/my-nvim-settings.git"
WORK_ROOT="${HOME}/.cache/my-nvim-settings-onboarding"
WORK_DIR="${WORK_ROOT}/my-nvim-settings"
LOG_FILE="/tmp/my-nvim-settings-install.log"

mkdir -p "${WORK_ROOT}"

if [ -d "${WORK_DIR}/.git" ]; then
  cd "${WORK_DIR}"
  git fetch --all --prune
  git reset --hard origin/main
else
  rm -rf "${WORK_DIR}"
  # clone path is fixed for deterministic runs
  git clone "${REPO_URL}" "${WORK_DIR}"
  cd "${WORK_DIR}"
fi

git checkout main
bash ./install.sh --yes --ci | tee "${LOG_FILE}"

if grep -q "FAILED" "${LOG_FILE}"; then
  echo "Setup failed. Review: ${LOG_FILE}"
  exit 1
fi

grep -Fq 'Post-install headless validation succeeded: nvim --headless "+Lazy! sync" "+checkhealth" +qa' "${LOG_FILE}" && \
  echo "Post-install validation output confirmed"
```

## Windows (PowerShell)

```powershell
$ErrorActionPreference = "Stop"

$repoUrl = "https://github.com/wjgoarxiv/my-nvim-settings.git"
$workRoot = Join-Path $env:TEMP "my-nvim-settings-onboarding"
$workDir = Join-Path $workRoot "my-nvim-settings"
$logFile = Join-Path $env:TEMP "my-nvim-settings-install.log"

New-Item -ItemType Directory -Path $workRoot -Force | Out-Null

if (Test-Path -LiteralPath (Join-Path $workDir ".git")) {
  Set-Location -Path $workDir
  git fetch --all --prune
  git reset --hard origin/main
} else {
  Remove-Item -LiteralPath $workDir -Recurse -Force -ErrorAction SilentlyContinue
  git clone $repoUrl $workDir
  Set-Location -Path $workDir
}

git checkout main
pwsh -File .\install.ps1 -Yes -CI | Tee-Object -FilePath $logFile

if (Select-String -Path $logFile -Pattern "FAILED") {
  Write-Error "Setup failed. Review: $logFile"
}

if (Select-String -Path $logFile -Pattern 'Post-install headless validation succeeded: nvim --headless "+Lazy! sync" "+checkhealth" +qa') {
  Write-Output "Post-install validation output confirmed"
}
```

## Completion criteria

- Run the selected block and provide `/tmp/my-nvim-settings-install.log` (or PowerShell temp log path) back to the coordinator.
- Log must include:
  - no `FAILED` lines
  - `Post-install headless validation succeeded: nvim --headless "+Lazy! sync" "+checkhealth" +qa`
