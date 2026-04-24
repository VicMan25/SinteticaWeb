<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Cancha"%>
<%@page import="umariana.reservassintetica.GestionarCanchas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeNav", "canchas");

    int paginaCanchas = 1;
    int registrosPorPaginaCanchas = 10;
    if (request.getParameter("paginaCanchas") != null) {
        try { paginaCanchas = Integer.parseInt(request.getParameter("paginaCanchas")); } catch (Exception ignored) {}
    }

    GestionarCanchas gestionarCanchas = new GestionarCanchas();
    List<Cancha> listaCanchas = gestionarCanchas.listarCanchas(paginaCanchas, registrosPorPaginaCanchas);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Canchas - La Bombonera</title>
    <%@ include file="/WEB-INF/includes/head.jspf" %>
</head>
<body class="min-h-screen flex flex-col">

    <%@ include file="/WEB-INF/includes/nav.jspf" %>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 fade-in">

        <!-- Breadcrumb -->
        <nav class="text-xs text-gray-500 mb-3">
            <a href="principal.jsp" class="hover:text-bombonera-700"><i class="fa-solid fa-house"></i> Inicio</a>
            <span class="mx-1.5 text-gray-300">/</span>
            <span class="text-gray-700 font-medium">Canchas</span>
        </nav>

        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-3 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-flag-checkered text-amber-500"></i> Gestión de Canchas
                </h1>
                <p class="text-gray-500 text-sm">Administra los escenarios deportivos disponibles para reservar.</p>
            </div>
            <button type="button" id="btnAbrirAgregar"
                    class="inline-flex items-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg shadow-md transition">
                <i class="fa-solid fa-plus"></i> Nueva cancha
            </button>
        </div>

        <!-- Tabla -->
        <div class="bg-white rounded-xl shadow-card overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm table-hover">
                    <thead class="bg-gray-50 text-gray-600 uppercase text-xs tracking-wide">
                        <tr>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-tag mr-1 text-gray-400"></i> Nombre</th>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-layer-group mr-1 text-gray-400"></i> Tipo</th>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-dollar-sign mr-1 text-gray-400"></i> Precio/Hora</th>
                            <th class="px-5 py-3 text-right">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (listaCanchas == null || listaCanchas.isEmpty()) { %>
                            <tr>
                                <td colspan="4" class="text-center py-10 text-gray-400">
                                    <i class="fa-regular fa-folder-open text-3xl mb-2"></i>
                                    <p>No hay canchas registradas.</p>
                                </td>
                            </tr>
                        <% } else {
                            for (Cancha cancha : listaCanchas) {
                                String tipo = cancha.getTipo();
                                String tipoIcon  = "fa-futbol";
                                String tipoColor = "bg-gray-100 text-gray-700";
                                if ("Futbol 5".equals(tipo))  { tipoIcon = "fa-5"; tipoColor = "bg-emerald-100 text-emerald-700"; }
                                if ("Futbol 7".equals(tipo))  { tipoIcon = "fa-7"; tipoColor = "bg-blue-100 text-blue-700"; }
                                if ("Futbol 11".equals(tipo)) { tipoIcon = "fa-futbol"; tipoColor = "bg-amber-100 text-amber-700"; }
                        %>
                        <tr>
                            <td class="px-5 py-3">
                                <div class="flex items-center gap-3">
                                    <span class="w-9 h-9 rounded-lg bg-bombonera-50 text-bombonera-700 flex items-center justify-center">
                                        <i class="fa-solid fa-flag-checkered"></i>
                                    </span>
                                    <span class="font-medium text-gray-800"><%= cancha.getNombre() %></span>
                                </div>
                            </td>
                            <td class="px-5 py-3">
                                <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-medium <%= tipoColor %>">
                                    <i class="fa-solid <%= tipoIcon %>"></i> <%= tipo %>
                                </span>
                            </td>
                            <td class="px-5 py-3 font-semibold text-gray-800">$<%= String.format("%,.2f", cancha.getPrecio_hora()) %></td>
                            <td class="px-5 py-3">
                                <div class="flex justify-end gap-2">
                                    <button type="button"
                                            class="btnEditar inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 transition"
                                            data-id="<%= cancha.getId_cancha() %>"
                                            data-nombre="<%= cancha.getNombre() %>"
                                            data-tipo="<%= cancha.getTipo() %>"
                                            data-precio="<%= cancha.getPrecio_hora() %>">
                                        <i class="fa-solid fa-pen-to-square"></i> Editar
                                    </button>
                                    <a href="sv_eliminarCancha?id=<%= cancha.getId_cancha() %>"
                                       onclick="return confirm('¿Seguro que deseas eliminar la cancha <%= cancha.getNombre() %>?');"
                                       class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-lg bg-red-50 text-red-700 hover:bg-red-100 transition">
                                        <i class="fa-solid fa-trash"></i> Eliminar
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%      }
                           }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Paginación -->
            <div class="flex items-center justify-between px-5 py-3 border-t border-gray-100 text-sm">
                <div class="text-gray-500">Página <span class="font-semibold text-gray-700"><%= paginaCanchas %></span></div>
                <div class="flex gap-2">
                    <% if (paginaCanchas > 1) { %>
                        <a href="canchas.jsp?paginaCanchas=<%= paginaCanchas - 1 %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            <i class="fa-solid fa-chevron-left text-xs"></i> Anterior
                        </a>
                    <% } %>
                    <% if (listaCanchas != null && listaCanchas.size() == registrosPorPaginaCanchas) { %>
                        <a href="canchas.jsp?paginaCanchas=<%= paginaCanchas + 1 %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            Siguiente <i class="fa-solid fa-chevron-right text-xs"></i>
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/includes/footer.jspf" %>

    <!-- Modal: Agregar / Editar cancha (misma UI, campos compartidos) -->
    <div id="modalCancha" class="hidden fixed inset-0 z-50 bg-black/40 items-center justify-center p-4" aria-hidden="true">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden">
            <div class="flex items-center justify-between px-5 py-4 bg-gradient-to-r from-bombonera-800 to-bombonera-600 text-white">
                <h2 id="modalCanchaTitulo" class="font-semibold flex items-center gap-2">
                    <i class="fa-solid fa-flag-checkered"></i> <span>Nueva cancha</span>
                </h2>
                <button type="button" class="cerrarModalCancha text-white/80 hover:text-white text-xl leading-none">&times;</button>
            </div>
            <form id="formCancha" method="post" action="sv_agregarCancha" class="p-5 space-y-4">
                <input type="hidden" name="id_cancha" id="cancha_id" value="">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-tag"></i></span>
                        <input type="text" name="nombre" id="cancha_nombre" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tipo</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-layer-group"></i></span>
                        <select name="tipo" id="cancha_tipo" required
                                class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none bg-white">
                            <option value="">Seleccione tipo</option>
                            <option value="Futbol 5">Fútbol 5</option>
                            <option value="Futbol 7">Fútbol 7</option>
                            <option value="Futbol 11">Fútbol 11</option>
                        </select>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Precio por hora (COP)</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-dollar-sign"></i></span>
                        <input type="number" step="0.01" min="0" name="precio_hora" id="cancha_precio" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2">
                    <button type="button" class="cerrarModalCancha px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg">Cancelar</button>
                    <button type="submit" id="btnSubmitCancha"
                            class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold bg-bombonera-700 hover:bg-bombonera-800 text-white rounded-lg shadow">
                        <i class="fa-solid fa-floppy-disk"></i> <span>Guardar</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        (function () {
            var modal    = document.getElementById('modalCancha');
            var titulo   = document.getElementById('modalCanchaTitulo').querySelector('span');
            var form     = document.getElementById('formCancha');
            var iId      = document.getElementById('cancha_id');
            var iNombre  = document.getElementById('cancha_nombre');
            var iTipo    = document.getElementById('cancha_tipo');
            var iPrecio  = document.getElementById('cancha_precio');
            var btnSubmitLabel = document.getElementById('btnSubmitCancha').querySelector('span');

            function abrir() { modal.classList.remove('hidden'); modal.classList.add('flex'); }
            function cerrar() { modal.classList.add('hidden'); modal.classList.remove('flex'); }

            document.getElementById('btnAbrirAgregar').addEventListener('click', function () {
                form.action = 'sv_agregarCancha';
                titulo.textContent = 'Nueva cancha';
                btnSubmitLabel.textContent = 'Guardar';
                iId.value = '';
                iNombre.value = '';
                iTipo.value = '';
                iPrecio.value = '';
                abrir();
            });

            document.querySelectorAll('.btnEditar').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    form.action = 'sv_editarCancha';
                    titulo.textContent = 'Editar cancha';
                    btnSubmitLabel.textContent = 'Actualizar';
                    iId.value     = btn.getAttribute('data-id');
                    iNombre.value = btn.getAttribute('data-nombre');
                    iTipo.value   = btn.getAttribute('data-tipo');
                    iPrecio.value = btn.getAttribute('data-precio');
                    abrir();
                });
            });

            document.querySelectorAll('.cerrarModalCancha').forEach(function (el) {
                el.addEventListener('click', cerrar);
            });
            modal.addEventListener('click', function (e) { if (e.target === modal) cerrar(); });
            document.addEventListener('keydown', function (e) { if (e.key === 'Escape') cerrar(); });
        })();
    </script>
</body>
</html>
