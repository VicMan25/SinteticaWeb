package umariana.reservassintetica;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class InitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        GestionarUsuarios dao = new GestionarUsuarios();
        try {
            if (!dao.hayAlgunUsuario()) {
                Usuario admin = new Usuario();
                admin.setUsername("admin");
                admin.setNombre("Administrador");
                admin.setEmail("admin@labombonera.local");
                admin.setRol("admin");
                dao.registrar(admin, "admin123");
                sce.getServletContext().log("Usuario admin creado (admin / admin123)");
            }
        } catch (Exception e) {
            sce.getServletContext().log("Error inicializando usuario admin: " + e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
