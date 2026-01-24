# Cómo Ejecutar el Proyecto desde IntelliJ IDEA

## El proyecto usa MAVEN (no Gradle)

### Paso 1: Configurar IntelliJ para Maven

1. **Abrir el proyecto como Maven:**
   - File → Open
   - Seleccionar el archivo `backend/pom.xml`
   - Elegir "Open as Project"

2. **Recargar el proyecto Maven:**
   - Abre la ventana Maven (View → Tool Windows → Maven)
   - Click en el ícono "Reload All Maven Projects" (círculo con flechas)

### Paso 2: Ejecutar el Backend

#### Opción A: Desde IntelliJ (Recomendado)

1. Abre el archivo: `backend/src/main/java/com/example/reservacancha/backend/ReservaCanchaBackendApplication.java`
2. Click derecho en la clase `ReservaCanchaBackendApplication`
3. Selecciona "Run 'ReservaCanchaBackendApplication.main()'"
4. El servidor iniciará en http://localhost:8080

#### Opción B: Desde PowerShell

```powershell
cd backend
.\start-backend.ps1
```

#### Opción C: Desde CMD/Batch

```batch
cd backend
mvnw.cmd spring-boot:run
```

### Paso 3: Verificar que el Backend está corriendo

Abre un navegador y ve a: http://localhost:8080

Deberías ver la página de inicio del sistema de reservas.

### APIs Disponibles

- GET http://localhost:8080/api/canchas - Lista todas las canchas
- GET http://localhost:8080/api/canchas/disponibles - Lista canchas disponibles
- GET http://localhost:8080/api/canchas/{id} - Obtiene una cancha por ID
- POST http://localhost:8080/api/canchas - Crea una nueva cancha
- PUT http://localhost:8080/api/canchas/{id} - Actualiza una cancha
- DELETE http://localhost:8080/api/canchas/{id} - Elimina una cancha
- PATCH http://localhost:8080/api/canchas/{id}/disponibilidad - Cambia disponibilidad

### Solución de Problemas

#### Error: "Port 8080 is already in use"

Detén el proceso que está usando el puerto 8080:

```powershell
# Buscar el proceso
netstat -ano | findstr :8080

# Matar el proceso (reemplaza PID con el número que aparece)
taskkill /PID <PID> /F
```

#### Error: IntelliJ dice "Does not contain Gradle"

El proyecto usa Maven, no Gradle. Sigue los pasos del Paso 1 para configurarlo correctamente.

## Ejecutar el Frontend

Ver instrucciones en `frontend/COMO-INICIAR-FRONTEND.md`

