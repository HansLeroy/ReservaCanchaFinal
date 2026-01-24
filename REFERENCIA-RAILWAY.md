# ⚡ REFERENCIA RAPIDA - VARIABLES DE RAILWAY

## 🔧 Variables de Entorno para el Backend

Copia y pega estas variables en Railway (Tab "Variables" → "New Variable"):

```
SPRING_PROFILES_ACTIVE=prod
```

```
DB_HOST=
(copiar MYSQLHOST del servicio MySQL)
```

```
DB_PORT=
(copiar MYSQLPORT del servicio MySQL)
```

```
DB_NAME=
(copiar MYSQLDATABASE del servicio MySQL)
```

```
DB_USERNAME=
(copiar MYSQLUSER del servicio MySQL)
```

```
DB_PASSWORD=
(copiar MYSQLPASSWORD del servicio MySQL)
```

```
FRONTEND_URL=https://reserva-cancha-sistema.vercel.app
```

```
PORT=8080
```

---

## 📝 Checklist

- [ ] MySQL creado en Railway
- [ ] Copiadas las 5 variables de MySQL
- [ ] Repositorio GitHub conectado
- [ ] 8 variables agregadas al backend
- [ ] Dominio generado (Settings → Networking)
- [ ] URL copiada
- [ ] API probada en navegador (/api/canchas)

---

## ✅ Verificación

Después de generar el dominio, prueba:
```
https://TU-DOMINIO.up.railway.app/api/canchas
```

Deberías ver JSON con las canchas.

---

## 🔄 Si algo falla

1. Ve a "Deployments" → "View Logs"
2. Busca líneas con "ERROR" en rojo
3. Verifica que todas las variables estén correctas
4. El servicio MySQL debe estar "Active" (verde)

---

## 📞 Siguiente Paso

Cuando tengas la URL del backend funcionando, ejecuta:
```powershell
.\DESPLEGAR-FRONTEND.ps1 -BackendUrl "https://tu-backend.up.railway.app"
```

