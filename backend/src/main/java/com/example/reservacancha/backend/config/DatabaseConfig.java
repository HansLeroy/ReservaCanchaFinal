package com.example.reservacancha.backend.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
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


    @Bean
    @Primary
    public DataSource dataSource() {
        System.out.println("🚀 Iniciando configuración de DataSource para producción...");

        // Obtener la URL desde la variable de entorno
        String databaseUrl = System.getenv("SPRING_DATASOURCE_URL");
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            databaseUrl = System.getenv("DATABASE_URL");
        }

        System.out.println("🔍 URL Original recibida: " + (databaseUrl != null ? databaseUrl : "NULL"));

        if (databaseUrl == null || databaseUrl.isEmpty()) {
            System.err.println("❌ ERROR CRÍTICO: No se encontró DATABASE_URL ni SPRING_DATASOURCE_URL");
            System.err.println("   Variables de entorno disponibles:");
            System.getenv().keySet().stream()
                .filter(key -> key.contains("DATABASE") || key.contains("DATASOURCE") || key.contains("POSTGRES"))
                .forEach(key -> System.err.println("     - " + key));
            throw new RuntimeException("No se encontró configuración de base de datos (DATABASE_URL o SPRING_DATASOURCE_URL)");
        }

        String jdbcUrl;
        String username = null;
        String password = null;

        // Si la URL ya tiene el prefijo jdbc:, usarla directamente
        if (databaseUrl.startsWith("jdbc:")) {
            System.out.println("✅ URL ya está en formato JDBC");
            jdbcUrl = databaseUrl;
            username = System.getenv("SPRING_DATASOURCE_USERNAME");
            password = System.getenv("SPRING_DATASOURCE_PASSWORD");

            if (username == null || password == null) {
                throw new RuntimeException("URL en formato JDBC pero faltan credenciales (SPRING_DATASOURCE_USERNAME o SPRING_DATASOURCE_PASSWORD)");
            }
        } else {
            try {
                System.out.println("🔄 Convirtiendo URL de PostgreSQL a formato JDBC...");
                // Parsear la URL de Render (formato: postgresql://user:pass@host:port/db)
                URI dbUri = new URI(databaseUrl);

                String userInfo = dbUri.getUserInfo();
                if (userInfo != null && userInfo.contains(":")) {
                    String[] userInfoParts = userInfo.split(":", 2);
                    username = userInfoParts[0];
                    password = userInfoParts[1];
                } else {
                    // Si no hay credenciales en la URL, usar variables de entorno
                    username = System.getenv("SPRING_DATASOURCE_USERNAME");
                    password = System.getenv("SPRING_DATASOURCE_PASSWORD");
                }

                if (username == null || username.isEmpty()) {
                    throw new RuntimeException("No se pudo extraer el username de la URL ni de las variables de entorno");
                }
                if (password == null || password.isEmpty()) {
                    throw new RuntimeException("No se pudo extraer el password de la URL ni de las variables de entorno");
                }

                String host = dbUri.getHost();
                int port = dbUri.getPort();
                // Si el puerto no está especificado, usar el puerto por defecto de PostgreSQL
                if (port == -1) {
                    port = 5432;
                    System.out.println("⚠️  Puerto no especificado, usando puerto por defecto: 5432");
                }
                String path = dbUri.getPath();

                // Validar que tengamos los datos necesarios
                if (host == null || host.isEmpty()) {
                    throw new RuntimeException("No se pudo extraer el host de la URL");
                }
                if (path == null || path.isEmpty()) {
                    throw new RuntimeException("No se pudo extraer la base de datos de la URL");
                }

                // Construir la URL JDBC
                jdbcUrl = String.format(
                    "jdbc:postgresql://%s:%d%s?sslmode=require",
                    host, port, path
                );

                System.out.println("✅ DATABASE_URL convertida exitosamente");
                System.out.println("   JDBC URL: " + jdbcUrl);
                System.out.println("   Host: " + host);
                System.out.println("   Port: " + port);
                System.out.println("   Database: " + path.substring(1));
                System.out.println("   Username: " + username);

            } catch (URISyntaxException e) {
                System.err.println("❌ Error parseando DATABASE_URL: " + e.getMessage());
                System.err.println("   URL recibida: " + databaseUrl);
                e.printStackTrace();
                throw new RuntimeException("No se pudo parsear la URL de la base de datos: " + e.getMessage(), e);
            } catch (Exception e) {
                System.err.println("❌ Error inesperado al configurar la base de datos: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("Error al configurar la base de datos: " + e.getMessage(), e);
            }
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

