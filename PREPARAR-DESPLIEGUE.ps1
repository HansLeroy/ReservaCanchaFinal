Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PREPARAR PROYECTO PARA DESPLIEGUE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-Not (Test-Path ".\backend")) {
    Write-Host "❌ Error: No se encuentra el directorio 'backend'" -ForegroundColor Red
    Write-Host "   Ejecuta este script desde la raíz del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Directorio correcto detectado" -ForegroundColor Green
Write-Host ""

# 1. Verificar Git
Write-Host "[1/6] Verificando Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "   ✅ Git instalado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Git no está instalado. Instálalo desde: https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# 2. Verificar archivos de configuración
Write-Host "[2/6] Verificando archivos de configuración..." -ForegroundColor Yellow
$archivosNecesarios = @(
    "backend\src\main\resources\application-prod.properties",
    "frontend\src\environments\environment.prod.ts",
    "Dockerfile",
    ".dockerignore",
    "railway.json",
    "vercel.json"
)

$faltantes = @()
foreach ($archivo in $archivosNecesarios) {
    if (Test-Path $archivo) {
        Write-Host "   ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $archivo - FALTA" -ForegroundColor Red
        $faltantes += $archivo
    }
}

if ($faltantes.Count -gt 0) {
    Write-Host ""
    Write-Host "   ⚠️ Archivos faltantes detectados. Deberían haberse creado automáticamente." -ForegroundColor Yellow
    exit 1
}

# 3. Verificar que el backend compila
Write-Host "[3/6] Verificando compilación del backend..." -ForegroundColor Yellow
Write-Host "   (Esto puede tomar 1-2 minutos...)" -ForegroundColor Gray
cd backend
$buildOutput = mvn clean package -DskipTests 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Backend compila correctamente" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error compilando backend" -ForegroundColor Red
    Write-Host $buildOutput -ForegroundColor Red
    cd ..
    exit 1
}
cd ..

# 4. Verificar dependencias del frontend
Write-Host "[4/6] Verificando frontend..." -ForegroundColor Yellow
cd frontend
if (Test-Path "node_modules") {
    Write-Host "   ✅ Dependencias de Node instaladas" -ForegroundColor Green
} else {
    Write-Host "   ⚠️ Instalando dependencias..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Dependencias instaladas" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Error instalando dependencias" -ForegroundColor Red
        cd ..
        exit 1
    }
}
cd ..

# 5. Inicializar Git si no está inicializado
Write-Host "[5/6] Configurando Git..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "   ✅ Repositorio Git ya inicializado" -ForegroundColor Green
} else {
    Write-Host "   📦 Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit - Sistema Reserva Canchas"
    Write-Host "   ✅ Repositorio Git inicializado" -ForegroundColor Green
}

# 6. Resumen final
Write-Host "[6/6] Generando resumen..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ PROYECTO LISTO PARA DESPLIEGUE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Crear repositorio en GitHub:" -ForegroundColor White
Write-Host "   - Ve a: https://github.com/new" -ForegroundColor Gray
Write-Host "   - Nombre: reserva-cancha-sistema" -ForegroundColor Gray
Write-Host "   - NO marques 'Initialize with README'" -ForegroundColor Gray
Write-Host ""

Write-Host "2. Subir código a GitHub:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/TU-USUARIO/reserva-cancha-sistema.git" -ForegroundColor Gray
Write-Host "   git branch -M main" -ForegroundColor Gray
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "3. Seguir la guía de despliegue:" -ForegroundColor White
Write-Host "   - Lee: DESPLIEGUE_RAPIDO.md (guía paso a paso)" -ForegroundColor Gray
Write-Host "   - O:   GUIA_DESPLIEGUE_HOSTING.md (guía completa)" -ForegroundColor Gray
Write-Host ""

Write-Host "📚 Documentación creada:" -ForegroundColor Cyan
Write-Host "   - DESPLIEGUE_RAPIDO.md        - Guía rápida (20 min)" -ForegroundColor White
Write-Host "   - GUIA_DESPLIEGUE_HOSTING.md  - Guía completa detallada" -ForegroundColor White
Write-Host "   - CHECKLIST_DESPLIEGUE.md     - Lista de verificación" -ForegroundColor White
Write-Host "   - .env.railway.example        - Ejemplo de variables" -ForegroundColor White
Write-Host ""

Write-Host "🚀 Plataformas recomendadas:" -ForegroundColor Cyan
Write-Host "   Backend:   Railway (https://railway.app)" -ForegroundColor White
Write-Host "   Frontend:  Vercel (https://vercel.com)" -ForegroundColor White
Write-Host "   Base de Datos: Railway MySQL (incluido)" -ForegroundColor White
Write-Host ""

Write-Host "💰 Costo estimado: GRATIS para empezar" -ForegroundColor Green
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

