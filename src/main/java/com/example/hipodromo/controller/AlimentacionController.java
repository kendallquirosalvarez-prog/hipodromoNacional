package com.example.hipodromo.controller;

import com.example.hipodromo.model.Alimentacion;
import com.example.hipodromo.repository.AlimentacionRepository;
import com.example.hipodromo.repository.CaballoRepository;
import com.example.hipodromo.repository.SuministroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/alimentacion")
public class AlimentacionController {

    @Autowired
    private AlimentacionRepository alimentacionRepository;

    @Autowired
    private CaballoRepository caballoRepository;

    @Autowired
    private SuministroRepository suministroRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("registros", alimentacionRepository.findAll());
        model.addAttribute("alimentacion", new Alimentacion());
        model.addAttribute("caballos", caballoRepository.findAll());
        model.addAttribute("suministros", suministroRepository.findAll());
        return "alimentacion/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Alimentacion alimentacion, RedirectAttributes ra) {
        try {
            alimentacionRepository.insertarAlimentacion(
                alimentacion.getIdCaballo(),
                alimentacion.getIdSuministro(),
                alimentacion.getTipoAlimento(),
                alimentacion.getCantidad(),
                alimentacion.getFecha()
            );
            ra.addFlashAttribute("mensaje", "Registro de alimentación guardado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/alimentacion";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        alimentacionRepository.eliminarAlimentacion(id);
        return "redirect:/alimentacion";
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
