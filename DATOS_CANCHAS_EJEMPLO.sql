-- ================================================================
-- SCRIPT: INSERTAR CANCHAS DE EJEMPLO
-- Base de Datos: reservas_canchas
-- Fecha: 23 de Enero de 2026
-- ================================================================

USE reservas_canchas;

-- Limpiar tabla de canchas (opcional - comentar si no quieres borrar)
-- DELETE FROM cancha;
-- ALTER TABLE cancha AUTO_INCREMENT = 1;

-- ================================================================
-- CANCHAS DE FÚTBOL
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Fútbol 5 - Los Pinos', 'Fútbol 5', 'Cancha de pasto sintético, iluminación LED, vestuarios con duchas. Ideal para partidos entre amigos.', 25000, TRUE),
('Cancha Fútbol 7 - El Estadio', 'Fútbol 7', 'Pasto sintético premium, marcación profesional, graderías para espectadores, tablero electrónico.', 35000, TRUE),
('Cancha Fútbol 11 - Arena Pro', 'Fútbol 11', 'Cancha reglamentaria tamaño FIFA, pasto sintético importado, camerinos amplios, zona de prensa.', 50000, TRUE),
('Cancha Fútbol 5 - La Bombonera', 'Fútbol 5', 'Pasto sintético, techo parcial, ideal para clima lluvioso. Incluye estacionamiento.', 28000, TRUE);

-- ================================================================
-- CANCHAS DE TENIS
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Tenis Central', 'Tenis', 'Cancha de arcilla profesional, red reglamentaria, iluminación nocturna. Incluye préstamo de raquetas.', 20000, TRUE),
('Cancha Tenis Court 2', 'Tenis', 'Superficie dura tipo US Open, graderías para 50 personas, marcador electrónico.', 22000, TRUE),
('Cancha Tenis Mini', 'Tenis', 'Cancha de práctica, ideal para clases y entrenamientos. Muro de práctica incluido.', 15000, TRUE);

-- ================================================================
-- CANCHAS DE PÁDEL
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Pádel Court 1 - Vista Hermosa', 'Pádel', 'Cancha panorámica de cristal templado, pasto sintético de última generación, iluminación LED.', 18000, TRUE),
('Pádel Court 2 - Indoor', 'Pádel', 'Cancha techada climatizada, ideal para todo clima. Incluye casilleros y duchas.', 22000, TRUE),
('Pádel Court 3 - Profesional', 'Pádel', 'Cancha homologada FIP, utilizada para torneos. Graderías para 100 personas.', 25000, TRUE);

-- ================================================================
-- CANCHAS DE BÁSQUETBOL
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Básquetbol NBA Style', 'Básquetbol', 'Duela profesional maple, tableros Spalding con aros anti-vandálico, graderías retráctiles.', 30000, TRUE),
('Cancha Básquetbol Street', 'Básquetbol', 'Superficie de concreto pulido, aro doble altura, ideal para práctica y juego 3x3.', 20000, TRUE),
('Cancha Básquetbol Indoor', 'Básquetbol', 'Multicancha techada, también sirve para volleyball. Sistema de ventilación y sonido.', 28000, TRUE);

-- ================================================================
-- CANCHAS DE VOLLEYBALL
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Volleyball de Arena', 'Volleyball', 'Arena de playa profesional importada, red reglamentaria, gradas para 80 personas.', 18000, TRUE),
('Cancha Volleyball Indoor', 'Volleyball', 'Duela sintética amortiguada, techo alto 10m, iluminación profesional para transmisiones.', 25000, TRUE);

-- ================================================================
-- CANCHAS EN MANTENIMIENTO (Desactivadas)
-- ================================================================

INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Fútbol 7 - En Remodelación', 'Fútbol 7', 'Actualmente en proceso de cambio de pasto sintético. Disponible desde febrero 2026.', 35000, FALSE),
('Pádel Court 4 - Mantenimiento', 'Pádel', 'En reparación de cristales laterales. Vuelve en servicio en una semana.', 20000, FALSE);

-- ================================================================
-- VERIFICACIÓN
-- ================================================================

-- Ver todas las canchas insertadas
SELECT
    cancha_id AS 'ID',
    nombre AS 'Nombre',
    tipo AS 'Deporte',
    precio_por_hora AS 'Precio/Hora',
    CASE WHEN disponible = 1 THEN '✅ Disponible' ELSE '🔴 Mantenimiento' END AS 'Estado'
FROM cancha
ORDER BY tipo, nombre;

-- Resumen por deporte
SELECT
    tipo AS 'Deporte',
    COUNT(*) AS 'Total Canchas',
    SUM(CASE WHEN disponible = 1 THEN 1 ELSE 0 END) AS 'Disponibles',
    SUM(CASE WHEN disponible = 0 THEN 1 ELSE 0 END) AS 'En Mantenimiento',
    CONCAT('$', FORMAT(AVG(precio_por_hora), 0)) AS 'Precio Promedio'
FROM cancha
GROUP BY tipo
ORDER BY tipo;

-- ================================================================
-- NOTAS:
-- ================================================================
--
-- Este script inserta 16 canchas de ejemplo:
--   - 4 de Fútbol (5, 7 y 11)
--   - 3 de Tenis
--   - 3 de Pádel
--   - 3 de Básquetbol
--   - 2 de Volleyball
--   - 2 en mantenimiento (desactivadas)
--
-- Para ejecutar este script:
-- 1. Abre MySQL Workbench o línea de comandos
-- 2. Ejecuta: source DATOS_CANCHAS_EJEMPLO.sql
--    O copia y pega el contenido completo
--
-- ================================================================

