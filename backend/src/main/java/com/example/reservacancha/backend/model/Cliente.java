package com.example.reservacancha.backend.model;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

/**
 * Entidad que representa un cliente que reserva canchas
 * (diferente de Usuario que administra el sistema)
 */
@Entity
@Table(name = "cliente")
public class Cliente {

    @Id
    @NotBlank
    @Size(max = 12)
    @Column(nullable = false, length = 12)
    private String rut;

    @NotBlank
    @Size(max = 100)
    @Column(nullable = false, length = 100)
    private String nombre;

    @NotBlank
    @Size(max = 100)
    @Column(nullable = false, length = 100)
    private String apellido;


    @NotBlank
    @Email
    @Size(max = 255)
    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @NotBlank
    @Size(max = 15)
    @Column(nullable = false, length = 15)
    private String telefono;

    @Size(max = 255)
    @Column(length = 255)
    private String direccion;

    @Column(nullable = false)
    private Boolean activo = true;

    @Column(name = "total_reservas")
    private Integer totalReservas = 0;

    @Column(name = "total_gastado", precision = 10, scale = 2)
    private Double totalGastado = 0.0;

    public Cliente() {
        this.activo = true;
        this.totalReservas = 0;
        this.totalGastado = 0.0;
    }

    public Cliente(String rut, String nombre, String apellido, String email, String telefono) {
        this.rut = rut;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.telefono = telefono;
        this.activo = true;
        this.totalReservas = 0;
        this.totalGastado = 0.0;
    }

    // Getters y Setters
    public String getId() {
        return rut;
    }

    public void setId(String id) {
        this.rut = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getRut() {
        return rut;
    }

    public void setRut(String rut) {
        this.rut = rut;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public Integer getTotalReservas() {
        return totalReservas;
    }

    public void setTotalReservas(Integer totalReservas) {
        this.totalReservas = totalReservas;
    }

    public Double getTotalGastado() {
        return totalGastado;
    }

    public void setTotalGastado(Double totalGastado) {
        this.totalGastado = totalGastado;
    }

    public void incrementarReservas() {
        this.totalReservas++;
    }

    public void agregarGasto(Double monto) {
        this.totalGastado += monto;
    }
}

