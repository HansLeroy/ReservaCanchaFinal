@echo off
echo ============================================
echo  Iniciando Sistema ReservaCancha
echo ============================================
echo.
echo Iniciando Backend (Puerto 8080)...
start "Backend - ReservaCancha" powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0backend\start-backend.ps1"

timeout /t 3 /nobreak >nul

echo Iniciando Frontend (Puerto 4200)...
start "Frontend - ReservaCancha" powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0frontend\start-frontend.ps1"

echo.
echo ============================================
echo  Ambos servicios estan iniciando...
echo ============================================
echo  Backend:  http://localhost:8080
echo  Frontend: http://localhost:4200
echo ============================================
echo.
pause

