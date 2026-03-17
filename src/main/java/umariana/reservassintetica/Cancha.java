package umariana.reservassintetica;

public class Cancha {
    private int id_cancha;
    private String nombre;
    private String tipo;
    private double precio_hora;

    public Cancha() {
    }

    public int getId_cancha() {
        return id_cancha;
    }

    public void setId_cancha(int id_cancha) {
        this.id_cancha = id_cancha;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public double getPrecio_hora() {
        return precio_hora;
    }

    public void setPrecio_hora(double precio_hora) {
        this.precio_hora = precio_hora;
    }
}