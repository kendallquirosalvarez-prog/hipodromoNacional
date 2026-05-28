package cr.ucr.hipodromo.repository;

import cr.ucr.hipodromo.model.HistorialTransaccion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;

@Repository
public interface HistorialTransaccionRepository extends JpaRepository<HistorialTransaccion, Long> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_transaccion(:p_id_factura, :p_monto, :p_metodo_pago, :p_fecha_pago)", nativeQuery = true)
    void insertarTransaccion(
        @Param("p_id_factura") String idFactura,
        @Param("p_monto") BigDecimal monto,
        @Param("p_metodo_pago") String metodoPago,
        @Param("p_fecha_pago") LocalDate fechaPago
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_transaccion(:p_id)", nativeQuery = true)
    void eliminarTransaccion(@Param("p_id") Long id);
}
