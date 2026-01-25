package com.example.reservacancha.backend.repository;

import com.example.reservacancha.backend.model.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para gestionar las reservas
 */
@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Long> {

    List<Reserva> findByCanchaId(Long canchaId);

    List<Reserva> findByClienteId(Long clienteId);

    List<Reserva> findByEstado(String estado);

    List<Reserva> findByRutCliente(String rutCliente);

    // Buscar reservas pendientes de pago por RUT
    List<Reserva> findByRutClienteAndPagoCompletadoFalse(String rutCliente);

    // Buscar reservas con pago pendiente que estén programadas para hoy o en el futuro
    @Query("SELECT r FROM Reserva r WHERE r.rutCliente = :rutCliente " +
           "AND r.pagoCompletado = false " +
           "AND r.estado = 'PENDIENTE_PAGO' " +
           "AND r.fechaHoraInicio >= :fechaActual " +
           "ORDER BY r.fechaHoraInicio ASC")
    List<Reserva> findReservasPendientesPorRut(@Param("rutCliente") String rutCliente,
                                                @Param("fechaActual") LocalDateTime fechaActual);

    // Buscar todas las reservas con pago pendiente
    List<Reserva> findByPagoCompletadoFalseAndEstado(String estado);

    // Buscar reservas confirmadas sin check-in
    @Query("SELECT r FROM Reserva r WHERE r.pagoCompletado = true " +
           "AND r.checkInRealizado = false " +
           "AND r.estado = 'CONFIRMADA' " +
           "AND r.fechaHoraInicio >= :fechaActual " +
           "ORDER BY r.fechaHoraInicio ASC")
    List<Reserva> findReservasConfirmadasSinCheckIn(@Param("fechaActual") LocalDateTime fechaActual);

    // Método optimizado para obtener la última reserva de un cliente por su RUT
    Optional<Reserva> findFirstByRutClienteOrderByFechaHoraInicioDesc(String rutCliente);

    /*
    default Optional<Reserva> findUltimaReservaPorRut(String rut) {
        return findByRutCliente(rut).stream()
                .max(java.util.Comparator.comparing(Reserva::getFechaHoraInicio));
    }
    */
}

