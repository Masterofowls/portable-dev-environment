@echo off
:: =====================================================
:: PORTABLE VS CODE LAUNCHER
:: =====================================================
:: Launches VS Code in fully portable/isolated mode
:: =====================================================

setlocal EnableDelayedExpansion

:: Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "PORTABLE_ROOT=%SCRIPT_DIR:~0,-1%"

:: Set all portable environment variables
set "PORTABLE_APPS=%PORTABLE_ROOT%\Apps"
set "PORTABLE_POWERSHELL=%PORTABLE_ROOT%\Apps\PowerShell"
set "PORTABLE_GIT=%PORTABLE_ROOT%\Apps\Git"
set "PORTABLE_NODEJS=%PORTABLE_ROOT%\Apps\NodeJS"
set "PORTABLE_NVM=%PORTABLE_ROOT%\Apps\NVM"
set "PORTABLE_PYTHON=%PORTABLE_ROOT%\Apps\Python"
set "PORTABLE_VSCODE=%PORTABLE_ROOT%\Apps\VSCode"
set "PORTABLE_CHROME=%PORTABLE_ROOT%\Apps\Chrome"
set "PORTABLE_FIREFOX=%PORTABLE_ROOT%\Apps\Firefox"
set "PORTABLE_DATA=%PORTABLE_ROOT%\Data"
set "PORTABLE_TEMP=%PORTABLE_ROOT%\Data\temp"
set "PORTABLE_HOME=%PORTABLE_ROOT%\Home"
set "PORTABLE_PROJECTS=%PORTABLE_ROOT%\Projects"

:: Override user profile paths for VS Code
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
set "PYTHONUSERBASE=%PORTABLE_ROOT%\Data\python-packages"
set "PIP_CACHE_DIR=%PORTABLE_ROOT%\Data\pip-cache"
set "GIT_CONFIG_GLOBAL=%PORTABLE_ROOT%\Config\.gitconfig"
set "VSCODE_PORTABLE=%PORTABLE_VSCODE%\data"

:: Build isolated PATH
set "PATH=%PORTABLE_GIT%\cmd;%PORTABLE_GIT%\bin;%PORTABLE_GIT%\usr\bin;%PORTABLE_NVM%;%PORTABLE_NODEJS%;%PORTABLE_PYTHON%;%PORTABLE_PYTHON%\Scripts;%PORTABLE_VSCODE%\bin;%PORTABLE_ROOT%\Data\npm-global;%PORTABLE_ROOT%\Scripts;%SystemRoot%\System32;%SystemRoot%"

:: VS Code data directories
set "VSCODE_USER_DATA=%PORTABLE_VSCODE%\data\user-data"
set "VSCODE_EXTENSIONS=%PORTABLE_VSCODE%\data\extensions"
set "VSCODE_TMP=%PORTABLE_VSCODE%\data\tmp"

:: Create directories if they don't exist
if not exist "%VSCODE_USER_DATA%" mkdir "%VSCODE_USER_DATA%"
if not exist "%VSCODE_EXTENSIONS%" mkdir "%VSCODE_EXTENSIONS%"
if not exist "%VSCODE_TMP%" mkdir "%VSCODE_TMP%"

:: Copy settings if they exist and settings.json doesn't
if exist "%PORTABLE_ROOT%\Config\vscode-settings.json" (
    if not exist "%VSCODE_USER_DATA%\User" mkdir "%VSCODE_USER_DATA%\User"
    if not exist "%VSCODE_USER_DATA%\User\settings.json" (
        copy /Y "%PORTABLE_ROOT%\Config\vscode-settings.json" "%VSCODE_USER_DATA%\User\settings.json" >nul 2>&1
    )
)

:: Check if VS Code exists
if exist "%PORTABLE_VSCODE%\Code.exe" (
    echo Starting VS Code Portable...
    
    :: Launch VS Code with portable flags
    start "" "%PORTABLE_VSCODE%\Code.exe" ^
        --user-data-dir "%VSCODE_USER_DATA%" ^
        --extensions-dir "%VSCODE_EXTENSIONS%" ^
        --disable-telemetry ^
        --disable-updates ^
        "%PORTABLE_PROJECTS%"
) else (
    echo VS Code not found at: %PORTABLE_VSCODE%
    echo Please run Setup-Environment.bat first.
    pause
)
