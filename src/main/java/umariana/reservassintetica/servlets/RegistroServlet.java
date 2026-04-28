package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarUsuarios;
import umariana.reservassintetica.Usuario;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String nombre   = request.getParameter("nombre");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String confirma = request.getParameter("confirma");

        if (username == null || username.trim().isEmpty()
                || nombre == null || nombre.trim().isEmpty()
                || password == null || password.length() < 6) {
            response.sendRedirect("registro.jsp?error=campos");
            return;
        }
        if (!password.equals(confirma)) {
            response.sendRedirect("registro.jsp?error=confirmacion");
            return;
        }

        GestionarUsuarios dao = new GestionarUsuarios();
        try {
            if (dao.existeUsuario(username.trim())) {
                response.sendRedirect("registro.jsp?error=existe");
                return;
            }
            Usuario u = new Usuario();
            u.setUsername(username.trim());
            u.setNombre(nombre.trim());
            u.setEmail(email);
            u.setRol("usuario");
            dao.registrar(u, password);
            response.sendRedirect("index.jsp?ok=registrado");
        } catch (Exception e) {
            getServletContext().log("Error en registro", e);
            response.sendRedirect("registro.jsp?error=servidor");
        }
    }
}
