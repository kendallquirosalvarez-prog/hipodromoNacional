package com.example.hipodromo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "propietario")
public class Propietario {

    @Id
    @Column(name = "id_propietario")
    private String idPropietario;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellidos")
    private String apellidos;

    @Column(name = "id_barrio")
    private Integer idBarrio;

    @Column(name = "propietario_con_descuento_proxima_facturacion")
    private Boolean descuentoProximaFacturacion;

    public String getIdPropietario() { return idPropietario; }
    public void setIdPropietario(String idPropietario) { this.idPropietario = idPropietario; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public Integer getIdBarrio() { return idBarrio; }
    public void setIdBarrio(Integer idBarrio) { this.idBarrio = idBarrio; }
    public Boolean getDescuentoProximaFacturacion() { return descuentoProximaFacturacion; }
    public void setDescuentoProximaFacturacion(Boolean d) { this.descuentoProximaFacturacion = d; }
}