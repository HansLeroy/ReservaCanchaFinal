# 📋 Preguntas y Respuestas del Profesor - Sistema ReservaCancha

## 🎯 PREGUNTAS SOBRE FUNCIONALIDAD DEL SISTEMA

### P1: ¿Qué hace este sistema?
**R:** Es un sistema web de gestión de reservas de canchas deportivas para el centro deportivo "El Pinar". Permite digitalizar el proceso manual de reservas que antes se hacía con cuadernos y libretas, evitando problemas como dobles reservas, pérdida de información y falta de control financiero.

### P2: ¿Cuál es el problema que resuelve?
**R:** Resuelve los siguientes problemas:
- ❌ Dobles reservas por falta de control
- ❌ Pérdida de información de clientes y pagos
- ❌ Imposibilidad de generar reportes financieros
- ❌ Falta de trazabilidad de operaciones
- ❌ Proceso manual propenso a errores

### P3: ¿Quiénes son los usuarios del sistema?
**R:** El sistema tiene 3 tipos de usuarios:
- **ADMIN**: Administrador con acceso completo al sistema
- **RECEPCIONISTA**: Personal que gestiona reservas diarias
- **CLIENTE**: Usuarios que realizan las reservas

### P4: ¿Cuáles son los módulos principales?
**R:** El sistema tiene 8 módulos principales:
1. **Login** - Autenticación de usuarios
2. **Home** - Dashboard principal
3. **Canchas** - Gestión de canchas (CRUD)
4. **Reservas** - Crear y gestionar reservas
5. **Check-in** - Control de asistencia
6. **Cancelar Reserva** - Gestión de cancelaciones
7. **Reportes** - Informes financieros y estadísticas
8. **Usuarios** - Administración de usuarios del sistema

---

## 🏗️ PREGUNTAS SOBRE ARQUITECTURA TÉCNICA

### P5: ¿Qué arquitectura utiliza el sistema?
**R:** Utiliza una **arquitectura cliente-servidor de 3 capas**:
- **Frontend**: Angular 15 (Cliente web)
- **Backend**: Spring Boot 2.7.14 (API REST)
- **Base de Datos**: MySQL 8 (desarrollo) / PostgreSQL (producción)

### P6: ¿Cómo se comunica el frontend con el backend?
**R:** A través de servicios HTTP de Angular que consumen endpoints REST del backend. Los datos se intercambian en formato JSON usando el protocolo HTTP/HTTPS.

**Ejemplo:**
```typescript
// Frontend (Angular Service)
getCancha(id: number): Observable<Cancha> {
  return this.http.get<Cancha>(`${this.apiUrl}/canchas/${id}`);
}

// Backend (Spring Controller)
@GetMapping("/canchas/{id}")
public ResponseEntity<Cancha> getCancha(@PathVariable Long id) {
  return ResponseEntity.ok(canchaService.findById(id));
}
```

### P7: ¿Qué patrón arquitectónico usa el backend?
**R:** Utiliza el patrón **MVC (Model-View-Controller)** con arquitectura en capas:
- **Controller**: Maneja peticiones HTTP y respuestas
- **Service**: Contiene la lógica de negocio
- **Repository**: Acceso a datos (usando Spring Data JPA)
- **Model/Entity**: Representación de las tablas de BD

### P8: ¿Por qué usa dos bases de datos diferentes?
**R:** 
- **MySQL**: Para desarrollo local (más fácil de configurar)
- **PostgreSQL**: Para producción en Render (requisito de la plataforma cloud)
El sistema se adapta automáticamente según la variable `SPRING_DATASOURCE_URL`.

---

## 💾 PREGUNTAS SOBRE BASE DE DATOS

### P9: ¿Cuáles son las entidades principales?
**R:** Las 6 entidades principales son:
1. **Usuario**: Usuarios del sistema (admin, recepcionista, cliente)
2. **Cliente**: Clientes que reservan canchas
3. **Cancha**: Canchas deportivas disponibles
4. **Reserva**: Reservas realizadas
5. **Pago**: Pagos asociados a reservas
6. **Horario**: Horarios de disponibilidad de canchas

### P10: ¿Cómo se relacionan las entidades principales?
**R:**
```
Cliente (1) ----< (N) Reserva
Cancha  (1) ----< (N) Reserva
Reserva (1) ---- (1) Pago
Cancha  (1) ----< (N) Horario
Usuario (1) ----< (N) Reserva (como operador)
```

### P11: ¿Cómo se previenen las dobles reservas?
**R:** Mediante 3 mecanismos:
1. **Validación en BD**: Restricción UNIQUE en (cancha_id, fecha, hora_inicio)
2. **Validación en Service**: Verificación de disponibilidad antes de guardar
3. **Validación en Frontend**: Mostrar solo horarios disponibles en tiempo real

---

## ⏰ PREGUNTAS SOBRE HORARIOS Y DISPONIBILIDAD

### P12: ¿Desde qué hora hasta qué hora funciona el sistema?
**R:** El sistema permite reservas desde las **08:00 hasta las 23:00 horas**.

Este horario está definido en:
- **Frontend**: Restricciones `min="08:00"` y `max="23:00"` en inputs de hora
- **Backend**: Validación en el Service de Reservas
- **Array de horarios**: `['08:00', '09:00', ..., '22:00', '23:00']`

### P13: ¿Cómo se configuran los horarios de las canchas?
**R:** Los horarios se configuran a nivel de:
1. **Global**: Horario estándar 08:00-23:00
2. **Por cancha**: Cada cancha puede tener su propio horario de apertura y cierre
3. **Por día**: Se pueden definir horarios específicos por día de la semana
4. **Excepciones**: Se pueden bloquear días festivos o por mantenimiento

### P14: ¿Por qué sale la hora 02:00 AM en el selector?
**R:** Esto ocurría porque el input `<input type="time">` no tenía restricciones. Se solucionó agregando:
```html
<input type="time" 
       min="08:00" 
       max="23:00"
       [(ngModel)]="horaInicio">
```

### P15: ¿Cómo se valida que las horas estén en el rango permitido?
**R:** Con validación en el método `validarFormulario()`:
```typescript
const [horaIni] = this.horaInicio.split(':').map(Number);
const [horaFin] = this.horaFin.split(':').map(Number);

if (horaIni < 8 || horaIni >= 23) {
  this.errorMessage = 'La hora de inicio debe estar entre las 08:00 y las 23:00';
  return false;
}
```

---

## 🔐 PREGUNTAS SOBRE SEGURIDAD

### P16: ¿Cómo se autentica un usuario?
**R:** Sistema de autenticación basado en **sesión**:
1. Usuario ingresa email y contraseña
2. Backend valida credenciales en BD
3. Si es válido, guarda usuario en sesión HTTP
4. Frontend guarda datos en `localStorage`
5. Cada petición incluye datos de sesión

### P17: ¿Las contraseñas están encriptadas?
**R:** **Actualmente NO** - Las contraseñas se guardan en texto plano (solo para propósitos académicos). En producción real se debería usar BCrypt:
```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

### P18: ¿Qué roles existen y qué permisos tienen?
**R:**
| Rol | Permisos |
|-----|----------|
| **ADMIN** | Acceso total: gestión de usuarios, canchas, reservas, reportes |
| **RECEPCIONISTA** | Crear reservas, check-in, cancelar reservas, ver reportes |
| **CLIENTE** | Ver canchas disponibles, hacer reservas propias |

---

## 🛠️ PREGUNTAS SOBRE TECNOLOGÍAS

### P19: ¿Qué tecnologías usa el backend?
**R:**
- **Java 11** - Lenguaje de programación
- **Spring Boot 2.7.14** - Framework principal
- **Spring Data JPA** - Capa de persistencia
- **Hibernate** - ORM para mapeo objeto-relacional
- **MySQL 8 / PostgreSQL** - Base de datos
- **HikariCP** - Pool de conexiones optimizado
- **Maven** - Gestor de dependencias

### P20: ¿Qué tecnologías usa el frontend?
**R:**
- **Angular 15** - Framework SPA
- **TypeScript** - Lenguaje tipado
- **RxJS** - Programación reactiva
- **HttpClient** - Peticiones HTTP
- **Bootstrap 5** - Estilos responsive
- **XLSX** - Exportación a Excel

### P21: ¿Por qué usa Maven y no Gradle?
**R:** Maven fue elegido por:
- Mayor estabilidad y madurez
- Documentación más extensa
- Mejor compatibilidad con Spring Boot
- Sintaxis XML más clara para principiantes
- Convención sobre configuración

### P22: ¿Qué es HikariCP y por qué se usa?
**R:** HikariCP es un **pool de conexiones** de alto rendimiento. Se usa porque:
- Reutiliza conexiones en lugar de crearlas cada vez
- Reduce latencia de conexión a BD
- Mejora el rendimiento hasta 10x
- Es el pool por defecto de Spring Boot

---

## 🚀 PREGUNTAS SOBRE DESPLIEGUE Y PRODUCCIÓN

### P23: ¿Dónde está desplegado el sistema?
**R:** 
- **Backend**: Render (https://reservacancha-backend.onrender.com)
- **Frontend**: Render Static Site
- **Base de Datos**: PostgreSQL en Render

### P24: ¿Cómo se ejecuta el sistema localmente?
**R:**
```powershell
# Backend
cd backend
mvnw.cmd spring-boot:run

# Frontend
cd frontend
npm install
ng serve
```

### P25: ¿Qué es Docker y por qué se usa?
**R:** Docker es una plataforma de contenedores que:
- Empaqueta la aplicación con todas sus dependencias
- Garantiza que funcione igual en cualquier entorno
- Facilita el despliegue en cloud
- Incluye Java, Maven y el JAR compilado

---

## ⚡ PREGUNTAS SOBRE OPTIMIZACIÓN

### P26: ¿Cuánto tarda el login?
**R:** **Menos de 100ms** después de las optimizaciones aplicadas:
- Eliminación de logging excesivo
- Índices en columnas `email` y `rut`
- Optimización de HikariCP
- Caché de prepared statements

### P27: ¿Qué optimizaciones se aplicaron al login?
**R:**
1. ✅ Eliminación de `System.out.println`
2. ✅ Índices en BD para búsquedas rápidas
3. ✅ Configuración de pool de conexiones
4. ✅ Caché de prepared statements MySQL
5. ✅ Desactivación de SQL logging en producción

---

## 📊 PREGUNTAS SOBRE REPORTES

### P28: ¿Qué reportes genera el sistema?
**R:**
1. **Ingresos por período**: Total recaudado en rango de fechas
2. **Reservas por cancha**: Ocupación de cada cancha
3. **Clientes frecuentes**: Top clientes por número de reservas
4. **Métodos de pago**: Distribución de formas de pago
5. **Exportación a Excel**: Todos los reportes son descargables

### P29: ¿Cómo se exportan los reportes a Excel?
**R:** Usando la librería **XLSX** en el frontend:
```typescript
import * as XLSX from 'xlsx';

exportarExcel(): void {
  const ws = XLSX.utils.json_to_sheet(this.datos);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Reporte');
  XLSX.writeFile(wb, 'reporte.xlsx');
}
```

---

## 📈 PREGUNTAS SOBRE METODOLOGÍA ÁGIL

### P30: ¿Qué metodología se usó para desarrollar el sistema?
**R:** **Metodología Ágil (Scrum/Iterativo-Incremental)** con:
- Desarrollo en sprints
- Entregas incrementales
- Feedback continuo
- Refactorización constante
- Documentación evolutiva

### P31: ¿Cuáles fueron los sprints del proyecto?
**R:**
- **Sprint 1 (MVP)**: Login, Home, CRUD Canchas, Reservas básicas
- **Sprint 2**: Check-in, Cancelaciones, Gestión de Usuarios
- **Sprint 3**: Reportes, Exportación Excel, Optimizaciones
- **Sprint 4**: Dockerización, Despliegue en Render, Configuración PostgreSQL

### P32: ¿Qué evidencias hay de metodología ágil?
**R:**
1. ✅ Commits frecuentes e incrementales
2. ✅ Desarrollo modular por componentes
3. ✅ Ciclos de refactorización (feat → fix → optimize)
4. ✅ Priorización tipo backlog
5. ✅ Documentación evolutiva (.md files)

---

## 🔧 PREGUNTAS SOBRE CÓDIGO Y BUENAS PRÁCTICAS

### P33: ¿Qué patrones de diseño se usaron?
**R:**
- **MVC**: Separación de responsabilidades
- **Repository Pattern**: Acceso a datos
- **Service Layer**: Lógica de negocio
- **DTO Pattern**: Transferencia de datos
- **Dependency Injection**: Inyección de dependencias (Spring)

### P34: ¿Cómo se maneja el CORS?
**R:** Con `@CrossOrigin` en los controllers:
```java
@CrossOrigin(origins = "http://localhost:4200")
@RestController
@RequestMapping("/api/canchas")
public class CanchaController {
    // ...
}
```

### P35: ¿Qué es JPA y Hibernate?
**R:**
- **JPA** (Java Persistence API): Especificación estándar para ORM en Java
- **Hibernate**: Implementación de JPA que mapea objetos Java a tablas SQL
- Permite trabajar con objetos en lugar de escribir SQL manualmente

---

## 🎓 PREGUNTAS TÍPICAS DE DEFENSA

### P36: ¿Cuál fue el mayor desafío técnico?
**R:** La **optimización del login** que tardaba 5 minutos. Se solucionó identificando cuellos de botella:
- Logging excesivo a consola
- Falta de índices en BD
- Pool de conexiones no optimizado

### P37: ¿Qué aprendiste con este proyecto?
**R:**
- Arquitectura cliente-servidor completa
- Integración Angular + Spring Boot
- Gestión de BD relacionales con JPA
- Optimización de consultas y rendimiento
- Despliegue en cloud (Render)
- Metodología ágil en la práctica

### P38: ¿Qué mejorarías del sistema?
**R:**
1. Implementar JWT para autenticación stateless
2. Encriptar contraseñas con BCrypt
3. Agregar tests unitarios y de integración
4. Implementar sistema de notificaciones (email/SMS)
5. Panel de analytics en tiempo real
6. App móvil nativa
7. Integración con pasarelas de pago reales

### P39: ¿Cómo escalaría el sistema?
**R:**
1. **Base de datos**: Replicación master-slave
2. **Backend**: Múltiples instancias con load balancer
3. **Cache**: Redis para sesiones y consultas frecuentes
4. **CDN**: CloudFlare para assets estáticos
5. **Microservicios**: Separar reservas, pagos, notificaciones

### P40: ¿El sistema está listo para producción real?
**R:** **Parcialmente**. Funciona correctamente pero necesita:
- ✅ Ya tiene: Arquitectura sólida, optimizaciones, despliegue cloud
- ❌ Falta: Seguridad robusta (JWT, BCrypt), tests automatizados, monitoreo
- ❌ Falta: Integración con pagos reales, notificaciones, backups automatizados

---

## 🎯 RESPUESTAS RÁPIDAS (Para respuestas cortas)

**¿Lenguaje backend?** → Java 11 con Spring Boot
**¿Lenguaje frontend?** → TypeScript con Angular 15
**¿Base de datos?** → MySQL (dev) / PostgreSQL (prod)
**¿Gestor de dependencias?** → Maven (backend), NPM (frontend)
**¿Patrón arquitectónico?** → MVC en capas
**¿Puerto del backend?** → 8080
**¿Puerto del frontend?** → 4200
**¿ORM usado?** → Hibernate con Spring Data JPA
**¿Horario de reservas?** → 08:00 a 23:00
**¿Tiempo de login?** → <100ms
**¿Plataforma de despliegue?** → Render

---

## 📝 PREGUNTAS SOBRE IMPLEMENTACIÓN ESPECÍFICA

### P41: ¿Cómo funciona el check-in?
**R:** Permite registrar la asistencia del cliente:
1. Busca reservas confirmadas para hoy
2. Muestra reservas próximas o en curso
3. Al hacer check-in cambia estado de `CONFIRMADA` a `EN_CURSO`
4. Registra la hora exacta de llegada del cliente

### P42: ¿Cómo se cancelan las reservas?
**R:** Proceso de cancelación:
1. Busca reservas por RUT del cliente
2. Muestra solo reservas futuras y confirmadas
3. Al cancelar cambia estado a `CANCELADA`
4. Opcionalmente puede registrar motivo de cancelación
5. Libera el horario para nuevas reservas

### P43: ¿Qué estados tiene una reserva?
**R:**
- `PENDIENTE`: Reserva creada pero no confirmada
- `CONFIRMADA`: Reserva confirmada y pago registrado
- `EN_CURSO`: Cliente hizo check-in
- `COMPLETADA`: Reserva finalizada
- `CANCELADA`: Reserva cancelada por cliente o admin
- `NO_ASISTIO`: Cliente no llegó a la hora

---

## 🌟 CONSEJO FINAL PARA LA DEFENSA

**Prepárate para:**
1. ✅ **Demo en vivo**: Mostrar cada módulo funcionando
2. ✅ **Explicar código**: Saber explicar cualquier parte del código
3. ✅ **Arquitectura**: Dibujar el diagrama de arquitectura
4. ✅ **Base de datos**: Mostrar el diagrama ER
5. ✅ **Metodología**: Explicar proceso de desarrollo ágil
6. ✅ **Problemas encontrados**: Hablar de retos y soluciones
7. ✅ **Mejoras futuras**: Proponer evoluciones del sistema

**Frase clave para cerrar:**
> "Este sistema demuestra una implementación completa de arquitectura cliente-servidor moderna, aplicando principios SOLID, patrones de diseño, metodología ágil y buenas prácticas de desarrollo, listo para evolucionar hacia un producto escalable y de nivel empresarial."

---

**Última actualización:** 27/01/2026
**Autor:** Sistema ReservaCancha
**Versión:** 1.0.0

