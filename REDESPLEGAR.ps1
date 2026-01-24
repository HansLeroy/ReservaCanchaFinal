# Script para redesplegar la aplicación después de corregir errores
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "REDESPLIEGUE DE RESERVA CANCHAS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en la carpeta correcta
if (-not (Test-Path ".\backend") -or -not (Test-Path ".\frontend")) {
    Write-Host "ERROR: Debes ejecutar este script desde la raíz del proyecto" -ForegroundColor Red
    exit 1
}

# Paso 1: Verificar cambios
Write-Host "1. Verificando cambios realizados..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Cambios en backend:" -ForegroundColor Green
Write-Host "  - Corregido formato URL PostgreSQL en application-prod.properties" -ForegroundColor White
Write-Host ""
Write-Host "Cambios en frontend:" -ForegroundColor Green
Write-Host "  - Todos los servicios ahora usan environment.apiUrl" -ForegroundColor White
Write-Host "  - environment.ts configurado para desarrollo (localhost:8080)" -ForegroundColor White
Write-Host "  - environment.prod.ts configurado para producción (Render)" -ForegroundColor White
Write-Host ""

# Paso 2: Confirmar subida
$confirmar = Read-Host "¿Deseas subir estos cambios a GitHub? (S/N)"
if ($confirmar -ne "S" -and $confirmar -ne "s") {
    Write-Host "Operación cancelada" -ForegroundColor Yellow
    exit 0
}

# Paso 3: Git add, commit y push
Write-Host ""
Write-Host "2. Subiendo cambios a GitHub..." -ForegroundColor Yellow
git add .
git commit -m "Fix: Corregir URL PostgreSQL y configurar servicios con environment"
git push origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo subir a GitHub" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "CAMBIOS SUBIDOS EXITOSAMENTE" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "SIGUIENTES PASOS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Ir a Render Dashboard:" -ForegroundColor White
Write-Host "   https://dashboard.render.com/" -ForegroundColor Blue
Write-Host ""
Write-Host "2. Para el BACKEND:" -ForegroundColor Yellow
Write-Host "   a) Ve a tu servicio 'reservacancha-backend'" -ForegroundColor White
Write-Host "   b) Ve a 'Environment'" -ForegroundColor White
Write-Host "   c) Verifica que exista la variable: DB_PASSWORD" -ForegroundColor White
Write-Host "   d) Si no existe, agrégala con el valor de tu base de datos" -ForegroundColor White
Write-Host "   e) Haz clic en 'Manual Deploy' -> 'Deploy latest commit'" -ForegroundColor White
Write-Host ""
Write-Host "3. Para el FRONTEND:" -ForegroundColor Yellow
Write-Host "   a) Ve a tu servicio 'reservacancha-frontend'" -ForegroundColor White
Write-Host "   b) Render debería redesplegar automáticamente" -ForegroundColor White
Write-Host "   c) Si no, haz clic en 'Manual Deploy' -> 'Deploy latest commit'" -ForegroundColor White
Write-Host ""
Write-Host "4. IMPORTANTE - Verificar la contraseña de PostgreSQL:" -ForegroundColor Red
Write-Host "   En Render, ve a tu base de datos PostgreSQL y copia:" -ForegroundColor White
Write-Host "   - Internal Database URL o" -ForegroundColor White
Write-Host "   - El password específico" -ForegroundColor White
Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

