@echo off
:: Quick Launch - VS Code Portable
:: Double-click to open VS Code with portable settings

setlocal
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PORTABLE_ROOT=%%~fI"

:: Set portable environment
set "PORTABLE_VSCODE=%PORTABLE_ROOT%\Apps\VSCode"
set "VSCODE_PORTABLE=%PORTABLE_VSCODE%\data"
set "HOME=%PORTABLE_ROOT%\Home"
set "TEMP=%PORTABLE_ROOT%\Data\temp"
set "APPDATA=%PORTABLE_ROOT%\Data\AppData"
set "LOCALAPPDATA=%PORTABLE_ROOT%\Data\LocalAppData"

:: Set tool paths for integrated terminal
set "PORTABLE_GIT=%PORTABLE_ROOT%\Apps\Git"
set "PORTABLE_NODEJS=%PORTABLE_ROOT%\Apps\NodeJS"
set "PORTABLE_PYTHON=%PORTABLE_ROOT%\Apps\Python"
set "PATH=%PORTABLE_GIT%\cmd;%PORTABLE_NODEJS%;%PORTABLE_PYTHON%;%PORTABLE_ROOT%\Data\npm-global;%SystemRoot%\System32"

start "" "%PORTABLE_VSCODE%\Code.exe" --user-data-dir "%VSCODE_PORTABLE%\user-data" --extensions-dir "%VSCODE_PORTABLE%\extensions" %*
