package com.example.hipodromo.controller;

import com.example.hipodromo.model.Evento;
import com.example.hipodromo.repository.EventoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.math.BigDecimal;

@Controller
@RequestMapping("/eventos")
public class EventoController {

    @Autowired
    private EventoRepository eventoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("eventos", eventoRepository.findAll());
        model.addAttribute("evento", new Evento());
        return "eventos/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Evento evento, RedirectAttributes ra) {
        try {
            eventoRepository.insertarEvento(
                evento.getIdEvento(),
                evento.getNombre(),
                evento.getFecha(),
                evento.getTipoCarrera(),
                evento.getDistancia(),
                evento.getPremioTotal(),
                evento.getEstado()
            );
            ra.addFlashAttribute("mensaje", "Evento registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/eventos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("evento", eventoRepository.findById(id).orElseThrow());
        model.addAttribute("eventos", eventoRepository.findAll());
        return "eventos/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Evento evento, RedirectAttributes ra) {
        try {
            eventoRepository.actualizarEvento(
                evento.getIdEvento(),
                evento.getFecha(),
                evento.getPremioTotal(),
                evento.getEstado()
            );
            ra.addFlashAttribute("mensaje", "Evento actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/eventos";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id, RedirectAttributes ra) {
        try {
            eventoRepository.eliminarEvento(id);
            ra.addFlashAttribute("mensaje", "Evento eliminado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al eliminar: " + extraerError(e));
        }
        return "redirect:/eventos";
    }

    @PostMapping("/finalizar")
    public String finalizar(
            @RequestParam String idEvento,
            @RequestParam(defaultValue = "50000") BigDecimal precio,
            RedirectAttributes ra) {
        try {
            eventoRepository.finalizarEvento(idEvento, precio);
            ra.addFlashAttribute("mensaje",
                "Evento " + idEvento + " finalizado. Facturas generadas automáticamente para todos los propietarios inscritos.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al finalizar: " + extraerError(e));
        }
        return "redirect:/eventos";
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