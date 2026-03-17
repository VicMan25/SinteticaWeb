
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

@WebServlet(name = "sv_editarCliente", urlPatterns = {"/sv_editarCliente"})
public class sv_editarCliente extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet sv_editarCliente</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet sv_editarCliente at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id_cliente = Integer.parseInt(request.getParameter("id_cliente"));
        String nombre = request.getParameter("nombre");
        String telefono =request.getParameter("telefono");
        String email =request.getParameter("email");
        
        Cliente c = new Cliente();
        c.setId_cliente(id_cliente);
        c.setNombre(nombre);
        c.setTelefono(telefono);
        c.setEmail(email);
        
        GestionarClientes gesClientes = new GestionarClientes();
        try {
            gesClientes.editarCliente(c);
        } catch (SQLException e) {
            System.err.println("Error al editar cliente: " + e.getMessage());
        }
        response.sendRedirect("clientes.jsp");
    }

  
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
