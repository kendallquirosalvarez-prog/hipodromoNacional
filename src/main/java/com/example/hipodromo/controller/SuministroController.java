package com.example.hipodromo.controller;

import com.example.hipodromo.model.Suministro;
import com.example.hipodromo.repository.SuministroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/suministros")
public class SuministroController {

    @Autowired
    private SuministroRepository suministroRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("suministros", suministroRepository.findAll());
        model.addAttribute("suministro", new Suministro());
        return "suministros/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Suministro suministro, RedirectAttributes ra) {
        try {
            suministroRepository.insertarSuministro(
                suministro.getIdSuministro(),
                suministro.getTipo(),
                suministro.getProveedor(),
                suministro.getCantidadDisponible(),
                suministro.getPrecioUnitario()
            );
            ra.addFlashAttribute("mensaje", "Suministro registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/suministros";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("suministro", suministroRepository.findById(id).orElse(new Suministro()));
        model.addAttribute("suministros", suministroRepository.findAll());
        return "suministros/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Suministro suministro, RedirectAttributes ra) {
        try {
            suministroRepository.actualizarSuministro(
                suministro.getIdSuministro(),
                suministro.getCantidadDisponible(),
                suministro.getPrecioUnitario()
            );
            ra.addFlashAttribute("mensaje", "Suministro actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/suministros";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        suministroRepository.eliminarSuministro(id);
        return "redirect:/suministros";
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
