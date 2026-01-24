Write-Host "==================================================" -ForegroundColor Green
Write-Host "  Iniciando Backend - ReservaCancha" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""

# Detener cualquier proceso Java previo
Write-Host "Deteniendo procesos Java previos..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

Set-Location -Path "$PSScriptRoot"

Write-Host "Compilando el proyecto..." -ForegroundColor Yellow
& .\mvnw.cmd clean package -DskipTests

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Compilacion exitosa!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Iniciando el servidor Spring Boot en el puerto 8080..." -ForegroundColor Yellow
    Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Cyan
    Write-Host ""

    & .\mvnw.cmd spring-boot:run
} else {
    Write-Host ""
    Write-Host "Error al compilar el proyecto" -ForegroundColor Red
    Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

