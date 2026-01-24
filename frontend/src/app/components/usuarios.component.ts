import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { UsuarioService, Usuario, CrearUsuarioRequest } from '../services/usuario.service';

@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrls: ['./usuarios.component.css']
})
export class UsuariosComponent implements OnInit {
  @Output() volverInicio = new EventEmitter<void>();

  usuarios: Usuario[] = [];
  mostrarFormulario: boolean = false;
  isLoading: boolean = false;
  errorMessage: string = '';
  successMessage: string = '';

  // Datos del formulario
  nuevoUsuario: CrearUsuarioRequest = {
    nombre: '',
    apellido: '',
    email: '',
    password: '',
    rut: '',
    telefono: '',
    rol: 'USUARIO'
  };

  // Control UI
  showPassword: boolean = false;

  constructor(private usuarioService: UsuarioService) {}

  ngOnInit() {
    this.cargarUsuarios();
  }

  cargarUsuarios() {
    this.isLoading = true;
    this.errorMessage = '';

    this.usuarioService.listarUsuarios().subscribe({
      next: (response) => {
        this.isLoading = false;
        if (response.success) {
          this.usuarios = response.usuarios;
        } else {
          this.errorMessage = response.message || 'Error al cargar usuarios';
        }
      },
      error: (error) => {
        this.isLoading = false;
        console.error('Error al cargar usuarios:', error);

        if (error.status === 403) {
          this.errorMessage = 'No tienes permisos para acceder a esta sección';
        } else if (error.status === 0) {
          this.errorMessage = 'No se puede conectar con el servidor';
        } else {
          this.errorMessage = error.error?.message || 'Error al cargar usuarios';
        }
      }
    });
  }

  abrirFormulario() {
    this.mostrarFormulario = true;
    this.limpiarFormulario();
    this.errorMessage = '';
    this.successMessage = '';
  }

  cerrarFormulario() {
    this.mostrarFormulario = false;
    this.limpiarFormulario();
    this.errorMessage = '';
    this.successMessage = '';
  }

  limpiarFormulario() {
    this.nuevoUsuario = {
      nombre: '',
      apellido: '',
      email: '',
      password: '',
      rut: '',
      telefono: '',
      rol: 'USUARIO'
    };
    this.showPassword = false;
  }

  crearUsuario() {
    if (!this.validarFormulario()) {
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.successMessage = '';

    this.usuarioService.crearUsuario(this.nuevoUsuario).subscribe({
      next: (response) => {
        this.isLoading = false;

        if (response.success) {
          this.successMessage = 'Usuario creado exitosamente';
          this.cargarUsuarios();

          // Cerrar formulario después de 2 segundos
          setTimeout(() => {
            this.cerrarFormulario();
            this.successMessage = '';
          }, 2000);
        } else {
          this.errorMessage = response.message || 'Error al crear usuario';
        }
      },
      error: (error) => {
        this.isLoading = false;
        console.error('Error al crear usuario:', error);

        if (error.status === 409) {
          this.errorMessage = 'El email o RUT ya está registrado';
        } else if (error.status === 403) {
          this.errorMessage = 'No tienes permisos para crear usuarios';
        } else {
          this.errorMessage = error.error?.message || 'Error al crear usuario';
        }
      }
    });
  }

  validarFormulario(): boolean {
    this.errorMessage = '';

    if (!this.nuevoUsuario.nombre || !this.nuevoUsuario.apellido ||
        !this.nuevoUsuario.email || !this.nuevoUsuario.password ||
        !this.nuevoUsuario.rut || !this.nuevoUsuario.rol) {
      this.errorMessage = 'Por favor, completa todos los campos obligatorios';
      return false;
    }

    if (!this.isValidEmail(this.nuevoUsuario.email)) {
      this.errorMessage = 'Por favor, ingresa un email válido';
      return false;
    }

    if (this.nuevoUsuario.password.length < 6) {
      this.errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      return false;
    }

    if (!this.validarRut(this.nuevoUsuario.rut)) {
      this.errorMessage = 'Por favor, ingresa un RUT válido (formato: 12345678-9)';
      return false;
    }

    return true;
  }

  isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  validarRut(rut: string): boolean {
    const rutRegex = /^\d{7,8}-[\dkK]$/;
    return rutRegex.test(rut);
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  cambiarEstado(usuario: Usuario) {
    const nuevoEstado = !usuario.activo;
    const accion = nuevoEstado ? 'activar' : 'desactivar';

    if (!confirm(`¿Estás seguro de ${accion} al usuario ${usuario.nombre} ${usuario.apellido}?`)) {
      return;
    }

    this.usuarioService.cambiarEstado(usuario.id, nuevoEstado).subscribe({
      next: (response) => {
        if (response.success) {
          usuario.activo = nuevoEstado;
          this.successMessage = `Usuario ${nuevoEstado ? 'activado' : 'desactivado'} exitosamente`;
          setTimeout(() => this.successMessage = '', 3000);
        } else {
          this.errorMessage = response.message || 'Error al cambiar estado';
        }
      },
      error: (error) => {
        console.error('Error al cambiar estado:', error);
        this.errorMessage = error.error?.message || 'Error al cambiar estado del usuario';
      }
    });
  }

  // Método para determinar si se puede cambiar el estado de un usuario
  puedeCambiarEstado(usuario: Usuario): boolean {
    // Siempre se puede activar un usuario inactivo
    if (!usuario.activo) {
      return true;
    }

    // Si el usuario NO es ADMIN, se puede desactivar
    if (usuario.rol !== 'ADMIN') {
      return true;
    }

    // Si es ADMIN, contar cuántos admins activos hay
    const adminsActivos = this.usuarios.filter(u => u.rol === 'ADMIN' && u.activo).length;

    // No se puede desactivar si es el último admin activo
    if (adminsActivos <= 1) {
      return false;
    }

    // Si hay más de un admin activo, sí se puede desactivar
    return true;
  }

  // Método para mostrar mensaje explicativo cuando el botón está deshabilitado
  getMensajeDeshabilitado(usuario: Usuario): string {
    if (!usuario.activo) {
      return 'Activar usuario';
    }

    if (usuario.rol !== 'ADMIN') {
      return 'Desactivar usuario';
    }

    const adminsActivos = this.usuarios.filter(u => u.rol === 'ADMIN' && u.activo).length;

    if (adminsActivos <= 1) {
      return 'No se puede desactivar el último administrador activo';
    }

    return 'Desactivar administrador';
  }

  volver() {
    this.volverInicio.emit();
  }

  getRolBadgeClass(rol: string): string {
    switch(rol) {
      case 'ADMIN': return 'badge-admin';
      case 'EMPLEADO': return 'badge-empleado';
      case 'USUARIO': return 'badge-usuario';
      default: return 'badge-default';
    }
  }
}

