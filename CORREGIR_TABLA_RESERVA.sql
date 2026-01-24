-- Script para corregir la tabla reserva con AUTO_INCREMENT
-- Ejecutar este script en MySQL Workbench

USE reservas_canchas;

-- Modificar la columna reserva_id para que sea AUTO_INCREMENT
ALTER TABLE reserva
MODIFY COLUMN reserva_id BIGINT NOT NULL AUTO_INCREMENT;

-- Verificar la estructura
DESCRIBE reserva;

-- Ver las foreign keys
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    TABLE_SCHEMA = 'reservas_canchas'
    AND TABLE_NAME = 'reserva'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

