-- ================================================================
-- CORRECCIÓN DE CONFLICTOS — Hipódromo Nacional
-- Ejecutar en Supabase > SQL Editor
-- ================================================================
-- Resuelve los choques entre los scripts de distintos integrantes:
--   1. Trigger del compañero que bloquea inserciones en caballo
--   2. sp_calcular_premios con columnas incorrectas
--   3. Procedures obsoletos que apuntan a tablas en plural
--   4. Funciones de trigger duplicadas/conflictivas
-- ================================================================


-- ================================================================
-- PASO 1: Eliminar triggers y funciones conflictivas del compañero
-- ================================================================

-- Triggers del compañero — nombres en SINGULAR y PLURAL para cubrir ambas variantes
DROP TRIGGER IF EXISTS trg_auditoria_caballo               ON caballo;
DROP TRIGGER IF EXISTS trg_auditoria_caballos              ON caballo;
DROP TRIGGER IF EXISTS trg_auditoria_propietario           ON propietario;
DROP TRIGGER IF EXISTS trg_auditoria_propietarios          ON propietario;
DROP TRIGGER IF EXISTS trg_auditoria_evento                ON evento;
DROP TRIGGER IF EXISTS trg_auditoria_eventos               ON evento;
DROP TRIGGER IF EXISTS trg_auditoria_inscripcion           ON inscripcion;
DROP TRIGGER IF EXISTS trg_auditoria_inscripciones         ON inscripcion;
DROP TRIGGER IF EXISTS trg_auditoria_factura               ON factura;
DROP TRIGGER IF EXISTS trg_auditoria_facturas              ON factura;
DROP TRIGGER IF EXISTS trg_auditoria_historial_veterinario ON historial_veterinario;
DROP TRIGGER IF EXISTS trg_auditoria_historial             ON historial_veterinario;
DROP TRIGGER IF EXISTS trg_auditoria_establo               ON establo;
DROP TRIGGER IF EXISTS trg_auditoria_establos              ON establo;
DROP TRIGGER IF EXISTS trg_auditoria_suministro            ON suministro;
DROP TRIGGER IF EXISTS trg_auditoria_suministros           ON suministro;
DROP TRIGGER IF EXISTS trg_auditoria_alimentacion          ON alimentacion;
DROP TRIGGER IF EXISTS trg_auditoria_resultado_carrera     ON resultado_carrera;
DROP TRIGGER IF EXISTS trg_auditoria_alerta_veterinaria    ON alerta_veterinaria;
DROP TRIGGER IF EXISTS trg_auditoria_historial_transaccion ON historial_transaccion;

-- Función genérica del compañero (usaba fn_auditar_tabla para todo)
DROP FUNCTION IF EXISTS fn_auditar_tabla() CASCADE;
-- Funciones individuales por si usaban la variante con nombre de tabla
DROP FUNCTION IF EXISTS fn_auditar_caballos();
DROP FUNCTION IF EXISTS fn_auditar_propietarios();
DROP FUNCTION IF EXISTS fn_auditar_eventos();
DROP FUNCTION IF EXISTS fn_auditar_inscripciones();
DROP FUNCTION IF EXISTS fn_auditar_facturas();
DROP FUNCTION IF EXISTS fn_auditar_historial();
DROP FUNCTION IF EXISTS fn_auditar_suministros();
DROP FUNCTION IF EXISTS fn_auditar_alimentacion();


-- ================================================================
-- PASO 2: Corregir sp_calcular_premios
-- El compañero usaba id_inscripcion y premio_obtenido,
-- pero nuestra tabla usa id_evento/id_caballo y premio_ganado
-- ================================================================

CREATE OR REPLACE PROCEDURE sp_calcular_premios(p_id_evento VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    v_premio_total NUMERIC(12,2);
BEGIN
    SELECT premio_total INTO v_premio_total
    FROM evento WHERE id_evento = p_id_evento;

    IF v_premio_total IS NULL THEN
        RAISE EXCEPTION 'Evento % no encontrado.', p_id_evento;
    END IF;

    UPDATE resultado_carrera
    SET premio_ganado = CASE
        WHEN posicion = 1 THEN ROUND(v_premio_total * 0.60, 2)
        WHEN posicion = 2 THEN ROUND(v_premio_total * 0.25, 2)
        WHEN posicion = 3 THEN ROUND(v_premio_total * 0.15, 2)
        ELSE 0
    END
    WHERE id_evento = p_id_evento;

    RAISE NOTICE 'Premios calculados para evento %', p_id_evento;
    RAISE NOTICE '1er lugar: %', ROUND(v_premio_total * 0.60, 2);
    RAISE NOTICE '2do lugar: %', ROUND(v_premio_total * 0.25, 2);
    RAISE NOTICE '3er lugar: %', ROUND(v_premio_total * 0.15, 2);
END;
$$;


-- ================================================================
-- PASO 3: Eliminar procedures del compañero que apuntan a
-- tablas en plural (no existen → causan errores)
-- ================================================================

DROP PROCEDURE IF EXISTS insertar_propietario(VARCHAR,VARCHAR,VARCHAR,INT);
DROP PROCEDURE IF EXISTS actualizar_propietario(VARCHAR,VARCHAR,VARCHAR,INT);
DROP PROCEDURE IF EXISTS eliminar_propietario(VARCHAR);

DROP PROCEDURE IF EXISTS insertar_telefono_propietario(VARCHAR,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_telefono_propietario(INT,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_telefono_propietario(INT);

DROP PROCEDURE IF EXISTS insertar_correo_propietario(VARCHAR,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_correo_propietario(INT,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_correo_propietario(INT);

DROP PROCEDURE IF EXISTS insertar_establo(VARCHAR,INT,INT,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_establo(VARCHAR,INT,INT,VARCHAR);

DROP PROCEDURE IF EXISTS insertar_caballo(VARCHAR,VARCHAR,DATE,CHAR,VARCHAR,DECIMAL,VARCHAR,VARCHAR,VARCHAR,DATE);
DROP PROCEDURE IF EXISTS actualizar_caballo(VARCHAR,DECIMAL,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_caballo(VARCHAR);

DROP PROCEDURE IF EXISTS insertar_evento(VARCHAR,VARCHAR,TIMESTAMP,VARCHAR,DECIMAL,DECIMAL,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_evento(VARCHAR,TIMESTAMP,DECIMAL,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_evento(VARCHAR);

DROP PROCEDURE IF EXISTS insertar_inscripcion(VARCHAR,VARCHAR,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_inscripcion(INT,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_inscripcion(INT);

DROP PROCEDURE IF EXISTS insertar_historial_veterinario(VARCHAR,TEXT,TEXT,DATE,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_historial_veterinario(INT,TEXT,TEXT);
DROP PROCEDURE IF EXISTS eliminar_historial_veterinario(INT);

DROP PROCEDURE IF EXISTS insertar_factura(VARCHAR,VARCHAR,DECIMAL,DECIMAL,DECIMAL,DECIMAL,VARCHAR);
DROP PROCEDURE IF EXISTS actualizar_factura(INT,DECIMAL,DECIMAL,VARCHAR);
DROP PROCEDURE IF EXISTS eliminar_factura(INT);

-- Procedures de ubicación del compañero (apuntan a Paises, Provincias, etc. en plural)
DROP PROCEDURE IF EXISTS sp_insertar_pais(VARCHAR);
DROP PROCEDURE IF EXISTS sp_insertar_provincia(VARCHAR,INT);
DROP PROCEDURE IF EXISTS sp_actualizar_provincia(INT,VARCHAR,INT);
DROP PROCEDURE IF EXISTS sp_insertar_canton(VARCHAR,INT);
DROP PROCEDURE IF EXISTS sp_insertar_distrito(VARCHAR,INT);
DROP PROCEDURE IF EXISTS sp_insertar_barrio(VARCHAR,INT);
DROP PROCEDURE IF EXISTS sp_eliminar_barrio(INT);


-- ================================================================
-- PASO 4: Verificar que los triggers correctos están activos
-- ================================================================

-- Debe mostrar: tr_auditoria_* en las tablas principales
--               tr_bitacora_* en las 8 tablas con >5 campos
--               tr_alerta_vencimiento en historial_veterinario
SELECT
    trigger_name,
    event_object_table  AS tabla,
    event_manipulation  AS evento,
    action_timing       AS momento
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name NOT LIKE 'RI_%'
ORDER BY event_object_table, trigger_name;
