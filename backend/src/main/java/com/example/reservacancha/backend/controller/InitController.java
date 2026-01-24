package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Usuario;
import com.example.reservacancha.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.HashMap;
import java.util.Map;

/**
 * Controlador temporal para inicializar el usuario administrador
 * Solo funciona si no existe ningún usuario ADMIN en la base de datos
 */
@RestController
@RequestMapping("/api/init")
public class InitController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Endpoint raíz - muestra información de ayuda
     */
    @RequestMapping(value = {"", "/"}, method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> infoEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("mensaje", "Endpoint de inicialización del sistema");
        response.put("endpoints", Map.of(
            "/api/init/admin", "Crear usuario administrador (GET o POST)",
            "/api/init/status", "Verificar estado del sistema (GET)"
        ));
        response.put("instrucciones", "Visita /api/init/admin para crear el usuario administrador");
        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint para crear el usuario administrador inicial
     * Solo funciona una vez - si ya existe un admin, no hace nada
     *
     * Uso: GET o POST https://reservacancha-backend.onrender.com/api/init/admin
     */
    @RequestMapping(value = "/admin", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> crearAdminInicial() {
        Map<String, Object> response = new HashMap<>();

        try {
            // Verificar si ya existe el usuario admin por email o RUT
            if (usuarioRepository.existsByEmail("admin@reservacancha.com") ||
                usuarioRepository.existsByRut("11111111-1")) {
                response.put("success", true);
                response.put("message", "El usuario administrador ya existe en el sistema");
                response.put("info", "Puedes iniciar sesión con estas credenciales");
                response.put("credenciales", Map.of(
                    "email", "admin@reservacancha.com",
                    "password", "admin123",
                    "rol", "ADMIN"
                ));
                return ResponseEntity.ok(response);
            }

            // Crear el usuario administrador
            Usuario admin = new Usuario();
            admin.setRut("11111111-1");
            admin.setNombre("Administrador");
            admin.setApellido("Sistema");
            admin.setEmail("admin@reservacancha.com");
            admin.setPassword("admin123"); // En producción real debería estar hasheada
            admin.setTelefono("+56912345678");
            admin.setRol("ADMIN");
            admin.setActivo(true);

            // Guardar en la base de datos
            Usuario adminGuardado = usuarioRepository.save(admin);

            response.put("success", true);
            response.put("message", "Usuario administrador creado exitosamente");
            response.put("credenciales", Map.of(
                "email", "admin@reservacancha.com",
                "password", "admin123",
                "rol", "ADMIN"
            ));
            response.put("advertencia", "Cambia la contraseña después del primer login");
            response.put("usuarioId", adminGuardado.getId());

            return ResponseEntity.ok(response);

        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // Error de duplicate key - el admin ya existe
            response.put("success", true);
            response.put("message", "El usuario administrador ya existe (duplicate key detectado)");
            response.put("info", "Puedes iniciar sesión con estas credenciales");
            response.put("credenciales", Map.of(
                "email", "admin@reservacancha.com",
                "password", "admin123",
                "rol", "ADMIN"
            ));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error inesperado al crear el usuario administrador");
            response.put("error", e.getMessage());
            response.put("errorType", e.getClass().getName());
            response.put("solucion", "El admin probablemente ya existe. Intenta iniciar sesión con: admin@reservacancha.com / admin123");
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Endpoint de emergencia para resetear el password del admin existente
     * Uso: GET/POST https://reservacancha-backend.onrender.com/api/init/reset-admin
     */
    @RequestMapping(value = "/reset-admin", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> resetearPasswordAdmin() {
        Map<String, Object> response = new HashMap<>();

        try {
            // Buscar el usuario admin por email
            var adminOpt = usuarioRepository.findByEmail("admin@reservacancha.com");

            if (adminOpt.isEmpty()) {
                // Buscar por RUT alternativo
                adminOpt = usuarioRepository.findByRut("11111111-1");
            }

            if (adminOpt.isPresent()) {
                Usuario admin = adminOpt.get();
                admin.setPassword("admin123");
                admin.setActivo(true);
                admin.setRol("ADMIN");
                usuarioRepository.save(admin);

                response.put("success", true);
                response.put("message", "Password del administrador reseteado exitosamente");
                response.put("credenciales", Map.of(
                    "email", admin.getEmail(),
                    "password", "admin123",
                    "rol", "ADMIN"
                ));
                response.put("info", "Ahora puedes iniciar sesión con estas credenciales");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "No se encontró ningún usuario administrador");
                response.put("solucion", "Visita /api/init/admin para crear uno nuevo");
                return ResponseEntity.status(404).body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al resetear el password del administrador");
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Endpoint para verificar el estado del sistema
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> verificarEstado() {
        Map<String, Object> response = new HashMap<>();

        try {
            long totalUsuarios = usuarioRepository.count();
            boolean adminExiste = usuarioRepository.existsByEmail("admin@reservacancha.com");

            response.put("success", true);
            response.put("totalUsuarios", totalUsuarios);
            response.put("adminExiste", adminExiste);
            response.put("mensaje", adminExiste
                ? "Sistema listo para usar - admin@reservacancha.com / admin123"
                : "Sistema necesita inicialización - visita /api/init/admin");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al verificar el estado");
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}

