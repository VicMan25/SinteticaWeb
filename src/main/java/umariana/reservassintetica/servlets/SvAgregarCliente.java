package umariana.reservassintetica.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cliente;
import umariana.reservassintetica.GestionarClientes;

@WebServlet(name = "SvAgregarCliente", urlPatterns = {"/sv_agregarCliente"})
public class SvAgregarCliente extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre   = request.getParameter("nombres");
        String telefono = request.getParameter("telefono");
        String email    = request.getParameter("email");

        if (nombre == null || nombre.trim().isEmpty()) {
            response.sendRedirect("clientes.jsp?error=campos");
            return;
        }

        Cliente c = new Cliente();
        c.setNombre(nombre.trim());
        c.setTelefono(telefono);
        c.setEmail(email);

        try {
            new GestionarClientes().registrarCliente(c);
            response.sendRedirect("clientes.jsp?ok=agregado");
        } catch (Exception e) {
            getServletContext().log("Error al agregar cliente", e);
            response.sendRedirect("clientes.jsp?error=servidor");
        }
    }
}
