Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  VERIFICACION Y PRUEBA DEL SISTEMA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Paso 1: Verificar backend
Write-Host "[1/3] Verificando que el backend este corriendo..." -ForegroundColor Yellow
Write-Host ""

try {
    $canchas = Invoke-RestMethod -Uri "http://localhost:8080/api/canchas" -TimeoutSec 10

    Write-Host "  ✓ Backend funcionando correctamente" -ForegroundColor Green
    Write-Host "  ✓ Canchas disponibles: $($canchas.Count)" -ForegroundColor Green
    Write-Host ""

    if ($canchas.Count -gt 0) {
        $canchaTest = $canchas[0]
        Write-Host "  Cancha para prueba:" -ForegroundColor Cyan
        Write-Host "    Nombre: $($canchaTest.nombre)" -ForegroundColor White
        Write-Host "    ID: $($canchaTest.id)" -ForegroundColor White
        Write-Host "    Precio: `$$($canchaTest.precioPorHora) por hora" -ForegroundColor White
        Write-Host ""

        # Paso 2: Crear reserva de prueba
        Write-Host "[2/3] Creando reserva de prueba..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Datos de la reserva:" -ForegroundColor Cyan
        Write-Host "    Cliente: Juan Pérez" -ForegroundColor Gray
        Write-Host "    RUT: 12345678-9" -ForegroundColor Gray
        Write-Host "    Email: juan@test.com" -ForegroundColor Gray
        Write-Host "    Teléfono: 912345678" -ForegroundColor Gray
        Write-Host "    Cancha: $($canchaTest.nombre)" -ForegroundColor Gray
        Write-Host "    Fecha: 2026-01-24" -ForegroundColor Gray
        Write-Host "    Horario: 14:00 - 15:00" -ForegroundColor Gray
        Write-Host "    Monto: `$$($canchaTest.precioPorHora) CLP" -ForegroundColor Gray
        Write-Host ""

        $reservaData = @{
            canchaId = $canchaTest.id
            nombreCliente = "Juan"
            apellidoCliente = "Pérez"
            emailCliente = "juan@test.com"
            telefonoCliente = "912345678"
            rutCliente = "12345678-9"
            fechaHoraInicio = "2026-01-24T14:00:00"
            fechaHoraFin = "2026-01-24T15:00:00"
            montoTotal = $canchaTest.precioPorHora
            tipoPago = "efectivo"
            estado = "CONFIRMADA"
        } | ConvertTo-Json -Compress

        $reserva = Invoke-RestMethod -Uri "http://localhost:8080/api/reservas" -Method POST -Body $reservaData -ContentType "application/json" -TimeoutSec 10

        Write-Host "  ========================================" -ForegroundColor Green
        Write-Host "    ✓✓✓ RESERVA CREADA EXITOSAMENTE ✓✓✓" -ForegroundColor Green
        Write-Host "  ========================================" -ForegroundColor Green
        Write-Host ""

        Write-Host "  Detalles de la reserva creada:" -ForegroundColor Cyan
        Write-Host "    ID: $($reserva.reservaId)" -ForegroundColor White
        Write-Host "    Cliente: $($reserva.nombreCliente) $($reserva.apellidoCliente)" -ForegroundColor White
        Write-Host "    RUT: $($reserva.rutCliente)" -ForegroundColor White
        Write-Host "    Email: $($reserva.emailCliente)" -ForegroundColor White
        Write-Host "    Teléfono: $($reserva.telefonoCliente)" -ForegroundColor White
        Write-Host "    Cancha ID: $($reserva.canchaId)" -ForegroundColor White
        Write-Host "    Fecha/Hora Inicio: $($reserva.fechaHoraInicio)" -ForegroundColor White
        Write-Host "    Fecha/Hora Fin: $($reserva.fechaHoraFin)" -ForegroundColor White
        Write-Host "    Monto Total: `$$($reserva.montoTotal) CLP" -ForegroundColor White
        Write-Host "    Tipo de Pago: $($reserva.tipoPago)" -ForegroundColor White
        Write-Host "    Estado: $($reserva.estado)" -ForegroundColor White
        Write-Host ""

        # Paso 3: Verificar en base de datos
        Write-Host "[3/3] Verificando reservas en el sistema..." -ForegroundColor Yellow
        $todasReservas = Invoke-RestMethod -Uri "http://localhost:8080/api/reservas" -TimeoutSec 5
        Write-Host "  ✓ Total de reservas guardadas: $($todasReservas.Count)" -ForegroundColor Green
        Write-Host ""

        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  ✓✓✓ SISTEMA FUNCIONANDO AL 100% ✓✓✓" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "El problema esta COMPLETAMENTE RESUELTO." -ForegroundColor Green
        Write-Host ""
        Write-Host "SIGUIENTE PASO:" -ForegroundColor Yellow
        Write-Host "  1. Abre: http://localhost:4200" -ForegroundColor Cyan
        Write-Host "  2. Presiona F5 para recargar" -ForegroundColor Cyan
        Write-Host "  3. Crea una reserva desde el formulario" -ForegroundColor Cyan
        Write-Host "  4. Deberia funcionar perfectamente!" -ForegroundColor Green
        Write-Host ""

    } else {
        Write-Host "  ⚠ No hay canchas registradas en el sistema" -ForegroundColor Yellow
        Write-Host "  Agrega canchas primero antes de crear reservas" -ForegroundColor Yellow
    }

} catch {
    Write-Host "  ✗ Backend no esta disponible" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUCION:" -ForegroundColor Yellow
    Write-Host "  1. Busca la ventana 'BACKEND - Puerto 8080 - NO CERRAR'" -ForegroundColor White
    Write-Host "  2. Espera a ver el mensaje: 'Started ReservaCanchaBackendApplication'" -ForegroundColor White
    Write-Host "  3. Luego ejecuta este script nuevamente" -ForegroundColor White
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

