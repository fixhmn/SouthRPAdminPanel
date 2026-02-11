@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
set "RDP_IP=46.174.55.42"
set "API_DIR=%ROOT%api"
set "WEB_DIR=%ROOT%web"

if not exist "%API_DIR%\.env" (
  echo Missing file: "%API_DIR%\.env"
  echo Create it first from api\.env.example
  pause
  exit /b 1
)

if not exist "%API_DIR%\.venv\Scripts\python.exe" (
  echo Missing API venv. Run run-rdp.bat first.
  pause
  exit /b 1
)

if not exist "%WEB_DIR%\.next\BUILD_ID" (
  echo Missing WEB build. Run run-rdp.bat first.
  pause
  exit /b 1
)

netsh advfirewall firewall add rule name="SouthRPSite API 8000" dir=in action=allow protocol=TCP localport=8000 >nul 2>&1
netsh advfirewall firewall add rule name="SouthRPSite WEB 3000" dir=in action=allow protocol=TCP localport=3000 >nul 2>&1

start "SouthRPSite API" cmd /k "cd /d ""%API_DIR%"" && call "".venv\Scripts\activate.bat"" && python -m uvicorn main:app --host 0.0.0.0 --port 8000 --env-file .env"
start "SouthRPSite WEB" cmd /k "cd /d ""%WEB_DIR%"" && npm run start -- --hostname 0.0.0.0 --port 3000"

echo Started.
echo WEB: http://%RDP_IP%:3000
echo API: http://%RDP_IP%:8000
pause
