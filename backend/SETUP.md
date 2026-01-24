# Backend - Sistema de Reserva de Canchas Deportivas

## Descripción
Backend desarrollado con Spring Boot y Maven que implementa el patrón Modelo-Vista-Controlador (MVC) para gestionar reservas de canchas deportivas.

## Estructura del Proyecto (Patrón MVC)

```
backend/
├── src/main/java/com/example/reservacancha/backend/
│   ├── controller/          # Controladores REST (Capa de presentación)
│   │   ├── HomeController.java
│   │   ├── CanchaController.java
│   │   └── ReservaController.java
│   ├── service/             # Servicios (Lógica de negocio)
│   │   ├── CanchaService.java
│   │   └── ReservaService.java
│   ├── model/               # Modelos/Entidades (Capa de datos)
│   │   ├── Cancha.java
│   │   └── Reserva.java
│   ├── repository/          # Repositorios (Acceso a datos)
│   │   ├── CanchaRepository.java
│   │   └── ReservaRepository.java
│   └── ReservaCanchaBackendApplication.java
└── pom.xml
```

## Tecnologías Utilizadas
- Java 11
- Spring Boot 2.7.14
- Maven
- Spring Web (REST APIs)
- Thymeleaf (opcional para vistas)

## Requisitos Previos
1. **Java JDK 11 o superior**
   - Descargar desde: https://www.oracle.com/java/technologies/javase-downloads.html
   
2. **Maven**
   - Descargar desde: https://maven.apache.org/download.cgi
   - Agregar Maven al PATH del sistema

## Instalación de Maven

### Windows (PowerShell como Administrador)
```powershell
# Opción 1: Usando Chocolatey
choco install maven

# Opción 2: Descarga manual
# 1. Descargar Maven desde https://maven.apache.org/download.cgi
# 2. Extraer en C:\Program Files\Apache\maven
# 3. Agregar al PATH: C:\Program Files\Apache\maven\bin
```

### Verificar instalación
```powershell
mvn --version
```

## Compilar y Ejecutar

### 1. Limpiar e instalar dependencias
```powershell
cd backend
mvn clean install
```

### 2. Ejecutar la aplicación
```powershell
mvn spring-boot:run
```

### 3. Acceder a la aplicación
- Backend API: http://localhost:8080
- Home: http://localhost:8080

## API Endpoints

### Canchas
- `GET /api/canchas` - Obtener todas las canchas
- `GET /api/canchas/{id}` - Obtener una cancha por ID
- `GET /api/canchas/disponibles` - Obtener canchas disponibles
- `POST /api/canchas` - Crear una nueva cancha
- `PUT /api/canchas/{id}` - Actualizar una cancha
- `DELETE /api/canchas/{id}` - Eliminar una cancha
- `PATCH /api/canchas/{id}/disponibilidad?disponible=true` - Cambiar disponibilidad

### Reservas
- `GET /api/reservas` - Obtener todas las reservas
- `GET /api/reservas/{id}` - Obtener una reserva por ID
- `GET /api/reservas/cancha/{canchaId}` - Obtener reservas de una cancha
- `POST /api/reservas` - Crear una nueva reserva
- `PUT /api/reservas/{id}` - Actualizar una reserva
- `DELETE /api/reservas/{id}` - Eliminar una reserva
- `PATCH /api/reservas/{id}/confirmar` - Confirmar una reserva
- `PATCH /api/reservas/{id}/cancelar` - Cancelar una reserva

## Ejemplo de Uso (API)

### Crear una Cancha
```json
POST /api/canchas
Content-Type: application/json

{
  "nombre": "Cancha Fútbol 2",
  "tipo": "Fútbol",
  "descripcion": "Cancha de fútbol 7",
  "precioPorHora": 45.0,
  "disponible": true
}
```

### Crear una Reserva
```json
POST /api/reservas
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

## Configuración

El archivo `src/main/resources/application.properties` contiene la configuración del servidor:
```properties
server.port=8080
```

## Notas
- Este proyecto usa almacenamiento en memoria. Para producción, se recomienda integrar una base de datos (MySQL, PostgreSQL, etc.)
- CORS está habilitado para http://localhost:4200 (Frontend Angular)
- El cálculo del monto total de la reserva se hace automáticamente basado en las horas y el precio por hora de la cancha

