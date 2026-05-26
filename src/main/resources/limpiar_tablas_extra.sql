-- ================================================================
-- LIMPIEZA DE TABLAS EXTRA — Hipódromo Nacional
-- Ejecutar ANTES de bitacoras_particionadas.sql
-- ================================================================
-- Este script elimina tablas creadas manualmente que quedaron
-- fuera del schema oficial, incluyendo las bitácoras en plural
-- (serán recreadas correctamente por bitacoras_particionadas.sql)
-- ================================================================


-- ----------------------------------------------------------------
-- 1. Bitácoras creadas manualmente (nombres en plural / sin año)
--    Serán recreadas en singular por bitacoras_particionadas.sql
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS bitacora_caballos              CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2025_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2025_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2025_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2025_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2026_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2026_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2026_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_2026_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_q1           CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_q2           CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_q3           CASCADE;
DROP TABLE IF EXISTS bitacora_caballos_q4           CASCADE;

DROP TABLE IF EXISTS bitacora_eventos               CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2025_q1       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2025_q2       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2025_q3       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2025_q4       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2026_q1       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2026_q2       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2026_q3       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_2026_q4       CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_q1            CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_q2            CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_q3            CASCADE;
DROP TABLE IF EXISTS bitacora_eventos_q4            CASCADE;

DROP TABLE IF EXISTS bitacora_facturas              CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2025_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2025_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2025_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2025_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2026_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2026_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2026_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_2026_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_q1           CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_q2           CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_q3           CASCADE;
DROP TABLE IF EXISTS bitacora_facturas_q4           CASCADE;

DROP TABLE IF EXISTS bitacora_historial_veterinario              CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2025_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2025_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2025_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2025_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2026_q1      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2026_q2      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2026_q3      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_2026_q4      CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_q1           CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_q2           CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_q3           CASCADE;
DROP TABLE IF EXISTS bitacora_historial_veterinario_q4           CASCADE;

DROP TABLE IF EXISTS bitacora_propietarios          CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2025_q1  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2025_q2  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2025_q3  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2025_q4  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2026_q1  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2026_q2  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2026_q3  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_2026_q4  CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_q1       CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_q2       CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_q3       CASCADE;
DROP TABLE IF EXISTS bitacora_propietarios_q4       CASCADE;

DROP TABLE IF EXISTS bitacora_suministros           CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2025_q1   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2025_q2   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2025_q3   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2025_q4   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2026_q1   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2026_q2   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2026_q3   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_2026_q4   CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_q1        CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_q2        CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_q3        CASCADE;
DROP TABLE IF EXISTS bitacora_suministros_q4        CASCADE;

DROP TABLE IF EXISTS bitacora_2026_q1               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q2               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q3               CASCADE;
DROP TABLE IF EXISTS bitacora_2026_q4               CASCADE;


-- ----------------------------------------------------------------
-- 2. Tablas duplicadas en plural (vacías, versión anterior)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS caballos                 CASCADE;
DROP TABLE IF EXISTS establos                CASCADE;
DROP TABLE IF EXISTS eventos                 CASCADE;
DROP TABLE IF EXISTS facturas                CASCADE;
DROP TABLE IF EXISTS inscripciones           CASCADE;
DROP TABLE IF EXISTS propietarios            CASCADE;
DROP TABLE IF EXISTS resultados_carrera      CASCADE;
DROP TABLE IF EXISTS suministros             CASCADE;
DROP TABLE IF EXISTS historial_transacciones CASCADE;
DROP TABLE IF EXISTS alertas_veterinarias    CASCADE;
DROP TABLE IF EXISTS alertas_certificacion   CASCADE;


-- ----------------------------------------------------------------
-- 3. Tablas de contacto duplicadas
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS correo_propietario      CASCADE;
DROP TABLE IF EXISTS correos_propietario     CASCADE;
DROP TABLE IF EXISTS telefono_propietario    CASCADE;
DROP TABLE IF EXISTS telefonos_propietario   CASCADE;


-- ----------------------------------------------------------------
-- 4. Tablas geográficas de versión anterior
--    (barrio, canton, etc. SÍ se usan en el schema actual — NO borrar)
-- ----------------------------------------------------------------
-- No se eliminan: pais, provincia, canton, distrito, barrio
-- Son referenciadas por propietario(id_barrio) y establo(id_barrio)


-- ----------------------------------------------------------------
-- Verificación: tablas que quedan
-- ----------------------------------------------------------------
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
