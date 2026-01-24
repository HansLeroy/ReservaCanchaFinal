package com.example.reservacancha.backend.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.LocalTime;

/**
 * Entidad que representa los horarios de operación de una cancha
 * Define cuándo está disponible cada cancha y sus tarifas por día/hora
 */
@Entity
@Table(name = "horario")
public class Horario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "horario_id")
    private Long horarioId;

    @NotNull
    @Column(name = "cancha_id", nullable = false)
    private Long canchaId;

    @NotBlank
    @Size(max = 20)
    @Column(name = "dia_semana", nullable = false, length = 20)
    private String diaSemana; // LUNES, MARTES, MIERCOLES, JUEVES, VIERNES, SABADO, DOMINGO

    @NotNull
    @Column(name = "hora_apertura", nullable = false)
    private LocalTime horaApertura;

    @NotNull
    @Column(name = "hora_cierre", nullable = false)
    private LocalTime horaCierre;

    @Column(name = "tarifa_por_hora", precision = 10, scale = 2)
    private Double tarifaPorHora;

    @Column(nullable = false)
    private Boolean disponible = true;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String notas;

    public Horario() {
        this.disponible = true;
    }

    public Horario(Long horarioId, Long canchaId, String diaSemana, LocalTime horaApertura,
                   LocalTime horaCierre, Double tarifaPorHora, Boolean disponible) {
        this.horarioId = horarioId;
        this.canchaId = canchaId;
        this.diaSemana = diaSemana;
        this.horaApertura = horaApertura;
        this.horaCierre = horaCierre;
        this.tarifaPorHora = tarifaPorHora;
        this.disponible = disponible;
    }

    // Getters y Setters
    public Long getHorarioId() {
        return horarioId;
    }

    public void setHorarioId(Long horarioId) {
        this.horarioId = horarioId;
    }

    // Alias para compatibilidad
    public Long getId() {
        return horarioId;
    }

    public void setId(Long id) {
        this.horarioId = id;
    }

    public Long getCanchaId() {
        return canchaId;
    }

    public void setCanchaId(Long canchaId) {
        this.canchaId = canchaId;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public LocalTime getHoraApertura() {
        return horaApertura;
    }

    public void setHoraApertura(LocalTime horaApertura) {
        this.horaApertura = horaApertura;
    }

    public LocalTime getHoraCierre() {
        return horaCierre;
    }

    public void setHoraCierre(LocalTime horaCierre) {
        this.horaCierre = horaCierre;
    }

    public Double getTarifaPorHora() {
        return tarifaPorHora;
    }

    public void setTarifaPorHora(Double tarifaPorHora) {
        this.tarifaPorHora = tarifaPorHora;
    }

    public Boolean getDisponible() {
        return disponible;
    }

    public void setDisponible(Boolean disponible) {
        this.disponible = disponible;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }
}

