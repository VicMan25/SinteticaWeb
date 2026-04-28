<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Cliente"%>
<%@page import="umariana.reservassintetica.GestionarClientes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeNav", "clientes");

    int paginaClientes = 1;
    int registrosPorPaginaClientes = 10;
    if (request.getParameter("paginaClientes") != null) {
        try { paginaClientes = Integer.parseInt(request.getParameter("paginaClientes")); } catch (Exception ignored) {}
    }

    String buscarNombre = request.getParameter("buscarNombre");
    String buscar = buscarNombre != null ? buscarNombre.trim() : "";

    GestionarClientes gestionarClientes = new GestionarClientes();
    List<Cliente> listaClientes;

    if (!buscar.isEmpty()) {
        listaClientes = gestionarClientes.listarClientesPorNombre(buscar, paginaClientes, registrosPorPaginaClientes);
    } else {
        listaClientes = gestionarClientes.listarClientes(paginaClientes, registrosPorPaginaClientes);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Clientes - La Bombonera</title>
    <%@ include file="/WEB-INF/includes/head.jspf" %>
</head>
<body class="min-h-screen flex flex-col">

    <%@ include file="/WEB-INF/includes/nav.jspf" %>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 fade-in">

        <!-- Breadcrumb -->
        <nav class="text-xs text-gray-500 mb-3">
            <a href="principal.jsp" class="hover:text-bombonera-700"><i class="fa-solid fa-house"></i> Inicio</a>
            <span class="mx-1.5 text-gray-300">/</span>
            <span class="text-gray-700 font-medium">Clientes</span>
        </nav>

        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-3 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-users text-blue-600"></i> Gestión de Clientes
                </h1>
                <p class="text-gray-500 text-sm">Personas registradas que pueden reservar canchas.</p>
            </div>
            <button type="button" id="btnNuevoCliente"
                    class="inline-flex items-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg shadow-md transition">
                <i class="fa-solid fa-user-plus"></i> Nuevo cliente
            </button>
        </div>

        <!-- Barra de búsqueda -->
        <form method="get" action="clientes.jsp" class="bg-white rounded-xl shadow-card p-4 mb-6">
            <div class="flex flex-col sm:flex-row gap-2">
                <div class="relative flex-1">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" name="buscarNombre" value="<%= buscar %>"
                           placeholder="Buscar cliente por nombre..."
                           class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                </div>
                <button type="submit" class="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg">
                    <i class="fa-solid fa-magnifying-glass"></i> Buscar
                </button>
                <% if (!buscar.isEmpty()) { %>
                    <a href="clientes.jsp" class="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-semibold rounded-lg">
                        <i class="fa-solid fa-xmark"></i> Limpiar
                    </a>
                <% } %>
            </div>
            <% if (!buscar.isEmpty()) { %>
                <p class="text-xs text-gray-500 mt-2">
                    <i class="fa-solid fa-filter"></i> Filtrando por: <span class="font-semibold text-gray-700"><%= buscar %></span>
                </p>
            <% } %>
        </form>

        <!-- Tabla -->
        <div class="bg-white rounded-xl shadow-card overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm table-hover">
                    <thead class="bg-gray-50 text-gray-600 uppercase text-xs tracking-wide">
                        <tr>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-user mr-1 text-gray-400"></i> Nombre</th>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-phone mr-1 text-gray-400"></i> Teléfono</th>
                            <th class="px-5 py-3 text-left"><i class="fa-solid fa-envelope mr-1 text-gray-400"></i> Email</th>
                            <th class="px-5 py-3 text-right">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (listaClientes == null || listaClientes.isEmpty()) { %>
                            <tr>
                                <td colspan="4" class="text-center py-10 text-gray-400">
                                    <i class="fa-regular fa-user text-3xl mb-2"></i>
                                    <p>No hay clientes para mostrar.</p>
                                </td>
                            </tr>
                        <% } else {
                            for (Cliente cliente : listaClientes) {
                                String inicial = cliente.getNombre() != null && !cliente.getNombre().isEmpty()
                                        ? cliente.getNombre().substring(0,1).toUpperCase() : "?";
                        %>
                        <tr>
                            <td class="px-5 py-3">
                                <div class="flex items-center gap-3">
                                    <span class="w-9 h-9 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center font-semibold"><%= inicial %></span>
                                    <span class="font-medium text-gray-800"><%= cliente.getNombre() %></span>
                                </div>
                            </td>
                            <td class="px-5 py-3 text-gray-600">
                                <% if (cliente.getTelefono() != null && !cliente.getTelefono().isEmpty()) { %>
                                    <a href="tel:<%= cliente.getTelefono() %>" class="hover:text-bombonera-700">
                                        <i class="fa-solid fa-phone text-gray-400 mr-1"></i><%= cliente.getTelefono() %>
                                    </a>
                                <% } else { %>
                                    <span class="text-gray-300">—</span>
                                <% } %>
                            </td>
                            <td class="px-5 py-3 text-gray-600">
                                <% if (cliente.getEmail() != null && !cliente.getEmail().isEmpty()) { %>
                                    <a href="mailto:<%= cliente.getEmail() %>" class="hover:text-bombonera-700 truncate">
                                        <i class="fa-solid fa-envelope text-gray-400 mr-1"></i><%= cliente.getEmail() %>
                                    </a>
                                <% } else { %>
                                    <span class="text-gray-300">—</span>
                                <% } %>
                            </td>
                            <td class="px-5 py-3">
                                <div class="flex justify-end gap-2">
                                    <button type="button"
                                            class="btnEditar inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 transition"
                                            data-id="<%= cliente.getId_cliente() %>"
                                            data-nombre="<%= cliente.getNombre() %>"
                                            data-telefono="<%= cliente.getTelefono() != null ? cliente.getTelefono() : "" %>"
                                            data-email="<%= cliente.getEmail() != null ? cliente.getEmail() : "" %>">
                                        <i class="fa-solid fa-pen-to-square"></i> Editar
                                    </button>
                                    <a href="sv_eliminarCliente?id=<%= cliente.getId_cliente() %>"
                                       onclick="return confirm('¿Seguro que deseas eliminar a <%= cliente.getNombre() %>?');"
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
                <div class="text-gray-500">Página <span class="font-semibold text-gray-700"><%= paginaClientes %></span></div>
                <div class="flex gap-2">
                    <% if (paginaClientes > 1) {
                           String qp = !buscar.isEmpty() ? ("&buscarNombre=" + java.net.URLEncoder.encode(buscar, "UTF-8")) : "";
                    %>
                        <a href="clientes.jsp?paginaClientes=<%= paginaClientes - 1 %><%= qp %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            <i class="fa-solid fa-chevron-left text-xs"></i> Anterior
                        </a>
                    <% } %>
                    <% if (listaClientes != null && listaClientes.size() == registrosPorPaginaClientes) {
                           String qn = !buscar.isEmpty() ? ("&buscarNombre=" + java.net.URLEncoder.encode(buscar, "UTF-8")) : "";
                    %>
                        <a href="clientes.jsp?paginaClientes=<%= paginaClientes + 1 %><%= qn %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            Siguiente <i class="fa-solid fa-chevron-right text-xs"></i>
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/includes/footer.jspf" %>

    <!-- Modal Agregar Cliente -->
    <div id="modalAgregarCliente" class="hidden fixed inset-0 z-50 bg-black/40 items-center justify-center p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden">
            <div class="flex items-center justify-between px-5 py-4 bg-gradient-to-r from-bombonera-800 to-bombonera-600 text-white">
                <h2 class="font-semibold flex items-center gap-2"><i class="fa-solid fa-user-plus"></i> Nuevo cliente</h2>
                <button type="button" class="cerrarModalAgregar text-white/80 hover:text-white text-xl leading-none">&times;</button>
            </div>
            <form action="sv_agregarCliente" method="POST" class="p-5 space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre completo</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-id-card"></i></span>
                        <input type="text" name="nombres" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Teléfono</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-phone"></i></span>
                        <input type="tel" name="telefono" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-envelope"></i></span>
                        <input type="email" name="email" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2">
                    <button type="button" class="cerrarModalAgregar px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg">Cancelar</button>
                    <button type="submit" class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold bg-bombonera-700 hover:bg-bombonera-800 text-white rounded-lg shadow">
                        <i class="fa-solid fa-floppy-disk"></i> Guardar cliente
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Editar Cliente -->
    <div id="modalEditarCliente" class="hidden fixed inset-0 z-50 bg-black/40 items-center justify-center p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden">
            <div class="flex items-center justify-between px-5 py-4 bg-gradient-to-r from-bombonera-800 to-bombonera-600 text-white">
                <h2 class="font-semibold flex items-center gap-2"><i class="fa-solid fa-pen-to-square"></i> Editar cliente</h2>
                <button type="button" class="cerrarModalEditar text-white/80 hover:text-white text-xl leading-none">&times;</button>
            </div>
            <form action="sv_editarCliente" method="post" class="p-5 space-y-4">
                <input type="hidden" name="id_cliente" id="editar_id_cliente">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nombre completo</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-id-card"></i></span>
                        <input type="text" id="editar_nombre" name="nombre" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Teléfono</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-phone"></i></span>
                        <input type="text" id="editar_telefono" name="telefono" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-envelope"></i></span>
                        <input type="email" id="editar_email" name="email" required
                               class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2">
                    <button type="button" class="cerrarModalEditar px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg">Cancelar</button>
                    <button type="submit" class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold bg-bombonera-700 hover:bg-bombonera-800 text-white rounded-lg shadow">
                        <i class="fa-solid fa-floppy-disk"></i> Actualizar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        (function () {
            var modalAgregar = document.getElementById('modalAgregarCliente');
            var modalEditar  = document.getElementById('modalEditarCliente');

            function mostrar(m) { m.classList.remove('hidden'); m.classList.add('flex'); }
            function ocultar(m) { m.classList.add('hidden'); m.classList.remove('flex'); }

            document.getElementById('btnNuevoCliente').addEventListener('click', function () { mostrar(modalAgregar); });
            document.querySelectorAll('.cerrarModalAgregar').forEach(function (el) { el.addEventListener('click', function () { ocultar(modalAgregar); }); });
            document.querySelectorAll('.cerrarModalEditar').forEach(function (el) { el.addEventListener('click', function () { ocultar(modalEditar); }); });

            document.querySelectorAll('.btnEditar').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    document.getElementById('editar_id_cliente').value = btn.getAttribute('data-id');
                    document.getElementById('editar_nombre').value     = btn.getAttribute('data-nombre');
                    document.getElementById('editar_telefono').value   = btn.getAttribute('data-telefono');
                    document.getElementById('editar_email').value      = btn.getAttribute('data-email');
                    mostrar(modalEditar);
                });
            });

            [modalAgregar, modalEditar].forEach(function (m) {
                m.addEventListener('click', function (e) { if (e.target === m) ocultar(m); });
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') { ocultar(modalAgregar); ocultar(modalEditar); }
            });
        })();
    </script>
</body>
</html>
