<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sistema de Reservas Deportivas</title>
        <link rel="icon" type="image/png" href="images/iconoPr.png">
        <link rel="stylesheet" href="styles/styles_login.css"/>
    </head>

    <body>
        
        <div class="container">

            <h1>Inicio de Sesión</h1>
            <h3>Bienvenido</h3>

            <form action="LoginServlet" method="post">
                <label for="username">Usuario:</label>
                <input type="text" id="username" name="username" placeholder="Ingresa tu usuario" required>

                <label for="password">Contraseña:</label>
                <input type="password" id="password" name="password" placeholder="Ingresa tu contraseña" required>

                <div class="wrap">
                    <button type="submit">Ingresar</button>
                </div>
            </form>

            <p>¿No estás registrado?
                <a href="principal.jsp" style="text-decoration: none;">Crear cuenta</a>
            </p>
        </div>
    </body>
</html>
