package com.example.hipodromo.controller;

import com.example.hipodromo.model.Caballo;
import com.example.hipodromo.repository.CaballoRepository;
import com.example.hipodromo.repository.PropietarioRepository;
import com.example.hipodromo.repository.EstabloRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Controller
@RequestMapping("/caballos")
public class CaballoController {

    @Autowired
    private CaballoRepository caballoRepository;

    @Autowired
    private PropietarioRepository propietarioRepository;

    @Autowired
    private EstabloRepository establoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("caballos", caballoRepository.findAll());
        model.addAttribute("caballo", new Caballo());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("establos", establoRepository.findAll());
        return "caballos/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Caballo caballo) {
        caballoRepository.insertarCaballo(
            caballo.getIdCaballo(),
            caballo.getNombre(),
            caballo.getFechaNacimiento(),
            caballo.getSexo(),
            caballo.getRaza(),
            caballo.getPeso(),
            caballo.getEstadoSalud(),
            caballo.getIdPropietario(),
            caballo.getIdEstablo()
        );
        return "redirect:/caballos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("caballo", caballoRepository.findById(id).orElse(new Caballo()));
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("establos", establoRepository.findAll());
        return "caballos/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Caballo caballo) {
        // Usa el stored procedure en lugar de save() para respetar las reglas de negocio de la BD
        caballoRepository.actualizarCaballo(
            caballo.getIdCaballo(),
            caballo.getPeso(),
            caballo.getEstadoSalud(),
            caballo.getIdEstablo()
        );
        return "redirect:/caballos";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        caballoRepository.deleteById(id);
        return "redirect:/caballos";
    }

}