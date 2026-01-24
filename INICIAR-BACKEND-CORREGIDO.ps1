 e unWrite-Host "========================================" -ForegroundColor Green
Write-Host "  INICIANDO SISTEMA - CON CORRECCION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# PASO 1: Iniciar MySQL
Write-Host "[1/5] Verificando MySQL..." -ForegroundColor Yellow
try {
    $mysqlService = Get-Service -Name "MySQL80" -ErrorAction Stop
    if ($mysqlService.Status -ne "Running") {
        Write-Host "  Iniciando MySQL..." -ForegroundColor Cyan
        Start-Service -Name "MySQL80" -ErrorAction Stop
        Write-Host "  ✓ MySQL iniciado" -ForegroundColor Green
    } else {
        Write-Host "  ✓ MySQL ya está corriendo" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ No se pudo verificar/iniciar MySQL" -ForegroundColor Yellow
    Write-Host "  Intentando continuar..." -ForegroundColor Yellow
}
Start-Sleep -Seconds 3

# PASO 2: Detener procesos previos
Write-Host "[2/5] Deteniendo procesos previos..." -ForegroundColor Yellow
Stop-Process -Name java,node -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "  ✓ Procesos detenidos" -ForegroundColor Green

# PASO 3: Compilar Backend con cambios
Write-Host "[3/5] Compilando Backend con correcciones..." -ForegroundColor Yellow
$backendPath = "C:\Users\hafer\IdeaProjects\ReservaCancha\backend"
cd $backendPath
$compileOutput = & .\mvnw.cmd clean package -DskipTests 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Backend compilado exitosamente" -ForegroundColor Green
} else {
    Write-Host "  ✗ Error al compilar backend" -ForegroundColor Red
    Write-Host "  Revisa los errores arriba" -ForegroundColor Red
    pause
    exit 1
}

# PASO 4: Iniciar Backend
Write-Host "[4/5] Iniciando Backend en puerto 8080..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "`$host.UI.RawUI.WindowTitle = 'BACKEND - Puerto 8080 - NO CERRAR'; Write-Host '========================================' -ForegroundColor Green; Write-Host '  BACKEND - ReservaCancha' -ForegroundColor Cyan; Write-Host '========================================' -ForegroundColor Green; Write-Host ''; Write-Host 'Iniciando servidor...' -ForegroundColor Yellow; Write-Host ''; cd '$backendPath'; .\mvnw.cmd spring-boot:run"
Write-Host "  ✓ Ventana de Backend abierta" -ForegroundColor Green

Write-Host "[5/5] Esperando 45 segundos para que el backend inicie..." -ForegroundColor Yellow
for ($i = 45; $i -gt 0; $i--) {
    Write-Host "  $i segundos restantes..." -ForegroundColor Gray -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "`r" -NoNewline
}
Write-Host "  ✓ Tiempo de espera completado" -ForegroundColor Green
Write-Host ""

# Verificar que el backend responda
Write-Host "Verificando que el backend responda..." -ForegroundColor Yellow
$intentos = 0
$backendOk = $false
while ($intentos -lt 5 -and -not $backendOk) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/canchas" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "✓ BACKEND FUNCIONANDO CORRECTAMENTE" -ForegroundColor Green
        Write-Host "  Canchas en sistema: $($response.Count)" -ForegroundColor Cyan
        $backendOk = $true
    } catch {
        $intentos++
        if ($intentos -lt 5) {
            Write-Host "  Intento $intentos/5 - Esperando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 10
        }
    }
}

if (-not $backendOk) {
    Write-Host ""
    Write-Host "⚠ El backend no responde todavía" -ForegroundColor Yellow
    Write-Host "  Verifica la ventana 'BACKEND - Puerto 8080'" -ForegroundColor Yellow
    Write-Host "  Espera hasta ver: 'Started ReservaCanchaBackendApplication'" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  BACKEND INICIADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "URL Backend:  http://localhost:8080/api/canchas" -ForegroundColor Cyan
Write-Host "URL Frontend: http://localhost:4200" -ForegroundColor Cyan
Write-Host ""
Write-Host "SIGUIENTE PASO:" -ForegroundColor Yellow
Write-Host "1. Abre el frontend: http://localhost:4200" -ForegroundColor White
Write-Host "2. Presiona F5 para recargar" -ForegroundColor White
Write-Host "3. Intenta crear una reserva" -ForegroundColor White
Write-Host ""
Write-Host "✓ Corrección aplicada: Campo 'usuarioId' eliminado" -ForegroundColor Green
Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

