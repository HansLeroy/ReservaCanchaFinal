package com.example.reservacancha.backend.controller;

import com.example.reservacancha.backend.model.Cliente;
import com.example.reservacancha.backend.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Controlador REST para gestionar clientes (personas que reservan)
 */
@RestController
@RequestMapping("/api/clientes")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:4500"})
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @GetMapping
    public ResponseEntity<List<Cliente>> obtenerTodosLosClientes() {
        List<Cliente> clientes = clienteService.obtenerTodosLosClientes();
        return ResponseEntity.ok(clientes);
    }

    @GetMapping("/activos")
    public ResponseEntity<List<Cliente>> obtenerClientesActivos() {
        List<Cliente> clientes = clienteService.obtenerClientesActivos();
        return ResponseEntity.ok(clientes);
    }

    @GetMapping("/{rut}")
    public ResponseEntity<Cliente> obtenerClientePorId(@PathVariable String rut) {
        Optional<Cliente> cliente = clienteService.obtenerClientePorId(rut);
        return cliente.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/rut/{rut}")
    public ResponseEntity<Cliente> buscarPorRut(@PathVariable String rut) {
        Optional<Cliente> cliente = clienteService.buscarPorRut(rut);
        return cliente.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<Cliente> buscarPorEmail(@PathVariable String email) {
        Optional<Cliente> cliente = clienteService.buscarPorEmail(email);
        return cliente.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> crearCliente(@RequestBody Cliente cliente) {
        try {
            Cliente nuevoCliente = clienteService.crearCliente(cliente);
            return ResponseEntity.status(HttpStatus.CREATED).body(nuevoCliente);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{rut}")
    public ResponseEntity<Cliente> actualizarCliente(@PathVariable String rut, @RequestBody Cliente cliente) {
        Cliente clienteActualizado = clienteService.actualizarCliente(rut, cliente);
        if (clienteActualizado != null) {
            return ResponseEntity.ok(clienteActualizado);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{rut}")
    public ResponseEntity<Void> eliminarCliente(@PathVariable String rut) {
        boolean eliminado = clienteService.eliminarCliente(rut);
        if (eliminado) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{rut}/activar")
    public ResponseEntity<Cliente> activarCliente(@PathVariable String rut) {
        Cliente cliente = clienteService.activarCliente(rut);
        if (cliente != null) {
            return ResponseEntity.ok(cliente);
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{rut}/desactivar")
    public ResponseEntity<Cliente> desactivarCliente(@PathVariable String rut) {
        Cliente cliente = clienteService.desactivarCliente(rut);
        if (cliente != null) {
            return ResponseEntity.ok(cliente);
        }
        return ResponseEntity.notFound().build();
    }
}

