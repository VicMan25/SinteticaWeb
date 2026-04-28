package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cancha;
import umariana.reservassintetica.GestionarCanchas;

@WebServlet(name = "SvEditarCancha", urlPatterns = {"/sv_editarCancha"})
public class SvEditarCancha extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id_cancha"));
            String nombre = request.getParameter("nombre");
            String tipo   = request.getParameter("tipo");
            String precio = request.getParameter("precio_hora");

            if (nombre == null || nombre.trim().isEmpty()
                    || tipo == null || tipo.trim().isEmpty()
                    || precio == null || precio.trim().isEmpty()) {
                response.sendRedirect("canchas.jsp?error=campos");
                return;
            }

            Cancha c = new Cancha();
            c.setId_cancha(id);
            c.setNombre(nombre.trim());
            c.setTipo(tipo.trim());
            c.setPrecio_hora(Double.parseDouble(precio));

            new GestionarCanchas().editarCancha(c);
            response.sendRedirect("canchas.jsp?ok=editado");

        } catch (NumberFormatException e) {
            response.sendRedirect("canchas.jsp?error=numero");
        } catch (Exception e) {
            getServletContext().log("Error al editar cancha", e);
            response.sendRedirect("canchas.jsp?error=servidor");
        }
    }
}
