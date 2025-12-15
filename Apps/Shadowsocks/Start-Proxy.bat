@echo off
:: Launch Shadowsocks Local Proxy
:: Runs as SOCKS5 proxy on 127.0.0.1:1080
:: NO admin rights needed, only affects apps configured to use the proxy

setlocal
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo ==========================================
echo  SHADOWSOCKS LOCAL PROXY
echo ==========================================
echo.
echo Server: 95.81.64.205:8443
echo Local:  127.0.0.1:1080 (SOCKS5)
echo.
echo Configure your apps to use:
echo   SOCKS5 Proxy: 127.0.0.1:1080
echo.
echo Press Ctrl+C to stop the proxy
echo ==========================================
echo.

sslocal.exe -c config.json
