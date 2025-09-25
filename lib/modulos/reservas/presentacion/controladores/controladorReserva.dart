import 'package:flutter/material.dart';
import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/alojamiento/dominio/entidadAlojamiento.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/clientes/presentacion/controladores/controladorCliente.dart';
import 'package:reservalo/modulos/reservas/datos/repositorios/repositorioReserva.dart';

import '../../datos/modelos/modeloReserva.dart';

class ControladorReserva extends ChangeNotifier {
  final RepositorioReserva repositorioReserva;
  final ControladorCliente controladorCliente;
  List<ModeloReserva> _listaReservas = [];
  List<ModeloReserva> _listaReservasDiaSeleccionado = [];

  ModeloReserva? _ultimaReserva;
  bool _variasReservas = false;

  ModeloCliente? _modeloCliente;
  bool _buscandoCliente = false;
  ControladorReserva({
    required this.repositorioReserva,
    required this.controladorCliente,
  });

  List<ModeloReserva> get listaReservasDiaSeleccionado =>
      _listaReservasDiaSeleccionado;

  set listaReservasDiaSeleccionado(List<ModeloReserva> value) {
    _listaReservasDiaSeleccionado = value;
    notifyListeners();
  }

  ModeloReserva? get ultimaReserva => _ultimaReserva;

  bool get variasReservas => _variasReservas;

  set variasReservas(bool value) {
    _variasReservas = value;
    notifyListeners();
  }

  set ultimaReserva(ModeloReserva? value) {
    _ultimaReserva = value;
    notifyListeners();
  }

  ModeloCliente? get modeloCliente => _modeloCliente;

  List<ModeloReserva> get listaReservas => _listaReservas;

  set listaReservas(List<ModeloReserva> value) {
    _listaReservas = value;
    notifyListeners();
  }

  set modeloCliente(ModeloCliente? value) {
    _modeloCliente = value;
    notifyListeners();
  }

  bool get buscandoCliente => _buscandoCliente;

  set buscandoCliente(bool value) {
    _buscandoCliente = value;
    notifyListeners();
  }

  List<ModeloAlojamiento> _listaModeloAlojamiento = [];

  List<ModeloAlojamiento> get listaModeloAlojamiento => _listaModeloAlojamiento;

  set listaModeloAlojamiento(List<ModeloAlojamiento> value) {
    _listaModeloAlojamiento = value;
    notifyListeners();
  }

  Future<dynamic> crearReserva(ModeloReserva modelo) async {
    return await repositorioReserva.crearReserva(modelo);
  }
  bool _todosAlojamientos=false;


  bool get todosAlojamientos => _todosAlojamientos;

  set todosAlojamientos(bool value) {
    _todosAlojamientos = value;
    notifyListeners();
  }

  Future<void> obtenerReservas(String id) async {
    final respuesta = await repositorioReserva.obtenerReservas(id);
    if (respuesta["status"] == "success") {
      listaReservas = List<ModeloReserva>.from(
        respuesta["data"].map((e) {
          return ModeloReserva(
            id: e["id_reserva"] ?? 0,
            entidadAlojamiento: ModeloAlojamiento(
              id: e["entidadAlojamiento"].toString(),
              nombre: e["nombre"],
              direccion: e["direccion"] ?? "",
            ),
            fechaLLegada: DateTime.parse(e["fechaLlegada"]),
            horaLlegada: e["horaLlegada"],
            fechaSalida: DateTime.parse(e["fechaSalida"]),
            horaSalida: e["horaSalida"],
            cantidadAdultos: e["cantidadAdultos"].toString(),
            cantidadNinos: e["cantidadNinos"].toString(),
            traeMascotas: e["traeMascotas"] == 1 ? true : false,
            importeTotal: double.parse(e["importeTotal"]),
            adelanto: double.parse(e["adelanto"]),
            pendiente: double.parse(e["pendiente"]),
            observaciones: e["observaciones"],
            entidadCliente: ModeloCliente(
              id: e["entidadCliente"].toString(),
              nombre: e["nombres"],
              email: e["email"],
              dni: e["dni"].toString(),
              telefono: e["telefono"].toString(),
            ),
            notaCliente: e["notaCliente"],
            estadoReserva: e["estadoReserva"],
          );
        }).toList(),
      );
    }
  }
  Future<void> obtenerReservasTodas() async {
    final respuesta = await repositorioReserva.obtenerReservasTodas();
    if (respuesta["status"] == "success") {
      listaReservas = List<ModeloReserva>.from(
        respuesta["data"].map((e) {
          return ModeloReserva(
            id: e["id_reserva"] ?? 0,
            entidadAlojamiento: ModeloAlojamiento(
              id: e["entidadAlojamiento"].toString(),
              nombre: e["nombre"],
              direccion: e["direccion"] ?? "",
            ),
            fechaLLegada: DateTime.parse(e["fechaLlegada"]),
            horaLlegada: e["horaLlegada"],
            fechaSalida: DateTime.parse(e["fechaSalida"]),
            horaSalida: e["horaSalida"],
            cantidadAdultos: e["cantidadAdultos"].toString(),
            cantidadNinos: e["cantidadNinos"].toString(),
            traeMascotas: e["traeMascotas"] == 1 ? true : false,
            importeTotal: double.parse(e["importeTotal"]),
            adelanto: double.parse(e["adelanto"]),
            pendiente: double.parse(e["pendiente"]),
            observaciones: e["observaciones"],
            entidadCliente: ModeloCliente(
              id: e["entidadCliente"].toString(),
              nombre: e["nombres"],
              email: e["email"],
              dni: e["dni"].toString(),
              telefono: e["telefono"].toString(),
            ),
            notaCliente: e["notaCliente"],
            estadoReserva: e["estadoReserva"],
          );
        }).toList(),
      );
    }
  }

  Future<dynamic> buscarCliente(String dni) async {
    return await controladorCliente.buscarCliente(dni);
  }

  DateTime fechaActual = DateTime.now();

  void mesAnterior(String id) async {
    fechaActual = DateTime(fechaActual.year, fechaActual.month - 1);
    await obtenerReservas(id);
    notifyListeners();
  }

  void mesSiguiente(String id) async {
    fechaActual = DateTime(fechaActual.year, fechaActual.month + 1);
    await obtenerReservas(id);
    notifyListeners();
  }
}
