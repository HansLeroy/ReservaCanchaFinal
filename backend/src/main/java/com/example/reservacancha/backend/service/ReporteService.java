package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.dto.ReporteGananciasDTO;
import com.example.reservacancha.backend.model.Pago;
import com.example.reservacancha.backend.repository.PagoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servicio para generar reportes de ganancias
 */
@Service
public class ReporteService {

    @Autowired
    private PagoRepository pagoRepository;

    public ReporteGananciasDTO generarReporte(LocalDate fechaInicio, LocalDate fechaFin) {
        List<Pago> pagos = pagoRepository.findByFechaRange(fechaInicio, fechaFin);

        Double totalGanancias = 0.0;
        Map<String, Double> gananciaPorTipo = new HashMap<>();
        Map<String, Integer> reservasPorTipo = new HashMap<>();
        Map<String, Double> gananciaPorPago = new HashMap<>();

        for (Pago pago : pagos) {
            // Total ganancias
            totalGanancias += pago.getMonto();

            // Ganancias por tipo de cancha
            String tipo = pago.getTipoCancha();
            gananciaPorTipo.put(tipo, gananciaPorTipo.getOrDefault(tipo, 0.0) + pago.getMonto());
            reservasPorTipo.put(tipo, reservasPorTipo.getOrDefault(tipo, 0) + 1);

            // Ganancias por tipo de pago
            String tipoPago = pago.getTipoPago();
            gananciaPorPago.put(tipoPago, gananciaPorPago.getOrDefault(tipoPago, 0.0) + pago.getMonto());
        }

        return new ReporteGananciasDTO(
                totalGanancias,
                pagos.size(),
                gananciaPorTipo,
                reservasPorTipo,
                gananciaPorPago,
                pagos
        );
    }

    public List<Pago> obtenerTodosPagos() {
        return pagoRepository.findAll();
    }

    public List<Pago> obtenerPagosPorFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        return pagoRepository.findByFechaRange(fechaInicio, fechaFin);
    }
}

