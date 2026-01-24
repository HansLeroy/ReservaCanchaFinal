# 🔑 CREAR USUARIO ADMINISTRADOR EN RENDER (PostgreSQL)

## ⚠️ PROBLEMA
Te sale "Credenciales incorrectas" porque la base de datos PostgreSQL en Render está vacía, no tiene usuarios creados.

## ✅ SOLUCIÓN: Crear Usuario Admin

---

## OPCIÓN 1: Usar el Query Console de Render (MÁS FÁCIL)

### Paso 1: Ir a tu Base de Datos en Render

1. Ve a **https://dashboard.render.com/**
2. Busca tu base de datos PostgreSQL: **reservacancha**
3. Click en el nombre de la base de datos

### Paso 2: Abrir el Query Console

1. En la página de tu base de datos PostgreSQL
2. Busca y click en **"Connect"** o **"Query"** o **"PSQL Console"**
3. Se abrirá una consola web para ejecutar comandos SQL

### Paso 3: Ejecutar este Script SQL

Copia y pega este código completo en el Query Console:

```sql
-- Crear usuario administrador
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES (
    '11111111-1',
    'Administrador',
    'Sistema',
    'admin@reservacancha.com',
    'admin123',
    '+56912345678',
    'ADMIN',
    TRUE
);

-- Verificar que se creó
SELECT * FROM usuario WHERE email = 'admin@reservacancha.com';
```

### Paso 4: Presiona Enter o "Execute"

Deberías ver un mensaje como:
```
INSERT 0 1
```

---

## OPCIÓN 2: Usar psql desde tu Computadora (Avanzado)

Si prefieres usar tu terminal local:

### Paso 1: Obtener las Credenciales de Conexión

1. En Render, ve a tu base de datos PostgreSQL
2. Busca **"Connections"** → **"External Database URL"**
3. Copia el comando PSQL Connection String

Ejemplo:
```
PGPASSWORD=abc123xyz psql -h dpg-xxx.ohio-postgres.render.com -U reservacancha reservacancha
```

### Paso 2: Ejecutar en tu Terminal

Abre PowerShell o CMD y pega el comando que copiaste.

### Paso 3: Ejecutar el SQL

Una vez conectado, pega:
```sql
INSERT INTO usuario (rut, nombre, apellido, email, password, telefono, rol, activo)
VALUES ('11111111-1', 'Administrador', 'Sistema', 'admin@reservacancha.com', 'admin123', '+56912345678', 'ADMIN', TRUE);
```

---

## OPCIÓN 3: Crear un Endpoint de Inicialización (Automático)

Si las opciones anteriores son complicadas, puedo crear un endpoint especial que cree el usuario automáticamente la primera vez.

---

## 🎯 CREDENCIALES DEL ADMINISTRADOR

Después de ejecutar el script, usa estas credenciales para iniciar sesión:

```
📧 Email:    admin@reservacancha.com
🔒 Password: admin123
👤 Rol:      ADMIN (acceso completo)
```

---

## ✅ VERIFICAR QUE FUNCIONÓ

### Paso 1: Ir a tu aplicación
```
https://reservacancha-frontend.onrender.com
```

### Paso 2: Iniciar Sesión
- Email: `admin@reservacancha.com`
- Password: `admin123`

### Paso 3: Deberías:
✅ Ver el mensaje "Inicio de sesión exitoso"  
✅ Ser redirigido al panel de administración  
✅ Ver el menú completo del sistema

---

## 🆘 SI AÚN NO FUNCIONA

### Error: "INSERT command denied"
- La tabla `usuario` no existe aún
- Verifica que el backend se haya desplegado correctamente
- Revisa los logs del backend, debería decir "Started ReservaCanchaBackendApplication"

### Error: "relation 'usuario' does not exist"
- Hibernate no ha creado las tablas automáticamente
- Verifica que `spring.jpa.hibernate.ddl-auto=update` esté en application-prod.properties
- Redespliega el backend y espera a que inicie completamente

### Solución Alternativa: Forzar Creación de Tablas

Si las tablas no se crean automáticamente, ejecuta primero esto en el Query Console:

```sql
-- Ver las tablas existentes
\dt

-- Si no hay tablas, espera a que el backend se despliegue completamente
-- Las tablas se crean automáticamente cuando el backend inicia por primera vez
```

---

## 📝 NOTAS IMPORTANTES

1. **Seguridad**: La contraseña `admin123` es temporal. Cámbiala después del primer login.

2. **Tablas Automáticas**: Las tablas se crean automáticamente gracias a Hibernate cuando el backend inicia por primera vez.

3. **Primera vez**: Si esta es la primera vez que despligas, espera 1-2 minutos después de que el backend diga "Started" antes de intentar crear el usuario.

---

## 🎉 RESULTADO ESPERADO

Después de crear el usuario:

✅ Login con `admin@reservacancha.com` / `admin123` funciona  
✅ Acceso completo al panel de administración  
✅ Puedes crear canchas, ver reservas, gestionar usuarios

---

**¿Cuál opción prefieres usar?**
- **Opción 1** es la más fácil (Query Console en Render)
- **Opción 2** si te sientes cómodo con terminal
- **Opción 3** si quieres que lo automatice con código

