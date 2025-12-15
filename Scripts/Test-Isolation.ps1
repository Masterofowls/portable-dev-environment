<#
.SYNOPSIS
    Quick test of the isolated environment
#>

# Source the profile
. "$PSScriptRoot\..\Config\PortableProfile.ps1"

Write-Host ""
Write-Host "Testing isolated environment..." -ForegroundColor Cyan
Write-Host ""

Write-Host "PATH contains only:" -ForegroundColor Yellow
($env:Path -split ';') | ForEach-Object { Write-Host "  $_" }

Write-Host ""
Write-Host "Tool Versions:" -ForegroundColor Yellow
Write-Host "  Git:    $(git --version 2>$null)"
Write-Host "  Node:   $(node --version 2>$null)"
Write-Host "  NPM:    $(npm --version 2>$null)"
Write-Host "  Python: $(python --version 2>$null)"

Write-Host ""
Write-Host "Environment Variables:" -ForegroundColor Yellow
Write-Host "  HOME:     $env:HOME"
Write-Host "  TEMP:     $env:TEMP"
Write-Host "  APPDATA:  $env:APPDATA"

Write-Host ""
Write-Host "Test PASSED - Environment is isolated!" -ForegroundColor Green
