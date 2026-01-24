import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  @Output() loginExitoso = new EventEmitter<void>();
  @Output() irARegistro = new EventEmitter<void>();

  email: string = '';
  password: string = '';
  showPassword: boolean = false;
  errorMessage: string = '';
  isLoading: boolean = false;

  constructor(
    private authService: AuthService
  ) {}

  onSubmit() {
    // Validación básica
    if (!this.email || !this.password) {
      this.errorMessage = 'Por favor, completa todos los campos';
      return;
    }

    if (!this.isValidEmail(this.email)) {
      this.errorMessage = 'Por favor, ingresa un correo válido';
      return;
    }

    // Limpiar mensaje de error
    this.errorMessage = '';
    this.isLoading = true;

    // Llamar al servicio de autenticación
    this.authService.login(this.email, this.password).subscribe({
      next: (response) => {
        this.isLoading = false;

        if (response.success && response.token) {
          // Guardar token y usuario
          this.authService.saveToken(response.token);
          if (response.user) {
            this.authService.saveUser(response.user);
          }

          // Emitir evento de login exitoso
          this.loginExitoso.emit();
        } else {
          this.errorMessage = response.message || 'Credenciales incorrectas';
        }
      },
      error: (error) => {
        this.isLoading = false;
        console.error('Error en login:', error);

        if (error.status === 401) {
          this.errorMessage = 'Credenciales incorrectas';
        } else if (error.status === 0) {
          this.errorMessage = 'No se puede conectar con el servidor. Verifica que el backend esté corriendo.';
        } else {
          this.errorMessage = error.error?.message || 'Error al iniciar sesión. Intenta nuevamente.';
        }
      }
    });
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}

