-- ================================================================
-- BITÁCORAS PARTICIONADAS POR TRIMESTRE
-- Rúbrica puntos 8 y 9 — Valor 3%
-- Para TODAS las tablas del modelo con más de 5 campos:
--   caballo (9), evento (7), inscripcion (6),
--   historial_veterinario (7), factura (9), alimentacion (6),
--   resultado_carrera (6), alerta_veterinaria (6)
-- ================================================================
-- Ejecutar en Supabase > SQL Editor
-- ================================================================


-- ================================================================
-- PASO 0: Limpiar versiones anteriores (si existen)
-- ================================================================
DROP TABLE IF EXISTS bitacora_caballo               CASCADE;
DROP TABLE IF EXISTS bitacora_evento                CASCADE;
DROP TABLE IF EXISTS bitacora_inscripcion           CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario CASCADE;
DROP TABLE IF EXISTS bitacora_factura               CASCADE;
DROP TABLE IF EXISTS bitacora_alimentacion          CASCADE;
DROP TABLE IF EXISTS bitacora_resultado_carrera     CASCADE;
DROP TABLE IF EXISTS bitacora_alerta_veterinaria    CASCADE;

-- También eliminar las creadas manualmente con nombre en plural
DROP TABLE IF EXISTS bitacora_caballos              CASCADE;
DROP TABLE IF EXISTS bitacora_eventos               CASCADE;
DROP TABLE IF EXISTS bitacora_facturas              CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios          CASCADE;
DROP TABLE IF EXISTS bitacora_suministros           CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q1               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q2               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q3               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q4               CASCADE;


-- ================================================================
-- 1. bitacora_caballo  (9 campos — tabla: caballo)
-- ================================================================

CREATE TABLE bitacora_caballo (
    id_caballo       VARCHAR(20),
    nombre           VARCHAR(100),
    fecha_nacimiento DATE,
    sexo             CHAR(1),
    raza             VARCHAR(50),
    peso             DECIMAL(10,2),
    estado_salud     VARCHAR(30),
    id_propietario   VARCHAR(20),
    id_establo       VARCHAR(20),
    usuario          VARCHAR(100) DEFAULT CURRENT_USER,
    accion           VARCHAR(10)  NOT NULL,
    fecha_registro   TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_caballo_2025_q1 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_caballo_2025_q2 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_caballo_2025_q3 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_caballo_2025_q4 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_caballo_2026_q1 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_caballo_2026_q2 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_caballo_2026_q3 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_caballo_2026_q4 PARTITION OF bitacora_caballo
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_caballo_default PARTITION OF bitacora_caballo DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_caballo()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row caballo%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_caballo (
        id_caballo, nombre, fecha_nacimiento, sexo, raza,
        peso, estado_salud, id_propietario, id_establo,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_caballo, v_row.nombre, v_row.fecha_nacimiento, v_row.sexo, v_row.raza,
        v_row.peso, v_row.estado_salud, v_row.id_propietario, v_row.id_establo,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_caballo ON caballo;
CREATE TRIGGER tr_bitacora_caballo
AFTER INSERT OR UPDATE OR DELETE ON caballo
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_caballo();


-- ================================================================
-- 2. bitacora_evento  (7 campos — tabla: evento)
-- ================================================================

CREATE TABLE bitacora_evento (
    id_evento    VARCHAR(20),
    nombre       VARCHAR(200),
    fecha        TIMESTAMP,
    tipo_carrera VARCHAR(50),
    distancia    INT,
    premio_total DECIMAL(12,2),
    estado       VARCHAR(30),
    usuario      VARCHAR(100) DEFAULT CURRENT_USER,
    accion       VARCHAR(10)  NOT NULL,
    fecha_registro TIMESTAMP  NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_evento_2025_q1 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_evento_2025_q2 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_evento_2025_q3 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_evento_2025_q4 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_evento_2026_q1 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_evento_2026_q2 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_evento_2026_q3 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_evento_2026_q4 PARTITION OF bitacora_evento
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_evento_default PARTITION OF bitacora_evento DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_evento()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row evento%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_evento (
        id_evento, nombre, fecha, tipo_carrera, distancia, premio_total, estado,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_evento, v_row.nombre, v_row.fecha, v_row.tipo_carrera,
        v_row.distancia, v_row.premio_total, v_row.estado,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_evento ON evento;
CREATE TRIGGER tr_bitacora_evento
AFTER INSERT OR UPDATE OR DELETE ON evento
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_evento();


-- ================================================================
-- 3. bitacora_inscripcion  (6 campos — tabla: inscripcion)
-- ================================================================

CREATE TABLE bitacora_inscripcion (
    id_inscripcion    VARCHAR(20),
    id_evento         VARCHAR(20),
    id_caballo        VARCHAR(20),
    fecha_inscripcion DATE,
    estado            VARCHAR(30),
    posicion_final    INT,
    usuario           VARCHAR(100) DEFAULT CURRENT_USER,
    accion            VARCHAR(10)  NOT NULL,
    fecha_registro    TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_inscripcion_2025_q1 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_inscripcion_2025_q2 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_inscripcion_2025_q3 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_inscripcion_2025_q4 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_inscripcion_2026_q1 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_inscripcion_2026_q2 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_inscripcion_2026_q3 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_inscripcion_2026_q4 PARTITION OF bitacora_inscripcion
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_inscripcion_default PARTITION OF bitacora_inscripcion DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_inscripcion()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row inscripcion%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_inscripcion (
        id_inscripcion, id_evento, id_caballo, fecha_inscripcion, estado, posicion_final,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_inscripcion, v_row.id_evento, v_row.id_caballo,
        v_row.fecha_inscripcion, v_row.estado, v_row.posicion_final,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_inscripcion ON inscripcion;
CREATE TRIGGER tr_bitacora_inscripcion
AFTER INSERT OR UPDATE OR DELETE ON inscripcion
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_inscripcion();


-- ================================================================
-- 4. bitacora_historial_veterinario  (7 campos)
-- ================================================================

CREATE TABLE bitacora_historial_veterinario (
    id_registro                     VARCHAR(20),
    id_caballo                      VARCHAR(20),
    diagnostico                     VARCHAR(300),
    tratamiento                     VARCHAR(300),
    fecha_revision                  DATE,
    fecha_vencimiento_certificacion DATE,
    veterinario_responsable         VARCHAR(150),
    usuario                         VARCHAR(100) DEFAULT CURRENT_USER,
    accion                          VARCHAR(10)  NOT NULL,
    fecha_registro                  TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_historial_veterinario_2025_q1 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_historial_veterinario_2025_q2 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_historial_veterinario_2025_q3 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_historial_veterinario_2025_q4 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_historial_veterinario_2026_q1 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_historial_veterinario_2026_q2 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_historial_veterinario_2026_q3 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_historial_veterinario_2026_q4 PARTITION OF bitacora_historial_veterinario
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_historial_veterinario_default PARTITION OF bitacora_historial_veterinario DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_historial_veterinario()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row historial_veterinario%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_historial_veterinario (
        id_registro, id_caballo, diagnostico, tratamiento,
        fecha_revision, fecha_vencimiento_certificacion, veterinario_responsable,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_registro, v_row.id_caballo, v_row.diagnostico, v_row.tratamiento,
        v_row.fecha_revision, v_row.fecha_vencimiento_certificacion, v_row.veterinario_responsable,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_historial_veterinario ON historial_veterinario;
CREATE TRIGGER tr_bitacora_historial_veterinario
AFTER INSERT OR UPDATE OR DELETE ON historial_veterinario
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_historial_veterinario();


-- ================================================================
-- 5. bitacora_factura  (9 campos — tabla: factura)
-- ================================================================

CREATE TABLE bitacora_factura (
    id_factura     VARCHAR(20),
    id_propietario VARCHAR(20),
    id_evento      VARCHAR(20),
    subtotal       DECIMAL(12,2),
    descuento      DECIMAL(12,2),
    impuestos      DECIMAL(12,2),
    total          DECIMAL(12,2),
    estado_pago    VARCHAR(30),
    fecha_emision  TIMESTAMP,
    usuario        VARCHAR(100) DEFAULT CURRENT_USER,
    accion         VARCHAR(10)  NOT NULL,
    fecha_registro TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_factura_2025_q1 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_factura_2025_q2 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_factura_2025_q3 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_factura_2025_q4 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_factura_2026_q1 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_factura_2026_q2 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_factura_2026_q3 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_factura_2026_q4 PARTITION OF bitacora_factura
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_factura_default PARTITION OF bitacora_factura DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_factura()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row factura%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_factura (
        id_factura, id_propietario, id_evento, subtotal, descuento,
        impuestos, total, estado_pago, fecha_emision,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_factura, v_row.id_propietario, v_row.id_evento, v_row.subtotal, v_row.descuento,
        v_row.impuestos, v_row.total, v_row.estado_pago, v_row.fecha_emision,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_factura ON factura;
CREATE TRIGGER tr_bitacora_factura
AFTER INSERT OR UPDATE OR DELETE ON factura
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_factura();


-- ================================================================
-- 6. bitacora_alimentacion  (6 campos — tabla: alimentacion)
-- ================================================================

CREATE TABLE bitacora_alimentacion (
    id_alimentacion BIGINT,
    id_caballo      VARCHAR(20),
    id_suministro   VARCHAR(20),
    tipo_alimento   VARCHAR(50),
    cantidad        DECIMAL(10,2),
    fecha           DATE,
    usuario         VARCHAR(100) DEFAULT CURRENT_USER,
    accion          VARCHAR(10)  NOT NULL,
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_alimentacion_2025_q1 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_alimentacion_2025_q2 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_alimentacion_2025_q3 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_alimentacion_2025_q4 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_alimentacion_2026_q1 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_alimentacion_2026_q2 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_alimentacion_2026_q3 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_alimentacion_2026_q4 PARTITION OF bitacora_alimentacion
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_alimentacion_default PARTITION OF bitacora_alimentacion DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_alimentacion()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row alimentacion%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_alimentacion (
        id_alimentacion, id_caballo, id_suministro, tipo_alimento, cantidad, fecha,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_alimentacion, v_row.id_caballo, v_row.id_suministro,
        v_row.tipo_alimento, v_row.cantidad, v_row.fecha,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_alimentacion ON alimentacion;
CREATE TRIGGER tr_bitacora_alimentacion
AFTER INSERT OR UPDATE OR DELETE ON alimentacion
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_alimentacion();


-- ================================================================
-- 7. bitacora_resultado_carrera  (6 campos)
-- ================================================================

CREATE TABLE bitacora_resultado_carrera (
    id_resultado   BIGINT,
    id_evento      VARCHAR(20),
    id_caballo     VARCHAR(20),
    posicion       INT,
    tiempo         VARCHAR(20),
    premio_ganado  DECIMAL(12,2),
    usuario        VARCHAR(100) DEFAULT CURRENT_USER,
    accion         VARCHAR(10)  NOT NULL,
    fecha_registro TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_resultado_carrera_2025_q1 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_resultado_carrera_2025_q2 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_resultado_carrera_2025_q3 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_resultado_carrera_2025_q4 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_resultado_carrera_2026_q1 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_resultado_carrera_2026_q2 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_resultado_carrera_2026_q3 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_resultado_carrera_2026_q4 PARTITION OF bitacora_resultado_carrera
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_resultado_carrera_default PARTITION OF bitacora_resultado_carrera DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_resultado_carrera()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row resultado_carrera%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_resultado_carrera (
        id_resultado, id_evento, id_caballo, posicion, tiempo, premio_ganado,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_resultado, v_row.id_evento, v_row.id_caballo,
        v_row.posicion, v_row.tiempo, v_row.premio_ganado,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_resultado_carrera ON resultado_carrera;
CREATE TRIGGER tr_bitacora_resultado_carrera
AFTER INSERT OR UPDATE OR DELETE ON resultado_carrera
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_resultado_carrera();


-- ================================================================
-- 8. bitacora_alerta_veterinaria  (6 campos)
-- ================================================================

CREATE TABLE bitacora_alerta_veterinaria (
    id_alerta      BIGINT,
    id_caballo     VARCHAR(20),
    id_propietario VARCHAR(20),
    mensaje        TEXT,
    leida          BOOLEAN,
    fecha_alerta   TIMESTAMP,
    usuario        VARCHAR(100) DEFAULT CURRENT_USER,
    accion         VARCHAR(10)  NOT NULL,
    fecha_registro TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_alerta_veterinaria_2025_q1 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q2 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q3 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q4 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q1 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q2 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q3 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q4 PARTITION OF bitacora_alerta_veterinaria
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
CREATE TABLE bitacora_alerta_veterinaria_default PARTITION OF bitacora_alerta_veterinaria DEFAULT;

CREATE OR REPLACE FUNCTION fn_bitacora_alerta_veterinaria()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE v_row alerta_veterinaria%ROWTYPE;
BEGIN
    IF TG_OP = 'DELETE' THEN v_row := OLD; ELSE v_row := NEW; END IF;
    INSERT INTO bitacora_alerta_veterinaria (
        id_alerta, id_caballo, id_propietario, mensaje, leida, fecha_alerta,
        usuario, accion, fecha_registro
    ) VALUES (
        v_row.id_alerta, v_row.id_caballo, v_row.id_propietario,
        v_row.mensaje, v_row.leida, v_row.fecha_alerta,
        CURRENT_USER, TG_OP, NOW()
    );
    RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;

DROP TRIGGER IF EXISTS tr_bitacora_alerta_veterinaria ON alerta_veterinaria;
CREATE TRIGGER tr_bitacora_alerta_veterinaria
AFTER INSERT OR UPDATE OR DELETE ON alerta_veterinaria
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_alerta_veterinaria();


-- ================================================================
-- VERIFICACIÓN FINAL
-- ================================================================
SELECT
    parent.relname  AS bitacora,
    child.relname   AS particion,
    pg_get_expr(child.relpartbound, child.oid) AS rango
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child  ON pg_inherits.inhrelid  = child.oid
WHERE parent.relname LIKE 'bitacora_%'
ORDER BY parent.relname, child.relname;
