# ============================================
# SOLUCIÓN AL ERROR 401 - PASOS CRÍTICOS
# ============================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Red
Write-Host "     ERROR 401: USUARIO ADMIN NO EXISTE" -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Red
Write-Host ""

Write-Host "DIAGNÓSTICO:" -ForegroundColor Yellow
Write-Host "✗ El backend responde con 401 (Unauthorized)" -ForegroundColor Red
Write-Host "✗ El usuario admin NO ha sido creado" -ForegroundColor Red
Write-Host "✗ El backend tiene el código VIEJO (con el bug)" -ForegroundColor Red
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     SOLUCIÓN: 3 PASOS OBLIGATORIOS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "PASO 1: REDESPLEGAR EL BACKEND" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor White
Write-Host "1. Abre tu navegador" -ForegroundColor White
Write-Host "2. Ve a: https://dashboard.render.com/" -ForegroundColor Cyan
Write-Host "3. Click en: 'reservacancha-backend'" -ForegroundColor White
Write-Host "4. Click en: 'Manual Deploy' (esquina superior derecha)" -ForegroundColor White
Write-Host "5. Selecciona: 'Deploy latest commit'" -ForegroundColor White
Write-Host "6. ESPERA hasta que diga 'Live' en VERDE" -ForegroundColor Yellow
Write-Host "   (Esto toma 5-10 minutos)" -ForegroundColor Gray
Write-Host ""

Write-Host "PASO 2: CREAR EL USUARIO ADMIN" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor White
Write-Host "Cuando el backend diga 'Live', abre en tu navegador:" -ForegroundColor White
Write-Host ""
Write-Host "   https://reservacancha-backend.onrender.com/api/init/admin" -ForegroundColor Cyan
Write-Host ""
Write-Host "Deberías ver:" -ForegroundColor White
Write-Host '   {' -ForegroundColor Gray
Write-Host '     "success": true,' -ForegroundColor Gray
Write-Host '     "credenciales": {' -ForegroundColor Gray
Write-Host '       "email": "admin@reservacancha.com",' -ForegroundColor Gray
Write-Host '       "password": "admin123"' -ForegroundColor Gray
Write-Host '     }' -ForegroundColor Gray
Write-Host '   }' -ForegroundColor Gray
Write-Host ""

Write-Host "PASO 3: INICIAR SESIÓN" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor White
Write-Host "Ve a: https://reservacancha-frontend.onrender.com" -ForegroundColor Cyan
Write-Host ""
Write-Host "Usa estas credenciales:" -ForegroundColor White
Write-Host "   Email:    admin@reservacancha.com" -ForegroundColor Yellow
Write-Host "   Password: admin123" -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     POR QUÉ NECESITAS REDESPLEGAR" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "El código actual en Render tiene un BUG:" -ForegroundColor Red
Write-Host "  • El endpoint /api/init/admin daba Error 500" -ForegroundColor Red
Write-Host "  • Por eso no podías crear el usuario admin" -ForegroundColor Red
Write-Host "  • Por eso el login da Error 401" -ForegroundColor Red
Write-Host ""
Write-Host "Ya CORREGÍ el bug y lo SUBÍ a GitHub:" -ForegroundColor Green
Write-Host "  ✓ Commit: 'fix: Corregir InitController...'" -ForegroundColor Green
Write-Host "  ✓ El código nuevo usa 'existsByEmail'" -ForegroundColor Green
Write-Host "  ✓ Ya no tendrás Error 500" -ForegroundColor Green
Write-Host ""
Write-Host "Pero Render aún tiene el código VIEJO:" -ForegroundColor Yellow
Write-Host "  → Por eso DEBES hacer 'Manual Deploy'" -ForegroundColor Yellow
Write-Host "  → Para que Render descargue el código NUEVO" -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     ¿NO PUEDES ACCEDER A RENDER?" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si no puedes acceder a Render o no tienes acceso:" -ForegroundColor Yellow
Write-Host ""
Write-Host "OPCIÓN A: Trigger desde Git" -ForegroundColor White
Write-Host "  Render puede redesplegar automáticamente con cada push" -ForegroundColor Gray
Write-Host "  (Pero esto puede tardar varios minutos)" -ForegroundColor Gray
Write-Host ""
Write-Host "OPCIÓN B: Crear admin manualmente en la BD" -ForegroundColor White
Write-Host "  Necesitas acceso al PostgreSQL en Render" -ForegroundColor Gray
Write-Host "  Ver: CREAR-ADMIN-POSTGRESQL-RENDER.md" -ForegroundColor Gray
Write-Host ""

Write-Host "============================================" -ForegroundColor Green
Write-Host "     RESULTADO ESPERADO" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Después de redesplegar:" -ForegroundColor White
Write-Host "  ✓ /api/init/admin funcionará (sin Error 500)" -ForegroundColor Green
Write-Host "  ✓ Usuario admin será creado en la BD" -ForegroundColor Green
Write-Host "  ✓ Login funcionará (sin Error 401)" -ForegroundColor Green
Write-Host "  ✓ Podrás entrar al sistema completo" -ForegroundColor Green
Write-Host ""

Write-Host "============================================" -ForegroundColor Red
Write-Host "     ACCIÓN INMEDIATA REQUERIDA" -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Red
Write-Host ""
Write-Host "1. Ve a Render Dashboard AHORA" -ForegroundColor Yellow
Write-Host "2. Haz 'Manual Deploy' del backend" -ForegroundColor Yellow
Write-Host "3. Espera 10 minutos" -ForegroundColor Yellow
Write-Host "4. Crea el admin visitando /api/init/admin" -ForegroundColor Yellow
Write-Host "5. Inicia sesión" -ForegroundColor Yellow
Write-Host ""

Write-Host "Presiona cualquier tecla para abrir Render Dashboard..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Abrir Render Dashboard en el navegador
Start-Process "https://dashboard.render.com/"

Write-Host ""
Write-Host "✓ Navegador abierto con Render Dashboard" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora sigue los pasos de arriba." -ForegroundColor White
Write-Host ""

