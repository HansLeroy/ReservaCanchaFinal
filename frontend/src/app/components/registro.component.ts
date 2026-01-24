import { Component, EventEmitter, Output } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-registro',
  templateUrl: './registro.component.html',
  styleUrls: ['./registro.component.css']
})
export class RegistroComponent {
  @Output() registroExitoso = new EventEmitter<void>();
  @Output() volverLogin = new EventEmitter<void>();

  // Datos del formulario
  nombre: string = '';
  apellido: string = '';
  email: string = '';
  password: string = '';
  confirmarPassword: string = '';
  rut: string = '';
  telefono: string = '';

  // Control UI
  showPassword: boolean = false;
  showConfirmPassword: boolean = false;
  errorMessage: string = '';
  isLoading: boolean = false;

  constructor(private authService: AuthService) {}

  onSubmit() {
    // Validaciones
    if (!this.validarFormulario()) {
      return;
    }

    this.errorMessage = '';
    this.isLoading = true;

    // Datos para registro
    const datosRegistro = {
      nombre: this.nombre,
      apellido: this.apellido,
      email: this.email,
      password: this.password,
      rut: this.rut,
      telefono: this.telefono
    };

    // Llamar servicio de registro
    this.authService.registro(datosRegistro).subscribe({
      next: (response) => {
        this.isLoading = false;

        if (response.success && response.token) {
          // Guardar token y usuario
          this.authService.saveToken(response.token);
          if (response.user) {
            this.authService.saveUser(response.user);
          }

          // Emitir evento de registro exitoso
          this.registroExitoso.emit();
        } else {
          this.errorMessage = response.message || 'Error al registrar usuario';
        }
      },
      error: (error) => {
        this.isLoading = false;
        console.error('Error en registro:', error);

        if (error.status === 409) {
          this.errorMessage = 'El email o RUT ya está registrado';
        } else if (error.status === 0) {
          this.errorMessage = 'No se puede conectar con el servidor. Verifica que el backend esté corriendo.';
        } else {
          this.errorMessage = error.error?.message || 'Error al registrar usuario. Intenta nuevamente.';
        }
      }
    });
  }

  validarFormulario(): boolean {
    this.errorMessage = '';

    if (!this.nombre || !this.apellido || !this.email ||
        !this.password || !this.confirmarPassword || !this.rut) {
      this.errorMessage = 'Por favor, completa todos los campos obligatorios';
      return false;
    }

    if (!this.isValidEmail(this.email)) {
      this.errorMessage = 'Por favor, ingresa un email válido';
      return false;
    }

    if (this.password.length < 6) {
      this.errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      return false;
    }

    if (this.password !== this.confirmarPassword) {
      this.errorMessage = 'Las contraseñas no coinciden';
      return false;
    }

    if (!this.validarRut(this.rut)) {
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

  toggleConfirmPasswordVisibility() {
    this.showConfirmPassword = !this.showConfirmPassword;
  }

  volver() {
    this.volverLogin.emit();
  }
}

