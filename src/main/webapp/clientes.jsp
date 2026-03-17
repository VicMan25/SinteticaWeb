<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Cliente"%>
<%@page import="umariana.reservassintetica.GestionarClientes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Clientes</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles_cc.css"/>
        <link rel="icon" type="image/png" href="images/iconoPr.png">
    </head>
    <body>

        <div class="container">
            <div class="header">
                <h1>Gestión de Clientes</h1>
                <div>
                    <a href="principal.jsp" class="btn btn-back">Volver al Inicio</a>
                    <!-- Botón para abrir modal Agregar -->
                    <button id="btnNuevoCliente" class="btn btn-new">+ Nuevo Cliente</button>
                </div>
            </div>

            <!-- Barra de búsqueda por nombre -->
            <form method="get" action="clientes.jsp" class="barra-busqueda" style="margin-bottom: 20px;">
                <input type="text" name="buscarNombre" placeholder="Buscar por nombre..." 
                       value="<%= request.getParameter("buscarNombre") != null ? request.getParameter("buscarNombre") : ""%>" />
                <button type="submit" class="btn btn-search">Buscar</button>
                <!-- Opcional: un botón para limpiar la búsqueda -->
                <a href="clientes.jsp" class="btn btn-clear">Limpiar</a>
            </form>

            <table>
                <thead>
                    <tr>
                        <th class="col-nombre">Nombre</th>
                        <th class="col-telefono">Teléfono</th>
                        <th class="col-email">Email</th>
                        <th class="col-acciones">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int paginaClientes = 1;
                        int registrosPorPaginaClientes = 10;

                        if (request.getParameter("paginaClientes") != null) {
                            paginaClientes = Integer.parseInt(request.getParameter("paginaClientes"));
                        }

                        String buscarNombre = request.getParameter("buscarNombre");

                        GestionarClientes gestionarClientes = new GestionarClientes();
                        List<Cliente> listaClientes;

                        if (buscarNombre != null && !buscarNombre.trim().isEmpty()) {
                            listaClientes = gestionarClientes.listarClientesPorNombre(buscarNombre.trim(), paginaClientes, registrosPorPaginaClientes);
                        } else {
                            listaClientes = gestionarClientes.listarClientes(paginaClientes, registrosPorPaginaClientes);
                        }

                        if (listaClientes != null && !listaClientes.isEmpty()) {
                            for (Cliente cliente : listaClientes) {
                    %>
                    <tr>
                        <td><%= cliente.getNombre()%></td>
                        <td><%= cliente.getTelefono()%></td>
                        <td><%= cliente.getEmail()%></td>
                        <td class="actions">
                            <button class="btn btnEditar" 
                                    data-id="<%= cliente.getId_cliente()%>" 
                                    data-nombre="<%= cliente.getNombre()%>" 
                                    data-telefono="<%= cliente.getTelefono()%>" 
                                    data-email="<%= cliente.getEmail()%>">
                                Editar
                            </button> |
                            <a href="sv_eliminarCliente?id=<%= cliente.getId_cliente()%>" onclick="return confirm('¿Seguro que deseas eliminar este cliente?');">Eliminar</a>
                        </td>
                    </tr>
                    <%      }
                    } else {
                    %>
                    <tr><td colspan="5">No hay clientes para mostrar</td></tr>
                    <% } %>
                </tbody>
            </table>

            <!-- Paginación -->
            <div class="pagination">
                <% if (paginaClientes > 1) {%>
                <a href="clientes.jsp?paginaClientes=<%= paginaClientes - 1%><%= buscarNombre != null && !buscarNombre.trim().isEmpty() ? "&buscarNombre=" + buscarNombre : ""%>">&laquo; Anterior</a>
                <% }%>

                <span>Página <%= paginaClientes%></span>

                <% if (listaClientes.size() == registrosPorPaginaClientes) {%>
                <a href="clientes.jsp?paginaClientes=<%= paginaClientes + 1%><%= buscarNombre != null && !buscarNombre.trim().isEmpty() ? "&buscarNombre=" + buscarNombre : ""%>">Siguiente &raquo;</a>
                <% }%>
            </div>
        </div>

        <!-- Modal para agregar cliente -->
        <div id="modalAgregarCliente" class="modal">
            <div class="modal-content">
                <span id="cerrarModal" class="close">&times;</span>
                <h2>Registrar Nuevo Cliente</h2>
                <form action="sv_agregarCliente" method="POST">
                    <label for="nombres">Nombre Completo:</label><br>
                    <input type="text" id="nombres" name="nombres" required><br><br>

                    <label for="telefono">Teléfono:</label><br>
                    <input type="tel" id="telefono" name="telefono" required><br><br>

                    <label for="email">Email:</label><br>
                    <input type="email" id="email" name="email" required><br><br>

                    <button type="submit" class="btn btn-primary">Guardar Cliente</button>
                    <button type="button" id="btnCancelar" class="btn btn-secondary">Cancelar</button>
                </form>
            </div>
        </div>

        <!-- Modal para editar cliente -->
        <div id="modalEditarCliente" class="modal">
            <div class="modal-content">
                <span id="cerrarModalEditar" class="close">&times;</span>
                <h2>Editar Cliente</h2>
                <form action="sv_editarCliente" method="post">
                    <input type="hidden" name="id_cliente" id="editar_id_cliente">

                    <label for="editar_nombre">Nombre:</label><br>
                    <input type="text" id="editar_nombre" name="nombre" required><br><br>

                    <label for="editar_telefono">Teléfono:</label><br>
                    <input type="text" id="editar_telefono" name="telefono" required><br><br>

                    <label for="editar_email">Email:</label><br>
                    <input type="email" id="editar_email" name="email" required><br><br>

                    <button type="submit" class="btn btn-primary">Actualizar</button>
                    <button type="button" id="btnCancelarEditar" class="btn btn-secondary">Cancelar</button>
                </form>
            </div>
        </div>

        <script>
            // Modal Agregar Cliente
            const modalAgregar = document.getElementById("modalAgregarCliente");
            const btnNuevo = document.getElementById("btnNuevoCliente");
            const spanCerrarAgregar = document.getElementById("cerrarModal");
            const btnCancelarAgregar = document.getElementById("btnCancelar");

            btnNuevo.onclick = function () {
                modalAgregar.style.display = "block";
            }

            spanCerrarAgregar.onclick = function () {
                modalAgregar.style.display = "none";
            }

            btnCancelarAgregar.onclick = function () {
                modalAgregar.style.display = "none";
            }

            // Modal Editar Cliente
            const modalEditar = document.getElementById("modalEditarCliente");
            const btnCancelarEditar = document.getElementById("btnCancelarEditar");
            const spanCerrarEditar = document.getElementById("cerrarModalEditar");

            document.querySelectorAll('.btnEditar').forEach(btn => {
                btn.addEventListener('click', () => {
                    // Cargar datos en el formulario de editar
                    document.getElementById('editar_id_cliente').value = btn.getAttribute('data-id');
                    document.getElementById('editar_nombre').value = btn.getAttribute('data-nombre');
                    document.getElementById('editar_telefono').value = btn.getAttribute('data-telefono');
                    document.getElementById('editar_email').value = btn.getAttribute('data-email');

                    // Mostrar modal editar
                    modalEditar.style.display = 'block';
                });
            });

            btnCancelarEditar.onclick = function () {
                modalEditar.style.display = "none";
            };

            spanCerrarEditar.onclick = function () {
                modalEditar.style.display = "none";
            };

            // Cerrar modales al hacer clic fuera
            window.onclick = function (event) {
                if (event.target == modalAgregar) {
                    modalAgregar.style.display = "none";
                }
                if (event.target == modalEditar) {
                    modalEditar.style.display = "none";
                }
            }
        </script>
    </body>
</html>
