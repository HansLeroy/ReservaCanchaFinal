# 🎯 CONFIGURACIÓN ESPECÍFICA PARA TU BASE DE DATOS

## 📊 Información de tu Base de Datos en Render

**Nombre:** reservacancha-db  
**Estado:** ✅ Available  
**Versión PostgreSQL:** 18  
**Región:** Ohio (US East)  
**Hostname:** dpg-d5qf88c9c44c73d1tlag-a  
**Port:** 5432  
**Database:** reservacancha  
**Username:** reservacancha  
**Password:** JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA

---

## 🔑 URLs de Conexión

### Internal Database URL (Usar esta en Render)
```
postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
```

### External Database URL (Para conexiones externas)
```
postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a.ohio-postgres.render.com:5432/reservacancha
```

---

## ⚙️ Variables de Entorno para Render Backend

En tu servicio **reservacancha-backend**, configura estas variables:

```bash
SPRING_PROFILES_ACTIVE=prod
DATABASE_URL=postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
FRONTEND_URL=https://reservacancha-frontend.onrender.com
```

**⚠️ IMPORTANTE:** Usa la **Internal Database URL** (sin `.ohio-postgres.render.com`) para mejor rendimiento.

---

## 🚀 Pasos para Aplicar la Configuración

### 1️⃣ Verificar y Hacer Commit

```powershell
cd C:\Users\hafer\IdeaProjects\ReservaCancha

# Ver cambios
git status

# Agregar cambios
git add .

# Commit
git commit -m "Fix: Actualizar configuración de base de datos con credenciales correctas de Render"

# Push
git push origin main
```

### 2️⃣ Configurar Variables de Entorno en Render

1. Ve a: https://dashboard.render.com
2. Selecciona tu servicio: **reservacancha-backend**
3. Ve a la pestaña **Environment**
4. Asegúrate de tener estas variables:

| Key | Value |
|-----|-------|
| `SPRING_PROFILES_ACTIVE` | `prod` |
| `DATABASE_URL` | `postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha` |
| `FRONTEND_URL` | `https://reservacancha-frontend.onrender.com` |

### 3️⃣ Trigger Manual Deploy (si es necesario)

Si Render no detecta los cambios automáticamente:
1. En tu servicio backend, click en **Manual Deploy**
2. Selecciona **Deploy latest commit**

---

## 🔍 Verificación de Logs

Después del deploy, en los logs deberías ver:

```
🚀 Iniciando configuración de DataSource para producción...
🔍 URL Original recibida: postgresql://reservacancha:***@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
🔄 Convirtiendo URL de PostgreSQL a formato JDBC...
✅ DATABASE_URL convertida exitosamente
   JDBC URL: jdbc:postgresql://dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha?sslmode=require
   Host: dpg-d5qf88c9c44c73d1tlag-a
   Port: 5432
   Database: reservacancha
   Username: reservacancha
...
Hibernate: create table if not exists ...
Started ReservaCanchaBackendApplication in X.XXX seconds (JVM running for X.XXX)
```

---

## 🧪 Probar Conexión Local (Opcional)

Si quieres probar la conexión desde tu máquina local:

### Opción A: Con psql
```powershell
$env:PGPASSWORD="JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA"
psql -h dpg-d5qf88c9c44c73d1tlag-a.ohio-postgres.render.com -p 5432 -U reservacancha -d reservacancha
```

### Opción B: Con aplicación Spring Boot local en modo prod
```powershell
$env:SPRING_PROFILES_ACTIVE="prod"
$env:DATABASE_URL="postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a.ohio-postgres.render.com:5432/reservacancha"

cd backend
./mvnw spring-boot:run
```

**Nota:** Para conexiones externas (fuera de Render), usa la **External Database URL** con `.ohio-postgres.render.com`.

---

## 📋 Checklist Final

Antes de hacer push, verifica:

- [x] render.yaml actualizado con URL correcta
- [x] DatabaseConfig.java compilado sin errores
- [x] application-prod.properties sin configuraciones conflictivas
- [x] Dockerfile optimizado
- [ ] Variables de entorno configuradas en Render Dashboard
- [ ] Base de datos **Available** en Render
- [ ] Frontend URL actualizada (si ya la tienes)

---

## 🔐 Seguridad

✅ **Recomendaciones:**

1. **No compartas estas credenciales públicamente**
2. Si el repositorio es público, considera usar Render Secrets
3. Puedes rotar la contraseña en Render Dashboard → Database → Settings
4. El archivo `render.yaml` en el repositorio está OK porque Render es privado

❌ **NO** expongas estas credenciales en:
- Logs públicos
- Documentación pública
- Capturas de pantalla compartidas
- Commits públicos de GitHub

---

## 📞 Próximos Pasos

1. **Ejecutar el script de deploy:**
   ```powershell
   .\deploy-solucion.ps1
   ```

2. **Verificar en Render Dashboard:**
   - Build exitoso
   - Logs muestran conexión exitosa
   - Aplicación responde correctamente

3. **Probar endpoints:**
   - Una vez desplegado, prueba: `https://tu-backend.onrender.com/health`
   - Verifica que responda correctamente

---

## ✅ Resumen

**Tu configuración está lista para:**
- ✅ Conectarse automáticamente a tu base de datos en Render
- ✅ Convertir URLs de PostgreSQL a JDBC
- ✅ Manejar errores de conexión
- ✅ Proporcionar logs detallados
- ✅ Funcionar en producción

**Simplemente ejecuta:**
```powershell
.\deploy-solucion.ps1
```

---

_Configuración específica para tu base de datos: reservacancha-db_  
_Hostname: dpg-d5qf88c9c44c73d1tlag-a_  
_Fecha: 25 de Enero de 2026_

