package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Distrito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DistritoRepository extends JpaRepository<Distrito, Integer> {
    List<Distrito> findByIdCantonOrderByNombreDistritoAsc(Integer idCanton);
}
