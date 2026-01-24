@echo off
echo =====================================
echo VERIFICAR Y CREAR USUARIO ADMIN
echo =====================================
echo.

echo Verificando estado del backend...
echo.
curl -s https://reservacancha-backend.onrender.com/api/init/status

echo.
echo.
echo =====================================
echo.
echo Creando usuario administrador...
echo.
curl -s https://reservacancha-backend.onrender.com/api/init/admin

echo.
echo.
echo =====================================
echo CREDENCIALES PARA LOGIN:
echo Email: admin@reservacancha.com
echo Password: admin123
echo =====================================
echo.
pause

