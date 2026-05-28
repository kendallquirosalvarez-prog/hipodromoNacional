package cr.ucr.hipodromo.controller;

import cr.ucr.hipodromo.model.Caballo;
import cr.ucr.hipodromo.repository.CaballoRepository;
import cr.ucr.hipodromo.repository.PropietarioRepository;
import cr.ucr.hipodromo.repository.EstabloRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.math.BigDecimal;
import java.time.LocalDate;

@Controller
@RequestMapping("/caballos")
public class CaballoController extends ControladorBase {

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
    public String guardar(@ModelAttribute Caballo caballo, RedirectAttributes ra) {
        try {
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
            ra.addFlashAttribute("mensaje", "Caballo registrado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
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
    public String actualizar(@ModelAttribute Caballo caballo, RedirectAttributes ra) {
        try {
            caballoRepository.actualizarCaballo(
                caballo.getIdCaballo(),
                caballo.getPeso(),
                caballo.getEstadoSalud(),
                caballo.getIdEstablo()
            );
            ra.addFlashAttribute("mensaje", "Caballo actualizado correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/caballos";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        caballoRepository.deleteById(id);
        return "redirect:/caballos";
    }
}