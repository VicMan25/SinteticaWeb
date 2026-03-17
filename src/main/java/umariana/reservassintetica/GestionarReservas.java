package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class GestionarReservas {

    public List<Reserva> listarReservas(int pagina, int registrosPorPagina) throws SQLException {
        List<Reserva> misReservas = new ArrayList<>();
        int offset = (pagina - 1) * registrosPorPagina;

        String sql = "SELECT r.id_reserva, c.nombre as nombre_cliente, ca.nombre as nombre_cancha, "
                + "r.fecha, r.hora_inicio, r.hora_fin, r.estado "
                + "FROM reservas r "
                + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                + "ORDER BY r.id_reserva DESC, r.fecha DESC, r.hora_inicio DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, registrosPorPagina);
            consulta.setInt(2, offset);

            try (ResultSet resultado = consulta.executeQuery()) {
                while (resultado.next()) {
                    Reserva reserva = new Reserva();
                    reserva.setId_reserva(resultado.getInt("id_reserva"));
                    reserva.setNombre_cliente(resultado.getString("nombre_cliente"));
                    reserva.setNombre_cancha(resultado.getString("nombre_cancha"));
                    reserva.setFecha(resultado.getDate("fecha"));
                    reserva.setHora_inicio(resultado.getTime("hora_inicio"));
                    reserva.setHora_fin(resultado.getTime("hora_fin"));
                    reserva.setEstado(resultado.getString("estado"));
                    misReservas.add(reserva);
                }
            }
        }
        return misReservas;
    }

    public boolean registrarReserva(Reserva reserva) throws SQLException {
        // Primero validar disponibilidad
        if (!validarDisponibilidad(reserva.getId_cancha(), reserva.getFecha(),
                reserva.getHora_inicio(), reserva.getHora_fin())) {
            throw new SQLException("La cancha no está disponible en ese horario");
        }

        String sql = "INSERT INTO reservas (id_cliente, id_cancha, fecha, hora_inicio, hora_fin, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, reserva.getId_cliente());
            consulta.setInt(2, reserva.getId_cancha());
            consulta.setDate(3, reserva.getFecha());
            consulta.setTime(4, reserva.getHora_inicio());
            consulta.setTime(5, reserva.getHora_fin());
            consulta.setString(6, reserva.getEstado());

            return consulta.executeUpdate() > 0;
        }
    }

    private boolean validarDisponibilidad(int idCancha, Date fecha, Time horaInicio, Time horaFin) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservas WHERE id_cancha = ? AND fecha = ? "
                + "AND ((hora_inicio < ? AND hora_fin > ?) OR "
                + "(hora_inicio >= ? AND hora_inicio < ?)) AND estado != 'Cancelada'";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, idCancha);
            consulta.setDate(2, fecha);
            consulta.setTime(3, horaFin);
            consulta.setTime(4, horaInicio);
            consulta.setTime(5, horaInicio);
            consulta.setTime(6, horaFin);

            try (ResultSet resultado = consulta.executeQuery()) {
                if (resultado.next()) {
                    return resultado.getInt(1) == 0;
                }
            }
        }
        return false;
    }

    public boolean editarReserva(Reserva reserva) throws SQLException {
        // Validar disponibilidad, excluyendo la reserva actual
        if (!validarDisponibilidadEdicion(reserva.getId_cancha(), reserva.getFecha(),
                reserva.getHora_inicio(), reserva.getHora_fin(), reserva.getId_reserva())) {
            throw new SQLException("La cancha no está disponible en ese horario para esta edición");
        }

        String sql = "UPDATE reservas SET id_cliente=?, id_cancha=?, fecha=?, hora_inicio=?, hora_fin=?, estado=? "
                + "WHERE id_reserva=?";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, reserva.getId_cliente());
            consulta.setInt(2, reserva.getId_cancha());
            consulta.setDate(3, reserva.getFecha());
            consulta.setTime(4, reserva.getHora_inicio());
            consulta.setTime(5, reserva.getHora_fin());
            consulta.setString(6, reserva.getEstado());
            consulta.setInt(7, reserva.getId_reserva());

            return consulta.executeUpdate() > 0;
        }
    }

    public boolean eliminarReserva(int idReserva) throws SQLException {
        String sql = "DELETE FROM reservas WHERE id_reserva = ?";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, idReserva);
            return consulta.executeUpdate() > 0;
        }
    }

    private boolean validarDisponibilidadEdicion(int idCancha, Date fecha, Time horaInicio, Time horaFin, int idReserva) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservas WHERE id_cancha = ? AND fecha = ? "
                + "AND id_reserva != ? AND "
                + "((hora_inicio < ? AND hora_fin > ?) OR (hora_inicio >= ? AND hora_inicio < ?)) "
                + "AND estado != 'Cancelada'";

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {

            consulta.setInt(1, idCancha);
            consulta.setDate(2, fecha);
            consulta.setInt(3, idReserva);
            consulta.setTime(4, horaFin);
            consulta.setTime(5, horaInicio);
            consulta.setTime(6, horaInicio);
            consulta.setTime(7, horaFin);

            try (ResultSet resultado = consulta.executeQuery()) {
                if (resultado.next()) {
                    return resultado.getInt(1) == 0;
                }
            }
        }
        return false;
    }

    public List<Reserva> buscarReservas(String filtro) throws SQLException {
        List<Reserva> reservas = new ArrayList<>();

        String sql;
        boolean esFecha = filtro.matches("\\d{4}-\\d{2}-\\d{2}");

        if (esFecha) {
            sql = "SELECT r.id_reserva, c.nombre AS nombre_cliente, ca.nombre AS nombre_cancha, "
                    + "r.fecha, r.hora_inicio, r.hora_fin, r.estado "
                    + "FROM reservas r "
                    + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                    + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                    + "WHERE r.fecha = ? "
                    + "ORDER BY r.fecha DESC, r.hora_inicio DESC";
        } else {
            sql = "SELECT r.id_reserva, c.nombre AS nombre_cliente, ca.nombre AS nombre_cancha, "
                    + "r.fecha, r.hora_inicio, r.hora_fin, r.estado "
                    + "FROM reservas r "
                    + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                    + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                    + "WHERE c.nombre LIKE ? "
                    + "ORDER BY r.fecha DESC, r.hora_inicio DESC";
        }

        try (Connection conexion = ConexionBD.conectar(); PreparedStatement consulta = conexion.prepareStatement(sql)) {
            if (esFecha) {
                consulta.setDate(1, java.sql.Date.valueOf(filtro));
            } else {
                consulta.setString(1, "%" + filtro + "%");
            }

            try (ResultSet resultado = consulta.executeQuery()) {
                while (resultado.next()) {
                    Reserva reserva = new Reserva();
                    reserva.setId_reserva(resultado.getInt("id_reserva"));
                    reserva.setNombre_cliente(resultado.getString("nombre_cliente"));
                    reserva.setNombre_cancha(resultado.getString("nombre_cancha"));
                    reserva.setFecha(resultado.getDate("fecha"));
                    reserva.setHora_inicio(resultado.getTime("hora_inicio"));
                    reserva.setHora_fin(resultado.getTime("hora_fin"));
                    reserva.setEstado(resultado.getString("estado"));
                    reservas.add(reserva);
                }
            }
        }

        return reservas;
    }

}
