-- Hipódromo Nacional — Sistema de Gestión de Carreras
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia · 2026
-- Ejecutar en Supabase > SQL Editor


-- ==============================================================
-- TABLAS
-- ==============================================================

CREATE TABLE IF NOT EXISTS pais (
    id_pais      SERIAL       PRIMARY KEY,
    nombre_pais  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS provincia (
    id_provincia     SERIAL       PRIMARY KEY,
    nombre_provincia VARCHAR(100) NOT NULL,
    id_pais          INT          NOT NULL REFERENCES pais(id_pais)
);

CREATE TABLE IF NOT EXISTS canton (
    id_canton    SERIAL       PRIMARY KEY,
    nombre_canton VARCHAR(100) NOT NULL,
    id_provincia INT          NOT NULL REFERENCES provincia(id_provincia)
);

CREATE TABLE IF NOT EXISTS distrito (
    id_distrito     SERIAL       PRIMARY KEY,
    nombre_distrito VARCHAR(100) NOT NULL,
    id_canton       INT          NOT NULL REFERENCES canton(id_canton)
);

CREATE TABLE IF NOT EXISTS barrio (
    id_barrio     SERIAL       PRIMARY KEY,
    nombre_barrio VARCHAR(100) NOT NULL,
    id_distrito   INT          NOT NULL REFERENCES distrito(id_distrito)
);

CREATE TABLE IF NOT EXISTS propietario (
    id_propietario                                VARCHAR(20)  PRIMARY KEY,
    nombre                                        VARCHAR(100) NOT NULL,
    apellidos                                     VARCHAR(100) NOT NULL,
    id_barrio                                     INT          REFERENCES barrio(id_barrio),
    propietario_con_descuento_proxima_facturacion BOOLEAN      DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS establo (
    id_establo VARCHAR(20) PRIMARY KEY,
    capacidad  INT         NOT NULL,
    estado     VARCHAR(50) NOT NULL,
    id_barrio  INT         REFERENCES barrio(id_barrio)
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
    id_inscripcion    VARCHAR(20) PRIMARY KEY,
    id_evento         VARCHAR(20) REFERENCES evento(id_evento),
    id_caballo        VARCHAR(20) REFERENCES caballo(id_caballo),
    fecha_inscripcion DATE,
    estado            VARCHAR(30),
    posicion_final    INT
);

CREATE TABLE IF NOT EXISTS historial_veterinario (
    id_registro                     VARCHAR(20)  PRIMARY KEY,
    id_caballo                      VARCHAR(20)  REFERENCES caballo(id_caballo),
    diagnostico                     VARCHAR(300),
    tratamiento                     VARCHAR(300),
    fecha_revision                  DATE,
    fecha_vencimiento_certificacion DATE,
    veterinario_responsable         VARCHAR(150)
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
    id_alerta      BIGSERIAL   PRIMARY KEY,
    id_caballo     VARCHAR(20) REFERENCES caballo(id_caballo),
    id_propietario VARCHAR(20) REFERENCES propietario(id_propietario),
    mensaje        TEXT,
    leida          BOOLEAN     DEFAULT FALSE,
    fecha_alerta   TIMESTAMP   DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS historial_transaccion (
    id_transaccion BIGSERIAL     PRIMARY KEY,
    id_factura     VARCHAR(20)   REFERENCES factura(id_factura),
    monto          DECIMAL(12,2),
    metodo_pago    VARCHAR(30),
    fecha_pago     DATE
);

CREATE TABLE IF NOT EXISTS usuarios (
    username VARCHAR(50)  PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nombre   VARCHAR(150) NOT NULL,
    rol      VARCHAR(50)  NOT NULL,
    activo   BOOLEAN      DEFAULT TRUE
);


-- ==============================================================
-- PROCEDIMIENTOS ALMACENADOS — CRUD
-- ==============================================================

-- Propietario

CREATE OR REPLACE PROCEDURE sp_insertar_propietario(
    p_id VARCHAR, p_nombre VARCHAR, p_apellidos VARCHAR, p_id_barrio INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO propietario (id_propietario, nombre, apellidos, id_barrio)
    VALUES (p_id, p_nombre, p_apellidos, p_id_barrio);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_propietario(
    p_id VARCHAR, p_nombre VARCHAR, p_apellidos VARCHAR, p_id_barrio INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE propietario
       SET nombre = p_nombre, apellidos = p_apellidos, id_barrio = p_id_barrio
     WHERE id_propietario = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_propietario(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM propietario WHERE id_propietario = p_id;
END; $$;


-- Establo

CREATE OR REPLACE PROCEDURE sp_insertar_establo(
    p_id VARCHAR, p_capacidad INTEGER, p_estado VARCHAR, p_id_barrio INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO establo (id_establo, capacidad, estado, id_barrio)
    VALUES (p_id, p_capacidad, p_estado, p_id_barrio);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_establo(
    p_id VARCHAR, p_capacidad INTEGER, p_estado VARCHAR, p_id_barrio INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE establo
       SET capacidad = p_capacidad, estado = p_estado, id_barrio = p_id_barrio
     WHERE id_establo = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_establo(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM establo WHERE id_establo = p_id;
END; $$;


-- Caballo

CREATE OR REPLACE PROCEDURE sp_insertar_caballo(
    p_id VARCHAR, p_nombre VARCHAR, p_fecha_nacimiento DATE, p_sexo VARCHAR,
    p_raza VARCHAR, p_peso DECIMAL, p_estado_salud VARCHAR,
    p_id_propietario VARCHAR, p_id_establo VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO caballo (id_caballo, nombre, fecha_nacimiento, sexo, raza,
                         peso, estado_salud, id_propietario, id_establo)
    VALUES (p_id, p_nombre, p_fecha_nacimiento, p_sexo, p_raza,
            p_peso, p_estado_salud, p_id_propietario, p_id_establo);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_caballo(
    p_id VARCHAR, p_peso DECIMAL, p_estado_salud VARCHAR, p_id_establo VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE caballo
       SET peso = p_peso, estado_salud = p_estado_salud, id_establo = p_id_establo
     WHERE id_caballo = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_caballo(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM caballo WHERE id_caballo = p_id;
END; $$;


-- Evento

CREATE OR REPLACE PROCEDURE sp_insertar_evento(
    p_id VARCHAR, p_nombre VARCHAR, p_fecha TIMESTAMP, p_tipo_carrera VARCHAR,
    p_distancia INTEGER, p_premio_total DECIMAL, p_estado VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO evento (id_evento, nombre, fecha, tipo_carrera, distancia, premio_total, estado)
    VALUES (p_id, p_nombre, p_fecha, p_tipo_carrera, p_distancia, p_premio_total, p_estado);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_evento(
    p_id VARCHAR, p_fecha TIMESTAMP, p_premio_total DECIMAL, p_estado VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE evento
       SET fecha = p_fecha, premio_total = p_premio_total, estado = p_estado
     WHERE id_evento = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_evento(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM evento WHERE id_evento = p_id;
END; $$;


-- Inscripción

CREATE OR REPLACE PROCEDURE sp_insertar_inscripcion(
    p_id VARCHAR, p_id_evento VARCHAR, p_id_caballo VARCHAR,
    p_fecha DATE, p_estado VARCHAR
) LANGUAGE plpgsql AS $$
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
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_inscripcion(
    p_id VARCHAR, p_estado VARCHAR, p_posicion_final INTEGER, p_tiempo VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE inscripcion
       SET estado = p_estado, posicion_final = p_posicion_final
     WHERE id_inscripcion = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_inscripcion(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM inscripcion WHERE id_inscripcion = p_id;
END; $$;


-- Historial Veterinario

CREATE OR REPLACE PROCEDURE sp_insertar_historial_veterinario(
    p_id VARCHAR, p_id_caballo VARCHAR, p_diagnostico VARCHAR,
    p_tratamiento VARCHAR, p_fecha_revision DATE,
    p_fecha_vencimiento DATE, p_veterinario VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO historial_veterinario (
        id_registro, id_caballo, diagnostico, tratamiento,
        fecha_revision, fecha_vencimiento_certificacion, veterinario_responsable
    ) VALUES (p_id, p_id_caballo, p_diagnostico, p_tratamiento,
              p_fecha_revision, p_fecha_vencimiento, p_veterinario);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_historial_veterinario(
    p_id VARCHAR, p_diagnostico VARCHAR, p_tratamiento VARCHAR, p_fecha_vencimiento DATE
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE historial_veterinario
       SET diagnostico = p_diagnostico,
           tratamiento = p_tratamiento,
           fecha_vencimiento_certificacion = p_fecha_vencimiento
     WHERE id_registro = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_historial_veterinario(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM historial_veterinario WHERE id_registro = p_id;
END; $$;


-- Factura (incluye descuento 10% para propietarios frecuentes e IVA 13% — Ley 9635 CR)

CREATE SEQUENCE IF NOT EXISTS seq_factura_auto START 1 INCREMENT 1;

CREATE OR REPLACE PROCEDURE sp_insertar_factura(
    p_id VARCHAR, p_id_propietario VARCHAR, p_id_evento VARCHAR,
    p_subtotal DECIMAL, p_descuento DECIMAL, p_impuestos DECIMAL,
    p_total DECIMAL, p_estado_pago VARCHAR
) LANGUAGE plpgsql AS $$
DECLARE
    v_tiene_descuento BOOLEAN := FALSE;
    v_descuento_final DECIMAL;
    v_impuestos_final DECIMAL;
    v_total_final     DECIMAL;
BEGIN
    SELECT propietario_con_descuento_proxima_facturacion
      INTO v_tiene_descuento
      FROM propietario
     WHERE id_propietario = p_id_propietario;

    IF v_tiene_descuento THEN
        v_descuento_final := ROUND(p_descuento + p_subtotal * 0.10, 2);
    ELSE
        v_descuento_final := p_descuento;
    END IF;

    v_impuestos_final := ROUND((p_subtotal - v_descuento_final) * 0.13, 2);
    v_total_final     := ROUND(p_subtotal - v_descuento_final + v_impuestos_final, 2);

    INSERT INTO factura (
        id_factura, id_propietario, id_evento,
        subtotal, descuento, impuestos, total, estado_pago
    ) VALUES (
        p_id, p_id_propietario, p_id_evento,
        p_subtotal, v_descuento_final, v_impuestos_final, v_total_final, p_estado_pago
    );

    IF v_tiene_descuento THEN
        UPDATE propietario
           SET propietario_con_descuento_proxima_facturacion = FALSE
         WHERE id_propietario = p_id_propietario;
    END IF;
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_factura(
    p_id VARCHAR, p_descuento DECIMAL, p_total DECIMAL, p_estado_pago VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE factura
       SET descuento = p_descuento, total = p_total, estado_pago = p_estado_pago
     WHERE id_factura = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_factura(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM factura WHERE id_factura = p_id;
END; $$;


-- Suministro

CREATE OR REPLACE PROCEDURE sp_insertar_suministro(
    p_id VARCHAR, p_tipo VARCHAR, p_proveedor VARCHAR,
    p_cantidad INTEGER, p_precio DECIMAL
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO suministro (id_suministro, tipo, proveedor, cantidad_disponible, precio_unitario)
    VALUES (p_id, p_tipo, p_proveedor, p_cantidad, p_precio);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_suministro(
    p_id VARCHAR, p_cantidad INTEGER, p_precio DECIMAL
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE suministro
       SET cantidad_disponible = p_cantidad, precio_unitario = p_precio
     WHERE id_suministro = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_suministro(p_id VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM suministro WHERE id_suministro = p_id;
END; $$;


-- Alimentación (descuenta automáticamente del stock de suministros)

CREATE OR REPLACE PROCEDURE sp_insertar_alimentacion(
    p_id_caballo VARCHAR, p_id_suministro VARCHAR,
    p_tipo_alimento VARCHAR, p_cantidad DECIMAL, p_fecha DATE
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO alimentacion (id_caballo, id_suministro, tipo_alimento, cantidad, fecha)
    VALUES (p_id_caballo, p_id_suministro, p_tipo_alimento, p_cantidad, p_fecha);

    UPDATE suministro
       SET cantidad_disponible = cantidad_disponible - FLOOR(p_cantidad)::INTEGER
     WHERE id_suministro = p_id_suministro;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_alimentacion(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM alimentacion WHERE id_alimentacion = p_id;
END; $$;


-- Resultado de Carrera

CREATE OR REPLACE PROCEDURE sp_insertar_resultado(
    p_id_evento VARCHAR, p_id_caballo VARCHAR,
    p_posicion INTEGER, p_tiempo VARCHAR, p_premio DECIMAL
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO resultado_carrera (id_evento, id_caballo, posicion, tiempo, premio_ganado)
    VALUES (p_id_evento, p_id_caballo, p_posicion, p_tiempo, p_premio);
END; $$;

CREATE OR REPLACE PROCEDURE sp_actualizar_resultado(
    p_id BIGINT, p_posicion INTEGER, p_tiempo VARCHAR, p_premio DECIMAL
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE resultado_carrera
       SET posicion = p_posicion, tiempo = p_tiempo, premio_ganado = p_premio
     WHERE id_resultado = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_resultado(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM resultado_carrera WHERE id_resultado = p_id;
END; $$;


-- Alerta Veterinaria

CREATE OR REPLACE PROCEDURE sp_insertar_alerta(
    p_id_caballo VARCHAR, p_id_propietario VARCHAR, p_mensaje TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO alerta_veterinaria (id_caballo, id_propietario, mensaje, leida, fecha_alerta)
    VALUES (p_id_caballo, p_id_propietario, p_mensaje, FALSE, NOW());
END; $$;

CREATE OR REPLACE PROCEDURE sp_marcar_alerta_leida(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE alerta_veterinaria SET leida = TRUE WHERE id_alerta = p_id;
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_alerta(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM alerta_veterinaria WHERE id_alerta = p_id;
END; $$;


-- Historial de Transacciones

CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
    p_id_factura VARCHAR, p_monto DECIMAL, p_metodo_pago VARCHAR, p_fecha_pago DATE
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO historial_transaccion (id_factura, monto, metodo_pago, fecha_pago)
    VALUES (p_id_factura, p_monto, p_metodo_pago, p_fecha_pago);
END; $$;

CREATE OR REPLACE PROCEDURE sp_eliminar_transaccion(p_id BIGINT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM historial_transaccion WHERE id_transaccion = p_id;
END; $$;


-- ==============================================================
-- PROCEDIMIENTOS DE AUTOMATIZACIÓN
-- ==============================================================

-- Marca propietarios con facturación > ₡500 000 en 6 meses para descuento en próxima factura.
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
END; $$;


-- Genera facturas para todos los eventos con inscripciones activas no facturadas
-- de un propietario. Aplica comisión 5%, descuento 10% si corresponde, IVA 13%.
CREATE OR REPLACE PROCEDURE sp_facturar_propietario(
    p_id_propietario     VARCHAR,
    p_precio_inscripcion DECIMAL DEFAULT 50000
) LANGUAGE plpgsql AS $$
DECLARE
    v_evento          RECORD;
    v_tiene_descuento BOOLEAN := FALSE;
    v_subtotal        DECIMAL;
    v_descuento       DECIMAL;
    v_impuestos       DECIMAL;
    v_total           DECIMAL;
    v_id_factura      VARCHAR;
    v_contador        INTEGER := 0;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM propietario WHERE id_propietario = p_id_propietario) THEN
        RAISE EXCEPTION 'Propietario % no encontrado.', p_id_propietario;
    END IF;

    SELECT propietario_con_descuento_proxima_facturacion
      INTO v_tiene_descuento
      FROM propietario WHERE id_propietario = p_id_propietario;

    FOR v_evento IN
        SELECT DISTINCT i.id_evento
          FROM inscripcion i
         INNER JOIN caballo c ON i.id_caballo = c.id_caballo
         WHERE c.id_propietario = p_id_propietario
           AND i.estado IN ('Inscrito', 'Confirmado', 'Competido', 'Activo')
           AND NOT EXISTS (
               SELECT 1 FROM factura f
                WHERE f.id_propietario = p_id_propietario
                  AND f.id_evento      = i.id_evento
           )
    LOOP
        v_subtotal  := ROUND(p_precio_inscripcion * 1.05, 2);
        v_descuento := CASE WHEN v_tiene_descuento THEN ROUND(v_subtotal * 0.10, 2) ELSE 0 END;
        v_impuestos := ROUND((v_subtotal - v_descuento) * 0.13, 2);
        v_total     := ROUND(v_subtotal - v_descuento + v_impuestos, 2);

        v_id_factura := 'FAC-' || p_id_propietario
                     || '-' || v_evento.id_evento
                     || '-' || LPAD(nextval('seq_factura_auto')::TEXT, 4, '0');

        INSERT INTO factura (
            id_factura, id_propietario, id_evento,
            subtotal, descuento, impuestos, total, estado_pago
        ) VALUES (
            v_id_factura, p_id_propietario, v_evento.id_evento,
            v_subtotal, v_descuento, v_impuestos, v_total, 'Pendiente'
        );

        v_contador := v_contador + 1;
    END LOOP;

    IF v_contador > 0 AND v_tiene_descuento THEN
        UPDATE propietario
           SET propietario_con_descuento_proxima_facturacion = FALSE
         WHERE id_propietario = p_id_propietario;
    END IF;

    RAISE NOTICE '% factura(s) generada(s) para propietario %.', v_contador, p_id_propietario;
END; $$;


-- Verifica que un caballo tenga certificación veterinaria vigente.
CREATE OR REPLACE PROCEDURE sp_validar_certificacion_veterinaria(p_id_caballo VARCHAR)
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
        RAISE EXCEPTION 'Certificación del caballo % venció el %. No puede inscribirse.',
                        p_id_caballo, v_vencimiento;
    END IF;

    RAISE NOTICE 'Caballo % — certificación válida hasta %.', p_id_caballo, v_vencimiento;
END; $$;


-- Finaliza un evento y genera facturas automáticas para todos los propietarios
-- con caballos inscritos y activos en ese evento.
CREATE OR REPLACE PROCEDURE sp_finalizar_evento(
    p_id_evento          VARCHAR(20),
    p_precio_inscripcion DECIMAL(12,2) DEFAULT 50000
) LANGUAGE plpgsql AS $$
DECLARE
    v_id_propietario VARCHAR(20);
    v_estado_actual  VARCHAR(20);
    v_total_facturas INTEGER := 0;
BEGIN
    SELECT estado INTO v_estado_actual
      FROM evento WHERE id_evento = p_id_evento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El evento % no existe.', p_id_evento;
    END IF;

    IF v_estado_actual IN ('Finalizado', 'Cancelado') THEN
        RAISE EXCEPTION 'El evento % ya está % y no puede procesarse nuevamente.',
                        p_id_evento, v_estado_actual;
    END IF;

    UPDATE evento SET estado = 'Finalizado' WHERE id_evento = p_id_evento;

    FOR v_id_propietario IN
        SELECT DISTINCT c.id_propietario
          FROM inscripcion i
          JOIN caballo c ON c.id_caballo = i.id_caballo
         WHERE i.id_evento = p_id_evento
           AND i.estado    = 'Activo'
    LOOP
        CALL sp_facturar_propietario(v_id_propietario, p_precio_inscripcion);
        v_total_facturas := v_total_facturas + 1;
    END LOOP;

    RAISE NOTICE 'Evento % finalizado. Facturas generadas para % propietario(s).',
                 p_id_evento, v_total_facturas;
END; $$;


-- ==============================================================
-- TRIGGERS
-- ==============================================================

-- Auditoría general: registra INSERT/UPDATE/DELETE en todas las tablas principales.

CREATE TABLE IF NOT EXISTS bitacora_auditoria (
    id_bitacora      BIGSERIAL    PRIMARY KEY,
    tabla_afectada   VARCHAR(50)  NOT NULL,
    operacion        VARCHAR(10)  NOT NULL,
    datos_anteriores TEXT,
    datos_nuevos     TEXT,
    usuario_bd       VARCHAR(100),
    fecha_hora       TIMESTAMP    DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_registrar_auditoria()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO bitacora_auditoria (
        tabla_afectada, operacion, datos_anteriores, datos_nuevos, usuario_bd, fecha_hora
    ) VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP != 'INSERT' THEN row_to_json(OLD)::TEXT ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW)::TEXT ELSE NULL END,
        CURRENT_USER,
        NOW()
    );
    RETURN NEW;
END; $$;

DO $$
DECLARE t TEXT;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'propietario','caballo','establo','evento','inscripcion',
        'historial_veterinario','factura','suministro','alimentacion',
        'resultado_carrera','alerta_veterinaria','historial_transaccion'
    ]
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS tr_auditoria_%1$s ON %1$s;
             CREATE TRIGGER tr_auditoria_%1$s
             AFTER INSERT OR UPDATE OR DELETE ON %1$s
             FOR EACH ROW EXECUTE FUNCTION fn_registrar_auditoria();', t);
    END LOOP;
END; $$;


-- Genera alerta automática cuando la certificación veterinaria está por vencer (≤ 30 días).

CREATE OR REPLACE FUNCTION fn_alerta_vencimiento()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.fecha_vencimiento_certificacion <= CURRENT_DATE + INTERVAL '30 days' THEN
        INSERT INTO alerta_veterinaria (id_caballo, id_propietario, mensaje, leida, fecha_alerta)
        SELECT NEW.id_caballo, c.id_propietario,
               'Certificación vence el ' || NEW.fecha_vencimiento_certificacion ||
               ' — programar revisión veterinaria.',
               FALSE, NOW()
          FROM caballo c WHERE c.id_caballo = NEW.id_caballo;
    END IF;
    RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS tr_alerta_vencimiento ON historial_veterinario;
CREATE TRIGGER tr_alerta_vencimiento
AFTER INSERT OR UPDATE OF fecha_vencimiento_certificacion ON historial_veterinario
FOR EACH ROW EXECUTE FUNCTION fn_alerta_vencimiento();


-- Activa el flag de descuento cuando la facturación acumulada del propietario
-- supera ₡500 000 en los últimos 6 meses.

CREATE OR REPLACE FUNCTION fn_descuento_frecuente()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_total_6m DECIMAL;
BEGIN
    SELECT COALESCE(SUM(total), 0) INTO v_total_6m
      FROM factura
     WHERE id_propietario = NEW.id_propietario
       AND fecha_emision  >= NOW() - INTERVAL '6 months'
       AND estado_pago    = 'Pagado';

    IF v_total_6m > 500000 THEN
        UPDATE propietario
           SET propietario_con_descuento_proxima_facturacion = TRUE
         WHERE id_propietario = NEW.id_propietario;
    END IF;
    RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS tr_descuento_frecuente ON factura;
CREATE TRIGGER tr_descuento_frecuente
AFTER INSERT ON factura
FOR EACH ROW EXECUTE FUNCTION fn_descuento_frecuente();


-- ==============================================================
-- BITÁCORAS PARTICIONADAS POR TRIMESTRE
-- Tablas: caballo, evento, inscripcion, historial_veterinario,
--         factura, alimentacion, resultado_carrera, alerta_veterinaria
-- ==============================================================

DROP TABLE IF EXISTS bitacora_caballo               CASCADE;
DROP TABLE IF EXISTS bitacora_evento                CASCADE;
DROP TABLE IF EXISTS bitacora_inscripcion           CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario CASCADE;
DROP TABLE IF EXISTS bitacora_factura               CASCADE;
DROP TABLE IF EXISTS bitacora_alimentacion          CASCADE;
DROP TABLE IF EXISTS bitacora_resultado_carrera     CASCADE;
DROP TABLE IF EXISTS bitacora_alerta_veterinaria    CASCADE;
DROP TABLE IF EXISTS bitacora_caballos              CASCADE;
DROP TABLE IF EXISTS bitacora_eventos               CASCADE;
DROP TABLE IF EXISTS bitacora_facturas              CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios          CASCADE;
DROP TABLE IF EXISTS bitacora_suministros           CASCADE;


-- bitacora_caballo

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

CREATE TABLE bitacora_caballo_2025_q1 PARTITION OF bitacora_caballo FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_caballo_2025_q2 PARTITION OF bitacora_caballo FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_caballo_2025_q3 PARTITION OF bitacora_caballo FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_caballo_2025_q4 PARTITION OF bitacora_caballo FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_caballo_2026_q1 PARTITION OF bitacora_caballo FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_caballo_2026_q2 PARTITION OF bitacora_caballo FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_caballo_2026_q3 PARTITION OF bitacora_caballo FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_caballo_2026_q4 PARTITION OF bitacora_caballo FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_caballo ON caballo;
CREATE TRIGGER tr_bitacora_caballo
AFTER INSERT OR UPDATE OR DELETE ON caballo
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_caballo();


-- bitacora_evento

CREATE TABLE bitacora_evento (
    id_evento      VARCHAR(20),
    nombre         VARCHAR(200),
    fecha          TIMESTAMP,
    tipo_carrera   VARCHAR(50),
    distancia      INT,
    premio_total   DECIMAL(12,2),
    estado         VARCHAR(30),
    usuario        VARCHAR(100) DEFAULT CURRENT_USER,
    accion         VARCHAR(10)  NOT NULL,
    fecha_registro TIMESTAMP    NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (fecha_registro);

CREATE TABLE bitacora_evento_2025_q1 PARTITION OF bitacora_evento FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_evento_2025_q2 PARTITION OF bitacora_evento FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_evento_2025_q3 PARTITION OF bitacora_evento FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_evento_2025_q4 PARTITION OF bitacora_evento FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_evento_2026_q1 PARTITION OF bitacora_evento FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_evento_2026_q2 PARTITION OF bitacora_evento FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_evento_2026_q3 PARTITION OF bitacora_evento FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_evento_2026_q4 PARTITION OF bitacora_evento FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_evento ON evento;
CREATE TRIGGER tr_bitacora_evento
AFTER INSERT OR UPDATE OR DELETE ON evento
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_evento();


-- bitacora_inscripcion

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

CREATE TABLE bitacora_inscripcion_2025_q1 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_inscripcion_2025_q2 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_inscripcion_2025_q3 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_inscripcion_2025_q4 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_inscripcion_2026_q1 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_inscripcion_2026_q2 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_inscripcion_2026_q3 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_inscripcion_2026_q4 PARTITION OF bitacora_inscripcion FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_inscripcion ON inscripcion;
CREATE TRIGGER tr_bitacora_inscripcion
AFTER INSERT OR UPDATE OR DELETE ON inscripcion
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_inscripcion();


-- bitacora_historial_veterinario

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

CREATE TABLE bitacora_historial_veterinario_2025_q1 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_historial_veterinario_2025_q2 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_historial_veterinario_2025_q3 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_historial_veterinario_2025_q4 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_historial_veterinario_2026_q1 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_historial_veterinario_2026_q2 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_historial_veterinario_2026_q3 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_historial_veterinario_2026_q4 PARTITION OF bitacora_historial_veterinario FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_historial_veterinario ON historial_veterinario;
CREATE TRIGGER tr_bitacora_historial_veterinario
AFTER INSERT OR UPDATE OR DELETE ON historial_veterinario
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_historial_veterinario();


-- bitacora_factura

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

CREATE TABLE bitacora_factura_2025_q1 PARTITION OF bitacora_factura FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_factura_2025_q2 PARTITION OF bitacora_factura FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_factura_2025_q3 PARTITION OF bitacora_factura FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_factura_2025_q4 PARTITION OF bitacora_factura FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_factura_2026_q1 PARTITION OF bitacora_factura FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_factura_2026_q2 PARTITION OF bitacora_factura FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_factura_2026_q3 PARTITION OF bitacora_factura FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_factura_2026_q4 PARTITION OF bitacora_factura FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_factura ON factura;
CREATE TRIGGER tr_bitacora_factura
AFTER INSERT OR UPDATE OR DELETE ON factura
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_factura();


-- bitacora_alimentacion

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

CREATE TABLE bitacora_alimentacion_2025_q1 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_alimentacion_2025_q2 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_alimentacion_2025_q3 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_alimentacion_2025_q4 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_alimentacion_2026_q1 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_alimentacion_2026_q2 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_alimentacion_2026_q3 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_alimentacion_2026_q4 PARTITION OF bitacora_alimentacion FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_alimentacion ON alimentacion;
CREATE TRIGGER tr_bitacora_alimentacion
AFTER INSERT OR UPDATE OR DELETE ON alimentacion
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_alimentacion();


-- bitacora_resultado_carrera

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

CREATE TABLE bitacora_resultado_carrera_2025_q1 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_resultado_carrera_2025_q2 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_resultado_carrera_2025_q3 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_resultado_carrera_2025_q4 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_resultado_carrera_2026_q1 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_resultado_carrera_2026_q2 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_resultado_carrera_2026_q3 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_resultado_carrera_2026_q4 PARTITION OF bitacora_resultado_carrera FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_resultado_carrera ON resultado_carrera;
CREATE TRIGGER tr_bitacora_resultado_carrera
AFTER INSERT OR UPDATE OR DELETE ON resultado_carrera
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_resultado_carrera();


-- bitacora_alerta_veterinaria

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

CREATE TABLE bitacora_alerta_veterinaria_2025_q1 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q2 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q3 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bitacora_alerta_veterinaria_2025_q4 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q1 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q2 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q3 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');
CREATE TABLE bitacora_alerta_veterinaria_2026_q4 PARTITION OF bitacora_alerta_veterinaria FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');
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
END; $$;

DROP TRIGGER IF EXISTS tr_bitacora_alerta_veterinaria ON alerta_veterinaria;
CREATE TRIGGER tr_bitacora_alerta_veterinaria
AFTER INSERT OR UPDATE OR DELETE ON alerta_veterinaria
FOR EACH ROW EXECUTE FUNCTION fn_bitacora_alerta_veterinaria();


-- ==============================================================
-- ÍNDICES
-- ==============================================================

CREATE INDEX IF NOT EXISTS idx_caballo_propietario          ON caballo(id_propietario);
CREATE INDEX IF NOT EXISTS idx_caballo_establo              ON caballo(id_establo);
CREATE INDEX IF NOT EXISTS idx_inscripcion_evento           ON inscripcion(id_evento);
CREATE INDEX IF NOT EXISTS idx_inscripcion_caballo          ON inscripcion(id_caballo);
CREATE INDEX IF NOT EXISTS idx_historial_vet_caballo_venc   ON historial_veterinario(id_caballo, fecha_vencimiento_certificacion);
CREATE INDEX IF NOT EXISTS idx_factura_propietario_fecha    ON factura(id_propietario, fecha_emision);
CREATE INDEX IF NOT EXISTS idx_alerta_propietario_leida     ON alerta_veterinaria(id_propietario, leida);
CREATE INDEX IF NOT EXISTS idx_alimentacion_caballo         ON alimentacion(id_caballo);
CREATE INDEX IF NOT EXISTS idx_resultado_evento             ON resultado_carrera(id_evento);
CREATE INDEX IF NOT EXISTS idx_resultado_caballo            ON resultado_carrera(id_caballo);
CREATE INDEX IF NOT EXISTS idx_transaccion_factura          ON historial_transaccion(id_factura);


-- ==============================================================
-- USUARIOS DEL SISTEMA
-- ==============================================================

-- Roles: ROLE_ADMIN · ROLE_PROPIETARIO · ROLE_VETERINARIO · ROLE_ENCARGADO
-- Contraseña en texto plano ({noop}) solo para entorno de demostración.
INSERT INTO usuarios (username, password, nombre, rol, activo) VALUES
    ('c19296', '{noop}C19296', 'Kendall Andrés Quirós Álvarez', 'ROLE_ADMIN',       true),
    ('c20051', '{noop}C20051', 'Kristy Daniela Acosta Mercado', 'ROLE_VETERINARIO', true),
    ('c23112', '{noop}C23112', 'Dering Josué García Acevedo',   'ROLE_PROPIETARIO', true),
    ('c24510', '{noop}C24510', 'Justin Josué Marenco Herrera',  'ROLE_ADMIN',       true),
    ('c17735', '{noop}C17735', 'David Daniel Sotela Sánchez',   'ROLE_ENCARGADO',   true)
ON CONFLICT (username) DO UPDATE SET rol = EXCLUDED.rol;


-- ==============================================================
-- DATOS DE DEMOSTRACIÓN
-- ==============================================================

TRUNCATE TABLE historial_transaccion CASCADE;
TRUNCATE TABLE alerta_veterinaria    CASCADE;
TRUNCATE TABLE resultado_carrera     CASCADE;
TRUNCATE TABLE alimentacion          CASCADE;
TRUNCATE TABLE suministro            CASCADE;
TRUNCATE TABLE factura               CASCADE;
TRUNCATE TABLE historial_veterinario CASCADE;
TRUNCATE TABLE inscripcion           CASCADE;
TRUNCATE TABLE evento                CASCADE;
TRUNCATE TABLE caballo               CASCADE;
TRUNCATE TABLE establo               CASCADE;
TRUNCATE TABLE propietario           CASCADE;
TRUNCATE TABLE barrio                CASCADE;
TRUNCATE TABLE distrito              CASCADE;
TRUNCATE TABLE canton                CASCADE;
TRUNCATE TABLE provincia             CASCADE;
TRUNCATE TABLE pais                  CASCADE;

INSERT INTO pais (id_pais, nombre_pais) VALUES
    (1, 'Costa Rica'), (2, 'Panamá'), (3, 'Nicaragua'), (4, 'Honduras'), (5, 'El Salvador');

INSERT INTO provincia (id_provincia, nombre_provincia, id_pais) VALUES
    (1, 'Guanacaste', 1), (2, 'San José', 1), (3, 'Alajuela', 1),
    (4, 'Heredia', 1),    (5, 'Puntarenas', 1);

INSERT INTO canton (id_canton, nombre_canton, id_provincia) VALUES
    (1, 'Liberia', 1), (2, 'Nicoya', 1), (3, 'Santa Cruz', 1),
    (4, 'Bagaces', 1), (5, 'Cañas', 1);

INSERT INTO distrito (id_distrito, nombre_distrito, id_canton) VALUES
    (1, 'Liberia Centro', 1), (2, 'Cañas Dulces', 1), (3, 'Mayorga', 1),
    (4, 'Nacascolo', 1),      (5, 'Curubandé', 1);

INSERT INTO barrio (nombre_barrio, id_distrito) VALUES
    ('Barrio El Bosque',       1), ('Barrio La Libertad',     1),
    ('Barrio Los Ángeles',     1), ('Barrio San Roque',       1),
    ('Barrio Victoria',        1), ('Barrio El Progreso',     2),
    ('Barrio Las Palmas',      2), ('Barrio Nuevo Horizonte', 2),
    ('Barrio Santa Cecilia',   2), ('Barrio La Paz',          2),
    ('Barrio El Roble',        3), ('Barrio Las Flores',      3),
    ('Barrio Montaña Verde',   3), ('Barrio San Francisco',   3),
    ('Barrio La Colina',       3), ('Barrio El Manglar',      4),
    ('Barrio Los Pinos',       4), ('Barrio Río Claro',       4),
    ('Barrio El Paraíso',      5), ('Barrio Las Brisas',      5);

INSERT INTO propietario (id_propietario, nombre, apellidos, id_barrio, propietario_con_descuento_proxima_facturacion) VALUES
    ('1-0501-0001', 'Carlos',   'Rodríguez Mora',    1,  false),
    ('1-0501-0002', 'María',    'González Jiménez',  2,  false),
    ('1-0501-0003', 'Luis',     'Vargas Solano',     3,  true),
    ('1-0501-0004', 'Ana',      'Campos Herrera',    4,  false),
    ('1-0501-0005', 'Jorge',    'Madrigal Rojas',    5,  false),
    ('1-0501-0006', 'Patricia', 'Ureña Brenes',      6,  true),
    ('1-0501-0007', 'Roberto',  'Chavarría Castro',  7,  false),
    ('1-0501-0008', 'Silvia',   'Mora Aguilar',      8,  false),
    ('1-0501-0009', 'Fernando', 'Salazar Vega',      9,  true),
    ('1-0501-0010', 'Lorena',   'Quirós Elizondo',   10, false),
    ('5-0245-0011', 'Andrés',   'Hidalgo Núñez',     11, false),
    ('5-0245-0012', 'Carmen',   'Araya Fonseca',     12, true),
    ('5-0245-0013', 'Manuel',   'Chaves Gutiérrez',  13, false),
    ('5-0245-0014', 'Isabel',   'Quesada Ramírez',   14, false),
    ('5-0245-0015', 'Diego',    'Valverde Picado',   15, false),
    ('5-0245-0016', 'Elena',    'Benavides Monge',   16, true),
    ('5-0245-0017', 'Gustavo',  'Solís Pérez',       17, false),
    ('5-0245-0018', 'Natalia',  'Corrales Badilla',  18, false),
    ('5-0245-0019', 'Rodrigo',  'Alpízar Zamora',    19, true),
    ('5-0245-0020', 'Marcela',  'Barrantes López',   20, false);

INSERT INTO establo (id_establo, capacidad, estado, id_barrio) VALUES
    ('EST-001', 15, 'Activo',           1),  ('EST-002', 20, 'Activo',           2),
    ('EST-003', 10, 'Lleno',            3),  ('EST-004', 25, 'Activo',           4),
    ('EST-005', 12, 'En Mantenimiento', 5),  ('EST-006', 18, 'Activo',           6),
    ('EST-007', 30, 'Activo',           7),  ('EST-008',  8, 'Lleno',            8),
    ('EST-009', 22, 'Activo',           9),  ('EST-010', 16, 'Activo',           10),
    ('EST-011', 14, 'En Mantenimiento', 11), ('EST-012', 20, 'Activo',           12),
    ('EST-013', 10, 'Activo',           13), ('EST-014', 25, 'Lleno',            14),
    ('EST-015', 18, 'Activo',           15), ('EST-016', 12, 'Activo',           16),
    ('EST-017', 20, 'Activo',           17), ('EST-018', 15, 'En Mantenimiento', 18),
    ('EST-019', 30, 'Activo',           19), ('EST-020', 22, 'Activo',           20);

INSERT INTO caballo (id_caballo, nombre, fecha_nacimiento, sexo, raza, peso, estado_salud, id_propietario, id_establo) VALUES
    ('CAB-001', 'Relámpago',  '2018-03-15', 'M', 'Pura Sangre',     480.50, 'Óptimo',  '1-0501-0001', 'EST-001'),
    ('CAB-002', 'Tormenta',   '2019-06-22', 'H', 'Cuarto de Milla', 430.00, 'Bueno',   '1-0501-0002', 'EST-002'),
    ('CAB-003', 'Ciclón',     '2017-11-08', 'M', 'Árabe',           460.75, 'Óptimo',  '1-0501-0003', 'EST-003'),
    ('CAB-004', 'Aurora',     '2020-01-30', 'H', 'Pura Sangre',     410.25, 'Regular', '1-0501-0004', 'EST-004'),
    ('CAB-005', 'Trueno',     '2016-08-14', 'M', 'Appaloosa',       495.00, 'Óptimo',  '1-0501-0005', 'EST-005'),
    ('CAB-006', 'Estrella',   '2021-02-20', 'H', 'Cuarto de Milla', 395.50, 'Bueno',   '1-0501-0006', 'EST-006'),
    ('CAB-007', 'Bravo',      '2018-09-05', 'M', 'Pura Sangre',     470.00, 'Óptimo',  '1-0501-0007', 'EST-007'),
    ('CAB-008', 'Luna',       '2019-12-18', 'H', 'Árabe',           415.75, 'Bueno',   '1-0501-0008', 'EST-008'),
    ('CAB-009', 'Volcán',     '2017-04-25', 'M', 'Pura Sangre',     488.25, 'Regular', '1-0501-0009', 'EST-009'),
    ('CAB-010', 'Niebla',     '2020-07-11', 'H', 'Cuarto de Milla', 425.00, 'Óptimo',  '1-0501-0010', 'EST-010'),
    ('CAB-011', 'Fuego',      '2016-05-03', 'M', 'Appaloosa',       501.50, 'Bueno',   '5-0245-0011', 'EST-011'),
    ('CAB-012', 'Esmeralda',  '2022-01-16', 'H', 'Pura Sangre',     400.00, 'Óptimo',  '5-0245-0012', 'EST-012'),
    ('CAB-013', 'Vendaval',   '2018-10-29', 'M', 'Árabe',           465.25, 'Bueno',   '5-0245-0013', 'EST-013'),
    ('CAB-014', 'Perla',      '2019-03-08', 'H', 'Cuarto de Milla', 435.75, 'Óptimo',  '5-0245-0014', 'EST-014'),
    ('CAB-015', 'Titán',      '2017-08-22', 'M', 'Pura Sangre',     492.00, 'Regular', '5-0245-0015', 'EST-015'),
    ('CAB-016', 'Diamante',   '2020-11-14', 'H', 'Árabe',           420.50, 'Bueno',   '5-0245-0016', 'EST-016'),
    ('CAB-017', 'Centella',   '2018-06-30', 'M', 'Pura Sangre',     478.00, 'Óptimo',  '5-0245-0017', 'EST-017'),
    ('CAB-018', 'Brisa',      '2021-09-05', 'H', 'Cuarto de Milla', 405.25, 'Bueno',   '5-0245-0018', 'EST-018'),
    ('CAB-019', 'Rayo',       '2016-12-20', 'M', 'Appaloosa',       510.00, 'Óptimo',  '5-0245-0019', 'EST-019'),
    ('CAB-020', 'Sirena',     '2019-04-17', 'H', 'Árabe',           412.75, 'Regular', '5-0245-0020', 'EST-020');

INSERT INTO evento (id_evento, nombre, fecha, tipo_carrera, distancia, premio_total, estado) VALUES
    ('EVT-001', 'Gran Premio Guanacaste 2025',     '2025-02-15 10:00:00', 'Clásica',    1200, 5000000.00, 'Finalizado'),
    ('EVT-002', 'Copa Liberia Primavera',           '2025-03-08 09:00:00', 'Velocidad',   800, 3500000.00, 'Finalizado'),
    ('EVT-003', 'Carrera del Sol',                 '2025-04-20 11:00:00', 'Obstáculos', 1600, 4200000.00, 'Finalizado'),
    ('EVT-004', 'Premio Nacional Pura Sangre',     '2025-05-10 10:00:00', 'Clásica',    2000, 8000000.00, 'Finalizado'),
    ('EVT-005', 'Trofeo Costa Rica',               '2025-06-14 09:30:00', 'Velocidad',  1000, 6500000.00, 'Finalizado'),
    ('EVT-006', 'Copa Sabana Verde',               '2025-07-05 10:00:00', 'Clásica',    1400, 4800000.00, 'Finalizado'),
    ('EVT-007', 'Gran Carrera del Pacífico',       '2025-08-23 11:00:00', 'Obstáculos', 1800, 7000000.00, 'Finalizado'),
    ('EVT-008', 'Campeonato Interregional',        '2025-09-12 09:00:00', 'Velocidad',  1200, 5500000.00, 'Finalizado'),
    ('EVT-009', 'Copa Independencia 2025',         '2025-09-15 10:00:00', 'Clásica',    2400, 9000000.00, 'Finalizado'),
    ('EVT-010', 'Premio Otoño',                    '2025-10-18 09:30:00', 'Velocidad',   800, 3000000.00, 'Finalizado'),
    ('EVT-011', 'Gran Premio Diciembre',           '2025-12-06 10:00:00', 'Clásica',    1600, 6000000.00, 'Programado'),
    ('EVT-012', 'Copa Navideña',                   '2025-12-20 09:00:00', 'Velocidad',  1000, 4500000.00, 'Programado'),
    ('EVT-013', 'Carrera de Año Nuevo',            '2026-01-10 11:00:00', 'Clásica',    1200, 5200000.00, 'Programado'),
    ('EVT-014', 'Copa Febrero Temporada',          '2026-02-07 10:00:00', 'Obstáculos', 1600, 4700000.00, 'Programado'),
    ('EVT-015', 'Gran Premio Verano 2026',         '2026-02-28 09:30:00', 'Clásica',    2000, 8500000.00, 'Programado'),
    ('EVT-016', 'Premio Primavera 2026',           '2026-03-21 10:00:00', 'Velocidad',   800, 3200000.00, 'Programado'),
    ('EVT-017', 'Trofeo Regional Norte',           '2026-04-11 11:00:00', 'Clásica',    1400, 5800000.00, 'Programado'),
    ('EVT-018', 'Copa Mayo 2026',                  '2026-05-02 09:00:00', 'Velocidad',  1000, 4000000.00, 'Programado'),
    ('EVT-019', 'Gran Carrera Aniversario',        '2026-05-15 10:00:00', 'Clásica',    1800, 7500000.00, 'En Curso'),
    ('EVT-020', 'Premio Especial Guanacaste 2026', '2026-07-25 09:30:00', 'Obstáculos', 2000, 9500000.00, 'Programado');

INSERT INTO inscripcion (id_inscripcion, id_evento, id_caballo, fecha_inscripcion, estado, posicion_final) VALUES
    ('INS-001', 'EVT-001', 'CAB-001', '2025-02-01', 'Completado', 1),
    ('INS-002', 'EVT-001', 'CAB-003', '2025-02-01', 'Completado', 2),
    ('INS-003', 'EVT-001', 'CAB-005', '2025-02-02', 'Completado', 3),
    ('INS-004', 'EVT-002', 'CAB-007', '2025-02-25', 'Completado', 1),
    ('INS-005', 'EVT-002', 'CAB-009', '2025-02-25', 'Completado', 2),
    ('INS-006', 'EVT-003', 'CAB-011', '2025-04-06', 'Completado', 1),
    ('INS-007', 'EVT-003', 'CAB-013', '2025-04-06', 'Completado', 2),
    ('INS-008', 'EVT-004', 'CAB-015', '2025-04-26', 'Completado', 1),
    ('INS-009', 'EVT-004', 'CAB-017', '2025-04-27', 'Completado', 2),
    ('INS-010', 'EVT-005', 'CAB-019', '2025-05-31', 'Completado', 1),
    ('INS-011', 'EVT-006', 'CAB-002', '2025-06-21', 'Completado', 1),
    ('INS-012', 'EVT-006', 'CAB-004', '2025-06-21', 'Completado', 2),
    ('INS-013', 'EVT-007', 'CAB-006', '2025-08-09', 'Completado', 1),
    ('INS-014', 'EVT-008', 'CAB-008', '2025-08-29', 'Completado', 1),
    ('INS-015', 'EVT-009', 'CAB-010', '2025-09-01', 'Completado', 1),
    ('INS-016', 'EVT-010', 'CAB-012', '2025-10-04', 'Completado', 1),
    ('INS-017', 'EVT-011', 'CAB-014', '2025-11-22', 'Inscrito',   NULL),
    ('INS-018', 'EVT-011', 'CAB-016', '2025-11-22', 'Inscrito',   NULL),
    ('INS-019', 'EVT-019', 'CAB-018', '2026-05-01', 'Activo',     NULL),
    ('INS-020', 'EVT-019', 'CAB-020', '2026-05-01', 'Activo',     NULL);

INSERT INTO factura (id_factura, id_propietario, id_evento, subtotal, descuento, impuestos, total, estado_pago, fecha_emision) VALUES
    ('FAC-001', '1-0501-0001', 'EVT-001', 150000.00,  0.00,     19500.00,  169500.00,  'Pagado',    '2025-02-15 12:00:00'),
    ('FAC-002', '1-0501-0002', 'EVT-001', 150000.00,  0.00,     19500.00,  169500.00,  'Pagado',    '2025-02-15 12:00:00'),
    ('FAC-003', '1-0501-0003', 'EVT-002', 120000.00,  12000.00, 14040.00,  122040.00,  'Pagado',    '2025-03-08 11:00:00'),
    ('FAC-004', '1-0501-0004', 'EVT-003', 135000.00,  0.00,     17550.00,  152550.00,  'Pagado',    '2025-04-20 13:00:00'),
    ('FAC-005', '1-0501-0005', 'EVT-004', 200000.00,  0.00,     26000.00,  226000.00,  'Pagado',    '2025-05-10 12:30:00'),
    ('FAC-006', '1-0501-0006', 'EVT-005', 180000.00,  18000.00, 21060.00,  183060.00,  'Pagado',    '2025-06-14 11:00:00'),
    ('FAC-007', '1-0501-0007', 'EVT-006', 145000.00,  0.00,     18850.00,  163850.00,  'Pagado',    '2025-07-05 12:00:00'),
    ('FAC-008', '1-0501-0008', 'EVT-007', 175000.00,  0.00,     22750.00,  197750.00,  'Pendiente', '2025-08-23 13:00:00'),
    ('FAC-009', '1-0501-0009', 'EVT-008', 160000.00,  0.00,     20800.00,  180800.00,  'Pagado',    '2025-09-12 11:30:00'),
    ('FAC-010', '1-0501-0010', 'EVT-009', 210000.00,  0.00,     27300.00,  237300.00,  'Pendiente', '2025-09-15 12:00:00'),
    ('FAC-011', '5-0245-0011', 'EVT-010', 110000.00,  0.00,     14300.00,  124300.00,  'Pagado',    '2025-10-18 10:00:00'),
    ('FAC-012', '5-0245-0012', 'EVT-006', 145000.00,  14500.00, 17032.50,  147532.50,  'Pagado',    '2025-07-05 12:30:00'),
    ('FAC-013', '5-0245-0013', 'EVT-007', 175000.00,  0.00,     22750.00,  197750.00,  'Pagado',    '2025-08-23 13:30:00'),
    ('FAC-014', '5-0245-0014', 'EVT-008', 160000.00,  0.00,     20800.00,  180800.00,  'Pendiente', '2025-09-12 12:00:00'),
    ('FAC-015', '5-0245-0015', 'EVT-009', 210000.00,  0.00,     27300.00,  237300.00,  'Pagado',    '2025-09-15 12:30:00'),
    ('FAC-016', '5-0245-0016', 'EVT-010', 110000.00,  11000.00, 12870.00,  111870.00,  'Pagado',    '2025-10-18 10:30:00'),
    ('FAC-017', '5-0245-0017', 'EVT-011', 165000.00,  0.00,     21450.00,  186450.00,  'Pendiente', '2025-11-01 09:00:00'),
    ('FAC-018', '5-0245-0018', 'EVT-011', 165000.00,  0.00,     21450.00,  186450.00,  'Pendiente', '2025-11-01 09:30:00'),
    ('FAC-019', '5-0245-0019', 'EVT-019', 190000.00,  19000.00, 22230.00,  193230.00,  'Pendiente', '2026-05-01 10:00:00'),
    ('FAC-020', '5-0245-0020', 'EVT-019', 190000.00,  0.00,     24700.00,  214700.00,  'Pendiente', '2026-05-01 10:30:00');

INSERT INTO historial_transaccion (id_factura, monto, metodo_pago, fecha_pago) VALUES
    ('FAC-001', 169500.00, 'Transferencia', '2025-02-16'),
    ('FAC-002', 169500.00, 'Efectivo',      '2025-02-17'),
    ('FAC-003', 122040.00, 'SINPE',         '2025-03-09'),
    ('FAC-004', 152550.00, 'Tarjeta',       '2025-04-21'),
    ('FAC-005', 226000.00, 'Transferencia', '2025-05-11'),
    ('FAC-006', 183060.00, 'Efectivo',      '2025-06-15'),
    ('FAC-007', 163850.00, 'SINPE',         '2025-07-06'),
    ('FAC-009', 180800.00, 'Tarjeta',       '2025-09-13'),
    ('FAC-011', 124300.00, 'Transferencia', '2025-10-19'),
    ('FAC-012', 147532.50, 'SINPE',         '2025-07-07');

CALL sp_insertar_suministro('SUM-001', 'Alimento',    'Nutrición Equina S.A.',    500, 850.00);
CALL sp_insertar_suministro('SUM-002', 'Alimento',    'Agropecuaria Liberia',     300, 1200.00);
CALL sp_insertar_suministro('SUM-003', 'Alimento',    'Granos del Norte S.R.L.',  200, 650.00);
CALL sp_insertar_suministro('SUM-004', 'Medicamento', 'Veterinaria Central',       80, 3500.00);
CALL sp_insertar_suministro('SUM-005', 'Medicamento', 'PharmEquine C.R.',          50, 7200.00);
CALL sp_insertar_suministro('SUM-006', 'Equipo',      'Hipic Supply C.R.',         25, 15000.00);
CALL sp_insertar_suministro('SUM-007', 'Limpieza',    'Distribuidora Guanacaste',  90, 450.00);
CALL sp_insertar_suministro('SUM-008', 'Alimento',    'Nutrición Equina S.A.',    150, 980.00);

CALL sp_insertar_historial_veterinario('HIV-001','CAB-001','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-01-10','2027-01-10','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-002','CAB-002','Lesión leve en tendón anterior',   'Reposo 15 días y anti-inflamatorio', '2025-01-15','2027-01-15','Dra. Laura Méndez');
CALL sp_insertar_historial_veterinario('HIV-003','CAB-003','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-02-05','2027-02-05','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-004','CAB-004','Cólico moderado',                  'Tratamiento hidratante y analgésico','2025-02-18','2027-02-18','Dr. Pablo Castro');
CALL sp_insertar_historial_veterinario('HIV-005','CAB-005','Revisión pre-carrera',             'Apto para competencia',              '2025-03-01','2027-03-01','Dra. Laura Méndez');
CALL sp_insertar_historial_veterinario('HIV-006','CAB-006','Infección cutánea superficial',    'Antibióticos tópicos 10 días',       '2025-03-12','2027-03-12','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-007','CAB-007','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-04-02','2027-04-02','Dr. Pablo Castro');
CALL sp_insertar_historial_veterinario('HIV-008','CAB-008','Examen de pezuñas',                'Herraje correctivo',                 '2025-04-15','2027-04-15','Dra. Laura Méndez');
CALL sp_insertar_historial_veterinario('HIV-009','CAB-009','Bronquitis leve',                  'Antibióticos y nebulización 7 días', '2025-05-03','2027-05-03','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-010','CAB-010','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-05-20','2027-05-20','Dra. Ana Vargas');
CALL sp_insertar_historial_veterinario('HIV-011','CAB-011','Revisión pre-carrera',             'Apto para competencia',              '2025-06-08','2027-06-08','Dr. Pablo Castro');
CALL sp_insertar_historial_veterinario('HIV-012','CAB-012','Otitis leve',                      'Tratamiento tópico auricular',       '2025-06-22','2027-06-22','Dra. Laura Méndez');
CALL sp_insertar_historial_veterinario('HIV-013','CAB-013','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-07-10','2027-07-10','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-014','CAB-014','Distensión muscular',              'Fisioterapia y reposo 20 días',      '2025-07-28','2027-07-28','Dra. Ana Vargas');
CALL sp_insertar_historial_veterinario('HIV-015','CAB-015','Revisión de dentadura',            'Limpieza dental y ajuste',           '2025-08-06','2027-08-06','Dr. Pablo Castro');
CALL sp_insertar_historial_veterinario('HIV-016','CAB-016','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-08-19','2027-08-19','Dra. Laura Méndez');
CALL sp_insertar_historial_veterinario('HIV-017','CAB-017','Úlcera gástrica leve',             'Omeprazol equino 30 días',           '2025-09-04','2027-09-04','Dr. Marco Solano');
CALL sp_insertar_historial_veterinario('HIV-018','CAB-018','Revisión pre-carrera',             'Apto para competencia',              '2025-09-15','2027-09-15','Dra. Ana Vargas');
CALL sp_insertar_historial_veterinario('HIV-019','CAB-019','Herida superficial en flanco',     'Limpieza y vendaje 5 días',          '2025-10-01','2027-10-01','Dr. Pablo Castro');
CALL sp_insertar_historial_veterinario('HIV-020','CAB-020','Revisión preventiva anual',        'Vacunas y desparasitación',          '2025-10-14','2027-10-14','Dra. Laura Méndez');

CALL sp_insertar_alimentacion('CAB-001','SUM-001','Heno',        5.00,'2026-05-20');
CALL sp_insertar_alimentacion('CAB-002','SUM-002','Concentrado', 3.50,'2026-05-20');
CALL sp_insertar_alimentacion('CAB-003','SUM-001','Heno',        4.50,'2026-05-21');
CALL sp_insertar_alimentacion('CAB-004','SUM-003','Avena',       2.00,'2026-05-21');
CALL sp_insertar_alimentacion('CAB-005','SUM-001','Heno',        5.50,'2026-05-22');
CALL sp_insertar_alimentacion('CAB-006','SUM-008','Zanahoria',   1.50,'2026-05-22');
CALL sp_insertar_alimentacion('CAB-007','SUM-002','Concentrado', 4.00,'2026-05-23');
CALL sp_insertar_alimentacion('CAB-008','SUM-001','Heno',        5.00,'2026-05-23');
CALL sp_insertar_alimentacion('CAB-009','SUM-003','Avena',       2.50,'2026-05-24');
CALL sp_insertar_alimentacion('CAB-010','SUM-001','Heno',        4.00,'2026-05-24');
CALL sp_insertar_alimentacion('CAB-011','SUM-002','Concentrado', 3.00,'2026-05-25');
CALL sp_insertar_alimentacion('CAB-012','SUM-001','Heno',        5.00,'2026-05-25');
CALL sp_insertar_alimentacion('CAB-013','SUM-008','Zanahoria',   2.00,'2026-05-25');
CALL sp_insertar_alimentacion('CAB-014','SUM-003','Avena',       3.00,'2026-05-26');
CALL sp_insertar_alimentacion('CAB-015','SUM-001','Heno',        4.50,'2026-05-26');

CALL sp_insertar_resultado('EVT-001','CAB-001',1,'1:12.45',3000000.00);
CALL sp_insertar_resultado('EVT-001','CAB-003',2,'1:13.10',1000000.00);
CALL sp_insertar_resultado('EVT-001','CAB-005',3,'1:13.58', 500000.00);
CALL sp_insertar_resultado('EVT-002','CAB-007',1,'0:48.32',2100000.00);
CALL sp_insertar_resultado('EVT-002','CAB-009',2,'0:49.01', 700000.00);
CALL sp_insertar_resultado('EVT-002','CAB-011',3,'0:49.55', 350000.00);
CALL sp_insertar_resultado('EVT-003','CAB-011',1,'1:58.20',2520000.00);
CALL sp_insertar_resultado('EVT-003','CAB-013',2,'1:59.45', 840000.00);
CALL sp_insertar_resultado('EVT-003','CAB-015',3,'2:00.12', 420000.00);
CALL sp_insertar_resultado('EVT-004','CAB-015',1,'2:21.30',4800000.00);
CALL sp_insertar_resultado('EVT-004','CAB-001',2,'2:22.15',1600000.00);
CALL sp_insertar_resultado('EVT-004','CAB-003',3,'2:23.00', 800000.00);
CALL sp_insertar_resultado('EVT-005','CAB-005',1,'1:02.48',3900000.00);
CALL sp_insertar_resultado('EVT-005','CAB-007',2,'1:03.12',1300000.00);
CALL sp_insertar_resultado('EVT-005','CAB-009',3,'1:03.55', 650000.00);
CALL sp_insertar_resultado('EVT-006','CAB-002',1,'1:26.15',2880000.00);
CALL sp_insertar_resultado('EVT-006','CAB-004',2,'1:27.05', 960000.00);
CALL sp_insertar_resultado('EVT-006','CAB-006',3,'1:27.48', 480000.00);
CALL sp_insertar_resultado('EVT-007','CAB-006',1,'2:10.34',4200000.00);
CALL sp_insertar_resultado('EVT-007','CAB-008',2,'2:11.20',1400000.00);
CALL sp_insertar_resultado('EVT-007','CAB-010',3,'2:12.05', 700000.00);
CALL sp_insertar_resultado('EVT-008','CAB-008',1,'1:15.40',3300000.00);
CALL sp_insertar_resultado('EVT-008','CAB-010',2,'1:16.22',1100000.00);
CALL sp_insertar_resultado('EVT-008','CAB-012',3,'1:17.01', 550000.00);
CALL sp_insertar_resultado('EVT-009','CAB-010',1,'2:52.10',5400000.00);
CALL sp_insertar_resultado('EVT-009','CAB-012',2,'2:53.45',1800000.00);
CALL sp_insertar_resultado('EVT-009','CAB-014',3,'2:54.30', 900000.00);
CALL sp_insertar_resultado('EVT-010','CAB-012',1,'0:50.18',1800000.00);
CALL sp_insertar_resultado('EVT-010','CAB-014',2,'0:51.05', 600000.00);
CALL sp_insertar_resultado('EVT-010','CAB-016',3,'0:51.48', 300000.00);

CALL sp_insertar_alerta('CAB-004','1-0501-0004','Estado de salud Regular — revisar antes de inscribir en próxima carrera.');
CALL sp_insertar_alerta('CAB-009','1-0501-0009','Historial de bronquitis: evitar carreras en condiciones de lluvia o humedad elevada.');
CALL sp_insertar_alerta('CAB-001','1-0501-0001','Seguimiento post-carrera: revisar articulaciones tras Copa Independencia 2025.');
CALL sp_insertar_alerta('CAB-006','1-0501-0006','Piel recuperada tras infección cutánea. Alta médica confirmada.');
