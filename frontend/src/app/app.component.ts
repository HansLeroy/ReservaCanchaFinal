import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'ReservaCancha';
  vistaActual: 'login' | 'home' | 'reservas' | 'reportes' | 'usuarios' | 'cancelar' | 'canchas' | 'checkin' = 'login';
  usuarioAutenticado: boolean = false;

  onLoginExitoso() {
    this.usuarioAutenticado = true;
    this.vistaActual = 'home';
  }


  mostrarLogin() {
    this.vistaActual = 'login';
  }

  mostrarHome() {
    this.vistaActual = 'home';
  }

  mostrarReservas() {
    this.vistaActual = 'reservas';
  }

  mostrarReportes() {
    this.vistaActual = 'reportes';
  }

  mostrarUsuarios() {
    this.vistaActual = 'usuarios';
  }

  mostrarCanchas() {
    this.vistaActual = 'canchas';
  }

  mostrarCancelar() {
    this.vistaActual = 'cancelar';
  }

  mostrarCheckin() {
    this.vistaActual = 'checkin';
  }

  cerrarSesion() {
    this.usuarioAutenticado = false;
    this.vistaActual = 'login';
  }
}
