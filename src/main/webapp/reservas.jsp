<%@page import="umariana.reservassintetica.GestionarClientes"%>
<%@page import="umariana.reservassintetica.GestionarCanchas"%>
<%@page import="umariana.reservassintetica.Cliente"%>
<%@page import="umariana.reservassintetica.Cancha"%>
<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Reserva"%>
<%@page import="umariana.reservassintetica.GestionarReservas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeNav", "reservas");

    String busqueda = request.getParameter("busqueda");
    String busq = busqueda != null ? busqueda.trim() : "";

    int paginaReservas = 1;
    int registrosPorPaginaReservas = 10;
    if (request.getParameter("paginaReservas") != null) {
        try { paginaReservas = Integer.parseInt(request.getParameter("paginaReservas")); } catch (Exception ignored) {}
    }

    GestionarReservas gestor = new GestionarReservas();
    List<Reserva> misReservas;

    if (!busq.isEmpty()) {
        misReservas = gestor.buscarReservas(busq);
    } else {
        misReservas = gestor.listarReservas(paginaReservas, registrosPorPaginaReservas);
    }

    GestionarClientes gestionarClientes = new GestionarClientes();
    List<Cliente> clientes = gestionarClientes.listarClientes(1, 1000);

    GestionarCanchas gestionarCanchas = new GestionarCanchas();
    List<Cancha> canchas = gestionarCanchas.listarCanchas(1, 1000);

    String error = request.getParameter("error");
    String ok    = request.getParameter("ok");
    String alertMsg = null, alertType = null;
    if ("ocupada".equals(error))      { alertMsg = "La cancha no está disponible en ese horario. Elige otro."; alertType = "danger"; }
    else if ("horas".equals(error))   { alertMsg = "La hora de fin debe ser posterior a la hora de inicio."; alertType = "danger"; }
    else if ("campos".equals(error))  { alertMsg = "Completa todos los campos requeridos."; alertType = "danger"; }
    else if ("servidor".equals(error)){ alertMsg = "Error del servidor. Intenta más tarde."; alertType = "danger"; }
    else if ("agregado".equals(ok))   { alertMsg = "Reserva creada correctamente."; alertType = "success"; }
    else if ("editado".equals(ok))    { alertMsg = "Reserva actualizada."; alertType = "success"; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reservas - La Bombonera</title>
    <%@ include file="/WEB-INF/includes/head.jspf" %>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
</head>
<body class="min-h-screen flex flex-col">

    <%@ include file="/WEB-INF/includes/nav.jspf" %>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 fade-in">

        <!-- Breadcrumb -->
        <nav class="text-xs text-gray-500 mb-3">
            <a href="principal.jsp" class="hover:text-bombonera-700"><i class="fa-solid fa-house"></i> Inicio</a>
            <span class="mx-1.5 text-gray-300">/</span>
            <span class="text-gray-700 font-medium">Reservas</span>
        </nav>

        <!-- Alerta -->
        <% if (alertMsg != null) {
            String cls = "danger".equals(alertType)
                ? "bg-red-50 border-red-200 text-red-700"
                : "bg-emerald-50 border-emerald-200 text-emerald-700";
            String ico = "danger".equals(alertType) ? "fa-circle-exclamation" : "fa-circle-check";
        %>
            <div class="mb-5 flex items-center gap-2 px-4 py-3 rounded-lg border <%= cls %>">
                <i class="fa-solid <%= ico %>"></i>
                <span class="text-sm"><%= alertMsg %></span>
            </div>
        <% } %>

        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-3 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-calendar-check text-bombonera-700"></i> Gestión de Reservas
                </h1>
                <p class="text-gray-500 text-sm">Agenda las horas de uso de las canchas del club.</p>
            </div>
            <button type="button" id="btnNuevaReserva"
                    class="inline-flex items-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg shadow-md transition">
                <i class="fa-solid fa-plus"></i> Nueva reserva
            </button>
        </div>

        <!-- Búsqueda -->
        <form action="reservas.jsp" method="get" class="bg-white rounded-xl shadow-card p-4 mb-6">
            <div class="flex flex-col sm:flex-row gap-2">
                <div class="relative flex-1">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" name="busqueda" value="<%= busq %>"
                           placeholder="Buscar por cliente o fecha (YYYY-MM-DD)..."
                           class="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                </div>
                <button type="submit" class="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg">
                    <i class="fa-solid fa-magnifying-glass"></i> Buscar
                </button>
                <% if (!busq.isEmpty()) { %>
                    <a href="reservas.jsp" class="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-semibold rounded-lg">
                        <i class="fa-solid fa-xmark"></i> Limpiar
                    </a>
                <% } %>
            </div>
        </form>

        <!-- Tabla -->
        <div class="bg-white rounded-xl shadow-card overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm table-hover">
                    <thead class="bg-gray-50 text-gray-600 uppercase text-xs tracking-wide">
                        <tr>
                            <th class="px-4 py-3 text-left"><i class="fa-solid fa-user mr-1 text-gray-400"></i> Cliente</th>
                            <th class="px-4 py-3 text-left"><i class="fa-solid fa-flag-checkered mr-1 text-gray-400"></i> Cancha</th>
                            <th class="px-4 py-3 text-left"><i class="fa-regular fa-calendar mr-1 text-gray-400"></i> Fecha</th>
                            <th class="px-4 py-3 text-left"><i class="fa-regular fa-clock mr-1 text-gray-400"></i> Horario</th>
                            <th class="px-4 py-3 text-left"><i class="fa-solid fa-flag mr-1 text-gray-400"></i> Estado</th>
                            <th class="px-4 py-3 text-right">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (misReservas == null || misReservas.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="text-center py-10 text-gray-400">
                                    <i class="fa-regular fa-calendar-xmark text-3xl mb-2"></i>
                                    <p>No hay reservas que mostrar.</p>
                                </td>
                            </tr>
                        <% } else {
                            for (Reserva reserva : misReservas) {
                                String estadoClass = "bg-gray-100 text-gray-700";
                                String estadoIcon  = "fa-circle";
                                if ("Pendiente".equals(reserva.getEstado()))  { estadoClass = "bg-amber-100 text-amber-700"; estadoIcon = "fa-hourglass-half"; }
                                if ("Confirmada".equals(reserva.getEstado())) { estadoClass = "bg-emerald-100 text-emerald-700"; estadoIcon = "fa-check"; }
                                if ("Cancelada".equals(reserva.getEstado()))  { estadoClass = "bg-red-100 text-red-700"; estadoIcon = "fa-xmark"; }
                        %>
                        <tr>
                            <td class="px-4 py-3">
                                <div class="flex items-center gap-2">
                                    <span class="w-8 h-8 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-xs font-semibold">
                                        <%= reserva.getNombre_cliente() != null && !reserva.getNombre_cliente().isEmpty() ? reserva.getNombre_cliente().substring(0,1).toUpperCase() : "?" %>
                                    </span>
                                    <span class="font-medium text-gray-800"><%= reserva.getNombre_cliente() %></span>
                                </div>
                            </td>
                            <td class="px-4 py-3 text-gray-700">
                                <i class="fa-solid fa-flag-checkered text-amber-500 mr-1"></i><%= reserva.getNombre_cancha() %>
                            </td>
                            <td class="px-4 py-3 text-gray-700"><%= reserva.getFecha() %></td>
                            <td class="px-4 py-3 text-gray-700"><%= reserva.getHora_inicio() %> - <%= reserva.getHora_fin() %></td>
                            <td class="px-4 py-3">
                                <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-medium <%= estadoClass %>">
                                    <i class="fa-solid <%= estadoIcon %>"></i> <%= reserva.getEstado() %>
                                </span>
                            </td>
                            <td class="px-4 py-3">
                                <div class="flex justify-end gap-2">
                                    <button type="button"
                                            class="btnEditar inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-lg bg-amber-50 text-amber-700 hover:bg-amber-100 transition"
                                            data-id="<%= reserva.getId_reserva() %>"
                                            data-id-cliente="<%= reserva.getId_cliente() %>"
                                            data-id-cancha="<%= reserva.getId_cancha() %>"
                                            data-fecha="<%= reserva.getFecha() %>"
                                            data-hora-inicio="<%= reserva.getHora_inicio() %>"
                                            data-hora-fin="<%= reserva.getHora_fin() %>"
                                            data-estado="<%= reserva.getEstado() %>">
                                        <i class="fa-solid fa-pen-to-square"></i> Editar
                                    </button>
                                    <a href="sv_eliminarReserva?id=<%= reserva.getId_reserva() %>"
                                       onclick="return confirm('¿Seguro que deseas eliminar esta reserva?');"
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

            <div class="flex items-center justify-between px-5 py-3 border-t border-gray-100 text-sm">
                <div class="text-gray-500">Página <span class="font-semibold text-gray-700"><%= paginaReservas %></span></div>
                <div class="flex gap-2">
                    <% if (paginaReservas > 1 && busq.isEmpty()) { %>
                        <a href="reservas.jsp?paginaReservas=<%= paginaReservas - 1 %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            <i class="fa-solid fa-chevron-left text-xs"></i> Anterior
                        </a>
                    <% } %>
                    <% if (misReservas != null && misReservas.size() == registrosPorPaginaReservas && busq.isEmpty()) { %>
                        <a href="reservas.jsp?paginaReservas=<%= paginaReservas + 1 %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600">
                            Siguiente <i class="fa-solid fa-chevron-right text-xs"></i>
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/includes/footer.jspf" %>

    <!-- Modal: Nueva Reserva -->
    <div id="modalReserva" class="hidden fixed inset-0 z-50 bg-black/40 items-center justify-center p-4 overflow-y-auto">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-lg overflow-hidden my-8">
            <div class="flex items-center justify-between px-5 py-4 bg-gradient-to-r from-bombonera-800 to-bombonera-600 text-white">
                <h2 class="font-semibold flex items-center gap-2"><i class="fa-solid fa-calendar-plus"></i> Nueva reserva</h2>
                <button type="button" class="cerrarModalNueva text-white/80 hover:text-white text-xl leading-none">&times;</button>
            </div>
            <form id="reservaForm" action="sv_agregarReserva" method="POST" class="p-5 space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-user text-gray-400 mr-1"></i> Cliente</label>
                    <select id="cliente" name="id_cliente" class="js-select-cliente w-full" required>
                        <option value="">Seleccione un cliente</option>
                        <% for (Cliente cliente : clientes) { %>
                        <option value="<%= cliente.getId_cliente() %>"><%= cliente.getNombre() %> (ID: <%= cliente.getId_cliente() %>)</option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-flag-checkered text-gray-400 mr-1"></i> Cancha</label>
                    <select id="cancha" name="id_cancha" class="js-select-cancha w-full" required>
                        <option value="">Seleccione una cancha</option>
                        <% for (Cancha cancha : canchas) { %>
                        <option value="<%= cancha.getId_cancha() %>"><%= cancha.getNombre() %> (ID: <%= cancha.getId_cancha() %>) - <%= cancha.getTipo() %></option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-calendar text-gray-400 mr-1"></i> Fecha</label>
                    <input type="date" name="fecha" id="fecha" required
                           class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-clock text-gray-400 mr-1"></i> Hora inicio</label>
                        <input type="time" name="hora_inicio" id="hora_inicio" required
                               class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-clock text-gray-400 mr-1"></i> Hora fin</label>
                        <input type="time" name="hora_fin" id="hora_fin" required
                               class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-flag text-gray-400 mr-1"></i> Estado</label>
                    <select name="estado" required
                            class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none bg-white">
                        <option value="Pendiente">Pendiente</option>
                        <option value="Confirmada">Confirmada</option>
                    </select>
                </div>

                <div class="flex justify-end gap-2 pt-2">
                    <button type="button" class="cerrarModalNueva px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg">Cancelar</button>
                    <button type="submit" class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold bg-bombonera-700 hover:bg-bombonera-800 text-white rounded-lg shadow">
                        <i class="fa-solid fa-floppy-disk"></i> Guardar reserva
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Editar Reserva -->
    <div id="modalEditarReserva" class="hidden fixed inset-0 z-50 bg-black/40 items-center justify-center p-4 overflow-y-auto">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-lg overflow-hidden my-8">
            <div class="flex items-center justify-between px-5 py-4 bg-gradient-to-r from-bombonera-800 to-bombonera-600 text-white">
                <h2 class="font-semibold flex items-center gap-2"><i class="fa-solid fa-pen-to-square"></i> Editar reserva</h2>
                <button type="button" class="cerrarModalEditar text-white/80 hover:text-white text-xl leading-none">&times;</button>
            </div>
            <form action="sv_editarReserva" method="POST" class="p-5 space-y-4">
                <input type="hidden" name="id_reserva" id="editar_id_reserva">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-user text-gray-400 mr-1"></i> Cliente</label>
                    <select id="editar_cliente" name="id_cliente" class="js-select-cliente-edit w-full" required>
                        <option value="">Seleccione un cliente</option>
                        <% for (Cliente cliente : clientes) { %>
                        <option value="<%= cliente.getId_cliente() %>"><%= cliente.getNombre() %> (ID: <%= cliente.getId_cliente() %>)</option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-flag-checkered text-gray-400 mr-1"></i> Cancha</label>
                    <select id="editar_cancha" name="id_cancha" class="js-select-cancha-edit w-full" required>
                        <option value="">Seleccione una cancha</option>
                        <% for (Cancha cancha : canchas) { %>
                        <option value="<%= cancha.getId_cancha() %>"><%= cancha.getNombre() %> (ID: <%= cancha.getId_cancha() %>) - <%= cancha.getTipo() %></option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-calendar text-gray-400 mr-1"></i> Fecha</label>
                    <input type="date" name="fecha" id="editar_fecha" required
                           class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-clock text-gray-400 mr-1"></i> Hora inicio</label>
                        <input type="time" name="hora_inicio" id="editar_hora_inicio" required
                               class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-regular fa-clock text-gray-400 mr-1"></i> Hora fin</label>
                        <input type="time" name="hora_fin" id="editar_hora_fin" required
                               class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fa-solid fa-flag text-gray-400 mr-1"></i> Estado</label>
                    <select name="estado" id="editar_estado" required
                            class="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-bombonera-600 focus:border-bombonera-600 outline-none bg-white">
                        <option value="Pendiente">Pendiente</option>
                        <option value="Confirmada">Confirmada</option>
                        <option value="Cancelada">Cancelada</option>
                    </select>
                </div>

                <div class="flex justify-end gap-2 pt-2">
                    <button type="button" class="cerrarModalEditar px-4 py-2 text-sm font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-lg">Cancelar</button>
                    <button type="submit" class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold bg-bombonera-700 hover:bg-bombonera-800 text-white rounded-lg shadow">
                        <i class="fa-solid fa-floppy-disk"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        var modalNueva  = document.getElementById('modalReserva');
        var modalEditar = document.getElementById('modalEditarReserva');

        function mostrar(m) { m.classList.remove('hidden'); m.classList.add('flex'); }
        function ocultar(m) { m.classList.add('hidden'); m.classList.remove('flex'); }

        document.getElementById('btnNuevaReserva').addEventListener('click', function () {
            mostrar(modalNueva);
            $('#cliente').trigger('change.select2');
            $('#cancha').trigger('change.select2');
        });
        document.querySelectorAll('.cerrarModalNueva').forEach(function (el) { el.addEventListener('click', function () { ocultar(modalNueva); }); });
        document.querySelectorAll('.cerrarModalEditar').forEach(function (el) { el.addEventListener('click', function () { ocultar(modalEditar); }); });

        [modalNueva, modalEditar].forEach(function (m) {
            m.addEventListener('click', function (e) { if (e.target === m) ocultar(m); });
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') { ocultar(modalNueva); ocultar(modalEditar); }
        });

        $(function () {
            $('#cliente, #editar_cliente').select2({
                placeholder: 'Escriba para buscar cliente...',
                dropdownParent: $(document.body)
            });
            $('#cancha, #editar_cancha').select2({
                placeholder: 'Escriba para buscar cancha...',
                dropdownParent: $(document.body)
            });

            var hoy = new Date().toISOString().split('T')[0];
            document.getElementById('fecha').min = hoy;

            $('#hora_fin').on('change', function () {
                var ini = $('#hora_inicio').val();
                var fin = $(this).val();
                if (ini && fin && fin <= ini) {
                    alert('La hora de fin debe ser posterior a la hora de inicio');
                    $(this).val('');
                }
            });
            $('#editar_hora_fin').on('change', function () {
                var ini = $('#editar_hora_inicio').val();
                var fin = $(this).val();
                if (ini && fin && fin <= ini) {
                    alert('La hora de fin debe ser posterior a la hora de inicio');
                    $(this).val('');
                }
            });

            $('#reservaForm').on('submit', function (e) {
                if (!$('#cliente').val()) { alert('Debe seleccionar un cliente'); e.preventDefault(); return false; }
                if (!$('#cancha').val())  { alert('Debe seleccionar una cancha');  e.preventDefault(); return false; }
            });

            document.querySelectorAll('.btnEditar').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    document.getElementById('editar_id_reserva').value = btn.getAttribute('data-id');
                    document.getElementById('editar_fecha').value       = btn.getAttribute('data-fecha');
                    document.getElementById('editar_hora_inicio').value = btn.getAttribute('data-hora-inicio');
                    document.getElementById('editar_hora_fin').value    = btn.getAttribute('data-hora-fin');
                    document.getElementById('editar_estado').value      = btn.getAttribute('data-estado');
                    $('#editar_cliente').val(btn.getAttribute('data-id-cliente')).trigger('change');
                    $('#editar_cancha').val(btn.getAttribute('data-id-cancha')).trigger('change');
                    mostrar(modalEditar);
                });
            });
        });
    </script>

</body>
</html>
