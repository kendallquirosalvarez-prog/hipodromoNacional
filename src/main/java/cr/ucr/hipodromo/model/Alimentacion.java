package cr.ucr.hipodromo.model;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "alimentacion")
public class Alimentacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alimentacion")
    private Long idAlimentacion;

    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "id_suministro")
    private String idSuministro;

    @Column(name = "tipo_alimento")
    private String tipoAlimento;

    @Column(name = "cantidad")
    private BigDecimal cantidad;

    @Column(name = "fecha")
    private LocalDate fecha;

    public Long getIdAlimentacion() { return idAlimentacion; }
    public void setIdAlimentacion(Long idAlimentacion) { this.idAlimentacion = idAlimentacion; }
    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public String getIdSuministro() { return idSuministro; }
    public void setIdSuministro(String idSuministro) { this.idSuministro = idSuministro; }
    public String getTipoAlimento() { return tipoAlimento; }
    public void setTipoAlimento(String tipoAlimento) { this.tipoAlimento = tipoAlimento; }
    public BigDecimal getCantidad() { return cantidad; }
    public void setCantidad(BigDecimal cantidad) { this.cantidad = cantidad; }
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
}
