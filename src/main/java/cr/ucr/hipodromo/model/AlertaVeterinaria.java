package cr.ucr.hipodromo.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "alerta_veterinaria")
public class AlertaVeterinaria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alerta")
    private Long idAlerta;

    @Column(name = "id_caballo")
    private String idCaballo;

    @Column(name = "id_propietario")
    private String idPropietario;

    @Column(name = "mensaje")
    private String mensaje;

    @Column(name = "leida")
    private Boolean leida;

    @Column(name = "fecha_alerta")
    private LocalDateTime fechaAlerta;

    public Long getIdAlerta() { return idAlerta; }
    public void setIdAlerta(Long idAlerta) { this.idAlerta = idAlerta; }
    public String getIdCaballo() { return idCaballo; }
    public void setIdCaballo(String idCaballo) { this.idCaballo = idCaballo; }
    public String getIdPropietario() { return idPropietario; }
    public void setIdPropietario(String idPropietario) { this.idPropietario = idPropietario; }
    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
    public Boolean getLeida() { return leida; }
    public void setLeida(Boolean leida) { this.leida = leida; }
    public LocalDateTime getFechaAlerta() { return fechaAlerta; }
    public void setFechaAlerta(LocalDateTime fechaAlerta) { this.fechaAlerta = fechaAlerta; }
}
