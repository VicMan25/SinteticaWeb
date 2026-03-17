<%@page import="umariana.reservassintetica.GestionarClientes"%>
<%@page import="umariana.reservassintetica.GestionarCanchas"%>
<%@page import="umariana.reservassintetica.Cliente"%>
<%@page import="umariana.reservassintetica.Cancha"%>
<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Reserva"%>
<%@page import="umariana.reservassintetica.GestionarReservas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String busqueda = request.getParameter("busqueda");
    int paginaReservas = 1;
    int registrosPorPaginaReservas = 10;

    if (request.getParameter("paginaReservas") != null) {
        paginaReservas = Integer.parseInt(request.getParameter("paginaReservas"));
    }

    GestionarReservas gestor = new GestionarReservas();
    List<Reserva> misReservas;

    if (busqueda != null && !busqueda.trim().isEmpty()) {
        misReservas = gestor.buscarReservas(busqueda);
    } else {
        misReservas = gestor.listarReservas(paginaReservas, registrosPorPaginaReservas);
    }

    // Para modales de clientes y canchas
    GestionarClientes gestionarClientes = new GestionarClientes();
    List<Cliente> clientes = gestionarClientes.listarClientes(1, 1000);

    GestionarCanchas gestionarCanchas = new GestionarCanchas();
    List<Cancha> canchas = gestionarCanchas.listarCanchas(1, 1000);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Reservas</title>
        <link rel="icon" type="image/png" href="images/iconoPr.png">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles_reserva.css"/>
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    </head>
    <body>

        <% if ("ocupada".equals(request.getParameter("error"))) { %>
        <div class="alert-danger">
            La cancha no está disponible en ese horario. Por favor elige otro.
        </div>
        <% }%>

        <form action="reservas.jsp" method="get" class="barra-busqueda" style="margin-bottom: 20px;">
            <input type="text" name="busqueda" value="<%= (busqueda != null) ? busqueda : ""%>" placeholder="Buscar por cliente o fecha (YYYY-MM-DD)" />
            <button type="submit">Buscar</button>
            <a href="reservas.jsp" class="btn btn-clear">Limpiar</a>
        </form>


        <div class="container">
            <div class="header">
                <h1>Gestión de Reservas</h1>
                <div>
                    <a href="principal.jsp" class="btn btn-back">Volver al Inicio</a>
                    <button class="btn btn-new" onclick="abrirModal()">+ Nueva Reserva</button>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th class="col-cliente">Cliente</th>
                        <th class="col-cancha">Cancha</th>
                        <th class="col-fecha">Fecha</th>
                        <th class="col-hora-inicio">Hora Inicio</th>
                        <th class="col-hora-fin">Hora Fin</th>
                        <th class="col-estado">Estado</th>
                        <th class="col-acciones">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Reserva reserva : misReservas) {
                            String estadoClass = "";
                            switch (reserva.getEstado()) {
                                case "Pendiente":
                                    estadoClass = "status-pending";
                                    break;
                                case "Confirmada":
                                    estadoClass = "status-confirmed";
                                    break;
                            }
                    %>
                    <tr>
                        <td><%= reserva.getNombre_cliente()%></td>
                        <td><%= reserva.getNombre_cancha()%></td>
                        <td><%= reserva.getFecha()%></td>
                        <td><%= reserva.getHora_inicio()%></td>
                        <td><%= reserva.getHora_fin()%></td>
                        <td class="<%= estadoClass%>"><%= reserva.getEstado()%></td>
                        <td class="actions">
                            <button class="btnEditar"
                                    data-id="<%= reserva.getId_reserva()%>"
                                    data-id-cliente="<%= reserva.getId_cliente()%>"
                                    data-id-cancha="<%= reserva.getId_cancha()%>"
                                    data-fecha="<%= reserva.getFecha()%>"
                                    data-hora-inicio="<%= reserva.getHora_inicio()%>"
                                    data-hora-fin="<%= reserva.getHora_fin()%>"
                                    data-estado="<%= reserva.getEstado()%>">
                                Editar
                            </button> |
                            <a href="sv_eliminarReserva?id=<%= reserva.getId_reserva()%>" onclick="return confirm('¿Seguro que deseas eliminar esta reserva?');">Eliminar</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="pagination">
                <% if (paginaReservas > 1) {%>
                <a href="reservas.jsp?paginaReservas=<%= paginaReservas - 1%>">&laquo; Anterior</a>
                <% }%>
                <span>Página <%= paginaReservas%></span>
                <% if (misReservas.size() == registrosPorPaginaReservas && (busqueda == null || busqueda.isEmpty())) {%>
                <a href="reservas.jsp?paginaReservas=<%= paginaReservas + 1%>">Siguiente &raquo;</a>
                <% } %>
            </div>
        </div>

        <!-- Modal de Nueva Reserva -->
        <div id="modalReserva" class="modal-overlay">
            <div class="modal-content">
                <h2>Nueva Reserva</h2>
                <form id="reservaForm" action="sv_agregarReserva" method="POST">
                    <div class="form-group">
                        <label for="cliente">Cliente:</label>
                        <select id="cliente" name="id_cliente" class="js-example-basic-single" required>
                            <option value="">Seleccione un cliente</option>
                            <%

                                for (Cliente cliente : clientes) {
                            %>
                            <option value="<%= cliente.getId_cliente()%>">
                                <%= cliente.getNombre()%> (ID: <%= cliente.getId_cliente()%>)
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="cancha">Cancha:</label>
                        <select id="cancha" name="id_cancha" class="js-example-basic-single" required>
                            <option value="">Seleccione una cancha</option>
                            <%

                                for (Cancha cancha : canchas) {
                            %>
                            <option value="<%= cancha.getId_cancha()%>">
                                <%= cancha.getNombre()%> (ID: <%= cancha.getId_cancha()%>) - <%= cancha.getTipo()%>
                            </option>
                            <% }%>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="fecha">Fecha:</label>
                        <input type="date" name="fecha" id="fecha" required>
                    </div>

                    <div class="form-group time-container">
                        <div class="half-width">
                            <label for="hora_inicio">Hora Inicio:</label>
                            <input type="time" name="hora_inicio" id="hora_fin" required>
                        </div>
                        <div class="half-width">
                            <label for="hora_fin">Hora Fin:</label>
                            <input type="time" name="hora_fin" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select name="estado" required>
                            <option value="Pendiente">Pendiente</option>
                            <option value="Confirmada">Confirmada</option>
                        </select>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-back">Guardar</button>
                        <button type="button" class="btn btn-cancel" onclick="cerrarModal()">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal de Editar Reserva -->
        <div id="modalEditarReserva" class="modal-overlay">
            <div class="modal-content">
                <span id="cerrarModalEditarReserva" class="close">&times;</span> <!-- Agregado para cerrar -->
                <h2>Editar Reserva</h2>
                <form action="sv_editarReserva" method="POST">
                    <input type="hidden" name="id_reserva" id="editar_id_reserva">

                    <div class="form-group">
                        <label for="editar_cliente">Cliente:</label>
                        <select id="editar_cliente" name="id_cliente" class="js-example-basic-singleO" required>
                            <option value="">Seleccione un cliente</option>
                            <% for (Cliente cliente : clientes) {%>
                            <option value="<%= cliente.getId_cliente()%>">
                                <%= cliente.getNombre()%> (ID: <%= cliente.getId_cliente()%>)
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editar_cancha">Cancha:</label>
                        <select id="editar_cancha" name="id_cancha" class="js-example-basic-singleO" required>
                            <option value="">Seleccione una cancha</option>
                            <% for (Cancha cancha : canchas) {%>
                            <option value="<%= cancha.getId_cancha()%>">
                                <%= cancha.getNombre()%> (ID: <%= cancha.getId_cancha()%>) - <%= cancha.getTipo()%>
                            </option>
                            <% }%>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="editar_fecha">Fecha:</label>
                        <input type="date" name="fecha" id="editar_fecha" required>
                    </div>

                    <div class="form-group time-container">
                        <div class="half-width">
                            <label for="editar_hora_inicio">Hora Inicio:</label>
                            <input type="time" name="hora_inicio" id="editar_hora_inicio" required>
                        </div>
                        <div class="half-width">
                            <label for="editar_hora_fin">Hora Fin:</label>
                            <input type="time" name="hora_fin" id="editar_hora_fin" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="editar_estado">Estado:</label>
                        <select name="estado" id="editar_estado" required>
                            <option value="Pendiente">Pendiente</option>
                            <option value="Confirmada">Confirmada</option>
                        </select>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-back">Guardar Cambios</button>
                        <button type="button" id="btnCancelarEditarReserva" class="btn btn-cancel">Cancelar</button> <!-- ID agregado -->
                    </div>
                </form>
            </div>
        </div>


        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script>
                            $(document).ready(function () {
                                $('.js-example-basic-single').select2();
                            });
                            function abrirModal() {
                                document.getElementById('modalReserva').style.display = 'flex';
                            }

                            function cerrarModal() {
                                document.getElementById('modalReserva').style.display = 'none';
                            }

                            $(document).ready(function () {
                                // Inicializar Select2 para los select
                                $('.js-example-basic-single').select2({
                                    placeholder: function () {
                                        $(this).data('placeholder');
                                    },
                                    allowClear: true
                                });
                                // Configurar búsqueda en el select de clientes
                                $('#cliente').select2({
                                    placeholder: "Escriba para buscar cliente...",
                                    minimumInputLength: 2,
                                    language: {
                                        inputTooShort: function () {
                                            return "Ingrese al menos 2 caracteres para buscar";
                                        }
                                    }
                                });
                                // Configurar búsqueda en el select de canchas
                                $('#cancha').select2({
                                    placeholder: "Escriba para buscar cancha...",
                                    minimumInputLength: 1,
                                    language: {
                                        inputTooShort: function () {
                                            return "Ingrese al menos 1 carácter para buscar";
                                        }
                                    }
                                });
                                // Establecer fecha mínima como hoy
                                const today = new Date().toISOString().split('T')[0];
                                document.getElementById('fecha').min = today;
                                // Validar que hora fin sea mayor a hora inicio
                                $('#hora_fin').change(function () {
                                    const horaInicio = $('#hora_inicio').val();
                                    const horaFin = $(this).val();
                                    if (horaInicio && horaFin && horaFin <= horaInicio) {
                                        alert('La hora de fin debe ser posterior a la hora de inicio');
                                        $(this).val('');
                                    }
                                });
                                // Validar formulario antes de enviar
                                $('#reservaForm').submit(function (e) {
                                    if (!$('#cliente').val()) {
                                        alert('Debe seleccionar un cliente');
                                        e.preventDefault();
                                        return false;
                                    }
                                    if (!$('#cancha').val()) {
                                        alert('Debe seleccionar una cancha');
                                        e.preventDefault();
                                        return false;
                                    }
                                    return true;
                                });
                            });

                            // Modal Editar Reserva
                            const modalEditarReserva = document.getElementById("modalEditarReserva");
                            const btnCancelarEditarReserva = document.getElementById("btnCancelarEditarReserva");
                            const spanCerrarEditarReserva = document.getElementById("cerrarModalEditarReserva");

                            document.querySelectorAll('.btnEditar').forEach(btn => {
                                btn.addEventListener('click', () => {
                                    // Cargar datos en el formulario de editar reserva
                                    document.getElementById('editar_id_reserva').value = btn.getAttribute('data-id');
                                    document.getElementById('editar_cliente').value = btn.getAttribute('data-nombre-cliente');
                                    document.getElementById('editar_cancha').value = btn.getAttribute('data-id-cancha');
                                    document.getElementById('editar_fecha').value = btn.getAttribute('data-fecha');
                                    document.getElementById('editar_hora_inicio').value = btn.getAttribute('data-hora-inicio');
                                    document.getElementById('editar_hora_fin').value = btn.getAttribute('data-hora-fin');
                                    document.getElementById('editar_estado').value = btn.getAttribute('data-estado');
                                    // Si usas Select2
                                    $('#editar_cliente').trigger('change');
                                    $('#editar_cancha').trigger('change');
                                    $('#editar_estado').trigger('change');
                                    // Mostrar modal editar
                                    modalEditarReserva.style.display = 'flex';
                                });
                            });

                            btnCancelarEditarReserva.onclick = function () {
                                modalEditarReserva.style.display = "none";
                            };

                            spanCerrarEditarReserva.onclick = function () {
                                modalEditarReserva.style.display = "none";
                            };

                            // Cerrar modal al hacer clic fuera
                            window.onclick = function (event) {
                                if (event.target === modalEditarReserva) {
                                    modalEditarReserva.style.display = "none";
                                }
                            };



        </script>
        <script>
            window.addEventListener('DOMContentLoaded', () => {
                const alert = document.querySelector('.alert-danger');
                if (alert) {
                    setTimeout(() => {
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500); // Remover del DOM después de que se desvanece
                    }, 4000); // Se oculta después de 4 segundos
                }
            });
        </script>

    </body>
</html>
