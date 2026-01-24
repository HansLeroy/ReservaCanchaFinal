# 🚀 GUÍA PASO A PASO: Desplegar en Render (ACTUALIZADA)

## ✅ LO QUE YA ESTÁ HECHO

- ✅ Código subido a GitHub
- ✅ Backend configurado para usar DATABASE_URL automáticamente
- ✅ Frontend configurado con URLs correctas

---

## 📋 LO QUE DEBES HACER AHORA

### PASO 1: Abrir Render Dashboard

1. Ve a: **https://dashboard.render.com/**
2. Inicia sesión con tu cuenta

---

### PASO 2: Configurar el Backend

#### 2.1 Encontrar tu servicio Backend

- En el dashboard, busca: **reservacancha-backend**
- Click en el nombre del servicio

#### 2.2 Vincular la Base de Datos (IMPORTANTE)

1. En el menú lateral, click en **"Environment"**

2. Busca el botón o enlace que diga:
   - **"Add Environment Variable"** o
   - **"Add from Database"**

3. Cuando aparezca el selector:
   - Busca tu base de datos PostgreSQL (debería llamarse algo como `reservacancha` o `postgres`)
   - Selecciónala
   - Render creará automáticamente una variable llamada `DATABASE_URL`

4. **Guarda los cambios**: Click en el botón azul **"Save Changes"**

#### 2.3 Redesplegar el Backend

1. En la parte superior de la página del servicio backend
2. Click en **"Manual Deploy"** (botón azul en la esquina superior derecha)
3. Selecciona **"Deploy latest commit"**
4. **Espera 5-10 minutos** (puede tardar)

#### 2.4 Verificar que funcionó

Mientras despliega, puedes ver los logs:

1. En el menú lateral, click en **"Logs"**
2. Busca estas líneas (scroll hacia abajo):

✅ **Buenas señales:**
```
✅ DATABASE_URL parseada exitosamente
   Host: dpg-xxx.ohio-postgres.render.com
   Database: reservacancha
   Username: reservacancha

✅ HikariPool-1 - Start completed
✅ Started ReservaCanchaBackendApplication in X.XXX seconds
```

❌ **Señales de error:**
```
❌ Unable to build Hibernate SessionFactory
❌ Driver org.postgresql.Driver claims to not accept jdbcUrl
```

---

### PASO 3: Verificar el Frontend

El frontend debería redesplegar automáticamente cuando detecte cambios en GitHub.

#### 3.1 Verificar el Despliegue

1. En Render Dashboard, busca: **reservacancha-frontend**
2. Click en el nombre
3. Ve a **"Logs"**
4. Deberías ver:
   ```
   ✅ Your site is live 🎉
   ```

#### 3.2 Si NO se redespliegue automáticamente:

1. En la página del servicio frontend
2. Click en **"Manual Deploy"**
3. Selecciona **"Deploy latest commit"**
4. Espera 2-3 minutos

---

### PASO 4: Probar la Aplicación

#### 4.1 Probar el Backend

Abre en tu navegador:
```
https://reservacancha-backend.onrender.com/api/canchas
```

**Resultado esperado:**
- Deberías ver un JSON (puede ser `[]` si no hay canchas)
- **NO** deberías ver "Whitelabel Error Page"

#### 4.2 Probar el Frontend

Abre en tu navegador:
```
https://reservacancha-frontend.onrender.com
```

**Resultado esperado:**
- Deberías ver tu aplicación Angular cargada
- Los botones y menús funcionan
- Presiona **F12** (consola del navegador) y verifica que NO haya errores rojos

---

## 🎯 RESUMEN DE LO QUE CAMBIÓ

### Antes (Manual - Complicado):
❌ Tenías que buscar la contraseña de PostgreSQL manualmente  
❌ Copiar y pegar credenciales  
❌ Configurar múltiples variables de entorno

### Ahora (Automático - Simple):
✅ Solo vinculas la base de datos en Render  
✅ El código automáticamente detecta y usa `DATABASE_URL`  
✅ Una sola acción en lugar de múltiples pasos

---

## 🔧 SI NO ENCUENTRAS LA OPCIÓN "Add from Database"

Si por alguna razón no ves la opción para vincular la base de datos:

### Opción Manual (Fallback):

1. **Obtén la URL de la base de datos:**
   - En Render Dashboard, ve a tu base de datos PostgreSQL
   - Busca **"Connections"** o **"Info"**
   - Copia la **Internal Database URL** completa
   
   Ejemplo:
   ```
   postgresql://reservacancha:ABC123xyz789@dpg-xxx.ohio-postgres.render.com:5432/reservacancha
   ```

2. **Agrégala manualmente al Backend:**
   - Ve a **reservacancha-backend** → **"Environment"**
   - Click en **"Add Environment Variable"**
   - **Key:** `DATABASE_URL`
   - **Value:** [Pega la URL completa que copiaste]
   - Click en **"Save Changes"**

3. **Redesplegar:**
   - Click en **"Manual Deploy"** → **"Deploy latest commit"**

---

## 📊 CHECKLIST FINAL

Marca cada paso cuando lo completes:

- [ ] 1. Abrir Render Dashboard
- [ ] 2. Ir a servicio Backend (reservacancha-backend)
- [ ] 3. Vincular base de datos PostgreSQL (Environment → Add from Database)
- [ ] 4. Guardar cambios (Save Changes)
- [ ] 5. Redesplegar backend (Manual Deploy → Deploy latest commit)
- [ ] 6. Esperar 5-10 minutos
- [ ] 7. Verificar logs del backend (buscar "Started ReservaCanchaBackendApplication")
- [ ] 8. Probar API: https://reservacancha-backend.onrender.com/api/canchas
- [ ] 9. Verificar frontend: https://reservacancha-frontend.onrender.com
- [ ] 10. Abrir consola del navegador (F12) y verificar que no hay errores

---

## 🆘 AYUDA RÁPIDA

### El backend no inicia:
- ✅ Verifica que la base de datos PostgreSQL esté activa en Render
- ✅ Verifica que exista la variable `DATABASE_URL` en Environment
- ✅ Copia los últimos 50 líneas de logs y revísalas

### El frontend carga pero muestra errores:
- ✅ Abre F12 (consola del navegador)
- ✅ Busca errores de CORS o conexión
- ✅ Verifica que el backend responda en `/api/canchas`

### "Whitelabel Error Page":
- ❌ El backend no está funcionando correctamente
- ✅ Revisa los logs del backend
- ✅ Verifica la conexión a la base de datos

---

## 📞 CONTACTO

Si después de seguir todos estos pasos sigues teniendo problemas:

1. Copia el error exacto de los logs
2. Copia el error de la consola del navegador (F12)
3. Toma captura de pantalla de la sección "Environment" del backend

---

**Fecha**: 24 de enero de 2026  
**Última actualización**: Configuración automática de DATABASE_URL implementada

**URLs finales esperadas:**
- Backend: `https://reservacancha-backend.onrender.com`
- Frontend: `https://reservacancha-frontend.onrender.com`

