Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  VERIFICACION DEL BACKEND" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Verificando si el backend esta corriendo..." -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/canchas" -TimeoutSec 10

    Write-Host "✓✓✓ BACKEND FUNCIONANDO CORRECTAMENTE ✓✓✓" -ForegroundColor Green
    Write-Host ""
    Write-Host "Canchas disponibles: $($response.Count)" -ForegroundColor Cyan

    if ($response.Count -gt 0) {
        Write-Host ""
        Write-Host "Canchas en el sistema:" -ForegroundColor Cyan
        foreach ($cancha in $response) {
            Write-Host "  - $($cancha.nombre) (ID: $($cancha.id), Precio: `$$($cancha.precioPorHora)/hora)" -ForegroundColor White
        }
    }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SISTEMA LISTO PARA USAR" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ahora puedes crear reservas desde:" -ForegroundColor Yellow
    Write-Host "  http://localhost:4200" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Pasos:" -ForegroundColor Yellow
    Write-Host "  1. Presiona F5 en el navegador" -ForegroundColor White
    Write-Host "  2. Llena el formulario de reserva" -ForegroundColor White
    Write-Host "  3. Haz clic en 'Confirmar Reserva'" -ForegroundColor White
    Write-Host "  4. Deberia funcionar!" -ForegroundColor Green
    Write-Host ""

} catch {
    Write-Host "✗ BACKEND NO ESTA DISPONIBLE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUCION:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Busca la ventana de PowerShell con titulo:" -ForegroundColor White
    Write-Host "   'BACKEND - Puerto 8080'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "2. Verifica que diga al final:" -ForegroundColor White
    Write-Host "   'Started ReservaCanchaBackendApplication in X.XXX seconds'" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. Si no existe la ventana, ejecuta:" -ForegroundColor White
    Write-Host "   cd C:\Users\hafer\IdeaProjects\ReservaCancha\backend" -ForegroundColor Cyan
    Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. Espera 1-2 minutos y ejecuta este script de nuevo" -ForegroundColor White
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

