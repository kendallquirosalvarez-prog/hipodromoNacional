package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Caballo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;

@Repository
public interface CaballoRepository extends JpaRepository<Caballo, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_caballo(:p_id, :p_nombre, :p_fecha_nacimiento, :p_sexo, :p_raza, :p_peso, :p_estado_salud, :p_id_propietario, :p_id_establo)", nativeQuery = true)
    void insertarCaballo(
        @Param("p_id") String id,
        @Param("p_nombre") String nombre,
        @Param("p_fecha_nacimiento") LocalDate fechaNacimiento,
        @Param("p_sexo") String sexo,
        @Param("p_raza") String raza,
        @Param("p_peso") BigDecimal peso,
        @Param("p_estado_salud") String estadoSalud,
        @Param("p_id_propietario") String idPropietario,
        @Param("p_id_establo") String idEstablo
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_caballo(:p_id, :p_peso, :p_estado_salud, :p_id_establo)", nativeQuery = true)
    void actualizarCaballo(
        @Param("p_id") String id,
        @Param("p_peso") BigDecimal peso,
        @Param("p_estado_salud") String estadoSalud,
        @Param("p_id_establo") String idEstablo
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_caballo(:p_id)", nativeQuery = true)
    void eliminarCaballo(@Param("p_id") String id);
}
