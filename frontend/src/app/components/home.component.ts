import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  @Output() irAReservas = new EventEmitter<void>();
  @Output() irAReportes = new EventEmitter<void>();
  @Output() irAUsuarios = new EventEmitter<void>();
  @Output() irACancelar = new EventEmitter<void>();
  @Output() irACanchas = new EventEmitter<void>();
  @Output() irACheckin = new EventEmitter<void>();
  @Output() cerrarSesion = new EventEmitter<void>();

  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    // Inicialización del componente
  }

  navegarAReservas() {
    this.irAReservas.emit();
  }

  navegarAReportes() {
    this.irAReportes.emit();
  }

  navegarAUsuarios() {
    this.irAUsuarios.emit();
  }

  navegarACancelar() {
    this.irACancelar.emit();
  }

  navegarACanchas() {
    this.irACanchas.emit();
  }

  navegarACheckin() {
    this.irACheckin.emit();
  }

  esAdmin(): boolean {
    const user = this.authService.getUser();
    return user && user.rol === 'ADMIN';
  }

  esUsuario(): boolean {
    const user = this.authService.getUser();
    return user && user.rol === 'USUARIO';
  }

  salir() {
    this.cerrarSesion.emit();
  }
}
