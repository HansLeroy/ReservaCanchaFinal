# 🚀 Guía Rápida de Despliegue - 5 Pasos

## 📝 Preparación Rápida

### ✅ Archivos ya creados:
- `application-prod.properties` - Configuración de producción del backend
- `environment.prod.ts` - Configuración de producción del frontend
- `Dockerfile` - Imagen Docker del backend
- `.dockerignore` - Archivos ignorados por Docker
- `railway.json` - Configuración de Railway
- `vercel.json` - Configuración de Vercel

---

## 🎯 Paso 1: Subir a GitHub (5 minutos)

```powershell
# 1. Inicializar Git (si no está inicializado)
git init

# 2. Agregar todos los archivos
git add .

# 3. Hacer commit
git commit -m "Sistema Reserva Canchas - Listo para producción"

# 4. Crear repositorio en GitHub:
# - Ve a: https://github.com/new
# - Nombre: reserva-cancha-sistema
# - Público o Privado
# - NO marques "Initialize with README"

# 5. Conectar y subir
git remote add origin https://github.com/TU-USUARIO/reserva-cancha-sistema.git
git branch -M main
git push -u origin main
```

---

## 🗄️ Paso 2: Base de Datos en Railway (3 minutos)

1. **Crear cuenta:**
   - Ve a https://railway.app
   - Click "Start a New Project"
   - Login con GitHub

2. **Crear MySQL:**
   - Click "New Project"
   - Click "Provision MySQL"
   - ✅ Base de datos creada automáticamente

3. **Obtener credenciales:**
   - Click en el servicio MySQL
   - Tab "Variables"
   - Copia: `MYSQL_URL`, `MYSQL_USER`, `MYSQL_PASSWORD`

---

## 🔧 Paso 3: Backend en Railway (5 minutos)

1. **Agregar servicio:**
   - En el mismo proyecto, click "New"
   - Click "GitHub Repo"
   - Selecciona tu repositorio

2. **Configurar variables de entorno:**
   - Click en el servicio
   - Tab "Variables"
   - Agregar:

```env
SPRING_PROFILES_ACTIVE=prod
DB_HOST=containers-us-west-xxx.railway.app
DB_PORT=7xxx
DB_NAME=railway
DB_USERNAME=root
DB_PASSWORD=(copiar de MySQL service)
FRONTEND_URL=https://tu-frontend.vercel.app
PORT=8080
```

3. **Generar dominio:**
   - Tab "Settings" → "Networking"
   - Click "Generate Domain"
   - **Guarda la URL**: `https://reservacancha-backend.up.railway.app`

4. **Esperar despliegue:**
   - Tab "Deployments"
   - Espera que diga "Success" ✅

---

## 🎨 Paso 4: Frontend en Vercel (5 minutos)

1. **Actualizar URL del backend:**
   - Edita `frontend/src/environments/environment.prod.ts`
   - Reemplaza la URL con la de Railway:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://reservacancha-backend.up.railway.app/api'
};
```

2. **Commit y push:**
```powershell
git add .
git commit -m "Actualizar API URL para producción"
git push origin main
```

3. **Desplegar en Vercel:**
   - Ve a https://vercel.com
   - Login con GitHub
   - Click "New Project"
   - Importa tu repositorio
   - Configura:
     - **Root Directory:** `frontend`
     - **Framework:** Angular
     - **Build Command:** `npm install && npm run build -- --configuration=production`
     - **Output Directory:** `dist/reservacancha-frontend`

4. **Deploy:**
   - Click "Deploy"
   - Espera ~2 minutos
   - **Guarda la URL**: `https://reserva-cancha-sistema.vercel.app`

---

## 🔄 Paso 5: Actualizar CORS (2 minutos)

1. **Volver a Railway:**
   - Abre tu servicio backend
   - Tab "Variables"
   - Actualiza `FRONTEND_URL` con la URL de Vercel
   - Railway redesplegarà automáticamente

---

## ✅ Verificación (2 minutos)

### Backend:
```powershell
# Probar API
curl https://reservacancha-backend.up.railway.app/api/canchas
```

Debería devolver JSON con las canchas.

### Frontend:
1. Abre la URL de Vercel
2. La aplicación debería cargar
3. Intenta hacer una reserva

---

## 🎉 ¡Listo! Tu App Está en Internet

**URLs finales:**
- 🎨 Frontend: `https://reserva-cancha-sistema.vercel.app`
- 🔧 Backend: `https://reservacancha-backend.up.railway.app`
- 📊 API: `https://reservacancha-backend.up.railway.app/api`

---

## 📱 Compartir con Usuarios

Comparte la URL del frontend:
```
https://reserva-cancha-sistema.vercel.app
```

**Credenciales de prueba:**
- Admin: `admin@reservacancha.cl` / `admin123`
- Usuario: `usuario@reservacancha.cl` / `usuario123`

---

## 🔄 Actualizar la App

Cada vez que hagas cambios:

```powershell
git add .
git commit -m "Descripción de cambios"
git push origin main
```

Railway y Vercel redesplegarán automáticamente.

---

## 💰 Costos

- **Railway:** $5 crédito gratis/mes (suficiente para empezar)
- **Vercel:** 100% gratis para proyectos personales

**Total: GRATIS** 🎉

---

## 🆘 Problemas Comunes

### Backend no inicia:
```powershell
# Ver logs en Railway:
# Dashboard → Tu servicio → Deployments → View Logs
```

### Frontend no conecta:
1. Verifica la URL en `environment.prod.ts`
2. Verifica CORS en Railway variables
3. Abre consola del navegador (F12) para ver errores

### Base de datos no conecta:
1. Verifica variables en Railway
2. Asegúrate que `DB_HOST`, `DB_PORT`, etc. están correctos

---

## 📚 Documentación Completa

Para más detalles, consulta:
- `GUIA_DESPLIEGUE_HOSTING.md` - Guía completa
- Railway Docs: https://docs.railway.app
- Vercel Docs: https://vercel.com/docs

---

*Tiempo total estimado: ~20 minutos*

