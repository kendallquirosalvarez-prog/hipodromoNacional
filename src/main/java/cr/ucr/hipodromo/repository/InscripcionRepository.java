package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Inscripcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;

@Repository
public interface InscripcionRepository extends JpaRepository<Inscripcion, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_inscripcion(:p_id, :p_id_evento, :p_id_caballo, :p_fecha, :p_estado)", nativeQuery = true)
    void insertarInscripcion(
        @Param("p_id") String id,
        @Param("p_id_evento") String idEvento,
        @Param("p_id_caballo") String idCaballo,
        @Param("p_fecha") LocalDate fecha,
        @Param("p_estado") String estado
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_inscripcion(:p_id, :p_estado, :p_posicion_final, :p_tiempo)", nativeQuery = true)
    void actualizarInscripcion(
        @Param("p_id") String id,
        @Param("p_estado") String estado,
        @Param("p_posicion_final") Integer posicionFinal,
        @Param("p_tiempo") String tiempo
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_inscripcion(:p_id)", nativeQuery = true)
    void eliminarInscripcion(@Param("p_id") String id);
}
