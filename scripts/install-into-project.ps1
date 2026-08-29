# Install design-doc-workflow into a project's .cursor/ (Cloud Agent + mobile).
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts/install-into-project.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/install-into-project.ps1 C:\path\to\project
param(
  [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$Repo = if ($env:DESIGN_DOC_WORKFLOW_REPO) { $env:DESIGN_DOC_WORKFLOW_REPO } else { "burokku-xp/design-doc-workflow" }
$Ref = if ($env:DESIGN_DOC_WORKFLOW_REF) { $env:DESIGN_DOC_WORKFLOW_REF } else { "main" }

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalRoot = Split-Path -Parent $ScriptDir

if ((Test-Path (Join-Path $LocalRoot ".cursor-plugin\plugin.json")) -and (Test-Path (Join-Path $ScriptDir "bootstrap-project.ps1"))) {
  $Root = $LocalRoot
} else {
  $Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("ddw-" + [guid]::NewGuid().ToString())
  New-Item -ItemType Directory -Path $Tmp -Force | Out-Null
  Write-Host "Fetching design-doc-workflow@${Ref} ..."
  git clone --depth 1 --branch $Ref "https://github.com/${Repo}.git" $Tmp
  $Root = $Tmp
}

& (Join-Path $Root "scripts\bootstrap-project.ps1") -ProjectPath $ProjectPath

Write-Host ""
Write-Host "Cloud Agent: commit .cursor/ and push. Set GITHUB_PAT in cursor.com/dashboard Cloud Agents secrets."
