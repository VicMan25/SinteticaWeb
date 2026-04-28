<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    String msg = null;
    if ("campos".equals(error))            msg = "Revisa los campos: nombre, usuario y contraseña (mínimo 6 caracteres).";
    else if ("confirmacion".equals(error)) msg = "Las contraseñas no coinciden.";
    else if ("existe".equals(error))       msg = "Ese usuario ya está registrado.";
    else if ("servidor".equals(error))     msg = "Error del servidor. Intenta más tarde.";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Cuenta - La Bombonera</title>
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
            <div class="bg-gradient-to-r from-green-700 to-green-600 p-6 text-center">
                <div class="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full shadow-lg mb-3">
                    <i class="fa-solid fa-user-plus text-2xl text-green-700"></i>
                </div>
                <h1 class="text-2xl font-bold text-white">Crear Cuenta</h1>
                <p class="text-green-100 text-xs mt-1">Regístrate para acceder al sistema</p>
            </div>

            <div class="p-8">
                <% if (msg != null) { %>
                    <div class="mb-4 flex items-start gap-2 px-4 py-3 rounded-lg bg-red-50 border border-red-200 text-red-700">
                        <i class="fa-solid fa-circle-exclamation mt-0.5"></i>
                        <span class="text-sm"><%= msg %></span>
                    </div>
                <% } %>

                <form action="RegistroServlet" method="post" class="space-y-4">
                    <div>
                        <label for="nombre" class="block text-sm font-medium text-gray-700 mb-1">Nombre Completo</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-id-card"></i>
                            </span>
                            <input type="text" id="nombre" name="nombre" required
                                   placeholder="Tu nombre"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Usuario</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-user"></i>
                            </span>
                            <input type="text" id="username" name="username" required
                                   placeholder="Nombre de usuario"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-envelope"></i>
                            </span>
                            <input type="email" id="email" name="email"
                                   placeholder="tu@correo.com"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Contraseña</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input type="password" id="password" name="password" required minlength="6"
                                   placeholder="Mínimo 6 caracteres"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <div>
                        <label for="confirma" class="block text-sm font-medium text-gray-700 mb-1">Confirmar Contraseña</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input type="password" id="confirma" name="confirma" required minlength="6"
                                   placeholder="Repite la contraseña"
                                   class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none transition">
                        </div>
                    </div>

                    <button type="submit"
                            class="w-full bg-gradient-to-r from-green-700 to-green-600 hover:from-green-800 hover:to-green-700 text-white font-semibold py-2.5 rounded-lg shadow-md hover:shadow-lg transition flex items-center justify-center gap-2">
                        <i class="fa-solid fa-user-plus"></i>
                        Registrarme
                    </button>
                </form>

                <p class="text-center text-sm text-gray-600 mt-6">
                    ¿Ya tienes cuenta?
                    <a href="index.jsp" class="text-green-700 font-semibold hover:text-green-800 hover:underline">
                        Iniciar sesión <i class="fa-solid fa-arrow-right text-xs ml-1"></i>
                    </a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
