<#
.SYNOPSIS
    Installs common VS Code extensions for the portable environment.
.DESCRIPTION
    Installs useful extensions for development using the portable VS Code.
#>

param(
    [switch]$Basic,
    [switch]$All
)

$ScriptRoot = $PSScriptRoot
if (-not $ScriptRoot) { $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$PortableRoot = (Get-Item $ScriptRoot).Parent.FullName

$VSCodePath = "$PortableRoot\Apps\VSCode\bin\code.cmd"
$ExtensionsDir = "$PortableRoot\Apps\VSCode\data\extensions"
$UserDataDir = "$PortableRoot\Apps\VSCode\data\user-data"

if (-not (Test-Path $VSCodePath)) {
    Write-Host "VS Code not found. Please run Setup-Environment.bat first." -ForegroundColor Red
    exit 1
}

$BasicExtensions = @(
    "ms-python.python",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens"
)

$AllExtensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens",
    "ms-vscode.powershell",
    "formulahendry.auto-close-tag",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense",
    "PKief.material-icon-theme",
    "streetsidesoftware.code-spell-checker"
)

$ExtensionsToInstall = if ($All) { $AllExtensions } else { $BasicExtensions }

Write-Host "Installing VS Code extensions..." -ForegroundColor Yellow
Write-Host ""

foreach ($ext in $ExtensionsToInstall) {
    Write-Host "Installing: $ext" -ForegroundColor Cyan
    & $VSCodePath --extensions-dir $ExtensionsDir --user-data-dir $UserDataDir --install-extension $ext --force 2>$null
}

Write-Host ""
Write-Host "Extensions installed successfully!" -ForegroundColor Green
