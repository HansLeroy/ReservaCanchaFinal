@echo off
title ReservaCancha - Inicializando Sistema Completo
color 0A

echo.
echo ========================================================
echo          SISTEMA DE RESERVA DE CANCHAS
echo ========================================================
echo.
echo Iniciando servicios...
echo.

REM Detener procesos previos
echo [1/4] Deteniendo procesos previos...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo [2/4] Iniciando Backend (Spring Boot - Puerto 8080)...
cd /d "%~dp0backend"
start "Backend - ReservaCancha [Puerto 8080]" cmd /k "echo Iniciando Backend... && mvnw.cmd spring-boot:run"

echo [3/4] Esperando 10 segundos para que el backend inicie...
timeout /t 10 /nobreak >nul

echo [4/4] Iniciando Frontend (Angular - Puerto 4200)...
cd /d "%~dp0frontend"
start "Frontend - ReservaCancha [Puerto 4200]" cmd /k "echo Iniciando Frontend... && npm start"

echo.
echo ========================================================
echo   SISTEMA INICIANDO - Espera 30-45 segundos
echo ========================================================
echo.
echo   Backend:  http://localhost:8080
echo   Frontend: http://localhost:4200
echo.
echo   Credenciales de prueba:
echo   - Admin: admin@reservacancha.com / admin123
echo   - Usuario: usuario@reservacancha.com / usuario123
echo.
echo ========================================================
echo.
echo Esperando 30 segundos antes de abrir el navegador...
timeout /t 30 /nobreak

echo.
echo Abriendo navegador...
start http://localhost:4200

echo.
echo ========================================================
echo   SISTEMA LISTO
echo ========================================================
echo.
echo Presiona cualquier tecla para cerrar esta ventana...
echo (Las ventanas de Backend y Frontend seguiran abiertas)
echo.
pause >nul

