-- Corregir la tabla cliente para que cliente_id sea AUTO_INCREMENT

USE reservas_canchas;

-- Ver estructura actual
DESCRIBE cliente;

-- Modificar la columna cliente_id para que sea AUTO_INCREMENT
ALTER TABLE cliente MODIFY COLUMN cliente_id BIGINT NOT NULL AUTO_INCREMENT;

-- Verificar cambio
DESCRIBE cliente;

-- Mostrar índices para confirmar
SHOW INDEX FROM cliente;

