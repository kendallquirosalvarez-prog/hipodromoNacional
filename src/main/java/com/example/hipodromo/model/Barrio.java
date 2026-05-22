package com.example.hipodromo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "barrio")
public class Barrio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_barrio")
    private Integer idBarrio;

    @Column(name = "nombre_barrio")
    private String nombreBarrio;

    @Column(name = "id_distrito")
    private Integer idDistrito;

    public Integer getIdBarrio() { return idBarrio; }
    public void setIdBarrio(Integer idBarrio) { this.idBarrio = idBarrio; }
    public String getNombreBarrio() { return nombreBarrio; }
    public void setNombreBarrio(String nombreBarrio) { this.nombreBarrio = nombreBarrio; }
    public Integer getIdDistrito() { return idDistrito; }
    public void setIdDistrito(Integer idDistrito) { this.idDistrito = idDistrito; }
}
