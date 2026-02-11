@echo off
setlocal EnableExtensions

REM ==========================================
REM SouthRPSite - Update from Git and Restart
REM ==========================================

set "ROOT=%~dp0"
set "API_DIR=%ROOT%api"
set "WEB_DIR=%ROOT%web"

echo [1/8] Checking git repository...
if not exist "%ROOT%\.git" (
  echo This folder is not a git repository: "%ROOT%"
  pause
  exit /b 1
)

echo [2/8] Pulling latest changes...
cd /d "%ROOT%"
git pull --ff-only
if errorlevel 1 (
  echo git pull failed. Resolve conflicts/issues and try again.
  pause
  exit /b 1
)

echo [3/8] Checking API env...
if not exist "%API_DIR%\.env" (
  echo Missing file: "%API_DIR%\.env"
  echo Create it first from api\.env.example
  pause
  exit /b 1
)

echo [4/8] Installing/updating API dependencies...
cd /d "%API_DIR%"
if not exist ".venv\Scripts\python.exe" (
  py -m venv .venv
)
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
  echo API dependency install failed.
  pause
  exit /b 1
)

echo [5/8] Installing/updating WEB dependencies...
cd /d "%WEB_DIR%"
where npm >nul 2>&1
if errorlevel 1 (
  echo npm is not installed or not in PATH.
  pause
  exit /b 1
)
set "npm_config_fund=false"
set "npm_config_audit=false"
if exist "package-lock.json" (
  call npm ci --no-audit --no-fund
) else (
  call npm install --no-audit --no-fund
)
if errorlevel 1 (
  echo WEB dependency install failed.
  pause
  exit /b 1
)

echo [6/8] Building WEB...
call npm run build
if errorlevel 1 (
  echo WEB build failed.
  pause
  exit /b 1
)

echo [7/8] Stopping old API/WEB windows (if running)...
taskkill /FI "WINDOWTITLE eq SouthRPSite API" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq SouthRPSite WEB" /T /F >nul 2>&1

echo [8/8] Starting services...
start "SouthRPSite API" cmd /k "cd /d ""%API_DIR%"" && call "".venv\Scripts\activate.bat"" && python -m uvicorn main:app --host 0.0.0.0 --port 8000 --env-file .env"
start "SouthRPSite WEB" cmd /k "cd /d ""%WEB_DIR%"" && npm run start -- --hostname 0.0.0.0 --port 3000"

echo.
echo Update complete.
echo API: http://46.174.55.42:8000/health
echo WEB: http://46.174.55.42:3000
echo.
pause
