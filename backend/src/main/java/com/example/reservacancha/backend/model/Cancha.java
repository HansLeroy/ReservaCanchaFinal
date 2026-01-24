package com.example.reservacancha.backend.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;

/**
 * Entidad que representa una cancha deportiva
 */
@Entity
@Table(name = "cancha")
public class Cancha {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cancha_id")
    private Long canchaId;

    @NotBlank
    @Size(max = 100)
    @Column(nullable = false, length = 100)
    private String nombre;

    @NotBlank
    @Size(max = 50)
    @Column(nullable = false, length = 50)
    private String tipo; // Futbol, Tenis, Basquetbol, etc.

    @Lob
    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Positive
    @Column(name = "precio_por_hora", nullable = false, precision = 10, scale = 2)
    private Double precioPorHora;

    @Column(nullable = false)
    private boolean disponible = true;

    public Cancha() {
    }

    public Cancha(Long canchaId, String nombre, String tipo, String descripcion, Double precioPorHora, boolean disponible) {
        this.canchaId = canchaId;
        this.nombre = nombre;
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.precioPorHora = precioPorHora;
        this.disponible = disponible;
    }

    // Getters y Setters

    public Long getCanchaId() {
        return canchaId;
    }

    public void setCanchaId(Long canchaId) {
        this.canchaId = canchaId;
    }

    // Alias para compatibilidad
    public Long getId() {
        return canchaId;
    }

    public void setId(Long id) {
        this.canchaId = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Double getPrecioPorHora() {
        return precioPorHora;
    }

    public void setPrecioPorHora(Double precioPorHora) {
        this.precioPorHora = precioPorHora;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }
}



