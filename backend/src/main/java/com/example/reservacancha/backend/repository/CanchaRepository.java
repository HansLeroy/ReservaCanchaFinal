package com.example.reservacancha.backend.repository;

import com.example.reservacancha.backend.model.Cancha;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repositorio JPA para gestionar canchas deportivas
 */
@Repository
public interface CanchaRepository extends JpaRepository<Cancha, Long> {

    List<Cancha> findByDisponible(boolean disponible);

    List<Cancha> findByTipo(String tipo);
}

