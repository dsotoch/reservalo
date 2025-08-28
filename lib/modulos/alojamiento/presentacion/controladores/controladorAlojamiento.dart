import 'package:flutter/material.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/datos/repositorios/repositorioAlojamiento.dart';

class ControladorAlojamiento extends ChangeNotifier {
  final RepositorioAlojamiento repositorioAlojamiento;
  ControladorAlojamiento({required this.repositorioAlojamiento});

  List<ModeloAlojamiento> _modeloAlojamiento = [];

  List<ModeloAlojamiento> get modeloAlojamiento => _modeloAlojamiento;

  set modeloAlojamiento(List<ModeloAlojamiento> value) {
    _modeloAlojamiento = value;
    notifyListeners();
  }

  Future<dynamic> eliminarAlojamientos(String id) async {
    final data = await repositorioAlojamiento.eliminarAlojamientos(id);
    return data;
  }

  Future<void> listarAlojamientos() async {
    final data = await repositorioAlojamiento.listarAlojamientos();

    if (data["status"] == "success") {
      modeloAlojamiento = List<ModeloAlojamiento>.from(
        data["data"].map((e) => ModeloAlojamiento.fromJson(e)),
      );
    } else {
      modeloAlojamiento = [];
    }
  }

  Future<bool> guardarAlojamientos(ModeloAlojamiento modelo) async {
    final data = await repositorioAlojamiento.guardarAlojamientos(modelo);

    if (data["status"] == "success") {
      final nuevo = ModeloAlojamiento.fromJson(data["data"]);
      modeloAlojamiento = [..._modeloAlojamiento, nuevo];
      return true;
    }
    return false;
  }
}
