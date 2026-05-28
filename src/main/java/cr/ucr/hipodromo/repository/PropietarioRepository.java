package cr.ucr.hipodromo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import cr.ucr.hipodromo.model.Propietario;

@Repository
public interface PropietarioRepository extends JpaRepository<Propietario, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_propietario(:p_id, :p_nombre, :p_apellidos, :p_id_barrio)", nativeQuery = true)
    void insertarPropietario(
        @Param("p_id") String id,
        @Param("p_nombre") String nombre,
        @Param("p_apellidos") String apellidos,
        @Param("p_id_barrio") Integer idBarrio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_propietario(:p_id, :p_nombre, :p_apellidos, :p_id_barrio)", nativeQuery = true)
    void actualizarPropietario(
        @Param("p_id") String id,
        @Param("p_nombre") String nombre,
        @Param("p_apellidos") String apellidos,
        @Param("p_id_barrio") Integer idBarrio
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_propietario(:p_id)", nativeQuery = true)
    void eliminarPropietario(@Param("p_id") String id);
}
