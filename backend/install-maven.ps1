# Script para ayudar con la instalación de Maven
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALADOR DE MAVEN" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# Verificar si Maven ya está instalado
Write-Host "`nVerificando si Maven está instalado..." -ForegroundColor Yellow
try {
    $mvnCheck = Get-Command mvn -ErrorAction Stop
    Write-Host "✅ Maven ya está instalado en:" -ForegroundColor Green
    Write-Host "   $($mvnCheck.Source)" -ForegroundColor White
    Write-Host "`nEjecutando mvn --version:" -ForegroundColor Cyan
    mvn --version
    Write-Host "`n✓ No necesitas hacer nada más!" -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "❌ Maven NO está instalado" -ForegroundColor Red
}

# Verificar si Chocolatey está disponible
Write-Host "`nVerificando si Chocolatey está disponible..." -ForegroundColor Yellow
try {
    $chocoCheck = Get-Command choco -ErrorAction Stop
    Write-Host "✅ Chocolatey está disponible" -ForegroundColor Green

    Write-Host "`n¿Deseas instalar Maven usando Chocolatey? (S/N): " -ForegroundColor Yellow -NoNewline
    $respuesta = Read-Host

    if ($respuesta -eq 'S' -or $respuesta -eq 's' -or $respuesta -eq 'Y' -or $respuesta -eq 'y') {
        Write-Host "`nInstalando Maven con Chocolatey..." -ForegroundColor Cyan
        Write-Host "Ejecutando: choco install maven -y" -ForegroundColor Gray
        choco install maven -y

        Write-Host "`n✓ Maven instalado!" -ForegroundColor Green
        Write-Host "Por favor, cierra y vuelve a abrir PowerShell para usar Maven" -ForegroundColor Yellow
        exit 0
    }
}
catch {
    Write-Host "⚠️  Chocolatey no está instalado" -ForegroundColor Yellow
}

# Si llegamos aquí, mostrar instrucciones manuales
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INSTALACIÓN MANUAL DE MAVEN" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nOpción 1: Instalar Chocolatey primero (recomendado)" -ForegroundColor Green
Write-Host "  1. Abre PowerShell como Administrador" -ForegroundColor White
Write-Host "  2. Ejecuta:" -ForegroundColor White
Write-Host "     Set-ExecutionPolicy Bypass -Scope Process -Force;" -ForegroundColor Cyan
Write-Host "     [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;" -ForegroundColor Cyan
Write-Host "     iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Cyan
Write-Host "  3. Luego ejecuta: choco install maven -y" -ForegroundColor Cyan

Write-Host "`nOpción 2: Descarga manual" -ForegroundColor Green
Write-Host "  1. Ve a: https://maven.apache.org/download.cgi" -ForegroundColor White
Write-Host "  2. Descarga: apache-maven-3.9.x-bin.zip" -ForegroundColor White
Write-Host "  3. Extrae en: C:\Program Files\Apache\maven" -ForegroundColor White
Write-Host "  4. Agrega al PATH del sistema:" -ForegroundColor White
Write-Host "     - Click derecho en 'Este equipo' > Propiedades" -ForegroundColor Gray
Write-Host "     - Variables de entorno" -ForegroundColor Gray
Write-Host "     - En 'Variables del sistema', edita 'Path'" -ForegroundColor Gray
Write-Host "     - Agrega: C:\Program Files\Apache\maven\bin" -ForegroundColor Gray
Write-Host "  5. Reinicia PowerShell" -ForegroundColor White

Write-Host "`nOpción 3: Usar Scoop (alternativa a Chocolatey)" -ForegroundColor Green
Write-Host "  1. Instala Scoop:" -ForegroundColor White
Write-Host "     iwr -useb get.scoop.sh | iex" -ForegroundColor Cyan
Write-Host "  2. Instala Maven:" -ForegroundColor White
Write-Host "     scoop install maven" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Después de instalar Maven, verifica con:" -ForegroundColor Yellow
Write-Host "  mvn --version" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

