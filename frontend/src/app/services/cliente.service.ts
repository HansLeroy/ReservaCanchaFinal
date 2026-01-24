import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ClienteData {
  rut: string;
  nombre: string;
  apellido: string;
  email: string;
  telefono: string;
}

@Injectable({
  providedIn: 'root'
})
export class ClienteService {
  private apiUrl = 'http://localhost:8080/api/reservas';

  constructor(private http: HttpClient) { }

  buscarClientePorRut(rut: string): Observable<ClienteData | null> {
    return this.http.get<ClienteData | null>(`${this.apiUrl}/cliente/${rut}`);
  }
}

