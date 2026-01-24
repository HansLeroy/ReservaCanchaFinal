@echo off
echo ===============================================
echo    CONSULTAR CANCHAS EN LA BASE DE DATOS
echo ===============================================
echo.

powershell -Command "$canchas = Invoke-RestMethod -Uri 'http://localhost:8080/api/canchas' -Method Get; Write-Host ''; Write-Host '===============================================' -ForegroundColor Cyan; Write-Host '   CANCHAS REGISTRADAS EN LA BASE DE DATOS   ' -ForegroundColor Cyan; Write-Host '===============================================' -ForegroundColor Cyan; Write-Host ''; if ($canchas.Count -gt 0) { Write-Host \"Total de canchas: $($canchas.Count)\" -ForegroundColor Green; Write-Host ''; $i = 1; foreach ($cancha in $canchas) { Write-Host \"--- Cancha #$i ---\" -ForegroundColor Yellow; Write-Host \"  ID:              $($cancha.id)\"; Write-Host \"  Nombre:          $($cancha.nombre)\"; Write-Host \"  Tipo:            $($cancha.tipo)\"; Write-Host \"  Descripcion:     $($cancha.descripcion)\"; Write-Host \"  Precio/Hora:     `$$($cancha.precioPorHora) CLP\" -ForegroundColor Green; $estado = if ($cancha.disponible) { 'DISPONIBLE' } else { 'EN MANTENIMIENTO' }; $color = if ($cancha.disponible) { 'Green' } else { 'Red' }; Write-Host \"  Estado:          $estado\" -ForegroundColor $color; Write-Host ''; $i++ } } else { Write-Host 'No hay canchas registradas en el sistema.' -ForegroundColor Red; Write-Host ''; }"

echo.
pause

