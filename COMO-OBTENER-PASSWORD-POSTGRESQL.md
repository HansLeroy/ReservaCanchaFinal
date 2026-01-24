# 🔑 CÓMO OBTENER LA CONTRASEÑA DE POSTGRESQL EN RENDER

## 📍 Contexto
Cuando desplegaste en Render, creaste una base de datos PostgreSQL nueva en la nube. Esta base de datos tiene su propia contraseña que Render generó automáticamente.

---

## 📝 PASOS PARA OBTENER LA CONTRASEÑA

### Opción 1: Desde el Dashboard de PostgreSQL (MÁS FÁCIL)

1. **Ve a Render Dashboard**
   - URL: https://dashboard.render.com/

2. **Busca tu Base de Datos PostgreSQL**
   - En el menú lateral, busca en tus servicios
   - Deberías ver algo como:
     - 📊 `reservacancha` (PostgreSQL)
     - o el nombre que le pusiste a tu BD

3. **Abre la Base de Datos**
   - Click en el nombre de la base de datos

4. **Ve a la sección "Connections" o "Info"**
   - Busca estas opciones:
     - **Internal Database URL** o
     - **External Database URL**

5. **Copia la URL completa**
   La URL se verá así:
   ```
   postgresql://reservacancha:JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA@dpg-d5qf88c9c44c73d1tlag-a.ohio-postgres.render.com:5432/reservacancha
   ```

6. **Extrae la contraseña**
   En la URL, la contraseña está entre `:` y `@`:
   ```
   postgresql://USUARIO:CONTRASEÑA@HOST:5432/DATABASE
                        ↑ ESTO ES LO QUE NECESITAS ↑
   ```
   
   En el ejemplo: `JjpQXMjIRkwVwLEnrbep3T3YmhJr1AhA`

---

### Opción 2: Mostrar las Credenciales Individuales

Algunas veces Render muestra las credenciales separadas:

1. En la página de tu base de datos PostgreSQL
2. Busca estas variables:
   - **Database**: `reservacancha`
   - **Username**: `reservacancha`
   - **Password**: `[LA CONTRASEÑA AQUÍ]` ← 🎯 ESTO ES LO QUE NECESITAS
   - **Host**: `dpg-d5qf88c9c44c73d1tlag-a.ohio-postgres.render.com`
   - **Port**: `5432`

---

## ⚙️ CÓMO CONFIGURAR LA CONTRASEÑA EN EL BACKEND

### Paso 1: Copiar la Contraseña

Copia la contraseña que obtuviste en los pasos anteriores

### Paso 2: Ir al Servicio Backend

1. Ve a https://dashboard.render.com/
2. Busca tu servicio **reservacancha-backend** (Web Service)
3. Click en el nombre del servicio

### Paso 3: Agregar la Variable de Entorno

1. En el menú lateral, click en **"Environment"**
2. Busca si ya existe la variable `DB_PASSWORD`
   - **Si existe**: Click en el valor y pégalo/actualízalo
   - **Si NO existe**: Click en **"Add Environment Variable"**

3. Agrega:
   ```
   Key:   DB_PASSWORD
   Value: [PEGA LA CONTRASEÑA AQUÍ]
   ```

4. Click en **"Save Changes"** (botón azul)

### Paso 4: Redesplegar

1. El servicio debería reiniciarse automáticamente
2. Si no, ve a la parte superior y click en **"Manual Deploy"**
3. Selecciona **"Deploy latest commit"**

---

## 🎯 EJEMPLO VISUAL

Si tu Internal Database URL es:
```
postgresql://reservacancha:ABC123xyz789@dpg-xxx.ohio-postgres.render.com:5432/reservacancha
```

Entonces:
- **Username**: `reservacancha`
- **Password**: `ABC123xyz789` ← Esto va en `DB_PASSWORD`
- **Host**: `dpg-xxx.ohio-postgres.render.com`
- **Database**: `reservacancha`

---

## ✅ VERIFICAR QUE FUNCIONÓ

Después de configurar `DB_PASSWORD`:

1. Ve a los **Logs** del backend (menú lateral en Render)
2. Deberías ver:
   ```
   ✅ HikariPool-1 - Start completed
   ✅ Started ReservaCanchaBackendApplication
   ```

3. Si ves errores como:
   ```
   ❌ Driver org.postgresql.Driver claims to not accept jdbcUrl
   ❌ Unable to build Hibernate SessionFactory
   ```
   La contraseña está incorrecta o falta configurarla.

---

## 🆘 SI NO ENCUENTRAS LA CONTRASEÑA

Si no encuentras la contraseña o la perdiste:

### Opción A: Crear Nueva Conexión String
En Render, puedes ver todas las credenciales en la página de la BD PostgreSQL.

### Opción B: Usar DATABASE_URL directamente
Podemos modificar el backend para usar la variable `DATABASE_URL` que Render crea automáticamente.

---

## 📸 CAPTURAS DE PANTALLA (Referencias)

En Render, la página de PostgreSQL debería mostrar:

```
┌─────────────────────────────────────┐
│  PostgreSQL Database                │
│  reservacancha                      │
├─────────────────────────────────────┤
│  Status: Available                  │
│                                     │
│  CONNECTIONS                        │
│  ├─ Internal Database URL           │
│  │  postgresql://reservacancha:... │
│  │  [COPY] 📋                       │
│  │                                  │
│  ├─ External Database URL           │
│  │  postgresql://reservacancha:... │
│  │  [COPY] 📋                       │
│  │                                  │
│  └─ Connection Details              │
│     Database: reservacancha         │
│     Username: reservacancha         │
│     Password: ********** [SHOW]     │ ← Click SHOW aquí
│     Host: dpg-xxx.ohio-postgres...  │
│     Port: 5432                      │
└─────────────────────────────────────┘
```

---

## 🔄 ALTERNATIVA: Usar DATABASE_URL Completa

Si tienes problemas, podemos cambiar el backend para usar directamente la variable `DATABASE_URL` que Render proporciona automáticamente. Avísame si prefieres esta opción.

---

**Fecha**: 24 de enero de 2026  
**Nota**: La contraseña es única para tu base de datos y fue generada por Render cuando la creaste.

