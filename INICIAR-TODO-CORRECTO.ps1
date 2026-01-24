Write-Host "========================================" -ForegroundColor Green
Write-Host "  INICIANDO SISTEMA RESERVA CANCHA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Detener procesos previos
Write-Host "[1/4] Deteniendo procesos previos..." -ForegroundColor Yellow
Stop-Process -Name java,node -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Iniciar Backend
Write-Host "[2/4] Iniciando Backend en puerto 8080..." -ForegroundColor Yellow
$backendPath = "C:\Users\hafer\IdeaProjects\ReservaCancha\backend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; Write-Host 'BACKEND - Puerto 8080' -ForegroundColor Cyan; java -jar target\reservacancha-backend-0.0.1-SNAPSHOT.jar"

Write-Host "[3/4] Esperando 20 segundos para que el backend inicie..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Iniciar Frontend
Write-Host "[4/4] Iniciando Frontend en puerto 4200..." -ForegroundColor Yellow
$frontendPath = "C:\Users\hafer\IdeaProjects\ReservaCancha\frontend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; Write-Host 'FRONTEND - Puerto 4200' -ForegroundColor Cyan; ng serve --open"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SISTEMA INICIADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Backend:  http://localhost:8080" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:4200" -ForegroundColor Cyan
Write-Host ""
Write-Host "Credenciales de prueba:" -ForegroundColor Yellow
Write-Host "  Admin:   admin@reservacancha.cl / admin123" -ForegroundColor White
Write-Host "  Usuario: usuario@reservacancha.cl / usuario123" -ForegroundColor White
Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar esta ventana..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

