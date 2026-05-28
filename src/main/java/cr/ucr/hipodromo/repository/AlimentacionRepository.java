package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Alimentacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;

@Repository
public interface AlimentacionRepository extends JpaRepository<Alimentacion, Long> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_alimentacion(:p_id_caballo, :p_id_suministro, :p_tipo_alimento, :p_cantidad, :p_fecha)", nativeQuery = true)
    void insertarAlimentacion(
        @Param("p_id_caballo") String idCaballo,
        @Param("p_id_suministro") String idSuministro,
        @Param("p_tipo_alimento") String tipoAlimento,
        @Param("p_cantidad") BigDecimal cantidad,
        @Param("p_fecha") LocalDate fecha
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_alimentacion(:p_id)", nativeQuery = true)
    void eliminarAlimentacion(@Param("p_id") Long id);
}
