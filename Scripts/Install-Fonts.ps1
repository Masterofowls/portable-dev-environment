<#
.SYNOPSIS
    Installs Nerd Fonts for the current user.
.DESCRIPTION
    Copies downloaded Nerd Fonts to the user's font directory.
    Run with -System switch and admin rights to install system-wide.
#>

param(
    [switch]$System
)

$FontsSource = "$PSScriptRoot\..\Data\Fonts"
$UserFontsDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$SystemFontsDir = "$env:SystemRoot\Fonts"

if (-not (Test-Path $FontsSource)) {
    Write-Host "No fonts found in: $FontsSource" -ForegroundColor Red
    Write-Host "Run Install-Tools.ps1 first to download fonts." -ForegroundColor Yellow
    exit 1
}

$fonts = Get-ChildItem "$FontsSource\*.ttf", "$FontsSource\*.otf" -ErrorAction SilentlyContinue

if ($fonts.Count -eq 0) {
    Write-Host "No font files found." -ForegroundColor Red
    exit 1
}

Write-Host "Found $($fonts.Count) font files." -ForegroundColor Cyan

if ($System) {
    # System-wide install (requires admin)
    $targetDir = $SystemFontsDir
    Write-Host "Installing fonts system-wide (requires admin)..." -ForegroundColor Yellow
} else {
    # User install
    $targetDir = $UserFontsDir
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Write-Host "Installing fonts for current user..." -ForegroundColor Yellow
}

$installed = 0
foreach ($font in $fonts) {
    $destPath = Join-Path $targetDir $font.Name
    
    try {
        Copy-Item -Path $font.FullName -Destination $destPath -Force
        
        # Register the font
        if (-not $System) {
            $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            $fontName = [System.IO.Path]::GetFileNameWithoutExtension($font.Name)
            Set-ItemProperty -Path $regPath -Name "$fontName (TrueType)" -Value $destPath -ErrorAction SilentlyContinue
        }
        
        $installed++
    }
    catch {
        Write-Host "  Failed to install: $($font.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Installed $installed fonts!" -ForegroundColor Green
Write-Host ""
Write-Host "Recommended fonts for terminal:" -ForegroundColor Yellow
Write-Host "  - CaskaydiaCove Nerd Font" -ForegroundColor Gray
Write-Host "  - JetBrainsMono Nerd Font" -ForegroundColor Gray
Write-Host ""
Write-Host "To use in Windows Terminal or VS Code, set the font family to:" -ForegroundColor Cyan
Write-Host '  "CaskaydiaCove Nerd Font"' -ForegroundColor White
Write-Host ""
