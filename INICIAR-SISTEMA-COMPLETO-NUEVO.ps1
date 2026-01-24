# Script para Iniciar el Sistema ReservaCancha Completo
# Fecha: 23 de Enero de 2026

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   INICIAR SISTEMA RESERVA CANCHA COMPLETO    " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Verificar MySQL
Write-Host "⏳ Paso 1: Verificando MySQL..." -ForegroundColor Yellow
$mysqlRunning = netstat -ano | Select-String ":3306"

if ($mysqlRunning) {
    Write-Host "✅ MySQL está corriendo" -ForegroundColor Green
} else {
    Write-Host "❌ MySQL NO está corriendo" -ForegroundColor Red
    Write-Host "   Por favor, inicia MySQL primero:" -ForegroundColor Yellow
    Write-Host "   - Busca 'MySQL' en el menú de inicio" -ForegroundColor Yellow
    Write-Host "   - O ejecuta: net start MySQL80" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "   Presiona ENTER después de iniciar MySQL"
}

Write-Host ""

# Paso 2: Detener procesos existentes
Write-Host "⏳ Paso 2: Limpiando procesos anteriores..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "java"} | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process | Where-Object {$_.ProcessName -eq "node"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "✅ Procesos limpiados" -ForegroundColor Green
Write-Host ""

# Paso 3: Iniciar Backend
Write-Host "⏳ Paso 3: Iniciando Backend (Spring Boot)..." -ForegroundColor Yellow
$backendPath = "C:\Users\hafer\IdeaProjects\ReservaCancha\backend"
cd $backendPath

Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath' ; java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar" -WindowStyle Normal

Write-Host "⏳ Esperando a que el backend inicie (25 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 25

# Verificar si el backend está corriendo
$backendRunning = netstat -ano | Select-String ":8080" | Select-String "LISTENING"
if ($backendRunning) {
    Write-Host "✅ Backend iniciado correctamente en puerto 8080" -ForegroundColor Green
} else {
    Write-Host "⚠️  El backend aún no ha iniciado completamente" -ForegroundColor Yellow
    Write-Host "   Verifica la ventana del backend para ver el progreso" -ForegroundColor Yellow
}

Write-Host ""

# Paso 4: Iniciar Frontend
Write-Host "⏳ Paso 4: Iniciando Frontend (Angular)..." -ForegroundColor Yellow
$frontendPath = "C:\Users\hafer\IdeaProjects\ReservaCancha\frontend"
cd $frontendPath

Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath' ; npm start" -WindowStyle Normal

Write-Host "⏳ Esperando a que Angular compile (30 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verificar si el frontend está corriendo
$frontendRunning = netstat -ano | Select-String ":4200" | Select-String "LISTENING"
if ($frontendRunning) {
    Write-Host "✅ Frontend iniciado correctamente en puerto 4200" -ForegroundColor Green
} else {
    Write-Host "⚠️  El frontend aún no ha iniciado completamente" -ForegroundColor Yellow
    Write-Host "   Verifica la ventana del frontend para ver el progreso" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "          SISTEMA INICIADO" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 URLs de acceso:" -ForegroundColor Yellow
Write-Host "   Frontend: http://localhost:4200" -ForegroundColor White
Write-Host "   Backend:  http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Credenciales de acceso:" -ForegroundColor Yellow
Write-Host "   Email:    admin@reservacancha.com" -ForegroundColor White
Write-Host "   Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "💡 Consejos:" -ForegroundColor Yellow
Write-Host "   - Hay 2 ventanas adicionales de PowerShell abiertas" -ForegroundColor White
Write-Host "   - Una para el backend (puerto 8080)" -ForegroundColor White
Write-Host "   - Una para el frontend (puerto 4200)" -ForegroundColor White
Write-Host "   - NO cierres esas ventanas mientras uses el sistema" -ForegroundColor White
Write-Host ""
Write-Host "   Para detener el sistema:" -ForegroundColor White
Write-Host "   - Cierra las ventanas de backend y frontend" -ForegroundColor White
Write-Host "   - O ejecuta: Get-Process java,node | Stop-Process -Force" -ForegroundColor White
Write-Host ""
Write-Host "¡Listo! Abre tu navegador en http://localhost:4200" -ForegroundColor Green
Write-Host ""

