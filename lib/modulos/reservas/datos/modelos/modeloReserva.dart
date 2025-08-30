import 'package:reservalo/modulos/alojamiento/datos/modelos/modeloAlojamiento.dart';
import 'package:reservalo/modulos/clientes/datos/modelos/modeloCliente.dart';
import 'package:reservalo/modulos/reservas/dominio/entidadReserva.dart';

class ModeloReserva extends EntidadReserva {
  ModeloReserva({
    required int id,
    required ModeloAlojamiento entidadAlojamiento,
    required DateTime fechaLLegada,
    required String horaLlegada,
    required DateTime fechaSalida,
    required String horaSalida,
    required String cantidadAdultos,
    required String cantidadNinos,
    required bool traeMascotas,
    required double importeTotal,
    required double adelanto,
    required double pendiente,
    required String observaciones,
    required ModeloCliente entidadCliente,
    required String notaCliente,
    required String estadoReserva,
  }) : super(
    id,
    entidadAlojamiento,
    fechaLLegada,
    horaLlegada,
    fechaSalida,
    horaSalida,
    cantidadAdultos,
    cantidadNinos,
    traeMascotas,
    importeTotal,
    adelanto,
    pendiente,
    observaciones,
    entidadCliente,
    notaCliente,
    estadoReserva,
  );

  // ===== fromJson =====
  factory ModeloReserva.fromJson(Map<String, dynamic> json) {
    return ModeloReserva(
      id:json['id_reserva']??0,
      entidadAlojamiento: ModeloAlojamiento.fromJson(json['entidadAlojamiento']),
      fechaLLegada: json['fechaLLegada'] ?? '',
      horaLlegada: json['horaLlegada'] ?? '',
      fechaSalida: json['fechaSalida'] ?? '',
      horaSalida: json['horaSalida'] ?? '',
      cantidadAdultos: json['cantidadAdultos'] ?? '',
      cantidadNinos: json['cantidadNinos'] ?? '',
      traeMascotas: json['traeMascotas'] ?? false,
      importeTotal: (json['importeTotal'] ?? 0).toDouble(),
      adelanto: (json['adelanto'] ?? 0).toDouble(),
      pendiente: (json['pendiente'] ?? 0).toDouble(),
      observaciones: json['observaciones'] ?? '',
      entidadCliente: ModeloCliente.fromMap(json['entidadCliente']),
      notaCliente: json['notaCliente'] ?? '',
      estadoReserva: json['estadoReserva'] ?? '',
    );
  }

  // ===== toJson / toMap =====
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'entidadAlojamiento': (entidadAlojamiento as ModeloAlojamiento).toJson(),
      'fechaLLegada': fechaLLegada.toIso8601String().split('T')[0],
      'horaLlegada': horaLlegada,
      'fechaSalida': fechaSalida.toIso8601String().split('T')[0],
      'horaSalida': horaSalida,
      'cantidadAdultos': cantidadAdultos,
      'cantidadNinos': cantidadNinos,
      'traeMascotas': traeMascotas,
      'importeTotal': importeTotal,
      'adelanto': adelanto,
      'pendiente': pendiente,
      'observaciones': observaciones,
      'entidadCliente': (entidadCliente as ModeloCliente).toMap(),
      'notaCliente': notaCliente,
      'estadoReserva': estadoReserva,
    };
  }
}
