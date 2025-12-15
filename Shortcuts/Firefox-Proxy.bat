@echo off
:: Launch Firefox with Shadowsocks Proxy
:: Automatically routes all Firefox traffic through the proxy

setlocal
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PORTABLE_ROOT=%%~fI"

set "PORTABLE_FIREFOX=%PORTABLE_ROOT%\Apps\Firefox"
set "FIREFOX_PROFILE=%PORTABLE_ROOT%\Data\firefox-profile-proxy"

if not exist "%FIREFOX_PROFILE%" mkdir "%FIREFOX_PROFILE%"

:: Start Firefox with SOCKS5 proxy profile (auto-configured)
start "" "%PORTABLE_FIREFOX%\firefox.exe" -profile "%FIREFOX_PROFILE%" -no-remote %*

echo Firefox started with SOCKS5 proxy (127.0.0.1:1080)
echo Make sure Shadowsocks is running!
