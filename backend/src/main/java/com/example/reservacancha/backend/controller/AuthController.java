package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Usuario;
import com.example.reservacancha.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class AuthController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody LoginRequest request) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Validar que vengan los datos
            if (request.getEmail() == null || request.getEmail().isEmpty()) {
                response.put("success", false);
                response.put("message", "El correo es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getPassword() == null || request.getPassword().isEmpty()) {
                response.put("success", false);
                response.put("message", "La contraseña es requerida");
                return ResponseEntity.badRequest().body(response);
            }

            // Buscar usuario
            Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(request.getEmail());

            if (!usuarioOpt.isPresent()) {
                response.put("success", false);
                response.put("message", "Usuario no encontrado");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            Usuario usuario = usuarioOpt.get();

            // Verificar si está activo
            if (!usuario.getActivo()) {
                response.put("success", false);
                response.put("message", "Usuario inactivo");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // Verificar contraseña
            if (!usuario.getPassword().equals(request.getPassword())) {
                response.put("success", false);
                response.put("message", "Contraseña incorrecta");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // Login exitoso
            response.put("success", true);
            response.put("message", "Login exitoso");
            response.put("token", generarToken(usuario));

            Map<String, Object> userData = new HashMap<>();
            userData.put("id", usuario.getId());
            userData.put("email", usuario.getEmail());
            userData.put("nombre", usuario.getNombre());
            userData.put("rol", usuario.getRol());

            response.put("user", userData);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error en el servidor: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateToken(@RequestHeader("Authorization") String token) {
        Map<String, Object> response = new HashMap<>();

        // Validación simple de token (en producción usar JWT)
        if (token != null && token.startsWith("Bearer ")) {
            response.put("valid", true);
            response.put("message", "Token válido");
            return ResponseEntity.ok(response);
        }

        response.put("valid", false);
        response.put("message", "Token inválido");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
    }

    @PostMapping("/registro")
    public ResponseEntity<Map<String, Object>> registro(@RequestBody RegistroRequest request) {
        Map<String, Object> response = new HashMap<>();

        // REGISTRO PÚBLICO DESHABILITADO
        // Solo el administrador puede crear nuevos usuarios desde el panel de administración
        response.put("success", false);
        response.put("message", "El registro público está deshabilitado. Por favor, contacta al administrador para solicitar acceso al sistema.");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);


    }
    // Generar token simple (en producción usar JWT)
    private String generarToken(Usuario usuario) {
        return "Bearer_" + usuario.getId() + "_" + System.currentTimeMillis();
    }

    // Clase interna para la petición de login
    public static class LoginRequest {
        private String email;
        private String password;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }

    // Clase interna para la petición de registro
    public static class RegistroRequest {
        private String nombre;
        private String apellido;
        private String email;
        private String password;
        private String rut;
        private String telefono;

        public String getNombre() {
            return nombre;
        }

        public void setNombre(String nombre) {
            this.nombre = nombre;
        }

        public String getApellido() {
            return apellido;
        }

        public void setApellido(String apellido) {
            this.apellido = apellido;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getRut() {
            return rut;
        }

        public void setRut(String rut) {
            this.rut = rut;
        }

        public String getTelefono() {
            return telefono;
        }

        public void setTelefono(String telefono) {
            this.telefono = telefono;
        }
    }
}
