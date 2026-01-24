@echo off
title Backend ReservaCancha - Puerto 8080
echo ========================================
echo Iniciando Backend - ReservaCancha
echo ========================================
echo.

cd /d "%~dp0"

echo Verificando puerto 8080...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING 2^>nul') do (
    echo Puerto 8080 ocupado por proceso %%a
    echo Deteniendo proceso...
    taskkill /F /PID %%a 2>nul
    timeout /t 3 /nobreak >nul
)

echo.
echo Puerto 8080 disponible.
echo.
echo Iniciando servidor Spring Boot...
echo El servidor estara disponible en: http://localhost:8080
echo Presiona Ctrl+C para detener el servidor
echo.
echo ========================================
echo.

call mvnw.cmd spring-boot:run

echo.
echo ========================================
echo Backend detenido
echo ========================================
pause

