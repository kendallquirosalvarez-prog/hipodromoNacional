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

import com.example.hipodromo.model.Propietario;
import com.example.hipodromo.repository.PropietarioRepository;

@Controller
@RequestMapping("/propietarios")
public class PropietarioController {

    @Autowired
    private PropietarioRepository propietarioRepository;

    @Autowired
    private JpaRepository<com.example.hipodromo.model.Barrio, Integer> barrioRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("propietario", new Propietario());
        model.addAttribute("barrios", barrioRepository.findAll());
        return "propietarios/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Propietario propietario) {
        propietarioRepository.insertarPropietario(
            propietario.getIdPropietario(),
            propietario.getNombre(),
            propietario.getApellidos(),
            propietario.getIdBarrio()
        );
        return "redirect:/propietarios";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("propietario", propietarioRepository.findById(id).orElseThrow());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("barrios", barrioRepository.findAll());
        return "propietarios/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Propietario propietario) {
        propietarioRepository.actualizarPropietario(
            propietario.getIdPropietario(),
            propietario.getNombre(),
            propietario.getApellidos(),
            propietario.getIdBarrio()
        );
        return "redirect:/propietarios";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        propietarioRepository.eliminarPropietario(id);
        return "redirect:/propietarios";
    }
}