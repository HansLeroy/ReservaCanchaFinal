USE reservas_canchas;

-- SOLUCIÓN DEFINITIVA: Eliminar y recrear la tabla reserva correctamente

-- Paso 1: Eliminar la tabla reserva
DROP TABLE IF EXISTS reserva;

-- Paso 2: Crear la tabla reserva con la estructura correcta
CREATE TABLE reserva (
    reserva_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cancha_id BIGINT NOT NULL,
    cliente_id VARCHAR(12) NOT NULL,
    fecha_hora_inicio DATETIME(6) NOT NULL,
    fecha_hora_fin DATETIME(6),
    monto_total DOUBLE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    tipo_pago VARCHAR(50),
    nombre_cliente VARCHAR(100),
    apellido_cliente VARCHAR(100),
    rut_cliente VARCHAR(12),
    email_cliente VARCHAR(255),
    telefono_cliente VARCHAR(15),
    CONSTRAINT FK_reserva_cancha FOREIGN KEY (cancha_id) REFERENCES cancha(cancha_id),
    CONSTRAINT FK_reserva_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(rut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Paso 3: Verificar la estructura
DESCRIBE reserva;

-- Paso 4: Mostrar las claves foráneas
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    TABLE_SCHEMA = 'reservas_canchas'
    AND TABLE_NAME = 'reserva'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

