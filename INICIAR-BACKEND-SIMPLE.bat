@echo off
cd /d "%~dp0backend"
echo ========================================
echo   Iniciando Backend ReservaCancha
echo ========================================
echo.
echo Limpiando procesos anteriores...
taskkill /F /IM java.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Compilando el proyecto...
call mvnw.cmd clean package -DskipTests

echo.
echo Iniciando el servidor...
java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar
pause

