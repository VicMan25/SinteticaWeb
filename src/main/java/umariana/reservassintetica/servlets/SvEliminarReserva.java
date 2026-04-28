package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarReservas;

@WebServlet(name = "SvEliminarReserva", urlPatterns = {"/sv_eliminarReserva"})
public class SvEliminarReserva extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }

    private void procesar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            new GestionarReservas().eliminarReserva(id);
            response.sendRedirect("reservas.jsp?ok=eliminado");
        } catch (NumberFormatException e) {
            response.sendRedirect("reservas.jsp?error=id");
        } catch (Exception e) {
            getServletContext().log("Error al eliminar reserva", e);
            response.sendRedirect("reservas.jsp?error=servidor");
        }
    }
}
