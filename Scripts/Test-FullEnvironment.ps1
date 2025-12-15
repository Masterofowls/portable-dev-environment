<#
.SYNOPSIS
    Full test of the portable development environment
#>

# Load the portable profile
. "$PSScriptRoot\..\Config\PortableProfile.ps1"

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  PORTABLE ENVIRONMENT FULL TEST" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

$TestsPassed = 0
$TestsFailed = 0

function Test-Item {
    param([string]$Name, [bool]$Condition, [string]$Details = "")
    if ($Condition) {
        Write-Host "  [PASS] " -NoNewline -ForegroundColor Green
        Write-Host $Name -NoNewline
        if ($Details) { Write-Host " - $Details" -ForegroundColor Gray } else { Write-Host "" }
        $script:TestsPassed++
    } else {
        Write-Host "  [FAIL] " -NoNewline -ForegroundColor Red
        Write-Host $Name
        $script:TestsFailed++
    }
}

# ==========================================
# 1. ENVIRONMENT ISOLATION
# ==========================================
Write-Host "[1] ENVIRONMENT ISOLATION" -ForegroundColor Yellow
Test-Item "PORTABLE_ROOT set" ($env:PORTABLE_ROOT -like "*PortableDev*") $env:PORTABLE_ROOT
Test-Item "HOME points to portable" ($env:HOME -like "*PortableDev*") $env:HOME
Test-Item "TEMP points to portable" ($env:TEMP -like "*PortableDev*") $env:TEMP
Test-Item "APPDATA points to portable" ($env:APPDATA -like "*PortableDev*") $env:APPDATA
Write-Host ""

# ==========================================
# 2. PATH ISOLATION
# ==========================================
Write-Host "[2] PATH ISOLATION" -ForegroundColor Yellow
$pathEntries = $env:Path -split ';'
$portablePaths = $pathEntries | Where-Object { $_ -like "*PortableDev*" }
$systemPaths = $pathEntries | Where-Object { $_ -like "*System32*" -or $_ -like "*Windows*" }
Test-Item "PATH has portable entries" ($portablePaths.Count -gt 5) "$($portablePaths.Count) portable paths"
Test-Item "PATH has minimal system paths" ($systemPaths.Count -le 2) "$($systemPaths.Count) system paths"
Test-Item "No user profile in PATH" (-not ($env:Path -like "*Users*froggy*")) 
Write-Host ""

# ==========================================
# 3. CORE APPLICATIONS
# ==========================================
Write-Host "[3] CORE APPLICATIONS" -ForegroundColor Yellow
Test-Item "PowerShell 7" (Test-Path "$env:PORTABLE_POWERSHELL\pwsh.exe") (& "$env:PORTABLE_POWERSHELL\pwsh.exe" --version 2>$null)
Test-Item "Git" (Test-Path "$env:PORTABLE_GIT\cmd\git.exe") (git --version 2>$null)
Test-Item "Node.js" (Test-Path "$env:PORTABLE_NODEJS\node.exe") (node --version 2>$null)
Test-Item "NPM" (Test-Path "$env:PORTABLE_NODEJS\npm.cmd") (npm --version 2>$null)
Test-Item "Python" (Test-Path "$env:PORTABLE_PYTHON\python.exe") (python --version 2>$null)
Test-Item "VS Code" (Test-Path "$env:PORTABLE_VSCODE\Code.exe")
Test-Item "Firefox" (Test-Path "$env:PORTABLE_FIREFOX\firefox.exe")
Write-Host ""

# ==========================================
# 4. POWERSHELL TOOLS
# ==========================================
Write-Host "[4] POWERSHELL TOOLS" -ForegroundColor Yellow
Test-Item "Oh My Posh" (Test-Path "$env:PORTABLE_OHMYPOSH\oh-my-posh.exe") (& "$env:PORTABLE_OHMYPOSH\oh-my-posh.exe" --version 2>$null)
Test-Item "Starship" (Test-Path "$env:PORTABLE_STARSHIP\starship.exe") (& "$env:PORTABLE_STARSHIP\starship.exe" --version 2>$null)
Test-Item "FZF" (Test-Path "$env:PORTABLE_FZF\fzf.exe") (& "$env:PORTABLE_FZF\fzf.exe" --version 2>$null)
Test-Item "Zoxide" (Test-Path "$env:PORTABLE_ZOXIDE\zoxide.exe") (& "$env:PORTABLE_ZOXIDE\zoxide.exe" --version 2>$null)
Test-Item "gsudo" (Test-Path "$env:PORTABLE_GSUDO\gsudo.exe")
Test-Item "pyenv-win" (Test-Path "$env:PORTABLE_PYENV\bin\pyenv.bat")
Test-Item "GitHub CLI" (Test-Path "$env:PORTABLE_GH\bin\gh.exe") (& "$env:PORTABLE_GH\bin\gh.exe" --version 2>$null | Select-Object -First 1)
Write-Host ""

# ==========================================
# 5. GIT CONFIGURATION
# ==========================================
Write-Host "[5] GIT CONFIGURATION" -ForegroundColor Yellow
$gitUser = git config --global user.name 2>$null
$gitEmail = git config --global user.email 2>$null
Test-Item "Git user configured" ($gitUser -eq "masterofowls") $gitUser
Test-Item "Git email configured" ($gitEmail -eq "mrdaniilsht@gmail.com") $gitEmail
Test-Item "Git config file" (Test-Path "$env:PORTABLE_ROOT\Config\.gitconfig")
Test-Item "Global gitignore" (Test-Path "$env:HOME\.gitignore_global")
Write-Host ""

# ==========================================
# 6. NPM CONFIGURATION
# ==========================================
Write-Host "[6] NPM CONFIGURATION" -ForegroundColor Yellow
Test-Item "NPM cache portable" ($env:NPM_CONFIG_CACHE -like "*PortableDev*") $env:NPM_CONFIG_CACHE
Test-Item "NPM prefix portable" ($env:NPM_CONFIG_PREFIX -like "*PortableDev*") $env:NPM_CONFIG_PREFIX
$copilotInstalled = Test-Path "$env:PORTABLE_ROOT\Data\npm-global\node_modules\@github\copilot"
Test-Item "@github/copilot installed" $copilotInstalled
Write-Host ""

# ==========================================
# 7. PYTHON CONFIGURATION
# ==========================================
Write-Host "[7] PYTHON CONFIGURATION" -ForegroundColor Yellow
Test-Item "Python user base portable" ($env:PYTHONUSERBASE -like "*PortableDev*") $env:PYTHONUSERBASE
Test-Item "Pip cache portable" ($env:PIP_CACHE_DIR -like "*PortableDev*") $env:PIP_CACHE_DIR
$playwrightInstalled = python -c "import playwright; print('yes')" 2>$null
Test-Item "Playwright installed" ($playwrightInstalled -eq "yes")
Write-Host ""

# ==========================================
# 8. CONFIG FILES
# ==========================================
Write-Host "[8] CONFIGURATION FILES" -ForegroundColor Yellow
Test-Item "Starship config" (Test-Path "$env:STARSHIP_CONFIG") $env:STARSHIP_CONFIG
Test-Item "Oh My Posh themes" (Test-Path "$env:POSH_THEMES_PATH")
Test-Item "VS Code settings" (Test-Path "$env:VSCODE_PORTABLE\user-data\User\settings.json")
Write-Host ""

# ==========================================
# 9. DATA DIRECTORIES
# ==========================================
Write-Host "[9] DATA DIRECTORIES" -ForegroundColor Yellow
Test-Item "Projects folder" (Test-Path $env:PORTABLE_PROJECTS) $env:PORTABLE_PROJECTS
Test-Item "Home folder" (Test-Path $env:HOME)
Test-Item "Temp folder" (Test-Path $env:TEMP)
Test-Item "NPM cache" (Test-Path $env:NPM_CONFIG_CACHE)
Test-Item "Pip cache" (Test-Path $env:PIP_CACHE_DIR)
Test-Item "Zoxide data" (Test-Path $env:_ZO_DATA_DIR)
Write-Host ""

# ==========================================
# 10. FUNCTIONAL TESTS
# ==========================================
Write-Host "[10] FUNCTIONAL TESTS" -ForegroundColor Yellow

# Test git works
$gitTest = git --version 2>$null
Test-Item "Git executable works" ($gitTest -like "git version*")

# Test node works
$nodeTest = node -e "console.log('ok')" 2>$null
Test-Item "Node.js runs code" ($nodeTest -eq "ok")

# Test npm works
$npmTest = npm --version 2>$null
Test-Item "NPM runs" ($npmTest -match "^\d+\.\d+")

# Test python works
$pythonTest = python -c "print('ok')" 2>$null
Test-Item "Python runs code" ($pythonTest -eq "ok")

# Test aliases exist
Test-Item "code alias exists" (Get-Command code -ErrorAction SilentlyContinue)
Test-Item "firefox alias exists" (Get-Command firefox -ErrorAction SilentlyContinue)
Test-Item "sudo alias exists" (Get-Alias sudo -ErrorAction SilentlyContinue)

Write-Host ""

# ==========================================
# SUMMARY
# ==========================================
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  TEST SUMMARY" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Passed: " -NoNewline
Write-Host $TestsPassed -ForegroundColor Green
Write-Host "  Failed: " -NoNewline
Write-Host $TestsFailed -ForegroundColor $(if ($TestsFailed -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($TestsFailed -eq 0) {
    Write-Host "  ALL TESTS PASSED! Environment is fully configured." -ForegroundColor Green
} else {
    Write-Host "  Some tests failed. Review the output above." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
