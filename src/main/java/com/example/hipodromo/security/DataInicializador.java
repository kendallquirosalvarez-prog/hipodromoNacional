package com.example.hipodromo.security;

import com.example.hipodromo.model.Usuario;
import com.example.hipodromo.repository.UsuarioRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DataInicializador implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInicializador.class);

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        try {
            if (usuarioRepository.count() == 0) {
                List<Usuario> usuarios = List.of(
                    new Usuario("c19296", passwordEncoder.encode("C19296"),
                        "Kendall Andrés Quirós Álvarez",  "ROLE_ADMIN",       true),
                    new Usuario("c20051", passwordEncoder.encode("C20051"),
                        "Kristy Daniela Acosta Mercado",  "ROLE_VETERINARIO", true),
                    new Usuario("c23112", passwordEncoder.encode("C23112"),
                        "Dering Josué García Acevedo",    "ROLE_OPERADOR",    true),
                    new Usuario("c24510", passwordEncoder.encode("C24510"),
                        "Justin Josué Marenco Herrera",   "ROLE_PROPIETARIO", true),
                    new Usuario("c17735", passwordEncoder.encode("C17735"),
                        "David Daniel Sotela Sánchez",    "ROLE_ENCARGADO",   true)
                );
                usuarioRepository.saveAll(usuarios);
                log.info("Usuarios del grupo creados exitosamente.");
            } else {
                log.info("Usuarios ya existen en la base de datos — omitiendo inicialización.");
            }
        } catch (Exception e) {
            log.warn("No se pudieron inicializar usuarios: {}. " +
                     "Asegúrese de ejecutar usuarios_seguridad.sql en Supabase primero.", e.getMessage());
        }
    }
}
