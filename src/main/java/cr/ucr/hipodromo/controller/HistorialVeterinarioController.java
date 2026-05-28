package cr.ucr.hipodromo.controller;

import cr.ucr.hipodromo.model.HistorialVeterinario;
import cr.ucr.hipodromo.repository.HistorialVeterinarioRepository;
import cr.ucr.hipodromo.repository.CaballoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/historial")
public class HistorialVeterinarioController extends ControladorBase {

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
    public String guardar(@ModelAttribute HistorialVeterinario historial, RedirectAttributes ra) {
        try {
            historialRepository.insertarHistorial(
                historial.getIdRegistro(),
                historial.getIdCaballo(),
                historial.getDiagnostico(),
                historial.getTratamiento(),
                historial.getFechaRevision(),
                historial.getFechaVencimientoCertificacion(),
                historial.getVeterinarioResponsable()
            );
            ra.addFlashAttribute("mensaje", "Historial veterinario registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
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
    public String actualizar(@ModelAttribute HistorialVeterinario historial, RedirectAttributes ra) {
        try {
            historialRepository.actualizarHistorial(
                historial.getIdRegistro(),
                historial.getDiagnostico(),
                historial.getTratamiento(),
                historial.getFechaVencimientoCertificacion()
            );
            ra.addFlashAttribute("mensaje", "Historial veterinario actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/historial";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        historialRepository.eliminarHistorial(id);
        return "redirect:/historial";
    }
}