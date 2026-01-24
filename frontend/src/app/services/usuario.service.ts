import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Usuario {
  id: number;
  nombre: string;
  apellido: string;
  email: string;
  rol: string;
  rut: string;
  telefono?: string;
  activo: boolean;
}

export interface CrearUsuarioRequest {
  nombre: string;
  apellido: string;
  email: string;
  password: string;
  rut: string;
  telefono?: string;
  rol: string;
}

@Injectable({
  providedIn: 'root'
})
export class UsuarioService {
  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) { }

  private getHeaders(): HttpHeaders {
    const user = this.getUser();
    return new HttpHeaders({
      'Content-Type': 'application/json',
      'User-Role': user?.rol || ''
    });
  }

  private getUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  }

  listarUsuarios(): Observable<any> {
    return this.http.get(`${this.apiUrl}/usuarios`, { headers: this.getHeaders() });
  }

  crearUsuario(usuario: CrearUsuarioRequest): Observable<any> {
    return this.http.post(`${this.apiUrl}/usuarios`, usuario, { headers: this.getHeaders() });
  }

  cambiarEstado(id: number, activo: boolean): Observable<any> {
    return this.http.patch(`${this.apiUrl}/usuarios/${id}/estado`, { activo }, { headers: this.getHeaders() });
  }
}

