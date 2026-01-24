# Frontend - Sistema de Reserva de Canchas Deportivas

## Descripción
Frontend desarrollado con Angular 15 para el sistema de reserva de canchas deportivas. Se conecta con el backend REST API.

## Estructura del Proyecto

```
frontend/
├── src/
│   ├── app/
│   │   ├── components/       # Componentes de la aplicación (Vista)
│   │   ├── services/         # Servicios para consumir API (Controlador)
│   │   ├── models/           # Interfaces y modelos (Modelo)
│   │   ├── app.component.*
│   │   └── app.module.ts
│   ├── assets/               # Recursos estáticos
│   ├── environments/         # Configuración de entornos
│   ├── index.html
│   ├── main.ts
│   └── styles.css
├── angular.json
├── package.json
└── tsconfig.json
```

## Tecnologías Utilizadas
- Angular 15
- TypeScript 4.9
- RxJS 7.8
- Angular Router
- Angular Forms

## Requisitos Previos
- **Node.js 16 o superior**
  - Descargar desde: https://nodejs.org/
- **npm** (incluido con Node.js)

## Instalación

### Opción 1: Usando el script de instalación
```powershell
cd frontend
.\install.ps1
```

### Opción 2: Manual
```powershell
cd frontend
npm install
```

## Ejecutar la Aplicación

### Modo desarrollo
```powershell
npm start
```
Esto iniciará el servidor en http://localhost:4200 y abrirá el navegador automáticamente.

### Modo desarrollo sin abrir navegador
```powershell
npm run ng serve
```

### Build para producción
```powershell
npm run build
```

## Scripts Disponibles
- `npm start` - Inicia el servidor de desarrollo y abre el navegador
- `npm run build` - Compila la aplicación para producción
- `npm run watch` - Compila en modo watch
- `npm test` - Ejecuta las pruebas unitarias

## Estructura de Componentes Recomendada

### Componentes a crear:
1. **Lista de Canchas** - Muestra todas las canchas disponibles
2. **Detalle de Cancha** - Información detallada de una cancha
3. **Formulario de Reserva** - Para crear nuevas reservas
4. **Lista de Reservas** - Muestra las reservas del usuario
5. **Gestión de Canchas** (Admin) - CRUD de canchas

### Servicios a crear:
1. **CanchaService** - Consume API de canchas
2. **ReservaService** - Consume API de reservas

### Modelos a crear:
1. **Cancha** - Interface para canchas
2. **Reserva** - Interface para reservas

## Conexión con el Backend

El frontend se conecta al backend en: `http://localhost:8080`

Configurar en `src/environments/environment.ts`:
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api'
};
```

## Ejemplo de Servicio

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CanchaService {
  private apiUrl = `${environment.apiUrl}/canchas`;

  constructor(private http: HttpClient) { }

  getCanchas(): Observable<Cancha[]> {
    return this.http.get<Cancha[]>(this.apiUrl);
  }

  getCanchaById(id: number): Observable<Cancha> {
    return this.http.get<Cancha>(`${this.apiUrl}/${id}`);
  }

  createCancha(cancha: Cancha): Observable<Cancha> {
    return this.http.post<Cancha>(this.apiUrl, cancha);
  }
}
```

## Próximos Pasos

1. Crear los modelos/interfaces (Cancha, Reserva)
2. Crear los servicios para consumir la API
3. Crear los componentes de la aplicación
4. Implementar el routing
5. Agregar estilos y diseño responsive

## Notas
- Asegúrate de que el backend esté corriendo en http://localhost:8080
- El frontend usa el puerto 4200 por defecto
- CORS está configurado en el backend para permitir peticiones desde localhost:4200

