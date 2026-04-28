package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Proveedor central de conexiones a la base de datos.
 *
 * Resuelve el DataSource "jdbc/bombonera" vía JNDI (declarado en
 * META-INF/context.xml y referenciado en WEB-INF/web.xml). El lookup se
 * hace una sola vez y se cachea — el pool es manejado por Tomcat (DBCP2).
 *
 * Las credenciales ya no viven en el código: se configuran en context.xml
 * y pueden sobrescribirse en producción vía
 * $CATALINA_BASE/conf/Catalina/localhost/reservasSintetica.xml.
 */
public class ConexionBD {

    private static final String JNDI_NAME = "java:comp/env/jdbc/bombonera";

    private static volatile DataSource dataSource;

    private ConexionBD() { }

    private static DataSource getDataSource() throws SQLException {
        DataSource ds = dataSource;
        if (ds == null) {
            synchronized (ConexionBD.class) {
                ds = dataSource;
                if (ds == null) {
                    try {
                        Context ctx = new InitialContext();
                        ds = (DataSource) ctx.lookup(JNDI_NAME);
                        dataSource = ds;
                    } catch (NamingException e) {
                        throw new SQLException(
                                "No se pudo resolver el DataSource JNDI '" + JNDI_NAME
                                + "'. Revisa META-INF/context.xml (Resource) y WEB-INF/web.xml (resource-ref).",
                                e);
                    }
                }
            }
        }
        return ds;
    }

    /**
     * Devuelve una conexión del pool. El caller DEBE cerrarla (try-with-resources)
     * para devolverla al pool — cerrarla NO cierra la conexión física.
     */
    public static Connection conectar() throws SQLException {
        return getDataSource().getConnection();
    }
}
