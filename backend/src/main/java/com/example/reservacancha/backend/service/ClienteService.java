package com.example.reservacancha.backend.service;

import com.example.reservacancha.backend.model.Cliente;
import com.example.reservacancha.backend.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

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
        if (rut == null) return Optional.empty();
        return clienteRepository.findById(normalizarRut(rut));
    }

    public Optional<Cliente> buscarPorRut(String rut) {
        if (rut == null) return Optional.empty();
        return clienteRepository.findByRut(normalizarRut(rut));
    }

    public Optional<Cliente> buscarPorEmail(String email) {
        if (email == null) return Optional.empty();
        return clienteRepository.findByEmail(email);
    }

    public Cliente crearCliente(Cliente cliente) {
        if (cliente == null) throw new IllegalArgumentException("Cliente nulo");
        String rutNormal = normalizarRut(cliente.getRut());
        if (!validarRut(rutNormal)) {
            throw new IllegalArgumentException("RUT inválido");
        }
        cliente.setRut(rutNormal);
        if (clienteRepository.existsByRut(rutNormal)) {
            throw new IllegalArgumentException("Ya existe un cliente con ese RUT");
        }
        return clienteRepository.save(cliente);
    }

    public Cliente actualizarCliente(String rut, Cliente cliente) {
        if (rut == null || cliente == null) return null;
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> existente = clienteRepository.findById(rutNormal);
        if (existente.isPresent()) {
            Cliente c = existente.get();
            c.setNombre(cliente.getNombre());
            c.setApellido(cliente.getApellido());
            c.setEmail(cliente.getEmail());
            c.setTelefono(cliente.getTelefono());
            return clienteRepository.save(c);
        }
        return null;
    }

    public boolean eliminarCliente(String rut) {
        if (rut == null) return false;
        String rutNormal = normalizarRut(rut);
        if (clienteRepository.existsById(rutNormal)) {
            clienteRepository.deleteById(rutNormal);
            return true;
        }
        return false;
    }

    public Cliente activarCliente(String rut) {
        if (rut == null) return null;
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> clienteOpt = clienteRepository.findById(rutNormal);
        if (clienteOpt.isPresent()) {
            Cliente c = clienteOpt.get();
            c.setActivo(true);
            return clienteRepository.save(c);
        }
        return null;
    }

    public Cliente desactivarCliente(String rut) {
        if (rut == null) return null;
        String rutNormal = normalizarRut(rut);
        Optional<Cliente> clienteOpt = clienteRepository.findById(rutNormal);
        if (clienteOpt.isPresent()) {
            Cliente c = clienteOpt.get();
            c.setActivo(false);
            return clienteRepository.save(c);
        }
        return null;
    }

    public void registrarReserva(String clienteRut, Double monto) {
        if (clienteRut == null) return;
        String rutNormal = normalizarRut(clienteRut);
        Optional<Cliente> clienteOpt = clienteRepository.findById(rutNormal);
        if (clienteOpt.isPresent()) {
            Cliente c = clienteOpt.get();
            try { c.incrementarReservas(); } catch (Throwable ignored) {}
            try { c.agregarGasto(monto); } catch (Throwable ignored) {}
            clienteRepository.save(c);
        }
    }

    public Cliente obtenerOCrearCliente(String nombre, String apellido, String rut,
                                         String email, String telefono) {
        if (rut == null) throw new IllegalArgumentException("RUT nulo");
        String rutNormal = normalizarRut(rut);
        if (!validarRut(rutNormal)) {
            throw new IllegalArgumentException("RUT inválido");
        }
        Optional<Cliente> existente = clienteRepository.findByRut(rutNormal);
        if (existente.isPresent()) {
            Cliente cliente = existente.get();
            cliente.setNombre(nombre);
            cliente.setApellido(apellido);
            cliente.setEmail(email);
            cliente.setTelefono(telefono);
            return clienteRepository.save(cliente);
        } else {
            Cliente nuevoCliente = new Cliente();
            nuevoCliente.setNombre(nombre);
            nuevoCliente.setApellido(apellido);
            nuevoCliente.setRut(rutNormal);
            nuevoCliente.setEmail(email);
            nuevoCliente.setTelefono(telefono);
            return clienteRepository.save(nuevoCliente);
        }
    }

    private boolean validarRut(String rut) {
        if (rut == null) return false;
        String clean = rut.replace(".", "").replace("-", "").toUpperCase();
        if (!clean.matches("\\d{7,8}[0-9K]")) return false;

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

    private String normalizarRut(String rut) {
        if (rut == null) return null;
        String clean = rut.replace(".", "").replace("-", "").toUpperCase();
        if (clean.length() < 2) return rut;
        String body = clean.substring(0, clean.length() - 1);
        String dv = clean.substring(clean.length() - 1);
        return body + "-" + dv;
    }

}

