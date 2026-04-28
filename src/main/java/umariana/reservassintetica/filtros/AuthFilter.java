package umariana.reservassintetica.filtros;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final Set<String> RUTAS_PUBLICAS = new HashSet<>(Arrays.asList(
            "/index.jsp",
            "/registro.jsp",
            "/LoginServlet",
            "/RegistroServlet",
            "/LogoutServlet"
    ));

    private static final Set<String> PREFIJOS_PUBLICOS = new HashSet<>(Arrays.asList(
            "/styles/",
            "/images/",
            "/resources/"
    ));

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ruta = request.getRequestURI().substring(request.getContextPath().length());

        if (ruta.isEmpty() || "/".equals(ruta)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        if (esPublica(ruta)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession sesion = request.getSession(false);
        boolean autenticado = sesion != null && sesion.getAttribute("usuarioLogueado") != null;

        if (autenticado) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=sesion");
        }
    }

    private boolean esPublica(String ruta) {
        if (RUTAS_PUBLICAS.contains(ruta)) {
            return true;
        }
        for (String prefijo : PREFIJOS_PUBLICOS) {
            if (ruta.startsWith(prefijo)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}
