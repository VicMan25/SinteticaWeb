package umariana.reservassintetica;

import java.sql.Date;
import java.sql.Time;

public class Reserva {
    private int id_reserva;
    private int id_cliente;  // Relación con Cliente
    private int id_cancha;   // Relación con Cancha
    private Date fecha;
    private Time hora_inicio;
    private Time hora_fin;
    private String estado;
    private String nombre_cliente; // Para mostrar en listados
    private String nombre_cancha;  // Para mostrar en listados

    // Constructor vacío
    public Reserva() {
    }

    // Constructor completo
    public Reserva(int id_reserva, int id_cliente, int id_cancha, Date fecha, 
                  Time hora_inicio, Time hora_fin, String estado) {
        this.id_reserva = id_reserva;
        this.id_cliente = id_cliente;
        this.id_cancha = id_cancha;
        this.fecha = fecha;
        this.hora_inicio = hora_inicio;
        this.hora_fin = hora_fin;
        this.estado = estado;
    }

    // Getters y Setters
    public int getId_reserva() {
        return id_reserva;
    }

    public void setId_reserva(int id_reserva) {
        this.id_reserva = id_reserva;
    }

    public int getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(int id_cliente) {
        this.id_cliente = id_cliente;
    }

    public int getId_cancha() {
        return id_cancha;
    }

    public void setId_cancha(int id_cancha) {
        this.id_cancha = id_cancha;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Time getHora_inicio() {
        return hora_inicio;
    }

    public void setHora_inicio(Time hora_inicio) {
        this.hora_inicio = hora_inicio;
    }

    public Time getHora_fin() {
        return hora_fin;
    }

    public void setHora_fin(Time hora_fin) {
        this.hora_fin = hora_fin;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombre_cliente() {
        return nombre_cliente;
    }

    public void setNombre_cliente(String nombre_cliente) {
        this.nombre_cliente = nombre_cliente;
    }

    public String getNombre_cancha() {
        return nombre_cancha;
    }

    public void setNombre_cancha(String nombre_cancha) {
        this.nombre_cancha = nombre_cancha;
    }
}