import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';

import { AppComponent } from './app.component';
import { LoginComponent } from './components/login.component';
import { RegistroComponent } from './components/registro.component';
import { ReservaComponent } from './components/reserva.component';
import { ReportesComponent } from './components/reportes.component';
import { HomeComponent } from './components/home.component';
import { UsuariosComponent } from './components/usuarios.component';
import { CancelarReservaComponent } from './components/cancelar-reserva.component';
import { CanchasComponent } from './components/canchas.component';
import { CheckinComponent } from './components/checkin.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegistroComponent,
    ReservaComponent,
    ReportesComponent,
    HomeComponent,
    UsuariosComponent,
    CancelarReservaComponent,
    CanchasComponent,
    CheckinComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    CommonModule
  ],
  providers: [],
  exports: [
    AppComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
