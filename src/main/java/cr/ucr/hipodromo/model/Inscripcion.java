package cr.ucr.hipodromo.model;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "inscripcion")
public class Inscripcion {

    @Id
    @Column(name = "id_inscripcion")
    private String idInscripcion;

    @Column(name = "id_evento")
    private String idEvento;

    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "fecha_inscripcion")
    private LocalDate fechaInscripcion;

    @Column(name = "estado")
    private String estado;

    @Column(name = "posicion_final")
    private Integer posicionFinal;

    public String getIdInscripcion() { return idInscripcion; }
    public void setIdInscripcion(String idInscripcion) { this.idInscripcion = idInscripcion; }
    public String getIdEvento() { return idEvento; }
    public void setIdEvento(String idEvento) { this.idEvento = idEvento; }
    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public LocalDate getFechaInscripcion() { return fechaInscripcion; }
    public void setFechaInscripcion(LocalDate fechaInscripcion) { this.fechaInscripcion = fechaInscripcion; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public Integer getPosicionFinal() { return posicionFinal; }
    public void setPosicionFinal(Integer posicionFinal) { this.posicionFinal = posicionFinal; }
}