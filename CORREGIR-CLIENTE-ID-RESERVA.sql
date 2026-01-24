-- SOLUCIÓN FINAL: Corregir columna cliente_id en tabla reserva

USE reservas_canchas;

-- Ver estructura actual de la tabla reserva
DESCRIBE reserva;

-- Modificar cliente_id para que sea VARCHAR(12) y permita almacenar el RUT completo
ALTER TABLE reserva MODIFY COLUMN cliente_id VARCHAR(12);

-- Verificar el cambio
DESCRIBE reserva;

SELECT 'Columna cliente_id modificada correctamente a VARCHAR(12)' as RESULTADO;

