package servlets;

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

@WebServlet(name = "sv_editarReserva", urlPatterns = {"/sv_editarReserva"})
public class sv_editarReserva extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
    int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
    int idCancha = Integer.parseInt(request.getParameter("id_cancha"));
    Date fecha = Date.valueOf(request.getParameter("fecha"));
    
    String horaInicioStr = request.getParameter("hora_inicio");
    if (horaInicioStr.length() == 5) {
        horaInicioStr += ":00";
    }
    Time horaInicio = Time.valueOf(horaInicioStr);
    
    String horaFinStr = request.getParameter("hora_fin");
    if (horaFinStr.length() == 5) {
        horaFinStr += ":00";
    }
    Time horaFin = Time.valueOf(horaFinStr);
    
    String estado = request.getParameter("estado");

    Reserva reserva = new Reserva();
    reserva.setId_reserva(idReserva);
    reserva.setId_cliente(idCliente);
    reserva.setId_cancha(idCancha);
    reserva.setFecha(fecha);
    reserva.setHora_inicio(horaInicio);
    reserva.setHora_fin(horaFin);
    reserva.setEstado(estado);

    GestionarReservas gesReservas = new GestionarReservas();
    try {
        gesReservas.editarReserva(reserva);
    } catch (SQLException e) {
        System.err.println("Error al editar reserva: " + e.getMessage());
        // Maneja el error adecuadamente aquí
    }

    response.sendRedirect("reservas.jsp");
}


    @Override
    public String getServletInfo() {
        return "Servlet para editar reservas";
    }
}
