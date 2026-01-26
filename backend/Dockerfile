# Use a Java 17 base image (eclipse-temurin is the recommended replacement for openjdk)
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory
WORKDIR /app

# Copy the entire backend directory
COPY backend/ ./

# Make mvnw executable (important for Linux)
RUN chmod +x ./mvnw

# Build the application
# Use the Maven wrapper to build the JAR
RUN ./mvnw clean install -DskipTests

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
# The JAR name should match what's in pom.xml
ENTRYPOINT ["java", "-jar", "target/reservacancha-backend-0.0.1-SNAPSHOT.jar"]

