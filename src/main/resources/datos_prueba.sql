-- Datos de prueba para el sistema Hipódromo Nacional.
-- Ejecutar en Supabase SQL Editor.
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia

-- Limpiar datos existentes respetando FK (orden inverso de dependencias)
TRUNCATE TABLE historial_transaccion CASCADE;
TRUNCATE TABLE alerta_veterinaria CASCADE;
TRUNCATE TABLE resultado_carrera CASCADE;
TRUNCATE TABLE alimentacion CASCADE;
TRUNCATE TABLE suministro CASCADE;
TRUNCATE TABLE factura CASCADE;
TRUNCATE TABLE historial_veterinario CASCADE;
TRUNCATE TABLE inscripcion CASCADE;
TRUNCATE TABLE evento CASCADE;
TRUNCATE TABLE caballo CASCADE;
TRUNCATE TABLE establo CASCADE;
TRUNCATE TABLE propietario CASCADE;
TRUNCATE TABLE barrio CASCADE;
TRUNCATE TABLE distrito CASCADE;
TRUNCATE TABLE canton CASCADE;
TRUNCATE TABLE provincia CASCADE;
TRUNCATE TABLE pais CASCADE;

-- Países
INSERT INTO pais (id_pais, nombre_pais) VALUES
(1, 'Costa Rica'),
(2, 'Panamá'),
(3, 'Nicaragua'),
(4, 'Honduras'),
(5, 'El Salvador');

-- Provincias
INSERT INTO provincia (id_provincia, nombre_provincia, id_pais) VALUES
(1, 'Guanacaste',   1),
(2, 'San José',     1),
(3, 'Alajuela',     1),
(4, 'Heredia',      1),
(5, 'Puntarenas',   1);

-- Cantones
INSERT INTO canton (id_canton, nombre_canton, id_provincia) VALUES
(1, 'Liberia',      1),
(2, 'Nicoya',       1),
(3, 'Santa Cruz',   1),
(4, 'Bagaces',      1),
(5, 'Cañas',        1);

-- Distritos
INSERT INTO distrito (id_distrito, nombre_distrito, id_canton) VALUES
(1, 'Liberia Centro',  1),
(2, 'Cañas Dulces',    1),
(3, 'Mayorga',         1),
(4, 'Nacascolo',       1),
(5, 'Curubandé',       1);

-- Barrios
INSERT INTO barrio (nombre_barrio, id_distrito) VALUES
('Barrio El Bosque',        1),
('Barrio La Libertad',      1),
('Barrio Los Ángeles',      1),
('Barrio San Roque',        1),
('Barrio Victoria',         1),
('Barrio El Progreso',      2),
('Barrio Las Palmas',       2),
('Barrio Nuevo Horizonte',  2),
('Barrio Santa Cecilia',    2),
('Barrio La Paz',           2),
('Barrio El Roble',         3),
('Barrio Las Flores',       3),
('Barrio Montaña Verde',    3),
('Barrio San Francisco',    3),
('Barrio La Colina',        3),
('Barrio El Manglar',       4),
('Barrio Los Pinos',        4),
('Barrio Río Claro',        4),
('Barrio El Paraíso',       5),
('Barrio Las Brisas',       5);

-- Propietarios (cédulas en formato costarricense X-XXXX-XXXX)
INSERT INTO propietario (id_propietario, nombre, apellidos, id_barrio, propietario_con_descuento_proxima_facturacion) VALUES
('1-0501-0001', 'Carlos',    'Rodríguez Mora',       1,  false),
('1-0501-0002', 'María',     'González Jiménez',     2,  false),
('1-0501-0003', 'Luis',      'Vargas Solano',        3,  true),
('1-0501-0004', 'Ana',       'Campos Herrera',       4,  false),
('1-0501-0005', 'Jorge',     'Madrigal Rojas',       5,  false),
('1-0501-0006', 'Patricia',  'Ureña Brenes',         6,  true),
('1-0501-0007', 'Roberto',   'Chavarría Castro',     7,  false),
('1-0501-0008', 'Silvia',    'Mora Aguilar',         8,  false),
('1-0501-0009', 'Fernando',  'Salazar Vega',         9,  true),
('1-0501-0010', 'Lorena',    'Quirós Elizondo',      10, false),
('5-0245-0011', 'Andrés',    'Hidalgo Núñez',        11, false),
('5-0245-0012', 'Carmen',    'Araya Fonseca',        12, true),
('5-0245-0013', 'Manuel',    'Chaves Gutiérrez',     13, false),
('5-0245-0014', 'Isabel',    'Quesada Ramírez',      14, false),
('5-0245-0015', 'Diego',     'Valverde Picado',      15, false),
('5-0245-0016', 'Elena',     'Benavides Monge',      16, true),
('5-0245-0017', 'Gustavo',   'Solís Pérez',          17, false),
('5-0245-0018', 'Natalia',   'Corrales Badilla',     18, false),
('5-0245-0019', 'Rodrigo',   'Alpízar Zamora',       19, true),
('5-0245-0020', 'Marcela',   'Barrantes López',      20, false);

-- Establos
INSERT INTO establo (id_establo, capacidad, estado, id_barrio) VALUES
('EST-001', 15, 'Activo',             1),
('EST-002', 20, 'Activo',             2),
('EST-003', 10, 'Lleno',              3),
('EST-004', 25, 'Activo',             4),
('EST-005', 12, 'En Mantenimiento',   5),
('EST-006', 18, 'Activo',             6),
('EST-007', 30, 'Activo',             7),
('EST-008', 8,  'Lleno',              8),
('EST-009', 22, 'Activo',             9),
('EST-010', 16, 'Activo',             10),
('EST-011', 14, 'En Mantenimiento',   11),
('EST-012', 20, 'Activo',             12),
('EST-013', 10, 'Activo',             13),
('EST-014', 25, 'Lleno',              14),
('EST-015', 18, 'Activo',             15),
('EST-016', 12, 'Activo',             16),
('EST-017', 20, 'Activo',             17),
('EST-018', 15, 'En Mantenimiento',   18),
('EST-019', 30, 'Activo',             19),
('EST-020', 22, 'Activo',             20);

-- Caballos
INSERT INTO caballo (id_caballo, nombre, fecha_nacimiento, sexo, raza, peso, estado_salud, id_propietario, id_establo) VALUES
('CAB-001', 'Relámpago',     '2018-03-15', 'M', 'Pura Sangre',        480.50, 'Óptimo',     '1-0501-0001', 'EST-001'),
('CAB-002', 'Tormenta',      '2019-06-22', 'H', 'Cuarto de Milla',    430.00, 'Bueno',      '1-0501-0002', 'EST-002'),
('CAB-003', 'Ciclón',        '2017-11-08', 'M', 'Árabe',              460.75, 'Óptimo',     '1-0501-0003', 'EST-003'),
('CAB-004', 'Aurora',        '2020-01-30', 'H', 'Pura Sangre',        410.25, 'Regular',    '1-0501-0004', 'EST-004'),
('CAB-005', 'Trueno',        '2016-08-14', 'M', 'Appaloosa',          495.00, 'Óptimo',     '1-0501-0005', 'EST-005'),
('CAB-006', 'Estrella',      '2021-02-20', 'H', 'Cuarto de Milla',    395.50, 'Bueno',      '1-0501-0006', 'EST-006'),
('CAB-007', 'Bravo',         '2018-09-05', 'M', 'Pura Sangre',        470.00, 'Óptimo',     '1-0501-0007', 'EST-007'),
('CAB-008', 'Luna',          '2019-12-18', 'H', 'Árabe',              415.75, 'Bueno',      '1-0501-0008', 'EST-008'),
('CAB-009', 'Volcán',        '2017-04-25', 'M', 'Pura Sangre',        488.25, 'Regular',    '1-0501-0009', 'EST-009'),
('CAB-010', 'Niebla',        '2020-07-11', 'H', 'Cuarto de Milla',    425.00, 'Óptimo',     '1-0501-0010', 'EST-010'),
('CAB-011', 'Fuego',         '2016-05-03', 'M', 'Appaloosa',          501.50, 'Bueno',      '5-0245-0011', 'EST-011'),
('CAB-012', 'Esmeralda',     '2022-01-16', 'H', 'Pura Sangre',        400.00, 'Óptimo',     '5-0245-0012', 'EST-012'),
('CAB-013', 'Vendaval',      '2018-10-29', 'M', 'Árabe',              465.25, 'Bueno',      '5-0245-0013', 'EST-013'),
('CAB-014', 'Perla',         '2019-03-08', 'H', 'Cuarto de Milla',    435.75, 'Óptimo',     '5-0245-0014', 'EST-014'),
('CAB-015', 'Titán',         '2017-08-22', 'M', 'Pura Sangre',        492.00, 'Regular',    '5-0245-0015', 'EST-015'),
('CAB-016', 'Diamante',      '2020-11-14', 'H', 'Árabe',              420.50, 'Bueno',      '5-0245-0016', 'EST-016'),
('CAB-017', 'Centella',      '2018-06-30', 'M', 'Pura Sangre',        478.00, 'Óptimo',     '5-0245-0017', 'EST-017'),
('CAB-018', 'Brisa',         '2021-09-05', 'H', 'Cuarto de Milla',    405.25, 'Bueno',      '5-0245-0018', 'EST-018'),
('CAB-019', 'Rayo',          '2016-12-20', 'M', 'Appaloosa',          510.00, 'Óptimo',     '5-0245-0019', 'EST-019'),
('CAB-020', 'Sirena',        '2019-04-17', 'H', 'Árabe',              412.75, 'Regular',    '5-0245-0020', 'EST-020');

-- Eventos
INSERT INTO evento (id_evento, nombre, fecha, tipo_carrera, distancia, premio_total, estado) VALUES
('EVT-001', 'Gran Premio Guanacaste 2025',       '2025-02-15 10:00:00', 'Clásica',      1200, 5000000.00,  'Finalizado'),
('EVT-002', 'Copa Liberia Primavera',             '2025-03-08 09:00:00', 'Velocidad',    800,  3500000.00,  'Finalizado'),
('EVT-003', 'Carrera del Sol',                   '2025-04-20 11:00:00', 'Obstáculos',   1600, 4200000.00,  'Finalizado'),
('EVT-004', 'Premio Nacional Pura Sangre',       '2025-05-10 10:00:00', 'Clásica',      2000, 8000000.00,  'Finalizado'),
('EVT-005', 'Trofeo Costa Rica',                 '2025-06-14 09:30:00', 'Velocidad',    1000, 6500000.00,  'Finalizado'),
('EVT-006', 'Copa Sabana Verde',                 '2025-07-05 10:00:00', 'Clásica',      1400, 4800000.00,  'Finalizado'),
('EVT-007', 'Gran Carrera del Pacífico',         '2025-08-23 11:00:00', 'Obstáculos',   1800, 7000000.00,  'Finalizado'),
('EVT-008', 'Campeonato Interregional',          '2025-09-12 09:00:00', 'Velocidad',    1200, 5500000.00,  'Finalizado'),
('EVT-009', 'Copa Independencia 2025',           '2025-09-15 10:00:00', 'Clásica',      2400, 9000000.00,  'Finalizado'),
('EVT-010', 'Premio Otoño',                      '2025-10-18 09:30:00', 'Velocidad',    800,  3000000.00,  'Finalizado'),
('EVT-011', 'Gran Premio Diciembre',             '2025-12-06 10:00:00', 'Clásica',      1600, 6000000.00,  'Programado'),
('EVT-012', 'Copa Navideña',                     '2025-12-20 09:00:00', 'Velocidad',    1000, 4500000.00,  'Programado'),
('EVT-013', 'Carrera de Año Nuevo',              '2026-01-10 11:00:00', 'Clásica',      1200, 5200000.00,  'Programado'),
('EVT-014', 'Copa Febrero Temporada',            '2026-02-07 10:00:00', 'Obstáculos',   1600, 4700000.00,  'Programado'),
('EVT-015', 'Gran Premio Verano 2026',           '2026-02-28 09:30:00', 'Clásica',      2000, 8500000.00,  'Programado'),
('EVT-016', 'Premio Primavera 2026',             '2026-03-21 10:00:00', 'Velocidad',    800,  3200000.00,  'Programado'),
('EVT-017', 'Trofeo Regional Norte',             '2026-04-11 11:00:00', 'Clásica',      1400, 5800000.00,  'Programado'),
('EVT-018', 'Copa Mayo 2026',                    '2026-05-02 09:00:00', 'Velocidad',    1000, 4000000.00,  'Programado'),
('EVT-019', 'Gran Carrera Aniversario',          '2026-05-15 10:00:00', 'Clásica',      1800, 7500000.00,  'En Curso'),
('EVT-020', 'Premio Especial Guanacaste 2026',   '2026-07-25 09:30:00', 'Obstáculos',   2000, 9500000.00,  'Programado');

-- Inscripciones
-- id_inscripcion es VARCHAR(50)
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
('INS-019', 'EVT-019', 'CAB-018', '2026-05-01', 'En Carrera', NULL),
('INS-020', 'EVT-019', 'CAB-020', '2026-05-01', 'En Carrera', NULL);

-- Historial veterinario
INSERT INTO historial_veterinario (id_registro, id_caballo, diagnostico, tratamiento, fecha_revision, fecha_vencimiento_certificacion, veterinario_responsable) VALUES
('HIV-001', 'CAB-001', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-01-10', '2026-01-10', 'Dr. Marco Solano'),
('HIV-002', 'CAB-002', 'Lesión leve en tendón anterior',      'Reposo 15 días y anti-inflamatorio',   '2025-01-15', '2026-01-15', 'Dra. Laura Méndez'),
('HIV-003', 'CAB-003', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-02-05', '2026-02-05', 'Dr. Marco Solano'),
('HIV-004', 'CAB-004', 'Cólico moderado',                     'Tratamiento hidratante y analgésico',  '2025-02-18', '2026-02-18', 'Dr. Pablo Castro'),
('HIV-005', 'CAB-005', 'Revisión pre-carrera',                'Apto para competencia',                '2025-03-01', '2026-03-01', 'Dra. Laura Méndez'),
('HIV-006', 'CAB-006', 'Infección cutánea superficial',       'Antibióticos tópicos 10 días',         '2025-03-12', '2026-03-12', 'Dr. Marco Solano'),
('HIV-007', 'CAB-007', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-04-02', '2026-04-02', 'Dr. Pablo Castro'),
('HIV-008', 'CAB-008', 'Examen de pezuñas',                   'Herraje correctivo',                   '2025-04-15', '2026-04-15', 'Dra. Laura Méndez'),
('HIV-009', 'CAB-009', 'Bronquitis leve',                     'Antibióticos y nebulización 7 días',   '2025-05-03', '2026-05-03', 'Dr. Marco Solano'),
('HIV-010', 'CAB-010', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-05-20', '2026-05-20', 'Dra. Ana Vargas'),
('HIV-011', 'CAB-011', 'Revisión pre-carrera',                'Apto para competencia',                '2025-06-08', '2026-06-08', 'Dr. Pablo Castro'),
('HIV-012', 'CAB-012', 'Otitis leve',                         'Tratamiento tópico auricular',         '2025-06-22', '2026-06-22', 'Dra. Laura Méndez'),
('HIV-013', 'CAB-013', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-07-10', '2026-07-10', 'Dr. Marco Solano'),
('HIV-014', 'CAB-014', 'Distensión muscular',                 'Fisioterapia y reposo 20 días',        '2025-07-28', '2026-07-28', 'Dra. Ana Vargas'),
('HIV-015', 'CAB-015', 'Revisión de dentadura',               'Limpieza dental y ajuste',             '2025-08-06', '2026-08-06', 'Dr. Pablo Castro'),
('HIV-016', 'CAB-016', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-08-19', '2026-08-19', 'Dra. Laura Méndez'),
('HIV-017', 'CAB-017', 'Úlcera gástrica leve',               'Omeprazol equino 30 días',             '2025-09-04', '2026-09-04', 'Dr. Marco Solano'),
('HIV-018', 'CAB-018', 'Revisión pre-carrera',                'Apto para competencia',                '2025-09-15', '2026-09-15', 'Dra. Ana Vargas'),
('HIV-019', 'CAB-019', 'Herida superficial en flanco',        'Limpieza y vendaje 5 días',            '2025-10-01', '2026-10-01', 'Dr. Pablo Castro'),
('HIV-020', 'CAB-020', 'Revisión preventiva anual',           'Vacunas y desparasitación',            '2025-10-14', '2026-10-14', 'Dra. Laura Méndez');

-- Facturas (subtotal * 0.13 = impuestos; total = subtotal - descuento + impuestos)
INSERT INTO factura (id_factura, id_propietario, id_evento, subtotal, descuento, impuestos, total, estado_pago, fecha_emision) VALUES
('FAC-001', '1-0501-0001', 'EVT-001', 150000.00, 0.00,     19500.00,  169500.00,  'Pagado',    '2025-02-15 12:00:00'),
('FAC-002', '1-0501-0002', 'EVT-001', 150000.00, 0.00,     19500.00,  169500.00,  'Pagado',    '2025-02-15 12:00:00'),
('FAC-003', '1-0501-0003', 'EVT-002', 120000.00, 12000.00, 14040.00,  122040.00,  'Pagado',    '2025-03-08 11:00:00'),
('FAC-004', '1-0501-0004', 'EVT-003', 135000.00, 0.00,     17550.00,  152550.00,  'Pagado',    '2025-04-20 13:00:00'),
('FAC-005', '1-0501-0005', 'EVT-004', 200000.00, 0.00,     26000.00,  226000.00,  'Pagado',    '2025-05-10 12:30:00'),
('FAC-006', '1-0501-0006', 'EVT-005', 180000.00, 18000.00, 21060.00,  183060.00,  'Pagado',    '2025-06-14 11:00:00'),
('FAC-007', '1-0501-0007', 'EVT-006', 145000.00, 0.00,     18850.00,  163850.00,  'Pagado',    '2025-07-05 12:00:00'),
('FAC-008', '1-0501-0008', 'EVT-007', 175000.00, 0.00,     22750.00,  197750.00,  'Pendiente', '2025-08-23 13:00:00'),
('FAC-009', '1-0501-0009', 'EVT-008', 160000.00, 0.00,     20800.00,  180800.00,  'Pagado',    '2025-09-12 11:30:00'),
('FAC-010', '1-0501-0010', 'EVT-009', 210000.00, 0.00,     27300.00,  237300.00,  'Pendiente', '2025-09-15 12:00:00'),
('FAC-011', '5-0245-0011', 'EVT-010', 110000.00, 0.00,     14300.00,  124300.00,  'Pagado',    '2025-10-18 10:00:00'),
('FAC-012', '5-0245-0012', 'EVT-006', 145000.00, 14500.00, 17032.50,  147532.50,  'Pagado',    '2025-07-05 12:30:00'),
('FAC-013', '5-0245-0013', 'EVT-007', 175000.00, 0.00,     22750.00,  197750.00,  'Pagado',    '2025-08-23 13:30:00'),
('FAC-014', '5-0245-0014', 'EVT-008', 160000.00, 0.00,     20800.00,  180800.00,  'Pendiente', '2025-09-12 12:00:00'),
('FAC-015', '5-0245-0015', 'EVT-009', 210000.00, 0.00,     27300.00,  237300.00,  'Pagado',    '2025-09-15 12:30:00'),
('FAC-016', '5-0245-0016', 'EVT-010', 110000.00, 11000.00, 12870.00,  111870.00,  'Pagado',    '2025-10-18 10:30:00'),
('FAC-017', '5-0245-0017', 'EVT-011', 165000.00, 0.00,     21450.00,  186450.00,  'Pendiente', '2025-11-01 09:00:00'),
('FAC-018', '5-0245-0018', 'EVT-011', 165000.00, 0.00,     21450.00,  186450.00,  'Pendiente', '2025-11-01 09:30:00'),
('FAC-019', '5-0245-0019', 'EVT-019', 190000.00, 19000.00, 22230.00,  193230.00,  'Pendiente', '2026-05-01 10:00:00'),
('FAC-020', '5-0245-0020', 'EVT-019', 190000.00, 0.00,     24700.00,  214700.00,  'Pendiente', '2026-05-01 10:30:00');

-- Suministros (inventario de alimentos y materiales)
INSERT INTO suministro (id_suministro, tipo, proveedor, cantidad_disponible, precio_unitario) VALUES
('SUM-001', 'Alimento',    'Nutrición Equina S.A.',    500, 850.00),
('SUM-002', 'Alimento',    'Agropecuaria Liberia',     300, 1200.00),
('SUM-003', 'Alimento',    'Granos del Norte S.R.L.',  200, 650.00),
('SUM-004', 'Medicamento', 'Veterinaria Central',       80, 3500.00),
('SUM-005', 'Medicamento', 'PharmEquine C.R.',          50, 7200.00),
('SUM-006', 'Equipo',      'Hipic Supply C.R.',         25, 15000.00),
('SUM-007', 'Limpieza',    'Distribuidora Guanacaste',  90, 450.00),
('SUM-008', 'Alimento',    'Nutrición Equina S.A.',    150, 980.00);

-- Alimentación (raciones registradas; el stored procedure descuenta de suministros)
INSERT INTO alimentacion (id_caballo, id_suministro, tipo_alimento, cantidad, fecha) VALUES
('CAB-001', 'SUM-001', 'Heno',        5.00, '2026-05-20'),
('CAB-002', 'SUM-002', 'Concentrado', 3.50, '2026-05-20'),
('CAB-003', 'SUM-001', 'Heno',        4.50, '2026-05-21'),
('CAB-004', 'SUM-003', 'Avena',       2.00, '2026-05-21'),
('CAB-005', 'SUM-001', 'Heno',        5.50, '2026-05-22'),
('CAB-006', 'SUM-008', 'Zanahoria',   1.50, '2026-05-22'),
('CAB-007', 'SUM-002', 'Concentrado', 4.00, '2026-05-23'),
('CAB-008', 'SUM-001', 'Heno',        5.00, '2026-05-23'),
('CAB-009', 'SUM-003', 'Avena',       2.50, '2026-05-24'),
('CAB-010', 'SUM-001', 'Heno',        4.00, '2026-05-24');

-- Resultados de carrera (eventos ya finalizados)
INSERT INTO resultado_carrera (id_evento, id_caballo, posicion, tiempo, premio_ganado) VALUES
('EVT-001', 'CAB-001', 1, '1:12.45', 3000000.00),
('EVT-001', 'CAB-003', 2, '1:13.10', 1000000.00),
('EVT-001', 'CAB-005', 3, '1:13.58',  500000.00),
('EVT-002', 'CAB-007', 1, '0:48.32', 2100000.00),
('EVT-002', 'CAB-009', 2, '0:49.01',  700000.00),
('EVT-003', 'CAB-011', 1, '1:58.20', 2520000.00),
('EVT-003', 'CAB-013', 2, '1:59.45',  840000.00),
('EVT-004', 'CAB-015', 1, '2:21.30', 4800000.00),
('EVT-004', 'CAB-017', 2, '2:22.15', 1600000.00),
('EVT-005', 'CAB-019', 1, '1:02.48', 3900000.00);

-- Alertas veterinarias (generadas por el trigger de vencimiento)
INSERT INTO alerta_veterinaria (id_caballo, id_propietario, mensaje, leida, fecha_alerta) VALUES
('CAB-001', '1-0501-0001', 'Certificación vence el 2026-01-10 — renovar antes de inscribir a próxima carrera', true,  '2025-12-11 08:00:00'),
('CAB-004', '1-0501-0004', 'Certificación vence el 2026-02-18 — animal en estado Regular, revisar antes de competir', false, '2026-01-19 08:00:00'),
('CAB-009', '1-0501-0009', 'Certificación vence el 2026-05-03 — próximo vencimiento dentro de 30 días', false, '2026-04-03 08:00:00'),
('CAB-015', '5-0245-0015', 'Certificación vence el 2026-08-06 — programar revisión veterinaria', false, '2026-07-07 08:00:00');

-- Historial de transacciones (pagos de facturas)
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

-- Verificación de conteos
SELECT 'pais'                    AS tabla, COUNT(*) AS registros FROM pais
UNION ALL SELECT 'propietario',          COUNT(*) FROM propietario
UNION ALL SELECT 'establo',              COUNT(*) FROM establo
UNION ALL SELECT 'caballo',              COUNT(*) FROM caballo
UNION ALL SELECT 'evento',               COUNT(*) FROM evento
UNION ALL SELECT 'inscripcion',          COUNT(*) FROM inscripcion
UNION ALL SELECT 'historial_veterinario',COUNT(*) FROM historial_veterinario
UNION ALL SELECT 'factura',              COUNT(*) FROM factura
UNION ALL SELECT 'suministro',           COUNT(*) FROM suministro
UNION ALL SELECT 'alimentacion',         COUNT(*) FROM alimentacion
UNION ALL SELECT 'resultado_carrera',    COUNT(*) FROM resultado_carrera
UNION ALL SELECT 'alerta_veterinaria',   COUNT(*) FROM alerta_veterinaria
UNION ALL SELECT 'historial_transaccion',COUNT(*) FROM historial_transaccion
ORDER BY tabla;
