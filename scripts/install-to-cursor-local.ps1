# Install design-doc-workflow to %USERPROFILE%\.cursor\plugins\local\ (all projects).
# Usage: powershell -ExecutionPolicy Bypass -File scripts/install-to-cursor-local.ps1
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Manifest = Get-Content (Join-Path $Root ".cursor-plugin\plugin.json") | ConvertFrom-Json
$Name = $Manifest.name
$Dest = Join-Path $env:USERPROFILE ".cursor\plugins\local\$Name"

Write-Host "Installing to: $Dest"

if (Test-Path $Dest) {
  Remove-Item -Recurse -Force $Dest
}
New-Item -ItemType Directory -Path $Dest -Force | Out-Null

$Items = @(
  ".cursor-plugin",
  "assets",
  "commands",
  "docs",
  "examples",
  "mcp.json",
  "rules",
  "skills",
  "templates",
  "LICENSE",
  "README.md"
)

foreach ($item in $Items) {
  $src = Join-Path $Root $item
  if (-not (Test-Path $src)) {
    throw "Missing: $src"
  }
  Copy-Item -Path $src -Destination $Dest -Recurse -Force
}

# Local path: plugin.json only
$Marketplace = Join-Path $Dest ".cursor-plugin\marketplace.json"
if (Test-Path $Marketplace) {
  Remove-Item -Force $Marketplace
}

Write-Host ""
Write-Host "Installed. Next steps:"
Write-Host "  1. Cursor -> Developer: Reload Window"
Write-Host "  2. Customize -> scope: User -> Skills / Rules を確認"
Write-Host "  3. Plugins -> Configure -> GITHUB_PAT を設定"
