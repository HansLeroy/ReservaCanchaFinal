#!/bin/bash

# Script de despliegue para Vercel
echo "🚀 Desplegando Frontend en Vercel..."

# Navegar al directorio del frontend
cd frontend

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm install

# Compilar para producción
echo "🔨 Compilando para producción..."
npm run build -- --configuration=production

echo "✅ Build completado. Archivos en dist/reservacancha-frontend/"

