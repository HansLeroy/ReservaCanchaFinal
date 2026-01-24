package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.dto.CheckInRequestDTO;
import com.example.reservacancha.backend.dto.ReservaPendienteDTO;
import com.example.reservacancha.backend.model.Cancha;
import com.example.reservacancha.backend.model.Reserva;
import com.example.reservacancha.backend.repository.CanchaRepository;
import com.example.reservacancha.backend.repository.ReservaRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servicio para gestionar el check-in de reservas y pagos pendientes
 */
@Service
public class CheckInService {

    private static final Logger logger = LoggerFactory.getLogger(CheckInService.class);

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private CanchaRepository canchaRepository;

    /**
     * Buscar reservas pendientes de pago por RUT del cliente
     */
    public List<ReservaPendienteDTO> buscarReservasPendientesPorRut(String rutCliente) {
        logger.info("🔍 Buscando reservas pendientes para RUT: {}", rutCliente);

        LocalDateTime ahora = LocalDateTime.now();
        List<Reserva> reservas = reservaRepository.findReservasPendientesPorRut(rutCliente, ahora);

        logger.info("✅ Se encontraron {} reservas pendientes", reservas.size());

        return reservas.stream()
                .map(this::convertirAReservaPendienteDTO)
                .collect(Collectors.toList());
    }

    /**
     * Realizar check-in de una reserva con pago pendiente
     */
    @Transactional
    public ReservaPendienteDTO realizarCheckIn(Long reservaId, CheckInRequestDTO checkInRequest) {
        logger.info("🎫 Iniciando check-in para reserva ID: {}", reservaId);

        // 1. Buscar la reserva
        Reserva reserva = reservaRepository.findById(reservaId)
                .orElseThrow(() -> new RuntimeException("Reserva no encontrada con ID: " + reservaId));

        // 2. Validar que el RUT coincida
        if (!reserva.getRutCliente().equals(checkInRequest.getRutCliente())) {
            throw new RuntimeException("El RUT proporcionado no coincide con la reserva");
        }

        // 3. Validar que la reserva esté pendiente de pago
        if (reserva.getPagoCompletado()) {
            throw new RuntimeException("Esta reserva ya tiene el pago completado");
        }

        // 4. Validar que no haya hecho check-in ya
        if (reserva.getCheckInRealizado()) {
            throw new RuntimeException("Ya se realizó check-in para esta reserva");
        }

        // 5. Validar el monto pagado
        if (!checkInRequest.getMontoPagado().equals(reserva.getMontoTotal())) {
            logger.warn("⚠️ Monto pagado {} diferente del monto total {}",
                       checkInRequest.getMontoPagado(), reserva.getMontoTotal());
        }

        // 6. Actualizar la reserva con el pago y check-in
        LocalDateTime ahora = LocalDateTime.now();
        reserva.setPagoCompletado(true);
        reserva.setFechaPago(ahora);
        reserva.setCheckInRealizado(true);
        reserva.setFechaCheckIn(ahora);
        reserva.setMetodoPagoCheckin(checkInRequest.getMetodoPago());
        reserva.setMontoPagado(checkInRequest.getMontoPagado());
        reserva.setEstado("EN_USO");

        // 7. Marcar la cancha como no disponible temporalmente
        Cancha cancha = canchaRepository.findById(reserva.getCanchaId())
                .orElseThrow(() -> new RuntimeException("Cancha no encontrada"));

        // Nota: La cancha se marca como no disponible solo durante el horario de la reserva
        // Esto se puede gestionar con un job programado que revise las reservas activas

        // 8. Guardar cambios
        Reserva reservaActualizada = reservaRepository.save(reserva);

        logger.info("✅ Check-in completado para reserva ID: {}", reservaId);
        logger.info("💰 Pago de ${} recibido vía {}", checkInRequest.getMontoPagado(),
                   checkInRequest.getMetodoPago());
        logger.info("🏟️ Cancha {} asignada al cliente {}", cancha.getNombre(),
                   reserva.getNombreCliente());

        return convertirAReservaPendienteDTO(reservaActualizada);
    }

    /**
     * Listar todas las reservas con pago pendiente
     */
    public List<ReservaPendienteDTO> listarReservasPendientesPago() {
        logger.info("📋 Listando todas las reservas con pago pendiente");

        List<Reserva> reservas = reservaRepository.findByPagoCompletadoFalseAndEstado("PENDIENTE_PAGO");

        logger.info("✅ Se encontraron {} reservas pendientes de pago", reservas.size());

        return reservas.stream()
                .map(this::convertirAReservaPendienteDTO)
                .collect(Collectors.toList());
    }

    /**
     * Listar reservas confirmadas sin check-in
     */
    public List<ReservaPendienteDTO> listarReservasConfirmadasSinCheckIn() {
        logger.info("📋 Listando reservas confirmadas sin check-in");

        LocalDateTime ahora = LocalDateTime.now();
        List<Reserva> reservas = reservaRepository.findReservasConfirmadasSinCheckIn(ahora);

        logger.info("✅ Se encontraron {} reservas confirmadas sin check-in", reservas.size());

        return reservas.stream()
                .map(this::convertirAReservaPendienteDTO)
                .collect(Collectors.toList());
    }

    /**
     * Cancelar una reserva con pago pendiente
     */
    @Transactional
    public void cancelarReservaPendiente(Long reservaId, String rutCliente) {
        logger.info("❌ Cancelando reserva ID: {} para RUT: {}", reservaId, rutCliente);

        Reserva reserva = reservaRepository.findById(reservaId)
                .orElseThrow(() -> new RuntimeException("Reserva no encontrada con ID: " + reservaId));

        // Validar que el RUT coincida
        if (!reserva.getRutCliente().equals(rutCliente)) {
            throw new RuntimeException("El RUT proporcionado no coincide con la reserva");
        }

        // Validar que no haya pagado
        if (reserva.getPagoCompletado()) {
            throw new RuntimeException("No se puede cancelar una reserva ya pagada");
        }

        reserva.setEstado("CANCELADA");
        reservaRepository.save(reserva);

        logger.info("✅ Reserva cancelada exitosamente");
    }

    /**
     * Convertir entidad Reserva a DTO
     */
    private ReservaPendienteDTO convertirAReservaPendienteDTO(Reserva reserva) {
        ReservaPendienteDTO dto = new ReservaPendienteDTO();
        dto.setReservaId(reserva.getReservaId());
        dto.setNombreCliente(reserva.getNombreCliente());
        dto.setApellidoCliente(reserva.getApellidoCliente());
        dto.setRutCliente(reserva.getRutCliente());
        dto.setTelefonoCliente(reserva.getTelefonoCliente());
        dto.setEmailCliente(reserva.getEmailCliente());
        dto.setCanchaId(reserva.getCanchaId());

        // Obtener nombre de la cancha
        canchaRepository.findById(reserva.getCanchaId()).ifPresent(cancha ->
            dto.setNombreCancha(cancha.getNombre())
        );

        dto.setFechaHoraInicio(reserva.getFechaHoraInicio());
        dto.setFechaHoraFin(reserva.getFechaHoraFin());
        dto.setMontoTotal(reserva.getMontoTotal());
        dto.setEstado(reserva.getEstado());
        dto.setPagoCompletado(reserva.getPagoCompletado());
        dto.setCheckInRealizado(reserva.getCheckInRealizado());

        return dto;
    }
}

