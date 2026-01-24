package com.example.reservacancha.backend.repository;

import com.example.reservacancha.backend.model.Horario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para gestionar horarios de canchas
 */
@Repository
public interface HorarioRepository extends JpaRepository<Horario, Long> {

    List<Horario> findByCanchaId(Long canchaId);

    List<Horario> findByCanchaIdAndDiaSemana(Long canchaId, String diaSemana);

    // Alias para compatibilidad con código existente - retorna el primero como Optional
    default Optional<Horario> findByCanchaIdAndDia(Long canchaId, String dia) {
        List<Horario> horarios = findByCanchaIdAndDiaSemana(canchaId, dia);
        return horarios.isEmpty() ? Optional.empty() : Optional.of(horarios.get(0));
    }

    List<Horario> findByDisponible(boolean disponible);

    default List<Horario> findDisponibles() {
        return findByDisponible(true);
    }

    default List<Horario> findByDiaSemana(String diaSemana) {
        return findAll().stream()
                .filter(h -> h.getDiaSemana().equals(diaSemana))
                .collect(java.util.stream.Collectors.toList());
    }

    default boolean existsByCanchaIdAndDia(Long canchaId, String dia) {
        return !findByCanchaIdAndDiaSemana(canchaId, dia).isEmpty();
    }

    default void deleteByCanchaId(Long canchaId) {
        List<Horario> horarios = findByCanchaId(canchaId);
        deleteAll(horarios);
    }
}

