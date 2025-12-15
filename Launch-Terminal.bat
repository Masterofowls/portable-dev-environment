@echo off
:: =====================================================
:: PORTABLE TERMINAL LAUNCHER
:: =====================================================
:: Launches an isolated PowerShell environment
:: =====================================================

setlocal EnableDelayedExpansion

:: Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "PORTABLE_ROOT=%SCRIPT_DIR:~0,-1%"

:: Set all portable environment variables BEFORE launching PowerShell
set "PORTABLE_APPS=%PORTABLE_ROOT%\Apps"
set "PORTABLE_POWERSHELL=%PORTABLE_ROOT%\Apps\PowerShell"
set "PORTABLE_GIT=%PORTABLE_ROOT%\Apps\Git"
set "PORTABLE_NODEJS=%PORTABLE_ROOT%\Apps\NodeJS"
set "PORTABLE_NVM=%PORTABLE_ROOT%\Apps\NVM"
set "PORTABLE_PYTHON=%PORTABLE_ROOT%\Apps\Python"
set "PORTABLE_VSCODE=%PORTABLE_ROOT%\Apps\VSCode"
set "PORTABLE_CHROME=%PORTABLE_ROOT%\Apps\Chrome"
set "PORTABLE_DATA=%PORTABLE_ROOT%\Data"
set "PORTABLE_TEMP=%PORTABLE_ROOT%\Data\temp"
set "PORTABLE_HOME=%PORTABLE_ROOT%\Home"
set "PORTABLE_PROJECTS=%PORTABLE_ROOT%\Projects"

:: Override user profile paths
set "HOME=%PORTABLE_HOME%"
set "USERPROFILE=%PORTABLE_HOME%"
set "TEMP=%PORTABLE_TEMP%"
set "TMP=%PORTABLE_TEMP%"
set "LOCALAPPDATA=%PORTABLE_ROOT%\Data\LocalAppData"
set "APPDATA=%PORTABLE_ROOT%\Data\AppData"

:: Tool-specific configuration
set "NVM_HOME=%PORTABLE_NVM%"
set "NVM_SYMLINK=%PORTABLE_NODEJS%"
set "NPM_CONFIG_CACHE=%PORTABLE_ROOT%\Data\npm-cache"
set "NPM_CONFIG_PREFIX=%PORTABLE_ROOT%\Data\npm-global"
set "NODE_PATH=%PORTABLE_ROOT%\Data\npm-global\node_modules"
set "PYTHONUSERBASE=%PORTABLE_ROOT%\Data\python-packages"
set "PIP_CACHE_DIR=%PORTABLE_ROOT%\Data\pip-cache"
set "GIT_CONFIG_GLOBAL=%PORTABLE_ROOT%\Config\.gitconfig"
set "VSCODE_PORTABLE=%PORTABLE_VSCODE%\data"

:: Build isolated PATH
set "PATH=%PORTABLE_GIT%\cmd;%PORTABLE_GIT%\bin;%PORTABLE_GIT%\usr\bin;%PORTABLE_NVM%;%PORTABLE_NODEJS%;%PORTABLE_PYTHON%;%PORTABLE_PYTHON%\Scripts;%PORTABLE_VSCODE%\bin;%PORTABLE_ROOT%\Data\npm-global;%PORTABLE_ROOT%\Scripts;%SystemRoot%\System32;%SystemRoot%"

:: Check if Windows Terminal is available
if exist "%PORTABLE_ROOT%\Apps\WindowsTerminal\WindowsTerminal.exe" (
    echo Starting Windows Terminal...
    
    :: Copy terminal settings if they exist
    if exist "%PORTABLE_ROOT%\Config\terminal-settings.json" (
        if not exist "%PORTABLE_ROOT%\Apps\WindowsTerminal\settings" mkdir "%PORTABLE_ROOT%\Apps\WindowsTerminal\settings"
        copy /Y "%PORTABLE_ROOT%\Config\terminal-settings.json" "%PORTABLE_ROOT%\Apps\WindowsTerminal\settings\settings.json" >nul 2>&1
    )
    
    :: Start Windows Terminal with portable PowerShell
    start "" "%PORTABLE_ROOT%\Apps\WindowsTerminal\WindowsTerminal.exe" --profile "Portable PowerShell"
) else if exist "%PORTABLE_POWERSHELL%\pwsh.exe" (
    :: Launch portable PowerShell directly in a new window
    echo Starting Portable PowerShell 7...
    start "Portable PowerShell" "%PORTABLE_POWERSHELL%\pwsh.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -Command "& '%PORTABLE_ROOT%\Config\PortableProfile.ps1'"
) else (
    :: Last resort: use system PowerShell with portable profile
    echo Portable PowerShell not found. Using system PowerShell with portable profile...
    start "Portable PowerShell" powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -Command "& '%PORTABLE_ROOT%\Config\PortableProfile.ps1'"
)
