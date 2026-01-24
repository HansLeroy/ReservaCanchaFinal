@echo off
echo ============================================
echo  Iniciando Backend - ReservaCancha
echo ============================================
echo.

cd /d "%~dp0"

echo Deteniendo procesos Java previos...
taskkill /F /IM java.exe >nul 2>&1

echo.
echo Esperando 2 segundos...
timeout /t 2 /nobreak >nul

echo.
echo Iniciando el servidor Spring Boot...
echo El servidor estara disponible en: http://localhost:8080
echo.
echo Presiona Ctrl+C para detener el servidor
echo ============================================
echo.

call mvnw.cmd spring-boot:run

pause

