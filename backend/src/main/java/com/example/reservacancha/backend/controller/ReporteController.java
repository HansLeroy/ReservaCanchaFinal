package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.dto.ReporteGananciasDTO;
import com.example.reservacancha.backend.model.Pago;
import com.example.reservacancha.backend.service.ReporteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * Controlador REST para reportes y ganancias
 */
@RestController
@RequestMapping("/api/reportes")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class ReporteController {

    @Autowired
    private ReporteService reporteService;

    @GetMapping("/ganancias")
    public ResponseEntity<ReporteGananciasDTO> obtenerReporteGanancias(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin) {

        ReporteGananciasDTO reporte = reporteService.generarReporte(fechaInicio, fechaFin);
        return ResponseEntity.ok(reporte);
    }

    @GetMapping("/pagos")
    public ResponseEntity<List<Pago>> obtenerPagos(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin) {

        List<Pago> pagos;
        if (fechaInicio != null && fechaFin != null) {
            pagos = reporteService.obtenerPagosPorFechas(fechaInicio, fechaFin);
        } else {
            pagos = reporteService.obtenerTodosPagos();
        }
        return ResponseEntity.ok(pagos);
    }

    @GetMapping
    public ResponseEntity<String> baseEndpoint() {
        return ResponseEntity.ok("Endpoint de reportes activo");
    }
}
