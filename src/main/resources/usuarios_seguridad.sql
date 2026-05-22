-- =============================================================
-- SEGURIDAD: Tabla de usuarios del sistema Hipódromo Nacional
-- Ejecutar en Supabase SQL Editor
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia
-- =============================================================

-- 1. Crear tabla
CREATE TABLE IF NOT EXISTS usuarios (
    username VARCHAR(50)  PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nombre   VARCHAR(150) NOT NULL,
    rol      VARCHAR(50)  NOT NULL,
    activo   BOOLEAN      DEFAULT TRUE
);

-- 2. Insertar usuarios del grupo
--    El prefijo {noop} indica contraseña en texto plano (solo para desarrollo/demo)
INSERT INTO usuarios (username, password, nombre, rol, activo) VALUES
    ('c19296', '{noop}C19296', 'Kendall Andrés Quirós Álvarez',  'ROLE_ADMIN',       true),
    ('c20051', '{noop}C20051', 'Kristy Daniela Acosta Mercado',  'ROLE_VETERINARIO', true),
    ('c23112', '{noop}C23112', 'Dering Josué García Acevedo',    'ROLE_OPERADOR',    true),
    ('c24510', '{noop}C24510', 'Justin Josué Marenco Herrera',   'ROLE_ADMIN',       true),
    ('c17735', '{noop}C17735', 'David Daniel Sotela Sánchez',    'ROLE_ENCARGADO',   true)
ON CONFLICT (username) DO NOTHING;

-- 3. Verificar resultado
SELECT username, nombre, rol, activo FROM usuarios ORDER BY username;
