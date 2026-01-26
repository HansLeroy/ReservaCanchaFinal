# Use a Java 17 base image (eclipse-temurin is the recommended replacement for openjdk)
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory
WORKDIR /app

# Copy the entire backend directory (. porque dockerContext ya es ./backend)
COPY . ./

# Make mvnw executable (important for Linux)
RUN chmod +x ./mvnw

# Build the application
# Use the Maven wrapper to build the JAR
RUN ./mvnw clean package -DskipTests

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application with support for Render's PORT variable
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar target/reservacancha-backend-0.0.1-SNAPSHOT.jar"]

