#!/bin/bash

# Script de despliegue para Railway
echo "🚀 Desplegando Backend en Railway..."

# Variables (Railway las inyectará automáticamente)
# DB_HOST, DB_PORT, DB_NAME, DB_USERNAME, DB_PASSWORD, FRONTEND_URL

# Compilar el proyecto
echo "📦 Compilando proyecto..."
cd backend
mvn clean package -DskipTests

# Railway ejecutará automáticamente el JAR
echo "✅ Compilación exitosa. Railway ejecutará el JAR automáticamente."

