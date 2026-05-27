package com.example.hipodromo.controller;

import com.example.hipodromo.model.AlertaVeterinaria;
import com.example.hipodromo.repository.AlertaVeterinariaRepository;
import com.example.hipodromo.repository.CaballoRepository;
import com.example.hipodromo.repository.PropietarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/alertas")
public class AlertaVeterinariaController {

    @Autowired
    private AlertaVeterinariaRepository alertaRepository;

    @Autowired
    private CaballoRepository caballoRepository;

    @Autowired
    private PropietarioRepository propietarioRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("alertas", alertaRepository.findAll());
        model.addAttribute("alerta", new AlertaVeterinaria());
        model.addAttribute("caballos", caballoRepository.findAll());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        return "alertas/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute AlertaVeterinaria alerta, RedirectAttributes ra) {
        try {
            alertaRepository.insertarAlerta(
                alerta.getIdCaballo(),
                alerta.getIdPropietario(),
                alerta.getMensaje()
            );
            ra.addFlashAttribute("mensaje", "Alerta registrada correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/alertas";
    }

    @GetMapping("/marcar-leida/{id}")
    public String marcarLeida(@PathVariable Long id) {
        alertaRepository.marcarLeida(id);
        return "redirect:/alertas";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        alertaRepository.eliminarAlerta(id);
        return "redirect:/alertas";
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
