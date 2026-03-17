package servlets;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarReservas;

@WebServlet(name = "sv_eliminarReserva", urlPatterns = {"/sv_eliminarReserva"})
public class sv_eliminarReserva extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        GestionarReservas gestorReservas = new GestionarReservas();

        try {
            boolean eliminada = gestorReservas.eliminarReserva(id);
            if (!eliminada) {
                System.out.println("No se pudo eliminar la reserva con ID: " + id);
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar la reserva: " + e.getMessage());
        }

        response.sendRedirect("reservas.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para eliminar una reserva";
    }
}
