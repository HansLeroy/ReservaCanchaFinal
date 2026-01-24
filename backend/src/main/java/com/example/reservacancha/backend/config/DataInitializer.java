package com.example.reservacancha.backend.config;

import com.example.reservacancha.backend.model.Usuario;
import com.example.reservacancha.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class DataInitializer {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostConstruct
    public void init() {
        // Verificar si existe un usuario administrador
        if (usuarioRepository.findAll().isEmpty()) {
            // Crear usuario administrador por defecto
            Usuario admin = new Usuario();
            admin.setNombre("Admin");
            admin.setApellido("Sistema");
            admin.setEmail("admin@reservacancha.cl");
            admin.setPassword("admin123");
            admin.setRut("11111111-1");
            admin.setTelefono("912345678");
            admin.setRol("ADMIN");
            admin.setActivo(true);

            usuarioRepository.save(admin);
            System.out.println("✅ Usuario administrador creado: admin@reservacancha.cl / admin123");

            // Crear usuario normal de ejemplo
            Usuario usuario = new Usuario();
            usuario.setNombre("Usuario");
            usuario.setApellido("Demo");
            usuario.setEmail("usuario@reservacancha.cl");
            usuario.setPassword("usuario123");
            usuario.setRut("22222222-2");
            usuario.setTelefono("987654321");
            usuario.setRol("USUARIO");
            usuario.setActivo(true);

            usuarioRepository.save(usuario);
            System.out.println("✅ Usuario de ejemplo creado: usuario@reservacancha.cl / usuario123");
        }
    }
}

