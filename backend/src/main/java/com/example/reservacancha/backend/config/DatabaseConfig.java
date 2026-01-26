package com.example.reservacancha.backend.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;
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

    @Value("${SPRING_DATASOURCE_URL:#{null}}")
    private String datasourceUrl;

    @Bean
    public DataSource dataSource() {
        // Obtener la URL desde la variable de entorno
        String databaseUrl = System.getenv("SPRING_DATASOURCE_URL");
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            databaseUrl = System.getenv("DATABASE_URL");
        }
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            databaseUrl = datasourceUrl;
        }

        String jdbcUrl;
        String username = null;
        String password = null;

        // Si la URL ya tiene el prefijo jdbc:, usarla directamente
        if (databaseUrl != null && databaseUrl.startsWith("jdbc:")) {
            System.out.println("✅ URL ya está en formato JDBC");
            jdbcUrl = databaseUrl;
            username = System.getenv("SPRING_DATASOURCE_USERNAME");
            password = System.getenv("SPRING_DATASOURCE_PASSWORD");
        } else if (databaseUrl != null && !databaseUrl.isEmpty()) {
            try {
                // Parsear la URL de Render (formato: postgresql://user:pass@host:port/db)
                URI dbUri = new URI(databaseUrl);

                username = dbUri.getUserInfo().split(":")[0];
                password = dbUri.getUserInfo().split(":")[1];
                String host = dbUri.getHost();
                int port = dbUri.getPort();
                String path = dbUri.getPath();

                // Construir la URL JDBC
                jdbcUrl = String.format(
                    "jdbc:postgresql://%s:%d%s?sslmode=require",
                    host, port, path
                );

                System.out.println("✅ DATABASE_URL convertida exitosamente");
                System.out.println("   Host: " + host);
                System.out.println("   Database: " + path.substring(1));
                System.out.println("   Username: " + username);

            } catch (URISyntaxException | NullPointerException e) {
                System.err.println("❌ Error parseando DATABASE_URL: " + e.getMessage());
                throw new RuntimeException("No se pudo parsear la URL de la base de datos", e);
            }
        } else {
            throw new RuntimeException("No se encontró configuración de base de datos");
        }

        // Configurar HikariCP
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);
        config.setDriverClassName("org.postgresql.Driver");
        config.setMaximumPoolSize(5);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);

        return new HikariDataSource(config);
    }
}

