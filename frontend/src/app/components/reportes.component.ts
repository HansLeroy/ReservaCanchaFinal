import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { ReporteService } from '../services/reporte.service';
import { Pago, ReporteGanancias } from '../models/models';
import * as XLSX from 'xlsx';

@Component({
  selector: 'app-reportes',
  templateUrl: './reportes.component.html',
  styleUrls: ['./reportes.component.css']
})
export class ReportesComponent implements OnInit {
  @Output() volverInicio = new EventEmitter<void>();
  @Output() irAReservas = new EventEmitter<void>();

  // Filtros de fecha
  fechaInicio: string = '';
  fechaFin: string = '';

  // Datos del reporte
  reporte: ReporteGanancias | null = null;
  pagos: Pago[] = [];

  // Control de UI
  cargando: boolean = false;
  errorMessage: string = '';
  mostrandoReporte: boolean = false;

  // Tipos de cancha para el gráfico
  tiposCanchaArray: { tipo: string, ganancia: number, reservas: number }[] = [];

  constructor(private reporteService: ReporteService) { }

  ngOnInit(): void {
    this.setFechasDefault();
  }

  setFechasDefault(): void {
    const hoy = new Date();
    const primerDiaMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1);

    this.fechaInicio = this.formatDate(primerDiaMes);
    this.fechaFin = this.formatDate(hoy);
  }

  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  generarReporte(): void {
    if (!this.fechaInicio || !this.fechaFin) {
      this.errorMessage = 'Por favor selecciona ambas fechas';
      return;
    }

    if (this.fechaInicio > this.fechaFin) {
      this.errorMessage = 'La fecha de inicio no puede ser mayor a la fecha de fin';
      return;
    }

    this.errorMessage = '';
    this.cargando = true;

    this.reporteService.obtenerReportePorFechas(this.fechaInicio, this.fechaFin).subscribe({
      next: (reporte) => {
        this.reporte = reporte;
        this.pagos = reporte.pagos;
        this.procesarDatosGrafico();
        this.mostrandoReporte = true;
        this.cargando = false;
      },
      error: (error) => {
        console.error('Error al obtener reporte:', error);
        this.errorMessage = 'Error al generar el reporte';
        this.cargando = false;
      }
    });
  }

  procesarDatosGrafico(): void {
    if (!this.reporte) return;

    this.tiposCanchaArray = Object.keys(this.reporte.gananciaPorTipo).map(tipo => ({
      tipo: tipo,
      ganancia: this.reporte!.gananciaPorTipo[tipo],
      reservas: this.reporte!.reservasPorTipo[tipo] || 0
    }));
  }

  limpiarFiltros(): void {
    this.setFechasDefault();
    this.mostrandoReporte = false;
    this.reporte = null;
    this.pagos = [];
    this.errorMessage = '';
  }

  obtenerPorcentaje(ganancia: number): number {
    if (!this.reporte || this.reporte.totalGanancias === 0) return 0;
    return (ganancia / this.reporte.totalGanancias) * 100;
  }

  getColorTipo(tipo: string): string {
    const colores: { [key: string]: string } = {
      'Futbol': '#4CAF50',
      'Padel': '#FF9800',
      'Basquetbol': '#F44336',
      'Tenis': '#2196F3'
    };
    return colores[tipo] || '#9E9E9E';
  }

  exportarExcel(): void {
    if (!this.reporte || this.pagos.length === 0) {
      alert('No hay datos para exportar');
      return;
    }

    // Crear libro de trabajo
    const workbook = XLSX.utils.book_new();

    // Hoja 1: Resumen General
    const resumenData = [
      ['REPORTE DE GANANCIAS'],
      ['Período:', `${this.fechaInicio} al ${this.fechaFin}`],
      ['Fecha de generación:', new Date().toLocaleDateString('es-CL')],
      [],
      ['RESUMEN GENERAL'],
      ['Total Ganancias:', `$${this.reporte.totalGanancias.toLocaleString('es-CL')}`],
      ['Total Reservas:', this.reporte.totalReservas],
      ['Promedio por Reserva:', `$${(this.reporte.totalGanancias / this.reporte.totalReservas || 0).toFixed(0)}`],
      [],
      ['GANANCIAS POR TIPO DE CANCHA'],
      ['Tipo', 'Cantidad Reservas', 'Ganancia', 'Porcentaje']
    ];

    // Agregar datos por tipo de cancha
    this.tiposCanchaArray.forEach(item => {
      resumenData.push([
        item.tipo,
        item.reservas,
        `$${item.ganancia.toLocaleString('es-CL')}`,
        `${this.obtenerPorcentaje(item.ganancia).toFixed(1)}%`
      ]);
    });

    // Agregar ganancias por método de pago
    if (this.reporte.gananciaPorPago) {
      resumenData.push([]);
      resumenData.push(['GANANCIAS POR MÉTODO DE PAGO']);
      resumenData.push(['Método', 'Ganancia']);

      Object.keys(this.reporte.gananciaPorPago).forEach(metodo => {
        resumenData.push([
          metodo.charAt(0).toUpperCase() + metodo.slice(1),
          `$${this.reporte!.gananciaPorPago[metodo].toLocaleString('es-CL')}`
        ]);
      });
    }

    const resumenSheet = XLSX.utils.aoa_to_sheet(resumenData);
    XLSX.utils.book_append_sheet(workbook, resumenSheet, 'Resumen');

    // Hoja 2: Detalle de Pagos
    const pagosData = this.pagos.map(pago => ({
      'Fecha': pago.fecha,
      'Cliente': pago.nombreCliente,
      'RUT': pago.rutCliente,
      'Cancha': pago.nombreCancha,
      'Tipo Cancha': pago.tipoCancha,
      'Hora Inicio': pago.horaInicio,
      'Hora Fin': pago.horaFin,
      'Metodo Pago': pago.tipoPago,
      'Monto': pago.monto
    }));

    const pagosSheet = XLSX.utils.json_to_sheet(pagosData);

    // Ajustar ancho de columnas
    const columnWidths = [
      { wch: 12 }, // Fecha
      { wch: 25 }, // Cliente
      { wch: 12 }, // RUT
      { wch: 20 }, // Cancha
      { wch: 15 }, // Tipo Cancha
      { wch: 10 }, // Hora Inicio
      { wch: 10 }, // Hora Fin
      { wch: 15 }, // Método Pago
      { wch: 12 }  // Monto
    ];
    pagosSheet['!cols'] = columnWidths;

    XLSX.utils.book_append_sheet(workbook, pagosSheet, 'Detalle de Pagos');

    // Generar nombre de archivo
    const nombreArchivo = `Reporte_Ganancias_${this.fechaInicio}_al_${this.fechaFin}.xlsx`;

    // Exportar archivo
    XLSX.writeFile(workbook, nombreArchivo);
  }

  imprimirReporte(): void {
    window.print();
  }
}

