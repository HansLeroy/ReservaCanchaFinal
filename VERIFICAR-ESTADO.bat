@echo off
echo ========================================
echo   VERIFICAR ESTADO DEL SISTEMA
echo ========================================
echo.

echo Verificando MySQL...
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    echo   [OK] MySQL corriendo
) else (
    echo   [X] MySQL NO corriendo
)

echo.
echo Verificando Backend...
netstat -ano | findstr ":8080" | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    echo   [OK] Backend corriendo
    echo.
    echo ========================================
    echo   SISTEMA LISTO PARA CREAR RESERVAS
    echo ========================================
    echo.
    echo Puedes crear tu reserva:
    echo 1. Recarga la pagina (F5)
    echo 2. Haz clic en 'Confirmar Reserva'
    echo.
) else (
    echo   [X] Backend NO corriendo
    echo.
    echo El backend debe estar corriendo para crear reservas.
    echo Busca la ventana: "BACKEND SPRING BOOT - NO CERRAR"
    echo.
)

echo.
echo Verificando Frontend...
netstat -ano | findstr ":4200" | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    echo   [OK] Frontend corriendo
) else (
    echo   [X] Frontend NO corriendo
)

echo.
pause

