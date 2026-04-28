<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    String ok    = request.getParameter("ok");
    String msg   = null;
    String tipo  = null;
    if ("credenciales".equals(error)) { msg = "Usuario o contraseña incorrectos."; tipo = "danger"; }
    else if ("sesion".equals(error))  { msg = "Debes iniciar sesión para continuar."; tipo = "danger"; }
    else if ("campos".equals(error))  { msg = "Completa usuario y contraseña."; tipo = "danger"; }
    else if ("servidor".equals(error)){ msg = "Error del servidor. Intenta más tarde."; tipo = "danger"; }
    else if ("registrado".equals(ok)) { msg = "Cuenta creada. Inicia sesión."; tipo = "success"; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - La Bombonera</title>
    <link rel="icon" type="image/png" href="images/iconoPr.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .bg-cancha {
            background-image:
                linear-gradient(rgba(6,78,59,0.85), rgba(4,47,34,0.85)),
                url('images/fondo_cancha.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="bg-cancha min-h-screen flex items-center justify-center p-4">

    <div class="w-full max-w-md">
        <div class="bg-white rounded-2xl shadow-2xl overflow-hidden">
            <div class="bg-gradient-to-r from-green-700 to-green-600 p-8 text-center">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-white rounded-full shadow-lg mb-4">
                    <i class="fa-solid fa-futbol text-4xl text-green-700"></i>
                </div>
                <h1 class="text-3xl font-bold text-white">La Bombonera</h1>
                <p class="text-green-100 text-sm mt-1">Sistema de Reservas Deportivas</p>
            </div>

            <div class="p-8">
                <h2 class="text-xl font-semibold text-gray-800 mb-1">Bienvenido</h2>
                <p class="text-gray-500 text-sm mb-6">Ingresa tus credenciales para continuar</p>

                <% if (msg != null) { %>
                    <div class="mb-4 flex items-start gap-2 px-4 py-3 rounded-lg <%= "danger".equals(tipo) ? "bg-red-50 border border-red-200 text-red-700" : "bg-green-50 border border-green-200 text-green-700" %>">
                        <i class="fa-solid <%= "danger".equals(tipo) ? "fa-circle-exclamation" : "fa-circle-check" %> mt-0.5"></i>
                        <span class="text-sm"><%= msg %></span>
                    </div>
                <% } %>

                <form action="LoginServlet" method="post" class="space-y-4">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Usuario</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-user"></i>
                            </span>
                            <input type="text" id="username" name="username" required
                                   placeholder="Tu nombre de usuario"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Contraseña</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input type="password" id="password" name="password" required
                                   placeholder="Ingresa tu contraseña"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <button type="submit"
                            class="w-full bg-gradient-to-r from-green-700 to-green-600 hover:from-green-800 hover:to-green-700 text-white font-semibold py-2.5 rounded-lg shadow-md hover:shadow-lg transition flex items-center justify-center gap-2">
                        <i class="fa-solid fa-right-to-bracket"></i>
                        Ingresar
                    </button>
                </form>

                <div class="relative my-6">
                    <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-gray-200"></div></div>
                    <div class="relative flex justify-center text-xs uppercase">
                        <span class="bg-white px-3 text-gray-400">o</span>
                    </div>
                </div>

                <p class="text-center text-sm text-gray-600">
                    ¿No tienes cuenta?
                    <a href="registro.jsp" class="text-green-700 font-semibold hover:text-green-800 hover:underline">
                        Crear cuenta <i class="fa-solid fa-arrow-right text-xs ml-1"></i>
                    </a>
                </p>
            </div>
        </div>

        <p class="text-center text-green-100 text-xs mt-6">
            © <%= java.time.Year.now().getValue() %> La Bombonera · Reservas Deportivas
        </p>
    </div>
</body>
</html>
