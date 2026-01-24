@echo off
cls
echo ================================================
echo    INICIAR SISTEMA RESERVACANCHA COMPLETO
echo ================================================
echo.

REM Paso 1: Limpiar procesos
echo [1/5] Limpiando procesos anteriores...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
timeout /t 3 >nul
echo       OK

REM Paso 2: Verificar MySQL
echo.
echo [2/5] Verificando MySQL...
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo       MySQL NO esta corriendo
    echo       Inicia MySQL y vuelve a ejecutar este script
    pause
    exit /b 1
) else (
    echo       MySQL OK
)

REM Paso 3: Iniciar Backend
echo.
echo [3/5] Iniciando Backend...
cd /d "%~dp0backend"
start "BACKEND RESERVACANCHA" /MIN cmd /c "echo Backend iniciando... && java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar"
echo       Backend iniciando en ventana separada
echo       Esperando 45 segundos...
timeout /t 45 >nul

REM Paso 4: Verificar Backend
echo.
echo [4/5] Verificando Backend...
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo       Backend aun no esta listo
    echo       Verifica la ventana "BACKEND RESERVACANCHA"
) else (
    echo       Backend OK
)

REM Paso 5: Iniciar Frontend
echo.
echo [5/5] Iniciando Frontend...
cd /d "%~dp0frontend"
start "FRONTEND RESERVACANCHA" /MIN cmd /c "echo Frontend iniciando... && npm start"
echo       Frontend iniciando en ventana separada
echo       Esperando 35 segundos...
timeout /t 35 >nul

REM Verificacion final
echo.
echo ================================================
echo              VERIFICACION FINAL
echo ================================================
echo.

netstat -ano | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [X] MySQL: NO CORRIENDO
) else (
    echo [OK] MySQL: CORRIENDO
)

netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [X] Backend: NO CORRIENDO
) else (
    echo [OK] Backend: CORRIENDO
)

netstat -ano | findstr ":4200" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [X] Frontend: NO CORRIENDO
) else (
    echo [OK] Frontend: CORRIENDO
)

echo.
echo ================================================
echo.
echo Sistema iniciado.
echo Abre tu navegador en: http://localhost:4200
echo.
echo IMPORTANTE:
echo - NO cierres las ventanas "BACKEND" y "FRONTEND"
echo - Si algo fallo, verifica esas ventanas
echo.
pause

