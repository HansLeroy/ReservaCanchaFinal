package com.example.reservacancha.backend.repository;

import com.example.reservacancha.backend.model.Pago;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para gestionar los pagos de reservas
 */
@Repository
public interface PagoRepository extends JpaRepository<Pago, Long> {

    Optional<Pago> findByReservaId(Long reservaId);

    List<Pago> findByEstado(String estado);

    default List<Pago> findByFechaRange(java.time.LocalDate inicio, java.time.LocalDate fin) {
        return findAll().stream()
                .filter(p -> p.getFecha() != null)
                .filter(p -> !p.getFecha().isBefore(inicio) && !p.getFecha().isAfter(fin))
                .collect(java.util.stream.Collectors.toList());
    }
}

