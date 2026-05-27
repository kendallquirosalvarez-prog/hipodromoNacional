-- ================================================================
-- AUTOMATIZACIÓN DE PROCESOS — Hipódromo Nacional
-- Ejecutar DESPUÉS de schema_completo.sql
-- ================================================================
-- Cubre los puntos 5, 11 y 12 de la rúbrica:
--   11 (5%): SP propietarios frecuentes + descuento automático 10%
--   12 (3%): SP facturación integral por propietario (CR IVA 13%)
--    5:      SP validar certificación + sp_calcular_premios
-- ================================================================


-- ================================================================
-- SECUENCIA para IDs de facturas auto-generadas
-- ================================================================
CREATE SEQUENCE IF NOT EXISTS seq_factura_auto START 1 INCREMENT 1;


-- ================================================================
-- PUNTO 11 (5%): sp_marcar_propietarios_frecuentes
-- Determina qué propietarios han facturado >₡500 000 en los
-- últimos 6 meses y activa su bandera de descuento.
-- ================================================================

CREATE OR REPLACE PROCEDURE sp_marcar_propietarios_frecuentes()
LANGUAGE plpgsql AS $$
DECLARE
    v_contador INTEGER := 0;
BEGIN
    UPDATE propietario p
       SET propietario_con_descuento_proxima_facturacion = TRUE
     WHERE (
               SELECT COALESCE(SUM(f.total), 0)
                 FROM factura f
                WHERE f.id_propietario = p.id_propietario
                  AND f.fecha_emision  >= NOW() - INTERVAL '6 months'
                  AND f.estado_pago    = 'Pagado'
           ) > 500000
       AND propietario_con_descuento_proxima_facturacion = FALSE;

    GET DIAGNOSTICS v_contador = ROW_COUNT;
    RAISE NOTICE '% propietario(s) marcado(s) con descuento para próxima facturación.', v_contador;
END;
$$;


-- ================================================================
-- PUNTO 11 (5%): sp_insertar_factura (versión con descuento auto)
-- Reemplaza la versión básica de schema_completo.sql.
-- Si el propietario tiene el flag activo, aplica 10% de descuento
-- adicional, recalcula IVA (13% CR) y total, y reinicializa el flag.
-- ================================================================

CREATE OR REPLACE PROCEDURE sp_insertar_factura(
    p_id             VARCHAR,
    p_id_propietario VARCHAR,
    p_id_evento      VARCHAR,
    p_subtotal       DECIMAL,
    p_descuento      DECIMAL,
    p_impuestos      DECIMAL,
    p_total          DECIMAL,
    p_estado_pago    VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_tiene_descuento BOOLEAN := FALSE;
    v_descuento_final DECIMAL;
    v_impuestos_final DECIMAL;
    v_total_final     DECIMAL;
BEGIN
    -- Verificar bandera de descuento frecuente
    SELECT propietario_con_descuento_proxima_facturacion
      INTO v_tiene_descuento
      FROM propietario
     WHERE id_propietario = p_id_propietario;

    IF v_tiene_descuento THEN
        -- 10% de descuento adicional sobre subtotal
        v_descuento_final := ROUND(p_descuento + p_subtotal * 0.10, 2);
        RAISE NOTICE 'Aplicando descuento del 10%% al propietario %. Descuento total: ₡%',
                     p_id_propietario, v_descuento_final;
    ELSE
        v_descuento_final := p_descuento;
    END IF;

    -- Calcular IVA (13% sobre subtotal neto) — Ley 9635 Costa Rica
    v_impuestos_final := ROUND((p_subtotal - v_descuento_final) * 0.13, 2);
    v_total_final     := ROUND(p_subtotal - v_descuento_final + v_impuestos_final, 2);

    INSERT INTO factura (
        id_factura, id_propietario, id_evento,
        subtotal, descuento, impuestos, total, estado_pago
    )
    VALUES (
        p_id, p_id_propietario, p_id_evento,
        p_subtotal, v_descuento_final, v_impuestos_final, v_total_final, p_estado_pago
    );

    -- Reinicializar bandera tras aplicar el descuento
    IF v_tiene_descuento THEN
        UPDATE propietario
           SET propietario_con_descuento_proxima_facturacion = FALSE
         WHERE id_propietario = p_id_propietario;

        RAISE NOTICE 'Descuento aplicado y bandera reinicializada para propietario %.', p_id_propietario;
    END IF;
END;
$$;


-- ================================================================
-- PUNTO 12 (3%): sp_facturar_propietario
-- Facturación integral por propietario — Legislación CR.
-- Genera facturas para todos los eventos con inscripciones activas
-- del propietario que aún no han sido facturadas.
-- Incluye: precio inscripción, comisión administrativa 5%,
--          descuento 10% si aplica, IVA 13% (Ley 9635).
-- ================================================================

CREATE OR REPLACE PROCEDURE sp_facturar_propietario(
    p_id_propietario     VARCHAR,
    p_precio_inscripcion DECIMAL DEFAULT 50000
)
LANGUAGE plpgsql AS $$
DECLARE
    v_evento             RECORD;
    v_comision_pct       DECIMAL := 0.05;   -- 5% comisión administrativa
    v_iva_pct            DECIMAL := 0.13;   -- IVA 13% (Ley 9635 CR)
    v_tiene_descuento    BOOLEAN := FALSE;
    v_subtotal           DECIMAL;
    v_descuento          DECIMAL;
    v_impuestos          DECIMAL;
    v_total              DECIMAL;
    v_id_factura         VARCHAR;
    v_contador           INTEGER := 0;
BEGIN
    -- Verificar que el propietario existe
    IF NOT EXISTS (SELECT 1 FROM propietario WHERE id_propietario = p_id_propietario) THEN
        RAISE EXCEPTION 'Propietario % no encontrado.', p_id_propietario;
    END IF;

    -- Verificar bandera de descuento
    SELECT propietario_con_descuento_proxima_facturacion
      INTO v_tiene_descuento
      FROM propietario
     WHERE id_propietario = p_id_propietario;

    -- Recorrer eventos con inscripciones activas no facturadas
    FOR v_evento IN
        SELECT DISTINCT i.id_evento
          FROM inscripcion i
         INNER JOIN caballo c ON i.id_caballo = c.id_caballo
         WHERE c.id_propietario = p_id_propietario
           AND i.estado IN ('Inscrito', 'Confirmado', 'Competido')
           AND NOT EXISTS (
               SELECT 1 FROM factura f
                WHERE f.id_propietario = p_id_propietario
                  AND f.id_evento       = i.id_evento
           )
    LOOP
        -- Subtotal = precio inscripción + 5% comisión administrativa
        v_subtotal  := ROUND(p_precio_inscripcion * (1 + v_comision_pct), 2);

        -- Descuento 10% si propietario frecuente
        v_descuento := CASE WHEN v_tiene_descuento
                            THEN ROUND(v_subtotal * 0.10, 2)
                            ELSE 0
                       END;

        -- IVA 13% sobre subtotal neto (Ley 9635, Art. 1)
        v_impuestos := ROUND((v_subtotal - v_descuento) * v_iva_pct, 2);
        v_total     := ROUND(v_subtotal - v_descuento + v_impuestos, 2);

        -- ID único: FAC-{propietario}-{evento}-{seq}
        v_id_factura := 'FAC-' || p_id_propietario
                     || '-' || v_evento.id_evento
                     || '-' || LPAD(nextval('seq_factura_auto')::TEXT, 4, '0');

        INSERT INTO factura (
            id_factura, id_propietario, id_evento,
            subtotal, descuento, impuestos, total, estado_pago
        )
        VALUES (
            v_id_factura, p_id_propietario, v_evento.id_evento,
            v_subtotal, v_descuento, v_impuestos, v_total, 'Pendiente'
        );

        v_contador := v_contador + 1;

        RAISE NOTICE 'Factura % generada — Evento: %, Subtotal: ₡%, Descuento: ₡%, IVA: ₡%, Total: ₡%',
                     v_id_factura, v_evento.id_evento,
                     v_subtotal, v_descuento, v_impuestos, v_total;
    END LOOP;

    IF v_contador = 0 THEN
        RAISE NOTICE 'No hay eventos pendientes de facturar para el propietario %.', p_id_propietario;
    ELSE
        RAISE NOTICE '% factura(s) generada(s) para propietario %.', v_contador, p_id_propietario;

        -- Reinicializar bandera de descuento tras facturar
        IF v_tiene_descuento THEN
            UPDATE propietario
               SET propietario_con_descuento_proxima_facturacion = FALSE
             WHERE id_propietario = p_id_propietario;
            RAISE NOTICE 'Descuento aplicado y bandera reinicializada para %.', p_id_propietario;
        END IF;
    END IF;
END;
$$;


-- ================================================================
-- PUNTO 5a: sp_validar_certificacion_veterinaria
-- Verifica si un caballo tiene certificación veterinaria vigente.
-- ================================================================

CREATE OR REPLACE PROCEDURE sp_validar_certificacion_veterinaria(
    p_id_caballo VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_vencimiento DATE;
BEGIN
    SELECT MAX(fecha_vencimiento_certificacion)
      INTO v_vencimiento
      FROM historial_veterinario
     WHERE id_caballo = p_id_caballo;

    IF v_vencimiento IS NULL THEN
        RAISE EXCEPTION 'Caballo % no tiene historial veterinario registrado.', p_id_caballo;
    END IF;

    IF v_vencimiento < CURRENT_DATE THEN
        RAISE EXCEPTION 'Certificación veterinaria del caballo % venció el %. No puede inscribirse.',
                        p_id_caballo, v_vencimiento;
    END IF;

    RAISE NOTICE 'Caballo % — certificación válida hasta el %.', p_id_caballo, v_vencimiento;
END;
$$;


-- ================================================================
-- VERIFICACIÓN
-- ================================================================

SELECT routine_name, routine_type
  FROM information_schema.routines
 WHERE routine_schema = 'public'
   AND routine_name IN (
       'sp_marcar_propietarios_frecuentes',
       'sp_insertar_factura',
       'sp_facturar_propietario',
       'sp_validar_certificacion_veterinaria',
       'sp_calcular_premios'
   )
 ORDER BY routine_name;
