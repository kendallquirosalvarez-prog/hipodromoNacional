package com.example.hipodromo.controller;

import com.example.hipodromo.model.Suministro;
import com.example.hipodromo.repository.SuministroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String guardar(@ModelAttribute Suministro suministro) {
        suministroRepository.insertarSuministro(
            suministro.getIdSuministro(),
            suministro.getTipo(),
            suministro.getProveedor(),
            suministro.getCantidadDisponible(),
            suministro.getPrecioUnitario()
        );
        return "redirect:/suministros";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("suministro", suministroRepository.findById(id).orElse(new Suministro()));
        model.addAttribute("suministros", suministroRepository.findAll());
        return "suministros/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Suministro suministro) {
        suministroRepository.actualizarSuministro(
            suministro.getIdSuministro(),
            suministro.getCantidadDisponible(),
            suministro.getPrecioUnitario()
        );
        return "redirect:/suministros";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        suministroRepository.eliminarSuministro(id);
        return "redirect:/suministros";
    }
}
