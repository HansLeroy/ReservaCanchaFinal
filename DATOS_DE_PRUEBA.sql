# 📊 DATOS DE PRUEBA PARA EL SISTEMA

## 🏟️ CANCHAS DE EJEMPLO

Ejecuta esto en MySQL Workbench para crear canchas de prueba:

```sql
USE reservas_canchas;

-- Crear 3 canchas de diferentes tipos
INSERT INTO cancha (nombre, tipo, disponible, precio_por_hora) VALUES
('Cancha 1 - Fútbol 11', 'Fútbol 11', TRUE, 25000.00),
('Cancha 2 - Fútbol 7', 'Fútbol 7', TRUE, 18000.00),
('Cancha 3 - Fútbol 5', 'Fútbol 5', TRUE, 12000.00),
('Cancha 4 - Tenis', 'Tenis', TRUE, 10000.00),
('Cancha 5 - Paddle', 'Paddle', TRUE, 8000.00);

-- Verificar que se crearon
SELECT * FROM cancha;
```

---

## ⏰ HORARIOS PARA LAS CANCHAS

```sql
-- Horarios para Cancha 1 (Fútbol 11)
INSERT INTO horario (cancha_id, dia_semana, hora_inicio, hora_fin, disponible) VALUES
(1, 'LUNES', '09:00:00', '22:00:00', TRUE),
(1, 'MARTES', '09:00:00', '22:00:00', TRUE),
(1, 'MIERCOLES', '09:00:00', '22:00:00', TRUE),
(1, 'JUEVES', '09:00:00', '22:00:00', TRUE),
(1, 'VIERNES', '09:00:00', '23:00:00', TRUE),
(1, 'SABADO', '08:00:00', '23:00:00', TRUE),
(1, 'DOMINGO', '08:00:00', '22:00:00', TRUE);

-- Horarios para Cancha 2 (Fútbol 7)
INSERT INTO horario (cancha_id, dia_semana, hora_inicio, hora_fin, disponible) VALUES
(2, 'LUNES', '10:00:00', '21:00:00', TRUE),
(2, 'MARTES', '10:00:00', '21:00:00', TRUE),
(2, 'MIERCOLES', '10:00:00', '21:00:00', TRUE),
(2, 'JUEVES', '10:00:00', '21:00:00', TRUE),
(2, 'VIERNES', '10:00:00', '22:00:00', TRUE),
(2, 'SABADO', '09:00:00', '22:00:00', TRUE),
(2, 'DOMINGO', '09:00:00', '21:00:00', TRUE);

-- Horarios para Cancha 3 (Fútbol 5)
INSERT INTO horario (cancha_id, dia_semana, hora_inicio, hora_fin, disponible) VALUES
(3, 'LUNES', '10:00:00', '22:00:00', TRUE),
(3, 'MARTES', '10:00:00', '22:00:00', TRUE),
(3, 'MIERCOLES', '10:00:00', '22:00:00', TRUE),
(3, 'JUEVES', '10:00:00', '22:00:00', TRUE),
(3, 'VIERNES', '10:00:00', '23:00:00', TRUE),
(3, 'SABADO', '09:00:00', '23:00:00', TRUE),
(3, 'DOMINGO', '09:00:00', '22:00:00', TRUE);

-- Verificar horarios
SELECT h.horario_id, c.nombre as cancha, h.dia_semana, h.hora_inicio, h.hora_fin, h.disponible
FROM horario h
JOIN cancha c ON h.cancha_id = c.cancha_id
ORDER BY c.cancha_id, h.horario_id;
```

---

## 👥 CLIENTES DE EJEMPLO

```sql
INSERT INTO cliente (rut, nombre, apellido, email, telefono, activo) VALUES
('11111111-1', 'Juan', 'Pérez', 'juan.perez@email.com', '+56911111111', TRUE),
('22222222-2', 'María', 'González', 'maria.gonzalez@email.com', '+56922222222', TRUE),
('33333333-3', 'Pedro', 'López', 'pedro.lopez@email.com', '+56933333333', TRUE),
('44444444-4', 'Ana', 'Martínez', 'ana.martinez@email.com', '+56944444444', TRUE),
('55555555-5', 'Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '+56955555555', TRUE);

-- Verificar clientes
SELECT * FROM cliente;
```

---

## 📅 RESERVAS DE EJEMPLO

```sql
-- Reserva 1: Juan Pérez - Cancha 1 - Hoy 18:00-19:00
INSERT INTO reserva (cancha_id, cliente_id, rut_cliente, fecha_hora_inicio, fecha_hora_fin, estado, precio_total)
VALUES (1, 1, '11111111-1', '2026-01-23 18:00:00', '2026-01-23 19:00:00', 'CONFIRMADA', 25000.00);

-- Reserva 2: María González - Cancha 2 - Mañana 20:00-21:00
INSERT INTO reserva (cancha_id, cliente_id, rut_cliente, fecha_hora_inicio, fecha_hora_fin, estado, precio_total)
VALUES (2, 2, '22222222-2', '2026-01-24 20:00:00', '2026-01-24 21:00:00', 'CONFIRMADA', 18000.00);

-- Reserva 3: Pedro López - Cancha 3 - Pasado mañana 19:00-20:00
INSERT INTO reserva (cancha_id, cliente_id, rut_cliente, fecha_hora_inicio, fecha_hora_fin, estado, precio_total)
VALUES (3, 3, '33333333-3', '2026-01-25 19:00:00', '2026-01-25 20:00:00', 'PENDIENTE', 12000.00);

-- Verificar reservas
SELECT r.reserva_id, c.nombre as cancha, cl.nombre as cliente, cl.apellido,
       r.fecha_hora_inicio, r.fecha_hora_fin, r.estado, r.precio_total
FROM reserva r
JOIN cancha c ON r.cancha_id = c.cancha_id
JOIN cliente cl ON r.cliente_id = cl.cliente_id
ORDER BY r.fecha_hora_inicio;
```

---

## 💳 PAGOS PARA LAS RESERVAS

```sql
-- Pago para Reserva 1 (COMPLETADO)
INSERT INTO pago (reserva_id, monto, fecha, metodo_pago, estado)
VALUES (1, 25000.00, '2026-01-23', 'EFECTIVO', 'COMPLETADO');

-- Pago para Reserva 2 (COMPLETADO)
INSERT INTO pago (reserva_id, monto, fecha, metodo_pago, estado)
VALUES (2, 18000.00, '2026-01-23', 'TRANSFERENCIA', 'COMPLETADO');

-- Pago para Reserva 3 (PENDIENTE)
INSERT INTO pago (reserva_id, monto, fecha, metodo_pago, estado)
VALUES (3, 12000.00, '2026-01-23', 'TARJETA', 'PENDIENTE');

-- Verificar pagos
SELECT p.pago_id, r.reserva_id, c.nombre as cancha,
       p.monto, p.fecha, p.metodo_pago, p.estado
FROM pago p
JOIN reserva r ON p.reserva_id = r.reserva_id
JOIN cancha c ON r.cancha_id = c.cancha_id
ORDER BY p.fecha;
```

---

## 👤 USUARIOS ADICIONALES

```sql
-- Usuario Recepcionista
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES ('99999999-9', 'Recepción', 'Principal', 'recepcion@reservacancha.com', 'recepcion123', '+56999999999', 'RECEPCIONISTA', TRUE);

-- Usuario Cliente (puede hacer reservas online)
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES ('88888888-8', 'Cliente', 'Online', 'cliente@reservacancha.com', 'cliente123', '+56988888888', 'CLIENTE', TRUE);

-- Verificar todos los usuarios
SELECT usuario_id, rut, nombre, apellido, email, rol, activo FROM usuario;
```

---

## 🔍 CONSULTAS ÚTILES

### Ver todas las canchas con sus horarios
```sql
SELECT c.nombre as Cancha, h.dia_semana as Dia,
       h.hora_inicio as Apertura, h.hora_fin as Cierre,
       c.precio_por_hora as Precio
FROM cancha c
LEFT JOIN horario h ON c.cancha_id = h.cancha_id
WHERE c.disponible = TRUE AND h.disponible = TRUE
ORDER BY c.cancha_id,
         FIELD(h.dia_semana, 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO');
```

### Ver todas las reservas con detalles completos
```sql
SELECT
    r.reserva_id,
    c.nombre as Cancha,
    CONCAT(cl.nombre, ' ', cl.apellido) as Cliente,
    cl.email as Email_Cliente,
    r.fecha_hora_inicio as Inicio,
    r.fecha_hora_fin as Fin,
    r.estado as Estado_Reserva,
    r.precio_total as Precio,
    p.metodo_pago as Metodo_Pago,
    p.estado as Estado_Pago
FROM reserva r
JOIN cancha c ON r.cancha_id = c.cancha_id
JOIN cliente cl ON r.cliente_id = cl.cliente_id
LEFT JOIN pago p ON r.reserva_id = p.reserva_id
ORDER BY r.fecha_hora_inicio DESC;
```

### Reporte de ingresos
```sql
SELECT
    DATE(p.fecha) as Fecha,
    COUNT(p.pago_id) as Total_Pagos,
    SUM(p.monto) as Ingresos_Totales,
    AVG(p.monto) as Promedio_Por_Pago
FROM pago p
WHERE p.estado = 'COMPLETADO'
GROUP BY DATE(p.fecha)
ORDER BY Fecha DESC;
```

### Canchas más reservadas
```sql
SELECT
    c.nombre as Cancha,
    COUNT(r.reserva_id) as Total_Reservas,
    SUM(r.precio_total) as Ingresos_Totales
FROM cancha c
LEFT JOIN reserva r ON c.cancha_id = r.cancha_id
GROUP BY c.cancha_id, c.nombre
ORDER BY Total_Reservas DESC;
```

---

## 🚀 SCRIPT COMPLETO (Todo en Uno)

Para cargar todos los datos de prueba de una vez:

```sql
USE reservas_canchas;

-- 1. Canchas
INSERT INTO cancha (nombre, tipo, disponible, precio_por_hora) VALUES
('Cancha 1 - Fútbol 11', 'Fútbol 11', TRUE, 25000.00),
('Cancha 2 - Fútbol 7', 'Fútbol 7', TRUE, 18000.00),
('Cancha 3 - Fútbol 5', 'Fútbol 5', TRUE, 12000.00);

-- 2. Horarios para las 3 canchas
INSERT INTO horario (cancha_id, dia_semana, hora_inicio, hora_fin, disponible) VALUES
(1, 'LUNES', '09:00:00', '22:00:00', TRUE),
(1, 'MARTES', '09:00:00', '22:00:00', TRUE),
(1, 'MIERCOLES', '09:00:00', '22:00:00', TRUE),
(1, 'JUEVES', '09:00:00', '22:00:00', TRUE),
(1, 'VIERNES', '09:00:00', '23:00:00', TRUE),
(1, 'SABADO', '08:00:00', '23:00:00', TRUE),
(1, 'DOMINGO', '08:00:00', '22:00:00', TRUE),
(2, 'LUNES', '10:00:00', '21:00:00', TRUE),
(2, 'MARTES', '10:00:00', '21:00:00', TRUE),
(2, 'MIERCOLES', '10:00:00', '21:00:00', TRUE),
(2, 'JUEVES', '10:00:00', '21:00:00', TRUE),
(2, 'VIERNES', '10:00:00', '22:00:00', TRUE),
(2, 'SABADO', '09:00:00', '22:00:00', TRUE),
(2, 'DOMINGO', '09:00:00', '21:00:00', TRUE),
(3, 'LUNES', '10:00:00', '22:00:00', TRUE),
(3, 'MARTES', '10:00:00', '22:00:00', TRUE),
(3, 'MIERCOLES', '10:00:00', '22:00:00', TRUE),
(3, 'JUEVES', '10:00:00', '22:00:00', TRUE),
(3, 'VIERNES', '10:00:00', '23:00:00', TRUE),
(3, 'SABADO', '09:00:00', '23:00:00', TRUE),
(3, 'DOMINGO', '09:00:00', '22:00:00', TRUE);

-- 3. Clientes
INSERT INTO cliente (rut, nombre, apellido, email, telefono, activo) VALUES
('11111111-1', 'Juan', 'Pérez', 'juan.perez@email.com', '+56911111111', TRUE),
('22222222-2', 'María', 'González', 'maria.gonzalez@email.com', '+56922222222', TRUE),
('33333333-3', 'Pedro', 'López', 'pedro.lopez@email.com', '+56933333333', TRUE);

-- 4. Reservas
INSERT INTO reserva (cancha_id, cliente_id, rut_cliente, fecha_hora_inicio, fecha_hora_fin, estado, precio_total) VALUES
(1, 1, '11111111-1', '2026-01-23 18:00:00', '2026-01-23 19:00:00', 'CONFIRMADA', 25000.00),
(2, 2, '22222222-2', '2026-01-24 20:00:00', '2026-01-24 21:00:00', 'CONFIRMADA', 18000.00),
(3, 3, '33333333-3', '2026-01-25 19:00:00', '2026-01-25 20:00:00', 'PENDIENTE', 12000.00);

-- 5. Pagos
INSERT INTO pago (reserva_id, monto, fecha, metodo_pago, estado) VALUES
(1, 25000.00, '2026-01-23', 'EFECTIVO', 'COMPLETADO'),
(2, 18000.00, '2026-01-23', 'TRANSFERENCIA', 'COMPLETADO'),
(3, 12000.00, '2026-01-23', 'TARJETA', 'PENDIENTE');

-- Verificación final
SELECT 'Canchas:', COUNT(*) FROM cancha;
SELECT 'Horarios:', COUNT(*) FROM horario;
SELECT 'Clientes:', COUNT(*) FROM cliente;
SELECT 'Reservas:', COUNT(*) FROM reserva;
SELECT 'Pagos:', COUNT(*) FROM pago;
```

---

## ✅ RESULTADO ESPERADO

Después de ejecutar todos los scripts tendrás:

- ✅ **3 Canchas** (Fútbol 11, 7 y 5)
- ✅ **21 Horarios** (7 días × 3 canchas)
- ✅ **3 Clientes** de prueba
- ✅ **3 Reservas** (confirmadas y pendientes)
- ✅ **3 Pagos** (completados y pendiente)
- ✅ **1 Usuario Admin** (ya creado)

**¡Tu sistema tendrá datos realistas para probar todas las funcionalidades!** 🎉

