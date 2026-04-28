package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cancha;
import umariana.reservassintetica.GestionarCanchas;

@WebServlet(name = "SvAgregarCancha", urlPatterns = {"/sv_agregarCancha"})
public class SvAgregarCancha extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String tipo   = request.getParameter("tipo");
        String precio = request.getParameter("precio_hora");

        if (nombre == null || nombre.trim().isEmpty()
                || tipo == null || tipo.trim().isEmpty()
                || precio == null || precio.trim().isEmpty()) {
            response.sendRedirect("canchas.jsp?error=campos");
            return;
        }

        try {
            Cancha c = new Cancha();
            c.setNombre(nombre.trim());
            c.setTipo(tipo.trim());
            c.setPrecio_hora(Double.parseDouble(precio));

            new GestionarCanchas().registrarCancha(c);
            response.sendRedirect("canchas.jsp?ok=agregado");

        } catch (NumberFormatException e) {
            response.sendRedirect("canchas.jsp?error=precio");
        } catch (Exception e) {
            getServletContext().log("Error al agregar cancha", e);
            response.sendRedirect("canchas.jsp?error=servidor");
        }
    }
}
