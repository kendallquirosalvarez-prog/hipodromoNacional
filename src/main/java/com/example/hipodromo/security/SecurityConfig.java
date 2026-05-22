package com.example.hipodromo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // Spring Boot detecta el bean UsuarioDetailsService + PasswordEncoder y los conecta automáticamente

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // Recursos estáticos y login siempre accesibles
                .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                .requestMatchers("/login").permitAll()
                // Control de acceso por módulo y rol
                .requestMatchers("/historial/**").hasAnyRole("ADMIN", "VETERINARIO")
                .requestMatchers("/establos/**").hasAnyRole("ADMIN", "ENCARGADO")
                .requestMatchers("/propietarios/**", "/caballos/**").hasAnyRole("ADMIN", "PROPIETARIO")
                .requestMatchers("/eventos/**", "/inscripciones/**", "/facturas/**").hasAnyRole("ADMIN", "OPERADOR")
                // Cualquier otra ruta requiere autenticación
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/acceso-denegado")
            );
        return http.build();
    }
}
