package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cliente;
import umariana.reservassintetica.GestionarClientes;

@WebServlet(name = "SvEditarCliente", urlPatterns = {"/sv_editarCliente"})
public class SvEditarCliente extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id_cliente"));
            String nombre   = request.getParameter("nombre");
            String telefono = request.getParameter("telefono");
            String email    = request.getParameter("email");

            if (nombre == null || nombre.trim().isEmpty()) {
                response.sendRedirect("clientes.jsp?error=campos");
                return;
            }

            Cliente c = new Cliente();
            c.setId_cliente(id);
            c.setNombre(nombre.trim());
            c.setTelefono(telefono);
            c.setEmail(email);

            new GestionarClientes().editarCliente(c);
            response.sendRedirect("clientes.jsp?ok=editado");

        } catch (NumberFormatException e) {
            response.sendRedirect("clientes.jsp?error=id");
        } catch (Exception e) {
            getServletContext().log("Error al editar cliente", e);
            response.sendRedirect("clientes.jsp?error=servidor");
        }
    }
}
