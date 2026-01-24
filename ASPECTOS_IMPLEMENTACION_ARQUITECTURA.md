# 📊 ASPECTOS DE IMPLEMENTACIÓN ARQUITECTURA
## Sistema de Reserva de Canchas Deportivas

---

## Tabla Resumen

| **Aspecto** | **Descripción** |
|-------------|-----------------|
| **Patrón arquitectónico** | Arquitectura de 3 capas y estilo arquitectónico REST. Cliente-Servidor con separación Frontend-Backend comunicándose mediante API RESTful. |
| **Frontend** | Framework Principal: **Angular 15.2.0**, Lenguaje: **TypeScript 4.9**, Librerías: **RxJS 7.8** (Programación Reactiva), **XLSX 0.18.5** (Exportación Excel). Puerto: **4500**. |
| **Backend** | Framework: **Spring Boot 2.7.14**, Lenguaje: **Java 11**, Build: **Maven 3.8+**, Servidor: **Apache Tomcat 9.x** embebido. Puerto: **8080**. API REST con endpoints HTTP. |
| **Base de datos** | Motor: **MySQL 8.0** con **Spring Data JPA/Hibernate**. Base de datos: **reservas_canchas**. Puerto: **3306**. 6 tablas relacionales con persistencia real. |
| **Infraestructura** | Despliegue en **localhost** para desarrollo (Frontend: 4500, Backend: 8080, MySQL: 3306). Comunicación HTTP/REST con JSON. Scripts .bat/.ps1 para Windows. Producción: Build con `ng build --prod` (Frontend) y `mvn package` .jar (Backend). |
| **Integración** | Frontend Angular consume API RESTful del Backend Spring Boot mediante HttpClient. Formato de datos: JSON. CORS habilitado entre puertos 4500 y 8080. Backend se conecta a MySQL mediante JDBC con Spring Data JPA. |

---

## Detalles Técnicos por Componente

### 🎨 FRONTEND - Angular 15.2.0

**Tecnologías:**
- Framework: Angular 15.2.0
- Lenguaje: TypeScript 4.9.0
- Programación Reactiva: RxJS 7.8.0
- Exportación: XLSX 0.18.5
- Build: Angular CLI 15.2.0

**Arquitectura:**
- Patrón: Component-Based + MVC
- Tipo: Single Page Application (SPA)
- Puerto: 4500

**Componentes:**
- `login.component` - Autenticación
- `registro.component` - Registro de usuarios
- `home.component` - Página principal
- `reserva.component` - Gestión de reservas
- `cancelar-reserva.component` - Cancelación
- `reportes.component` - Reportes y estadísticas
- `usuarios.component` - Administración de usuarios

**Servicios:**
- `auth.service` - Autenticación
- `usuario.service` - Gestión de usuarios
- `cliente.service` - Gestión de clientes
- `cancha.service` - Gestión de canchas
- `reserva.service` - Gestión de reservas
- `reporte.service` - Generación de reportes

---

### ⚙️ BACKEND - Spring Boot 2.7.14

**Tecnologías:**
- Framework: Spring Boot 2.7.14
- Lenguaje: Java 11
- Build Tool: Maven 3.8+
- Servidor: Apache Tomcat 9.x (embebido)
- ORM: Spring Data JPA con Hibernate
- Puerto: 8080

**Arquitectura:**
- Patrón: MVC + Repository Pattern
- Capas: Controller → Service → Repository
- API: RESTful con JSON

**Módulos Spring Boot:**
- `spring-boot-starter-web` - REST API
- `spring-boot-starter-data-jpa` - Persistencia
- `spring-boot-starter-validation` - Validaciones
- `mysql-connector-j` - Driver MySQL

**Controladores REST:**
- `AuthController` - /api/auth
- `UsuarioController` - /api/usuarios
- `ClienteController` - /api/clientes
- `CanchaController` - /api/canchas
- `HorarioController` - /api/horarios
- `ReservaController` - /api/reservas
- `ReporteController` - /api/reportes

---

### 🗄️ BASE DE DATOS - MySQL 8.0

**Configuración:**
- Motor: MySQL Community Server 8.0
- Base de datos: `reservas_canchas`
- Puerto: 3306
- Usuario: root
- Charset: utf8mb4
- ORM: Hibernate (JPA)

**Tablas (6):**
1. `usuario` - Usuarios del sistema (admin, recepcionista, cliente)
2. `cliente` - Clientes que reservan canchas
3. `cancha` - Canchas deportivas disponibles
4. `horario` - Horarios de operación por cancha
5. `reserva` - Reservas realizadas
6. `pago` - Pagos asociados a reservas

**Características:**
- Persistencia real con Spring Data JPA
- Generación automática de schema (Hibernate DDL)
- Integridad referencial con Foreign Keys
- Transacciones ACID
- Índices en campos frecuentes

**Relaciones:**
- USUARIO (1:N) → RESERVA
- CLIENTE (1:N) → RESERVA
- CANCHA (1:N) → HORARIO
- CANCHA (1:N) → RESERVA
- RESERVA (1:1) → PAGO

---

### 🌐 INFRAESTRUCTURA

**Entorno de Desarrollo:**
```
Cliente (Browser) → Frontend (localhost:4500) → Backend (localhost:8080) → MySQL (localhost:3306)
```

**Componentes:**
- **Servidor Web:** Angular Dev Server (puerto 4500)
- **Servidor de Aplicaciones:** Tomcat embebido (puerto 8080)
- **Base de Datos:** MySQL Server (puerto 3306)

**Scripts de Inicio (Windows):**
- `START-FRONTEND.bat` - Inicia Angular
- `INICIAR-BACKEND.bat` - Inicia Spring Boot
- `INICIAR-SISTEMA-COMPLETO.bat` - Inicia ambos

**Comunicación:**
- Frontend ↔ Backend: HTTP/REST con JSON
- Backend ↔ Base de Datos: JDBC (Spring Data JPA)
- CORS: Habilitado entre puertos 4500 y 8080

**Despliegue en Producción:**
- Frontend: `ng build --prod` → Archivos estáticos en /dist
- Backend: `mvn package` → JAR ejecutable
- Base de Datos: MySQL en servidor dedicado

---

### 🔗 INTEGRACIÓN

**Frontend → Backend:**
```typescript
// Angular HttpClient
this.reservaService.crear(reserva).subscribe(
  response => { /* Reserva creada */ },
  error => { /* Manejar error */ }
);
```

**API REST Endpoints:**
```
GET    /api/reservas           - Listar todas
POST   /api/reservas           - Crear nueva
PUT    /api/reservas/{id}      - Actualizar
DELETE /api/reservas/{id}      - Cancelar
GET    /api/canchas            - Listar canchas
GET    /api/clientes           - Listar clientes
GET    /api/reportes/ganancias - Reporte de ganancias
```

**Backend → Base de Datos:**
```java
// Spring Data JPA Repository
@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Long> {
    List<Reserva> findByCanchaId(Long canchaId);
    List<Reserva> findByEstado(String estado);
}
```

**Flujo Completo:**
1. Usuario interactúa con Angular (localhost:4500)
2. Angular envía petición HTTP a Spring Boot (localhost:8080)
3. Spring Boot procesa con servicios y repositorios
4. Hibernate ejecuta SQL en MySQL (localhost:3306)
5. MySQL persiste datos en disco
6. Respuesta JSON vuelve a Angular
7. Angular actualiza la vista

---

## 🎯 Características Principales

### Frontend
✅ Arquitectura basada en componentes  
✅ Programación reactiva con RxJS  
✅ Validación de formularios  
✅ Exportación a Excel  
✅ Navegación sin recarga (SPA)  
✅ Consumo de API REST  

### Backend
✅ API RESTful con Spring Boot  
✅ Arquitectura en capas (MVC)  
✅ Inyección de dependencias  
✅ Manejo de excepciones  
✅ Logging de operaciones  
✅ CORS configurado  

### Base de Datos
✅ Persistencia real en MySQL  
✅ ORM con Spring Data JPA  
✅ Generación automática de schema  
✅ Transacciones ACID  
✅ Consultas optimizadas  
✅ Integridad referencial  

### Infraestructura
✅ Fácil despliegue local  
✅ Scripts automatizados  
✅ Arquitectura escalable  
✅ Separación frontend-backend  
✅ Comunicación HTTP/REST  

---

## 📋 Requisitos del Sistema

**Software Requerido:**
- Java JDK 11+
- Node.js 18+ y NPM 9+
- Maven 3.8+
- MySQL 8.0+
- IDE: IntelliJ IDEA / VSCode

**Hardware Mínimo:**
- Procesador: Intel Core i3 o equivalente
- RAM: 4 GB (8 GB recomendado)
- Disco: 2 GB libres
- Red: Conexión a Internet

---

**Sistema:** Reserva de Canchas Deportivas  
**Versión:** 2.0 con MySQL  
**Fecha:** Enero 2026  
**Stack:** Angular 15 + Spring Boot 2.7 + MySQL 8.0

