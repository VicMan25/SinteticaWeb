package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Calcula KPIs y series de ingresos para el dashboard financiero.
 *
 * Ingreso por reserva = precio_hora * duracion_en_horas, contando sólo las
 * reservas cuyo estado no sea "Cancelada".
 */
public class GestionarFinanzas {

    /** Suma de ingresos de todas las reservas no canceladas. */
    public double ingresosTotales() throws SQLException {
        String sql
                = "SELECT COALESCE(SUM(ca.precio_hora * TIMESTAMPDIFF(SECOND, r.hora_inicio, r.hora_fin) / 3600.0), 0) AS total "
                + "FROM reservas r "
                + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                + "WHERE r.estado <> 'Cancelada'";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble("total") : 0d;
        }
    }

    /** Ingresos del mes actual. */
    public double ingresosMesActual() throws SQLException {
        String sql
                = "SELECT COALESCE(SUM(ca.precio_hora * TIMESTAMPDIFF(SECOND, r.hora_inicio, r.hora_fin) / 3600.0), 0) AS total "
                + "FROM reservas r "
                + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                + "WHERE r.estado <> 'Cancelada' "
                + "AND YEAR(r.fecha) = YEAR(CURDATE()) "
                + "AND MONTH(r.fecha) = MONTH(CURDATE())";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble("total") : 0d;
        }
    }

    /** Número de reservas confirmadas/pendientes del día de hoy. */
    public int reservasHoy() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservas WHERE fecha = CURDATE() AND estado <> 'Cancelada'";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Total de reservas activas (histórico, no canceladas). */
    public int totalReservas() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservas WHERE estado <> 'Cancelada'";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int totalClientes() throws SQLException {
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM clientes");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int totalCanchas() throws SQLException {
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM canchas");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int reservasPendientes() throws SQLException {
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM reservas WHERE estado = 'Pendiente'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int reservasConfirmadas() throws SQLException {
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM reservas WHERE estado = 'Confirmada'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /**
     * Ingresos por mes de los últimos N meses, incluyendo meses sin reservas con valor 0.
     * Devuelve mapa ordenado: "YYYY-MM" -> total.
     */
    public Map<String, Double> ingresosPorMes(int ultimosMeses) throws SQLException {
        if (ultimosMeses < 1) ultimosMeses = 6;

        // Pre-llenar los últimos N meses con 0 para que el gráfico no tenga huecos.
        Map<String, Double> resultado = new LinkedHashMap<>();
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.MONTH, -(ultimosMeses - 1));
        for (int i = 0; i < ultimosMeses; i++) {
            String clave = String.format("%tY-%tm", cal, cal);
            resultado.put(clave, 0d);
            cal.add(java.util.Calendar.MONTH, 1);
        }

        String sql
                = "SELECT DATE_FORMAT(r.fecha, '%Y-%m') AS mes, "
                + "       SUM(ca.precio_hora * TIMESTAMPDIFF(SECOND, r.hora_inicio, r.hora_fin) / 3600.0) AS total "
                + "FROM reservas r "
                + "JOIN canchas ca ON r.id_cancha = ca.id_cancha "
                + "WHERE r.estado <> 'Cancelada' "
                + "AND r.fecha >= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL ? MONTH) "
                + "GROUP BY mes "
                + "ORDER BY mes";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ultimosMeses - 1);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String mes = rs.getString("mes");
                    if (resultado.containsKey(mes)) {
                        resultado.put(mes, rs.getDouble("total"));
                    }
                }
            }
        }
        return resultado;
    }

    /** Fila del desglose por cancha: [nombre, tipo, reservas, total]. */
    public static class FilaCancha {
        public String nombre;
        public String tipo;
        public int reservas;
        public double total;
    }

    public List<FilaCancha> ingresosPorCancha() throws SQLException {
        List<FilaCancha> filas = new ArrayList<>();
        String sql
                = "SELECT ca.nombre, ca.tipo, "
                + "       COUNT(r.id_reserva) AS reservas, "
                + "       COALESCE(SUM(ca.precio_hora * TIMESTAMPDIFF(SECOND, r.hora_inicio, r.hora_fin) / 3600.0), 0) AS total "
                + "FROM canchas ca "
                + "LEFT JOIN reservas r ON r.id_cancha = ca.id_cancha AND r.estado <> 'Cancelada' "
                + "GROUP BY ca.id_cancha, ca.nombre, ca.tipo "
                + "ORDER BY total DESC";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                FilaCancha f = new FilaCancha();
                f.nombre   = rs.getString("nombre");
                f.tipo     = rs.getString("tipo");
                f.reservas = rs.getInt("reservas");
                f.total    = rs.getDouble("total");
                filas.add(f);
            }
        }
        return filas;
    }

    /** Fila del ranking de clientes: [nombre, reservas, total]. */
    public static class FilaCliente {
        public String nombre;
        public int reservas;
        public double total;
    }

    public List<FilaCliente> rankingClientes(int limite) throws SQLException {
        if (limite < 1) limite = 10;
        List<FilaCliente> filas = new ArrayList<>();
        String sql
                = "SELECT c.nombre, "
                + "       COUNT(r.id_reserva) AS reservas, "
                + "       COALESCE(SUM(ca.precio_hora * TIMESTAMPDIFF(SECOND, r.hora_inicio, r.hora_fin) / 3600.0), 0) AS total "
                + "FROM clientes c "
                + "LEFT JOIN reservas r ON r.id_cliente = c.id_cliente AND r.estado <> 'Cancelada' "
                + "LEFT JOIN canchas  ca ON r.id_cancha  = ca.id_cancha "
                + "GROUP BY c.id_cliente, c.nombre "
                + "HAVING reservas > 0 "
                + "ORDER BY total DESC "
                + "LIMIT ?";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FilaCliente f = new FilaCliente();
                    f.nombre   = rs.getString("nombre");
                    f.reservas = rs.getInt("reservas");
                    f.total    = rs.getDouble("total");
                    filas.add(f);
                }
            }
        }
        return filas;
    }

    /** Fila de la lista "próximas reservas" del dashboard. */
    public static class FilaProximaReserva {
        public String cliente;
        public String cancha;
        public java.sql.Date fecha;
        public java.sql.Time horaInicio;
        public java.sql.Time horaFin;
        public String estado;
    }

    public List<FilaProximaReserva> proximasReservas(int limite) throws SQLException {
        if (limite < 1) limite = 5;
        List<FilaProximaReserva> filas = new ArrayList<>();
        String sql
                = "SELECT c.nombre AS cliente, ca.nombre AS cancha, r.fecha, r.hora_inicio, r.hora_fin, r.estado "
                + "FROM reservas r "
                + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                + "JOIN canchas  ca ON r.id_cancha  = ca.id_cancha "
                + "WHERE r.estado <> 'Cancelada' "
                + "AND (r.fecha > CURDATE() OR (r.fecha = CURDATE() AND r.hora_inicio >= CURTIME())) "
                + "ORDER BY r.fecha ASC, r.hora_inicio ASC "
                + "LIMIT ?";
        try (Connection con = ConexionBD.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FilaProximaReserva f = new FilaProximaReserva();
                    f.cliente    = rs.getString("cliente");
                    f.cancha     = rs.getString("cancha");
                    f.fecha      = rs.getDate("fecha");
                    f.horaInicio = rs.getTime("hora_inicio");
                    f.horaFin    = rs.getTime("hora_fin");
                    f.estado     = rs.getString("estado");
                    filas.add(f);
                }
            }
        }
        return filas;
    }
}
