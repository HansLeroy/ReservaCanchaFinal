-- Corregir la tabla cliente eliminando la columna duplicada cliente_id

USE reservas_canchas;

-- Ver estructura actual
DESCRIBE cliente;

-- Eliminar la columna cliente_id duplicada (la que NO es PRIMARY KEY)
ALTER TABLE cliente DROP COLUMN cliente_id;

-- Verificar que quedó solo la columna id
DESCRIBE cliente;

