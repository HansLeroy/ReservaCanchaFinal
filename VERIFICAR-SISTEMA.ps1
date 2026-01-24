# Script de Verificación del Sistema Completo

Write-Host "`n" -NoNewline
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      VERIFICACIÓN DEL SISTEMA RESERVA CANCHA              ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar Backend
Write-Host "1. " -NoNewline -ForegroundColor Yellow
Write-Host "Verificando Backend (puerto 8080)..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/canchas" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host " ✓" -ForegroundColor Green
    Write-Host "   Estado: Funcionando correctamente" -ForegroundColor Green
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "   Estado: No responde o error" -ForegroundColor Red
    Write-Host "   Detalles: $($_.Exception.Message)" -ForegroundColor Gray
}

# 2. Verificar Frontend
Write-Host "`n2. " -NoNewline -ForegroundColor Yellow
Write-Host "Verificando Frontend (puerto 4200)..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:4200" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host " ✓" -ForegroundColor Green
    Write-Host "   Estado: Funcionando correctamente" -ForegroundColor Green
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "   Estado: No responde o error" -ForegroundColor Red
    Write-Host "   Detalles: $($_.Exception.Message)" -ForegroundColor Gray
}

# 3. Verificar estructura de tabla reserva
Write-Host "`n3. " -NoNewline -ForegroundColor Yellow
Write-Host "Verificando estructura de tabla 'reserva'..." -NoNewline

$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if (Test-Path $mysqlPath) {
    $query = "USE reservas_canchas; DESCRIBE reserva;"
    $result = & $mysqlPath -u root -proot -e $query 2>&1

    if ($result -like "*reserva_id*auto_increment*") {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "   Estado: Campo 'reserva_id' con AUTO_INCREMENT" -ForegroundColor Green
    } else {
        Write-Host " ?" -ForegroundColor Yellow
        Write-Host "   Estado: No se pudo verificar completamente" -ForegroundColor Yellow
    }
} else {
    Write-Host " ?" -ForegroundColor Yellow
    Write-Host "   MySQL no encontrado en ruta esperada" -ForegroundColor Gray
}

# 4. Verificar endpoint de reservas
Write-Host "`n4. " -NoNewline -ForegroundColor Yellow
Write-Host "Verificando endpoint de reservas..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/reservas" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host " ✓" -ForegroundColor Green
    Write-Host "   Estado: Endpoint disponible" -ForegroundColor Green
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "   Estado: No responde" -ForegroundColor Red
}

# 5. Verificar endpoint de canchas
Write-Host "`n5. " -NoNewline -ForegroundColor Yellow
Write-Host "Verificando endpoint de canchas..." -NoNewline
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/canchas" -TimeoutSec 5 -ErrorAction Stop
    $numCanchas = $response.Count
    Write-Host " ✓" -ForegroundColor Green
    Write-Host "   Estado: $numCanchas cancha(s) disponible(s)" -ForegroundColor Green
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "   Estado: No responde" -ForegroundColor Red
}

# Resumen
Write-Host "`n" -NoNewline
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    RESUMEN DEL SISTEMA                    ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "URLs del Sistema:" -ForegroundColor Yellow
Write-Host "  • Frontend:  " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:4200" -ForegroundColor White
Write-Host "  • Backend:   " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8080" -ForegroundColor White
Write-Host "  • API Docs:  " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8080/swagger-ui.html" -ForegroundColor White
Write-Host ""

Write-Host "Credenciales de Admin:" -ForegroundColor Yellow
Write-Host "  • Email:     " -NoNewline -ForegroundColor Gray
Write-Host "admin@reservacancha.com" -ForegroundColor White
Write-Host "  • Password:  " -NoNewline -ForegroundColor Gray
Write-Host "admin123" -ForegroundColor White
Write-Host ""

Write-Host "Para crear una reserva de prueba, ejecuta:" -ForegroundColor Yellow
Write-Host "  .\test-reserva.ps1" -ForegroundColor White
Write-Host ""

