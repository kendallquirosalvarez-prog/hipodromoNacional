package cr.ucr.hipodromo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "distrito")
public class Distrito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_distrito")
    private Integer idDistrito;

    @Column(name = "nombre_distrito")
    private String nombreDistrito;

    @Column(name = "id_canton")
    private Integer idCanton;

    public Integer getIdDistrito() { return idDistrito; }
    public void setIdDistrito(Integer v) { this.idDistrito = v; }
    public String getNombreDistrito() { return nombreDistrito; }
    public void setNombreDistrito(String v) { this.nombreDistrito = v; }
    public Integer getIdCanton() { return idCanton; }
    public void setIdCanton(Integer v) { this.idCanton = v; }
}
