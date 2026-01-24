package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Horario;
import com.example.reservacancha.backend.service.HorarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controlador REST para gestionar los horarios de las canchas
 */
@RestController
@RequestMapping("/api/horarios")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class HorarioController {

    @Autowired
    private HorarioService horarioService;

    @GetMapping
    public ResponseEntity<List<Horario>> obtenerTodosLosHorarios() {
        List<Horario> horarios = horarioService.obtenerTodosLosHorarios();
        return ResponseEntity.ok(horarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Horario> obtenerHorarioPorId(@PathVariable Long id) {
        Optional<Horario> horario = horarioService.obtenerHorarioPorId(id);
        return horario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/cancha/{canchaId}")
    public ResponseEntity<List<Horario>> obtenerHorariosPorCancha(@PathVariable Long canchaId) {
        List<Horario> horarios = horarioService.obtenerHorariosPorCancha(canchaId);
        return ResponseEntity.ok(horarios);
    }

    @GetMapping("/cancha/{canchaId}/dia/{diaSemana}")
    public ResponseEntity<Horario> obtenerHorarioPorCanchaYDia(
            @PathVariable Long canchaId,
            @PathVariable String diaSemana) {
        Optional<Horario> horario = horarioService.obtenerHorarioPorCanchaYDia(canchaId, diaSemana);
        return horario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/dia/{diaSemana}")
    public ResponseEntity<List<Horario>> obtenerHorariosPorDia(@PathVariable String diaSemana) {
        List<Horario> horarios = horarioService.obtenerHorariosPorDia(diaSemana);
        return ResponseEntity.ok(horarios);
    }

    @GetMapping("/disponibles")
    public ResponseEntity<List<Horario>> obtenerHorariosDisponibles() {
        List<Horario> horarios = horarioService.obtenerHorariosDisponibles();
        return ResponseEntity.ok(horarios);
    }

    @PostMapping
    public ResponseEntity<?> crearHorario(@RequestBody Horario horario) {
        try {
            Horario nuevoHorario = horarioService.crearHorario(horario);
            return ResponseEntity.status(HttpStatus.CREATED).body(nuevoHorario);
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> actualizarHorario(@PathVariable Long id, @RequestBody Horario horario) {
        try {
            Horario horarioActualizado = horarioService.actualizarHorario(id, horario);
            if (horarioActualizado != null) {
                return ResponseEntity.ok(horarioActualizado);
            }
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarHorario(@PathVariable Long id) {
        boolean eliminado = horarioService.eliminarHorario(id);
        if (eliminado) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/cancha/{canchaId}")
    public ResponseEntity<Void> eliminarHorariosPorCancha(@PathVariable Long canchaId) {
        horarioService.eliminarHorariosPorCancha(canchaId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/cancha/{canchaId}/fecha/{fecha}")
    public ResponseEntity<Horario> obtenerHorarioPorFecha(
            @PathVariable Long canchaId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        Optional<Horario> horario = horarioService.obtenerHorarioPorFecha(canchaId, fecha);
        return horario.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/cancha/{canchaId}/tarifa/{fecha}")
    public ResponseEntity<Map<String, Object>> obtenerTarifaPorFecha(
            @PathVariable Long canchaId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        Double tarifa = horarioService.obtenerTarifa(canchaId, fecha);

        Map<String, Object> response = new HashMap<>();
        if (tarifa != null) {
            response.put("canchaId", canchaId);
            response.put("fecha", fecha);
            response.put("tarifaPorHora", tarifa);
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.notFound().build();
    }

    @GetMapping("/cancha/{canchaId}/abierta")
    public ResponseEntity<Map<String, Object>> verificarSiEstaAbierta(
            @PathVariable Long canchaId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime hora) {

        boolean abierta = horarioService.estaAbierta(canchaId, fecha, hora);

        Map<String, Object> response = new HashMap<>();
        response.put("canchaId", canchaId);
        response.put("fecha", fecha);
        response.put("hora", hora);
        response.put("abierta", abierta);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/cancha/{canchaId}/validar-reserva")
    public ResponseEntity<Map<String, Object>> validarHorarioReserva(
            @PathVariable Long canchaId,
            @RequestBody ValidacionReservaRequest request) {

        boolean valido = horarioService.validarHorarioReserva(
            canchaId, request.getFecha(), request.getHoraInicio(), request.getHoraFin());

        Map<String, Object> response = new HashMap<>();
        response.put("valido", valido);

        if (!valido) {
            response.put("mensaje", "La reserva está fuera del horario de operación de la cancha");
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/cancha/{canchaId}/crear-estandar")
    public ResponseEntity<Map<String, String>> crearHorariosEstandar(
            @PathVariable Long canchaId,
            @RequestParam Double tarifaBase) {

        horarioService.crearHorariosEstandar(canchaId, tarifaBase);

        Map<String, String> response = new HashMap<>();
        response.put("mensaje", "Horarios estándar creados exitosamente para la cancha " + canchaId);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // Clase interna para la validación de reserva
    public static class ValidacionReservaRequest {
        private LocalDate fecha;
        private LocalTime horaInicio;
        private LocalTime horaFin;

        public LocalDate getFecha() {
            return fecha;
        }

        public void setFecha(LocalDate fecha) {
            this.fecha = fecha;
        }

        public LocalTime getHoraInicio() {
            return horaInicio;
        }

        public void setHoraInicio(LocalTime horaInicio) {
            this.horaInicio = horaInicio;
        }

        public LocalTime getHoraFin() {
            return horaFin;
        }

        public void setHoraFin(LocalTime horaFin) {
            this.horaFin = horaFin;
        }
    }
}

