# Copy plugin rules/skills/commands into a target project's .cursor/ (project-scoped fallback).
# Usage: powershell -ExecutionPolicy Bypass -File scripts/bootstrap-project.ps1 C:\path\to\project
param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectPath
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-not (Test-Path $ProjectPath -PathType Container)) {
  throw "Target directory not found: $ProjectPath"
}

$Cursor = Join-Path $ProjectPath ".cursor"
$Rules = Join-Path $Cursor "rules"
$Skills = Join-Path $Cursor "skills"
$Commands = Join-Path $Cursor "commands"

New-Item -ItemType Directory -Path $Rules, $Skills, $Commands -Force | Out-Null

Copy-Item (Join-Path $Root "rules\*.mdc") $Rules -Force

Get-ChildItem (Join-Path $Root "skills") -Directory | Where-Object { $_.Name -ne "_shared" } | ForEach-Object {
  $dest = Join-Path $Skills $_.Name
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item $_.FullName $dest -Recurse -Force
}

Copy-Item (Join-Path $Root "commands\*.md") $Commands -Force

$version = (Get-Content (Join-Path $Root ".cursor-plugin\plugin.json") | ConvertFrom-Json).version
@"
# Installed from design-doc-workflow plugin bootstrap
version=$version
source=$Root
"@ | Set-Content (Join-Path $Cursor "design-doc-workflow.version")

Write-Host "Bootstrapped .cursor/ in: $ProjectPath"
Write-Host "Open project in Cursor -> Customize -> select this project scope"
