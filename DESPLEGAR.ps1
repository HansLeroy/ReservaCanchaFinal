# ============================================
# DESPLIEGUE RAPIDO - SISTEMA RESERVA CANCHAS
# ============================================
# Uso: .\DESPLEGAR.ps1 -GithubUrl "https://github.com/TU-USUARIO/reserva-cancha-sistema.git"

param(
    [Parameter(Mandatory=$true)]
    [string]$GithubUrl
)

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   DESPLEGANDO SISTEMA RESERVA CANCHAS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Conectar con GitHub
Write-Host "[1/2] Conectando con GitHub..." -ForegroundColor Yellow
try {
    git remote remove origin 2>$null | Out-Null
} catch {}

git remote add origin $GithubUrl
git branch -M main

Write-Host "      Subiendo codigo a GitHub..." -ForegroundColor White
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "      ✓ Codigo subido exitosamente" -ForegroundColor Green
} else {
    Write-Host "      ✗ Error al subir codigo" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/2] Abriendo Railway y Vercel..." -ForegroundColor Yellow
Write-Host ""

# Mostrar resumen
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   CODIGO SUBIDO A GITHUB ✓" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tu repositorio:" -ForegroundColor White
Write-Host "$($GithubUrl -replace '.git$','')" -ForegroundColor Cyan
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   SIGUIENTES PASOS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "A. DESPLEGAR BASE DE DATOS Y BACKEND (Railway)" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. En Railway (se abrira en el navegador):" -ForegroundColor White
Write-Host "      - Login con GitHub" -ForegroundColor Gray
Write-Host "      - Click 'New Project' → 'Provision MySQL'" -ForegroundColor Gray
Write-Host "      - Espera 30 segundos" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. Agregar Backend:" -ForegroundColor White
Write-Host "      - Click 'New' → 'GitHub Repo'" -ForegroundColor Gray
Write-Host "      - Selecciona: reserva-cancha-sistema" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. Configurar Variables (Tab 'Variables'):" -ForegroundColor White
Write-Host "      SPRING_PROFILES_ACTIVE = prod" -ForegroundColor Gray
Write-Host "      DB_HOST = (copiar de MySQL service)" -ForegroundColor Gray
Write-Host "      DB_PORT = (copiar de MySQL service)" -ForegroundColor Gray
Write-Host "      DB_NAME = (copiar de MySQL service)" -ForegroundColor Gray
Write-Host "      DB_USERNAME = (copiar de MySQL service)" -ForegroundColor Gray
Write-Host "      DB_PASSWORD = (copiar de MySQL service)" -ForegroundColor Gray
Write-Host "      FRONTEND_URL = https://tu-app.vercel.app" -ForegroundColor Gray
Write-Host "      PORT = 8080" -ForegroundColor Gray
Write-Host ""
Write-Host "   4. Generar dominio publico:" -ForegroundColor White
Write-Host "      - Tab 'Settings' → 'Generate Domain'" -ForegroundColor Gray
Write-Host "      - COPIA LA URL (ej: https://reservacancha-backend.up.railway.app)" -ForegroundColor Green
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "B. DESPLEGAR FRONTEND (Vercel)" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. PRIMERO ejecuta (con la URL de Railway):" -ForegroundColor White
Write-Host "      .\DESPLEGAR-FRONTEND.ps1 -BackendUrl 'URL-DE-RAILWAY'" -ForegroundColor Green
Write-Host ""
Write-Host "   2. En Vercel (se abrira en el navegador):" -ForegroundColor White
Write-Host "      - Login con GitHub" -ForegroundColor Gray
Write-Host "      - Click 'New Project'" -ForegroundColor Gray
Write-Host "      - Importa: reserva-cancha-sistema" -ForegroundColor Gray
Write-Host "      - Root Directory: frontend" -ForegroundColor Red
Write-Host "      - Framework: Angular" -ForegroundColor Gray
Write-Host "      - Deploy!" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. Actualizar CORS:" -ForegroundColor White
Write-Host "      - Vuelve a Railway" -ForegroundColor Gray
Write-Host "      - Edita variable FRONTEND_URL con la URL de Vercel" -ForegroundColor Gray
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Enter para abrir Railway y Vercel..." -ForegroundColor Yellow
Read-Host

# Abrir navegadores
Start-Process "https://railway.app"
Start-Sleep -Seconds 2
Start-Process "https://vercel.com"

Write-Host ""
Write-Host "✓ Navegadores abiertos" -ForegroundColor Green
Write-Host ""
Write-Host "¡Sigue las instrucciones de arriba!" -ForegroundColor Cyan
Write-Host ""

