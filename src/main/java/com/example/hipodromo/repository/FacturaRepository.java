package com.example.hipodromo.repository;

import com.example.hipodromo.model.Factura;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Repository
public interface FacturaRepository extends JpaRepository<Factura, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_factura(:p_id, :p_id_propietario, :p_id_evento, :p_subtotal, :p_descuento, :p_impuestos, :p_total, :p_estado_pago)", nativeQuery = true)
    void insertarFactura(
        @Param("p_id") String id,
        @Param("p_id_propietario") String idPropietario,
        @Param("p_id_evento") String idEvento,
        @Param("p_subtotal") BigDecimal subtotal,
        @Param("p_descuento") BigDecimal descuento,
        @Param("p_impuestos") BigDecimal impuestos,
        @Param("p_total") BigDecimal total,
        @Param("p_estado_pago") String estadoPago
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_factura(:p_id, :p_descuento, :p_total, :p_estado_pago)", nativeQuery = true)
    void actualizarFactura(
        @Param("p_id") String id,
        @Param("p_descuento") BigDecimal descuento,
        @Param("p_total") BigDecimal total,
        @Param("p_estado_pago") String estadoPago
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_factura(:p_id)", nativeQuery = true)
    void eliminarFactura(@Param("p_id") String id);
}
