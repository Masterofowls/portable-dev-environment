<# 
.SYNOPSIS
    Downloads and installs additional PowerShell tools for the isolated environment.
.DESCRIPTION
    This script downloads and configures:
    - Oh My Posh - Prompt theming
    - Starship - Cross-shell prompt
    - Nerd Fonts - Patched fonts with icons
    - FZF - Fuzzy finder
    - Zoxide - Smarter cd command
    - gsudo - Sudo for Windows
    - pyenv-win - Python version manager
    - Playwright - Browser automation
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Get script location and set up paths
$ScriptRoot = $PSScriptRoot
if (-not $ScriptRoot) { $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition }
$PortableRoot = (Get-Item $ScriptRoot).Parent.FullName

$AppsDir = "$PortableRoot\Apps"
$DataDir = "$PortableRoot\Data"
$TempDir = "$PortableRoot\Data\temp"
$DownloadsDir = "$PortableRoot\Data\downloads"
$FontsDir = "$PortableRoot\Data\Fonts"

# Create directories
$DirsToCreate = @($AppsDir, $DataDir, $TempDir, $DownloadsDir, $FontsDir)
foreach ($dir in $DirsToCreate) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Host "==========================================" -ForegroundColor Magenta
Write-Host "  PowerShell Tools Installer" -ForegroundColor Magenta  
Write-Host "==========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Installing to: $PortableRoot" -ForegroundColor Cyan
Write-Host ""

function Download-File {
    param(
        [string]$Url,
        [string]$OutFile
    )
    
    Write-Host "  Downloading: $Url" -ForegroundColor Gray
    
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        $ProgressPreference = 'Continue'
    }
    catch {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutFile)
    }
}

function Extract-Archive {
    param(
        [string]$Path,
        [string]$Destination
    )
    
    Write-Host "  Extracting to: $Destination" -ForegroundColor Gray
    
    if ($Path -match "\.zip$") {
        Expand-Archive -Path $Path -DestinationPath $Destination -Force
    }
}

# ===========================================
# 1. OH MY POSH
# ===========================================
Write-Host "[1/8] Installing Oh My Posh..." -ForegroundColor Yellow
$OhMyPoshDir = "$AppsDir\OhMyPosh"
if (-not (Test-Path "$OhMyPoshDir\oh-my-posh.exe") -or $Force) {
    $OmpVersion = "24.15.1"
    $OmpUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v$OmpVersion/posh-windows-amd64.exe"
    $ThemesUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v$OmpVersion/themes.zip"
    
    if (-not (Test-Path $OhMyPoshDir)) {
        New-Item -ItemType Directory -Path $OhMyPoshDir -Force | Out-Null
    }
    New-Item -ItemType Directory -Path "$OhMyPoshDir\themes" -Force | Out-Null
    
    Download-File -Url $OmpUrl -OutFile "$OhMyPoshDir\oh-my-posh.exe"
    Download-File -Url $ThemesUrl -OutFile "$DownloadsDir\omp-themes.zip"
    Extract-Archive -Path "$DownloadsDir\omp-themes.zip" -Destination "$OhMyPoshDir\themes"
    
    Write-Host "  Oh My Posh installed!" -ForegroundColor Green
}
else {
    Write-Host "  Oh My Posh already installed." -ForegroundColor Gray
}

# ===========================================
# 2. STARSHIP
# ===========================================
Write-Host "[2/8] Installing Starship..." -ForegroundColor Yellow
$StarshipDir = "$AppsDir\Starship"
if (-not (Test-Path "$StarshipDir\starship.exe") -or $Force) {
    $StarshipUrl = "https://github.com/starship/starship/releases/latest/download/starship-x86_64-pc-windows-msvc.zip"
    $StarshipZip = "$DownloadsDir\starship.zip"
    
    Download-File -Url $StarshipUrl -OutFile $StarshipZip
    
    if (-not (Test-Path $StarshipDir)) {
        New-Item -ItemType Directory -Path $StarshipDir -Force | Out-Null
    }
    Extract-Archive -Path $StarshipZip -Destination $StarshipDir
    
    # Create default config
    $StarshipConfig = @"
# Starship Configuration for Portable Environment
format = """
[░▒▓](#a3aed2)\
[  ](bg:#a3aed2 fg:#090c0c)\
[](bg:#769ff0 fg:#a3aed2)\
\$directory\
[](fg:#769ff0 bg:#394260)\
\$git_branch\
\$git_status\
[](fg:#394260 bg:#212736)\
\$nodejs\
\$python\
[](fg:#212736 bg:#1d2230)\
\$time\
[ ](fg:#1d2230)\
\n\$character"""

[directory]
style = "fg:#e3e5e5 bg:#769ff0"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = ""
style = "bg:#394260"
format = '[[ \$symbol \$branch ](fg:#769ff0 bg:#394260)](\$style)'

[git_status]
style = "bg:#394260"
format = '[[(\$all_status\$ahead_behind )](fg:#769ff0 bg:#394260)](\$style)'

[nodejs]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[python]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#1d2230"
format = '[[  \$time ](fg:#a0a9cb bg:#1d2230)](\$style)'

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
"@
    $StarshipConfig | Out-File -FilePath "$PortableRoot\Config\starship.toml" -Encoding UTF8 -Force
    
    Write-Host "  Starship installed!" -ForegroundColor Green
}
else {
    Write-Host "  Starship already installed." -ForegroundColor Gray
}

# ===========================================
# 3. NERD FONTS (CascadiaCode/JetBrainsMono)
# ===========================================
Write-Host "[3/8] Installing Nerd Fonts..." -ForegroundColor Yellow
if (-not (Test-Path "$FontsDir\CaskaydiaCoveNerdFont-Regular.ttf") -or $Force) {
    # CaskaydiaCove (Cascadia Code) Nerd Font
    $CascadiaUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip"
    $JetBrainsUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
    
    Download-File -Url $CascadiaUrl -OutFile "$DownloadsDir\CascadiaCode.zip"
    Extract-Archive -Path "$DownloadsDir\CascadiaCode.zip" -Destination $FontsDir
    
    Download-File -Url $JetBrainsUrl -OutFile "$DownloadsDir\JetBrainsMono.zip"
    Extract-Archive -Path "$DownloadsDir\JetBrainsMono.zip" -Destination $FontsDir
    
    Write-Host "  Nerd Fonts downloaded to: $FontsDir" -ForegroundColor Green
    Write-Host "  Note: To use fonts, install them manually or run Install-Fonts.ps1" -ForegroundColor Cyan
}
else {
    Write-Host "  Nerd Fonts already downloaded." -ForegroundColor Gray
}

# ===========================================
# 4. FZF (Fuzzy Finder)
# ===========================================
Write-Host "[4/8] Installing FZF..." -ForegroundColor Yellow
$FzfDir = "$AppsDir\FZF"
if (-not (Test-Path "$FzfDir\fzf.exe") -or $Force) {
    $FzfVersion = "0.56.3"
    $FzfUrl = "https://github.com/junegunn/fzf/releases/download/v$FzfVersion/fzf-$FzfVersion-windows_amd64.zip"
    $FzfZip = "$DownloadsDir\fzf.zip"
    
    Download-File -Url $FzfUrl -OutFile $FzfZip
    
    if (-not (Test-Path $FzfDir)) {
        New-Item -ItemType Directory -Path $FzfDir -Force | Out-Null
    }
    Extract-Archive -Path $FzfZip -Destination $FzfDir
    
    Write-Host "  FZF installed!" -ForegroundColor Green
}
else {
    Write-Host "  FZF already installed." -ForegroundColor Gray
}

# ===========================================
# 5. ZOXIDE (Smarter cd)
# ===========================================
Write-Host "[5/8] Installing Zoxide..." -ForegroundColor Yellow
$ZoxideDir = "$AppsDir\Zoxide"
if (-not (Test-Path "$ZoxideDir\zoxide.exe") -or $Force) {
    $ZoxideUrl = "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-0.9.6-x86_64-pc-windows-msvc.zip"
    $ZoxideZip = "$DownloadsDir\zoxide.zip"
    
    Download-File -Url $ZoxideUrl -OutFile $ZoxideZip
    
    if (-not (Test-Path $ZoxideDir)) {
        New-Item -ItemType Directory -Path $ZoxideDir -Force | Out-Null
    }
    Extract-Archive -Path $ZoxideZip -Destination $ZoxideDir
    
    Write-Host "  Zoxide installed!" -ForegroundColor Green
}
else {
    Write-Host "  Zoxide already installed." -ForegroundColor Gray
}

# ===========================================
# 6. GSUDO (Sudo for Windows)
# ===========================================
Write-Host "[6/8] Installing gsudo..." -ForegroundColor Yellow
$GsudoDir = "$AppsDir\gsudo"
if (-not (Test-Path "$GsudoDir\gsudo.exe") -or $Force) {
    $GsudoVersion = "2.5.1"
    $GsudoUrl = "https://github.com/gerardog/gsudo/releases/download/v$GsudoVersion/gsudo.portable.zip"
    $GsudoZip = "$DownloadsDir\gsudo.zip"
    
    Download-File -Url $GsudoUrl -OutFile $GsudoZip
    
    if (-not (Test-Path $GsudoDir)) {
        New-Item -ItemType Directory -Path $GsudoDir -Force | Out-Null
    }
    Extract-Archive -Path $GsudoZip -Destination $GsudoDir
    
    # Move from nested folder if exists
    $nestedX64 = "$GsudoDir\x64"
    if (Test-Path $nestedX64) {
        Get-ChildItem "$nestedX64\*" | Move-Item -Destination $GsudoDir -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "  gsudo installed!" -ForegroundColor Green
}
else {
    Write-Host "  gsudo already installed." -ForegroundColor Gray
}

# ===========================================
# 7. PYENV-WIN (Python Version Manager)
# ===========================================
Write-Host "[7/8] Installing pyenv-win..." -ForegroundColor Yellow
$PyenvDir = "$AppsDir\pyenv-win"
if (-not (Test-Path "$PyenvDir\pyenv-win\bin\pyenv.bat") -or $Force) {
    $PyenvUrl = "https://github.com/pyenv-win/pyenv-win/archive/refs/heads/master.zip"
    $PyenvZip = "$DownloadsDir\pyenv-win.zip"
    
    Download-File -Url $PyenvUrl -OutFile $PyenvZip
    
    if (Test-Path $PyenvDir) { Remove-Item $PyenvDir -Recurse -Force }
    New-Item -ItemType Directory -Path $PyenvDir -Force | Out-Null
    Extract-Archive -Path $PyenvZip -Destination $TempDir
    
    # Move from extracted folder
    $PyenvExtracted = "$TempDir\pyenv-win-master\pyenv-win"
    if (Test-Path $PyenvExtracted) {
        Move-Item -Path $PyenvExtracted -Destination $PyenvDir -Force
    }
    
    # Create versions and shims directories
    New-Item -ItemType Directory -Path "$PyenvDir\pyenv-win\versions" -Force | Out-Null
    New-Item -ItemType Directory -Path "$PyenvDir\pyenv-win\shims" -Force | Out-Null
    
    Write-Host "  pyenv-win installed!" -ForegroundColor Green
    Write-Host "  Use 'pyenv install <version>' to install Python versions" -ForegroundColor Cyan
}
else {
    Write-Host "  pyenv-win already installed." -ForegroundColor Gray
}

# ===========================================
# 8. PLAYWRIGHT (via pip in portable Python)
# ===========================================
Write-Host "[8/8] Installing Playwright..." -ForegroundColor Yellow
$PythonExe = "$AppsDir\Python\python.exe"
$PlaywrightInstalled = & $PythonExe -c "import playwright; print('yes')" 2>$null

if ($PlaywrightInstalled -ne "yes" -or $Force) {
    if (Test-Path $PythonExe) {
        Write-Host "  Installing Playwright via pip..." -ForegroundColor Gray
        
        # Set environment for pip
        $env:PIP_CACHE_DIR = "$DataDir\pip-cache"
        $env:PYTHONUSERBASE = "$DataDir\python-packages"
        
        # Install playwright
        & $PythonExe -m pip install playwright --quiet --no-warn-script-location
        
        Write-Host "  Playwright Python package installed!" -ForegroundColor Green
        Write-Host "  Run 'python -m playwright install' to download browsers" -ForegroundColor Cyan
        Write-Host "  Browsers will be stored in: $DataDir\playwright-browsers" -ForegroundColor Cyan
    }
    else {
        Write-Host "  Python not found. Install Python first." -ForegroundColor Red
    }
}
else {
    Write-Host "  Playwright already installed." -ForegroundColor Gray
}

# ===========================================
# PSReadLine and PSFzf Modules
# ===========================================
Write-Host ""
Write-Host "[Bonus] Installing PowerShell modules..." -ForegroundColor Yellow
$PSModulesDir = "$DataDir\PSModules"
New-Item -ItemType Directory -Path $PSModulesDir -Force | Out-Null

# Use portable pwsh to install modules
$PwshExe = "$AppsDir\PowerShell\pwsh.exe"
if (Test-Path $PwshExe) {
    Write-Host "  Installing PSReadLine, PSFzf, Terminal-Icons..." -ForegroundColor Gray
    
    $installScript = @"
`$env:PSModulePath = '$PSModulesDir'
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction SilentlyContinue
Install-Module -Name PSFzf -Scope CurrentUser -Force -ErrorAction SilentlyContinue
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -ErrorAction SilentlyContinue
"@
    & $PwshExe -NoProfile -ExecutionPolicy Bypass -Command $installScript 2>$null
    
    Write-Host "  PowerShell modules installed!" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Magenta
Write-Host "  Tools Installation Complete!" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Installed Tools:" -ForegroundColor Yellow
Write-Host "  - Oh My Posh (prompt theming)" -ForegroundColor White
Write-Host "  - Starship (cross-shell prompt)" -ForegroundColor White
Write-Host "  - Nerd Fonts (CascadiaCode, JetBrainsMono)" -ForegroundColor White
Write-Host "  - FZF (fuzzy finder)" -ForegroundColor White
Write-Host "  - Zoxide (smarter cd)" -ForegroundColor White
Write-Host "  - gsudo (sudo for Windows)" -ForegroundColor White
Write-Host "  - pyenv-win (Python version manager)" -ForegroundColor White
Write-Host "  - Playwright (browser automation)" -ForegroundColor White
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  - Starship config: $PortableRoot\Config\starship.toml" -ForegroundColor Gray
Write-Host "  - Oh My Posh themes: $OhMyPoshDir\themes\" -ForegroundColor Gray
Write-Host "  - Fonts: $FontsDir\ (install manually)" -ForegroundColor Gray
Write-Host ""
Write-Host "To switch prompts, edit PortableProfile.ps1:" -ForegroundColor Cyan
Write-Host "  `$env:PROMPT_STYLE = 'ohmyposh'  # or 'starship' or 'simple'" -ForegroundColor Gray
Write-Host ""
