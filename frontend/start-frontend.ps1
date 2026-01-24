# Script para iniciar el frontend Angular

Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     INICIANDO FRONTEND - RESERVA DE CANCHAS       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📦 Verificando dependencias..." -ForegroundColor Yellow

if (!(Test-Path "node_modules")) {
    Write-Host "⚠️  node_modules no encontrado. Instalando dependencias..." -ForegroundColor Red
    npm install
}

Write-Host "✅ Dependencias verificadas`n" -ForegroundColor Green

Write-Host "🚀 Iniciando servidor de desarrollo Angular..." -ForegroundColor Yellow
Write-Host "   Puerto: 4200" -ForegroundColor White
Write-Host "   URL: http://localhost:4200`n" -ForegroundColor White

Write-Host "⏳ Compilando... Esto puede tomar unos momentos...`n" -ForegroundColor Cyan

# Iniciar el servidor
npm start

