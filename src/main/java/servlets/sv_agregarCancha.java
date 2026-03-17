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

@WebServlet(name = "sv_agregarCancha", urlPatterns = {"/sv_agregarCancha"})
public class sv_agregarCancha extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        double precioHora = Double.parseDouble(request.getParameter("precio_hora"));

        Cancha cancha = new Cancha();
        cancha.setNombre(nombre);
        cancha.setTipo(tipo);
        cancha.setPrecio_hora(precioHora);

        GestionarCanchas gestionar = new GestionarCanchas();

        try {
            boolean resultado = gestionar.registrarCancha(cancha);
            if (resultado) {
                response.sendRedirect("canchas.jsp");
            } else {
                response.sendRedirect("canchas.jsp?error=true");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("canchas.jsp?error=exception");
        }
    }
}
