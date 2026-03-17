<%@page import="java.util.List"%>
<%@page import="umariana.reservassintetica.Cancha"%>
<%@page import="umariana.reservassintetica.GestionarCanchas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Canchas</title>
          
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles_cc.css"/> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="icon" type="image/png" href="images/iconoPr.png">
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Gestión de Canchas</h1>
                <div>
                    <a href="principal.jsp" class="btn btn-back">Volver al Inicio</a>
                    <button class="btn btn-new" data-bs-toggle="modal" data-bs-target="#modalAgregarCancha">+ Nueva Cancha</button>
                </div>
            </div>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th style="width: 25%;">Nombre</th>
                        <th style="width: 20%;">Tipo</th>
                        <th style="width: 20%;">Precio/Hora</th>
                        <th style="width: 25%;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int paginaCanchas = 1;
                        int registrosPorPaginaCanchas = 10;
                        if (request.getParameter("paginaCanchas") != null) {
                            paginaCanchas = Integer.parseInt(request.getParameter("paginaCanchas"));
                        }

                        GestionarCanchas gestionarCanchas = new GestionarCanchas();
                        List<Cancha> listaCanchas = gestionarCanchas.listarCanchas(paginaCanchas, registrosPorPaginaCanchas);

                        for (Cancha cancha : listaCanchas) {
                    %>
                    <tr>
                        <td><%= cancha.getNombre()%></td>
                        <td><%= cancha.getTipo()%></td>
                        <td class="price">$<%= String.format("%,.2f", cancha.getPrecio_hora())%></td>
                        <td class="actions">
                            <button class="btnEditar" data-bs-toggle="modal" data-bs-target="#modalEditarCancha<%= cancha.getId_cancha()%>">Editar</button> |
                            <a href="sv_eliminarCancha?id=<%= cancha.getId_cancha()%>" onclick="return confirm('¿Está seguro de eliminar esta cancha?');">Eliminar</a>
                        </td>
                    </tr>

                    <!-- Modal Editar Cancha -->
                <div class="modal fade" id="modalEditarCancha<%= cancha.getId_cancha()%>" tabindex="-1" aria-labelledby="modalEditarCanchaLabel<%= cancha.getId_cancha()%>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="sv_editarCancha" method="post">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalEditarCanchaLabel<%= cancha.getId_cancha()%>">Editar Cancha</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="id_cancha" value="<%= cancha.getId_cancha()%>">

                                    <div class="mb-3">
                                        <label for="nombre<%= cancha.getId_cancha()%>" class="form-label">Nombre</label>
                                        <input type="text" class="form-control" id="nombre<%= cancha.getId_cancha()%>" name="nombre" value="<%= cancha.getNombre()%>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="tipo<%= cancha.getId_cancha()%>" class="form-label">Tipo</label>
                                        <select class="form-select" id="tipo<%= cancha.getId_cancha()%>" name="tipo" required>
                                            <option value="Futbol 5" <%= cancha.getTipo().equals("Futbol 5") ? "selected" : ""%>>Fútbol 5</option>
                                            <option value="Futbol 7" <%= cancha.getTipo().equals("Futbol 7") ? "selected" : ""%>>Fútbol 7</option>
                                            <option value="Futbol 11" <%= cancha.getTipo().equals("Futbol 11") ? "selected" : ""%>>Fútbol 11</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label for="precio<%= cancha.getId_cancha()%>" class="form-label">Precio por Hora</label>
                                        <input type="number" step="0.01" class="form-control" id="precio<%= cancha.getId_cancha()%>" name="precio_hora" value="<%= cancha.getPrecio_hora()%>" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Actualizar</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
                </tbody>
            </table>

            <!-- Paginación -->
            <div class="pagination d-flex justify-content-center align-items-center gap-3 mt-4">
                <% if (paginaCanchas > 1) {%>
                <a href="canchas.jsp?paginaCanchas=<%= paginaCanchas - 1%>" class="btn btn-outline-primary">&laquo; Anterior</a>
                <% }%>
                <span>Página <%= paginaCanchas%></span>
                <% if (listaCanchas.size() == registrosPorPaginaCanchas) {%>
                <a href="canchas.jsp?paginaCanchas=<%= paginaCanchas + 1%>" class="btn btn-outline-primary">Siguiente &raquo;</a>
                <% }%>
            </div>
        </div>

        <!-- Modal Agregar Cancha -->
        <div class="modal fade" id="modalAgregarCancha" tabindex="-1" aria-labelledby="modalAgregarCanchaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="sv_agregarCancha" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalAgregarCanchaLabel">Registrar Nueva Cancha</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre:</label>
                                <input type="text" class="form-control" name="nombre" id="nombre" required>
                            </div>
                            <div class="mb-3">
                                <label for="tipo" class="form-label">Tipo</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="">Seleccione tipo</option>
                                    <option value="Futbol 5">Fútbol 5</option>
                                    <option value="Futbol 7">Fútbol 7</option>
                                    <option value="Futbol 11">Fútbol 11</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="precio_hora" class="form-label">Precio por Hora:</label>
                                <input type="number" step="0.01" class="form-control" name="precio_hora" id="precio_hora" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Registrar</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
