# 🔐 Vista de Login - ReservaCancha

## 📋 Descripción

Vista de login moderna y atractiva con temática deportiva para el sistema de reserva de canchas deportivas.

## 🎨 Características de Diseño

### Visual
- **Gradiente deportivo**: Combinación de azul profundo y púrpura vibrante
- **Patrón de fondo animado**: Efecto de movimiento sutil
- **Tarjeta flotante**: Diseño glassmorphism con sombras suaves
- **Iconos SVG**: Diseño vectorial limpio y escalable
- **Emojis deportivos**: ⚽ 🏀 🎾 ⚾ con animaciones bounce

### Interactividad
- ✅ Validación en tiempo real del correo electrónico
- 👁️ Botón para mostrar/ocultar contraseña
- 🔔 Mensajes de error animados
- ⚡ Efectos hover y transiciones suaves
- 📱 Diseño completamente responsive

## 🎯 Funcionalidades

### Campos del Formulario
1. **Correo Electrónico**
   - Validación de formato de email
   - Icono de sobre
   - Placeholder: "tu@correo.com"

2. **Contraseña**
   - Toggle para mostrar/ocultar
   - Icono de candado
   - Placeholder: "••••••••"

3. **Recordarme**
   - Checkbox opcional
   - Guarda la sesión del usuario

4. **¿Olvidaste tu contraseña?**
   - Link para recuperación

### Validaciones
- ✉️ Formato de correo válido
- 🔒 Campos obligatorios
- ⚠️ Mensajes de error claros

## 🎨 Paleta de Colores

### Principales
- **Azul Oscuro**: `#1e3c72`
- **Azul Medio**: `#2a5298`
- **Púrpura**: `#7e22ce`
- **Púrpura Oscuro**: `#6b21a8`

### Secundarios
- **Texto Principal**: `#1e293b`
- **Texto Secundario**: `#64748b`
- **Texto Placeholder**: `#94a3b8`
- **Bordes**: `#e2e8f0`
- **Fondo**: `#f8fafc`

### Estados
- **Error**: `#dc2626` (rojo)
- **Fondo Error**: `#fee2e2`
- **Hover**: Tonos más oscuros de los colores principales

## 📱 Responsive

### Desktop (>640px)
- Tarjeta de 440px de ancho
- Padding generoso
- Iconos deportivos grandes

### Mobile (<640px)
- Tarjeta adaptada al ancho
- Padding reducido
- Opciones del formulario en columna
- Iconos deportivos más pequeños

## 🔄 Animaciones

### Al Cargar
- **slideIn**: Entrada suave de la tarjeta desde abajo
- **fadeIn**: Aparición gradual de elementos
- **patternMove**: Movimiento continuo del patrón de fondo

### Interacciones
- **pulse**: Logo con efecto de respiración
- **bounce**: Iconos deportivos rebotando
- **shake**: Mensaje de error con sacudida
- **hover**: Transformaciones y cambios de color

## 🛠️ Estructura de Archivos

```
frontend/src/app/components/
├── login.component.ts      # Lógica del componente
├── login.component.html    # Template HTML
└── login.component.css     # Estilos CSS
```

## 💻 Uso del Componente

```typescript
// En app.module.ts
import { LoginComponent } from './components/login.component';

@NgModule({
  declarations: [
    LoginComponent
  ],
  imports: [
    FormsModule  // Requerido para ngModel
  ]
})
```

```html
<!-- En cualquier template -->
<app-login></app-login>
```

## 🔐 Validación de Correo

```typescript
isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
```

## 🚀 Próximas Mejoras

### Funcionalidad
- [ ] Integración con backend para autenticación real
- [ ] Manejo de tokens JWT
- [ ] Recordar sesión con localStorage
- [ ] Recuperación de contraseña funcional
- [ ] Registro de usuarios
- [ ] Login con redes sociales (Google, Facebook)

### UX/UI
- [ ] Indicador de fuerza de contraseña
- [ ] Modo oscuro
- [ ] Más animaciones de carga
- [ ] Feedback háptico en móvil
- [ ] Captcha para seguridad

### Accesibilidad
- [ ] Mejorar ARIA labels
- [ ] Navegación por teclado
- [ ] Contraste de colores WCAG AA
- [ ] Soporte para lectores de pantalla

## 📝 Ejemplo de Uso

```typescript
// Ejemplo de datos de prueba
email: 'usuario@ejemplo.com'
password: '12345678'

// Al hacer submit, muestra un alert de bienvenida
// En producción, esto se reemplazaría con:
// - Llamada al API de autenticación
// - Guardado de token
// - Redirección al dashboard
```

## 🎯 Tips de Personalización

### Cambiar Colores
Edita las variables en `login.component.css`:
```css
/* Cambiar gradiente principal */
background: linear-gradient(135deg, #TU_COLOR_1, #TU_COLOR_2);

/* Cambiar color de botones */
.btn-login {
  background: linear-gradient(135deg, #TU_COLOR, #TU_COLOR_OSCURO);
}
```

### Agregar Más Deportes
```html
<div class="sports-icons">
  <div class="sport-icon">⚽</div>
  <div class="sport-icon">🏀</div>
  <div class="sport-icon">🎾</div>
  <div class="sport-icon">⚾</div>
  <div class="sport-icon">🏐</div> <!-- Nuevo -->
  <div class="sport-icon">🏈</div> <!-- Nuevo -->
</div>
```

## 🌟 Características Destacadas

1. **🎨 Diseño Moderno**: Uso de glassmorphism y gradientes
2. **⚡ Performance**: Animaciones con CSS (sin JavaScript pesado)
3. **📱 Mobile-First**: Diseño responsive desde el inicio
4. **♿ Accesible**: Etiquetas semánticas y ARIA básico
5. **🔒 Seguro**: Validaciones client-side
6. **🎭 Atractivo**: Iconos deportivos y animaciones divertidas

---

**¡Disfruta de tu nueva vista de login deportiva!** 🏆

