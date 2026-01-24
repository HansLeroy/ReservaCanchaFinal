import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { ReservaService } from '../services/reserva.service';

@Component({
  selector: 'app-checkin',
  templateUrl: './checkin.component.html',
  styleUrls: ['./checkin.component.css']
})
export class CheckinComponent implements OnInit {
  @Output() volverInicio = new EventEmitter<void>();

  // Búsqueda de cliente
  rutCliente: string = '';
  buscandoReservas: boolean = false;

  // Reservas del cliente
  reservasPendientes: any[] = [];
  reservaSeleccionada: any = null;

  // Métodos de pago
  metodoPagoSeleccionado: string = '';
  tiposPago: { valor: string, nombre: string, icono: string }[] = [
    { valor: 'efectivo', nombre: 'Efectivo', icono: '💵' },
    { valor: 'transferencia', nombre: 'Transferencia Bancaria', icono: '🏦' },
    { valor: 'debito', nombre: 'Tarjeta de Débito', icono: '💳' },
    { valor: 'credito', nombre: 'Tarjeta de Crédito', icono: '💳' },
    { valor: 'webpay', nombre: 'Webpay', icono: '🛒' }
  ];

  // Control UI
  mostrandoPago: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';
  isLoading: boolean = false;

  constructor(private reservaService: ReservaService) { }

  ngOnInit(): void {
  }

  buscarReservas(): void {
    if (!this.rutCliente || this.rutCliente.length < 9) {
      this.errorMessage = 'Ingresa un RUT válido';
      return;
    }

    this.buscandoReservas = true;
    this.errorMessage = '';
    this.reservasPendientes = [];

    this.reservaService.getReservasPorRut(this.rutCliente).subscribe({
      next: (reservas) => {
        this.buscandoReservas = false;

        const ahora = new Date();

        // Filtrar solo reservas pendientes de pago para hoy
        this.reservasPendientes = reservas.filter((r: any) => {
          const fechaReserva = new Date(r.fechaHoraInicio);
          const esMismaFecha = fechaReserva.toDateString() === ahora.toDateString();
          const esPendiente = r.estado === 'PENDIENTE_PAGO' && !r.pagoCompletado;

          return esMismaFecha && esPendiente;
        });

        if (this.reservasPendientes.length === 0) {
          this.errorMessage = 'No hay reservas pendientes de pago para hoy con este RUT';
        }
      },
      error: (error) => {
        this.buscandoReservas = false;
        this.errorMessage = 'Error al buscar reservas. Intenta nuevamente.';
        console.error('Error:', error);
      }
    });
  }

  seleccionarReserva(reserva: any): void {
    this.reservaSeleccionada = reserva;
    this.mostrandoPago = true;
    this.metodoPagoSeleccionado = '';
  }

  volverALista(): void {
    this.reservaSeleccionada = null;
    this.mostrandoPago = false;
    this.metodoPagoSeleccionado = '';
  }

  confirmarCheckIn(): void {
    if (!this.metodoPagoSeleccionado) {
      this.errorMessage = 'Selecciona un método de pago';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    const datosCheckIn: Partial<any> = {
      reservaId: this.reservaSeleccionada.reservaId || this.reservaSeleccionada.id,
      metodoPagoCheckin: this.metodoPagoSeleccionado,
      montoPagado: this.reservaSeleccionada.montoTotal,
      pagoCompletado: true,
      checkInRealizado: true,
      estado: 'CONFIRMADA'
    };

    // Aquí llamarías a un endpoint específico para check-in
    // Por ahora actualizamos la reserva
    const id = this.reservaSeleccionada.reservaId || this.reservaSeleccionada.id;
    this.reservaService.actualizarReserva(id, datosCheckIn as any).subscribe({
      next: (response) => {
        this.isLoading = false;
        this.successMessage = `✓ Check-In realizado exitosamente. Pago confirmado: $${this.reservaSeleccionada.montoTotal.toLocaleString('es-CL')} CLP`;

        // Limpiar y volver
        setTimeout(() => {
          this.limpiar();
        }, 3000);
      },
      error: (error) => {
        this.isLoading = false;
        this.errorMessage = 'Error al realizar el check-in. Intenta nuevamente.';
        console.error('Error:', error);
      }
    });
  }

  limpiar(): void {
    this.rutCliente = '';
    this.reservasPendientes = [];
    this.reservaSeleccionada = null;
    this.mostrandoPago = false;
    this.metodoPagoSeleccionado = '';
    this.errorMessage = '';
    this.successMessage = '';
  }

  formatearFecha(fecha: string): string {
    const date = new Date(fecha);
    return date.toLocaleDateString('es-CL');
  }

  formatearHora(fecha: string): string {
    const date = new Date(fecha);
    return date.toLocaleTimeString('es-CL', { hour: '2-digit', minute: '2-digit' });
  }
}

