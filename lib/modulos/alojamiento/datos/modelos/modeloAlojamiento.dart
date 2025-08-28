import 'package:reservalo/modulos/alojamiento/dominio/entidadAlojamiento.dart';

class ModeloAlojamiento extends EntidadAlojamiento {
  ModeloAlojamiento({
    required super.nombre,
    required super.direccion,
    required super.id,
  });

  // Factory constructor para crear desde JSON
  factory ModeloAlojamiento.fromJson(Map<String, dynamic> json) {
    return ModeloAlojamiento(
      id: json['id'].toString(),
      direccion: json["direccion"].toString(),
      nombre: json['nombre'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'direccion':direccion,
      'nombre': nombre,
    };
  }
}
