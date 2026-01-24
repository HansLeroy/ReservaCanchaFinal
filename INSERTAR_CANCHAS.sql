-- Script para insertar canchas de ejemplo
-- 2 de fútbol, 1 de tenis, 1 de pádel

USE reservas_canchas;

-- Eliminar canchas existentes si las hay (opcional)
-- DELETE FROM cancha;

-- Insertar las 4 canchas
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha de Fútbol 1', 'FUTBOL_11', 'Cancha de fútbol con césped sintético', 15000, 1),
('Cancha de Fútbol 2', 'FUTBOL_11', 'Cancha de fútbol profesional', 15000, 1),
('Cancha de Tenis 1', 'TENIS', 'Cancha de tenis con superficie dura', 10000, 1),
('Cancha de Pádel 1', 'PADEL', 'Cancha de pádel profesional', 20000, 1);

-- Verificar las canchas insertadas
SELECT * FROM cancha;

