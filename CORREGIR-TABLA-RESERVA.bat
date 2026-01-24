@echo off
title CORREGIR TABLA RESERVA - MySQL
color 0E
echo ========================================
echo   CORRECCION TABLA RESERVA
echo ========================================
echo.
echo Este script eliminara la columna usuario_id
echo de la tabla reserva en MySQL.
echo.
echo IMPORTANTE: Asegurate de que MySQL este corriendo.
echo.
pause

echo.
echo Ejecutando correccion...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pHans199303. -D reservas_canchas -e "ALTER TABLE reserva DROP COLUMN IF EXISTS usuario_id; DESCRIBE reserva;"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   CORRECCION EXITOSA
    echo ========================================
    echo.
    echo La columna usuario_id ha sido eliminada.
    echo Ahora reinicia el backend.
    echo.
) else (
    echo.
    echo ========================================
    echo   ERROR
    echo ========================================
    echo.
    echo No se pudo conectar a MySQL o ejecutar el comando.
    echo Verifica:
    echo 1. MySQL esta corriendo
    echo 2. La contrasena es correcta
    echo 3. La base de datos 'reservas_canchas' existe
    echo.
)

pause

