-- Script para verificar y corregir la estructura de la tabla reserva

-- Ver estructura actual
DESCRIBE reserva;

-- Si existe la columna usuario_id, eliminarla
ALTER TABLE reserva DROP COLUMN IF EXISTS usuario_id;

-- Verificar que se eliminó
DESCRIBE reserva;

-- Ver registros existentes
SELECT COUNT(*) as total_reservas FROM reserva;

