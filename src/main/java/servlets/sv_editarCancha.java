package servlets;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cancha;
import umariana.reservassintetica.GestionarCanchas;

@WebServlet(name = "sv_editarCancha", urlPatterns = {"/sv_editarCancha"})
public class sv_editarCancha extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id_cancha = Integer.parseInt(request.getParameter("id_cancha"));
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        double precio_hora = Double.parseDouble(request.getParameter("precio_hora"));

        Cancha cancha = new Cancha();
        cancha.setId_cancha(id_cancha);
        cancha.setNombre(nombre);
        cancha.setTipo(tipo);
        cancha.setPrecio_hora(precio_hora);

        GestionarCanchas gestor = new GestionarCanchas();

        try {
            gestor.editarCancha(cancha);
        } catch (SQLException e) {
            System.err.println("Error al editar cancha: " + e.getMessage());
        }

        response.sendRedirect("canchas.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para editar canchas";
    }
}
