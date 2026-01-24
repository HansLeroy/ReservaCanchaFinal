# Script para iniciar BACKEND y FRONTEND juntos
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SISTEMA RESERVA CANCHA" -ForegroundColor Green
Write-Host "Iniciando Backend y Frontend" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Verificar y liberar puerto 8080
Write-Host "1. Verificando puerto 8080..." -ForegroundColor Yellow
$port8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($port8080) {
    Write-Host "   Puerto 8080 en uso. Liberando..." -ForegroundColor Yellow
    $processId = $port8080.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Write-Host "   OK Puerto 8080 disponible" -ForegroundColor Green

# Verificar y liberar puerto 4200
Write-Host "`n2. Verificando puerto 4200..." -ForegroundColor Yellow
$port4200 = Get-NetTCPConnection -LocalPort 4200 -ErrorAction SilentlyContinue
if ($port4200) {
    Write-Host "   Puerto 4200 en uso. Liberando..." -ForegroundColor Yellow
    $processId = $port4200.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}
Write-Host "   OK Puerto 4200 disponible" -ForegroundColor Green

# Iniciar Backend
Write-Host "`n3. Iniciando BACKEND..." -ForegroundColor Yellow
Write-Host "   Abriendo ventana para el backend..." -ForegroundColor Gray
Start-Process cmd -ArgumentList "/k", "cd /d C:\Users\hafer\IdeaProjects\ReservaCancha\backend && title BACKEND - Puerto 8080 && color 0A && echo ======================================== && echo BACKEND RESERVA CANCHA - Puerto 8080 && echo ======================================== && echo. && mvnw.cmd spring-boot:run"

# Esperar a que el backend compile e inicie
Write-Host "`n4. Esperando que el backend compile e inicie..." -ForegroundColor Yellow
Write-Host "   Esto puede tomar 30-60 segundos..." -ForegroundColor Gray

for ($i=45; $i -gt 0; $i--) {
    Write-Progress -Activity "Iniciando Backend" -Status "Esperando... $i segundos restantes" -PercentComplete ((45-$i)/45*100)
    Start-Sleep -Seconds 1

    # Verificar cada 5 segundos si el backend ya esta listo
    if ($i % 5 -eq 0) {
        $backendCheck = netstat -ano | findstr ":8080" | findstr "LISTENING"
        if ($backendCheck) {
            Write-Progress -Activity "Iniciando Backend" -Completed
            Write-Host "`n   OK Backend iniciado exitosamente!" -ForegroundColor Green
            break
        }
    }
}

# Verificar si el backend esta corriendo
$backendRunning = netstat -ano | findstr ":8080" | findstr "LISTENING"
if ($backendRunning) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "OK BACKEND CORRIENDO EN PUERTO 8080" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "URL: http://localhost:8080`n" -ForegroundColor Cyan

    # Iniciar Frontend
    Write-Host "5. Iniciando FRONTEND..." -ForegroundColor Yellow
    Write-Host "   Abriendo ventana para el frontend..." -ForegroundColor Gray
    Start-Process cmd -ArgumentList "/k", "cd /d C:\Users\hafer\IdeaProjects\ReservaCancha\frontend && title FRONTEND - Puerto 4200 && color 0B && echo ======================================== && echo FRONTEND RESERVA CANCHA - Puerto 4200 && echo ======================================== && echo. && npm start"

    Write-Host "`n6. Esperando que el frontend compile..." -ForegroundColor Yellow
    Write-Host "   Esto puede tomar 20-40 segundos..." -ForegroundColor Gray

    for ($i=30; $i -gt 0; $i--) {
        Write-Progress -Activity "Iniciando Frontend" -Status "Esperando... $i segundos restantes" -PercentComplete ((30-$i)/30*100)
        Start-Sleep -Seconds 1

        if ($i % 5 -eq 0) {
            $frontendCheck = netstat -ano | findstr ":4200" | findstr "LISTENING"
            if ($frontendCheck) {
                Write-Progress -Activity "Iniciando Frontend" -Completed
                Write-Host "`n   OK Frontend iniciado exitosamente!" -ForegroundColor Green
                break
            }
        }
    }

    # Verificar si el frontend esta corriendo
    Start-Sleep -Seconds 2
    $frontendRunning = netstat -ano | findstr ":4200" | findstr "LISTENING"

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "SISTEMA RESERVA CANCHA" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan

    if ($backendRunning) {
        Write-Host "OK Backend:  http://localhost:8080" -ForegroundColor Green
    }

    if ($frontendRunning) {
        Write-Host "OK Frontend: http://localhost:4200" -ForegroundColor Green
    } else {
        Write-Host "NOTA Frontend: Iniciando... (revisa la ventana)" -ForegroundColor Yellow
    }

    Write-Host "========================================`n" -ForegroundColor Cyan

    if ($frontendRunning) {
        Write-Host "Sistema listo! Abre tu navegador en:" -ForegroundColor Green
        Write-Host "   http://localhost:4200`n" -ForegroundColor Cyan

        # Abrir navegador automaticamente
        Start-Sleep -Seconds 3
        Start-Process "http://localhost:4200"
    } else {
        Write-Host "El frontend esta compilando..." -ForegroundColor Yellow
        Write-Host "   Espera unos segundos y abre:" -ForegroundColor Gray
        Write-Host "   http://localhost:4200`n" -ForegroundColor Cyan
    }

} else {
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "ERROR: Backend no se inicio" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "`nPor favor:" -ForegroundColor Yellow
    Write-Host "1. Revisa la ventana CMD del backend para ver errores" -ForegroundColor White
    Write-Host "2. Verifica que Java este instalado: java -version" -ForegroundColor White
    Write-Host "3. O usa IntelliJ IDEA para ejecutar el proyecto`n" -ForegroundColor White
}

Write-Host "`nScript finalizado. Las ventanas de backend y frontend seguiran abiertas." -ForegroundColor Gray

