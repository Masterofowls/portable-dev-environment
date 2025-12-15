@echo off
:: =====================================================
:: PORTABLE CHROME LAUNCHER
:: =====================================================

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PORTABLE_ROOT=%SCRIPT_DIR:~0,-1%"
set "PORTABLE_CHROME=%PORTABLE_ROOT%\Apps\Chrome"
set "CHROME_DATA=%PORTABLE_ROOT%\Data\chrome-data"

if not exist "%CHROME_DATA%" mkdir "%CHROME_DATA%"

if exist "%PORTABLE_CHROME%\GoogleChromePortable.exe" (
    echo Starting Chrome Portable...
    start "" "%PORTABLE_CHROME%\GoogleChromePortable.exe"
) else if exist "%PORTABLE_CHROME%\App\Chrome-bin\chrome.exe" (
    echo Starting Chrome Portable...
    start "" "%PORTABLE_CHROME%\App\Chrome-bin\chrome.exe" --user-data-dir="%CHROME_DATA%"
) else (
    echo Chrome Portable not found.
    echo Please run Setup-Environment.bat first.
    pause
)
