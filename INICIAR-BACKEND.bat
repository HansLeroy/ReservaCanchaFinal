@echo off
echo ===============================================
echo      INICIANDO BACKEND - ReservaCancha
echo ===============================================
echo.

REM Verificar MySQL
echo [1/3] Verificando MySQL...
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo    × MySQL NO esta corriendo
    echo.
    echo    Inicia MySQL primero:
    echo    1. Windows + R
    echo    2. Escribe: services.msc
    echo    3. Busca: MySQL80
    echo    4. Clic derecho - Iniciar
    echo.
    pause
    exit /b 1
) else (
    echo    √ MySQL OK
)

echo.
echo [2/3] Iniciando Backend Spring Boot...
echo       Por favor espera 30-40 segundos...
echo       NO cierres esta ventana.
echo.

cd /d C:\Users\hafer\IdeaProjects\ReservaCancha\backend
java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar

echo.
echo × El backend se detuvo
pause

