package com.example.reservacancha.backend.dto;

import java.time.LocalDateTime;

/**
 * DTO de respuesta para consultar reservas pendientes de pago
 */
public class ReservaPendienteDTO {

    private Long reservaId;
    private String nombreCliente;
    private String apellidoCliente;
    private String rutCliente;
    private String telefonoCliente;
    private String emailCliente;
    private Long canchaId;
    private String nombreCancha;
    private LocalDateTime fechaHoraInicio;
    private LocalDateTime fechaHoraFin;
    private Double montoTotal;
    private String estado;
    private Boolean pagoCompletado;
    private Boolean checkInRealizado;

    // Constructores
    public ReservaPendienteDTO() {
    }

    public ReservaPendienteDTO(Long reservaId, String nombreCliente, String apellidoCliente,
                               String rutCliente, String telefonoCliente, String emailCliente,
                               Long canchaId, LocalDateTime fechaHoraInicio, LocalDateTime fechaHoraFin,
                               Double montoTotal, String estado, Boolean pagoCompletado,
                               Boolean checkInRealizado) {
        this.reservaId = reservaId;
        this.nombreCliente = nombreCliente;
        this.apellidoCliente = apellidoCliente;
        this.rutCliente = rutCliente;
        this.telefonoCliente = telefonoCliente;
        this.emailCliente = emailCliente;
        this.canchaId = canchaId;
        this.fechaHoraInicio = fechaHoraInicio;
        this.fechaHoraFin = fechaHoraFin;
        this.montoTotal = montoTotal;
        this.estado = estado;
        this.pagoCompletado = pagoCompletado;
        this.checkInRealizado = checkInRealizado;
    }

    // Getters y Setters
    public Long getReservaId() {
        return reservaId;
    }

    public void setReservaId(Long reservaId) {
        this.reservaId = reservaId;
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

    public String getRutCliente() {
        return rutCliente;
    }

    public void setRutCliente(String rutCliente) {
        this.rutCliente = rutCliente;
    }

    public String getTelefonoCliente() {
        return telefonoCliente;
    }

    public void setTelefonoCliente(String telefonoCliente) {
        this.telefonoCliente = telefonoCliente;
    }

    public String getEmailCliente() {
        return emailCliente;
    }

    public void setEmailCliente(String emailCliente) {
        this.emailCliente = emailCliente;
    }

    public Long getCanchaId() {
        return canchaId;
    }

    public void setCanchaId(Long canchaId) {
        this.canchaId = canchaId;
    }

    public String getNombreCancha() {
        return nombreCancha;
    }

    public void setNombreCancha(String nombreCancha) {
        this.nombreCancha = nombreCancha;
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

    public Boolean getCheckInRealizado() {
        return checkInRealizado;
    }

    public void setCheckInRealizado(Boolean checkInRealizado) {
        this.checkInRealizado = checkInRealizado;
    }
}

