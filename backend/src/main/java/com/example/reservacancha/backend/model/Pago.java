package com.example.reservacancha.backend.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;
import java.time.LocalDate;

/**
 * Entidad que representa un pago realizado
 */
@Entity
@Table(name = "pago")
public class Pago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pago_id")
    private Long pagoId;

    @NotNull
    @Column(name = "reserva_id", nullable = false, unique = true)
    private Long reservaId;

    @Size(max = 100)
    @Column(name = "nombre_cliente", length = 100)
    private String nombreCliente;

    @Size(max = 12)
    @Column(name = "rut_cliente", length = 12)
    private String rutCliente;

    @Size(max = 100)
    @Column(name = "nombre_cancha", length = 100)
    private String nombreCancha;

    @Size(max = 50)
    @Column(name = "tipo_cancha", length = 50)
    private String tipoCancha;

    @Column
    private LocalDate fecha;

    @Size(max = 10)
    @Column(name = "hora_inicio", length = 10)
    private String horaInicio;

    @Size(max = 10)
    @Column(name = "hora_fin", length = 10)
    private String horaFin;

    @Positive
    @Column(nullable = false, precision = 10, scale = 2)
    private Double monto;

    @NotBlank
    @Size(max = 50)
    @Column(name = "tipo_pago", nullable = false, length = 50)
    private String tipoPago;

    @NotNull
    @Column(name = "fecha_pago", nullable = false)
    private LocalDate fechaPago;

    @NotBlank
    @Size(max = 20)
    @Column(nullable = false, length = 20)
    private String estado;

    public Pago() {
    }

    public Pago(Long pagoId, Long reservaId, String nombreCliente, String rutCliente,
                String nombreCancha, String tipoCancha, LocalDate fecha,
                String horaInicio, String horaFin, Double monto,
                String tipoPago, LocalDate fechaPago, String estado) {
        this.pagoId = pagoId;
        this.reservaId = reservaId;
        this.nombreCliente = nombreCliente;
        this.rutCliente = rutCliente;
        this.nombreCancha = nombreCancha;
        this.tipoCancha = tipoCancha;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.monto = monto;
        this.tipoPago = tipoPago;
        this.fechaPago = fechaPago;
        this.estado = estado;
    }

    // Getters y Setters
    public Long getPagoId() {
        return pagoId;
    }

    public void setPagoId(Long pagoId) {
        this.pagoId = pagoId;
    }

    // Alias para compatibilidad
    public Long getId() {
        return pagoId;
    }

    public void setId(Long id) {
        this.pagoId = id;
    }

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

    public String getRutCliente() {
        return rutCliente;
    }

    public void setRutCliente(String rutCliente) {
        this.rutCliente = rutCliente;
    }

    public String getNombreCancha() {
        return nombreCancha;
    }

    public void setNombreCancha(String nombreCancha) {
        this.nombreCancha = nombreCancha;
    }

    public String getTipoCancha() {
        return tipoCancha;
    }

    public void setTipoCancha(String tipoCancha) {
        this.tipoCancha = tipoCancha;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(String horaFin) {
        this.horaFin = horaFin;
    }

    public Double getMonto() {
        return monto;
    }

    public void setMonto(Double monto) {
        this.monto = monto;
    }

    public String getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(String tipoPago) {
        this.tipoPago = tipoPago;
    }

    public LocalDate getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(LocalDate fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}

