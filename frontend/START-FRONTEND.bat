@echo off
echo.
echo ========================================
echo   INICIANDO FRONTEND ANGULAR
echo ========================================
echo.
cd /d "%~dp0"
echo Ubicacion: %CD%
echo.
echo Iniciando servidor de desarrollo...
echo URL: http://localhost:4200
echo.
call npm start

