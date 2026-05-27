package com.example.hipodromo.controller;

import com.example.hipodromo.model.ResultadoCarrera;
import com.example.hipodromo.repository.ResultadoCarreraRepository;
import com.example.hipodromo.repository.EventoRepository;
import com.example.hipodromo.repository.CaballoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/resultados")
public class ResultadoCarreraController {

    @Autowired
    private ResultadoCarreraRepository resultadoRepository;

    @Autowired
    private EventoRepository eventoRepository;

    @Autowired
    private CaballoRepository caballoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("resultados", resultadoRepository.findAll());
        model.addAttribute("resultado", new ResultadoCarrera());
        model.addAttribute("eventos", eventoRepository.findAll());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "resultados/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute ResultadoCarrera resultado, RedirectAttributes ra) {
        try {
            resultadoRepository.insertarResultado(
                resultado.getIdEvento(),
                resultado.getIdCaballo(),
                resultado.getPosicion(),
                resultado.getTiempo(),
                resultado.getPremioGanado()
            );
            ra.addFlashAttribute("mensaje", "Resultado registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/resultados";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("resultado", resultadoRepository.findById(id).orElse(new ResultadoCarrera()));
        model.addAttribute("resultados", resultadoRepository.findAll());
        model.addAttribute("eventos", eventoRepository.findAll());
        model.addAttribute("caballos", caballoRepository.findAll());
        return "resultados/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute ResultadoCarrera resultado, RedirectAttributes ra) {
        try {
            resultadoRepository.actualizarResultado(
                resultado.getIdResultado(),
                resultado.getPosicion(),
                resultado.getTiempo(),
                resultado.getPremioGanado()
            );
            ra.addFlashAttribute("mensaje", "Resultado actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/resultados";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        resultadoRepository.eliminarResultado(id);
        return "redirect:/resultados";
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
