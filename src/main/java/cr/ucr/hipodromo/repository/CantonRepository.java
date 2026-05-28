package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.Canton;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CantonRepository extends JpaRepository<Canton, Integer> {
    List<Canton> findByIdProvinciaOrderByNombreCantonAsc(Integer idProvincia);
}
