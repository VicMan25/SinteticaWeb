package umariana.reservassintetica;

import java.io.Serializable;

public class Usuario implements Serializable {

    private int id_usuario;
    private String username;
    private String password_hash;
    private String nombre;
    private String email;
    private String rol;

    public Usuario() {
    }

    public Usuario(int id_usuario, String username, String nombre, String email, String rol) {
        this.id_usuario = id_usuario;
        this.username = username;
        this.nombre = nombre;
        this.email = email;
        this.rol = rol;
    }

    public int getId_usuario() { return id_usuario; }
    public void setId_usuario(int id_usuario) { this.id_usuario = id_usuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword_hash() { return password_hash; }
    public void setPassword_hash(String password_hash) { this.password_hash = password_hash; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public boolean esAdmin() {
        return "admin".equalsIgnoreCase(rol);
    }
}
