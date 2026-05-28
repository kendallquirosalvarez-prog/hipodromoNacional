package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.HistorialVeterinario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;

@Repository
public interface HistorialVeterinarioRepository extends JpaRepository<HistorialVeterinario, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_historial_veterinario(:p_id, :p_id_caballo, :p_diagnostico, :p_tratamiento, :p_fecha_revision, :p_fecha_vencimiento, :p_veterinario)", nativeQuery = true)
    void insertarHistorial(
        @Param("p_id") String id,
        @Param("p_id_caballo") String idCaballo,
        @Param("p_diagnostico") String diagnostico,
        @Param("p_tratamiento") String tratamiento,
        @Param("p_fecha_revision") LocalDate fechaRevision,
        @Param("p_fecha_vencimiento") LocalDate fechaVencimiento,
        @Param("p_veterinario") String veterinario
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_historial_veterinario(:p_id, :p_diagnostico, :p_tratamiento, :p_fecha_vencimiento)", nativeQuery = true)
    void actualizarHistorial(
        @Param("p_id") String id,
        @Param("p_diagnostico") String diagnostico,
        @Param("p_tratamiento") String tratamiento,
        @Param("p_fecha_vencimiento") LocalDate fechaVencimiento
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_historial_veterinario(:p_id)", nativeQuery = true)
    void eliminarHistorial(@Param("p_id") String id);
}
