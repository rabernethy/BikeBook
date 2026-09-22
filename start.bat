@echo off
REM Launcher for Windows - serves the app locally and opens your browser.
REM Your data lives in the browser (IndexedDB) keyed to this exact URL, so
REM ALWAYS launch it the same way (same port) or you'll get a fresh empty store.
setlocal
cd /d "%~dp0"
set "PORT=%~1"
if "%PORT%"=="" set "PORT=8787"
set "URL=http://127.0.0.1:%PORT%/"

where py >nul 2>nul
if %errorlevel%==0 (
  echo Running at %URL%   ^(close this window to stop^)
  start "" "%URL%"
  py -m http.server %PORT% --bind 127.0.0.1
  goto :eof
)
where python >nul 2>nul
if %errorlevel%==0 (
  echo Running at %URL%   ^(close this window to stop^)
  start "" "%URL%"
  python -m http.server %PORT% --bind 127.0.0.1
  goto :eof
)
where npx >nul 2>nul
if %errorlevel%==0 (
  echo Running at %URL%   ^(close this window to stop^)
  start "" "%URL%"
  npx --yes http-server . -p %PORT% -a 127.0.0.1
  goto :eof
)
echo Could not find Python or Node.
echo Install Python from https://www.python.org/downloads/ and tick
echo "Add python.exe to PATH" during setup, then run this file again.
pause
