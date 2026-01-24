package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Cancha;
import com.example.reservacancha.backend.service.CanchaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Controlador REST para gestionar las canchas deportivas
 */
@RestController
@RequestMapping("/api/canchas")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class CanchaController {

    @Autowired
    private CanchaService canchaService;

    @GetMapping
    public ResponseEntity<List<Cancha>> obtenerTodasLasCanchas() {
        List<Cancha> canchas = canchaService.obtenerTodasLasCanchas();
        return ResponseEntity.ok(canchas);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cancha> obtenerCanchaPorId(@PathVariable Long id) {
        Optional<Cancha> cancha = canchaService.obtenerCanchaPorId(id);
        return cancha.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/disponibles")
    public ResponseEntity<List<Cancha>> obtenerCanchasDisponibles() {
        List<Cancha> canchas = canchaService.obtenerCanchasDisponibles();
        return ResponseEntity.ok(canchas);
    }

    @PostMapping
    public ResponseEntity<Cancha> crearCancha(@RequestBody Cancha cancha) {
        Cancha nuevaCancha = canchaService.crearCancha(cancha);
        return ResponseEntity.status(HttpStatus.CREATED).body(nuevaCancha);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Cancha> actualizarCancha(@PathVariable Long id, @RequestBody Cancha cancha) {
        Cancha canchaActualizada = canchaService.actualizarCancha(id, cancha);
        if (canchaActualizada != null) {
            return ResponseEntity.ok(canchaActualizada);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarCancha(@PathVariable Long id) {
        boolean eliminada = canchaService.eliminarCancha(id);
        if (eliminada) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{id}/disponibilidad")
    public ResponseEntity<Void> cambiarDisponibilidad(@PathVariable Long id, @RequestParam boolean disponible) {
        boolean actualizada = canchaService.cambiarDisponibilidad(id, disponible);
        if (actualizada) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}

