import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Pago, ReporteGanancias } from '../models/models';

@Injectable({
  providedIn: 'root'
})
export class ReporteService {
  private apiUrl = 'http://localhost:8080/api/reportes';

  constructor(private http: HttpClient) { }

  obtenerReportePorFechas(fechaInicio: string, fechaFin: string): Observable<ReporteGanancias> {
    const params = new HttpParams()
      .set('fechaInicio', fechaInicio)
      .set('fechaFin', fechaFin);

    return this.http.get<ReporteGanancias>(`${this.apiUrl}/ganancias`, { params });
  }

  obtenerTodosPagos(): Observable<Pago[]> {
    return this.http.get<Pago[]>(`${this.apiUrl}/pagos`);
  }

  obtenerPagosPorFechas(fechaInicio: string, fechaFin: string): Observable<Pago[]> {
    const params = new HttpParams()
      .set('fechaInicio', fechaInicio)
      .set('fechaFin', fechaFin);

    return this.http.get<Pago[]>(`${this.apiUrl}/pagos`, { params });
  }
}

