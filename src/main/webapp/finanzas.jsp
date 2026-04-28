<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.GestionarFinanzas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeNav", "finanzas");

    GestionarFinanzas gf = new GestionarFinanzas();

    double ingresosTotales = 0d, ingresosMes = 0d;
    int totalReservas = 0, reservasHoy = 0, reservasPendientes = 0, reservasConfirmadas = 0, totalClientes = 0, totalCanchas = 0;
    Map<String, Double> porMes = java.util.Collections.emptyMap();
    List<GestionarFinanzas.FilaCancha>  porCancha   = java.util.Collections.emptyList();
    List<GestionarFinanzas.FilaCliente> topClientes = java.util.Collections.emptyList();

    try {
        ingresosTotales     = gf.ingresosTotales();
        ingresosMes         = gf.ingresosMesActual();
        totalReservas       = gf.totalReservas();
        reservasHoy         = gf.reservasHoy();
        reservasPendientes  = gf.reservasPendientes();
        reservasConfirmadas = gf.reservasConfirmadas();
        totalClientes       = gf.totalClientes();
        totalCanchas        = gf.totalCanchas();
        porMes              = gf.ingresosPorMes(6);
        porCancha           = gf.ingresosPorCancha();
        topClientes         = gf.rankingClientes(10);
    } catch (Exception e) {
        // Degrada a valores vacíos, no rompe la página.
    }

    double ticketPromedio = totalReservas > 0 ? ingresosTotales / totalReservas : 0d;

    // Serializar datos del gráfico a JSON en arrays de JS
    StringBuilder labels = new StringBuilder("[");
    StringBuilder datos  = new StringBuilder("[");
    boolean primero = true;
    String[] meses = {"ene","feb","mar","abr","may","jun","jul","ago","sep","oct","nov","dic"};
    for (Map.Entry<String, Double> e : porMes.entrySet()) {
        if (!primero) { labels.append(","); datos.append(","); }
        String clave = e.getKey(); // YYYY-MM
        String anio = clave.substring(0,4);
        int m = Integer.parseInt(clave.substring(5,7));
        labels.append("\"").append(meses[m-1]).append(" ").append(anio.substring(2)).append("\"");
        datos.append(String.format(java.util.Locale.US, "%.2f", e.getValue()));
        primero = false;
    }
    labels.append("]");
    datos.append("]");

    // Datos para gráfico por cancha (barras horizontales)
    StringBuilder canchaLabels = new StringBuilder("[");
    StringBuilder canchaDatos  = new StringBuilder("[");
    boolean pr = true;
    for (GestionarFinanzas.FilaCancha f : porCancha) {
        if (!pr) { canchaLabels.append(","); canchaDatos.append(","); }
        canchaLabels.append("\"").append(f.nombre.replace("\"","\\\"")).append("\"");
        canchaDatos.append(String.format(java.util.Locale.US, "%.2f", f.total));
        pr = false;
    }
    canchaLabels.append("]");
    canchaDatos.append("]");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Finanzas - La Bombonera</title>
    <%@ include file="/WEB-INF/includes/head.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body class="min-h-screen flex flex-col">

    <%@ include file="/WEB-INF/includes/nav.jspf" %>

    <main class="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8 fade-in">

        <nav class="text-xs text-gray-500 mb-3">
            <a href="principal.jsp" class="hover:text-bombonera-700"><i class="fa-solid fa-house"></i> Inicio</a>
            <span class="mx-1.5 text-gray-300">/</span>
            <span class="text-gray-700 font-medium">Finanzas</span>
        </nav>

        <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-3 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-sack-dollar text-emerald-600"></i> Dashboard financiero
                </h1>
                <p class="text-gray-500 text-sm">Análisis de ingresos, reservas y desempeño por cancha y cliente.</p>
            </div>
            <div class="flex gap-2">
                <a href="reservas.jsp" class="inline-flex items-center gap-2 px-4 py-2.5 bg-bombonera-700 hover:bg-bombonera-800 text-white text-sm font-semibold rounded-lg shadow-md">
                    <i class="fa-solid fa-calendar-check"></i> Ir a reservas
                </a>
            </div>
        </div>

        <!-- KPIs -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div class="bg-gradient-to-br from-emerald-600 to-emerald-500 text-white rounded-xl shadow-card p-5">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium uppercase text-emerald-100">Ingresos totales</p>
                        <p class="text-2xl font-bold mt-1">$<%= String.format("%,.0f", ingresosTotales) %></p>
                    </div>
                    <i class="fa-solid fa-sack-dollar text-3xl text-emerald-100"></i>
                </div>
                <p class="text-xs text-emerald-100 mt-2">Acumulado histórico</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-bombonera-600">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Ingresos del mes</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1">$<%= String.format("%,.0f", ingresosMes) %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-bombonera-100 flex items-center justify-center">
                        <i class="fa-solid fa-chart-line text-bombonera-700 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2"><%= reservasHoy %> reservas hoy</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-blue-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Ticket promedio</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1">$<%= String.format("%,.0f", ticketPromedio) %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                        <i class="fa-solid fa-receipt text-blue-600 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2">por reserva</p>
            </div>

            <div class="bg-white rounded-xl shadow-card p-5 border-l-4 border-amber-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-medium text-gray-500 uppercase">Total reservas</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1"><%= totalReservas %></p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-amber-100 flex items-center justify-center">
                        <i class="fa-solid fa-calendar-check text-amber-600 text-xl"></i>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-2"><%= reservasConfirmadas %> confirmadas · <%= reservasPendientes %> pendientes</p>
            </div>
        </div>

        <!-- Mini-KPI secundarios -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div class="bg-white rounded-xl shadow-card p-4 flex items-center gap-3">
                <span class="w-10 h-10 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center"><i class="fa-solid fa-users"></i></span>
                <div><p class="text-xs text-gray-500">Clientes</p><p class="font-bold text-gray-800"><%= totalClientes %></p></div>
            </div>
            <div class="bg-white rounded-xl shadow-card p-4 flex items-center gap-3">
                <span class="w-10 h-10 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center"><i class="fa-solid fa-flag-checkered"></i></span>
                <div><p class="text-xs text-gray-500">Canchas</p><p class="font-bold text-gray-800"><%= totalCanchas %></p></div>
            </div>
            <div class="bg-white rounded-xl shadow-card p-4 flex items-center gap-3">
                <span class="w-10 h-10 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center"><i class="fa-solid fa-check"></i></span>
                <div><p class="text-xs text-gray-500">Confirmadas</p><p class="font-bold text-gray-800"><%= reservasConfirmadas %></p></div>
            </div>
            <div class="bg-white rounded-xl shadow-card p-4 flex items-center gap-3">
                <span class="w-10 h-10 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center"><i class="fa-solid fa-hourglass-half"></i></span>
                <div><p class="text-xs text-gray-500">Pendientes</p><p class="font-bold text-gray-800"><%= reservasPendientes %></p></div>
            </div>
        </div>

        <!-- Gráficos -->
        <div class="grid lg:grid-cols-3 gap-6 mb-6">
            <section class="lg:col-span-2 bg-white rounded-xl shadow-card p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-lg font-semibold text-gray-800"><i class="fa-solid fa-chart-line text-bombonera-700 mr-2"></i>Ingresos (últimos 6 meses)</h2>
                    <span class="text-xs text-gray-400">valores en pesos</span>
                </div>
                <div class="h-64"><canvas id="chartIngresos"></canvas></div>
            </section>

            <section class="bg-white rounded-xl shadow-card p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4"><i class="fa-solid fa-chart-pie text-bombonera-700 mr-2"></i>Estado reservas</h2>
                <div class="h-64 flex items-center justify-center"><canvas id="chartEstados"></canvas></div>
            </section>
        </div>

        <div class="grid lg:grid-cols-2 gap-6">

            <!-- Ingresos por cancha -->
            <section class="bg-white rounded-xl shadow-card p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4"><i class="fa-solid fa-flag-checkered text-amber-500 mr-2"></i>Ingresos por cancha</h2>
                <div class="h-64 mb-5"><canvas id="chartCanchas"></canvas></div>
                <div class="overflow-x-auto -mx-6">
                    <table class="min-w-full text-sm">
                        <thead class="bg-gray-50 text-gray-600 text-xs uppercase">
                            <tr>
                                <th class="px-5 py-2 text-left">Cancha</th>
                                <th class="px-5 py-2 text-left">Tipo</th>
                                <th class="px-5 py-2 text-right">Reservas</th>
                                <th class="px-5 py-2 text-right">Total</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <% if (porCancha.isEmpty()) { %>
                                <tr><td colspan="4" class="text-center py-6 text-gray-400">Sin datos</td></tr>
                            <% } else for (GestionarFinanzas.FilaCancha f : porCancha) { %>
                                <tr>
                                    <td class="px-5 py-2 font-medium text-gray-800"><%= f.nombre %></td>
                                    <td class="px-5 py-2 text-gray-600"><%= f.tipo %></td>
                                    <td class="px-5 py-2 text-right text-gray-700"><%= f.reservas %></td>
                                    <td class="px-5 py-2 text-right font-semibold text-emerald-700">$<%= String.format("%,.0f", f.total) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Top clientes -->
            <section class="bg-white rounded-xl shadow-card p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4"><i class="fa-solid fa-trophy text-amber-500 mr-2"></i>Top clientes</h2>
                <% if (topClientes.isEmpty()) { %>
                    <div class="text-center py-10 text-gray-400">
                        <i class="fa-regular fa-user text-3xl mb-2"></i>
                        <p>Aún no hay reservas registradas.</p>
                    </div>
                <% } else { %>
                    <ol class="space-y-3">
                    <%
                        int pos = 1;
                        for (GestionarFinanzas.FilaCliente c : topClientes) {
                            String medal = "bg-gray-100 text-gray-600";
                            String medalIcon = "fa-hashtag";
                            if (pos == 1) { medal = "bg-amber-100 text-amber-700"; medalIcon = "fa-crown"; }
                            else if (pos == 2) { medal = "bg-gray-200 text-gray-700"; medalIcon = "fa-medal"; }
                            else if (pos == 3) { medal = "bg-orange-100 text-orange-700"; medalIcon = "fa-award"; }
                    %>
                        <li class="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 border border-gray-100">
                            <span class="w-9 h-9 rounded-full <%= medal %> flex items-center justify-center font-bold text-sm">
                                <%= pos <= 3 ? "<i class=\"fa-solid " + medalIcon + "\"></i>" : String.valueOf(pos) %>
                            </span>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-semibold text-gray-800 truncate"><%= c.nombre %></p>
                                <p class="text-xs text-gray-500"><%= c.reservas %> reserva<%= c.reservas == 1 ? "" : "s" %></p>
                            </div>
                            <span class="text-sm font-bold text-emerald-700">$<%= String.format("%,.0f", c.total) %></span>
                        </li>
                    <%      pos++;
                        }
                    %>
                    </ol>
                <% } %>
            </section>
        </div>
    </main>

    <%@ include file="/WEB-INF/includes/footer.jspf" %>

    <script>
        var formatCOP = new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 });

        // Línea de ingresos por mes
        new Chart(document.getElementById('chartIngresos'), {
            type: 'line',
            data: {
                labels: <%= labels.toString() %>,
                datasets: [{
                    label: 'Ingresos',
                    data: <%= datos.toString() %>,
                    borderColor: '#047857',
                    backgroundColor: 'rgba(5,150,105,0.15)',
                    tension: 0.35,
                    fill: true,
                    pointRadius: 4,
                    pointBackgroundColor: '#047857'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: function (ctx) { return formatCOP.format(ctx.parsed.y); } } }
                },
                scales: {
                    y: { ticks: { callback: function (v) { return '$' + v.toLocaleString('es-CO'); } } }
                }
            }
        });

        // Dona de estados
        new Chart(document.getElementById('chartEstados'), {
            type: 'doughnut',
            data: {
                labels: ['Confirmadas', 'Pendientes'],
                datasets: [{
                    data: [<%= reservasConfirmadas %>, <%= reservasPendientes %>],
                    backgroundColor: ['#059669', '#f59e0b'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // Barras por cancha
        new Chart(document.getElementById('chartCanchas'), {
            type: 'bar',
            data: {
                labels: <%= canchaLabels.toString() %>,
                datasets: [{
                    label: 'Ingresos',
                    data: <%= canchaDatos.toString() %>,
                    backgroundColor: '#f59e0b',
                    borderRadius: 6
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: function (ctx) { return formatCOP.format(ctx.parsed.x); } } }
                },
                scales: {
                    x: { ticks: { callback: function (v) { return '$' + v.toLocaleString('es-CO'); } } }
                }
            }
        });
    </script>
</body>
</html>
