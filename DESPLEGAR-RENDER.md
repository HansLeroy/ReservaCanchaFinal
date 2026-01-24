# ============================================
# DESPLIEGUE EN RENDER.COM (ALTERNATIVA A RAILWAY)
# ============================================

## 🚀 PASOS PARA DESPLEGAR EN RENDER

### 1. Crear cuenta en Render (1 minuto)
- Ve a: https://render.com
- Click "Get Started"
- Login con GitHub (más fácil)
- Autoriza Render

### 2. Crear Base de Datos PostgreSQL (GRATIS)
- Dashboard → "New" → "PostgreSQL"
- Name: reservacancha-db
- Region: Oregon (US West)
- Plan: FREE
- Click "Create Database"
- Espera 1 minuto

### 3. Copiar credenciales de la DB
Una vez creada, ve a la base de datos y copia:
- Internal Database URL (la usaremos)

### 4. Desplegar Backend
- Dashboard → "New" → "Web Service"
- Connect tu repositorio: reserva-cancha-sistema
- Name: reservacancha-backend
- Root Directory: backend
- Environment: Java
- Build Command: ./mvnw clean package -DskipTests
- Start Command: java -jar target/reservacancha-backend-0.0.1-SNAPSHOT.jar
- Plan: FREE

### 5. Configurar Variables de Entorno
En el backend, agregar estas variables:

```
SPRING_PROFILES_ACTIVE=prod
DB_HOST=(de la URL de PostgreSQL)
DB_PORT=5432
DB_NAME=(de la URL de PostgreSQL)
DB_USERNAME=(de la URL de PostgreSQL)
DB_PASSWORD=(de la URL de PostgreSQL)
FRONTEND_URL=https://tu-frontend.vercel.app
PORT=10000
```

### 6. Desplegar Frontend en Vercel
(Igual que antes, ya está configurado)

---

## 💡 VENTAJAS DE RENDER:
✅ No requiere verificación 2FA complicada
✅ 100% gratis para empezar
✅ Despliegue automático desde GitHub
✅ Incluye base de datos PostgreSQL gratis
✅ SSL incluido

---

## ⚠️ NOTA: Cambio de MySQL a PostgreSQL
Render usa PostgreSQL en lugar de MySQL en el plan gratis.
Necesitaremos hacer un pequeño cambio en el código.

