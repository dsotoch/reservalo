import 'package:flutter/cupertino.dart';
import 'package:reservalo/modulos/clientes/datos/repositorios/repositorioCliente.dart';

import '../../datos/modelos/modeloCliente.dart';

class ControladorCliente extends ChangeNotifier {
  final RepositorioCliente repositorioCliente;
  ControladorCliente({required this.repositorioCliente});

  List<ModeloCliente> _listaClientes = [];
  List<ModeloCliente> _filtroListaClientes = [];

  String _dni = "";
  String _nombre = "";
  String _telefono = "";
  String _idcliente = "";
  String _email = "";

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

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

  Future<dynamic> listarClientes() async {
    final data = await repositorioCliente.listarClientes();
    if (data["status"] == "success") {
      listaClientes = List<ModeloCliente>.from(
        data["data"].map((e) => ModeloCliente.fromMap(e)),
      );
    } else {
      listaClientes = [];
    }
  }
  Future<bool> crearCliente(ModeloCliente modelo) async {
    final data = await repositorioCliente.crearCliente(modelo);
    if(data["status"]=="success"){
      final nuevo = ModeloCliente.fromMap(data["data"]);
      listaClientes = [..._listaClientes, nuevo];
      return true;
    }
    return false;
  }
  Future<dynamic> eliminarCliente(String id) async {
    final data = await repositorioCliente.eliminarCliente(id);
    return data;
  }
  Future<dynamic> buscarCliente(String dni) async {
    final data = await repositorioCliente.buscarCliente(dni);
    return data;
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
