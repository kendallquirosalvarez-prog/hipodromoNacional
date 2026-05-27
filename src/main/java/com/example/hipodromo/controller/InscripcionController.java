package com.example.hipodromo.controller;

import com.example.hipodromo.model.Inscripcion;
import com.example.hipodromo.repository.InscripcionRepository;
import com.example.hipodromo.repository.EventoRepository;
import com.example.hipodromo.repository.CaballoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/inscripciones")
public class InscripcionController {

    @Autowired
    private InscripcionRepository inscripcionRepository;

    @Autowired
    private EventoRepository eventoRepository;

    @Autowired
    private CaballoRepository caballoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("inscripciones", inscripcionRepository.findAll());
        model.addAttribute("inscripcion", new Inscripcion());
        model.addAttribute("eventos", eventoRepository.findAll());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "inscripciones/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Inscripcion inscripcion, RedirectAttributes ra) {
        try {
            inscripcionRepository.insertarInscripcion(
                inscripcion.getIdInscripcion(),
                inscripcion.getIdEvento(),
                inscripcion.getIdCaballo(),
                inscripcion.getFechaInscripcion(),
                inscripcion.getEstado()
            );
            ra.addFlashAttribute("mensaje", "Inscripción registrada correctamente.");
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.contains("certificación veterinaria")) {
                ra.addFlashAttribute("error",
                    "No se puede inscribir al caballo: no tiene certificación veterinaria vigente. " +
                    "Registre primero un historial veterinario con fecha de vencimiento futura.");
            } else {
                ra.addFlashAttribute("error", "Error al registrar la inscripción: " + msg);
            }
        }
        return "redirect:/inscripciones";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("inscripcion", inscripcionRepository.findById(id).orElseThrow());
        model.addAttribute("inscripciones", inscripcionRepository.findAll());
        model.addAttribute("eventos", eventoRepository.findAll());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "inscripciones/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Inscripcion inscripcion) {
        inscripcionRepository.actualizarInscripcion(
            inscripcion.getIdInscripcion(),
            inscripcion.getEstado(),
            inscripcion.getPosicionFinal(),
            null
        );
        return "redirect:/inscripciones";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        inscripcionRepository.eliminarInscripcion(id);
        return "redirect:/inscripciones";
    }
}