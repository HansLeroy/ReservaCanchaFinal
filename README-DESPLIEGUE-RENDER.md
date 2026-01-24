# 🚀 Despliegue Rápido en Render

## 📌 Situación Actual

✅ **Ya tienes creada la base de datos PostgreSQL en Render**

Datos de conexión:
- **Hostname**: `dpg-d5qf88c9c44c73d1tlag-a`
- **Puerto**: `5432`
- **Base de datos**: `reservacancha`
- **Usuario**: `reservacancha`
- **Contraseña**: [Visible en tu Dashboard de Render → Click en el ícono 👁️]

---

## ⚡ Instrucciones Rápidas

### 1️⃣ Ejecuta el script de preparación

```powershell
.\PREPARAR-RENDER.ps1
```

Este script:
- ✅ Verifica que tengas todo instalado (Java, Node.js, Git)
- ✅ Compila el backend
- ✅ Compila el frontend
- ✅ Te guía al siguiente paso

---

### 2️⃣ Sube tu código a GitHub

```powershell
.\SUBIR-A-GITHUB.ps1
```

Este script:
- ✅ Inicializa Git
- ✅ Hace commit de tu código
- ✅ Sube todo a GitHub

---

### 3️⃣ Despliega en Render

Tienes **2 opciones**:

#### **Opción A: Despliegue Manual** (Recomendado)

1. Lee la guía completa:
   ```powershell
   notepad GUIA-RENDER-COMPLETA.md
   ```

2. O ejecuta el script con instrucciones:
   ```powershell
   .\DESPLEGAR-EN-RENDER.ps1
   ```

#### **Opción B: Despliegue Automático**

Si ya subiste tu código a GitHub:

1. Ve a [Render Dashboard](https://dashboard.render.com/)
2. Click en **"New +"** → **"Blueprint"**
3. Selecciona tu repositorio `ReservaCancha`
4. Render detectará el archivo `render.yaml` y desplegará todo automáticamente

---

## 📋 Checklist de Despliegue

- [ ] Compilar backend (`.\PREPARAR-RENDER.ps1`)
- [ ] Compilar frontend (`.\PREPARAR-RENDER.ps1`)
- [ ] Subir código a GitHub (`.\SUBIR-A-GITHUB.ps1`)
- [ ] Crear Web Service para el backend en Render
- [ ] Configurar variables de entorno del backend
- [ ] Obtener URL del backend desplegado
- [ ] Actualizar `frontend/src/environments/environment.prod.ts` con la URL del backend
- [ ] Crear Static Site para el frontend en Render
- [ ] ¡Probar la aplicación! 🎉

---

## 🔗 URLs Útiles

- **Render Dashboard**: https://dashboard.render.com/
- **Crear nuevo repositorio en GitHub**: https://github.com/new
- **Guía completa de Render**: [GUIA-RENDER-COMPLETA.md](./GUIA-RENDER-COMPLETA.md)

---

## 📞 ¿Problemas?

1. Lee `GUIA-RENDER-COMPLETA.md` para solución de problemas
2. Revisa los logs en Render Dashboard
3. Verifica que todas las variables de entorno estén configuradas correctamente

---

## 🎯 Resumen

**En 3 comandos**:

```powershell
# 1. Preparar proyecto
.\PREPARAR-RENDER.ps1

# 2. Subir a GitHub
.\SUBIR-A-GITHUB.ps1

# 3. Ver instrucciones de despliegue
.\DESPLEGAR-EN-RENDER.ps1
```

**¡Eso es todo! 🚀**

