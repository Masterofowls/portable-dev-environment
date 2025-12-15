<#
.SYNOPSIS
    Quick verification of the portable environment setup.
.DESCRIPTION
    Checks that all portable applications are properly installed and configured.
#>

$ErrorActionPreference = "Continue"

# Get paths
$ScriptRoot = $PSScriptRoot
if (-not $ScriptRoot) { $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$PortableRoot = (Get-Item $ScriptRoot).Parent.FullName

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  PORTABLE ENVIRONMENT STATUS" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Root: $PortableRoot" -ForegroundColor Gray
Write-Host ""

function Test-App {
    param(
        [string]$Name,
        [string]$Path,
        [string]$VersionCommand
    )
    
    $status = if (Test-Path $Path) { "OK" } else { "MISSING" }
    $color = if ($status -eq "OK") { "Green" } else { "Red" }
    
    $version = ""
    if ($status -eq "OK" -and $VersionCommand) {
        try {
            $version = Invoke-Expression $VersionCommand 2>$null | Select-Object -First 1
        } catch {}
    }
    
    Write-Host ("{0,-20}" -f $Name) -NoNewline
    Write-Host ("{0,-10}" -f "[$status]") -NoNewline -ForegroundColor $color
    if ($version) { Write-Host " $version" -ForegroundColor Gray } else { Write-Host "" }
}

Write-Host "APPLICATIONS:" -ForegroundColor Yellow
Write-Host "-" * 50

Test-App "PowerShell 7" "$PortableRoot\Apps\PowerShell\pwsh.exe" "& '$PortableRoot\Apps\PowerShell\pwsh.exe' --version"
Test-App "Windows Terminal" "$PortableRoot\Apps\WindowsTerminal\WindowsTerminal.exe" ""
Test-App "Git" "$PortableRoot\Apps\Git\cmd\git.exe" "& '$PortableRoot\Apps\Git\cmd\git.exe' --version"
Test-App "Node.js" "$PortableRoot\Apps\NodeJS\node.exe" "& '$PortableRoot\Apps\NodeJS\node.exe' --version"
Test-App "NVM" "$PortableRoot\Apps\NVM\nvm.exe" "& '$PortableRoot\Apps\NVM\nvm.exe' version"
Test-App "Python" "$PortableRoot\Apps\Python\python.exe" "& '$PortableRoot\Apps\Python\python.exe' --version"
Test-App "VS Code" "$PortableRoot\Apps\VSCode\Code.exe" ""
Test-App "Firefox" "$PortableRoot\Apps\Firefox\firefox.exe" ""
Test-App "Chrome" "$PortableRoot\Apps\Chrome\GoogleChromePortable.exe" ""

Write-Host ""
Write-Host "POWERSHELL TOOLS:" -ForegroundColor Yellow
Write-Host "-" * 50

Test-App "Oh My Posh" "$PortableRoot\Apps\OhMyPosh\oh-my-posh.exe" "& '$PortableRoot\Apps\OhMyPosh\oh-my-posh.exe' --version"
Test-App "Starship" "$PortableRoot\Apps\Starship\starship.exe" "& '$PortableRoot\Apps\Starship\starship.exe' --version"
Test-App "FZF" "$PortableRoot\Apps\FZF\fzf.exe" "& '$PortableRoot\Apps\FZF\fzf.exe' --version"
Test-App "Zoxide" "$PortableRoot\Apps\Zoxide\zoxide.exe" "& '$PortableRoot\Apps\Zoxide\zoxide.exe' --version"
Test-App "gsudo" "$PortableRoot\Apps\gsudo\gsudo.exe" ""
Test-App "pyenv-win" "$PortableRoot\Apps\pyenv-win\pyenv-win\bin\pyenv.bat" ""

Write-Host ""
Write-Host "DIRECTORIES:" -ForegroundColor Yellow
Write-Host "-" * 50

$dirs = @(
    @{Name="Projects"; Path="$PortableRoot\Projects"},
    @{Name="Home"; Path="$PortableRoot\Home"},
    @{Name="Temp"; Path="$PortableRoot\Data\temp"},
    @{Name="NPM Cache"; Path="$PortableRoot\Data\npm-cache"},
    @{Name="NPM Global"; Path="$PortableRoot\Data\npm-global"},
    @{Name="VS Code Data"; Path="$PortableRoot\Apps\VSCode\data"}
)

foreach ($dir in $dirs) {
    $exists = Test-Path $dir.Path
    $status = if ($exists) { "OK" } else { "MISSING" }
    $color = if ($exists) { "Green" } else { "Red" }
    Write-Host ("{0,-20}" -f $dir.Name) -NoNewline
    Write-Host "[$status]" -ForegroundColor $color
}

Write-Host ""
Write-Host "ENVIRONMENT VARIABLES:" -ForegroundColor Yellow
Write-Host "-" * 50

$envVars = @(
    @{Name="PORTABLE_ROOT"; Value=$env:PORTABLE_ROOT},
    @{Name="HOME"; Value=$env:HOME},
    @{Name="TEMP"; Value=$env:TEMP},
    @{Name="GIT_CONFIG_GLOBAL"; Value=$env:GIT_CONFIG_GLOBAL}
)

foreach ($var in $envVars) {
    $status = if ($var.Value) { "SET" } else { "NOT SET" }
    $color = if ($var.Value) { "Green" } else { "Yellow" }
    Write-Host ("{0,-20}" -f $var.Name) -NoNewline
    Write-Host "[$status]" -NoNewline -ForegroundColor $color
    if ($var.Value) { Write-Host " $($var.Value)" -ForegroundColor Gray } else { Write-Host "" }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
