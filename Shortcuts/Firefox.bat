@echo off
:: Quick Launch - Firefox Portable
:: Double-click to open Firefox with portable profile

setlocal
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PORTABLE_ROOT=%%~fI"

set "PORTABLE_FIREFOX=%PORTABLE_ROOT%\Apps\Firefox"
set "FIREFOX_PROFILE=%PORTABLE_ROOT%\Data\firefox-profile"

if not exist "%FIREFOX_PROFILE%" mkdir "%FIREFOX_PROFILE%"

start "" "%PORTABLE_FIREFOX%\firefox.exe" -profile "%FIREFOX_PROFILE%" %*
