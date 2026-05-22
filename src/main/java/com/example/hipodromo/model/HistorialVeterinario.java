package com.example.hipodromo.model;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "historial_veterinario")
public class HistorialVeterinario {

    @Id
    @Column(name = "id_registro")
    private String idRegistro;

    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "diagnostico")
    private String diagnostico;

    @Column(name = "tratamiento")
    private String tratamiento;

    @Column(name = "fecha_revision")
    private LocalDate fechaRevision;

    @Column(name = "fecha_vencimiento_certificacion")
    private LocalDate fechaVencimientoCertificacion;

    @Column(name = "veterinario_responsable")
    private String veterinarioResponsable;

    public String getIdRegistro() { return idRegistro; }
    public void setIdRegistro(String idRegistro) { this.idRegistro = idRegistro; }
    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }
    public String getTratamiento() { return tratamiento; }
    public void setTratamiento(String tratamiento) { this.tratamiento = tratamiento; }
    public LocalDate getFechaRevision() { return fechaRevision; }
    public void setFechaRevision(LocalDate fechaRevision) { this.fechaRevision = fechaRevision; }
    public LocalDate getFechaVencimientoCertificacion() { return fechaVencimientoCertificacion; }
    public void setFechaVencimientoCertificacion(LocalDate f) { this.fechaVencimientoCertificacion = f; }
    public String getVeterinarioResponsable() { return veterinarioResponsable; }
    public void setVeterinarioResponsable(String v) { this.veterinarioResponsable = v; }
}
