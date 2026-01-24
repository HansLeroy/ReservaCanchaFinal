package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.dto.ClienteDTO;
import com.example.reservacancha.backend.model.Cancha;
import com.example.reservacancha.backend.model.Cliente;
import com.example.reservacancha.backend.model.Pago;
import com.example.reservacancha.backend.model.Reserva;
import com.example.reservacancha.backend.repository.CanchaRepository;
import com.example.reservacancha.backend.repository.PagoRepository;
import com.example.reservacancha.backend.repository.ReservaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar la lógica de negocio de las reservas
 */
@Service
public class ReservaService {

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private CanchaRepository canchaRepository;

    @Autowired
    private PagoRepository pagoRepository;

    @Autowired
    private ClienteService clienteService;

    public List<Reserva> obtenerTodasLasReservas() {
        return reservaRepository.findAll();
    }

    public Optional<Reserva> obtenerReservaPorId(Long id) {
        return reservaRepository.findById(id);
    }

    public List<Reserva> obtenerReservasPorCancha(Long canchaId) {
        return reservaRepository.findByCanchaId(canchaId);
    }

    public Reserva crearReserva(Reserva reserva) {
        try {
            System.out.println("=== SERVICE: Creando reserva ===");

            // Obtener o crear cliente
            System.out.println("Paso 1: Obteniendo/creando cliente...");
            Cliente cliente = clienteService.obtenerOCrearCliente(
                reserva.getNombreCliente(),
                reserva.getApellidoCliente(),
                reserva.getRutCliente(),
                reserva.getEmailCliente(),
                reserva.getTelefonoCliente()
            );
            System.out.println("✓ Cliente obtenido/creado con ID: " + cliente.getId());

            reserva.setClienteId(cliente.getId());

            // Calcular el monto total basado en las horas y el precio de la cancha
            System.out.println("Paso 2: Buscando cancha con ID: " + reserva.getCanchaId());
            Optional<Cancha> canchaOpt = canchaRepository.findById(reserva.getCanchaId());
            if (canchaOpt.isPresent()) {
                Cancha cancha = canchaOpt.get();
                System.out.println("✓ Cancha encontrada: " + cancha.getNombre());

                long horas = Duration.between(reserva.getFechaHoraInicio(), reserva.getFechaHoraFin()).toHours();
                double montoTotal = horas * cancha.getPrecioPorHora();
                reserva.setMontoTotal(montoTotal);
                reserva.setEstado("CONFIRMADA");
                System.out.println("✓ Monto calculado: " + montoTotal + " (" + horas + " horas)");

                // Guardar reserva
                System.out.println("Paso 3: Guardando reserva en BD...");
                Reserva reservaGuardada = reservaRepository.save(reserva);
                System.out.println("✓ Reserva guardada con ID: " + reservaGuardada.getId());

                // Actualizar estadísticas del cliente
                System.out.println("Paso 4: Actualizando estadísticas del cliente...");
                clienteService.registrarReserva(cliente.getId(), montoTotal);
                System.out.println("✓ Estadísticas actualizadas");

                // Crear pago automáticamente
                System.out.println("Paso 5: Creando registro de pago...");
                crearPagoDeReserva(reservaGuardada, cancha);
                System.out.println("✓ Pago registrado");

                return reservaGuardada;
            } else {
                System.out.println("✗ Cancha NO encontrada con ID: " + reserva.getCanchaId());
            }
        } catch (Exception e) {
            System.out.println("✗ EXCEPCIÓN en crearReserva: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    private void crearPagoDeReserva(Reserva reserva, Cancha cancha) {
        Pago pago = new Pago();
        pago.setReservaId(reserva.getId());
        pago.setNombreCliente(reserva.getNombreCliente() + " " + reserva.getApellidoCliente());
        pago.setRutCliente(reserva.getRutCliente());
        pago.setNombreCancha(cancha.getNombre());
        pago.setTipoCancha(cancha.getTipo());
        pago.setFecha(reserva.getFechaHoraInicio().toLocalDate());
        pago.setHoraInicio(reserva.getFechaHoraInicio().toLocalTime().toString());
        pago.setHoraFin(reserva.getFechaHoraFin().toLocalTime().toString());
        pago.setMonto(reserva.getMontoTotal());
        pago.setTipoPago(reserva.getTipoPago());
        pago.setFechaPago(LocalDate.now());
        pago.setEstado("PAGADO");

        pagoRepository.save(pago);
    }

    /**
     * Crear reserva telefónica con pago pendiente
     * El cliente llama, se toma sus datos pero no paga en ese momento
     */
    public Reserva crearReservaTelefonica(Reserva reserva) {
        try {
            System.out.println("=== SERVICE: Creando reserva telefónica (PAGO PENDIENTE) ===");

            // Obtener o crear cliente
            System.out.println("Paso 1: Obteniendo/creando cliente...");
            Cliente cliente = clienteService.obtenerOCrearCliente(
                reserva.getNombreCliente(),
                reserva.getApellidoCliente(),
                reserva.getRutCliente(),
                reserva.getEmailCliente(),
                reserva.getTelefonoCliente()
            );
            System.out.println("✓ Cliente obtenido/creado con ID: " + cliente.getId());

            reserva.setClienteId(cliente.getId());

            // Calcular el monto total
            System.out.println("Paso 2: Buscando cancha con ID: " + reserva.getCanchaId());
            Optional<Cancha> canchaOpt = canchaRepository.findById(reserva.getCanchaId());
            if (canchaOpt.isPresent()) {
                Cancha cancha = canchaOpt.get();
                System.out.println("✓ Cancha encontrada: " + cancha.getNombre());

                long horas = Duration.between(reserva.getFechaHoraInicio(), reserva.getFechaHoraFin()).toHours();
                double montoTotal = horas * cancha.getPrecioPorHora();
                reserva.setMontoTotal(montoTotal);

                // Configurar como PAGO PENDIENTE
                reserva.setEstado("PENDIENTE_PAGO");
                reserva.setPagoCompletado(false);
                reserva.setCheckInRealizado(false);

                System.out.println("✓ Monto calculado: " + montoTotal + " (" + horas + " horas)");
                System.out.println("📞 Estado: PENDIENTE_PAGO (Reserva telefónica)");

                // Guardar reserva
                System.out.println("Paso 3: Guardando reserva telefónica en BD...");
                Reserva reservaGuardada = reservaRepository.save(reserva);
                System.out.println("✓ Reserva telefónica guardada con ID: " + reservaGuardada.getId());
                System.out.println("💡 El cliente debe hacer check-in y pagar cuando llegue");

                return reservaGuardada;
            } else {
                System.out.println("✗ Cancha NO encontrada con ID: " + reserva.getCanchaId());
                throw new RuntimeException("Cancha no encontrada");
            }
        } catch (Exception e) {
            System.out.println("✗ EXCEPCIÓN en crearReservaTelefonica: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Reserva actualizarReserva(Long id, Reserva reservaActualizada) {
        Optional<Reserva> reservaExistente = reservaRepository.findById(id);
        if (reservaExistente.isPresent()) {
            reservaActualizada.setId(id);
            return reservaRepository.save(reservaActualizada);
        }
        return null;
    }

    public boolean eliminarReserva(Long id) {
        Optional<Reserva> reserva = reservaRepository.findById(id);
        if (reserva.isPresent()) {
            reservaRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public boolean confirmarReserva(Long id) {
        return cambiarEstadoReserva(id, "CONFIRMADA");
    }

    public boolean cancelarReserva(Long id) {
        return cambiarEstadoReserva(id, "CANCELADA");
    }

    private boolean cambiarEstadoReserva(Long id, String nuevoEstado) {
        Optional<Reserva> reservaOpt = reservaRepository.findById(id);
        if (reservaOpt.isPresent()) {
            Reserva reserva = reservaOpt.get();
            reserva.setEstado(nuevoEstado);
            reservaRepository.save(reserva);
            return true;
        }
        return false;
    }

    public Optional<ClienteDTO> buscarClientePorRut(String rut) {
        Optional<Reserva> ultimaReserva = reservaRepository.findUltimaReservaPorRut(rut);

        if (ultimaReserva.isPresent()) {
            Reserva reserva = ultimaReserva.get();
            ClienteDTO cliente = new ClienteDTO(
                reserva.getRutCliente(),
                reserva.getNombreCliente(),
                reserva.getApellidoCliente(),
                reserva.getEmailCliente(),
                reserva.getTelefonoCliente()
            );
            return Optional.of(cliente);
        }

        return Optional.empty();
    }

    public List<Reserva> obtenerReservasPorRutCliente(String rut) {
        return reservaRepository.findByRutCliente(rut);
    }
}

