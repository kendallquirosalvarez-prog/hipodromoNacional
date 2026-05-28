package cr.ucr.hipodromo.controller;

// Extrae el mensaje raíz de una cadena de excepciones para mostrarlo en la vista
// sin el prefijo "ERROR: " que agrega el driver de PostgreSQL.
public abstract class ControladorBase {

    protected static String extraerError(Exception e) {
        Throwable t = e;
        while (t.getCause() != null) t = t.getCause();
        String msg = t.getMessage();
        if (msg == null) return "Error inesperado al procesar la solicitud.";
        if (msg.startsWith("ERROR: ")) msg = msg.substring(7);
        return msg;
    }
}
