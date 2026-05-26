package com.example.hipodromo.controller;

import com.example.hipodromo.model.HistorialTransaccion;
import com.example.hipodromo.repository.HistorialTransaccionRepository;
import com.example.hipodromo.repository.FacturaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/transacciones")
public class HistorialTransaccionController {

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
    public String guardar(@ModelAttribute HistorialTransaccion transaccion) {
        transaccionRepository.insertarTransaccion(
            transaccion.getIdFactura(),
            transaccion.getMonto(),
            transaccion.getMetodoPago(),
            transaccion.getFechaPago()
        );
        return "redirect:/transacciones";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        transaccionRepository.eliminarTransaccion(id);
        return "redirect:/transacciones";
    }
}
