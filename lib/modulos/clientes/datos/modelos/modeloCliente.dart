import 'package:reservalo/modulos/clientes/dominio/entidadCliente.dart';

class ModeloCliente extends EntidadCliente {
  ModeloCliente({
    required String id,
    required String nombre,
    required String email,
    required String dni,
    required String telefono,
  }) : super(
    id: id,
    nombre: nombre,
    dni: dni,
    telefono: telefono,
  );

  factory ModeloCliente.fromMap(Map<String, dynamic> map) {
    return ModeloCliente(
      id: map["id"] ?? "",
      nombre: map["nombre"] ?? "",
      email: map["email"] ?? "",
      dni: map["dni"] ?? "",
      telefono: map["telefono"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "dni": dni,
      "telefono": telefono,
    };
  }

  EntidadCliente toEntity() {
    return EntidadCliente(
      id: id,
      nombre: nombre,
      dni: dni,
      telefono: telefono,
    );
  }
}
