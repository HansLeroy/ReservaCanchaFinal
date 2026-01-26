# 🔧 Configuración de Base de Datos en Render

## ✅ Solución Implementada

Se ha corregido el error de conexión a PostgreSQL que mostraba:
```
Driver org.postgresql.Driver claims to not accept jdbcUrl, postgresql://...
```

El problema ocurría porque Render proporciona URLs en formato `postgresql://` pero JDBC necesita `jdbc:postgresql://`.

---

## 📋 Variables de Entorno Requeridas en Render

### Opción 1: Usando DATABASE_URL (Recomendada)

Render automáticamente crea la variable `DATABASE_URL` cuando vinculas una base de datos PostgreSQL.

**No necesitas configurar nada manualmente** - solo vincula tu base de datos PostgreSQL en Render y el sistema usará automáticamente `DATABASE_URL`.

Formato esperado:
```
postgresql://usuario:contraseña@host.render.com:5432/nombre_base_datos
```

### Opción 2: Variables Separadas

Si prefieres usar variables separadas, configura:

```
SPRING_DATASOURCE_URL=jdbc:postgresql://host.render.com:5432/nombre_db?sslmode=require
SPRING_DATASOURCE_USERNAME=tu_usuario
SPRING_DATASOURCE_PASSWORD=tu_contraseña
```

---

## 🚀 Variables de Entorno Obligatorias en Render

Asegúrate de tener estas configuradas:

```bash
# Perfil de Spring
SPRING_PROFILES_ACTIVE=prod

# Puerto (Render lo configura automáticamente, pero puedes especificarlo)
PORT=10000

# URL del Frontend (para CORS)
FRONTEND_URL=https://tu-frontend.onrender.com

# Base de datos (automático si vinculas PostgreSQL)
DATABASE_URL=postgresql://usuario:password@host:5432/db
```

---

## 📝 Pasos para Configurar en Render

### 1. Crear el Web Service

1. Ve a tu Dashboard de Render
2. Click en "New +" → "Web Service"
3. Conecta tu repositorio de GitHub

### 2. Configurar el Build

```yaml
Build Command: cd backend && ./mvnw clean package -DskipTests
Start Command: cd backend && java -Dserver.port=$PORT -jar target/reservacancha-backend-0.0.1-SNAPSHOT.jar
```

### 3. Variables de Entorno

En la sección "Environment", agrega:

| Key | Value |
|-----|-------|
| `SPRING_PROFILES_ACTIVE` | `prod` |
| `FRONTEND_URL` | `https://tu-frontend.onrender.com` |

### 4. Vincular Base de Datos PostgreSQL

1. En la página de tu Web Service, ve a "Environment" 
2. Scroll hasta "Add Database"
3. Selecciona tu base de datos PostgreSQL (o crea una nueva)
4. Render automáticamente agregará la variable `DATABASE_URL`

---

## 🔍 Logs de Depuración

Cuando tu aplicación inicie correctamente, verás estos logs:

```
🚀 Iniciando configuración de DataSource para producción...
🔍 URL Original recibida: postgresql://user:pass@host:5432/db
🔄 Convirtiendo URL de PostgreSQL a formato JDBC...
✅ DATABASE_URL convertida exitosamente
   JDBC URL: jdbc:postgresql://host:5432/db?sslmode=require
   Host: host.render.com
   Port: 5432
   Database: nombre_db
   Username: usuario
```

Si hay errores, verás mensajes claros indicando qué falta.

---

## ⚠️ Errores Comunes y Soluciones

### Error: "No se encontró DATABASE_URL ni SPRING_DATASOURCE_URL"

**Solución:** Vincula tu base de datos PostgreSQL en Render:
- Ve a tu Web Service → Environment → Add Database
- Selecciona tu PostgreSQL database

### Error: "port: -1"

**Solución:** La URL no incluye el puerto. El sistema ahora usa `5432` por defecto automáticamente.

### Error: "Connection refused"

**Solución:** Verifica que:
1. La base de datos PostgreSQL esté activa en Render
2. La variable `DATABASE_URL` esté configurada correctamente
3. Tu plan de Render permite conexiones a la base de datos

### Error: "SSL connection required"

**Solución:** Ya está configurado - todas las conexiones usan `sslmode=require` automáticamente.

---

## 🧪 Probar Localmente en Modo Producción

Si quieres probar la configuración de producción localmente:

```powershell
# Configurar variables de entorno
$env:SPRING_PROFILES_ACTIVE="prod"
$env:DATABASE_URL="postgresql://localhost:5432/reservas_canchas"
$env:SPRING_DATASOURCE_USERNAME="tu_usuario"
$env:SPRING_DATASOURCE_PASSWORD="tu_password"

# Ejecutar
cd backend
./mvnw spring-boot:run
```

---

## 📦 Archivo Compilado

El archivo `.jar` listo para deploy está en:
```
backend/target/reservacancha-backend-0.0.1-SNAPSHOT.jar
```

---

## 🔐 Seguridad

- ✅ Todas las conexiones usan SSL (`sslmode=require`)
- ✅ Las contraseñas nunca se imprimen en los logs
- ✅ Las credenciales se obtienen de variables de entorno
- ✅ No hay credenciales hardcodeadas en el código

---

## 📚 Archivos Modificados

1. **DatabaseConfig.java** - Configuración personalizada de DataSource
   - Convierte URLs de PostgreSQL a JDBC
   - Maneja credenciales de múltiples fuentes
   - Logs de depuración detallados

2. **application-prod.properties** - Propiedades de producción
   - Eliminadas configuraciones conflictivas
   - JPA/Hibernate configurado para PostgreSQL
   - Pool de conexiones manejado por DatabaseConfig

---

## 🆘 Soporte

Si sigues teniendo problemas:

1. Revisa los logs en Render Dashboard → Logs
2. Verifica que `SPRING_PROFILES_ACTIVE=prod` esté configurado
3. Confirma que la base de datos esté vinculada
4. Busca los mensajes con emojis (🚀 🔍 ✅ ❌) en los logs

El sistema ahora proporciona mensajes de error muy detallados que te indicarán exactamente qué falta o está mal configurado.

