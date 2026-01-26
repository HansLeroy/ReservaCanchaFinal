# Script para hacer commit y push de la solución del error JDBC
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  DEPLOY DE SOLUCIÓN - Error JDBC PostgreSQL  " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si estamos en un repositorio git
if (-not (Test-Path .git)) {
    Write-Host "❌ ERROR: No estás en la raíz del repositorio git" -ForegroundColor Red
    Write-Host "   Por favor, ejecuta este script desde: C:\Users\hafer\IdeaProjects\ReservaCancha" -ForegroundColor Yellow
    exit 1
}

# Mostrar archivos modificados
Write-Host "📋 Archivos que se agregarán al commit:" -ForegroundColor Yellow
Write-Host ""
git status --short

Write-Host ""
Write-Host "🔍 Verificando cambios importantes..." -ForegroundColor Cyan

# Verificar que los archivos clave existan
$archivosRequeridos = @(
    "backend\src\main\java\com\example\reservacancha\backend\config\DatabaseConfig.java",
    "backend\src\main\resources\application-prod.properties",
    "backend\Dockerfile",
    "render.yaml"
)

$todoOk = $true
foreach ($archivo in $archivosRequeridos) {
    if (Test-Path $archivo) {
        Write-Host "  ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $archivo - NO ENCONTRADO" -ForegroundColor Red
        $todoOk = $false
    }
}

Write-Host ""

if (-not $todoOk) {
    Write-Host "❌ Faltan archivos requeridos. Por favor verifica la estructura del proyecto." -ForegroundColor Red
    exit 1
}

# Confirmar con el usuario
Write-Host "⚠️  ¿Deseas continuar con el commit y push? (S/N): " -ForegroundColor Yellow -NoNewline
$respuesta = Read-Host

if ($respuesta -ne "S" -and $respuesta -ne "s") {
    Write-Host "❌ Operación cancelada por el usuario." -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "📦 Agregando archivos al staging..." -ForegroundColor Cyan

# Agregar archivos específicos
git add backend/src/main/java/com/example/reservacancha/backend/config/DatabaseConfig.java
git add backend/src/main/resources/application-prod.properties
git add backend/Dockerfile
git add render.yaml
git add backend/RENDER-DATABASE-CONFIG.md
git add CAMBIOS-SOLUCION-JDBC.md
git add MI-BASE-DE-DATOS-CONFIG.md
git add INSTRUCCIONES-RAPIDAS.txt
git add deploy-solucion.ps1
git add backend/target/reservacancha-backend-0.0.1-SNAPSHOT.jar

Write-Host "✅ Archivos agregados" -ForegroundColor Green
Write-Host ""

# Crear commit
Write-Host "💾 Creando commit..." -ForegroundColor Cyan
$mensajeCommit = @"
Fix: Corregir configuración de base de datos PostgreSQL para Render

Cambios principales:
- DatabaseConfig: Conversión automática de postgresql:// a jdbc:postgresql://
- application-prod.properties: Eliminadas configuraciones conflictivas
- render.yaml: Cambiado a usar DATABASE_URL en lugar de SPRING_DATASOURCE_URL
- Dockerfile: Corregido COPY y agregado soporte para PORT variable

Soluciona el error:
java.lang.RuntimeException: Driver org.postgresql.Driver claims to not accept jdbcUrl, postgresql://...

Archivos modificados:
- backend/config/DatabaseConfig.java (mejorado con logs y validaciones)
- backend/application-prod.properties (simplificado)
- render.yaml (configuración correcta de env vars)
- backend/Dockerfile (optimizado)

Nuevos archivos:
- backend/RENDER-DATABASE-CONFIG.md (documentación completa)
- CAMBIOS-SOLUCION-JDBC.md (resumen de cambios)
"@

git commit -m "$mensajeCommit"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit creado exitosamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error al crear el commit" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Haciendo push a GitHub..." -ForegroundColor Cyan

# Obtener la rama actual
$ramaActual = git rev-parse --abbrev-ref HEAD
Write-Host "   Rama: $ramaActual" -ForegroundColor Gray

# Push
git push origin $ramaActual

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ PUSH COMPLETADO EXITOSAMENTE  " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Ve a tu Dashboard de Render" -ForegroundColor White
    Write-Host "   https://dashboard.render.com" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Selecciona tu servicio backend" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Verifica las variables de entorno:" -ForegroundColor White
    Write-Host "   ✓ SPRING_PROFILES_ACTIVE = prod" -ForegroundColor Gray
    Write-Host "   ✓ DATABASE_URL = postgresql://..." -ForegroundColor Gray
    Write-Host "   ✓ FRONTEND_URL = https://tu-frontend.onrender.com" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Render iniciará el deploy automáticamente" -ForegroundColor White
    Write-Host ""
    Write-Host "5. Monitorea los logs y busca estos mensajes:" -ForegroundColor White
    Write-Host "   🚀 Iniciando configuración de DataSource..." -ForegroundColor Gray
    Write-Host "   ✅ DATABASE_URL convertida exitosamente" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📚 Documentación completa en:" -ForegroundColor Cyan
    Write-Host "   - backend\RENDER-DATABASE-CONFIG.md" -ForegroundColor Gray
    Write-Host "   - CAMBIOS-SOLUCION-JDBC.md" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ ERROR al hacer push" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  1. No tienes permisos en el repositorio" -ForegroundColor Gray
    Write-Host "  2. Necesitas hacer pull primero" -ForegroundColor Gray
    Write-Host "  3. Hay conflictos con el remoto" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Intenta:" -ForegroundColor Yellow
    Write-Host "  git pull origin $ramaActual" -ForegroundColor Gray
    Write-Host "  y luego vuelve a ejecutar este script" -ForegroundColor Gray
    exit 1
}

