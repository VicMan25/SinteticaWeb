package servlets;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import umariana.reservassintetica.Reserva;
import umariana.reservassintetica.GestionarReservas;

@WebServlet(name = "sv_agregarReserva", urlPatterns = {"/sv_agregarReserva"})
public class sv_agregarReserva extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener los parámetros del formulario
            int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
            int idCancha = Integer.parseInt(request.getParameter("id_cancha"));
            Date fecha = Date.valueOf(request.getParameter("fecha"));
            Time horaInicio = Time.valueOf(request.getParameter("hora_inicio") + ":00");
            Time horaFin = Time.valueOf(request.getParameter("hora_fin") + ":00");
            String estado = request.getParameter("estado");

            // Crear la reserva
            Reserva reserva = new Reserva();
            reserva.setId_cliente(idCliente);
            reserva.setId_cancha(idCancha);
            reserva.setFecha(fecha);
            reserva.setHora_inicio(horaInicio);
            reserva.setHora_fin(horaFin);
            reserva.setEstado(estado);

            GestionarReservas gestor = new GestionarReservas();
            boolean exito = gestor.registrarReserva(reserva);

            if (exito) {
                response.sendRedirect("reservas.jsp");
            } else {
                response.sendRedirect("reservas.jsp?error=true");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("reservas.jsp?error=ocupada");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reservas.jsp?error=general");
        }
    }
}
