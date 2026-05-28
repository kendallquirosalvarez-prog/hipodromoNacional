package cr.ucr.hipodromo.security;

import cr.ucr.hipodromo.model.Usuario;
import cr.ucr.hipodromo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UsuarioDetailsService implements UserDetailsService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));

        // Convierte el rol almacenado (ej. ROLE_ADMIN) al nombre sin prefijo para .roles()
        String rolSinPrefijo = usuario.getRol().replace("ROLE_", "");

        return User.builder()
            .username(usuario.getUsername())
            .password(usuario.getPassword())
            .roles(rolSinPrefijo)
            .disabled(!usuario.isActivo())
            .build();
    }
}
