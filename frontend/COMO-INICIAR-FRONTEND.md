# 🚀 Cómo Iniciar el Frontend (Vista de Login)

## ⚡ INICIO RÁPIDO

### Desde la terminal:
```powershell
cd C:\Users\hafer\IdeaProjects\ReservaCancha\frontend
npm start
```

### Desde Windows:
1. Abre una terminal CMD o PowerShell
2. Ejecuta los comandos de arriba
3. Espera a que compile (30-60 segundos)
4. Ve al navegador en la URL que muestre

---

## 🔍 Qué Buscar

En la terminal verás algo como:
```
** Angular Live Development Server is listening on localhost:4200 **
```

Esa es la URL donde debes ir en tu navegador.

---

## 🌐 URLs Comunes

- **Puerto por defecto**: http://localhost:4200
- **Puerto alternativo**: http://localhost:60518 (si 4200 está ocupado)

---

## ❌ Solución de Problemas

### Error: "Cannot GET /"
- **Causa**: El servidor aún está compilando
- **Solución**: Espera 20-30 segundos y presiona F5

### Error: "ERR_CONNECTION_REFUSED"
- **Causa**: El servidor no está corriendo
- **Solución**: Ejecuta `npm start` en la carpeta frontend

### Error: "Port 4200 is already in use"
- **Causa**: Hay otro servidor usando el puerto
- **Solución**: Angular preguntará si quieres usar otro puerto, responde "Yes"

### Servidor se cierra solo
- **Causa**: Error de compilación
- **Solución**: 
  1. Lee el error en la terminal
  2. Si dice algo de "spec.ts", es normal (archivos de prueba)
  3. El servidor debería seguir corriendo

---

## 🛑 Detener el Servidor

1. Ve a la ventana CMD/PowerShell donde está corriendo
2. Presiona `Ctrl + C`
3. Confirma con `S` o `Y`

---

## 🔄 Reiniciar el Servidor

Si el servidor está dando problemas:

1. Detén el servidor (Ctrl + C)
2. Limpia caché: `npm cache clean --force`
3. Reinstala dependencias: `npm install`
4. Inicia de nuevo: `npm start`

---

## 📝 Comandos Útiles

```powershell
# Ver qué está usando el puerto 4200
netstat -ano | findstr :4200

# Matar proceso en puerto 4200 (si está atascado)
# Primero encuentra el PID con el comando de arriba
# Luego ejecuta:
taskkill /PID [NUMERO_PID] /F

# Verificar versión de Node
node --version

# Verificar versión de npm
npm --version

# Verificar versión de Angular CLI
npx ng version
```

---

## ✨ Vista de Login Incluye

- 🎨 Diseño deportivo moderno
- 📝 Formulario de correo y contraseña
- 👁️ Botón mostrar/ocultar contraseña
- ✉️ Validación de email
- 🔔 Mensajes de error
- ⚽🏀🎾⚾ Iconos deportivos animados
- 📱 Diseño responsive

---

## 🆘 ¿Necesitas Ayuda?

Si algo no funciona:
1. Verifica que Node.js esté instalado: `node --version`
2. Verifica que npm funcione: `npm --version`
3. Lee los errores en la terminal
4. Busca el error en Google o pídeme ayuda

---

## 📍 Ubicación de Archivos

- **Componente**: `src/app/components/login.component.ts`
- **Template**: `src/app/components/login.component.html`
- **Estilos**: `src/app/components/login.component.css`
- **Módulo**: `src/app/app.module.ts`

---

**¡Disfruta de tu vista de login deportiva!** 🏆

