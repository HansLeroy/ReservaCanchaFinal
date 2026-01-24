package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.model.Cliente;
import com.example.reservacancha.backend.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar clientes
 */
@Service
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    public List<Cliente> obtenerTodosLosClientes() {
        return clienteRepository.findAll();
    }

    public List<Cliente> obtenerClientesActivos() {
        return clienteRepository.findActivos();
    }

    public Optional<Cliente> obtenerClientePorId(String rut) {
        return clienteRepository.findById(rut);
    }

    public Optional<Cliente> buscarPorRut(String rut) {
        return clienteRepository.findByRut(rut);
    }

    public Optional<Cliente> buscarPorEmail(String email) {
        return clienteRepository.findByEmail(email);
    }

    public Cliente crearCliente(Cliente cliente) {
        // Validar que no exista el RUT
        if (clienteRepository.existsByRut(cliente.getRut())) {
            throw new IllegalArgumentException("Ya existe un cliente con ese RUT");
        }

        // Validar que no exista el email
        if (clienteRepository.existsByEmail(cliente.getEmail())) {
            throw new IllegalArgumentException("Ya existe un cliente con ese email");
        }

        return clienteRepository.save(cliente);
    }

    public Cliente actualizarCliente(String rut, Cliente cliente) {
        Optional<Cliente> existente = clienteRepository.findById(rut);
        if (existente.isEmpty()) {
            return null;
        }

        cliente.setId(rut);
        return clienteRepository.save(cliente);
    }

    public boolean eliminarCliente(String rut) {
        if (clienteRepository.existsById(rut)) {
            clienteRepository.deleteById(rut);
            return true;
        }
        return false;
    }

    public Cliente activarCliente(String rut) {
        Optional<Cliente> cliente = clienteRepository.findById(rut);
        if (cliente.isPresent()) {
            cliente.get().setActivo(true);
            return clienteRepository.save(cliente.get());
        }
        return null;
    }

    public Cliente desactivarCliente(String rut) {
        Optional<Cliente> cliente = clienteRepository.findById(rut);
        if (cliente.isPresent()) {
            cliente.get().setActivo(false);
            return clienteRepository.save(cliente.get());
        }
        return null;
    }

    public void registrarReserva(String clienteRut, Double monto) {
        Optional<Cliente> cliente = clienteRepository.findById(clienteRut);
        if (cliente.isPresent()) {
            cliente.get().incrementarReservas();
            cliente.get().agregarGasto(monto);
            clienteRepository.save(cliente.get());
        }
    }

    public Cliente obtenerOCrearCliente(String nombre, String apellido, String rut,
                                       String email, String telefono) {
        // Buscar si ya existe el cliente por RUT
        Optional<Cliente> existente = clienteRepository.findByRut(rut);

        if (existente.isPresent()) {
            // Actualizar datos si es necesario
            Cliente cliente = existente.get();
            cliente.setNombre(nombre);
            cliente.setApellido(apellido);
            cliente.setEmail(email);
            cliente.setTelefono(telefono);
            return clienteRepository.save(cliente);
        } else {
            // Crear nuevo cliente
            Cliente nuevoCliente = new Cliente();
            nuevoCliente.setNombre(nombre);
            nuevoCliente.setApellido(apellido);
            nuevoCliente.setRut(rut);
            nuevoCliente.setEmail(email);
            nuevoCliente.setTelefono(telefono);
            return clienteRepository.save(nuevoCliente);
        }
    }
}

