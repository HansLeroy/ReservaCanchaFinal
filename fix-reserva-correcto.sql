-- Script correcto para eliminar la columna usuario_id
-- MySQL no soporta "IF EXISTS" en DROP COLUMN

USE reservas_canchas;

-- Eliminar la columna usuario_id (sin IF EXISTS)
ALTER TABLE reserva DROP COLUMN usuario_id;

-- Verificar que se eliminó
DESCRIBE reserva;

