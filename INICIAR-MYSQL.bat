@echo off
echo ===============================================
echo    INICIAR MySQL PARA ReservaCancha
echo ===============================================
echo.

echo Intentando iniciar MySQL...
net start MySQL80

if %errorlevel% equ 0 (
    echo.
    echo ✓ MySQL iniciado correctamente!
    echo.
    echo Ahora puedes ejecutar: INICIAR-SISTEMA-COMPLETO-NUEVO.ps1
    echo.
) else (
    echo.
    echo × Error al iniciar MySQL
    echo.
    echo Posibles soluciones:
    echo 1. Ejecuta este archivo como Administrador
    echo 2. Verifica que MySQL este instalado
    echo 3. El servicio puede tener otro nombre (MySQL, MySQL 8.0, etc)
    echo.
)

pause

