package cr.ucr.hipodromo.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "resultado_carrera")
public class ResultadoCarrera {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_resultado")
    private Long idResultado;

    @Column(name = "id_evento")
    private String idEvento;

    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "posicion")
    private Integer posicion;

    @Column(name = "tiempo")
    private String tiempo;

    @Column(name = "premio_ganado")
    private BigDecimal premioGanado;

    public Long getIdResultado() { return idResultado; }
    public void setIdResultado(Long idResultado) { this.idResultado = idResultado; }
    public String getIdEvento() { return idEvento; }
    public void setIdEvento(String idEvento) { this.idEvento = idEvento; }
    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public Integer getPosicion() { return posicion; }
    public void setPosicion(Integer posicion) { this.posicion = posicion; }
    public String getTiempo() { return tiempo; }
    public void setTiempo(String tiempo) { this.tiempo = tiempo; }
    public BigDecimal getPremioGanado() { return premioGanado; }
    public void setPremioGanado(BigDecimal premioGanado) { this.premioGanado = premioGanado; }
}
