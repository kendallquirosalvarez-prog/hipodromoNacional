-- =============================================================
-- SEGURIDAD: Tabla de usuarios del sistema Hipódromo Nacional
-- Ejecutar en Supabase SQL Editor ANTES de iniciar la aplicación
-- IF-5100 Administración de Bases de Datos · UCR Sede Liberia
-- =============================================================

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    username VARCHAR(50)  PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nombre   VARCHAR(150) NOT NULL,
    rol      VARCHAR(50)  NOT NULL,
    activo   BOOLEAN      DEFAULT TRUE
);

-- Nota: los hashes BCrypt son generados automáticamente por DataInicializador.java
-- al primer arranque de la aplicación (si la tabla está vacía).
-- Si prefiere insertar manualmente, use contraseñas en texto plano con el prefijo {noop}:
--
-- INSERT INTO usuarios VALUES ('c19296', '{noop}C19296', 'Kendall Andrés Quirós Álvarez',  'ROLE_ADMIN',       true);
-- INSERT INTO usuarios VALUES ('c20051', '{noop}C20051', 'Kristy Daniela Acosta Mercado',  'ROLE_VETERINARIO', true);
-- INSERT INTO usuarios VALUES ('c23112', '{noop}C23112', 'Dering Josué García Acevedo',    'ROLE_OPERADOR',    true);
-- INSERT INTO usuarios VALUES ('c24510', '{noop}C24510', 'Justin Josué Marenco Herrera',   'ROLE_ADMIN',       true);
-- INSERT INTO usuarios VALUES ('c17735', '{noop}C17735', 'David Daniel Sotela Sánchez',    'ROLE_ENCARGADO',   true);

-- Verificar
SELECT username, nombre, rol, activo FROM usuarios ORDER BY username;
