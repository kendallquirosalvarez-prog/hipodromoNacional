package com.example.hipodromo.repository;

import com.example.hipodromo.model.AlertaVeterinaria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface AlertaVeterinariaRepository extends JpaRepository<AlertaVeterinaria, Long> {

    @Modifying
    @Transactional
    @Query(value = "CALL sp_insertar_alerta(:p_id_caballo, :p_id_propietario, :p_mensaje)", nativeQuery = true)
    void insertarAlerta(
        @Param("p_id_caballo") String idCaballo,
        @Param("p_id_propietario") String idPropietario,
        @Param("p_mensaje") String mensaje
    );

    @Modifying
    @Transactional
    @Query(value = "CALL sp_marcar_alerta_leida(:p_id)", nativeQuery = true)
    void marcarLeida(@Param("p_id") Long id);

    @Modifying
    @Transactional
    @Query(value = "CALL sp_eliminar_alerta(:p_id)", nativeQuery = true)
    void eliminarAlerta(@Param("p_id") Long id);
}
