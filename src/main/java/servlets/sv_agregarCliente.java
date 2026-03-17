
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import umariana.reservassintetica.Cliente;
import umariana.reservassintetica.GestionarClientes;

@WebServlet(name = "sv_agregarCliente", urlPatterns = {"/sv_agregarCliente"})
public class sv_agregarCliente extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombres = request.getParameter("nombres");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");

        Cliente c = new Cliente();
        c.setNombre(nombres);
        c.setTelefono(telefono);
        c.setEmail(email);

        GestionarClientes gestionar = new GestionarClientes();

        try {
            boolean resultado = gestionar.registrarCliente(c);
            if (resultado) {
                response.sendRedirect("clientes.jsp");
            } else {
                response.sendRedirect("agregarcliente.jsp?error=true");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("agregarcliente.jsp?error=exception");
        }
    }
}
