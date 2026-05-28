package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Establo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface EstabloRepository extends JpaRepository<Establo, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_establo(:p_id, :p_capacidad, :p_estado, :p_id_barrio)", nativeQuery = true)
    void insertarEstablo(
        @Param("p_id") String id,
        @Param("p_capacidad") Integer capacidad,
        @Param("p_estado") String estado,
        @Param("p_id_barrio") Integer idBarrio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_establo(:p_id, :p_capacidad, :p_estado, :p_id_barrio)", nativeQuery = true)
    void actualizarEstablo(
        @Param("p_id") String id,
        @Param("p_capacidad") Integer capacidad,
        @Param("p_estado") String estado,
        @Param("p_id_barrio") Integer idBarrio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_establo(:p_id)", nativeQuery = true)
    void eliminarEstablo(@Param("p_id") String id);
}
