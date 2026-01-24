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
@CrossOrigin(origins = "*")
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
            // Verificar si ya existe el usuario admin por email
            if (usuarioRepository.existsByEmail("admin@reservacancha.com")) {
                response.put("success", false);
                response.put("message", "Ya existe un usuario administrador en el sistema");
                response.put("info", "Usa: admin@reservacancha.com / admin123");
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

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al crear el usuario administrador");
            response.put("error", e.getMessage());
            response.put("stackTrace", e.getClass().getName());
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

