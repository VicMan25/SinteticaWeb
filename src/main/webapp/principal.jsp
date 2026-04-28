<%@page import="umariana.reservassintetica.GestionarFinanzas"%>
<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
    request.setAttribute("activeNav", "dashboard");

    // KPIs
    GestionarFinanzas gf = new GestionarFinanzas();
    int    kpiReservasHoy   = 0;
    int    kpiTotalReservas = 0;
    int    kpiClientes      = 0;
    int    kpiCanchas       = 0;
    int    kpiPendientes    = 0;
    double kpiIngresosMes   = 0d;
    List<GestionarFinanzas.FilaProximaReserva> proximas = java.util.Collections.emptyList();
    try {
        kpiReservasHoy   = gf.reservasHoy();
        kpiTotalReservas = gf.totalReservas();
        kpiClientes      = gf.totalClientes();
        kpiCanchas       = gf.totalCanchas();
        kpiPendientes    = gf.reservasPendientes();
        kpiIngresosMes   = gf.ingresosMesActual();
        proximas         = gf.proximasReservas(5);
    } catch (Exception e) {
        // El dashboard degrada a 0 si algo falla, no rompe el flujo.
    }

    String hora = new java.text.SimpleDateFormat("HH").format(new java.util.Date());
    int h = Integer.parseInt(hora);
    String saludo = (h < 12) ? "Buenos días" : (h < 19 ? "Buenas tardes" : "Buenas noches");
    String fechaHoy = new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("es","ES"))
                          .format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - La Bombonera</title>
    <%@ include file="/WEB-INF/includes/head.jspf" %>
</head>
<body class="min-h-screen flex flex-col">

    <%@ include file="/WEB-INF/includes/nav.jspf" %>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 fade-in">

        <!-- Saludo -->
        <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-3 mb-8">
            <div>
                <p class="text-sm text-gray-500"><i class="fa-regular fa-calendar mr-1"></i><%= fechaHoy %></p>
                <h1 class="text-3xl font-bold text-gray-800 mt-1">
                    <%= saludo %>, <span class="text-bombonera-700"><%= usuarioLogueado != null ? usuarioLogueado.getNombre().split(" ")[0] : "Usuario" %></span>
                </h1>
                <p class="text-gray-500 mt-1">Este es el resumen de actividad del sistema hoy.</p>
            </div>
            <div class="flex gap-2">
                <a href="reservas.jsp" class="inline-flex items-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg shadow-md transition">
                    <i class="fa-solid fa-plus"></i> Nueva reserva
                </a>
                <a href="finanzas.jsp" class="inline-flex items-center gap-2 px-4 py-2.5 bg-white hover:bg-gray-50 border border-gray-200 text-gray-700 text-sm font-semibold rounded-lg shadow-sm transition">
                    <i class="fa-solid fa-chart-line"></i> Ver finanzas
                </a>
            </div>
        </div>

        <!-- KPI cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-bombonera-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Reservas hoy</p>
                        <p class="text-3xl font-bold text-gray-800 mt-1"><%= kpiReservasHoy %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-bombonera-100 flex items-center justify-center">
                        <i class="fa-solid fa-calendar-day text-bombonera-700 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2"><%= kpiPendientes %> pendientes</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-blue-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Clientes</p>
                        <p class="text-3xl font-bold text-gray-800 mt-1"><%= kpiClientes %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                        <i class="fa-solid fa-users text-blue-600 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2">registrados en el sistema</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-amber-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Canchas</p>
                        <p class="text-3xl font-bold text-gray-800 mt-1"><%= kpiCanchas %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-amber-100 flex items-center justify-center">
                        <i class="fa-solid fa-flag-checkered text-amber-600 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2">activas para reservar</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-emerald-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Ingresos del mes</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1">$<%= String.format("%,.0f", kpiIngresosMes) %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-emerald-100 flex items-center justify-center">
                        <i class="fa-solid fa-sack-dollar text-emerald-600 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2"><%= kpiTotalReservas %> reservas totales</p>
            </div>
        </div>

        <div class="grid lg:grid-cols-3 gap-6">

            <!-- Accesos rápidos -->
            <section class="lg:col-span-2 bg-white rounded-xl shadow-card p-6">
                <div class="flex items-center justify-between mb-5">
                    <h2 class="text-lg font-semibold text-gray-800">
                        <i class="fa-solid fa-bolt text-bombonera-700 mr-2"></i> Módulos del sistema
                    </h2>
                </div>

                <div class="grid sm:grid-cols-2 gap-4">
                    <a href="reservas.jsp" class="group relative overflow-hidden rounded-xl border border-gray-200 bg-gradient-to-br from-bombonera-50 to-white p-5 hover:shadow-card-hover hover:border-bombonera-600 transition">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-lg bg-bombonera-700 text-white flex items-center justify-center shadow-md group-hover:scale-105 transition">
                                <i class="fa-solid fa-calendar-check text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-semibold text-gray-800">Reservas</h3>
                                <p class="text-sm text-gray-500 mt-0.5">Agendar, editar y consultar horarios.</p>
                            </div>
                        </div>
                        <span class="absolute bottom-3 right-3 text-bombonera-700 opacity-0 group-hover:opacity-100 transition">
                            <i class="fa-solid fa-arrow-right"></i>
                        </span>
                    </a>

                    <a href="canchas.jsp" class="group relative overflow-hidden rounded-xl border border-gray-200 bg-gradient-to-br from-amber-50 to-white p-5 hover:shadow-card-hover hover:border-amber-500 transition">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-lg bg-amber-500 text-white flex items-center justify-center shadow-md group-hover:scale-105 transition">
                                <i class="fa-solid fa-flag-checkered text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-semibold text-gray-800">Canchas</h3>
                                <p class="text-sm text-gray-500 mt-0.5">Tipos, precios por hora y disponibilidad.</p>
                            </div>
                        </div>
                        <span class="absolute bottom-3 right-3 text-amber-500 opacity-0 group-hover:opacity-100 transition">
                            <i class="fa-solid fa-arrow-right"></i>
                        </span>
                    </a>

                    <a href="clientes.jsp" class="group relative overflow-hidden rounded-xl border border-gray-200 bg-gradient-to-br from-blue-50 to-white p-5 hover:shadow-card-hover hover:border-blue-500 transition">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-lg bg-blue-600 text-white flex items-center justify-center shadow-md group-hover:scale-105 transition">
                                <i class="fa-solid fa-users text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-semibold text-gray-800">Clientes</h3>
                                <p class="text-sm text-gray-500 mt-0.5">Registro y búsqueda de usuarios del club.</p>
                            </div>
                        </div>
                        <span class="absolute bottom-3 right-3 text-blue-600 opacity-0 group-hover:opacity-100 transition">
                            <i class="fa-solid fa-arrow-right"></i>
                        </span>
                    </a>

                    <a href="finanzas.jsp" class="group relative overflow-hidden rounded-xl border border-gray-200 bg-gradient-to-br from-emerald-50 to-white p-5 hover:shadow-card-hover hover:border-emerald-500 transition">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-lg bg-emerald-600 text-white flex items-center justify-center shadow-md group-hover:scale-105 transition">
                                <i class="fa-solid fa-sack-dollar text-xl"></i>
                            </div>
                            <div>
                                <h3 class="font-semibold text-gray-800">Finanzas</h3>
                                <p class="text-sm text-gray-500 mt-0.5">Ingresos, tendencias y top clientes.</p>
                            </div>
                        </div>
                        <span class="absolute bottom-3 right-3 text-emerald-600 opacity-0 group-hover:opacity-100 transition">
                            <i class="fa-solid fa-arrow-right"></i>
                        </span>
                    </a>
                </div>
            </section>

            <!-- Próximas reservas -->
            <section class="bg-white rounded-xl shadow-card p-6">
                <div class="flex items-center justify-between mb-5">
                    <h2 class="text-lg font-semibold text-gray-800">
                        <i class="fa-regular fa-clock text-bombonera-700 mr-2"></i> Próximas reservas
                    </h2>
                    <a href="reservas.jsp" class="text-xs font-medium text-bombonera-700 hover:underline">Ver todas</a>
                </div>

                <% if (proximas.isEmpty()) { %>
                    <div class="text-center py-8 text-gray-400">
                        <i class="fa-regular fa-calendar-xmark text-3xl mb-2"></i>
                        <p class="text-sm">No hay reservas próximas.</p>
                    </div>
                <% } else { %>
                    <ul class="space-y-3">
                    <% for (GestionarFinanzas.FilaProximaReserva p : proximas) {
                        String badgeClass = "Confirmada".equals(p.estado)
                            ? "bg-emerald-100 text-emerald-700"
                            : "bg-amber-100 text-amber-700";
                        String badgeIcon = "Confirmada".equals(p.estado) ? "fa-check" : "fa-hourglass-half";
                    %>
                        <li class="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100">
                            <div class="w-10 h-10 rounded-lg bg-bombonera-50 text-bombonera-700 flex flex-col items-center justify-center shrink-0">
                                <span class="text-[10px] uppercase leading-none"><%= new java.text.SimpleDateFormat("MMM", new java.util.Locale("es")).format(p.fecha) %></span>
                                <span class="text-base font-bold leading-none"><%= new java.text.SimpleDateFormat("d").format(p.fecha) %></span>
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-semibold text-gray-800 truncate"><i class="fa-solid fa-user text-gray-400 mr-1"></i><%= p.cliente %></p>
                                <p class="text-xs text-gray-500 truncate"><i class="fa-solid fa-flag-checkered mr-1"></i><%= p.cancha %></p>
                                <p class="text-xs text-gray-400 mt-0.5"><i class="fa-regular fa-clock mr-1"></i><%= p.horaInicio %> - <%= p.horaFin %></p>
                            </div>
                            <span class="inline-flex items-center gap-1 px-2 py-0.5 text-[11px] font-medium rounded-full <%= badgeClass %>">
                                <i class="fa-solid <%= badgeIcon %>"></i> <%= p.estado %>
                            </span>
                        </li>
                    <% } %>
                    </ul>
                <% } %>
            </section>
        </div>
    </main>

    <%@ include file="/WEB-INF/includes/footer.jspf" %>
</body>
</html>
