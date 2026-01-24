# 🚀 DESPLIEGUE CON BLUEPRINT EN RENDER - Paso a Paso

## ✅ Preparación Completa
- ✅ Código subido a GitHub: `HansLeroy/reservas-canchas`
- ✅ Base de datos PostgreSQL creada en Render
- ✅ Archivo `render.yaml` configurado

---

## 📋 PASOS PARA DESPLEGAR

### **Paso 1: Ir al Dashboard de Render**

🔗 Abre en tu navegador: **https://dashboard.render.com/**

---

### **Paso 2: Crear un Blueprint**

1. **Click en el botón "New +"** (esquina superior derecha)
2. **Selecciona "Blueprint"** del menú desplegable

---

### **Paso 3: Conectar tu Repositorio**

1. **Busca tu repositorio**: `HansLeroy/reservas-canchas`
2. **Click en "Connect"**
3. Si no ves el repositorio:
   - Click en "Configure account"
   - Autoriza Render para acceder a tus repositorios
   - Selecciona `reservas-canchas`

---

### **Paso 4: Render Detecta el Blueprint**

Render automáticamente detectará el archivo `render.yaml` y mostrará:

- ✅ **reservacancha-backend** (Web Service)
- ✅ **reservacancha-frontend** (Static Site)

---

### **Paso 5: IMPORTANTE - Configurar Variables de Entorno**

**ANTES DE CONTINUAR**, necesitas configurar 2 variables secretas:

#### 1. **DB_PASSWORD**
   - Ve a tu Dashboard de Render
   - Click en `reservacancha-db` (tu base de datos)
   - Click en "Info"
   - **Click en el ícono del ojo 👁️** junto a "Password"
   - **Copia la contraseña**

#### 2. **DATABASE_URL**
   - Usa este formato:
   ```
   postgresql://reservacancha:[TU_PASSWORD]@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
   ```
   - Reemplaza `[TU_PASSWORD]` con la contraseña que copiaste

---

### **Paso 6: Aplicar el Blueprint**

En la pantalla de configuración del Blueprint:

1. **Configura las variables secretas**:
   - Busca `DB_PASSWORD` → Pega tu contraseña
   - Busca `DATABASE_URL` → Pega la URL completa

2. **Revisa la configuración**:
   - Branch: `main` ✓
   - Plan: `Free` ✓

3. **Click en "Apply"**

---

### **Paso 7: Esperar el Despliegue**

Render comenzará a:
1. ✅ **Compilar el backend** (5-8 minutos)
   - Maven descargará dependencias
   - Compilará el código Java
   - Creará el JAR

2. ✅ **Compilar el frontend** (3-5 minutos)
   - npm instalará dependencias
   - Compilará Angular para producción

3. ✅ **Iniciar los servicios**

**Total: 10-15 minutos** ⏱️

---

### **Paso 8: Verificar el Despliegue**

Una vez completado:

#### **Backend**
- URL: `https://reservacancha-backend.onrender.com`
- Prueba: `https://reservacancha-backend.onrender.com/api/canchas`
- Deberías ver una lista de canchas (puede estar vacía al inicio)

#### **Frontend**
- URL: `https://reservacancha-frontend.onrender.com`
- Deberías ver tu aplicación funcionando

---

## 🔧 Si hay Problemas

### **Error: "Build Failed"**

1. **Ve a "Logs"** del servicio que falló
2. **Busca el error** (scroll hasta el final)
3. Errores comunes:
   - **Maven timeout**: Vuelve a intentar (click en "Manual Deploy")
   - **Database connection**: Verifica `DB_PASSWORD` y `DATABASE_URL`

### **Backend se inicia pero no responde**

1. **Verifica las variables de entorno**:
   - `DB_PASSWORD` debe estar correcta
   - `DATABASE_URL` debe tener el formato correcto
   
2. **Revisa los logs**:
   - Click en "Logs" en el backend
   - Busca errores de conexión a la base de datos

### **Frontend no se conecta al Backend**

1. **Obtén la URL real del backend** (después del despliegue)
2. **Actualiza `environment.prod.ts`**:
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://TU-BACKEND-REAL-URL.onrender.com/api'
   };
   ```
3. **Haz commit y push**:
   ```bash
   git add frontend/src/environments/environment.prod.ts
   git commit -m "Actualizar URL del backend"
   git push
   ```
4. Render redesplegar automáticamente

---

## 📊 Monitoreo

En el Dashboard de Render puedes ver:
- 📈 **Métricas**: CPU, memoria, requests
- 📝 **Logs**: Logs en tiempo real
- 🔄 **Deploys**: Historial de despliegues
- ⚙️ **Settings**: Configuración

---

## 🎯 Resumen de URLs que Necesitas

### **Para configurar las variables de entorno:**

1. **Ver contraseña de la DB**:
   ```
   https://dashboard.render.com/
   → Click en "reservacancha-db"
   → Click en "Info"
   → Click en el ícono del ojo 👁️ junto a "Password"
   ```

2. **DATABASE_URL** (formato):
   ```
   postgresql://reservacancha:[PASSWORD]@dpg-d5qf88c9c44c73d1tlag-a:5432/reservacancha
   ```

### **URLs Finales (después del despliegue):**
- Frontend: `https://reservacancha-frontend.onrender.com`
- Backend: `https://reservacancha-backend.onrender.com`
- API: `https://reservacancha-backend.onrender.com/api/canchas`

---

## ✨ ¡Listo!

Sigue estos pasos y tu aplicación estará en producción en 15 minutos.

**¡Éxito con tu despliegue! 🚀**

