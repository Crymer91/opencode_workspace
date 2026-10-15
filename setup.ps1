#Requires -Version 5.1
<#
.SYNOPSIS
    Sets up opencode on this machine and wires up this workspace.

.DESCRIPTION
    - Checks for Node.js / npm
    - Installs (or updates) the latest opencode-ai globally
    - Verifies the local opencode.json
    - Ensures the local .opencode skills/agents folders exist

.PARAMETER SkipInstall
    Skip the global npm install step (useful if opencode is already installed).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\setup.ps1
#>
[CmdletBinding()]
param(
    [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    $msg" -ForegroundColor Green }
function Write-Note($msg) { Write-Host "    $msg" -ForegroundColor Yellow }

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. Prerequisites
Write-Step 'Checking prerequisites'
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw 'npm was not found. Install Node.js LTS from https://nodejs.org and re-run this script.'
}
$nodeVersion = node --version
$npmVersion = npm --version
Write-Ok "node $nodeVersion, npm $npmVersion"

# 2. Install / update opencode
if ($SkipInstall) {
    Write-Step 'Skipping install (-SkipInstall)'
} else {
    Write-Step 'Installing latest opencode-ai globally'
    npm install -g opencode-ai@latest
    if ($LASTEXITCODE -ne 0) { throw "npm install failed with exit code $LASTEXITCODE" }
}

if (Get-Command opencode -ErrorAction SilentlyContinue) {
    $version = (opencode --version) 2>$null
    if ($version) { Write-Ok "opencode $version installed" }
} else {
    Write-Note 'opencode is not on PATH yet. Open a new terminal and re-run if needed.'
}

# 3. Verify workspace config
Write-Step 'Verifying workspace config'
$configPath = Join-Path $repoRoot 'opencode.json'
if (Test-Path -LiteralPath $configPath) {
    Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json | Out-Null
    Write-Ok 'opencode.json is valid JSON'
} else {
    Write-Note "opencode.json not found at $configPath"
}

# 4. Ensure local folders
Write-Step 'Ensuring local .opencode folders'
foreach ($dir in @('.opencode\skills', '.opencode\agent')) {
    $full = Join-Path $repoRoot $dir
    if (-not (Test-Path -LiteralPath $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        Write-Ok "created $dir"
    } else {
        Write-Ok "$dir present"
    }
}

Write-Step 'Done'
Write-Host 'Restart opencode from this directory to load the config, skills, and agents.' -ForegroundColor Cyan
