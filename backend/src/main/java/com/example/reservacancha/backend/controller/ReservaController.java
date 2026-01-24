package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.dto.ClienteDTO;
import com.example.reservacancha.backend.model.Reserva;
import com.example.reservacancha.backend.service.ReservaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controlador REST para gestionar las reservas
 */
@RestController
@RequestMapping("/api/reservas")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class ReservaController {

    @Autowired
    private ReservaService reservaService;

    @GetMapping
    public ResponseEntity<List<Reserva>> obtenerTodasLasReservas() {
        List<Reserva> reservas = reservaService.obtenerTodasLasReservas();
        return ResponseEntity.ok(reservas);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Reserva> obtenerReservaPorId(@PathVariable Long id) {
        Optional<Reserva> reserva = reservaService.obtenerReservaPorId(id);
        return reserva.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/cancha/{canchaId}")
    public ResponseEntity<List<Reserva>> obtenerReservasPorCancha(@PathVariable Long canchaId) {
        List<Reserva> reservas = reservaService.obtenerReservasPorCancha(canchaId);
        return ResponseEntity.ok(reservas);
    }

    @PostMapping
    public ResponseEntity<?> crearReserva(@Valid @RequestBody Reserva reserva, BindingResult bindingResult) {
        try {
            // Verificar errores de validación
            if (bindingResult.hasErrors()) {
                Map<String, String> errores = new HashMap<>();
                for (FieldError error : bindingResult.getFieldErrors()) {
                    errores.put(error.getField(), error.getDefaultMessage());
                }
                System.out.println("✗ ERRORES DE VALIDACIÓN:");
                errores.forEach((campo, mensaje) -> System.out.println("  - " + campo + ": " + mensaje));
                return ResponseEntity.badRequest().body(errores);
            }

            System.out.println("=== CREAR RESERVA - DEBUG ===");
            System.out.println("CanchaId: " + reserva.getCanchaId());
            System.out.println("Cliente: " + reserva.getNombreCliente() + " " + reserva.getApellidoCliente());
            System.out.println("RUT: " + reserva.getRutCliente());
            System.out.println("Fecha Inicio: " + reserva.getFechaHoraInicio());
            System.out.println("Fecha Fin: " + reserva.getFechaHoraFin());
            System.out.println("Monto: " + reserva.getMontoTotal());
            System.out.println("Tipo Pago: " + reserva.getTipoPago());
            System.out.println("Estado: " + reserva.getEstado());

            Reserva nuevaReserva = reservaService.crearReserva(reserva);
            if (nuevaReserva != null) {
                System.out.println("✓ Reserva creada exitosamente con ID: " + nuevaReserva.getId());
                return ResponseEntity.status(HttpStatus.CREATED).body(nuevaReserva);
            }
            System.out.println("✗ El servicio retornó null - Cancha no encontrada");
            return ResponseEntity.badRequest().body("La cancha seleccionada no existe");
        } catch (Exception e) {
            System.out.println("✗ ERROR AL CREAR RESERVA: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    /**
     * Crear reserva telefónica con pago pendiente
     * POST /api/reservas/telefonica
     */
    @PostMapping("/telefonica")
    public ResponseEntity<?> crearReservaTelefonica(@Valid @RequestBody Reserva reserva, BindingResult bindingResult) {
        try {
            // Verificar errores de validación
            if (bindingResult.hasErrors()) {
                Map<String, String> errores = new HashMap<>();
                for (FieldError error : bindingResult.getFieldErrors()) {
                    errores.put(error.getField(), error.getDefaultMessage());
                }
                System.out.println("✗ ERRORES DE VALIDACIÓN:");
                errores.forEach((campo, mensaje) -> System.out.println("  - " + campo + ": " + mensaje));
                return ResponseEntity.badRequest().body(errores);
            }

            System.out.println("=== CREAR RESERVA TELEFÓNICA (PAGO PENDIENTE) ===");
            System.out.println("📞 Cliente llamó para reservar");
            System.out.println("CanchaId: " + reserva.getCanchaId());
            System.out.println("Cliente: " + reserva.getNombreCliente() + " " + reserva.getApellidoCliente());
            System.out.println("RUT: " + reserva.getRutCliente());
            System.out.println("Teléfono: " + reserva.getTelefonoCliente());
            System.out.println("Fecha Inicio: " + reserva.getFechaHoraInicio());
            System.out.println("Fecha Fin: " + reserva.getFechaHoraFin());

            Reserva nuevaReserva = reservaService.crearReservaTelefonica(reserva);
            if (nuevaReserva != null) {
                System.out.println("✓ Reserva telefónica creada con ID: " + nuevaReserva.getId());
                System.out.println("💰 Estado: PAGO PENDIENTE");
                System.out.println("💡 El cliente debe hacer check-in cuando llegue");

                Map<String, Object> response = new HashMap<>();
                response.put("mensaje", "Reserva telefónica creada exitosamente. El cliente debe presentarse y pagar al llegar.");
                response.put("reserva", nuevaReserva);
                response.put("requiereCheckIn", true);

                return ResponseEntity.status(HttpStatus.CREATED).body(response);
            }
            System.out.println("✗ El servicio retornó null - Cancha no encontrada");
            return ResponseEntity.badRequest().body("La cancha seleccionada no existe");
        } catch (Exception e) {
            System.out.println("✗ ERROR AL CREAR RESERVA TELEFÓNICA: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Reserva> actualizarReserva(@PathVariable Long id, @RequestBody Reserva reserva) {
        Reserva reservaActualizada = reservaService.actualizarReserva(id, reserva);
        if (reservaActualizada != null) {
            return ResponseEntity.ok(reservaActualizada);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarReserva(@PathVariable Long id) {
        boolean eliminada = reservaService.eliminarReserva(id);
        if (eliminada) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{id}/confirmar")
    public ResponseEntity<Void> confirmarReserva(@PathVariable Long id) {
        boolean confirmada = reservaService.confirmarReserva(id);
        if (confirmada) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{id}/cancelar")
    public ResponseEntity<Void> cancelarReserva(@PathVariable Long id) {
        boolean cancelada = reservaService.cancelarReserva(id);
        if (cancelada) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/cliente/{rut}")
    public ResponseEntity<ClienteDTO> buscarClientePorRut(@PathVariable String rut) {
        Optional<ClienteDTO> cliente = reservaService.buscarClientePorRut(rut);
        return cliente.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/cliente/rut/{rut}")
    public ResponseEntity<List<Reserva>> obtenerReservasPorRutCliente(@PathVariable String rut) {
        List<Reserva> reservas = reservaService.obtenerReservasPorRutCliente(rut);
        if (reservas.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(reservas);
    }
}

