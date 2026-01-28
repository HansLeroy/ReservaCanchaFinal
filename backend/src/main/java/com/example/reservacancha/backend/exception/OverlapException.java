package com.example.reservacancha.backend.exception;

public class OverlapException extends RuntimeException {
    private Long conflictReservaId;
    private String conflictFechaInicio; // ISO datetime
    private String conflictFechaFin;    // ISO datetime

    public OverlapException(Long conflictReservaId, String conflictFechaInicio, String conflictFechaFin, String message) {
        super(message);
        this.conflictReservaId = conflictReservaId;
        this.conflictFechaInicio = conflictFechaInicio;
        this.conflictFechaFin = conflictFechaFin;
    }

    public Long getConflictReservaId() {
        return conflictReservaId;
    }

    public String getConflictFechaInicio() {
        return conflictFechaInicio;
    }

    public String getConflictFechaFin() {
        return conflictFechaFin;
    }
}
