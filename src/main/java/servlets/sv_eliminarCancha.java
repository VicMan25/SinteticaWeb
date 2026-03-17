package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarCanchas;

@WebServlet(name = "sv_eliminarCancha", urlPatterns = {"/sv_eliminarCancha"})
public class sv_eliminarCancha extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet eliminarCancha</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet eliminarCancha at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        GestionarCanchas gesCanchas = new GestionarCanchas();
        try {
            gesCanchas.eliminarCancha(id);
        } catch (SQLException e) {
            System.out.println("No se pudo eliminar la cancha: " + e.getMessage());
        }
        response.sendRedirect("canchas.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para eliminar canchas";
    }
}
