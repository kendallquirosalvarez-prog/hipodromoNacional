package cr.ucr.hipodromo.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "suministro")
public class Suministro {

    @Id
    @Column(name = "id_suministro")
    private String idSuministro;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "proveedor")
    private String proveedor;

    @Column(name = "cantidad_disponible")
    private Integer cantidadDisponible;

    @Column(name = "precio_unitario")
    private BigDecimal precioUnitario;

    public String getIdSuministro() { return idSuministro; }
    public void setIdSuministro(String idSuministro) { this.idSuministro = idSuministro; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getProveedor() { return proveedor; }
    public void setProveedor(String proveedor) { this.proveedor = proveedor; }
    public Integer getCantidadDisponible() { return cantidadDisponible; }
    public void setCantidadDisponible(Integer cantidadDisponible) { this.cantidadDisponible = cantidadDisponible; }
    public BigDecimal getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(BigDecimal precioUnitario) { this.precioUnitario = precioUnitario; }
}
