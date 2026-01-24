package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.dto.CheckInRequestDTO;
import com.example.reservacancha.backend.dto.ReservaPendienteDTO;
import com.example.reservacancha.backend.service.CheckInService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controlador REST para gestionar check-in de reservas
 */
@RestController
@RequestMapping("/api/checkin")
@CrossOrigin(origins = "*")
public class CheckInController {

    private static final Logger logger = LoggerFactory.getLogger(CheckInController.class);

    @Autowired
    private CheckInService checkInService;

    /**
     * Buscar reservas pendientes de pago por RUT
     * GET /api/checkin/buscar/{rut}
     */
    @GetMapping("/buscar/{rut}")
    public ResponseEntity<?> buscarReservasPorRut(@PathVariable String rut) {
        try {
            logger.info("🔍 Buscando reservas para RUT: {}", rut);

            List<ReservaPendienteDTO> reservas = checkInService.buscarReservasPendientesPorRut(rut);

            if (reservas.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("mensaje", "No se encontraron reservas pendientes para este RUT");
                response.put("reservas", reservas);
                return ResponseEntity.ok(response);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("mensaje", "Reservas encontradas");
            response.put("cantidad", reservas.size());
            response.put("reservas", reservas);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("❌ Error al buscar reservas: {}", e.getMessage(), e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al buscar reservas: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Realizar check-in de una reserva
     * POST /api/checkin/{reservaId}
     */
    @PostMapping("/{reservaId}")
    public ResponseEntity<?> realizarCheckIn(
            @PathVariable Long reservaId,
            @Valid @RequestBody CheckInRequestDTO checkInRequest) {
        try {
            logger.info("🎫 Realizando check-in para reserva ID: {}", reservaId);
            logger.info("💰 Método de pago: {}, Monto: {}",
                       checkInRequest.getMetodoPago(), checkInRequest.getMontoPagado());

            ReservaPendienteDTO reserva = checkInService.realizarCheckIn(reservaId, checkInRequest);

            Map<String, Object> response = new HashMap<>();
            response.put("mensaje", "Check-in realizado exitosamente");
            response.put("reserva", reserva);

            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            logger.error("❌ Error en check-in: {}", e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);

        } catch (Exception e) {
            logger.error("❌ Error inesperado en check-in: {}", e.getMessage(), e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al realizar check-in: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Listar todas las reservas con pago pendiente
     * GET /api/checkin/pendientes
     */
    @GetMapping("/pendientes")
    public ResponseEntity<?> listarReservasPendientes() {
        try {
            logger.info("📋 Listando todas las reservas con pago pendiente");

            List<ReservaPendienteDTO> reservas = checkInService.listarReservasPendientesPago();

            Map<String, Object> response = new HashMap<>();
            response.put("mensaje", "Reservas pendientes de pago");
            response.put("cantidad", reservas.size());
            response.put("reservas", reservas);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("❌ Error al listar reservas pendientes: {}", e.getMessage(), e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al listar reservas: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Listar reservas confirmadas sin check-in
     * GET /api/checkin/sin-checkin
     */
    @GetMapping("/sin-checkin")
    public ResponseEntity<?> listarReservasSinCheckIn() {
        try {
            logger.info("📋 Listando reservas confirmadas sin check-in");

            List<ReservaPendienteDTO> reservas = checkInService.listarReservasConfirmadasSinCheckIn();

            Map<String, Object> response = new HashMap<>();
            response.put("mensaje", "Reservas confirmadas sin check-in");
            response.put("cantidad", reservas.size());
            response.put("reservas", reservas);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("❌ Error al listar reservas sin check-in: {}", e.getMessage(), e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al listar reservas: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Cancelar reserva con pago pendiente
     * DELETE /api/checkin/{reservaId}/cancelar
     */
    @DeleteMapping("/{reservaId}/cancelar")
    public ResponseEntity<?> cancelarReserva(
            @PathVariable Long reservaId,
            @RequestParam String rut) {
        try {
            logger.info("❌ Cancelando reserva ID: {} para RUT: {}", reservaId, rut);

            checkInService.cancelarReservaPendiente(reservaId, rut);

            Map<String, String> response = new HashMap<>();
            response.put("mensaje", "Reserva cancelada exitosamente");

            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            logger.error("❌ Error al cancelar: {}", e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);

        } catch (Exception e) {
            logger.error("❌ Error inesperado al cancelar: {}", e.getMessage(), e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al cancelar reserva: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}

