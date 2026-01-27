-- =====================================================
-- SCRIPT DE OPTIMIZACION PARA LOGIN
-- Ejecutar este script en MySQL para mejorar rendimiento
-- =====================================================

USE reservas_canchas;

-- Verificar índices actuales en la tabla usuario
SHOW INDEX FROM usuario;

-- Crear índice en columna email si no existe (acelera findByEmail)
-- Nota: Si la columna ya tiene UNIQUE constraint, el índice ya existe
ALTER TABLE usuario ADD INDEX IF NOT EXISTS idx_usuario_email (email);

-- Crear índice en columna rut si no existe
ALTER TABLE usuario ADD INDEX IF NOT EXISTS idx_usuario_rut (rut);

-- Verificar que los índices se crearon correctamente
SHOW INDEX FROM usuario;

-- Probar el plan de ejecución de la consulta de login
EXPLAIN SELECT * FROM usuario WHERE email = 'usuario@reservacancha.cl';

-- El resultado debe mostrar que usa el índice idx_usuario_email
-- Si dice "type: ref" y "key: idx_usuario_email" está optimizado
-- Si dice "type: ALL" significa que hace full table scan (lento)

-- OPCIONAL: Analizar tabla para optimizar estadísticas
ANALYZE TABLE usuario;

-- OPCIONAL: Ver estadísticas de la tabla
SHOW TABLE STATUS LIKE 'usuario';

