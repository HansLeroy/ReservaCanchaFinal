export interface Usuario {
  id?: number;
  nombre: string;
  apellido: string;
  email: string;
  telefono: string;
  rut: string;
}

export interface Cancha {
  id?: number;
  nombre: string;
  tipo: string;
  descripcion: string;
  precioPorHora: number;
  disponible: boolean;
}

export interface Reserva {
  id: number;
  reservaId?: number;
  nombreCliente: string;
  apellidoCliente: string;
  rutCliente: string;
  emailCliente: string;
  telefonoCliente: string;
  fechaHoraInicio: string;
  fechaHoraFin: string;
  montoTotal: number;
  estado: string;
  tipoPago: string;
  canchaId: number;
  fechaFormateada?: string;
  montoFormateado?: string;
  pagoCompletado?: boolean;
  checkInRealizado?: boolean;
  fechaPago?: string;
  fechaCheckIn?: string;
  metodoPagoCheckin?: string;
  montoPagado?: number;
}

export interface Pago {
  id?: number;
  reservaId: number;
  nombreCliente: string;
  rutCliente: string;
  nombreCancha: string;
  tipoCancha: string;
  fecha: string;
  horaInicio: string;
  horaFin: string;
  monto: number;
  tipoPago: string;
  fechaPago: string;
  estado: string;
}

export interface ReporteGanancias {
  totalGanancias: number;
  totalReservas: number;
  gananciaPorTipo: { [key: string]: number };
  reservasPorTipo: { [key: string]: number };
  gananciaPorPago: { [key: string]: number };
  pagos: Pago[];
}
