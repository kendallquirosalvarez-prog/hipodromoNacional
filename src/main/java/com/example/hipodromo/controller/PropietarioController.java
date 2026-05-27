package com.example.hipodromo.controller;

import com.example.hipodromo.model.Barrio;
import com.example.hipodromo.model.Propietario;
import com.example.hipodromo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/propietarios")
public class PropietarioController {

    @Autowired private PropietarioRepository propietarioRepository;
    @Autowired private ProvinciaRepository   provinciaRepository;
    @Autowired private CantonRepository      cantonRepository;
    @Autowired private DistritoRepository    distritoRepository;
    @Autowired private BarrioRepository      barrioRepository;

    @GetMapping
    public String listar(
            @RequestParam(required = false) Integer fp,   // filtro provincia
            @RequestParam(required = false) Integer fc,   // filtro cantón
            @RequestParam(required = false) Integer fd,   // filtro distrito
            Model model) {

        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("propietario",  new Propietario());
        model.addAttribute("provincias",   provinciaRepository.findAll());
        model.addAttribute("fp", fp);
        model.addAttribute("fc", fc);
        model.addAttribute("fd", fd);

        if (fp != null) {
            model.addAttribute("cantones",  cantonRepository.findByIdProvinciaOrderByNombreCantonAsc(fp));
        } else {
            model.addAttribute("cantones",  Collections.emptyList());
        }

        if (fc != null) {
            model.addAttribute("distritos", distritoRepository.findByIdCantonOrderByNombreDistritoAsc(fc));
        } else {
            model.addAttribute("distritos", Collections.emptyList());
        }

        List<Barrio> barrios;
        if (fd != null) {
            barrios = barrioRepository.findByIdDistritoOrderByNombreBarrioAsc(fd);
        } else if (fc != null) {
            barrios = barrioRepository.findByIdCanton(fc);
        } else if (fp != null) {
            barrios = barrioRepository.findByIdProvincia(fp);
        } else {
            barrios = barrioRepository.findAll();
        }
        model.addAttribute("barrios", barrios);

        return "propietarios/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Propietario propietario, RedirectAttributes ra) {
        try {
            propietarioRepository.insertarPropietario(
                propietario.getIdPropietario(),
                propietario.getNombre(),
                propietario.getApellidos(),
                propietario.getIdBarrio()
            );
            ra.addFlashAttribute("mensaje", "Propietario registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/propietarios";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("propietario",  propietarioRepository.findById(id).orElseThrow());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("provincias",   provinciaRepository.findAll());
        model.addAttribute("cantones",     Collections.emptyList());
        model.addAttribute("distritos",    Collections.emptyList());
        model.addAttribute("barrios",      barrioRepository.findAll());
        return "propietarios/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Propietario propietario, RedirectAttributes ra) {
        try {
            propietarioRepository.actualizarPropietario(
                propietario.getIdPropietario(),
                propietario.getNombre(),
                propietario.getApellidos(),
                propietario.getIdBarrio()
            );
            ra.addFlashAttribute("mensaje", "Propietario actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/propietarios";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id, RedirectAttributes ra) {
        try {
            propietarioRepository.eliminarPropietario(id);
            ra.addFlashAttribute("mensaje", "Propietario eliminado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al eliminar: " + extraerError(e));
        }
        return "redirect:/propietarios";
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
