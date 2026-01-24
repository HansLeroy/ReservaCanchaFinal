package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Usuario;
import com.example.reservacancha.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
     * Endpoint para crear el usuario administrador inicial
     * Solo funciona una vez - si ya existe un admin, no hace nada
     *
     * Uso: GET https://reservacancha-backend.onrender.com/api/init/admin
     */
    @GetMapping("/admin")
    public ResponseEntity<Map<String, Object>> crearAdminInicial() {
        Map<String, Object> response = new HashMap<>();

        try {
            // Verificar si ya existe un usuario administrador
            long countAdmins = usuarioRepository.countByRol("ADMIN");

            if (countAdmins > 0) {
                response.put("success", false);
                response.put("message", "Ya existe un usuario administrador en el sistema");
                response.put("info", "No se puede crear otro admin por seguridad");
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
            long adminCount = usuarioRepository.countByRol("ADMIN");

            response.put("success", true);
            response.put("totalUsuarios", totalUsuarios);
            response.put("adminCount", adminCount);
            response.put("adminExiste", adminCount > 0);
            response.put("mensaje", adminCount > 0
                ? "Sistema listo para usar"
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

