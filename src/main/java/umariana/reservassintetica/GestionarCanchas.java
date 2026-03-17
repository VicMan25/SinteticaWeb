package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GestionarCanchas {

    public List<Cancha> listarCanchas(int pagina, int registrosPorPagina) throws SQLException {
        List<Cancha> misCanchas = new ArrayList<>();
        
        if (pagina < 1) pagina = 1;
        if (registrosPorPagina < 1) registrosPorPagina = 10;

        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT id_cancha, nombre, tipo, precio_hora FROM canchas ORDER BY id_cancha DESC LIMIT ? OFFSET ?";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, registrosPorPagina);
            consulta.setInt(2, offset);
            
            try (ResultSet resultado = consulta.executeQuery()) {
                while (resultado.next()) {
                    Cancha cancha = new Cancha();
                    cancha.setId_cancha(resultado.getInt("id_cancha"));
                    cancha.setNombre(resultado.getString("nombre"));
                    cancha.setTipo(resultado.getString("tipo"));
                    cancha.setPrecio_hora(resultado.getDouble("precio_hora"));
                    misCanchas.add(cancha);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar canchas: " + e.getMessage());
            throw e;
        }
        return misCanchas;
    }

    public boolean registrarCancha(Cancha cancha) throws SQLException {
        String sql = "INSERT INTO canchas (nombre, tipo, precio_hora) VALUES (?, ?, ?)";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setString(1, cancha.getNombre());
            consulta.setString(2, cancha.getTipo());
            consulta.setDouble(3, cancha.getPrecio_hora());

            int filasAfectadas = consulta.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar cancha: " + e.getMessage());
            throw e;
        }
    }

    public boolean editarCancha(Cancha cancha) throws SQLException {
        boolean editado = false;
        Connection conexion = null;
        PreparedStatement consulta = null;

        try {
            conexion = ConexionBD.conectar();
            String sql = "UPDATE canchas SET nombre = ?, tipo = ?, precio_hora = ? WHERE id_cancha = ?";
            

            consulta = conexion.prepareStatement(sql);
            consulta.setString(1, cancha.getNombre());
            consulta.setString(2, cancha.getTipo());
            consulta.setDouble(3, cancha.getPrecio_hora());
            consulta.setInt(4, cancha.getId_cancha());

            int filas = consulta.executeUpdate();
            if (filas > 0) {
                editado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al editar cancha: " + e.getMessage());
        } finally {
            if (consulta != null) consulta.close();
            if (conexion != null) conexion.close();
        }

        return editado;
    }

    public boolean eliminarCancha(int idCancha) throws SQLException {
        boolean eliminado = false;
        Connection conexion = null;
        PreparedStatement consulta = null;

        try {
            conexion = ConexionBD.conectar();
            String sql = "DELETE FROM canchas WHERE id_cancha = ?";
            consulta = conexion.prepareStatement(sql);
            consulta.setInt(1, idCancha);

            int filas = consulta.executeUpdate();
            if (filas > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al eliminar cancha: " + e.getMessage());
        } finally {
            if (consulta != null) consulta.close();
            if (conexion != null) conexion.close();
        }

        return eliminado;
    }
}
