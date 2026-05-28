package cr.ucr.hipodromo.controller;

import cr.ucr.hipodromo.model.HistorialTransaccion;
import cr.ucr.hipodromo.repository.HistorialTransaccionRepository;
import cr.ucr.hipodromo.repository.FacturaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/transacciones")
public class HistorialTransaccionController extends ControladorBase {

    @Autowired
    private HistorialTransaccionRepository transaccionRepository;

    @Autowired
    private FacturaRepository facturaRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("transacciones", transaccionRepository.findAll());
        model.addAttribute("transaccion", new HistorialTransaccion());
        model.addAttribute("facturas", facturaRepository.findAll());
        return "transacciones/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute HistorialTransaccion transaccion, RedirectAttributes ra) {
        try {
            transaccionRepository.insertarTransaccion(
                transaccion.getIdFactura(),
                transaccion.getMonto(),
                transaccion.getMetodoPago(),
                transaccion.getFechaPago()
            );
            ra.addFlashAttribute("mensaje", "Transacción registrada correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al registrar: " + extraerError(e));
        }
        return "redirect:/transacciones";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        transaccionRepository.eliminarTransaccion(id);
        return "redirect:/transacciones";
    }
}
