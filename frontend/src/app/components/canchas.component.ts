import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { CanchaService } from '../services/cancha.service';
import { Cancha } from '../models/models';

@Component({
  selector: 'app-canchas',
  templateUrl: './canchas.component.html',
  styleUrls: ['./canchas.component.css']
})
export class CanchasComponent implements OnInit {
  @Output() volverInicio = new EventEmitter<void>();

  canchas: Cancha[] = [];
  canchasFiltradas: Cancha[] = [];

  // Filtros
  filtroDeporte: string = 'TODOS';
  filtroEstado: string = 'TODOS';
  filtroBusqueda: string = '';

  // Deportes disponibles
  deportes: string[] = ['Fútbol 5', 'Fútbol 7', 'Fútbol 11', 'Tenis', 'Pádel', 'Básquetbol', 'Volleyball'];

  // Formulario
  mostrarFormulario: boolean = false;
  modoEdicion: boolean = false;
  canchaActual: Cancha = this.nuevaCancha();

  // UI
  isLoading: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';

  // Ordenamiento
  ordenarPor: string = 'nombre';
  ordenAscendente: boolean = true;

  constructor(private canchaService: CanchaService) { }

  ngOnInit(): void {
    this.cargarCanchas();
  }

  cargarCanchas(): void {
    this.isLoading = true;
    this.canchaService.getCanchas().subscribe({
      next: (canchas) => {
        this.canchas = canchas;
        this.aplicarFiltros();
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar canchas:', error);
        this.errorMessage = 'Error al cargar las canchas';
        this.isLoading = false;
      }
    });
  }

  aplicarFiltros(): void {
    this.canchasFiltradas = this.canchas.filter(cancha => {
      // Filtro por deporte
      const pasaDeporte = this.filtroDeporte === 'TODOS' || cancha.tipo === this.filtroDeporte;

      // Filtro por estado
      let pasaEstado = true;
      if (this.filtroEstado === 'DISPONIBLES') {
        pasaEstado = cancha.disponible;
      } else if (this.filtroEstado === 'MANTENIMIENTO') {
        pasaEstado = !cancha.disponible;
      }

      // Filtro por búsqueda
      const pasaBusqueda = !this.filtroBusqueda ||
        cancha.nombre.toLowerCase().includes(this.filtroBusqueda.toLowerCase()) ||
        cancha.tipo.toLowerCase().includes(this.filtroBusqueda.toLowerCase()) ||
        cancha.descripcion?.toLowerCase().includes(this.filtroBusqueda.toLowerCase());

      return pasaDeporte && pasaEstado && pasaBusqueda;
    });

    this.ordenarCanchas();
  }

  ordenarCanchas(): void {
    this.canchasFiltradas.sort((a, b) => {
      let valorA: any;
      let valorB: any;

      switch (this.ordenarPor) {
        case 'nombre':
          valorA = a.nombre.toLowerCase();
          valorB = b.nombre.toLowerCase();
          break;
        case 'tipo':
          valorA = a.tipo.toLowerCase();
          valorB = b.tipo.toLowerCase();
          break;
        case 'precio':
          valorA = a.precioPorHora;
          valorB = b.precioPorHora;
          break;
        default:
          return 0;
      }

      if (valorA < valorB) return this.ordenAscendente ? -1 : 1;
      if (valorA > valorB) return this.ordenAscendente ? 1 : -1;
      return 0;
    });
  }

  cambiarOrden(campo: string): void {
    if (this.ordenarPor === campo) {
      this.ordenAscendente = !this.ordenAscendente;
    } else {
      this.ordenarPor = campo;
      this.ordenAscendente = true;
    }
    this.ordenarCanchas();
  }

  abrirFormularioNueva(): void {
    this.modoEdicion = false;
    this.canchaActual = this.nuevaCancha();
    this.mostrarFormulario = true;
    this.errorMessage = '';
    this.successMessage = '';
  }

  editarCancha(cancha: Cancha): void {
    this.modoEdicion = true;
    this.canchaActual = { ...cancha };
    this.mostrarFormulario = true;
    this.errorMessage = '';
    this.successMessage = '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  cancelarFormulario(): void {
    this.mostrarFormulario = false;
    this.canchaActual = this.nuevaCancha();
    this.errorMessage = '';
  }

  guardarCancha(): void {
    if (!this.validarFormulario()) {
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    if (this.modoEdicion && this.canchaActual.id) {
      // Actualizar
      this.canchaService.updateCancha(this.canchaActual.id, this.canchaActual).subscribe({
        next: () => {
          this.successMessage = '✅ Cancha actualizada exitosamente';
          this.mostrarFormulario = false;
          this.cargarCanchas();
          setTimeout(() => this.successMessage = '', 3000);
        },
        error: (error: any) => {
          console.error('Error al actualizar:', error);
          this.errorMessage = 'Error al actualizar la cancha';
          this.isLoading = false;
        }
      });
    } else {
      // Crear nueva
      this.canchaService.createCancha(this.canchaActual).subscribe({
        next: () => {
          this.successMessage = '✅ Cancha creada exitosamente';
          this.mostrarFormulario = false;
          this.cargarCanchas();
          setTimeout(() => this.successMessage = '', 3000);
        },
        error: (error: any) => {
          console.error('Error al crear:', error);
          this.errorMessage = 'Error al crear la cancha';
          this.isLoading = false;
        }
      });
    }
  }

  cambiarEstadoCancha(cancha: Cancha): void {
    const nuevoEstado = !cancha.disponible;
    const mensaje = nuevoEstado ? 'activar' : 'desactivar';

    if (!confirm(`¿Está seguro de ${mensaje} la cancha "${cancha.nombre}"?`)) {
      return;
    }

    const canchaActualizada = { ...cancha, disponible: nuevoEstado };

    this.canchaService.updateCancha(cancha.id!, canchaActualizada).subscribe({
      next: () => {
        this.successMessage = `✅ Cancha ${nuevoEstado ? 'activada' : 'desactivada'} exitosamente`;
        this.cargarCanchas();
        setTimeout(() => this.successMessage = '', 3000);
      },
      error: (error: any) => {
        console.error('Error al cambiar estado:', error);
        this.errorMessage = 'Error al cambiar el estado de la cancha';
      }
    });
  }

  eliminarCancha(cancha: Cancha): void {
    if (!confirm(`¿Está COMPLETAMENTE SEGURO de eliminar la cancha "${cancha.nombre}"?\n\nEsta acción no se puede deshacer.`)) {
      return;
    }

    this.canchaService.deleteCancha(cancha.id!).subscribe({
      next: () => {
        this.successMessage = '✅ Cancha eliminada exitosamente';
        this.cargarCanchas();
        setTimeout(() => this.successMessage = '', 3000);
      },
      error: (error: any) => {
        console.error('Error al eliminar:', error);
        this.errorMessage = 'Error al eliminar la cancha. Puede tener reservas asociadas.';
      }
    });
  }

  validarFormulario(): boolean {
    this.errorMessage = '';

    if (!this.canchaActual.nombre || this.canchaActual.nombre.trim() === '') {
      this.errorMessage = 'El nombre de la cancha es obligatorio';
      return false;
    }

    if (!this.canchaActual.tipo || this.canchaActual.tipo === '') {
      this.errorMessage = 'Debes seleccionar el tipo de deporte';
      return false;
    }

    if (!this.canchaActual.precioPorHora || this.canchaActual.precioPorHora <= 0) {
      this.errorMessage = 'El precio por hora debe ser mayor a 0';
      return false;
    }

    return true;
  }

  nuevaCancha(): Cancha {
    return {
      nombre: '',
      tipo: '',
      descripcion: '',
      precioPorHora: 0,
      disponible: true
    };
  }

  obtenerIconoDeporte(tipo: string): string {
    const iconos: {[key: string]: string} = {
      'Fútbol 5': '⚽',
      'Fútbol 7': '⚽',
      'Fútbol 11': '⚽',
      'Tenis': '🎾',
      'Pádel': '🏓',
      'Básquetbol': '🏀',
      'Volleyball': '🏐'
    };
    return iconos[tipo] || '🏟️';
  }

  obtenerEstadisticas() {
    return {
      total: this.canchas.length,
      disponibles: this.canchas.filter(c => c.disponible).length,
      mantenimiento: this.canchas.filter(c => !c.disponible).length,
      filtradas: this.canchasFiltradas.length
    };
  }

  volver(): void {
    this.volverInicio.emit();
  }
}

