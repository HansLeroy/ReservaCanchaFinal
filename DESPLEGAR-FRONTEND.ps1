# ============================================
# SCRIPT DE DESPLIEGUE FRONTEND
# Sistema Reserva Canchas
# ============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$BackendUrl
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  CONFIGURANDO FRONTEND PARA PRODUCCION" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Asegurar que la URL termina en /api
$apiUrl = $BackendUrl.TrimEnd('/')
if (-not $apiUrl.EndsWith('/api')) {
    $apiUrl = "$apiUrl/api"
}

Write-Host "[1/3] Actualizando configuración de producción..." -ForegroundColor Yellow

# Actualizar environment.prod.ts
$envProdPath = "frontend\src\environments\environment.prod.ts"
$envProdContent = @"
export const environment = {
  production: true,
  apiUrl: '$apiUrl'
};
"@

Set-Content -Path $envProdPath -Value $envProdContent -Encoding UTF8
Write-Host "✓ environment.prod.ts actualizado" -ForegroundColor Green

# Commit y push
Write-Host ""
Write-Host "[2/3] Subiendo cambios a GitHub..." -ForegroundColor Yellow
git add .
git commit -m "Actualizar API URL para producción: $apiUrl"
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Cambios subidos exitosamente" -ForegroundColor Green
} else {
    Write-Host "✗ Error al subir cambios" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DESPLEGAR EN VERCEL" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Abre tu navegador y sigue estos pasos:" -ForegroundColor White
Write-Host ""
Write-Host "1. Ve a: https://vercel.com" -ForegroundColor Yellow
Write-Host "2. Login con GitHub" -ForegroundColor Yellow
Write-Host "3. Click 'New Project'" -ForegroundColor Yellow
Write-Host "4. Importa tu repositorio de GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "CONFIGURACION IMPORTANTE:" -ForegroundColor Cyan
Write-Host "5. Root Directory: frontend" -ForegroundColor Yellow
Write-Host "6. Framework Preset: Angular" -ForegroundColor Yellow
Write-Host "7. Build Command:" -ForegroundColor Yellow
Write-Host "   npm install && npm run build -- --configuration=production" -ForegroundColor White
Write-Host "8. Output Directory: dist/reservacancha-frontend" -ForegroundColor Yellow
Write-Host ""
Write-Host "9. Click 'Deploy'" -ForegroundColor Yellow
Write-Host "10. Espera ~2 minutos" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Una vez que Vercel termine:" -ForegroundColor White
Write-Host ""
Write-Host "1. COPIA la URL de tu app (ej: https://reserva-cancha-sistema.vercel.app)" -ForegroundColor Yellow
Write-Host "2. Ve a Railway → Tu servicio backend → Tab 'Variables'" -ForegroundColor Yellow
Write-Host "3. ACTUALIZA la variable FRONTEND_URL con la URL de Vercel" -ForegroundColor Yellow
Write-Host "4. Railway redesplegarà automáticamente" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend configurado con API: $apiUrl" -ForegroundColor Green
Write-Host ""
Write-Host "Presiona Enter para abrir Vercel en el navegador..." -ForegroundColor Yellow
Read-Host
Start-Process "https://vercel.com"

