# ============================================
# SCRIPT DE DESPLIEGUE AUTOMATICO
# Sistema Reserva Canchas
# ============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$GithubUrl
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DESPLIEGUE AUTOMATICO - RESERVA CANCHAS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Conectar con GitHub
Write-Host "[1/5] Conectando con GitHub..." -ForegroundColor Yellow
try {
    git remote remove origin 2>$null
    git remote add origin $GithubUrl
    Write-Host "✓ Remoto configurado" -ForegroundColor Green
} catch {
    Write-Host "✓ Remoto ya existía" -ForegroundColor Green
}

# Paso 2: Subir código
Write-Host ""
Write-Host "[2/5] Subiendo código a GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Código subido exitosamente" -ForegroundColor Green
} else {
    Write-Host "✗ Error al subir código" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  SIGUIENTE PASO: DESPLEGAR EN RAILWAY" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Abre tu navegador y sigue estos pasos:" -ForegroundColor White
Write-Host ""
Write-Host "1. Ve a: https://railway.app" -ForegroundColor Yellow
Write-Host "2. Click en 'Start a New Project'" -ForegroundColor Yellow
Write-Host "3. Login con GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "CREAR BASE DE DATOS:" -ForegroundColor Cyan
Write-Host "4. Click 'New Project' → 'Provision MySQL'" -ForegroundColor Yellow
Write-Host "5. Espera a que se cree (30 segundos)" -ForegroundColor Yellow
Write-Host "6. Click en el servicio MySQL → Tab 'Variables'" -ForegroundColor Yellow
Write-Host "7. COPIA estas variables (las necesitarás):" -ForegroundColor Yellow
Write-Host "   - MYSQLHOST" -ForegroundColor White
Write-Host "   - MYSQLPORT" -ForegroundColor White
Write-Host "   - MYSQLDATABASE" -ForegroundColor White
Write-Host "   - MYSQLUSER" -ForegroundColor White
Write-Host "   - MYSQLPASSWORD" -ForegroundColor White
Write-Host ""
Write-Host "DESPLEGAR BACKEND:" -ForegroundColor Cyan
Write-Host "8. En el mismo proyecto, click 'New' → 'GitHub Repo'" -ForegroundColor Yellow
Write-Host "9. Selecciona: $($GithubUrl -replace '.git$','')" -ForegroundColor Yellow
Write-Host "10. Click en el servicio → Tab 'Variables'" -ForegroundColor Yellow
Write-Host ""
Write-Host "11. AGREGAR ESTAS VARIABLES (click 'New Variable'):" -ForegroundColor Yellow
Write-Host ""
Write-Host "    SPRING_PROFILES_ACTIVE = prod" -ForegroundColor White
Write-Host "    DB_HOST = (pegar MYSQLHOST de arriba)" -ForegroundColor White
Write-Host "    DB_PORT = (pegar MYSQLPORT de arriba)" -ForegroundColor White
Write-Host "    DB_NAME = (pegar MYSQLDATABASE de arriba)" -ForegroundColor White
Write-Host "    DB_USERNAME = (pegar MYSQLUSER de arriba)" -ForegroundColor White
Write-Host "    DB_PASSWORD = (pegar MYSQLPASSWORD de arriba)" -ForegroundColor White
Write-Host "    FRONTEND_URL = https://tu-app.vercel.app" -ForegroundColor White
Write-Host "    PORT = 8080" -ForegroundColor White
Write-Host ""
Write-Host "12. Tab 'Settings' → 'Networking' → 'Generate Domain'" -ForegroundColor Yellow
Write-Host "13. COPIA LA URL generada (ej: https://reservacancha-backend.up.railway.app)" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Cuando tengas la URL del backend, ejecuta:" -ForegroundColor White
Write-Host ""
Write-Host ".\DESPLEGAR-FRONTEND.ps1 -BackendUrl 'https://tu-backend.up.railway.app'" -ForegroundColor Green
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Enter para abrir Railway en el navegador..." -ForegroundColor Yellow
Read-Host
Start-Process "https://railway.app"

