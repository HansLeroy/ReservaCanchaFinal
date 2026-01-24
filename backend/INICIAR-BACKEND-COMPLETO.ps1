# Script para iniciar el backend correctamente
Write-Host "Iniciando backend de ReservaCancha..." -ForegroundColor Green

# Cambiar al directorio del backend
Set-Location -Path "C:\Users\hafer\IdeaProjects\ReservaCancha\backend"

# Verificar si el puerto 8080 está en uso
$port8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($port8080) {
    Write-Host "El puerto 8080 ya está en uso. Deteniendo procesos..." -ForegroundColor Yellow
    $processId = $port8080.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Limpiar el proyecto
Write-Host "Limpiando proyecto Maven..." -ForegroundColor Cyan
.\mvnw.cmd clean

# Compilar el proyecto
Write-Host "Compilando proyecto..." -ForegroundColor Cyan
.\mvnw.cmd compile

# Iniciar el backend
Write-Host "Iniciando servidor Spring Boot..." -ForegroundColor Green
.\mvnw.cmd spring-boot:run

