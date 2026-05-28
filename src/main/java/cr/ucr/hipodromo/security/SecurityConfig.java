package cr.ucr.hipodromo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // Spring Boot detecta el bean UsuarioDetailsService + PasswordEncoder y los conecta automáticamente

    @Bean
    public PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // Recursos estáticos y login siempre accesibles
                .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                .requestMatchers("/login", "/er-diagram.html", "/er-diagram-nuevo.html").permitAll()
                // Control de acceso por módulo y rol
                .requestMatchers("/historial/**", "/alertas/**").hasAnyRole("ADMIN", "VETERINARIO")
                .requestMatchers("/establos/**", "/suministros/**", "/alimentacion/**").hasAnyRole("ADMIN", "ENCARGADO")
                // Propietarios: registran caballos, inscriben animales, consultan resultados y facturación
                .requestMatchers("/propietarios/**", "/caballos/**",
                                 "/eventos/**", "/inscripciones/**", "/facturas/**",
                                 "/transacciones/**", "/resultados/**").hasAnyRole("ADMIN", "PROPIETARIO")
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
