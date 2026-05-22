package com.example.hipodromo.repository;

import com.example.hipodromo.model.Evento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Repository
public interface EventoRepository extends JpaRepository<Evento, String> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_evento(:p_id, :p_nombre, :p_fecha, :p_tipo_carrera, :p_distancia, :p_premio_total, :p_estado)", nativeQuery = true)
    void insertarEvento(
        @Param("p_id") String id,
        @Param("p_nombre") String nombre,
        @Param("p_fecha") LocalDateTime fecha,
        @Param("p_tipo_carrera") String tipoCarrera,
        @Param("p_distancia") Integer distancia,
        @Param("p_premio_total") BigDecimal premioTotal,
        @Param("p_estado") String estado
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_actualizar_evento(:p_id, :p_fecha, :p_premio_total, :p_estado)", nativeQuery = true)
    void actualizarEvento(
        @Param("p_id") String id,
        @Param("p_fecha") LocalDateTime fecha,
        @Param("p_premio_total") BigDecimal premioTotal,
        @Param("p_estado") String estado
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_evento(:p_id)", nativeQuery = true)
    void eliminarEvento(@Param("p_id") String id);
}
