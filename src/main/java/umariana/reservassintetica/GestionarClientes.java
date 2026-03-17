package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GestionarClientes {

    public List<Cliente> listarClientes(int pagina, int registrosPorPagina) throws SQLException {
        List<Cliente> misClientes = new ArrayList<>();

        // Validación básica de parámetros
        if (pagina < 1) {
            pagina = 1;
        }
        if (registrosPorPagina < 1) {
            registrosPorPagina = 10;
        }

        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT id_cliente, nombre, telefono, email FROM clientes ORDER BY id_cliente DESC LIMIT ? OFFSET ?";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, registrosPorPagina);
            consulta.setInt(2, offset);

            try (ResultSet resultado = consulta.executeQuery()) {
                while (resultado.next()) {
                    Cliente micliente = new Cliente();
                    micliente.setId_cliente(resultado.getInt("id_cliente"));
                    micliente.setNombre(resultado.getString("nombre"));
                    micliente.setTelefono(resultado.getString("telefono"));
                    micliente.setEmail(resultado.getString("email"));
                    misClientes.add(micliente);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
            throw e; // Relanzar la excepción para manejo superior
        }
        return misClientes;
    }

    public boolean registrarCliente(Cliente c) throws SQLException {
        String sql = "insert into clientes(nombre, telefono, email) values(?,?,?)";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setString(1, c.getNombre());
            consulta.setString(2, c.getTelefono());
            consulta.setString(3, c.getEmail());

            int filasAfectadas = consulta.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editarCliente(Cliente c) throws SQLException {
        boolean editado = false;
        Connection conexion = null;
        PreparedStatement consulta = null;

        try {
            conexion = ConexionBD.conectar();
            String sql = "UPDATE clientes SET nombre=?, telefono=?, email=? WHERE id_cliente=?";

            consulta = conexion.prepareStatement(sql);
            consulta.setString(1, c.getNombre());
            consulta.setString(2, c.getTelefono());
            consulta.setString(3, c.getEmail());
            consulta.setInt(4, c.getId_cliente());

            int filas = consulta.executeUpdate();
            if (filas > 0) {
                editado = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (consulta != null) {
                consulta.close();
            }
            if (conexion != null) {
                conexion.close();
            }
        }
        return editado;
    }

    public boolean eliminarCliente(int idCliente) throws SQLException {
        boolean eliminado = false;
        Connection conexion = null;
        PreparedStatement consulta = null;

        try {
            conexion = ConexionBD.conectar();
            String sql = "DELETE FROM clientes WHERE id_cliente = ?";
            consulta = conexion.prepareStatement(sql);
            consulta.setInt(1, idCliente);
            int filas = consulta.executeUpdate();
            if (filas > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
        } finally {
            if (consulta != null) {
                consulta.close();
            }
            if (conexion != null) {
                conexion.close();
            }
        }
        return eliminado;
    }

    public List<Cliente> listarClientesPorNombre(String nombreBusqueda, int pagina, int registrosPorPagina) throws SQLException {
        List<Cliente> misClientes = new ArrayList<>();

        if (pagina < 1) {
            pagina = 1;
        }
        if (registrosPorPagina < 1) {
            registrosPorPagina = 10;
        }

        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT id_cliente, nombre, telefono, email FROM clientes "
                + "WHERE nombre LIKE ? ORDER BY nombre ASC LIMIT ? OFFSET ?";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setString(1, "%" + nombreBusqueda + "%"); // búsqueda parcial por nombre
            consulta.setInt(2, registrosPorPagina);
            consulta.setInt(3, offset);

            try (ResultSet resultado = consulta.executeQuery()) {
                while (resultado.next()) {
                    Cliente micliente = new Cliente();
                    micliente.setId_cliente(resultado.getInt("id_cliente"));
                    micliente.setNombre(resultado.getString("nombre"));
                    micliente.setTelefono(resultado.getString("telefono"));
                    micliente.setEmail(resultado.getString("email"));
                    misClientes.add(micliente);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes por nombre: " + e.getMessage());
            throw e;
        }
        return misClientes;
    }

}
