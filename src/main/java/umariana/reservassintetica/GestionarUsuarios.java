package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GestionarUsuarios {

    public Usuario autenticar(String username, String passwordPlano) throws SQLException {
        String sql = "SELECT id_usuario, username, password_hash, nombre, email, rol "
                + "FROM usuarios WHERE username = ?";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setString(1, username);

            try (ResultSet rs = consulta.executeQuery()) {
                if (rs.next()) {
                    String hashGuardado = rs.getString("password_hash");
                    if (PasswordUtil.verify(passwordPlano, hashGuardado)) {
                        Usuario u = new Usuario();
                        u.setId_usuario(rs.getInt("id_usuario"));
                        u.setUsername(rs.getString("username"));
                        u.setNombre(rs.getString("nombre"));
                        u.setEmail(rs.getString("email"));
                        u.setRol(rs.getString("rol"));
                        return u;
                    }
                }
            }
        }
        return null;
    }

    public boolean registrar(Usuario u, String passwordPlano) throws SQLException {
        String sql = "INSERT INTO usuarios (username, password_hash, nombre, email, rol) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setString(1, u.getUsername());
            consulta.setString(2, PasswordUtil.hash(passwordPlano));
            consulta.setString(3, u.getNombre());
            consulta.setString(4, u.getEmail());
            consulta.setString(5, u.getRol() == null ? "usuario" : u.getRol());

            return consulta.executeUpdate() > 0;
        }
    }

    public boolean existeUsuario(String username) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE username = ?";
        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql)) {
            consulta.setString(1, username);
            try (ResultSet rs = consulta.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean hayAlgunUsuario() throws SQLException {
        String sql = "SELECT 1 FROM usuarios LIMIT 1";
        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql);
             ResultSet rs = consulta.executeQuery()) {
            return rs.next();
        }
    }
}
