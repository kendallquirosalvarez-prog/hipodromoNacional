package com.example.hipodromo.controller;

import com.example.hipodromo.model.HistorialVeterinario;
import com.example.hipodromo.repository.HistorialVeterinarioRepository;
import com.example.hipodromo.repository.CaballoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/historial")
public class HistorialVeterinarioController {

    @Autowired
    private HistorialVeterinarioRepository historialRepository;

    @Autowired
    private CaballoRepository caballoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("historiales", historialRepository.findAll());
        model.addAttribute("historial", new HistorialVeterinario());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "historial/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute HistorialVeterinario historial) {
        historialRepository.insertarHistorial(
            historial.getIdRegistro(),
            historial.getIdCaballo(),
            historial.getDiagnostico(),
            historial.getTratamiento(),
            historial.getFechaRevision(),
            historial.getFechaVencimientoCertificacion(),
            historial.getVeterinarioResponsable()
        );
        return "redirect:/historial";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("historial", historialRepository.findById(id).orElseThrow());
        model.addAttribute("historiales", historialRepository.findAll());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "historial/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute HistorialVeterinario historial) {
        historialRepository.actualizarHistorial(
            historial.getIdRegistro(),
            historial.getDiagnostico(),
            historial.getTratamiento(),
            historial.getFechaVencimientoCertificacion()
        );
        return "redirect:/historial";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        historialRepository.eliminarHistorial(id);
        return "redirect:/historial";
    }
}