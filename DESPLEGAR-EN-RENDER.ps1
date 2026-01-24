# Script para Despliegue en Render
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  DESPLIEGUE EN RENDER - Reserva Cancha" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Información de la base de datos desde Render
Write-Host "1. INFORMACIÓN DE TU BASE DE DATOS EN RENDER:" -ForegroundColor Yellow
Write-Host "   - Hostname: dpg-d5qf88c9c44c73d1tlag-a" -ForegroundColor White
Write-Host "   - Port: 5432" -ForegroundColor White
Write-Host "   - Database: reservacancha" -ForegroundColor White
Write-Host "   - Username: reservacancha" -ForegroundColor White
Write-Host "   - Password: [Visible en Render Dashboard]" -ForegroundColor White
Write-Host ""

# Paso 1: Verificar que el backend esté listo
Write-Host "2. COMPILANDO BACKEND..." -ForegroundColor Yellow
Set-Location backend
if (Test-Path "target\reservacancha-backend-0.0.1-SNAPSHOT.jar") {
    Write-Host "   ✓ JAR ya existe" -ForegroundColor Green
} else {
    Write-Host "   Compilando..." -ForegroundColor White
    .\mvnw clean package -DskipTests
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Backend compilado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Error al compilar backend" -ForegroundColor Red
        exit 1
    }
}
Set-Location ..
Write-Host ""

# Paso 2: Construir frontend
Write-Host "3. COMPILANDO FRONTEND..." -ForegroundColor Yellow
Set-Location frontend
if (Test-Path "dist\reservacancha-frontend") {
    Write-Host "   Limpiando compilación anterior..." -ForegroundColor White
    Remove-Item -Recurse -Force "dist\reservacancha-frontend"
}
npm run build -- --configuration production
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Frontend compilado exitosamente" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error al compilar frontend" -ForegroundColor Red
    exit 1
}
Set-Location ..
Write-Host ""

# Instrucciones para desplegar
Write-Host "4. PASOS PARA DESPLEGAR EN RENDER:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   A. BACKEND (Web Service):" -ForegroundColor Cyan
Write-Host "      1. Ve a https://dashboard.render.com/" -ForegroundColor White
Write-Host "      2. Click en 'New +' -> 'Web Service'" -ForegroundColor White
Write-Host "      3. Conecta tu repositorio de GitHub" -ForegroundColor White
Write-Host "      4. Configuración:" -ForegroundColor White
Write-Host "         - Name: reservacancha-backend" -ForegroundColor Gray
Write-Host "         - Environment: Java" -ForegroundColor Gray
Write-Host "         - Build Command: cd backend && ./mvnw clean package -DskipTests" -ForegroundColor Gray
Write-Host "         - Start Command: java -jar backend/target/reservacancha-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod" -ForegroundColor Gray
Write-Host "      5. Variables de entorno (Environment):" -ForegroundColor White
Write-Host "         - SPRING_PROFILES_ACTIVE=prod" -ForegroundColor Gray
Write-Host "         - DATABASE_URL=[Internal Database URL de tu DB]" -ForegroundColor Gray
Write-Host "         - DB_HOST=dpg-d5qf88c9c44c73d1tlag-a" -ForegroundColor Gray
Write-Host "         - DB_PORT=5432" -ForegroundColor Gray
Write-Host "         - DB_NAME=reservacancha" -ForegroundColor Gray
Write-Host "         - DB_USERNAME=reservacancha" -ForegroundColor Gray
Write-Host "         - DB_PASSWORD=[tu password de Render]" -ForegroundColor Gray
Write-Host "         - DB_DRIVER=org.postgresql.Driver" -ForegroundColor Gray
Write-Host "         - DB_DIALECT=org.hibernate.dialect.PostgreSQLDialect" -ForegroundColor Gray
Write-Host "         - FRONTEND_URL=https://reservacancha-frontend.onrender.com" -ForegroundColor Gray
Write-Host ""
Write-Host "   B. FRONTEND (Static Site):" -ForegroundColor Cyan
Write-Host "      1. Click en 'New +' -> 'Static Site'" -ForegroundColor White
Write-Host "      2. Conecta tu repositorio de GitHub" -ForegroundColor White
Write-Host "      3. Configuración:" -ForegroundColor White
Write-Host "         - Name: reservacancha-frontend" -ForegroundColor Gray
Write-Host "         - Build Command: cd frontend && npm install && npm run build -- --configuration production" -ForegroundColor Gray
Write-Host "         - Publish Directory: frontend/dist/reservacancha-frontend" -ForegroundColor Gray
Write-Host ""
Write-Host "   C. ACTUALIZAR URL DEL BACKEND EN FRONTEND:" -ForegroundColor Cyan
Write-Host "      Una vez que el backend esté desplegado:" -ForegroundColor White
Write-Host "      1. Copia la URL del backend (ej: https://reservacancha-backend.onrender.com)" -ForegroundColor White
Write-Host "      2. Actualiza frontend/src/environments/environment.prod.ts" -ForegroundColor White
Write-Host "      3. Haz commit y push para redesplegar el frontend" -ForegroundColor White
Write-Host ""

Write-Host "5. ALTERNATIVA RÁPIDA - DESPLIEGUE DESDE GITHUB:" -ForegroundColor Yellow
Write-Host "   1. Sube tu código a GitHub (si aún no lo has hecho)" -ForegroundColor White
Write-Host "   2. En Render Dashboard, usa 'Blueprint' y selecciona render.yaml" -ForegroundColor White
Write-Host "   3. Render desplegará automáticamente todo el stack" -ForegroundColor White
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  ¿Necesitas ayuda con GitHub?" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Ejecuta: .\SUBIR-A-GITHUB.ps1" -ForegroundColor White
Write-Host ""

$respuesta = Read-Host "¿Quieres que te ayude a subir el código a GitHub? (s/n)"
if ($respuesta -eq 's' -or $respuesta -eq 'S') {
    Write-Host ""
    Write-Host "Ejecuta estos comandos:" -ForegroundColor Yellow
    Write-Host "git init" -ForegroundColor White
    Write-Host "git add ." -ForegroundColor White
    Write-Host "git commit -m 'Proyecto ReservaCancha listo para Render'" -ForegroundColor White
    Write-Host "git branch -M main" -ForegroundColor White
    Write-Host "git remote add origin https://github.com/TU-USUARIO/reservacancha.git" -ForegroundColor White
    Write-Host "git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "Después ve a Render y conecta tu repositorio." -ForegroundColor Green
}

