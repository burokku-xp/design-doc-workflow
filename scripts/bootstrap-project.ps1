# Copy plugin rules/skills/commands into a target project's .cursor/ (Cloud Agent + project scope).
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

Get-ChildItem (Join-Path $Root "skills") -Directory | ForEach-Object {
  $dest = Join-Path $Skills $_.Name
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item $_.FullName $dest -Recurse -Force
}

Copy-Item (Join-Path $Root "commands\*.md") $Commands -Force

$manifest = Get-Content (Join-Path $Root ".cursor-plugin\plugin.json") | ConvertFrom-Json
$version = $manifest.version
$repo = if ($manifest.repository) { $manifest.repository } else { "https://github.com/burokku-xp/design-doc-workflow" }

@"
version=$version
source=$repo
installed_by=bootstrap-project.ps1
"@ | Set-Content (Join-Path $Cursor "design-doc-workflow.version")

@"
# design-doc-workflow (project-local)

Committed for Cursor Cloud Agent, mobile, and Web.

- Skills: ``.cursor/skills/`` (7)
- Rules: ``.cursor/rules/`` (3)
- Docs: https://github.com/burokku-xp/design-doc-workflow/blob/main/docs/cloud-agent.md
"@ | Set-Content (Join-Path $Cursor "README.md")

Write-Host "Bootstrapped .cursor/ in: $ProjectPath"
Write-Host "Next: git add .cursor && git commit && git push  (required for Cloud Agent)"
