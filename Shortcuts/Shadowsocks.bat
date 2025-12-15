@echo off
:: Quick Launch - Shadowsocks Proxy (Background)
:: Starts the proxy minimized

setlocal
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PORTABLE_ROOT=%%~fI"

start /min "" "%PORTABLE_ROOT%\Apps\Shadowsocks\sslocal.exe" -c "%PORTABLE_ROOT%\Apps\Shadowsocks\config.json"
echo Shadowsocks proxy started on 127.0.0.1:1080
