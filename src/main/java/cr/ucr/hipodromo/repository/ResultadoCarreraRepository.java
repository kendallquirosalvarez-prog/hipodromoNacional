package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.ResultadoCarrera;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Repository
public interface ResultadoCarreraRepository extends JpaRepository<ResultadoCarrera, Long> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_resultado(:p_id_evento, :p_id_caballo, :p_posicion, :p_tiempo, :p_premio)", nativeQuery = true)
    void insertarResultado(
        @Param("p_id_evento") String idEvento,
        @Param("p_id_caballo") String idCaballo,
        @Param("p_posicion") Integer posicion,
        @Param("p_tiempo") String tiempo,
        @Param("p_premio") BigDecimal premioGanado
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_resultado(:p_id, :p_posicion, :p_tiempo, :p_premio)", nativeQuery = true)
    void actualizarResultado(
        @Param("p_id") Long id,
        @Param("p_posicion") Integer posicion,
        @Param("p_tiempo") String tiempo,
        @Param("p_premio") BigDecimal premioGanado
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_resultado(:p_id)", nativeQuery = true)
    void eliminarResultado(@Param("p_id") Long id);
}
