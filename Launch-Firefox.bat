@echo off
:: =====================================================
:: PORTABLE FIREFOX LAUNCHER
:: =====================================================

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PORTABLE_ROOT=%SCRIPT_DIR:~0,-1%"
set "PORTABLE_FIREFOX=%PORTABLE_ROOT%\Apps\Firefox"
set "FIREFOX_PROFILE=%PORTABLE_ROOT%\Data\firefox-profile"

:: Create profile directory if it doesn't exist
if not exist "%FIREFOX_PROFILE%" mkdir "%FIREFOX_PROFILE%"

if exist "%PORTABLE_FIREFOX%\firefox.exe" (
    echo Starting Firefox Portable...
    start "" "%PORTABLE_FIREFOX%\firefox.exe" -profile "%FIREFOX_PROFILE%"
) else (
    echo Firefox Portable not found at: %PORTABLE_FIREFOX%
    echo Please run Setup-Environment.bat first.
    pause
)
