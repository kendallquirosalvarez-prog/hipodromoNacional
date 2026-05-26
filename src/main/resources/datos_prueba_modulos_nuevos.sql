-- =================================================================
-- DATOS DE PRUEBA — Módulos Nuevos (Fase 2)
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia
--
-- PREREQUISITO: ejecutar datos_prueba.sql primero para tener los
-- datos base (caballos, propietarios, eventos, facturas).
--
-- Este script usa los stored procedures para demostrar la lógica
-- de negocio implementada en la base de datos.
-- =================================================================


-- -----------------------------------------------------------------
-- LIMPIEZA PREVIA (para poder ejecutar más de una vez)
-- -----------------------------------------------------------------
DELETE FROM historial_transaccion
  WHERE id_factura IN (
    'FAC-001','FAC-002','FAC-003','FAC-004','FAC-005',
    'FAC-006','FAC-007','FAC-009','FAC-011','FAC-012',
    'FAC-013','FAC-015','FAC-016'
  );

DELETE FROM alerta_veterinaria
  WHERE id_caballo IN (
    'CAB-001','CAB-002','CAB-003','CAB-004','CAB-005',
    'CAB-006','CAB-007','CAB-008','CAB-009','CAB-010',
    'CAB-011','CAB-012','CAB-013','CAB-014','CAB-015'
  );

DELETE FROM resultado_carrera
  WHERE id_evento IN (
    'EVT-001','EVT-002','EVT-003','EVT-004','EVT-005',
    'EVT-006','EVT-007','EVT-008','EVT-009','EVT-010'
  );

DELETE FROM alimentacion
  WHERE id_caballo IN (
    'CAB-001','CAB-002','CAB-003','CAB-004','CAB-005',
    'CAB-006','CAB-007','CAB-008','CAB-009','CAB-010',
    'CAB-011','CAB-012','CAB-013','CAB-014','CAB-015'
  );

-- Restaurar cantidades de suministro antes de re-insertar alimentacion
UPDATE suministro SET cantidad_disponible = 500 WHERE id_suministro = 'SUM-001';
UPDATE suministro SET cantidad_disponible = 300 WHERE id_suministro = 'SUM-002';
UPDATE suministro SET cantidad_disponible = 200 WHERE id_suministro = 'SUM-003';
UPDATE suministro SET cantidad_disponible = 150 WHERE id_suministro = 'SUM-008';


-- =================================================================
-- 1. HISTORIAL VETERINARIO
--    sp_insertar_historial_veterinario registra la certificación
--    que luego valida sp_insertar_inscripcion.
-- =================================================================

CALL sp_insertar_historial_veterinario(
  'HIV-001', 'CAB-001',
  'Revisión preventiva anual',
  'Vacunas y desparasitación',
  '2025-01-10', '2026-01-10',
  'Dr. Marco Solano'
);

CALL sp_insertar_historial_veterinario(
  'HIV-002', 'CAB-002',
  'Lesión leve en tendón anterior',
  'Reposo 15 días y anti-inflamatorio',
  '2025-01-15', '2026-01-15',
  'Dra. Laura Méndez'
);

CALL sp_insertar_historial_veterinario(
  'HIV-003', 'CAB-003',
  'Revisión preventiva anual',
  'Vacunas y desparasitación',
  '2025-02-05', '2026-02-05',
  'Dr. Marco Solano'
);

CALL sp_insertar_historial_veterinario(
  'HIV-004', 'CAB-004',
  'Cólico moderado',
  'Tratamiento hidratante y analgésico',
  '2025-02-18', '2026-02-18',
  'Dr. Pablo Castro'
);

CALL sp_insertar_historial_veterinario(
  'HIV-005', 'CAB-005',
  'Revisión pre-carrera',
  'Apto para competencia',
  '2025-03-01', '2026-03-01',
  'Dra. Laura Méndez'
);

CALL sp_insertar_historial_veterinario(
  'HIV-006', 'CAB-006',
  'Infección cutánea superficial',
  'Antibióticos tópicos 10 días',
  '2025-03-12', '2026-03-12',
  'Dr. Marco Solano'
);

CALL sp_insertar_historial_veterinario(
  'HIV-007', 'CAB-007',
  'Revisión preventiva anual',
  'Vacunas y desparasitación',
  '2025-04-02', '2026-04-02',
  'Dr. Pablo Castro'
);

CALL sp_insertar_historial_veterinario(
  'HIV-008', 'CAB-008',
  'Examen de pezuñas',
  'Herraje correctivo',
  '2025-04-15', '2026-04-15',
  'Dra. Laura Méndez'
);

CALL sp_insertar_historial_veterinario(
  'HIV-009', 'CAB-009',
  'Bronquitis leve',
  'Antibióticos y nebulización 7 días',
  '2025-05-03', '2026-05-03',
  'Dr. Marco Solano'
);

CALL sp_insertar_historial_veterinario(
  'HIV-010', 'CAB-010',
  'Revisión preventiva anual',
  'Vacunas y desparasitación',
  '2025-05-20', '2026-05-20',
  'Dra. Ana Vargas'
);

CALL sp_insertar_historial_veterinario(
  'HIV-011', 'CAB-011',
  'Revisión pre-carrera',
  'Apto para competencia',
  '2025-06-08', '2026-06-08',
  'Dr. Pablo Castro'
);

CALL sp_insertar_historial_veterinario(
  'HIV-012', 'CAB-012',
  'Otitis leve',
  'Tratamiento tópico auricular',
  '2025-06-22', '2026-06-22',
  'Dra. Laura Méndez'
);

CALL sp_insertar_historial_veterinario(
  'HIV-013', 'CAB-013',
  'Revisión preventiva anual',
  'Vacunas y desparasitación',
  '2025-07-10', '2026-07-10',
  'Dr. Marco Solano'
);

CALL sp_insertar_historial_veterinario(
  'HIV-014', 'CAB-014',
  'Distensión muscular',
  'Fisioterapia y reposo 20 días',
  '2025-07-28', '2026-07-28',
  'Dra. Ana Vargas'
);

CALL sp_insertar_historial_veterinario(
  'HIV-015', 'CAB-015',
  'Revisión de dentadura',
  'Limpieza dental y ajuste',
  '2025-08-06', '2026-08-06',
  'Dr. Pablo Castro'
);


-- =================================================================
-- 2. SUMINISTROS
--    sp_insertar_suministro registra el inventario inicial.
-- =================================================================

CALL sp_insertar_suministro('SUM-001', 'Alimento',    'Nutrición Equina S.A.',     500, 850.00);
CALL sp_insertar_suministro('SUM-002', 'Alimento',    'Agropecuaria Liberia',      300, 1200.00);
CALL sp_insertar_suministro('SUM-003', 'Alimento',    'Granos del Norte S.R.L.',   200, 650.00);
CALL sp_insertar_suministro('SUM-004', 'Medicamento', 'Veterinaria Central',        80, 3500.00);
CALL sp_insertar_suministro('SUM-005', 'Medicamento', 'PharmEquine C.R.',           50, 7200.00);
CALL sp_insertar_suministro('SUM-006', 'Equipo',      'Hipic Supply C.R.',          25, 15000.00);
CALL sp_insertar_suministro('SUM-007', 'Limpieza',    'Distribuidora Guanacaste',   90, 450.00);
CALL sp_insertar_suministro('SUM-008', 'Alimento',    'Nutrición Equina S.A.',     150, 980.00);

-- Verificar inventario antes de registrar alimentación
SELECT id_suministro, tipo, cantidad_disponible AS stock_inicial
  FROM suministro ORDER BY id_suministro;


-- =================================================================
-- 3. ALIMENTACION
--    sp_insertar_alimentacion registra la ración Y descuenta
--    automáticamente del inventario de suministros.
-- =================================================================

CALL sp_insertar_alimentacion('CAB-001', 'SUM-001', 'Heno',        5.00, '2026-05-20');
CALL sp_insertar_alimentacion('CAB-002', 'SUM-002', 'Concentrado', 3.50, '2026-05-20');
CALL sp_insertar_alimentacion('CAB-003', 'SUM-001', 'Heno',        4.50, '2026-05-21');
CALL sp_insertar_alimentacion('CAB-004', 'SUM-003', 'Avena',       2.00, '2026-05-21');
CALL sp_insertar_alimentacion('CAB-005', 'SUM-001', 'Heno',        5.50, '2026-05-22');
CALL sp_insertar_alimentacion('CAB-006', 'SUM-008', 'Zanahoria',   1.50, '2026-05-22');
CALL sp_insertar_alimentacion('CAB-007', 'SUM-002', 'Concentrado', 4.00, '2026-05-23');
CALL sp_insertar_alimentacion('CAB-008', 'SUM-001', 'Heno',        5.00, '2026-05-23');
CALL sp_insertar_alimentacion('CAB-009', 'SUM-003', 'Avena',       2.50, '2026-05-24');
CALL sp_insertar_alimentacion('CAB-010', 'SUM-001', 'Heno',        4.00, '2026-05-24');
CALL sp_insertar_alimentacion('CAB-011', 'SUM-002', 'Concentrado', 3.00, '2026-05-25');
CALL sp_insertar_alimentacion('CAB-012', 'SUM-001', 'Heno',        5.00, '2026-05-25');
CALL sp_insertar_alimentacion('CAB-013', 'SUM-008', 'Zanahoria',   2.00, '2026-05-25');
CALL sp_insertar_alimentacion('CAB-014', 'SUM-003', 'Avena',       3.00, '2026-05-26');
CALL sp_insertar_alimentacion('CAB-015', 'SUM-001', 'Heno',        4.50, '2026-05-26');

-- Verificar descuento automático en inventario (stock debe ser menor al inicial)
SELECT s.id_suministro, s.tipo, s.cantidad_disponible AS stock_actual,
       SUM(FLOOR(a.cantidad))::INTEGER AS unidades_consumidas
  FROM suministro s
  LEFT JOIN alimentacion a ON a.id_suministro = s.id_suministro
 GROUP BY s.id_suministro, s.tipo, s.cantidad_disponible
 ORDER BY s.id_suministro;


-- =================================================================
-- 4. RESULTADO_CARRERA
--    sp_insertar_resultado registra el desempeño de cada caballo
--    en eventos ya finalizados.
-- =================================================================

-- EVT-001: Gran Premio Guanacaste 2025
CALL sp_insertar_resultado('EVT-001', 'CAB-001', 1, '1:12.45', 3000000.00);
CALL sp_insertar_resultado('EVT-001', 'CAB-003', 2, '1:13.10', 1000000.00);
CALL sp_insertar_resultado('EVT-001', 'CAB-005', 3, '1:13.58',  500000.00);

-- EVT-002: Copa Liberia Primavera
CALL sp_insertar_resultado('EVT-002', 'CAB-007', 1, '0:48.32', 2100000.00);
CALL sp_insertar_resultado('EVT-002', 'CAB-009', 2, '0:49.01',  700000.00);
CALL sp_insertar_resultado('EVT-002', 'CAB-011', 3, '0:49.55',  350000.00);

-- EVT-003: Carrera del Sol
CALL sp_insertar_resultado('EVT-003', 'CAB-011', 1, '1:58.20', 2520000.00);
CALL sp_insertar_resultado('EVT-003', 'CAB-013', 2, '1:59.45',  840000.00);
CALL sp_insertar_resultado('EVT-003', 'CAB-015', 3, '2:00.12',  420000.00);

-- EVT-004: Premio Nacional Pura Sangre
CALL sp_insertar_resultado('EVT-004', 'CAB-015', 1, '2:21.30', 4800000.00);
CALL sp_insertar_resultado('EVT-004', 'CAB-001', 2, '2:22.15', 1600000.00);
CALL sp_insertar_resultado('EVT-004', 'CAB-003', 3, '2:23.00',  800000.00);

-- EVT-005: Trofeo Costa Rica
CALL sp_insertar_resultado('EVT-005', 'CAB-005', 1, '1:02.48', 3900000.00);
CALL sp_insertar_resultado('EVT-005', 'CAB-007', 2, '1:03.12', 1300000.00);

-- EVT-006: Copa Sabana Verde
CALL sp_insertar_resultado('EVT-006', 'CAB-002', 1, '1:26.15', 2880000.00);
CALL sp_insertar_resultado('EVT-006', 'CAB-004', 2, '1:27.05',  960000.00);

-- EVT-007: Gran Carrera del Pacífico
CALL sp_insertar_resultado('EVT-007', 'CAB-006', 1, '2:10.34', 4200000.00);
CALL sp_insertar_resultado('EVT-007', 'CAB-008', 2, '2:11.20', 1400000.00);

-- EVT-008: Campeonato Interregional
CALL sp_insertar_resultado('EVT-008', 'CAB-008', 1, '1:15.40', 3300000.00);
CALL sp_insertar_resultado('EVT-008', 'CAB-010', 2, '1:16.22', 1100000.00);

-- EVT-009: Copa Independencia 2025
CALL sp_insertar_resultado('EVT-009', 'CAB-010', 1, '2:52.10', 5400000.00);
CALL sp_insertar_resultado('EVT-009', 'CAB-012', 2, '2:53.45', 1800000.00);
CALL sp_insertar_resultado('EVT-009', 'CAB-014', 3, '2:54.30',  900000.00);

-- EVT-010: Premio Otoño
CALL sp_insertar_resultado('EVT-010', 'CAB-012', 1, '0:50.18', 1800000.00);
CALL sp_insertar_resultado('EVT-010', 'CAB-014', 2, '0:51.05',  600000.00);


-- =================================================================
-- 5. ALERTA_VETERINARIA
--    sp_insertar_alerta crea notificaciones para propietarios.
--    Nota: el trigger fn_alerta_vencimiento las genera automáticamente
--    cuando se inserta un historial con cert. próxima a vencer.
-- =================================================================

-- Alertas manuales adicionales (además de las generadas por trigger)
CALL sp_insertar_alerta(
  'CAB-004', '1-0501-0004',
  'Estado de salud Regular — se recomienda revisión antes de inscribir en próxima carrera.'
);

CALL sp_insertar_alerta(
  'CAB-009', '1-0501-0009',
  'Historial de bronquitis: evitar carreras en condiciones de lluvia o humedad elevada.'
);

CALL sp_insertar_alerta(
  'CAB-015', '5-0245-0015',
  'Certificación vence el 2026-08-06 — programar revisión veterinaria con anticipación.'
);

CALL sp_insertar_alerta(
  'CAB-001', '1-0501-0001',
  'Seguimiento post-carrera: revisar articulaciones tras Copa Independencia 2025.'
);

CALL sp_insertar_alerta(
  'CAB-006', '1-0501-0006',
  'Piel recuperada tras infección cutánea. Alta médica confirmada.'
);

-- Marcar algunas alertas como leídas
CALL sp_marcar_alerta_leida(1);
CALL sp_marcar_alerta_leida(3);


-- =================================================================
-- 6. HISTORIAL_TRANSACCION
--    sp_insertar_transaccion registra el pago de una factura.
-- =================================================================

CALL sp_insertar_transaccion('FAC-001', 169500.00, 'Transferencia SINPE', '2025-02-16');
CALL sp_insertar_transaccion('FAC-002', 169500.00, 'Efectivo',            '2025-02-17');
CALL sp_insertar_transaccion('FAC-003', 122040.00, 'SINPE Móvil',         '2025-03-09');
CALL sp_insertar_transaccion('FAC-004', 152550.00, 'Tarjeta débito',      '2025-04-21');
CALL sp_insertar_transaccion('FAC-005', 226000.00, 'Transferencia SINPE', '2025-05-11');
CALL sp_insertar_transaccion('FAC-006', 183060.00, 'Efectivo',            '2025-06-15');
CALL sp_insertar_transaccion('FAC-007', 163850.00, 'SINPE Móvil',         '2025-07-06');
CALL sp_insertar_transaccion('FAC-009', 180800.00, 'Tarjeta crédito',     '2025-09-13');
CALL sp_insertar_transaccion('FAC-011', 124300.00, 'Transferencia SINPE', '2025-10-19');
CALL sp_insertar_transaccion('FAC-012', 147532.50, 'SINPE Móvil',         '2025-07-07');
CALL sp_insertar_transaccion('FAC-013', 197750.00, 'Transferencia SINPE', '2025-08-25');
CALL sp_insertar_transaccion('FAC-015', 237300.00, 'Efectivo',            '2025-09-16');
CALL sp_insertar_transaccion('FAC-016', 111870.00, 'Tarjeta débito',      '2025-10-20');


-- =================================================================
-- VERIFICACIÓN FINAL
-- =================================================================
SELECT
    'historial_veterinario' AS modulo, COUNT(*) AS registros FROM historial_veterinario
UNION ALL SELECT 'suministro',          COUNT(*) FROM suministro
UNION ALL SELECT 'alimentacion',        COUNT(*) FROM alimentacion
UNION ALL SELECT 'resultado_carrera',   COUNT(*) FROM resultado_carrera
UNION ALL SELECT 'alerta_veterinaria',  COUNT(*) FROM alerta_veterinaria
UNION ALL SELECT 'historial_transaccion', COUNT(*) FROM historial_transaccion
ORDER BY modulo;
