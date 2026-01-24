package com.example.reservacancha.backend.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

/**
 * Entidad que representa una reserva de cancha
 */
@Entity
@Table(name = "reserva")
public class Reserva {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "reserva_id")
    private Long reservaId;

    @Column(name = "cliente_id", length = 12)
    private String clienteId; // RUT del Cliente (nullable)

    @NotNull
    @Column(name = "cancha_id", nullable = false)
    private Long canchaId;

    // Campos denormalizados para consultas rápidas
    @NotBlank
    @Size(max = 100)
    @Column(name = "nombre_cliente", nullable = false, length = 100)
    private String nombreCliente;

    @NotBlank
    @Size(max = 100)
    @Column(name = "apellido_cliente", nullable = false, length = 100)
    private String apellidoCliente;

    @NotBlank
    @Size(max = 255)
    @Column(name = "email_cliente", nullable = false, length = 255)
    private String emailCliente;

    @NotBlank
    @Size(max = 15)
    @Column(name = "telefono_cliente", nullable = false, length = 15)
    private String telefonoCliente;

    @NotBlank
    @Size(max = 12)
    @Column(name = "rut_cliente", nullable = false, length = 12)
    private String rutCliente;

    @NotNull
    @Column(name = "fecha_hora_inicio", nullable = false)
    private LocalDateTime fechaHoraInicio;

    @NotNull
    @Column(name = "fecha_hora_fin", nullable = false)
    private LocalDateTime fechaHoraFin;

    @Column(name = "monto_total", nullable = false, precision = 10, scale = 2)
    private Double montoTotal;

    @NotBlank
    @Size(max = 50)
    @Column(name = "tipo_pago", nullable = false, length = 50)
    private String tipoPago; // efectivo, transferencia, debito, credito, webpay

    @NotBlank
    @Size(max = 20)
    @Column(nullable = false, length = 20)
    private String estado; // PENDIENTE_PAGO, CONFIRMADA, EN_USO, FINALIZADA, CANCELADA

    // Campos para sistema de check-in y pago pendiente
    @Column(name = "pago_completado", nullable = false)
    private Boolean pagoCompletado = false;

    @Column(name = "fecha_pago")
    private LocalDateTime fechaPago;

    @Column(name = "check_in_realizado", nullable = false)
    private Boolean checkInRealizado = false;

    @Column(name = "fecha_check_in")
    private LocalDateTime fechaCheckIn;

    @Size(max = 50)
    @Column(name = "metodo_pago_checkin", length = 50)
    private String metodoPagoCheckin;

    @Column(name = "monto_pagado", precision = 10, scale = 2)
    private Double montoPagado;


    public Reserva() {
    }

    public Reserva(Long reservaId, Long canchaId, String nombreCliente, String emailCliente,
                   String telefonoCliente, LocalDateTime fechaHoraInicio,
                   LocalDateTime fechaHoraFin, Double montoTotal, String estado) {
        this.reservaId = reservaId;
        this.canchaId = canchaId;
        this.nombreCliente = nombreCliente;
        this.emailCliente = emailCliente;
        this.telefonoCliente = telefonoCliente;
        this.fechaHoraInicio = fechaHoraInicio;
        this.fechaHoraFin = fechaHoraFin;
        this.montoTotal = montoTotal;
        this.estado = estado;
    }

    // Getters y Setters
    public Long getReservaId() {
        return reservaId;
    }

    public void setReservaId(Long reservaId) {
        this.reservaId = reservaId;
    }

    // Alias para compatibilidad
    public Long getId() {
        return reservaId;
    }

    public void setId(Long id) {
        this.reservaId = id;
    }

    public String getClienteId() {
        return clienteId;
    }

    public void setClienteId(String clienteId) {
        this.clienteId = clienteId;
    }

    public Long getCanchaId() {
        return canchaId;
    }

    public void setCanchaId(Long canchaId) {
        this.canchaId = canchaId;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getApellidoCliente() {
        return apellidoCliente;
    }

    public void setApellidoCliente(String apellidoCliente) {
        this.apellidoCliente = apellidoCliente;
    }

    public String getEmailCliente() {
        return emailCliente;
    }

    public void setEmailCliente(String emailCliente) {
        this.emailCliente = emailCliente;
    }

    public String getTelefonoCliente() {
        return telefonoCliente;
    }

    public void setTelefonoCliente(String telefonoCliente) {
        this.telefonoCliente = telefonoCliente;
    }

    public String getRutCliente() {
        return rutCliente;
    }

    public void setRutCliente(String rutCliente) {
        this.rutCliente = rutCliente;
    }

    public LocalDateTime getFechaHoraInicio() {
        return fechaHoraInicio;
    }

    public void setFechaHoraInicio(LocalDateTime fechaHoraInicio) {
        this.fechaHoraInicio = fechaHoraInicio;
    }

    public LocalDateTime getFechaHoraFin() {
        return fechaHoraFin;
    }

    public void setFechaHoraFin(LocalDateTime fechaHoraFin) {
        this.fechaHoraFin = fechaHoraFin;
    }

    public Double getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(Double montoTotal) {
        this.montoTotal = montoTotal;
    }

    public String getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(String tipoPago) {
        this.tipoPago = tipoPago;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Boolean getPagoCompletado() {
        return pagoCompletado;
    }

    public void setPagoCompletado(Boolean pagoCompletado) {
        this.pagoCompletado = pagoCompletado;
    }

    public LocalDateTime getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(LocalDateTime fechaPago) {
        this.fechaPago = fechaPago;
    }

    public Boolean getCheckInRealizado() {
        return checkInRealizado;
    }

    public void setCheckInRealizado(Boolean checkInRealizado) {
        this.checkInRealizado = checkInRealizado;
    }

    public LocalDateTime getFechaCheckIn() {
        return fechaCheckIn;
    }

    public void setFechaCheckIn(LocalDateTime fechaCheckIn) {
        this.fechaCheckIn = fechaCheckIn;
    }

    public String getMetodoPagoCheckin() {
        return metodoPagoCheckin;
    }

    public void setMetodoPagoCheckin(String metodoPagoCheckin) {
        this.metodoPagoCheckin = metodoPagoCheckin;
    }

    public Double getMontoPagado() {
        return montoPagado;
    }

    public void setMontoPagado(Double montoPagado) {
        this.montoPagado = montoPagado;
    }
}

