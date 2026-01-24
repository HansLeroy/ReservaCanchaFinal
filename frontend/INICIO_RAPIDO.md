# 🚀 GUÍA RÁPIDA DE INICIO

## ✅ Lo que ya está hecho:

1. **Backend completo con patrón MVC**
   - ✅ Modelos: `Cancha.java`, `Reserva.java`
   - ✅ Repositorios: `CanchaRepository.java`, `ReservaRepository.java`
   - ✅ Servicios: `CanchaService.java`, `ReservaService.java`
   - ✅ Controladores REST: `CanchaController.java`, `ReservaController.java`

2. **Frontend base configurado**
   - ✅ Angular 15 instalado
   - ✅ Dependencias instaladas (934 paquetes)

3. **Documentación**
   - ✅ PROJECT_README.md
   - ✅ backend/SETUP.md
   - ✅ frontend/SETUP.md
   - ✅ RESUMEN_PROYECTO.txt

---

## 🎯 PARA EMPEZAR AHORA:

### Paso 1: Instalar Maven

**Ejecuta el script de ayuda:**
```powershell
cd backend
.\install-maven.ps1
```

O instala manualmente con Chocolatey:
```powershell
choco install maven -y
```

### Paso 2: Iniciar el Backend

```powershell
cd backend
mvn clean install
mvn spring-boot:run
```

✓ Backend corriendo en: **http://localhost:8080**

### Paso 3: Iniciar el Frontend (en otra terminal)

```powershell
cd frontend
npm start
```

✓ Frontend corriendo en: **http://localhost:4200**

---

## 🧪 PROBAR LA API

Una vez que el backend esté corriendo, puedes probar los endpoints:

### Ver las canchas disponibles:
```
GET http://localhost:8080/api/canchas
```

### Crear una reserva:
```
POST http://localhost:8080/api/reservas
Content-Type: application/json

{
  "canchaId": 1,
  "nombreCliente": "Juan Pérez",
  "emailCliente": "juan@example.com",
  "telefonoCliente": "123456789",
  "fechaHoraInicio": "2025-12-30T10:00:00",
  "fechaHoraFin": "2025-12-30T12:00:00"
}
```

Puedes usar:
- **Navegador** para GET requests
- **Postman** / **Insomnia** para todas las peticiones
- **curl** desde la terminal
- **Thunder Client** (extensión de VS Code)

---

## 📋 PRÓXIMOS PASOS RECOMENDADOS:

### Para el Frontend:

1. **Crear los modelos** (interfaces TypeScript):
   ```bash
   cd frontend/src/app
   mkdir models
   # Crear: models/cancha.model.ts
   # Crear: models/reserva.model.ts
   ```

2. **Crear los servicios**:
   ```bash
   ng generate service services/cancha
   ng generate service services/reserva
   ```

3. **Crear componentes**:
   ```bash
   ng generate component components/cancha-lista
   ng generate component components/cancha-detalle
   ng generate component components/reserva-form
   ng generate component components/reserva-lista
   ```

4. **Configurar el routing** en `app.module.ts`

5. **Agregar estilos** (Bootstrap, Material, etc.)

---

## 📚 DOCUMENTACIÓN COMPLETA:

- **Documentación general**: `PROJECT_README.md`
- **Backend detallado**: `backend/SETUP.md`
- **Frontend detallado**: `frontend/SETUP.md`
- **Resumen visual**: `RESUMEN_PROYECTO.txt`

---

## ❓ ¿PROBLEMAS?

### Maven no se reconoce:
1. Asegúrate de haber cerrado y reabierto la terminal después de instalar
2. Verifica el PATH del sistema
3. Ejecuta: `.\install-maven.ps1` para ayuda

### Puerto ocupado:
- Backend (8080): Cambia el puerto en `backend/src/main/resources/application.properties`
- Frontend (4200): Cambia en `frontend/angular.json`

### Error de CORS:
Ya está configurado en los controladores para permitir peticiones desde `http://localhost:4200`

---

## 🎉 ¡LISTO PARA DESARROLLAR!

El proyecto está completamente configurado con:
- ✅ Backend funcional con API REST completa
- ✅ Frontend base instalado
- ✅ Patrón MVC implementado
- ✅ CORS configurado
- ✅ Datos de ejemplo incluidos
- ✅ Documentación completa

**¡Solo instala Maven y ejecuta los comandos!** 🚀

