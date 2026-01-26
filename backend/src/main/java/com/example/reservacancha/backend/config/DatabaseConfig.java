package com.example.reservacancha.backend.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import javax.annotation.PostConstruct;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Configuración para parsear DATABASE_URL de Render
 * Render proporciona URLs en formato: postgresql://user:pass@host:port/db
 * Spring Boot necesita: jdbc:postgresql://host:port/db
 */
@Configuration
@Profile("prod")
public class DatabaseConfig {

    @PostConstruct
    public void initDatabaseUrl() {
        // Render puede proporcionar la URL como DATABASE_URL o SPRING_DATASOURCE_URL
        String databaseUrl = System.getenv("DATABASE_URL");
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            databaseUrl = System.getenv("SPRING_DATASOURCE_URL");
        }

        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            // Si la URL ya tiene el prefijo jdbc:, no hacer nada
            if (databaseUrl.startsWith("jdbc:")) {
                System.out.println("✅ URL ya está en formato JDBC, no se requiere conversión");
                return;
            }
            
            try {
                // Parsear la URL de Render (formato: postgresql://user:pass@host:port/db)
                URI dbUri = new URI(databaseUrl);

                String username = dbUri.getUserInfo().split(":")[0];
                String password = dbUri.getUserInfo().split(":")[1];
                String host = dbUri.getHost();
                int port = dbUri.getPort();
                String path = dbUri.getPath();

                // Construir la URL JDBC
                String jdbcUrl = String.format(
                    "jdbc:postgresql://%s:%d%s?sslmode=require",
                    host, port, path
                );

                // Establecer las propiedades del sistema para Spring Boot
                System.setProperty("spring.datasource.url", jdbcUrl);
                System.setProperty("spring.datasource.username", username);
                System.setProperty("spring.datasource.password", password);

                System.out.println("✅ DATABASE_URL parseada exitosamente");
                System.out.println("   Host: " + host);
                System.out.println("   Database: " + path.substring(1)); // Remove leading /
                System.out.println("   Username: " + username);

            } catch (URISyntaxException e) {
                System.err.println("❌ Error parseando DATABASE_URL: " + e.getMessage());
                // No hacemos nada, dejamos que Spring use las configuraciones del properties
            }
        } else {
            System.out.println("ℹ️  DATABASE_URL no encontrada, usando configuración manual del properties");
        }
    }
}

