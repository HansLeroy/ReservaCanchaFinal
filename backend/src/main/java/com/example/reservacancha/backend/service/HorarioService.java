package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.model.Horario;
import com.example.reservacancha.backend.repository.HorarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar la lógica de negocio de los horarios
 */
@Service
public class HorarioService {

    @Autowired
    private HorarioRepository horarioRepository;

    public List<Horario> obtenerTodosLosHorarios() {
        return horarioRepository.findAll();
    }

    public Optional<Horario> obtenerHorarioPorId(Long id) {
        return horarioRepository.findById(id);
    }

    public List<Horario> obtenerHorariosPorCancha(Long canchaId) {
        return horarioRepository.findByCanchaId(canchaId);
    }

    public Optional<Horario> obtenerHorarioPorCanchaYDia(Long canchaId, String diaSemana) {
        return horarioRepository.findByCanchaIdAndDia(canchaId, diaSemana);
    }

    public List<Horario> obtenerHorariosPorDia(String diaSemana) {
        return horarioRepository.findByDiaSemana(diaSemana);
    }

    public List<Horario> obtenerHorariosDisponibles() {
        return horarioRepository.findDisponibles();
    }

    public Horario crearHorario(Horario horario) {
        // Validar que no exista ya un horario para esa cancha en ese día
        if (horarioRepository.existsByCanchaIdAndDia(horario.getCanchaId(), horario.getDiaSemana())) {
            throw new IllegalArgumentException(
                "Ya existe un horario para la cancha " + horario.getCanchaId() +
                " el día " + horario.getDiaSemana());
        }

        // Validar que la hora de cierre sea después de la apertura
        if (horario.getHoraCierre().isBefore(horario.getHoraApertura())) {
            throw new IllegalArgumentException("La hora de cierre debe ser posterior a la hora de apertura");
        }

        // Validar tarifa positiva
        if (horario.getTarifaPorHora() != null && horario.getTarifaPorHora() <= 0) {
            throw new IllegalArgumentException("La tarifa debe ser mayor a cero");
        }

        return horarioRepository.save(horario);
    }

    public Horario actualizarHorario(Long id, Horario horarioActualizado) {
        Optional<Horario> horarioExistente = horarioRepository.findById(id);
        if (horarioExistente.isEmpty()) {
            return null;
        }

        // Validar que la hora de cierre sea después de la apertura
        if (horarioActualizado.getHoraCierre().isBefore(horarioActualizado.getHoraApertura())) {
            throw new IllegalArgumentException("La hora de cierre debe ser posterior a la hora de apertura");
        }

        horarioActualizado.setId(id);
        return horarioRepository.save(horarioActualizado);
    }

    public boolean eliminarHorario(Long id) {
        if (horarioRepository.existsById(id)) {
            horarioRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public void eliminarHorariosPorCancha(Long canchaId) {
        horarioRepository.deleteByCanchaId(canchaId);
    }

    /**
     * Verifica si una cancha está abierta en una fecha y hora específica
     */
    public boolean estaAbierta(Long canchaId, LocalDate fecha, LocalTime hora) {
        String diaSemana = convertirDiaSemana(fecha.getDayOfWeek());
        Optional<Horario> horarioOpt = horarioRepository.findByCanchaIdAndDia(canchaId, diaSemana);

        if (horarioOpt.isEmpty()) {
            return false;
        }

        Horario horario = horarioOpt.get();

        if (!horario.getDisponible()) {
            return false;
        }

        return !hora.isBefore(horario.getHoraApertura()) && hora.isBefore(horario.getHoraCierre());
    }

    /**
     * Obtiene la tarifa de una cancha para un día específico
     */
    public Double obtenerTarifa(Long canchaId, LocalDate fecha) {
        String diaSemana = convertirDiaSemana(fecha.getDayOfWeek());
        Optional<Horario> horarioOpt = horarioRepository.findByCanchaIdAndDia(canchaId, diaSemana);

        return horarioOpt.map(Horario::getTarifaPorHora).orElse(null);
    }

    /**
     * Obtiene el horario de una cancha para una fecha específica
     */
    public Optional<Horario> obtenerHorarioPorFecha(Long canchaId, LocalDate fecha) {
        String diaSemana = convertirDiaSemana(fecha.getDayOfWeek());
        return horarioRepository.findByCanchaIdAndDia(canchaId, diaSemana);
    }

    /**
     * Crear horarios estándar para una cancha nueva (Lunes a Domingo 8:00-22:00)
     */
    public void crearHorariosEstandar(Long canchaId, Double tarifaBase) {
        String[] dias = {"LUNES", "MARTES", "MIERCOLES", "JUEVES", "VIERNES", "SABADO", "DOMINGO"};

        for (String dia : dias) {
            // No crear si ya existe
            if (!horarioRepository.existsByCanchaIdAndDia(canchaId, dia)) {
                Horario horario = new Horario();
                horario.setCanchaId(canchaId);
                horario.setDiaSemana(dia);
                horario.setHoraApertura(LocalTime.of(8, 0));
                horario.setHoraCierre(LocalTime.of(22, 0));
                horario.setTarifaPorHora(tarifaBase);
                horario.setDisponible(true);
                horarioRepository.save(horario);
            }
        }
    }

    /**
     * Convertir DayOfWeek de Java a String en español
     */
    private String convertirDiaSemana(DayOfWeek dayOfWeek) {
        switch (dayOfWeek) {
            case MONDAY: return "LUNES";
            case TUESDAY: return "MARTES";
            case WEDNESDAY: return "MIERCOLES";
            case THURSDAY: return "JUEVES";
            case FRIDAY: return "VIERNES";
            case SATURDAY: return "SABADO";
            case SUNDAY: return "DOMINGO";
            default: return "";
        }
    }

    /**
     * Validar que una reserva esté dentro del horario de operación
     */
    public boolean validarHorarioReserva(Long canchaId, LocalDate fecha, LocalTime horaInicio, LocalTime horaFin) {
        String diaSemana = convertirDiaSemana(fecha.getDayOfWeek());
        Optional<Horario> horarioOpt = horarioRepository.findByCanchaIdAndDia(canchaId, diaSemana);

        if (horarioOpt.isEmpty()) {
            return false; // No hay horario definido para ese día
        }

        Horario horario = horarioOpt.get();

        if (!horario.getDisponible()) {
            return false; // Cancha no disponible ese día
        }

        // Validar que la reserva esté dentro del horario de apertura/cierre
        return !horaInicio.isBefore(horario.getHoraApertura()) &&
               !horaFin.isAfter(horario.getHoraCierre());
    }
}

