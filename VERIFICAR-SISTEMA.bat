@echo off
title VERIFICACION DEL SISTEMA
color 0A
echo ========================================
echo   VERIFICACION DEL SISTEMA
echo ========================================
echo.

echo [1/4] Verificando MySQL...
sc query MySQL80 | findstr "RUNNING" >nul
if %errorlevel% equ 0 (
    echo   [OK] MySQL esta corriendo
) else (
    echo   [X] MySQL NO esta corriendo
    echo   Ejecuta: net start MySQL80
)
echo.

echo [2/4] Verificando proceso Java...
tasklist | findstr "java.exe" >nul
if %errorlevel% equ 0 (
    echo   [OK] Java esta corriendo
) else (
    echo   [X] Java NO esta corriendo
    echo   El backend no esta iniciado
)
echo.

echo [3/4] Verificando puerto 8080...
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    echo   [OK] Puerto 8080 esta escuchando
) else (
    echo   [X] Puerto 8080 NO esta escuchando
    echo   El backend no esta listo
)
echo.

echo [4/4] Probando conexion HTTP...
powershell -Command "try { $r = Invoke-RestMethod -Uri 'http://localhost:8080/api/canchas' -TimeoutSec 5; Write-Host '  [OK] Backend responde - Canchas:' $r.Count -ForegroundColor Green } catch { Write-Host '  [X] Backend no responde' -ForegroundColor Red }"
echo.

echo ========================================
echo   INSTRUCCIONES
echo ========================================
echo.
echo Si TODO esta [OK]:
echo   1. Ve a http://localhost:4200
echo   2. Presiona F5
echo   3. Intenta crear una reserva
echo.
echo Si algo esta [X]:
echo   1. Abre: INICIAR-BACKEND-CORREGIDO.ps1
echo   2. Espera 2-3 minutos
echo   3. Ejecuta este script de nuevo
echo.
pause

