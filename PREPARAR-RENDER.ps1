# SCRIPT DE PREPARACION COMPLETA PARA RENDER
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PREPARACION PARA RENDER" -ForegroundColor Cyan
Write-Host "  Reserva Cancha - Despliegue Completo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PASO 1: Verificar requisitos
Write-Host "PASO 1: Verificando Requisitos..." -ForegroundColor Yellow
Write-Host ""

$errores = @()

# Verificar Java
Write-Host "  Verificando Java..." -NoNewline
$javaInstalled = Get-Command java -ErrorAction SilentlyContinue
if ($javaInstalled) {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FALTA" -ForegroundColor Red
    $errores += "Java no esta instalado"
}

# Verificar Maven
Write-Host "  Verificando Maven..." -NoNewline
if (Test-Path "backend\mvnw") {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FALTA" -ForegroundColor Red
    $errores += "Maven wrapper no encontrado"
}

# Verificar Node.js
Write-Host "  Verificando Node.js..." -NoNewline
$nodeInstalled = Get-Command node -ErrorAction SilentlyContinue
if ($nodeInstalled) {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FALTA" -ForegroundColor Red
    $errores += "Node.js no esta instalado"
}

# Verificar Git
Write-Host "  Verificando Git..." -NoNewline
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if ($gitInstalled) {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FALTA" -ForegroundColor Red
    $errores += "Git no esta instalado"
}

Write-Host ""

if ($errores.Count -gt 0) {
    Write-Host "ERRORES ENCONTRADOS:" -ForegroundColor Red
    foreach ($error in $errores) {
        Write-Host "  - $error" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Por favor, instala los requisitos faltantes." -ForegroundColor Yellow
    exit 1
}

Write-Host "Todos los requisitos estan instalados" -ForegroundColor Green
Write-Host ""

# PASO 2: Compilar Backend
Write-Host "PASO 2: Compilando Backend..." -ForegroundColor Yellow
Set-Location backend
Write-Host "  Compilando..." -ForegroundColor White
.\mvnw clean package -DskipTests
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Backend compilado exitosamente" -ForegroundColor Green
} else {
    Write-Host "  Error al compilar backend" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Set-Location ..
Write-Host ""

# PASO 3: Instalar dependencias del Frontend
Write-Host "PASO 3: Instalando Dependencias del Frontend..." -ForegroundColor Yellow
Set-Location frontend
if (-not (Test-Path "node_modules")) {
    Write-Host "  Instalando..." -ForegroundColor White
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Dependencias instaladas" -ForegroundColor Green
    } else {
        Write-Host "  Error al instalar dependencias" -ForegroundColor Red
        Set-Location ..
        exit 1
    }
} else {
    Write-Host "  Dependencias ya instaladas" -ForegroundColor Green
}
Set-Location ..
Write-Host ""

# PASO 4: Compilar Frontend
Write-Host "PASO 4: Compilando Frontend..." -ForegroundColor Yellow
Set-Location frontend
if (Test-Path "dist\reservacancha-frontend") {
    Write-Host "  Limpiando compilacion anterior..." -ForegroundColor White
    Remove-Item -Recurse -Force "dist\reservacancha-frontend"
}
Write-Host "  Compilando para produccion..." -ForegroundColor White
npm run build -- --configuration production
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Frontend compilado exitosamente" -ForegroundColor Green
} else {
    Write-Host "  Error al compilar frontend" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Set-Location ..
Write-Host ""

# PASO 5: Informacion sobre la base de datos
Write-Host "PASO 5: Informacion de tu Base de Datos en Render" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Has creado una base de datos PostgreSQL:" -ForegroundColor White
Write-Host "  - Hostname:     dpg-d5qf88c9c44c73d1tlag-a" -ForegroundColor Gray
Write-Host "  - Port:         5432" -ForegroundColor Gray
Write-Host "  - Database:     reservacancha" -ForegroundColor Gray
Write-Host "  - Username:     reservacancha" -ForegroundColor Gray
Write-Host "  - Password:     [Visible en Render Dashboard]" -ForegroundColor Gray
Write-Host ""
Write-Host "  Para ver la contrasena:" -ForegroundColor Cyan
Write-Host "    1. Ve a tu Dashboard de Render" -ForegroundColor White
Write-Host "    2. Entra a 'reservacancha-db'" -ForegroundColor White
Write-Host "    3. Click en 'Info'" -ForegroundColor White
Write-Host "    4. Click en el icono del ojo junto a 'Password'" -ForegroundColor White
Write-Host ""

# PASO 6: Siguiente paso
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PREPARACION COMPLETA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tu proyecto esta listo para desplegar en Render." -ForegroundColor Green
Write-Host ""
Write-Host "SIGUIENTE PASO - Elige una opcion:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Opcion A - Subir a GitHub primero:" -ForegroundColor Cyan
Write-Host "    .\SUBIR-A-GITHUB.ps1" -ForegroundColor White
Write-Host ""
Write-Host "  Opcion B - Ver guia completa:" -ForegroundColor Cyan
Write-Host "    notepad GUIA-RENDER-COMPLETA.md" -ForegroundColor White
Write-Host ""
Write-Host "  Opcion C - Ver pasos rapidos:" -ForegroundColor Cyan
Write-Host "    .\DESPLEGAR-EN-RENDER.ps1" -ForegroundColor White
Write-Host ""

Write-Host "Ejecuta uno de los scripts cuando estes listo." -ForegroundColor Cyan
Write-Host ""
Write-Host "Exito en tu despliegue!" -ForegroundColor Green
Write-Host ""

