# ======================================================
# SCRIPT DE PRUEBA DE LOGIN - SISTEMA RESERVA CANCHA
# ======================================================
# Este script prueba el endpoint de login y mide el tiempo de respuesta

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PRUEBA DE LOGIN - SISTEMA RESERVA CANCHA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$apiUrl = "http://localhost:8080/api/auth/login"
$email = "usuario@reservacancha.cl"
$password = "usuario123"

# Body JSON
$body = @{
    email = $email
    password = $password
} | ConvertTo-Json

Write-Host "Configuración:" -ForegroundColor Yellow
Write-Host "  URL: $apiUrl"
Write-Host "  Email: $email"
Write-Host ""

# Verificar que el servidor esté corriendo
Write-Host "Verificando servidor..." -ForegroundColor Yellow
try {
    $healthCheck = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/validate" -Method Get -Headers @{Authorization="Bearer test"} -ErrorAction SilentlyContinue
    Write-Host "✓ Servidor respondiendo" -ForegroundColor Green
} catch {
    Write-Host "✗ ADVERTENCIA: Servidor puede no estar corriendo en puerto 8080" -ForegroundColor Red
    Write-Host "  Asegúrate de iniciar el backend con: .\mvnw spring-boot:run" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "EJECUTANDO PRUEBA DE LOGIN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Realizar 5 pruebas
$tiempos = @()
$exitoso = 0
$fallidos = 0

for ($i = 1; $i -le 5; $i++) {
    Write-Host "Intento $i de 5..." -ForegroundColor Yellow

    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $response = Invoke-RestMethod -Uri $apiUrl `
                                      -Method Post `
                                      -ContentType "application/json" `
                                      -Body $body `
                                      -ErrorAction Stop

        $stopwatch.Stop()
        $tiempoMs = $stopwatch.ElapsedMilliseconds
        $tiempos += $tiempoMs

        if ($response.success -eq $true) {
            Write-Host "  ✓ Login exitoso en $tiempoMs ms" -ForegroundColor Green
            $exitoso++

            if ($i -eq 1) {
                Write-Host "  Usuario: $($response.user.nombre) ($($response.user.email))" -ForegroundColor Gray
                Write-Host "  Rol: $($response.user.rol)" -ForegroundColor Gray
                Write-Host "  Token: $($response.token.Substring(0, 30))..." -ForegroundColor Gray
            }
        } else {
            Write-Host "  ✗ Login falló: $($response.message)" -ForegroundColor Red
            $fallidos++
        }

    } catch {
        Write-Host "  ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
        $fallidos++
    }

    Write-Host ""
    Start-Sleep -Milliseconds 500
}

# Calcular estadísticas
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESULTADOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($tiempos.Count -gt 0) {
    $promedio = ($tiempos | Measure-Object -Average).Average
    $minimo = ($tiempos | Measure-Object -Minimum).Minimum
    $maximo = ($tiempos | Measure-Object -Maximum).Maximum

    Write-Host "Pruebas exitosas: $exitoso / 5" -ForegroundColor $(if ($exitoso -eq 5) { "Green" } else { "Yellow" })
    Write-Host "Pruebas fallidas: $fallidos / 5" -ForegroundColor $(if ($fallidos -eq 0) { "Green" } else { "Red" })
    Write-Host ""

    Write-Host "Tiempos de respuesta:" -ForegroundColor Yellow
    Write-Host "  Mínimo:   $minimo ms" -ForegroundColor Cyan
    Write-Host "  Máximo:   $maximo ms" -ForegroundColor Cyan
    Write-Host "  Promedio: $([Math]::Round($promedio, 2)) ms" -ForegroundColor Cyan
    Write-Host ""

    # Evaluación
    if ($promedio -lt 100) {
        Write-Host "✓ EXCELENTE: Tiempo promedio < 100ms (0.1 segundos)" -ForegroundColor Green
        Write-Host "  El login está perfectamente optimizado." -ForegroundColor Green
    } elseif ($promedio -lt 500) {
        Write-Host "✓ BUENO: Tiempo promedio < 500ms (0.5 segundos)" -ForegroundColor Yellow
        Write-Host "  El login está optimizado y es aceptable." -ForegroundColor Yellow
    } elseif ($promedio -lt 1000) {
        Write-Host "⚠ ACEPTABLE: Tiempo promedio < 1 segundo" -ForegroundColor Yellow
        Write-Host "  Considera revisar los índices de la base de datos." -ForegroundColor Yellow
    } elseif ($promedio -lt 60000) {
        Write-Host "✗ LENTO: Tiempo promedio > 1 segundo pero < 1 minuto" -ForegroundColor Red
        Write-Host "  ACCIÓN REQUERIDA: Ejecuta el script SQL de optimización." -ForegroundColor Red
    } else {
        Write-Host "✗ MUY LENTO: Tiempo promedio > 1 minuto" -ForegroundColor Red
        Write-Host "  ACCIÓN URGENTE:" -ForegroundColor Red
        Write-Host "  1. Ejecuta: mysql -u root -p < optimizacion-login.sql" -ForegroundColor Yellow
        Write-Host "  2. Verifica logs del servidor" -ForegroundColor Yellow
        Write-Host "  3. Revisa GUIA-OPTIMIZACION-LOGIN.md" -ForegroundColor Yellow
    }

} else {
    Write-Host "✗ NO SE PUDO COMPLETAR NINGUNA PRUEBA" -ForegroundColor Red
    Write-Host "  Verifica que el servidor esté corriendo." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PRÓXIMOS PASOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Revisa los logs del servidor:" -ForegroundColor Yellow
Write-Host "   Get-Content app.log -Tail 50 | Select-String 'Login de'" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Verifica índices en MySQL:" -ForegroundColor Yellow
Write-Host "   mysql -u root -p" -ForegroundColor Gray
Write-Host "   USE reservas_canchas;" -ForegroundColor Gray
Write-Host "   SHOW INDEX FROM usuario;" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Consulta la guía completa:" -ForegroundColor Yellow
Write-Host "   Get-Content GUIA-OPTIMIZACION-LOGIN.md" -ForegroundColor Gray
Write-Host ""

