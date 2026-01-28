import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { CanchaService } from '../services/cancha.service';
import { ReservaService } from '../services/reserva.service';
import { ClienteService } from '../services/cliente.service';
import { Cancha, Reserva } from '../models/models';

@Component({
  selector: 'app-reserva',
  templateUrl: './reserva.component.html',
  styleUrls: ['./reserva.component.css']
})
export class ReservaComponent implements OnInit {
  @Output() volverInicio = new EventEmitter<void>();

  // Datos del cliente
  nombreCliente: string = '';
  apellidoCliente: string = '';
  emailCliente: string = '';
  telefonoCliente: string = '';
  rutCliente: string = '';

  // Datos de la reserva
  canchas: Cancha[] = [];
  canchaSeleccionada: Cancha | null = null;
  canchaSeleccionadaId: number | string = ''; // Para vincular con el select
  fechaReserva: string = '';
  horaInicio: string = '';
  horaFin: string = '';
  precioTotal: number = 0;
  tipoPago: string = '';

  // Control de UI
  mostrarFormulario: boolean = true;
  errorMessage: string = '';
  successMessage: string = '';
  isLoading: boolean = false;
  buscandoCliente: boolean = false;
  clienteEncontrado: boolean = false;
  mensajeBusqueda: string = '';
  reservasHoy: any[] = [];
  mostrarAlertaReservas: boolean = false;

  // Disponibilidad inmediata
  mostrarDisponibilidadInmediata: boolean = false;
  canchasDisponiblesAhora: any[] = [];
  horaActual: string = '';
  cargandoDisponibilidad: boolean = false;

  // Horarios disponibles (08:00 a 23:00) — generados cada 15 minutos
  horariosDisponibles: string[] = [];

  // Tipos de pago disponibles
  tiposPago: { valor: string, nombre: string, icono: string }[] = [
    { valor: 'efectivo', nombre: 'Efectivo', icono: '💵' },
    { valor: 'transferencia', nombre: 'Transferencia Bancaria', icono: '🏦' },
    { valor: 'debito', nombre: 'Tarjeta de Débito', icono: '💳' },
    { valor: 'credito', nombre: 'Tarjeta de Crédito', icono: '💳' },
    { valor: 'webpay', nombre: 'Webpay', icono: '🛒' }
  ];

  constructor(
    private canchaService: CanchaService,
    private reservaService: ReservaService,
    private clienteService: ClienteService
  ) { }

  ngOnInit(): void {
    this.cargarCanchas();
    this.setFechaMinima();
    this.actualizarHoraActual();
    this.generarHorariosDisponibles();
  }

  generarHorariosDisponibles(): void {
    const inicio = 8; // 08:00
    const fin = 23;   // 23:00
    const pasosMinutos = 15;
    const slots: string[] = [];

    for (let h = inicio; h <= fin; h++) {
      for (let m = 0; m < 60; m += pasosMinutos) {
        // Evitar incluir 23:15, 23:30, 23:45 — máximo 23:00
        if (h === fin && m > 0) continue;
        const hh = String(h).padStart(2, '0');
        const mm = String(m).padStart(2, '0');
        slots.push(`${hh}:${mm}`);
      }
    }

    this.horariosDisponibles = slots;
  }

  actualizarHoraActual(): void {
    const ahora = new Date();
    this.horaActual = ahora.toLocaleTimeString('es-CL', { hour: '2-digit', minute: '2-digit' });
  }

  verDisponibilidadInmediata(): void {
    this.mostrarDisponibilidadInmediata = !this.mostrarDisponibilidadInmediata;

    if (this.mostrarDisponibilidadInmediata) {
      this.verificarDisponibilidadAhora();
    }
  }

  verificarDisponibilidadAhora(): void {
    this.cargandoDisponibilidad = true;
    this.actualizarHoraActual();

    // Si no hay canchas en el sistema
    if (this.canchas.length === 0) {
      console.log('No hay canchas registradas en el sistema');
      this.canchasDisponiblesAhora = [];
      this.cargandoDisponibilidad = false;
      return;
    }

    // Obtener todas las reservas
    this.reservaService.getReservas().subscribe({
      next: (reservas) => {
        const ahora = new Date();
        const fechaHoy = ahora.toISOString().split('T')[0];

        // Filtrar reservas de hoy
        const reservasHoy = reservas.filter(r => {
          const fechaReserva = r.fechaHoraInicio.split('T')[0];
          return fechaReserva === fechaHoy && r.estado === 'CONFIRMADA';
        });

        console.log(`Reservas de hoy: ${reservasHoy.length}`);

        // Verificar disponibilidad de cada cancha
        this.canchasDisponiblesAhora = this.canchas.map(cancha => {
          // Buscar si la cancha está ocupada ahora
          const ocupadaAhora = reservasHoy.find(r => {
            if (r.canchaId !== cancha.id) return false;

            const inicio = new Date(r.fechaHoraInicio);
            const fin = new Date(r.fechaHoraFin);
            return ahora >= inicio && ahora <= fin;
          });

          // Buscar próxima reserva
          const proximasReservas = reservasHoy
            .filter(r => r.canchaId === cancha.id && new Date(r.fechaHoraInicio) > ahora)
            .sort((a, b) => new Date(a.fechaHoraInicio).getTime() - new Date(b.fechaHoraInicio).getTime());

          const proximaReserva = proximasReservas[0];

          const disponible = !ocupadaAhora;
          console.log(`Cancha ${cancha.nombre}: ${disponible ? 'DISPONIBLE' : 'OCUPADA'}`);

          return {
            ...cancha,
            disponibleAhora: disponible,
            ocupadaHasta: ocupadaAhora ? this.formatearHora(ocupadaAhora.fechaHoraFin) : null,
            proximaReserva: proximaReserva ? {
              horaInicio: this.formatearHora(proximaReserva.fechaHoraInicio),
              horaFin: this.formatearHora(proximaReserva.fechaHoraFin),
              cliente: proximaReserva.nombreCliente
            } : null
          };
        });

        const disponibles = this.canchasDisponiblesAhora.filter(c => c.disponibleAhora).length;
        console.log(`Total canchas disponibles: ${disponibles} de ${this.canchas.length}`);

        this.cargandoDisponibilidad = false;
      },
      error: (error) => {
        console.error('Error al verificar disponibilidad:', error);
        // Si hay error, mostrar todas las canchas como disponibles
        this.canchasDisponiblesAhora = this.canchas.map(cancha => ({
          ...cancha,
          disponibleAhora: true,
          ocupadaHasta: null,
          proximaReserva: null
        }));
        this.cargandoDisponibilidad = false;
      }
    });
  }


  seleccionarCanchaDisponible(cancha: any): void {
    console.log('🎯 Cancha seleccionada:', cancha);

    // 1. Seleccionar la cancha
    this.canchaSeleccionada = cancha;

    // 2. Establecer el ID de la cancha para el select
    this.canchaSeleccionadaId = cancha.id;
    console.log('🆔 ID de cancha establecido:', this.canchaSeleccionadaId);

    // 3. Cerrar el panel de disponibilidad
    this.mostrarDisponibilidadInmediata = false;

    // 4. Auto-rellenar FECHA (hoy o mañana si es muy tarde)
    const ahora = new Date();
    let fechaReserva = new Date();

    // Si son más de las 22:00, reservar para mañana
    if (ahora.getHours() >= 22) {
      fechaReserva.setDate(fechaReserva.getDate() + 1);
      // Hora de inicio: 08:00 (primera hora del día)
      this.horaInicio = '08:00';
      // Hora fin: 09:00
      this.horaFin = '09:00';
      console.log('⏰ Horario tardío detectado. Reservando para mañana a las 08:00');
    } else {
      // Hora actual redondeada al siguiente cuarto de hora
      const minutos = Math.ceil(ahora.getMinutes() / 15) * 15;
      const horaInicio = new Date(ahora);
      horaInicio.setMinutes(minutos);
      horaInicio.setSeconds(0);

      // Si al redondear pasamos a la siguiente hora y es >= 22, usar mañana
      if (horaInicio.getHours() >= 22) {
        fechaReserva.setDate(fechaReserva.getDate() + 1);
        this.horaInicio = '08:00';
        this.horaFin = '09:00';
        console.log('⏰ Hora redondeada >= 22:00. Reservando para mañana a las 08:00');
      } else {
        this.horaInicio = horaInicio.toTimeString().slice(0, 5);

        // Hora fin: 1 hora después
        const horaFinDate = new Date(horaInicio.getTime() + 60 * 60 * 1000);

        // Si la hora fin pasa de las 23:00, ajustar a 23:00
        if (horaFinDate.getHours() >= 23) {
          this.horaFin = '23:00';
          console.log('⏰ Hora fin ajustada a 23:00 (límite del día)');
        } else {
          this.horaFin = horaFinDate.toTimeString().slice(0, 5);
        }
      }
    }

    // Establecer la fecha en formato YYYY-MM-DD
    const year = fechaReserva.getFullYear();
    const month = String(fechaReserva.getMonth() + 1).padStart(2, '0');
    const day = String(fechaReserva.getDate()).padStart(2, '0');
    this.fechaReserva = `${year}-${month}-${day}`;

    console.log('📅 Fecha establecida:', this.fechaReserva);
    console.log('⏰ Hora inicio:', this.horaInicio);
    console.log('⏰ Hora fin:', this.horaFin);

    // 7. Calcular precio automáticamente
    this.calcularPrecio();
    console.log('💰 Precio calculado:', this.precioTotal);

    // 8. Asegurarse de que el formulario esté visible
    this.mostrarFormulario = true;

    // 9. Scroll suave al inicio del formulario
    setTimeout(() => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }, 100);

    console.log('✅ Auto-relleno completado. Cancha:', cancha.nombre, 'Fecha:', this.fechaReserva, 'Horario:', this.horaInicio, '-', this.horaFin);
  }

  cargarCanchas(): void {
    this.canchaService.getCanchasDisponibles().subscribe({
      next: (canchas) => {
        this.canchas = canchas;
      },
      error: (error) => {
        console.error('Error al cargar canchas:', error);
        this.errorMessage = 'Error al cargar las canchas disponibles';
      }
    });
  }

  setFechaMinima(): void {
    const hoy = new Date();
    const year = hoy.getFullYear();
    const month = String(hoy.getMonth() + 1).padStart(2, '0');
    const day = String(hoy.getDate()).padStart(2, '0');
    this.fechaReserva = `${year}-${month}-${day}`;
  }

  onCanchaChangeById(canchaId: any): void {
    console.log('🔄 Cancha cambiada por ID:', canchaId);
    if (canchaId && canchaId !== '') {
      const id = Number(canchaId);
      this.canchaSeleccionada = this.canchas.find(c => c.id === id) || null;
      console.log('✅ Cancha encontrada:', this.canchaSeleccionada);
      this.calcularPrecio();
    } else {
      this.canchaSeleccionada = null;
      this.precioTotal = 0;
    }
  }

  // Mantener compatibilidad con el método anterior
  onCanchaChange(event: any): void {
    const canchaId = Number(event.target.value);
    this.canchaSeleccionadaId = canchaId;
    this.onCanchaChangeById(canchaId);
  }

  onRutChange(): void {
    // Limpiar mensajes previos
    this.mensajeBusqueda = '';
    this.clienteEncontrado = false;

    // Validar formato básico de RUT
    if (this.rutCliente.length >= 9 && this.validarRut(this.rutCliente)) {
      this.buscarClientePorRut();
    }
  }

  buscarClientePorRut(): void {
    this.buscandoCliente = true;
    this.mensajeBusqueda = 'Buscando cliente...';
    this.reservasHoy = [];
    this.mostrarAlertaReservas = false;

    this.clienteService.buscarClientePorRut(this.rutCliente).subscribe({
      next: (cliente) => {
        this.buscandoCliente = false;

        if (cliente && cliente.nombre) {
          // Cliente encontrado - autocompletar datos
          this.nombreCliente = cliente.nombre;
          this.apellidoCliente = cliente.apellido;
          this.emailCliente = cliente.email;
          this.telefonoCliente = cliente.telefono;

          this.clienteEncontrado = true;
          this.mensajeBusqueda = '✓ Cliente encontrado - Datos cargados automáticamente';

          // Buscar reservas futuras del cliente
          this.buscarReservasFuturas();
        } else {
          // Cliente no encontrado
          this.mensajeBusqueda = 'Cliente nuevo - Completa los datos';
          this.clienteEncontrado = false;
        }
      },
      error: (error) => {
        this.buscandoCliente = false;
        console.log('Cliente no encontrado, es un cliente nuevo');
        this.mensajeBusqueda = 'Cliente nuevo - Completa los datos';
        this.clienteEncontrado = false;
      }
    });
  }

  buscarReservasFuturas(): void {
    this.reservaService.getReservasPorRut(this.rutCliente).subscribe({
      next: (reservas) => {
        const ahora = new Date();

        // Filtrar solo las reservas futuras que estén confirmadas
        this.reservasHoy = reservas.filter(r => {
          const fechaReserva = new Date(r.fechaHoraInicio);
          return fechaReserva >= ahora && r.estado === 'CONFIRMADA';
        }).sort((a, b) => {
          // Ordenar por fecha más cercana primero
          return new Date(a.fechaHoraInicio).getTime() - new Date(b.fechaHoraInicio).getTime();
        });

        if (this.reservasHoy.length > 0) {
          this.mostrarAlertaReservas = true;
        }
      },
      error: (error) => {
        console.log('No se encontraron reservas futuras');
      }
    });
  }

  cancelarReservaExistente(reservaId: number): void {
    if (confirm('¿Está seguro de cancelar esta reserva?')) {
      this.reservaService.cancelarReserva(reservaId).subscribe({
        next: () => {
          this.successMessage = '✅ Reserva cancelada exitosamente';
          this.buscarReservasFuturas(); // Actualizar la lista
          setTimeout(() => {
            this.successMessage = '';
            this.mostrarAlertaReservas = false;
            this.reservasHoy = [];
          }, 3000);
        },
        error: (error) => {
          this.errorMessage = 'Error al cancelar la reserva';
          console.error(error);
        }
      });
    }
  }

  continuarConNuevaReserva(): void {
    this.mostrarAlertaReservas = false;
  }

  formatearHora(fechaHora: string): string {
    const fecha = new Date(fechaHora);
    return fecha.toLocaleTimeString('es-CL', { hour: '2-digit', minute: '2-digit' });
  }

  formatearFechaCompleta(fechaHora: string): string {
    const fecha = new Date(fechaHora);
    const hoy = new Date();
    const manana = new Date(hoy);
    manana.setDate(hoy.getDate() + 1);

    // Normalizar fechas para comparación (sin hora)
    const fechaSinHora = new Date(fecha.getFullYear(), fecha.getMonth(), fecha.getDate());
    const hoySinHora = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
    const mananaSinHora = new Date(manana.getFullYear(), manana.getMonth(), manana.getDate());

    if (fechaSinHora.getTime() === hoySinHora.getTime()) {
      return '🔴 HOY';
    } else if (fechaSinHora.getTime() === mananaSinHora.getTime()) {
      return '🟡 MAÑANA';
    } else {
      return fecha.toLocaleDateString('es-CL', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
  }

  esDiaEspecial(fechaHora: string): string {
    const fecha = new Date(fechaHora);
    const hoy = new Date();
    const manana = new Date(hoy);
    manana.setDate(hoy.getDate() + 1);

    const fechaSinHora = new Date(fecha.getFullYear(), fecha.getMonth(), fecha.getDate());
    const hoySinHora = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
    const mananaSinHora = new Date(manana.getFullYear(), manana.getMonth(), manana.getDate());

    if (fechaSinHora.getTime() === hoySinHora.getTime()) {
      return 'hoy';
    } else if (fechaSinHora.getTime() === mananaSinHora.getTime()) {
      return 'manana';
    }
    return '';
  }

  onHoraInicioChange(): void {
    if (this.horaInicio) {
      // Validar y corregir la hora si está fuera de rango
      this.validarHoraInicio();

      // Establecer hora fin automáticamente (1 hora después)
      const [hora, minuto] = this.horaInicio.split(':');
      const horaNum = parseInt(hora);
      let horaFinNum = horaNum + 1;

      // Asegurar que la hora fin no exceda las 23:00
      if (horaFinNum > 23) {
        horaFinNum = 23;
      }

      this.horaFin = `${String(horaFinNum).padStart(2, '0')}:${minuto}`;
      this.calcularPrecio();
    }
  }
  

  validarHoraInicio(): void {
    if (!this.horaInicio) return;
    const [hora, minuto] = this.horaInicio.split(':').map(Number);

    // Si la hora es menor a 8, forzar a 08:00
    if (hora < 8) {
      this.horaInicio = '08:00';
      this.errorMessage = 'La hora de inicio debe ser desde las 08:00. Se ajustó automáticamente.';
      setTimeout(() => this.errorMessage = '', 3000);
      return;
    }

    // No permitir iniciar después de las 22:00 (para que la reserva no exceda 23:00)
    if (hora > 22 || (hora === 22 && minuto > 0)) {
      this.horaInicio = '22:00';
      this.errorMessage = 'La hora de inicio no puede ser después de las 22:00. Se ajustó automáticamente.';
      setTimeout(() => this.errorMessage = '', 3000);
      return;
    }

    // Si el valor no está dentro de los slots disponibles, intentar normalizar al siguiente slot disponible
    if (!this.horariosDisponibles.includes(this.horaInicio)) {
      // Buscar el primer slot mayor o igual
      const slot = this.horariosDisponibles.find(s => s >= this.horaInicio);
      if (slot) this.horaInicio = slot;
    }
  }

  validarHoraFin(): void {
    if (!this.horaFin) return;
    const [hora, minuto] = this.horaFin.split(':').map(Number);

    // Si la hora es menor a 8, forzar a 09:00
    if (hora < 8) {
      this.horaFin = '09:00';
      this.errorMessage = 'La hora de fin debe ser desde las 09:00. Se ajustó automáticamente.';
      setTimeout(() => this.errorMessage = '', 3000);
      return;
    }

    // No permitir hora fin después de 23:00
    if (hora > 23 || (hora === 23 && minuto > 0)) {
      this.horaFin = '23:00';
      this.errorMessage = 'La hora de fin no puede ser después de las 23:00. Se ajustó automáticamente.';
      setTimeout(() => this.errorMessage = '', 3000);
      return;
    }

    // Si el valor no está dentro de los slots disponibles, normalizar al slot anterior disponible
    if (!this.horariosDisponibles.includes(this.horaFin)) {
      // Buscar el último slot menor o igual
      const slotsMenores = this.horariosDisponibles.filter(s => s <= this.horaFin);
      if (slotsMenores.length > 0) this.horaFin = slotsMenores[slotsMenores.length - 1];
    }

    // Validar que hora fin sea posterior a hora inicio; si no, ajustar sumando 1 hora a inicio
    if (this.horaInicio && this.horaFin <= this.horaInicio) {
      const [hIni, mIni] = this.horaInicio.split(':').map(Number);
      const fechaTmp = new Date();
      fechaTmp.setHours(hIni + 1, mIni, 0, 0);
      const hh = String(fechaTmp.getHours()).padStart(2, '0');
      const mm = String(fechaTmp.getMinutes()).padStart(2, '0');
      this.horaFin = `${hh}:${mm}`;
      this.errorMessage = 'La hora de fin debe ser posterior a la hora de inicio. Se ajustó automáticamente.';
      setTimeout(() => this.errorMessage = '', 3000);
    }
  }

  calcularPrecio(): void {
    if (this.canchaSeleccionada && this.horaInicio && this.horaFin) {
      const [horaIni, minIni] = this.horaInicio.split(':').map(Number);
      const [horaFin, minFin] = this.horaFin.split(':').map(Number);

      const minutosInicio = horaIni * 60 + minIni;
      const minutosFin = horaFin * 60 + minFin;
      const duracionHoras = (minutosFin - minutosInicio) / 60;

      this.precioTotal = this.canchaSeleccionada.precioPorHora * duracionHoras;
    }
  }

  validarFormulario(): boolean {
    console.log('=== VALIDANDO FORMULARIO ===');
    this.errorMessage = '';

    console.log('Nombre:', this.nombreCliente);
    console.log('Apellido:', this.apellidoCliente);
    console.log('Email:', this.emailCliente);
    console.log('Teléfono:', this.telefonoCliente);
    console.log('RUT:', this.rutCliente);

    if (!this.nombreCliente || !this.apellidoCliente || !this.emailCliente ||
        !this.telefonoCliente || !this.rutCliente) {
      this.errorMessage = 'Por favor, completa todos los datos del cliente';
      console.log('❌ Faltan datos del cliente');
      return false;
    }

    console.log('Validando email...');
    if (!this.validarEmail(this.emailCliente)) {
      this.errorMessage = 'Por favor, ingresa un email válido';
      console.log('❌ Email inválido');
      return false;
    }
    console.log('✓ Email válido');

    console.log('Validando RUT...');
    if (!this.validarRut(this.rutCliente)) {
      this.errorMessage = 'Por favor, ingresa un RUT válido (formato: 12345678-9)';
      console.log('❌ RUT inválido');
      return false;
    }
    console.log('✓ RUT válido');

    console.log('Validando cancha...');
    console.log('Cancha seleccionada:', this.canchaSeleccionada);
    if (!this.canchaSeleccionada) {
      this.errorMessage = 'Por favor, selecciona una cancha';
      console.log('❌ No hay cancha seleccionada');
      return false;
    }
    console.log('✓ Cancha seleccionada:', this.canchaSeleccionada.nombre);

    console.log('Validando fecha y horario...');
    console.log('Fecha:', this.fechaReserva);
    console.log('Hora inicio:', this.horaInicio);
    console.log('Hora fin:', this.horaFin);

    if (!this.fechaReserva || !this.horaInicio || !this.horaFin) {
      this.errorMessage = 'Por favor, completa la fecha y horario';
      console.log('❌ Faltan fecha u horario');
      return false;
    }
    console.log('✓ Fecha y horario presentes');

    // Validar que las horas estén en el rango permitido (08:00 a 23:00)
    console.log('Validando horario permitido (08:00 - 23:00)...');
    const [horaIni] = this.horaInicio.split(':').map(Number);
    const [horaFin] = this.horaFin.split(':').map(Number);

    if (horaIni < 8 || horaIni >= 23) {
      this.errorMessage = 'La hora de inicio debe estar entre las 08:00 y las 22:00';
      console.log('❌ Hora inicio fuera de rango');
      // Corregir automáticamente
      this.horaInicio = horaIni < 8 ? '08:00' : '22:00';
      return false;
    }

    if (horaFin < 8 || horaFin > 23) {
      this.errorMessage = 'La hora de fin debe estar entre las 08:00 y las 23:00';
      console.log('❌ Hora fin fuera de rango');
      // Corregir automáticamente
      this.horaFin = horaFin < 8 ? '09:00' : '23:00';
      return false;
    }
    console.log('✓ Horarios dentro del rango permitido');

    console.log('Comparando horas...');
    console.log('Hora fin <= Hora inicio?', this.horaFin, '<=', this.horaInicio);
    if (this.horaFin <= this.horaInicio) {
      this.errorMessage = 'La hora de fin debe ser posterior a la hora de inicio';
      console.log('❌ Hora fin no es posterior a hora inicio');
      return false;
    }
    console.log('✓ Hora fin es posterior a hora inicio');

    console.log('Validando tipo de pago...');
    console.log('Tipo pago:', this.tipoPago);
    if (!this.tipoPago) {
      this.errorMessage = 'Por favor, selecciona un método de pago';
      console.log('❌ No hay tipo de pago');
      return false;
    }
    console.log('✓ Tipo de pago seleccionado');

    console.log('✓✓✓ FORMULARIO VÁLIDO ✓✓✓');
    return true;
  }

  validarEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  validarRut(rut: string): boolean {
    const rutRegex = /^\d{7,8}-[\dkK]$/;
    return rutRegex.test(rut);
  }

  onSubmit(): void {
    console.log('=== SUBMIT INICIADO ===');
    console.log('Validando formulario...');

    if (!this.validarFormulario()) {
      console.log('❌ Validación falló:', this.errorMessage);
      return;
    }

    console.log('✓ Validación exitosa');

    this.isLoading = true;
    this.errorMessage = '';

    // Convertir fecha y hora al formato LocalDateTime que espera el backend
    const fechaHoraInicio = `${this.fechaReserva}T${this.horaInicio}:00`;
    const fechaHoraFin = `${this.fechaReserva}T${this.horaFin}:00`;

    console.log('=== CREAR RESERVA - DEBUG ===');
    console.log('CanchaId:', this.canchaSeleccionada?.id);
    console.log('Cliente:', this.nombreCliente, this.apellidoCliente);
    console.log('RUT:', this.rutCliente);
    console.log('Fecha Inicio:', fechaHoraInicio);
    console.log('Fecha Fin:', fechaHoraFin);
    console.log('Monto:', this.precioTotal);
    console.log('Tipo Pago:', this.tipoPago);
    console.log('Estado: CONFIRMADA');

    // Determinar el estado según el tipo de pago
    const esPagoPendiente = this.tipoPago === 'por_pagar';
    const estadoReserva = esPagoPendiente ? 'PENDIENTE_PAGO' : 'CONFIRMADA';

    // Crear objeto con los nombres de campos que espera el backend
    const reservaData = {
      canchaId: this.canchaSeleccionada!.id,
      nombreCliente: this.nombreCliente,
      apellidoCliente: this.apellidoCliente,
      emailCliente: this.emailCliente,
      telefonoCliente: this.telefonoCliente,
      rutCliente: this.rutCliente,
      fechaHoraInicio: fechaHoraInicio,
      fechaHoraFin: fechaHoraFin,
      montoTotal: this.precioTotal,
      tipoPago: this.tipoPago,
      estado: estadoReserva,
      pagoCompletado: !esPagoPendiente,
      checkInRealizado: false
    };

    console.log('Datos a enviar:', JSON.stringify(reservaData, null, 2));

    this.reservaService.crearReserva(reservaData as any).subscribe({
      next: (_response) => {
        console.log('✓✓✓ RESERVA CREADA EXITOSAMENTE ✓✓✓');
        console.log('Respuesta del servidor:', _response);
        this.isLoading = false;

        if (this.tipoPago === 'por_pagar') {
          this.successMessage = `¡Reserva registrada! El cliente debe realizar el pago al llegar (Check-In). Total: $${this.precioTotal.toLocaleString('es-CL')} CLP`;
        } else {
          this.successMessage = `¡Reserva creada exitosamente! Total pagado: $${this.precioTotal.toLocaleString('es-CL')} CLP`;
        }

        this.mostrarFormulario = false;

        // Mostrar resumen
        setTimeout(() => {
          this.limpiarFormulario();
        }, 5000);
      },
      error: (error) => {
        this.isLoading = false;
        console.error('❌ ERROR AL CREAR RESERVA:', error);
        console.error('Status:', error.status);
        console.error('Error completo:', JSON.stringify(error, null, 2));

        if (error.status === 0) {
          this.errorMessage = 'No se puede conectar con el servidor. Verifica que el backend esté corriendo.';
        } else {
          this.errorMessage = error.error?.message || 'Error al crear la reserva. Intenta nuevamente.';
        }
      }
    });
  }

  limpiarFormulario(): void {
    this.nombreCliente = '';
    this.apellidoCliente = '';
    this.emailCliente = '';
    this.telefonoCliente = '';
    this.rutCliente = '';
    this.canchaSeleccionada = null;
    this.horaInicio = '';
    this.horaFin = '';
    this.precioTotal = 0;
    this.tipoPago = '';
    this.errorMessage = '';
    this.successMessage = '';
    this.mostrarFormulario = true;
    this.buscandoCliente = false;
    this.clienteEncontrado = false;
    this.mensajeBusqueda = '';
    this.setFechaMinima();
  }

  nuevaReserva(): void {
    this.limpiarFormulario();
  }

  obtenerNombrePago(valor: string): string {
    const pago = this.tiposPago.find(p => p.valor === valor);
    return pago ? `${pago.icono} ${pago.nombre}` : valor;
  }

  obtenerCanchasDisponibles(): number {
    return this.canchasDisponiblesAhora.filter(c => c.disponibleAhora).length;
  }
}

