package com.example.reservacancha.backend.dto;

import com.example.reservacancha.backend.model.Pago;
import java.util.List;
import java.util.Map;

/**
 * DTO para reportes de ganancias
 */
public class ReporteGananciasDTO {
    private Double totalGanancias;
    private Integer totalReservas;
    private Map<String, Double> gananciaPorTipo;
    private Map<String, Integer> reservasPorTipo;
    private Map<String, Double> gananciaPorPago;
    private List<Pago> pagos;

    public ReporteGananciasDTO() {
    }

    public ReporteGananciasDTO(Double totalGanancias, Integer totalReservas,
                               Map<String, Double> gananciaPorTipo,
                               Map<String, Integer> reservasPorTipo,
                               Map<String, Double> gananciaPorPago,
                               List<Pago> pagos) {
        this.totalGanancias = totalGanancias;
        this.totalReservas = totalReservas;
        this.gananciaPorTipo = gananciaPorTipo;
        this.reservasPorTipo = reservasPorTipo;
        this.gananciaPorPago = gananciaPorPago;
        this.pagos = pagos;
    }

    // Getters y Setters
    public Double getTotalGanancias() {
        return totalGanancias;
    }

    public void setTotalGanancias(Double totalGanancias) {
        this.totalGanancias = totalGanancias;
    }

    public Integer getTotalReservas() {
        return totalReservas;
    }

    public void setTotalReservas(Integer totalReservas) {
        this.totalReservas = totalReservas;
    }

    public Map<String, Double> getGananciaPorTipo() {
        return gananciaPorTipo;
    }

    public void setGananciaPorTipo(Map<String, Double> gananciaPorTipo) {
        this.gananciaPorTipo = gananciaPorTipo;
    }

    public Map<String, Integer> getReservasPorTipo() {
        return reservasPorTipo;
    }

    public void setReservasPorTipo(Map<String, Integer> reservasPorTipo) {
        this.reservasPorTipo = reservasPorTipo;
    }

    public Map<String, Double> getGananciaPorPago() {
        return gananciaPorPago;
    }

    public void setGananciaPorPago(Map<String, Double> gananciaPorPago) {
        this.gananciaPorPago = gananciaPorPago;
    }

    public List<Pago> getPagos() {
        return pagos;
    }

    public void setPagos(List<Pago> pagos) {
        this.pagos = pagos;
    }
}

