# Dockerfile para Spring Boot Backend

# Etapa 1: Construcción
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app

# Copiar archivos de configuración de Maven
COPY backend/pom.xml .
COPY backend/src ./src

# Compilar el proyecto
RUN mvn clean package -DskipTests

# Etapa 2: Imagen final
FROM openjdk:11-jre-slim
WORKDIR /app

# Copiar el JAR compilado desde la etapa de construcción
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto (Railway lo asignará dinámicamente)
EXPOSE 8080

# Variables de entorno por defecto
ENV SPRING_PROFILES_ACTIVE=prod

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]

