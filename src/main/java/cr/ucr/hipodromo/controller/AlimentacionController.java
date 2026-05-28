package cr.ucr.hipodromo.controller;

import cr.ucr.hipodromo.model.Alimentacion;
import cr.ucr.hipodromo.repository.AlimentacionRepository;
import cr.ucr.hipodromo.repository.CaballoRepository;
import cr.ucr.hipodromo.repository.SuministroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/alimentacion")
public class AlimentacionController extends ControladorBase {

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
}
