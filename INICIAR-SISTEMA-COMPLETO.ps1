# Script de Inicio Rápido del Sistema Completo
# Abre todas las ventanas necesarias automáticamente

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        INICIANDO SISTEMA RESERVA CANCHA                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

$projectPath = "C:\Users\hafer\IdeaProjects\ReservaCancha"

# 1. Verificar MySQL
Write-Host "[1/4] Verificando MySQL..." -ForegroundColor Yellow
$mysqlProcess = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
if ($mysqlProcess) {
    Write-Host "      ✓ MySQL está corriendo" -ForegroundColor Green
} else {
    Write-Host "      ! Iniciando MySQL..." -ForegroundColor Yellow
    Start-Process "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" -WindowStyle Hidden
    Start-Sleep -Seconds 5
    Write-Host "      ✓ MySQL iniciado" -ForegroundColor Green
}

# 2. Iniciar Backend
Write-Host "`n[2/4] Iniciando Backend..." -ForegroundColor Yellow
$backendPath = "$projectPath\backend"
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$backendPath'; Write-Host '=== BACKEND RESERVA CANCHA ===' -ForegroundColor Cyan; java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar"
) -WindowStyle Normal
Write-Host "      ✓ Ventana de Backend abierta" -ForegroundColor Green

# 3. Esperar a que el backend inicie
Write-Host "      Esperando 25 segundos a que el backend inicie..." -ForegroundColor Gray
Start-Sleep -Seconds 25

# 4. Iniciar Frontend
Write-Host "`n[3/4] Iniciando Frontend..." -ForegroundColor Yellow
$frontendPath = "$projectPath\frontend"
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$frontendPath'; Write-Host '=== FRONTEND RESERVA CANCHA ===' -ForegroundColor Cyan; npm start"
) -WindowStyle Normal
Write-Host "      ✓ Ventana de Frontend abierta" -ForegroundColor Green

# 5. Esperar a que el frontend compile
Write-Host "      Esperando 30 segundos a que el frontend compile..." -ForegroundColor Gray
Start-Sleep -Seconds 30

# 6. Abrir navegador
Write-Host "`n[4/4] Abriendo navegador..." -ForegroundColor Yellow
Start-Process "http://localhost:4200"
Write-Host "      ✓ Navegador abierto en http://localhost:4200" -ForegroundColor Green

# Resumen final
Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              SISTEMA INICIADO CORRECTAMENTE               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Servicios corriendo:" -ForegroundColor Yellow
Write-Host "  ✓ MySQL:    " -NoNewline -ForegroundColor Green
Write-Host "Puerto 3306" -ForegroundColor White
Write-Host "  ✓ Backend:  " -NoNewline -ForegroundColor Green
Write-Host "http://localhost:8080" -ForegroundColor White
Write-Host "  ✓ Frontend: " -NoNewline -ForegroundColor Green
Write-Host "http://localhost:4200" -ForegroundColor White

Write-Host "`nCredenciales de Admin:" -ForegroundColor Yellow
Write-Host "  Email:    admin@reservacancha.com" -ForegroundColor White
Write-Host "  Password: admin123" -ForegroundColor White

Write-Host "`nPara verificar el estado del sistema:" -ForegroundColor Yellow
Write-Host "  .\VERIFICAR-SISTEMA.ps1" -ForegroundColor White

Write-Host "`nPresiona cualquier tecla para cerrar esta ventana..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

