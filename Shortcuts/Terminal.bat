@echo off
:: Quick Launch - Terminal (PowerShell 7)
:: Double-click to open isolated PowerShell terminal

setlocal
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PORTABLE_ROOT=%%~fI"

start "" "%PORTABLE_ROOT%\Apps\PowerShell\pwsh.exe" -NoLogo -NoExit -ExecutionPolicy Bypass -File "%PORTABLE_ROOT%\Config\PortableProfile.ps1"
