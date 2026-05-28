package cr.ucr.hipodromo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "establo")
public class Establo {

    @Id
    @Column(name = "id_establo")
    private String idEstablo;

    @Column(name = "capacidad")
    private Integer capacidad;

    @Column(name = "estado")
    private String estado;

    @Column(name = "id_barrio")
    private Integer idBarrio;

    public String getIdEstablo() { return idEstablo; }
    public void setIdEstablo(String idEstablo) { this.idEstablo = idEstablo; }
    public Integer getCapacidad() { return capacidad; }
    public void setCapacidad(Integer capacidad) { this.capacidad = capacidad; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public Integer getIdBarrio() { return idBarrio; }
    public void setIdBarrio(Integer idBarrio) { this.idBarrio = idBarrio; }
}
