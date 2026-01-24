import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Cancha } from '../models/models';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CanchaService {
  private apiUrl = `${environment.apiUrl}/canchas`;

  constructor(private http: HttpClient) { }

  getCanchas(): Observable<Cancha[]> {
    return this.http.get<Cancha[]>(this.apiUrl);
  }

  getCanchasDisponibles(): Observable<Cancha[]> {
    return this.http.get<Cancha[]>(`${this.apiUrl}/disponibles`);
  }

  getCanchaById(id: number): Observable<Cancha> {
    return this.http.get<Cancha>(`${this.apiUrl}/${id}`);
  }

  createCancha(cancha: Cancha): Observable<Cancha> {
    return this.http.post<Cancha>(this.apiUrl, cancha);
  }

  updateCancha(id: number, cancha: Cancha): Observable<Cancha> {
    return this.http.put<Cancha>(`${this.apiUrl}/${id}`, cancha);
  }

  deleteCancha(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}

