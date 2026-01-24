-- ========================================
-- CREAR USUARIO ADMINISTRADOR
-- ========================================
-- Ejecuta este script en MySQL Workbench

USE reservas_canchas;

-- Insertar usuario administrador con todos los privilegios
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES (
    '11111111-1',                      -- RUT del administrador
    'Administrador',                   -- Nombre
    'Sistema',                         -- Apellido
    'admin@reservacancha.com',         -- Email
    'admin123',                        -- Password (en producción debería estar encriptada)
    '+56912345678',                    -- Teléfono
    'ADMIN',                           -- Rol con todos los permisos
    TRUE                               -- Usuario activo
);

-- Verificar que se creó correctamente
SELECT * FROM usuario WHERE email = 'admin@reservacancha.com';

-- ========================================
-- CREDENCIALES DEL USUARIO ADMINISTRADOR
-- ========================================
-- Email:    admin@reservacancha.com
-- Password: admin123
-- Rol:      ADMIN (acceso completo al sistema)
-- Estado:   Activo
-- ========================================

-- Opcional: Crear más usuarios de prueba

-- Usuario Recepcionista
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES (
    '22222222-2',
    'María',
    'González',
    'recepcion@reservacancha.com',
    'recepcion123',
    '+56987654321',
    'RECEPCIONISTA',
    TRUE
);

-- Usuario Cliente
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES (
    '33333333-3',
    'Juan',
    'Pérez',
    'cliente@reservacancha.com',
    'cliente123',
    '+56911111111',
    'CLIENTE',
    TRUE
);

-- Ver todos los usuarios creados
SELECT usuario_id, rut, nombre, apellido, email, rol, activo
FROM usuario
ORDER BY usuario_id;

