# Install Extra Portable Applications
# Zed IDE, Everything Search, Draw.io, LibreOffice Portable

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

$PortableRoot = Split-Path -Parent $PSScriptRoot
$AppsDir = "$PortableRoot\Apps"
$TempDir = "$PortableRoot\Data\temp"

# Create directories
@($AppsDir, $TempDir) | ForEach-Object {
    if (-not (Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}

function Write-Status {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host ">> $Message" -ForegroundColor $Color
}

function Get-GitHubLatestRelease {
    param([string]$Repo, [string]$Pattern)
    try {
        $releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -Headers @{"User-Agent"="PowerShell"}
        $asset = $releases.assets | Where-Object { $_.name -like $Pattern } | Select-Object -First 1
        return @{ Url = $asset.browser_download_url; Name = $asset.name; Version = $releases.tag_name }
    } catch {
        Write-Warning "Failed to get release info for $Repo"
        return $null
    }
}

# ============================================
# ZED IDE (Portable)
# ============================================
Write-Status "Installing Zed IDE..." "Yellow"
$ZedDir = "$AppsDir\Zed"
if (-not (Test-Path "$ZedDir\zed.exe")) {
    try {
        # Zed for Windows - get latest release
        $zedRelease = Get-GitHubLatestRelease -Repo "zed-industries/zed" -Pattern "*windows*.zip"
        if ($zedRelease -and $zedRelease.Url) {
            Write-Status "Downloading Zed $($zedRelease.Version)..."
            $zedZip = "$TempDir\zed.zip"
            Invoke-WebRequest -Uri $zedRelease.Url -OutFile $zedZip -UseBasicParsing
            
            New-Item -ItemType Directory -Path $ZedDir -Force | Out-Null
            Expand-Archive -Path $zedZip -DestinationPath $ZedDir -Force
            
            # Move files from nested folder if exists
            $nested = Get-ChildItem -Path $ZedDir -Directory | Select-Object -First 1
            if ($nested -and (Test-Path "$($nested.FullName)\zed.exe")) {
                Get-ChildItem -Path $nested.FullName | Move-Item -Destination $ZedDir -Force
                Remove-Item $nested.FullName -Force -Recurse -ErrorAction SilentlyContinue
            }
            
            Remove-Item $zedZip -Force -ErrorAction SilentlyContinue
            Write-Status "Zed installed: $($zedRelease.Version)" "Green"
        } else {
            Write-Warning "Could not find Zed Windows release"
        }
    } catch {
        Write-Warning "Failed to install Zed: $_"
    }
} else {
    Write-Status "Zed already installed" "Green"
}

# ============================================
# EVERYTHING SEARCH (Portable)
# ============================================
Write-Status "Installing Everything Search..." "Yellow"
$EverythingDir = "$AppsDir\Everything"
if (-not (Test-Path "$EverythingDir\Everything.exe")) {
    try {
        # Everything portable 64-bit
        $everythingUrl = "https://www.voidtools.com/Everything-1.4.1.1026.x64.zip"
        $everythingZip = "$TempDir\everything.zip"
        
        Write-Status "Downloading Everything Search..."
        Invoke-WebRequest -Uri $everythingUrl -OutFile $everythingZip -UseBasicParsing
        
        New-Item -ItemType Directory -Path $EverythingDir -Force | Out-Null
        Expand-Archive -Path $everythingZip -DestinationPath $EverythingDir -Force
        
        # Create portable marker so it stores settings locally
        New-Item -ItemType File -Path "$EverythingDir\Everything.ini" -Force | Out-Null
        
        Remove-Item $everythingZip -Force -ErrorAction SilentlyContinue
        Write-Status "Everything Search installed: 1.4.1.1026" "Green"
    } catch {
        Write-Warning "Failed to install Everything: $_"
    }
} else {
    Write-Status "Everything already installed" "Green"
}

# ============================================
# DRAW.IO DESKTOP (Portable)
# ============================================
Write-Status "Installing Draw.io Desktop..." "Yellow"
$DrawioDir = "$AppsDir\Drawio"
if (-not (Test-Path "$DrawioDir\draw.io.exe")) {
    try {
        # Draw.io desktop from GitHub releases
        $drawioRelease = Get-GitHubLatestRelease -Repo "jgraph/drawio-desktop" -Pattern "*windows-no-installer.exe"
        if ($drawioRelease -and $drawioRelease.Url) {
            Write-Status "Downloading Draw.io $($drawioRelease.Version)..."
            
            New-Item -ItemType Directory -Path $DrawioDir -Force | Out-Null
            Invoke-WebRequest -Uri $drawioRelease.Url -OutFile "$DrawioDir\draw.io.exe" -UseBasicParsing
            
            Write-Status "Draw.io installed: $($drawioRelease.Version)" "Green"
        } else {
            # Fallback to zip version
            $drawioRelease = Get-GitHubLatestRelease -Repo "jgraph/drawio-desktop" -Pattern "*win32-x64*.zip"
            if ($drawioRelease -and $drawioRelease.Url) {
                Write-Status "Downloading Draw.io ZIP $($drawioRelease.Version)..."
                $drawioZip = "$TempDir\drawio.zip"
                Invoke-WebRequest -Uri $drawioRelease.Url -OutFile $drawioZip -UseBasicParsing
                
                New-Item -ItemType Directory -Path $DrawioDir -Force | Out-Null
                Expand-Archive -Path $drawioZip -DestinationPath $DrawioDir -Force
                
                # Handle nested folder
                $nested = Get-ChildItem -Path $DrawioDir -Directory | Select-Object -First 1
                if ($nested) {
                    Get-ChildItem -Path $nested.FullName | Move-Item -Destination $DrawioDir -Force
                    Remove-Item $nested.FullName -Force -Recurse -ErrorAction SilentlyContinue
                }
                
                Remove-Item $drawioZip -Force -ErrorAction SilentlyContinue
                Write-Status "Draw.io installed: $($drawioRelease.Version)" "Green"
            }
        }
    } catch {
        Write-Warning "Failed to install Draw.io: $_"
    }
} else {
    Write-Status "Draw.io already installed" "Green"
}

# ============================================
# LIBREOFFICE PORTABLE
# ============================================
Write-Status "Installing LibreOffice Portable..." "Yellow"
$LibreOfficeDir = "$AppsDir\LibreOffice"
if (-not (Test-Path "$LibreOfficeDir\LibreOfficePortable.exe") -and -not (Test-Path "$LibreOfficeDir\App\libreoffice\program\soffice.exe")) {
    try {
        # LibreOffice Portable from PortableApps - Fresh version
        $libreUrl = "https://download3.portableapps.com/portableapps/LibreOfficePortableFresh/LibreOfficePortableFresh_24.8.4_MultilingualStandard.paf.exe"
        $libreInstaller = "$TempDir\LibreOfficePortable.paf.exe"
        
        Write-Status "Downloading LibreOffice Portable (this may take a while ~350MB)..."
        Invoke-WebRequest -Uri $libreUrl -OutFile $libreInstaller -UseBasicParsing
        
        Write-Status "Extracting LibreOffice (silent install to portable folder)..."
        New-Item -ItemType Directory -Path $LibreOfficeDir -Force | Out-Null
        
        # Run the PortableApps installer silently
        Start-Process -FilePath $libreInstaller -ArgumentList "/DESTINATION=`"$LibreOfficeDir`"", "/SILENT" -Wait -NoNewWindow
        
        Remove-Item $libreInstaller -Force -ErrorAction SilentlyContinue
        Write-Status "LibreOffice Portable installed: 24.8.4" "Green"
    } catch {
        Write-Warning "Failed to install LibreOffice: $_"
    }
} else {
    Write-Status "LibreOffice already installed" "Green"
}

# ============================================
# WINGET PORTABLE (UniGetUI as alternative)
# ============================================
Write-Status "Installing UniGetUI (WinGet GUI alternative)..." "Yellow"
$UniGetDir = "$AppsDir\UniGetUI"
if (-not (Test-Path "$UniGetDir\UniGetUI.exe") -and -not (Test-Path "$UniGetDir\WingetUI.exe")) {
    try {
        # UniGetUI (formerly WingetUI) - portable package manager GUI
        $unigetRelease = Get-GitHubLatestRelease -Repo "marticliment/UniGetUI" -Pattern "*Portable.zip"
        if ($unigetRelease -and $unigetRelease.Url) {
            Write-Status "Downloading UniGetUI $($unigetRelease.Version)..."
            $unigetZip = "$TempDir\unigetui.zip"
            Invoke-WebRequest -Uri $unigetRelease.Url -OutFile $unigetZip -UseBasicParsing
            
            New-Item -ItemType Directory -Path $UniGetDir -Force | Out-Null
            Expand-Archive -Path $unigetZip -DestinationPath $UniGetDir -Force
            
            Remove-Item $unigetZip -Force -ErrorAction SilentlyContinue
            Write-Status "UniGetUI installed: $($unigetRelease.Version)" "Green"
        }
    } catch {
        Write-Warning "Failed to install UniGetUI: $_"
    }
} else {
    Write-Status "UniGetUI already installed" "Green"
}

# ============================================
# SUMMARY
# ============================================
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " INSTALLATION COMPLETE" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

$apps = @(
    @{ Name = "Zed IDE"; Path = "$AppsDir\Zed\zed.exe" },
    @{ Name = "Everything Search"; Path = "$AppsDir\Everything\Everything.exe" },
    @{ Name = "Draw.io"; Path = "$AppsDir\Drawio\draw.io.exe" },
    @{ Name = "LibreOffice"; Path = "$AppsDir\LibreOffice\LibreOfficePortable.exe" },
    @{ Name = "UniGetUI"; Path = "$AppsDir\UniGetUI\UniGetUI.exe" }
)

foreach ($app in $apps) {
    $status = if (Test-Path $app.Path) { "[OK]" } else { "[--]" }
    $color = if (Test-Path $app.Path) { "Green" } else { "Red" }
    Write-Host "$status $($app.Name)" -ForegroundColor $color
}

Write-Host ""
Write-Host "Note: Restart your terminal to use new commands." -ForegroundColor Yellow
Write-Host "Commands: zed, everything, drawio, libre, uniget" -ForegroundColor Cyan
