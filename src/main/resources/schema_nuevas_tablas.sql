-- Tablas y stored procedures para los 5 módulos nuevos del sistema Hipódromo Nacional.
-- Ejecutar en Supabase SQL Editor ANTES de usar los módulos nuevos.
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia

-- ─────────────────────────────────────────────────────────────
-- TABLAS
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS suministro (
    id_suministro       VARCHAR(20)   PRIMARY KEY,
    tipo                VARCHAR(50),
    proveedor           VARCHAR(100),
    cantidad_disponible INTEGER       DEFAULT 0,
    precio_unitario     DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS alimentacion (
    id_alimentacion BIGSERIAL     PRIMARY KEY,
    id_caballo      VARCHAR(20)   REFERENCES caballo(id_caballo),
    id_suministro   VARCHAR(20)   REFERENCES suministro(id_suministro),
    tipo_alimento   VARCHAR(50),
    cantidad        DECIMAL(10,2),
    fecha           DATE
);

CREATE TABLE IF NOT EXISTS resultado_carrera (
    id_resultado  BIGSERIAL     PRIMARY KEY,
    id_evento     VARCHAR(20)   REFERENCES evento(id_evento),
    id_caballo    VARCHAR(20)   REFERENCES caballo(id_caballo),
    posicion      INTEGER,
    tiempo        VARCHAR(20),
    premio_ganado DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS alerta_veterinaria (
    id_alerta      BIGSERIAL     PRIMARY KEY,
    id_caballo     VARCHAR(20)   REFERENCES caballo(id_caballo),
    id_propietario VARCHAR(20)   REFERENCES propietario(id_propietario),
    mensaje        TEXT,
    leida          BOOLEAN       DEFAULT FALSE,
    fecha_alerta   TIMESTAMP     DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS historial_transaccion (
    id_transaccion BIGSERIAL     PRIMARY KEY,
    id_factura     VARCHAR(20)   REFERENCES factura(id_factura),
    monto          DECIMAL(12,2),
    metodo_pago    VARCHAR(30),
    fecha_pago     DATE
);

-- ─────────────────────────────────────────────────────────────
-- STORED PROCEDURES — SUMINISTRO
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE PROCEDURE sp_insertar_suministro(
    p_id        VARCHAR,
    p_tipo      VARCHAR,
    p_proveedor VARCHAR,
    p_cantidad  INTEGER,
    p_precio    DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO suministro (id_suministro, tipo, proveedor, cantidad_disponible, precio_unitario)
    VALUES (p_id, p_tipo, p_proveedor, p_cantidad, p_precio);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_suministro(
    p_id       VARCHAR,
    p_cantidad INTEGER,
    p_precio   DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE suministro
       SET cantidad_disponible = p_cantidad,
           precio_unitario     = p_precio
     WHERE id_suministro = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_suministro(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM suministro WHERE id_suministro = p_id;
END;
$$;

-- ─────────────────────────────────────────────────────────────
-- STORED PROCEDURES — ALIMENTACION
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE PROCEDURE sp_insertar_alimentacion(
    p_id_caballo    VARCHAR,
    p_id_suministro VARCHAR,
    p_tipo_alimento VARCHAR,
    p_cantidad      DECIMAL,
    p_fecha         DATE
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO alimentacion (id_caballo, id_suministro, tipo_alimento, cantidad, fecha)
    VALUES (p_id_caballo, p_id_suministro, p_tipo_alimento, p_cantidad, p_fecha);

    -- Descuenta del inventario
    UPDATE suministro
       SET cantidad_disponible = cantidad_disponible - FLOOR(p_cantidad)::INTEGER
     WHERE id_suministro = p_id_suministro;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_alimentacion(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM alimentacion WHERE id_alimentacion = p_id;
END;
$$;

-- ─────────────────────────────────────────────────────────────
-- STORED PROCEDURES — RESULTADO CARRERA
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE PROCEDURE sp_insertar_resultado(
    p_id_evento  VARCHAR,
    p_id_caballo VARCHAR,
    p_posicion   INTEGER,
    p_tiempo     VARCHAR,
    p_premio     DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO resultado_carrera (id_evento, id_caballo, posicion, tiempo, premio_ganado)
    VALUES (p_id_evento, p_id_caballo, p_posicion, p_tiempo, p_premio);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_resultado(
    p_id       BIGINT,
    p_posicion INTEGER,
    p_tiempo   VARCHAR,
    p_premio   DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE resultado_carrera
       SET posicion      = p_posicion,
           tiempo        = p_tiempo,
           premio_ganado = p_premio
     WHERE id_resultado = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_resultado(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM resultado_carrera WHERE id_resultado = p_id;
END;
$$;

-- ─────────────────────────────────────────────────────────────
-- STORED PROCEDURES — ALERTA VETERINARIA
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE PROCEDURE sp_insertar_alerta(
    p_id_caballo     VARCHAR,
    p_id_propietario VARCHAR,
    p_mensaje        TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO alerta_veterinaria (id_caballo, id_propietario, mensaje, leida, fecha_alerta)
    VALUES (p_id_caballo, p_id_propietario, p_mensaje, FALSE, NOW());
END;
$$;

CREATE OR REPLACE PROCEDURE sp_marcar_alerta_leida(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE alerta_veterinaria SET leida = TRUE WHERE id_alerta = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_alerta(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM alerta_veterinaria WHERE id_alerta = p_id;
END;
$$;

-- ─────────────────────────────────────────────────────────────
-- STORED PROCEDURES — HISTORIAL TRANSACCION
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
    p_id_factura   VARCHAR,
    p_monto        DECIMAL,
    p_metodo_pago  VARCHAR,
    p_fecha_pago   DATE
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO historial_transaccion (id_factura, monto, metodo_pago, fecha_pago)
    VALUES (p_id_factura, p_monto, p_metodo_pago, p_fecha_pago);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_transaccion(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM historial_transaccion WHERE id_transaccion = p_id;
END;
$$;

-- ─────────────────────────────────────────────────────────────
-- VERIFICACION
-- ─────────────────────────────────────────────────────────────
SELECT table_name
  FROM information_schema.tables
 WHERE table_schema = 'public'
   AND table_name IN ('suministro','alimentacion','resultado_carrera',
                      'alerta_veterinaria','historial_transaccion')
 ORDER BY table_name;
