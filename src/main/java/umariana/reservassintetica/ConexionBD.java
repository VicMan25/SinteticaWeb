/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package umariana.reservassintetica;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    private static String url = "jdbc:mysql://localhost:3306/gestion_reservas";
    private static String user = "root";
    private static String password = "123456";
    
    public static Connection conectar() throws SQLException
    {
        try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        }catch(ClassNotFoundException e){
            System.out.println("Error con el driver "+ e.getMessage());
        }
        return DriverManager.getConnection(url, user, password);
    }
    
    
}