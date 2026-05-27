package com.example.hipodromo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "canton")
public class Canton {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_canton")
    private Integer idCanton;

    @Column(name = "nombre_canton")
    private String nombreCanton;

    @Column(name = "id_provincia")
    private Integer idProvincia;

    public Integer getIdCanton() { return idCanton; }
    public void setIdCanton(Integer v) { this.idCanton = v; }
    public String getNombreCanton() { return nombreCanton; }
    public void setNombreCanton(String v) { this.nombreCanton = v; }
    public Integer getIdProvincia() { return idProvincia; }
    public void setIdProvincia(Integer v) { this.idProvincia = v; }
}
