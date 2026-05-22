package com.example.hipodromo.controller;

import com.example.hipodromo.model.Inscripcion;
import com.example.hipodromo.repository.InscripcionRepository;
import com.example.hipodromo.repository.EventoRepository;
import com.example.hipodromo.repository.CaballoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String guardar(@ModelAttribute Inscripcion inscripcion) {
        inscripcionRepository.insertarInscripcion(
            inscripcion.getIdInscripcion(),
            inscripcion.getIdEvento(),
            inscripcion.getIdCaballo(),
            inscripcion.getFechaInscripcion(),
            inscripcion.getEstado()
        );
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