package cr.ucr.hipodromo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @Column(name = "username", length = 50)
    private String username;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Column(name = "nombre", length = 150, nullable = false)
    private String nombre;

    /** Rol del usuario: ROLE_ADMIN, ROLE_VETERINARIO, ROLE_OPERADOR, ROLE_PROPIETARIO, ROLE_ENCARGADO */
    @Column(name = "rol", length = 50, nullable = false)
    private String rol;

    @Column(name = "activo", nullable = false)
    private boolean activo = true;

    public Usuario() {}

    public Usuario(String username, String password, String nombre, String rol, boolean activo) {
        this.username = username;
        this.password = password;
        this.nombre   = nombre;
        this.rol      = rol;
        this.activo   = activo;
    }

    public String getUsername()              { return username; }
    public void   setUsername(String u)      { this.username = u; }

    public String getPassword()              { return password; }
    public void   setPassword(String p)      { this.password = p; }

    public String getNombre()                { return nombre; }
    public void   setNombre(String n)        { this.nombre = n; }

    public String getRol()                   { return rol; }
    public void   setRol(String r)           { this.rol = r; }

    public boolean isActivo()                { return activo; }
    public void    setActivo(boolean a)      { this.activo = a; }
}
