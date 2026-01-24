-- =====================================================
-- Script para insertar canchas iniciales
-- Fecha: 2026-01-23
-- =====================================================

USE reservas_canchas;

-- Eliminar canchas existentes si las hay
DELETE FROM reserva;
DELETE FROM cancha;

-- Resetear el auto_increment
ALTER TABLE cancha AUTO_INCREMENT = 1;

-- =====================================================
-- Insertar 4 canchas: 2 Fútbol, 1 Tenis, 1 Pádel
-- =====================================================

-- Cancha 1: Fútbol 5
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible)
VALUES (
    'Cancha de Fútbol 5 - Norte',
    'FUTBOL_5',
    'Cancha de fútbol 5 con pasto sintético de última generación. Incluye iluminación LED y graderías.',
    15000.0,
    true
);

-- Cancha 2: Fútbol 7
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible)
VALUES (
    'Cancha de Fútbol 7 - Sur',
    'FUTBOL_7',
    'Cancha de fútbol 7 con pasto sintético premium. Cuenta con vestuarios y estacionamiento.',
    15000.0,
    true
);

-- Cancha 3: Tenis
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible)
VALUES (
    'Cancha de Tenis Central',
    'TENIS',
    'Cancha de tenis profesional con superficie dura tipo Plexicushion. Incluye red regulable y marcador electrónico.',
    10000.0,
    true
);

-- Cancha 4: Pádel
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible)
VALUES (
    'Cancha de Pádel Premium',
    'PADEL',
    'Cancha de pádel con cristales panorámicos y césped sintético de alta calidad. Iluminación profesional.',
    20000.0,
    true
);

-- =====================================================
-- Verificar las canchas insertadas
-- =====================================================
SELECT
    cancha_id,
    nombre,
    tipo,
    precio_por_hora,
    disponible
FROM cancha
ORDER BY cancha_id;

-- Mostrar resumen
SELECT
    COUNT(*) as total_canchas,
    SUM(CASE WHEN tipo LIKE 'FUTBOL%' THEN 1 ELSE 0 END) as canchas_futbol,
    SUM(CASE WHEN tipo = 'TENIS' THEN 1 ELSE 0 END) as canchas_tenis,
    SUM(CASE WHEN tipo = 'PADEL' THEN 1 ELSE 0 END) as canchas_padel
FROM cancha;

-- =====================================================
-- Resultado esperado:
--
-- cancha_id | nombre                          | tipo      | precio | disponible
-- ----------|--------------------------------|-----------|--------|------------
-- 1         | Cancha de Fútbol 5 - Norte     | FUTBOL_5  | 15000  | true
-- 2         | Cancha de Fútbol 7 - Sur       | FUTBOL_7  | 15000  | true
-- 3         | Cancha de Tenis Central        | TENIS     | 10000  | true
-- 4         | Cancha de Pádel Premium        | PADEL     | 20000  | true
-- =====================================================

