# Portable PowerShell Profile - Completely Isolated
# This profile runs BEFORE any commands and sets up the isolated environment

# Get the drive letter dynamically
$ScriptRoot = $PSScriptRoot
if (-not $ScriptRoot) { 
    $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition 
}
# Config folder is inside PortableDev, so go up one level
$PortableRoot = Split-Path -Parent $ScriptRoot
$DriveLetter = Split-Path -Qualifier $PortableRoot

# ============================================
# PROMPT STYLE CONFIGURATION
# Options: 'ohmyposh', 'starship', 'simple'
# ============================================
$env:PROMPT_STYLE = 'starship'

# Define all portable paths
$env:PORTABLE_ROOT = $PortableRoot
$env:PORTABLE_DRIVE = $DriveLetter

# Apps paths
$env:PORTABLE_APPS = "$PortableRoot\Apps"
$env:PORTABLE_POWERSHELL = "$PortableRoot\Apps\PowerShell"
$env:PORTABLE_NODEJS = "$PortableRoot\Apps\NodeJS"
$env:PORTABLE_NVM = "$PortableRoot\Apps\NVM"
$env:PORTABLE_PYTHON = "$PortableRoot\Apps\Python"
$env:PORTABLE_VSCODE = "$PortableRoot\Apps\VSCode"
$env:PORTABLE_CHROME = "$PortableRoot\Apps\Chrome"
$env:PORTABLE_FIREFOX = "$PortableRoot\Apps\Firefox"
$env:PORTABLE_GIT = "$PortableRoot\Apps\Git"

# New tools paths
$env:PORTABLE_OHMYPOSH = "$PortableRoot\Apps\OhMyPosh"
$env:PORTABLE_STARSHIP = "$PortableRoot\Apps\Starship"
$env:PORTABLE_FZF = "$PortableRoot\Apps\FZF"
$env:PORTABLE_ZOXIDE = "$PortableRoot\Apps\Zoxide"
$env:PORTABLE_GSUDO = "$PortableRoot\Apps\gsudo"
$env:PORTABLE_PYENV = "$PortableRoot\Apps\pyenv-win\pyenv-win"
$env:PORTABLE_GH = "$PortableRoot\Apps\GitHubCLI"

# Data paths
$env:PORTABLE_DATA = "$PortableRoot\Data"
$env:PORTABLE_TEMP = "$PortableRoot\Data\temp"
$env:PORTABLE_HOME = "$PortableRoot\Home"
$env:PORTABLE_PROJECTS = "$PortableRoot\Projects"

# Override standard environment variables
$env:HOME = $env:PORTABLE_HOME
$env:USERPROFILE = $env:PORTABLE_HOME
$env:HOMEPATH = $env:PORTABLE_HOME
$env:HOMEDRIVE = $DriveLetter
$env:TEMP = $env:PORTABLE_TEMP
$env:TMP = $env:PORTABLE_TEMP
$env:LOCALAPPDATA = "$PortableRoot\Data\LocalAppData"
$env:APPDATA = "$PortableRoot\Data\AppData"

# NVM Configuration
$env:NVM_HOME = $env:PORTABLE_NVM
$env:NVM_SYMLINK = "$PortableRoot\Apps\NodeJS"

# Node.js / NPM Configuration
$env:NPM_CONFIG_CACHE = "$PortableRoot\Data\npm-cache"
$env:NPM_CONFIG_PREFIX = "$PortableRoot\Data\npm-global"
$env:NODE_PATH = "$PortableRoot\Data\npm-global\node_modules"

# Python Configuration
$env:PYTHONUSERBASE = "$PortableRoot\Data\python-packages"
$env:PIP_CACHE_DIR = "$PortableRoot\Data\pip-cache"
$env:PYTHONDONTWRITEBYTECODE = "1"

# Git Configuration
$env:GIT_CONFIG_GLOBAL = "$PortableRoot\Config\.gitconfig"
$env:GIT_CONFIG_SYSTEM = ""

# VS Code Configuration
$env:VSCODE_PORTABLE = "$PortableRoot\Apps\VSCode\data"

# Starship config path
$env:STARSHIP_CONFIG = "$PortableRoot\Config\starship.toml"
$env:STARSHIP_CACHE = "$PortableRoot\Data\starship-cache"

# Oh My Posh config
$env:POSH_THEMES_PATH = "$env:PORTABLE_OHMYPOSH\themes"

# Zoxide data
$env:_ZO_DATA_DIR = "$PortableRoot\Data\zoxide"

# FZF configuration
$env:FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --info=inline"

# pyenv-win configuration
$env:PYENV = "$env:PORTABLE_PYENV"
$env:PYENV_ROOT = "$env:PORTABLE_PYENV"
$env:PYENV_HOME = "$env:PORTABLE_PYENV"

# Playwright browsers location
$env:PLAYWRIGHT_BROWSERS_PATH = "$PortableRoot\Data\playwright-browsers"

# Chrome Configuration  
$env:CHROME_USER_DATA = "$PortableRoot\Data\chrome-data"

# Build completely isolated PATH - ONLY portable apps
$IsolatedPath = @(
    "$env:PORTABLE_GIT\cmd",
    "$env:PORTABLE_GIT\bin",
    "$env:PORTABLE_GIT\usr\bin",
    "$env:PORTABLE_NVM",
    "$env:PORTABLE_NODEJS",
    "$env:PORTABLE_PYTHON",
    "$env:PORTABLE_PYTHON\Scripts",
    "$env:PORTABLE_VSCODE\bin",
    "$env:PORTABLE_OHMYPOSH",
    "$env:PORTABLE_STARSHIP",
    "$env:PORTABLE_FZF",
    "$env:PORTABLE_ZOXIDE",
    "$env:PORTABLE_GSUDO",
    "$env:PORTABLE_PYENV\bin",
    "$env:PORTABLE_PYENV\shims",
    "$env:PORTABLE_GH\bin",
    "$PortableRoot\Data\npm-global",
    "$PortableRoot\Data\python-packages\Scripts",
    "$PortableRoot\Scripts",
    # Minimal system paths required for basic Windows functionality
    "$env:SystemRoot\System32",
    "$env:SystemRoot"
) -join ";"

$env:Path = $IsolatedPath

# Set PowerShell module path to portable only
$env:PSModulePath = "$PortableRoot\Data\PSModules"

# Set location to projects folder
if (Test-Path $env:PORTABLE_PROJECTS) {
    Set-Location $env:PORTABLE_PROJECTS
}

# Create directories if they don't exist
$DirsToCreate = @(
    $env:PORTABLE_TEMP,
    $env:LOCALAPPDATA,
    $env:APPDATA,
    $env:NPM_CONFIG_CACHE,
    $env:NPM_CONFIG_PREFIX,
    $env:PYTHONUSERBASE,
    $env:PIP_CACHE_DIR,
    "$PortableRoot\Data\PSModules",
    $env:PORTABLE_HOME,
    $env:PORTABLE_PROJECTS,
    $env:VSCODE_PORTABLE,
    $env:CHROME_USER_DATA,
    $env:STARSHIP_CACHE,
    $env:_ZO_DATA_DIR,
    $env:PLAYWRIGHT_BROWSERS_PATH
)

foreach ($dir in $DirsToCreate) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# ============================================
# LOAD PSREADLINE (Enhanced readline)
# ============================================
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    
    # PSReadLine configuration
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# ============================================
# LOAD TERMINAL-ICONS (File icons in ls)
# ============================================
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

# ============================================
# INITIALIZE FZF + PSFzf
# ============================================
if ((Test-Path "$env:PORTABLE_FZF\fzf.exe") -and (Get-Module -ListAvailable -Name PSFzf)) {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    
    # Configure PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

# ============================================
# INITIALIZE ZOXIDE (Smarter cd)
# ============================================
if (Test-Path "$env:PORTABLE_ZOXIDE\zoxide.exe") {
    Invoke-Expression (& "$env:PORTABLE_ZOXIDE\zoxide.exe" init powershell | Out-String)
}

# ============================================
# SETUP PROMPT (Oh My Posh / Starship / Simple)
# ============================================
$PromptInitialized = $false

if ($env:PROMPT_STYLE -eq 'ohmyposh' -and (Test-Path "$env:PORTABLE_OHMYPOSH\oh-my-posh.exe")) {
    # Oh My Posh with a nice theme
    $OmpTheme = "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json"
    if (-not (Test-Path $OmpTheme)) {
        $OmpTheme = "$env:POSH_THEMES_PATH\agnoster.omp.json"
    }
    if (Test-Path $OmpTheme) {
        & "$env:PORTABLE_OHMYPOSH\oh-my-posh.exe" init pwsh --config $OmpTheme | Invoke-Expression
        $PromptInitialized = $true
    }
}
elseif ($env:PROMPT_STYLE -eq 'starship' -and (Test-Path "$env:PORTABLE_STARSHIP\starship.exe")) {
    # Starship prompt
    Invoke-Expression (& "$env:PORTABLE_STARSHIP\starship.exe" init powershell | Out-String)
    $PromptInitialized = $true
}

# Simple fallback prompt if nothing else loaded
if (-not $PromptInitialized) {
    function global:prompt {
        $location = Get-Location
        $relativePath = $location.Path -replace [regex]::Escape($env:PORTABLE_ROOT), "~"
        Write-Host "[PORTABLE] " -NoNewline -ForegroundColor Green
        Write-Host "$relativePath" -NoNewline -ForegroundColor Cyan
        Write-Host " >" -NoNewline -ForegroundColor White
        return " "
    }
}

# Aliases for portable apps
# 'code' opens system VS Code, 'pcode' opens portable VS Code
function code { 
    $systemCode = "$env:LOCALAPPDATA\..\Local\Programs\Microsoft VS Code\Code.exe"
    if (-not (Test-Path $systemCode)) {
        $systemCode = "C:\Program Files\Microsoft VS Code\Code.exe"
    }
    if (-not (Test-Path $systemCode)) {
        $systemCode = "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
    }
    if (Test-Path $systemCode) {
        & $systemCode $args
    } else {
        Write-Host "System VS Code not found. Use 'pcode' for portable VS Code." -ForegroundColor Yellow
    }
}
function pcode { & "$env:PORTABLE_VSCODE\Code.exe" --user-data-dir "$env:VSCODE_PORTABLE\user-data" --extensions-dir "$env:VSCODE_PORTABLE\extensions" $args }
function chrome { & "$env:PORTABLE_CHROME\GoogleChromePortable.exe" --user-data-dir="$env:CHROME_USER_DATA" $args }
function firefox { & "$env:PORTABLE_FIREFOX\firefox.exe" -profile "$env:PORTABLE_ROOT\Data\firefox-profile" $args }

# Shadowsocks proxy functions
$env:PORTABLE_SS = "$env:PORTABLE_ROOT\Apps\Shadowsocks"
function ss-start { 
    Write-Host "Starting Shadowsocks proxy on 127.0.0.1:1080..." -ForegroundColor Cyan
    Start-Process -FilePath "$env:PORTABLE_SS\sslocal.exe" -ArgumentList "-c", "$env:PORTABLE_SS\config.json" -WindowStyle Minimized
    Write-Host "Proxy started! Configure apps to use SOCKS5 127.0.0.1:1080" -ForegroundColor Green
}
function ss-stop { 
    Get-Process -Name "sslocal" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Shadowsocks proxy stopped." -ForegroundColor Yellow
}
function ss-status {
    $proc = Get-Process -Name "sslocal" -ErrorAction SilentlyContinue
    if ($proc) {
        Write-Host "Shadowsocks is RUNNING (PID: $($proc.Id))" -ForegroundColor Green
        Write-Host "SOCKS5 Proxy: 127.0.0.1:1080" -ForegroundColor Cyan
    } else {
        Write-Host "Shadowsocks is NOT running" -ForegroundColor Red
    }
}
function firefox-proxy { & "$env:PORTABLE_FIREFOX\firefox.exe" -profile "$env:PORTABLE_ROOT\Data\firefox-profile-proxy" -no-remote $args }

# gsudo alias (sudo for Windows)
if (Test-Path "$env:PORTABLE_GSUDO\gsudo.exe") {
    Set-Alias -Name sudo -Value "$env:PORTABLE_GSUDO\gsudo.exe" -Scope Global
}

# pyenv alias
if (Test-Path "$env:PORTABLE_PYENV\bin\pyenv.bat") {
    function pyenv { & "$env:PORTABLE_PYENV\bin\pyenv.bat" $args }
}

# Useful aliases
Set-Alias -Name ll -Value Get-ChildItem -Scope Global
Set-Alias -Name la -Value Get-ChildItem -Scope Global
Set-Alias -Name which -Value Get-Command -Scope Global
Set-Alias -Name touch -Value New-Item -Scope Global

# Quick navigation aliases
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function proj { Set-Location $env:PORTABLE_PROJECTS }
function home { Set-Location $env:PORTABLE_HOME }

# FZF-powered functions
if (Test-Path "$env:PORTABLE_FZF\fzf.exe") {
    # Fuzzy find and cd to directory
    function fcd {
        $dir = Get-ChildItem -Directory -Recurse -Depth 3 | ForEach-Object { $_.FullName } | & "$env:PORTABLE_FZF\fzf.exe"
        if ($dir) { Set-Location $dir }
    }
    
    # Fuzzy find and open file in VS Code
    function fcode {
        $file = Get-ChildItem -File -Recurse -Depth 5 | ForEach-Object { $_.FullName } | & "$env:PORTABLE_FZF\fzf.exe"
        if ($file) { code $file }
    }
    
    # Fuzzy search git history
    function flog {
        git log --oneline | & "$env:PORTABLE_FZF\fzf.exe" --preview "git show {1}"
    }
}

# Display welcome message
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " PORTABLE DEVELOPMENT ENVIRONMENT" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Root:     $env:PORTABLE_ROOT" -ForegroundColor Cyan
Write-Host "Projects: $env:PORTABLE_PROJECTS" -ForegroundColor Cyan
Write-Host "Prompt:   $env:PROMPT_STYLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Yellow
Write-Host "  code     - Open system VS Code" -ForegroundColor Gray
Write-Host "  pcode    - Open portable VS Code" -ForegroundColor Gray
Write-Host "  proj     - Go to Projects folder" -ForegroundColor Gray
Write-Host "  fcd      - Fuzzy find directory" -ForegroundColor Gray
Write-Host "  fcode    - Fuzzy find and open in VS Code" -ForegroundColor Gray
Write-Host "  z <dir>  - Smart cd (zoxide)" -ForegroundColor Gray
Write-Host "  sudo     - Run as admin (gsudo)" -ForegroundColor Gray
Write-Host "  pyenv    - Python version manager" -ForegroundColor Gray
Write-Host "  Ctrl+R   - Fuzzy history search" -ForegroundColor Gray
Write-Host "  Ctrl+F   - Fuzzy file search" -ForegroundColor Gray
Write-Host ""
Write-Host "Proxy Commands:" -ForegroundColor Yellow
Write-Host "  ss-start      - Start Shadowsocks proxy" -ForegroundColor Gray
Write-Host "  ss-stop       - Stop Shadowsocks proxy" -ForegroundColor Gray
Write-Host "  ss-status     - Check proxy status" -ForegroundColor Gray
Write-Host "  firefox-proxy - Firefox with proxy enabled" -ForegroundColor Gray
Write-Host ""
Write-Host "This environment is ISOLATED from the system." -ForegroundColor Yellow
Write-Host ""
