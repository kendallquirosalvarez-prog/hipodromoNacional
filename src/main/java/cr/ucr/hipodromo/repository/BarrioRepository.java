package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Barrio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BarrioRepository extends JpaRepository<Barrio, Integer> {

    List<Barrio> findByIdDistritoOrderByNombreBarrioAsc(Integer idDistrito);

    @Query(value = """
        SELECT b.* FROM barrio b
        JOIN distrito d ON b.id_distrito = d.id_distrito
        WHERE d.id_canton = :idCanton
        ORDER BY b.nombre_barrio
        """, nativeQuery = true)
    List<Barrio> findByIdCanton(@Param("idCanton") Integer idCanton);

    @Query(value = """
        SELECT b.* FROM barrio b
        JOIN distrito d ON b.id_distrito = d.id_distrito
        JOIN canton   c ON d.id_canton   = c.id_canton
        WHERE c.id_provincia = :idProvincia
        ORDER BY b.nombre_barrio
        """, nativeQuery = true)
    List<Barrio> findByIdProvincia(@Param("idProvincia") Integer idProvincia);
}
