# Script para limpiar e instalar dependencias del frontend Angular
Write-Host "=== Instalación de Frontend Angular ===" -ForegroundColor Green

# Paso 1: Limpiar instalaciones anteriores
Write-Host "`nPaso 1: Limpiando instalaciones anteriores..." -ForegroundColor Yellow
if (Test-Path ".\node_modules") {
    Write-Host "Eliminando node_modules..." -ForegroundColor Yellow
    Remove-Item ".\node_modules" -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path ".\package-lock.json") {
    Write-Host "Eliminando package-lock.json..." -ForegroundColor Yellow
    Remove-Item ".\package-lock.json" -Force -ErrorAction SilentlyContinue
}

# Paso 2: Limpiar caché de npm
Write-Host "`nPaso 2: Limpiando caché de npm..." -ForegroundColor Yellow
npm cache clean --force

# Paso 3: Instalar dependencias
Write-Host "`nPaso 3: Instalando dependencias (esto puede tardar varios minutos)..." -ForegroundColor Yellow
npm install

# Paso 4: Verificar instalación
Write-Host "`nPaso 4: Verificando instalación..." -ForegroundColor Yellow
if (Test-Path ".\node_modules\@angular\core") {
    Write-Host "`n✓ Dependencias instaladas correctamente!" -ForegroundColor Green
    Write-Host "`nPara iniciar el servidor de desarrollo, ejecuta:" -ForegroundColor Cyan
    Write-Host "  npm start" -ForegroundColor White
    Write-Host "`nLuego abre tu navegador en: http://localhost:4200" -ForegroundColor Cyan
} else {
    Write-Host "`n✗ Error: Las dependencias no se instalaron correctamente" -ForegroundColor Red
    Write-Host "Revisa los errores anteriores e intenta de nuevo" -ForegroundColor Red
}

