package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Usuario;
import com.example.reservacancha.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Controlador para gestión de usuarios (solo ADMIN)
 */
@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Obtener todos los usuarios (solo ADMIN)
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> listarUsuarios(@RequestHeader(value = "User-Role", required = false) String userRole) {
        Map<String, Object> response = new HashMap<>();

        // Verificar que sea ADMIN
        if (!"ADMIN".equals(userRole)) {
            response.put("success", false);
            response.put("message", "No tienes permisos para acceder a esta función");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }

        try {
            List<Usuario> usuarios = usuarioRepository.findAll();

            // Mapear usuarios sin contraseña
            List<Map<String, Object>> usuariosData = usuarios.stream()
                .map(u -> {
                    Map<String, Object> userData = new HashMap<>();
                    userData.put("id", u.getId());
                    userData.put("nombre", u.getNombre());
                    userData.put("apellido", u.getApellido());
                    userData.put("email", u.getEmail());
                    userData.put("rol", u.getRol());
                    userData.put("rut", u.getRut());
                    userData.put("telefono", u.getTelefono());
                    userData.put("activo", u.getActivo());
                    return userData;
                })
                .collect(Collectors.toList());

            response.put("success", true);
            response.put("usuarios", usuariosData);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al obtener usuarios: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Crear nuevo usuario (solo ADMIN)
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> crearUsuario(
            @RequestBody CrearUsuarioRequest request,
            @RequestHeader(value = "User-Role", required = false) String userRole) {

        Map<String, Object> response = new HashMap<>();

        // Verificar que sea ADMIN
        if (!"ADMIN".equals(userRole)) {
            response.put("success", false);
            response.put("message", "No tienes permisos para crear usuarios");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }

        try {
            // Validaciones
            if (request.getNombre() == null || request.getNombre().isEmpty()) {
                response.put("success", false);
                response.put("message", "El nombre es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getApellido() == null || request.getApellido().isEmpty()) {
                response.put("success", false);
                response.put("message", "El apellido es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getEmail() == null || request.getEmail().isEmpty()) {
                response.put("success", false);
                response.put("message", "El email es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getPassword() == null || request.getPassword().length() < 6) {
                response.put("success", false);
                response.put("message", "La contraseña debe tener al menos 6 caracteres");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getRut() == null || request.getRut().isEmpty()) {
                response.put("success", false);
                response.put("message", "El RUT es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            if (request.getRol() == null || request.getRol().isEmpty()) {
                response.put("success", false);
                response.put("message", "El rol es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            // Verificar si el email ya existe
            if (usuarioRepository.existsByEmail(request.getEmail())) {
                response.put("success", false);
                response.put("message", "El email ya está registrado");
                return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
            }

            // Verificar si el RUT ya existe
            if (usuarioRepository.existsByRut(request.getRut())) {
                response.put("success", false);
                response.put("message", "El RUT ya está registrado");
                return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
            }

            // Crear nuevo usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombre(request.getNombre());
            nuevoUsuario.setApellido(request.getApellido());
            nuevoUsuario.setEmail(request.getEmail());
            nuevoUsuario.setPassword(request.getPassword()); // En producción: encriptar
            nuevoUsuario.setRut(request.getRut());
            nuevoUsuario.setTelefono(request.getTelefono());
            nuevoUsuario.setRol(request.getRol());
            nuevoUsuario.setActivo(true);

            // Guardar usuario
            Usuario usuarioGuardado = usuarioRepository.save(nuevoUsuario);

            // Respuesta exitosa (sin contraseña)
            response.put("success", true);
            response.put("message", "Usuario creado exitosamente");
            response.put("usuario", Map.of(
                "id", usuarioGuardado.getId(),
                "nombre", usuarioGuardado.getNombre(),
                "apellido", usuarioGuardado.getApellido(),
                "email", usuarioGuardado.getEmail(),
                "rol", usuarioGuardado.getRol(),
                "rut", usuarioGuardado.getRut(),
                "telefono", usuarioGuardado.getTelefono() != null ? usuarioGuardado.getTelefono() : "",
                "activo", usuarioGuardado.getActivo()
            ));

            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al crear usuario: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Activar/Desactivar usuario (solo ADMIN)
     */
    @PatchMapping("/{id}/estado")
    public ResponseEntity<Map<String, Object>> cambiarEstado(
            @PathVariable Long id,
            @RequestBody Map<String, Boolean> body,
            @RequestHeader(value = "User-Role", required = false) String userRole) {

        Map<String, Object> response = new HashMap<>();

        // Verificar que sea ADMIN
        if (!"ADMIN".equals(userRole)) {
            response.put("success", false);
            response.put("message", "No tienes permisos para modificar usuarios");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }

        try {
            Usuario usuario = usuarioRepository.findById(id).orElse(null);

            if (usuario == null) {
                response.put("success", false);
                response.put("message", "Usuario no encontrado");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

            Boolean nuevoEstado = body.get("activo");
            if (nuevoEstado == null) {
                response.put("success", false);
                response.put("message", "Estado 'activo' es requerido");
                return ResponseEntity.badRequest().body(response);
            }

            usuario.setActivo(nuevoEstado);
            usuarioRepository.save(usuario);

            response.put("success", true);
            response.put("message", "Estado del usuario actualizado");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error al cambiar estado: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // Clase interna para la petición de crear usuario
    public static class CrearUsuarioRequest {
        private String nombre;
        private String apellido;
        private String email;
        private String password;
        private String rut;
        private String telefono;
        private String rol;

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

        public String getRol() {
            return rol;
        }

        public void setRol(String rol) {
            this.rol = rol;
        }
    }
}

