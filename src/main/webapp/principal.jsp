<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Reservas Deportivas</title>
        <link rel="icon" type="image/png" href="images/iconoPr.png">
        <link rel="stylesheet" href="styles/styles_index.css"/>
    </head>
    <body>

        <nav class="navbar">
            <div class="navbar-container">
                <a href="index.jsp" class="navbar-logo">La Bombonera</a>
                <ul class="navbar-menu">
                    <li class="dropdown">
                        <a href="#">Cerrar Sesión ▾</a>
                        <ul class="dropdown-menu">
                            <a>Usuario</a>
                            <li><a>Victor Manuel Velasquez B</a></li>
                            <li><a href="copas.jsp">victormanux0925@gmail.com</a></li>
                            <a href="index.jsp">Salir</a>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="welcome-container">
            <img src="images/iconoPr.png" alt="Logo" class="logo" />
            <h1>Sistema De Reservas La Bombonera</h1>
            <p>Seleccione el módulo que desea gestionar:</p>

            <div class="modules">
                <a href="clientes.jsp" class="module-card">
                    <div class="module-icon">👥</div>
                    <div class="module-title">Clientes</div>
                    <div class="btn-module">Entrar</div>
                </a>

                <a href="canchas.jsp" class="module-card">
                    <div class="module-icon">🏟️</div>
                    <div class="module-title">Canchas</div>
                    <div class="btn-module">Entrar</div>
                </a>

                <a href="reservas.jsp" class="module-card">
                    <div class="module-icon">📅</div>
                    <div class="module-title">Reservas</div>
                    <div class="btn-module">Entrar</div>
                </a>
            </div>

            <footer>
                Sistema desarrollado por Valentina A - Carlos Q - Victor V © <%= java.time.Year.now().getValue()%>
            </footer>
        </div>

    </body>
</html>