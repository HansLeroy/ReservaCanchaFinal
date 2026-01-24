package com.example.reservacancha.backend.repository;

import com.example.reservacancha.backend.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para gestionar clientes del sistema (personas que reservan)
 */
@Repository
public interface ClienteRepository extends JpaRepository<Cliente, String> {

    Optional<Cliente> findByRut(String rut);

    Optional<Cliente> findByEmail(String email);

    boolean existsByRut(String rut);

    boolean existsByEmail(String email);

    default List<Cliente> findActivos() {
        return findAll().stream()
                .filter(Cliente::getActivo)
                .collect(java.util.stream.Collectors.toList());
    }
}

