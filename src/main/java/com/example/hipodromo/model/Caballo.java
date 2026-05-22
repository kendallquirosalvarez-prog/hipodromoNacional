package com.example.hipodromo.model;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "caballo")
public class Caballo {

    @Id
    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "fecha_nacimiento")
    private LocalDate fechaNacimiento;

    @Column(name = "sexo")
    private String sexo;

    @Column(name = "raza")
    private String raza;

    @Column(name = "peso")
    private BigDecimal peso;

    @Column(name = "estado_salud")
    private String estadoSalud;

    @Column(name = "id_propietario")
    private String idPropietario;

    @Column(name = "id_establo")
    private String idEstablo;

    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public LocalDate getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(LocalDate fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public String getRaza() { return raza; }
    public void setRaza(String raza) { this.raza = raza; }
    public BigDecimal getPeso() { return peso; }
    public void setPeso(BigDecimal peso) { this.peso = peso; }
    public String getEstadoSalud() { return estadoSalud; }
    public void setEstadoSalud(String estadoSalud) { this.estadoSalud = estadoSalud; }
    public String getIdPropietario() { return idPropietario; }
    public void setIdPropietario(String idPropietario) { this.idPropietario = idPropietario; }
    public String getIdEstablo() { return idEstablo; }
    public void setIdEstablo(String idEstablo) { this.idEstablo = idEstablo; }
}
