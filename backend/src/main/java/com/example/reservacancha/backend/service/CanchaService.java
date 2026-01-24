package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.model.Cancha;
import com.example.reservacancha.backend.repository.CanchaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar la logica de negocio de las canchas
 */
@Service
public class CanchaService {

    @Autowired
    private CanchaRepository canchaRepository;

    public List<Cancha> obtenerTodasLasCanchas() {
        return canchaRepository.findAll();
    }

    public Optional<Cancha> obtenerCanchaPorId(Long id) {
        return canchaRepository.findById(id);
    }

    public List<Cancha> obtenerCanchasDisponibles() {
        return canchaRepository.findAll().stream()
                .filter(Cancha::isDisponible)
                .toList();
    }

    public Cancha crearCancha(Cancha cancha) {
        return canchaRepository.save(cancha);
    }

    public Cancha actualizarCancha(Long id, Cancha canchaActualizada) {
        Optional<Cancha> canchaExistente = canchaRepository.findById(id);
        if (canchaExistente.isPresent()) {
            canchaActualizada.setId(id);
            return canchaRepository.save(canchaActualizada);
        }
        return null;
    }

    public boolean eliminarCancha(Long id) {
        Optional<Cancha> cancha = canchaRepository.findById(id);
        if (cancha.isPresent()) {
            canchaRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public boolean cambiarDisponibilidad(Long id, boolean disponible) {
        Optional<Cancha> canchaOpt = canchaRepository.findById(id);
        if (canchaOpt.isPresent()) {
            Cancha cancha = canchaOpt.get();
            cancha.setDisponible(disponible);
            canchaRepository.save(cancha);
            return true;
        }
        return false;
    }
}

