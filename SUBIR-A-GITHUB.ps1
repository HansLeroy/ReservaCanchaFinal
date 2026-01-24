# Script para Subir el Proyecto a GitHub
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  SUBIR PROYECTO A GITHUB" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si git esta instalado
Write-Host "Verificando Git..." -ForegroundColor Yellow
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-Host "Git no esta instalado." -ForegroundColor Red
    Write-Host "  Descargalo desde: https://git-scm.com/download/win" -ForegroundColor White
    exit 1
}
Write-Host "Git esta instalado" -ForegroundColor Green
Write-Host ""

# Preguntar datos del repositorio
Write-Host "PASO 1: Configuracion del Repositorio" -ForegroundColor Yellow
Write-Host ""
Write-Host "Veo que ya tienes repositorios en GitHub:" -ForegroundColor White
Write-Host "  - HansLeroy/reservas-canchas" -ForegroundColor Cyan
Write-Host "  - HansLeroy/reserva-cancha-sistema" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opciones:" -ForegroundColor Yellow
Write-Host "  1. Usar un repositorio existente" -ForegroundColor White
Write-Host "  2. Crear uno nuevo en: https://github.com/new" -ForegroundColor White
Write-Host ""

$usuario = Read-Host "Tu usuario de GitHub (default: HansLeroy)"
if ([string]::IsNullOrWhiteSpace($usuario)) {
    $usuario = "HansLeroy"
}

$repo = Read-Host "Nombre del repositorio (ej: reservas-canchas, reserva-cancha-sistema, o uno nuevo)"
if ([string]::IsNullOrWhiteSpace($repo)) {
    $repo = "reservas-canchas"
}
Write-Host ""

# Inicializar o verificar repositorio
Write-Host "PASO 2: Inicializando Repositorio Git..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "Repositorio Git ya existe" -ForegroundColor Green
} else {
    git init
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repositorio Git inicializado" -ForegroundColor Green
    } else {
        Write-Host "Error al inicializar Git" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Agregar archivos
Write-Host "PASO 3: Agregando Archivos..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -eq 0) {
    Write-Host "Archivos agregados" -ForegroundColor Green
} else {
    Write-Host "Error al agregar archivos" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Hacer commit
Write-Host "PASO 4: Creando Commit..." -ForegroundColor Yellow
git commit -m "Proyecto ReservaCancha listo para despliegue en Render"
if ($LASTEXITCODE -eq 0) {
    Write-Host "Commit creado" -ForegroundColor Green
} else {
    Write-Host "Puede que no haya cambios para commitear o ya exista un commit" -ForegroundColor Yellow
}
Write-Host ""

# Configurar rama principal
Write-Host "PASO 5: Configurando Rama Principal..." -ForegroundColor Yellow
git branch -M main
Write-Host "Rama 'main' configurada" -ForegroundColor Green
Write-Host ""

# Agregar repositorio remoto
Write-Host "PASO 6: Conectando con GitHub..." -ForegroundColor Yellow
$repoUrl = "https://github.com/$usuario/$repo.git"
$remoteExists = git remote | Select-String -Pattern "origin" -Quiet
if ($remoteExists) {
    Write-Host "Remote 'origin' ya existe. Actualizando URL..." -ForegroundColor Yellow
    git remote set-url origin $repoUrl
} else {
    git remote add origin $repoUrl
}
Write-Host "Conectado a: $repoUrl" -ForegroundColor Green
Write-Host ""

# Push a GitHub
Write-Host "PASO 7: Subiendo Codigo a GitHub..." -ForegroundColor Yellow
Write-Host "Esto puede tardar unos minutos..." -ForegroundColor White
git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "Codigo subido exitosamente a GitHub" -ForegroundColor Green
} else {
    Write-Host "Puede haber errores. Verifica tu autenticacion de GitHub." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Si usas autenticacion de 2 factores, necesitas:" -ForegroundColor White
    Write-Host "  1. Crear un Personal Access Token en GitHub" -ForegroundColor Gray
    Write-Host "  2. Ir a: Settings -> Developer settings -> Personal access tokens" -ForegroundColor Gray
    Write-Host "  3. Usar el token como contrasena al hacer push" -ForegroundColor Gray
}
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  LISTO!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tu codigo esta en: https://github.com/$usuario/$repo" -ForegroundColor Green
Write-Host ""
Write-Host "SIGUIENTE PASO:" -ForegroundColor Yellow
Write-Host "Ve a Render Dashboard: https://dashboard.render.com/" -ForegroundColor White
Write-Host "y sigue las instrucciones en: GUIA-RENDER-COMPLETA.md" -ForegroundColor White
Write-Host ""

