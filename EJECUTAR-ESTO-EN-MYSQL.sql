-- SCRIPT COMPLETO PARA HACER RUT LA PRIMARY KEY DE CLIENTE

USE reservas_canchas;

-- Paso 1: Eliminar FOREIGN KEY constraint
ALTER TABLE reserva DROP FOREIGN KEY FK7cg2jiyn5cf6f6elccvb6963k;

-- Paso 2: Quitar AUTO_INCREMENT de id
ALTER TABLE cliente MODIFY COLUMN id BIGINT NOT NULL;

-- Paso 3: Eliminar PRIMARY KEY
ALTER TABLE cliente DROP PRIMARY KEY;

-- Paso 4: Eliminar columna id
ALTER TABLE cliente DROP COLUMN id;

-- Paso 5: Eliminar cliente_id si existe
ALTER TABLE cliente DROP COLUMN IF EXISTS cliente_id;

-- Paso 6: Hacer RUT la PRIMARY KEY
ALTER TABLE cliente ADD PRIMARY KEY (rut);

-- Paso 7: Modificar cliente_id en reserva a VARCHAR(12)
ALTER TABLE reserva MODIFY COLUMN cliente_id VARCHAR(12);

-- Paso 8: Verificar resultados
DESCRIBE cliente;
DESCRIBE reserva;

SELECT '✓ RUT ahora es PRIMARY KEY de cliente' as RESULTADO;

