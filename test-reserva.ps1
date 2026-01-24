# Script para probar la creación de reservas

Write-Host "`n=== TEST DE CREACIÓN DE RESERVA ===" -ForegroundColor Cyan

# Datos de la reserva
$reservaData = @{
    canchaId = 1
    nombreCliente = "Hans"
    apellidoCliente = "Ferreira"
    rutCliente = "18441202-0"
    emailCliente = "ha.ferreira93@gmail.com"
    telefonoCliente = "+5698788778"
    fechaHoraInicio = "2026-01-24T10:00:00"
    fechaHoraFin = "2026-01-24T11:00:00"
    montoTotal = 7.0
    tipoPago = "efectivo"
    estado = "CONFIRMADA"
} | ConvertTo-Json

Write-Host "`nDatos de la reserva:" -ForegroundColor Yellow
Write-Host $reservaData

Write-Host "`nEnviando petición a http://localhost:8080/api/reservas..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/reservas" `
        -Method Post `
        -ContentType "application/json" `
        -Body $reservaData `
        -TimeoutSec 10

    Write-Host "`n✓ RESERVA CREADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "`nRespuesta del servidor:" -ForegroundColor Cyan
    $response | ConvertTo-Json -Depth 3 | Write-Host

} catch {
    Write-Host "`n✗ ERROR AL CREAR RESERVA" -ForegroundColor Red
    Write-Host "Detalles del error:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message

    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "`nRespuesta del servidor:" -ForegroundColor Yellow
        Write-Host $responseBody
    }
}

Write-Host "`n=== FIN DEL TEST ===" -ForegroundColor Cyan

