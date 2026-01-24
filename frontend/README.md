# 🎨 Frontend - ReservaCancha

Frontend de la aplicación de reserva de canchas deportivas construido con **Angular 15**.

---

## 🚀 Inicio Rápido

### Instalación (Solo primera vez)
```bash
npm install
```

### Desarrollo
```bash
npm start
```

La aplicación se abrirá en: **http://localhost:4200**

---

## 📁 Estructura

```
frontend/
├── src/
│   ├── app/
│   │   ├── components/        # Componentes de la aplicación
│   │   │   └── login/         # Componente de login
│   │   ├── app.component.ts   # Componente raíz
│   │   └── app.module.ts      # Módulo principal
│   ├── assets/                # Recursos estáticos
│   ├── styles.css             # Estilos globales
│   └── index.html             # HTML principal
├── package.json               # Dependencias npm
├── angular.json               # Configuración de Angular
└── tsconfig.json              # Configuración de TypeScript
```

---

## 🎯 Funcionalidades

### ✅ Implementado
- **Vista de Login**
  - Diseño deportivo moderno
  - Validación de email
  - Mostrar/ocultar contraseña
  - Mensajes de error
  - Responsive design
  - Animaciones suaves

### ⏳ Por Implementar
- Dashboard principal
- Lista de canchas
- Detalle de cancha
- Formulario de reserva
- Lista de reservas
- Perfil de usuario

---

## 🎨 Vista de Login

### Características
- 🎨 Gradiente deportivo azul-púrpura
- ⚡ Animaciones con CSS
- 👁️ Toggle de contraseña
- ✉️ Validación de email
- 📱 100% Responsive
- ⚽🏀🎾⚾ Iconos deportivos animados

### Componentes
- **login.component.ts** - Lógica del componente
- **login.component.html** - Template HTML
- **login.component.css** - Estilos (350+ líneas)

---

## 📝 Scripts Disponibles

```bash
# Desarrollo
npm start                 # Inicia servidor de desarrollo

# Compilación
npm run build            # Compila para producción
npm run build:dev        # Compila para desarrollo

# Tests
npm test                 # Ejecuta tests unitarios
npm run test:watch       # Tests en modo watch
npm run e2e              # Tests end-to-end

# Linting
npm run lint             # Verifica código
```

---

## 🛠️ Tecnologías

- **Angular**: 15.0.0
- **TypeScript**: 4.9.4
- **RxJS**: 7.8.0
- **Zone.js**: 0.12.0

### Dependencias de Desarrollo
- **Angular CLI**: 15.0.0
- **Karma**: Test runner
- **Jasmine**: Framework de testing

---

## 🌐 Configuración

### Puertos
- **Desarrollo**: 4200
- **Producción**: Configurable

### Backend API
- **URL**: http://localhost:8080
- **CORS**: Configurado automáticamente

---

## 🎨 Estilos

### Fuentes
- **Principal**: Inter (Google Fonts)
- **Fallback**: System fonts

### Colores Principales
```css
/* Azul Deportivo */
--primary-blue: #1e3c72;
--primary-purple: #7e22ce;

/* Gradiente */
background: linear-gradient(135deg, #1e3c72, #7e22ce);
```

---

## 📱 Responsive

El diseño se adapta a:
- 📱 Móviles (< 640px)
- 📱 Tablets (640px - 1024px)
- 💻 Desktop (> 1024px)

---

## 🔧 Comandos Útiles

### Ver puerto en uso
```bash
netstat -ano | findstr :4200
```

### Limpiar caché
```bash
npm cache clean --force
rm -rf node_modules
npm install
```

### Ver versión de Angular
```bash
npx ng version
```

---

## ⚠️ Solución de Problemas

### Error: "Cannot GET /"
**Causa**: Servidor aún compilando  
**Solución**: Espera 20-30 segundos y presiona F5

### Error: "Port 4200 is already in use"
**Causa**: Puerto ocupado  
**Solución**: Angular preguntará si quieres usar otro puerto, responde "Yes"

### Errores de compilación
```bash
# Reinstalar dependencias
rm -rf node_modules package-lock.json
npm install

# Limpiar caché
npm cache clean --force
```

---

## 📚 Documentación Adicional

- [COMO-INICIAR-FRONTEND.md](COMO-INICIAR-FRONTEND.md) - Guía de inicio
- [LOGIN_README.md](LOGIN_README.md) - Documentación del login
- [Angular Docs](https://angular.io/docs) - Documentación oficial

---

## 🔜 Próximos Pasos

1. **Dashboard**: Crear vista principal
2. **Canchas**: Lista y detalle
3. **Reservas**: Formulario y gestión
4. **Routing**: Configurar rutas
5. **Servicios HTTP**: Conectar con backend
6. **Autenticación**: Login funcional
7. **Guards**: Protección de rutas

---

## 🎯 Estructura Recomendada (Próxima)

```
src/app/
├── components/
│   ├── login/
│   ├── dashboard/
│   ├── canchas/
│   │   ├── cancha-lista/
│   │   └── cancha-detalle/
│   └── reservas/
│       ├── reserva-form/
│       └── reserva-lista/
├── services/
│   ├── auth.service.ts
│   ├── cancha.service.ts
│   └── reserva.service.ts
├── models/
│   ├── cancha.model.ts
│   └── reserva.model.ts
└── guards/
    └── auth.guard.ts
```

---

## ✨ Características Visuales

### Animaciones
- **fadeIn**: Entrada de elementos
- **slideIn**: Deslizamiento suave
- **bounce**: Iconos deportivos
- **shake**: Mensajes de error
- **pulse**: Logo animado

### Efectos
- **Glassmorphism**: Fondo semitransparente
- **Gradientes**: Colores deportivos
- **Sombras**: Profundidad visual
- **Hover**: Feedback interactivo

---

## 🆘 Ayuda

Si encuentras problemas:
1. Verifica la versión de Node: `node --version` (requiere 16+)
2. Verifica npm: `npm --version`
3. Revisa la consola del navegador (F12)
4. Lee los errores en la terminal

---

**¡Disfruta desarrollando!** 🚀

---

**Última actualización**: Diciembre 2025

