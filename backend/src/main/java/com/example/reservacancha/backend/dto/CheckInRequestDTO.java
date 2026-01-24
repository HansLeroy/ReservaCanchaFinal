package com.example.reservacancha.backend.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;

/**
 * DTO para realizar check-in de una reserva
 */
public class CheckInRequestDTO {

    @NotBlank(message = "El RUT del cliente es obligatorio")
    @Size(max = 12, message = "El RUT no puede tener más de 12 caracteres")
    private String rutCliente;

    @NotBlank(message = "El método de pago es obligatorio")
    @Size(max = 50, message = "El método de pago no puede tener más de 50 caracteres")
    private String metodoPago; // efectivo, tarjeta_debito, tarjeta_credito, transferencia

    @NotNull(message = "El monto pagado es obligatorio")
    @Positive(message = "El monto debe ser positivo")
    private Double montoPagado;

    // Constructores
    public CheckInRequestDTO() {
    }

    public CheckInRequestDTO(String rutCliente, String metodoPago, Double montoPagado) {
        this.rutCliente = rutCliente;
        this.metodoPago = metodoPago;
        this.montoPagado = montoPagado;
    }

    // Getters y Setters
    public String getRutCliente() {
        return rutCliente;
    }

    public void setRutCliente(String rutCliente) {
        this.rutCliente = rutCliente;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public Double getMontoPagado() {
        return montoPagado;
    }

    public void setMontoPagado(Double montoPagado) {
        this.montoPagado = montoPagado;
    }
}

