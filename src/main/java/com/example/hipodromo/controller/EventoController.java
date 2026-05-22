package com.example.hipodromo.controller;

import com.example.hipodromo.model.Evento;
import com.example.hipodromo.repository.EventoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String guardar(@ModelAttribute Evento evento) {
        eventoRepository.insertarEvento(
            evento.getIdEvento(),
            evento.getNombre(),
            evento.getFecha(),
            evento.getTipoCarrera(),
            evento.getDistancia(),
            evento.getPremioTotal(),
            evento.getEstado()
        );
        return "redirect:/eventos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("evento", eventoRepository.findById(id).orElseThrow());
        model.addAttribute("eventos", eventoRepository.findAll());
        return "eventos/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Evento evento) {
        eventoRepository.actualizarEvento(
            evento.getIdEvento(),
            evento.getFecha(),
            evento.getPremioTotal(),
            evento.getEstado()
        );
        return "redirect:/eventos";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        eventoRepository.eliminarEvento(id);
        return "redirect:/eventos";
    }
}