package com.example.hipodromo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hipodromo.model.Establo;
import com.example.hipodromo.repository.EstabloRepository;

@Controller
@RequestMapping("/establos")
public class EstabloController {

    @Autowired
    private EstabloRepository establoRepository;

    @Autowired
    private JpaRepository<com.example.hipodromo.model.Barrio, Integer> barrioRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("establos", establoRepository.findAll());
        model.addAttribute("establo", new Establo());
        model.addAttribute("barrios", barrioRepository.findAll());
        return "establos/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Establo establo, RedirectAttributes ra) {
        try {
            establoRepository.insertarEstablo(
                establo.getIdEstablo(),
                establo.getCapacidad(),
                establo.getEstado(),
                establo.getIdBarrio()
            );
            ra.addFlashAttribute("mensaje", "Establo registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/establos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("establo", establoRepository.findById(id).orElseThrow());
        model.addAttribute("establos", establoRepository.findAll());
        model.addAttribute("barrios", barrioRepository.findAll());
        return "establos/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Establo establo, RedirectAttributes ra) {
        try {
            establoRepository.actualizarEstablo(
                establo.getIdEstablo(),
                establo.getCapacidad(),
                establo.getEstado(),
                establo.getIdBarrio()
            );
            ra.addFlashAttribute("mensaje", "Establo actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/establos";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        establoRepository.eliminarEstablo(id);
        return "redirect:/establos";
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