go-- ============================================
-- EJECUTAR ESTE SCRIPT EN MYSQL WORKBENCH
-- ============================================
USE reservas_canchas;

-- Agregar campos de check-in y pago pendiente a la tabla reserva
ALTER TABLE reserva
ADD COLUMN pago_completado BOOLEAN DEFAULT FALSE COMMENT 'Indica si el pago fue completado',
ADD COLUMN fecha_pago DATETIME NULL COMMENT 'Fecha y hora en que se realizó el pago',
ADD COLUMN check_in_realizado BOOLEAN DEFAULT FALSE COMMENT 'Indica si el cliente hizo check-in',
ADD COLUMN fecha_check_in DATETIME NULL COMMENT 'Fecha y hora en que se realizó el check-in',
ADD COLUMN metodo_pago_checkin VARCHAR(50) NULL COMMENT 'Método de pago usado en check-in (efectivo, tarjeta, etc.)',
ADD COLUMN monto_pagado DECIMAL(10,2) NULL COMMENT 'Monto pagado en el check-in';

-- Verificar que se agregaron correctamente
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'reservas_canchas'
    AND TABLE_NAME = 'reserva'
    AND COLUMN_NAME IN ('pago_completado', 'fecha_pago', 'check_in_realizado', 'fecha_check_in', 'metodo_pago_checkin', 'monto_pagado');

