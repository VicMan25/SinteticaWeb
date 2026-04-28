package umariana.reservassintetica.servlets;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarReservas;
import umariana.reservassintetica.Reserva;

@WebServlet(name = "SvEditarReserva", urlPatterns = {"/sv_editarReserva"})
public class SvEditarReserva extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
            int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
            int idCancha  = Integer.parseInt(request.getParameter("id_cancha"));
            Date fecha      = Date.valueOf(request.getParameter("fecha"));
            Time horaInicio = Time.valueOf(request.getParameter("hora_inicio") + ":00");
            Time horaFin    = Time.valueOf(request.getParameter("hora_fin") + ":00");
            String estado   = request.getParameter("estado");

            if (!horaFin.after(horaInicio)) {
                response.sendRedirect("reservas.jsp?error=horas");
                return;
            }

            Reserva r = new Reserva();
            r.setId_reserva(idReserva);
            r.setId_cliente(idCliente);
            r.setId_cancha(idCancha);
            r.setFecha(fecha);
            r.setHora_inicio(horaInicio);
            r.setHora_fin(horaFin);
            r.setEstado(estado);

            new GestionarReservas().editarReserva(r);
            response.sendRedirect("reservas.jsp?ok=editado");

        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("disponible")) {
                response.sendRedirect("reservas.jsp?error=ocupada");
            } else {
                getServletContext().log("Error SQL al editar reserva", e);
                response.sendRedirect("reservas.jsp?error=servidor");
            }
        } catch (IllegalArgumentException | NullPointerException e) {
            response.sendRedirect("reservas.jsp?error=campos");
        } catch (Exception e) {
            getServletContext().log("Error al editar reserva", e);
            response.sendRedirect("reservas.jsp?error=servidor");
        }
    }
}
