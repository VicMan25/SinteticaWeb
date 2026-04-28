package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import umariana.reservassintetica.GestionarUsuarios;
import umariana.reservassintetica.Usuario;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty()
                || password == null || password.isEmpty()) {
            response.sendRedirect("index.jsp?error=campos");
            return;
        }

        try {
            Usuario u = new GestionarUsuarios().autenticar(username.trim(), password);
            if (u == null) {
                response.sendRedirect("index.jsp?error=credenciales");
                return;
            }

            HttpSession sesionVieja = request.getSession(false);
            if (sesionVieja != null) {
                sesionVieja.invalidate();
            }
            HttpSession sesion = request.getSession(true);
            sesion.setAttribute("usuarioLogueado", u);
            sesion.setMaxInactiveInterval(30 * 60);

            response.sendRedirect("principal.jsp");

        } catch (Exception e) {
            getServletContext().log("Error en login", e);
            response.sendRedirect("index.jsp?error=servidor");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
