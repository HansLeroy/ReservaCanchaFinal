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
        return clienteRepository.findById(normalizarRut(rut));
        if (!validarRut(cliente.getRut())) {
            throw new IllegalArgumentException("RUT inválido");
        }
        return clienteRepository.findByRut(normalizarRut(rut));
        if (clienteRepository.existsByRut(cliente.getRut())) {
            throw new IllegalArgumentException("Ya existe un cliente con ese RUT");
        }
        // Normalizar y validar RUT
        String rutNormal = normalizarRut(cliente.getRut());
        if (!validarRut(rutNormal)) {
            throw new IllegalArgumentException("RUT inválido");
        }
        cliente.setRut(rutNormal);

        // Validar que no exista el RUT
        if (clienteRepository.existsByRut(rutNormal)) {
            throw new IllegalArgumentException("Ya existe un cliente con ese RUT");
        }

    public Cliente actualizarCliente(String rut, Cliente cliente) {
        Optional<Cliente> existente = clienteRepository.findById(rut);
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> existente = clienteRepository.findById(rutNormal);
            return null;
        }

        cliente.setId(rut);
        cliente.setId(rutNormal);
    }

    public boolean eliminarCliente(String rut) {
        if (clienteRepository.existsById(rut)) {
        String rutNormal = normalizarRut(rut);
        if (clienteRepository.existsById(rutNormal)) {
            clienteRepository.deleteById(rutNormal);
        }
        return false;
    }

    public Cliente activarCliente(String rut) {
        Optional<Cliente> cliente = clienteRepository.findById(rut);
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> cliente = clienteRepository.findById(rutNormal);
            cliente.get().setActivo(true);
            return clienteRepository.save(cliente.get());
        }
        return null;
    }

    public Cliente desactivarCliente(String rut) {
        Optional<Cliente> cliente = clienteRepository.findById(rut);
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> cliente = clienteRepository.findById(rutNormal);
            cliente.get().setActivo(false);
            return clienteRepository.save(cliente.get());
        }
        return null;
    }

    public void registrarReserva(String clienteRut, Double monto) {
        Optional<Cliente> cliente = clienteRepository.findById(clienteRut);
        Optional<Cliente> cliente = clienteRepository.findById(normalizarRut(clienteRut));
            cliente.get().incrementarReservas();
            cliente.get().agregarGasto(monto);
            clienteRepository.save(cliente.get());
        }
    }

    public Cliente obtenerOCrearCliente(String nombre, String apellido, String rut,
                                       String email, String telefono) {
        // Normalizar y validar RUT
        // Normalizar y validar RUT
        String rutNormal = normalizarRut(rut);
        if (!validarRut(rutNormal)) {
            throw new IllegalArgumentException("RUT inválido");
        }
        // Buscar si ya existe el cliente por RUT
        Optional<Cliente> existente = clienteRepository.findByRut(rut);
        Optional<Cliente> existente = clienteRepository.findByRut(rutNormal);
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
            Cliente nuevoCliente = new Cliente();
            nuevoCliente.setNombre(nombre);
            nuevoCliente.setApellido(apellido);
            nuevoCliente.setRut(rutNormal);
            nuevoCliente.setTelefono(telefono);
            return clienteRepository.save(nuevoCliente);
        }
    }

    /**
     * Valida un RUT chileno usando módulo 11.
     */
    private boolean validarRut(String rut) {
        if (rut == null) return false;
        String clean = rut.replace(".", "").replace("-", "").toUpperCase();
        if (!clean.matches("\\\d{7,8}[0-9K]")) return false;

        String body = clean.substring(0, clean.length() - 1);
        char dv = clean.charAt(clean.length() - 1);
        int sum = 0;
        int mul = 2;
        for (int i = body.length() - 1; i >= 0; i--) {
            sum += Character.getNumericValue(body.charAt(i)) * mul;
            mul = (mul == 7) ? 2 : mul + 1;
        }
        int res = 11 - (sum % 11);
        char dvCalc;
        if (res == 11) dvCalc = '0';
        else if (res == 10) dvCalc = 'K';
        else dvCalc = Character.forDigit(res, 10);
        return dvCalc == dv;
    }
}

    private String normalizarRut(String rut) {
        if (rut == null) return null;
        String clean = rut.replace(".", "").replace("-", "").toUpperCase();
        if (clean.length() < 2) return rut;
        String body = clean.substring(0, clean.length() - 1);
        String dv = clean.substring(clean.length() - 1);
        return body + "-" + dv;
    }

