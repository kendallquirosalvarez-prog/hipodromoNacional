package com.example.hipodromo.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "evento")
public class Evento {

    @Id
    @Column(name = "id_evento")
    private String idEvento;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "fecha")
    private LocalDateTime fecha;

    @Column(name = "tipo_carrera")
    private String tipoCarrera;

    @Column(name = "distancia")
    private Integer distancia;

    @Column(name = "premio_total")
    private BigDecimal premioTotal;

    @Column(name = "estado")
    private String estado;

    public String getIdEvento() { return idEvento; }
    public void setIdEvento(String idEvento) { this.idEvento = idEvento; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public LocalDateTime getFecha() { return fecha; }
    public void setFecha(LocalDateTime fecha) { this.fecha = fecha; }
    public String getTipoCarrera() { return tipoCarrera; }
    public void setTipoCarrera(String tipoCarrera) { this.tipoCarrera = tipoCarrera; }
    public Integer getDistancia() { return distancia; }
    public void setDistancia(Integer distancia) { this.distancia = distancia; }
    public BigDecimal getPremioTotal() { return premioTotal; }
    public void setPremioTotal(BigDecimal premioTotal) { this.premioTotal = premioTotal; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
