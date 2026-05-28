package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Suministro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Repository
public interface SuministroRepository extends JpaRepository<Suministro, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_suministro(:p_id, :p_tipo, :p_proveedor, :p_cantidad, :p_precio)", nativeQuery = true)
    void insertarSuministro(
        @Param("p_id") String id,
        @Param("p_tipo") String tipo,
        @Param("p_proveedor") String proveedor,
        @Param("p_cantidad") Integer cantidad,
        @Param("p_precio") BigDecimal precio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_suministro(:p_id, :p_cantidad, :p_precio)", nativeQuery = true)
    void actualizarSuministro(
        @Param("p_id") String id,
        @Param("p_cantidad") Integer cantidad,
        @Param("p_precio") BigDecimal precio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_suministro(:p_id)", nativeQuery = true)
    void eliminarSuministro(@Param("p_id") String id);
}
