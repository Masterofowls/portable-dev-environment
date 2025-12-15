@echo off
:: =====================================================
:: PORTABLE DEVELOPMENT ENVIRONMENT - FIRST TIME SETUP
:: =====================================================
:: Run this script as Administrator for first-time setup
:: =====================================================

setlocal EnableDelayedExpansion

:: Get the drive letter where this script is located
set "SCRIPT_DIR=%~dp0"
:: Remove trailing backslash
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Check if we're already in PortableDev folder
if exist "%SCRIPT_DIR%\Scripts\Install-Apps.ps1" (
    set "PORTABLE_ROOT=%SCRIPT_DIR%"
) else (
    set "PORTABLE_ROOT=%SCRIPT_DIR%\PortableDev"
)

echo.
echo =========================================
echo   PORTABLE DEV ENVIRONMENT SETUP
echo =========================================
echo.
echo This will set up an isolated development environment.
echo Location: %PORTABLE_ROOT%
echo.

:: Check for admin rights (optional, for some operations)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Note: Running without admin rights.
    echo Some features may be limited.
    echo.
)

:: Create directory structure
echo Creating directory structure...
if not exist "%PORTABLE_ROOT%" mkdir "%PORTABLE_ROOT%"
if not exist "%PORTABLE_ROOT%\Apps" mkdir "%PORTABLE_ROOT%\Apps"
if not exist "%PORTABLE_ROOT%\Apps\WindowsTerminal" mkdir "%PORTABLE_ROOT%\Apps\WindowsTerminal"
if not exist "%PORTABLE_ROOT%\Apps\PowerShell" mkdir "%PORTABLE_ROOT%\Apps\PowerShell"
if not exist "%PORTABLE_ROOT%\Apps\NodeJS" mkdir "%PORTABLE_ROOT%\Apps\NodeJS"
if not exist "%PORTABLE_ROOT%\Apps\NVM" mkdir "%PORTABLE_ROOT%\Apps\NVM"
if not exist "%PORTABLE_ROOT%\Apps\Python" mkdir "%PORTABLE_ROOT%\Apps\Python"
if not exist "%PORTABLE_ROOT%\Apps\VSCode" mkdir "%PORTABLE_ROOT%\Apps\VSCode"
if not exist "%PORTABLE_ROOT%\Apps\Chrome" mkdir "%PORTABLE_ROOT%\Apps\Chrome"
if not exist "%PORTABLE_ROOT%\Apps\Git" mkdir "%PORTABLE_ROOT%\Apps\Git"
if not exist "%PORTABLE_ROOT%\Config" mkdir "%PORTABLE_ROOT%\Config"
if not exist "%PORTABLE_ROOT%\Data" mkdir "%PORTABLE_ROOT%\Data"
if not exist "%PORTABLE_ROOT%\Data\temp" mkdir "%PORTABLE_ROOT%\Data\temp"
if not exist "%PORTABLE_ROOT%\Data\downloads" mkdir "%PORTABLE_ROOT%\Data\downloads"
if not exist "%PORTABLE_ROOT%\Data\npm-cache" mkdir "%PORTABLE_ROOT%\Data\npm-cache"
if not exist "%PORTABLE_ROOT%\Data\npm-global" mkdir "%PORTABLE_ROOT%\Data\npm-global"
if not exist "%PORTABLE_ROOT%\Data\pip-cache" mkdir "%PORTABLE_ROOT%\Data\pip-cache"
if not exist "%PORTABLE_ROOT%\Data\python-packages" mkdir "%PORTABLE_ROOT%\Data\python-packages"
if not exist "%PORTABLE_ROOT%\Data\LocalAppData" mkdir "%PORTABLE_ROOT%\Data\LocalAppData"
if not exist "%PORTABLE_ROOT%\Data\AppData" mkdir "%PORTABLE_ROOT%\Data\AppData"
if not exist "%PORTABLE_ROOT%\Data\PSModules" mkdir "%PORTABLE_ROOT%\Data\PSModules"
if not exist "%PORTABLE_ROOT%\Data\chrome-data" mkdir "%PORTABLE_ROOT%\Data\chrome-data"
if not exist "%PORTABLE_ROOT%\Home" mkdir "%PORTABLE_ROOT%\Home"
if not exist "%PORTABLE_ROOT%\Projects" mkdir "%PORTABLE_ROOT%\Projects"
if not exist "%PORTABLE_ROOT%\Scripts" mkdir "%PORTABLE_ROOT%\Scripts"

echo Directory structure created.
echo.

:: Run the PowerShell installation script
echo Starting application downloads and installation...
echo This may take several minutes depending on your internet connection.
echo.

:: Use system PowerShell to bootstrap the installation
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%PORTABLE_ROOT%\Scripts\Install-Apps.ps1'"

echo.
echo =========================================
echo   SETUP COMPLETE!
echo =========================================
echo.
echo To start your isolated environment:
echo   Run: Launch-Terminal.bat
echo.
echo To start VS Code:
echo   Run: Launch-VSCode.bat
echo.
pause
