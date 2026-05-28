package cr.ucr.hipodromo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "provincia")
public class Provincia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_provincia")
    private Integer idProvincia;

    @Column(name = "nombre_provincia")
    private String nombreProvincia;

    @Column(name = "id_pais")
    private Integer idPais;

    public Integer getIdProvincia() { return idProvincia; }
    public void setIdProvincia(Integer v) { this.idProvincia = v; }
    public String getNombreProvincia() { return nombreProvincia; }
    public void setNombreProvincia(String v) { this.nombreProvincia = v; }
    public Integer getIdPais() { return idPais; }
    public void setIdPais(Integer v) { this.idPais = v; }
}
