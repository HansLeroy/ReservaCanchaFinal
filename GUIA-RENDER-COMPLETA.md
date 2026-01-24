# 🚀 Guía de Despliegue en Render

## 📋 Resumen del Estado Actual

✅ **Base de Datos PostgreSQL creada en Render:**
- **Hostname**: `dpg-d5qf88c9c44c73d1tlag-a`
- **Port**: `5432`
- **Database**: `reservacancha`
- **Username**: `reservacancha`
- **Password**: [Visible en tu Dashboard de Render, click en el ícono del ojo 👁️]
- **Internal Database URL**: `postgresql://reservacancha:[PASSWORD]@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha`

---

## 🎯 Paso a Paso: Despliegue Completo

### **Opción 1: Despliegue Manual (Recomendado para principiantes)**

#### 1️⃣ **Preparar el Proyecto Localmente**

```powershell
# Ejecuta este script
.\DESPLEGAR-EN-RENDER.ps1
```

Este script:
- ✅ Compila el backend (JAR)
- ✅ Compila el frontend (producción)
- ✅ Te muestra las instrucciones paso a paso

---

#### 2️⃣ **Desplegar el Backend en Render**

1. **Ve a tu Dashboard de Render**: https://dashboard.render.com/
2. **Click en el botón "New +"** → Selecciona **"Web Service"**
3. **Conecta tu repositorio**:
   - Si aún no has subido tu código a GitHub, ve al paso **"Subir a GitHub"** al final
   - Selecciona el repositorio `ReservaCancha`
4. **Configuración del Web Service**:

   | Campo | Valor |
   |-------|-------|
   | **Name** | `reservacancha-backend` |
   | **Environment** | `Java` |
   | **Region** | `Oregon (US West)` o el más cercano |
   | **Branch** | `main` |
   | **Root Directory** | (dejar vacío) |
   | **Build Command** | `cd backend && chmod +x mvnw && ./mvnw clean package -DskipTests` |
   | **Start Command** | `java -jar backend/target/reservacancha-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod` |

5. **Variables de Entorno** (Environment Variables):
   
   Click en **"Advanced"** → **"Add Environment Variable"**:

   ```plaintext
   SPRING_PROFILES_ACTIVE=prod
   DATABASE_URL=postgresql://reservacancha:[TU_PASSWORD]@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
   DB_HOST=dpg-d5qf88c9c44c73d1tlag-a
   DB_PORT=5432
   DB_NAME=reservacancha
   DB_USERNAME=reservacancha
   DB_PASSWORD=[TU_PASSWORD_DE_RENDER]
   DB_DRIVER=org.postgresql.Driver
   DB_DIALECT=org.hibernate.dialect.PostgreSQLDialect
   FRONTEND_URL=https://reservacancha-frontend.onrender.com
   ```

   > 💡 **Importante**: Reemplaza `[TU_PASSWORD]` y `[TU_PASSWORD_DE_RENDER]` con la contraseña real de tu base de datos (la puedes ver en el Dashboard de la DB haciendo click en el ícono del ojo 👁️)

6. **Plan**: Selecciona **"Free"**
7. **Click en "Create Web Service"**

⏱️ **Espera 5-10 minutos** mientras Render despliega tu backend.

---

#### 3️⃣ **Actualizar la URL del Backend en el Frontend**

1. Una vez que el backend esté desplegado, **copia su URL**:
   - Será algo como: `https://reservacancha-backend.onrender.com`

2. **Actualiza el archivo del frontend**:
   ```typescript
   // frontend/src/environments/environment.prod.ts
   export const environment = {
     production: true,
     apiUrl: 'https://reservacancha-backend.onrender.com/api'  // ← Tu URL aquí
   };
   ```

3. **Haz commit de los cambios**:
   ```powershell
   git add frontend/src/environments/environment.prod.ts
   git commit -m "Actualizar URL del backend en producción"
   git push
   ```

---

#### 4️⃣ **Desplegar el Frontend en Render**

1. **Ve a tu Dashboard de Render**: https://dashboard.render.com/
2. **Click en "New +"** → Selecciona **"Static Site"**
3. **Conecta tu repositorio**: Selecciona `ReservaCancha`
4. **Configuración del Static Site**:

   | Campo | Valor |
   |-------|-------|
   | **Name** | `reservacancha-frontend` |
   | **Branch** | `main` |
   | **Root Directory** | (dejar vacío) |
   | **Build Command** | `cd frontend && npm install && npm run build -- --configuration production` |
   | **Publish Directory** | `frontend/dist/reservacancha-frontend` |

5. **Plan**: Selecciona **"Free"**
6. **Click en "Create Static Site"**

⏱️ **Espera 5-10 minutos** mientras Render despliega tu frontend.

---

### **Opción 2: Despliegue Automático con Blueprint (Avanzado)**

Si tu código ya está en GitHub:

1. **Ve a Render Dashboard** → **"New +"** → **"Blueprint"**
2. **Conecta tu repositorio** `ReservaCancha`
3. Render detectará automáticamente el archivo `render.yaml`
4. **Configura las variables de entorno** para la base de datos
5. **Click en "Apply"**

Render desplegará automáticamente:
- ✅ Base de datos PostgreSQL
- ✅ Backend (Web Service)
- ✅ Frontend (Static Site)

---

## 📤 Subir tu Código a GitHub

Si aún no has subido tu código a GitHub:

### **Paso 1: Crear un repositorio en GitHub**
1. Ve a https://github.com/new
2. Nombre: `reservacancha`
3. Privado o Público (tu elección)
4. **NO** marques "Initialize with README"
5. Click en **"Create repository"**

### **Paso 2: Subir el código**

```powershell
# Inicializar repositorio Git
git init

# Crear .gitignore si no existe
@"
node_modules/
target/
dist/
*.log
.DS_Store
.idea/
*.iml
"@ | Out-File -FilePath .gitignore -Encoding utf8

# Agregar archivos
git add .

# Hacer commit
git commit -m "Proyecto ReservaCancha listo para Render"

# Configurar rama principal
git branch -M main

# Agregar repositorio remoto (REEMPLAZA con tu URL)
git remote add origin https://github.com/TU-USUARIO/reservacancha.git

# Subir código
git push -u origin main
```

---

## 🔍 Verificar el Despliegue

### **Backend**
```powershell
# Prueba el endpoint de canchas
curl https://reservacancha-backend.onrender.com/api/canchas
```

### **Frontend**
Abre en tu navegador: `https://reservacancha-frontend.onrender.com`

---

## 🐛 Solución de Problemas

### **Error: "Application failed to start"**
- ✅ Verifica que todas las variables de entorno estén configuradas
- ✅ Revisa los logs en Render Dashboard → Tu servicio → "Logs"
- ✅ Asegúrate de que la contraseña de la DB sea correcta

### **Error: "Build failed"**
- ✅ Verifica que el `Build Command` sea correcto
- ✅ Asegúrate de que el `pom.xml` tenga la dependencia de PostgreSQL
- ✅ Revisa los logs de compilación

### **Frontend no se conecta al Backend**
- ✅ Verifica que `environment.prod.ts` tenga la URL correcta del backend
- ✅ Asegúrate de que el backend esté corriendo
- ✅ Verifica que el CORS esté configurado correctamente (variable `FRONTEND_URL`)

### **Base de datos no conecta**
- ✅ Copia la contraseña haciendo click en el ícono del ojo 👁️ en Render
- ✅ Verifica que el hostname sea el interno: `dpg-d5qf88c9c44c73d1tlag-a`
- ✅ Asegúrate de usar el puerto `5432`

---

## 📊 Monitoreo

En el Dashboard de Render puedes ver:
- 📈 **Métricas**: CPU, memoria, requests
- 📝 **Logs**: Logs en tiempo real de tu aplicación
- 🔄 **Deploys**: Historial de despliegues
- ⚙️ **Settings**: Configuración y variables de entorno

---

## 🎉 ¡Listo!

Tu aplicación ReservaCancha está ahora desplegada en:
- **Frontend**: `https://reservacancha-frontend.onrender.com`
- **Backend**: `https://reservacancha-backend.onrender.com`
- **Base de Datos**: PostgreSQL en Render

---

## 📞 Soporte

Si tienes problemas:
1. Revisa los **logs** en Render Dashboard
2. Verifica las **variables de entorno**
3. Consulta la documentación de Render: https://render.com/docs

---

**¡Disfruta de tu aplicación en producción! 🚀**

