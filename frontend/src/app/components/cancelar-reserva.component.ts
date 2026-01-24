import { Component, EventEmitter, Output } from '@angular/core';
import { ReservaService } from '../services/reserva.service';
import { Reserva } from '../models/models';

@Component({
  selector: 'app-cancelar-reserva',
  templateUrl: './cancelar-reserva.component.html',
  styleUrls: ['./cancelar-reserva.component.css']
})
export class CancelarReservaComponent {
  @Output() volverInicio = new EventEmitter<void>();

  rutCliente: string = '';
  reservas: Reserva[] = [];
  reservasPendientes: Reserva[] = [];
  buscando: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';
  clienteEncontrado: boolean = false;
  reservasFormateadas: any[] = [];

  constructor(private reservaService: ReservaService) {}

  ngOnInit() {
    this.reservasFormateadas = this.reservas.map(reserva => ({
      ...reserva,
      fechaFormateada: this.formatearFecha(reserva.fechaHoraInicio),
      montoFormateado: this.formatearMonto(reserva.montoTotal)
    }));
  }

  buscarReservas(): void {
    if (!this.rutCliente || this.rutCliente.trim() === '') {
      this.errorMessage = 'Por favor, ingresa un RUT válido';
      return;
    }

    this.buscando = true;
    this.errorMessage = '';
    this.successMessage = '';
    this.reservas = [];
    this.reservasPendientes = [];
    this.clienteEncontrado = false;

    // Llamar al servicio para buscar reservas por RUT
    this.reservaService.getReservasPorRut(this.rutCliente).subscribe({
      next: (reservas) => {
        this.buscando = false;
        this.reservas = reservas;

        // Filtrar solo reservas confirmadas (pendientes/activas)
        this.reservasPendientes = reservas.filter(r => r.estado === 'CONFIRMADA');

        if (reservas.length === 0) {
          this.errorMessage = 'No se encontraron reservas para este RUT';
        } else {
          this.clienteEncontrado = true;
          if (this.reservasPendientes.length === 0) {
            this.errorMessage = 'Este cliente no tiene reservas pendientes';
          }
        }

        // Formatear reservas para mostrar en la plantilla
        this.reservasFormateadas = reservas.map(reserva => ({
          ...reserva,
          fechaFormateada: this.formatearFecha(reserva.fechaHoraInicio),
          montoFormateado: this.formatearMonto(reserva.montoTotal)
        }));
      },
      error: (error) => {
        this.buscando = false;
        console.error('Error al buscar reservas:', error);
        this.errorMessage = 'No se encontraron reservas para este RUT o hubo un error';
      }
    });
  }

  cancelarReserva(reserva: Reserva): void {
    if (!confirm(`¿Está seguro de cancelar la reserva de ${reserva.nombreCliente} ${reserva.apellidoCliente}?\nFecha: ${this.formatearFecha(reserva.fechaHoraInicio)}\nMonto: $${this.formatearMonto(reserva.montoTotal)}`)) {
      return;
    }

    this.reservaService.cancelarReserva(reserva.id).subscribe({
      next: () => {
        this.successMessage = '✅ Reserva cancelada exitosamente';

        // Actualizar el estado de la reserva en la lista
        reserva.estado = 'CANCELADA';

        // Actualizar la lista de reservas pendientes
        this.reservasPendientes = this.reservas.filter(r => r.estado === 'CONFIRMADA');

        // Limpiar el mensaje de éxito después de 3 segundos
        setTimeout(() => {
          this.successMessage = '';
        }, 3000);
      },
      error: (error) => {
        console.error('Error al cancelar reserva:', error);
        this.errorMessage = 'Error al cancelar la reserva. Intenta nuevamente.';
      }
    });
  }

  formatearFecha(fecha: string): string {
    const date = new Date(fecha);
    const opciones: Intl.DateTimeFormatOptions = {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return date.toLocaleDateString('es-CL', opciones);
  }

  formatearMonto(monto: number): string {
    return monto.toLocaleString('es-CL');
  }

  limpiar(): void {
    this.rutCliente = '';
    this.reservas = [];
    this.reservasPendientes = [];
    this.errorMessage = '';
    this.successMessage = '';
    this.clienteEncontrado = false;
  }

  get reservasCanceladas(): Reserva[] {
    return this.reservas.filter(r => r.estado === 'CANCELADA');
  }

  get reservasPendientesFormateadas(): any[] {
    return this.reservasPendientes.map(reserva => ({
      ...reserva,
      fechaFormateada: this.formatearFecha(reserva.fechaHoraInicio),
      montoFormateado: this.formatearMonto(reserva.montoTotal)
    }));
  }

  volver(): void {
    this.volverInicio.emit();
  }
}
