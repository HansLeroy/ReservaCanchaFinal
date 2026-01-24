# 🚀 DESPLIEGUE DEL SISTEMA - GUÍA COMPLETA

## 📌 Estado Actual
✅ Código preparado y commiteado en Git local
✅ Backend compilado y listo
✅ Scripts de despliegue automático creados

---

## 🎯 PROCESO DE DESPLIEGUE (20 minutos)

### PASO 1️⃣: Crear Repositorio en GitHub (2 minutos)

1. Ve a: **https://github.com/new**
2. Configura:
   - **Repository name:** `reserva-cancha-sistema`
   - **Description:** Sistema de Reserva de Canchas Deportivas
   - **Visibilidad:** Público (recomendado para Railway/Vercel gratis)
   - ⚠️ **NO marques** "Initialize with README"
3. Click **"Create repository"**
4. Copia la URL del repositorio (ejemplo: `https://github.com/TU-USUARIO/reserva-cancha-sistema.git`)

**Luego ejecuta en PowerShell:**
```powershell
.\DESPLEGAR-AUTOMATICO.ps1 -GithubUrl "https://github.com/TU-USUARIO/reserva-cancha-sistema.git"
```

---

### PASO 2️⃣: Desplegar Base de Datos en Railway (3 minutos)

El script anterior te abrirá Railway. Sigue estos pasos:

1. **Login en Railway:**
   - Ve a https://railway.app
   - Click "Start a New Project"
   - Login con GitHub

2. **Crear MySQL:**
   - Click "New Project"
   - Selecciona "Provision MySQL"
   - Espera 30 segundos a que se cree

3. **Obtener credenciales:**
   - Click en el servicio **MySQL**
   - Tab **"Variables"**
   - Copia estas variables (las necesitarás):
     * `MYSQLHOST` (ej: containers-us-west-xxx.railway.app)
     * `MYSQLPORT` (ej: 7432)
     * `MYSQLDATABASE` (ej: railway)
     * `MYSQLUSER` (ej: root)
     * `MYSQLPASSWORD` (ej: xxxxx)

---

### PASO 3️⃣: Desplegar Backend en Railway (5 minutos)

1. **Agregar servicio desde GitHub:**
   - En el mismo proyecto de Railway, click **"New"**
   - Selecciona **"GitHub Repo"**
   - Autoriza a Railway si es necesario
   - Selecciona tu repositorio `reserva-cancha-sistema`

2. **Configurar variables de entorno:**
   - Click en el nuevo servicio (tu repo)
   - Tab **"Variables"**
   - Click **"New Variable"** para cada una:

   ```
   SPRING_PROFILES_ACTIVE = prod
   DB_HOST = (pegar MYSQLHOST de arriba)
   DB_PORT = (pegar MYSQLPORT de arriba)
   DB_NAME = (pegar MYSQLDATABASE de arriba)
   DB_USERNAME = (pegar MYSQLUSER de arriba)
   DB_PASSWORD = (pegar MYSQLPASSWORD de arriba)
   FRONTEND_URL = https://tu-app.vercel.app
   PORT = 8080
   ```

3. **Generar dominio público:**
   - Tab **"Settings"**
   - Sección **"Networking"**
   - Click **"Generate Domain"**
   - **⭐ COPIA LA URL** (ej: https://reservacancha-backend.up.railway.app)

4. **Verificar despliegue:**
   - Tab **"Deployments"**
   - Espera que diga **"Success"** ✅
   - Si falla, revisa los logs

---

### PASO 4️⃣: Desplegar Frontend en Vercel (5 minutos)

**Ejecuta en PowerShell:**
```powershell
.\DESPLEGAR-FRONTEND.ps1 -BackendUrl "https://tu-backend.up.railway.app"
```

El script actualizará la configuración y te abrirá Vercel. Sigue estos pasos:

1. **Login en Vercel:**
   - Ve a https://vercel.com
   - Login con GitHub

2. **Importar proyecto:**
   - Click **"New Project"**
   - Selecciona tu repositorio `reserva-cancha-sistema`
   - Click **"Import"**

3. **Configurar build:**
   - **Root Directory:** `frontend` ⚠️ IMPORTANTE
   - **Framework Preset:** Angular
   - **Build Command:** `npm install && npm run build -- --configuration=production`
   - **Output Directory:** `dist/reservacancha-frontend`

4. **Deploy:**
   - Click **"Deploy"**
   - Espera ~2 minutos
   - **⭐ COPIA LA URL** (ej: https://reserva-cancha-sistema.vercel.app)

---

### PASO 5️⃣: Actualizar CORS en Railway (2 minutos)

1. Vuelve a **Railway**
2. Click en tu servicio **backend**
3. Tab **"Variables"**
4. Edita la variable `FRONTEND_URL`
5. Pega la URL de Vercel
6. Railway redesplegarà automáticamente

---

## ✅ VERIFICACIÓN FINAL

### Probar Backend:
Abre en el navegador:
```
https://tu-backend.up.railway.app/api/canchas
```
Deberías ver un JSON con las canchas.

### Probar Frontend:
Abre en el navegador:
```
https://tu-app.vercel.app
```
La aplicación debería cargar y funcionar completamente.

---

## 🎉 ¡LISTO! Tu Sistema Está en Internet

**URLs Finales:**
- 🎨 **Frontend:** https://tu-app.vercel.app
- 🔧 **Backend:** https://tu-backend.up.railway.app
- 📊 **API:** https://tu-backend.up.railway.app/api

**Credenciales de Prueba:**
- **Admin:** admin@reservacancha.cl / admin123
- **Usuario:** usuario@reservacancha.cl / usuario123

---

## 🔄 Actualizar la Aplicación en el Futuro

Cuando hagas cambios en el código:

```powershell
git add .
git commit -m "Descripción de los cambios"
git push origin main
```

Railway y Vercel redesplegarán automáticamente.

---

## 💰 Costos

- **Railway:** $5 USD crédito gratis/mes (suficiente para desarrollo)
- **Vercel:** 100% gratis para proyectos personales
- **GitHub:** 100% gratis para repositorios públicos/privados

**Total Inicial: GRATIS** 🎉

---

## 🆘 Solución de Problemas

### Backend no responde:
1. Railway → Tu servicio → Tab "Deployments" → "View Logs"
2. Verifica que todas las variables estén correctas
3. Verifica que el servicio MySQL esté activo

### Frontend muestra error de conexión:
1. Abre la consola del navegador (F12)
2. Verifica que la URL del backend esté correcta
3. Verifica CORS en Railway (variable FRONTEND_URL)

### Base de datos vacía:
1. El backend crea las tablas automáticamente
2. Ejecuta el DataInitializer para datos de prueba
3. Revisa los logs del backend en Railway

---

## 📚 Archivos Importantes

- `DESPLEGAR-AUTOMATICO.ps1` - Sube código a GitHub y guía para Railway
- `DESPLEGAR-FRONTEND.ps1` - Configura frontend y guía para Vercel
- `backend/src/main/resources/application-prod.properties` - Config producción backend
- `frontend/src/environments/environment.prod.ts` - Config producción frontend

---

## 📞 Siguiente Paso

**Ejecuta ahora:**
```powershell
.\DESPLEGAR-AUTOMATICO.ps1 -GithubUrl "TU-URL-DE-GITHUB"
```

¡Buena suerte con el despliegue! 🚀

