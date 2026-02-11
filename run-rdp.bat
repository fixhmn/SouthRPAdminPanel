@echo off
setlocal EnableExtensions

REM ==========================================
REM SouthRPSite - Install, Build and Run (RDP)
REM ==========================================

set "ROOT=%~dp0"
set "RDP_IP=46.174.55.42"
set "API_DIR=%ROOT%api"
set "WEB_DIR=%ROOT%web"

echo [1/6] Checking API env file...
if not exist "%API_DIR%\.env" (
  copy "%API_DIR%\.env.example" "%API_DIR%\.env" >nul
  echo Created: "%API_DIR%\.env"
  echo Fill required values in api\.env and run this file again.
  echo Required: DISCORD_CLIENT_ID, DISCORD_CLIENT_SECRET, DISCORD_BOT_TOKEN
  pause
  exit /b 1
)

echo [2/6] Checking WEB env file...
if not exist "%WEB_DIR%\.env.local" (
  > "%WEB_DIR%\.env.local" echo NEXT_PUBLIC_API_BASE=http://%RDP_IP%:8000
  echo Created: "%WEB_DIR%\.env.local"
)

echo [3/6] Installing API dependencies...
cd /d "%API_DIR%"
if not exist ".venv\Scripts\python.exe" (
  py -m venv .venv
)
call ".venv\Scripts\activate"
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
  echo Failed to install API dependencies.
  pause
  exit /b 1
)

echo [4/6] Installing WEB dependencies...
cd /d "%WEB_DIR%"
if not exist "node_modules" (
  npm install
) else (
  npm install
)
if errorlevel 1 (
  echo Failed to install WEB dependencies.
  pause
  exit /b 1
)

echo [5/6] Building WEB...
npm run build
if errorlevel 1 (
  echo WEB build failed.
  pause
  exit /b 1
)

echo [6/6] Opening firewall and starting services...
netsh advfirewall firewall add rule name="SouthRPSite API 8000" dir=in action=allow protocol=TCP localport=8000 >nul 2>&1
netsh advfirewall firewall add rule name="SouthRPSite WEB 3000" dir=in action=allow protocol=TCP localport=3000 >nul 2>&1

start "SouthRPSite API" cmd /k "cd /d ""%API_DIR%"" && call "".venv\Scripts\activate.bat"" && python -m uvicorn main:app --host 0.0.0.0 --port 8000 --env-file .env"
start "SouthRPSite WEB" cmd /k "cd /d ""%WEB_DIR%"" && npm run start -- --hostname 0.0.0.0 --port 3000"

echo.
echo Started.
echo WEB: http://%RDP_IP%:3000
echo API: http://%RDP_IP%:8000
echo.
echo If Discord login fails, check api window logs.
pause
