-- Verificar estructura actual de la tabla reserva
USE reservas_canchas;

-- Ver todas las columnas
DESCRIBE reserva;

-- Ver si hay restricciones o índices problemáticos
SHOW CREATE TABLE reserva;

-- Intentar insertar una reserva de prueba directamente
INSERT INTO reserva (
    cancha_id,
    nombre_cliente,
    apellido_cliente,
    email_cliente,
    telefono_cliente,
    rut_cliente,
    fecha_hora_inicio,
    fecha_hora_fin,
    monto_total,
    tipo_pago,
    estado
) VALUES (
    1,
    'Test',
    'Usuario',
    'test@test.com',
    '912345678',
    '12345678-9',
    '2026-01-23 15:00:00',
    '2026-01-23 16:00:00',
    7.0,
    'efectivo',
    'CONFIRMADA'
);

-- Ver si se insertó
SELECT * FROM reserva ORDER BY reserva_id DESC LIMIT 1;

