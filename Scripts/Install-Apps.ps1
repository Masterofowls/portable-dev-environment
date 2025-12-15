<# 
.SYNOPSIS
    Downloads and installs all portable applications for the isolated environment.
.DESCRIPTION
    This script downloads portable versions of:
    - Windows Terminal
    - PowerShell 7
    - Git Portable
    - NVM for Windows
    - Node.js (via NVM)
    - Python Portable
    - VS Code Portable
    - Chrome Portable
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

# Create directories
$DirsToCreate = @($AppsDir, $DataDir, $TempDir, $DownloadsDir)
foreach ($dir in $DirsToCreate) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Host "======================================" -ForegroundColor Green
Write-Host "  Portable Environment Installer" -ForegroundColor Green  
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installing to: $PortableRoot" -ForegroundColor Cyan
Write-Host ""

function Download-File {
    param(
        [string]$Url,
        [string]$OutFile
    )
    
    Write-Host "  Downloading: $Url" -ForegroundColor Gray
    
    # Use BITS for better download handling
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        $ProgressPreference = 'Continue'
    }
    catch {
        # Fallback to WebClient
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
    elseif ($Path -match "\.7z$" -or $Path -match "\.tar") {
        # Use 7-zip if available, otherwise try tar
        if (Get-Command 7z -ErrorAction SilentlyContinue) {
            & 7z x $Path -o"$Destination" -y
        }
        elseif (Get-Command tar -ErrorAction SilentlyContinue) {
            tar -xf $Path -C $Destination
        }
    }
}

# ===========================================
# 1. POWERSHELL 7 PORTABLE
# ===========================================
Write-Host "[1/8] Installing PowerShell 7 Portable..." -ForegroundColor Yellow
$PwshDir = "$AppsDir\PowerShell"
if (-not (Test-Path "$PwshDir\pwsh.exe") -or $Force) {
    $PwshVersion = "7.4.6"
    $PwshUrl = "https://github.com/PowerShell/PowerShell/releases/download/v$PwshVersion/PowerShell-$PwshVersion-win-x64.zip"
    $PwshZip = "$DownloadsDir\PowerShell.zip"
    
    Download-File -Url $PwshUrl -OutFile $PwshZip
    
    if (Test-Path $PwshDir) { Remove-Item $PwshDir -Recurse -Force }
    New-Item -ItemType Directory -Path $PwshDir -Force | Out-Null
    Extract-Archive -Path $PwshZip -Destination $PwshDir
    
    Write-Host "  PowerShell 7 installed!" -ForegroundColor Green
}
else {
    Write-Host "  PowerShell 7 already installed." -ForegroundColor Gray
}

# ===========================================
# 2. WINDOWS TERMINAL PORTABLE
# ===========================================
Write-Host "[2/8] Installing Windows Terminal Portable..." -ForegroundColor Yellow
$TerminalDir = "$AppsDir\WindowsTerminal"
if (-not (Test-Path "$TerminalDir\WindowsTerminal.exe") -or $Force) {
    # Windows Terminal portable - using GitHub releases
    $TerminalVersion = "1.21.2911.0"
    $TerminalUrl = "https://github.com/microsoft/terminal/releases/download/v$TerminalVersion/Microsoft.WindowsTerminalPreview_Win11_$($TerminalVersion)_8wekyb3d8bbwe.msixbundle_Windows11_PreinstallKit.zip"
    
    Write-Host "  Note: Windows Terminal portable requires extraction from MSIX." -ForegroundColor Cyan
    Write-Host "  Using alternative: Launching pwsh.exe directly instead." -ForegroundColor Cyan
    
    # Create a placeholder - we'll launch pwsh directly
    if (-not (Test-Path $TerminalDir)) {
        New-Item -ItemType Directory -Path $TerminalDir -Force | Out-Null
    }
    
    Write-Host "  Windows Terminal setup skipped (will use PowerShell directly)." -ForegroundColor Yellow
}
else {
    Write-Host "  Windows Terminal already installed." -ForegroundColor Gray
}

# ===========================================
# 3. GIT PORTABLE
# ===========================================
Write-Host "[3/8] Installing Git Portable..." -ForegroundColor Yellow
$GitDir = "$AppsDir\Git"
if (-not (Test-Path "$GitDir\cmd\git.exe") -or $Force) {
    $GitVersion = "2.47.1"
    $GitUrl = "https://github.com/git-for-windows/git/releases/download/v$GitVersion.windows.1/PortableGit-$GitVersion-64-bit.7z.exe"
    $GitExe = "$DownloadsDir\PortableGit.exe"
    
    Download-File -Url $GitUrl -OutFile $GitExe
    
    if (Test-Path $GitDir) { Remove-Item $GitDir -Recurse -Force }
    New-Item -ItemType Directory -Path $GitDir -Force | Out-Null
    
    # Extract self-extracting archive
    Start-Process -FilePath $GitExe -ArgumentList "-o`"$GitDir`"", "-y" -Wait -NoNewWindow
    
    Write-Host "  Git Portable installed!" -ForegroundColor Green
}
else {
    Write-Host "  Git Portable already installed." -ForegroundColor Gray
}

# ===========================================
# 4. NVM FOR WINDOWS (Portable)
# ===========================================
Write-Host "[4/8] Installing NVM for Windows..." -ForegroundColor Yellow
$NvmDir = "$AppsDir\NVM"
if (-not (Test-Path "$NvmDir\nvm.exe") -or $Force) {
    $NvmVersion = "1.2.2"
    $NvmUrl = "https://github.com/coreybutler/nvm-windows/releases/download/$NvmVersion/nvm-noinstall.zip"
    $NvmZip = "$DownloadsDir\nvm.zip"
    
    Download-File -Url $NvmUrl -OutFile $NvmZip
    
    if (Test-Path $NvmDir) { Remove-Item $NvmDir -Recurse -Force }
    New-Item -ItemType Directory -Path $NvmDir -Force | Out-Null
    Extract-Archive -Path $NvmZip -Destination $NvmDir
    
    # Create NVM settings file
    $NodeJsDir = "$AppsDir\NodeJS"
    if (-not (Test-Path $NodeJsDir)) { New-Item -ItemType Directory -Path $NodeJsDir -Force | Out-Null }
    
    $NvmSettings = @"
root: $NvmDir
path: $NodeJsDir
arch: 64
proxy: none
"@
    $NvmSettings | Out-File -FilePath "$NvmDir\settings.txt" -Encoding ASCII -Force
    
    Write-Host "  NVM installed!" -ForegroundColor Green
}
else {
    Write-Host "  NVM already installed." -ForegroundColor Gray
}

# ===========================================
# 5. NODE.JS (via direct download for portability)
# ===========================================
Write-Host "[5/8] Installing Node.js..." -ForegroundColor Yellow
$NodeDir = "$AppsDir\NodeJS"
if (-not (Test-Path "$NodeDir\node.exe") -or $Force) {
    $NodeVersion = "22.12.0"
    $NodeUrl = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-x64.zip"
    $NodeZip = "$DownloadsDir\nodejs.zip"
    
    Download-File -Url $NodeUrl -OutFile $NodeZip
    
    if (Test-Path $NodeDir) { Remove-Item $NodeDir -Recurse -Force }
    New-Item -ItemType Directory -Path $NodeDir -Force | Out-Null
    Extract-Archive -Path $NodeZip -Destination $TempDir
    
    # Move from nested folder
    $NodeExtracted = "$TempDir\node-v$NodeVersion-win-x64"
    if (Test-Path $NodeExtracted) {
        Get-ChildItem $NodeExtracted | Move-Item -Destination $NodeDir -Force
        Remove-Item $NodeExtracted -Force
    }
    
    # Configure npm to use portable paths
    $NpmRc = @"
cache=$($DataDir -replace '\\', '/')/npm-cache
prefix=$($DataDir -replace '\\', '/')/npm-global
"@
    $NpmRc | Out-File -FilePath "$NodeDir\.npmrc" -Encoding ASCII -Force
    
    Write-Host "  Node.js installed!" -ForegroundColor Green
}
else {
    Write-Host "  Node.js already installed." -ForegroundColor Gray
}

# ===========================================
# 6. PYTHON PORTABLE (Embedded)
# ===========================================
Write-Host "[6/8] Installing Python Portable..." -ForegroundColor Yellow
$PythonDir = "$AppsDir\Python"
if (-not (Test-Path "$PythonDir\python.exe") -or $Force) {
    $PythonVersion = "3.12.8"
    $PythonUrl = "https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-embed-amd64.zip"
    $PythonZip = "$DownloadsDir\python.zip"
    
    Download-File -Url $PythonUrl -OutFile $PythonZip
    
    if (Test-Path $PythonDir) { Remove-Item $PythonDir -Recurse -Force }
    New-Item -ItemType Directory -Path $PythonDir -Force | Out-Null
    Extract-Archive -Path $PythonZip -Destination $PythonDir
    
    # Enable pip in embedded Python
    $PthFile = Get-ChildItem "$PythonDir\python*._pth" | Select-Object -First 1
    if ($PthFile) {
        $content = Get-Content $PthFile.FullName
        $content = $content -replace '#import site', 'import site'
        $content | Set-Content $PthFile.FullName
    }
    
    # Create Scripts directory
    New-Item -ItemType Directory -Path "$PythonDir\Scripts" -Force | Out-Null
    
    # Download get-pip.py
    $GetPipUrl = "https://bootstrap.pypa.io/get-pip.py"
    $GetPipFile = "$PythonDir\get-pip.py"
    Download-File -Url $GetPipUrl -OutFile $GetPipFile
    
    # Install pip
    Write-Host "  Installing pip..." -ForegroundColor Gray
    & "$PythonDir\python.exe" $GetPipFile --no-warn-script-location
    
    Write-Host "  Python Portable installed!" -ForegroundColor Green
}
else {
    Write-Host "  Python already installed." -ForegroundColor Gray
}

# ===========================================
# 7. VS CODE PORTABLE
# ===========================================
Write-Host "[7/8] Installing VS Code Portable..." -ForegroundColor Yellow
$VSCodeDir = "$AppsDir\VSCode"
if (-not (Test-Path "$VSCodeDir\Code.exe") -or $Force) {
    $VSCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
    $VSCodeZip = "$DownloadsDir\vscode.zip"
    
    Download-File -Url $VSCodeUrl -OutFile $VSCodeZip
    
    if (Test-Path $VSCodeDir) { Remove-Item $VSCodeDir -Recurse -Force }
    New-Item -ItemType Directory -Path $VSCodeDir -Force | Out-Null
    Extract-Archive -Path $VSCodeZip -Destination $VSCodeDir
    
    # Create 'data' folder to enable portable mode
    $VSCodeDataDir = "$VSCodeDir\data"
    New-Item -ItemType Directory -Path $VSCodeDataDir -Force | Out-Null
    New-Item -ItemType Directory -Path "$VSCodeDataDir\user-data" -Force | Out-Null
    New-Item -ItemType Directory -Path "$VSCodeDataDir\extensions" -Force | Out-Null
    New-Item -ItemType Directory -Path "$VSCodeDataDir\tmp" -Force | Out-Null
    
    Write-Host "  VS Code Portable installed!" -ForegroundColor Green
}
else {
    Write-Host "  VS Code already installed." -ForegroundColor Gray
}

# ===========================================
# 8. CHROME PORTABLE (PortableApps version)
# ===========================================
Write-Host "[8/8] Installing Chrome Portable..." -ForegroundColor Yellow
$ChromeDir = "$AppsDir\Chrome"
if (-not (Test-Path "$ChromeDir\GoogleChromePortable.exe") -or $Force) {
    # Using PortableApps Chrome
    $ChromeUrl = "https://download3.portableapps.com/portableapps/GoogleChromePortable/GoogleChromePortable_131.0.6778.86_online.paf.exe"
    $ChromeExe = "$DownloadsDir\ChromePortable.exe"
    
    Write-Host "  Note: Chrome requires manual extraction or use the installer." -ForegroundColor Cyan
    Write-Host "  Downloading Chrome Portable installer..." -ForegroundColor Gray
    
    try {
        Download-File -Url $ChromeUrl -OutFile $ChromeExe
        
        if (Test-Path $ChromeDir) { Remove-Item $ChromeDir -Recurse -Force }
        New-Item -ItemType Directory -Path $ChromeDir -Force | Out-Null
        
        # Run silent install to the portable location
        Write-Host "  Running Chrome Portable installer (this may take a moment)..." -ForegroundColor Gray
        Start-Process -FilePath $ChromeExe -ArgumentList "/DESTINATION=`"$ChromeDir`"", "/SILENT" -Wait
        
        Write-Host "  Chrome Portable installed!" -ForegroundColor Green
    }
    catch {
        Write-Host "  Chrome download failed. You can manually download from:" -ForegroundColor Yellow
        Write-Host "  https://portableapps.com/apps/internet/google_chrome_portable" -ForegroundColor Cyan
    }
}
else {
    Write-Host "  Chrome Portable already installed." -ForegroundColor Gray
}

# ===========================================
# CLEANUP
# ===========================================
Write-Host ""
Write-Host "Cleaning up downloads..." -ForegroundColor Gray
# Keep downloads for potential reinstall
# Remove-Item "$DownloadsDir\*" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run 'Launch-Terminal.bat' to start isolated terminal" -ForegroundColor White
Write-Host "  2. Or run 'Launch-VSCode.bat' to start VS Code" -ForegroundColor White
Write-Host ""
