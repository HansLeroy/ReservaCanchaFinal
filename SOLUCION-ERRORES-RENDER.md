# SOLUCIÓN A ERRORES DE DESPLIEGUE EN RENDER

## Problemas Identificados y Solucionados

### 1. Error en Backend: "Driver org.postgresql.Driver claims to not accept jdbcUrl"
**Causa**: La URL de PostgreSQL tenía un formato incorrecto
**Solución Aplicada**: Corregido en `backend/src/main/resources/application-prod.properties`

### 2. Frontend no se conecta al Backend
**Causa**: Las URLs estaban hardcodeadas a localhost en todos los servicios
**Solución Aplicada**: Todos los servicios ahora usan `environment.apiUrl`

---

## PASOS PARA COMPLETAR EL DESPLIEGUE

### Paso 1: Subir los Cambios a GitHub

Ejecuta el script:
```powershell
.\REDESPLEGAR.ps1
```

O manualmente:
```powershell
git add .
git commit -m "Fix: Corregir configuración de producción"
git push origin main
```

---

### Paso 2: Configurar Variables de Entorno en Render

#### IMPORTANTE: Obtener la Contraseña de PostgreSQL

1. Ve a [Render Dashboard](https://dashboard.render.com/)
2. Busca tu base de datos PostgreSQL (`reservacancha`)
3. En la sección "Connections", copia la **Internal Database URL**
   - Formato: `postgresql://usuario:CONTRASEÑA@host:5432/nombredb`
   - Extrae la **CONTRASEÑA** de esta URL

#### Configurar el Backend

1. Ve a tu servicio **reservacancha-backend**
2. Click en **"Environment"** en el menú lateral
3. Agrega/Verifica estas variables:

```
DB_PASSWORD = [LA_CONTRASEÑA_QUE_COPIASTE]
```

4. Si quieres más seguridad, también puedes configurar (opcional):
```
FRONTEND_URL = https://reservacancha-frontend.onrender.com
```

5. **Guarda los cambios** (botón "Save Changes")

---

### Paso 3: Redesplegar los Servicios

#### Backend:
1. En la página del servicio **reservacancha-backend**
2. Click en **"Manual Deploy"** (esquina superior derecha)
3. Selecciona **"Deploy latest commit"**
4. Espera a que termine el despliegue (5-10 minutos)
5. Verifica los logs - debe decir: "Started ReservaCanchaBackendApplication"

#### Frontend:
1. En la página del servicio **reservacancha-frontend**
2. Render debería redesplegar automáticamente
3. Si no, click en **"Manual Deploy"** -> **"Deploy latest commit"**
4. Espera a que termine (2-3 minutos)

---

### Paso 4: Verificar que Todo Funciona

#### Verificar Backend:
```
URL: https://reservacancha-backend.onrender.com/api/canchas
```
- Deberías ver un JSON con las canchas o un array vacío `[]`
- Si ves "Whitelabel Error Page" o error 404, hay un problema

#### Verificar Frontend:
```
URL: https://reservacancha-frontend.onrender.com
```
- Deberías ver tu aplicación Angular
- Abre la consola del navegador (F12)
- No deberían haber errores CORS o de conexión

---

## CONFIGURACIÓN DETALLADA DE VARIABLES DE ENTORNO

### Backend (`reservacancha-backend`)

Variables mínimas requeridas:
```
DB_PASSWORD = [contraseña-postgresql]
```

Variables opcionales recomendadas:
```
FRONTEND_URL = https://reservacancha-frontend.onrender.com
SPRING_PROFILES_ACTIVE = prod
```

### Frontend (`reservacancha-frontend`)

**No requiere variables de entorno** porque la URL del backend está en `environment.prod.ts`:
```typescript
apiUrl: 'https://reservacancha-backend.onrender.com/api'
```

---

## SOLUCIÓN DE PROBLEMAS COMUNES

### Si el Backend sigue sin conectarse a la BD:

1. Verifica que la base de datos PostgreSQL esté activa
2. Ve a la BD en Render y copia la **Internal Database URL completa**
3. En el backend, agrega una variable temporal:
```
SPRING_DATASOURCE_URL = [pega la URL completa aquí]
```

### Si el Frontend muestra páginas en blanco:

1. Verifica que el backend responda:
   - `https://reservacancha-backend.onrender.com/api/canchas`
2. Abre la consola del navegador (F12)
3. Busca errores de CORS o conexión

### Si aparece Error 404:

**En el Backend**: La base de datos no está conectada
- Verifica variables de entorno
- Revisa los logs del servicio

**En el Frontend**: Problema de enrutamiento
- Verifica que `_redirects` esté en `dist/` después del build
- Debe estar configurado en `angular.json` (ya está)

---

## LOGS ÚTILES PARA DEBUGGING

### Ver logs del Backend en Render:
1. Ve al servicio backend
2. Click en "Logs" en el menú lateral
3. Busca líneas como:
   - `Started ReservaCanchaBackendApplication` ✅ (bueno)
   - `HikariPool-1 - Start completed` ✅ (BD conectada)
   - `Unable to build Hibernate SessionFactory` ❌ (BD no conectada)

### Ver logs del Frontend:
1. Ve al servicio frontend
2. Click en "Logs"
3. Verifica que diga:
   - `Your site is live 🎉` ✅

---

## CONTACTO Y SOPORTE

Si después de seguir estos pasos sigues teniendo problemas:

1. Copia los últimos 50 líneas de logs del backend
2. Copia los errores de la consola del navegador (F12)
3. Verifica que las URLs estén correctas:
   - Backend debe terminar en `/api`
   - Frontend debe cargar sin errores

---

## RESUMEN DE CAMBIOS REALIZADOS

✅ Corregido formato URL PostgreSQL en `application-prod.properties`
✅ Configurado `auth.service.ts` para usar `environment.apiUrl`
✅ Configurado `cancha.service.ts` para usar `environment.apiUrl`
✅ Configurado `cliente.service.ts` para usar `environment.apiUrl`
✅ Configurado `reporte.service.ts` para usar `environment.apiUrl`
✅ Configurado `reserva.service.ts` para usar `environment.apiUrl`
✅ Configurado `usuario.service.ts` para usar `environment.apiUrl`
✅ `environment.ts` configurado para desarrollo (localhost)
✅ `environment.prod.ts` configurado para producción (Render)
✅ Archivo `_redirects` configurado para routing de Angular

**Fecha de corrección**: 24 de enero de 2026

