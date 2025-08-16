import 'package:reservalo/modulos/alojamiento/dominio/entidadAlojamiento.dart';

class ModeloAlojamiento extends EntidadAlojamiento {
  ModeloAlojamiento({
    required super.nombre,
    required super.id,
  });

  // Factory constructor para crear desde JSON
  factory ModeloAlojamiento.fromJson(Map<String, dynamic> json) {
    return ModeloAlojamiento(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
