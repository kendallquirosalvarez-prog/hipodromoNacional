-- =============================================================
-- SCHEMA COMPLETO — SISTEMA HIPÓDROMO NACIONAL
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia
-- Ejecutar en Supabase SQL Editor (en el orden que aparece)
-- =============================================================


-- =============================================================
-- TABLAS GEOGRÁFICAS
-- =============================================================

CREATE TABLE IF NOT EXISTS pais (
    id_pais      SERIAL       PRIMARY KEY,
    nombre_pais  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS provincia (
    id_provincia      SERIAL       PRIMARY KEY,
    nombre_provincia  VARCHAR(100) NOT NULL,
    id_pais           INT          NOT NULL REFERENCES pais(id_pais)
);

CREATE TABLE IF NOT EXISTS canton (
    id_canton      SERIAL       PRIMARY KEY,
    nombre_canton  VARCHAR(100) NOT NULL,
    id_provincia   INT          NOT NULL REFERENCES provincia(id_provincia)
);

CREATE TABLE IF NOT EXISTS distrito (
    id_distrito      SERIAL       PRIMARY KEY,
    nombre_distrito  VARCHAR(100) NOT NULL,
    id_canton        INT          NOT NULL REFERENCES canton(id_canton)
);

CREATE TABLE IF NOT EXISTS barrio (
    id_barrio      SERIAL       PRIMARY KEY,
    nombre_barrio  VARCHAR(100) NOT NULL,
    id_distrito    INT          NOT NULL REFERENCES distrito(id_distrito)
);


-- =============================================================
-- TABLAS PRINCIPALES
-- =============================================================

CREATE TABLE IF NOT EXISTS propietario (
    id_propietario                              VARCHAR(20)  PRIMARY KEY,
    nombre                                      VARCHAR(100) NOT NULL,
    apellidos                                   VARCHAR(100) NOT NULL,
    id_barrio                                   INT          REFERENCES barrio(id_barrio),
    propietario_con_descuento_proxima_facturacion BOOLEAN    DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS establo (
    id_establo  VARCHAR(20)  PRIMARY KEY,
    capacidad   INT          NOT NULL,
    estado      VARCHAR(50)  NOT NULL,
    id_barrio   INT          REFERENCES barrio(id_barrio)
);

CREATE TABLE IF NOT EXISTS caballo (
    id_caballo       VARCHAR(20)   PRIMARY KEY,
    nombre           VARCHAR(100)  NOT NULL,
    fecha_nacimiento DATE,
    sexo             CHAR(1),
    raza             VARCHAR(50),
    peso             DECIMAL(10,2),
    estado_salud     VARCHAR(30),
    id_propietario   VARCHAR(20)   REFERENCES propietario(id_propietario),
    id_establo       VARCHAR(20)   REFERENCES establo(id_establo)
);

CREATE TABLE IF NOT EXISTS evento (
    id_evento    VARCHAR(20)   PRIMARY KEY,
    nombre       VARCHAR(200)  NOT NULL,
    fecha        TIMESTAMP     NOT NULL,
    tipo_carrera VARCHAR(50),
    distancia    INT,
    premio_total DECIMAL(12,2),
    estado       VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS inscripcion (
    id_inscripcion    VARCHAR(20)  PRIMARY KEY,
    id_evento         VARCHAR(20)  REFERENCES evento(id_evento),
    id_caballo        VARCHAR(20)  REFERENCES caballo(id_caballo),
    fecha_inscripcion DATE,
    estado            VARCHAR(30),
    posicion_final    INT
);

CREATE TABLE IF NOT EXISTS historial_veterinario (
    id_registro                  VARCHAR(20)  PRIMARY KEY,
    id_caballo                   VARCHAR(20)  REFERENCES caballo(id_caballo),
    diagnostico                  VARCHAR(300),
    tratamiento                  VARCHAR(300),
    fecha_revision               DATE,
    fecha_vencimiento_certificacion DATE,
    veterinario_responsable      VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS factura (
    id_factura     VARCHAR(20)   PRIMARY KEY,
    id_propietario VARCHAR(20)   REFERENCES propietario(id_propietario),
    id_evento      VARCHAR(20)   REFERENCES evento(id_evento),
    subtotal       DECIMAL(12,2),
    descuento      DECIMAL(12,2) DEFAULT 0,
    impuestos      DECIMAL(12,2),
    total          DECIMAL(12,2),
    estado_pago    VARCHAR(30),
    fecha_emision  TIMESTAMP     DEFAULT NOW()
);


-- =============================================================
-- TABLAS NUEVAS (segunda fase)
-- =============================================================

CREATE TABLE IF NOT EXISTS suministro (
    id_suministro       VARCHAR(20)   PRIMARY KEY,
    tipo                VARCHAR(50),
    proveedor           VARCHAR(100),
    cantidad_disponible INT           DEFAULT 0,
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
    posicion      INT,
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


-- =============================================================
-- TABLA DE USUARIOS (Spring Security)
-- =============================================================

CREATE TABLE IF NOT EXISTS usuarios (
    username  VARCHAR(50)  PRIMARY KEY,
    password  VARCHAR(255) NOT NULL,
    nombre    VARCHAR(150) NOT NULL,
    rol       VARCHAR(50)  NOT NULL,
    activo    BOOLEAN      DEFAULT TRUE
);


-- =============================================================
-- STORED PROCEDURES — PROPIETARIO
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_propietario(
    p_id         VARCHAR,
    p_nombre     VARCHAR,
    p_apellidos  VARCHAR,
    p_id_barrio  INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO propietario (id_propietario, nombre, apellidos, id_barrio)
    VALUES (p_id, p_nombre, p_apellidos, p_id_barrio);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_propietario(
    p_id         VARCHAR,
    p_nombre     VARCHAR,
    p_apellidos  VARCHAR,
    p_id_barrio  INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE propietario
       SET nombre    = p_nombre,
           apellidos = p_apellidos,
           id_barrio = p_id_barrio
     WHERE id_propietario = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_propietario(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM propietario WHERE id_propietario = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — ESTABLO
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_establo(
    p_id        VARCHAR,
    p_capacidad INTEGER,
    p_estado    VARCHAR,
    p_id_barrio INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO establo (id_establo, capacidad, estado, id_barrio)
    VALUES (p_id, p_capacidad, p_estado, p_id_barrio);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_establo(
    p_id        VARCHAR,
    p_capacidad INTEGER,
    p_estado    VARCHAR,
    p_id_barrio INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE establo
       SET capacidad = p_capacidad,
           estado    = p_estado,
           id_barrio = p_id_barrio
     WHERE id_establo = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_establo(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM establo WHERE id_establo = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — CABALLO
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_caballo(
    p_id               VARCHAR,
    p_nombre           VARCHAR,
    p_fecha_nacimiento DATE,
    p_sexo             VARCHAR,
    p_raza             VARCHAR,
    p_peso             DECIMAL,
    p_estado_salud     VARCHAR,
    p_id_propietario   VARCHAR,
    p_id_establo       VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO caballo (id_caballo, nombre, fecha_nacimiento, sexo, raza,
                         peso, estado_salud, id_propietario, id_establo)
    VALUES (p_id, p_nombre, p_fecha_nacimiento, p_sexo, p_raza,
            p_peso, p_estado_salud, p_id_propietario, p_id_establo);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_caballo(
    p_id           VARCHAR,
    p_peso         DECIMAL,
    p_estado_salud VARCHAR,
    p_id_establo   VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE caballo
       SET peso         = p_peso,
           estado_salud = p_estado_salud,
           id_establo   = p_id_establo
     WHERE id_caballo = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_caballo(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM caballo WHERE id_caballo = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — EVENTO
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_evento(
    p_id          VARCHAR,
    p_nombre      VARCHAR,
    p_fecha       TIMESTAMP,
    p_tipo_carrera VARCHAR,
    p_distancia   INTEGER,
    p_premio_total DECIMAL,
    p_estado      VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO evento (id_evento, nombre, fecha, tipo_carrera, distancia, premio_total, estado)
    VALUES (p_id, p_nombre, p_fecha, p_tipo_carrera, p_distancia, p_premio_total, p_estado);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_evento(
    p_id           VARCHAR,
    p_fecha        TIMESTAMP,
    p_premio_total DECIMAL,
    p_estado       VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE evento
       SET fecha        = p_fecha,
           premio_total = p_premio_total,
           estado       = p_estado
     WHERE id_evento = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_evento(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM evento WHERE id_evento = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — INSCRIPCION
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_inscripcion(
    p_id         VARCHAR,
    p_id_evento  VARCHAR,
    p_id_caballo VARCHAR,
    p_fecha      DATE,
    p_estado     VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM historial_veterinario
         WHERE id_caballo = p_id_caballo
           AND fecha_vencimiento_certificacion >= CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'El caballo no tiene certificación veterinaria vigente.';
    END IF;

    INSERT INTO inscripcion (id_inscripcion, id_evento, id_caballo, fecha_inscripcion, estado)
    VALUES (p_id, p_id_evento, p_id_caballo, p_fecha, p_estado);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_inscripcion(
    p_id            VARCHAR,
    p_estado        VARCHAR,
    p_posicion_final INTEGER,
    p_tiempo        VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE inscripcion
       SET estado         = p_estado,
           posicion_final = p_posicion_final
     WHERE id_inscripcion = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_inscripcion(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM inscripcion WHERE id_inscripcion = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — HISTORIAL VETERINARIO
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_historial_veterinario(
    p_id                VARCHAR,
    p_id_caballo        VARCHAR,
    p_diagnostico       VARCHAR,
    p_tratamiento       VARCHAR,
    p_fecha_revision    DATE,
    p_fecha_vencimiento DATE,
    p_veterinario       VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO historial_veterinario (
        id_registro, id_caballo, diagnostico, tratamiento,
        fecha_revision, fecha_vencimiento_certificacion, veterinario_responsable
    )
    VALUES (p_id, p_id_caballo, p_diagnostico, p_tratamiento,
            p_fecha_revision, p_fecha_vencimiento, p_veterinario);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_historial_veterinario(
    p_id                VARCHAR,
    p_diagnostico       VARCHAR,
    p_tratamiento       VARCHAR,
    p_fecha_vencimiento DATE
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE historial_veterinario
       SET diagnostico                    = p_diagnostico,
           tratamiento                    = p_tratamiento,
           fecha_vencimiento_certificacion = p_fecha_vencimiento
     WHERE id_registro = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_historial_veterinario(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM historial_veterinario WHERE id_registro = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — FACTURA
-- =============================================================

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
BEGIN
    IF ABS(p_impuestos - (p_subtotal - p_descuento) * 0.13) > 0.01 THEN
        RAISE EXCEPTION 'El IVA debe ser el 13%% del subtotal neto.';
    END IF;

    INSERT INTO factura (id_factura, id_propietario, id_evento,
                         subtotal, descuento, impuestos, total, estado_pago)
    VALUES (p_id, p_id_propietario, p_id_evento,
            p_subtotal, p_descuento, p_impuestos, p_total, p_estado_pago);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_actualizar_factura(
    p_id          VARCHAR,
    p_descuento   DECIMAL,
    p_total       DECIMAL,
    p_estado_pago VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE factura
       SET descuento   = p_descuento,
           total       = p_total,
           estado_pago = p_estado_pago
     WHERE id_factura = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_eliminar_factura(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM factura WHERE id_factura = p_id;
END;
$$;


-- =============================================================
-- STORED PROCEDURES — SUMINISTRO
-- =============================================================

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


-- =============================================================
-- STORED PROCEDURES — ALIMENTACION
-- =============================================================

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


-- =============================================================
-- STORED PROCEDURES — RESULTADO CARRERA
-- =============================================================

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


-- =============================================================
-- STORED PROCEDURES — ALERTA VETERINARIA
-- =============================================================

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


-- =============================================================
-- STORED PROCEDURES — HISTORIAL TRANSACCION
-- =============================================================

CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
    p_id_factura  VARCHAR,
    p_monto       DECIMAL,
    p_metodo_pago VARCHAR,
    p_fecha_pago  DATE
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


-- =============================================================
-- TRIGGER DE AUDITORÍA
-- =============================================================

CREATE TABLE IF NOT EXISTS bitacora_auditoria (
    id_bitacora     BIGSERIAL    PRIMARY KEY,
    tabla_afectada  VARCHAR(50)  NOT NULL,
    operacion       VARCHAR(10)  NOT NULL,
    datos_anteriores TEXT,
    datos_nuevos     TEXT,
    usuario_bd       VARCHAR(100),
    fecha_hora       TIMESTAMP   DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_registrar_auditoria()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO bitacora_auditoria (
        tabla_afectada, operacion, datos_anteriores, datos_nuevos, usuario_bd, fecha_hora
    )
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP != 'INSERT' THEN row_to_json(OLD)::TEXT ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW)::TEXT ELSE NULL END,
        CURRENT_USER,
        NOW()
    );
    RETURN NEW;
END;
$$;

-- Asociar el trigger a las tablas principales
DO $$
DECLARE
    t TEXT;
BEGIN
    FOREACH t IN ARRAY ARRAY['propietario','caballo','establo','evento',
                              'inscripcion','historial_veterinario','factura',
                              'suministro','alimentacion','resultado_carrera',
                              'alerta_veterinaria','historial_transaccion']
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS tr_auditoria_%1$s ON %1$s;
             CREATE TRIGGER tr_auditoria_%1$s
             AFTER INSERT OR UPDATE OR DELETE ON %1$s
             FOR EACH ROW EXECUTE FUNCTION fn_registrar_auditoria();', t);
    END LOOP;
END;
$$;


-- =============================================================
-- TRIGGER: ALERTA AUTOMÁTICA POR VENCIMIENTO DE CERTIFICACIÓN
-- =============================================================

CREATE OR REPLACE FUNCTION fn_alerta_vencimiento()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.fecha_vencimiento_certificacion <= CURRENT_DATE + INTERVAL '30 days' THEN
        INSERT INTO alerta_veterinaria (id_caballo, id_propietario, mensaje, leida, fecha_alerta)
        SELECT NEW.id_caballo,
               c.id_propietario,
               'Certificación vence el ' || NEW.fecha_vencimiento_certificacion ||
               ' — programar revisión veterinaria.',
               FALSE,
               NOW()
          FROM caballo c
         WHERE c.id_caballo = NEW.id_caballo;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_alerta_vencimiento ON historial_veterinario;
CREATE TRIGGER tr_alerta_vencimiento
AFTER INSERT OR UPDATE OF fecha_vencimiento_certificacion ON historial_veterinario
FOR EACH ROW EXECUTE FUNCTION fn_alerta_vencimiento();


-- =============================================================
-- TRIGGER: DESCUENTO AUTOMÁTICO POR CLIENTE FRECUENTE
-- =============================================================

CREATE OR REPLACE FUNCTION fn_descuento_frecuente()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_total_6m DECIMAL;
BEGIN
    SELECT COALESCE(SUM(total), 0) INTO v_total_6m
      FROM factura
     WHERE id_propietario = NEW.id_propietario
       AND fecha_emision >= NOW() - INTERVAL '6 months'
       AND estado_pago = 'Pagado';

    IF v_total_6m > 500000 THEN
        UPDATE propietario
           SET propietario_con_descuento_proxima_facturacion = TRUE
         WHERE id_propietario = NEW.id_propietario;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_descuento_frecuente ON factura;
CREATE TRIGGER tr_descuento_frecuente
AFTER INSERT ON factura
FOR EACH ROW EXECUTE FUNCTION fn_descuento_frecuente();


-- =============================================================
-- VERIFICACIÓN FINAL
-- =============================================================

SELECT table_name,
       (SELECT COUNT(*) FROM information_schema.columns
         WHERE table_name = t.table_name
           AND table_schema = 'public') AS columnas
  FROM information_schema.tables t
 WHERE table_schema = 'public'
   AND table_type = 'BASE TABLE'
 ORDER BY table_name;
