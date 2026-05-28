package cr.ucr.hipodromo.controller;

import cr.ucr.hipodromo.model.Factura;
import cr.ucr.hipodromo.repository.FacturaRepository;
import cr.ucr.hipodromo.repository.PropietarioRepository;
import cr.ucr.hipodromo.repository.EventoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.math.BigDecimal;

@Controller
@RequestMapping("/facturas")
public class FacturaController extends ControladorBase {

    @Autowired
    private FacturaRepository facturaRepository;

    @Autowired
    private PropietarioRepository propietarioRepository;

    @Autowired
    private EventoRepository eventoRepository;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("facturas", facturaRepository.findAll());
        model.addAttribute("factura", new Factura());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("eventos", eventoRepository.findAll());
        return "facturas/index";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Factura factura, RedirectAttributes ra) {
        try {
            facturaRepository.insertarFactura(
                factura.getIdFactura(),
                factura.getIdPropietario(),
                factura.getIdEvento(),
                factura.getSubtotal(),
                factura.getDescuento(),
                factura.getImpuestos(),
                factura.getTotal(),
                factura.getEstadoPago()
            );
            ra.addFlashAttribute("mensaje", "Factura registrada correctamente.");
        } catch (Exception e) {
            String msg = extraerError(e);
            if (msg.contains("IVA") || msg.contains("13%")) {
                ra.addFlashAttribute("error",
                    "El IVA ingresado no corresponde al 13% del subtotal neto (Ley 9635). Verifique los montos.");
            } else {
                ra.addFlashAttribute("error", "Error al registrar: " + msg);
            }
        }
        return "redirect:/facturas";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable String id, Model model) {
        model.addAttribute("factura", facturaRepository.findById(id).orElseThrow());
        model.addAttribute("facturas", facturaRepository.findAll());
        model.addAttribute("propietarios", propietarioRepository.findAll());
        model.addAttribute("eventos", eventoRepository.findAll());
        return "facturas/index";
    }

    @PostMapping("/actualizar")
    public String actualizar(@ModelAttribute Factura factura, RedirectAttributes ra) {
        try {
            facturaRepository.actualizarFactura(
                factura.getIdFactura(),
                factura.getDescuento(),
                factura.getTotal(),
                factura.getEstadoPago()
            );
            ra.addFlashAttribute("mensaje", "Factura actualizada correctamente.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error al actualizar: " + extraerError(e));
        }
        return "redirect:/facturas";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable String id) {
        facturaRepository.eliminarFactura(id);
        return "redirect:/facturas";
    }

    @PostMapping("/marcar-frecuentes")
    public String marcarFrecuentes(RedirectAttributes ra) {
        facturaRepository.marcarPropietariosFrecuentes();
        ra.addFlashAttribute("mensaje", "Propietarios frecuentes marcados para descuento del 10%.");
        return "redirect:/facturas";
    }

    @PostMapping("/facturar-propietario")
    public String facturarPropietario(
            @RequestParam("idPropietario") String idPropietario,
            @RequestParam(value = "precioInscripcion", defaultValue = "50000") BigDecimal precioInscripcion,
            RedirectAttributes ra) {
        facturaRepository.facturarPropietario(idPropietario, precioInscripcion);
        ra.addFlashAttribute("mensaje", "Facturación completada para el propietario " + idPropietario + ".");
        return "redirect:/facturas";
    }
}