-- =====================================================
-- SCRIPT DE INICIALIZACIÓN DE BASE DE DATOS
-- Sistema de Reserva de Canchas Deportivas
-- =====================================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS reservas_canchas
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE reservas_canchas;

-- =====================================================
-- NOTA: Las tablas se crean automáticamente con Hibernate
-- usando spring.jpa.hibernate.ddl-auto=update
-- Este script solo incluye datos iniciales
-- =====================================================

-- =====================================================
-- DATOS INICIALES: USUARIOS
-- =====================================================
INSERT INTO usuario (nombre, apellido, email, password, rol, rut, telefono, activo) VALUES
('Admin', 'Sistema', 'admin@reservacancha.cl', 'admin123', 'ADMIN', '11111111-1', '912345678', true),
('Recepcionista', 'Principal', 'recepcion@reservacancha.cl', 'recep123', 'RECEPCIONISTA', '22222222-2', '923456789', true),
('Usuario', 'Demo', 'usuario@reservacancha.cl', 'usuario123', 'CLIENTE', '33333333-3', '934567890', true)
ON DUPLICATE KEY UPDATE nombre=nombre;

-- =====================================================
-- DATOS INICIALES: CLIENTES
-- =====================================================
INSERT INTO cliente (nombre, apellido, rut, email, telefono, direccion, activo, total_reservas, total_gastado) VALUES
('Juan', 'Pérez', '12345678-9', 'juan.perez@email.com', '+56912345678', 'Av. Principal 123', true, 0, 0.00),
('María', 'González', '98765432-1', 'maria.gonzalez@email.com', '+56987654321', 'Calle Secundaria 456', true, 0, 0.00),
('Pedro', 'López', '11223344-5', 'pedro.lopez@email.com', '+56911223344', 'Pasaje Norte 789', true, 0, 0.00)
ON DUPLICATE KEY UPDATE nombre=nombre;

-- =====================================================
-- DATOS INICIALES: CANCHAS
-- =====================================================
INSERT INTO cancha (nombre, tipo, descripcion, precio_por_hora, disponible) VALUES
('Cancha Fútbol 1', 'Fútbol 5', 'Cancha de pasto sintético, iluminada', 25000.00, true),
('Cancha Fútbol 2', 'Fútbol 7', 'Cancha de césped artificial con graderías', 35000.00, true),
('Cancha Tenis Central', 'Tenis', 'Cancha profesional con superficie dura', 20000.00, true),
('Cancha Básquetbol', 'Básquetbol', 'Cancha techada con piso de madera', 30000.00, true),
('Cancha Pádel 1', 'Pádel', 'Cancha con cristales panorámicos', 28000.00, true)
ON DUPLICATE KEY UPDATE nombre=nombre;

-- =====================================================
-- DATOS INICIALES: HORARIOS (Ejemplo para Cancha 1)
-- =====================================================
INSERT INTO horario (cancha_id, dia_semana, hora_apertura, hora_cierre, tarifa_por_hora, disponible, notas) VALUES
(1, 'LUNES', '08:00:00', '22:00:00', 25000.00, true, 'Horario normal de lunes'),
(1, 'MARTES', '08:00:00', '22:00:00', 25000.00, true, 'Horario normal de martes'),
(1, 'MIERCOLES', '08:00:00', '22:00:00', 25000.00, true, 'Horario normal de miércoles'),
(1, 'JUEVES', '08:00:00', '22:00:00', 25000.00, true, 'Horario normal de jueves'),
(1, 'VIERNES', '08:00:00', '23:00:00', 30000.00, true, 'Horario extendido viernes'),
(1, 'SABADO', '09:00:00', '23:00:00', 35000.00, true, 'Tarifa fin de semana'),
(1, 'DOMINGO', '09:00:00', '21:00:00', 35000.00, true, 'Tarifa fin de semana')
ON DUPLICATE KEY UPDATE dia_semana=dia_semana;

-- =====================================================
-- INSTRUCCIONES DE USO
-- =====================================================
--
-- Para ejecutar este script:
--
-- Opción 1: Desde línea de comandos MySQL
--   mysql -u root -p < init-database.sql
--
-- Opción 2: Desde MySQL Workbench
--   File > Open SQL Script > Seleccionar este archivo > Execute
--
-- Opción 3: Desde terminal MySQL
--   mysql -u root -p
--   source /ruta/completa/init-database.sql
--
-- NOTA: Asegúrate de tener MySQL corriendo en puerto 3306
-- y que las credenciales en application.properties coincidan
-- =====================================================

-- =====================================================
-- VERIFICACIÓN DE DATOS
-- =====================================================
SELECT 'Usuarios insertados:' as Info, COUNT(*) as Total FROM usuario;
SELECT 'Clientes insertados:' as Info, COUNT(*) as Total FROM cliente;
SELECT 'Canchas insertadas:' as Info, COUNT(*) as Total FROM cancha;
SELECT 'Horarios insertados:' as Info, COUNT(*) as Total FROM horario;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================

