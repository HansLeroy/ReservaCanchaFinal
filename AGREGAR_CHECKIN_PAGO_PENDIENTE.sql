-- Script para agregar funcionalidad de Check-in y Pago Pendiente
-- Ejecutar este script en MySQL Workbench

USE reservas_canchas;

-- Agregar columnas para el sistema de check-in y pago pendiente
ALTER TABLE reserva
ADD COLUMN pago_completado BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Indica si el pago está completado',
ADD COLUMN fecha_pago DATETIME NULL COMMENT 'Fecha y hora en que se completó el pago',
ADD COLUMN check_in_realizado BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Indica si el cliente hizo check-in',
ADD COLUMN fecha_check_in DATETIME NULL COMMENT 'Fecha y hora del check-in',
ADD COLUMN metodo_pago_checkin VARCHAR(50) NULL COMMENT 'Método de pago usado en el check-in',
ADD COLUMN monto_pagado DECIMAL(10,2) NULL COMMENT 'Monto pagado en el check-in';

-- Actualizar las reservas existentes para marcar pagos como completados
UPDATE reserva
SET pago_completado = TRUE,
    fecha_pago = NOW()
WHERE estado IN ('CONFIRMADA', 'EN_USO', 'FINALIZADA');

-- Verificar la estructura actualizada
DESCRIBE reserva;

-- Crear un nuevo estado para reservas con pago pendiente
-- Los estados ahora serán:
-- 'PENDIENTE_PAGO' - Reserva creada por teléfono, esperando pago
-- 'CONFIRMADA' - Pago completado, esperando check-in
-- 'EN_USO' - Cliente hizo check-in y está usando la cancha
-- 'FINALIZADA' - Reserva completada
-- 'CANCELADA' - Reserva cancelada

SELECT * FROM reserva LIMIT 5;

