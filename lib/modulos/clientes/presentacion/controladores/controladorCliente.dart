import 'package:flutter/cupertino.dart';

import '../../datos/modelos/modeloCliente.dart';

class ControladorCliente extends ChangeNotifier {
  List<ModeloCliente> _listaClientes = [];
  List<ModeloCliente> _filtroListaClientes = [];

  String _dni = "";
  String _nombre = "";
  String _telefono = "";
  String _idcliente = "";
  String get idcliente => _idcliente;

  set idcliente(String value) {
    _idcliente = value;
    notifyListeners();

  }
  String get dni => _dni;

  set dni(String value) {
    _dni = value;
    notifyListeners();

  }

  List<ModeloCliente> get listaClientes => _listaClientes;
  List<ModeloCliente> get filtroListaClientes =>
      _filtroListaClientes.isEmpty ? _listaClientes : _filtroListaClientes;

  set listaClientes(List<ModeloCliente> value) {
    _listaClientes = value;
    notifyListeners();
  }

  void filtrarClientes(String query) {
    if (query.isEmpty) {
      _filtroListaClientes = [];
    } else {
      _filtroListaClientes = _listaClientes.where((cliente) {
        final nombre = cliente.nombre.toLowerCase();
        final telefono = cliente.telefono.toLowerCase();
        final dni = cliente.dni.toLowerCase();
        final input = query.toLowerCase();
        return nombre.contains(input) ||
            telefono.contains(input) ||
            dni.contains(input);
      }).toList();
    }
    notifyListeners();
  }

  get nombre => _nombre;

  set nombre(value) {
    _nombre = value;
    notifyListeners();
  }

  get telefono => _telefono;

  set telefono(value) {
    _telefono = value;
    notifyListeners();

  }
}
