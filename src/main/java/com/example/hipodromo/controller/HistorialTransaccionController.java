package com.example.hipodromo.controller;

import com.example.hipodromo.model.HistorialTransaccion;
import com.example.hipodromo.repository.HistorialTransaccionRepository;
import com.example.hipodromo.repository.FacturaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/transacciones")
public class HistorialTransaccionController {

    @Autowired
    private HistorialTransaccionRepository transaccionRepository;

    @Autowired
    private FacturaRepository facturaRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("transacciones", transaccionRepository.findAll());
        model.addAttribute("transaccion", new HistorialTransaccion());
        model.addAttribute("facturas", facturaRepository.findAll());
        return "transacciones/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute HistorialTransaccion transaccion, RedirectAttributes ra) {
        try {
            transaccionRepository.insertarTransaccion(
                transaccion.getIdFactura(),
                transaccion.getMonto(),
                transaccion.getMetodoPago(),
                transaccion.getFechaPago()
            );
            ra.addFlashAttribute("mensaje", "Transacción registrada correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/transacciones";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        transaccionRepository.eliminarTransaccion(id);
        return "redirect:/transacciones";
    }

    private static String extraerError(Exception e) {
        Throwable t = e;
        while (t.getCause() != null) t = t.getCause();
        String msg = t.getMessage();
        if (msg == null) return "Error inesperado al procesar la solicitud.";
        if (msg.startsWith("ERROR: ")) msg = msg.substring(7);
        return msg;
    }
}
