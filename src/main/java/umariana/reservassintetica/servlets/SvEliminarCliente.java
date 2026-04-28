package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.GestionarClientes;

@WebServlet(name = "SvEliminarCliente", urlPatterns = {"/sv_eliminarCliente"})
public class SvEliminarCliente extends HttpServlet {

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
            new GestionarClientes().eliminarCliente(id);
            response.sendRedirect("clientes.jsp?ok=eliminado");
        } catch (NumberFormatException e) {
            response.sendRedirect("clientes.jsp?error=id");
        } catch (Exception e) {
            getServletContext().log("Error al eliminar cliente", e);
            response.sendRedirect("clientes.jsp?error=referencias");
        }
    }
}
