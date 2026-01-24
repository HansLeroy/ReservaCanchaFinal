@echo off
echo ================================================
echo  INSERTAR CANCHAS INICIALES
echo ================================================
echo.
echo Insertando 4 canchas en la base de datos:
echo - 2 Canchas de Futbol (15.000 CLP/hora)
echo - 1 Cancha de Tenis (10.000 CLP/hora)
echo - 1 Cancha de Padel (20.000 CLP/hora)
echo.

mysql -u root -proot reservas_canchas < INSERTAR_CANCHAS_INICIAL.sql

echo.
echo ================================================
echo  VERIFICANDO CANCHAS INSERTADAS
echo ================================================
echo.

mysql -u root -proot -e "USE reservas_canchas; SELECT cancha_id as ID, nombre as 'Nombre de Cancha', tipo as Tipo, precio_por_hora as 'Precio/Hora', CASE WHEN disponible=1 THEN 'Si' ELSE 'No' END as Disponible FROM cancha ORDER BY cancha_id;"

echo.
echo ================================================
echo  LISTO! Canchas insertadas correctamente
echo ================================================
echo.
pause

